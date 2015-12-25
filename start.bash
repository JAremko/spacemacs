#!/bin/bash

sudo git config --global user.email $GEMAIL
sudo git config --global user.name $GNAME

export NO_AT_BRIDGE=1
export SHELL=/usr/bin/fish

sudo touch ~/workspace/emacs-desktop
sudo chmod 777 ~/workspace/emacs-desktop

/usr/bin/emacs
