#!/bin/bash

{ # this ensures the entire script is downloaded #

lsb_release -d | grep 'Ubuntu' >& /dev/null
[[ $? -ne 0 ]] && { echo "仅支持 Ubuntu 16.04 系统"; exit 1; }

DISTRO=$(lsb_release -c -s)
[[ ${DISTRO} -ne "xenial" ]] && { echo "仅支持 Ubuntu 16.04 系统"; exit 1; }

local green="\e[1;32m"
local nc="\e[0m"

echo -e "${green}===> 开始下载...${nc}"
apt-get update > /dev/null 2>&1
apt-get install -y unzip > /dev/null 2>&1
cd $HOME
wget -q https://github.com/summerblue/laravel-ubuntu-init/archive/16.04.zip -O laravel-ubuntu-init.zip
rm -rf laravel-ubuntu-init
unzip -q laravel-ubuntu-init.zip -d laravel-ubuntu-init
rm -f laravel-ubuntu-init.zip
echo -e "${green}===> 下载完毕${nc}"
echo ""
echo -e "${green}安装脚本位于${HOME}/laravel-ubuntu-init${nc}"
cd -
} # this ensures the entire script is downloaded #
