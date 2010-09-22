#!/bin/sh
# Beginning of PBS batch script.
#PBS -M andrew.m.melo@vanderbilt.edu
# Status/Progress EMails sent to "my.address@vanderbilt.edu"
#PBS -m bae
# Email generated at b)eginning, a)bort, and e)nd of jobs
#PBS -l nodes=1:x86
# Nodes required (#nodes:#processors per node:CPU type)
#PBS -l mem=2000mb
# Total job memory required (specify how many megabytes)
#PBS -l pmem=2000mb
# Memory required per processor (specify how many megabytes)
#PBS -l walltime=08:00:00
# You must specify Wall Clock time (hh:mm:ss) [Maximum allowed 30 days = 720:00:00]
#PBS -o myjob.output
# Send job stdout to file "myjob.output"
#PBS -j oe

echo "hi"
cat $PBS_NODEFILE
cd
. ~/setup_grid.sh
cd /home/meloam/Condor_glidein
exec ./startcondor-frompbs.sh -r 474
