set_multicycle_path -setup -start -from [get_clocks CLK600_1] -to [get_cells {{BC_PER1_reg[?]} {TDC1_CH?/C_PER_reg[?]} {TDC1_CH?/C_STR1_reg} BC_STR11_reg}] 2
set_multicycle_path -hold -start -from [get_clocks CLK600_1] -to [get_cells {{BC_PER1_reg[?]}  {TDC1_CH?/C_PER_reg[?]} {TDC1_CH?/C_STR1_reg} BC_STR11_reg }] 1
set_multicycle_path -setup -start -from [get_clocks CLK600_2] -to [get_cells {{BC_PER2_reg[?]} {TDC2_CH?/C_PER_reg[?]} {TDC2_CH?/C_STR1_reg} BC_STR21_reg }] 2
set_multicycle_path -hold -start -from [get_clocks CLK600_2] -to [get_cells {{BC_PER2_reg[?]}  {TDC2_CH?/C_PER_reg[?]} {TDC2_CH?/C_STR1_reg} BC_STR21_reg }] 1
set_multicycle_path -setup -start -from [get_clocks CLK600_3] -to [get_cells {{BC_PER3_reg[?]} {TDC3_CH?/C_PER_reg[?]} {TDC3_CH?/C_STR1_reg} BC_STR31_reg }] 2
set_multicycle_path -hold -start -from [get_clocks CLK600_3] -to [get_cells {{BC_PER3_reg[?]}  {TDC3_CH?/C_PER_reg[?]} {TDC3_CH?/C_STR1_reg} BC_STR31_reg }] 1

set_max_delay -datapath_only -from [get_clocks CLK320] -to [get_ports {TT* AT*}] 1.800

#set_multicycle_path -setup -from [get_pins {af1/m0_reg[?]/C af1/ml_reg[?]/C}] -to [get_cells {af1/ml_reg[?]}] 2
#set_multicycle_path -hold  -from [get_pins {af1/m0_reg[?]/C af1/ml_reg[?]/C}] -to [get_cells {af1/ml_reg[?]}] 1
#set_multicycle_path -setup -from [get_pins {af2/m0_reg[?]/C af2/ml_reg[?]/C}] -to [get_cells {af2/ml_reg[?]}] 2
#set_multicycle_path -hold  -from [get_pins {af2/m0_reg[?]/C af2/ml_reg[?]/C}] -to [get_cells {af2/ml_reg[?]}] 1
#set_multicycle_path -setup -from [get_pins {af3/m0_reg[?]/C af3/ml_reg[?]/C}] -to [get_cells {af3/ml_reg[?]}] 2
#set_multicycle_path -hold  -from [get_pins {af3/m0_reg[?]/C af3/ml_reg[?]/C}] -to [get_cells {af3/ml_reg[?}}] 1


set_max_delay -datapath_only -from [get_clocks {TDCCLK1 CLK300_1}] -to [get_cells {TDC1_CH?/tdc_raw_i_reg[*]}] 3.000
set_max_delay -datapath_only -from [get_clocks {TDCCLK2 CLK300_2}] -to [get_cells {TDC2_CH?/tdc_raw_i_reg[*]}] 3.000
set_max_delay -datapath_only -from [get_clocks {TDCCLK3 CLK300_3}] -to [get_cells {TDC3_CH?/tdc_raw_i_reg[*]}] 3.000

set_max_delay -datapath_only -from [get_clocks -include_generated_clocks {TDCCLK1 CLK300_1}] -to [get_cells {{CHANNEL1?/CH_TIME1_reg[*]} CHANNEL1?/CH_t_trig1_reg CHANNEL1?/CH_trig_f_reg CHANNEL1?/ch_tc1_reg[?]}] 3.800
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks {TDCCLK2 CLK300_2}] -to [get_cells {{CHANNEL2?/CH_TIME1_reg[*]} CHANNEL2?/CH_t_trig1_reg CHANNEL2?/CH_trig_f_reg CHANNEL2?/ch_tc1_reg[?]}] 3.800
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks {TDCCLK3 CLK300_3}] -to [get_cells {{CHANNEL3?/CH_TIME1_reg[*]} CHANNEL3?/CH_t_trig1_reg CHANNEL3?/CH_trig_f_reg CHANNEL3?/ch_tc1_reg[?]}] 3.800

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


set_multicycle_path -setup -from [get_clocks TX_CLK] -to [get_cells {BC_cou_reg[*] Orbit_ID_reg[*] TR_to_reg[*]}] 2
set_multicycle_path -hold -end -from [get_clocks TX_CLK] -to [get_cells {BC_cou_reg[*] Orbit_ID_reg[*] TR_to_reg[*]}] 1

#set_multicycle_path -setup -from [get_cells {CHANNEL??/CH_0_reg[*]}] -to [get_cells {{CHANNEL??/CH_R0_reg[*]} {CHANNEL??/CH_R1_reg[*]}}] 2
#set_multicycle_path -hold -from [get_cells {CHANNEL??/CH_0_reg[*]}] -to [get_cells {{CHANNEL??/CH_R0_reg[*]} {CHANNEL??/CH_R1_reg[*]}}] 1

