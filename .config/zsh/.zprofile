TERMINAL=st; export TERMINAL

path+=("$HOME"/.local/bin)

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
export TS3_CONFIG_DIR="$XDG_CONFIG_HOME"/ts3client
export SQLITE_HISTORY="$XDG_DATA_HOME"/sqlite_history

# Moving vim
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.vim" | so $MYVIMRC'

export DOTFILES="$XDG_CONFIG_HOME"/repo.git

export NNN_TRASH=1
export NNN_COLORS='1234'
export NNN_OPTS='drx'

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
      exec startx $XINITRC &> /dev/null   			# Starting i3wm
fi
