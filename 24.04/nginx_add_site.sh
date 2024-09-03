#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh

[ $(id -u) != "0" ] && { ansi -n --bold --bg-red "请用 root 账户执行本脚本"; exit 1; }

read -r -p "请输入项目名：" project

[[ $project =~ ^[a-zA-Z\0-9_\-\.]+$ ]] || {
    ansi -n --bold --bg-red "项目名包含非法字符"
    exit 1
}

read -r -p "请输入站点域名（多个域名用空格隔开）：" domains

project_dir="/var/www/${project}"

ansi -n --bold --green "域名列表：${domains}"
ansi -n --bold --green "项目名：${project}"
ansi -n --bold --green "项目目录：${project_dir}"

read -r -p "是否确认？ [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        ansi -n --bold --bg-red "用户取消"
        exit 1
        ;;
esac

cat ${CURRENT_DIR}/nginx_site_conf.tpl |
    sed "s|{{domains}}|${domains}|g" |
    sed "s|{{project}}|${project}|g" |
    sed "s|{{project_dir}}|${project_dir}|g" > /etc/nginx/sites-available/${project}.conf

ln -sf /etc/nginx/sites-available/${project}.conf /etc/nginx/sites-enabled/${project}.conf

ansi -n --bold --green "配置文件创建成功";

mkdir -p ${project_dir} && chown -R ${WWW_USER}.${WWW_USER_GROUP} ${project_dir}

systemctl restart nginx.service

ansi -n --bold --green "Nginx 重启成功";
