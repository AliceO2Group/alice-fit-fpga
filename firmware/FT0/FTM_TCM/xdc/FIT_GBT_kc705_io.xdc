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

