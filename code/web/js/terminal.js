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

  const SHELL_WELCOME = 'Welcome, root.';

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
    appendOutput(forTerm);
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
    if (onStatus) onStatus(isOnline, message);
  }

  function sendInput(data) {
    if (!ws || ws.readyState !== WebSocket.OPEN) return false;
    ws.send(JSON.stringify({ type: 'input', data }));
    return true;
  }

  function sendCommand(cmd) {
    const line = cmd.endsWith('\n') ? cmd : cmd + '\n';
    if (shellReady && termGateOpen) {
      appendOutput(line, 'stdout');
    }
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
      if (typeof LibertyLogs !== 'undefined' && data.event) {
        LibertyLogs.addEvent(data.event);
      }
      return;
    }

    if (data.type === 'snapshot') {
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
        if (e.key === 'Enter' && inputEl.value) {
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
