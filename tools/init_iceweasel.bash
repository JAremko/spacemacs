#!/bin/bash

sudo apt-get -y install xvfb
sudo Xvfb :1 -screen 0 800x600x24&
sleep 10
DISPLAY=:1 iceweasel&
sleep 60
sudo pkill Xvfb
sudo pkill -f iceweasel
sudo apt-get -y purge xvfb

return 0
