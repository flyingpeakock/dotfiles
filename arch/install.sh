#!/bin/bash

# Run reflector for faster downloads
# Change this if in a different location
sudo pacman --noconfirm -S --needed reflector || echo "error installing reflector" && sleep 1

sudo reflector --country Sweden --country Norway --country Denmark --country Finland --sort rate --connection-timeout 2 --download-timeout 2 --age 24 --save /etc/pacman.d/mirrorlist && echo "mirrorlist updated" || echo "could not update mirrorlist" && sleep 1

# Install yay
sudo pacman --noconfirm -S --needed base-devel || echo "could not install base-devel group" && sleep 1   # Making sure base-devel is installed

git clone https://aur.archlinux.org/yay.git || echo "could not clone yay" && sleep 1

pushd yay
makepkg -si && echo "yay installed" || echo "could not install yay" && sleep 1
popd
rm -r yay || echo "could not remove yay directory" && sleep 1

# Update
sudo pacman --noconfirm Syu && echo "Update completed." || echo "error updating" && sleep 1

# Installing packages from pkglist
sudo pacman --noconfirm -S --needed - < ~/.dotfiles/arch/pkglist.txt && echo "pacman packages installed" || echo "error installing pacman packages" && sleep 1

# Installing packages from pkglist_AUR
yay --noconfirm -S --needed - < ~/.dotfiles/arch/pkglist_aur.txt && echo "yay packages installed" || echo "error installing aur packages" && sleep 1

# Moving config files

# xkb map
sudo ln -sf ~/.dotfiles/keyboard/se_cm /usr/share/X11/xkb/symbols/ && echo "xkb map linked" || echo "Could not link xkb map"

# Alacritty terminal
ln -sf /.dotfiles/alacritty ~/.config/ && echo "Alacritty config linked" || echo "could not link alacritty config"
l

# Setup nnn config and plugins
ln -sf /.dotfiles/nnn ~/.config/ && echo "nnn config linked" || echo "could not link nnn config"

# Creating user bin directory if it doesn't exist
if [ ! -d ~/.local ]; then
    mkdir ~/.local
fi
if [ ! -d ~/.local/bin ]; then
    mkdir ~/.local/bin
fi

# Setup i3 and other wm related config files
~/.dotfiles/i3/movei3.sh && echo "Linked i3 config" || echo "Error setting up i3"

# Setup tmux config
~/.dotfiles/tmux/movetmux.sh && echo "Linked tmux config" || "Error linking tmux config"

# Setup zsh config
~/.dotfiles/zsh/movezsh.sh && echo "Linked zsh config" || "Error linking zsh config"

# Setup vim config
~/.dotfiles/vim/movevim.sh && echo "Linked vim config" || "Error linking vim config"

echo "Setup completed"

