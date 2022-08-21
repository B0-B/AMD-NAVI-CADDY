#!/bin/bash

function highlight () {
	printf "\n\t\033[1;33m$1\033[1;35m\n"; sleep 1
}

#!/bin/bash
if [[ -z $1 ]]; then

# -- globals --
declare dir="$HOME"
declare usr="$(whoami)"

highlight "Navi 12 (BC-160) Setup\n\n"

# -- show info -- 
highlight "install path: $dir\n\tcurrent user: $usr"


# -- configure grub --
highlight "Configure grub ..."
grubPath=/etc/default/grub # environment path for grub
sudo sed -i '10s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.ppfeaturemask=0xffffffff amdgpu.runpm=0"/' $grubPath &&
sudo update-grub # final reboot at the end of script


wait


# -- decide which OS to use & install drivers --
version=$(lsb_release -d | awk -F"\t" '{print $2}')
if [[ *"Ubuntu 18"* == $version ]];then
    highlight "OS $version found!"
	# -- check for driver install --
	if [ -d "$dir/driver" ]; then
		highlight "Driver directory was found at $dir/driver"
	else
		highlight "Installing drivers ..."
		cd $dir && mkdir driver && cd driver/ # create driver directory and tab into it
		wget https://drivers.amd.com/drivers/linux/amdgpu-pro-20.40-1147287-ubuntu-18.04.tar.xz --referer https://support.amd.com &&
		tar -Jxvf amdgpu-pro-20.40-1147287-ubuntu-18.04.tar.xz && 
		cd amdgpu-pro-20.40-1147287-ubuntu-18.04/ &&
		sudo ./amdgpu-install -y --no-dkms --opencl=pal --headless &&
		cd $dir/driver &&
		wget https://drivers.amd.com/drivers/linux/amdgpu-pro-21.20-1274019-ubuntu-18.04.tar.xz --referer https://support.amd.com &&
		tar -Jxvf amdgpu-pro-21.20-1274019-ubuntu-18.04.tar.xz &&
		cd amdgpu-pro-21.20-1274019-ubuntu-18.04/ &&
		sudo apt install ./amdgpu-dkms-firmware_5.11.5.26-1274019_all.deb ./amdgpu-dkms_5.11.5.26-1274019_all.deb -y &&
		cd $dir/driver &&
		sudo usermod -a -G video $usr && # set groups for ocl device recognition
		sudo usermod -a -G render $usr
	fi
elif [[ $version == *"Ubuntu 20"* ]];then
    highlight "OS $version found!"
	# -- check for driver install --
	if [ -d "$dir/driver" ]; then
		highlight "Driver directory was found at $dir/driver"
	else
		highlight "Installing drivers ..."
		cd $dir && mkdir driver && cd driver/ # create driver directory and tab into it
		wget https://drivers.amd.com/drivers/linux/amdgpu-pro-20.40-1147286-ubuntu-20.04.tar.xz --referer https://support.amd.com &&
		tar -Jxvf amdgpu-pro-20.40-1147286-ubuntu-20.04.tar.xz && 
		cd amdgpu-pro-20.40-1147286-ubuntu-20.04/ &&
		sudo ./amdgpu-install -y --no-dkms --opencl=pal --headless &&
		cd $dir/driver &&
		wget https://drivers.amd.com/drivers/linux/amdgpu-pro-21.20-1271047-ubuntu-20.04.tar.xz --referer https://support.amd.com &&
		tar -Jxvf amdgpu-pro-21.20-1271047-ubuntu-20.04.tar.xz &&
		cd amdgpu-pro-21.20-1271047-ubuntu-20.04/ &&
		sudo apt install ./amdgpu-dkms-firmware_5.11.5.26-1271047_all.deb ./amdgpu-dkms_5.11.5.26-1271047_all.deb -y &&
		cd $dir/driver &&
		sudo usermod -a -G video $usr && # set groups for ocl device recognition
		sudo usermod -a -G render $usr
	fi
