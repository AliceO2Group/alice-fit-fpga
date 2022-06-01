#!/bin/bash

set -x

if [[ $# -eq 0 ]]; then
    echo "USEAGE: build_local.sh project_name [PM/TCM_v1/TCM_proto/FTM_PM/FTM_TCM]"
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
    && cp $(find build -name "*.bit") ../bits/${PROJECT}.bit \
    && cp $(find build -name "*.bin") ../bits/${PROJECT}.bin \
    && cp $(find -name "*.log") ../bits/${PROJECT}_logs/
