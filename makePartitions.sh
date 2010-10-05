#!/bin/sh
fdisk /dev/sdb < fdiskscript.stdin
fdisk /dev/sdc < fdiskscript.stdin
pvcreate /dev/sdb2 /dev/sdc2
vgcreate dumpspace /dev/sdb2 /dev/sdc2
lvcreate -i 2 -ndumpvolume -L400G dumpspace
mkfs.ext3 /dev/dumpspace/dumpvolume
mkdir /mnt/dumpspace
mount -t ext3 /dev/dumpspace/dumpvolume /mnt/dumpspace
mkdir /mnt/dumpspace/squid
mkdir /mnt/dumpspace/condor
