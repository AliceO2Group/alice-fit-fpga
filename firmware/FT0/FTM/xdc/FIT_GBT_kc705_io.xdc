set_property PACKAGE_PIN AE23 [get_ports CLKPM_P]
# FTM v1.0 10.01.19

# J22 (P1) CONNECTOR
# FMC_SFP_TX_P 			FMC_HPC_DP0_C2M_P		D2 D1
# FMC_SFP_RX_P 			FMC_HPC_DP0_M2C_P		E4 E3
# FMC_CLK_200_P 		FMC_HPC_GBTCLK0_M2C_P	C8 C7
# FMC_LHC_CLK_P			FMC_HPC_LA00_CC_P		C25 B25

# FMC_IPBUS_SPI_MOSI 	FMC_HPC_LA33_P			H21
# FMC_IPBUS_SPI_MISO 	FMC_HPC_LA33_N			H22
# FMC_IPBUS_SPI_SCK		FMC_HPC_LA32_P			D21
# FMC_IPBUS_SPI_NSS		FMC_HPC_LA32_N			C21

# ??? sfp_rate_sel FMC_HPC_LA18_CC_P	F21
# ??? sfp_los  FMC_HPC_LA18_CC_N	E21

# J2 (P2) CONNECTOR
# FMC_SFP_I2C_SCL		FMC_LPC_LA33_P			AC29
# FMC_SFP_TX_DISABLE	FMC_LPC_LA33_N			AC30

set_property PACKAGE_PIN C8 [get_ports FMC_HPC_clk_200_p]
set_property PACKAGE_PIN C7 [get_ports FMC_HPC_clk_200_n]



# =========================== TCM proto ============================
#set_property PACKAGE_PIN D27 [get_ports FMC_HPC_clk_A_p]
#set_property PACKAGE_PIN C27 [get_ports FMC_HPC_clk_A_n]

# =========================== FTM ============================
set_property PACKAGE_PIN C25 [get_ports FMC_HPC_clk_A_p]
set_property PACKAGE_PIN B25 [get_ports FMC_HPC_clk_A_n]

set_property PACKAGE_PIN H24 [get_ports LAS_EN]
set_property IOSTANDARD LVCMOS25 [get_ports LAS_EN]

#set_property PACKAGE_PIN AG27 [get_ports TCM_TT0_P]
#set_property PACKAGE_PIN AJ26 [get_ports TCM_TA1_P]
#set_property PACKAGE_PIN AJ27 [get_ports TCM_TA0_P]
#set_property PACKAGE_PIN AF26 [get_ports TCM_TT1_P]

set_property PACKAGE_PIN AF25 [get_ports TCM_SPI_SEL]
set_property PACKAGE_PIN AD24 [get_ports TCM_SPI_MOSI]
set_property PACKAGE_PIN AC24 [get_ports TCM_SPI_SCK]
set_property PACKAGE_PIN AJ23 [get_ports TCM_SPI_MISO]
set_property IOSTANDARD LVCMOS25 [get_ports TCM_SPI_MISO]
set_property IOSTANDARD LVCMOS25 [get_ports TCM_SPI_MOSI]
set_property IOSTANDARD LVCMOS25 [get_ports TCM_SPI_SCK]
set_property IOSTANDARD LVCMOS25 [get_ports TCM_SPI_SEL]
set_property DRIVE 12 [get_ports TCM_SPI_SEL]

set_property PACKAGE_PIN AK30 [get_ports {LA[8]}]
set_property PACKAGE_PIN AK29 [get_ports {LA[9]}]
set_property PACKAGE_PIN AJ28 [get_ports {LA[10]}]
set_property PACKAGE_PIN AH27 [get_ports {LA[11]}]
set_property PACKAGE_PIN AH26 [get_ports {LA[12]}]
set_property PACKAGE_PIN AD28 [get_ports {LA[13]}]
set_property PACKAGE_PIN AD27 [get_ports {LA[14]}]
set_property PACKAGE_PIN AC27 [get_ports {LA[15]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[15]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[14]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[13]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[12]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[11]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[10]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[9]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[8]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LA[0]}]
set_property SLEW FAST [get_ports {LA[15]}]
set_property SLEW FAST [get_ports {LA[14]}]
set_property SLEW FAST [get_ports {LA[13]}]
set_property SLEW FAST [get_ports {LA[12]}]
set_property SLEW FAST [get_ports {LA[11]}]
set_property SLEW FAST [get_ports {LA[10]}]
set_property SLEW FAST [get_ports {LA[9]}]
set_property SLEW FAST [get_ports {LA[8]}]
set_property SLEW FAST [get_ports {LA[7]}]
set_property SLEW FAST [get_ports {LA[6]}]
set_property SLEW FAST [get_ports {LA[5]}]
set_property SLEW FAST [get_ports {LA[4]}]
set_property SLEW FAST [get_ports {LA[3]}]
set_property SLEW FAST [get_ports {LA[2]}]
set_property SLEW FAST [get_ports {LA[1]}]
set_property SLEW FAST [get_ports {LA[0]}]

set_property PACKAGE_PIN AJ29 [get_ports {LA[7]}]
set_property PACKAGE_PIN AC26 [get_ports {LA[6]}]
set_property PACKAGE_PIN AG30 [get_ports {LA[5]}]
set_property PACKAGE_PIN AD26 [get_ports {LA[4]}]
set_property PACKAGE_PIN AH30 [get_ports {LA[3]}]
set_property PACKAGE_PIN AE28 [get_ports {LA[2]}]
set_property PACKAGE_PIN AE30 [get_ports {LA[1]}]
set_property PACKAGE_PIN AF28 [get_ports {LA[0]}]


