/**
 * LibertyOS — log hierarchy spec (aggregation rules only, no UI)
 *
 *   L1 CommandRun   user-visible command / process group
 *     L2 SysEvent   semantic behavior (optional — may be empty for pwd)
 *       L3 Raw      LOG JSON + LOG_NOTE, each with ts
 *
 * Classification uses kernel LOG { module, event, data } — not NOTE text regex.
 * P0/P1: episode stack + pid/watchPids — no activity_id required.
 * P4+:   activity + activity_id on LOG/NOTE; episode stack becomes optional.
 */
const LogAggregate = (() => {
  /**
   * How an L1 CommandRun closes. Priority order — never equate prompt with process exit.
   * @readonly
   */
  const L1_BOUNDARY = {
    PROCESS_EXIT: 'process_exit',       // LOG_PROC exit / fault_kill for tracked root pid
    JOB_COMPLETE: 'job_complete',       // foreground job reaped (future: shell job table)
    PROMPT_HEURISTIC: 'prompt_heuristic', // root@…$ — interaction boundary only, fallback
    EXPLICIT_END: 'explicit_end',         // vi :wq, [parent] ipc_echo done
  };

  /** Lower number = higher priority when multiple signals could close L1. */
  const L1_BOUNDARY_PRIORITY = [
    L1_BOUNDARY.PROCESS_EXIT,
    L1_BOUNDARY.JOB_COMPLETE,
    L1_BOUNDARY.EXPLICIT_END,
    L1_BOUNDARY.PROMPT_HEURISTIC,
  ];

  /**
   * L1 profile: shell builtins vs external ELF — not a demo-program name list.
   * minimal → L1 may have zero L2 (pwd, ls, cat)
   * default → show L2 buckets that actually have kernel LOG content
   */
  function commandProfile(cmd) {
    const t = String(cmd || '').trim();
    if (/^\.\//.test(t) || t.startsWith('/')) return 'default';
    return 'minimal';
  }

  const L2 = {
    PAGE_FAULTS: 'page_faults',
    PROCESS_LIFECYCLE: 'process_lifecycle',
    SEM_SYNC: 'sem_sync',
    SEM_LIFECYCLE: 'sem_lifecycle',
    IPC_LIFECYCLE: 'ipc_lifecycle',
    IPC_EXCHANGE: 'ipc_exchange',
    APP_MILESTONE: 'app_milestone', // LOG_APP("vi", "saved", …)
    TRAP: 'trap',
    SCHED: 'sched',
    MISC: 'misc',
  };

  /** Kernel proc events → process_lifecycle (see proc_user.c, proc.c, trap.c). */
  const PROC_LIFECYCLE_EVENTS = new Set([
    'fork', 'exec', 'exit', 'fault_kill',
    'user_enter', 'user_exit', 'exit_trap', 'zombie', 'vm_destroy', 'trap_return',
  ]);

  const LOG_RULES = [
    { l2: L2.PAGE_FAULTS, match: (e) => e.module === 'irq' && e.event === 'page_fault' },
    { l2: L2.PROCESS_LIFECYCLE, match: (e) => e.module === 'proc' && PROC_LIFECYCLE_EVENTS.has(e.event) },
    { l2: L2.SEM_LIFECYCLE, match: (e) => e.module === 'sem' && e.event === 'create' },
    { l2: L2.SEM_SYNC, match: (e) => e.module === 'sem' && /^(wait|acquire|post|wake)$/.test(e.event) },
    { l2: L2.APP_MILESTONE, match: (e) => e.module === 'app' || e.module === 'vi' },
    { l2: L2.TRAP, match: (e) => e.module === 'trap' || e.module === 'trap-diag' },
    { l2: L2.SCHED, match: (e) => e.module === 'sched' },
    { l2: L2.MISC, match: () => true },
  ];

  /**
   * NOTE attachment uses a context stack, not keyword → bucket.
   * While handling a page_fault LOG, subsequent NOTEs attach to that fault's L3
   * until the fault episode ends (next fault, sched run, or timeout).
   */
  const NOTE_CONTEXT = {
    PAGE_FAULT_EPISODE: 'page_fault_episode',
    NONE: null,
  };

  const L2_PRESENT = {
    [L2.PAGE_FAULTS]: (bucket) => ({
      title: bucket.items.length === 1 ? 'page fault' : `${bucket.items.length} page faults`,
    }),
    [L2.PROCESS_LIFECYCLE]: () => ({ title: 'process lifecycle' }),
    [L2.SEM_SYNC]: () => ({ title: 'message exchange' }),
    [L2.SEM_LIFECYCLE]: () => ({ title: 'semaphore setup' }),
    [L2.IPC_LIFECYCLE]: () => ({ title: 'IPC processes' }),
    [L2.IPC_EXCHANGE]: () => ({ title: 'message exchange' }),
    [L2.APP_MILESTONE]: (bucket) => ({
      title: bucket.items.at(-1)?.data?.phase || bucket.items.at(-1)?.text || 'milestone',
    }),
    [L2.TRAP]: (bucket) => ({
      title: bucket.items.length === 1 ? 'trap' : `${bucket.items.length} traps`,
    }),
    [L2.SCHED]: () => ({ title: 'scheduler' }),
    [L2.MISC]: () => ({ title: 'detail' }),
  };

  /** Teaching order: fault/IPC/sem stories before generic lifecycle boilerplate. */
  const L2_DISPLAY_ORDER = [
    L2.PAGE_FAULTS,
    L2.SEM_LIFECYCLE,
    L2.SEM_SYNC,
    L2.IPC_LIFECYCLE,
    L2.IPC_EXCHANGE,
    L2.APP_MILESTONE,
    L2.PROCESS_LIFECYCLE,
  ];

  const L2_NOISE = new Set([L2.TRAP, L2.SCHED, L2.MISC]);

  /**
   * After aggregation, decide which L2 buckets to show — driven by bucket content, not command name.
   */
  function visibleL2Buckets(buckets, cmd) {
    const profile = commandProfile(cmd);
    const keys = Object.keys(buckets);

    if (profile === 'minimal') {
      return keys.filter((k) => !L2_NOISE.has(k) && k !== L2.PROCESS_LIFECYCLE);
    }

    const out = [];
    for (const k of L2_DISPLAY_ORDER) {
      if (buckets[k]?.items?.length) out.push(k);
    }
    for (const k of keys) {
      if (out.includes(k) || L2_NOISE.has(k)) continue;
      if (buckets[k]?.items?.length) out.push(k);
    }
    if (out.length === 0) {
      for (const k of [L2.TRAP, L2.SCHED]) {
        if (buckets[k]?.items?.length) out.push(k);
      }
    }
    return out;
  }

  /** Orphan events after prompt but before process exit → attach to BackgroundJob L1 (future). */
  const BACKGROUND_ORPHAN_POLICY = 'hold_until_exit';

  function classifyLog(event) {
    const rule = LOG_RULES.find((r) => r.match(event));
    return rule ? rule.l2 : L2.MISC;
  }

  /**
   * Unstructured LOG_NOTE — only page-fault episode context; no text regex routing.
   * @param {string} text NOTE body
   * @param {string|null} activeContext NOTE_CONTEXT frame
   */
  function classifyNote(text, activeContext) {
    if (activeContext === NOTE_CONTEXT.PAGE_FAULT_EPISODE) {
      return { l2: L2.PAGE_FAULTS, attachTo: 'current_episode' };
    }
    return { l2: L2.MISC, attachTo: 'bucket' };
  }

  /** Opening a page_fault LOG pushes context; trap leave or next fault pops it. */
  function contextOnLog(event, stack) {
    const next = [...stack];
    if (event.module === 'irq' && event.event === 'page_fault') {
      next.push(NOTE_CONTEXT.PAGE_FAULT_EPISODE);
    } else if (event.module === 'trap' && event.event === 'leave') {
      if (next.at(-1) === NOTE_CONTEXT.PAGE_FAULT_EPISODE) next.pop();
    }
    return next;
  }

  function presentL2(kind, bucket, cmdHint) {
    const fn = L2_PRESENT[kind];
    return fn ? fn(bucket, cmdHint) : { title: kind };
  }

  /** Every L3 item should carry ts for future timeline view. */
  function stamp(item, ts) {
    return { ...item, ts: ts ?? item.ts_ms ?? item.ts ?? 0 };
  }

  /** L1 presentation: minimal commands show only "completed". */
  function presentL1(cmd, profile, anchorPid) {
    const title = String(cmd || '').trim() || 'command';
    if (profile === 'minimal') {
      return { title, subtitle: 'completed', expandable: false };
    }
    const pidPart = anchorPid != null ? ` pid=${anchorPid}` : '';
    return { title: `${title}${pidPart}`, subtitle: null, expandable: true };
  }

  return {
    L1_BOUNDARY,
    L1_BOUNDARY_PRIORITY,
    L2,
    NOTE_CONTEXT,
    BACKGROUND_ORPHAN_POLICY,
    PROC_LIFECYCLE_EVENTS,
    commandProfile,
    classifyLog,
    classifyNote,
    contextOnLog,
    visibleL2Buckets,
    presentL2,
    presentL1,
    stamp,
  };
})();
