# Start x
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
      exec startx $XINITRC &> /dev/null
fi
