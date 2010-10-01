#!/bin/bash
mkdir /tmp/Condor_glidein


CONDOR_CONFIG=$HOME/Condor_glidein/glidein_config_vanderbilt
_condor_CONDOR_HOST=localhost.localdomain
_condor_GLIDEIN_HOST=localhost.localdomain
_condor_LOCAL_DIR=/tmp/Condor_glidein/local/`hostname`/$$
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
TOTAL_CPUS=`cat /proc/cpuinfo | grep processor | wc -l`
#_condor_NUM_CPUS=`echo '$TOTAL_CPUS/2.5' | bc`
_condor_NUM_CPUS=1
_condor_UID_DOMAIN=`hostname`
_condor_FILESYSTEM_DOMAIN=`hostname`
_condor_MAIL=/bin/mail
_condor_STARTD_NOCLAIM_SHUTDOWN=9999999
# _condor_START_owner=`whoami`
_condor_CONDOR_IDS=`id -u`.`id -g`
MYHOST=`hostname`
_condor_MASTER_NAME="$MYHOST.$$"
_condor_STARTD_NAME="$MYHOST.$$"
PATH=$HOME/python-install/bin:$PATH

command -v python2.6 > /dev/null
rc=$?
if [[ $rc != 0 ]]; then
	echo "Didn't find python2.6, adding some things to the path"
	PATH=$HOME/python-install/bin:$PATH
	PYTHONHOME=$HOME/python-install/
fi
echo "Starting Condor slave..."
SCRAM_ARCH=slc5_ia32_gcc434
X509_USER_PROXY=/home/meloam/proxy.cert
# set the scram arch
if [ 'x$SCRAM_ARCH' = 'x' ]; then
	if [ `uname -m` = 'x86_64' ];then
		SCRAM_ARCH=slc5_amd64_gcc434
	else
		SCRAM_ARCH=slc5_ia32_gcc434
	fi
	echo "SCRAM_ARCH was autodetected: $SCRAM_ARCH"
else
	echo "SCRAM_ARCH is already set: $SCRAM_ARCH"
fi
cd
. setup_grid.sh
echo "FIXME: This script currently pulls all of the current environment"
echo "         variables into the userjobs' environment. May want to fix."
export _condor_MASTER_NAME
export _condor_STARTD_NAME
export X509_USER_PROXY
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
# export _condor_START_owner
exec ~/Condor_glidein/7.4.2-i686-pc-Linux-2.4/glidein_startup -f  "$@"
