#!/bin/bash
Xvfb :1 -screen 0 800x600x24&
xvfbPID=$!
sleep 5
DISPLAY=:1 iceweasel&
sleep 60 
kill $!
kill $xvfbPID
