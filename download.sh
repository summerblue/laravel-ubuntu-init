#!/bin/bash

lsb_release -d | grep 'Ubuntu' >& /dev/null
[[ $? -ne 0 ]] && { echo "仅支持 Ubuntu 16.04 系统"; exit 1; }

DISTRO=$(lsb_release -c -s)
[[ ${DISTRO} -ne "xenial" ]] && { echo "仅支持 Ubuntu 16.04 系统"; exit 1; }

apt-get update > /dev/null 2>&1
apt-get install -y unzip > /dev/null 2>&1
cd ~
wget -q https://github.com/summerblue/laravel-ubuntu-init/archive/16.04.zip -O laravel-ubuntu-init.zip
unzip -q laravel-ubuntu-init.zip
rm -f laravel-ubuntu-init.zip
echo "下载完毕"
