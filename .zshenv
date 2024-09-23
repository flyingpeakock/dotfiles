# Set path
typeset -U PATH path # No duplicates
path+=("$HOME"/.local/bin)

# Vim mode
export EDITOR='vim'
export VISUAL='vim'

export MANROFFOPT="-c"
export PAGER='less'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Move all other zsh files out of home
export ZDOTDIR=$HOME/.config/zsh

# XDG Dirs
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_RUNTIME_DIR=/run/user/"$UID"
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

# Moving stuff out home home
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export LESSHISTFILE=-
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export NVM_DIR="$XDG_DATA_HOME"/nvm
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc
export HISTDB_FILE="$XDG_DATA_HOME"/zsh/history/zsh-history.db
export XAUTHORITY="$XDG_RUNTIME_DIR"/XAuthority
export SQLITE_HISTORY="$XDG_DATA_HOME"/sqlite_history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export SSB_HOME="$XDG_DATA_HOME"/zoom
export TS3_CONFIG_DIR="$XDG_CONFIG_HOME"/ts3client
export _FASD_DATA="$XDG_DATA_HOME"/fasd
export _FASD_VIMINFO="$XDG_CONFIG_HOME"/vim/viminfo

# Moving vim
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.vim" | so $MYVIMRC'

# Atuin url
export ATUIN_SYNC_ADDRESS=https://atuin.loki.asgard

# Location of bare dotfile repository if installed with script
export DOTFILES="$XDG_CONFIG_HOME"/repo.git

# Private stuff that should be kept out of git
setopt NULL_GLOB
for PRIVATE in $ZDOTDIR/private/*.env.zsh
do
    [ -f "$PRIVATE" ] && source "$PRIVATE"
done
unsetopt NULL_GLOB
