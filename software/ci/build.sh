#!/bin/bash

set -x

if [[ $# -eq 0 ]]; then
    echo "USEAGE: build.sh project_name"
    exit 1
fi

PROJECT=$1

echo "building ${PROJECT}"

source /opt/Xilinx/Vivado/2019.2/settings64.sh

cd firmware/FT0/${PROJECT} \
    && rm -fr build \
    && rm -f *.log *.jou \
    && vivado -mode batch -source make.tcl \
    && mv $(find build -name "*.bit") build/${PROJECT}.bit \
    && mv $(find build -name "*.bin") build/${PROJECT}.bin

## save the exit code
EC=$?

## always save all log files
tar cvf - $(find . -name "*.log") | gzip - > build/${PROJECT}_logs.tar.gz

exit ${EC}
