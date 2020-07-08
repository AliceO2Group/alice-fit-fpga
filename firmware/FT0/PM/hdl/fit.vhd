----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:22:33 08/05/2016 
-- Design Name: 
-- Module Name:    fit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

package PM12_pkg is
type trig_time is array (0 to 11)  of STD_LOGIC_VECTOR (9 downto 0);
type trig_ampl0 is array (0 to 11) of STD_LOGIC_VECTOR(12 downto 0);
end package; 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.PM12_pkg.all; 

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;



entity fit is
    Port (    TDCCLK1_P : in  STD_LOGIC;
			  TDCCLK1_N : in  STD_LOGIC;
			  RDA1_P : in  STD_LOGIC;
			  RDA1_N : in  STD_LOGIC;
			  RSA1_P : in  STD_LOGIC;
			  RSA1_N : in  STD_LOGIC;
			  RDB1_P : in  STD_LOGIC;
			  RDB1_N : in  STD_LOGIC;
			  RSB1_P : in  STD_LOGIC;
			  RSB1_N : in  STD_LOGIC;
			  RDC1_P : in  STD_LOGIC;
			  RDC1_N : in  STD_LOGIC;
			  RSC1_P : in  STD_LOGIC;
			  RSC1_N : in  STD_LOGIC;
			  RDD1_P : in  STD_LOGIC;
			  RDD1_N : in  STD_LOGIC;
			  RSD1_P : in  STD_LOGIC;
			  RSD1_N : in  STD_LOGIC;
			  INA1_P : in  STD_LOGIC;
			  INA1_N : in  STD_LOGIC;
			  INB1_P : in  STD_LOGIC;
              INB1_N : in  STD_LOGIC;
			  INC1_P : in  STD_LOGIC;
              INC1_N : in  STD_LOGIC;
			  IND1_P : in  STD_LOGIC;
              IND1_N : in  STD_LOGIC;
			  DI1 : in  STD_LOGIC_VECTOR (12 downto 0);
			  DI2 : in  STD_LOGIC_VECTOR (12 downto 0);
			  DI3 : in  STD_LOGIC_VECTOR (12 downto 0);
			  DI4 : in  STD_LOGIC_VECTOR (12 downto 0);
			  STR1 : in  STD_LOGIC;
			  STR2 : in  STD_LOGIC;
			  STR3 : in  STD_LOGIC;
			  STR4 : in  STD_LOGIC;
			  MCLK1_P : in  STD_LOGIC;
              MCLK1_N : in  STD_LOGIC;

			  TDCCLK2_P : in  STD_LOGIC;
			  TDCCLK2_N : in  STD_LOGIC;
			  RDA2_P : in  STD_LOGIC;
			  RDA2_N : in  STD_LOGIC;
			  RSA2_P : in  STD_LOGIC;
			  RSA2_N : in  STD_LOGIC;
			  RDB2_P : in  STD_LOGIC;
			  RDB2_N : in  STD_LOGIC;
			  RSB2_P : in  STD_LOGIC;
			  RSB2_N : in  STD_LOGIC;
			  RDC2_P : in  STD_LOGIC;
			  RDC2_N : in  STD_LOGIC;
			  RSC2_P : in  STD_LOGIC;
			  RSC2_N : in  STD_LOGIC;
			  RDD2_P : in  STD_LOGIC;
			  RDD2_N : in  STD_LOGIC;
			  RSD2_P : in  STD_LOGIC;
			  RSD2_N : in  STD_LOGIC;
			  INA2_P : in  STD_LOGIC;
			  INA2_N : in  STD_LOGIC;
			  INB2_P : in  STD_LOGIC;
              INB2_N : in  STD_LOGIC;
			  INC2_P : in  STD_LOGIC;
              INC2_N : in  STD_LOGIC;
			  IND2_P : in  STD_LOGIC;
              IND2_N : in  STD_LOGIC;
			  DI5 : in  STD_LOGIC_VECTOR (12 downto 0);
			  DI6 : in  STD_LOGIC_VECTOR (12 downto 0);
			  DI7 : in  STD_LOGIC_VECTOR (12 downto 0);
			  DI8 : in  STD_LOGIC_VECTOR (12 downto 0);
			  STR5 : in  STD_LOGIC;
			  STR6 : in  STD_LOGIC;
			  STR7 : in  STD_LOGIC;
			  STR8 : in  STD_LOGIC;
			  MCLK2_P : in  STD_LOGIC;
              MCLK2_N : in  STD_LOGIC;

			  TDCCLK3_P : in  STD_LOGIC;
			  TDCCLK3_N : in  STD_LOGIC;
			  RDA3_P : in  STD_LOGIC;
			  RDA3_N : in  STD_LOGIC;
			  RSA3_P : in  STD_LOGIC;
			  RSA3_N : in  STD_LOGIC;
			  RDB3_P : in  STD_LOGIC;
			  RDB3_N : in  STD_LOGIC;
			  RSB3_P : in  STD_LOGIC;
			  RSB3_N : in  STD_LOGIC;
			  RDC3_P : in  STD_LOGIC;
			  RDC3_N : in  STD_LOGIC;
			  RSC3_P : in  STD_LOGIC;
			  RSC3_N : in  STD_LOGIC;
			  RDD3_P : in  STD_LOGIC;
			  RDD3_N : in  STD_LOGIC;
			  RSD3_P : in  STD_LOGIC;
			  RSD3_N : in  STD_LOGIC;
			  INA3_P : in  STD_LOGIC;
			  INA3_N : in  STD_LOGIC;
			  INB3_P : in  STD_LOGIC;
              INB3_N : in  STD_LOGIC;
			  INC3_P : in  STD_LOGIC;
              INC3_N : in  STD_LOGIC;
			  IND3_P : in  STD_LOGIC;
              IND3_N : in  STD_LOGIC;
			  DI9 : in  STD_LOGIC_VECTOR (12 downto 0);
			  DI10 : in  STD_LOGIC_VECTOR (12 downto 0);
			  DI11 : in  STD_LOGIC_VECTOR (12 downto 0);
			  DI12 : in  STD_LOGIC_VECTOR (12 downto 0);
			  STR9 : in  STD_LOGIC;
			  STR10 : in  STD_LOGIC;
			  STR11 : in  STD_LOGIC;
			  STR12 : in  STD_LOGIC;
			  MCLK3_P : in  STD_LOGIC;
              MCLK3_N : in  STD_LOGIC;

			  
			  SCK : in  STD_LOGIC;
			  MISO : out  STD_LOGIC;
			  MOSI : in  STD_LOGIC;
			  CS  : in  STD_LOGIC;
			  RST  : in  STD_LOGIC;
			  IRQ : out  STD_LOGIC;
			  AT0_P : out  STD_LOGIC;
			  AT0_N : out  STD_LOGIC;
			  AT1_P : out  STD_LOGIC;
			  AT1_N : out  STD_LOGIC;
			  TT0_P : out  STD_LOGIC;
			  TT0_N : out  STD_LOGIC;
			  TT1_P : out  STD_LOGIC;
			  TT1_N : out  STD_LOGIC;
			  HMOSI  : in  STD_LOGIC;
			  HMISO  : out  STD_LOGIC;
			  HSCK  : in  STD_LOGIC;
			  HSEL  : in  STD_LOGIC;
			  LA0 : out  STD_LOGIC_VECTOR (15 downto 0);
			  LA1 : out  STD_LOGIC_VECTOR (15 downto 0);
			  LA2 : out  STD_LOGIC_VECTOR (15 downto 0);
			  LA3 : out  STD_LOGIC_VECTOR (15 downto 0);
			  LACK0 : out  STD_LOGIC; 
			  LACK1 : out  STD_LOGIC; 
			  LACK2 : out  STD_LOGIC; 
			  LACK3 : out  STD_LOGIC;
			  EVNT  : out  STD_LOGIC;
			  LED1 : out  STD_LOGIC;
			  LED2 : out  STD_LOGIC;
			  LED3 : out  STD_LOGIC;
			  LED4 : out  STD_LOGIC;
			  MGTCLK_P : in  STD_LOGIC;
			  MGTCLK_N : in  STD_LOGIC;
			  GBT_RX_P : in  STD_LOGIC;
			  GBT_RX_N : in  STD_LOGIC;
			  GBT_TX_P : out  STD_LOGIC;
			  GBT_TX_N : out  STD_LOGIC;
			  FSEL : out  STD_LOGIC;
              FMOSI : out  STD_LOGIC;
              FMISO : in  STD_LOGIC 

			  );
end fit;


architecture RTL of fit is
attribute mark_debug : string;	

type data_vector is array (0 to 11) of STD_LOGIC_VECTOR (32 downto 0);
type trig_ampl is array (0 to 11) of STD_LOGIC_VECTOR(10 downto 0);

signal RESET, lock320, lock300_1, lock300_2, lock300_3, sreset, rsti, SPI_CS, spi_rd, spi_rden,  spi_lock320, spi_lock320_0, cnt_rst, cnt_rd, spi_wr_rdy, spi_wr0, spi_wr1, spi_wr2, spi_wr_req : STD_LOGIC;
signal spi_lock_1, spi_lock0_1, spi_lock_2, spi_lock0_2, spi_lock_3, spi_lock0_3, rd_lock_spi, rd_lock_hspi, rd_lock, dcs_irq : STD_LOGIC;
signal rstcount : STD_LOGIC_VECTOR (3 downto 0);
signal irq_cnt : STD_LOGIC_VECTOR (1 downto 0);
signal hspi_rden, hcnt_rd, hspi_wr_rdy, hspi_rd, hspi_wr0, hspi_wr1, hspi_wr2, hspi_wr_req, hspibuf_wr, spibuf_wr, hspibuf_rd, spibuf_rd, hspi_na, spi_na, hspi_h : STD_LOGIC;
signal hspibuf_wr0, spibuf_wr0, hspibuf_rd0, spibuf_rd0, hspibuf_wr1, spibuf_wr1, hspibuf_rd1, spibuf_rd1, hspibuf_wr2, spibuf_wr2, hspibuf_rd2, spibuf_rd2 : STD_LOGIC;
signal sbuf_wrena, hbuf_wrena, sbuf_rdena, hbuf_rdena, sbuf_ena, hbuf_ena, hbuf_req, buf_lock, buf_lock0, buf_lock1, buf_lock2, vect_clr, vect_clr_req : STD_LOGIC;
signal hspi_buf_out, spi_buf_out : STD_LOGIC_VECTOR (15 downto 0);
signal buf_cou : STD_LOGIC_VECTOR (7 downto 0);
signal buf_vector, rd_buf_vector : STD_LOGIC_VECTOR (59 downto 0); 
signal SPI_DATA, spi_wr_data, HSPI_DATA, hspi_wr_data, hspi_wr_data_l, reg_wr_data, hspi_32l : STD_LOGIC_VECTOR (15 downto 0);
signal spi_addr, hspi_addr, reg_wr_addr : STD_LOGIC_VECTOR (8 downto 0);
signal spi_bit_count, hspi_bit_count : STD_LOGIC_VECTOR (4 downto 0);
signal gate_time_low, gate_time_high : STD_LOGIC_VECTOR (7 downto 0);
signal reg32_wr, reg32_wr0, reg32_wr1, reg32_wr2, reg32_rd, reg32_rd0, reg32_rd1, reg32_rd2, reg32_str : STD_LOGIC;
signal CH1A_shift, CH1B_shift, CH1C_shift, CH1D_shift, CH2A_shift, CH2B_shift, CH2C_shift, CH2D_shift, CH3A_shift, CH3B_shift, CH3C_shift, CH3D_shift : STD_LOGIC_VECTOR (11 downto 0);
signal CH1_0_zero, CH1_1_zero, CH2_0_zero, CH2_1_zero, CH3_0_zero, CH3_1_zero, CH4_0_zero, CH4_1_zero, CH5_0_zero, CH5_1_zero, CH6_0_zero, CH6_1_zero, CH7_0_zero, CH7_1_zero, CH8_0_zero, CH8_1_zero, CH9_0_zero, CH9_1_zero, CH10_0_zero, CH10_1_zero, CH11_0_zero, CH11_1_zero, CH12_0_zero, CH12_1_zero  : STD_LOGIC_VECTOR (11 downto 0);
signal CH1_0_rg, CH1_1_rg, CH2_0_rg, CH2_1_rg, CH3_0_rg, CH3_1_rg, CH4_0_rg, CH4_1_rg, CH5_0_rg, CH5_1_rg, CH6_0_rg, CH6_1_rg, CH7_0_rg, CH7_1_rg, CH8_0_rg, CH8_1_rg, CH9_0_rg, CH9_1_rg, CH10_0_rg, CH10_1_rg, CH11_0_rg, CH11_1_rg, CH12_0_rg, CH12_1_rg : STD_LOGIC_VECTOR (11 downto 0);
signal CH1_0_rc, CH1_1_rc, CH2_0_rc, CH2_1_rc, CH3_0_rc, CH3_1_rc, CH4_0_rc, CH4_1_rc, CH5_0_rc, CH5_1_rc, CH6_0_rc, CH6_1_rc, CH7_0_rc, CH7_1_rc, CH8_0_rc, CH8_1_rc, CH9_0_rc, CH9_1_rc, CH10_0_rc, CH10_1_rc, CH11_0_rc, CH11_1_rc, CH12_0_rc, CH12_1_rc : STD_LOGIC_VECTOR (11 downto 0);

signal TDCCLK1,TDCCLK2,TDCCLK3,RDA1,RSA1,RDB1,RSB1,RDC1,RSC1,RDD1,RSD1,RDA2,RSA2,RDB2,RSB2,RDC2,RSC2,RDD2,RSD2,RDA3,RSA3,RDB3,RSB3,RDC3,RSC3,RDD3,RSD3,TDCCLK1L,TDCCLK2L,TDCCLK3L : STD_LOGIC; 
signal CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12 : STD_LOGIC_VECTOR (12 downto 0);
signal CSTR1,CSTR2,CSTR3,CSTR4, CSTR5,CSTR6,CSTR7,CSTR8, CSTR9,CSTR10,CSTR11,CSTR12, CGE1,CGE2,CGE3,CGE4,CGE5,CGE6,CGE7,CGE8,CGE9,CGE10,CGE11,CGE12, CGE1i,CGE2i,CGE3i,CGE4i,CGE5i,CGE6i,CGE7i,CGE8i,CGE9i,CGE10i,CGE11i,CGE12i : STD_LOGIC; 
signal SCKI,MISOI,MOSII,LOCKI,TDCHCLI,TDCHDI,TDCHSI,TDCRSI,TDCALMI,EVNTI,SYNCO : STD_LOGIC; 
signal MCLK40, MCLK40_1, MCLK40_0, MCLK40T, mclk1, mclk2, mclk3, MGTCLK: STD_LOGIC;
signal MCLK40_IN1,  MCLK40_IN2,  MCLK40_IN3 : STD_LOGIC;
signal AT0,AT1,TT0,TT1 : STD_LOGIC;
signal HMOSII,HMISOI,HSCKI,HSELI : STD_LOGIC;
signal LA0I, LA1I, LA2I, LA3I : STD_LOGIC_VECTOR (15 downto 0);
signal LACK0I,LACK1I,LACK2I,LACK3I : STD_LOGIC;

signal BC_BITS1, BC_BITS2, BC_BITS3 : STD_LOGIC_VECTOR (2 downto 0);
signal BCOLD1, BCOLD2, BCOLD3 : STD_LOGIC_VECTOR (1 downto 0);

signal BC_PER1, BC_PER2, BC_PER3 : STD_LOGIC_VECTOR (6 downto 0);
signal BC_JUMP1, BC_JUMP2, BC_JUMP3, ALM_CLR, almclr10, almclr11, alm_clr1, almclr20, almclr21, alm_clr2, almclr30, almclr31, alm_clr3, IRQI : STD_LOGIC;
signal HBC_JUMP1, HBC_JUMP2, HBC_JUMP3, hclr10, hclr11, h_clr1, hclr20, hclr21, h_clr2, hclr30, hclr31, h_clr3, Hs_rd, HGBTRXerr, hstat_clr, hstat_clr0, hstat_clr1 : STD_LOGIC;

signal TDC_COU1, TDC_COU2, TDC_COU3 : STD_LOGIC_VECTOR (3 downto 0);

signal TDC1A, TDC1B, TDC1C, TDC1D, TDC2A, TDC2B, TDC2C, TDC2D, TDC3A, TDC3B, TDC3C, TDC3D : STD_LOGIC_VECTOR (11 downto 0);

