#!/bin/bash

# Get the grid/cms environment
. /opt/grid/3.1.41-0/external/etc/profile.d/grid-env.sh
. /opt/cms/cmsset_default.sh prod

# Setup X509 rules
chmod 600 $HOME/proxy.cert
export X509_USER_CERT=$HOME/proxy.cert


CONDOR_CONFIG=$HOME/Condor_glidein/glidein_config_amazon
_condor_CONDOR_HOST=`wget -q -O - http://instance-data.ec2.internal/latest/meta-data/public-ipv4`
_condor_GLIDEIN_HOST=`wget -q -O - http://instance-data.ec2.internal/latest/meta-data/public-ipv4`
_condor_LOCAL_DIR=/mnt/dumpspace/condor
if [ ! -d $_condor_LOCAL_DIR ]; then
	echo "Creating condor's LOCAL_DIR"
	mkdir -p $_condor_LOCAL_DIR
fi
if [ ! -d $_condor_LOCAL_DIR/log ]; then
	echo "Creating condor's log directory"
	mkdir $_condor_LOCAL_DIR/log
fi
if [ ! -d $_condor_LOCAL_DIR/execute ]; then
	echo "Creating condor's execute directory"
	mkdir $_condor_LOCAL_DIR/execute
fi
_condor_SBIN=$HOME/Condor_glidein/7.4.2-i686-pc-Linux-2.4
_condor_CONDOR_ADMIN=andrew.melo@gmail.com
_condor_NUM_CPUS=`cat /proc/cpuinfo | grep processor | wc -l`
_condor_UID_DOMAIN=`hostname`
_condor_FILESYSTEM_DOMAIN=`hostname`
_condor_MAIL=/bin/mail
_condor_STARTD_NOCLAIM_SHUTDOWN=9999999
# _condor_START_owner=`whoami`
_condor_CONDOR_IDS=`id -u`.`id -g`
command -v python2.6 > /dev/null
rc=$?
if [[ $rc != 0 ]]; then
	echo "Didn't find python2.6, adding some things to the path"
	PATH=$HOME/python-install/bin:$PATH
#	PYTHONHOME=$HOME/python-install/
fi
echo "FIXME: This script currently pulls all of the current environment"
echo "         variables into the userjobs' environment. May want to fix."
. /opt/cms/cmsset_default.sh
export WMAGENT_SITE_CONFIG_OVERRIDE=`pwd`/site-local-config.xml
_condor_hostname=`wget -q -O - http://instance-data.ec2.internal/latest/meta-data/public-hotname`
_condor_TCP_FORWARDING_HOST=`wget -q -O - http://instance-data.ec2.internal/latest/meta-data/public-ipv4`
_condor_PRIVATE_NETWORK_INTERFACE=`hostname -i`
_condor_PublicNetworkIpAddr=$_condor_TCP_FORWARDING_HOST
export _condor_COLLECTOR_HOST=$CMS_CERNVMPOOL

#
# - Do exports
#
export _condor_PublicNetworkIpAddr
export _condor_hostname
export _condor_PRIVATE_NETWORK_INTERFACE
export _condor_TCP_FORWARDING_HOST
export VO_CMS_SW_DIR=/opt/cms 
export SCRAM_ARCH
export PATH
export PYTHONHOME
export _condor_CONDOR_IDS
export CONDOR_CONFIG
export _condor_CONDOR_HOST
export _condor_GLIDEIN_HOST
export _condor_LOCAL_DIR
export _condor_SBIN
export _condor_CONDOR_ADMIN
export _condor_NUM_CPUS
export _condor_UID_DOMAIN
export _condor_FILESYSTEM_DOMAIN
export _condor_MAIL
export _condor_STARTD_NOCLAIM_SHUTDOWN
export CMS_PATH=/root
#
# - Give the environment
#
env

#
# - Start the slave
#
echo "Starting Condor Slave..."
$HOME/Condor_glidein/7.4.2-i686-pc-Linux-2.4/glidein_startup $@
	
