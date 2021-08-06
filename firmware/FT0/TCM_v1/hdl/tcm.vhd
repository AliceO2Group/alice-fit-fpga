----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2017 12:57:41 PM
-- Design Name: 
-- Module Name: tcm - combined
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


package HDMI_pkg is
    type HDMI_trig is array (9 downto 0) of std_logic_vector (3 downto 0);
    type Trgdat is array (9 downto 0) of std_logic_vector (31 downto 0);
end package;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.HDMI_pkg.all;
use work.ipbus.ALL;


entity tcm is
 Port (CLKA_P : in STD_LOGIC;
       CLKA_N : in STD_LOGIC;
       CLKC_P : in STD_LOGIC;
       CLKC_N : in STD_LOGIC;
       HDMIA0_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA0_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA1_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA1_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA2_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA2_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA3_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA3_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA4_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA4_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA5_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA5_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA6_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA6_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA7_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA7_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA8_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA8_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA9_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIA9_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC0_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC0_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC1_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC1_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC2_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC2_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC3_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC3_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC4_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC4_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC5_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC5_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC6_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC6_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC7_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC7_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC8_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC8_N : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC9_P : in STD_LOGIC_VECTOR (3 downto 0);
       HDMIC9_N : in STD_LOGIC_VECTOR (3 downto 0);
       SELA : out STD_LOGIC_VECTOR (9 downto 0);
       SELC : out STD_LOGIC_VECTOR (9 downto 0);
       SCKA : out STD_LOGIC_VECTOR (9 downto 0);
       SCKC : out STD_LOGIC_VECTOR (9 downto 0);
       MOSIA : out STD_LOGIC_VECTOR (9 downto 0);
       MOSIC : out STD_LOGIC_VECTOR (9 downto 0);
       MISOA : in STD_LOGIC_VECTOR (9 downto 0);
       MISOC : in STD_LOGIC_VECTOR (9 downto 0);
       Vertex_P : out STD_LOGIC;
       Vertex_N : out STD_LOGIC;
       OrA_P : out STD_LOGIC;
       OrA_N : out STD_LOGIC;
       OrB_P : out STD_LOGIC;
       OrB_N : out STD_LOGIC;
       SC_P : out STD_LOGIC;
       SC_N : out STD_LOGIC;
       C_P : out STD_LOGIC;
       C_N : out STD_LOGIC;
       LAS_P : out STD_LOGIC;
       LAS_N : out STD_LOGIC;
       LCLK_P : in STD_LOGIC;
       LCLK_N : in STD_LOGIC;  
       RST : in STD_LOGIC;
       IRQ : out STD_LOGIC;
       CS :  in STD_LOGIC;
       SCK :  in STD_LOGIC;
       MOSI :  in STD_LOGIC;
       MISO :  out STD_LOGIC;
       LA0 : out  STD_LOGIC_VECTOR (15 downto 0);
       LA1 : out  STD_LOGIC_VECTOR (15 downto 0);
       LA2 : out  STD_LOGIC_VECTOR (15 downto 0);
       LA3 : out  STD_LOGIC_VECTOR (15 downto 0);
       LACK0 : out  STD_LOGIC; 
       LACK1 : out  STD_LOGIC; 
       LACK2 : out  STD_LOGIC; 
       LACK3 : out  STD_LOGIC;
       LED :  out  STD_LOGIC_VECTOR (7 downto 0);
       MGTCLK_P : in  STD_LOGIC;
       MGTCLK_N : in  STD_LOGIC;
       GBT_RX_P : in  STD_LOGIC;
       GBT_RX_N : in  STD_LOGIC;
       GBT_TX_P : out  STD_LOGIC;
       GBT_TX_N : out  STD_LOGIC;
       ETHCLK_P : in  STD_LOGIC;
       ETHCLK_N : in  STD_LOGIC;
       ETH_RX_P : in  STD_LOGIC;
       ETH_RX_N : in  STD_LOGIC;
       ETH_TX_P : out  STD_LOGIC;
       ETH_TX_N : out  STD_LOGIC;
       FSEL : out  STD_LOGIC;
       FMOSI : out  STD_LOGIC;
       FMISO : in  STD_LOGIC 
        );
end tcm;

architecture RTL of tcm is

type spi_arr is array (19 downto 0) of std_logic_vector (31 downto 0);
type Tout_arr is array (4 downto 0) of std_logic_vector (31 downto 0);
type cou_arr is array (14 downto 0) of std_logic_vector (31 downto 0);
type rdout_conf_arr is array (11 downto 0) of std_logic_vector (31 downto 0);
type rdout_stat_arr is array (7 downto 0) of std_logic_vector (31 downto 0);

signal HDMIA_P, HDMIA_N, HDMIC_P, HDMIC_N, TDA_P, TDA_N, TDC_P, TDC_N  : HDMI_trig;
signal TDA, TDC, TDC0, TDC1, TDC2 : Trgdat;
signal hdmia_config, hdmic_config, Status_A, Status_C, f_out, f_inp, l_mode, l_patt0, l_patt1, Orbit_ID, flash_data_out, t_stmp, rout_buf, mcu_ts, bc_corrl, bc_corrA, bc_corrC : STD_LOGIC_VECTOR (31 downto 0);
signal trig_mod: STD_LOGIC_VECTOR (14 downto 0);
signal trg_r_wr : STD_LOGIC_VECTOR (4 downto 0);
signal trg_r : Tout_arr;
signal count_r : cou_arr;
signal Tout_sel, Tmode_sel : STD_LOGIC;
signal CLK320A, CLK320C, Vertex, Vertex_0, OrA_i, OrC_i, OrA,S, OrC, SC, SC_0, C, C_0, B_rdy, B_rdy0, B_rdy1, B_rdy2, B_rdy3, OrC_B, OrC_B0, OrC_B1, OrC_B2, reset, rsti, lasi, irqi, mgtclk, clka, clkc, LCLK, LCLKI : STD_LOGIC;
signal clksys40 : std_logic;
signal CSi, MOSIi, MISOi, SCKi :  STD_LOGIC; 
signal bitcnt_A, bitcnt_C : STD_LOGIC_VECTOR (2 downto 0);
signal Tcnt_cnt : STD_LOGIC_VECTOR (3 downto 0);
signal Thigh, Tlow  : STD_LOGIC_VECTOR (9 downto 0);
signal Tdiff : STD_LOGIC_VECTOR (9 downto 0);
signal selai, selci, sckai, sckci, mosiai, mosici, misoai, misoci, reqA, reqC, reqA2, reqA1, reqA0, reqC2, reqC1, reqC0 : STD_LOGIC_VECTOR (9 downto 0);
signal PM_rq : STD_LOGIC_VECTOR (19 downto 0);
signal spi_bit_count : STD_LOGIC_VECTOR (4 downto 0);
signal spi_addr, spi_wr_addr : STD_LOGIC_VECTOR (8 downto 0);
signal spi_rd, spi_wr_rdy, spi_wr0, spi_wr1, spi_wr2, spi_wr_req, spi_na, rd_lock_spi : STD_LOGIC;
signal SPI_DATA, spi_wr_data : STD_LOGIC_VECTOR (15 downto 0);
signal LA0I, LA1I, LA2I, LA3I : STD_LOGIC_VECTOR (15 downto 0);
signal LACK0I,LACK1I,LACK2I,LACK3I : STD_LOGIC;
signal ledi : STD_LOGIC_VECTOR (7 downto 0);
signal ipb_clk, ipb_rst, ipb_str, ipb_iswr, ipb_isrd, ipb_wr, tcmx_select, tcmr_select, tcmr_ack, clk200, dly_rdy, tcmx_ack, tcmx_err, tcmx_wr, tcmr_wr, tcmx_rd_ack : std_logic;
signal mac_addr: std_logic_vector(47 downto 0);
signal ip_addr, ipb_addr, ipb_data_out, ipb_data_in, local_reg_rd, cnt_ctrl_data : std_logic_vector(31 downto 0);
signal ipb_out: ipb_wbus;
signal ipb_in: ipb_rbus;
signal ipb_leds : STD_LOGIC_VECTOR (1 downto 0);
signal ipb_stp : std_logic :='1';
signal TX_CLK, RX_CLK, GBT_is_TXD, GBT_is_RXD, GBTRX_ready, RX_err, RX_err1, rxerr0, txled0, rxled0, IsRXData0, GBTRX_ready0, GBTRX_ready1, GBTRX_ready2, t100ms, TXact, RXact, GBT_rdy, GBT_rdy0, GBT_chg, GBTRXerr, GBTRXerr_ipb, ipb_stat_rd, IPB_rdy0, IPB_chg : std_logic;
signal GBT_TX_D, GBT_RX_D :  STD_LOGIC_VECTOR (79 downto 0);
signal cou_100ms :  STD_LOGIC_VECTOR (21 downto 0);
signal spi_buf_out, mem_out_ipb : STD_LOGIC_VECTOR (15 downto 0);
signal sreset, dcs_irq, vect_clr, vect_clr_req, spibuf_wr, spibuf_wr0, spibuf_wr1, spibuf_wr2, spibuf_rd, spibuf_rd0, spibuf_rd1, spibuf_rd2, ibuf_wrena, sbuf_wrena, buf_lock, buf_lock0, buf_lock1, buf_lock2, sbuf_ena, sbuf_rdena, rd_lock_a, rd_lock_c  : STD_LOGIC;
signal irq_clr, stat_clr, stat_clr0, stat_clr1, rst_spi0, rst_spi1, rst_spi2 : STD_LOGIC;
signal rstcount : STD_LOGIC_VECTOR (6 downto 0);
signal buf_vector, rd_buf_vector, trigs : STD_LOGIC_VECTOR (4 downto 0);
signal irq_cnt, buf_b : STD_LOGIC_VECTOR (1 downto 0);
signal SC_A, C_A, SC_C, C_C, Treg_data : STD_LOGIC_VECTOR (15 downto 0); 
signal AmplA, AmplC, AmplC0, AmplC1, AmplC2 : STD_LOGIC_VECTOR (16 downto 0);
signal AmplS : STD_LOGIC_VECTOR (17 downto 0);
signal Treg_addr : STD_LOGIC_VECTOR (2 downto 0);
signal TimeC, TimeC0, TimeC1, TimeC2, TimeA : STD_LOGIC_VECTOR (8 downto 0);
signal TimeA_o, TimeC_o :  STD_LOGIC_VECTOR (15 downto 0);
signal AvgA, AvgC : STD_LOGIC_VECTOR (13 downto 0);
signal TresbM, TdiffM : STD_LOGIC_VECTOR (23 downto 0);
signal hdmiac_select, hdmicc_select, hdmias_select, hdmics_select, pll_lock_a, pll_lock_c, hdmis_ack, mul_ena, mul_enc, sideA_OK, sideC_OK, stat_clrA, stat_clrC, as_chg, cs_chg, rst_fl, as_blk, cs_blk, hdmi_to0, hdmi_to : STD_LOGIC;
signal PM_tcou :  STD_LOGIC_VECTOR (23 downto 0);
signal dly_rst, cnt_rd, pm_adr_sel, pm_rdy, cnt_ctrl_sel, cnt_ctrl_rdy, ipb_locked, cnt_clr, cnt_lock, Tcnt_sel, Tcnt_0_rd, cnt_lock0, cnt_lock1, cnt_lock2, Tcnt_clr, cnt_clr0, cnt_clr1, cnt_clr2, Tcnt_ack, Tcnt_err : STD_LOGIC;
signal fifo_sel, fifo_csel, f_rd, f_empty, f_wr, f_full, lclk160, lmode_sel, lpatt0_sel, lpatt1_sel, l_on, l_on0, l_on1, l_tg1, l_tg, l_fbin, l_fbout, a_t, a0_t, an_t : STD_LOGIC;
signal l_cnt : STD_LOGIC_VECTOR (1 downto 0);
signal f_cnt : STD_LOGIC_VECTOR (9 downto 0);
signal spi_bus_in : spi_arr; 
signal pm_select, pm_rdy_a : STD_LOGIC_VECTOR (19 downto 0);
signal lpatt_cnt, Nchan_A, Nchan_C, Nchan_C0, Nchan_C1, Nchan_C2 : STD_LOGIC_VECTOR (6 downto 0);
signal lpatt_sreg : STD_LOGIC_VECTOR (63 downto 0);
signal lfreq_cnt : STD_LOGIC_VECTOR (23 downto 0);
signal BC_cou : STD_LOGIC_VECTOR(11 downto 0);
signal ldr : STD_LOGIC_VECTOR(3 downto 0);
signal Tmode : STD_LOGIC_VECTOR(7 downto 0);
signal Rd_word, FIFO_in : STD_LOGIC_VECTOR(159 downto 0);
signal gbt_wr, gbt_empty, rdoutc_sel, rdoutc_ack, rdoutc_wr, rdouts_sel, RST_req : STD_LOGIC;
signal readout_control_reg :  ctrl_reg_t;
signal readout_status_reg :  stat_reg_t;
signal New_BCID : STD_LOGIC;
signal las_o, l_st, flshreg_sel, bkgndA, bkgndC, bkgndC0, bkgndC1, bkgndC2, bgA_inc, bgC_inc, bgOr, bgAnd, orA_str, orA_cnt, orC_cnt, Or_or, Or_and, Bg_Aclr, Bg_Cclr, Bg_Orclr, Bg_Andclr, sca, scc, ca, cc, scb, cb : STD_LOGIC;
signal tstamp_sel, d_rd, d_rdy, adc_sel, adc_sel1, rout_lock0, rout_lock1, rout_lock2, PM_rst, cctrl_rst, clk_src, clk_l, clk_frs, mcuts_sel, pmena_sel, pm_err, bccorr_sel, bccorr_ack, corr_inc, SC_str, CC_str, V_str : STD_LOGIC;
signal bccorrA_sel, bccorrC_sel, bccorr_ack0, bccorr_rd : STD_LOGIC; 
signal d_addr : STD_LOGIC_VECTOR(6 DOWNTO 0);
signal d_sns : STD_LOGIC_VECTOR(15 DOWNTO 0);

