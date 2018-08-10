#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/helpers.sh
source ${CURRENT_DIR}/../common/ansi.sh
source ${CURRENT_DIR}/../common/spinner.sh

[ $(id -u) != "0" ] && { ansi -n --bg-red "请用 root 账户执行本脚本"; exit 1; }

[ $# -lt 2 ] && { 
    ansi -n --green "命令格式：./add_nginx_site.sh {域名} {项目名}"
    ansi -n --green "多个域名用空格隔开，并且需在两端加上双引号，如：./add_nginx_site.sh \"leo108.com www.leo108.com\" leo108"
    exit 1
}

domains=$1
project=$2
project_dir="/var/www/${project}"

ansi -n --green "域名列表：${domains}"
ansi -n --green "项目名：${project}"
ansi -n --green "项目目录：${project_dir}"

read -r -p "是否确认？ [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        ansi -n --bg-red "用户取消"
        exit 1
        ;;
esac

cat ${CURRENT_DIR}/nginx_site_conf.tpl |
    sed "s/{{domains}}/${domains}/g" |
    sed "s/{{project}}/${project}/g" |
    sed "s/{{project_dir}}/${project_dir}/g" > /etc/nginx/sites-available/${project}.conf

ln -sf /etc/nginx/sites-available/${project}.conf /etc/nginx/sites-enabled/${project}.conf
