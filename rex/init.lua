-- Prefix: ctrl+space.

-- panes
rex.bind("ctrl+space>z", "pane.zoom")
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
rex.bind("ctrl+space>x", "pane.close")
rex.bind("ctrl+space>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+space>shift+5", "pane.split", { direction = "right" })

-- windos/client
rex.bind("ctrl+space>r", "client.tab.rename")
rex.bind("ctrl+space>shift+r", "client.config.reload")
rex.bind("ctrl+space>c", "client.tab.new")
rex.bind("alt+shift+h", "client.tab.previous")
rex.bind("alt+shift+l", "client.tab.next")

-- sessions
rex.bind("ctrl+space>s", "session.switch")

-- Resize mode (tmux key table "resize", plus Herdr's arrow keys)
rex.mode("resize", { exclusive = true })
rex.bind("resize/escape", "client.mode.exit")
rex.bind("resize/enter", "client.mode.exit")
rex.bind("ctrl+space>m", "client.mode.enter", { name = "resize" })
rex.bind("resize/h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("resize/j", "pane.resize", { amount = 5, direction = "down" })
rex.bind("resize/k", "pane.resize", { amount = 5, direction = "up" })
rex.bind("resize/l", "pane.resize", { amount = 5, direction = "right" })
rex.bind("resize/left", "pane.resize", { direction = "left" })
rex.bind("resize/down", "pane.resize", { direction = "down" })
rex.bind("resize/up", "pane.resize", { direction = "up" })
rex.bind("resize/right", "pane.resize", { direction = "right" })
