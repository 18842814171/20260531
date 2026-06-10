#!/usr/bin/env bash
set -euo pipefail

WEB_DIR="$(cd "$(dirname "$0")" && pwd)"
MYOS_ROOT="$(cd "${WEB_DIR}/../myos" && pwd)"
VENV="${WEB_DIR}/.venv"

export MYOS_ROOT
export WEB_DIR
# 方案 B: nginx 对外 :3333，Flask 仅本机 :5000（VM_PORT 须与 nginx proxy_pass 一致）
export VM_HOST="${VM_HOST:-127.0.0.1}"
export VM_PORT="${VM_PORT:-5000}"

if [[ ! -f "${MYOS_ROOT}/out/os" ]]; then
    echo "hint: kernel 未构建，先在 ${MYOS_ROOT} 运行 make" >&2
fi

if [[ -x "${VENV}/bin/python3" ]] && "${VENV}/bin/python3" -c "import flask_sock" 2>/dev/null; then
    PYTHON="${VENV}/bin/python3"
elif [[ -x "/home/linda/4.10/myenv/bin/python3" ]] && /home/linda/4.10/myenv/bin/python3 -c "import flask_sock" 2>/dev/null; then
    PYTHON="/home/linda/4.10/myenv/bin/python3"
else
    echo "creating venv at ${VENV}"
    python3 -m venv "${VENV}"
    "${VENV}/bin/pip" install -r "${WEB_DIR}/requirements.txt"
    PYTHON="${VENV}/bin/python3"
fi

echo "LibertyOS backend  MYOS_ROOT=${MYOS_ROOT}  ${VM_HOST}:${VM_PORT}  (对外访问 nginx :3333)"
exec "${PYTHON}" "${WEB_DIR}/server.py"
