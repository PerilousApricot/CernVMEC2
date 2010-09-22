#!/bin/sh

export SCRAM_ARCH=slc5_amd64_gcc434
mkdir ~/cms-comp
cd ~/cms-comp
wget http://cmsrep.cern.ch/cmssw/comp/bootstrap.sh
sh ./bootstrap.sh  -path $PWD -repository comp setup
source ./$SCRAM_ARCH/external/apt/0.5.15lorg3.2-cmp/etc/profile.d/init.sh
apt-get update
apt-get -y install cms+wmcore-webtools+WMCORE_0_1_1_pre19

