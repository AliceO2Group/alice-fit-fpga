# Ethernet RefClk (125MHz)
create_clock -period 8.000 -name eth_refclk [get_ports ETHCLK_P]


# Ethernet driven by Ethernet txoutclk (i.e. via transceiver)
create_generated_clock -name eth_clk_62_5 -source [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKIN1] [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name eth_clk_125 -source [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKIN1] [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKOUT1]

# Clocks derived from MMCM driven by Ethernet RefClk directly (i.e. not via transceiver)
create_generated_clock -name clk_ipb -source [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKIN1] [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKOUT0]
create_generated_clock -name free_clk -source [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKIN1] [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKOUT1]
create_generated_clock -name dly_clk -source [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKIN1] [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKOUT2]

create_clock -period 5.000 -name MGTCLK [get_ports MGTCLK_P]
create_clock -period 8.333 -name RxWordCLK [get_pins {FitGbtPrg/gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/RXOUTCLK}]
create_clock -period 8.333 -name TxWordCLK [get_pins {FitGbtPrg/gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/TXOUTCLK}]

create_generated_clock -name RXDataCLK [get_pins FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst/CLKOUT0]


set_false_path -through [get_pins ipbus_module/clocks/nuke_i_reg/Q]


create_clock -period 25.000 -name MCLKA -waveform {0.000 12.500} [get_ports CLKA_P]
create_clock -period 25.000 -name MCLKC -waveform {0.000 12.500} [get_ports CLKC_P]

create_clock -period 100.000 -name SPI [get_ports SCK]

#clock groups for standalone progect
#for integrated use spetial groups
######################################
set_clock_groups -name ASYNC_CLOCKS -asynchronous -group [get_clocks -include_generated_clocks {RxWordCLK RXDataCLK}] -group [get_clocks -include_generated_clocks TxWordCLK] -group [get_clocks MGTCLK]
set_clock_groups -name ASYNC_CLOCKS2 -asynchronous -group [get_clocks -include_generated_clocks MCLKA] -group [get_clocks MGTCLK]
set_clock_groups -name ASYNC_CLOCKS3 -asynchronous -group [get_clocks -include_generated_clocks MCLKA] -group [get_clocks clk_ipb] -group [get_clocks -include_generated_clocks {RxWordCLK RXDataCLK}] 

set_clock_groups -name ASYNC_CLOCIPB -asynchronous  -group [get_clocks clk_ipb] -group [get_clocks -include_generated_clocks MCLKA] -group [get_clocks -include_generated_clocks MCLKC]

set_clock_groups -asynchronous -group [get_clocks {eth_refclk clk_ipb}] -group [get_clocks -include_generated_clocks ipbus_module/eth/phy/*/gtxe2_i/TXOUTCLK] -group [get_clocks -include_generated_clocks ipbus_module/eth/phy/*/gtxe2_i/RXOUTCLK]

set_clock_groups -asynchronous -group [get_clocks free_clk]
set_clock_groups -asynchronous -group [get_clocks dly_clk]
set_clock_groups -name SPI_ASYNC -asynchronous -group [get_clocks SPI]

set_input_delay -clock [get_clocks SPI] -clock_fall -min 5.000 [get_ports MOSI ]
set_input_delay -clock [get_clocks SPI] -clock_fall -max 10.000 [get_ports MOSI]
set_input_delay -clock [get_clocks SPI] -clock_fall -min 5.000 [get_ports CS]
set_input_delay -clock [get_clocks SPI] -clock_fall -max 10.000 [get_ports CS]
set_output_delay -clock [get_clocks SPI] -max 5.000 [get_ports MISO]
set_output_delay -clock [get_clocks SPI] -min 0.000 [get_ports MISO]


set_false_path -through [get_pins ipbus_module/clocks/nuke_i_reg/Q]

set_max_delay -datapath_only -from [get_clocks *] -to [get_ports {*LA* LED*}] 15.000

set_input_delay -clock [get_clocks clk_ipb] -min 5.000 [get_ports  {MISO?[?]}]
set_input_delay -clock [get_clocks clk_ipb] -max 10.000 [get_ports {MISO?[?]}]
set_output_delay -clock [get_clocks clk_ipb] -max 5.000 [get_ports {{MOSI?[?]} {SEL?[?]} {SCK?[?]}}]
set_output_delay -clock [get_clocks clk_ipb] -min 0.000 [get_ports {{MOSI?[?]} {SEL?[?]} {SCK?[?]}}]






## RX Phase Aligner
##-----------------
## Comment: The period of TX_FRAMECLK is 25ns but "TS_GBTTX_SCRAMBLER_TO_GEARBOX" is set to 16ns, providing 9ns for setup margin.
set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/scrambler/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/txGearbox/*/D}] 16.000

## GBT RX:
##--------

## Comment: The period of RX_FRAMECLK is 25ns but "TS_GBTRX_GEARBOX_TO_DESCRAMBLER" is set to 20ns, providing 5ns for setup margin.
set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/rxGearbox/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/descrambler/*/D}] 20.000


