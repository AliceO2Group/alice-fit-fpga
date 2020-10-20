#!/bin/bash

PROJECTS=$@

echo building $PROJECTS

source /opt/Xilinx/Vivado/2019.2/settings64.sh

for p in $PROJECTS; do
    cd firmware/FT0/$p \
       && rm -fr build \
       && rm -f *.log *.jou \
       && vivado -mode batch -source make.tcl \
       && mv $(find build -name "*.bit") build/${p}.bit
    tar cvf - $(find . -name "*.log") | gzip - > build/${p}_logs.tar.gz
done
