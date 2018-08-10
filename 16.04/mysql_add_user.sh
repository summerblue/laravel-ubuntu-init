#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh

read -r -p "请输入 Mysql root 密码：" MYSQL_ROOT_PASSWORD

mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "quit" > /dev/null 2>&1 || {
    ansi -n --bg-red "密码不正确"
    exit 1
}

read -r -p "请输入要新建的用户名：" MYSQL_NORMAL_USER

MYSQL_NORMAL_USER_PASSWORD=`random_string`

read -r -p "是否创建同名数据库并赋予权限？[y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        CREATE_DB=1
        ;;
    *)
        CREATE_DB=0
        ;;
esac

mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "CREATE USER '${MYSQL_NORMAL_USER}'@'127.0.0.1' IDENTIFIED BY '${MYSQL_NORMAL_USER_PASSWORD}';" > /dev/null 2>&1

if [[ CREATE_DB -eq 1 ]]; then
    mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE ${MYSQL_NORMAL_USER};" > /dev/null 2>&1
    mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL ON ${MYSQL_NORMAL_USER}.* TO '${MYSQL_NORMAL_USER}'@'127.0.0.1' IDENTIFIED BY '${MYSQL_NORMAL_USER_PASSWORD}';" > /dev/null 2>&1
    mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL ON ${MYSQL_NORMAL_USER}.* TO '${MYSQL_NORMAL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_NORMAL_USER_PASSWORD}';" > /dev/null 2>&1
    mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
fi

ansi -n --green "创建成功";

ansi --green "用户名："; ansi -n --bg-yellow --black ${MYSQL_NORMAL_USER}
ansi --green "密码："; ansi -n --bg-yellow --black ${MYSQL_NORMAL_USER_PASSWORD}
