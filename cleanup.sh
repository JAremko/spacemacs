#!/bin/sh

apt-get clean -y
rm -rf /var/lib/apt/lists/*
rm -rf /var/lib/apt/lists/partial/*
rm -rf /tmp/*

find / -name ".git" -prune -exec rm -rf "{}" \;
