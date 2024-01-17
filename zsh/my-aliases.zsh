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

