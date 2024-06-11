## Tmux 256-color support

To enable tmux-256color support on MacOS you will need to download the termcolor info first. Run the below commands and
kill tmux and restart it to pick up the latest configuration changes.

```bash
brew install ncurses
$(brew --prefix)/opt/ncurses/bin/infocmp -x tmux-256color > ~/tmux-256color.src
tic -x terminfo.src
```

Verify the command terminfo is working by running `echo $TERM` and it should return `tmux-256color`.
