/**
 * LibertyOS — WebSocket PTY terminal (protocol from server_0428.py)
 */
const LibertyTerminal = (() => {
  const reconnectDelayMs = 3000;

  let ws = null;
  let reconnectTimer = null;
  let online = false;
  let loginSent = false;
  let shellReady = false;
  let termGateOpen = false;
  let loginTimer = null;
  let preShellBuf = '';
  let rawInputMode = false;
  let consoleLogHold = '';

  const SHELL_WELCOME = 'Welcome, root.';
  const LOG_TS_MARKER = 'LOG {"ts_ms"';
  const LOG_SNAP_MARKER = 'LOG_SNAPSHOT {';

  function setInputPlaceholder() {
    if (!inputEl) return;
    if (!online) {
      inputEl.placeholder = '等待连接...';
      return;
    }
    if (rawInputMode) {
      inputEl.placeholder = '交互模式 (vi)：单键发送，Esc 切 NORMAL，:wq 保存';
      return;
    }
    inputEl.placeholder = '输入命令后 Enter（shell）；vi 会自动切换为单键模式';
  }

  function enableRawInput() {
    if (rawInputMode) return;
    rawInputMode = true;
    if (inputEl) inputEl.value = '';
    setInputPlaceholder();
  }

  function disableRawInput() {
    if (!rawInputMode) return;
    rawInputMode = false;
    if (inputEl) inputEl.value = '';
    setInputPlaceholder();
  }

  function maybeUpdateRawInput(text) {
    if (!text) return;
    if (/-- vi .+ --/.test(text) || /-- NORMAL --/.test(text) || /-- INSERT --/.test(text)) {
      enableRawInput();
    }
    if (/Type text and press Enter \(q to quit\):/.test(text)) {
      enableRawInput();
    }
    if (/vi: saved/.test(text) || /vi: write failed/.test(text) || /vi: quit/.test(text)) {
      disableRawInput();
    }
    if (/\[parent\] ipc_echo done/.test(text)) {
      disableRawInput();
    }
  }

  function tryForwardLogLine(line) {
    if (typeof LibertyLogs === 'undefined') return;
    const clean = line.replace(/\r$/, '');
    if (clean.startsWith('LOG ')) {
      try {
        const ev = JSON.parse(clean.slice(4).trim());
        if (ev && typeof ev === 'object') LibertyLogs.addEvent(ev);
      } catch { /* ignore */ }
      return;
    }
    if (clean.startsWith('LOG_SNAPSHOT ')) {
      try {
        const snap = JSON.parse(clean.slice('LOG_SNAPSHOT '.length).trim());
        if (snap && typeof snap === 'object') LibertyLogs.handleSnapshot(snap);
      } catch { /* ignore */ }
    }
  }

  /** Fallback: strip LOG lines that leaked onto the console byte stream. */
  function stripLogFromConsole(chunk) {
    let s = consoleLogHold + String(chunk ?? '');
    consoleLogHold = '';
    let out = '';
    let i = 0;

    while (i < s.length) {
      const a = s.indexOf(LOG_TS_MARKER, i);
      const b = s.indexOf(LOG_SNAP_MARKER, i);
      let at = -1;
      if (a >= 0 && (b < 0 || a <= b)) at = a;
      else if (b >= 0) at = b;

      if (at < 0) {
        out += s.slice(i);
        break;
      }

      out += s.slice(i, at);
      const nl = s.indexOf('\n', at);
      if (nl < 0) {
        consoleLogHold = s.slice(at);
        break;
      }
      tryForwardLogLine(s.slice(at, nl));
      i = nl + 1;
    }
    return out;
  }

  function keyToWire(e) {
    if (e.key === 'Enter') return '\n';
    if (e.key === 'Backspace') return '\x7f';
    if (e.key === 'Escape') return '\x1b';
    if (e.key === 'Tab') return '\t';
    if (e.ctrlKey && e.key === 'c') return '\x03';
    if (e.key.length === 1 && !e.ctrlKey && !e.metaKey && !e.altKey) return e.key;
    return null;
  }

  function resetLoginState() {
    loginSent = false;
    shellReady = false;
    termGateOpen = false;
    preShellBuf = '';
    if (loginTimer) {
      clearTimeout(loginTimer);
      loginTimer = null;
    }
  }

  function getPendingLoginUser() {
    return typeof LibertyOS !== 'undefined' ? LibertyOS.getLoginUser() : null;
  }

  function scheduleAutoLogin(text) {
    const user = getPendingLoginUser();
    if (!user || loginSent || shellReady || loginTimer) return;
    const plain = stripAnsi(String(text || ''));
    if (!/login:\s*/.test(plain) && !plain.includes('Username: root')) return;

    loginTimer = setTimeout(() => {
      loginTimer = null;
      if (loginSent || shellReady) return;
      loginSent = true;
      sendCommand(user);
    }, 350);
  }

  function markShellReady() {
    if (!preShellBuf.includes(SHELL_WELCOME)) return;

    shellReady = true;
    ready = true;
    termGateOpen = true;

    if (outputEl) outputEl.innerHTML = '';

    const idx = preShellBuf.indexOf(SHELL_WELCOME);
    const tail = idx >= 0 ? preShellBuf.slice(idx) : preShellBuf;
    if (tail) appendOutput(tail);

    if (onReady) onReady();
  }

  function appendTerminalOutput(forTerm) {
    if (!forTerm) return;
    if (!termGateOpen) return;
    const cleaned = stripLogFromConsole(forTerm);
    maybeUpdateRawInput(cleaned);
    if (cleaned) appendOutput(cleaned);
  }
  let outputEl = null;
  let inputEl = null;
  let onReady = null;
  let onStatus = null;
  let ready = false;

  function stripAnsi(input) {
    if (!input) return '';
    let s = input.replace(/\x1B\][^\x07]*(\x07|\x1B\\)/g, '');
    s = s.replace(/\x1B\[[0-?]*[ -/]*[@-~]/g, '');
    return s;
  }

  function getWsUrl() {
    const proto = location.protocol === 'https:' ? 'wss:' : 'ws:';
    return `${proto}//${location.host}/ws/ssh`;
  }

  function scrollOutput() {
    if (outputEl) outputEl.scrollTop = outputEl.scrollHeight;
  }

  function getOrCreateLastLine() {
    let last = outputEl.lastElementChild;
    if (!last || !last.classList.contains('console__line')) {
      last = document.createElement('div');
      last.className = 'console__line console__line--stdout';
      outputEl.appendChild(last);
    }
    return last;
  }

  function appendOutput(rawText, cls = 'stdout') {
    const text = stripAnsi(String(rawText ?? ''));
    if (!text) return;

    const normalized = text.replace(/\r\n/g, '\n').replace(/\r/g, '\n');
    const parts = normalized.split('\n');
    const first = parts.shift();

    if (first !== undefined && first.length) {
      const lastLine = getOrCreateLastLine();
      lastLine.className = `console__line console__line--${cls}`;
      lastLine.textContent += first;
    }

    for (const part of parts) {
      const line = document.createElement('div');
      line.className = `console__line console__line--${cls}`;
      line.textContent = part;
      outputEl.appendChild(line);
    }
    scrollOutput();
  }

  function setStatus(isOnline, message) {
    online = isOnline;
    if (inputEl) inputEl.disabled = !isOnline;
    setInputPlaceholder();
    if (onStatus) onStatus(isOnline, message);
  }

  function sendInput(data) {
    if (!ws || ws.readyState !== WebSocket.OPEN) return false;
    ws.send(JSON.stringify({ type: 'input', data }));
    return true;
  }

  function sendCommand(cmd) {
    const line = cmd.endsWith('\n') ? cmd : cmd + '\n';
    return sendInput(line);
  }

  function scheduleReconnect() {
    if (reconnectTimer) return;
    reconnectTimer = setTimeout(() => {
      reconnectTimer = null;
      connect();
    }, reconnectDelayMs);
  }

  function handleMessage(event) {
    let data;
    try {
      data = JSON.parse(event.data);
    } catch {
      appendOutput(String(event.data || ''));
      return;
    }

    if (data.type === 'output') {
      if (data.channel && data.channel !== 'console') return;
      const chunk = data.data || '';
      const visible = chunk.replace('[ready]\n', '').replace('[ready]', '');

      scheduleAutoLogin(visible);

      if (!shellReady) {
        preShellBuf += stripAnsi(visible);
        markShellReady();
        if (!shellReady) return;
      }

      if (chunk.includes('[ready]') && shellReady && onReady) {
        ready = true;
      }

      appendTerminalOutput(visible);
      return;
    }

    if (data.type === 'event') {
      if (data.channel && data.channel !== 'log') return;
      if (typeof LibertyLogs !== 'undefined' && data.event) {
        LibertyLogs.addEvent(data.event);
      }
      return;
    }

    if (data.type === 'snapshot') {
      if (data.channel && data.channel !== 'log') return;
      if (typeof LibertyLogs !== 'undefined' && data.snapshot) {
        LibertyLogs.handleSnapshot(data.snapshot);
      }
      return;
    }

    if (data.type === 'error') {
      appendOutput(data.message || '后端错误', 'error');
    }
  }

  function connect() {
    if (ws && (ws.readyState === WebSocket.OPEN || ws.readyState === WebSocket.CONNECTING)) {
      return;
    }

    ready = false;
    resetLoginState();
    disableRawInput();
    consoleLogHold = '';
    const url = getWsUrl();
    appendOutput(`连接 ${url} ...\n`, 'system');
    ws = new WebSocket(url);

    ws.onopen = () => {
      setStatus(true, '已连接');
      appendOutput('WebSocket 已连接，等待 QEMU 输出...\n', 'system');
    };

    ws.onmessage = handleMessage;

    ws.onerror = () => {
      setStatus(false, '连接异常');
      appendOutput('WebSocket 连接异常\n', 'error');
    };

    ws.onclose = () => {
      setStatus(false, '未连接');
      ready = false;
      resetLoginState();
      disableRawInput();
      consoleLogHold = '';
      appendOutput('连接已断开，3 秒后重连...\n', 'system');
      scheduleReconnect();
    };
  }

  function init(opts) {
    outputEl = opts.outputEl;
    inputEl = opts.inputEl;
    onReady = opts.onReady || null;
    onStatus = opts.onStatus || null;

    if (inputEl) {
      inputEl.addEventListener('keydown', (e) => {
        if (!online || !shellReady) return;

        if (rawInputMode) {
          const ch = keyToWire(e);
          if (ch === null) return;
          e.preventDefault();
          sendInput(ch);
          return;
        }

        if (e.key === 'Enter' && inputEl.value) {
          e.preventDefault();
          const cmd = inputEl.value;
          inputEl.value = '';
          sendCommand(cmd);
        }
      });
    }

    connect();
  }

  function clear() {
    if (outputEl) outputEl.innerHTML = '';
    termGateOpen = shellReady;
  }

  function isReady() {
    return online && ready;
  }

  return { init, connect, sendCommand, sendInput, clear, isReady, appendOutput };
})();
