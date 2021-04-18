#! /bin/zsh

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root"; exit 1; fi

# Decrypting the drive before
parent_path=$( cd "$(dirname "${(%):-%N}")" ; pwd -P )
cat $parent_path/key | ssh pi@pi.lan sudo decrypt.sh

rsync -aAXHSp --delete -e ssh --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/*/.thumbnails/*","/home/*/Downloads/*","/home/*/.cache/mozilla/*","/home/*/.local/share/Trash/*","/home/*/Vbox","/home/*/Documents/archiso/build/*","/home/*/Documents/archiso/work"} / root@pi.lan:/$HOST && ssh pi@pi.lan sudo snapshot.sh $HOST

# Encrypt drive when done
ssh pi@pi.lan sudo encrypt.sh
