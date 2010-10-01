#!/bin/sh

git status
echo "WARNING YOU NEED TO MAKE SURE THAT YOU COMMITTED BEFORE DOING THIS"
echo "git commit -am \"commit message\""
rm sandbox.tar.gz
git archive --format=tar --prefix=Condor_glidein/ HEAD | gzip > sandbox.tar.gz
tar --concatenate --file=sandbox.tar.gz pythonbundle.tar.gz
scp sandbox.tar.gz meloam@vpac05.phy.vanderbilt.edu:/home/meloam/web/
