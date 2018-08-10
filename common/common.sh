#!/bin/bash

COMMON_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${COMMON_DIR}/helpers.sh
source ${COMMON_DIR}/ansi.sh
source ${COMMON_DIR}/spinner.sh

export LOG_PATH=/var/log/laravel-ubuntu-init.log
export WWW_USER="www-data"
export WWW_USER_GROUP="www-data"
