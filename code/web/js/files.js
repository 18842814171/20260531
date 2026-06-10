/**
 * LibertyOS — graphical file browser (/home/root)
 */

const LibertyFiles = (() => {
  const { $, $$, escapeHtml, formatSize, getFileIcon, fileIconHtml } = LibertyOS;

  let files = [];
  let selectedName = null;
  let treeEl = null;
  let iconsEl = null;
  let viewerTitleEl = null;
  let viewerContentEl = null;
  let placeholderEl = null;
  let closeBtn = null;
  let onRun = null;
  let onOpenFile = null;

  async function fetchFiles() {
    const res = await fetch('/api/files');
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    files = data.files || [];
    return files;
  }

  async function fetchFileContent(name) {
    const res = await fetch(`/api/file?name=${encodeURIComponent(name)}`);
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || `HTTP ${res.status}`);
    }
    return res.json();
  }

  function guestCommand(entry) {
    if (entry.type === 'exec') return `./${entry.name}`;
    return null;
  }

  function runEntry(entry) {
    const cmd = guestCommand(entry);
    if (cmd && onRun) onRun(cmd);
  }

  function showViewer(name, content) {
    if (viewerTitleEl) viewerTitleEl.textContent = name;
    if (viewerContentEl) {
      viewerContentEl.textContent = content;
      viewerContentEl.classList.remove('hidden');
    }
    placeholderEl?.classList.add('hidden');
    closeBtn?.classList.remove('hidden');
  }

  function hideViewer() {
    if (viewerTitleEl) viewerTitleEl.textContent = '文件预览';
    viewerContentEl?.classList.add('hidden');
    viewerContentEl && (viewerContentEl.textContent = '');
    placeholderEl?.classList.remove('hidden');
    closeBtn?.classList.add('hidden');
    selectedName = null;
    renderFileTree();
  }

  async function openReadable(entry) {
    selectedName = entry.name;
    renderFileTree();
    if (onOpenFile) onOpenFile();
    try {
      const data = await fetchFileContent(entry.name);
      showViewer(entry.name, data.content || '');
    } catch (err) {
      showViewer(entry.name, `[读取失败] ${err.message}`);
    }
  }

  function handleClick(entry) {
    selectedName = entry.name;
    renderFileTree();

    if (entry.type === 'exec') {
      runEntry(entry);
      return;
    }
    openReadable(entry);
  }

  function renderFileTree() {
    if (!treeEl) return;
    if (!files.length) {
      treeEl.innerHTML = '<div class="file-tree__empty">目录为空</div>';
      return;
    }

    const sorted = [...files].sort((a, b) => {
      const order = { exec: 0, script: 1, source: 2, text: 3, file: 4 };
      const da = order[a.type] ?? 9;
      const db = order[b.type] ?? 9;
      if (da !== db) return da - db;
      return a.name.localeCompare(b.name);
    });

    treeEl.innerHTML = sorted.map((entry) => {
      const icon = getFileIcon(entry.type);
      const selected = entry.name === selectedName ? ' file-tree__item--selected' : '';
      const hint = entry.type === 'exec' ? '运行' : '查看';
      return `
        <div class="file-tree__item file-tree__item--${icon.css}${selected}"
             data-name="${escapeHtml(entry.name)}" title="${hint}: ${escapeHtml(entry.name)}">
          <span class="file-tree__icon file-tree__icon--${icon.css}">${fileIconHtml(entry.type)}</span>
          <span class="file-tree__name">${escapeHtml(entry.name)}</span>
          <span class="file-tree__size">${formatSize(entry.size)}</span>
        </div>`;
    }).join('');

    $$('.file-tree__item', treeEl).forEach((item) => {
      item.addEventListener('click', () => {
        const name = item.dataset.name;
        const entry = files.find((f) => f.name === name);
        if (entry) handleClick(entry);
      });
    });
  }

  function renderQuickLaunch() {
    if (!iconsEl) return;
    const execs = files.filter((f) => f.type === 'exec');
    if (!execs.length) {
      iconsEl.innerHTML = '<div class="file-tree__empty">无可执行程序</div>';
      return;
    }

    iconsEl.innerHTML = execs.map((entry) => {
      return `
        <div class="desktop-icon" data-name="${escapeHtml(entry.name)}"
             title="运行 ./${escapeHtml(entry.name)}">
          <div class="desktop-icon__glyph desktop-icon__glyph--exec">${fileIconHtml('exec')}</div>
          <span class="desktop-icon__label">${escapeHtml(entry.name)}</span>
        </div>`;
    }).join('');

    $$('.desktop-icon', iconsEl).forEach((el) => {
      el.addEventListener('click', () => {
        const entry = files.find((f) => f.name === el.dataset.name);
        if (entry) runEntry(entry);
      });
    });
  }

  function render() {
    renderQuickLaunch();
    renderFileTree();
  }

  async function refresh() {
    if (treeEl) treeEl.innerHTML = '<div class="file-tree__empty">加载中...</div>';
    try {
      await fetchFiles();
      render();
    } catch (err) {
      if (treeEl) {
        treeEl.innerHTML = `<div class="file-tree__empty file-tree__empty--error">加载失败: ${escapeHtml(err.message)}</div>`;
      }
    }
  }

  function init(opts) {
    treeEl = opts.treeEl;
    iconsEl = opts.iconsEl;
    viewerTitleEl = opts.viewerTitleEl;
    viewerContentEl = opts.viewerContentEl;
    placeholderEl = opts.placeholderEl;
    closeBtn = opts.viewerCloseBtn;
    onRun = opts.onRun || null;
    onOpenFile = opts.onOpenFile || null;

    opts.refreshBtn?.addEventListener('click', () => refresh());
    opts.viewerCloseBtn?.addEventListener('click', () => hideViewer());

    refresh();
  }

  return { init, refresh, hideViewer };
})();
