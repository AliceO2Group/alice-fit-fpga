set_false_path -through [get_pins ipbus_module/clocks/nuke_i_reg/Q]

set_max_delay -datapath_only -from [get_clocks *] -to [get_ports {LA?[*] LAC* LED*}] 15.000

set_false_path -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtRx_ErrorDet_ff_reg FitGbtPrg/gbt_bank_gen.gbtBankDsgn/GBT_Status_O_reg[*] IsRXData0_reg}]

set_max_delay -from [get_cells las_o_reg] -to [get_clocks LCLK] 2.900

## GBT RX:
##--------

## Comment: The period of RX_FRAMECLK is 25ns but "TS_GBTRX_GEARBOX_TO_DESCRAMBLER" is set to 20ns, providing 5ns for setup margin.
#set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/rxGearbox/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/descrambler/*/D}] 20.000

set_multicycle_path -setup -start -from [get_clocks RxWordCLK] -to [get_cells {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/*_O_reg
                                                                    FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/RX_DATA_O_reg[*]
                                                                    FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/feedbackRegister_reg[*]}] 3
set_multicycle_path -hold -start -from [get_clocks RxWordCLK] -to [get_cells {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/*_O_reg 
                                                                    FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/RX_DATA_O_reg[*]
                                                                    FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/feedbackRegister_reg[*]}] 2

#set_false_path -hold -from [get_clocks RXDataCLK] -to [get_pins {FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D}]
#et_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_pins {FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D}] 1.000

set_max_delay -datapath_only -from [get_clocks CLKsys40] -to [get_pins readout_laser_out_ff0_reg/D] 3.000
set_max_delay -datapath_only -from [get_clocks MCLKA] -to [get_clocks CLKA320] 3.000

set_multicycle_path -setup -from [get_clocks CLKA320] -to [get_cells {{*/T_?_reg} *_str_reg gbt_wr_reg}] 2
set_multicycle_path -hold -from [get_clocks CLKA320] -to [get_cells {{*/T_?_reg} *_str_reg gbt_wr_reg}] 1

set_multicycle_path -setup -from [get_cells {{tcma/Ampl_o_reg[*]} {tcma/AmplI_o_reg[*]} {tcma/Nchan_A_reg[*]} {tcma/Time_o_reg[*]} {tcma/Avg_reg[*]} {AmplC_reg[*]} {Nchan_C_reg[*]} {TimeC_reg[*]} t_blk_reg}] -to [get_cells  {Rd_word_reg[*]}] 2
set_multicycle_path -hold -from [get_cells {{tcma/Ampl_o_reg[*]} {tcma/AmplI_o_reg[*]} {tcma/Nchan_A_reg[*]}  {tcma/Time_o_reg[*]} {tcma/Avg_reg[*]} {AmplC_reg[*]} {Nchan_C_reg[*]} {TimeC_reg[*]} t_blk_reg}] -to [get_cells {Rd_word_reg[*]}] 1

set_multicycle_path -setup -from [get_cells {tcma/NC_reg[?][?]}] -to [get_clocks CLKA320] 2
set_multicycle_path -hold -from [get_cells {tcma/NC_reg[?][?]}] -to [get_clocks CLKA320] 1
set_multicycle_path -setup -from [get_cells {tcmc/NC_reg[?][?]}] -to [get_clocks CLKC320] 2
set_multicycle_path -hold -from [get_cells {tcmc/NC_reg[?][?]}] -to [get_clocks CLKC320] 1


#set_multicycle_path -setup -from [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ BMEM.bram.* && NAME =~  "m_cr*/m0/*"}] -to [get_clocks CLKA320] 2
#set_multicycle_path -hold -from [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ BMEM.bram.* && NAME =~  "m_cr*/m0/*"}] -to [get_clocks CLKA320] 1

set_max_delay -datapath_only -from [get_clocks CLKC320] -to [get_clocks CLKA320] 3.000

set_false_path -from [get_ports RST]
set_false_path -from  [get_cells sreset_reg -include_replicated_objects]

# GBT readout
#####################################################################

# Reset generator multipath -------------------------------------
#set_false_path -from [get_cells FitGbtPrg/Reset_Generator_comp/GenRes_DataClk_ff*_reg]  -to [all_registers]

# RX Sync comp -------------------------------------
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_DATA_DATACLK_reg[*]}] 3.000
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_IS_DATA_DATACLK_reg*}] 3.000
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from00_reg] 2.000
set_property ASYNC_REG true [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from00_reg]
set_property ASYNC_REG true [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from01_reg]

set_false_path -from [get_clocks -include_generated_clocks MCLKA] -to [get_clocks RXDataCLK]

set_false_path -from [get_clocks RXDataCLK] -to [get_cells rout_buf_reg[*]]

