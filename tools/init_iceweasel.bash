#!/bin/bash

sudo apt-get -y install xvfb
echo "star Xvfb"
sudo Xvfb :1 -screen 0 800x600x24&
echo "sleep 10"
sleep 10
echo "start iceweasel"
DISPLAY=:1 iceweasel&
echo "sleep 60"
sleep 60
echo "kill iceweasel"
sudo pkill -f iceweasel || true
echo "kill Xvfb"
sudo pkill Xvfb || true
sudo apt-get -y purge xvfb
