set_multicycle_path -setup -start -from [get_clocks CLK600_1] -to [get_cells {{BC_PER1_reg[?]} {TDC1_CH?/C_PER_reg[?]} BC_STR11_reg TDC1_CH?/C_STR1_reg}] 2
set_multicycle_path -hold -start -from [get_clocks CLK600_1] -to [get_cells {{BC_PER1_reg[?]}  {TDC1_CH?/C_PER_reg[?]} BC_STR11_reg TDC1_CH?/C_STR1_reg}] 1
set_multicycle_path -setup -start -from [get_clocks CLK600_2] -to [get_cells {{BC_PER2_reg[?]} {TDC2_CH?/C_PER_reg[?]} BC_STR21_reg TDC2_CH?/C_STR1_reg}] 2
set_multicycle_path -hold -start -from [get_clocks CLK600_2] -to [get_cells {{BC_PER2_reg[?]}  {TDC2_CH?/C_PER_reg[?]} BC_STR21_reg TDC2_CH?/C_STR1_reg}] 1
set_multicycle_path -setup -start -from [get_clocks CLK600_3] -to [get_cells {{BC_PER3_reg[?]} {TDC3_CH?/C_PER_reg[?]} BC_STR31_reg TDC3_CH?/C_STR1_reg}] 2
set_multicycle_path -hold -start -from [get_clocks CLK600_3] -to [get_cells {{BC_PER3_reg[?]}  {TDC3_CH?/C_PER_reg[?]} BC_STR31_reg TDC3_CH?/C_STR1_reg}] 1

set_max_delay -datapath_only -from [get_clocks CLK320] -to [get_ports {TT* AT*}] 1.800

set_max_delay -datapath_only -from [get_clocks {TDCCLK1 CLK300_1}] -to [get_cells {TDC1_CH?/tdc_raw_i_reg[*]}] 3.000
set_max_delay -datapath_only -from [get_clocks {TDCCLK2 CLK300_2}] -to [get_cells {TDC2_CH?/tdc_raw_i_reg[*]}] 3.000
set_max_delay -datapath_only -from [get_clocks {TDCCLK3 CLK300_3}] -to [get_cells {TDC3_CH?/tdc_raw_i_reg[*]}] 3.000

set_max_delay -datapath_only -from [get_clocks -include_generated_clocks {TDCCLK1 CLK300_1}] -to [get_cells {{CHANNEL1?/CH_TIME1_reg[*]} CHANNEL1?/CH_t_trig1_reg CHANNEL1?/CH_trig_f_reg}] 3.800
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks {TDCCLK2 CLK300_2}] -to [get_cells {{CHANNEL2?/CH_TIME1_reg[*]} CHANNEL2?/CH_t_trig1_reg CHANNEL2?/CH_trig_f_reg}] 3.800
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks {TDCCLK3 CLK300_3}] -to [get_cells {{CHANNEL3?/CH_TIME1_reg[*]} CHANNEL3?/CH_t_trig1_reg CHANNEL3?/CH_trig_f_reg}] 3.800

set_max_delay -datapath_only -from [get_clocks -include_generated_clocks TDCCLK1] -to [get_cells CHANNEL1?/TDC_rdy320_0_reg] 1.000
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks TDCCLK2] -to [get_cells CHANNEL2?/TDC_rdy320_0_reg] 1.000
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks TDCCLK3] -to [get_cells CHANNEL3?/TDC_rdy320_0_reg] 1.000

set_max_delay -datapath_only -from [get_clocks {CLK300_? TX_CLK}] -to [get_pins TCM_req0_reg/D] 3.000

set_max_delay -datapath_only -from [get_ports {MCLK?_P IN??_P}] -to [get_cells {TDC?_CH?/PINCAPT/ISERDES_1 PINCAPT_*/ISERDES_1}] 2.000

