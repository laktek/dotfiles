[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


#export DISPLAY=":0.0"
export CLICOLOR=1
#export MANPATH="/usr/local/man:$MANPATH"
#export COPYFILE_DISABLE=true
export ARCHFLAGS='-arch x86_64'
export EDITOR='vim -f'

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}

export PS1="\[\033[38;5;33m\]\h\[\033[38;5;64m\]:\[\033[38;5;37m\]\W\[\033[38;5;136m\]\$(parse_git_branch)\[\033[38;5;160m\]\$\[\033[00m\] "

# Source NVM to manage Node versions
[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh

# Include Go tools
export GOROOT=/usr/local/go/
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

 #Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# Override default bash settings based on the OS.
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  . ~/.bash_linux
elif [[ "$unamestr" == 'Darwin' ]]; then
  . ~/.bash_osx
fi

# Add Flutter to PATH
export PATH=$PATH:/$HOME/src/flutter/bin
