#Created by Constraints Editor (xc7k160t-ffg676-2) - 2017/05/04

# All timing constraint translations are rough conversions, intended to act as a template for further manual refinement. The translations should not be expected to produce semantically identical results to the original ucf. Each xdc timing constraint must be manually inspected and verified to ensure it captures the desired intent

# In xdc, all clocks are related by default. This differs from ucf, where clocks are unrelated unless specified otherwise. As a result, you may now see cross-clock paths that were previously unconstrained in ucf. Commented out xdc false path constraints have been generated and can be uncommented, should you wish to remove these new paths. These commands are located after the last clock definition

create_clock -period 5.000 -name MGTCLK [get_ports MGTCLK_P]

create_clock -period 3.333 -name TDCCLK1 [get_ports TDCCLK1_P]
create_clock -period 3.333 -name TDCCLK2 [get_ports TDCCLK2_P]
create_clock -period 3.333 -name TDCCLK3 [get_ports TDCCLK3_P]

create_clock -period 25.000 -name MCLK1 [get_ports MCLK1_P]
create_clock -period 25.000 -name MCLK2 [get_ports MCLK2_P]
create_clock -period 25.000 -name MCLK3 [get_ports MCLK3_P]
create_clock -period 100.000 -name SPI [get_ports SCK]
create_clock -period 50.000 -name HSPI [get_ports HSCK]

create_clock -period 8.333 -name RxWordCLK [get_pins {FitGbtPrg/gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/RXOUTCLK}]
create_clock -period 8.333 -name TxWordCLK [get_pins {FitGbtPrg/gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i/TXOUTCLK}]

create_generated_clock -name RXDataCLK [get_pins FitGbtPrg/gbtBankDsgn/gbtBank_rxFrmClkPhAlgnr/latOpt_phalgnr_gen.mmcm_inst/pll/inst/mmcm_adv_inst/CLKOUT0]
set_clock_groups -name ASYNC_CLOCKS -asynchronous -group [get_clocks -include_generated_clocks {RxWordCLK RXDataCLK}] -group [get_clocks -include_generated_clocks TxWordCLK] -group [get_clocks -include_generated_clocks MCLK1]

set_clock_groups -name SPI_ASYNC -asynchronous -group [get_clocks SPI]
set_clock_groups -name HSPI_ASYNC -asynchronous -group [get_clocks HSPI]

set_input_delay -clock [get_clocks TDCCLK1] -min 1.200 [get_ports {RDA1_N RDA1_P RDB1_N RDB1_P RDC1_N RDC1_P RDD1_N RDD1_P RSA1_N RSA1_P RSB1_N RSB1_P RSC1_N RSC1_P RSD1_N RSD1_P}]
set_input_delay -clock [get_clocks TDCCLK1] -max 1.800 [get_ports {RDA1_N RDA1_P RDB1_N RDB1_P RDC1_N RDC1_P RDD1_N RDD1_P RSA1_N RSA1_P RSB1_N RSB1_P RSC1_N RSC1_P RSD1_N RSD1_P}]
set_input_delay -clock [get_clocks TDCCLK2] -min 1.200 [get_ports {RDA2_N RDA2_P RDB2_N RDB2_P RDC2_N RDC2_P RDD2_N RDD2_P RSA2_N RSA2_P RSB2_N RSB2_P RSC2_N RSC2_P RSD2_N RSD2_P}]
set_input_delay -clock [get_clocks TDCCLK2] -max 1.800 [get_ports {RDA2_N RDA2_P RDB2_N RDB2_P RDC2_N RDC2_P RDD2_N RDD2_P RSA2_N RSA2_P RSB2_N RSB2_P RSC2_N RSC2_P RSD2_N RSD2_P}]
set_input_delay -clock [get_clocks TDCCLK3] -min 1.200 [get_ports {RDA3_N RDA3_P RDB3_N RDB3_P RDC3_N RDC3_P RDD3_N RDD3_P RSA3_N RSA3_P RSB3_N RSB3_P RSC3_N RSC3_P RSD3_N RSD3_P}]
set_input_delay -clock [get_clocks TDCCLK3] -max 1.800 [get_ports {RDA3_N RDA3_P RDB3_N RDB3_P RDC3_N RDC3_P RDD3_N RDD3_P RSA3_N RSA3_P RSB3_N RSB3_P RSC3_N RSC3_P RSD3_N RSD3_P}]

set_input_delay -clock [get_clocks SPI] -max -5.000 [get_ports {MOSI CS}]
set_input_delay -clock [get_clocks SPI] -min -10.000 [get_ports {MOSI CS}]
set_output_delay -clock [get_clocks SPI] -max 5.000 [get_ports MISO]
set_output_delay -clock [get_clocks SPI] -min 0.000 [get_ports MISO]

