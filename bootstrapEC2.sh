#!/bin/sh

chmod +x *.sh
./makePartitions.sh
conary update squid
rm /etc/squid/squid.conf
cp squid.conf /etc/squid/squid.conf
/etc/init.d/squid stop
/etc/init.d/squid start
./modifySiteLocalConfig.sh
./startcondor-amazon.sh
