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
      inputEl.placeholder = online ? '可直接在 QEMU 里输入（左侧点击文件无需敲命令）' : '等待连接...';
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

  LibertyLogs.init({
    listEl: $('#log-bubble-list'),
    emptyEl: $('#log-bubble-empty'),
    badgeEl: $('#log-count-badge'),
    pageInfoEl: $('#log-page-info'),
    prevBtn: $('#log-prev'),
    nextBtn: $('#log-next'),
  });

  LibertyTerminal.init({
    outputEl,
    inputEl,
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
    LibertyLogs.clear();
  });
  $('#btn-reconnect')?.addEventListener('click', () => LibertyTerminal.connect());
  $('#btn-logout')?.addEventListener('click', () => {
    clearSession();
    window.location.href = 'index.html';
  });

  switchView('desktop');
  inputEl?.focus();
})();