set_max_delay -datapath_only -from [get_clocks TDCCLK1] -to [get_cells TDC1_CH?/rs300_0_reg] 5.000
set_max_delay -datapath_only -from [get_clocks TDCCLK2] -to [get_cells TDC2_CH?/rs300_0_reg] 5.000
set_max_delay -datapath_only -from [get_clocks TDCCLK3] -to [get_cells TDC3_CH?/rs300_0_reg] 5.000

set_max_delay -datapath_only -from [get_clocks *] -to [get_ports {*LA* LED* IRQ}] 15.000

set_input_delay -clock [get_clocks SPI] -clock_fall -min 5.000 [get_ports MOSI]
set_input_delay -clock [get_clocks SPI] -clock_fall -max 10.000 [get_ports MOSI]
set_input_delay -clock [get_clocks SPI] -clock_fall -min 5.000 [get_ports CS]
set_input_delay -clock [get_clocks SPI] -clock_fall -max 10.000 [get_ports CS]
set_output_delay -clock [get_clocks SPI] -min 0.000 [get_ports MISO]
set_output_delay -clock [get_clocks SPI] -max 10.000 [get_ports MISO]

set_input_delay -clock [get_clocks HSPI]  -min 5.000 [get_ports HSEL]
set_input_delay -clock [get_clocks HSPI]  -max 10.000 [get_ports HSEL]
set_output_delay -clock [get_clocks HSPI] -min 0.000 [get_ports HMISO]
set_output_delay -clock [get_clocks HSPI] -max 10.000 [get_ports HMISO]

set_max_delay -datapath_only -from [get_clocks CLK320] -to [get_ports EVNT] 6.000
set_max_delay -datapath_only -from [get_ports DI*] -to [get_clocks CLK320] 5.000
set_max_delay -datapath_only -from [get_ports STR*] -to [get_clocks CLK320] 2.500

set_false_path -from [get_ports RST]
set_false_path -from [get_cells {sreset_reg alm_rst0_reg} -include_replicated_objects]
set_false_path -to [get_pins all_locked_reg/D]

set_multicycle_path -setup -from [get_clocks CLK320] -through [get_cells CHANNEL??/Ampl_corr] 2
set_multicycle_path -hold -from [get_clocks CLK320] -through [get_cells CHANNEL??/Ampl_corr] 1

set_multicycle_path -setup -from [get_cells {CHANNEL??/CH_0_reg[*]}] -to [get_cells {{CHANNEL??/CH_R0_reg[*]} {CHANNEL??/CH_R1_reg[*]}}] 2
set_multicycle_path -hold -from [get_cells {CHANNEL??/CH_0_reg[*]}] -to [get_cells {{CHANNEL??/CH_R0_reg[*]} {CHANNEL??/CH_R1_reg[*]}}] 1

set_false_path -from [get_cells {{CH*_shift_reg[*]} {CH*_zero_reg[*]} {CH*_rc_reg[*]} {ampl_sat_reg[*]} {gate_time_high_reg[*]} {chans_ena_reg[*]}}] -to [get_clocks CLK320]
set_false_path -from [get_cells ipbus_control_reg_reg[*][*]]  

#set_max_delay  -datapath_only -from [get_clocks RXDataCLK] -to [get_pins IsRXData0_reg/D] 5.000
set_false_path -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/gbtBankDsgn/GBT_Status_O_reg[gbtRx_ErrorDet] FitGbtPrg/gbtBankDsgn/GBT_Status_O_reg[gbtRx_Ready] IsRXData0_reg}]



#set_max_delay -datapath_only -from [get_cells {GBT1/gbtBank_1/gbtRx_gen[1].gbtRx/rxGearbox/rxGearboxLatOpt_gen.rxGearboxLatOpt/*_reg[*]}] -to [get_pins {GBT1/gbtBank_1/gbtRx_gen[1].gbtRx/descrambler/*/*_reg[*]/D}] 16.000

## RX Phase Aligner
##-----------------
## Comment: The period of TX_FRAMECLK is 25ns but "TS_GBTTX_SCRAMBLER_TO_GEARBOX" is set to 16ns, providing 9ns for setup margin.
#set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/scrambler/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/txGearbox/*/D}] 16.000

