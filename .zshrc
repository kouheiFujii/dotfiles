export PATH="$HOME/.rbenv/bin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:/usr/local/protobuf/bin"
eval "$(rbenv init -)"
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"
export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/lib"

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# alias:git
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

# alias: commands
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias vz="vim ~/.zshrc"
alias vsz="code ~/.zshrc" # vscode open
alias cz="cat ~/.zshrc"
alias sz="source ~/.zshrc"

# alias: projects
alias gi="cd ~/git"
alias be="cd ~/git/backend"
alias fe="cd ~/git/frontend"

# alias: docker
alias dstop_all="docker ps --format {{.ID}} | xargs docker stop"
alias dp="docker ps"
alias dimg="docker images"
alias drmi="docker rmi"
alias dcrm="docker container rm"

# alias: docker compose
alias dc="docker compose"
alias dce="docker compose exec"

dcup() {
  docker compose up $@
}

dcrun() {
  docker compose run --rm $@
}
# iTerm starship
eval "$(starship init zsh)"

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
