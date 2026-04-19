#!/bin/bash
set -euo pipefail

APP_DATA_DIR="${APP_DATA_DIR:-/app/xpra_user_data}"
export HOME="${HOME:-$APP_DATA_DIR}"
PROFILE_DIR="${CHROME_PROFILE_DIR:-${HOME}/chrome-profile}"
START_URL="${START_URL:-https://www.google.com/}"
WINDOW_SIZE="${CHROME_WINDOW_SIZE:-1366,768}"

mkdir -p "$PROFILE_DIR"

exec /usr/bin/google-chrome-stable \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --no-first-run \
    --no-default-browser-check \
    --password-store=basic \
    --user-data-dir="$PROFILE_DIR" \
    --window-size="$WINDOW_SIZE" \
    "$START_URL"
