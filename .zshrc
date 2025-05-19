zmodload zsh/zprof

export PATH="$HOME/.asdf/installs/ruby/3.3.0/bin:$PATH"
export DOTFILES=$HOME/git/dotfiles

# export PATH="/usr/local/opt/mysql-client/bin:$PATH"
# export CPATH="/usr/local/opt/mysql-client/include:$CPATH"
# export LIBRARY_PATH="/usr/local/opt/mysql-client/lib:$LIBRARY_PATH"
# export LDFLAGS="-L/usr/local/opt/mysql-client/lib"
# export CPPFLAGS="-I/usr/local/opt/mysql-client/include"
# export MYSQLCLIENT_LDFLAGS=$(pkg-config --libs mysqlclient)
# export MYSQLCLIENT_CFLAGS=$(pkg-config --cflags mysqlclient)


. $(brew --prefix asdf)/libexec/asdf.sh

[[ -f $DOTFILES/zsh/aliases.zsh ]] && source $DOTFILES/zsh/aliases.zsh
[[ -f $DOTFILES/zsh/functions.zsh ]] && source $DOTFILES/zsh/functions.zsh

if [ -f '/Users/kouhei/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kouhei/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kouhei/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kouhei/google-cloud-sdk/completion.zsh.inc'; fi
