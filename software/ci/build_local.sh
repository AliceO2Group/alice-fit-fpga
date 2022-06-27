#!/bin/bash

#set -x

if [[ $# -eq 0 ]]; then
    echo "USEAGE: build_local.sh project_name [PM/TCM_v1/TCM_proto/FTM_PM/FTM_TCM]"
    exit 1
fi

PROJECT=$1

echo "##########################################################"
echo "################      building ${PROJECT}   ##################"
echo "##########################################################"

start_time=$(date +%s.%N)
sD=$(date  +%Y-%m-%d)
sT=$(date +%H:%M:%S)
echo "Start time: "  "$sD" "$sT"


source /opt/Xilinx/Vivado/2019.2/settings64.sh
cd firmware/FT0/${PROJECT} \
    && rm -rf ../bits/${PROJECT}* \
    && mkdir ../bits/${PROJECT}_logs \
    && rm -fr build \
    && rm -f *.log *.jou \
    && vivado -mode batch -source make.tcl \
    && cp $(find build -name "*.bit") ../bits/${PROJECT}.bit \
    && cp $(find build -name "*.bin") ../bits/${PROJECT}.bin \
    && cp $(find -name "*.log") ../bits/${PROJECT}_logs/ \
    && cp $(find -name "tight_setup_hold_pins.txt") ../bits/${PROJECT}_logs/
	
	
echo
echo
echo
echo "##########################################################"
echo "PROJECT NAME: ${PROJECT}"

end_time=$(date +%s.%N)
eD=$(date  +%Y-%m-%d)
eT=$(date +%H:%M:%S)
echo "Start time: "  "$sD" "$sT"
echo "Stop time: "  "$eD" "$eT"
dt=$(echo "$end_time - $start_time" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)
LC_NUMERIC=C printf "Runtime: %02d:%02d:%02.4f\n" $dh $dm $ds
echo
echo "parsing bits command line:"
echo "scp -r ./firmware/FT0/bits dfinogee@lxplus.cern.ch:/eos/user/d/dfinogee/alice-fit-fpga-artifacts/"
echo
echo "parsing repo command line"
echo "rsync -avz -delete --exclude={'build','nppBackup','__pycache__','.git','.Xil','bits','*.bak','*.jou','*.log','*.tmp','*.coe'} ../alice-fit-fpga dfinogee@lxplus.cern.ch:/eos/user/d/dfinogee/alice-fit-fpga-artifacts/"
echo
echo "Timing summary log:"
echo
grep -A10 "Design Timing Summary" ../bits/${PROJECT}_logs/impl_1_timing_summary.log
echo
