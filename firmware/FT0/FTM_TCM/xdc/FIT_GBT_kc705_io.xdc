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

set_property IOSTANDARD LVCMOS25 [get_ports SCOPE]
set_property PACKAGE_PIN E28 [get_ports SCOPE]

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


set_property MARK_DEBUG true [get_nets IsRxData_rxclk_from_GBT]
connect_debug_port u_ila_0/probe1 [get_nets [list IsRxData_rxclk_from_GBT]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 3 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list CDMClkpllcomp/inst/CLK_OUT1_40]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 80 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {Data_from_FITrd[0]} {Data_from_FITrd[1]} {Data_from_FITrd[2]} {Data_from_FITrd[3]} {Data_from_FITrd[4]} {Data_from_FITrd[5]} {Data_from_FITrd[6]} {Data_from_FITrd[7]} {Data_from_FITrd[8]} {Data_from_FITrd[9]} {Data_from_FITrd[10]} {Data_from_FITrd[11]} {Data_from_FITrd[12]} {Data_from_FITrd[13]} {Data_from_FITrd[14]} {Data_from_FITrd[15]} {Data_from_FITrd[16]} {Data_from_FITrd[17]} {Data_from_FITrd[18]} {Data_from_FITrd[19]} {Data_from_FITrd[20]} {Data_from_FITrd[21]} {Data_from_FITrd[22]} {Data_from_FITrd[23]} {Data_from_FITrd[24]} {Data_from_FITrd[25]} {Data_from_FITrd[26]} {Data_from_FITrd[27]} {Data_from_FITrd[28]} {Data_from_FITrd[29]} {Data_from_FITrd[30]} {Data_from_FITrd[31]} {Data_from_FITrd[32]} {Data_from_FITrd[33]} {Data_from_FITrd[34]} {Data_from_FITrd[35]} {Data_from_FITrd[36]} {Data_from_FITrd[37]} {Data_from_FITrd[38]} {Data_from_FITrd[39]} {Data_from_FITrd[40]} {Data_from_FITrd[41]} {Data_from_FITrd[42]} {Data_from_FITrd[43]} {Data_from_FITrd[44]} {Data_from_FITrd[45]} {Data_from_FITrd[46]} {Data_from_FITrd[47]} {Data_from_FITrd[48]} {Data_from_FITrd[49]} {Data_from_FITrd[50]} {Data_from_FITrd[51]} {Data_from_FITrd[52]} {Data_from_FITrd[53]} {Data_from_FITrd[54]} {Data_from_FITrd[55]} {Data_from_FITrd[56]} {Data_from_FITrd[57]} {Data_from_FITrd[58]} {Data_from_FITrd[59]} {Data_from_FITrd[60]} {Data_from_FITrd[61]} {Data_from_FITrd[62]} {Data_from_FITrd[63]} {Data_from_FITrd[64]} {Data_from_FITrd[65]} {Data_from_FITrd[66]} {Data_from_FITrd[67]} {Data_from_FITrd[68]} {Data_from_FITrd[69]} {Data_from_FITrd[70]} {Data_from_FITrd[71]} {Data_from_FITrd[72]} {Data_from_FITrd[73]} {Data_from_FITrd[74]} {Data_from_FITrd[75]} {Data_from_FITrd[76]} {Data_from_FITrd[77]} {Data_from_FITrd[78]} {Data_from_FITrd[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 80 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {FitGbtPrg/RX_Data_DataClk[0]} {FitGbtPrg/RX_Data_DataClk[1]} {FitGbtPrg/RX_Data_DataClk[2]} {FitGbtPrg/RX_Data_DataClk[3]} {FitGbtPrg/RX_Data_DataClk[4]} {FitGbtPrg/RX_Data_DataClk[5]} {FitGbtPrg/RX_Data_DataClk[6]} {FitGbtPrg/RX_Data_DataClk[7]} {FitGbtPrg/RX_Data_DataClk[8]} {FitGbtPrg/RX_Data_DataClk[9]} {FitGbtPrg/RX_Data_DataClk[10]} {FitGbtPrg/RX_Data_DataClk[11]} {FitGbtPrg/RX_Data_DataClk[12]} {FitGbtPrg/RX_Data_DataClk[13]} {FitGbtPrg/RX_Data_DataClk[14]} {FitGbtPrg/RX_Data_DataClk[15]} {FitGbtPrg/RX_Data_DataClk[16]} {FitGbtPrg/RX_Data_DataClk[17]} {FitGbtPrg/RX_Data_DataClk[18]} {FitGbtPrg/RX_Data_DataClk[19]} {FitGbtPrg/RX_Data_DataClk[20]} {FitGbtPrg/RX_Data_DataClk[21]} {FitGbtPrg/RX_Data_DataClk[22]} {FitGbtPrg/RX_Data_DataClk[23]} {FitGbtPrg/RX_Data_DataClk[24]} {FitGbtPrg/RX_Data_DataClk[25]} {FitGbtPrg/RX_Data_DataClk[26]} {FitGbtPrg/RX_Data_DataClk[27]} {FitGbtPrg/RX_Data_DataClk[28]} {FitGbtPrg/RX_Data_DataClk[29]} {FitGbtPrg/RX_Data_DataClk[30]} {FitGbtPrg/RX_Data_DataClk[31]} {FitGbtPrg/RX_Data_DataClk[32]} {FitGbtPrg/RX_Data_DataClk[33]} {FitGbtPrg/RX_Data_DataClk[34]} {FitGbtPrg/RX_Data_DataClk[35]} {FitGbtPrg/RX_Data_DataClk[36]} {FitGbtPrg/RX_Data_DataClk[37]} {FitGbtPrg/RX_Data_DataClk[38]} {FitGbtPrg/RX_Data_DataClk[39]} {FitGbtPrg/RX_Data_DataClk[40]} {FitGbtPrg/RX_Data_DataClk[41]} {FitGbtPrg/RX_Data_DataClk[42]} {FitGbtPrg/RX_Data_DataClk[43]} {FitGbtPrg/RX_Data_DataClk[44]} {FitGbtPrg/RX_Data_DataClk[45]} {FitGbtPrg/RX_Data_DataClk[46]} {FitGbtPrg/RX_Data_DataClk[47]} {FitGbtPrg/RX_Data_DataClk[48]} {FitGbtPrg/RX_Data_DataClk[49]} {FitGbtPrg/RX_Data_DataClk[50]} {FitGbtPrg/RX_Data_DataClk[51]} {FitGbtPrg/RX_Data_DataClk[52]} {FitGbtPrg/RX_Data_DataClk[53]} {FitGbtPrg/RX_Data_DataClk[54]} {FitGbtPrg/RX_Data_DataClk[55]} {FitGbtPrg/RX_Data_DataClk[56]} {FitGbtPrg/RX_Data_DataClk[57]} {FitGbtPrg/RX_Data_DataClk[58]} {FitGbtPrg/RX_Data_DataClk[59]} {FitGbtPrg/RX_Data_DataClk[60]} {FitGbtPrg/RX_Data_DataClk[61]} {FitGbtPrg/RX_Data_DataClk[62]} {FitGbtPrg/RX_Data_DataClk[63]} {FitGbtPrg/RX_Data_DataClk[64]} {FitGbtPrg/RX_Data_DataClk[65]} {FitGbtPrg/RX_Data_DataClk[66]} {FitGbtPrg/RX_Data_DataClk[67]} {FitGbtPrg/RX_Data_DataClk[68]} {FitGbtPrg/RX_Data_DataClk[69]} {FitGbtPrg/RX_Data_DataClk[70]} {FitGbtPrg/RX_Data_DataClk[71]} {FitGbtPrg/RX_Data_DataClk[72]} {FitGbtPrg/RX_Data_DataClk[73]} {FitGbtPrg/RX_Data_DataClk[74]} {FitGbtPrg/RX_Data_DataClk[75]} {FitGbtPrg/RX_Data_DataClk[76]} {FitGbtPrg/RX_Data_DataClk[77]} {FitGbtPrg/RX_Data_DataClk[78]} {FitGbtPrg/RX_Data_DataClk[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list FitGbtPrg/RX_IsData_DataClk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list IsData_from_FITrd]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets GPIO_SMA_J13_OBUF]
