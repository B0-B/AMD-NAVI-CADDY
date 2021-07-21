#!/bin/bash


function highlight () {
	printf "\n\t\033[1;33m$1\033[1;35m\n"; sleep 1
}


# -- globals --
declare dir="$HOME"
declare usr="$(whoami)"



# -- show info -- 
highlight "install path: $dir\n\tcurrent user: $usr"


# -- configure grub --
highlight "Configure grub ..."
grubPath=/etc/default/grub # environment path for grub
sudo sed -i '10s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.ppfeaturemask=0xffffffff amdgpu.runpm=0"/' $grubPath &&
sudo update-grub # final reboot at the end of script


wait


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


wait


# -- install tools --
highlight "Install tools ..."
sudo apt install -y clinfo ssh 


wait


# -- check for miner install --
if [ -d "$dir/miner" ]; then
	highlight "Miner directory was found at $dir/miner"
else
	highlight "Download Miner ..."
	mkdir $dir/miner && 
	cd $dir/miner &&
	wget https://github.com/todxx/teamredminer/releases/download/v0.8.3/teamredminer-v0.8.3-linux.tgz --referer https://github.com &&
	tar -xvf teamredminer-v0.8.3-linux.tgz &&
	cd $dir
fi


wait


# -- output ssh info --
ip=$(hostname -i)
highlight "SSH: Machine will be accessable under $usr@$ip"


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
