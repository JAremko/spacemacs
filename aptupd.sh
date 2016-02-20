#!/bin/sh

apt-get clean -y
rm -rf /var/lib/apt/lists/*
rm -rf /var/lib/apt/lists/partial/*
apt-get clean -y
apt-get update -y
apt-get upgrade -y
