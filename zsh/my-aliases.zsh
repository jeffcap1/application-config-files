# My custom aliases
alias ll="ls -lAh"
alias bo="brew update && echo \"\n---------\n\" && brew outdated --greedy"
alias bu="brew upgrade"
alias bug="brew upgrade --greedy"
alias sup="source ~/.zshrc"
alias gpat="git pull --all --tags"
alias addkey='eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa'
alias vi="env TERM=wezterm nvim"
alias nvim="env TERM=wezterm nvim"
alias ff="fastfetch"

alias gt="git tag -l | sort -Vr | head -n 10"
alias gtf="git tag -l | sort -Vr"

# tmux
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# tmuxifier
alias t='tmuxifier ls | fzf | xargs -I{} tmuxifier s {}'

