TERMINAL=st; export TERMINAL

path+=('/home/philipj/.local/bin')
path+=('/home/philipj/.cargo/bin')

export DOTFILES=$HOME/.config/repo.git

export NNN_TRASH=1
export NNN_COLORS='1234'
export NNN_OPTS='drx'

export NNN_TRASH=1
export NNN_COLORS='1234'
export NNN_OPTS='drx'

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
      exec startx &> /dev/null   			# Starting i3wm
fi
