#CLOCK ========================================================================

# Ethernet RefClk (125MHz)
create_clock -period 8.000 -name eth_refclk [get_ports eth_clk_p]


create_generated_clock -name decoupled_clk -source [get_pins ipbus_module/eth/decoupled_clk_reg/C] -divide_by 2 [get_pins ipbus_module/eth/decoupled_clk_reg/Q]

# Ethernet driven by Ethernet txoutclk (i.e. via transceiver)
create_generated_clock -name eth_clk_62_5 -source [get_pins ipbus_module/eth/mmcm/CLKIN1] [get_pins ipbus_module/eth/mmcm/CLKOUT1]
create_generated_clock -name eth_clk_125 -source [get_pins ipbus_module/eth/mmcm/CLKIN1] [get_pins ipbus_module/eth/mmcm/CLKOUT2]

# Clocks derived from MMCM driven by Ethernet RefClk directly (i.e. not via transceiver)
create_generated_clock -name clk_ipb -source [get_pins ipbus_module/clocks/mmcm/CLKIN1] [get_pins ipbus_module/clocks/mmcm/CLKOUT1]


set_false_path -through [get_pins ipbus_module/clocks/nuke_i_reg/Q]
set_false_path -through [get_pins ipbus_module/clocks/rst_reg/Q]

create_clock -period 5.000 -name USER_CLK_P -waveform {0.000 2.500} [get_ports USER_CLK_P]

create_clock -period 25.000 -name FMC_HPC_DATACLK [get_ports FMC_HPC_clk_A_p]
create_clock -period 25.000 -name CLK40_PM [get_ports CLKPM_P]

create_clock -period 5.000 -name FMC_HPC_REFCLK [get_ports FMC_HPC_clk_200_p]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets FMC_HPC_clk_200_p]



create_clock -period 8.333 -name RxWordCLK [get_pins {gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/RXOUTCLK}]
create_clock -period 8.333 -name TxWordCLK [get_pins {gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/TXOUTCLK}]

create_generated_clock -name RXDataCLK [get_pins gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name Data_clk_40 [get_pins CDMClkpllcomp/inst/plle2_adv_inst/CLKOUT0]
create_generated_clock -name SystemCLK_320 [get_pins CDMClkpllcomp/inst/plle2_adv_inst/CLKOUT1]



set_clock_groups -name ASYNC_CLOCKS -asynchronous -group [get_clocks -include_generated_clocks {RxWordCLK RXDataCLK}]\
												  -group [get_clocks -include_generated_clocks TxWordCLK]\ 
												  -group [get_clocks -include_generated_clocks eth_refclk]\
												  -group [get_clocks -include_generated_clocks ipbus_module/eth/phy/U0/transceiver_inst/gtwizard_inst/U0/gtwizard_i/gt0_GTWIZARD_i/gtxe2_i/TXOUTCLK]\ 
												  -group [get_clocks -include_generated_clocks ipbus_module/eth/phy/U0/transceiver_inst/gtwizard_inst/U0/gtwizard_i/gt0_GTWIZARD_i/gtxe2_i/RXOUTCLK]\ 
												  -group [get_clocks -include_generated_clocks {FMC_HPC_REFCLK FMC_HPC_DATACLK CLK40_PM}]

set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks eth_refclk] -group [get_clocks -include_generated_clocks FMC_HPC_DATACLK]


#================================================================================





#RESET ==========================================================================
set_false_path -from [get_cells {Reset_Generator_comp/GenRes_DataClk_ff*_reg}] -to [all_registers]
set_false_path -from [get_cells gbtBankDsgn/gbtBank_gbtBankRst/gbtResetRx_from_generalRstFsm_reg]
set_false_path -from [get_cells gbtBankDsgn/gbtBank_gbtBankRst/mgtResetRx_from_generalRstFsm_reg]
set_false_path -from [get_cells gbtBankDsgn/gbtBank_gbtBankRst/gbtResetTx_from_generalRstFsm_reg]
set_false_path -from [get_cells PLL_Reset_Generator_comp/out_reset_ff_reg] -to [all_registers]

#================================================================================




#DATA GEN =======================================================================
set_multicycle_path -setup -from [get_clocks Data_clk_40] -to [get_cells {FIT_TESTMODULE_core_comp/Module_Data_Gen_comp/n_words_in_packet_send_reg[?]}] 8
set_multicycle_path -hold -from [get_clocks Data_clk_40] -to [get_cells {FIT_TESTMODULE_core_comp/Module_Data_Gen_comp/n_words_in_packet_send_reg[?]}] 8

set_multicycle_path -setup -from [get_cells FIT_TESTMODULE_core_comp/CRU_ORBC_Gen_comp/bpattern_counter_reg[*]] -to [get_clocks SystemCLK_320] 8
set_multicycle_path -hold -from [get_cells FIT_TESTMODULE_core_comp/CRU_ORBC_Gen_comp/bpattern_counter_reg[*]] -to [get_clocks SystemCLK_320] 8

