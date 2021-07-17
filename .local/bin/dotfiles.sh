#!/bin/sh
# This is a currently just a script that links certain things to
# outside of my home directory

repoDir=$HOME/.config/repo.git
backupDir=$HOME/backup-config
gitURL="git://philipj.ydns.eu/dotfiles.git"

gitdot() {
    git --git-dir=$repoDir --work-tree=$HOME $@
}

setup() {
    printf "Cloning dotfiles into $repoDir\n"
    git clone --bare --branch termux $gitURL $repoDir > /dev/null
    printf "Done\n"
    gitdot checkout 2>&1 /dev/null
    if [ $? -ne 0 ]; then
        mkdir -p $backupDir
        printf "Conflicting config files found. Moving to $backupDir\n"
        gitdot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $backupDir/{}
    fi;
    gitdot checkout > /dev/null
    gitdot config status.showUntrackedFiles no > /dev/null
}

changeShell() {
    printf "Change to zsh?\n"
    select yn in "Yes" "No"
    case $yn in
        yes ) chsh -s zsh;;
    esac
}

setkeyMap() {
    sudo ln -sf ~/.config/xkb/se_cm /usr/share/X11/xkb/symbols/ 2>&1 /dev/null
    setxkbmap se_cm 2>&1 /dev/null
}

[ ! -e $repoDir ] && setup

shell = `echo $SHELL | awk -F '/' '{print $(NF)}'`
[ $shell = "zsh" ] || changeShell
setkeyMap || printf "Error setting xkb map. Perhaps you don't have X installed?\n"
