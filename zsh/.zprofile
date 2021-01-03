export EDITOR='vim'
export VISUAL='vim'

TERMINAL=alacritty; export TERMINAL

path+=('/home/philipj/.local/bin')

# nnn configuration
###################################
export NNN_SSHFS="sshfs -o follow_symlinks" # make sshfs follow symlinks on the remote
export NNN_COLORS="2136"                    # use a different color for each context
export NNN_TRASH=1                          # trash (needs trash-cli) instead of delete

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
      exec startx &> /dev/null   			# Starting i3wm
fi
