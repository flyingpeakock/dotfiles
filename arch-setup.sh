#!/bin/bash


pacapps=(
    zsh     # Default shell
    vim     # Text editor
    tmux    # terminal multiplexer
    openssh

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
systemctl enable reflector.service

# Install yay
sudo pacman --noconfirm -S base-devel   # Making sure base-devel is installed
git clone https://aur.archlinux.org/yay.git
pushd yay
makepkg -si
popd
rm yay

# update system with yay
yay ---noconfirm Syu

sudo pacman --noconfirm -S ${pacapps[*]}
yay --noconfirm -S ${yayapps[*]}

echo "Done installing applications, moving config files"

sudo ln -sf ~/.dotfiles/keyboard/se_cm /usr/share/X11/xkb/symbols/ || echo "Could no create keymap simlink"
ln -sf ~/.dotfiles/alacritty ~/.config/ || echo "could not move alacritty"
~/.dotfiles/i3/movei3.sh
~/.dotfiles/tmux/movetmux.sh
~/.dotfiles/zsh/movezsh.sh
~/.dotfiles/vim/movevim.sh

