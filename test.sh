#!/bin/bash
version=$(lsb_release -d | awk -F"\t" '{print $2}')
if [[ *"Ubuntu 18"* == $version ]];then
    echo "$version found"
elif [[ $version == *"Ubuntu 20"* ]];then
    echo "$version found"
else
    echo "$version not supported!"
fi