set_false_path -from [get_cells {{CH*_shift_reg[*]} {CH*_rc_reg[*]} {ampl_sat_reg[*]} {gate_time_high_reg[*]} {chans_ena_r_reg[*]}}] -to [get_clocks CLK320]
set_false_path -from [get_cells ipbus_control_reg_reg[*][*]]  

#set_max_delay  -datapath_only -from [get_clocks RXDataCLK] -to [get_pins IsRXData0_reg/D] 5.000
set_false_path -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtRx_ErrorDet_ff_reg FitGbtPrg/gbt_bank_gen.gbtBankDsgn/GBT_Status_O_reg[*] IsRXData0_reg}]
set_false_path -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtRx_ErrorDet_ff_reg FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtRx_ErrorDet_ff*}]
set_false_path -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtRx_ErrorDet_ff_reg FitGbtPrg/gbt_bank_gen.gbtBankDsgn/Rx_Ready_ff*}]



#set_max_delay -datapath_only -from [get_cells {GBT1/gbtBank_1/gbtRx_gen[1].gbtRx/rxGearbox/rxGearboxLatOpt_gen.rxGearboxLatOpt/*_reg[*]}] -to [get_pins {GBT1/gbtBank_1/gbtRx_gen[1].gbtRx/descrambler/*/*_reg[*]/D}] 16.000

## RX Phase Aligner
##-----------------
## Comment: The period of TX_FRAMECLK is 25ns but "TS_GBTTX_SCRAMBLER_TO_GEARBOX" is set to 16ns, providing 9ns for setup margin.
#set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/scrambler/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/txGearbox/*/D}] 16.000

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


#set_false_path -hold -from [get_clocks RXDataCLK] -to [get_pins FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D]
#set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_pins FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D] 1.000


# GBT readout
#####################################################################
# TOP
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins {gbt_global_status_reg[*]/D}]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins {gbt_global_status_reg[*]/D}]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins {rx_phase_status_reg[*]/D}]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins {rx_phase_status_reg[*]/D}]

# Reset_Generator ----------------------------------
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Reset_Generator_comp/reset_sclk_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Reset_Generator_comp/reset_sclk_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Reset_Generator_comp/DataClk_qff00_sysclk_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Reset_Generator_comp/DataClk_qff00_sysclk_reg/D]
set_false_path -from [get_clocks TX_CLK] -to [get_pins {FitGbtPrg/Reset_Generator_comp/Reset_SClk_O*/D}]
set_false_path -from [get_clocks TX_CLK] -to [get_pins {FitGbtPrg/Reset_Generator_comp/count_ready_reg*/D}]

# RXDATA_CLKSync ----------------------------------
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_DATA_sysclk_reg[*]}] 3.000
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_IS_DATA_sysclk_reg*}] 3.000
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from00_reg] 2.000

set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/RxData_ClkSync_comp/rx_error_reset_sclk_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/RxData_ClkSync_comp/rx_error_reset_sclk_reg/D]


# Module_Data_Gen ----------------------------------
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/using_generator_sc_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/using_generator_sc_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/event_orbit_sc_reg[*]/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/event_orbit_sc_reg[*]/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/event_bc_sc_reg[*]/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/event_bc_sc_reg[*]/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/event_rx_ph_err_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/event_rx_ph_err_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/event_rx_ph_reg[*]/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Module_Data_Gen_comp/event_rx_ph_reg[*]/D]

# Module_Data_Gen ----------------------------------
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/curr_orbit_sc_reg[*]/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/curr_orbit_sc_reg[*]/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/curr_bc_sc_reg[*]/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/curr_bc_sc_reg[*]/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/data_enabled_sc_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/data_enabled_sc_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/is_readout_sc_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/is_readout_sc_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/is_readout_ff3_sc_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/is_readout_ff3_sc_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/start_of_run_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/start_of_run_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/trigger_select_val_sc_reg[*]/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/trigger_select_val_sc_reg[*]/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/reset_dt_counters_sc_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/reset_dt_counters_sc_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/hb_rdh_response_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/hb_rdh_response_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/start_of_run_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/start_of_run_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/readout_bypass_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/readout_bypass_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/hb_reject_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/Event_Selector_comp/hb_reject_reg/D]

# bc_indicator ----------------------------------
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/bc_indicator_data_comp/reset_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/bc_indicator_data_comp/reset_reg/D]

# DataConverter ----------------------------------
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/DataConverter_comp/reset_drop_counters_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/DataConverter_comp/reset_drop_counters_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/DataConverter_comp/start_of_run_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/DataConverter_comp/start_of_run_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/DataConverter_comp/readout_bypass_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/DataConverter_comp/readout_bypass_reg/D]
set_multicycle_path 8 -setup -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/DataConverter_comp/data_enabled_sclk_reg/D]
set_multicycle_path 7 -hold -end -from [get_clocks TX_CLK] -to [get_pins  FitGbtPrg/DataConverter_comp/data_enabled_sclk_reg/D]










