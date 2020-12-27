#!/bin/bash


pacapps=(
    zsh     # Default shell
    vim     # Text editor
    tmux    # terminal multiplexer
)

yayapps=( )

sudo pacman -S ${pacapps[*]}

