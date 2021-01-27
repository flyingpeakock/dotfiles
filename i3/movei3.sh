#!/bin/bash

ln -sf ~/.dotfiles/i3/i3/ ~/.config/ || echo "could not move i3 config"
ln -sf ~/.dotfiles/i3/i3status/ ~/.config/ || echo "could not move i3status"
ln -sf ~/.dotfiles/i3/picom.conf ~/.config/ || echo "could not move picom conf"
ln -sf ~/.dotfiles/i3/rofi/ ~/.config/ || echo "could not move rofi conf"
ln -sf ~/.dotfiles/i3/dunst/ ~/.config/ || echo "could not move dunstrc"
ln -sf ~/.dotfiles/i3/.xinitrc ~/ || echo "could not move xinitrc"
ln -sf ~/.dotfiles/i3/.Xresources ~/ || echo "could not move Xresources"

echo "linked i3 files"
