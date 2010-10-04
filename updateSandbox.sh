#!/bin/sh

git status
echo "WARNING YOU NEED TO MAKE SURE THAT YOU COMMITTED BEFORE DOING THIS"
echo "git commit -am \"commit message\""
rm sandbox.tar
git archive --format=tar --prefix=Condor_glidein/ HEAD > sandbox.tar
tar --concatenate --file=sandbox.tar pythonbundle.tar
scp sandbox.tar meloam@vpac05.phy.vanderbilt.edu:/home/meloam/web/
