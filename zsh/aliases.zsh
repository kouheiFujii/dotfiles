#!/bin/zsh

# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# git
alias g="git"
alias a="git add"
alias cm="git commit"
alias m="git merge"
alias b="git branch"
alias d="git diff"
alias sw="git switch"
alias rt="git restore"
alias rb="git rebase"
alias st="git stash"
alias push="git push origin"
alias pull="git pull origin"
alias pullrb="git pull --rebase origin"
alias checkout="git checkout"
alias re_so="git reset --soft HEAD^"
alias re="git reset"
alias sh="git show"

alias reload="source ${DOTFILES}/.zshrc"

# projects
alias gi="cd ~/git"
alias be="cd ~/git/backend"
alias fe="cd ~/git/frontend"
alias dot="cd ~/dotfiles"

# docker
alias dstop_all="docker ps --format {{.ID}} | xargs docker stop"
alias dp="docker ps"
alias dimg="docker images"
alias drmi="docker rmi"
alias dcrm="docker container rm"

# docker compose
alias dc="docker compose"
alias dce="docker compose exec"

# mysql
alias mstart="mysql.server start"
alias mstop="mysql.server stop"
alias mrestart="mysql.server restart"
alias mlogin="mysql -u root -p"
