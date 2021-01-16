TERMINAL=alacritty; export TERMINAL

path+=('/home/pi/.local/bin')

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
      exec startx &> /dev/null   			# Starting i3wm
fi