set_multicycle_path -setup -from [get_cells FIT_TESTMODULE_core_comp/CRU_ORBC_Gen_comp/single_trg_val_ff_reg[*]] -to [get_clocks SystemCLK_320] 8
set_multicycle_path -hold -from [get_cells FIT_TESTMODULE_core_comp/CRU_ORBC_Gen_comp/single_trg_val_ff_reg[*]] -to [get_clocks SystemCLK_320] 8
#================================================================================





#IPBUS DATA SENDER ==============================================================
set_max_delay -datapath_only -from [get_cells {FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/ipbus_status_reg_map_dc_reg[*][*]}] -to [get_cells {FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/ipbus_status_reg_ipbclk_reg[*][*]}] 10.000
set_max_delay -datapath_only -from [get_cells FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/ipbus_control_reg_reg[*][*]] -to [get_cells FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc*] 10.000

set_max_delay -datapath_only -from [get_cells ipbus_module/clocks/rst_ipb_reg] -to [get_cells {FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/ipbus_status_reg_map_dc_reg[*][*]}] 10.000
set_max_delay -datapath_only -from [get_cells ipbus_module/clocks/rst_ipb_reg] -to [get_cells FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc_reg*] 10.000

set_multicycle_path -setup -from [get_clocks SystemCLK_320] -through [get_cells FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc*] 8
set_multicycle_path -hold -from [get_clocks SystemCLK_320] -through [get_cells FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc*] 7

set_multicycle_path -setup -from [get_clocks Data_clk_40] -through [get_cells FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc*] 8
set_multicycle_path -hold -from [get_clocks Data_clk_40] -through [get_cells FIT_TESTMODULE_core_comp/FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc*] 7

set_multicycle_path -setup -from [get_cells {FIT_TESTMODULE_core_comp/CRU_ORBC_Gen_comp/BC_counter_datagen_comp/ORBC_ID_COUNT_ff_reg[*]}] -to [get_clocks CLK320_MMCM320_PH] 7
set_multicycle_path -hold -end -from [get_cells {FIT_TESTMODULE_core_comp/CRU_ORBC_Gen_comp/BC_counter_datagen_comp/ORBC_ID_COUNT_ff_reg[*]}] -to [get_clocks CLK320_MMCM320_PH] 6
#================================================================================



# GBT ===========================================================================
create_pblock sfpQuad_area
resize_pblock [get_pblocks sfpQuad_area] -add {CLOCKREGION_X1Y5:CLOCKREGION_X1Y5}
#add_cells_to_pblock [get_pblocks sfpQuad_area] [get_cells -quiet [list genRst]]


#used in exmpl ds; generate frame clk
#set_property LOC PLLE2_ADV_X0Y6 [get_cells txPll/inst/plle2_adv_inst]

## Comment: The period of TX_FRAMECLK is 25ns but "TS_GBTTX_SCRAMBLER_TO_GEARBOX" is set to 16ns, providing 9ns for setup margin.
set_false_path -hold -from [get_clocks RXDataCLK] -to [get_pins {gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D}]
set_max_delay -from [get_clocks RXDataCLK] -to [get_pins {gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D}] 1.000

## Comment: The period of TX_FRAMECLK is 25ns but "TS_GBTTX_SCRAMBLER_TO_GEARBOX" is set to 16ns, providing 9ns for setup margin.
set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/scrambler/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/txGearbox/*/D}] 16.000

## Comment: The period of RX_FRAMECLK is 25ns but "TS_GBTRX_GEARBOX_TO_DESCRAMBLER" is set to 20ns, providing 5ns for setup margin.
set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/rxGearbox/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/descrambler/*/D}] 20.000


## Comment: The period of RX_FRAMECLK is 25ns but "TS_GBTRX_GEARBOX_TO_DESCRAMBLER" is set to 20ns, providing 5ns for setup margin.
set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/rxGearbox/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/descrambler/*/D}] 20.000

set_property LOC MMCME2_ADV_X0Y6 [get_cells gbtBankDsgn/*/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets gbtBankDsgn/*/latOpt_phalgnr_gen.mmcm_inst/pll/inst/clk_out1_xlx_k7v7_gbt_rx_frameclk_phalgnr_mmcm]
#================================================================================



set_property IOB TRUE [get_cells  Laser_Signal_out_reg]


# HDMI ============================================================================
set_property IOB TRUE [get_cells -hierarchical {TDi_reg[?]}]
set_property IOB TRUE [get_cells {PM_T??_reg}]
set_property ASYNC_REG TRUE [get_cells -hierarchical {rd_lock0_reg rd_lock1_reg}]

set_property ASYNC_REG TRUE [get_cells {PM_req0_reg PM_req1_reg}]
set_property ASYNC_REG TRUE [get_cells {rq_irq0_reg rq_irq1_reg}]

set_max_delay -datapath_only -from [get_clocks *] -to [get_ports {{LA[*]} GPIO_LED_*}] 15.000

set_false_path -from [get_cells -hierarchical srst_reg]

set_property BEL MMCME2_ADV [get_cells HDMI0/PLL1/inst/mmcm_adv_inst]
set_property LOC MMCME2_ADV_X0Y1 [get_cells HDMI0/PLL1/inst/mmcm_adv_inst]
#================================================================================

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets pm_sck]
create_clock -period 64.000 -name PM_sck [get_ports PM_SPI_SCK]