# ============================================================


set_property IOSTANDARD LVDS_25 [get_ports LAS_D_N]
set_property IOSTANDARD LVDS_25 [get_ports LAS_D_P]
set_property PACKAGE_PIN G28 [get_ports LAS_D_P]
set_property PACKAGE_PIN F28 [get_ports LAS_D_N]


set_property PACKAGE_PIN E3 [get_ports eth_rx_n]
set_property PACKAGE_PIN E4 [get_ports eth_rx_p]
set_property PACKAGE_PIN D1 [get_ports eth_tx_n]
set_property PACKAGE_PIN D2 [get_ports eth_tx_p]
set_property PACKAGE_PIN G8 [get_ports eth_clk_p]
set_property PACKAGE_PIN G7 [get_ports eth_clk_n]

set_property PACKAGE_PIN H22 [get_ports spi_miso]
set_property PACKAGE_PIN H21 [get_ports spi_mosi]
set_property PACKAGE_PIN D21 [get_ports spi_sclk]
set_property PACKAGE_PIN C21 [get_ports spi_ss]

set_property IOSTANDARD LVCMOS25 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS25 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS25 [get_ports spi_sclk]
set_property IOSTANDARD LVCMOS25 [get_ports spi_ss]

set_property PACKAGE_PIN F21 [get_ports {sfp_rate_sel[0]}]
set_property PACKAGE_PIN C19 [get_ports {sfp_rate_sel[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {sfp_rate_sel[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {sfp_rate_sel[0]}]

set_property IOSTANDARD LVCMOS25 [get_ports sfp_los]
set_property PACKAGE_PIN E21 [get_ports sfp_los]



set_property PACKAGE_PIN Y20 [get_ports SFP_TX_DSBL]
set_property IOSTANDARD LVCMOS25 [get_ports SFP_TX_DSBL]

set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_1]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_0]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_3]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_2]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_LED_4]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_LED_6]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_7]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_BUTTON_SW_C]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_LED_5]
#set_property IOSTANDARD LVCMOS25 [get_ports GPIO_SMA_J13]
#set_property IOSTANDARD LVCMOS25 [get_ports GPIO_SMA_J14]
set_property DRIVE 12 [get_ports GPIO_LED_1]
set_property DRIVE 12 [get_ports GPIO_LED_0]
set_property DRIVE 12 [get_ports GPIO_LED_3]
set_property DRIVE 12 [get_ports GPIO_LED_2]
set_property DRIVE 12 [get_ports GPIO_LED_4]
set_property DRIVE 12 [get_ports GPIO_LED_6]
set_property DRIVE 12 [get_ports GPIO_LED_7]
set_property DRIVE 12 [get_ports GPIO_LED_5]
set_property DRIVE 12 [get_ports SFP_TX_DSBL]
#set_property DRIVE 16 [get_ports GPIO_SMA_J13]
#set_property DRIVE 16 [get_ports GPIO_SMA_J14]
set_property SLEW SLOW [get_ports GPIO_LED_1]
set_property SLEW SLOW [get_ports GPIO_LED_0]
set_property SLEW SLOW [get_ports GPIO_LED_3]
set_property SLEW SLOW [get_ports GPIO_LED_2]
set_property SLEW SLOW [get_ports GPIO_LED_4]
set_property SLEW SLOW [get_ports GPIO_LED_6]
set_property SLEW SLOW [get_ports GPIO_LED_7]
set_property SLEW SLOW [get_ports GPIO_LED_5]
set_property SLEW SLOW [get_ports SFP_TX_DSBL]
#set_property SLEW FAST [get_ports GPIO_SMA_J13]
#set_property SLEW FAST [get_ports GPIO_SMA_J14]

set_property PACKAGE_PIN J8 [get_ports SMA_MGT_CLK_P]
set_property PACKAGE_PIN AD12 [get_ports SYS_CLK_P]
set_property IOSTANDARD LVDS [get_ports SYS_CLK_P]
set_property IOSTANDARD LVDS [get_ports SYS_CLK_N]
set_property PACKAGE_PIN K28 [get_ports USER_CLK_P]
set_property IOSTANDARD LVDS_25 [get_ports USER_CLK_P]
set_property IOSTANDARD LVDS_25 [get_ports USER_CLK_N]
set_property PACKAGE_PIN G12 [get_ports GPIO_BUTTON_SW_C]
set_property PACKAGE_PIN AB8 [get_ports GPIO_LED_0]
set_property PACKAGE_PIN AA8 [get_ports GPIO_LED_1]
set_property PACKAGE_PIN AC9 [get_ports GPIO_LED_2]
set_property PACKAGE_PIN AB9 [get_ports GPIO_LED_3]
set_property PACKAGE_PIN AE26 [get_ports GPIO_LED_4]
set_property PACKAGE_PIN G19 [get_ports GPIO_LED_5]
set_property PACKAGE_PIN E18 [get_ports GPIO_LED_6]
set_property PACKAGE_PIN F16 [get_ports GPIO_LED_7]

set_property PACKAGE_PIN Y23 [get_ports GPIO_SMA_J13]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_SMA_J13]
set_property PACKAGE_PIN Y24 [get_ports GPIO_SMA_J14]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_SMA_J14]

set_property PACKAGE_PIN AB7 [get_ports RESET]
set_property IOSTANDARD LVCMOS15 [get_ports RESET]

set_property PACKAGE_PIN G3 [get_ports SFP_RX_N]
set_property PACKAGE_PIN G4 [get_ports SFP_RX_P]
set_property PACKAGE_PIN H1 [get_ports SFP_TX_N]
set_property PACKAGE_PIN H2 [get_ports SFP_TX_P]


