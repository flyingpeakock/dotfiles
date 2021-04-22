#!/bin/sh
# This is a currently just a script that links certain things to
# outside of my home directory

repoDir=$HOME/.config/repo.git
gitURL="git://philipj.ydns.eu/dotfiles.git"

gitdot() {
    git --git-dir=$repoDir --work-tree=$HOME $@
}

setup() {
    git clone --bare --branch tty $gitURL $repoDir
    mkdir -p .config-backup
    gitdot checkout
    if [ $? = 0 ]; then
        echo "Checkout out config.";
    else
        echo "Backing up existing dotfiles"
        gitdot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
    fi;
    gitdot checkout
    gitdot config status.showUntrackedFiles no

    echo "Don't forget to change shell and set setxkbmap"
}

[ ! -e $repoDir ] && setup

sudo ln -sf ~/.config/xkb/se_cm /usr/share/X11/xkb/symbols/ || echo "Could not link xkb map"