set_false_path -hold -from [get_clocks RXDataCLK] -to [get_pins {FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D}]
set_max_delay  -from [get_clocks RXDataCLK] -to [get_pins {FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.phase_computing_inst/serialToParallel_reg[0]/D}] 1.000




set_property ASYNC_REG true [get_cells spi_wr0_reg]
set_property ASYNC_REG true [get_cells spi_wr1_reg]
set_property ASYNC_REG true [get_cells {cnt_lock0_reg cnt_lock1_reg}]
set_property ASYNC_REG true [get_cells {cnt_clr0_reg cnt_clr1_reg}]


create_generated_clock -name CLKA320 -source [get_pins tcma/PLL1/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLKA [get_pins tcma/PLL1/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name CLKC320 -source [get_pins tcmc/PLL1/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLKC [get_pins tcmc/PLL1/inst/mmcm_adv_inst/CLKOUT0]


#set_max_delay -datapath_only -from [get_ports *HDMI*] -to [get_clocks CLKA320] 1.0



set_property IOB TRUE [get_cells -hierarchical T_o_reg]
set_property IOB TRUE [get_cells lasi_reg]
set_property ASYNC_REG TRUE [get_cells {l_on_reg l_on0_reg}]

set_multicycle_path -setup -from [get_clocks CLKA320] -to [get_cells {{C_vertex/T_?_reg} {Rd_word_reg[*]}}] 2
set_multicycle_path -hold -from [get_clocks CLKA320] -to [get_cells {{C_vertex/T_?_reg} {Rd_word_reg[*]}}] 1

set_multicycle_path -setup -from [get_cells {tcma/NC_reg[?][?]}] -to [get_clocks CLKA320] 2
set_multicycle_path -hold -from [get_cells {tcma/NC_reg[?][?]}] -to [get_clocks CLKA320] 1
set_multicycle_path -setup -from [get_cells {tcmc/NC_reg[?][?]}] -to [get_clocks CLKC320] 2
set_multicycle_path -hold -from [get_cells {tcmc/NC_reg[?][?]}] -to [get_clocks CLKC320] 1


set_multicycle_path -setup -from [get_cells {{tcma/Ampl_o_reg[*]}  {AmplC_reg[*]}}] -to [get_cells  {C_FC/T_?_reg C_SC/T_?_reg {Rd_word_reg[*]}}] 2
set_multicycle_path -hold -from [get_cells {{tcma/Ampl_o_reg[*]}  {AmplC_reg[*]}}] -to [get_cells {C_FC/T_?_reg C_SC/T_?_reg {Rd_word_reg[*]}}] 1

set_max_delay -datapath_only -from [get_cells {MULC/U0/i_mult/gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg {tcmc/Ampl_o_reg[*]} {tcmc/Nchan_A_reg[*]}}] -to [get_clocks CLKA320] 3.000

set_max_delay -datapath_only -from [get_cells {tcmc/HDMIA[?].HDMI_RX/trig_data_reg[*]}] -to [get_clocks CLKA320] 3.000
set_max_delay -datapath_only -from [get_cells B_rdy_reg] -to [get_clocks CLKA320] 1.000
set_property ASYNC_REG true [get_cells B_rdy0_reg]
set_property ASYNC_REG true [get_cells B_rdy1_reg]

set_false_path -from [get_ports RST]
set_false_path -from [get_cells sreset_reg]

set_property ASYNC_REG true [get_cells spibuf_wr0_reg]
set_property ASYNC_REG true [get_cells spibuf_wr1_reg]
set_property ASYNC_REG true [get_cells spibuf_rd0_reg]
set_property ASYNC_REG true [get_cells spibuf_rd1_reg]
set_property ASYNC_REG true [get_cells buf_lock0_reg]
set_property ASYNC_REG true [get_cells buf_lock1_reg]
set_property ASYNC_REG true [get_cells rst_spi0_reg]
set_property ASYNC_REG true [get_cells rst_spi1_reg]


set_property BEL MMCME2_ADV [get_cells FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst]
set_property LOC MMCME2_ADV_X0Y4 [get_cells FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst]

set_property BEL MMCME2_ADV [get_cells tcma/PLL1/inst/mmcm_adv_inst]
set_property LOC MMCME2_ADV_X1Y1 [get_cells tcma/PLL1/inst/mmcm_adv_inst]


set_property IOB TRUE [get_cells -hierarchical {TDi_reg[?]}]
set_property ASYNC_REG TRUE [get_cells -hierarchical {rd_lock0_reg rd_lock1_reg}]
set_property ASYNC_REG TRUE [get_cells -hierarchical {stat_clr0_reg stat_clr1_reg}]

set_property ASYNC_REG TRUE [get_cells {reqA1_reg[?] reqA0_reg[?] reqC1_reg[?] reqC0_reg[?]}]

#set_false_path  -from [get_clocks MCLKA] -to [get_cells LA2I_reg[2]]
#set_false_path  -from [get_clocks MCLKC] -to [get_cells LA2I_reg[3]]
