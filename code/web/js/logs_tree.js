/**
 * LibertyOS — hierarchical log panel (P0/P1)
 * L1 CommandRun → L2 SysEvent → L3 Raw (episode stack; no activity_id yet)
 */
const LibertyLogsTree = (() => {
  const MAX_RUNS = 80;
  const REVEAL_GAP_MS = 40;
  const REVEAL_FALLBACK_MS = 90;
  const STICK_BOTTOM_PX = 80;
  const SHELL_PID = 1;

  let activeRun = null;
  let bootRun = null;
  let completedRuns = [];
  let runIdSeq = 1;
  let noteContextStack = [];

  let revealQueue = [];
  let revealActive = false;
  let revealFallbackTimer = null;
  let followLatest = true;

  let listEl = null;
  let emptyEl = null;
  let badgeEl = null;

  function esc(s) {
    return String(s ?? '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  function fmtVal(v) {
    if (v === null || v === undefined) return '—';
    if (typeof v === 'object') return JSON.stringify(v);
    return String(v);
  }

  function pidFromData(d) {
    if (!d || d.pid == null) return null;
    const n = Number(d.pid);
    return Number.isFinite(n) ? n : null;
  }

  function belongsToRun(run, pid) {
    if (pid == null) return true;
    if (!run.anchorPid) return true;
    return run.watchPids.has(pid);
  }

  function cancelReveal() {
    if (revealFallbackTimer) {
      clearTimeout(revealFallbackTimer);
      revealFallbackTimer = null;
    }
    revealQueue = [];
    revealActive = false;
  }

  function finishRevealStep() {
    if (!revealActive) return;
    if (revealFallbackTimer) {
      clearTimeout(revealFallbackTimer);
      revealFallbackTimer = null;
    }
    revealActive = false;
    if (followLatest) ensureScrolledToBottom();
    if (revealQueue.length > 0) setTimeout(pumpRevealQueue, REVEAL_GAP_MS);
  }

  function pumpRevealQueue() {
    if (revealActive || revealQueue.length === 0 || !listEl) return;
    revealActive = true;
    const run = revealQueue.shift();
    const card = mountRun(run, true);
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        card.classList.remove('bubble-enter-pending');
        card.classList.add('bubble-enter');
        if (followLatest) ensureScrolledToBottom();
        card.addEventListener('transitionend', finishRevealStep, { once: true });
        revealFallbackTimer = setTimeout(finishRevealStep, REVEAL_FALLBACK_MS);
      });
    });
  }

  function isNearBottom() {
    if (!listEl) return true;
    return listEl.scrollHeight - listEl.scrollTop - listEl.clientHeight <= STICK_BOTTOM_PX;
  }

  function ensureScrolledToBottom() {
    if (!listEl) return;
    const snap = () => { listEl.scrollTop = listEl.scrollHeight - listEl.clientHeight; };
    snap();
    requestAnimationFrame(snap);
  }

  function updateBadge() {
    if (badgeEl) badgeEl.textContent = String(completedRuns.length);
    if (emptyEl) emptyEl.classList.toggle('hidden', completedRuns.length > 0 || revealQueue.length > 0);
  }

  function newRun(cmd, { isBoot = false } = {}) {
    const profile = isBoot ? 'boot' : LogAggregate.commandProfile(cmd);
    const run = {
      id: runIdSeq++,
      cmd: isBoot ? 'boot' : cmd,
      profile,
      anchorPid: null,
      watchPids: new Set(),
      items: [],
      boundary: null,
      isBoot,
      anchorExited: false,
    };
    if (profile === 'minimal') {
      run.anchorPid = SHELL_PID;
      run.watchPids.add(SHELL_PID);
    }
    return run;
  }

  function beginCommand(cmd) {
    if (activeRun) endCommand('forced');
    activeRun = newRun(cmd);
  }

  function endCommand(boundary) {
    const run = activeRun;
    if (!run) return;
    run.boundary = boundary;
    activeRun = null;
    noteContextStack = [];
    if (run.items.length === 0 && run.profile === 'minimal') {
      run.items.push({ kind: 'meta', text: 'completed', ts: Date.now() % 100000 });
    }
    completedRuns.push(run);
    if (completedRuns.length > MAX_RUNS) completedRuns.shift();
    revealQueue.push(run);
    pumpRevealQueue();
    updateBadge();
  }

  function onShellReady() {
    if (bootRun) {
      bootRun.boundary = 'shell_ready';
      completedRuns.push(bootRun);
      revealQueue.push(bootRun);
      bootRun = null;
      pumpRevealQueue();
      updateBadge();
    }
  }

  function trackFork(parent, child) {
    if (!activeRun || parent == null || child == null) return;
    if (activeRun.watchPids.has(parent)) activeRun.watchPids.add(child);
  }

  function trySetAnchor(pid) {
    if (!activeRun || activeRun.anchorPid != null || pid == null) return;
    activeRun.anchorPid = pid;
    activeRun.watchPids.add(pid);
  }

  function tryEndOnExit(pid) {
    if (!activeRun || pid == null) return;
    if (activeRun.anchorPid === pid) activeRun.anchorExited = true;
  }

  function onPrompt() {
    if (!activeRun) return;
    if (activeRun.profile === 'minimal' || activeRun.anchorExited) {
      endCommand(
        activeRun.anchorExited
          ? LogAggregate.L1_BOUNDARY.PROCESS_EXIT
          : LogAggregate.L1_BOUNDARY.PROMPT_HEURISTIC,
      );
    }
  }

  function ingestLog(log) {
    const pid = pidFromData(log.data);
    if (!belongsToRun(activeRun || bootRun, pid)) return;

    const target = activeRun || bootRun;
    if (!target) return;

    target.items.push(LogAggregate.stamp({ kind: 'log', log }, log.ts_ms));

    if (log.module === 'proc' && log.event === 'fork') {
      const p = pidFromData({ pid: log.data?.parent });
      const c = pidFromData({ pid: log.data?.child });
      if (p != null && c != null) trackFork(p, c);
    }
    if (log.module === 'proc' && log.event === 'user_enter') {
      trySetAnchor(pid);
    }
    if (log.module === 'proc' && (log.event === 'exit' || log.event === 'fault_kill' || log.event === 'user_exit')) {
      tryEndOnExit(pid);
    }

    noteContextStack = LogAggregate.contextOnLog(log, noteContextStack);
  }

  function ingestNote(text) {
    const t = String(text ?? '').trim();
    if (!t) return;

    const target = activeRun || bootRun;
    if (!target) return;

    const ctx = noteContextStack.at(-1) || null;
    target.items.push(LogAggregate.stamp({ kind: 'note', text: t, ctx }, Date.now() % 100000));
  }

  function addEvent(log) {
    if (!log || typeof log !== 'object') return;
    if (!activeRun && !bootRun) bootRun = newRun('boot', { isBoot: true });
    ingestLog(log);
  }

  function addNote(text) {
    if (!activeRun && !bootRun) bootRun = newRun('boot', { isBoot: true });
    ingestNote(text);
  }

  function handleSnapshot(data) {
    addEvent({
      ts_ms: Date.now() % 100000,
      module: 'snapshot',
      event: 'stats',
      hart: 0,
      data,
    });
  }

  function aggregateEpisodes(items) {
    const episodes = [];
    let current = null;

    for (const it of items) {
      if (it.kind === 'log' && it.log?.module === 'irq' && it.log?.event === 'page_fault') {
        current = { fault: it, notes: [], ts: it.ts };
        episodes.push(current);
        continue;
      }
      if (it.kind === 'log' && it.log?.module === 'trap' && it.log?.event === 'leave') {
        current = null;
        continue;
      }
      if (it.kind === 'note' && it.ctx === LogAggregate.NOTE_CONTEXT.PAGE_FAULT_EPISODE && current) {
        current.notes.push(it);
        continue;
      }
      if (it.kind === 'note' && current) {
        current.notes.push(it);
      }
    }
    return episodes;
  }

  function aggregateRun(run) {
    const buckets = {};
    const misc = [];

    for (const it of run.items) {
      if (it.kind === 'meta') continue;
      if (it.kind === 'log') {
        const l2 = LogAggregate.classifyLog(it.log);
        if (!buckets[l2]) buckets[l2] = { kind: l2, items: [] };
        buckets[l2].items.push(it);
      } else if (it.kind === 'note') {
        if (it.ctx === LogAggregate.NOTE_CONTEXT.PAGE_FAULT_EPISODE && buckets[LogAggregate.L2.PAGE_FAULTS]) {
          buckets[LogAggregate.L2.PAGE_FAULTS].items.push(it);
        } else {
          const { l2 } = LogAggregate.classifyNote(it.text, null);
          if (!buckets[l2]) buckets[l2] = { kind: l2, items: [] };
          buckets[l2].items.push(it);
        }
      }
    }

    const visible = LogAggregate.visibleL2Buckets(buckets, run.cmd);
    const l2List = [];

    for (const key of visible) {
      const bucket = buckets[key];
      if (!bucket || bucket.items.length === 0) continue;
      const pres = LogAggregate.presentL2(key, bucket, run.cmd);
      const entry = { kind: key, title: pres.title, items: bucket.items };
      if (key === LogAggregate.L2.PAGE_FAULTS) {
        entry.episodes = aggregateEpisodes(bucket.items);
        entry.title = entry.episodes.length === 1
          ? 'page fault'
          : `${entry.episodes.length} page faults`;
      }
      l2List.push(entry);
    }

    const l1 = LogAggregate.presentL1(run.cmd, run.profile, run.anchorPid);
    return { run, l1, l2List };
  }

  function renderL3Log(log) {
    const d = log.data || {};
    const keys = Object.keys(d);
    let body = keys.map((k) => `<div class="info-row"><span>${esc(k)}</span><span>${esc(fmtVal(d[k]))}</span></div>`).join('');
    if (!body) body = `<div class="note-detail">${esc(log.module)} · ${esc(log.event)}</div>`;
    return body;
  }

  function renderRun(agg) {
    const { run, l1, l2List } = agg;
    const profCls = run.profile === 'minimal' ? 'command-card--minimal' : 'command-card--rich';
    const expandable = l1.expandable && l2List.length > 0;

    let body = '';
    if (expandable) {
      for (const l2 of l2List) {
        let inner = '';
        if (l2.episodes?.length) {
          inner = l2.episodes.map((ep) => {
            const stval = ep.fault?.log?.data?.stval ?? '';
            const notes = ep.notes.map((n) => `<div class="note-detail">${esc(n.text)}</div>`).join('');
            return `<div class="fault-episode"><div class="fault-episode__head">fault ${esc(stval)}</div>${notes}</div>`;
          }).join('');
        } else {
          inner = l2.items.map((it) => {
            if (it.kind === 'log') return `<div class="sys-raw">${renderL3Log(it.log)}</div>`;
            if (it.kind === 'note') return `<div class="note-detail">${esc(it.text)}</div>`;
            return '';
          }).join('');
        }
        body += `<div class="sys-event"><div class="sys-event__header card-header--clickable"><span>${esc(l2.title)}</span><i class="bi bi-chevron-down card-chevron"></i></div><div class="sys-event__body">${inner}</div></div>`;
      }
    }

    const sub = l1.subtitle ? `<span class="log-badge">${esc(l1.subtitle)}</span>` : '';

    return `<div class="command-card ${profCls}" data-run-id="${run.id}">
      <div class="command-card__header card-header--clickable" role="button" tabindex="0" aria-expanded="false">
        <div class="event-tag"><i class="bi bi-terminal event-icon"></i><span class="card-summary">${esc(l1.title)}</span></div>
        <div class="card-header__meta">${sub}${expandable ? '<i class="bi bi-chevron-down card-chevron"></i>' : ''}</div>
      </div>
      ${expandable ? `<div class="command-card__body">${body}</div>` : ''}
    </div>`;
  }

  function mountRun(run, animate) {
    const agg = aggregateRun(run);
    const wrapper = document.createElement('div');
    wrapper.innerHTML = renderRun(agg);
    const card = wrapper.firstElementChild;
    if (animate) card.classList.add('bubble-enter-pending');
    listEl.appendChild(card);
    return card;
  }

  function clearCards() {
    listEl?.querySelectorAll('.command-card').forEach((el) => el.remove());
  }

  function clear() {
    cancelReveal();
    activeRun = null;
    bootRun = null;
    completedRuns = [];
    noteContextStack = [];
    followLatest = true;
    clearCards();
    updateBadge();
  }

  function onExplicitEnd() {
    if (activeRun) endCommand(LogAggregate.L1_BOUNDARY.EXPLICIT_END);
  }

  function hasActiveRun() {
    return activeRun != null;
  }

  function init(opts) {
    listEl = opts.listEl;
    emptyEl = opts.emptyEl;
    badgeEl = opts.badgeEl;
    bootRun = newRun('boot', { isBoot: true });

    listEl?.addEventListener('scroll', () => { followLatest = isNearBottom(); }, { passive: true });
    listEl?.addEventListener('wheel', (e) => { if (e.deltaY < 0) followLatest = false; }, { passive: true });

    listEl?.addEventListener('click', (e) => {
      const h = e.target.closest('.sys-event__header');
      if (h && listEl.contains(h)) {
        h.parentElement.classList.toggle('sys-event--expanded');
        return;
      }
      const ch = e.target.closest('.command-card__header');
      if (ch && listEl.contains(ch)) {
        ch.closest('.command-card').classList.toggle('command-card--expanded');
      }
    });

    updateBadge();
  }

  return {
    init,
    clear,
    addEvent,
    addNote,
    handleSnapshot,
    beginCommand,
    endCommand,
    onShellReady,
    onPrompt,
    onExplicitEnd,
    hasActiveRun,
  };
})();
