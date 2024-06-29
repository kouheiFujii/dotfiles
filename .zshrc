export DOTFILES=$HOME/git/dotfiles

. $(brew --prefix asdf)/libexec/asdf.sh

[[ -f $DOTFILES/zsh/aliases.zsh ]] && source $DOTFILES/zsh/aliases.zsh
[[ -f $DOTFILES/zsh/functions.zsh ]] && source $DOTFILES/zsh/functions.zsh
