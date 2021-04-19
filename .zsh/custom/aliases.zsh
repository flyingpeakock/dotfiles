alias open=xdg-open
alias diskspace="du -S | sort -n -r |more"
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"
alias please='sudo $(fc -ln -1)'
alias rm='echo "Are you sure you want to use this command? Did you mean trash-put?"; echo "If you meant to use rm type \\\\rm"; false'
alias pc="ssh -X philipj@desktop.lan"
alias laptop="ssh -X philipj@laptop.lan"
alias rasp="ssh -X pi@pi.lan"
alias phone="ssh localhost@phone.lan -p 8022"
alias python="python3"
alias pip="pip3"
alias calc="python -i -c 'from math import *; import numpy as np;'"
alias vimsu="sudo -E vim"
alias -s pdf=zathura
alias gitdot="git --git-dir=$DOTFILES --work-tree=$HOME"
alias gpg2=gpg2 --homedir "$XDG_DATA_HOME"/gnupg
