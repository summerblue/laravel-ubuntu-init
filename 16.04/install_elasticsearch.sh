#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh

[ $(id -u) != "0" ] && { ansi -n --bold --bg-red "请用 root 账户执行本脚本"; exit 1; }

function install_java {
    apt-get install -y openjdk-8-jre
}

function install_es {
    curl -sS https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/elasticstack/6.x/apt stable main" > /etc/apt/sources.list.d/elastic-6.x.list
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
call_function install_es "正在安装 Elasticsearch" ${LOG_PATH}
call_function install_es_plugins "正在安装 Elasticsearch 插件" ${LOG_PATH}

ansi --green --bold -n "安装完毕"
