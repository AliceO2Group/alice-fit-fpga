#*****************************************************************************************
# Vivado (TM) v2018.1 (64-bit)
#
# make.tcl: Tcl script for re-creating and building the bitstream for the project 'fit'
#
# IP Build 2185939 on Wed Apr  4 20:55:05 MDT 2018
#
#*****************************************************************************************

set part "xc7k160tffg676-3"

source ../../tcl/fit.tcl

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set project_name "PM"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set project_name $::user_project_name
}

variable script_file
set script_file "make.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set project_name [lindex $::argv $i] }
      "--help"         { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/build"]"

if {[string equal [open_project -quiet "build/PM.xpr"] ""]} {
    set proj_create "yes"
    puts ${proj_create}
    puts ${project_name}
    create_project ${project_name} ./build -part $part
} else {
    set proj_create "no"
    puts ${proj_create}
}

puts "ok"
puts current_project
# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set_property \
    -dict [list \
	       "corecontainer.enable"  "1" \
	       "default_lib"           "xil_defaultlib" \
	       "ip_cache_permissions"  "read write" \
	       "ip_output_repo"        "$proj_dir/${project_name}.cache/ip" \
	       "part"                  $part \
	       "sim.ip.auto_export_scripts" "1" \
	       "simulator_language"    "Mixed" \
	       "source_mgmt_mode"      "DisplayOnly" \
	       "target_language"       "VHDL" \
	       "xpm_libraries"         "XPM_CDC XPM_MEMORY" \
	       "xsim.array_display_limit" "64"] \
    [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Import local files from the original project
set files [list \
 [file normalize "${origin_dir}/hdl/Channel.vhd" ]\
 [file normalize "${origin_dir}/hdl/TDCCHAN.vhd" ]\
 [file normalize "${origin_dir}/hdl/counters.vhd" ]\
 [file normalize "${origin_dir}/hdl/trigger.vhd" ]\
 [file normalize "${origin_dir}/hdl/pin_capt.vhd" ]\
 [file normalize "${origin_dir}/hdl/autophase.vhd" ]\
 [file normalize "${origin_dir}/hdl/Flash_prog.vhd" ]\
 [file normalize "${origin_dir}/hdl/fit.vhd" ]\
  [file normalize "${origin_dir}/hdl/hyst.vhd" ]\
   [file normalize "${origin_dir}/hdl/PM12_pkg.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_bank_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_banks_user_setup.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_bank_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/phaligner_mmcm_controller.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/rxframeclk_phalgnr/phaligner_phase_computing.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/rxframeclk_phalgnr/phaligner_phase_comparator.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/xlx_k7v7_phalgnr_std_mmcm.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/rxframeclk_phalgnr/gbt_rx_frameclk_phalgnr.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/gbt_bank_reset.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_21bit.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_polydiv.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_rsencode.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_intlver.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std_rdwrctrl.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_phasemon.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip.vhd" ]\
  [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/mgt/mgt_latopt_bitslipctrl.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_mgt_latopt.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/mgt/multi_gigabit_transceivers.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_wraddr.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_pattsearch.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_bscounter.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_rightshift.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner.vhd" ]\
  [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_latopt.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_deintlver.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_syndrom.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_lmbddet.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_errlcpoly.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_elpeval.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_chnsrch.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rs2errcor.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rsdec.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_21bit.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_status.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_bank.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_auto_phase_align.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_cpll_railing.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_gt.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_init.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_multi_gt.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_rx_startup_fsm.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_sync_block.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_sync_pulse.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_tx_manual_phase_align.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_tx_startup_fsm.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/gbt_tx/xlx_k7v7_gbt_tx_gearbox_std_dpram.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/GBT_TXRX5.vhd"] \
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/DataConverter_PM.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/ltu_rx_decoder.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/Reset_Generator.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/fit_gbt_boardPM_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/FIT_GBT_project.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/Module_Data_Gen_PM.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/cru_ltu_emu.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/TX_Data_Gen.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/Event_selector.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/fit_gbt_common_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/RXDataClkSync.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/CRU_packet_Builder.vhd" ]\
]

add_files -norecurse -fileset sources_1 $files

if {[string equal $proj_create "yes"]} {
    # Set 'sources_1' fileset object
    set obj [get_filesets sources_1]
    add_files -norecurse -fileset $obj $files
    set_property -name "file_type" -value "VHDL" -objects [get_files [list "*.vhd"]]
	
    fit::make_ipcores "${proj_dir}/generated"

    # the following is needed in order to have parallel IP synthesis and implementation runs
    set_property GENERATE_SYNTH_CHECKPOINT TRUE [get_files "*.xci"]
    
    # Set 'sources_1' fileset properties
    set_property \
	-dict [list \
		   "top"                     "PM"\
		   "edif_extra_search_paths" "D:/proj/PM/ipcore_dir"] \
	[get_filesets sources_1]

    # Create 'constrs_1' fileset (if not found)
    if {[string equal [get_filesets -quiet constrs_1] ""]} {
	create_fileset -constrset constrs_1
    }

    # Add/Import constrs file and set constrs file properties
    set constr_files [list \
			  [file normalize "$origin_dir/xdc/Timing.xdc"]\
			  [file normalize "$origin_dir/xdc/fit.xdc"]\
			  [file normalize "$origin_dir/xdc/ios.xdc"]\
			 ]
    add_files -fileset constrs_1 ${constr_files}

    set_property -name "file_type" -value "XDC" -objects [get_files -of_objects [get_filesets constrs_1] [list "*/xdc/*.xdc"]]

    set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*/xdc/Timing.xdc"]]
    set_property -name "used_in" -value "implementation" -objects $file_obj
    set_property -name "used_in_synthesis" -value "0" -objects $file_obj

    set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*/xdc/fit.xdc"]]
    set_property -name "processing_order" -value "EARLY" -objects $file_obj

    set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*/xdc/ios.xdc"]]
    set_property -name "processing_order" -value "NORMAL" -objects $file_obj
    
    # Set 'constrs_1' fileset properties
    set obj [get_filesets constrs_1]
    set_property -name "target_constrs_file" -value "[get_files *xdc/ios.xdc]" -objects $obj
}


#timing report strategy
config_webtalk -user off



# upgrade_ip [get_ips]
generate_target synthesis [get_ips] -force

foreach ip [get_ips] {
    puts $ip
    create_ip_run [get_files ${ip}.xci]
	set_property generate_synth_checkpoint false [get_files ${ip}.xci]
    generate_target all [get_files ${ip}.xci]}

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
    create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)






# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Import local files from the original project
set files [list \
 [file normalize "${origin_dir}/../../common/gbt-readout/sim/readout_simulation.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/sim/main_signals.wcfg" ]\
]
#set imported_files [import_files -fileset sim_1 $files]
add_files -norecurse -fileset sim_1 $files

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "testbench_readout" -objects $obj





# Create 'synth_1' run (if not found)
config_webtalk -user off

if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part $part -flow {Vivado Synthesis 2019} -strategy "Flow_PerfOptimized_high" -report_strategy {Timing Closure Reports} -constrset constrs_1
} else {
    set_property strategy "Flow_PerfOptimized_high" [get_runs synth_1]
    set_property flow "Vivado Synthesis 2019" [get_runs synth_1]
}


set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj

proc gen_report {name type steps runs} {
    if { [ string equal [get_report_configs -of_objects [get_runs ${runs}] ${name}] "" ] } {
	create_report_config -report_name ${name} -report_type ${type} -steps ${steps} -runs ${runs}
    }
    set obj [get_report_configs -of_objects [get_runs ${runs}] ${name}]
    if { $obj != "" } {
	set_property -name "is_enabled" -value "0" -objects $obj
    }
}
gen_report synth_1_synth_report_utilization_0 report_utilization:1.0 synth_design synth_1

set obj [get_runs synth_1]
set_property -name "part" -value ${part} -objects $obj
set_property -name "strategy" -value "Flow_PerfOptimized_high" -objects $obj
set_property -name "steps.synth_design.args.fanout_limit" -value "400" -objects $obj
set_property -name "steps.synth_design.args.fsm_extraction" -value "one_hot" -objects $obj
set_property -name "steps.synth_design.args.keep_equivalent_registers" -value "1" -objects $obj
set_property -name "steps.synth_design.args.resource_sharing" -value "off" -objects $obj
set_property -name "steps.synth_design.args.no_lc" -value "1" -objects $obj
set_property -name "steps.synth_design.args.shreg_min_size" -value "5" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part ${part} -flow {Vivado Synthesis 2019} -strategy "Performance_NetDelay_low" -report_strategy {Timing Closure Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Performance_NetDelay_low" [get_runs impl_1]
  set_property flow {Vivado Implementation 2019} [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj

gen_report impl_1_init_report_timing_summary_0 report_timing_summary:1.0 init_design impl_1
gen_report impl_1_opt_report_drc_0 report_drc:1.0 opt_design impl_1
gen_report impl_1_opt_report_timing_summary_0 report_timing_summary:1.0 opt_design impl_1
gen_report impl_1_power_opt_report_timing_summary_0 report_timing_summary:1.0 power_opt_design impl_1
gen_report impl_1_place_report_io_0 report_io:1.0 place_design impl_1
gen_report impl_1_place_report_utilization_0 report_utilization:1.0 place_design impl_1
gen_report impl_1_place_report_control_sets_0 report_control_sets:1.0 place_design impl_1
gen_report impl_1_place_report_incremental_reuse_0 report_incremental_reuse:1.0 place_design impl_1
gen_report impl_1_place_report_incremental_reuse_1 report_incremental_reuse:1.0 place_design impl_1
gen_report impl_1_place_report_timing_summary_0 report_timing_summary:1.0 place_design impl_1
gen_report impl_1_post_place_power_opt_report_timing_summary_0 report_timing_summary:1.0 post_place_power_opt_design impl_1
gen_report impl_1_phys_opt_report_timing_summary_0 report_timing_summary:1.0 phys_opt_design impl_1
gen_report impl_1_route_report_drc_0 report_drc:1.0 route_design impl_1
gen_report impl_1_route_report_methodology_0 report_methodology:1.0 route_design impl_1
gen_report impl_1_route_report_power_0 report_power:1.0 route_design impl_1
gen_report impl_1_route_report_route_status_0 report_route_status:1.0 route_design impl_1
gen_report impl_1_route_report_timing_summary_0 report_timing_summary:1.0 route_design impl_1
gen_report impl_1_route_report_incremental_reuse_0 report_incremental_reuse:1.0 route_design impl_1
gen_report impl_1_route_report_clock_utilization_0 report_clock_utilization:1.0 route_design impl_1
gen_report impl_1_route_report_bus_skew_0 report_bus_skew:1.1 route_design impl_1
gen_report impl_1_post_route_phys_opt_report_timing_summary_0 report_timing_summary:1.0 post_route_phys_opt_design impl_1
gen_report impl_1_post_route_phys_opt_report_bus_skew_0 report_bus_skew:1.1 post_route_phys_opt_design impl_1

set obj [get_runs impl_1]
set_property -name "part" -value ${part} -objects $obj
set_property -name "strategy" -value "Performance_NetDelay_low" -objects $obj
set_property -name "steps.opt_design.args.directive" -value "Explore" -objects $obj
set_property -name "steps.place_design.args.directive" -value "ExtraNetDelay_low" -objects $obj
set_property -name "steps.phys_opt_design.is_enabled" -value "1" -objects $obj
set_property -name "steps.phys_opt_design.args.directive" -value "AggressiveExplore" -objects $obj
set_property -name "steps.route_design.args.directive" -value "NoTimingRelaxation" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.bin_file" -value "1" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:${project_name}"

update_compile_order -fileset sources_1
reset_run -quiet synth_1
launch_runs impl_1 -to_step write_bitstream  -jobs 7
wait_on_run impl_1
