#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='lsd'
alias nvi="nvim"
alias rm="trash"
PATH="$HOME/.local/bin:$PATH"
PS1="\[\033[32m\]  \[\033[37m\]\[\033[34m\]\w \[\033[0m\]"
. "$HOME/.cargo/env"
export PATH=$PATH:/home/namish/.spicetify