## GBT RX:
##--------

## Comment: The period of RX_FRAMECLK is 25ns but "TS_GBTRX_GEARBOX_TO_DESCRAMBLER" is set to 20ns, providing 5ns for setup margin.
#set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/rxGearbox/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/descrambler/*/D}] 20.000

set_multicycle_path -setup -start -from [get_clocks RxWordCLK] -to [get_cells {FitGbtPrg/gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/*_O_reg
                                                                    FitGbtPrg/gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/RX_DATA_O_reg[*]
                                                                    FitGbtPrg/gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/feedbackRegister_reg[*]}] 3
set_multicycle_path -hold -start -from [get_clocks RxWordCLK] -to [get_cells {FitGbtPrg/gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/*_O_reg 
                                                                    FitGbtPrg/gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/RX_DATA_O_reg[*]
                                                                    FitGbtPrg/gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/feedbackRegister_reg[*]}] 2


#set_false_path -hold -from [get_clocks RXDataCLK] -to [get_pins FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D]
#set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_pins FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D] 1.000


# GBT readout
#####################################################################

#set_false_path -from [get_cells ipbus_control_reg_reg[*][*]]  -to [all_registers]

# Reset generator multipath -------------------------------------
#set_false_path -from [get_cells FitGbtPrg/Reset_Generator_comp/GenRes_DataClk_ff1_reg]  

#set_multicycle_path -setup -from [get_cells {FitGbtPrg/Data_Packager_comp/Event_Selector_comp/fromcru_dec_orbit_ff_reg[*]}] -to [get_cells  FitGbtPrg/Data_Packager_comp/Event_Selector_comp/is_sending_packet_ff_reg] 7
#set_multicycle_path -hold -end -from [get_cells {FitGbtPrg/Data_Packager_comp/Event_Selector_comp/fromcru_dec_orbit_ff_reg[*]}] -to [get_cells FitGbtPrg/Data_Packager_comp/Event_Selector_comp/is_sending_packet_ff_reg] 6

# RX Sync comp -------------------------------------
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_DATA_DATACLK_reg[*]}] 3.000
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_IS_DATA_DATACLK_reg*}] 3.000
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from00_reg] 2.000

set_false_path -from [get_clocks -include_generated_clocks MCLK1] -to [get_clocks RXDataCLK]


#set_multicycle_path -setup -start -from [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_DATA_DATACLK_ffsc_reg[*]}] -to [get_cells  {FitGbtPrg/RxData_ClkSync_comp/RX_DATA_DATACLK_ffdc_reg[*]}] 7
#set_multicycle_path -hold -from [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_DATA_DATACLK_ffsc_reg[*]}] -to [get_cells  {FitGbtPrg/RxData_ClkSync_comp/RX_DATA_DATACLK_ffdc_reg[*]}] 6

#set_multicycle_path -setup -start -from [get_cells {FitGbtPrg/DataClk_I_strobe_comp/count_ready_reg}] -to [get_cells  {FitGbtPrg/DataClk_I_strobe_comp/count_ready_dtclk_ff_reg}] 7
#set_multicycle_path -hold -from [get_cells {FitGbtPrg/DataClk_I_strobe_comp/count_ready_reg}] -to [get_cells  {FitGbtPrg/DataClk_I_strobe_comp/count_ready_dtclk_ff_reg}] 6

#set_multicycle_path -setup -start -from [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_IS_DATA_DATACLK_ffsc_reg}] -to [get_cells  {FitGbtPrg/RxData_ClkSync_comp/RX_IS_DATA_DATACLK_ffdc_reg}] 7
#set_multicycle_path -hold -from [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_IS_DATA_DATACLK_ffsc_reg}] -to [get_cells  {FitGbtPrg/RxData_ClkSync_comp/RX_IS_DATA_DATACLK_ffdc_reg}] 6