signal CH_TIME_T : trig_time;
--signal Trig_on0, Trig_onA0 : STD_LOGIC;
signal GBT_TX_D, GBT_RX_D : STD_LOGIC_VECTOR (79 downto 0);

signal TDC1A_raw, TDC1B_raw, TDC1C_raw, TDC1D_raw, TDC2A_raw, TDC2B_raw, TDC2C_raw, TDC2D_raw, TDC3A_raw, TDC3B_raw, TDC3C_raw, TDC3D_raw  : STD_LOGIC_VECTOR (12 downto 0);

signal clk300_1, clk300_2, clk300_3, clk600_1, clk600_2, clk600_3, clk600_90_1, clk600_90_2, clk600_90_3, clk320, clkfbin1, clkfbout1, clkfbin2, clkfbout2, clkfbin3, clkfbout3 : STD_LOGIC;

signal BC_STR1, BC_STR11, BC_STR12, BC_STR2, BC_STR21, BC_STR22,BC_STR3, BC_STR31, BC_STR32, C1_EV : STD_LOGIC;
signal F1A_full, F1B_full, F1C_full, F1D_full, F2A_full, F2B_full, F2C_full, F2D_full, F3A_full, F3B_full, F3C_full, F3D_full, Trig_on0, Trig_onA0 : STD_LOGIC;
signal TDC1A_rdy0, TDC1B_rdy0, TDC1C_rdy0, TDC1D_rdy0, TDC2A_rdy0, TDC2B_rdy0, TDC2C_rdy0, TDC2D_rdy0, TDC3A_rdy0, TDC3B_rdy0, TDC3C_rdy0, TDC3D_rdy0 : STD_LOGIC;
signal mt_cou : STD_LOGIC_VECTOR(2 downto 0);
signal BC_cou : STD_LOGIC_VECTOR(11 downto 0);
signal TR_to :  STD_LOGIC_VECTOR(5 downto 0);

signal CH_ampl0 : trig_ampl0;

signal N_chans :  STD_LOGIC_VECTOR(3 downto 0);

signal tt,ta,tto,tao : STD_LOGIC_VECTOR (1 downto 0);

signal GBT_is_RXD, GBT_is_TXD, RX_CLK, TX_CLK, GBTRX_ready, GBTRX_ready0, GBT_chg, HGBT_chg, GBT_rdy, GBT_rdy0, t100ms, RX_err, RX_err1, RX_err_LED, rxerr0, TXact, RXact, RXLED, TXLED, txled0, rxled0, LNKLED, IsRXData0, GBTRXerr, stat_clr, stat_clr0, stat_clr1 : STD_LOGIC;
signal cou_100ms :  STD_LOGIC_VECTOR (21 downto 0);
signal alm_rst0, alm_rst, chans_block : STD_LOGIC;

signal chans_ena, chans_ena_r : STD_LOGIC_VECTOR (11 downto 0);

signal Zcal_done, Zcal_done0 : STD_LOGIC;
signal CH1_Z0, CH1_Z1, CH2_Z0, CH2_Z1, CH3_Z0, CH3_Z1, CH4_Z0, CH4_Z1, CH5_Z0, CH5_Z1, CH6_Z0, CH6_Z1, CH7_Z0, CH7_Z1, CH8_Z0, CH8_Z1, CH9_Z0, CH9_Z1, CH10_Z0, CH10_Z1, CH11_Z0, CH11_Z1, CH12_Z0, CH12_Z1 : STD_LOGIC_VECTOR (11 downto 0);

signal N1_chans, N2_chans : STD_LOGIC_VECTOR (2 downto 0);
signal TT_mode : STD_LOGIC;

signal ampl_sat : STD_LOGIC_VECTOR (11 downto 0);
signal Event_in, DATA_rd, DATA_rdy, inp_cou, CH_trig, CH_triga, CH_do, Cal_done, trig_bgnd : STD_LOGIC_VECTOR (11 downto 0);
signal inp_event, EV_ID_wr, EV_ID_rd, EV_ID_empty, Event_ready, Event_ready_0, Event_free, wr_out_id, New_BCID, DATA80_rd, DATA_empty, FIFO_dis, wr_nch, ev_tout, ev_tout0 : STD_LOGIC;
signal ev_tout_cnt : STD_LOGIC_VECTOR (7 downto 0);

signal CH_N0, CH_N1, CH_N0_0, CH_N1_0, CH_NUM : STD_LOGIC_VECTOR (3 downto 0);
signal CH_NUM1, CH_NUM2 : STD_LOGIC_VECTOR (2 downto 0);
signal WRDS_NUM : STD_LOGIC_VECTOR (2 downto 0);
signal Orbit_ID, hspid_w32, hspid_r32, tstamp, hspib_32 : STD_LOGIC_VECTOR (31 downto 0);
signal xadc_r, xadc_out : STD_LOGIC_VECTOR (15 downto 0);
signal xadc_a: STD_LOGIC_VECTOR (6 downto 0);
signal EV_ID_in, EV_ID_out : STD_LOGIC_VECTOR (55 downto 0);
signal EV_DATA80, DATA80_in : STD_LOGIC_VECTOR (79 downto 0);
--signal  mux_out, str_la : STD_LOGIC;
signal WR_fifo_out, wr_hspi32, rd_hspi32, flsh_sel, TCM_req, TCM_reqh, TCM_req0, TCM_req1, TCM_req2, fl_rst, rd_xadc, xadc_rq0, xadc_rq1, xadc_rq2, xadc_en, xadc_rdy, gs0, gs1 : STD_LOGIC;

signal DATA_out : data_vector;


signal ev_out_cou :  STD_LOGIC_VECTOR (3 downto 0);
signal cnt_out, hcnt_out :  STD_LOGIC_VECTOR (15 downto 0);

signal psen1, psincdec1, jumpa1, flock1, fdone1, psen2, psincdec2, jumpa2, flock2, fdone2, psen3, psincdec3, jumpa3, flock3, fdone3, all_locked  :  STD_LOGIC;
signal pshift1, pshift2, pshift3 :  STD_LOGIC_VECTOR (5 downto 0);
 
signal rx_phase_status : std_logic_vector(3 downto 0); 
 
component  PLL320
    port (  mclk_in         : in     std_logic;
	    RESET           : in     std_logic;
	    locked           : out     std_logic;
	    CLK320           : out     std_logic;
	    CLK40           : out     std_logic);
end component;

component CLK600_pll 
    port (  CLK_IN          : in     std_logic;
	    RESET           : in     std_logic;
	    CLKFB_IN        : in     std_logic;
	    locked           : out     std_logic;
	    psclk             : in     std_logic;
        psen              : in     std_logic;
        psincdec          : in     std_logic;
        psdone            : out    std_logic;
		CLK600          : out    std_logic;
		CLK600_90       : out    std_logic;
		CLK300          : out    std_logic;
		CLKFB_OUT          : out    std_logic);
end component;

component pin_capt
    Port ( pin_in : in  STD_LOGIC;
           pin_out : out  STD_LOGIC;
           clk600 : in  STD_LOGIC;
           clk600_90 : in  STD_LOGIC;
           clk300 : in  STD_LOGIC;
           str : out  STD_LOGIC;
           ptime : out  STD_LOGIC_VECTOR (2 downto 0));
end component;

component TDCCHAN is
       Port ( pin_in : in STD_LOGIC;
              pin_out : out STD_LOGIC;
              clk300 : in STD_LOGIC;
              clk600 : in STD_LOGIC;
              clk600_90 : in STD_LOGIC;
              reset : in STD_LOGIC;
              tdcclk : in STD_LOGIC;
              rstr : in STD_LOGIC;
              rdata : in STD_LOGIC;
              tdc_count : in STD_LOGIC_VECTOR (3 downto 0);
              bc_time : in STD_LOGIC_VECTOR (6 downto 0);
              tdc_out : out STD_LOGIC_VECTOR (11 downto 0);
              tdc_rdy : out STD_LOGIC;
 --             fifo_full : out STD_LOGIC;
              tdc_raw : out STD_LOGIC_VECTOR (12 downto 0);
              tdc_raw_lock: in STD_LOGIC
              );
   end component;
   
   component Channel is
       Port ( CGE : in STD_LOGIC;
              clk320 : in STD_LOGIC;
              reset  : in STD_LOGIC;
              tdc_rdy_in : in STD_LOGIC;
              mt_cou : in STD_LOGIC_VECTOR (2 downto 0);
              bc_cou : in STD_LOGIC_VECTOR (5 downto 0);
              TR_bc : in STD_LOGIC_VECTOR (5 downto 0);          
              TDC : in STD_LOGIC_VECTOR (11 downto 0);
--              TDC_full : in STD_LOGIC;
              CSTR : in STD_LOGIC;
              CH :  in STD_LOGIC_VECTOR(12 downto 0);
              CH_shift : in STD_LOGIC_VECTOR (11 downto 0);
              gate_time_low :  in STD_LOGIC_VECTOR (7 downto 0);
			  FIFO_dis: in STD_LOGIC;
              gate_time_high :  in STD_LOGIC_VECTOR (7 downto 0);
              Ampl_sat :  in STD_LOGIC_VECTOR (11 downto 0);
              CH0_zero : in STD_LOGIC_VECTOR (11 downto 0);
              CH1_zero : in STD_LOGIC_VECTOR (11 downto 0);
              CH_trig_outt : out STD_LOGIC;
              CH_trig_outa : out STD_LOGIC;
              CH_trig_bgnd : out STD_LOGIC;
              CH_TIME : out STD_LOGIC_VECTOR (9 downto 0);
              CH_ampl  : out STD_LOGIC_VECTOR (12 downto 0);
              DATA_out : out STD_LOGIC_VECTOR (32 downto 0);
              DATA_ready : out STD_LOGIC;
              DATA_rd : in STD_LOGIC;
              Event_in  : out STD_LOGIC;
              Cal : in STD_LOGIC;
              Z0_cal : out STD_LOGIC_VECTOR (11 downto 0);
              Z1_cal : out STD_LOGIC_VECTOR (11 downto 0);
              Cal_done : out STD_LOGIC;
              spi_lock : in STD_LOGIC;
              R0_cal : out STD_LOGIC_VECTOR (11 downto 0);
              R1_cal : out STD_LOGIC_VECTOR (11 downto 0);
              R0_corr : in STD_LOGIC_VECTOR (11 downto 0);
              R1_corr : in STD_LOGIC_VECTOR (11 downto 0);
              pulse_in : out STD_LOGIC;
              chan_ena : in STD_LOGIC
               );
              
   end component;
   
--   component GBT_TX_RX is
--       Port ( RESET : in  STD_LOGIC;
--              MgtRefClk : in  STD_LOGIC;
--              MGT_RX_P : in  STD_LOGIC;
--              MGT_RX_N : in  STD_LOGIC;
--              MGT_TX_P : out  STD_LOGIC;
--              MGT_TX_N : out  STD_LOGIC;
--              TXDataClk : in  STD_LOGIC;
--              TXData : in  STD_LOGIC_VECTOR (79 downto 0);
--              TXData_SC : in  STD_LOGIC_VECTOR (3 downto 0);
--              IsTXData : in  STD_LOGIC;
--              RXDataClk : out  STD_LOGIC;
--              RXData : out  STD_LOGIC_VECTOR (79 downto 0);
--              RXData_SC : out  STD_LOGIC_VECTOR (3 downto 0);
--              IsRXData : out  STD_LOGIC;
--              RX_ready : out  STD_LOGIC;
--              RX_errors : out  STD_LOGIC
--              );
--   end component;

      component EVENTID_FIFO
       Port ( clk : IN STD_LOGIC; 
       srst : IN STD_LOGIC;
       din : IN STD_LOGIC_VECTOR(55 DOWNTO 0);
       wr_en : IN STD_LOGIC;
       rd_en : IN STD_LOGIC;
       dout : OUT STD_LOGIC_VECTOR(55 DOWNTO 0);
       full : OUT STD_LOGIC;
       empty : OUT STD_LOGIC);
      end component ;

   
   -- ###############################################
   -- #########  GBT Readout ########################
   -- ###############################################
   signal FIT_GBT_status : FIT_GBT_status_type;
   signal FIT_GBT_control : CONTROL_REGISTER_type;
           
attribute mark_debug of FIT_GBT_control : signal is "true";
attribute mark_debug of FIT_GBT_status : signal is "true";
           
   signal Data_from_FITrd             : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
   signal IsData_from_FITrd        : STD_LOGIC;
   
   signal RxData_rxclk_from_GBT     : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
   signal IsRxData_rxclk_from_GBT    : STD_LOGIC;
   
   signal PM_data_toreadout		:  board_data_type;
   
   signal    ipbus_control_reg : cntr_reg_addrreg_type;
   signal    ipbus_status_reg: status_reg_addrreg_type;

   signal    gbt_global_status : std_logic_vector(3 downto 0);

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
           Control_register_I    : in CONTROL_REGISTER_type;
           
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
           rx_ph320 : out std_logic_vector(2 downto 0);
		   ph_error320 : out std_logic; 
              -- FIT readour status, including BCOR_ID to PM/TCM
           FIT_GBT_status_O : out FIT_GBT_status_type
                      
       );
   end component;
   -- ###############################################
   -- ###############################################
   -- ###############################################





   

  
    component counters 
          Port ( clk : in STD_LOGIC;
                 evnt : in STD_LOGIC_VECTOR (11 downto 0);
                 trig : in STD_LOGIC_VECTOR (11 downto 0);
                 reset : in STD_LOGIC;
                 dout : out STD_LOGIC_VECTOR (15 downto 0);
                 hdout : out STD_LOGIC_VECTOR (15 downto 0);
                 raddr : in STD_LOGIC_VECTOR (5 downto 0);
                 hraddr : in STD_LOGIC_VECTOR (4 downto 0);
                 hl : in STD_LOGIC;
                 rd_en : in STD_LOGIC;
                 hrd_en : in STD_LOGIC
                 );
      end component;
      
      component trigger 
          Port ( clk320 : in STD_LOGIC;
                 mt_cou : in STD_LOGIC_VECTOR (2 downto 0);
                 CH_trigt : in STD_LOGIC_VECTOR (11 downto 0);
                 CH_triga : in STD_LOGIC_VECTOR (11 downto 0);
                 CH_trigb : in STD_LOGIC_VECTOR (11 downto 0);
                 CH_TIME_T : in trig_time;
                 CH_ampl0 : in trig_ampl0;
                 tcm_req : in STD_LOGIC;
                 tt  : out STD_LOGIC_VECTOR (1 downto 0);
                 ta  : out STD_LOGIC_VECTOR (1 downto 0)
                  );
      end component;
      
      COMPONENT Xmega_buf
        PORT (
          clka : IN STD_LOGIC;
          ena : IN STD_LOGIC;
          wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
          addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
          dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          clkb : IN STD_LOGIC;
          enb : IN STD_LOGIC;
          web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
          addrb : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
          dinb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
      END COMPONENT;
      
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

COMPONENT autophase
Port ( clk : in STD_LOGIC;
       lock : in STD_LOGIC;
       jump : in STD_LOGIC;
       psen : out STD_LOGIC;
       psincdec :  out STD_LOGIC;
       done  :  out STD_LOGIC;
       shift : out STD_LOGIC_VECTOR (5 downto 0)
       );
END COMPONENT;       

begin

TCLK1: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>TDCCLK1_P, IB=>TDCCLK1_N, O=>TDCCLK1L);

TCLKB1: BUFR 
   generic map (  BUFR_DIVIDE => "BYPASS" )
   port map (O => TDCCLK1, CE => '1', CLR => '0', I => TDCCLK1L);

TCLK2: IBUFDS
   generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
   port map (I=>TDCCLK2_P, IB=>TDCCLK2_N, O=>TDCCLK2L);
   
TCLKB2: BUFR 
      generic map (  BUFR_DIVIDE => "BYPASS" )
      port map (O => TDCCLK2, CE => '1', CLR => '0', I => TDCCLK2L);

TCLK3: IBUFDS
      generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
      port map (I=>TDCCLK3_P, IB=>TDCCLK3_N, O=>TDCCLK3L);
    
TCLKB3: BUFR 
      generic map (  BUFR_DIVIDE => "BYPASS" )
         port map (O => TDCCLK3, CE => '1', CLR => '0', I => TDCCLK3L);


