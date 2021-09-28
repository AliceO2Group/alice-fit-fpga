#!/bin/bash

set -x

if [[ $# -eq 0 ]]; then
    echo "USEAGE: build.sh project_name"
    exit 1
fi

PROJECT=$1

echo "building ${PROJECT}"

source /opt/Xilinx/Vivado/2019.2/settings64.sh

cd  firmware/FT0/${PROJECT} \
    && rm -rf ../bits/${PROJECT}* \
    && mkdir ../bits/${PROJECT}_logs \
    && rm -fr build \
    && rm -f *.log *.jou \
    && vivado -mode batch -source make.tcl \
    && mv $(find build -name "*.bit") /home/dfinogee/git/alice-fit-fpga/firmware/FT0/bits/${PROJECT}.bit \
    && mv $(find build -name "*.bin") /home/dfinogee/git/alice-fit-fpga/firmware/FT0/bits/${PROJECT}.bin \
    && mv $(find -name "*.log") /home/dfinogee/git/alice-fit-fpga/firmware/FT0/bits/${PROJECT}_logs/
