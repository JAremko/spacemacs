#!/bin/bash

git config --global user.email $GITEMAIL
git config --global user.name $GITNAME

export NO_AT_BRIDGE=1
export SHELL=/usr/bin/fish

sudo touch ~/workspace/emacs-desktop
sudo chmod 766 ~/workspace/emacs-desktop

/usr/bin/emacs
