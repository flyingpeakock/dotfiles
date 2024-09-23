# Set colors
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P03B4252" #nord1
    echo -en "\e]P84C566A" #nord3
    echo -en "\e]P1BF616A" #nord11
    echo -en "\e]P9BF616A" #nord11
    echo -en "\e]P2A3BE8C" #nord14
    echo -en "\e]PAA3BE8c" #nord14
    echo -en "\e]P3EBCB8B" #nord13
    echo -en "\e]PBEBCB8B" #nord13
    echo -en "\e]P481A1C1" #nord9
    echo -en "\e]PC81A1C1" #nord9
    echo -en "\e]P5B48EAD" #nord15
    echo -en "\e]PDB48EAD" #nord15
    echo -en "\e]P688C0D0" #nord8
    echo -en "\e]PE8FBCBB" #nord7
    echo -en "\e]P7E5E9F0" #nord5
    echo -en "\e]PFECEFF4" #nord6
    clear #for background artifacting
fi

cbonsai -p 2> /dev/null
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
CASE_SENSITIVE="false"
setopt alwaystoend
setopt autocd
setopt autolist
setopt automenu
setopt autonamedirs
setopt autopushd
setopt cdablevars
setopt completeinword
setopt correctall
setopt histexpiredupsfirst
setopt histfindnodups
setopt histignoredups
setopt histignorespace
setopt interactivecomments
setopt listpacked
setopt nobeep
setopt nocasematch
setopt pushdignoredups
setopt sharehistory
autoload -Uz add-zsh-hook

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' special-dirs false
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' verbose true
_comp_options+=(globdots)
autoload -U compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zmodload zsh/complist

# User files
for CUSTOM in $ZDOTDIR/custom/*
do
    [ -f "$CUSTOM" ] && source "$CUSTOM"
done

fpath=("$ZDOTDIR/functions" $fpath)
for func in $ZDOTDIR/functions/*
do
    autoload $func
done

# Private files
setopt NULL_GLOB
for PRIVATE in $ZDOTDIR/private/*.rc.zsh
do
    [ -f "$PRIVATE" ] && source "$PRIVATE"
done
unsetopt NULL_GLOB

eval "$(zoxide init zsh)"

# Plugins
source "$ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fpath=("$ZDOTDIR/plugins/zsh-completions/src" $fpath)
source "$ZDOTDIR/plugins/command-not-found/command-not-found.zsh"
source "$ZDOTDIR/plugins/fuzzy-sys/fuzzy-sys.plugin.zsh"
source "$ZDOTDIR/plugins/bwf/bwf.plugin.zsh"
eval "$(atuin init zsh)"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char > /dev/null 2>&1
bindkey -M menuselect 'k' vi-up-line-or-history > /dev/null 2>&1
bindkey -M menuselect 'l' vi-forward-char > /dev/null 2>&1
bindkey -M menuselect 'j' vi-down-line-or-history > /dev/null 2>&1
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
	for c in {a,i}{\',\",\`}; do
		bindkey -M $m $c select-quoted
	done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
	for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
		bindkey -M $m $c select-bracketed
	done
done

# Edit line in vim buffer ctrl-v
autoload edit-command-line
zle -N edit-command-line
bindkey '^v' edit-command-line

# Enter vim buffer from normal mode
autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "^v" edit-command-line

# Source any private files if they exist
setopt NULL_GLOB
for PRIVATE in $ZDOTDIR/private/*.rc.zsh
do
    [ -f "$PRIVATE" ] && source "$PRIVATE"
done

# Fix for gpg not prompting for password
export GPG_TTY=$(tty)

source "$ZDOTDIR/p10k.zsh"

# Keep this at the end
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
