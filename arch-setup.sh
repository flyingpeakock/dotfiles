#!/bin/bash

pacapps=(
    zsh     # Default shell
    vim     # Text editor
    tmux    # terminal multiplexer
    openssh

    cmake

    xorg-server
    xorg-xinit
    xorg-xrandr
    xterm
    xsel
    xclip

    i3-gaps
    i3lock
    i3status
    rofi
    feh
    lxappearance

    pulseaudio
    pavucontrol

    noto-fonts
    noto-fonts-emoji
    powerline-fonts
    ttf-dejavu
    ttf-font-awesome
    papirus-icon-theme
    xcursor-breeze

    rofi-calc

    neofetch
    lolcat

    alacritty   # Terminal
    firefox     # Web browser
    teamspeak3 
    discord
    flameshot
    glances
    go
    ncdu
    networkmanager
    firewalld
    zoom
    python
    python-pip
    redshift
    thunar
    torbrowser-launcher
    trash-cli
    vlc
    sqlite
)

yayapps=( 
    console_sudoku # My own app
    picom-git
    visual-studio-code-bin
    bitwarden-cli
    latex-mk
    nordic-theme-git
    otf-font-awesome
    rofi-emoji
    rofi-greenclip
    ttf-tonf-awesome-4
)

# Run reflector for faster downloads
# Change this if in a different location
sudo pacman --noconfirm -S reflector
sudo reflector --country Sweden --country Norway --country Denmark --country Finland --sort rate --connection-timeout 2 --download-timeout 2 --age 24 --save /etc/pacman.d/mirrorlist
sudo systemctl enable reflector.service
echo "reflector enabled"
wait 1

# Install yay
sudo pacman --noconfirm -S base-devel   # Making sure base-devel is installed
git clone https://aur.archlinux.org/yay.git
pushd yay
makepkg -si
popd
rm yay
echo "yay installed"
wait 1

# update system with yay
yay ---noconfirm Syu
echo "system updated"
wait 1

sudo pacman --noconfirm -S ${pacapps[*]}
echo "pacman apps installed"
wait 1

yay --noconfirm -S ${yayapps[*]}
echo "yay apps installed"
wait 1

echo "Done installing applications, moving config files"

sudo ln -sf ~/.dotfiles/keyboard/se_cm /usr/share/X11/xkb/symbols/ || echo "Could no create keymap simlink"
echo "keyboard files linked"
wait 1

ln -sf ~/.dotfiles/alacritty ~/.config/ || echo "could not move alacritty"
echo "alacritty config linked"
wait 1

if [ ! -d ~/.local ]; then
    mkdir ~/.local
fi
if [ ! -d ~/.local/bin ]; then
    mkdir ~/.local/bin
fi

~/.dotfiles/i3/movei3.sh
wait 1

~/.dotfiles/tmux/movetmux.sh
wait 1

~/.dotfiles/zsh/movezsh.sh
wait 1

~/.dotfiles/vim/movevim.sh
wait 1

echo "arch setup script completed"

