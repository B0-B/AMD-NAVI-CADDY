<h1 align=center><strong>AMD</strong> NAVI 1x MULTI GPU SETUP [LINUX]</h2>

# Prerequisites
Ubuntu 20.04.2 (Desktop LTS) and no updates (apt-get update) [TESTED]
Ubuntu 18.04 [NOT TESTED]

# Dependencies
- AMD 20.40 Driver
- Team Red Miner 0.8.5
- no-dkms

# Download
Open a terminal anywhere and type
```bash
~$ wget -O - https://b0-b.github.io/AMD-NAVI-1x-SETUP/pull.sh | bash 
```
and hit enter. The `setup.sh` and `uninstall.sh` will be downloaded in the home directory.

# Setup

### 1. Run setup
Go into your home directory and run the setup
```bash
~$ cd $HOME
~$ /bin/bash setup.sh
```
The script will ask for a password at the beginning and for a reboot when finished.
Please reboot your system.

### 2. Override Parameters
Go into the generated overdrive.sh script in the miner directory 

```bash
cd $HOME/miner/teamredminer-v0.8.5-linux/
```

When multiple GPUs are utilized on a single mainboard (MB), the MB dependend PCI IDs need to be determined to set MCLK and GFX voltages clocks correctly and allow maximum memory allocation (before mining workload).
To find these use the `card_from_pci.sh` script in the same directory, by trying HEX numbers starting from 0.
```bash
/bin/bash card_from_pci.sh "0"
0   # <-- If a 0 is returned a card was found at PCI slot 0
/bin/bash card_from_pci.sh "1"
0   # second card was found at slot 1
/bin/bash card_from_pci.sh "2"
ERROR ... # no card found at slot 2!
```


Once all cards are found please override the gpu call in overdrive.sh
```bash
...
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
gpu "03" & gpu "06" & ... # <-- override this line to gpu "0" & gpu "1" or any other PCI slots found
```

```bash
nano overdrive.sh
```
Last edit in line 4 the Wallet address
```bash
...
declare wallet="YOUR WALLET ADDRESS HERE"
...
```

and save with `CTRL + x`.

# Run
To start the mining workload with output (process is bound to the shell) type
```bash
/bin/bash overdrive.sh
```
and to start the process in the background (ssh shell can be closed then) run the detatched mode
```bash
/bin/bash detatch.sh
```