set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]






set_property PACKAGE_PIN AJ26 [get_ports TCM_TT0_P]
set_property PACKAGE_PIN AJ27 [get_ports TCM_TT1_P]
set_property PACKAGE_PIN AG27 [get_ports TCM_TA1_P]
set_property PACKAGE_PIN AF26 [get_ports TCM_TA0_P]


set_property PACKAGE_PIN AD23 [get_ports PM_TA0_P]
set_property PACKAGE_PIN AH21 [get_ports PM_TA1_P]
set_property PACKAGE_PIN AF20 [get_ports PM_TT0_P]
set_property PACKAGE_PIN AG20 [get_ports PM_TT1_P]

set_property PACKAGE_PIN AE25 [get_ports PM_SPI_MISO]
set_property PACKAGE_PIN AH25 [get_ports PM_SPI_MOSI]
set_property PACKAGE_PIN AG25 [get_ports PM_SPI_SCK]
set_property PACKAGE_PIN AJ22 [get_ports PM_SPI_SEL]
set_property IOSTANDARD LVCMOS25 [get_ports PM_SPI_MISO]
set_property IOSTANDARD LVCMOS25 [get_ports PM_SPI_MOSI]
set_property IOSTANDARD LVCMOS25 [get_ports PM_SPI_SCK]
set_property IOSTANDARD LVCMOS25 [get_ports PM_SPI_SEL]


set_property BITSTREAM.CONFIG.CONFIGRATE 16 [current_design]
set_property BITSTREAM.GENERAL.XADCENHANCEDLINEARITY ON [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPPOWERDOWN ENABLE [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]

set_property CONFIG_VOLTAGE 2.5 [current_design]
set_property CFGBVS VCCO [current_design]


set_property PACKAGE_PIN Y29 [get_ports GPIO_DIP_SW0]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_DIP_SW0]

connect_debug_port dbg_hub/clk [get_nets TESTM_status[GBT_status][rxWordClk]]