else
    highlight "$version not supported!"
	return
fi


wait


# -- check for miner install --
if [ -d "$dir/miner" ]; then
	highlight "Miner directory was found at $dir/miner"
else
	highlight "Download Miner ..."
	mkdir $dir/miner && 
	cd $dir/miner &&
	wget https://github.com/todxx/teamredminer/releases/download/v0.8.5/teamredminer-v0.8.5-linux.tgz --referer https://github.com &&
	tar -xvf teamredminer-v0.8.5-linux.tgz &&
	cd $dir
fi


wait 


# -- add the overdrive and pci scripts to miner directory --
highlight "Inject $dir/miner/teamredminer-v0.8.5-linux/overdrive.sh ..."
echo '#!/bin/bash
# -- WALLET --
declare wallet="YOUR WALLET ADDRESS HERE"
declare workername="YOUR WORKER NAME HERE"
# These environment variables should be set for the driver to allow max mem allocation from the gpu(s).
function gpu () {
cd `dirname $0`
C=`./card_from_pci.sh $1`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1600" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "m 1 1000" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1600 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
}
gpu "03" & gpu "06" & gpu "09" & gpu "0c" & gpu "0f" & gpu "13" & gpu "16" & gpu "19" & gpu "1c" & gpu "1f" & gpu "22" & gpu "25" &&
wait
./teamredminer -a ethash -o stratum+tcp://eu1.ethermine.org:4444 -u $wallet.$workerName -p x --eth_config=B' >> $dir/miner/teamredminer-v0.8.5-linux/overdrive.sh &&
highlight "Inject $dir/miner/teamredminer-v0.8.5-linux/card_from_pci.sh ..."
echo '#!/bin/bash
cd `dirname $0`
if [ $# -ne 1 ]
then
    echo "Usage $0: <pci bus id>"
fi
BUSID=$1
P=`egrep PCI_SLOT_NAME /sys/class/drm/card*/device/uevent | egrep "$BUSID"`
if [ -z "$P" ]
then
    echo "Error: no device found for bus id $BUSID, exiting."
fi
DEVDIR=`dirname $P`
CARD=`echo $DEVDIR | cut -f 5 -d / | sed "s/[^0-9]//g"`
    echo $CARD
' >> $dir/miner/teamredminer-v0.8.5-linux/card_from_pci.sh
highlight "Inject $dir/miner/teamredminer-v0.8.5-linux/detatch.sh ..."
echo '#!/bin/bash
setsid -f bash overdrive.sh > /dev/null 2>&1
echo "Team Red Miner will start soon, you may close this shell now."' >> $dir/miner/teamredminer-v0.8.5-linux/detatch.sh
# and finally make both scripts executable
highlight "Make both .sh files executable ..."
sudo chmod +x $dir/miner/teamredminer-v0.8.5-linux/card_from_pci.sh
sudo chmod +x $dir/miner/teamredminer-v0.8.5-linux/overdrive.sh
sudo chmod +x $dir/miner/teamredminer-v0.8.5-linux/detatch.sh
highlight "done.\n"


wait


# -- install tools --
highlight "Install tools ..."
sudo apt install -y clinfo ssh &&
highlight "done.\n"


wait


# -- output ssh info --
highlight "SSH: Machine will be accessable under $usr@$(hostname)"

elif [[ $1 == "uninstall" ]]; then

    highlight "Uninstall ..."
    $HOME/driver/amdgpu-pro-20.40-1147286-ubuntu-20.04/amdgpu-install --uninstall -y
    rm -r $HOME/driver $HOME/miner
    rm $HOME/setup.sh $HOME/uninstall.sh

fi

# -- final reboot --
highlight "Reboot system now [recommended]? (y/n)"
read qreboot
if [ $qreboot == "y" ]; then
	for i in 5 4 3 2 1
	do
		printf "Reboot in $i seconds ...\r"; sleep 1
	done
	sudo reboot
fi

cd $HOME # back to home
echo "setup finished."
