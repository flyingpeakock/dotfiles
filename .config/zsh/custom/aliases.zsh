alias open=xdg-open
alias diskspace="du -S | sort -n -r | less"
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"
alias loki="ssh -X philipj@loki.asgard"
alias balder="ssh -X philipj@balder.asgard"
alias heimdall="ssh -X pi@heimdall.asgard"
alias phone="ssh localhost@phone.lan -p 8022"
alias python="python3"
alias pip="pip3"
alias calc="python -i -c 'from math import *; import numpy as np;'"
alias vimsu="sudo -e"
alias -s pdf=zathura
alias gpg2=gpg2 --homedir "$XDG_DATA_HOME"/gnupg
alias dragon="dragon-drag-and-drop -a -x"
exa --icons &> /dev/null
if [ "$?" -gt 0 ]; then
    alias ll="exa -l --git"
    alias ls="exa --git"
else
    alias ll="exa -l --git --icons"
    alias ls="exa --git --icons"
fi
