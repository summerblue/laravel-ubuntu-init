#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/helpers.sh
source ${CURRENT_DIR}/ansi.sh
source ${CURRENT_DIR}/spinner.sh

export LOG_PATH=/var/log/laravel-ubuntu-init.log
export WWW_USER="www-data"
export WWW_USER_GROUP="www-data"