set_property OFFCHIP_TERM NONE [get_ports GPIO_SMA_J13]
set_property OFFCHIP_TERM NONE [get_ports TCM_SPI_MOSI]
set_property OFFCHIP_TERM NONE [get_ports TCM_SPI_SCK]
set_property OFFCHIP_TERM NONE [get_ports TCM_SPI_SEL]
set_property OFFCHIP_TERM NONE [get_ports LA[15]]
set_property OFFCHIP_TERM NONE [get_ports LA[14]]
set_property OFFCHIP_TERM NONE [get_ports LA[13]]
set_property OFFCHIP_TERM NONE [get_ports LA[12]]
set_property OFFCHIP_TERM NONE [get_ports LA[11]]
set_property OFFCHIP_TERM NONE [get_ports LA[10]]
set_property OFFCHIP_TERM NONE [get_ports LA[9]]
set_property OFFCHIP_TERM NONE [get_ports LA[8]]
set_property OFFCHIP_TERM NONE [get_ports LA[7]]
set_property OFFCHIP_TERM NONE [get_ports LA[6]]
set_property OFFCHIP_TERM NONE [get_ports LA[5]]
set_property OFFCHIP_TERM NONE [get_ports LA[4]]
set_property OFFCHIP_TERM NONE [get_ports LA[3]]
set_property OFFCHIP_TERM NONE [get_ports LA[2]]
set_property OFFCHIP_TERM NONE [get_ports LA[1]]
set_property OFFCHIP_TERM NONE [get_ports LA[0]]
set_property OFFCHIP_TERM NONE [get_ports sfp_rate_sel[1]]
set_property OFFCHIP_TERM NONE [get_ports sfp_rate_sel[0]]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 6 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list CDMClkpllcomp/inst/CLK_OUT1_40]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[0]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[1]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[2]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[3]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[4]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[5]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[6]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[7]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[8]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[9]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[10]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[11]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[12]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[13]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[14]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[15]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[16]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[17]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[18]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[19]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[20]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[21]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[22]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[23]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[24]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[25]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[26]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[27]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[28]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[29]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[30]} {FitGbtPrg/CRU_ORBC_Gen_comp/TRG_result[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[0]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[1]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[2]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[3]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[4]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[5]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[6]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[7]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[8]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[9]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[10]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[11]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[12]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[13]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[14]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[15]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[16]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[17]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[18]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[19]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[20]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[21]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[22]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[23]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[24]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[25]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[26]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[27]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[28]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[29]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[30]} {FitGbtPrg/CRU_ORBC_Gen_comp/bpattern_counter[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[0]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[1]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[2]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[3]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[4]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[5]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[6]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[7]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[8]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[9]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[10]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[11]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[12]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[13]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[14]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[15]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[16]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[17]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[18]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[19]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[20]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[21]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[22]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[23]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[24]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[25]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[26]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[27]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[28]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[29]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[30]} {FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_send[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 3 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {FitGbtPrg/CRU_ORBC_Gen_comp/rd_trg_send_mode[0]} {FitGbtPrg/CRU_ORBC_Gen_comp/rd_trg_send_mode[1]} {FitGbtPrg/CRU_ORBC_Gen_comp/rd_trg_send_mode[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[0]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[1]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[2]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[3]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[4]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[5]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[6]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[7]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[8]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[9]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[10]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[11]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[12]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[13]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[14]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[15]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[16]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[17]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[18]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[19]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[20]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[21]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[22]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[23]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[24]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[25]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[26]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[27]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[28]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[29]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[30]} {FitGbtPrg/CRU_ORBC_Gen_comp/single_trg_send_val[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 80 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {FitGbtPrg/RX_Data_DataClk[0]} {FitGbtPrg/RX_Data_DataClk[1]} {FitGbtPrg/RX_Data_DataClk[2]} {FitGbtPrg/RX_Data_DataClk[3]} {FitGbtPrg/RX_Data_DataClk[4]} {FitGbtPrg/RX_Data_DataClk[5]} {FitGbtPrg/RX_Data_DataClk[6]} {FitGbtPrg/RX_Data_DataClk[7]} {FitGbtPrg/RX_Data_DataClk[8]} {FitGbtPrg/RX_Data_DataClk[9]} {FitGbtPrg/RX_Data_DataClk[10]} {FitGbtPrg/RX_Data_DataClk[11]} {FitGbtPrg/RX_Data_DataClk[12]} {FitGbtPrg/RX_Data_DataClk[13]} {FitGbtPrg/RX_Data_DataClk[14]} {FitGbtPrg/RX_Data_DataClk[15]} {FitGbtPrg/RX_Data_DataClk[16]} {FitGbtPrg/RX_Data_DataClk[17]} {FitGbtPrg/RX_Data_DataClk[18]} {FitGbtPrg/RX_Data_DataClk[19]} {FitGbtPrg/RX_Data_DataClk[20]} {FitGbtPrg/RX_Data_DataClk[21]} {FitGbtPrg/RX_Data_DataClk[22]} {FitGbtPrg/RX_Data_DataClk[23]} {FitGbtPrg/RX_Data_DataClk[24]} {FitGbtPrg/RX_Data_DataClk[25]} {FitGbtPrg/RX_Data_DataClk[26]} {FitGbtPrg/RX_Data_DataClk[27]} {FitGbtPrg/RX_Data_DataClk[28]} {FitGbtPrg/RX_Data_DataClk[29]} {FitGbtPrg/RX_Data_DataClk[30]} {FitGbtPrg/RX_Data_DataClk[31]} {FitGbtPrg/RX_Data_DataClk[32]} {FitGbtPrg/RX_Data_DataClk[33]} {FitGbtPrg/RX_Data_DataClk[34]} {FitGbtPrg/RX_Data_DataClk[35]} {FitGbtPrg/RX_Data_DataClk[36]} {FitGbtPrg/RX_Data_DataClk[37]} {FitGbtPrg/RX_Data_DataClk[38]} {FitGbtPrg/RX_Data_DataClk[39]} {FitGbtPrg/RX_Data_DataClk[40]} {FitGbtPrg/RX_Data_DataClk[41]} {FitGbtPrg/RX_Data_DataClk[42]} {FitGbtPrg/RX_Data_DataClk[43]} {FitGbtPrg/RX_Data_DataClk[44]} {FitGbtPrg/RX_Data_DataClk[45]} {FitGbtPrg/RX_Data_DataClk[46]} {FitGbtPrg/RX_Data_DataClk[47]} {FitGbtPrg/RX_Data_DataClk[48]} {FitGbtPrg/RX_Data_DataClk[49]} {FitGbtPrg/RX_Data_DataClk[50]} {FitGbtPrg/RX_Data_DataClk[51]} {FitGbtPrg/RX_Data_DataClk[52]} {FitGbtPrg/RX_Data_DataClk[53]} {FitGbtPrg/RX_Data_DataClk[54]} {FitGbtPrg/RX_Data_DataClk[55]} {FitGbtPrg/RX_Data_DataClk[56]} {FitGbtPrg/RX_Data_DataClk[57]} {FitGbtPrg/RX_Data_DataClk[58]} {FitGbtPrg/RX_Data_DataClk[59]} {FitGbtPrg/RX_Data_DataClk[60]} {FitGbtPrg/RX_Data_DataClk[61]} {FitGbtPrg/RX_Data_DataClk[62]} {FitGbtPrg/RX_Data_DataClk[63]} {FitGbtPrg/RX_Data_DataClk[64]} {FitGbtPrg/RX_Data_DataClk[65]} {FitGbtPrg/RX_Data_DataClk[66]} {FitGbtPrg/RX_Data_DataClk[67]} {FitGbtPrg/RX_Data_DataClk[68]} {FitGbtPrg/RX_Data_DataClk[69]} {FitGbtPrg/RX_Data_DataClk[70]} {FitGbtPrg/RX_Data_DataClk[71]} {FitGbtPrg/RX_Data_DataClk[72]} {FitGbtPrg/RX_Data_DataClk[73]} {FitGbtPrg/RX_Data_DataClk[74]} {FitGbtPrg/RX_Data_DataClk[75]} {FitGbtPrg/RX_Data_DataClk[76]} {FitGbtPrg/RX_Data_DataClk[77]} {FitGbtPrg/RX_Data_DataClk[78]} {FitGbtPrg/RX_Data_DataClk[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 80 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {FitGbtPrg/RX_Data_from_orbcgen[0]} {FitGbtPrg/RX_Data_from_orbcgen[1]} {FitGbtPrg/RX_Data_from_orbcgen[2]} {FitGbtPrg/RX_Data_from_orbcgen[3]} {FitGbtPrg/RX_Data_from_orbcgen[4]} {FitGbtPrg/RX_Data_from_orbcgen[5]} {FitGbtPrg/RX_Data_from_orbcgen[6]} {FitGbtPrg/RX_Data_from_orbcgen[7]} {FitGbtPrg/RX_Data_from_orbcgen[8]} {FitGbtPrg/RX_Data_from_orbcgen[9]} {FitGbtPrg/RX_Data_from_orbcgen[10]} {FitGbtPrg/RX_Data_from_orbcgen[11]} {FitGbtPrg/RX_Data_from_orbcgen[12]} {FitGbtPrg/RX_Data_from_orbcgen[13]} {FitGbtPrg/RX_Data_from_orbcgen[14]} {FitGbtPrg/RX_Data_from_orbcgen[15]} {FitGbtPrg/RX_Data_from_orbcgen[16]} {FitGbtPrg/RX_Data_from_orbcgen[17]} {FitGbtPrg/RX_Data_from_orbcgen[18]} {FitGbtPrg/RX_Data_from_orbcgen[19]} {FitGbtPrg/RX_Data_from_orbcgen[20]} {FitGbtPrg/RX_Data_from_orbcgen[21]} {FitGbtPrg/RX_Data_from_orbcgen[22]} {FitGbtPrg/RX_Data_from_orbcgen[23]} {FitGbtPrg/RX_Data_from_orbcgen[24]} {FitGbtPrg/RX_Data_from_orbcgen[25]} {FitGbtPrg/RX_Data_from_orbcgen[26]} {FitGbtPrg/RX_Data_from_orbcgen[27]} {FitGbtPrg/RX_Data_from_orbcgen[28]} {FitGbtPrg/RX_Data_from_orbcgen[29]} {FitGbtPrg/RX_Data_from_orbcgen[30]} {FitGbtPrg/RX_Data_from_orbcgen[31]} {FitGbtPrg/RX_Data_from_orbcgen[32]} {FitGbtPrg/RX_Data_from_orbcgen[33]} {FitGbtPrg/RX_Data_from_orbcgen[34]} {FitGbtPrg/RX_Data_from_orbcgen[35]} {FitGbtPrg/RX_Data_from_orbcgen[36]} {FitGbtPrg/RX_Data_from_orbcgen[37]} {FitGbtPrg/RX_Data_from_orbcgen[38]} {FitGbtPrg/RX_Data_from_orbcgen[39]} {FitGbtPrg/RX_Data_from_orbcgen[40]} {FitGbtPrg/RX_Data_from_orbcgen[41]} {FitGbtPrg/RX_Data_from_orbcgen[42]} {FitGbtPrg/RX_Data_from_orbcgen[43]} {FitGbtPrg/RX_Data_from_orbcgen[44]} {FitGbtPrg/RX_Data_from_orbcgen[45]} {FitGbtPrg/RX_Data_from_orbcgen[46]} {FitGbtPrg/RX_Data_from_orbcgen[47]} {FitGbtPrg/RX_Data_from_orbcgen[48]} {FitGbtPrg/RX_Data_from_orbcgen[49]} {FitGbtPrg/RX_Data_from_orbcgen[50]} {FitGbtPrg/RX_Data_from_orbcgen[51]} {FitGbtPrg/RX_Data_from_orbcgen[52]} {FitGbtPrg/RX_Data_from_orbcgen[53]} {FitGbtPrg/RX_Data_from_orbcgen[54]} {FitGbtPrg/RX_Data_from_orbcgen[55]} {FitGbtPrg/RX_Data_from_orbcgen[56]} {FitGbtPrg/RX_Data_from_orbcgen[57]} {FitGbtPrg/RX_Data_from_orbcgen[58]} {FitGbtPrg/RX_Data_from_orbcgen[59]} {FitGbtPrg/RX_Data_from_orbcgen[60]} {FitGbtPrg/RX_Data_from_orbcgen[61]} {FitGbtPrg/RX_Data_from_orbcgen[62]} {FitGbtPrg/RX_Data_from_orbcgen[63]} {FitGbtPrg/RX_Data_from_orbcgen[64]} {FitGbtPrg/RX_Data_from_orbcgen[65]} {FitGbtPrg/RX_Data_from_orbcgen[66]} {FitGbtPrg/RX_Data_from_orbcgen[67]} {FitGbtPrg/RX_Data_from_orbcgen[68]} {FitGbtPrg/RX_Data_from_orbcgen[69]} {FitGbtPrg/RX_Data_from_orbcgen[70]} {FitGbtPrg/RX_Data_from_orbcgen[71]} {FitGbtPrg/RX_Data_from_orbcgen[72]} {FitGbtPrg/RX_Data_from_orbcgen[73]} {FitGbtPrg/RX_Data_from_orbcgen[74]} {FitGbtPrg/RX_Data_from_orbcgen[75]} {FitGbtPrg/RX_Data_from_orbcgen[76]} {FitGbtPrg/RX_Data_from_orbcgen[77]} {FitGbtPrg/RX_Data_from_orbcgen[78]} {FitGbtPrg/RX_Data_from_orbcgen[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 80 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {FitGbtPrg/TX_Data_from_packager[0]} {FitGbtPrg/TX_Data_from_packager[1]} {FitGbtPrg/TX_Data_from_packager[2]} {FitGbtPrg/TX_Data_from_packager[3]} {FitGbtPrg/TX_Data_from_packager[4]} {FitGbtPrg/TX_Data_from_packager[5]} {FitGbtPrg/TX_Data_from_packager[6]} {FitGbtPrg/TX_Data_from_packager[7]} {FitGbtPrg/TX_Data_from_packager[8]} {FitGbtPrg/TX_Data_from_packager[9]} {FitGbtPrg/TX_Data_from_packager[10]} {FitGbtPrg/TX_Data_from_packager[11]} {FitGbtPrg/TX_Data_from_packager[12]} {FitGbtPrg/TX_Data_from_packager[13]} {FitGbtPrg/TX_Data_from_packager[14]} {FitGbtPrg/TX_Data_from_packager[15]} {FitGbtPrg/TX_Data_from_packager[16]} {FitGbtPrg/TX_Data_from_packager[17]} {FitGbtPrg/TX_Data_from_packager[18]} {FitGbtPrg/TX_Data_from_packager[19]} {FitGbtPrg/TX_Data_from_packager[20]} {FitGbtPrg/TX_Data_from_packager[21]} {FitGbtPrg/TX_Data_from_packager[22]} {FitGbtPrg/TX_Data_from_packager[23]} {FitGbtPrg/TX_Data_from_packager[24]} {FitGbtPrg/TX_Data_from_packager[25]} {FitGbtPrg/TX_Data_from_packager[26]} {FitGbtPrg/TX_Data_from_packager[27]} {FitGbtPrg/TX_Data_from_packager[28]} {FitGbtPrg/TX_Data_from_packager[29]} {FitGbtPrg/TX_Data_from_packager[30]} {FitGbtPrg/TX_Data_from_packager[31]} {FitGbtPrg/TX_Data_from_packager[32]} {FitGbtPrg/TX_Data_from_packager[33]} {FitGbtPrg/TX_Data_from_packager[34]} {FitGbtPrg/TX_Data_from_packager[35]} {FitGbtPrg/TX_Data_from_packager[36]} {FitGbtPrg/TX_Data_from_packager[37]} {FitGbtPrg/TX_Data_from_packager[38]} {FitGbtPrg/TX_Data_from_packager[39]} {FitGbtPrg/TX_Data_from_packager[40]} {FitGbtPrg/TX_Data_from_packager[41]} {FitGbtPrg/TX_Data_from_packager[42]} {FitGbtPrg/TX_Data_from_packager[43]} {FitGbtPrg/TX_Data_from_packager[44]} {FitGbtPrg/TX_Data_from_packager[45]} {FitGbtPrg/TX_Data_from_packager[46]} {FitGbtPrg/TX_Data_from_packager[47]} {FitGbtPrg/TX_Data_from_packager[48]} {FitGbtPrg/TX_Data_from_packager[49]} {FitGbtPrg/TX_Data_from_packager[50]} {FitGbtPrg/TX_Data_from_packager[51]} {FitGbtPrg/TX_Data_from_packager[52]} {FitGbtPrg/TX_Data_from_packager[53]} {FitGbtPrg/TX_Data_from_packager[54]} {FitGbtPrg/TX_Data_from_packager[55]} {FitGbtPrg/TX_Data_from_packager[56]} {FitGbtPrg/TX_Data_from_packager[57]} {FitGbtPrg/TX_Data_from_packager[58]} {FitGbtPrg/TX_Data_from_packager[59]} {FitGbtPrg/TX_Data_from_packager[60]} {FitGbtPrg/TX_Data_from_packager[61]} {FitGbtPrg/TX_Data_from_packager[62]} {FitGbtPrg/TX_Data_from_packager[63]} {FitGbtPrg/TX_Data_from_packager[64]} {FitGbtPrg/TX_Data_from_packager[65]} {FitGbtPrg/TX_Data_from_packager[66]} {FitGbtPrg/TX_Data_from_packager[67]} {FitGbtPrg/TX_Data_from_packager[68]} {FitGbtPrg/TX_Data_from_packager[69]} {FitGbtPrg/TX_Data_from_packager[70]} {FitGbtPrg/TX_Data_from_packager[71]} {FitGbtPrg/TX_Data_from_packager[72]} {FitGbtPrg/TX_Data_from_packager[73]} {FitGbtPrg/TX_Data_from_packager[74]} {FitGbtPrg/TX_Data_from_packager[75]} {FitGbtPrg/TX_Data_from_packager[76]} {FitGbtPrg/TX_Data_from_packager[77]} {FitGbtPrg/TX_Data_from_packager[78]} {FitGbtPrg/TX_Data_from_packager[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 12 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 2 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCIDsync_Mode][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCIDsync_Mode][1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 12 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[BCID_from_CRU_corrected][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][15]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][16]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][17]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][18]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][19]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][20]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][21]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][22]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][23]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][24]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][25]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][26]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][27]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][28]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][29]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][30]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 2 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[CRU_Readout_Mode][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[CRU_Readout_Mode][1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 2 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Readout_Mode][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Readout_Mode][1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][15]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][16]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][17]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][18]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][19]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][20]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][21]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][22]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][23]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][24]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][25]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][26]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][27]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][28]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][29]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][30]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[ORBIT_from_CRU_corrected][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][15]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][16]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][17]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][18]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][19]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][20]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][21]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][22]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][23]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][24]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][25]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][26]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][27]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][28]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][29]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][30]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Trigger_from_CRU][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][cntr_fifo_count][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][cntr_fifo_count][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][cntr_fifo_count][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][cntr_fifo_count][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][cntr_fifo_count][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][cntr_fifo_count][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][cntr_fifo_count][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][cntr_fifo_count][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 3 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[rx_phase][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[rx_phase][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[rx_phase][2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list FitGbtPrg/CRU_ORBC_Gen_comp/cont_trg_bunch_mask_comp]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][gbtRx_ErrorDet]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][gbtRx_ErrorLatch]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][gbtRx_Ready]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][mgtLinkReady]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][Rx_Phase_error]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][tx_fsmResetDone]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][txOutClkFabric]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Start_run]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[Stop_run]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list FitGbtPrg/CRU_ORBC_Gen_comp/is_send_single_trg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list FitGbtPrg/CRU_ORBC_Gen_comp/is_sentd_cont_trg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list FitGbtPrg/CRU_ORBC_Gen_comp/is_trigger_sending]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list FitGbtPrg/RX_IsData_DataClk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list FitGbtPrg/RX_IsData_from_orbcgen]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list FitGbtPrg/TX_IsData_from_packager]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 6 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list ipbus_module/clocks/pll/inst/clkout1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 12 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq_hboffset][11]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 16 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_freq][15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 32 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][15]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][16]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][17]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][18]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][19]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][20]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][21]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][22]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][23]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][24]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][25]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][26]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][27]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][28]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][29]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][30]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][bunch_pattern][31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 32 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][15]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][16]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][17]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][18]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][19]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][20]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][21]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][22]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][23]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][24]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][25]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][26]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][27]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][28]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][29]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][30]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][trigger_resp_mask][31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 2 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][usage_generator][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Data_Gen][usage_generator][1]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 2 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][Readout_command][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][Readout_command][1]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 16 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][DET_Field][15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe7]
set_property port_width 16 [get_debug_ports u_ila_1/probe7]
connect_debug_port u_ila_1/probe7 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][FEE_ID][15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe8]
set_property port_width 16 [get_debug_ports u_ila_1/probe8]
connect_debug_port u_ila_1/probe8 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[RDH_data][PAR][15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe9]
set_property port_width 16 [get_debug_ports u_ila_1/probe9]
connect_debug_port u_ila_1/probe9 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq][15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe10]
set_property port_width 12 [get_debug_ports u_ila_1/probe10]
connect_debug_port u_ila_1/probe10 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][bunch_freq_hboffset][11]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe11]
set_property port_width 32 [get_debug_ports u_ila_1/probe11]
connect_debug_port u_ila_1/probe11 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][15]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][16]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][17]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][18]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][19]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][20]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][21]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][22]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][23]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][24]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][25]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][26]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][27]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][28]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][29]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][30]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_cont_value][31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe12]
set_property port_width 64 [get_debug_ports u_ila_1/probe12]
connect_debug_port u_ila_1/probe12 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][15]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][16]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][17]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][18]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][19]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][20]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][21]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][22]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][23]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][24]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][25]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][26]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][27]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][28]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][29]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][30]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][31]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][32]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][33]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][34]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][35]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][36]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][37]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][38]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][39]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][40]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][41]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][42]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][43]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][44]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][45]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][46]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][47]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][48]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][49]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][50]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][51]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][52]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][53]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][54]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][55]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][56]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][57]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][58]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][59]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][60]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][61]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][62]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_pattern][63]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe13]
set_property port_width 32 [get_debug_ports u_ila_1/probe13]
connect_debug_port u_ila_1/probe13 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][15]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][16]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][17]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][18]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][19]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][20]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][21]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][22]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][23]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][24]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][25]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][26]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][27]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][28]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][29]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][30]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][trigger_single_val][31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe14]
set_property port_width 2 [get_debug_ports u_ila_1/probe14]
connect_debug_port u_ila_1/probe14 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][usage_generator][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[Trigger_Gen][usage_generator][1]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe15]
set_property port_width 12 [get_debug_ports u_ila_1/probe15]
connect_debug_port u_ila_1/probe15 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[crutrg_delay_comp][11]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe16]
set_property port_width 16 [get_debug_ports u_ila_1/probe16]
connect_debug_port u_ila_1/probe16 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[max_data_payload][15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe17]
set_property port_width 12 [get_debug_ports u_ila_1/probe17]
connect_debug_port u_ila_1/probe17 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[n_BCID_delay][11]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe18]
set_property port_width 32 [get_debug_ports u_ila_1/probe18]
connect_debug_port u_ila_1/probe18 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][0]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][1]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][2]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][3]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][4]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][5]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][6]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][7]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][8]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][9]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][10]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][11]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][12]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][13]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][14]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][15]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][16]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][17]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][18]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][19]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][20]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][21]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][22]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][23]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][24]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][25]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][26]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][27]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][28]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][29]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][30]} {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[trg_data_select][31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe19]
set_property port_width 13 [get_debug_ports u_ila_1/probe19]
connect_debug_port u_ila_1/probe19 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][ftmipbus_fifo_count][12]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe20]
set_property port_width 1 [get_debug_ports u_ila_1/probe20]
connect_debug_port u_ila_1/probe20 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[is_hb_response]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe21]
set_property port_width 1 [get_debug_ports u_ila_1/probe21]
connect_debug_port u_ila_1/probe21 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[readout_bypass]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe22]
set_property port_width 1 [get_debug_ports u_ila_1/probe22]
connect_debug_port u_ila_1/probe22 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[reset_drophit_counter]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe23]
set_property port_width 1 [get_debug_ports u_ila_1/probe23]
connect_debug_port u_ila_1/probe23 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[reset_gbt]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe24]
set_property port_width 1 [get_debug_ports u_ila_1/probe24]
connect_debug_port u_ila_1/probe24 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[reset_gbt_rxerror]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe25]
set_property port_width 1 [get_debug_ports u_ila_1/probe25]
connect_debug_port u_ila_1/probe25 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[reset_gen_offset]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe26]
set_property port_width 1 [get_debug_ports u_ila_1/probe26]
connect_debug_port u_ila_1/probe26 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[reset_orbc_synd]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe27]
set_property port_width 1 [get_debug_ports u_ila_1/probe27]
connect_debug_port u_ila_1/probe27 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[reset_rxph_error]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe28]
set_property port_width 1 [get_debug_ports u_ila_1/probe28]
connect_debug_port u_ila_1/probe28 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/Control_register_reg_dc[strt_rdmode_lock]}]]
create_debug_core u_ila_2 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_2]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_2]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_2]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_2]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_2]
set_property C_INPUT_PIPE_STAGES 6 [get_debug_cores u_ila_2]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_2]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_2]
set_property port_width 1 [get_debug_ports u_ila_2/clk]
connect_debug_port u_ila_2/clk [get_nets [list CDMClkpllcomp/inst/CLK_OUT2_320]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe0]
set_property port_width 13 [get_debug_ports u_ila_2/probe0]
connect_debug_port u_ila_2/probe0 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][slct_fifo_count][12]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe1]
set_property port_width 13 [get_debug_ports u_ila_2/probe1]
connect_debug_port u_ila_2/probe1 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][raw_fifo_count][12]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe2]
set_property port_width 12 [get_debug_ports u_ila_2/probe2]
connect_debug_port u_ila_2/probe2 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_bc_hdrop][11]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe3]
set_property port_width 10 [get_debug_ports u_ila_2/probe3]
connect_debug_port u_ila_2/probe3 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[fifo_status][trg_fifo_count][9]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe4]
set_property port_width 32 [get_debug_ports u_ila_2/probe4]
connect_debug_port u_ila_2/probe4 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][15]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][16]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][17]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][18]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][19]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][20]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][21]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][22]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][23]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][24]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][25]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][26]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][27]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][28]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][29]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][30]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][first_orbit_hdrop][31]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe5]
set_property port_width 32 [get_debug_ports u_ila_2/probe5]
connect_debug_port u_ila_2/probe5 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][15]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][16]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][17]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][18]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][19]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][20]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][21]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][22]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][23]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][24]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][25]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][26]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][27]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][28]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][29]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][30]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][hits_skipped][31]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe6]
set_property port_width 12 [get_debug_ports u_ila_2/probe6]
connect_debug_port u_ila_2/probe6 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_bc_hdrop][11]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe7]
set_property port_width 32 [get_debug_ports u_ila_2/probe7]
connect_debug_port u_ila_2/probe7 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][15]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][16]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][17]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][18]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][19]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][20]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][21]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][22]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][23]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][24]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][25]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][26]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][27]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][28]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][29]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][30]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_converter][last_orbit_hdrop][31]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe8]
set_property port_width 12 [get_debug_ports u_ila_2/probe8]
connect_debug_port u_ila_2/probe8 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_bc_hdrop][11]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe9]
set_property port_width 32 [get_debug_ports u_ila_2/probe9]
connect_debug_port u_ila_2/probe9 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][15]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][16]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][17]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][18]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][19]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][20]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][21]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][22]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][23]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][24]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][25]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][26]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][27]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][28]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][29]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][30]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][first_orbit_hdrop][31]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe10]
set_property port_width 16 [get_debug_ports u_ila_2/probe10]
connect_debug_port u_ila_2/probe10 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_send_porbit][15]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe11]
set_property port_width 32 [get_debug_ports u_ila_2/probe11]
connect_debug_port u_ila_2/probe11 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][15]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][16]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][17]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][18]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][19]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][20]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][21]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][22]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][23]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][24]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][25]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][26]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][27]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][28]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][29]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][30]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][hits_skipped][31]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe12]
set_property port_width 12 [get_debug_ports u_ila_2/probe12]
connect_debug_port u_ila_2/probe12 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_bc_hdrop][11]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe13]
set_property port_width 32 [get_debug_ports u_ila_2/probe13]
connect_debug_port u_ila_2/probe13 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][0]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][1]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][2]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][3]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][4]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][5]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][6]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][7]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][8]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][9]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][10]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][11]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][12]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][13]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][14]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][15]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][16]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][17]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][18]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][19]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][20]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][21]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][22]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][23]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][24]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][25]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][26]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][27]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][28]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][29]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][30]} {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[hits_rd_counter_selector][last_orbit_hdrop][31]}]]
create_debug_core u_ila_3 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_3]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_3]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_3]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_3]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_3]
set_property C_INPUT_PIPE_STAGES 6 [get_debug_cores u_ila_3]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_3]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_3]
set_property port_width 1 [get_debug_ports u_ila_3/clk]
connect_debug_port u_ila_3/clk [get_nets [list {FitGbtPrg/gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/cpllpd_wait_reg[95]__0_4}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe0]
set_property port_width 1 [get_debug_ports u_ila_3/probe0]
connect_debug_port u_ila_3/probe0 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][mgt_phalin_cplllock]}]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe1]
set_property port_width 1 [get_debug_ports u_ila_3/probe1]
connect_debug_port u_ila_3/probe1 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][rxFrameClkReady]}]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe2]
set_property port_width 1 [get_debug_ports u_ila_3/probe2]
connect_debug_port u_ila_3/probe2 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][rxWordClkReady]}]]
create_debug_core u_ila_4 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_4]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_4]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_4]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_4]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_4]
set_property C_INPUT_PIPE_STAGES 6 [get_debug_cores u_ila_4]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_4]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_4]
set_property port_width 1 [get_debug_ports u_ila_4/clk]
connect_debug_port u_ila_4/clk [get_nets [list {FitGbtPrg/gbtBankDsgn/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/cpllpd_wait_reg[95]__0_5}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_4/probe0]
set_property port_width 1 [get_debug_ports u_ila_4/probe0]
connect_debug_port u_ila_4/probe0 [get_nets [list {FIT_TESTMODULE_IPBUS_sender_comp/FIT_GBT_status[GBT_status][tx_resetDone]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets TESTM_status[GBT_status][txWordClk]]
