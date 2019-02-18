#!/bin/bash -euo pipefail

{ # this ensures the entire script is downloaded #

unsupported_system() { echo "仅支持 Ubuntu 16.04 系统"; exit 1; }

lsb_release -d | grep 'Ubuntu' >& /dev/null || unsupported_system

[[ "$(lsb_release -c -s)" == "xenial" ]] || unsupported_system

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

[ $(id -u) != "0" ] && {
    source ${HOME}/laravel-ubuntu-init/common/ansi.sh
    ansi -n --bold --bg-yellow --black "当前账户并非 root，请用 root 账户执行安装脚本（使用命令：sudo -H -s 切换为 root）"
} || {
    ./laravel-ubuntu-init/16.04/install.sh
}

cd - > /dev/null

} # this ensures the entire script is downloaded #
