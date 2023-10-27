#!/bin/bash

# if not running interactively, don't do anything

case $- in
    *i*) ;;
      *) return;;
esac

# set a fancy prompt (non-color, unless we know we "want" color)

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)

        color_prompt=yes
    else
	    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt

# if this is an xterm set the title to user@host:dir

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# aliases

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# variables

export PATH="/home/yasiru/bin:$PATH"
export PYTHONSTARTUP="$HOME/.pythonrc.py" # python startup file

# history configuration

setopt histignorealldups

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# keybindings

bindkey "^ " autosuggest-accept
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# utility

if [ -f ./.venv/bin/activate ]; then
    source ./.venv/bin/activate # if a python virtual envirnment is found activate it automatically
    activate() { source ./.venv/bin/activate; } # utility command to easily activate the enviornment
fi

eval "$(zoxide init zsh)" # setting up zoxide
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(oh-my-posh init zsh --config /home/yasiru/Documents/.posh-theme.omp.json)"

# setting up thefuck

# eval $(thefuck --alias)
# eval $(thefuck --alias fk)

setup_nvm() {
    export NVM_DIR="$HOME/.nvm"

    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion
}

# zsh plugins

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # !!! must be the last plugin sourced
