#!/bin/bash

CONDOR_CONFIG=$HOME/Condor_glidein/glidein_condor_config
_condor_CONDOR_HOST=localhost.localdomain
_condor_GLIDEIN_HOST=localhost.localdomain
_condor_LOCAL_DIR=$HOME/Condor_glidein/local/`hostname`
if [ ! -d $_condor_LOCAL_DIR ]; then
	echo "Creating condor's LOCAL_DIR"
	mkdir $HOME/Condor_glidein/local/
	mkdir $_condor_LOCAL_DIR
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
	PYTHONHOME=$HOME/python-install/
fi
echo "Starting Condor slave..."

# set the scram arch
SCRAM_ARCH=slc5_ia32_gcc434
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

echo "FIXME: This script currently pulls all of the current environment"
echo "         variables into the userjobs' environment. May want to fix."

export SCRAM_ARCH
export PATH
export PYTHONHOME
export _condor_CONDOR_IDS
export CONDOR_CONFIG
export _conor_CONDOR_HOST
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
~/Condor_glidein/7.4.2-i686-pc-Linux-2.4/glidein_startup $@
