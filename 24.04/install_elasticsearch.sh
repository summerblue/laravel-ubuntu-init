#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh

VERSION=$1
VERSION=${VERSION:-6}

[ $(id -u) != "0" ] && { ansi -n --bold --bg-red "请用 root 账户执行本脚本"; exit 1; }

# 设置 JAVA_HOME
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/java-8-openjdk-amd64/bin:/usr/lib/jvm/java-8-openjdk-amd64/db/bin:/usr/lib/jvm/java-8-openjdk-amd64/jre/bin"
export J2SDKDIR="/usr/lib/jvm/java-8-openjdk-amd64"
export J2REDIR="/usr/lib/jvm/java-8-openjdk-amd64/jre*"
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export DERBY_HOME="/usr/lib/jvm/java-8-openjdk-amd64/db"

function install_java {
    apt-get install -y openjdk-8-jre
}

function install_es {
    curl -sS https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/elasticstack/${VERSION}.x/apt stable main" > /etc/apt/sources.list.d/elastic-${VERSION}.x.list
    apt-get update
    apt-get install -y elasticsearch
    service elasticsearch start
}

function install_es_plugins {
    ESVersion=$(/usr/share/elasticsearch/bin/elasticsearch -V|awk -F',' '{print $1}'| awk '{print $2}')

    [[ -e /usr/share/elasticsearch/plugins/analysis-ik ]] || {
        /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${ESVersion}/elasticsearch-analysis-ik-${ESVersion}.zip
    }
    mkdir -p /etc/elasticsearch/analysis/
    touch /etc/elasticsearch/analysis/synonyms.txt

    service elasticsearch restart
}

call_function install_java "正在安装 JAVA" ${LOG_PATH}
call_function install_es "正在安装 Elasticsearch ${VERSION}" ${LOG_PATH}
call_function install_es_plugins "正在安装 Elasticsearch 插件" ${LOG_PATH}

ansi --green --bold -n "安装完毕"
