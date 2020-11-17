#CLOCK ========================================================================

# Ethernet RefClk (125MHz)
create_clock -period 8.000 -name eth_refclk [get_ports eth_clk_p]


# Ethernet driven by Ethernet txoutclk (i.e. via transceiver)
create_generated_clock -name eth_clk_62_5 -source [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKIN1] [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name eth_clk_125 -source [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKIN1] [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKOUT1]

# Clocks derived from MMCM driven by Ethernet RefClk directly (i.e. not via transceiver)
create_generated_clock -name clk_ipb -source [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKIN1] [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKOUT0]
create_generated_clock -name free_clk -source [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKIN1] [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKOUT1]
create_generated_clock -name dly_clk -source [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKIN1] [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKOUT2]


set_false_path -through [get_pins ipbus_module/clocks/nuke_i_reg/Q]


create_clock -period 5.000 -name USER_CLK_P -waveform {0.000 2.500} [get_ports USER_CLK_P]

create_clock -period 25.000 -name FMC_HPC_DATACLK [get_ports FMC_HPC_clk_A_p]
create_clock -period 25.000 -name CLK40_PM [get_ports CLKPM_P]

create_clock -period 5.000 -name FMC_HPC_REFCLK [get_ports FMC_HPC_clk_200_p]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets FMC_HPC_clk_200_p]



create_clock -period 8.333 -name RxWordCLK [get_pins {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/RXOUTCLK}]
create_clock -period 8.333 -name TxWordCLK [get_pins {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/TXOUTCLK}]

create_generated_clock -name RXDataCLK [get_pins FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name Data_clk_40 -source [get_pins CDMClkpllcomp/inst/plle2_adv_inst/CLKIN1] [get_pins CDMClkpllcomp/inst/plle2_adv_inst/CLKOUT0]
create_generated_clock -name SystemCLK_320 -source [get_pins CDMClkpllcomp/inst/plle2_adv_inst/CLKIN1] [get_pins CDMClkpllcomp/inst/plle2_adv_inst/CLKOUT1]

set_clock_groups -name ASYNC_CLOCKS1 -asynchronous -group [get_clocks {RxWordCLK RXDataCLK}] -group [get_clocks -include_generated_clocks {FMC_HPC_DATACLK}]
set_clock_groups -name ASYNC_CLOCKS2 -asynchronous -group [get_clocks TxWordCLK ] -group [get_clocks -include_generated_clocks {FMC_HPC_DATACLK}]
 
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks ipbus_module/eth/phy/*/gtxe2_i/TXOUTCLK] -group [get_clocks -include_generated_clocks ipbus_module/eth/phy/*/gtxe2_i/RXOUTCLK] 

set_clock_groups -name ASYNC_CLOCIPB -asynchronous -group [get_clocks -include_generated_clocks eth_refclk]

#================================================================================





#RESET ==========================================================================
set_false_path -from [get_cells Reset_Generator_comp/GenRes_DataClk_ff*_reg] 
#================================================================================




set_max_delay -datapath_only -from [get_cells HDMI0/trig_data_reg[*]] -to [get_clocks SystemCLK_320] 3.000
set_max_delay -datapath_only -from [get_cells HDMI0/DValid_reg] -to [get_clocks SystemCLK_320] 1.000
set_property ASYNC_REG true [get_cells {hdmi_ready0_reg hdmi_ready1_reg}]

set_false_path -from [get_clocks RXDataCLK] -to [get_cells {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/GBT_Status_O_reg[gbtRx_ErrorDet] FitGbtPrg/gbt_bank_gen.gbtBankDsgn/GBT_Status_O_reg[gbtRx_Ready]}]



set_multicycle_path -setup -start -from [get_clocks RxWordCLK] -to [get_cells {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/*_O_reg
                                                                    FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/RX_DATA_O_reg[*]
                                                                    FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/feedbackRegister_reg[*]}] 3
set_multicycle_path -hold -start -from [get_clocks RxWordCLK] -to [get_cells {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/*_O_reg 
                                                                    FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/RX_DATA_O_reg[*]
                                                                    FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/descrambler/gbtFrameOrWideBus_gen.gbtRxDescrambler84bit_gen[?].gbtRxDescrambler21bit/feedbackRegister_reg[*]}] 2


set_property ASYNC_REG true [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from00_reg]
set_property ASYNC_REG true [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from01_reg]

#================================================================================

set_false_path -to [get_ports SCOPE] 

set_property IOB TRUE [get_cells Laser_Signal_out_reg]


# HDMI ============================================================================
set_property IOB TRUE [get_cells -hierarchical {TDi_reg[?]}]
set_property IOB TRUE [get_cells PM_T??_reg]
set_property ASYNC_REG true [get_cells -hierarchical {rd_lock0_reg rd_lock1_reg}]

set_property ASYNC_REG true [get_cells PM_req0_reg]
set_property ASYNC_REG true [get_cells PM_req1_reg]
set_property ASYNC_REG true [get_cells rq_irq0_reg]
set_property ASYNC_REG true [get_cells rq_irq1_reg]

set_max_delay -datapath_only -from [get_clocks *] -to [get_ports {LA[*] GPIO_LED_*}] 15.000

set_false_path -from [get_cells -hierarchical srst_reg]

set_property BEL MMCME2_ADV [get_cells HDMI0/PLL1/inst/mmcm_adv_inst]
set_property LOC MMCME2_ADV_X0Y1 [get_cells HDMI0/PLL1/inst/mmcm_adv_inst]
#================================================================================

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets pm_sck]
create_clock -period 64.000 -name PM_sck [get_ports PM_SPI_SCK]

