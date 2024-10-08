# Set path
typeset -U PATH path # No duplicates
path+=("$HOME"/.local/bin)
[[ -d "$HOME"/.atuin/bin ]] && path+=("$HOME"/.atuin/bin)

# Vim mode
export EDITOR='vim'
export VISUAL='vim'

# set bat as manpager
export MANROFFOPT="-c"
export PAGER='less'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# XDG Dirs
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_RUNTIME_DIR=/run/user/"$UID"
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

# Move all other zsh files out of home
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh

# Moving stuff out home home
export LESSHISTFILE=-

export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export NVM_DIR="$XDG_DATA_HOME"/nvm
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export HISTDB_FILE="$XDG_DATA_HOME"/zsh/history/zsh-history.db
export SQLITE_HISTORY="$XDG_DATA_HOME"/sqlite_history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export SSB_HOME="$XDG_DATA_HOME"/zoom
export _FASD_DATA="$XDG_DATA_HOME"/fasd
export GOPATH="$XDG_DATA_HOME"/go

export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc
export TS3_CONFIG_DIR="$XDG_CONFIG_HOME"/ts3client
export _FASD_VIMINFO="$XDG_CONFIG_HOME"/vim/viminfo
export IPYTHONDIR="$XDG_CONFIG_HOME"/ipython
export XCURSOR_PATH="${XCURSOR_PATH}":"$XDG_DATA_HOME"/icons
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

export XAUTHORITY="$XDG_RUNTIME_DIR"/XAuthority

# Moving vim
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.vim" | so $MYVIMRC'

# Location of bare dotfile repository if installed with script
export DOTFILES="$XDG_CONFIG_HOME"/repo.git

# Private stuff that should be kept out of git
setopt NULL_GLOB
for PRIVATE in $ZDOTDIR/private/*.env.zsh
do
    [ -f "$PRIVATE" ] && source "$PRIVATE"
done
unsetopt NULL_GLOB
