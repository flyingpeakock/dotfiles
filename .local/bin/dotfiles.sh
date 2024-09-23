#!/bin/sh

# This script clones a bare reposity then checks it out
# into the users home directory. It also links a swedish
# colemak keyboard layout as well as enables it.
# Author: Philip Johansson

repoDir="$HOME/.config/repo.git"
gitURL="https://git.phlipphlop.me/phlipphlop/dotfiles.git"
backupDir="$HOME/config.backup"


gitdot() {
    git --git-dir=$repoDir --work-tree="$HOME" "$@"
}

backup() {
    dir=$(dirname "$2")
    printf "\tBacking up file $1\n"
    mkdir -p "$dir"
    mv "$1" "$2"
}
export -f backup

setup() {
    printf "Cloning dotfiles bare repo into $repoDir\n"
    git clone --bare --branch wayland $gitURL $repoDir > /dev/null 2>&1
    printf "Attempting to check out bare repo\n"
    gitdot checkout > /dev/null 2>&1
    if [ "$?" -ne 0 ]; then
        printf "Conflicting files found. Moving to $backupDir\n"
        gitdot checkout 2>&1 | egrep "^\s" | awk {'print $1'} | xargs -I{} -- sh -c 'backup "{}" '"$backupDir"'/"{}"'
    fi;
    gitdot checkout > /dev/null && printf "Checked out bare repo to home directory\n"
    gitdot config status.showUntrackedFiles no > /dev/null

    printf "Adding plugins as submodules\n"
    gitdot submodule init > /dev/null 2>&1
    printf "Updating plugins\n"
    gitdot submodule update > /dev/null 2>&1
}

setkeyMap() {
    [ ! -e /usr/share/X11/xkb/symbols/se_cm ] && sudo ln -sf ~/.config/xkb/se_cm /usr/share/X11/xkb/symbols/ > /dev/null 2>&1
    setxkbmap se_cm > /dev/null 2>&1
}

[ ! -e $repoDir ] && setup

shell=$(echo $SHELL | awk -F '/' '{print $(NF)}')
[ "$shell" != "zsh\n" ] && chsh -s /bin/zsh
[ -e "$HOME/.config/xkb/se_cm" ] && setkeyMap

