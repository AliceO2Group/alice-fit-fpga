![PM_TCM](https://github.com/dfinogee/alice-fit-fpga/blob/devel/photo/FT0_front.jpg?raw=true)

----
# ALICE Fast Interaction Trigger (FIT) firmware repository

Authors: Dmitry.Serebryakov@cern.ch, Dmitry.Finogeev@cern.ch

----
## Setup

### Clone the Git repository

    git clone https://github.com/AliceO2Group/alice-fit-fpga.git
    git pull --recurse-submodules

----
## Projects compilation
'\<projec\>' = PM/TCM_v1/TCM_proto/FTM_PM/FTM_TCM

### Vivado tcl mode (linux)

     cd alice-fit-fpga/firmware/FT0/<projec>
     vivado -mode batch -source make.tcl 

### Macro (linux)

Macro will compile project and copy bit + bin + logs files into firmware/FT0/bits/

     cd alice-fit-fpga/
     ./software/ci/build_local.sh <project>

### Vivado GUI (win/linux)

run vivado v2019.2.1/v2020.1
	
	(linux)
	source /opt/Xilinx/Vivado/2019.2/settings64.sh
	vivado
	
open tcl console and change directory to the project

	(in tcl console)
	cd /<path>/alice-fit-fpga/firmware/FT0/<projec>
  
remove build directory (if exist) and run compilation

	(in tcl console)
	source ./make.tcl


### Export IP cores to `ipcore_properties`

Open the TCL console in the Vivado window and type in the following commands:

    source ../../tcl/fit.tcl
    fit::update_ip_properties


