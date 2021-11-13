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
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
autoload -U compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# User files
for CUSTOM in $ZDOTDIR/custom/*
do
    [ -f "$CUSTOM" ] && source "$CUSTOM"
done

# Private files
privateDir="$ZDOTDIR/private/rc"
if [[ -d "$privateDir" ]];
then
    for PRIVATE in $privateDir/*
    do
        [ -f "$PRIVATE" ] && source "$PRIVATE"
    done
fi

eval "$(zoxide init zsh)"

# Plugins
source "$ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fpath=("$ZDOTDIR/plugins/zsh-completions/src" $fpath)
source "$ZDOTDIR/plugins/zsh-histdb/sqlite-history.zsh"
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$ZDOTDIR/plugins/command-not-found/command-not-found.zsh"
source "$ZDOTDIR/plugins/fuzzy-sys/fuzzy-sys.plugin.zsh"

_zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    suggestion=$(_histdb_query "$query")
}
ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

source "$ZDOTDIR/p10k.zsh"

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

# Keep this at the end
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
