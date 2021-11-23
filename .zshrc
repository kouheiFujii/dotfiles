# mysql
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"

# Go programing 
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# alias:bundle
alias be='bundle exec'
alias bi='bundle install'


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
alias st_lis="git stash list"
alias st_ap="git stash apply"
alias push="git push origin"
alias pull="git pull origin"

# iTerm starship
eval "$(starship init zsh)"

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
