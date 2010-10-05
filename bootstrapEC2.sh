#!/bin/sh
export HOME=/root/
chmod +x *.sh
./makePartitions.sh
conary update squid
rm /etc/squid/squid.conf
cp squid.conf /etc/squid/squid.conf
chown -R squid:squid squid
olddir=`pwd`
cd /mnt/dumpspace/squid
squid -z
cd $olddir
/etc/init.d/squid stop
/etc/init.d/squid start
./modifySiteLocalConfig.sh
./startcondor-amazon.sh &
