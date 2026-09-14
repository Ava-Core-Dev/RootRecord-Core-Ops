#!/usr/bin/env bash
# Dev-Desk — same job as Windows C:\Users\rootr\ava\windows\start_desk.py
# This folder is the Electron window. Live origin/data is ~/Ava-Core.
set -euo pipefail

export PATH="${HOME}/.local/bin:/usr/local/bin:${PATH}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESK_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
AVA_ROOT="${AVA_HOME:-${HOME}/Ava-Core}"
LOG_DIR="${AVA_ROOT}/data/logs"
mkdir -p "${LOG_DIR}" "${AVA_ROOT}/data" || true

exec >>"${LOG_DIR}/dev-desk.log" 2>&1
echo "---- $(date -Iseconds) start-dev-desk desk=${DESK_ROOT} ava=${AVA_ROOT} ----"

export AVA_HOME="${AVA_ROOT}"
export AVA_HANDOFF="${AVA_ROOT}"
export ROOTMC_ENV_FILE="${AVA_ROOT}/.env"
export AVA_ENV_FILE="${AVA_ROOT}/.env"
export AVA_DESKTOP_UI=1
export AVA_RICH_PRESENCE="${AVA_RICH_PRESENCE:-1}"
export AVA_PORT="${AVA_PORT:-8787}"

if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
  export DISPLAY="${DISPLAY:-:0}"
fi

if [[ -f "${AVA_ROOT}/data/power-off.json" ]]; then
  rm -f "${AVA_ROOT}/data/power-off.json"
  echo "cleared power-off.json"
fi

UID_NUM="$(id -u)"
export PULSE_SERVER="${PULSE_SERVER:-unix:/run/user/${UID_NUM}/pulse/native}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/${UID_NUM}}"

cd "${DESK_ROOT}"

if [[ ! -d node_modules/electron ]]; then
  echo "Installing Electron desktop deps…"
  npm install --prefer-offline 2>&1 || npm install
fi

ELECTRON_BIN="${DESK_ROOT}/node_modules/.bin/electron"
ELECTRON_DIST="${DESK_ROOT}/node_modules/electron/dist/electron"

if [[ ! -x "${ELECTRON_BIN}" && ! -x "${ELECTRON_DIST}" ]]; then
  echo "ERROR: electron binary missing — run: cd ${DESK_ROOT} && npm install" >&2
  exit 1
fi

unset ELECTRON_RUN_AS_NODE || true
export ELECTRON_DISABLE_SANDBOX="${ELECTRON_DISABLE_SANDBOX:-1}"
export ELECTRON_OZONE_PLATFORM_HINT="${ELECTRON_OZONE_PLATFORM_HINT:-auto}"

echo "Starting Dev-Desk (origin ${AVA_ROOT} :8787)"
if [[ -x "${ELECTRON_DIST}" ]]; then
  exec "${ELECTRON_DIST}" --no-sandbox --ozone-platform-hint=auto .
fi
exec "${ELECTRON_BIN}" --no-sandbox --ozone-platform-hint=auto .
