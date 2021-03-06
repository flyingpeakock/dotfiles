#!/bin/bash

# Run reflector for faster downloads
# Change this if in a different location
sudo pacman --noconfirm -S --needed reflector || echo "error installing reflector" && sleep 1

sudo reflector --country Sweden --country Norway --country Denmark --country Finland --sort rate --connection-timeout 2 --download-timeout 2 --age 24 --save /etc/pacman.d/mirrorlist && echo "mirrorlist updated" || echo "could not update mirrorlist" && sleep 1

# Install paru
sudo pacman --noconfirm -S --needed base-devel || echo "could not install base-devel group" && sleep 1   # Making sure base-devel is installed

git clone https://aur.archlinux.org/paru-bin.git || echo "could not clone paru" && sleep 1

pushd paru
makepkg -si && echo "paru installed" || echo "could not install paru" && sleep 1
popd
rm -rf paru || echo "could not remove paru directory" && sleep 1

# Update
sudo pacman --noconfirm Syu && echo "Update completed." || echo "error updating" && sleep 1

# Installing packages from pkglist
sudo pacman --noconfirm -S --needed - < ~/.dotfiles/arch/pkglist.txt && echo "pacman packages installed" || echo "error installing pacman packages" && sleep 1

# Installing packages from pkglist_AUR
paru --noconfirm -S --needed - < ~/.dotfiles/arch/pkglist_aur.txt && echo "AUR packages installed" || echo "error installing aur packages" && sleep 1

# Moving config files

# xkb map
sudo ln -sf ~/.dotfiles/keyboard/se_cm /usr/share/X11/xkb/symbols/ && echo "xkb map linked" || echo "Could not link xkb map"

# Themeing spotify
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
spicetify
spicetify backup apply enable-devtool
spicetify config current_theme Nord
pushd "$(dirname "$(spicetify -c)")/CustomApps"
git clone https://github.com/khanhas/genius-spicetify genius
popd
spicetify config custom_apps genius
spicetify update
echo "Spotify nord theme applied"

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

