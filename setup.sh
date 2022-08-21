#!/usr/bin/env bash

# Logger
function log () {  
    printf "\033[1;33m\t$1\033[1;35m\n"; sleep 1
}

log "\033[1;31mAMD\033[1;33m Navi Caddy Menu"

search_dir=/the/path/to/base/dir/
for entry in "$search_dir"/*
do
  echo "$entry"
done