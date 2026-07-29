# Herdr Plugins Setup

This document records the installation and configuration steps for:

- [`vim-herdr-navigation`](https://github.com/paulbkim-dev/vim-herdr-navigation)
- [`herdr-plugin-sesh`](https://github.com/fullerzz/herdr-plugin-sesh)

It also documents the local fixes required for Alt-based Neovim navigation and source-based installation of the Sesh plugin.

## Prerequisites

The examples assume:

- Herdr is installed and working.
- Herdr's prefix is configured as `ctrl+space`.
- Navigation uses `Alt+h/j/k/l`.

Recommended local plugin directory:

```text
~/.config/herdr/plugins
```

---

# vim-herdr-navigation

## 1. Clone and link the plugin

```zsh
git clone \
  https://github.com/paulbkim-dev/vim-herdr-navigation.git \
  "$HOME/.config/herdr/plugins/vim-herdr-navigation"

herdr plugin link \
  "$HOME/.config/herdr/plugins/vim-herdr-navigation"
```

Verify the plugin actions:

```zsh
herdr plugin action list --plugin vim-herdr-navigation
```

## 2. Configure Herdr keybindings

Disable Herdr's built-in direct pane-focus bindings so they do not conflict with the plugin actions:

```toml
[keys]
focus_pane_left = ""
focus_pane_down = ""
focus_pane_up = ""
focus_pane_right = ""
```

Add the plugin-action bindings:

```toml
[[keys.command]]
key = "alt+h"
type = "plugin_action"
command = "vim-herdr-navigation.left"
description = "Navigate left across Neovim and Herdr panes"

[[keys.command]]
key = "alt+j"
type = "plugin_action"
command = "vim-herdr-navigation.down"
description = "Navigate down across Neovim and Herdr panes"

[[keys.command]]
key = "alt+k"
type = "plugin_action"
command = "vim-herdr-navigation.up"
description = "Navigate up across Neovim and Herdr panes"

[[keys.command]]
key = "alt+l"
type = "plugin_action"
command = "vim-herdr-navigation.right"
description = "Navigate right across Neovim and Herdr panes"
```

Reload Herdr after editing the configuration.

## 3. Fix Alt-key forwarding

The upstream `navigate.sh` forwards `Ctrl+h/j/k/l` into Neovim. When Herdr is configured to capture `Alt+h/j/k/l`, that creates a mismatch:

```text
Alt+h in Herdr
-> plugin action runs
-> navigate.sh forwards Ctrl+h
-> Neovim is listening for Alt+h
-> nothing happens
```

Edit:

```text
~/.config/herdr/plugins/vim-herdr-navigation/navigate.sh
```

Change the forwarded keys from Ctrl to Alt.

Before:

```bash
case "$dir" in
  left) key="ctrl+h" ;;
  down) key="ctrl+j" ;;
  up) key="ctrl+k" ;;
  right) key="ctrl+l" ;;
  *) echo "navigate.sh: unknown direction: $dir" >&2; exit 2 ;;
esac
```

After:

```bash
case "$dir" in
  left) key="alt+h" ;;
  down) key="alt+j" ;;
  up) key="alt+k" ;;
  right) key="alt+l" ;;
  *) echo "navigate.sh: unknown direction: $dir" >&2; exit 2 ;;
esac
```

Reload Herdr again after changing the script.

> This is a local modification. A future `git pull` may overwrite it. Consider maintaining a fork or a small patch file.

## 4. Verify navigation

Inside Neovim:

```vim
:verbose nmap <M-h>
:verbose nmap <M-j>
:verbose nmap <M-k>
:verbose nmap <M-l>
```

Expected behavior:

```text
Alt+h/j/k/l inside Neovim
-> move between Neovim splits
-> at a Neovim edge, move to a Herdr pane

Alt+h/j/k/l inside another Herdr pane
-> move to the adjacent Herdr pane
```

---

# herdr-plugin-sesh

## 1. Clone the plugin

```zsh
git clone \
  https://github.com/fullerzz/herdr-plugin-sesh.git \
  "$HOME/.config/herdr/plugins/herdr-plugin-sesh"
```

Use the exact directory name `herdr-plugin-sesh`. A differently named directory can still be linked, but using the repository name avoids confusion while troubleshooting.

## 2. Build the plugin binary

A local `herdr plugin link` reads the plugin manifest, but it does not necessarily build the executable referenced by that manifest.

The plugin expects this binary:

```text
./bin/herdr-sesh
```

The repository provides a `just` task, but `just` is not required. Run the underlying commands directly:

```zsh
cd "$HOME/.config/herdr/plugins/herdr-plugin-sesh"

mkdir -p bin
go build -o bin/herdr-sesh ./cmd/herdr-sesh
```

Verify the binary exists:

```zsh
ls -l bin/herdr-sesh
```

## 3. Link the built plugin

```zsh
cd "$HOME/.config/herdr/plugins/herdr-plugin-sesh"

herdr plugin unlink fullerzz.sesh 2>/dev/null || true
herdr plugin link "$PWD"
```

Verify its actions:

```zsh
herdr plugin action list --plugin fullerzz.sesh | jq
```

## 4. Configure Herdr keybindings

```toml
[[keys.command]]
key = "prefix+t"
type = "plugin_action"
command = "fullerzz.sesh.open-picker"
description = "Open the Sesh workspace picker"

[[keys.command]]
key = "prefix+shift+l"
type = "plugin_action"
command = "fullerzz.sesh.last"
description = "Switch to the previous Sesh workspace"
```

Reload Herdr after changing the configuration.

## 5. Validate the plugin independently of keybindings

Open the picker directly:

```zsh
herdr plugin action invoke fullerzz.sesh.open-picker
```

Invoke the previous-workspace action directly:

```zsh
herdr plugin action invoke fullerzz.sesh.last
```

Inspect plugin logs:

```zsh
herdr plugin log list --plugin fullerzz.sesh | jq
```

### Missing binary error

If the logs contain:

```text
No such file or directory (os error 2)
```

and show a command such as:

```text
./bin/herdr-sesh plugin open-picker
```

then the plugin binary was not built before linking. Repeat the build and relink steps.

## 6. Previous-workspace behavior

`fullerzz.sesh.last` only works after Sesh has recorded a previous workspace.

This sequence works:

```text
prefix+t
-> select workspace A

prefix+t
-> select workspace B

prefix+shift+l
-> return to workspace A
```

This sequence does not currently populate Sesh history:

```text
Herdr native workspace picker
-> switch to another workspace
-> fullerzz.sesh.last
```

When no Sesh-managed history exists, the plugin log reports:

```text
no previous workspace recorded
```

Use the Sesh picker (`prefix+t`) as the primary workspace picker when you want `prefix+shift+l` to return to the previous workspace.

---

# Updating the plugins

## vim-herdr-navigation

Because `navigate.sh` was locally modified, update carefully:

```zsh
cd "$HOME/.config/herdr/plugins/vim-herdr-navigation"
git pull --ff-only
```

After pulling, verify that `navigate.sh` still forwards `alt+h/j/k/l`. Reapply the patch if upstream replaced it.

## herdr-plugin-sesh

After pulling new source, rebuild and relink:

```zsh
cd "$HOME/.config/herdr/plugins/herdr-plugin-sesh"

git pull --ff-only
mkdir -p bin
go build -o bin/herdr-sesh ./cmd/herdr-sesh
herdr plugin link "$PWD"
```

Reload Herdr after updating either plugin.

---

# Troubleshooting commands

List actions:

```zsh
herdr plugin action list --plugin vim-herdr-navigation
herdr plugin action list --plugin fullerzz.sesh | jq
```

Inspect Sesh logs:

```zsh
herdr plugin log list --plugin fullerzz.sesh | jq
```

Verify the Sesh executable:

```zsh
ls -l "$HOME/.config/herdr/plugins/herdr-plugin-sesh/bin/herdr-sesh"
```

Reload Herdr using the configured reload action or restart Herdr completely.
