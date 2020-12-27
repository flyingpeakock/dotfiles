#!/bin/bash

which vim > /dev/null 2>&1
    if [[ ! "$?" -eq "0" ]]; then
        echo "No vim installation found, exiting"
        exit 1
    fi

ln -sf ~/.dotfiles/vim/.vim/ ~/ || echo "could not move .vim folder"
ln -sf ~/.dotfiles/vim/.vimrc ~/ || echo "could not move .vimrc"

[[ -f ~/.viminfo ]] && mv ~/.viminfo ~/.dotfiles/vim/viminfo

read -p "Run YouCompleteMe install? (y/N) " yn
case $yn in
    [Yy]* ) ~/.dotfiles/vim/.vim/plugged/YouCompleteMe/install.py --all;
esac
echo "vim config files linked"
