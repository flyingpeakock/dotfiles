#!/bin/sh
# This is a currently just a script that links certain things to
# outside of my home directory

sudo ln -sf ~/Documents/systemd/backup.timer /etc/systemd/system/ || echo "Could not link backup.timer"

sudo ln -sf ~/Documents/systemd/backup.service /etc/systemd/system/ || echo "Could not link backup.service"

sudo ln -sf ~/Documents/systemd/customlock@.service /etc/systemd/system/ || echo "Could not link custom lock"

sudo ln -sf ~/.config/xkb/se_cm /usr/share/X11/xkb/symbols/ || echo "Could not link xkb map"

