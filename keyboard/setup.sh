#!/bin/bash

sudo ln -sf ~/.dotfiles/keyboard/se_cm /usr/share/X11/xkb/symbols/se_cm
localectl --no-convert set-x11-keymap se_cm pc104
