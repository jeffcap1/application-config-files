#!/usr/bin/env bash
# Toggle the workmux sidebar. When showing it, focus the sidebar pane in the
# given window. Hiding uses `workmux sidebar off`, which avoids the `q` prompt.
# Usage: workmux-sidebar-toggle.sh <window_id>
set -euo pipefail

window="${1:-}"

if [[ -n "$(tmux show-options -gqv @workmux_sidebar_enabled)" ]]; then
  workmux sidebar off
  exit 0
fi

workmux sidebar on

[[ -z "$window" ]] && exit 0
pane="$(tmux list-panes -t "$window" -F '#{pane_id} #{pane_start_command}' |
  awk '/_sidebar-run/ { print $1; exit }')"
[[ -n "$pane" ]] && tmux select-pane -t "$pane"
