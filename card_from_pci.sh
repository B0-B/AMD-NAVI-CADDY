#!/bin/bash
cd `dirname $0`
if [ $# -ne 1 ]
then
    echo "Usage $0: <pci bus id>"
    exit 1
fi
BUSID=$1
P=`egrep PCI_SLOT_NAME /sys/class/drm/card*/device/uevent | egrep "$BUSID"`
if [ -z "$P" ]
then
    echo "Error: no device found for bus id $BUSID, exiting."
    exit 1
fi
DEVDIR=`dirname $P`
CARD=`echo $DEVDIR | cut -f 5 -d / | sed 's/[^0-9]//g'`
    echo $CARD
exit 0