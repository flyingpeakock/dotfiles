#!/bin/bash

if [[ $(id -u) = 0 ]]; then
    echo "Running as root"
else
    echo "This script needs to be run as root"
    exit 1
fi

which pacman > /dev/null 2>&1
    if [[ ! "$?" -eq "0" ]]; then
        echo "pacman is not installed..."
        echo "exiting"
        exit 1
    fi

pacinstall() {
    which $1 > /dev/null 2>&1
        if [[ "$?" -eq "0" ]]; then
            echo "${1} found, not installing."
        else
            pacman -S --noconfirm $1
            echo "${1} installed."
        fi
}

apps=( zsh tmux vim )
for i in "${apps[@]}"
do
    pacinstall $i
done
