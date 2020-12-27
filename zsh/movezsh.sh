#!/bin/bash

which zsh > /dev/null 2>&1
    if [[ ! "$?" -eq "0" ]]; then
        echo "No zsh installation found, exiting"
        exit 1
    fi

ln -sf ~/.dotfiles/zsh/.zshrc ~/ || echo "could not move .zshrc"
ln -sf ~/.dotfiles/zsh/.zprofile ~/ || echo "could not move .zprofile"
if [[ -f ~/.zcompdump* ]]; then
    mv -i ~/.zcompdump* ~/.dotfiles/zsh/
fi
chsh -s /bin/zsh
echo "zsh config files linked"
