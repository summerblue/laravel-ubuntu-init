#!/bin/bash

random_string(){
    length=${1:-32}
    echo `cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${length} | head -n 1`
}
