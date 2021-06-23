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
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
autoload -U compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

eval "$(fasd --init auto)"

# Plugins
source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=(~/.conifg/zsh/plugins/zsh-completions/src $fpath)
source ~/.config/zsh/plugins/zsh-histdb/sqlite-history.zsh
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.config/zsh/plugins/command-not-found/command-not-found.zsh

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

# User files
for CUSTOM in `find ~/.config/zsh/custom`
do
    [ -f "$CUSTOM" ] && source "$CUSTOM"
done

source ~/.config/zsh/p10k.zsh

# try to set xkbmap here for tty
setxkbmap se_cm 2> /dev/null

# Keep this at the end
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
