/**
 * LibertyOS — desktop + live console + graphical files
 */

(function () {
  const { $, $$, getSession, clearSession } = LibertyOS;

  if (!getSession()) {
    window.location.replace('index.html');
    return;
  }

  const outputEl = $('#console-output');
  const inputEl = $('#console-input');
  const statusDot = $('#status-dot');
  const statusText = $('#status-text');
  const sidebarNav = $('#sidebar-nav');

  function setConnectionStatus(online, message) {
    if (statusDot) {
      statusDot.style.background = online ? 'var(--success)' : 'var(--warning)';
      statusDot.style.boxShadow = online ? '0 0 8px var(--success)' : '0 0 8px var(--warning)';
    }
    if (statusText) statusText.textContent = message;
    if (inputEl) {
      inputEl.disabled = !online;
    }
  }

  function switchView(view) {
    $$('#sidebar-nav .sidebar__nav-item[data-view]').forEach((btn) => {
      btn.classList.toggle('sidebar__nav-item--active', btn.dataset.view === view);
    });

    $$('.sidebar__panel[data-view]').forEach((panel) => {
      panel.classList.toggle('hidden', panel.dataset.view !== view);
    });

    if (view === 'files') {
      LibertyFiles.refresh();
      $('#file-tree')?.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }

  $$('#sidebar-nav .sidebar__nav-item[data-view]').forEach((btn) => {
    btn.addEventListener('click', () => {
      if (btn.disabled) return;
      switchView(btn.dataset.view);
    });
  });

  const LogPanel = typeof LibertyLogsTree !== 'undefined' ? LibertyLogsTree : LibertyLogs;

  LogPanel.init({
    listEl: $('#log-bubble-list'),
    emptyEl: $('#log-bubble-empty'),
    badgeEl: $('#log-count-badge'),
  });

  LibertyTerminal.init({
    outputEl,
    inputEl,
    promptLabelEl: $('#console-prompt'),
    onStatus: setConnectionStatus,
    onReady: () => setConnectionStatus(true, 'QEMU 就绪'),
  });

  LibertyFiles.init({
    treeEl: $('#file-tree'),
    iconsEl: $('#desktop-icons'),
    viewerTitleEl: $('#file-viewer-title'),
    viewerContentEl: $('#file-viewer-content'),
    placeholderEl: $('#file-placeholder'),
    refreshBtn: $('#btn-refresh-files'),
    viewerCloseBtn: $('#file-viewer-close'),
    onRun: (cmd) => LibertyTerminal.sendCommand(cmd),
    onOpenFile: () => {},
  });

  $('#btn-clear')?.addEventListener('click', () => {
    LibertyTerminal.clear();
    LogPanel.clear();
  });
  $('#btn-reconnect')?.addEventListener('click', () => LibertyTerminal.connect());
  $('#btn-logout')?.addEventListener('click', () => {
    clearSession();
    window.location.href = 'index.html';
  });

  switchView('desktop');
  inputEl?.focus();

  (function initConsoleResize() {
    const workspace = $('.workspace');
    const splitter = $('#console-splitter');
    const consolePanel = $('#console-panel');
    if (!workspace || !splitter || !consolePanel) return;

    const STORAGE_KEY = 'libertyos-console-height';
    const DEFAULT_H = 280;
    const MIN_H = 120;

    function maxHeight() {
      const h = workspace.getBoundingClientRect().height;
      return Math.max(MIN_H, Math.floor(h * 0.85));
    }

    function applyHeight(px) {
      const clamped = Math.max(MIN_H, Math.min(maxHeight(), Math.round(px)));
      workspace.style.setProperty('--console-panel-height', `${clamped}px`);
      return clamped;
    }

    const saved = parseInt(localStorage.getItem(STORAGE_KEY) || '', 10);
    applyHeight(Number.isFinite(saved) && saved > 0 ? saved : DEFAULT_H);

    let dragging = false;

    function onMove(clientY) {
      const rect = workspace.getBoundingClientRect();
      applyHeight(rect.bottom - clientY);
    }

    splitter.addEventListener('mousedown', (e) => {
      if (e.button !== 0) return;
      dragging = true;
      splitter.classList.add('workspace__splitter--dragging');
      document.body.style.cursor = 'row-resize';
      document.body.style.userSelect = 'none';
      e.preventDefault();
    });

    splitter.addEventListener('dblclick', () => {
      const h = applyHeight(DEFAULT_H);
      localStorage.setItem(STORAGE_KEY, String(h));
    });

    splitter.addEventListener('keydown', (e) => {
      const step = e.shiftKey ? 40 : 16;
      const cur = parseInt(
        getComputedStyle(workspace).getPropertyValue('--console-panel-height'),
        10,
      ) || DEFAULT_H;
      if (e.key === 'ArrowUp') {
        e.preventDefault();
        applyHeight(cur + step);
      } else if (e.key === 'ArrowDown') {
        e.preventDefault();
        applyHeight(cur - step);
      } else if (e.key === 'Home') {
        e.preventDefault();
        applyHeight(maxHeight());
      } else if (e.key === 'End') {
        e.preventDefault();
        applyHeight(MIN_H);
      } else {
        return;
      }
      localStorage.setItem(STORAGE_KEY, String(parseInt(
        getComputedStyle(workspace).getPropertyValue('--console-panel-height'),
        10,
      )));
    });

    window.addEventListener('mousemove', (e) => {
      if (!dragging) return;
      onMove(e.clientY);
    });

    window.addEventListener('mouseup', () => {
      if (!dragging) return;
      dragging = false;
      splitter.classList.remove('workspace__splitter--dragging');
      document.body.style.cursor = '';
      document.body.style.userSelect = '';
      const h = parseInt(
        getComputedStyle(workspace).getPropertyValue('--console-panel-height'),
        10,
      );
      if (Number.isFinite(h)) localStorage.setItem(STORAGE_KEY, String(h));
    });

    window.addEventListener('resize', () => {
      const h = parseInt(
        getComputedStyle(workspace).getPropertyValue('--console-panel-height'),
        10,
      ) || DEFAULT_H;
      applyHeight(h);
    });
  })();
})();
