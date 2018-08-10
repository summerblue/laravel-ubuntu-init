#!/bin/bash

{ # this ensures the entire script is downloaded #

lsb_release -d | grep 'Ubuntu' >& /dev/null
[[ $? -ne 0 ]] && { echo "仅支持 Ubuntu 16.04 系统"; exit 1; }

DISTRO=$(lsb_release -c -s)
[[ ${DISTRO} -ne "xenial" ]] && { echo "仅支持 Ubuntu 16.04 系统"; exit 1; }

green="\e[1;32m"
nc="\e[0m"

echo -e "${green}===> 开始下载...${nc}"
cd $HOME
wget -q https://github.com/summerblue/laravel-ubuntu-init/archive/master.tar.gz -O laravel-ubuntu-init.tar.gz
rm -rf laravel-ubuntu-init
tar zxf laravel-ubuntu-init.tar.gz
mv laravel-ubuntu-init-master laravel-ubuntu-init
rm -f laravel-ubuntu-init.tar.gz
echo -e "${green}===> 下载完毕${nc}"
echo ""
echo -e "${green}安装脚本位于： ${HOME}/laravel-ubuntu-init${nc}"
cd - > /dev/null
} # this ensures the entire script is downloaded #