RDA1_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDA1_P, IB=>RDA1_N, O=>RDA1);
RSA1_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSA1_P, IB=>RSA1_N, O=>RSA1);
RDB1_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDB1_P, IB=>RDB1_N, O=>RDB1);
RSB1_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSB1_P, IB=>RSB1_N, O=>RSB1);
RDC1_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDC1_P, IB=>RDC1_N, O=>RDC1);
RSC1_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSC1_P, IB=>RSC1_N, O=>RSC1);
RDD1_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDD1_P, IB=>RDD1_N, O=>RDD1);
RSD1_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSD1_P, IB=>RSD1_N, O=>RSD1);

RDA2_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDA2_P, IB=>RDA2_N, O=>RDA2);
RSA2_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSA2_P, IB=>RSA2_N, O=>RSA2);
RDB2_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDB2_P, IB=>RDB2_N, O=>RDB2);
RSB2_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSB2_P, IB=>RSB2_N, O=>RSB2);
RDC2_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDC2_P, IB=>RDC2_N, O=>RDC2);
RSC2_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSC2_P, IB=>RSC2_N, O=>RSC2);
RDD2_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDD2_P, IB=>RDD2_N, O=>RDD2);
RSD2_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSD2_P, IB=>RSD2_N, O=>RSD2);

RDA3_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDA3_P, IB=>RDA3_N, O=>RDA3);
RSA3_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSA3_P, IB=>RSA3_N, O=>RSA3);
RDB3_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDB3_P, IB=>RDB3_N, O=>RDB3);
RSB3_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSB3_P, IB=>RSB3_N, O=>RSB3);
RDC3_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDC3_P, IB=>RDC3_N, O=>RDC3);
RSC3_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSC3_P, IB=>RSC3_N, O=>RSC3);
RDD3_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RDD3_P, IB=>RDD3_N, O=>RDD3);
RSD3_B: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>RSD3_P, IB=>RSD3_N, O=>RSD3);


ADCIN: for i in 0 to 12 generate
ADC1: IBUF
   port map (O => CH1(i), I => DI1(i) );
ADC2: IBUF
   port map (O => CH2(i), I => DI2(i) );
ADC3: IBUF
   port map (O => CH3(i), I => DI3(i) );
ADC4: IBUF
   port map (O => CH4(i), I => DI4(i) );
ADC5: IBUF
   port map (O => CH5(i), I => DI5(i) );
ADC6: IBUF
   port map (O => CH6(i), I => DI6(i) );
ADC7: IBUF
   port map (O => CH7(i), I => DI7(i) );
ADC8: IBUF
   port map (O => CH8(i), I => DI8(i) );
ADC9: IBUF
   port map (O => CH9(i), I => DI9(i) );
ADC10: IBUF
   port map (O => CH10(i), I => DI10(i) );
ADC11: IBUF
   port map (O => CH11(i), I => DI11(i) );
ADC12: IBUF
   port map (O => CH12(i), I => DI12(i) );
end generate;

iN1: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>INA1_P, IB=>INA1_N, O=>CGE1i);
iN2: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>INB1_P, IB=>INB1_N, O=>CGE2i);
iN3: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>INC1_P, IB=>INC1_N, O=>CGE3i);
iN4: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>IND1_P, IB=>IND1_N, O=>CGE4i);
iN5: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>INA2_P, IB=>INA2_N, O=>CGE5i);
iN6: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>INB2_P, IB=>INB2_N, O=>CGE6i);
iN7: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>INC2_P, IB=>INC2_N, O=>CGE7i);
iN8: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>IND2_P, IB=>IND2_N, O=>CGE8i);
iN9: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>INA3_P, IB=>INA3_N, O=>CGE9i);
iN10: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>INB3_P, IB=>INB3_N, O=>CGE10i);
iN11: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>INC3_P, IB=>INC3_N, O=>CGE11i);
iN12: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>IND3_P, IB=>IND3_N, O=>CGE12i);


iSTR1: IBUF
   port map (O => CSTR1, I => STR1 );
iSTR2: IBUF
   port map (O => CSTR2, I => STR2 );
iSTR3: IBUF
   port map (O => CSTR3, I => STR3 );
iSTR4: IBUF
   port map (O => CSTR4, I => STR4 );
iSTR5: IBUF
   port map (O => CSTR5, I => STR5 );
iSTR6: IBUF
   port map (O => CSTR6, I => STR6 );
iSTR7: IBUF
   port map (O => CSTR7, I => STR7 );
iSTR8: IBUF
   port map (O => CSTR8, I => STR8 );
iSTR9: IBUF
   port map (O => CSTR9, I => STR9 );
iSTR10: IBUF
   port map (O => CSTR10, I => STR10 );
iSTR11: IBUF
   port map (O => CSTR11, I => STR11 );
iSTR12: IBUF
   port map (O => CSTR12, I => STR12 );

iSCK: IBUF
 port map (O => SCKI, I =>SCK );
iMISO: OBUFT
 port map (I =>MISOI , O => MISO, T=>spi_rden );
iMOSI: IBUF
 port map (O =>MOSII, I => MOSI  );
iCS: IBUF
port map (O => SPI_CS, I => CS );
iRST: IBUF
port map (O => rsti, I => RST );

iMCLK1: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>MCLK1_P, IB=>MCLK1_N, O=>MCLK1);

iMCLK2: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>MCLK2_P, IB=>MCLK2_N, O=>MCLK2);

iMCLK3: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>MCLK3_P, IB=>MCLK3_N, O=>MCLK3);

iAT0: OBUFDS
generic map (SLEW => "FAST", IOSTANDARD => "LVDS") port map (I=>AT0, OB=>AT0_N, O=>AT0_P);
iAT1: OBUFDS
generic map (SLEW => "FAST", IOSTANDARD => "LVDS") port map (I=>AT1, OB=>AT1_N, O=>AT1_P);
iTT0: OBUFDS
generic map (SLEW => "FAST", IOSTANDARD => "LVDS") port map (I=>TT0, OB=>TT0_N, O=>TT0_P);
iTT1: OBUFDS
generic map (SLEW => "FAST", IOSTANDARD => "LVDS") port map (I=>TT1, OB=>TT1_N, O=>TT1_P);

iHMOSI: IBUF
   port map (O =>HMOSII , I => HMOSI );
iHSCK: IBUF
   port map (O =>HSCKI , I => HSCK );
iHSEL: IBUF
   port map (O =>HSELI , I => HSEL );
iHMISO: OBUFT
   port map (O => HMISO , I => HMISOI, T=>hspi_rden);
  
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

ILED1: OBUF
      port map (O => LED1, I => TXLED);
ILED2: OBUF
      port map (O => LED2, I => RXLED);
ILED3: OBUF
      port map (O => LED3, I => LNKLED);
ILED4: OBUF
      port map (O => LED4, I => RX_err_LED);
IRQ1: OBUF
      port map (O => IRQ, I => IRQI);

IEVNT: OBUF
   port map (O => EVNT, I => EVNTI);
	
IMGTCLK1: IBUFDS_GTE2
	port map (O => MGTCLK, I => MGTCLK_P, IB => MGTCLK_N, CEB=>'0');

fl_upg: FLASH generic map (clk_freq => 40000 ) 
              port map (rst=>fl_rst, clk  => TX_CLK, data_in =>hspid_w32, data_out =>hspid_r32, A =>hspi_addr(1 downto 0), wr_flshreg =>wr_hspi32, rd_flshreg  =>rd_hspi32, flshreg_sel=>flsh_sel, FSEL =>FSEL, FMOSI =>FMOSI, FMISO =>FMISO);
	

IRQI<= BC_JUMP1 or BC_JUMP2 or BC_JUMP3 or GBTRXerr or GBT_chg or dcs_irq when (irq_cnt="11") else '0';

at0<=tao(0); at1<=tao(1); tt0<=tto(0); tt1<=tto(1); 

-- #################################################################################################
-- #################   FIT GBT Readout    ##########################################################
-- #################################################################################################
--GBT1:  GBT_TX_RX port map (
--            RESET =>RESET, 
--            MgtRefClk => MGTCLK, 
--            MGT_RX_P =>GBT_RX_P,
--            MGT_RX_N =>GBT_RX_N,  
--            MGT_TX_P =>GBT_TX_P, 
--            MGT_TX_N =>GBT_TX_N, 
--            TXDataClk =>TX_CLK, 
--            TXData => GBT_TX_D, 
--            TXData_SC=>"0000", 
--            IsTXData =>GBT_is_TXD, 
--            RXDataClk => RX_CLK, 
--            RXData =>GBT_RX_D, 
--            RXData_SC =>open, 
--            IsRXData => GBT_is_RXD, 
--            RX_ready=>GBTRX_ready, 
--            RX_errors=> RX_err
--        );

-- FIT GBT project =====================================
FitGbtPrg: FIT_GBT_project
	generic map(
		GENERATE_GBT_BANK	=> 1
	)
	
	Port map(
		RESET_I				=>	sreset,
		SysClk_I			=>	clk320,
		DataClk_I			=>	TX_CLK,
		MgtRefClk_I			=>	MGTCLK,
		RxDataClk_I			=> RX_CLK, -- 40MHz data clock in RX domain (loop back)
		GBT_RxFrameClk_O	=> RX_CLK,
		
		Board_data_I		=> PM_data_toreadout,
		Control_register_I	=> FIT_GBT_control,
		
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

		FIT_GBT_status_O 	=> FIT_GBT_status
		);		
-- =====================================================

GBT_is_RXD <= IsRxData_rxclk_from_GBT;
GBTRX_ready <= FIT_GBT_status.GBT_status.gbtRx_Ready;
RX_err <= FIT_GBT_status.GBT_status.gbtRx_ErrorDet;



--PM_data_toreadout.is_header  <=  GBT_is_TXD;
--PM_data_toreadout.is_data    <=  GBT_is_TXD;
--PM_data_toreadout.is_packet  <=  GBT_is_TXD;
--PM_data_toreadout.data_word  <=  GBT_TX_D;

   
FIT_GBT_control <= func_CNTRREG_getcntrreg(ipbus_control_reg);
ipbus_status_reg <= func_STATREG_getaddrreg(FIT_GBT_status);

gbt_global_status(0) <=  FIT_GBT_status.GBT_status.Rx_Phase_error;
gbt_global_status(1) <=  '1' when FIT_GBT_status.BCIDsync_Mode = mode_LOST else '0';
--gbt_global_status(2) <=  '1' when FIT_GBT_status.hits_rd_counter_selector.hits_skipped /= x"0000_0000" else '0';
gbt_global_status(3) <=  '0';

