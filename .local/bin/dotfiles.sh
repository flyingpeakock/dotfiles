#!/bin/sh

# This script clones a bare reposity then checks it out
# into the users home directory
# Author: Philip Johansson

repoDir="$HOME/.config/repo.git"
gitURL="https://git.phlipphlop.me/phlipphlop/dotfiles.git"
backupDir="$HOME/config.backup"

gitdot() {
    git --git-dir=$repoDir --work-tree="$HOME" "$@"
}

backup_script=$(mktemp)
cat <<EOF > $backup_script
dir=\$(dirname "\$2")
printf "\\tBacking up file \$1\\n"
mkdir -p "\$dir"
mv "\$1" "\$2"
EOF
chmod +x $backup_script

setup() {
    printf "Cloning dotfiles bare repo into $repoDir\n"
    git clone --bare --branch tty $gitURL $repoDir > /dev/null 2>&1
    printf "Attempting to check out bare repo\n"
    gitdot checkout > /dev/null 2>&1
    if [ "$?" -ne 0 ]; then
        printf "Conflicting files found. Moving to $backupDir\n"
        gitdot checkout 2>&1 | grep -E "^\s" | awk {'print $1'} | xargs -I{} -- sh -c "$backup_script \"{}\" $backupDir/\"{}\""
    fi;
    gitdot checkout > /dev/null && printf "Checked out bare repo to home directory\n"
    gitdot config status.showUntrackedFiles no > /dev/null

    printf "Adding plugins as submodules\n"
    gitdot submodule init > /dev/null 2>&1
    printf "Updating plugins\n"
    gitdot submodule update > /dev/null 2>&1
    printf"Done installing dotfiles"
}

[ ! -e $repoDir ] && setup