signal rx_phase_status : std_logic_vector(3 downto 0);
signal laser_t0, laser_t : std_logic;
signal pm_ena : std_logic_vector(19 downto 0) := x"00000";

component tcm_side is
 Port (CLKA : in STD_LOGIC;
        RST : in STD_LOGIC;
        SRST : in STD_LOGIC;
        TD_P : in HDMI_trig;
        TD_N : in HDMI_trig;
        Config : in STD_LOGIC_VECTOR (31 downto 0);
        Status : out STD_LOGIC_VECTOR (31 downto 0);
        Stat_adr : in STD_LOGIC_VECTOR (3 downto 0);
        stat_clr : in STD_LOGIC;
        stat_chg : in STD_LOGIC;
        side_OK : out STD_LOGIC;
        TDD : out Trgdat;
        rd_lock : in STD_LOGIC;
        Or_o : out STD_LOGIC;
        CLK320_o : out STD_LOGIC;
        clksys40_o : out std_logic;
        pll_lock : out STD_LOGIC;
        mt_cou_o : out STD_LOGIC_VECTOR (2 downto 0);
        Time_o : out STD_LOGIC_VECTOR (15 downto 0);
        Ampl_o : out STD_LOGIC_VECTOR (16 downto 0);
        Avg_o : out STD_LOGIC_VECTOR (13 downto 0);
        Nchan : out STD_LOGIC_VECTOR (6 downto 0);
        req : out STD_LOGIC_VECTOR (9 downto 0);
        bkgnd : out STD_LOGIC 
        );
end component;

COMPONENT MULADD
  PORT (
    A : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    C : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    SUBTRACT : IN STD_LOGIC;
    P : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    PCOUT : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
  );
END COMPONENT;

COMPONENT MULT14xS16
  PORT (
    CLK : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    CE : IN STD_LOGIC;
    P : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT; 
 
 
 component IPBUS_basex_infra is
	port(
		eth_clk_p: in std_logic; -- 125MHz MGT clock
		eth_clk_n: in std_logic;
		eth_rx_p: in std_logic; -- Ethernet MGT input
		eth_rx_n: in std_logic;
		eth_tx_p: out std_logic; -- Ethernet MGT output
		eth_tx_n: out std_logic;
		clk_ipb_o: out std_logic; -- IPbus clock
		rst_ipb_o: out std_logic;
		RESET : in std_logic; -- The signal of doom
		leds: out std_logic_vector(1 downto 0); -- status LEDs
		mac_addr: in std_logic_vector(47 downto 0); -- MAC address
		ip_addr: in std_logic_vector(31 downto 0); -- IP address
		ipb_in: in ipb_rbus; -- ipbus
		ipb_out: out ipb_wbus;
		clk200:  out std_logic;
		locked:  out std_logic
		);
end component;
	

  component FLASH
    generic (   
    clk_freq  :   integer
     ); 
     PORT (
    rst : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_out : out STD_LOGIC_VECTOR(31 DOWNTO 0);
    A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    wr_flshreg : IN STD_LOGIC;
    rd_flshreg : IN STD_LOGIC;
    flshreg_sel : IN STD_LOGIC;
    FSEL : out  STD_LOGIC;
    FMOSI : out  STD_LOGIC;
    FMISO : in  STD_LOGIC
     );
  END COMPONENT;

component counter32
 Port (clk320 : in STD_LOGIC;
       cout : out STD_LOGIC_VECTOR (31 downto 0);
       rd : in STD_LOGIC;
       clr : in STD_LOGIC;
       inc : in STD_LOGIC
       );
end component;        

component BC_correlator is
    Port ( clk320  : in STD_LOGIC;
           BC_cou : in STD_LOGIC_VECTOR (11 downto 0);
           mt_cou : in STD_LOGIC_VECTOR (2 downto 0);
           inc : in STD_LOGIC; 
           clr : in STD_LOGIC;
           ipb_clk : in STD_LOGIC;
           rd : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (11 downto 0);
           data : out STD_LOGIC_VECTOR (31 downto 0)
           );
end component;

   -- ###############################################
   -- #########  GBT Readout ########################
   -- ###############################################
   signal readout_status : readout_status_t;
   signal readout_control : readout_control_t;
           
   signal Data_from_FITrd             : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
   signal IsData_from_FITrd        : STD_LOGIC;

   
   signal RxData_rxclk_from_GBT     : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
   signal IsRxData_rxclk_from_GBT    : STD_LOGIC;
   
   signal TCM_data_toreadout		:  board_data_type;
   
   signal gbt_global_status : std_logic_vector(3 downto 0);
   signal readout_laser_out, readout_laser_out_ff0, readout_laser_out_ff1 : std_logic;
   
   component FIT_GBT_project is
       generic (
           GENERATE_GBT_BANK    : integer := 1
       );
   
       Port (        
           RESET_I                : in  STD_LOGIC;
           SysClk_I             : in  STD_LOGIC; -- 320MHz system clock
           DataClk_I             : in  STD_LOGIC; -- 40MHz data clock
           MgtRefClk_I         : in  STD_LOGIC; -- 200MHz ref clock
           RxDataClk_I            : in STD_LOGIC; -- 40MHz data clock in RX domain
           GBT_RxFrameClk_O    : out STD_LOGIC; --Rx GBT frame clk 40MHz
           
           Board_data_I        : in board_data_type; --PM or TCM data
           Control_register_I    : in readout_control_t;
           
           MGT_RX_P_I         : in  STD_LOGIC;
           MGT_RX_N_I         : in  STD_LOGIC;
           MGT_TX_P_O         : out  STD_LOGIC;
           MGT_TX_N_O        : out  STD_LOGIC;
           MGT_TX_dsbl_O     : out  STD_LOGIC;
           
           -- GBT data to/from FIT readout 
           RxData_rxclk_to_FITrd_I     : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
           IsRxData_rxclk_to_FITrd_I    : in  STD_LOGIC;
           Data_from_FITrd_O             : out  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
           IsData_from_FITrd_O            : out  STD_LOGIC;
           
           -- GBT data to/from GBT project
           Data_to_GBT_I     : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
           IsData_to_GBT_I    : in  STD_LOGIC;
           RxData_rxclk_from_GBT_O     : out  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
           IsRxData_rxclk_from_GBT_O    : out  STD_LOGIC;
   
           -- FIT readour status, including BCOR_ID to PM/TCM
           readout_status_o : out readout_status_t
       );
   end component;
   -- ###############################################
   -- ###############################################
   -- ###############################################





COMPONENT Xmega_buf
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

 component pm_spi is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DI : in STD_LOGIC_VECTOR (31 downto 0);
           DO : out STD_LOGIC_VECTOR (31 downto 0);
           A : in STD_LOGIC_VECTOR (8 downto 0);
           wr  : in STD_LOGIC;
           rd : in STD_LOGIC;
           cs : in STD_LOGIC;
           rdy : out STD_LOGIC;
           spi_sel : out STD_LOGIC;
           spi_clk : out STD_LOGIC;
           spi_mosi : out STD_LOGIC;
           spi_miso : in STD_LOGIC;
           cnt_rd : in STD_LOGIC;
           PM_rst : in STD_LOGIC;
           ena : in STD_LOGIC
           );
           
   end component; 
   
   component cnt_ctrl is
   Port (CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DI : in STD_LOGIC_VECTOR (31 downto 0);
           DO : out STD_LOGIC_VECTOR (31 downto 0);
           A : in STD_LOGIC_VECTOR (3 downto 0);
           wr  : in STD_LOGIC;
           rd : in STD_LOGIC;
           cs : in STD_LOGIC;
           rdy : out STD_LOGIC;
           cnt_rd : out STD_LOGIC
            );
   end component;

   component trigger_out is 
   Port (clk320 : in STD_LOGIC;
        T_in : in STD_LOGIC;
        T_out : out STD_LOGIC;
        mode : in STD_LOGIC_VECTOR (2 downto 0);
        ipb_clk : in STD_LOGIC;
        DI : in STD_LOGIC_VECTOR (31 downto 0);
        DO : out STD_LOGIC_VECTOR (31 downto 0);
        CO : out STD_LOGIC_VECTOR (31 downto 0);
        A : in STD_LOGIC;
        wr  : in STD_LOGIC;
        c_rd  : in STD_LOGIC;
        c_clr  : in STD_LOGIC;
        mt_cnt : in STD_LOGIC_VECTOR (2 downto 0);
        T_r : out STD_LOGIC
        );
   end component;
   
   COMPONENT COUNTER_FIFO
     PORT (
       clk : IN STD_LOGIC;
       srst : IN STD_LOGIC;
       din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       wr_en : IN STD_LOGIC;
       rd_en : IN STD_LOGIC;
       dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
       full : OUT STD_LOGIC;
       empty : OUT STD_LOGIC;
       data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
     );
   END COMPONENT;
   
   component LCLK_PLL
   port
    (
     clkfb_in          : in     std_logic;
     clkfb_out         : out    std_logic;
     LCLK160          : out    std_logic;
     reset           : in     std_logic;
     clk40           : in     std_logic
    );
   end component;

     COMPONENT SENSOR
     PORT (
       di_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
       daddr_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
       den_in : IN STD_LOGIC;
       dwe_in : IN STD_LOGIC;
       drdy_out : OUT STD_LOGIC;
       do_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
       dclk_in : IN STD_LOGIC;
       reset_in : IN STD_LOGIC;
       vp_in : IN STD_LOGIC;
       vn_in : IN STD_LOGIC;
       channel_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
       eoc_out : OUT STD_LOGIC;
       alarm_out : OUT STD_LOGIC;
       eos_out : OUT STD_LOGIC;
       busy_out : OUT STD_LOGIC
     );
   END COMPONENT;


