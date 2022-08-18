alias ls='ls -G'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Need to set this to get solarized color-scheme
# to work in tmux.
alias tmux='TERM=screen-256color-bce tmux'

# some more ls aliases
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias ss='export $(cat .env) && script/server'
alias server='python -m SimpleHTTPServer'

alias gp='git pull'
alias gc='git commit'
alias gs='git status'
alias gsp='git stage -p'
alias gch='git checkout'

# use Neovim instead of Vim
alias vim='nvim'
