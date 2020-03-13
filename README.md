![PM_TCM](https://repository-images.githubusercontent.com/238522341/aca2c500-48cf-11ea-95b5-4a498a732d8e?dl=0)

----
# ALICE Fast Interaction Trigger (FIT) firmware repository

Authors: Dmitry.Serebryakov@cern.ch, Dmitry.Finogeev@cern.ch

----
## Setup

### Clone the Git repository

    git clone https://github.com/AliceO2Group/alice-fit-fpga.git

### Update to latest version

    git pull --recurse-submodules

----
### Set up Vivado 2018.1

    source /opt/Xilinx/Vivado/2018.1/settings64.sh

----
## Generate bitstreams

### FIT/FT0/PM

     cd alice-fit-fpga/firmware/FT0/PM
     vivado -mode batch -source make.tcl 

### FIT/FT0/TCM

     cd alice-fit-fpga/firmware/FT0/TCM
     vivado -mode batch -source make.tcl 

### FIT/FT0/FTM

     cd alice-fit-fpga/firmware/FT0/FTM
     vivado -mode batch -source make.tcl 

----
## After any change to IP cores

Open the TCL console in the Vivado window and type in the following commands:

    source ../../tcl/fit.tcl
    fit::update_ip_properties

Then git add/commit any new/changed files in the directory `ipcore_properties`

----
## After any change to IP cores and/or to VHDL source files

git add/commit any new/changed VHDL files

