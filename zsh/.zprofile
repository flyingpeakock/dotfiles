TERMINAL=st; export TERMINAL

path+=('/home/philipj/.local/bin')

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
      exec startx &> /dev/null   			# Starting i3wm
fi
