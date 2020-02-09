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

set_max_delay -datapath_only -from [get_clocks -include_generated_clocks CLK300_1] -to [get_cells CHANNEL1?/FEV_0_reg] 1.500
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks CLK300_2] -to [get_cells CHANNEL2?/FEV_0_reg] 1.500
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks CLK300_3] -to [get_cells CHANNEL3?/FEV_0_reg] 1.500

set_max_delay -datapath_only -from [get_clocks -include_generated_clocks TDCCLK1] -to [get_cells CHANNEL1?/TDC_rdy320_0_reg] 1.000
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks TDCCLK2] -to [get_cells CHANNEL2?/TDC_rdy320_0_reg] 1.000
set_max_delay -datapath_only -from [get_clocks -include_generated_clocks TDCCLK3] -to [get_cells CHANNEL3?/TDC_rdy320_0_reg] 1.000

set_max_delay -datapath_only -from [get_ports {MCLK?_P IN??_P}] -to [get_cells {TDC?_CH?/PINCAPT/ISERDES_1 PINCAPT_*/ISERDES_1}] 2.000

set_max_delay -datapath_only -from [get_clocks TDCCLK1] -to [get_cells TDC1_CH?/rs300_0_reg] 5.000
set_max_delay -datapath_only -from [get_clocks TDCCLK2] -to [get_cells TDC2_CH?/rs300_0_reg] 5.000
set_max_delay -datapath_only -from [get_clocks TDCCLK3] -to [get_cells TDC3_CH?/rs300_0_reg] 5.000

set_max_delay -datapath_only -from [get_ports CS] -to [get_ports MISO] 10.000

set_max_delay -datapath_only -from [get_clocks *] -to [get_ports {*LA* LED* IRQ}] 15.000

set_max_delay -datapath_only -from [get_clocks CLK320] -to [get_ports EVNT] 6.000
set_max_delay -datapath_only -from [get_ports DI*] -to [get_clocks CLK320] 5.000
set_max_delay -datapath_only -from [get_ports STR*] -to [get_clocks CLK320] 2.500
set_false_path -from [get_ports RST]

set_multicycle_path -setup -from [get_clocks CLK320] -to [get_cells CHANNEL??/Ampl_corr] 2
set_multicycle_path -hold -from [get_clocks CLK320] -to [get_cells CHANNEL??/Ampl_corr] 1

set_multicycle_path -setup -from [get_cells {CHANNEL??/CH_0_reg[*]}] -to [get_cells {{CHANNEL??/CH_R0_reg[*]} {CHANNEL??/CH_R1_reg[*]}}] 2
set_multicycle_path -hold -from [get_cells {CHANNEL??/CH_0_reg[*]}] -to [get_cells {{CHANNEL??/CH_R0_reg[*]} {CHANNEL??/CH_R1_reg[*]}}] 1

set_false_path -from [get_cells {{CH*_shift_reg[*]} {CH*_zero_reg[*]} {CH*_rc_reg[*]} {ampl_sat_reg[*]} {gate_time_high_reg[*]} {chans_ena_reg[*]} {ipbus_control_reg_reg[*][*]}}] -to [get_clocks CLK320]
set_false_path -from [get_cells sreset_reg]

set_max_delay -from [get_clocks RXDataCLK] -to [get_pins IsRXData0_reg/D] 5.000



#set_max_delay -datapath_only -from [get_cells {GBT1/gbtBank_1/gbtRx_gen[1].gbtRx/rxGearbox/rxGearboxLatOpt_gen.rxGearboxLatOpt/*_reg[*]}] -to [get_pins {GBT1/gbtBank_1/gbtRx_gen[1].gbtRx/descrambler/*/*_reg[*]/D}] 16.000

## RX Phase Aligner
##-----------------
## Comment: The period of TX_FRAMECLK is 25ns but "TS_GBTTX_SCRAMBLER_TO_GEARBOX" is set to 16ns, providing 9ns for setup margin.
set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/scrambler/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/txGearbox/*/D}] 16.000

## GBT RX:
##--------

## Comment: The period of RX_FRAMECLK is 25ns but "TS_GBTRX_GEARBOX_TO_DESCRAMBLER" is set to 20ns, providing 5ns for setup margin.
set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/rxGearbox/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/descrambler/*/D}] 20.000



set_false_path -hold -from [get_clocks RXDataCLK] -to [get_pins FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D]
set_max_delay -from [get_clocks RXDataCLK] -to [get_pins FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D] 1.000


# GBT readout
#####################################################################

# Reset generator multipath -------------------------------------
set_false_path -from [get_cells FitGbtPrg/Reset_Generator_comp/GenRes_DataClk_ff*_reg]  -to [all_registers]
set_false_path -from [get_cells FitGbtPrg/gbtBankDsgn/gbtBank_gbtBankRst/gbtResetRx_from_generalRstFsm_reg]
set_false_path -from [get_cells FitGbtPrg/gbtBankDsgn/gbtBank_gbtBankRst/mgtResetRx_from_generalRstFsm_reg]
set_false_path -from [get_cells FitGbtPrg/gbtBankDsgn/gbtBank_gbtBankRst/gbtResetTx_from_generalRstFsm_reg]

# RX Sync comp -------------------------------------
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_DATA_DATACLK_ffsc_reg[*]}] 3.000
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/RxData_ClkSync_comp/RX_IS_DATA_DATACLK_ffsc_reg*}] 3.000
set_max_delay -datapath_only -from [get_clocks RXDataCLK] -to [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from_ff00_reg] 1.000

set_property ASYNC_REG true [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from_ff00_reg]
set_property ASYNC_REG true [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from_ff01_reg]






