/**
 * LibertyOS — shared DOM utilities
 */

const LibertyOS = (() => {
  const FILE_ICONS = {
    exec:   { bi: 'bi-play-fill',     label: '可执行', css: 'exec' },
    script: { bi: 'bi-filetype-sh',   label: '脚本',   css: 'script' },
    source: { bi: 'bi-braces',        label: '源码',   css: 'source' },
    text:   { bi: 'bi-file-text',     label: '文本',   css: 'text' },
    file:   { bi: 'bi-file-earmark',  label: '文件',   css: 'file' },
  };

  function $(sel, root = document) {
    return root.querySelector(sel);
  }

  function $$(sel, root = document) {
    return [...root.querySelectorAll(sel)];
  }

  function escapeHtml(str) {
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  function formatSize(bytes) {
    if (bytes < 1024) return `${bytes} B`;
    return `${(bytes / 1024).toFixed(1)} KB`;
  }

  const SESSION_KEY = 'libertyos_session';

  function setSession(user) {
    sessionStorage.setItem(SESSION_KEY, JSON.stringify({ user, ts: Date.now() }));
  }

  function getSession() {
    try {
      const raw = sessionStorage.getItem(SESSION_KEY);
      if (!raw) return null;
      const data = JSON.parse(raw);
      return data && data.user ? data : null;
    } catch {
      return null;
    }
  }

  function clearSession() {
    sessionStorage.removeItem(SESSION_KEY);
  }

  function getLoginUser() {
    return getSession()?.user || null;
  }

  function getFileIcon(type) {
    return FILE_ICONS[type] || FILE_ICONS.file;
  }

  function fileIconHtml(type) {
    const icon = getFileIcon(type);
    return `<i class="bi ${icon.bi}" aria-hidden="true"></i>`;
  }

  return { FILE_ICONS, $, $$, escapeHtml, formatSize, getFileIcon, fileIconHtml,
           setSession, getSession, clearSession, getLoginUser };
})();
