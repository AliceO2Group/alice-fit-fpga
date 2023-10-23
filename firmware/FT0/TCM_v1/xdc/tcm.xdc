# Ethernet RefClk (125MHz)
create_clock -period 8.000 -name eth_refclk [get_ports ETHCLK_P]

create_clock -period 12.500 -name LCLK [get_ports LCLK_P]


# Ethernet driven by Ethernet txoutclk (i.e. via transceiver)
create_generated_clock -name eth_clk_62_5 -source [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKIN1] [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name eth_clk_125 -source [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKIN1] [get_pins ipbus_module/eth/mmcm/inst/mmcm_adv_inst/CLKOUT1]

# Clocks derived from MMCM driven by Ethernet RefClk directly (i.e. not via transceiver)
create_generated_clock -name clk_ipb -source [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKIN1] [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKOUT0]
create_generated_clock -name free_clk -source [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKIN1] [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKOUT1]
create_generated_clock -name dly_clk -source [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKIN1] [get_pins ipbus_module/clocks/pll/inst/plle2_adv_inst/CLKOUT2]

create_clock -period 5.000 -name MGTCLK [get_ports MGTCLK_P]
create_clock -period 8.333 -name RxWordCLK [get_pins {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/RXOUTCLK}]
create_clock -period 8.333 -name TxWordCLK [get_pins {FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/TXOUTCLK}]

create_generated_clock -name RXDataCLK [get_pins FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst/CLKOUT0]

create_clock -period 25.000 -name MCLKA -waveform {0.000 12.500} [get_ports CLKA_P]
create_clock -period 25.000 -name MCLKC -waveform {0.000 12.500} [get_ports CLKC_P]

create_clock -period 100.000 -name SPI [get_ports SCK]

#clock groups for standalone progect
#for integrated use spetial groups
######################################
#set_clock_groups -name ASYNC_CLOCKS0 -asynchronous -group [get_clocks {RxWordCLK RXDataCLK}] -group [get_clocks  TxWordCLK] 
set_clock_groups -name ASYNC_CLOCKS1 -asynchronous  -group [get_clocks  TxWordCLK] -group [get_clocks -include_generated_clocks MCLKA]
set_clock_groups -name ASYNC_CLOCKS2 -asynchronous  -group [get_clocks  RxWordCLK] -group [get_clocks -include_generated_clocks MCLKA]

set_clock_groups -name ASYNC_CLOCIPB -asynchronous -group [get_clocks -include_generated_clocks eth_refclk] 
set_clock_groups -asynchronous  -group [get_clocks -include_generated_clocks ipbus_module/eth/phy/*/gtxe2_i/TXOUTCLK] -group [get_clocks -include_generated_clocks ipbus_module/eth/phy/*/gtxe2_i/RXOUTCLK]

#set_clock_groups -asynchronous -group [get_clocks free_clk]
#set_clock_groups -asynchronous -group [get_clocks dly_clk]

set_clock_groups -name SPI_ASYNC -asynchronous -group [get_clocks SPI]

set_input_delay -clock [get_clocks SPI] -clock_fall -min 5.000 [get_ports MOSI]
set_input_delay -clock [get_clocks SPI] -clock_fall -max 10.000 [get_ports MOSI]
set_input_delay -clock [get_clocks SPI] -clock_fall -min 5.000 [get_ports CS]
set_input_delay -clock [get_clocks SPI] -clock_fall -max 10.000 [get_ports CS]
set_output_delay -clock [get_clocks SPI] -max 5.000 [get_ports MISO]
set_output_delay -clock [get_clocks SPI] -min 0.000 [get_ports MISO]

set_input_delay -clock [get_clocks clk_ipb] -min 5.000 [get_ports {MISO?[?]}]
set_input_delay -clock [get_clocks clk_ipb] -max 10.000 [get_ports {MISO?[?]}]
set_output_delay -clock [get_clocks clk_ipb] -max 5.000 [get_ports {{MOSI?[?]} {SEL?[?]} {SCK?[?]}}]
set_output_delay -clock [get_clocks clk_ipb] -min 0.000 [get_ports {{MOSI?[?]} {SEL?[?]} {SCK?[?]}}]


set_property ASYNC_REG true [get_cells spi_wr0_reg]
set_property ASYNC_REG true [get_cells spi_wr1_reg]
set_property ASYNC_REG true [get_cells cnt_lock0_reg]
set_property ASYNC_REG true [get_cells cnt_lock1_reg]
set_property ASYNC_REG true [get_cells cnt_clr0_reg]
set_property ASYNC_REG true [get_cells cnt_clr1_reg]
set_property ASYNC_REG true [get_cells {rout_lock0_reg rout_lock1_reg}]
set_property ASYNC_REG true [get_cells {rdout_errc0_reg rdout_errc1_reg}]
set_property ASYNC_REG true [get_cells {rdout_errf_rd0_reg rdout_errf_rd1_reg}]

set_property ASYNC_REG true [get_cells {Ccnt_clr0_reg Ccnt_clr1_reg}]

create_generated_clock -name CLKA320 -source [get_pins tcma/PLL1/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLKA [get_pins tcma/PLL1/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name CLKC320 -source [get_pins tcmc/PLL1/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLKC [get_pins tcmc/PLL1/inst/mmcm_adv_inst/CLKOUT0]

create_generated_clock -name TX_CLK -source [get_pins tcma/PLL1/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLKA [get_pins tcma/PLL1/inst/mmcm_adv_inst/CLKOUT2]

set_property IOB TRUE [get_cells -hierarchical T_o_reg]
set_property IOB TRUE [get_cells lasi_reg]

set_property ASYNC_REG true [get_cells {l_st0_reg l_st1_reg}]

set_property ASYNC_REG true [get_cells {avgt_lk0_reg avgt_lk_reg}]

set_property ASYNC_REG true [get_cells B_rdy0_reg]
set_property ASYNC_REG true [get_cells B_rdy1_reg]


set_property ASYNC_REG true [get_cells spibuf_wr0_reg]
set_property ASYNC_REG true [get_cells spibuf_wr1_reg]
set_property ASYNC_REG true [get_cells spibuf_rd0_reg]
set_property ASYNC_REG true [get_cells spibuf_rd1_reg]
set_property ASYNC_REG true [get_cells buf_lock0_reg]
set_property ASYNC_REG true [get_cells buf_lock1_reg]
set_property ASYNC_REG true [get_cells rst_spi0_reg]
set_property ASYNC_REG true [get_cells rst_spi1_reg]

set_property BEL MMCME2_ADV [get_cells FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst]
set_property LOC MMCME2_ADV_X0Y4 [get_cells FitGbtPrg/gbt_bank_gen.gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst]

set_property BEL MMCME2_ADV [get_cells tcma/PLL1/inst/mmcm_adv_inst]
set_property LOC MMCME2_ADV_X1Y1 [get_cells tcma/PLL1/inst/mmcm_adv_inst]

set_property BEL PLLE2_ADV [get_cells Lclk0/inst/plle2_adv_inst]
set_property LOC PLLE2_ADV_X1Y1 [get_cells Lclk0/inst/plle2_adv_inst]

set_property IOB TRUE [get_cells -hierarchical {TDi_reg[?]}]
set_property ASYNC_REG true [get_cells -hierarchical {rd_lock0_reg rd_lock1_reg}]
set_property ASYNC_REG true [get_cells -hierarchical {stat_clr0_reg stat_clr1_reg}]
set_property ASYNC_REG true [get_cells -hierarchical {GBTRX_ready0_reg GBTRX_ready1_reg}]

set_property ASYNC_REG true [get_cells {{reqA1_reg[?]} {reqA0_reg[?]} {reqC1_reg[?]} {reqC0_reg[?]}}]


# GBT readout
#####################################################################

# Reset generator multipath -------------------------------------
#set_false_path -from [get_cells FitGbtPrg/Reset_Generator_comp/GenRes_DataClk_ff*_reg]  -to [all_registers]

# RX Sync comp -------------------------------------
set_property ASYNC_REG true [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from00_reg]
set_property ASYNC_REG true [get_cells FitGbtPrg/RxData_ClkSync_comp/RX_CLK_from01_reg]


