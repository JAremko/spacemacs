#!/bin/bash

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

git config --global user.email $GEMAIL
git config --global user.name $GNAME

/usr/sbin/sshd -De
