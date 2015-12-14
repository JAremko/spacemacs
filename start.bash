#!/bin/bash

sudo git config --global user.email $GEMAIL
sudo git config --global user.name $GNAME

export NO_AT_BRIDGE=1
export SHELL=/usr/bin/fish

/usr/bin/emacs
