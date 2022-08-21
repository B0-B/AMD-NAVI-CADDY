#!/usr/bin/env bash

#       AMD 2022
#       Navi 14 XTB (Gemini) Blockchain Mining Setup Script        
#       ---------------------------------------------------
#
#       Specify the mining parameters and run the script by 
#           ~ $ . setup.sh


# ======== Parameters ========
scriptname='Navi 14 XTB (Gemini) Blockchain Mining Setup'

usr=$(whoami)

# - paths
Root="$HOME"                                            # Root path (default is home directory)
driverpath="$Root/driver"                               # Sub directory of driver
minerpath="$Root/miner"                                 # Sub directory of miner

# - wallet
wallet="YOUR WALLET ADDRESS HERE"                       # wallet address has to match the algorithm
workername="YOUR WORKER NAME HERE"                      # provide a miner name (will be visible in the pool)

# - mining
algo="ethash"                                           # algorithm for first run, can be changed later
pool="stratum+tcp://eu1.ethermine.org:4444"             # Pool URL - Pattern: <Protocol>:<Pool Address>:<Port>
trm_version='0.10.2'                                    # Team Red Miner Version (https://github.com/todxx/teamredminer/releases)

# - driver (do not change)
package="amdgpu-install_21.50.50000-1_all.deb"
driver_url="https://repo.radeon.com/amdgpu-install/21.50/ubuntu/focal/$package"
# ============================


# Logger
function log () {  
    printf "\033[1;33m[Setup]\t$1\033[1;35m\n"; sleep 1
}

# output scriptname
log "\033[1;31mAMD\033[1;33m $scriptname"
sleep 2


# install option
if [ -z $1 ]; then

    # install general dependencies
    log "installing general dependencies ..."
    sudo apt-get update &&
    sudo apt install ssh -y &&
    log "Successful.\n"

    # create paths in home
    log "create install directories ..."
    mkdir $driverpath &&
    mkdir $minerpath &&
    log "Successful.\n"

    # download 21.50 driver
    log "downloading driver from $driver_url ..." &&
    cd $driverpath &&
    wget $driver_url &&
    log "Successful.\n"
    
    # installing driver
    log "Installing $package ..." &&
    sudo apt-get install ./$package -y &&
    sudo apt-get update &&
    /usr/bin/amdgpu-install -y --opencl=rocr,legacy --accept-eula &&
    log "Successful.\n"

    # user gorup rights
    log "Set user group rights ..."
    sudo usermod -a -G video $usr &&
    sudo usermod -a -G render $usr &&
    sudo apt autoremove --purge -y && sudo apt autoclean &&
    log "Successful.\n"

    # install team red miner
    log "Downloading Team Red Miner $trm_version to '$minerpath' ..."
    cd $minerpath && 
    wget https://github.com/todxx/teamredminer/releases/download/v$trm_version/teamredminer-v$trm_version-linux.tgz --referer https://github.com &&
    log "Unpackaging ..."
    tar -xvf teamredminer-v$trm_version-linux.tgz &&
    rm teamredminer-v$trm_version-linux.tgz &&
    log "Successful.\n"

    # inject overdrive.sh
    log "Build 'overdrive.sh' in '$minerpath' ..."
    cd "$minerpath/teamredminer-v$trm_version-linux" &&
    echo `declare wallet="YOUR WALLET ADDRESS HERE"\ndeclare workername="YOUR WORKER NAME HERE"\n./teamredminer -a $algo -o $pool -u $wallet.$workername -p x --eth_config=B` >> overdrive.sh &&
    sudo chmod +x overdrive.sh && # make it executable
    log "Successful.\n"

elif [ $1 == 'uninstall' ]; then

    log "Uninstalling $scriptname ..."
    sudo amdgpu-uninstall -y && sudo apt-get purge amdgpu-install && log 'uninstalled driver.' || log 'cannot uninstall driver.' &&
    rm -rf $driverpath $minerpath
    log "Successfully removed."

fi

# reboot option
log "Reboot system now [recommended]? (y/n)"
read q
if [ $q == "y" ]; then
    for i in 3 2 1
    do
        printf "Reboot in $i ...\r"; sleep 1
    done
    sudo reboot
fi

log "Finished setup."