#!/bin/sh

#list a content summary of a number of RPM packages

# USAGE: showrpm rpmfile1 rpmfile2 ...

# EXAMPLE: showrpm /cdrom/RedHat/RPMS/*.rpm

for rpmpackage in $*; do

if [ -r "$rpmpackage" ];then

echo "=============== $rpmpackage =============="

rpm -qi -p $rpmpackage

else

echo "ERROR: cannot read file $rpmpackage"

fi

done 
