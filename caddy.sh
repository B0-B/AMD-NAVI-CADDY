#!/usr/bin/env bash

# Logger
function log () {  
    printf "\033[1;33m\t$1\033[1;35m\n"; sleep 1
}

# for every corresponding setup index there is a reference url at same index 
declare setups=(
    "Navi 12 GLXLB [BC-160]"
    "Navi 10 XTB [TDC-120]"
    "Navi 14 XTB [TDC-160]"
)
declare reference=(
    "navi_12_bc-160.sh"
    "navi_10_xtb.sh"
    "navi_14_xtb.sh"
)


# selection
if [[ -z $1 ]];then

    # welcome
    log "\033[1;31mAMD\033[1;33m Navi Caddy Menu\n\n"

    # display setup options
    log "ID\tGPU Setup\n\t------------------------------------"
    id=0;
    for setup in "${setups[@]}";
    do
        printf "\t$id\t$setup\n"
        id=$((id+1))
    done
    log "------------------------------------"

    printf "Please select a setup id from above: "
    read selection
else
    selection=$1
fi
log "selected setup: ${setups[$selection]}"
declare url="https://b0-b.github.io/AMD-NAVI-CADDY/lib/${reference[$selection]}"

# download the setup to home directory and start setup
log "download $url and install ..."
cd ~ && wget $url && bash ${reference[$selection]}