set_input_delay -clock [get_clocks HSPI] -max -5.000 [get_ports {HMOSI HSEL}]
set_input_delay -clock [get_clocks HSPI] -min -10.000 [get_ports {HMOSI HSEL}]
set_output_delay -clock [get_clocks HSPI] -max 5.000 [get_ports HMISO]
set_output_delay -clock [get_clocks HSPI] -min 0.000 [get_ports HMISO]

create_generated_clock -name CLK600_1 -source [get_pins PLL1/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLK1 [get_pins PLL1/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name CLK600_90_1 -source [get_pins PLL1/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLK1 [get_pins PLL1/inst/mmcm_adv_inst/CLKOUT1]
create_generated_clock -name CLK300_1 -source [get_pins PLL1/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLK1 [get_pins PLL1/inst/mmcm_adv_inst/CLKOUT2]
create_generated_clock -name CLK600_2 -source [get_pins PLL2/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLK2 [get_pins PLL2/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name CLK600_90_2 -source [get_pins PLL2/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLK2 [get_pins PLL2/inst/mmcm_adv_inst/CLKOUT1]
create_generated_clock -name CLK300_2 -source [get_pins PLL2/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLK2 [get_pins PLL2/inst/mmcm_adv_inst/CLKOUT2]
create_generated_clock -name CLK600_3 -source [get_pins PLL3/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLK3 [get_pins PLL3/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name CLK600_90_3 -source [get_pins PLL3/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLK3 [get_pins PLL3/inst/mmcm_adv_inst/CLKOUT1]
create_generated_clock -name CLK300_3 -source [get_pins PLL3/inst/mmcm_adv_inst/CLKIN1] -master_clock MCLK3 [get_pins PLL3/inst/mmcm_adv_inst/CLKOUT2]

create_generated_clock -name CLK320 -source [get_pins PLL4/inst/plle2_adv_inst/CLKIN1] -master_clock MCLK1 [get_pins PLL4/inst/plle2_adv_inst/CLKOUT0]

set_property ASYNC_REG true [get_cells spi_lock_?_reg]
set_property ASYNC_REG true [get_cells spi_lock0_?_reg]

set_property ASYNC_REG true [get_cells almclr??_reg]
set_property ASYNC_REG true [get_cells stat_clr?_reg]

set_property ASYNC_REG true [get_cells spi_lock320_reg]
set_property ASYNC_REG true [get_cells spi_lock320_0_reg]

set_property ASYNC_REG true [get_cells hclr??_reg]
set_property ASYNC_REG true [get_cells hstat_clr?_reg]

set_property ASYNC_REG true [get_cells CHANNEL??/TDC_rdy320_0_reg]
set_property ASYNC_REG true [get_cells CHANNEL??/TDC_rdy320_reg]

set_property ASYNC_REG true [get_cells CHANNEL??/EV_0_reg]
set_property ASYNC_REG true [get_cells CHANNEL??/EV_reg]

set_property ASYNC_REG true [get_cells CHANNEL??/CSTR_0_reg]
set_property ASYNC_REG true [get_cells CHANNEL??/CSTR_1_reg]

set_property ASYNC_REG true [get_cells {TDC?_CH?/rs300_0_reg TDC?_CH?/rs300_1_reg}]
set_property ASYNC_REG true [get_cells reg32_wr0_reg]
set_property ASYNC_REG true [get_cells reg32_wr1_reg]
set_property ASYNC_REG true [get_cells spi_wr0_reg]
set_property ASYNC_REG true [get_cells spi_wr1_reg]
set_property ASYNC_REG true [get_cells hspi_wr0_reg]
set_property ASYNC_REG true [get_cells hspi_wr1_reg]
set_property ASYNC_REG true [get_cells spibuf_wr0_reg]
set_property ASYNC_REG true [get_cells spibuf_wr1_reg]
set_property ASYNC_REG true [get_cells hspibuf_wr0_reg]
set_property ASYNC_REG true [get_cells hspibuf_wr1_reg]
set_property ASYNC_REG true [get_cells spibuf_rd0_reg]
set_property ASYNC_REG true [get_cells spibuf_rd1_reg]
set_property ASYNC_REG true [get_cells hspibuf_rd0_reg]
set_property ASYNC_REG true [get_cells hspibuf_rd1_reg]
set_property ASYNC_REG true [get_cells buf_lock0_reg]
set_property ASYNC_REG true [get_cells buf_lock1_reg]
set_property ASYNC_REG true [get_cells count1/rd_en0_reg]
set_property ASYNC_REG true [get_cells count1/rd_en1_reg]
set_property ASYNC_REG true [get_cells count1/hrd_en0_reg]
set_property ASYNC_REG true [get_cells count1/hrd_en1_reg]


set_property IOB TRUE [get_cells {{tto_reg[?]} {tao_reg[?]}}]

set_property BEL PLLE2_ADV [get_cells PLL4/inst/plle2_adv_inst]
set_property LOC PLLE2_ADV_X1Y2 [get_cells PLL4/inst/plle2_adv_inst]