attribute IODELAY_GROUP : STRING;
attribute IODELAY_GROUP of IDL1: label is "TCM_DLY";

   attribute mark_debug                        : string;
  attribute mark_debug of Data_from_FITrd : signal is "true";
  attribute mark_debug of IsData_from_FITrd     : signal is "true";

begin

HDMIA_P(0)<=HDMIA0_P; HDMIA_N(0)<=HDMIA0_N; HDMIC_P(0)<=HDMIC0_P; HDMIC_N(0)<=HDMIC0_N;
HDMIA_P(1)<=HDMIA1_P; HDMIA_N(1)<=HDMIA1_N; HDMIC_P(1)<=HDMIC1_P; HDMIC_N(1)<=HDMIC1_N;
HDMIA_P(2)<=HDMIA2_P; HDMIA_N(2)<=HDMIA2_N; HDMIC_P(2)<=HDMIC2_P; HDMIC_N(2)<=HDMIC2_N;
HDMIA_P(3)<=HDMIA3_P; HDMIA_N(3)<=HDMIA3_N; HDMIC_P(3)<=HDMIC3_P; HDMIC_N(3)<=HDMIC3_N;
HDMIA_P(4)<=HDMIA4_P; HDMIA_N(4)<=HDMIA4_N; HDMIC_P(4)<=HDMIC4_P; HDMIC_N(4)<=HDMIC4_N;
HDMIA_P(5)<=HDMIA5_P; HDMIA_N(5)<=HDMIA5_N; HDMIC_P(5)<=HDMIC5_P; HDMIC_N(5)<=HDMIC5_N;
HDMIA_P(6)<=HDMIA6_P; HDMIA_N(6)<=HDMIA6_N; HDMIC_P(6)<=HDMIC6_P; HDMIC_N(6)<=HDMIC6_N;
HDMIA_P(7)<=HDMIA7_P; HDMIA_N(7)<=HDMIA7_N; HDMIC_P(7)<=HDMIC7_P; HDMIC_N(7)<=HDMIC7_N;
HDMIA_P(8)<=HDMIA8_P; HDMIA_N(8)<=HDMIA8_N; HDMIC_P(8)<=HDMIC8_P; HDMIC_N(8)<=HDMIC8_N;
HDMIA_P(9)<=HDMIA9_P; HDMIA_N(9)<=HDMIA9_N; HDMIC_P(9)<=HDMIC9_P; HDMIC_N(9)<=HDMIC9_N;


GTEBUF: IBUFDS_GTE2 port map(i => MGTCLK_P,	ib => MGTCLK_N,	o => mgtclk, ceb => '0');
CLKA0: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>CLKA_P, IB=>CLKA_N, O=>CLKA); 
CLKC0: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS_25")
port map (I=>CLKC_P, IB=>CLKC_N, O=>CLKC); 
CLKL0: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>LCLK_P, IB=>LCLK_N, O=>LCLKI);  
LB0 : BUFIO
port map (O => LCLK, I => LCLKI);

HDMIAIN:  for j in 0 to 9 generate
HDMIAIN0: for i in 0 to 3 generate

HDMIAINF: if (j/=5) or (i/=1) generate
HDMIAIN1: IBUFDS_DIFF_OUT
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (O=>TDA_P(j)(i), OB=>TDA_N(j)(i), I=>HDMIA_P(j)(i), IB=>HDMIA_N(j)(i));
end generate;

HDMIAINR: if (j=5) and (i=1) generate
HDMIAIN2: IBUFDS_DIFF_OUT
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (O=>TDA_N(j)(i), OB=>TDA_P(j)(i), I=>HDMIA_P(j)(i), IB=>HDMIA_N(j)(i));
end generate;

end generate;
end generate;  

HDMIC0IN:  for j in 0 to 9 generate
HDMIC0IN0: for i in 0 to 1 generate
HDMIC0IN1: IBUFDS_DIFF_OUT
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS_25")
port map (O=>TDC_P(j)(i), OB=>TDC_N(j)(i), I=>HDMIC_P(j)(i), IB=>HDMIC_N(j)(i));
end generate;
end generate; 
	
HDMIC1IN:  for j in 0 to 9 generate
HDMIC1IN0: for i in 2 to 3 generate
HDMIC1IN1: IBUFDS_DIFF_OUT
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (O=>TDC_P(j)(i), OB=>TDC_N(j)(i), I=>HDMIC_P(j)(i), IB=>HDMIC_N(j)(i));
end generate;
end generate; 

VTX1: OBUFDS generic map (IOSTANDARD => "LVDS", SLEW => "FAST")
            port map (O=>Vertex_P, OB=>Vertex_N, I=>Vertex);         
ORA1: OBUFDS generic map (IOSTANDARD => "LVDS", SLEW => "FAST")
                      port map (O=>ORA_P, OB=>ORA_N, I=>OrA);
ORB1: OBUFDS generic map (IOSTANDARD => "LVDS", SLEW => "FAST")
                      port map (O=>ORB_P, OB=>ORB_N, I=>OrC);         
SC1: OBUFDS generic map (IOSTANDARD => "LVDS", SLEW => "FAST")
                      port map (O=>SC_P, OB=>SC_N, I=>SC);         
C1: OBUFDS generic map (IOSTANDARD => "LVDS", SLEW => "FAST")
                      port map (O=>C_P, OB=>C_N, I=>C);         
LAS1: OBUFDS generic map (IOSTANDARD => "LVDS", SLEW => "FAST")
                      port map (O=>LAS_P, OB=>LAS_N, I=>lasi);         
                      
SPI_IO:  for i in 0 to 9 generate

SPI_sela: OBUF port map (O=>SELA(i), I=>selai(i));
SPI_selB: OBUF port map (O=>SELC(i), I=>selci(i));
SPI_scka: OBUF port map (O=>SCKA(i), I=>sckai(i));
SPI_sckB: OBUF port map (O=>SCKc(i), I=>sckci(i));
SPI_mosia: OBUF port map (O=>MOSIA(i), I=>mosiai(i));
SPI_MOSIC: OBUF port map (O=>MOSIC(i), I=>mosici(i));
SPI_misoa: IBUF port map (O=>misoai(i), I=>MISOA(i));
SPI_misoB: IBUF port map (O=>misoci(i), I=>MISOC(i));
                               
end generate;

cs1:    IBUF port map (O=>csi, I=>CS);
sck1:   IBUF port map (O=>scki, I=>SCK);
mosi1:  IBUF port map (O=>mosii, I=>MOSI);
miso1:  OBUFT port map (O=>MISO, I=>MISOi, T=>CSi);
rst1:   IBUF port map (O=>rsti, I=>RST);
IRQ1:   OBUF port map (O=>IRQ, I=>irqi);

ILA: for i in 0 to 15 generate
ILA0: OBUF
   port map (O => LA0(i), I => LA0I(i) );
ILA1: OBUF
   port map (O => LA1(i), I => LA1I(i) );
ILA2: OBUF
   port map (O => LA2(i), I => LA2I(i) );
ILA3: OBUF
   port map (O => LA3(i), I => LA3I(i) );
end generate;
	
ILACK0: OBUF
   port map (O => LACK0, I => LACK0I);
ILACK1: OBUF
   port map (O => LACK1, I => LACK1I);
ILACK2: OBUF
   port map (O => LACK2, I => LACK2I);
ILACK3: OBUF
   port map (O => LACK3, I => LACK3I);

ledo1: for i in 0 to 7 generate
leso0: OBUF  port map (O => LED(i), I => ledi(i) );
end generate;

ledi(1 downto 0)<= not ipb_leds; 
ledi(2)<=not GBTRX_ready;
ledi(3)<=rxerr0 or (not GBTRX_ready);
ledi(4)<=txled0 or (not GBTRX_ready);                                  
ledi(5)<=rxled0 or (not GBTRX_ready);   
ledi(6)<=not SideA_OK;
ledi(7)<=not SideC_OK;

reset<= not rsti;   


IDL1 : IDELAYCTRL
   port map (
      RDY => dly_rdy,       -- 1-bit output: Ready output
      REFCLK => clk200, -- 1-bit input: Reference clock input
      RST => dly_rst        -- 1-bit input: Active high reset input
   );



-- IP-BUS module ===============================================


