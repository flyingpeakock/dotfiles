#!/bin/bash

pacapps=(
    zsh
    vim
    tmux
    openssh
    sshfs

    cmake
    go
    python
    python-pip
    gdb
    gdb-common

    laptop-mode-tools

    xorg
    xorg-xinit
    arandr
    xterm
    xsel
    xclip
    alacritty

    i3-gaps
    i3lock
    i3status
    rofi
    feh
    lxappearance

    pulseaudio
    pavucontrol
    vlc

    noto-fonts
    noto-fonts-emoji
    powerline-fonts
    ttf-dejavu
    ttf-font-awesome
    papirus-icon-theme

    rofi-calc

    neofetch
    lolcat

    discord
    teamspeak3 

    firefox
    torbrowser-launcher

    thunar
    flameshot

    glances
    ncdu
    networkmanager
    firewalld
    trash-cli
    redshift
    sqlite

    zathura
    zathura-pdf-mupdf
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
    ttf-font-awesome-4
    xcursor-breeze
    zoom
)

# Run reflector for faster downloads
# Change this if in a different location
sudo pacman --noconfirm -S reflector
sudo reflector --country Sweden --country Norway --country Denmark --country Finland --sort rate --connection-timeout 2 --download-timeout 2 --age 24 --save /etc/pacman.d/mirrorlist
sudo systemctl enable reflector.service
echo "reflector enabled"
sleep 1

# Install yay
sudo pacman --noconfirm -S base-devel   # Making sure base-devel is installed
git clone https://aur.archlinux.org/yay.git
pushd yay
makepkg -si
popd
rm yay
echo "yay installed"
sleep 1

# update system with yay
yay ---noconfirm Syu
echo "system updated"
sleep 1

sudo pacman --noconfirm -S ${pacapps[*]}
echo "pacman apps installed"
sleep 1

yay --noconfirm -S ${yayapps[*]}
echo "yay apps installed"
sleep 1

echo "Done installing applications, moving config files"

sudo ln -sf ~/.dotfiles/keyboard/se_cm /usr/share/X11/xkb/symbols/ || echo "Could no create keymap simlink"
echo "keyboard files linked"
sleep 1

ln -sf ~/.dotfiles/alacritty ~/.config/ || echo "could not move alacritty"
echo "alacritty config linked"
sleep 1

if [ ! -d ~/.local ]; then
    mkdir ~/.local
fi
if [ ! -d ~/.local/bin ]; then
    mkdir ~/.local/bin
fi

~/.dotfiles/i3/movei3.sh
sleep 1

~/.dotfiles/tmux/movetmux.sh
sleep 1

~/.dotfiles/zsh/movezsh.sh
sleep 1

~/.dotfiles/vim/movevim.sh
sleep 1

echo "arch setup script completed"

