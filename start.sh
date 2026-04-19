#!/bin/bash
set -euo pipefail

XPRA_PORT="${XPRA_PORT:-${PORT:-3000}}"
XPRA_DISPLAY="${XPRA_DISPLAY:-:100}"
APP_DATA_DIR="${APP_DATA_DIR:-/app/xpra_user_data}"
export HOME="${HOME:-$APP_DATA_DIR}"
CHROME_PROFILE_DIR="${CHROME_PROFILE_DIR:-$APP_DATA_DIR/chrome-profile}"

mkdir -p "$APP_DATA_DIR" "$CHROME_PROFILE_DIR" /run/dbus
rm -f /run/dbus/pid 2>/dev/null || true

if ! pgrep -x dbus-daemon >/dev/null 2>&1; then
    dbus-daemon --system --fork || true
fi

if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    eval "$(dbus-launch --sh-syntax)"
fi

echo "=== 启动 Xpra HTML5 浏览容器 ==="
echo "监听端口: ${XPRA_PORT}"
echo "访问方式: 使用平台分配的 HTTPS 域名访问该端口"
echo "起始页面: ${START_URL:-https://www.google.com/}"

XPRA_ARGS=(
    start
    "$XPRA_DISPLAY"
    "--bind-tcp=0.0.0.0:${XPRA_PORT}"
    --html=on
    --daemon=no
    --mdns=no
    --notifications=no
    --pulseaudio=no
    --speaker=off
    --microphone=off
    --printing=no
    --webcam=no
    --dbus-launch=no
    --exit-with-children=no
    --start-child=/app/bin/launch-chrome.sh
)

if [ -n "${XPRA_EXTRA_ARGS:-}" ]; then
    # shellcheck disable=SC2206
    EXTRA_ARGS=(${XPRA_EXTRA_ARGS})
    XPRA_ARGS+=("${EXTRA_ARGS[@]}")
fi

exec xpra "${XPRA_ARGS[@]}"
