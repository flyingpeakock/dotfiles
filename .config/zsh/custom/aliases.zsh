alias open=xdg-open
alias diskspace="du -S | sort -n -r | less"
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"
alias rm='echo "Are you sure you want to use this command? Did you mean trash-put?"; echo "If you meant to use rm type \\\\rm"; false'
# alias loki="ssh -X philipj@loki.asgard"
alias loki="tmr philipj@loki.asgard"
alias balder="tmr philipj@balder.asgard"
alias heimdall="ssh -X root@heimdall.asgard"
alias phlip4="tmr phlip4.asgard"
alias python="python3"
alias pip="pip3"
alias calc="python -i -c 'from math import *; import numpy as np;'"
alias vimsu="sudo -e"
alias -s pdf=zathura
alias gpg2=gpg2 --homedir "$XDG_DATA_HOME"/gnupg
alias dragon="dragon-drag-and-drop -a -x"
alias tmpd="cd $(mktemp -d)"
alias remote-backup="ssh remote-backup@heimdall.asgard"
exa --icons &> /dev/null
if [ "$?" -gt 0 ]; then
    alias ll="exa -l --git"
    alias ls="exa --git"
    alias la="exa --all --git"
    alias lla="exa -l --all --git"
else
    alias ll="exa -l --git --icons"
    alias ls="exa --git --icons"
    alias la="exa --all --git --icons"
    alias lla="exa -l --all --git --icons"
fi
