#!/bin/bash

echo """
#####################################
#Setting up i3 and misc config files#
#####################################
""";

sudo ln -sf ~/.dotfiles/i3/i3/ ~/.config/
ln -sf ~/.dotfiles/i3/i3status/ ~/.config/
ln -sf ~/.dotfiles/i3/picom.conf ~/.config/
ln -sf ~/.dotfiles/i3/rofi/ ~/.config/

echo "completed"
