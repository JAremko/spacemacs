#!/bin/bash

sudo git config --global user.email $GEMAIL
sudo git config --global user.name $GNAME

export NO_AT_BRIDGE=1
export SHELL=/usr/bin/fish

mkdir -p ~/workspace/desktop

/usr/bin/emacs

sudo poweroff