ipbus_module:  IPBUS_basex_infra port map(
    eth_clk_p => ethclk_p,
    eth_clk_n => ethclk_n,
    eth_tx_p => eth_tx_p,
    eth_tx_n => eth_tx_n,
    eth_rx_p => eth_rx_p,
    eth_rx_n => eth_rx_n,
    
    clk_ipb_o => ipb_clk,
    rst_ipb_o => ipb_rst,
   
    
    RESET => ipb_stp,
    
    leds => ipb_leds, -- status LEDs
    mac_addr => mac_addr,
    
    ip_addr => ip_addr,
    ipb_in => ipb_in,
    ipb_out => ipb_out,
    clk200 =>clk200,
    locked=>ipb_locked
);

fl_upg: FLASH generic map (clk_freq => 31250 ) 
              port map (rst=>ipb_rst, clk  => ipb_clk, data_in =>ipb_data_out, data_out =>flash_data_out, A =>ipb_addr(1 downto 0), wr_flshreg =>ipb_iswr, rd_flshreg  =>ipb_isrd, flshreg_sel=>flshreg_sel, FSEL =>FSEL, FMOSI =>FMOSI, FMISO =>FMISO); 

TX_CLK<=clksys40;




-- #################################################################################################
-- #################   FIT GBT Readout    ##########################################################
-- #################################################################################################

-- GBT1:  GBT_TX_RX port map (
-- RESET =>RESET,
-- MgtRefClk => mgtclk,
-- MGT_RX_P =>GBT_RX_P,
-- MGT_RX_N =>GBT_RX_N,
-- MGT_TX_P =>GBT_TX_P,
-- MGT_TX_N =>GBT_TX_N,
-- TXDataClk =>TX_CLK,
-- TXData => GBT_TX_D,
-- TXData_SC=>"0000",
-- IsTXData =>GBT_is_TXD,
-- RXDataClk => RX_CLK,
-- RXData =>GBT_RX_D,
-- RXData_SC =>open,
-- IsRXData => GBT_is_RXD,
-- RX_ready=>GBTRX_ready,
-- RX_errors=> RX_err
-- );
                                  
-- FIT GBT project =====================================
FitGbtPrg: FIT_GBT_project
	generic map(
		GENERATE_GBT_BANK	=> 1
	)
	
	Port map(
		RESET_I				=>	sreset,
		SysClk_I			=>	CLK320A,
		DataClk_I			=>	clksys40,
		MgtRefClk_I			=>	MGTCLK,
		RxDataClk_I			=> RX_CLK, -- 40MHz data clock in RX domain (loop back)
		GBT_RxFrameClk_O	=> RX_CLK,
		
		Board_data_I		=> TCM_data_toreadout,
		Control_register_I	=> readout_control,
		
		MGT_RX_P_I			=>	GBT_RX_P,
		MGT_RX_N_I			=>	GBT_RX_N,
		MGT_TX_P_O			=>	GBT_TX_P,
		MGT_TX_N_O			=>	GBT_TX_N,
		MGT_TX_dsbl_O		=>	open,
		
		RxData_rxclk_to_FITrd_I 	=> RxData_rxclk_from_GBT, --loop back data
		IsRxData_rxclk_to_FITrd_I	=> IsRxData_rxclk_from_GBT, --loop back data
		Data_from_FITrd_O 			=> Data_from_FITrd,
		IsData_from_FITrd_O			=> IsData_from_FITrd,
		Data_to_GBT_I 				=> Data_from_FITrd, --loop back data
		IsData_to_GBT_I				=> IsData_from_FITrd, --loop back data
		
		RxData_rxclk_from_GBT_O	 	=> RxData_rxclk_from_GBT,
		IsRxData_rxclk_from_GBT_O	=> IsRxData_rxclk_from_GBT,

		readout_status_o 	=> readout_status
--		GPIO_O => GPIO
		);		
-- =====================================================

GBT_is_RXD <= IsRxData_rxclk_from_GBT;

GBTRX_ready <= readout_status.GBT_status.gbtRx_Ready;
RX_err <= readout_status.GBT_status.gbtRx_ErrorDet;

--PM_data_toreadout.is_header  <=  GBT_is_TXD;
--PM_data_toreadout.is_data    <=  GBT_is_TXD;
--PM_data_toreadout.is_packet  <=  GBT_is_TXD;
--PM_data_toreadout.data_word  <=  GBT_TX_D;

   
readout_control <= func_CNTRREG_getcntrreg(readout_control_reg);
readout_status_reg <= func_STATREG_getaddrreg(readout_status);

gbt_global_status(0) <=  readout_status.GBT_status.Rx_Phase_error;
--gbt_global_status(1) <=  '1' when readout_status.BCIDsync_Mode = mode_LOST else '0';
--gbt_global_status(2) <=  '1' when readout_status.hits_rd_counter_selector.hits_skipped /= x"0000_0000" else '0';
gbt_global_status(3) <=  '0';


