#!/bin/bash
# These environment variables should be set to for the driver to allow max mem allocation from the gpu(s).
# GPU 0
cd `dirname $0`
C=`./card_from_pci.sh 03`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 1
cd `dirname $0`
C=`./card_from_pci.sh 06`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 2
cd `dirname $0`
C=`./card_from_pci.sh 09`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 3
cd `dirname $0`
C=`./card_from_pci.sh 0c`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 4
cd `dirname $0`
C=`./card_from_pci.sh 0f`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 5
cd `dirname $0`
C=`./card_from_pci.sh 13`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 6
cd `dirname $0`
C=`./card_from_pci.sh 16`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 7
cd `dirname $0`
C=`./card_from_pci.sh 19`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 8
cd `dirname $0`
C=`./card_from_pci.sh 1c`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 9
cd `dirname $0`
C=`./card_from_pci.sh 1f`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 10
cd `dirname $0`
C=`./card_from_pci.sh 22`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# GPU 11
cd `dirname $0`
C=`./card_from_pci.sh 25`
C=`echo $C | xargs`
echo "manual" > /sys/class/drm/card$C/device/power_dpm_force_performance_level
echo "s 1 1500" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo"m 1 900" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "vc 2 1500 925" > /sys/class/drm/card$C/device/pp_od_clk_voltage
echo "c" > /sys/class/drm/card$C/device/pp_od_clk_voltage
cat /sys/class/drm/card$C/device/pp_od_clk_voltage
# TRM miner (please add your wallet address!)
./teamredminer -a ethash -o stratum+tcp://eu1.ethermine.org:4444 -u Your_Wallet_Address.worker -p x