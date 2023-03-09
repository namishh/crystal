
# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:

echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'
bindkey "^[[3~" delete-char
alias v="nvim"
alias rm="trash"
alias ls='ls --color=auto'
alias clp='dye -b -p "#5a5a58,#838383,#191919,#121111,#dfddde,#dfdddd,#eaac79,#1b1b1b,#af575b,#7d8a6b,#caac79,#7d95ae,#a07ea7,#6d8f8a,#b7b7b7,#272727,#c15a5e,#8fa175,#d8b170,#8097fb,#b183ba,#8cb5af,#d4d5d5"'
PATH=$PATH:~/.local/bin
export PATH
export PATH=$PATH:/home/namish/.spicetify:/home/namish/.nimble/bin:/home/namish/.local/share/nvim/mason/bin