process (clksys40)
begin
    if (clksys40'event and clksys40='1') then
         if ( readout_status.BCIDsync_Mode = mode_LOST) then
         gbt_global_status(1) <=  '1';
        else 
         gbt_global_status(1) <=  '0';
        end if;


        if ( readout_status.fsm_errors = x"00") then
         gbt_global_status(2) <=  '0';
        else 
         gbt_global_status(2) <=  '1';
        end if;
        
        if ( readout_status.Trigger_from_CRU and readout_control.Data_Gen.trigger_resp_mask ) /= 0 then
         readout_laser_out <=  '1';
        else 
         readout_laser_out <=  '0';
        end if;
    end if;
end process;
--gbt_global_status <=  x"0";


-- #################################################################################################
-- #################################################################################################





process(CLKA, RESET)
begin
if (RESET='1') then sreset<='1'; rstcount<=(others=>'0'); dly_rst<='0'; else
   if (CLKA'event) and (CLKA='1') then
     if (rstcount=63) then  sreset<='0'; 
      else 
        if ((pll_lock_c and pll_lock_a and ipb_locked)='1') then  
          if (rstcount<=20) or ((rstcount>20) and (dly_rdy='1')) then rstcount<=rstcount+1; end if;
          if (rstcount=16) then dly_rst<='1'; end if;
          if (rstcount=20) then dly_rst<='0'; end if;
        end if; 
       end if;

    end if;
  end if;
end process;

process (TX_CLK)
begin
if (TX_CLK'event and TX_CLK='1') then

GBT_is_TXD<=IsData_from_FITrd;
IsRXData0<=GBT_is_RXD;

if GBTRX_ready='0' then GBT_rdy0<='0'; GBT_rdy<='0';  
   else 
   if (t100ms='1') then  GBT_rdy0<='1'; 
      if  (GBT_rdy0='1') then GBT_rdy<='1'; end if;
    end if;
end if; 


if t100ms='0' then cou_100ms<=cou_100ms+1; 
    if RX_err='1' then RX_err1<='1'; end if; 
    if GBT_is_TXD='1' then TXact<='1'; end if; 
    if IsRXData0='1' then RXact<='1'; end if;  
  else cou_100ms<=(others=>'0'); RX_err1<='0'; TXact<='0'; RXact<='0';
    if (RX_err='1') or (RX_err1='1') then RXerr0<='0'; else RXerr0<='1'; end if; 
    if (GBT_is_TXD='1') or (TXact='1') then txled0<='0'; else txled0<='1'; end if; 
    if (IsRXData0='1') or (RXact='1') then rxled0<='0'; else rxled0<='1'; end if;
   end if;

end if;
end process; 

t100ms <='1' when cou_100ms=3999999 else '0';

PM_SC: for i in 0 to 9 generate
pm_spiA:    pm_spi Port map ( CLK => ipb_clk, RST=> ipb_rst, DI=> ipb_data_out, DO=> spi_bus_in(i), A=> ipb_addr(8 downto 0), wr=> ipb_iswr, rd=> ipb_isrd, cs=> pm_select(i), rdy=> pm_rdy_a(i), spi_sel=> selai(i), spi_clk=> sckai(i),
                          spi_mosi=> mosiai(i), spi_miso=> misoai(i), cnt_rd=> cnt_rd, PM_rst =>PM_rst, ena=> pm_ena(i));		

pm_spiC:    pm_spi Port map ( CLK=> ipb_clk, RST=> ipb_rst, DI=> ipb_data_out, DO=> spi_bus_in(i+10), A=> ipb_addr(8 downto 0), wr=> ipb_iswr, rd=> ipb_isrd, cs=> pm_select(i+10), rdy=> pm_rdy_a(i+10), spi_sel=>selci(i), spi_clk=> sckci(i),
                          spi_mosi=> mosici(i), spi_miso=> misoci(i), cnt_rd=> cnt_rd, PM_rst =>PM_rst, ena=> pm_ena(i+10));
end generate;                         		

cctrl_rst <= ipb_rst or PM_rst;

cnt_ctr:   cnt_ctrl  Port map ( CLK => ipb_clk, RST  => cctrl_rst, DI => ipb_data_out, DO => cnt_ctrl_data, A => ipb_addr(3 downto 0), wr => ipb_iswr, rd => ipb_isrd, cs => cnt_ctrl_sel, rdy => cnt_ctrl_rdy, cnt_rd => cnt_rd);		
                    
Tfifo: COUNTER_FIFO  PORT MAP (clk => ipb_clk, srst => ipb_rst , din =>f_inp ,  wr_en =>f_wr , rd_en =>f_rd , dout =>f_out , full =>f_full , empty =>f_empty , data_count => f_cnt );

f_rd<= fifo_sel and (not f_empty); 
f_wr<= '1' when (Tcnt_cnt/=15) and (f_full='0') and (ipb_rst='0') else '0';
f_inp<= count_r(to_integer(unsigned(Tcnt_cnt))) when (Tcnt_cnt/=15) else (others=>'0');

tcmx_select <= ipb_str when ipb_addr(31 downto 3)= x"0000000" & '0' else '0';
tcmr_select <= ipb_str when ipb_addr(31 downto 3)= x"0000000" & '1' else '0';
hdmias_select <= ipb_str when (ipb_addr(31 downto 4)= x"0000001") and (ipb_addr(3 downto 0)<x"A")  else '0';
hdmiac_select  <= ipb_str when ipb_addr(31 downto 0)= x"0000001A"  else '0';
lmode_sel<= ipb_str when ipb_addr(31 downto 0)= x"0000001B"  else '0';
lpatt0_sel<= ipb_str when ipb_addr(31 downto 0)= x"0000001C"  else '0';
lpatt1_sel<= ipb_str when ipb_addr(31 downto 0)= x"0000001D"  else '0';
pmena_sel<= ipb_str when ipb_addr(31 downto 0)= x"0000001E"  else '0';
hdmics_select <= ipb_str when (ipb_addr(31 downto 4)= x"0000003") and (ipb_addr(3 downto 0)<x"A")  else '0';
hdmicc_select  <= ipb_str when ipb_addr(31 downto 0)= x"0000003A"  else '0';
cnt_ctrl_sel  <= ipb_str when ipb_addr(31 downto 4)= x"0000005"  else '0';
Tout_sel <= ipb_str when (ipb_addr(31 downto 4)= x"0000006") and (ipb_addr(3 downto 0)<x"A") else '0';
Tmode_sel <= ipb_str when ipb_addr(31 downto 0)= x"0000006A"  else '0';
Tcnt_sel <= ipb_str when (ipb_addr(31 downto 4)= x"0000007") and (ipb_addr(3 downto 0)<=x"E")  else '0';
Tcnt_0_rd <= ipb_str when (ipb_addr(31 downto 0)= x"00000070") and (ipb_isrd='1')  else '0';
rdoutc_sel <= ipb_str when (ipb_addr(31 downto 0)>= x"000000D8") and (ipb_addr(31 downto 0)<= x"000000E7") else '0';
rdouts_sel <= ipb_str when (ipb_addr(31 downto 0)>= x"000000E8") and (ipb_addr(31 downto 0)<= x"000000F6") and (ipb_isrd='1') else '0';
mcuts_sel <= ipb_str when  (ipb_addr(31 downto 0)= x"000000F7") and (ipb_isrd='1') else '0';
flshreg_sel <= ipb_str when (ipb_addr(31 downto 2)= x"000000F" & "10") else '0';
fifo_sel <= ipb_str when (ipb_addr(31 downto 0)= x"00000100") and (ipb_isrd='1')  else '0';
fifo_csel <= ipb_str when (ipb_addr(31 downto 0)= x"00000101") and (ipb_isrd='1')  else '0';
pm_adr_sel <= ipb_str when (ipb_addr(31 downto 14)= 0) and (ipb_addr(13 downto 9)/=0) and (ipb_addr(13 downto 9)<=20) else '0' ;
tstamp_sel  <= ipb_str when (ipb_addr(31 downto 0)= x"000000FF") and (ipb_isrd='1') else '0';
adc_sel<= ipb_str when (ipb_addr(31 downto 2)= x"000000F" & "11") and (ipb_isrd='1') and ipb_addr(1 downto 0)/="11" else '0';
bccorr_sel<= ipb_str when (ipb_addr(31 downto 12)= x"00004") and (ipb_isrd='1') else '0';
bccorrA_sel<= ipb_str when (ipb_addr(31 downto 12)= x"00008") and (ipb_isrd='1') else '0';
bccorrC_sel<= ipb_str when (ipb_addr(31 downto 12)= x"0000C") and (ipb_isrd='1') else '0';

PM_sel: for i in 0 to 19 generate
pm_select(i)<= (pm_adr_sel and pm_ena(i)) when (ipb_addr(13 downto 9)= i+1) else '0';  

end generate; 

Trout_sel: for i in 0 to 4 generate
trg_r_wr(i)<= Tout_sel and ipb_iswr when (ipb_addr(3 downto 1)= i) else '0';  
end generate; 

ipb_data_out<=ipb_out.ipb_wdata; ipb_addr<=ipb_out.ipb_addr;
ipb_in.ipb_rdata<=ipb_data_in; 
  
ipb_iswr<=ipb_out.ipb_write and ipb_out.ipb_strobe; ipb_isrd<=(not ipb_out.ipb_write) and ipb_out.ipb_strobe; 

ipb_str<=ipb_out.ipb_strobe; ipb_wr<= ipb_out.ipb_write; 

pm_rdy<=pm_rdy_a(to_integer(unsigned(ipb_addr(14 downto 9)))-1);
pm_err<=not pm_ena(to_integer(unsigned(ipb_addr(14 downto 9)))-1);

ipb_in.ipb_ack<= tcmx_ack when (tcmx_select='1') 
else tcmr_ack when (tcmr_select='1')
else '1' when (hdmiac_select='1') or (hdmicc_select='1') or (flshreg_sel='1') 
else hdmis_ack when (hdmias_select='1') or (hdmics_select='1')
else cnt_ctrl_rdy when (cnt_ctrl_sel='1')
else pm_rdy when (pm_adr_sel='1')
else '1' when ((Tout_sel or Tmode_sel)='1')
else Tcnt_ack when (Tcnt_sel='1')
else '1' when  (rdoutc_sel='1')
else '1' when  (rdouts_sel='1')
else '1' when (fifo_sel or fifo_csel or lmode_sel or lpatt0_sel or lpatt1_sel or tstamp_sel or mcuts_sel or pmena_sel) ='1'
else d_rdy when (adc_sel='1')
else bccorr_ack when (bccorr_rd='1')
else '0';

ipb_in.ipb_err<= tcmx_err when (tcmx_select='1') 
else Tcnt_err when (Tcnt_sel='1')
else pm_err when (pm_adr_sel='1')
else '0';
 
 
 
ipb_data_in<= x"0000" & mem_out_ipb  when (tcmx_select='1') and (ipb_isrd='1')
else local_reg_rd when (tcmr_select='1') and (ipb_isrd='1')
else Status_a when  ((hdmias_select='1') or (hdmiac_select='1')) and (ipb_isrd='1')
else l_mode when  (lmode_sel='1') and (ipb_isrd='1')
else l_patt0 when  (lpatt0_sel='1') and (ipb_isrd='1')
else l_patt1 when  (lpatt1_sel='1') and (ipb_isrd='1')
else x"000" & pm_ena when  (pmena_sel='1') and (ipb_isrd='1')
else Status_C when  ((hdmics_select='1') or (hdmicc_select='1')) and (ipb_isrd='1')
else cnt_ctrl_data when (cnt_ctrl_sel='1') and (ipb_isrd='1')
else trg_r(to_integer(unsigned(ipb_addr(3 downto 1)))) when  (Tout_sel='1') and (ipb_isrd='1') and (ipb_addr(3 downto 0)<x"A")
else x"0000" & '0' & trig_mod when (Tmode_sel='1') and (ipb_isrd='1')
else count_r(to_integer(unsigned(ipb_addr(3 downto 0)))) when (Tcnt_sel='1') and (ipb_isrd='1')
else readout_control_reg(to_integer(unsigned(ipb_addr(5 downto 0)))-16#18#) when (rdoutc_sel='1') and (ipb_isrd='1')
else mcu_ts when (mcuts_sel='1')
else rout_buf when (rdouts_sel='1') 
else f_out when (fifo_sel='1')
else x"00000" & "00" & f_cnt when (fifo_csel='1')
else spi_bus_in(to_integer(unsigned(ipb_addr(13 downto 9)))-1) when (pm_adr_sel='1') and (ipb_isrd='1')
else flash_data_out when (flshreg_sel='1')  and (ipb_isrd='1')
else t_stmp when (tstamp_sel='1')
else x"0000" & d_sns when (adc_sel='1')
else bc_corrl when (bccorr_sel='1')
else bc_corrA when (bccorrA_sel='1')
else bc_corrC when (bccorrC_sel='1')
else (others =>'0'); 

with ipb_addr(2 downto 0) select 
local_reg_rd<= x"0000" & std_logic_vector(resize(signed(Tlow),16)) when "000", 
               x"0000" & std_logic_vector(resize(signed(Thigh),16)) when "001",
               x"0000" & SC_A when "010",
               x"0000" & SC_C when "011",
               x"0000" & C_A when "100",
               x"0000" & C_C when "101",
               x"0000" & x"00" & Tmode when "110",
               PM_rq & RST_req & clk_l & gbt_global_status & GBTRXerr_ipb & GBTRX_ready & clk_src & rst_fl & pll_lock_c & pll_lock_a when "111";
 
Tcnt_clr<= ipb_str when (ipb_addr(31 downto 0)= x"0000000F") and (ipb_iswr='1') and (ipb_data_out(9)='1') else '0';

rd_lock_a <= '1' when (hdmias_select='1') and (ipb_isrd='1') else '0';
rd_lock_c <= '1' when (hdmics_select='1') and (ipb_isrd='1') else '0';    


Tcnt_ack<= '1' when (ipb_isrd='1') else '0';
Tcnt_err<= '1' when (ipb_iswr='1') else '0';

tcmx_ack<= '1' when ((tcmx_wr='1')and (sbuf_wrena='0'))  or (tcmx_rd_ack='1') else '0';  
tcmx_err<='1' when (ipb_addr(2 downto 0)>4) and (ipb_iswr='1') else '0';
tcmx_wr<='1'  when (tcmx_select='1') and (ipb_addr(2 downto 0)<5) and (ipb_iswr='1') else '0';
tcmr_wr<='1'  when (tcmr_select='1') and (ipb_iswr='1') else '0';

tcmr_ack<= not spi_wr_req when (ipb_iswr='1') else '1';

ipb_stat_rd<= '1' when (ipb_isrd='1') and (tcmr_select='1') and (ipb_addr(2 downto 0)= 7) else '0';

hdmis_ack<= '1' when (ipb_isrd='1') else '0';


stat_clrA<=hdmiac_select and ipb_isrd;
stat_clrC<=hdmicc_select and ipb_isrd;
UA2 : USR_ACCESSE2   port map (CFGCLK => open, DATA => t_stmp, DATAVALID => open );

SNS : SENSOR  PORT MAP ( di_in => (others=>'0'), daddr_in => d_addr, den_in => d_rd, dwe_in => '0', drdy_out => d_rdy, do_out => d_sns, dclk_in => ipb_clk,
             reset_in => ipb_rst, vp_in => '0', vn_in => '0', channel_out => open,  eoc_out => open, alarm_out => open, eos_out => open, busy_out => open);

d_addr<="00000" & ipb_addr(1 downto 0);

d_rd<= adc_sel  and not adc_sel1;


Lclk0: LCLK_PLL port map (clkfb_in=> l_fbin, clkfb_out=> l_fbout, LCLK160 => LCLK160, reset => reset, clk40 => CLKA);

lclk_fbH : BUFH  port map ( O => l_fbin, I => L_fbout);

process(CLKA)
begin
if (CLKA'event) and (CLKA='1') then

a_t<=not a_t; l_on1<=l_on0; l_on0 <= l_st;  
readout_laser_out_ff0 <= readout_laser_out;
readout_laser_out_ff1 <= readout_laser_out_ff0;

 if (l_mode(31)='0') then  lfreq_cnt<=(others=>'0'); lpatt_cnt<=(others=>'0');
  else
   if (lfreq_cnt=1) and (lpatt_cnt(6 downto 1)=0) then lfreq_cnt<=l_mode(23 downto 0); lpatt_sreg<=l_patt1 & l_patt0; lpatt_cnt<="1000000";  
     else 
       lfreq_cnt<=lfreq_cnt-1; 
       if  (lpatt_cnt/=0) then lpatt_cnt<=lpatt_cnt-1;  lpatt_sreg<=lpatt_sreg(62 downto 0) & '0'; end if;
    end if;
  end if;        
end if;
end process;

l_st<= readout_laser_out_ff1 when (l_mode(31)='0') else lpatt_sreg(63);

process (LCLK160)
begin
if (LCLK160'event and LCLK160='0') then an_t<=a_t; end if;
end process;

 process (LCLK160)
begin
if (LCLK160'event and LCLK160='1') then 

a0_t<=an_t; l_tg1<=l_tg;

 l_tg<=l_on and (not l_tg1);
 las_o<=l_on and (not l_tg1);

 if (a0_t XOR an_t)='1' then l_cnt<="10"; else l_cnt<=l_cnt+1; end if;

 if (ldr(1 downto 0)=l_cnt) then
    case ldr(3 downto 2) is
    when "00" => l_on<= l_st;
    when "01" => l_on<= l_on0;
    when "10" => l_on<= l_on1;
    when others => l_on<='0';
    end case;  
 end if;

end if;
end process;

process(LCLK)
begin
if (LCLK'event and LCLK='1') then
                                  
lasi<=las_o;
                                  
end if;
end process;

tcma: tcm_side port map(CLKA=>CLKA,  RST=>reset, SRST=>sreset, TD_P=>TDA_P, TD_N=>TDA_N, Config=>hdmia_config, Status=>Status_a, stat_adr=> ipb_addr(3 downto 0), stat_clr=>stat_clrA, stat_chg=>as_blk, side_OK=>sideA_OK, TDD=>TDA, rd_lock=> rd_lock_a,
                         Or_o=>OrA_i, CLK320_o=>CLK320A, clksys40_o => clksys40, pll_lock=> pll_lock_a, mt_cou_o=>bitcnt_A, Time_o=>TimeA_o, Avg_o=>AvgA, Ampl_O=>AmplA, Nchan=> Nchan_A, req=> reqA, bkgnd=> bkgndA);

tcmc: tcm_side port map(CLKA=>CLKC,  RST=>reset, SRST=>sreset, TD_P=>TDC_P, TD_N=>TDC_N, Config=>hdmic_config, Status=>Status_C, stat_adr=> ipb_addr(3 downto 0), stat_clr=>stat_clrC, stat_chg=>cs_blk, side_OK=>sideC_OK, TDD=>TDC0, rd_lock=> rd_lock_c, 
                        Or_o=>OrC_B, CLK320_o=>CLK320C, clksys40_o=> open, pll_lock=> pll_lock_c, mt_cou_o=>bitcnt_c, Time_o=>TimeC_o, Avg_o=>AvgC, Ampl_o=>AmplC0, Nchan=> Nchan_C0, req=> reqC, bkgnd=> bkgndC0);

TresbM<=TimeC(8) & TimeC & "00000000000000";
Tdiff<=TdiffM(23 downto 14); 

            
MULA:  MULADD  PORT MAP (A => AvgA, B => TimeA_o, C => TresbM, SUBTRACT => '1',    P => TdiffM,    PCOUT => open);
MULA1: MULT14xS16  PORT MAP (clk => CLK320A, A => AvgA, B => TimeA_o, CE=>mul_ena, P => TimeA);
MULC: MULT14xS16  PORT MAP (clk => CLK320C, A => AvgC, B => TimeC_o, CE=>mul_enc, P => TimeC0);
 
mul_enc<= '1' when (bitcnt_c="001") else '0';  mul_ena<= '1' when (bitcnt_a="001") else '0';



process (SCKi, CSi)
begin
if (CSi='1') then spi_bit_count<="00000"; spibuf_wr<='0'; spi_wr_rdy<='0'; spibuf_rd<='0'; spi_na<='0';  else

if (SCKi'event and SCKi='0') then MISOI<=SPI_DATA(15); end if;

if (SCKi'event and SCKi='1') then 
        if (spi_bit_count="11111") then spi_bit_count<="10000"; spi_na<='1';
          if  (spi_rd='0') then spi_wr_data<=SPI_DATA(14 downto 0) & MOSII;  
            case to_integer(unsigned(spi_addr(7 downto 0))) is
            
            when 16#0# to 16#6# =>  spi_wr_rdy<='1';
            when 16#10# to 16#17# =>  spibuf_wr<='1';
            when 16#18# => ldr <= SPI_DATA(2 downto 0) & MOSIi; 
                           if (SPI_DATA(11)='1') then clk_src<= SPI_DATA(8) or SPI_DATA(9); clk_l <= SPI_DATA(10); end if; 
            
             when 16#F0# => ipb_stp<='1'; ip_addr(15 downto 0)<=SPI_DATA(14 downto 0) & MOSIi;
             when 16#F1# => ip_addr(31 downto 16)<=SPI_DATA(14 downto 0) & MOSIi;
             when 16#F2# => mac_addr(15 downto 0)<=SPI_DATA(14 downto 0) & MOSIi;
             when 16#F3# => mac_addr(31 downto 16)<=SPI_DATA(14 downto 0) & MOSIi;
             when 16#F4# => ipb_stp<='0'; mac_addr(47 downto 32)<=SPI_DATA(14 downto 0) & MOSIi;
             when 16#F5# => mcu_ts(15 downto 0)<=SPI_DATA(14 downto 0) & MOSIi;
             when 16#F6# => mcu_ts(31 downto 16)<=SPI_DATA(14 downto 0) & MOSIi;
             when others => null;
             end case;
          end if;
           else
           spi_bit_count<=spi_bit_count+1;
          end if;
       
        if (spi_bit_count="10000") then spi_wr_rdy<='0'; spibuf_wr<='0'; if (spi_rd='0') and (spi_na='1') then spi_addr <= spi_addr+1; end if; end if;
        if (spi_bit_count="00000") then spi_rd <= MOSIi; end if;
        if (spi_bit_count="01001") then spi_addr <= SPI_DATA(7 downto 0) & MOSIi; end if;
        if (spi_bit_count(3 downto 0)="1110") and (spi_rd='1') and (spi_addr(7 downto 3) = "00010") then spibuf_rd<='1'; end if; 

         if (rd_lock_spi='1') then  spibuf_rd<='0'; spi_addr <= spi_addr+1; 
       
          case to_integer(unsigned(spi_addr(7 downto 0))) is
            when 0 => SPI_DATA<=std_logic_vector(resize(signed(Tlow),16)); 
            when 1 => SPI_DATA<=std_logic_vector(resize(signed(Thigh),16));
            when 2 => SPI_DATA<= SC_A; 
            when 3 => SPI_DATA<= SC_C; 
            when 4 => SPI_DATA<= C_A;
            when 5 => SPI_DATA<= C_C; 
            when 6 => SPI_DATA<=x"00" & Tmode;
                        
            when 16#10# to 16#17# => SPI_DATA<=spi_buf_out;
            when 16#18# => SPI_DATA<= x"000" & ldr;
            when 16#7F#  => SPI_DATA<= "0000" & RST_req & clk_frs & dcs_irq & "00" & ipb_leds(0) & GBTRXerr & GBTRX_ready & "00" & pll_lock_c & pll_lock_a;

            when 16#F0# =>  SPI_DATA<=ip_addr(15 downto 0);
            when 16#F1# =>  SPI_DATA<=ip_addr(31 downto 16);
            when 16#F2# =>  SPI_DATA<=mac_addr(15 downto 0);
            when 16#F3# =>  SPI_DATA<=mac_addr(31 downto 16);
            when 16#F4# =>  SPI_DATA<=mac_addr(47 downto 32);
            when 16#F5# =>  SPI_DATA<=mcu_ts(15 downto 0);
            when 16#F6# =>  SPI_DATA<=mcu_ts(31 downto 16);
            when 16#F8#  => SPI_DATA<=x"00" & "000" & rd_buf_vector;
            when others => SPI_DATA<=x"0000";
          end case;
        else SPI_DATA<=SPI_DATA(14 downto 0) & MOSII; 
        end if;
         
end if;
end if;
end process;

rd_lock_spi <= '1' when (spi_bit_count(3 downto 0)=x"F") and (spi_rd='1') and (spi_addr(8)='0') else '0';
buf_lock <= '1' when (spi_bit_count(3 downto 0)=x"A") and (spi_rd='1') and (spi_addr='0' & x"F8") else '0';
irq_clr <= '1' when (spi_bit_count="10000") and (spi_rd='1') and (spi_addr='0' & x"80") else '0';

irqi<=  dcs_irq or IPB_chg or GBT_chg or GBTRXerr or RST_req when (irq_cnt="11") else '0';

PM_rst <= rst_spi2 and (not rst_spi1); 

bccorr_rd<= bccorr_sel or bccorrA_sel or bccorrC_sel; bccorr_ack<=bccorr_ack0 and bccorr_rd;

hdmi_to0<='1' when (PM_tcou/=15625000) else '0';
as_blk<=as_chg or hdmi_to; cs_blk<=cs_chg or hdmi_to;

process(ipb_clk)
begin
if (ipb_clk'event and ipb_clk='1') then

if (bccorr_ack0='0') and (bccorr_rd='1') then bccorr_ack0<='1'; else  bccorr_ack0<='0'; end if;

adc_sel1<=adc_sel and not d_rdy;

for i in 0 to 9 loop 

reqA2(i)<=reqA1(i);  reqA1(i)<=reqA0(i); reqA0(i)<=reqA(i);
reqC2(i)<=reqC1(i);  reqC1(i)<=reqC0(i); reqC0(i)<=reqC(i);

if (reqA2(i)='0') and (reqA1(i)='1') then PM_rq(i)<='1';
 else
  if (ipb_stat_rd='1') then PM_rq(i)<='0'; end if;
end if;

if (reqC2(i)='0') and (reqC1(i)='1') then PM_rq(i+10)<='1';
 else
  if (ipb_stat_rd='1') then PM_rq(i+10)<='0'; end if;
end if;

end loop; 

GBTRX_ready0<=GBTRX_ready; GBTRX_ready1 <=GBTRX_ready0; GBTRX_ready2 <=GBTRX_ready1;
IPB_rdy0<=ipb_leds(0);

if (rst_spi1='1') then RST_req<='0'; clk_frs<='0';
  else
   if (tcmr_select='1') and (ipb_iswr='1') and (ipb_addr(2 downto 0)=7) then 
        if (ipb_data_out(11)='1') then RST_req<='1'; end if;
        if (ipb_data_out(10)='1') and (ipb_data_out(11)='1') then clk_frs<='1'; end if;
   end if;
end if;

if (ipb_rst='1') then hdmia_config<=(others=>'0'); hdmic_config<=(others=>'0');
  else
   hdmi_to<=hdmi_to0;
   if (PM_rst='1') then PM_tcou<=(others=>'0');
     else
   if (hdmi_to0='1') then PM_tcou<=PM_tcou+1; end if;  
   end if;
   if (hdmiac_select='1') and (ipb_iswr='1') then hdmia_config<=ipb_data_out; as_chg<='1'; end if;
   if (hdmicc_select='1') and (ipb_iswr='1') then hdmic_config<=ipb_data_out; cs_chg<='1'; end if;
end if;

if (as_chg='1') then as_chg<='0'; end if; if (cs_chg='1') then cs_chg<='0'; end if;

if (Tmode_sel='1') and (ipb_iswr='1') then trig_mod<=ipb_data_out(14 downto 0); end if;
if (rst_spi1='1') then l_mode<=(others=>'0');
  else
       if (lmode_sel='1') and (ipb_iswr='1') then l_mode<=ipb_data_out(31 downto 0); end if;
end if;
if (lpatt0_sel='1') and (ipb_iswr='1') then l_patt0<=ipb_data_out(31 downto 0); end if;
if (lpatt1_sel='1') and (ipb_iswr='1') then l_patt1<=ipb_data_out(31 downto 0); end if;
if (pmena_sel='1') and (ipb_iswr='1') then pm_ena<=ipb_data_out(19 downto 0); end if;

if (rst_spi1='1') or ((GBTRX_ready2='1') and (GBTRX_ready1='0')) then readout_control_reg(0)(22)<='1';
 else
  if (rdoutc_sel='1') and (ipb_iswr='1') then
  if  (ipb_addr(7 downto 0)=16#D8#) then readout_control_reg(0)<= ipb_data_out(31 downto 23) & (ipb_data_out(22) or not GBTRX_ready1) & ipb_data_out(21 downto 0);
    else  
     readout_control_reg(to_integer(unsigned(ipb_addr(7 downto 0)))-16#D8#)<=ipb_data_out(31 downto 0);
  end if; 
 end if;
end if;

if (ipb_leds(0)/=IPB_rdy0) then IPB_chg<='1';
  else 
   if (stat_clr1='1') and (stat_clr='0') then IPB_chg<='0'; end if;
end if;

if (GBTRX_ready/=GBTRX_ready0) then GBT_chg<='1';
  else 
   if (stat_clr1='1') and (stat_clr='0') then GBT_chg<='0'; end if;
end if;

if (GBTRX_ready='1') and (RX_err='1') and (GBT_rdy='1') then GBTRXerr<='1'; GBTRXerr_ipb<='1';
  else 
    if (stat_clr1='1') and (stat_clr='0') then GBTRXerr<='0'; end if;
    if (ipb_stat_rd='1') then GBTRXerr_ipb<='0'; end if;
end if;

if (rst_spi1='1') then rst_fl<='1';
  else 
    if (ipb_stat_rd='1') then rst_fl<='0'; end if;
end if;

 if (stat_clr1='1') and (stat_clr='0') then irq_cnt<="00"; 
   else if (irq_cnt/="11") then irq_cnt<=irq_cnt+1; end if;
 end if; 
 
 if ((tcmx_select and ipb_isrd)='1') then tcmx_rd_ack<= not tcmx_rd_ack; else tcmx_rd_ack<='0'; end if; 

rst_spi2 <= rst_spi1; rst_spi1 <= rst_spi0;  rst_spi0<=sreset or ipb_rst;
spibuf_wr2<=spibuf_wr1; spibuf_wr1<=spibuf_wr0; spibuf_wr0<=spibuf_wr;
spibuf_rd2<=spibuf_rd1; spibuf_rd1<=spibuf_rd0; spibuf_rd0<=spibuf_rd;
stat_clr0<=irq_clr; stat_clr1<=stat_clr0; stat_clr<=stat_clr1;
buf_lock2<=buf_lock1; buf_lock1<=buf_lock0; buf_lock0<=buf_lock;
--gbt_global_status
if rst_spi1='1' then buf_vector<="00000"; buf_b<="11"; dcs_irq<='0'; vect_clr_req<='0';

else 

 if (ibuf_wrena='1') then buf_vector(to_integer(unsigned(ipb_addr(2 downto 0))))<='1'; buf_b<="00"; 
   if (vect_clr='1') then vect_clr_req<='1'; end if;
  else
   vect_clr_req<='0';
   if (vect_clr='1') or (vect_clr_req='1') then rd_buf_vector<=buf_vector; buf_vector<="00000"; end if;
   if (buf_b/="11") then buf_b<=buf_b+1; end if; 
 
 end if;

 if (buf_b="01") then dcs_irq<='1'; 
  else if (stat_clr1='1') and (stat_clr='0') then dcs_irq<='0'; end if;
 end if;

spi_wr2<=spi_wr1; spi_wr1<=spi_wr0; spi_wr0<=spi_wr_rdy;


      if (spi_wr_req='1') or (tcmr_wr='1') then
       case Treg_addr is 
            when "000" => Tlow<=Treg_data(9 downto 0); 
            when "001" => Thigh<=Treg_data(9 downto 0); 
            when "010" => SC_A<=Treg_data; 
            when "011" => SC_C<=Treg_data; 
            when "100" => C_A<=Treg_data; 
            when "101" => C_C<=Treg_data;
            when "110" => Tmode<=Treg_data(7 downto 0);
           when others => null;
         end case;
                                     
        end if;
        
if (ipb_rst='1') then Tcnt_cnt<="1111";
else
 if (cnt_rd='1') and (f_cnt<=495) then Tcnt_cnt<="0000"; 
    else if (Tcnt_cnt/=15) then Tcnt_cnt<=Tcnt_cnt+1; end if;
             
 end if;
end if;        

end if;
end if;
end process;

spi_wr_req<= (not spi_wr2) and spi_wr1;

Treg_addr<=spi_addr(2 downto 0) when (spi_wr_req='1') else ipb_addr(2 downto 0);
Treg_data<= spi_wr_data(15 downto 0) when (spi_wr_req='1')  else ipb_data_out(15 downto 0);

vect_clr<=(not buf_lock2) and buf_lock1; 
sbuf_wrena<=(not spibuf_wr2) and spibuf_wr1; sbuf_rdena<=(not spibuf_rd2) and spibuf_rd1;
ibuf_wrena<=(tcmx_wr and (not sbuf_wrena)); 
sbuf_ena<=sbuf_wrena or sbuf_rdena;


Xmegamem : Xmega_buf PORT MAP (clka => ipb_clk, ena => tcmx_select, wea(0) => ibuf_wrena, addra => ipb_addr(2 downto 0), dina => ipb_data_out(15 downto 0), douta=>mem_out_ipb, clkb => ipb_clk, enb => sbuf_ena, web(0) => sbuf_wrena, addrb => spi_addr(2 downto 0), dinb => spi_wr_data, doutb => spi_buf_out); 

C_orA : trigger_out port map ( clk320 => clk320A,   T_in=>OrA_i, T_out =>OrA, mode=>trig_mod(2 downto 0), ipb_clk=>ipb_clk, DI=>ipb_data_out, DO=>trg_r(0), CO=>count_r(0), A=>ipb_addr(0), wr=>trg_r_wr(0), c_rd=>cnt_lock, c_clr=>cnt_clr, mt_cnt=>bitcnt_A, T_r=>trigs(0));
C_orC : trigger_out port map ( clk320 => clk320A,   T_in=>OrC_i, T_out =>OrC, mode=>trig_mod(5 downto 3), ipb_clk=>ipb_clk, DI=>ipb_data_out, DO=>trg_r(1), CO=>count_r(1), A=>ipb_addr(0), wr=>trg_r_wr(1), c_rd=>cnt_lock, c_clr=>cnt_clr, mt_cnt=>bitcnt_A, T_r=>trigs(1));
C_SC  : trigger_out port map ( clk320 => clk320A,   T_in=>SC_0, T_out =>SC, mode=>trig_mod(8 downto 6), ipb_clk=>ipb_clk, DI=>ipb_data_out, DO=>trg_r(2), CO=>count_r(2), A=>ipb_addr(0), wr=>trg_r_wr(2), c_rd=>cnt_lock, c_clr=>cnt_clr, mt_cnt=>bitcnt_A, T_r=>trigs(2));
C_FC : trigger_out port map ( clk320 => clk320A,   T_in=>C_0, T_out =>C, mode=>trig_mod(11 downto 9), ipb_clk=>ipb_clk, DI=>ipb_data_out, DO=>trg_r(3), CO=>count_r(3), A=>ipb_addr(0), wr=>trg_r_wr(3), c_rd=>cnt_lock, c_clr=>cnt_clr, mt_cnt=>bitcnt_A, T_r=>trigs(3));
C_vertex : trigger_out port map ( clk320 => clk320A,   T_in=>Vertex_0, T_out =>Vertex, mode=>trig_mod(14 downto 12), ipb_clk=>ipb_clk, DI=>ipb_data_out, CO=>count_r(4), DO=>trg_r(4), A=>ipb_addr(0), wr=>trg_r_wr(4), c_rd=>cnt_lock, c_clr=>cnt_clr, mt_cnt=>bitcnt_A, T_r=>trigs(4));
        
bgA_inc<= '1' when (bkgndA='1') and (bitcnt_A="011") else '0';
bgC_inc<= '1' when (bkgndC='1') and (bitcnt_A="011") else '0';
bgAnd<= bgA_inc and bgC_inc; 
bgOr<= bgA_inc or bgC_inc;        

orA_cnt<= '1' when (orA_str='1') and (bitcnt_A="011") else '0';
orC_cnt<= '1' when (OrC_i='1') and (bitcnt_A="011") else '0';

Or_or<= orA_cnt or orC_cnt;
Or_and<= orA_cnt and orC_cnt;
Bg_Aclr<= bgA_inc and not orA_cnt; 
Bg_Cclr<= bgC_inc and not orC_cnt;
Bg_Orclr<= Bg_Aclr or Bg_Cclr;
Bg_Andclr<= Bg_Aclr and Bg_Cclr;

cou_bA: counter32  port map (clk320=> clk320A, cout=> count_r(5), rd=> cnt_lock, clr=> cnt_clr, inc=> bgA_inc);
cou_bC: counter32  port map (clk320=> clk320A, cout=> count_r(6), rd=> cnt_lock, clr=> cnt_clr, inc=> bgC_inc);
cou_bAnd: counter32  port map (clk320=> clk320A, cout=> count_r(7), rd=> cnt_lock, clr=> cnt_clr, inc=> bgAnd);
cou_bor: counter32  port map (clk320=> clk320A, cout=> count_r(8), rd=> cnt_lock, clr=> cnt_clr, inc=> bgOr);
cou_oror: counter32  port map (clk320=> clk320A, cout=> count_r(9), rd=> cnt_lock, clr=> cnt_clr, inc=> Or_or);
cou_orand: counter32  port map (clk320=> clk320A, cout=> count_r(10), rd=> cnt_lock, clr=> cnt_clr, inc=> Or_and);
cou_AC: counter32  port map (clk320=> clk320A, cout=> count_r(11), rd=> cnt_lock, clr=> cnt_clr, inc=> bg_Aclr);
cou_CC: counter32  port map (clk320=> clk320A, cout=> count_r(12), rd=> cnt_lock, clr=> cnt_clr, inc=> bg_Cclr);
cou_orc: counter32  port map (clk320=> clk320A, cout=> count_r(13), rd=> cnt_lock, clr=> cnt_clr, inc=> bg_Orclr);
cou_andc: counter32  port map (clk320=> clk320A, cout=> count_r(14), rd=> cnt_lock, clr=> cnt_clr, inc=> bg_Andclr);

with Tmode(7 downto 4) select corr_inc<=
   '0'                                                 when x"0",
   orA_str                                             when x"1",
   orC_i                                               when x"2",
   SC_str                                              when x"3",
   CC_str                                              when x"4",
   V_str                                               when x"5",
   bkgndA                                              when x"6",
   bkgndC                                              when x"7",
   bkgndA and bkgndC                                   when x"8",
   bkgndA or bkgndC                                    when x"9",
   orA_str and  orC_i                                  when x"A",
   orA_str or  orC_i                                   when x"B",
   bkgndA and not orA_str                              when x"C",
   bkgndC and not orC_i                                when x"D",
   (bkgndA and not orA_str) or (bkgndC and not orC_i)  when x"E",
   (bkgndA and not orA_str) and (bkgndC and not orC_i) when x"F";

m_cr: BC_correlator port map(clk320 =>CLK320A, BC_cou =>BC_COU, mt_cou =>bitcnt_A, inc =>corr_inc, clr =>cnt_clr, ipb_clk => ipb_clk, rd =>bccorr_sel, addr =>ipb_addr(11 downto 0), data =>bc_corrl); 
m_crA: BC_correlator port map(clk320 =>CLK320A, BC_cou =>BC_COU, mt_cou =>bitcnt_A, inc =>orA_str, clr =>cnt_clr, ipb_clk => ipb_clk, rd =>bccorrA_sel, addr =>ipb_addr(11 downto 0), data =>bc_corrA); 
m_crC: BC_correlator port map(clk320 =>CLK320A, BC_cou =>BC_COU, mt_cou =>bitcnt_A, inc =>orC_i, clr =>cnt_clr, ipb_clk => ipb_clk, rd =>bccorrC_sel, addr =>ipb_addr(11 downto 0), data =>bc_corrC); 
   
Vertex_0<= '1' when (signed(Tdiff)>=signed(Tlow)) and (signed(Tdiff)<=signed(Thigh))  and (OrA_i='1') and (OrC_i='1') else '0';
          
AmplS<= (AmplA(16) & AmplA) + (AmplC(16) & AmplC); 
         
sca<= '1' when (unsigned(AmplA(15 downto 0))>unsigned(SC_A & '0')) and (AmplA(16)='0') else '0';
scc<= '1' when (unsigned(AmplC(15 downto 0))>unsigned(SC_C & '0')) and (AmplC(16)='0') else '0';
ca<=  '1' when (unsigned(AmplA(15 downto 0))>unsigned(C_A & '0')) and (AmplA(16)='0') else '0';
cc<=  '1' when (unsigned(AmplC(15 downto 0))>unsigned(C_C & '0')) and (AmplC(16)='0') else '0';
scb<= '1' when (unsigned(AmplS(16 downto 0))>unsigned(SC_A & '0')) and (AmplS(17)='0') else '0';
cb<=  '1' when (unsigned(AmplS(16 downto 0))>unsigned(C_A & '0')) and (AmplS(17)='0') else '0';
         
SC_0<=     not C_0  when   (((sca='1') or (Tmode(1)='1')) and ((scc='1') or (Tmode(2)='1')) and (Tmode(2 downto 1)/="11")) or ((scb='1') and Tmode(2 downto 1)="11") else '0';
         
C_0<=        '1'  when   (((ca='1') or (Tmode(1)='1')) and ((cc='1') or (Tmode(2)='1')) and (Tmode(2 downto 1)/="11")) or ((cb='1') and Tmode(2 downto 1)="11") else '0';
               
         
cnt_lock<=(cnt_lock1 and (not cnt_lock2)) or cnt_rd; cnt_clr<=cnt_clr1 and (not cnt_clr2);                            
    
process (CLK320A)
    begin
    if (CLK320A'event and CLK320A='1') then
    
	rx_phase_status(2 downto 0) <= readout_status.rx_phase;
    rx_phase_status(3) <= readout_status.GBT_status.Rx_Phase_error;

laser_t0<=l_on0; laser_t<=laser_t0;     
    
 cnt_lock2<=cnt_lock1; cnt_lock1<=cnt_lock0; cnt_lock0<=Tcnt_0_rd; cnt_clr2<=cnt_clr1; cnt_clr1<=cnt_clr0; cnt_clr0<=Tcnt_clr; 
 rout_lock2<=rout_lock1; rout_lock1<=rout_lock0; rout_lock0<=rdouts_sel and ipb_clk;
 
 if (rout_lock1='1') and (rout_lock2='0') then rout_buf <=readout_status_reg(to_integer(unsigned(ipb_addr(5 downto 0)))-16#28#); end if;

B_rdy3<=B_rdy2; B_rdy2<=B_rdy1; B_rdy1<=B_rdy0; B_rdy0<=B_rdy;

if (B_rdy1='1') and (B_rdy2='0') then TimeC1<=TimeC0; AmplC1<=AmplC0; OrC_B1<=OrC_B; Nchan_C1<=Nchan_C0; bkgndC1<= bkgndC0; end if;
if (B_rdy2='1') and (B_rdy3='0') then TDC1<=TDC0; end if;

if (bitcnt_A="000") then 

    if (Tmode(0)='1') then 
         if (B_rdy1='1') and (B_rdy2='0') then TimeC2<=TimeC0; AmplC2<=AmplC0; OrC_B2<=OrC_B; Nchan_C2<=Nchan_C0; bkgndC2<= bkgndC0; 
            else TimeC2<=TimeC1; AmplC2<=AmplC1; OrC_B2<=OrC_B1; Nchan_C2<=Nchan_C1; bkgndC2<= bkgndC1;
            end if;
       TimeC<=TimeC2; AmplC<=AmplC2; OrC_i<=OrC_B2; Nchan_C<=Nchan_C2; bkgndC<= bkgndC2; 
       else 
         if (B_rdy1='1') and (B_rdy2='0') then TimeC<=TimeC0; AmplC<=AmplC0; ORC_i<=OrC_B; Nchan_C<=Nchan_C0; bkgndC<= bkgndC0;
            else TimeC<=TimeC1; AmplC<=AmplC1; OrC_i<=OrC_B1; Nchan_C<=Nchan_C1; bkgndC<= bkgndC1; 
         end if;
   end if;
end if;    



if (bitcnt_A="001") then 
 if (New_BCID='1') then BC_COU<=readout_status. BCID_from_CRU_corrected; Orbit_ID<=readout_status. ORBIT_from_CRU_corrected;
 else
  if (BC_COU=x"DEB") then BC_cou<=x"000"; Orbit_ID<=Orbit_ID+1; else BC_cou<=BC_cou+1; end if;
  end if;
    
if (Tmode(0)='1') then 
             if (B_rdy2='1') and (B_rdy3='0') then TDC2<=TDC0;  
                else TDC2<=TDC1;
                end if;
            TDC<=TDC2;
            else 
             if (B_rdy2='1') and (B_rdy2='0') then TDC<=TDC0;
                else TDC<=TDC1;
             end if;
       end if;    
    
    
end if;
    
if (bitcnt_A="010") then
 if ((OrA_i or ORC_i or SC_0 or C_0 or laser_t)='1') then
 Rd_Word<= x"F" & Tmode(3) &"001" & x"000000" & rx_phase_status & Orbit_ID & BC_COU & '0' & TimeC & '0' & TimeA  & '0' & AmplC  & '0' & AmplA & '0' & Nchan_C & '0' & Nchan_A & "00" & laser_t & trigs;
 gbt_wr<='1';
 end if;
 
 orA_str<= OrA_i; SC_str<= SC_0; CC_str<= C_0; V_str<=Vertex_0;
  
end if;    

if (bitcnt_A="011") then
 if (Tmode(3)='0') then gbt_wr<='0'; end if;
end if;

if (bitcnt_A="111") then
 if (Tmode(3)='1') then gbt_wr<='0'; end if;
end if;
 
 end if;
end process;

New_BCID <= readout_status.Start_run when (readout_status.BCIDsync_Mode=mode_SYNC) else '0';


FIFO_in<= TDA(2)(15 downto 0) & TDA(1) & TDA(0) & TDA(4) & TDA(3) & TDA(2)(31 downto 16) when (bitcnt_A="100") and (gbt_wr='1')     
else TDA(7)(15 downto 0) & TDA(6) & TDA(5) & TDA(9) & TDA(8) & TDA(7)(31 downto 16) when (bitcnt_A="101") and (gbt_wr='1')
else TDC(2)(15 downto 0) & TDC(1) & TDC(0) & TDC(4) & TDC(3) & TDC(2)(31 downto 16) when (bitcnt_A="110") and (gbt_wr='1')     
else TDC(7)(15 downto 0) & TDC(6) & TDC(5) & TDC(9) & TDC(8) & TDC(7)(31 downto 16) when (bitcnt_A="111") and (gbt_wr='1')
else Rd_Word;

TCM_data_toreadout.data_word  <=  FIFO_in;
TCM_data_toreadout.is_header  <=  '1' when (bitcnt_A="011") else '0';
TCM_data_toreadout.is_data    <=  gbt_wr;



process (CLK320C)
begin
if (CLK320C'event and CLK320C='1') then

if (bitcnt_c="001") then B_rdy<='1';  end if;

if (bitcnt_c="110") then  B_rdy<='0'; end if; 



end if;
end process;
 


--la2i(0)<=clka;
--la2i(1)<=clkc;
--la2i(2)<=bitcnt_A(2);
--la2i(3)<=bitcnt_C(2);
--la2i(2)<=OrC_B;
--la2i(3)<=OrC_B1;
--la2i(4)<=OrC_B2;
 

end RTL;
