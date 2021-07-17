#!/bin/sh
# This is a currently just a script that links certain things to
# outside of my home directory

repoDir=$HOME/.config/repo.git
backupDir=$HOME/backup-config
gitURL="https://github.com/flyingpeakock/dotfiles.git"

gitdot() {
    git --git-dir=$repoDir --work-tree=$HOME $@
}

setup() {
    printf "Cloning dotfiles into $repoDir\n"
    git clone --bare --branch laptop $gitURL $repoDir > /dev/null
    printf "Attempting to check out bare repo\n"
    gitdot checkout 2>&1 /dev/null
    if [ $? -ne 0 ]; then
        mkdir -p $backupDir
        printf "Conflicting config files found. Moving to $backupDir\n"
        gitdot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $backupDir/{}
        gitdot checkout > /dev/null && printf "Checked out bare repo to home directory\n"
    fi;
    gitdot config status.showUntrackedFiles no > /dev/null
}

changeShell() {
    printf "Change default shell to zsh?\n"
    select yn in "Yes" "No"
    case $yn in
        Yes ) chsh -s /bin/zsh;;
    esac
}

setkeyMap() {
    sudo ln -sf ~/.config/xkb/se_cm /usr/share/X11/xkb/symbols/ 2>&1 /dev/null
    setxkbmap se_cm 2>&1 /dev/null
}


[ ! -e $repoDir ] && setup

shell = `echo $SHELL | awk -F '/' '{print $(NF)}'`
[ $shell = "zsh" ] || changeShell
[ -e $HOME/.config/xkb/se_cm ] && setkeyMap || printf "Error setting xkb map. Perhaps you don't have X installed?\n"
