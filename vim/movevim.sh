#!/bin/bash

echo """
#####################################
#Setting up vim dotfiles and plugins#
#####################################
""";

which vim > /dev/null 2>&1
    if [[ ! "$?" -eq "0" ]]; then
        echo "No vim installation found, exiting"
        exit 1
    fi

ln -sf ~/.dotfiles/vim/.vim/ ~/ || echo "could not move .vim folder"
ln -sf ~/.dotfiles/vim/.vimrc ~/ || echo "could not move .vimrc"

[[ -f ~/.viminfo ]] && mv ~/.viminfo ~/.dotfiles/vim/viminfo

read -p "Run YouCompleteMe install?" yn
case $yn in
    [Yy]* ) ~/.dotfiles/vim/.vim/plugged/YouCompleteMe/install.py --all;
esac
echo "completed"
