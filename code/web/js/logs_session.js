/**
 * LibertyOS — session-grouped log panel (experimental; LIBERTY_LOG_UI=session)
 * One bubble per command; expand for nested LOG events.
 */
const LibertyLogsSession = (() => {
  const MAX_SESSIONS = 80;
  const REVEAL_GAP_MS = 30;
  const REVEAL_FALLBACK_MS = 80;
  const STICK_BOTTOM_PX = 80;

  let sessions = [];
  let activeSession = null;
  let bootPending = true;
  let sessionIdSeq = 1;

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

  function interpretCause(causeStr) {
    if (!causeStr) return '';
    try {
      const causeBig = BigInt(String(causeStr));
      const isInterrupt = (causeBig >> 63n) === 1n;
      const code = Number(causeBig & 0xffffffffn);
      if (isInterrupt) {
        if (code === 5) return 'Interrupt + 5 = Supervisor Timer Interrupt (监督者定时器中断)';
        if (code === 1) return 'Interrupt + 1 = Supervisor Software Interrupt';
        return `Interrupt + ${code}`;
      }
      return `Exception code ${code}`;
    } catch {
      return String(causeStr);
    }
  }

  function explainIrqCode(code) {
    const n = Number(code);
    if (n === 5) return 'Supervisor Timer Interrupt (监督者定时器中断)';
    if (n === 1) return 'Supervisor Software Interrupt';
    if (n === 0) return 'User Software Interrupt';
    return `中断源 #${n}`;
  }

  function sessionKindClass(kind) {
    if (kind === 'boot') return 'session-card--boot';
    if (kind === 'ipc_echo') return 'session-card--ipc';
    if (kind === 'background') return 'session-card--bg';
    return 'session-card--cmd';
  }

  function eventKindClass(log) {
    const mod = log.module;
    const ev = log.event;
    if (mod === 'trap' && ev === 'enter') return 'card-enter';
    if (mod === 'trap' && ev === 'leave') return 'card-leave';
    if (mod === 'trap-diag') return 'card-diag';
    if (mod === 'boot') return 'card-boot';
    return 'card-default';
  }

  function eventSummary(log) {
    const mod = log.module;
    const ev = log.event;
    const d = log.data || {};
    if (mod === 'trap' && ev === 'enter') {
      const code = d.code != null ? explainIrqCode(d.code) : '';
      return `trap · enter${d.pid != null ? ` pid=${d.pid}` : ''}${code ? ` · ${code}` : ''}`;
    }
    if (mod === 'trap' && ev === 'leave') return 'trap · leave';
    if (mod === 'trap-diag' && ev === 'leave_handler') return 'trap-diag · leave_handler';
    if (mod === 'proc' && ev === 'exit') return `proc · exit${d.pid != null ? ` pid=${d.pid}` : ''}`;
    if (mod === 'proc' && ev === 'fault_kill') return `proc · fault_kill pid=${d.pid ?? '?'}`;
    if (mod === 'sched' && ev === 'run') return `sched · run pid=${d.pid ?? '?'}`;
    if (mod === 'pmm') return `pmm · ${ev}`;
    if (mod === 'sem') return `sem · ${ev}`;
    if (mod === 'irq') return `irq · ${ev}`;
    return `${mod} · ${ev}`;
  }

  function eventIcon(log) {
    const mod = log.module;
    const ev = log.event;
    if (mod === 'trap' && ev === 'enter') return 'bi-lightning-charge-fill';
    if (mod === 'trap' && ev === 'leave') return 'bi-box-arrow-right';
    if (mod === 'trap-diag') return 'bi-clipboard2-pulse';
    if (mod === 'boot') return 'bi-power';
    if (mod === 'proc') return 'bi-cpu';
    if (mod === 'pmm') return 'bi-memory';
    if (mod === 'sched') return 'bi-arrow-left-right';
    return 'bi-journal-text';
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
    if (revealQueue.length > 0) {
      setTimeout(pumpRevealQueue, REVEAL_GAP_MS);
    }
  }

  function pumpRevealQueue() {
    if (revealActive || revealQueue.length === 0 || !listEl) return;
    revealActive = true;

    const session = revealQueue.shift();
    const card = mountSession(session, true);

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

  function row(label, tooltip, icon, value) {
    return `<div class="info-row">
      <span class="info-label" data-tooltip="${esc(tooltip)}"><i class="bi ${icon}"></i> ${esc(label)}</span>
      <span class="info-value">${esc(fmtVal(value))}</span>
    </div>`;
  }

  function rowBlock(label, tooltip, icon, value, desc) {
    return `<div class="info-block">
      ${row(label, tooltip, icon, value)}
      ${desc ? `<div class="value-desc">${esc(desc)}</div>` : ''}
    </div>`;
  }

  function cardOpen(cardClass, icon, title, module, ts) {
    return `<div class="trap-card ${cardClass}">
      <div class="card-header card-header--clickable" role="button" tabindex="0" aria-expanded="false">
        <div class="event-tag">
          <i class="bi ${icon} event-icon"></i>
          <span class="card-summary">${esc(title)}</span>
          <span class="log-badge">${esc(module)}</span>
        </div>
        <div class="card-header__meta">
          <span class="timestamp"><i class="bi bi-clock"></i> ${esc(ts)} ms</span>
          <i class="bi bi-chevron-down card-chevron" aria-hidden="true"></i>
        </div>
      </div>
      <div class="card-body">`;
  }

  function cardClose() {
    return '</div></div>';
  }

  function renderTrapEnter(log) {
    const d = log.data || {};
    const code = d.code;
    return cardOpen('card-enter', 'bi-lightning-charge-fill', '陷阱进入 · 中断现场', log.module, log.ts_ms)
      + row('hart (硬件线程)', '当前硬件线程 (Hardware Thread)', 'bi-diagram-3', log.hart)
      + row('pid (进程ID)', '进程 ID (Process ID)', 'bi-person', d.pid)
      + row('mode (特权模式)', '陷入陷阱时的特权模式', 'bi-shield', d.mode)
      + row('epc (异常程序计数器)', 'Exception PC', 'bi-pin-map', d.epc)
      + row('sscratch (临时寄存器)', '陷阱入口保存的用户栈指针', 'bi-archive', d.sscratch)
      + row('kind (陷阱类型)', '中断或同步异常', 'bi-exclamation-triangle', d.kind)
      + rowBlock('code (中断编号)', 'scause 低位编码', 'bi-hash', code, explainIrqCode(code))
      + (d.frame ? `<div class="log-badge-group"><span class="log-badge"><i class="bi bi-layers"></i> frame: ${esc(d.frame)}</span></div>` : '')
      + cardClose();
  }

  function renderTrapLeave(log) {
    const d = log.data || {};
    return cardOpen('card-leave', 'bi-box-arrow-right', '陷阱退出 · 恢复上下文', log.module, log.ts_ms)
      + row('hart (硬件线程)', '当前硬件线程', 'bi-diagram-3', log.hart)
      + row('depth (嵌套深度)', '陷阱嵌套深度', 'bi-stack', d.depth)
      + row('return_pc (返回地址)', '陷阱处理完成后返回的 PC', 'bi-box-arrow-up-right', d.return_pc)
      + row('trap_epc (陷阱 epc)', '进入陷阱时记录的 epc', 'bi-arrow-repeat', d.trap_epc)
      + rowBlock('cause (陷阱原因)', 'scause 寄存器', 'bi-lightning', d.cause, interpretCause(d.cause))
      + cardClose();
  }

  function renderTrapDiagLeave(log) {
    const d = log.data || {};
    const sstatus = d.sstatus;
    let sstatusDesc = '';
    if (sstatus) {
      try {
        const val = BigInt(String(sstatus));
        const sie = Number((val >> 1n) & 1n);
        const spp = Number((val >> 8n) & 1n);
        sstatusDesc = `SPP=${spp} (${spp ? '来自 Supervisor' : '来自 User'}) | SIE=${sie} (${sie ? '中断已启用' : '中断已屏蔽'})`;
      } catch {
        sstatusDesc = '';
      }
    }
    return cardOpen('card-diag', 'bi-clipboard2-pulse', '陷阱诊断 · 状态寄存器', log.module, log.ts_ms)
      + row('hart (硬件线程)', '当前硬件线程', 'bi-diagram-3', log.hart)
      + row('ret_sepc (返回 sepc)', 'sret 返回时将写入 sepc', 'bi-arrow-counterclockwise', d.ret_sepc)
      + row('sscratch (临时寄存器)', '用户栈指针快照', 'bi-archive', d.sscratch)
      + rowBlock('sstatus (监督者状态寄存器)', 'Supervisor Status', 'bi-gear', sstatus, sstatusDesc)
      + cardClose();
  }

  function renderGeneric(log) {
    const d = log.data || {};
    const keys = Object.keys(d);
    let body = row('hart (硬件线程)', '硬件线程 ID', 'bi-diagram-3', log.hart);
    if (keys.length === 0) {
      body += `<div class="value-desc">${esc(log.module)}/${esc(log.event)} — 无附加字段</div>`;
    } else {
      keys.forEach((k) => {
        body += row(k, k, 'bi-dot', d[k]);
      });
    }
    const modClass = log.module === 'boot' ? 'card-boot' : 'card-default';
    const icon = log.module === 'boot' ? 'bi-power' : log.module === 'proc' ? 'bi-cpu' : 'bi-journal-text';
    return cardOpen(modClass, icon, `${log.module} · ${log.event}`, log.module, log.ts_ms)
      + body
      + cardClose();
  }

  function renderBubble(log) {
    const mod = log.module;
    const ev = log.event;
    if (mod === 'trap' && ev === 'enter') return renderTrapEnter(log);
    if (mod === 'trap' && ev === 'leave') return renderTrapLeave(log);
    if (mod === 'trap-diag' && ev === 'leave_handler') return renderTrapDiagLeave(log);
    return renderGeneric(log);
  }

  function renderSessionEvents(session) {
    let html = '';
    session.notes.forEach((note) => {
      html += `<div class="session-note"><i class="bi bi-terminal"></i> ${esc(note)}</div>`;
    });
    session.events.forEach((log, idx) => {
      const kind = eventKindClass(log);
      html += `<div class="session-event ${kind}" data-event-idx="${idx}">
        <div class="session-event__header card-header--clickable" role="button" tabindex="0" aria-expanded="false">
          <div class="event-tag">
            <i class="bi ${eventIcon(log)} event-icon"></i>
            <span class="card-summary">${esc(eventSummary(log))}</span>
          </div>
          <div class="card-header__meta">
            <span class="timestamp"><i class="bi bi-clock"></i> ${esc(log.ts_ms)} ms</span>
            <i class="bi bi-chevron-down card-chevron" aria-hidden="true"></i>
          </div>
        </div>
        <div class="session-event__detail">${renderBubble(log)}</div>
      </div>`;
    });
    if (!html) {
      html = '<div class="session-empty">本段无内核 LOG 事件</div>';
    }
    return html;
  }

  function renderSession(session) {
    const count = session.events.length + session.notes.length;
    const kindCls = sessionKindClass(session.kind);
    return `<div class="session-card ${kindCls}" data-session-id="${session.id}">
      <div class="session-card__header card-header--clickable" role="button" tabindex="0" aria-expanded="false">
        <div class="event-tag">
          <i class="bi bi-collection event-icon"></i>
          <span class="card-summary">事件：${esc(session.title)}</span>
        </div>
        <div class="card-header__meta">
          <span class="log-badge">${count} 条</span>
          <i class="bi bi-chevron-down card-chevron" aria-hidden="true"></i>
        </div>
      </div>
      <div class="session-card__body">${renderSessionEvents(session)}</div>
    </div>`;
  }

  function isNearBottom() {
    if (!listEl) return true;
    const gap = listEl.scrollHeight - listEl.scrollTop - listEl.clientHeight;
    return gap <= STICK_BOTTOM_PX;
  }

  function maxScrollTop() {
    if (!listEl) return 0;
    return Math.max(0, listEl.scrollHeight - listEl.clientHeight);
  }

  function ensureScrolledToBottom() {
    if (!listEl) return;
    const snap = () => {
      listEl.scrollTop = maxScrollTop();
    };
    snap();
    requestAnimationFrame(() => {
      snap();
      requestAnimationFrame(snap);
    });
  }

  function updateBadge() {
    if (badgeEl) badgeEl.textContent = String(sessions.length);
    const hasVisible = sessions.length > 0 || revealQueue.length > 0;
    if (emptyEl) emptyEl.classList.toggle('hidden', hasVisible);
  }

  function clearCards() {
    if (!listEl) return;
    listEl.querySelectorAll('.session-card').forEach((el) => el.remove());
  }

  function mountSession(session, animate) {
    const wrapper = document.createElement('div');
    wrapper.innerHTML = renderSession(session);
    const card = wrapper.firstElementChild;
    if (animate) card.classList.add('bubble-enter-pending');
    listEl.appendChild(card);
    return card;
  }

  function trimOldest() {
    if (sessions.length <= MAX_SESSIONS) return;
    sessions.shift();
    const oldest = listEl?.querySelector('.session-card');
    oldest?.remove();
  }

  function ensureActiveSession(title, kind) {
    if (activeSession) return activeSession;
    if (bootPending) {
      activeSession = {
        id: sessionIdSeq++,
        title: 'boot',
        kind: 'boot',
        events: [],
        notes: [],
      };
      return activeSession;
    }
    activeSession = {
      id: sessionIdSeq++,
      title: title || 'kernel',
      kind: kind || 'command',
      events: [],
      notes: [],
    };
    return activeSession;
  }

  function beginSession(title, kind = 'command') {
    if (activeSession) endSession();
    activeSession = {
      id: sessionIdSeq++,
      title: title || 'command',
      kind,
      events: [],
      notes: [],
    };
  }

  function endSession(titleOverride) {
    if (!activeSession) return;
    if (titleOverride) activeSession.title = titleOverride;
    const session = activeSession;
    activeSession = null;
    sessions.push(session);
    trimOldest();
    revealQueue.push(session);
    pumpRevealQueue();
    updateBadge();
  }

  function onShellReady() {
    bootPending = false;
    if (activeSession && activeSession.kind === 'boot') {
      endSession();
    }
  }

  function noteConsoleLine(line) {
    const text = String(line ?? '').trim();
    if (!text) return;
    const session = ensureActiveSession('kernel', 'misc');
    session.notes.push(text);
  }

  function addEvent(log) {
    if (!log || typeof log !== 'object') return;
    const session = ensureActiveSession();
    session.events.push(log);
  }

  function handleSnapshot(data) {
    if (!data || typeof data !== 'object') return;
    addEvent({
      ts_ms: Date.now() % 100000,
      module: 'snapshot',
      event: 'stats',
      hart: 0,
      data,
    });
  }

  function clear() {
    cancelReveal();
    sessions = [];
    activeSession = null;
    bootPending = true;
    sessionIdSeq = 1;
    followLatest = true;
    clearCards();
    updateBadge();
  }

  function toggleSession(card) {
    const expanded = card.classList.toggle('session-card--expanded');
    const header = card.querySelector('.session-card__header');
    if (header) header.setAttribute('aria-expanded', expanded ? 'true' : 'false');
    if (followLatest) ensureScrolledToBottom();
  }

  function toggleSessionEvent(item) {
    const expanded = item.classList.toggle('session-event--expanded');
    const header = item.querySelector('.session-event__header');
    if (header) header.setAttribute('aria-expanded', expanded ? 'true' : 'false');
    if (followLatest) ensureScrolledToBottom();
  }

  function init(opts) {
    listEl = opts.listEl;
    emptyEl = opts.emptyEl;
    badgeEl = opts.badgeEl;

    listEl?.addEventListener('scroll', () => {
      followLatest = isNearBottom();
    }, { passive: true });

    listEl?.addEventListener('wheel', (e) => {
      if (e.deltaY < 0) followLatest = false;
    }, { passive: true });

    listEl?.addEventListener('click', (e) => {
      const eventHeader = e.target.closest('.session-event__header');
      if (eventHeader && listEl.contains(eventHeader)) {
        e.stopPropagation();
        const item = eventHeader.closest('.session-event');
        if (item) toggleSessionEvent(item);
        return;
      }
      const sessionHeader = e.target.closest('.session-card__header');
      if (sessionHeader && listEl.contains(sessionHeader)) {
        const card = sessionHeader.closest('.session-card');
        if (card) toggleSession(card);
      }
    });

    listEl?.addEventListener('keydown', (e) => {
      if (e.key !== 'Enter' && e.key !== ' ') return;
      const eventHeader = e.target.closest('.session-event__header');
      if (eventHeader && listEl.contains(eventHeader)) {
        e.preventDefault();
        e.stopPropagation();
        const item = eventHeader.closest('.session-event');
        if (item) toggleSessionEvent(item);
        return;
      }
      const sessionHeader = e.target.closest('.session-card__header');
      if (sessionHeader && listEl.contains(sessionHeader)) {
        e.preventDefault();
        const card = sessionHeader.closest('.session-card');
        if (card) toggleSession(card);
      }
    });

    updateBadge();
  }

  return {
    init,
    clear,
    addEvent,
    handleSnapshot,
    beginSession,
    endSession,
    onShellReady,
    noteConsoleLine,
  };
})();
