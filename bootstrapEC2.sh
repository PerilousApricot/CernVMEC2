#!/bin/sh
export HOME=/root/
chmod +x *.sh
useradd condor
echo 'cd /root/Condor_glidein' >> /etc/rc.local
echo './makePartitions.sh' >> /etc/rc.local 
echo 'conary update squid' >> /etc/rc.local 
echo 'rm /etc/squid/squid.conf' >> /etc/rc.local 
echo 'cp squid.conf /etc/squid/squid.conf' >> /etc/rc.local 
echo 'chown -R squid:squid /mnt/dumpspace/squid' >> /etc/rc.local 
echo 'olddir=`pwd`' >> /etc/rc.local 
echo 'cd /mnt/dumpspace/squid' >> /etc/rc.local
echo 'chmod 777 /mnt/dumpspace' >> /etc/rc.local
echo 'chmod 777 /mnt/dumpspace/condor' >> /etc/rc.local
echo 'mkdir /mnt/dumpspace/condor/execute' >> /etc/rc.local
echo 'chmod 777 /mnt/dumpspace/condor/execute' >> /etc/rc.local
echo 'squid -z' >> /etc/rc.local 
echo 'cd /root/Condor_glidein' >> /etc/rc.local 
echo '/etc/init.d/squid stop' >> /etc/rc.local 
echo '/etc/init.d/squid start' >> /etc/rc.local 
env | awk '/.*/ {print "export " $0}' >> /etc/rc.local

echo './modifySiteLocalConfig.sh' >> /etc/rc.local 
echo '#none' >> /etc/rc.local
echo './startcondor-amazon.sh' >> /etc/rc.local
