<h1 align=center><strong>AMD</strong> NAVI CADDY 
<h3 align=center>GPU MINING SETUP LIBRARY [LINUX]</h3>

<br>



# Usage

To start the setup open a terminal and download-open the install menu

```bash
cd ~ && get https://b0-b.github.io/AMD-NAVI-CADDY/setup.sh && bash setup.sh
```

the menu will pop up, select an ID and hit ENTER

```bash
        AMD Navi Caddy Menu


        ID      GPU Setup
        ------------------------------------
        0       Navi 12 GLXLB [BC-160]
        1       Navi 10 XTB [TDC-120]
        ------------------------------------
        Please select a setup id from above: 1
        selected setup: Navi 10 XTB [TDC-120]
        download https://b0-b.github.io/AMD-NAVI-CADDY/lib/navi_10_xtb.sh and install ...
```

the installation will start accordingly.

Once the ID is known (will persist) the install can be triggered directly by passing the ID as line argument

```bash
cd ~ && get https://b0-b.github.io/AMD-NAVI-CADDY/setup.sh && bash setup.sh <id>
```




<br>

# Recommended Kernel & OS Prerequisites
| GPU Setup | Kernel | OS |
|---|---|---|
| Navi 10 XTB | 5.15 or earlier | Ubuntu 20.04.3 |
| Navi 12 (BC-160) |  5.11.27 or earlier | Ubuntu 20.04.2 |

It is important to mention <strong>not</strong> to upgrade the Kernel by `sudo apt upgrade`.

<br>


# Modify Overdrive Script

After any install the `overdrive.sh` will be generated in `~/miner/teamredminer-.../overdrive.sh` which serves as the start script.

## 1. Set Wallet and Worker

Edit the following lines 

```bash
...
declare wallet="YOUR WALLET ADDRESS HERE"
declare workername="YOUR WORKER NAME HERE"
...
```

and save with CTRL + x.

## 2. Overdrive Capability
Some setups utilize overdrive capability to get higher hash rates. 
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
