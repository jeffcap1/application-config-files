#!/bin/sh

NVR_BIN="/opt/homebrew/bin/nvr"
NVIM_BIN="/opt/homebrew/bin/nvim"

if [ -n "${NVIM:-}" ]; then
  exec "$NVR_BIN" \
    --servername "$NVIM" \
    --remote-tab-wait-silent \
    +'setlocal bufhidden=delete' \
    "$@"
fi

exec "$NVIM_BIN" "$@"
