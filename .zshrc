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

[[ -f $DOTFILES/zsh/aliases.zsh ]] && source $DOTFILES/zsh/aliases.zsh
