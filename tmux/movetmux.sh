#!/bin/bash

which tmux > /dev/null 2>&1
    if [[ ! "$?" -eq "0" ]]; then
        echo "No tmux installation found, exiting"
        exit 1
    fi

ln -sf ~/.dotfiles/tmux/.tmux.conf ~/ || echo "could not move .tmux.conf"
ln -sf ~/.dotfiles/tmux/.tmux ~/ || echo "could not move .tmux folder"
echo "linked tmux config files"