process (clk320)
begin
    if (clk320'event and clk320='1') then
        if ( FIT_GBT_status.hits_rd_counter_selector.hits_skipped = x"0000_0000") then
         gbt_global_status(2) <=  '0';
        else 
         gbt_global_status(2) <=  '1';
        end if;
    end if;
end process;
--gbt_global_status <=  x"0";

-- #################################################################################################
-- #################################################################################################


                                  
LNKLED<=not GBTRX_ready;
RX_err_LED<=rxerr0 or (not GBTRX_ready);
TXLED<=txled0 or (not GBTRX_ready);                                  
RXLED<=rxled0 or (not GBTRX_ready);                                  


process (TX_CLK)
begin
if (TX_CLK'event and TX_CLK='1') then

xadc_rq2 <=xadc_rq1; xadc_rq1<= xadc_rq0; xadc_rq0 <=rd_xadc; 

if (xadc_rdy='1') then xadc_r<=xadc_out; end if; 

fl_rst <=sreset; 

GBT_is_TXD<=IsData_from_FITrd;
IsRXData0<=GBT_is_RXD;
GBTRX_ready0<=GBTRX_ready;

stat_clr0<=ALM_CLR; stat_clr1<=stat_clr0; stat_clr<=stat_clr1;
hstat_clr0<=Hs_rd; hstat_clr1<=hstat_clr0; hstat_clr<=hstat_clr1;


 if (stat_clr1='1') and (stat_clr='0') then irq_cnt<="00"; 
   else if (irq_cnt/="11") then irq_cnt<=irq_cnt+1; end if;
 end if; 
 
 if (GBTRX_ready/=GBTRX_ready0) then GBT_chg<='1'; HGBT_chg<='1';
  else 
   if (stat_clr1='1') and (stat_clr='0') then GBT_chg<='0'; end if;
   if (hstat_clr1='1') and (hstat_clr='0') then HGBT_chg<='0'; end if;
end if;


if (GBTRX_ready='1') and (GBT_rdy='1') and (RX_err='1') then GBTRXerr<='1'; HGBTRXerr<='1';
  else 
    if (stat_clr1='1') and (stat_clr='0') then GBTRXerr<='0'; end if;
    if (hstat_clr1='1') and (hstat_clr='0') then HGBTRXerr<='0'; end if;
end if;

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
  else cou_100ms<="00" & x"00000"; RX_err1<='0'; TXact<='0'; RXact<='0';
    if (RX_err='1') or (RX_err1='1') then RXerr0<='0'; else RXerr0<='1'; end if; 
    if (GBT_is_TXD='1') or (TXact='1') then txled0<='0'; else txled0<='1'; end if; 
    if (IsRXData0='1') or (RXact='1') then rxled0<='0'; else rxled0<='1'; end if;
end if;


end if;
end process; 

t100ms <='1' when cou_100ms="11" & x"D08FF" else '0';

MCLKB1: BUFR 
      generic map (  BUFR_DIVIDE => "BYPASS" )
         port map (O => MCLK40, CE => '1', CLR => '0', I => MCLK40_IN1);
                                  
process (MCLK40)
begin
if (MCLK40'event and MCLK40='1') then
MCLK40T <= not MCLK40T;
 end if;

end process; 

af1: autophase port map(clk =>clk300_1, lock =>flock1, jump =>jumpa1, psen =>psen1, psincdec =>psincdec1, done => fdone1, shift =>pshift1);
PLL1: CLK600_pll port map(CLK_IN=>MCLK40_IN1, RESET=>RESET, CLKFB_IN=>clkfbin1, locked=>flock1, psclk=> clk300_1, psen=> psen1, psincdec =>psincdec1, psdone =>open, CLK600=>clk600_1, CLK600_90=>CLK600_90_1, CLK300=>clk300_1, CLKFB_OUT=>clkfbout1); 
FBBUF1: BUFH port map(O=>clkfbin1, I=>clkfbout1); 
af2: autophase port map(clk =>clk300_2, lock =>flock2, jump =>jumpa2, psen =>psen2, psincdec =>psincdec2, done => fdone2, shift =>pshift2);
PLL2: CLK600_pll port map(CLK_IN=>MCLK40_IN2, RESET=>RESET, CLKFB_IN=>clkfbin2, locked=>flock2, psclk=> clk300_2, psen=> psen2, psincdec =>psincdec2, psdone =>open, CLK600=>clk600_2, CLK600_90=>CLK600_90_2, CLK300=>clk300_2, CLKFB_OUT=>clkfbout2); 
FBBUF2: BUFH port map(O=>clkfbin2, I=>clkfbout2); 
af3: autophase port map(clk =>clk300_3, lock =>flock3, jump =>jumpa3, psen =>psen3, psincdec =>psincdec3, done => fdone3, shift =>pshift3);
PLL3: CLK600_pll port map(CLK_IN=>MCLK40_IN3, RESET=>RESET, CLKFB_IN=>clkfbin3, locked=>flock3, psclk=> clk300_3, psen=> psen3, psincdec =>psincdec3, psdone =>open, CLK600=>clk600_3, CLK600_90=>CLK600_90_3, CLK300=>clk300_3, CLKFB_OUT=>clkfbout3);
FBBUF3: BUFH port map(O=>clkfbin3, I=>clkfbout3); 

lock300_1<= flock1 and fdone1; lock300_2<= flock2 and fdone2;  lock300_3<= flock3 and fdone3;  

PLL4: PLL320 port map(mclk_in=>MCLK40, RESET=>RESET, locked=>lock320, CLK320=>clk320, CLK40=> TX_CLK);

PINCAPT_M40_1: pin_capt port map ( pin_in => MCLK1, pin_out => MCLK40_IN1, clk600 => clk600_1, clk600_90 => clk600_90_1, clk300 => clk300_1, str => BC_STR1, ptime => BC_BITS1);
PINCAPT_M40_2: pin_capt port map ( pin_in => MCLK2, pin_out => MCLK40_IN2, clk600 => clk600_2, clk600_90 => clk600_90_2, clk300 => clk300_2, str => BC_STR2, ptime => BC_BITS2);
PINCAPT_M40_3: pin_capt port map ( pin_in => MCLK3, pin_out => MCLK40_IN3, clk600 => clk600_3, clk600_90 => clk600_90_3, clk300 => clk300_3, str => BC_STR3, ptime => BC_BITS3);

TDC1_CHA: TDCCHAN port map( pin_in =>CGE1i, pin_out =>CGE1, clk300 =>clk300_1, clk600 =>clk600_1, clk600_90 =>clk600_90_1, reset =>sreset, tdcclk =>tdcclk1, rstr =>rsa1, rdata =>rda1, tdc_count =>TDC_COU1, bc_time =>BC_PER1, tdc_out =>TDC1A, tdc_rdy =>TDC1A_rdy0,
         tdc_raw=>TDC1A_raw, tdc_raw_lock=>spi_lock_1);
TDC1_CHB: TDCCHAN port map( pin_in =>CGE2i, pin_out =>CGE2, clk300 =>clk300_1, clk600 =>clk600_1, clk600_90 =>clk600_90_1, reset =>sreset, tdcclk =>tdcclk1, rstr =>rsb1, rdata =>rdb1, tdc_count =>TDC_COU1, bc_time =>BC_PER1, tdc_out =>TDC1B, tdc_rdy =>TDC1B_rdy0,
         tdc_raw=>TDC1B_raw, tdc_raw_lock=>spi_lock_1);
TDC1_CHC: TDCCHAN port map( pin_in =>CGE3i, pin_out =>CGE3, clk300 =>clk300_1, clk600 =>clk600_1, clk600_90 =>clk600_90_1, reset =>sreset, tdcclk =>tdcclk1, rstr =>rsc1, rdata =>rdc1, tdc_count =>TDC_COU1, bc_time =>BC_PER1, tdc_out =>TDC1C, tdc_rdy =>TDC1C_rdy0,
         tdc_raw=>TDC1C_raw, tdc_raw_lock=>spi_lock_1);
TDC1_CHD: TDCCHAN port map( pin_in =>CGE4i, pin_out =>CGE4, clk300 =>clk300_1, clk600 =>clk600_1, clk600_90 =>clk600_90_1, reset =>sreset, tdcclk =>tdcclk1, rstr =>rsd1, rdata =>rdd1, tdc_count =>TDC_COU1, bc_time =>BC_PER1, tdc_out =>TDC1D, tdc_rdy =>TDC1D_rdy0,
         tdc_raw=>TDC1D_raw, tdc_raw_lock=>spi_lock_1);

TDC2_CHA: TDCCHAN port map( pin_in =>CGE5i, pin_out =>CGE5, clk300 =>clk300_2, clk600 =>clk600_2, clk600_90 =>clk600_90_2, reset =>sreset, tdcclk =>tdcclk2, rstr =>rsa2, rdata =>rda2, tdc_count =>TDC_COU2, bc_time =>BC_PER2, tdc_out =>TDC2A, tdc_rdy =>TDC2A_rdy0,
         tdc_raw=>TDC2A_raw, tdc_raw_lock=>spi_lock_2);
TDC2_CHB: TDCCHAN port map( pin_in =>CGE6i, pin_out =>CGE6, clk300 =>clk300_2, clk600 =>clk600_2, clk600_90 =>clk600_90_2, reset =>sreset, tdcclk =>tdcclk2, rstr =>rsb2, rdata =>rdb2, tdc_count =>TDC_COU2, bc_time =>BC_PER2, tdc_out =>TDC2B, tdc_rdy =>TDC2B_rdy0,
         tdc_raw=>TDC2B_raw, tdc_raw_lock=>spi_lock_2);
TDC2_CHC: TDCCHAN port map( pin_in =>CGE7i, pin_out =>CGE7, clk300 =>clk300_2, clk600 =>clk600_2, clk600_90 =>clk600_90_2, reset =>sreset, tdcclk =>tdcclk2, rstr =>rsc2, rdata =>rdc2, tdc_count =>TDC_COU2, bc_time =>BC_PER2, tdc_out =>TDC2C, tdc_rdy =>TDC2C_rdy0,
         tdc_raw=>TDC2C_raw, tdc_raw_lock=>spi_lock_2);
TDC2_CHD: TDCCHAN port map( pin_in =>CGE8i, pin_out =>CGE8, clk300 =>clk300_2, clk600 =>clk600_2, clk600_90 =>clk600_90_2, reset =>sreset, tdcclk =>tdcclk2, rstr =>rsd2, rdata =>rdd2, tdc_count =>TDC_COU2, bc_time =>BC_PER2, tdc_out =>TDC2D, tdc_rdy =>TDC2D_rdy0,
         tdc_raw=>TDC2D_raw, tdc_raw_lock=>spi_lock_2);

TDC3_CHA: TDCCHAN port map( pin_in =>CGE9i, pin_out =>CGE9, clk300 =>clk300_3, clk600 =>clk600_3, clk600_90 =>clk600_90_3, reset =>sreset, tdcclk =>tdcclk3, rstr =>rsa3, rdata =>rda3, tdc_count =>TDC_COU3, bc_time =>BC_PER3, tdc_out =>TDC3A, tdc_rdy =>TDC3A_rdy0,
         tdc_raw=>TDC3A_raw, tdc_raw_lock=>spi_lock_3);
TDC3_CHB: TDCCHAN port map( pin_in =>CGE10i, pin_out =>CGE10, clk300 =>clk300_3, clk600 =>clk600_3, clk600_90 =>clk600_90_3, reset =>sreset, tdcclk =>tdcclk3, rstr =>rsb3, rdata =>rdb3, tdc_count =>TDC_COU3, bc_time =>BC_PER3, tdc_out =>TDC3B, tdc_rdy =>TDC3B_rdy0,
         tdc_raw=>TDC3B_raw, tdc_raw_lock=>spi_lock_3);
TDC3_CHC: TDCCHAN port map( pin_in =>CGE11i, pin_out =>CGE11, clk300 =>clk300_3, clk600 =>clk600_3, clk600_90 =>clk600_90_3, reset =>sreset, tdcclk =>tdcclk3, rstr =>rsc3, rdata =>rdc3, tdc_count =>TDC_COU3, bc_time =>BC_PER3, tdc_out =>TDC3C, tdc_rdy =>TDC3C_rdy0,
         tdc_raw=>TDC3C_raw, tdc_raw_lock=>spi_lock_3);
TDC3_CHD: TDCCHAN port map( pin_in =>CGE12i, pin_out =>CGE12, clk300 =>clk300_3, clk600 =>clk600_3, clk600_90 =>clk600_90_3, reset =>sreset, tdcclk =>tdcclk3, rstr =>rsd3, rdata =>rdd3, tdc_count =>TDC_COU3, bc_time =>BC_PER3, tdc_out =>TDC3D, tdc_rdy =>TDC3D_rdy0,
         tdc_raw=>TDC3D_raw, tdc_raw_lock=>spi_lock_3);



CHANNEL1A : channel port map (CGE =>CGE1, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC1A_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC1A, CSTR =>CSTR1, CH =>CH1, CH_shift => CH1A_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH1_0_zero, CH1_zero =>CH1_1_zero, CH_trig_outt =>CH_trig(0), CH_trig_outa =>CH_triga(0), CH_trig_bgnd=> trig_bgnd(0), CH_TIME =>CH_TIME_T(0),
                             CH_ampl =>CH_ampl0(0), DATA_out=>DATA_out(0), DATA_ready=>DATA_rdy(0), DATA_rd=>DATA_rd(0), FIFO_dis=>FIFO_dis, Event_in=>Event_in(0), Cal=>EVNTI, Z0_cal=>CH1_Z0, Z1_cal=>CH1_Z1, Cal_done=>Cal_done(0), spi_lock=>spi_lock320, R0_cal=>CH1_0_rg,
                             R1_cal=>CH1_1_rg, R0_corr=>CH1_0_rc, R1_corr=>CH1_1_rc, pulse_in=>inp_cou(0), chan_ena=>chans_ena(0));

CHANNEL1B : channel port map (CGE =>CGE2, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC1B_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC1B, CSTR =>CSTR2, CH =>CH2, CH_shift => CH1B_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH2_0_zero, CH1_zero =>CH2_1_zero, CH_trig_outt =>CH_trig(1), CH_trig_outa =>CH_triga(1), CH_trig_bgnd=> trig_bgnd(1), CH_TIME =>CH_TIME_T(1),
                             CH_ampl =>CH_ampl0(1), DATA_out=>DATA_out(1), DATA_ready=>DATA_rdy(1), DATA_rd=>DATA_rd(1), FIFO_dis=>FIFO_dis, Event_in=>Event_in(1), Cal=>EVNTI, Z0_cal=>CH2_Z0, Z1_cal=>CH2_Z1, Cal_done=>Cal_done(1),  spi_lock=>spi_lock320, R0_cal=>CH2_0_rg,
                             R1_cal=>CH2_1_rg, R0_corr=>CH2_0_rc, R1_corr=>CH2_1_rc, pulse_in=>inp_cou(1), chan_ena=>chans_ena(1));

CHANNEL1C : channel port map (CGE =>CGE3, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC1C_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC1C, CSTR =>CSTR3, CH =>CH3, CH_shift => CH1C_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH3_0_zero, CH1_zero =>CH3_1_zero, CH_trig_outt =>CH_trig(2), CH_trig_outa =>CH_triga(2), CH_trig_bgnd=> trig_bgnd(2), CH_TIME =>CH_TIME_T(2),
                             CH_ampl =>CH_ampl0(2), DATA_out=>DATA_out(2),DATA_ready=>DATA_rdy(2), DATA_rd=>DATA_rd(2), FIFO_dis=>FIFO_dis, Event_in=>Event_in(2), Cal=>EVNTI, Z0_cal=>CH3_Z0, Z1_cal=>CH3_Z1, Cal_done=>Cal_done(2),  spi_lock=>spi_lock320, R0_cal=>CH3_0_rg,
                             R1_cal=>CH3_1_rg, R0_corr=>CH3_0_rc, R1_corr=>CH3_1_rc, pulse_in=>inp_cou(2), chan_ena=>chans_ena(2));

CHANNEL1D : channel port map (CGE =>CGE4, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC1D_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC1D, CSTR =>CSTR4, CH =>CH4, CH_shift => CH1D_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH4_0_zero, CH1_zero =>CH4_1_zero, CH_trig_outt =>CH_trig(3), CH_trig_outa =>CH_triga(3), CH_trig_bgnd=> trig_bgnd(3), CH_TIME =>CH_TIME_T(3),
                             CH_ampl =>CH_ampl0(3), DATA_out=>DATA_out(3), DATA_ready=>DATA_rdy(3), DATA_rd=>DATA_rd(3), FIFO_dis=>FIFO_dis, Event_in=>Event_in(3), Cal=>EVNTI, Z0_cal=>CH4_Z0, Z1_cal=>CH4_Z1, Cal_done=>Cal_done(3),  spi_lock=>spi_lock320, R0_cal=>CH4_0_rg,
                             R1_cal=>CH4_1_rg, R0_corr=>CH4_0_rc, R1_corr=>CH4_1_rc, pulse_in=>inp_cou(3), chan_ena=>chans_ena(3));
                             
CHANNEL2A : channel port map (CGE =>CGE5, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC2A_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC2A, CSTR =>CSTR5, CH =>CH5, CH_shift => CH2A_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH5_0_zero, CH1_zero =>CH5_1_zero, CH_trig_outt =>CH_trig(4), CH_trig_outa =>CH_triga(4), CH_trig_bgnd=> trig_bgnd(4), CH_TIME =>CH_TIME_T(4),
                             CH_ampl =>CH_ampl0(4), DATA_out=>DATA_out(4), DATA_ready=>DATA_rdy(4), DATA_rd=>DATA_rd(4), FIFO_dis=>FIFO_dis, Event_in=>Event_in(4), Cal=>EVNTI, Z0_cal=>CH5_Z0, Z1_cal=>CH5_Z1, Cal_done=>Cal_done(4),  spi_lock=>spi_lock320, R0_cal=>CH5_0_rg,
                             R1_cal=>CH5_1_rg, R0_corr=>CH5_0_rc, R1_corr=>CH5_1_rc, pulse_in=>inp_cou(4), chan_ena=>chans_ena(4));
                             
CHANNEL2B : channel port map (CGE =>CGE6, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC2B_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC2B, CSTR =>CSTR6, CH =>CH6, CH_shift => CH2B_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH6_0_zero, CH1_zero =>CH6_1_zero, CH_trig_outt =>CH_trig(5), CH_trig_outa =>CH_triga(5), CH_trig_bgnd=> trig_bgnd(5), CH_TIME =>CH_TIME_T(5),
                             CH_ampl =>CH_ampl0(5), DATA_out=>DATA_out(5), DATA_ready=>DATA_rdy(5), DATA_rd=>DATA_rd(5), FIFO_dis=>FIFO_dis, Event_in=>Event_in(5), Cal=>EVNTI, Z0_cal=>CH6_Z0, Z1_cal=>CH6_Z1, Cal_done=>Cal_done(5),  spi_lock=>spi_lock320, R0_cal=>CH6_0_rg,
                             R1_cal=>CH6_1_rg, R0_corr=>CH6_0_rc, R1_corr=>CH6_1_rc, pulse_in=>inp_cou(5), chan_ena=>chans_ena(5));
                             
CHANNEL2C : channel port map (CGE =>CGE7, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC2C_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC2C, CSTR =>CSTR7, CH =>CH7, CH_shift => CH2C_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH7_0_zero, CH1_zero =>CH7_1_zero, CH_trig_outt =>CH_trig(6), CH_trig_outa =>CH_triga(6), CH_trig_bgnd=> trig_bgnd(6), CH_TIME =>CH_TIME_T(6),
                             CH_ampl =>CH_ampl0(6), DATA_out=>DATA_out(6), DATA_ready=>DATA_rdy(6), DATA_rd=>DATA_rd(6), FIFO_dis=>FIFO_dis, Event_in=>Event_in(6), Cal=>EVNTI, Z0_cal=>CH7_Z0, Z1_cal=>CH7_Z1, Cal_done=>Cal_done(6),  spi_lock=>spi_lock320, R0_cal=>CH7_0_rg,
                             R1_cal=>CH7_1_rg, R0_corr=>CH7_0_rc, R1_corr=>CH7_1_rc, pulse_in=>inp_cou(6), chan_ena=>chans_ena(6));
                             
CHANNEL2D : channel port map (CGE =>CGE8, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC2D_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC2D, CSTR =>CSTR8, CH =>CH8, CH_shift => CH2D_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH8_0_zero, CH1_zero =>CH8_1_zero, CH_trig_outt =>CH_trig(7), CH_trig_outa =>CH_triga(7), CH_trig_bgnd=> trig_bgnd(7), CH_TIME =>CH_TIME_T(7),
                             CH_ampl =>CH_ampl0(7), DATA_out=>DATA_out(7), DATA_ready=>DATA_rdy(7), DATA_rd=>DATA_rd(7), FIFO_dis=>FIFO_dis, Event_in=>Event_in(7), Cal=>EVNTI, Z0_cal=>CH8_Z0, Z1_cal=>CH8_Z1, Cal_done=>Cal_done(7),  spi_lock=>spi_lock320, R0_cal=>CH8_0_rg,
                             R1_cal=>CH8_1_rg, R0_corr=>CH8_0_rc, R1_corr=>CH8_1_rc, pulse_in=>inp_cou(7), chan_ena=>chans_ena(7));
                             
CHANNEL3A : channel port map (CGE =>CGE9, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC3A_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC3A, CSTR =>CSTR9, CH =>CH9, CH_shift => CH3A_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH9_0_zero, CH1_zero =>CH9_1_zero, CH_trig_outt =>CH_trig(8), CH_trig_outa =>CH_triga(8), CH_trig_bgnd=> trig_bgnd(8), CH_TIME =>CH_TIME_T(8),
                             CH_ampl =>CH_ampl0(8), DATA_out=>DATA_out(8), DATA_ready=>DATA_rdy(8), DATA_rd=>DATA_rd(8), FIFO_dis=>FIFO_dis, Event_in=>Event_in(8), Cal=>EVNTI, Z0_cal=>CH9_Z0, Z1_cal=>CH9_Z1, Cal_done=>Cal_done(8),  spi_lock=>spi_lock320, R0_cal=>CH9_0_rg,
                             R1_cal=>CH9_1_rg, R0_corr=>CH9_0_rc, R1_corr=>CH9_1_rc, pulse_in=>inp_cou(8), chan_ena=>chans_ena(8));
                                                           
CHANNEL3B : channel port map (CGE =>CGE10, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC3B_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC3B, CSTR =>CSTR10, CH =>CH10, CH_shift => CH3B_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH10_0_zero, CH1_zero =>CH10_1_zero, CH_trig_outt =>CH_trig(9), CH_trig_outa =>CH_triga(9), CH_trig_bgnd=> trig_bgnd(9), CH_TIME =>CH_TIME_T(9),
                             CH_ampl =>CH_ampl0(9), DATA_out=>DATA_out(9), DATA_ready=>DATA_rdy(9), DATA_rd=>DATA_rd(9), FIFO_dis=>FIFO_dis, Event_in=>Event_in(9), Cal=>EVNTI, Z0_cal=>CH10_Z0, Z1_cal=>CH10_Z1, Cal_done=>Cal_done(9),  spi_lock=>spi_lock320, R0_cal=>CH10_0_rg,
                             R1_cal=>CH10_1_rg, R0_corr=>CH10_0_rc, R1_corr=>CH10_1_rc, pulse_in=>inp_cou(9), chan_ena=>chans_ena(9));
                                                           
CHANNEL3C : channel port map (CGE =>CGE11, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC3C_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC3C, CSTR =>CSTR11, CH =>CH11, CH_shift => CH3C_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH11_0_zero, CH1_zero =>CH11_1_zero, CH_trig_outt =>CH_trig(10), CH_trig_outa =>CH_triga(10), CH_trig_bgnd=> trig_bgnd(10), CH_TIME =>CH_TIME_T(10),
                             CH_ampl =>CH_ampl0(10), DATA_out=>DATA_out(10), DATA_ready=>DATA_rdy(10), DATA_rd=>DATA_rd(10), FIFO_dis=>FIFO_dis, Event_in=>Event_in(10), Cal=>EVNTI, Z0_cal=>CH11_Z0, Z1_cal=>CH11_Z1, Cal_done=>Cal_done(10),  spi_lock=>spi_lock320, R0_cal=>CH11_0_rg,
                             R1_cal=>CH11_1_rg, R0_corr=>CH11_0_rc, R1_corr=>CH11_1_rc, pulse_in=>inp_cou(10), chan_ena=>chans_ena(10));
                                                           
CHANNEL3D : channel port map (CGE =>CGE12, clk320 =>clk320, reset =>sreset, tdc_rdy_in=> TDC3D_rdy0, mt_cou =>mt_cou, bc_cou =>BC_COU(5 downto 0), TR_bc =>TR_to, TDC =>TDC3D, CSTR =>CSTR12, CH =>CH12, CH_shift => CH3D_shift,
                             gate_time_low => gate_time_low, gate_time_high =>gate_time_high, Ampl_sat =>Ampl_sat, CH0_zero =>CH12_0_zero, CH1_zero =>CH12_1_zero, CH_trig_outt =>CH_trig(11), CH_trig_outa =>CH_triga(11), CH_trig_bgnd=> trig_bgnd(11), CH_TIME =>CH_TIME_T(11),
                             CH_ampl =>CH_ampl0(11), DATA_out=>DATA_out(11), DATA_ready=>DATA_rdy(11), DATA_rd=>DATA_rd(11), FIFO_dis=>FIFO_dis, Event_in=>Event_in(11), Cal=>EVNTI, Z0_cal=>CH12_Z0, Z1_cal=>CH12_Z1, Cal_done=>Cal_done(11),  spi_lock=>spi_lock320, R0_cal=>CH12_0_rg,
                             R1_cal=>CH12_1_rg, R0_corr=>CH12_0_rc, R1_corr=>CH12_1_rc, pulse_in=>inp_cou(11), chan_ena=>chans_ena(11));
                             
TRG0: trigger port map ( clk320=>clk320, mt_cou=>mt_cou, CH_trigt=>CH_trig, CH_triga=>CH_triga, CH_trigb=>trig_bgnd, CH_TIME_T=>CH_TIME_T, CH_ampl0=>CH_ampl0, tcm_req=>tcm_req, tt=>tt, ta=>ta);
 
EV_FIFO: EVENTID_FIFO port map (clk => clk320, srst =>sreset, din =>EV_ID_in, wr_en => EV_ID_wr, rd_en =>EV_ID_rd, dout => EV_ID_out, full =>open, empty =>EV_ID_empty);

EV_ID_in<= Orbit_ID & BC_Cou & Event_in;
EV_ID_wr<= '1' when (inp_event='1') and (mt_cou="001") else '0';
EV_ID_rd<= '1' when (EV_ID_empty='0') and ((Event_free='1') or ((Event_ready='1') and (CH_do=0)) or (ev_tout='1')) else '0';  

--OUT_FIFO: FIFO_OUT port map (rst =>sreset, wr_clk => clk320, rd_clk=>TX_CLK, din =>DATA80_in, wr_en => WR_fifo_out, rd_en =>DATA80_rd, dout => DATA80_out, full =>open, empty =>DATA_empty, wr_rst_busy => open, rd_rst_busy => open);

--DATA80_rd<= not DATA_empty;


count1: counters port map (clk=>clk320, evnt=>inp_cou, trig=>CH_trig, reset=>cnt_rst, dout=>cnt_out, hdout=>hcnt_out, raddr=>spi_addr(5 downto 0), hraddr=>hspi_addr(4 downto 0), hl=>hspi_h, rd_en=>cnt_rd, hrd_en=>hcnt_rd);



process(MCLK40, RESET)
begin
if (RESET='1') then sreset<='1'; rstcount<="0000"; else
if (MCLK40'event) and (MCLK40='1') then

alm_rst0 <=sreset;
all_locked <= lock320 and lock300_1 and lock300_2 and lock300_3;

if (rstcount="1111") then  sreset<='0'; else 
   if (all_locked='1') then rstcount<=rstcount+1; end if; 
   end if;
end if;
end if;
end process;

alm_rst<=not sreset and alm_rst0;

rd_lock_hspi <= '1' when  (hspi_bit_count(3 downto 0)=x"F") and (hspi_rd='1') and (hspi_addr(8)='0') else '0';
Hs_rd <= '1' when (hspi_bit_count="10000") and (hspi_rd='1') and (hspi_addr='0' & x"80") else alm_rst;
reg32_str <= '1' when ((hspi_bit_count="01010") or (hspi_bit_count="10000")) and (hspi_rd='1') and (hspi_addr(8)='0') else '0'; 
rd_xadc <= reg32_str when (hspi_addr(7 downto 2) = "111111") and (hspi_addr(1 downto 0) /= "11") else '0'; 
reg32_rd <=reg32_str when (hspi_addr(7 downto 3)>="11101") and (hspi_addr(7 downto 2)<"111111") else '0';  
flsh_sel<='1' when (hspi_addr(7 downto 2)="111110") else '0';

process (HSCKI, HSELI, RESET)
begin
if (HSELI='0') then hspi_bit_count<="00000"; hcnt_rd<='0'; hspibuf_wr<='0'; hspibuf_rd<='0'; hspi_na<='0'; reg32_wr<='0';
else
if (HSCKI'event and HSCKI='0') then 

        if (hspi_bit_count="11111") then  hspi_bit_count<="10000"; hspi_na<='1';
              if  (hspi_rd='0') then 
                 if (hspi_h='0') then hspi_wr_data<=HSPI_DATA(14 downto 0) & HMOSII;
                  else hspi_wr_data_l<=HSPI_DATA(14 downto 0) & HMOSII;
                 end if;
                if (hspi_addr(7)='0') then  hspi_wr_rdy<='1'; end if;
                if (hspi_addr(7 downto 6)="10") then hspibuf_wr<='1'; end if; 
                if (hspi_addr(7 downto 3)>="11011") and (hspi_h='1') then reg32_wr<='1'; end if; 
                  
              end if;
        else 
        hspi_bit_count<=hspi_bit_count+1; 
        end if;
        
        if (hspi_bit_count="10000") then hspi_wr_rdy<='0'; hspibuf_wr<='0'; reg32_wr<='0';
           if (hspi_rd='0') and (hspi_na='1') then
             if (hspi_addr(7 downto 4)<x"C") or (hspi_h='1') then hspi_addr <= hspi_addr+1; end if;
             if  (hspi_addr(7 downto 3)>="11011") then hspi_h<= not hspi_h;  end if;
           end if; 
           
        end if;
        if (hspi_bit_count="00000") then hspi_rd <= HMOSII; end if;
        if (hspi_bit_count="01001") then hspi_addr <= HSPI_DATA(7 downto 0) & HMOSII; hspi_h<='0'; end if;
        if (hspi_bit_count="01110") and (hspi_rd='1') and (hspi_addr(7 downto 0)=x"C0") then hcnt_rd<='1'; end if;
               
        if (hspi_bit_count(3 downto 0)="1110") and (hspi_rd='1') and (hspi_addr(7 downto 6)="10") then hspibuf_rd<='1';  end if; 
        
        if  (rd_lock_hspi='1') then 
             hspibuf_rd<='0';  hspi_h<= not hspi_h; 
         
             if (hspi_addr(7 downto 4)<x"C") or (hspi_h='1') then hspi_addr <= hspi_addr+1; end if;
             if (hspi_addr(7 downto 3)>="11101")  and (hspi_h='1') then HSPI_DATA<=hspi_32l;
            
             else

          case to_integer(unsigned(hspi_addr(7 downto 0))) is
            when 0 => HSPI_DATA<=x"00" & gate_time_high; 
            when 1 => HSPI_DATA<=x"0" & CH1A_shift;
            when 2 => HSPI_DATA<=x"0" & CH1B_shift; 
            when 3 => HSPI_DATA<=x"0" & CH1C_shift; 
            when 4 => HSPI_DATA<=x"0" & CH1D_shift; 
            when 5 => HSPI_DATA<=x"0" & CH2A_shift;
            when 6 => HSPI_DATA<=x"0" & CH2B_shift; 
            when 7 => HSPI_DATA<=x"0" & CH2C_shift; 
            when 8 => HSPI_DATA<=x"0" & CH2D_shift; 
            when 9 => HSPI_DATA<=x"0" & CH3A_shift;
            when 16#A# => HSPI_DATA<=x"0" & CH3B_shift; 
            when 16#B# => HSPI_DATA<=x"0" & CH3C_shift; 
            when 16#C# => HSPI_DATA<=x"0" & CH3D_shift; 

            when 16#D# => HSPI_DATA<=x"0" & CH1_0_zero; 
            when 16#E# => HSPI_DATA<=x"0" & CH1_1_zero;
            when 16#F# => HSPI_DATA<=x"0" & CH2_0_zero;
            when 16#10# => HSPI_DATA<=x"0" & CH2_1_zero;
            when 16#11# => HSPI_DATA<=x"0" & CH3_0_zero; 
            when 16#12# => HSPI_DATA<=x"0" & CH3_1_zero;
            when 16#13# => HSPI_DATA<=x"0" & CH4_0_zero;
            when 16#14# => HSPI_DATA<=x"0" & CH4_1_zero;
            when 16#15# => HSPI_DATA<=x"0" & CH5_0_zero; 
            when 16#16# => HSPI_DATA<=x"0" & CH5_1_zero;
            when 16#17# => HSPI_DATA<=x"0" & CH6_0_zero;
            when 16#18# => HSPI_DATA<=x"0" & CH6_1_zero;
            when 16#19# => HSPI_DATA<=x"0" & CH7_0_zero; 
            when 16#1A# => HSPI_DATA<=x"0" & CH7_1_zero;
            when 16#1B# => HSPI_DATA<=x"0" & CH8_0_zero;
            when 16#1C# => HSPI_DATA<=x"0" & CH8_1_zero;
            when 16#1D# => HSPI_DATA<=x"0" & CH9_0_zero; 
            when 16#1E# => HSPI_DATA<=x"0" & CH9_1_zero;
            when 16#1F# => HSPI_DATA<=x"0" & CH10_0_zero;
            when 16#20# => HSPI_DATA<=x"0" & CH10_1_zero;
            when 16#21# => HSPI_DATA<=x"0" & CH11_0_zero; 
            when 16#22# => HSPI_DATA<=x"0" & CH11_1_zero;
            when 16#23# => HSPI_DATA<=x"0" & CH12_0_zero;
            when 16#24# => HSPI_DATA<=x"0" & CH12_1_zero;

            when 16#25# => HSPI_DATA<=x"0" & CH1_0_rc; 
            when 16#26# => HSPI_DATA<=x"0" & CH1_1_rc;
            when 16#27# => HSPI_DATA<=x"0" & CH2_0_rc;
            when 16#28# => HSPI_DATA<=x"0" & CH2_1_rc;
            when 16#29# => HSPI_DATA<=x"0" & CH3_0_rc; 
            when 16#2A# => HSPI_DATA<=x"0" & CH3_1_rc;
            when 16#2B# => HSPI_DATA<=x"0" & CH4_0_rc;
            when 16#2C# => HSPI_DATA<=x"0" & CH4_1_rc;
            when 16#2D# => HSPI_DATA<=x"0" & CH5_0_rc; 
            when 16#2E# => HSPI_DATA<=x"0" & CH5_1_rc;
            when 16#2F# => HSPI_DATA<=x"0" & CH6_0_rc;
            when 16#30# => HSPI_DATA<=x"0" & CH6_1_rc;
            when 16#31# => HSPI_DATA<=x"0" & CH7_0_rc; 
            when 16#32# => HSPI_DATA<=x"0" & CH7_1_rc;
            when 16#33# => HSPI_DATA<=x"0" & CH8_0_rc;
            when 16#34# => HSPI_DATA<=x"0" & CH8_1_rc;
            when 16#35# => HSPI_DATA<=x"0" & CH9_0_rc; 
            when 16#36# => HSPI_DATA<=x"0" & CH9_1_rc;
            when 16#37# => HSPI_DATA<=x"0" & CH10_0_rc;
            when 16#38# => HSPI_DATA<=x"0" & CH10_1_rc;
            when 16#39# => HSPI_DATA<=x"0" & CH11_0_rc; 
            when 16#3A# => HSPI_DATA<=x"0" & CH11_1_rc;
            when 16#3B# => HSPI_DATA<=x"0" & CH12_0_rc;
            when 16#3C# => HSPI_DATA<=x"0" & CH12_1_rc;
            when 16#3D# => HSPI_DATA<=x"0" & Ampl_sat;
            
            when 16#3E# => HSPI_DATA<=pshift2(5) & pshift2(5) & pshift2 & pshift1(5) & pshift1(5) & pshift1;
            when 16#3F# => HSPI_DATA<=x"00" & pshift3(5) & pshift3(5) & pshift3;
                        
                        
            when 16#40# => HSPI_DATA<="00" & TDC1A_raw (12 downto 7) & '0' & TDC1A_raw(6 downto 0);
            when 16#41# => HSPI_DATA<="00" & TDC1B_raw (12 downto 7) & '0' & TDC1B_raw(6 downto 0);
            when 16#42# => HSPI_DATA<="00" & TDC1C_raw (12 downto 7) & '0' & TDC1C_raw(6 downto 0);
            when 16#43# => HSPI_DATA<="00" & TDC1D_raw (12 downto 7) & '0' & TDC1D_raw(6 downto 0);
            when 16#44# => HSPI_DATA<="00" & TDC2A_raw (12 downto 7) & '0' & TDC2A_raw(6 downto 0);
            when 16#45# => HSPI_DATA<="00" & TDC2B_raw (12 downto 7) & '0' & TDC2B_raw(6 downto 0);
            when 16#46# => HSPI_DATA<="00" & TDC2C_raw (12 downto 7) & '0' & TDC2C_raw(6 downto 0);
            when 16#47# => HSPI_DATA<="00" & TDC2D_raw (12 downto 7) & '0' & TDC2D_raw(6 downto 0);
            when 16#48# => HSPI_DATA<="00" & TDC3A_raw (12 downto 7) & '0' & TDC3A_raw(6 downto 0);
            when 16#49# => HSPI_DATA<="00" & TDC3B_raw (12 downto 7) & '0' & TDC3B_raw(6 downto 0);
            when 16#4A# => HSPI_DATA<="00" & TDC3C_raw (12 downto 7) & '0' & TDC3C_raw(6 downto 0);
            when 16#4B# => HSPI_DATA<="00" & TDC3D_raw (12 downto 7) & '0' & TDC3D_raw(6 downto 0);
            
            when 16#4C# =>  HSPI_DATA<=x"0" & CH1_Z0;
            when 16#4D# =>  HSPI_DATA<=x"0" & CH1_Z1;
            when 16#4E# =>  HSPI_DATA<=x"0" & CH2_Z0;
            when 16#4F# =>  HSPI_DATA<=x"0" & CH2_Z1;
            when 16#50# =>  HSPI_DATA<=x"0" & CH3_Z0;
            when 16#51# =>  HSPI_DATA<=x"0" & CH3_Z1;
            when 16#52# =>  HSPI_DATA<=x"0" & CH4_Z0;
            when 16#53# =>  HSPI_DATA<=x"0" & CH4_Z1;
            when 16#54# =>  HSPI_DATA<=x"0" & CH5_Z0;
            when 16#55# =>  HSPI_DATA<=x"0" & CH5_Z1;
            when 16#56# =>  HSPI_DATA<=x"0" & CH6_Z0;
            when 16#57# =>  HSPI_DATA<=x"0" & CH6_Z1;
            when 16#58# =>  HSPI_DATA<=x"0" & CH7_Z0;
            when 16#59# =>  HSPI_DATA<=x"0" & CH7_Z1;
            when 16#5A# =>  HSPI_DATA<=x"0" & CH8_Z0;
            when 16#5B# =>  HSPI_DATA<=x"0" & CH8_Z1;
            when 16#5C# =>  HSPI_DATA<=x"0" & CH9_Z0;
            when 16#5D# =>  HSPI_DATA<=x"0" & CH9_Z1;
            when 16#5E# =>  HSPI_DATA<=x"0" & CH10_Z0;
            when 16#5F# =>  HSPI_DATA<=x"0" & CH10_Z1;
            when 16#60# =>  HSPI_DATA<=x"0" & CH11_Z0;
            when 16#61# =>  HSPI_DATA<=x"0" & CH11_Z1;
            when 16#62# =>  HSPI_DATA<=x"0" & CH12_Z0;
            when 16#63# =>  HSPI_DATA<=x"0" & CH12_Z1;
            
            when 16#64# =>  HSPI_DATA<=x"0" & CH1_0_rg;
            when 16#65# =>  HSPI_DATA<=x"0" & CH1_1_rg;
            when 16#66# =>  HSPI_DATA<=x"0" & CH2_0_rg;
            when 16#67# =>  HSPI_DATA<=x"0" & CH2_1_rg;
            when 16#68# =>  HSPI_DATA<=x"0" & CH3_0_rg;
            when 16#69# =>  HSPI_DATA<=x"0" & CH3_1_rg;
            when 16#6A# =>  HSPI_DATA<=x"0" & CH4_0_rg;
            when 16#6B# =>  HSPI_DATA<=x"0" & CH4_1_rg;
            when 16#6C# =>  HSPI_DATA<=x"0" & CH5_0_rg;
            when 16#6D# =>  HSPI_DATA<=x"0" & CH5_1_rg;
            when 16#6E# =>  HSPI_DATA<=x"0" & CH6_0_rg;
            when 16#6F# =>  HSPI_DATA<=x"0" & CH6_1_rg;
            when 16#70# =>  HSPI_DATA<=x"0" & CH7_0_rg;
            when 16#71# =>  HSPI_DATA<=x"0" & CH7_1_rg;
            when 16#72# =>  HSPI_DATA<=x"0" & CH8_0_rg;
            when 16#73# =>  HSPI_DATA<=x"0" & CH8_1_rg;
            when 16#74# =>  HSPI_DATA<=x"0" & CH9_0_rg;
            when 16#75# =>  HSPI_DATA<=x"0" & CH9_1_rg;
            when 16#76# =>  HSPI_DATA<=x"0" & CH10_0_rg;
            when 16#77# =>  HSPI_DATA<=x"0" & CH10_1_rg;
            when 16#78# =>  HSPI_DATA<=x"0" & CH11_0_rg;
            when 16#79# =>  HSPI_DATA<=x"0" & CH11_1_rg;
            when 16#7A# =>  HSPI_DATA<=x"0" & CH12_0_rg;
            when 16#7B# =>  HSPI_DATA<=x"0" & CH12_1_rg;
            
            when 16#7C# =>  HSPI_DATA<=x"0" & chans_ena_r;

            when 16#7F# =>  HSPI_DATA<= gbt_global_status & '0' & EVNTI & '0' &  HBC_JUMP3 & HBC_JUMP2 & HBC_JUMP1 & HGBTRXerr & GBTRX_ready & lock300_3 & lock300_2 & lock300_1 & lock320;
            when 16#80# to 16#BF# => HSPI_DATA<=hspi_buf_out;
            
            when 16#C0# to 16#D7# => HSPI_DATA<=hcnt_out;
            
            -- gbt status            ipbus_control_reg
            when 16#D8# to 16#e7#  => if (hspi_h='0') then HSPI_DATA<=ipbus_control_reg(to_integer(unsigned(hspi_addr(7 downto 0)))-16#D8#)(31 downto 16);
                                          else HSPI_DATA<=ipbus_control_reg(to_integer(unsigned(hspi_addr(7 downto 0)))-16#D8#)(15 downto 0); end if;

            when 16#E8# to 16#FB# => HSPI_DATA<=hspib_32(31 downto 16); hspi_32l <=hspib_32(15 downto 0); 
                                          
            when 16#FC# to 16#FE# => HSPI_DATA<=(others=>'0'); hspi_32l <=xadc_r;
                                          
            when 16#FF#  => HSPI_DATA<=tstamp(31 downto 16); hspi_32l <=tstamp(15 downto 0);
                                          
            
            when others =>  HSPI_DATA<=x"0000";
                           
          end case;
         end if;           
        else HSPI_DATA<=HSPI_DATA(14 downto 0) & HMOSII; 
        end if;
         
end if;

end if;
end process;

UA2 : USR_ACCESSE2   port map (CFGCLK => open, DATA => tstamp, DATAVALID => open );

SNS : SENSOR  PORT MAP ( di_in => (others=>'0'), daddr_in => xadc_a, den_in => xadc_en, dwe_in => '0', drdy_out => xadc_rdy, do_out => xadc_out, dclk_in => TX_CLK,
             reset_in => sreset, vp_in => '0', vn_in => '0', channel_out => open,  eoc_out => open, alarm_out => open, eos_out => open, busy_out => open);

xadc_a<="00000" & hspi_addr(1 downto 0); xadc_en <= xadc_rq1 and not xadc_rq2;

TCM_reqh <= HBC_JUMP3 or HBC_JUMP2 or HBC_JUMP1 or HGBTRXerr or HGBT_chg;

rd_lock_spi <= '1' when (spi_bit_count(3 downto 0)=x"F") and (spi_rd='1') and (spi_addr(8)='0') else '0';
ALM_CLR <= '1' when (spi_bit_count="10000") and (spi_rd='1') and (spi_addr='0' & x"80") else '0';
buf_lock <= '1' when (spi_bit_count(3 downto 0)=x"A") and (spi_rd='1') and (spi_addr='0' & x"F0") else '0';

process (SCKI, SPI_CS)
begin
if (SPI_CS='1') then spi_bit_count<="00000"; cnt_rd<='0'; spibuf_wr<='0'; spibuf_rd<='0'; spi_na<='0'; else

if (SCKi'event and SCKi='0') then MISOI<=SPI_DATA(15); end if;

if (SCKI'event and SCKI='1') then

        if (spi_bit_count="11111") then spi_bit_count<="10000"; spi_na<='1';
          if  (spi_rd='0') then   spi_wr_data<=SPI_DATA(14 downto 0) & MOSII;  
            if (spi_addr(7)='0') then  spi_wr_rdy<='1'; else if (spi_addr(6)='0') then spibuf_wr<='1'; end if; end if;
          end if;
         else 
         spi_bit_count<=spi_bit_count+1; 
        end if;
        if (spi_bit_count="10000") then spi_wr_rdy<='0'; spibuf_wr<='0'; if (spi_rd='0') and (spi_na='1') then spi_addr <= spi_addr+1; end if; end if;
        if (spi_bit_count="00000") then spi_rd <= MOSII; end if;
        if (spi_bit_count="01001") then spi_addr <= SPI_DATA(7 downto 0) & MOSII; end if;
        if (spi_bit_count="01110") and (spi_rd='1') and (spi_addr(7 downto 0)=x"C0") then cnt_rd<='1'; end if;
        
        if (spi_bit_count(3 downto 0)="1110") and (spi_rd='1') and (spi_addr(7 downto 6)="10") then spibuf_rd<='1'; end if; 
                     
        if (rd_lock_spi='1') then  spibuf_rd<='0'; spi_addr <= spi_addr+1; 

          case to_integer(unsigned(spi_addr(7 downto 0))) is
            when 0 => SPI_DATA<=x"00" & gate_time_high; 
            when 1 => SPI_DATA<=x"0" & CH1A_shift;
            when 2 => SPI_DATA<=x"0" & CH1B_shift; 
            when 3 => SPI_DATA<=x"0" & CH1C_shift; 
            when 4 => SPI_DATA<=x"0" & CH1D_shift; 
            when 5 => SPI_DATA<=x"0" & CH2A_shift;
            when 6 => SPI_DATA<=x"0" & CH2B_shift; 
            when 7 => SPI_DATA<=x"0" & CH2C_shift; 
            when 8 => SPI_DATA<=x"0" & CH2D_shift; 
            when 9 => SPI_DATA<=x"0" & CH3A_shift;
            when 16#A# => SPI_DATA<=x"0" & CH3B_shift; 
            when 16#B# => SPI_DATA<=x"0" & CH3C_shift; 
            when 16#C# => SPI_DATA<=x"0" & CH3D_shift; 

            when 16#D# => SPI_DATA<=x"0" & CH1_0_zero; 
            when 16#E# => SPI_DATA<=x"0" & CH1_1_zero;
            when 16#F# => SPI_DATA<=x"0" & CH2_0_zero;
            when 16#10# => SPI_DATA<=x"0" & CH2_1_zero;
            when 16#11# => SPI_DATA<=x"0" & CH3_0_zero; 
            when 16#12# => SPI_DATA<=x"0" & CH3_1_zero;
            when 16#13# => SPI_DATA<=x"0" & CH4_0_zero;
            when 16#14# => SPI_DATA<=x"0" & CH4_1_zero;
            when 16#15# => SPI_DATA<=x"0" & CH5_0_zero; 
            when 16#16# => SPI_DATA<=x"0" & CH5_1_zero;
            when 16#17# => SPI_DATA<=x"0" & CH6_0_zero;
            when 16#18# => SPI_DATA<=x"0" & CH6_1_zero;
            when 16#19# => SPI_DATA<=x"0" & CH7_0_zero; 
            when 16#1A# => SPI_DATA<=x"0" & CH7_1_zero;
            when 16#1B# => SPI_DATA<=x"0" & CH8_0_zero;
            when 16#1C# => SPI_DATA<=x"0" & CH8_1_zero;
            when 16#1D# => SPI_DATA<=x"0" & CH9_0_zero; 
            when 16#1E# => SPI_DATA<=x"0" & CH9_1_zero;
            when 16#1F# => SPI_DATA<=x"0" & CH10_0_zero;
            when 16#20# => SPI_DATA<=x"0" & CH10_1_zero;
            when 16#21# => SPI_DATA<=x"0" & CH11_0_zero; 
            when 16#22# => SPI_DATA<=x"0" & CH11_1_zero;
            when 16#23# => SPI_DATA<=x"0" & CH12_0_zero;
            when 16#24# => SPI_DATA<=x"0" & CH12_1_zero;

            when 16#25# => SPI_DATA<=x"0" & CH1_0_rc; 
            when 16#26# => SPI_DATA<=x"0" & CH1_1_rc;
            when 16#27# => SPI_DATA<=x"0" & CH2_0_rc;
            when 16#28# => SPI_DATA<=x"0" & CH2_1_rc;
            when 16#29# => SPI_DATA<=x"0" & CH3_0_rc; 
            when 16#2A# => SPI_DATA<=x"0" & CH3_1_rc;
            when 16#2B# => SPI_DATA<=x"0" & CH4_0_rc;
            when 16#2C# => SPI_DATA<=x"0" & CH4_1_rc;
            when 16#2D# => SPI_DATA<=x"0" & CH5_0_rc; 
            when 16#2E# => SPI_DATA<=x"0" & CH5_1_rc;
            when 16#2F# => SPI_DATA<=x"0" & CH6_0_rc;
            when 16#30# => SPI_DATA<=x"0" & CH6_1_rc;
            when 16#31# => SPI_DATA<=x"0" & CH7_0_rc; 
            when 16#32# => SPI_DATA<=x"0" & CH7_1_rc;
            when 16#33# => SPI_DATA<=x"0" & CH8_0_rc;
            when 16#34# => SPI_DATA<=x"0" & CH8_1_rc;
            when 16#35# => SPI_DATA<=x"0" & CH9_0_rc; 
            when 16#36# => SPI_DATA<=x"0" & CH9_1_rc;
            when 16#37# => SPI_DATA<=x"0" & CH10_0_rc;
            when 16#38# => SPI_DATA<=x"0" & CH10_1_rc;
            when 16#39# => SPI_DATA<=x"0" & CH11_0_rc; 
            when 16#3A# => SPI_DATA<=x"0" & CH11_1_rc;
            when 16#3B# => SPI_DATA<=x"0" & CH12_0_rc;
            when 16#3C# => SPI_DATA<=x"0" & CH12_1_rc;
            when 16#3D# => SPI_DATA<=x"0" & Ampl_sat;

            when 16#3E# => SPI_DATA<=pshift2(5) & pshift2(5) & pshift2 & pshift1(5) & pshift1(5) & pshift1;
            when 16#3F# => SPI_DATA<=x"00" & pshift3(5) & pshift3(5) & pshift3;
                        
            when 16#40# => SPI_DATA<="00" & TDC1A_raw (12 downto 7) & '0' & TDC1A_raw(6 downto 0);
            when 16#41# => SPI_DATA<="00" & TDC1B_raw (12 downto 7) & '0' & TDC1B_raw(6 downto 0);
            when 16#42# => SPI_DATA<="00" & TDC1C_raw (12 downto 7) & '0' & TDC1C_raw(6 downto 0);
            when 16#43# => SPI_DATA<="00" & TDC1D_raw (12 downto 7) & '0' & TDC1D_raw(6 downto 0);
            when 16#44# => SPI_DATA<="00" & TDC2A_raw (12 downto 7) & '0' & TDC2A_raw(6 downto 0);
            when 16#45# => SPI_DATA<="00" & TDC2B_raw (12 downto 7) & '0' & TDC2B_raw(6 downto 0);
            when 16#46# => SPI_DATA<="00" & TDC2C_raw (12 downto 7) & '0' & TDC2C_raw(6 downto 0);
            when 16#47# => SPI_DATA<="00" & TDC2D_raw (12 downto 7) & '0' & TDC2D_raw(6 downto 0);
            when 16#48# => SPI_DATA<="00" & TDC3A_raw (12 downto 7) & '0' & TDC3A_raw(6 downto 0);
            when 16#49# => SPI_DATA<="00" & TDC3B_raw (12 downto 7) & '0' & TDC3B_raw(6 downto 0);
            when 16#4A# => SPI_DATA<="00" & TDC3C_raw (12 downto 7) & '0' & TDC3C_raw(6 downto 0);
            when 16#4B# => SPI_DATA<="00" & TDC3D_raw (12 downto 7) & '0' & TDC3D_raw(6 downto 0);
            
            when 16#4C# =>  SPI_DATA<=x"0" & CH1_Z0;
            when 16#4D# =>  SPI_DATA<=x"0" & CH1_Z1;
            when 16#4E# =>  SPI_DATA<=x"0" & CH2_Z0;
            when 16#4F# =>  SPI_DATA<=x"0" & CH2_Z1;
            when 16#50# =>  SPI_DATA<=x"0" & CH3_Z0;
            when 16#51# =>  SPI_DATA<=x"0" & CH3_Z1;
            when 16#52# =>  SPI_DATA<=x"0" & CH4_Z0;
            when 16#53# =>  SPI_DATA<=x"0" & CH4_Z1;
            when 16#54# =>  SPI_DATA<=x"0" & CH5_Z0;
            when 16#55# =>  SPI_DATA<=x"0" & CH5_Z1;
            when 16#56# =>  SPI_DATA<=x"0" & CH6_Z0;
            when 16#57# =>  SPI_DATA<=x"0" & CH6_Z1;
            when 16#58# =>  SPI_DATA<=x"0" & CH7_Z0;
            when 16#59# =>  SPI_DATA<=x"0" & CH7_Z1;
            when 16#5A# =>  SPI_DATA<=x"0" & CH8_Z0;
            when 16#5B# =>  SPI_DATA<=x"0" & CH8_Z1;
            when 16#5C# =>  SPI_DATA<=x"0" & CH9_Z0;
            when 16#5D# =>  SPI_DATA<=x"0" & CH9_Z1;
            when 16#5E# =>  SPI_DATA<=x"0" & CH10_Z0;
            when 16#5F# =>  SPI_DATA<=x"0" & CH10_Z1;
            when 16#60# =>  SPI_DATA<=x"0" & CH11_Z0;
            when 16#61# =>  SPI_DATA<=x"0" & CH11_Z1;
            when 16#62# =>  SPI_DATA<=x"0" & CH12_Z0;
            when 16#63# =>  SPI_DATA<=x"0" & CH12_Z1;
            
            when 16#64# =>  SPI_DATA<=x"0" & CH1_0_rg;
            when 16#65# =>  SPI_DATA<=x"0" & CH1_1_rg;
            when 16#66# =>  SPI_DATA<=x"0" & CH2_0_rg;
            when 16#67# =>  SPI_DATA<=x"0" & CH2_1_rg;
            when 16#68# =>  SPI_DATA<=x"0" & CH3_0_rg;
            when 16#69# =>  SPI_DATA<=x"0" & CH3_1_rg;
            when 16#6A# =>  SPI_DATA<=x"0" & CH4_0_rg;
            when 16#6B# =>  SPI_DATA<=x"0" & CH4_1_rg;
            when 16#6C# =>  SPI_DATA<=x"0" & CH5_0_rg;
            when 16#6D# =>  SPI_DATA<=x"0" & CH5_1_rg;
            when 16#6E# =>  SPI_DATA<=x"0" & CH6_0_rg;
            when 16#6F# =>  SPI_DATA<=x"0" & CH6_1_rg;
            when 16#70# =>  SPI_DATA<=x"0" & CH7_0_rg;
            when 16#71# =>  SPI_DATA<=x"0" & CH7_1_rg;
            when 16#72# =>  SPI_DATA<=x"0" & CH8_0_rg;
            when 16#73# =>  SPI_DATA<=x"0" & CH8_1_rg;
            when 16#74# =>  SPI_DATA<=x"0" & CH9_0_rg;
            when 16#75# =>  SPI_DATA<=x"0" & CH9_1_rg;
            when 16#76# =>  SPI_DATA<=x"0" & CH10_0_rg;
            when 16#77# =>  SPI_DATA<=x"0" & CH10_1_rg;
            when 16#78# =>  SPI_DATA<=x"0" & CH11_0_rg;
            when 16#79# =>  SPI_DATA<=x"0" & CH11_1_rg;
            when 16#7A# =>  SPI_DATA<=x"0" & CH12_0_rg;
            when 16#7B# =>  SPI_DATA<=x"0" & CH12_1_rg;
            
            when 16#7C# =>  SPI_DATA<=x"0" & chans_ena_r;

            when 16#7F# =>  SPI_DATA<=x"0" & '0'& EVNTI & dcs_irq & BC_JUMP3 & BC_JUMP2 & BC_JUMP1 & GBTRXerr & GBTRX_ready & lock300_3 & lock300_2 & lock300_1 & lock320;
            when 16#80# to 16#BF# => SPI_DATA<=spi_buf_out;
            when 16#C0# to 16#EF# => SPI_DATA<=cnt_out;
            when 16#F0#  => SPI_DATA<=rd_buf_vector(15 downto 0);
            when 16#F1#  => SPI_DATA<=rd_buf_vector(31 downto 16);
            when 16#F2#  => SPI_DATA<=rd_buf_vector(47 downto 32);
            when 16#F3#  => SPI_DATA<=x"0" & rd_buf_vector(59 downto 48);
            
            when others =>  SPI_DATA<=x"0000";
             
          end case;
        else SPI_DATA<=SPI_DATA(14 downto 0) & MOSII; 
        end if;
         
end if;
end if;
end process;

hspid_w32 <= hspi_wr_data & hspi_wr_data_l; 

wr_hspi32 <= '1' when (reg32_wr2='0') and (reg32_wr1='1') else '0';
rd_hspi32 <= '1' when (reg32_rd2='0') and (reg32_rd1='1') else '0';

reg_wr_data<= spi_wr_data when  (spi_wr_req='1') else  hspi_wr_data; 
reg_wr_addr<= spi_addr when  (spi_wr_req='1') else  hspi_addr; 

process(TX_CLK, sreset)
begin
if sreset='1' then buf_vector<=x"000000000000000"; buf_cou<=x"A0"; dcs_irq<='0'; vect_clr_req<='0'; ipbus_control_reg(0)<= x"0040_0000";
else 
if (TX_CLK'event and TX_CLK='1') then

reg32_wr2<=reg32_wr1; reg32_wr1<=reg32_wr0; reg32_wr0<=reg32_wr; reg32_rd2<=reg32_rd1; reg32_rd1<=reg32_rd0; reg32_rd0<=reg32_rd;
spibuf_wr2<=spibuf_wr1; spibuf_wr1<=spibuf_wr0; spibuf_wr0<=spibuf_wr; hspibuf_wr2<=hspibuf_wr1; hspibuf_wr1<=hspibuf_wr0; hspibuf_wr0<=hspibuf_wr;
spibuf_rd2<=spibuf_rd1; spibuf_rd1<=spibuf_rd0; spibuf_rd0<=spibuf_rd; hspibuf_rd2<=hspibuf_rd1; hspibuf_rd1<=hspibuf_rd0; hspibuf_rd0<=hspibuf_rd;

buf_lock2<=buf_lock1; buf_lock1<=buf_lock0; buf_lock0<=buf_lock;

hbuf_req <= (not hspibuf_wr2) and hspibuf_wr1 and sbuf_wrena; 

if (rd_hspi32='1') then 
   if (flsh_sel='0') then hspib_32 <=ipbus_status_reg(to_integer(unsigned(hspi_addr(7 downto 0)))-16#E8#);
       else hspib_32 <=hspid_r32;
   end if;
end if;   
   

 if (hbuf_wrena='1') and (hspi_addr(5 downto 0)<"111100") then buf_vector(to_integer(unsigned(hspi_addr(5 downto 0))))<='1'; buf_cou<=x"00"; 
   if (vect_clr='1') then vect_clr_req<='1'; end if;
  else
   vect_clr_req<='0';
   if (vect_clr='1') or (vect_clr_req='1') then rd_buf_vector<=buf_vector; buf_vector<=x"000000000000000"; end if;
   if (buf_cou/=x"A0") then buf_cou<=buf_cou+1; end if; 
 
 end if;
 
 
 if (buf_cou=x"9F") then dcs_irq<='1'; 
  else if (stat_clr1='1') and (stat_clr='0') then dcs_irq<='0'; end if;
 end if;

if (GBTRX_ready='0') and (GBTRX_ready0='1') then ipbus_control_reg(0)(22)<='1';
  else  
     if (reg32_wr2='0') and (reg32_wr1='1') and (hspi_addr(7 downto 0)<=16#E7#)  then
        if  (hspi_addr(7 downto 0)=16#D8#) then ipbus_control_reg(0)<= hspid_w32(31 downto 23) & (hspid_w32(22) or not GBTRX_ready) & hspid_w32(21 downto 0);
           else  ipbus_control_reg(to_integer(unsigned(hspi_addr(7 downto 0)))-16#D8#)<= hspid_w32;
        end if;
   end if; 
 end if; 
           

 
end if;
end if;
end process;

vect_clr<=(not buf_lock2) and buf_lock1; 
sbuf_wrena<=(not spibuf_wr2) and spibuf_wr1; sbuf_rdena<=(not spibuf_rd2) and spibuf_rd1;
hbuf_wrena<=((not hspibuf_wr2) and hspibuf_wr1 and (not sbuf_wrena)) or  hbuf_req; 
hbuf_rdena<=(not hspibuf_rd2) and hspibuf_rd1;
sbuf_ena<=sbuf_wrena or sbuf_rdena; hbuf_ena<=hbuf_wrena or hbuf_rdena;

Xmegamem : Xmega_buf PORT MAP (clka => TX_CLK, ena => hbuf_ena, wea(0) => hbuf_wrena, addra => hspi_addr(5 downto 0), dina => hspi_wr_data, douta=>hspi_buf_out, clkb => TX_CLK, enb => sbuf_ena, web(0) => sbuf_wrena, addrb => spi_addr(5 downto 0), dinb => spi_wr_data, doutb => spi_buf_out); 

tcm_req <= ((not tcm_req2) and tcm_req1) or ((not gs0) and gbt_global_status(0)) or ((not gs1) and gbt_global_status(1));

process(clk320)
begin
if (clk320'event and clk320='1') then

gs0<=gbt_global_status(0); gs1<=gbt_global_status(1);

spi_wr2<=spi_wr1; spi_wr1<=spi_wr0; spi_wr0<=spi_wr_rdy; hspi_wr2<=hspi_wr1; hspi_wr1<=hspi_wr0; hspi_wr0<=hspi_wr_rdy;

tcm_req2<=tcm_req1; tcm_req1<=tcm_req0;  tcm_req0<=tcm_reqh;

if (spi_wr2='0') and (spi_wr1='1') then spi_wr_req<='1'; end if;
if (hspi_wr2='0') and (hspi_wr1='1') then hspi_wr_req<='1'; end if;

if (cnt_rst='1') then cnt_rst<='0'; end if;
Zcal_done<=Zcal_done0;
if (EVNTI='1') and (((Zcal_done0='1') and (Zcal_done='0')) or (sreset='1')) then EVNTI<='0'; end if;

   if (sreset='1') then chans_block <= '0';
     else
       if (spi_wr_req='1') or  (hspi_wr_req='1') then
       case reg_wr_addr(7 downto 0) is 
            when x"00" => gate_time_high<=reg_wr_data(7 downto 0); 
            when x"01" => CH1A_shift<=reg_wr_data(11 downto 0); 
            when x"02" => CH1B_shift<=reg_wr_data(11 downto 0);
            when x"03" => CH1C_shift<=reg_wr_data(11 downto 0); 
            when x"04" => CH1D_shift<=reg_wr_data(11 downto 0); 
            when x"05" => CH2A_shift<=reg_wr_data(11 downto 0); 
            when x"06" => CH2B_shift<=reg_wr_data(11 downto 0);
            when x"07" => CH2C_shift<=reg_wr_data(11 downto 0); 
            when x"08" => CH2D_shift<=reg_wr_data(11 downto 0); 
            when x"09" => CH3A_shift<=reg_wr_data(11 downto 0); 
            when x"0A" => CH3B_shift<=reg_wr_data(11 downto 0);
            when x"0B" => CH3C_shift<=reg_wr_data(11 downto 0); 
            when x"0C" => CH3D_shift<=reg_wr_data(11 downto 0); 


            when x"0D" => CH1_0_zero<=reg_wr_data(11 downto 0);
            when x"0E" => CH1_1_zero<=reg_wr_data(11 downto 0);
            when x"0F" => CH2_0_zero<=reg_wr_data(11 downto 0);
            when x"10" => CH2_1_zero<=reg_wr_data(11 downto 0);
            when x"11" => CH3_0_zero<=reg_wr_data(11 downto 0);
            when x"12" => CH3_1_zero<=reg_wr_data(11 downto 0);
            when x"13" => CH4_0_zero<=reg_wr_data(11 downto 0);
            when x"14" => CH4_1_zero<=reg_wr_data(11 downto 0);
            when x"15" => CH5_0_zero<=reg_wr_data(11 downto 0);
            when x"16" => CH5_1_zero<=reg_wr_data(11 downto 0);
            when x"17" => CH6_0_zero<=reg_wr_data(11 downto 0);
            when x"18" => CH6_1_zero<=reg_wr_data(11 downto 0);
            when x"19" => CH7_0_zero<=reg_wr_data(11 downto 0);
            when x"1A" => CH7_1_zero<=reg_wr_data(11 downto 0);
            when x"1B" => CH8_0_zero<=reg_wr_data(11 downto 0);
            when x"1C" => CH8_1_zero<=reg_wr_data(11 downto 0);
            when x"1D" => CH9_0_zero<=reg_wr_data(11 downto 0);
            when x"1E" => CH9_1_zero<=reg_wr_data(11 downto 0);
            when x"1F" => CH10_0_zero<=reg_wr_data(11 downto 0);
            when x"20" => CH10_1_zero<=reg_wr_data(11 downto 0);
            when x"21" => CH11_0_zero<=reg_wr_data(11 downto 0);
            when x"22" => CH11_1_zero<=reg_wr_data(11 downto 0);
            when x"23" => CH12_0_zero<=reg_wr_data(11 downto 0);
            when x"24" => CH12_1_zero<=reg_wr_data(11 downto 0);
            
            
            
            when x"25" => CH1_0_rc<=reg_wr_data(11 downto 0);
            when x"26" => CH1_1_rc<=reg_wr_data(11 downto 0);
            when x"27" => CH2_0_rc<=reg_wr_data(11 downto 0);
            when x"28" => CH2_1_rc<=reg_wr_data(11 downto 0);
            when x"29" => CH3_0_rc<=reg_wr_data(11 downto 0);
            when x"2A" => CH3_1_rc<=reg_wr_data(11 downto 0);
            when x"2B" => CH4_0_rc<=reg_wr_data(11 downto 0);
            when x"2C" => CH4_1_rc<=reg_wr_data(11 downto 0);
            when x"2D" => CH5_0_rc<=reg_wr_data(11 downto 0);
            when x"2E" => CH5_1_rc<=reg_wr_data(11 downto 0);
            when x"2F" => CH6_0_rc<=reg_wr_data(11 downto 0);
            when x"30" => CH6_1_rc<=reg_wr_data(11 downto 0);
            when x"31" => CH7_0_rc<=reg_wr_data(11 downto 0);
            when x"32" => CH7_1_rc<=reg_wr_data(11 downto 0);
            when x"33" => CH8_0_rc<=reg_wr_data(11 downto 0);
            when x"34" => CH8_1_rc<=reg_wr_data(11 downto 0);
            when x"35" => CH9_0_rc<=reg_wr_data(11 downto 0);
            when x"36" => CH9_1_rc<=reg_wr_data(11 downto 0);
            when x"37" => CH10_0_rc<=reg_wr_data(11 downto 0);
            when x"38" => CH10_1_rc<=reg_wr_data(11 downto 0);
            when x"39" => CH11_0_rc<=reg_wr_data(11 downto 0);
            when x"3A" => CH11_1_rc<=reg_wr_data(11 downto 0);
            when x"3B" => CH12_0_rc<=reg_wr_data(11 downto 0);
            when x"3C" => CH12_1_rc<=reg_wr_data(11 downto 0);
            when x"3D" => Ampl_sat <=reg_wr_data(11 downto 0);
            
            when x"7C" => chans_ena_r <=reg_wr_data(11 downto 0);
                        
            when x"7F" => if (cnt_rst='0') and (reg_wr_data(9)='1') then cnt_rst<='1'; end if;
                          if (EVNTI='0') and (reg_wr_data(10)='1')  then EVNTI<='1'; end if;
                          if (spi_wr_req='1') and (reg_wr_data(11)='1') then chans_block <= '1'; end if;
            
            when others => null;
         end case;
          if (spi_wr_req='1') then spi_wr_req<='0'; end if;
          if (hspi_wr_req='1') and (spi_wr_req='0') then hspi_wr_req<='0'; end if;
         
        end if;
    end if;        
end if;
end process;

 RESET <= not rsti; spi_rden<= SPI_CS; hspi_rden<= not HSELI;
 
 HMISOI<=HSPI_DATA(15);

gate_time_low<=(not gate_time_high)+1;

rd_lock<= rd_lock_spi or rd_lock_hspi;

ch_en: for i in 0 to 11 generate

chans_ena(i) <= chans_ena_r(i) and chans_block;

end generate;

process (tdcclk1)
begin
if (tdcclk1'event and tdcclk1='1') then 

spi_lock_1<=spi_lock0_1;  spi_lock0_1<= rd_lock;

end if;
end process;

process (tdcclk2)
begin
if (tdcclk2'event and tdcclk2='1') then 

spi_lock_2<=spi_lock0_2;  spi_lock0_2<= rd_lock;

end if;
end process;

process (tdcclk3)
begin
if (tdcclk3'event and tdcclk3='1') then 

spi_lock_3<=spi_lock0_3;  spi_lock0_3<= rd_lock;

end if;
end process;

process (clk300_1)
begin
if (clk300_1'event and clk300_1='1') then 

almclr10<=ALM_CLR; almclr11<=almclr10; alm_clr1<=almclr11;
hclr10<=Hs_rd; hclr11<=hclr10; h_clr1<=hclr11; 
		
	BC_STR11<=BC_STR1; BC_STR12<=BC_STR11;   
	
	TDC_COU1<=TDC_COU1+1; 

	if (BC_STR1='1' and BC_STR11='0') then BC_PER1<= TDC_COU1 & BC_BITS1; end if;
	if (BC_STR11='1' and BC_STR12='0') then  BCOLD1<=BC_PER1(1 downto 0); end if;
	if (BC_STR11='1' and BC_STR12='0') and (BCOLD1/=BC_PER1(1 downto 0)) then BC_JUMP1<='1'; HBC_JUMP1<='1'; jumpa1<='1';
	  else
	   jumpa1<='0';
	   if (alm_clr1='0') and (almclr11='1') then BC_JUMP1<='0'; end if;
	   if (h_clr1='0') and (hclr11='1') then HBC_JUMP1<='0'; end if;
    end if;
	
end if;
end process;

process (clk300_2)
begin
if (clk300_2'event and clk300_2='1') then 

almclr20<=ALM_CLR; almclr21<=almclr20; alm_clr2<=almclr21;
hclr20<=Hs_rd; hclr21<=hclr20; h_clr2<=hclr21; 
		
	BC_STR21<=BC_STR2; BC_STR22<=BC_STR21;  
	
	TDC_COU2<=TDC_COU2+1; 

 if (BC_STR2='1' and BC_STR21='0') then BC_PER2<= TDC_COU2 & BC_BITS2; end if; 
 if (BC_STR21='1' and BC_STR22='0') then  BCOLD2<=BC_PER2(1 downto 0); end if;
    if BC_STR21='1' and BC_STR22='0' and (BCOLD2/=BC_PER2(1 downto 0))then BC_JUMP2<='1'; HBC_JUMP2<='1'; jumpa2<='1';
     else
       jumpa2<='0';
       if (alm_clr2='0') and (almclr21='1') then BC_JUMP2<='0';   end if;
       if (h_clr2='0') and (hclr21='1') then HBC_JUMP2<='0'; end if;
 end if;
	
end if;
end process;

process (clk300_3)
begin
if (clk300_3'event and clk300_3='1') then 
		
almclr30<=ALM_CLR; almclr31<=almclr30; alm_clr3<=almclr31;
hclr30<=Hs_rd; hclr31<=hclr30; h_clr3<=hclr31;  

	BC_STR31<=BC_STR3;   BC_STR32<=BC_STR31;
	
	TDC_COU3<=TDC_COU3+1; 

	if (BC_STR3='1' and BC_STR31='0') then BC_PER3<= TDC_COU3 & BC_BITS3; end if; 
	if (BC_STR31='1' and BC_STR32='0') then BCOLD3<=BC_PER3(1 downto 0); end if;
	if BC_STR31='1' and BC_STR32='0' and (BCOLD3/=BC_PER3(1 downto 0))then BC_JUMP3<='1'; HBC_JUMP3<='1'; jumpa3<='1';
	  else 
	    jumpa3<='0';
      	if (alm_clr3='0') and (almclr31='1') then BC_JUMP3<='0'; end if;
      	if (h_clr3='0') and (hclr31='1') then HBC_JUMP3<='0'; end if;
    end if;
	
end if;
end process;

PM_data_toreadout.data_word  <=  DATA80_in;


process (clk320)
begin
if (clk320'event and clk320='1') then

spi_lock320<=spi_lock320_0;  spi_lock320_0<= rd_lock;

tto<=tt;  tao<=ta;  
MCLK40_0<=MCLK40T; MCLK40_1<=MCLK40_0; if (MCLK40_0/=MCLK40_1) then mt_cou<="000"; else mt_cou<=mt_cou+1; end if;

PM_data_toreadout.is_header  <=  wr_out_id;
PM_data_toreadout.is_data    <=  Event_ready or wr_out_id;
PM_data_toreadout.is_packet  <=  Event_ready or wr_out_id;

if (wr_out_id='1') then DATA80_in<= x"F" & '0' & WRDS_NUM & x"000000" & rx_phase_status & EV_ID_out(55 downto 12);
   else DATA80_in<=EV_DATA80;
end if;
if (Event_free='1') or (wr_out_id='1') then ev_tout_cnt<=(others=>'0');
       else  ev_tout_cnt<=ev_tout_cnt+1;
end if;
if (ev_tout_cnt=96) then  ev_tout<='1';  else ev_tout<='0'; end if;
ev_tout0 <= ev_tout;

--if (wr_out_id='1') or (Event_ready='1') then WR_fifo_out<='1'; else WR_fifo_out<='0';  end if;

if (Event_ready='0') then
 if (Event_ready_0='1') then Event_ready<='1'; end if;
 else
 if (CH_do=0) then Event_ready<='0'; end if;
end if;
 

if (wr_nch='1') then CH_do<=EV_ID_out(11 downto 0);  wr_nch<='0'; 
 else
   if (Event_ready='1') or (Event_ready_0='1') then
   
    case CH_N0_0 is
              when x"1" => CH_do(0)<='0'; 
              when x"2" => CH_do(1)<='0'; 
              when x"3" => CH_do(2)<='0'; 
              when x"4" => CH_do(3)<='0'; 
              when x"5" => CH_do(4)<='0'; 
              when x"6" => CH_do(5)<='0'; 
              when x"7" => CH_do(6)<='0'; 
              when x"8" => CH_do(7)<='0'; 
              when x"9" => CH_do(8)<='0'; 
              when x"A" => CH_do(9)<='0'; 
              when x"B" => CH_do(10)<='0'; 
              when x"C" => CH_do(11)<='0'; 
              when others =>null;
  end case;
  
  case CH_N1_0 is
              when x"2" => CH_do(1)<='0'; 
              when x"3" => CH_do(2)<='0'; 
              when x"4" => CH_do(3)<='0'; 
              when x"5" => CH_do(4)<='0'; 
              when x"6" => CH_do(5)<='0'; 
              when x"7" => CH_do(6)<='0'; 
              when x"8" => CH_do(7)<='0'; 
              when x"9" => CH_do(8)<='0'; 
              when x"A" => CH_do(9)<='0'; 
              when x"B" => CH_do(10)<='0'; 
              when x"C" => CH_do(11)<='0'; 
              when others =>null;
  end case;
  end if;
 if (sreset='0') and (EV_ID_rd='1') then wr_nch<='1'; end if;
end if;
 
 if (sreset='1') then Event_free<='1'; 
   else 
    if (Event_free='1') then
       if (EV_ID_empty='0')  then EVENT_free<='0'; end if;
    else
       if (((Event_ready='1') and (CH_do=0)) or (ev_tout0='1')) and (EV_ID_empty='1') then Event_free<='1';  end if;
    end if;
 end if;

if  (Event_ready='1') or (Event_ready_0='1') then  CH_N0<= CH_N0_0; CH_N1<= CH_N1_0; end if;

if (mt_cou="001") then
  if (New_BCID='1') then BC_COU<=FIT_GBT_status. BCID_from_CRU_corrected; Orbit_ID<=FIT_GBT_status. ORBIT_from_CRU_corrected;
    if (FIT_GBT_status. BCID_from_CRU_corrected>x"003") then TR_to<=FIT_GBT_status. BCID_from_CRU_corrected(5 downto 0)-"000100"; else TR_to<="1010" & FIT_GBT_status. BCID_from_CRU_corrected(1 downto 0); end if;
  
    else  
    if (BC_COU=x"DEB") then BC_cou<=x"000"; Orbit_ID<=Orbit_ID+1; else BC_cou<=BC_cou+1; end if;
    if (BC_COU>x"003") then TR_to<=BC_COU(5 downto 0)-"000100"; else TR_to<="1010" & BC_COU(1 downto 0); end if;
    end if;
  end if;
end if;
end process;

New_BCID <= FIT_GBT_status.Start_run when (FIT_GBT_status.BCIDsync_Mode=mode_SYNC) else '0';

CH_N0_0<= x"1" when  CH_do(0)='1'
   else   x"2" when  CH_do(1)='1'
   else   x"3" when  CH_do(2)='1'
   else   x"4" when  CH_do(3)='1'
   else   x"5" when  CH_do(4)='1'
   else   x"6" when  CH_do(5)='1'
   else   x"7" when  CH_do(6)='1'
   else   x"8" when  CH_do(7)='1'
   else   x"9" when  CH_do(8)='1'
   else   x"A" when  CH_do(9)='1'
   else   x"B" when  CH_do(10)='1'
   else   x"C" when  CH_do(11)='1'
   else   x"0";
 
CH_N1_0<=  x"2" when  CH_do(1)='1' and (CH_N0_0/=x"2")
  else     x"3" when  CH_do(2)='1' and (CH_N0_0/=x"3")
  else     x"4" when  CH_do(3)='1' and (CH_N0_0/=x"4")
  else     x"5" when  CH_do(4)='1' and (CH_N0_0/=x"5")
  else     x"6" when  CH_do(5)='1' and (CH_N0_0/=x"6")
  else     x"7" when  CH_do(6)='1' and (CH_N0_0/=x"7")
  else     x"8" when  CH_do(7)='1' and (CH_N0_0/=x"8")
  else     x"9" when  CH_do(8)='1' and (CH_N0_0/=x"9")
  else     x"A" when  CH_do(9)='1' and (CH_N0_0/=x"A")
  else     x"B" when  CH_do(10)='1' and (CH_N0_0/=x"B")
  else     x"C" when  CH_do(11)='1' and (CH_N0_0/=x"C")
  else     x"0";
 

EV_DATA80(32 downto 0)<= Data_out(0) when CH_N0=x"1" else
                         Data_out(1) when CH_N0=x"2" else 
                         Data_out(2) when CH_N0=x"3" else 
                         Data_out(3) when CH_N0=x"4" else 
                         Data_out(4) when CH_N0=x"5" else 
                         Data_out(5) when CH_N0=x"6" else 
                         Data_out(6) when CH_N0=x"7" else 
                         Data_out(7) when CH_N0=x"8" else 
                         Data_out(8) when CH_N0=x"9" else 
                         Data_out(9) when CH_N0=x"A" else 
                         Data_out(10) when CH_N0=x"B" else 
                         Data_out(11) when CH_N0=x"C" else
                         "0" & x"00000000";
                         
EV_DATA80(35 downto 33)<= "000";
EV_DATA80(39 downto 36)<= CH_N0;                         
                         
EV_DATA80(72 downto 40)<= Data_out(1) when CH_N1=x"2" else 
                          Data_out(2) when CH_N1=x"3" else 
                          Data_out(3) when CH_N1=x"4" else 
                          Data_out(4) when CH_N1=x"5" else 
                          Data_out(5) when CH_N1=x"6" else 
                          Data_out(6) when CH_N1=x"7" else 
                          Data_out(7) when CH_N1=x"8" else 
                          Data_out(8) when CH_N1=x"9" else 
                          Data_out(9) when CH_N1=x"A" else 
                          Data_out(10) when CH_N1=x"B" else 
                          Data_out(11) when CH_N1=x"C" else
                          "0" & x"00000000";

EV_DATA80(75 downto 73)<= "000";
EV_DATA80(79 downto 76)<= CH_N1;                         
                          

inp_event <=Event_in(0) or Event_in(1) or Event_in(2) or Event_in(3) or Event_in(4) or Event_in(5) or Event_in(6) or Event_in(7) or Event_in(8) or Event_in(9) or Event_in(10) or Event_in(11);

Zcal_done0<= '1' when (Cal_done=x"FFF") else '0';

Event_ready_0<= ((not EV_ID_out(0)) or Data_rdy(0)) and ((not EV_ID_out(1)) or Data_rdy(1)) and ((not EV_ID_out(2)) or Data_rdy(2)) and ((not EV_ID_out(3)) or Data_rdy(3)) and ((not EV_ID_out(4)) or Data_rdy(4))and ((not EV_ID_out(5)) or Data_rdy(5))
          and ((not EV_ID_out(6)) or Data_rdy(6)) and ((not EV_ID_out(7)) or Data_rdy(7)) and ((not EV_ID_out(8)) or Data_rdy(8)) and ((not EV_ID_out(9)) or Data_rdy(9)) and ((not EV_ID_out(10)) or Data_rdy(10)) and ((not EV_ID_out(11)) or Data_rdy(11))
          and not (Event_free or wr_nch);
     

CH_NUM1<= ("00" & EV_ID_out(0)) + ("00" & EV_ID_out(1)) + ("00" & EV_ID_out(2)) + ("00" & EV_ID_out(3)) + ("00" & EV_ID_out(4)) + ("00" & EV_ID_out(5));
CH_NUM2<=  ("00" & EV_ID_out(6)) + ("00" & EV_ID_out(7)) + ("00" & EV_ID_out(8)) + ("00" & EV_ID_out(9)) + ("00" & EV_ID_out(10)) +("00" & EV_ID_out(11));
CH_NUM<=('0' & CH_NUM1) + ('0' & CH_NUM2);
WRDS_NUM<=CH_NUM(3 downto 1) + ("00" & CH_NUM(0)) when (ev_tout='0') else "000";          
          
FIFO_RD: for i in 0 to 11 generate
DATA_rd(i)<= '1'  when (Event_Ready_0='1') and (Event_Ready='0') and (EV_ID_out(i)='1') and (Data_rdy(i)='1') else '0';
end generate;

FIFO_dis<=EV_ID_empty and EVENT_free;
wr_out_id<= (Event_ready_0 and (not Event_ready)) or ev_tout;

--process (TX_CLK)
--begin
--if (TX_CLK'event and TX_CLK='1') then
  
--    if (DATA_empty='0') then mux_out<= not mux_out; else mux_out<='1'; end if;
--    str_la<=(not DATA_empty) or (not mux_out);

--end if;
--end process; 

--la0i <= DATA80_out(15 downto 0) when (mux_out='0') else DATA80_out(55 downto 40);
--la1i <= DATA80_out(31 downto 16) when (mux_out='0') else DATA80_out(71 downto 56);
--la2i(8 downto 0) <= '0' & DATA80_out(39 downto 32) when (mux_out='0') else '1' & DATA80_out(79 downto 72);



--la2i(0)<=EVNTI; la2i(1)<=Zcal_done; la2i(2)<=inp_cou(1); la2i(3)<=CSTR2; la2i(4)<=inp_cou(2); la2i(5)<=CSTR3; la2i(6)<=inp_cou(3); la2i(7)<=CSTR4; la2i(8)<=inp_cou(4); la2i(9)<=CSTR5; la2i(10)<=inp_cou(5); la2i(11)<=CSTR6; 
--la2i(12)<=inp_cou(6); la2i(13)<=CSTR7; la2i(14)<=inp_cou(7); la2i(15)<=CSTR8; lack2i<=inp_cou(8); lack3i<=CSTR9; la3i(14)<=inp_cou(9); la3i(15)<=CSTR10; la3i(12)<=inp_cou(10); la3i(13)<=CSTR11; la3i(10)<=inp_cou(11); la3i(11)<=CSTR12;

--la2i(1 downto 0)<=BCOLD1(1 downto 0); la2i(2)<=BC_JUMP1; la2i(3)<=ALM_CLR; la2i(4)<=BC_JUMP2; la2i(5)<=BC_JUMP3;

--la3i(0)<=rchange1; la3i(1)<=rchange2; la3i(2)<=rchange3;


--la0i(0)<=MCLK40_IN1; la0i(1)<=MCLK40_IN2; la0i(2)<=MCLK40_IN3; la0i(3)<=CSTR1; la0i(4)<=CGE1; la0i(5)<=lTDCCLK1; la0i(6)<=RSA1;
--la3i(15)<=inp_event;

--la0i<=LA_vector(15 downto 0); la1i<=LA_vector(31 downto 16); la2i<=LA_vector(47 downto 32); la3i(7 downto 0)<=LA_vector(55 downto 48);


--la1i(15 downto 14) <= ttla;
--la2i(15 downto 14) <= tala;

--la2i(0)<=HSELI; la2i(1)<=HSCKI; la2i(2)<=HMOSII; la2i(3)<=HMISOI; la2i(4)<=hspi_h; la2i(5)<=dcs_irq; la2i(6)<=hbuf_ena; la2i(7)<=hbuf_wrena; la2i(8)<=reg32_wr;

--la3i(0)<=gs0;  la3i(1)<=gs1;




--la2i(15) <= PM_data_toreadout.is_data;
--la2i(14) <= PM_data_toreadout.is_packet;
--la2i(13) <= PM_data_toreadout.is_header;
--la2i(12 downto 0) <= PM_data_toreadout.data_word(12 downto 0);

end RTL;
