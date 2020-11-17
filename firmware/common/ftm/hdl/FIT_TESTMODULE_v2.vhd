----------------------------------------------------------------------------------
-- Company: INR RAS Moscow
-- Engineer: Finogeev D.A. (dmitry-finogeev@yandex.ru)
-- 
-- Create Date:    14:00:14 12/22/2016 
-- Design Name: FIT - GBT project
-- Module Name:    FIT_GBT_kc705_designe - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.ipbus.ALL;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity FIT_TESTMODULE_v2 is
	Port(
		RESET : 		in  STD_LOGIC;
		
		SYS_CLK_P : 	in  STD_LOGIC;
		SYS_CLK_N : 	in  STD_LOGIC;
		USER_CLK_P : 	in  STD_LOGIC;
		USER_CLK_N : 	in  STD_LOGIC;
		SMA_MGT_CLK_P :	in  STD_LOGIC;
		SMA_MGT_CLK_N :	in  STD_LOGIC;
		
        eth_clk_p: in std_logic; -- 125MHz MGT clock
        eth_clk_n: in std_logic;
		
		SFP_RX_P : 		in  STD_LOGIC;
		SFP_RX_N : 		in  STD_LOGIC;
		SFP_TX_P : 		out  STD_LOGIC;
		SFP_TX_N : 		out  STD_LOGIC;
		SFP_TX_DSBL : 	out  STD_LOGIC;
		

		
		GPIO_SMA_J13 : 	out  STD_LOGIC;
		GPIO_SMA_J14 : 	out  STD_LOGIC;
		
		GPIO_LED_0 : 	out  STD_LOGIC;
		GPIO_LED_1 : 	out  STD_LOGIC;
		GPIO_LED_2 : 	out  STD_LOGIC;
		GPIO_LED_3 : 	out  STD_LOGIC;
		GPIO_LED_4 : 	out  STD_LOGIC;
		GPIO_LED_5 : 	out  STD_LOGIC;
		GPIO_LED_6 : 	out  STD_LOGIC;
		GPIO_LED_7 : 	out  STD_LOGIC;
		GPIO_BUTTON_SW_C: in STD_LOGIC;
		GPIO_DIP_SW0 : in STD_LOGIC;
		
		-- FTM V1.0
		LAS_EN : out STD_LOGIC;
        LAS_D_P : out STD_LOGIC;
        LAS_D_N : out STD_LOGIC;
        SCOPE : out STD_LOGIC;

		FMC_HPC_clk_A_p :	in  STD_LOGIC;
		FMC_HPC_clk_A_n :	in  STD_LOGIC;
		FMC_HPC_clk_200_p :	in  STD_LOGIC;
		FMC_HPC_clk_200_n :	in  STD_LOGIC;

        eth_rx_p: in std_logic; -- Ethernet MGT input
        eth_rx_n: in std_logic;
        eth_tx_p: out std_logic; -- Ethernet MGT output
        eth_tx_n: out std_logic;
		
        sfp_los: in std_logic;
        sfp_rate_sel: out std_logic_vector(1 downto 0); -- SFP rate select
		
        spi_ss: out std_logic;
        spi_mosi: out std_logic;
        spi_miso: in std_logic;
        spi_sclk: out std_logic;
        
        TCM_SPI_MOSI : out std_logic;
        TCM_SPI_MISO : in std_logic;
        TCM_SPI_SCK  : out std_logic;
        TCM_SPI_SEL  : out std_logic;
        
        TCM_TT0_P  : in std_logic;
        TCM_TT0_N  : in std_logic;
        TCM_TT1_P  : in std_logic;
        TCM_TT1_N  : in std_logic;
        TCM_TA0_P  : in std_logic;
        TCM_TA0_N  : in std_logic;
        TCM_TA1_P  : in std_logic;
        TCM_TA1_N  : in std_logic;

        PM_SPI_MOSI : in std_logic;
        PM_SPI_MISO : out std_logic;
        PM_SPI_SCK  : in std_logic;
        PM_SPI_SEL  : in std_logic;

        PM_TT0_P  : out std_logic;
        PM_TT0_N  : out std_logic;
        PM_TT1_P  : out std_logic;
        PM_TT1_N  : out std_logic;
        PM_TA0_P  : out std_logic;
        PM_TA0_N  : out std_logic;
        PM_TA1_P  : out std_logic;
        PM_TA1_N  : out std_logic;
        CLKPM_P : in std_logic;
        CLKPM_N : in std_logic;
        
        LA : out std_logic_vector (15 downto 0)
		
		);
end FIT_TESTMODULE_v2;



architecture Behavioral of FIT_TESTMODULE_v2 is

-- Reset signals
    signal reset_to_syscount 		: std_logic;
    signal Is_SysClkCounter_ready   : std_logic;
    signal reset_aft_pllready : std_logic;
    signal SDclk_pll_ready, clk200_rdy : std_logic;
    signal gbt_reset, reset_to_syscount40    :std_logic;

-- generators cloks
	signal SYSCLK_gen : std_logic;
	signal SMA_MGT_CLK : std_logic;	
	signal USERCLK_gen : std_logic;
	signal source_gen : std_logic;
	
-- CDM clocks
	signal CDM_clk_A : std_logic;
	signal CDM_clk_200 : std_logic;
	signal CDM_pll_SysClk : std_logic;
	signal CDM_pll_clk_A : std_logic;


-- FIT PM clocks
	signal SysClk_pll : std_logic;   
	signal DataClk_pll : std_logic;   
	signal MgtRefClk_pll : std_logic; 
	
-- CLOCK to FIT_GBT
	signal SysClk_to_FIT_GBT : std_logic;   
	signal DataClk_to_FIT_GBT : std_logic;
	signal MgtRefClk_to_FIT_GBT : std_logic;   
	signal GBT_RxFrameClk	: STD_LOGIC;
	
	
-- GBT signals
   signal Data_from_FITrd             : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
   signal IsData_from_FITrd        : STD_LOGIC;
   
   signal RxData_rxclk_from_GBT     : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
   signal IsRxData_rxclk_from_GBT    : STD_LOGIC;
	
	signal from_gbt_bank_prj_GBT_status : Type_GBT_status;
	
	
-- IP-BUS signals
	signal ipb_clk, ipb_rst : std_logic;
	signal ipb_data_in, ipb_data_in_tm, ipb_data_out, spi_data_r, pm_spi_data, tcm_sc_data, loc_data : STD_LOGIC_VECTOR (31 downto 0);
	signal ipb_addr : STD_LOGIC_VECTOR(31 downto 0);
	signal ipb_iswr, ipb_isrd, ipb_wr, ipb_str, spi_sel, spi_err, spi_ack, tm_sel, ipb_ack_tm, ipb_err_tm, loc_rdy : std_logic;
	signal ipb_out: ipb_wbus;
    signal ipb_in: ipb_rbus;
    signal bus_select : STD_LOGIC_VECTOR(4 downto 0);
    signal LAI : STD_LOGIC_VECTOR(15 downto 0);
    signal clk200, dly_rdy : STD_LOGIC;
    signal SCOPE_I : std_logic;

    signal mac_addr: std_logic_vector(47 downto 0);
    signal ip_addr: std_logic_vector(31 downto 0);

    signal HDMI0_P, HDMI0_N, HDMI0_o : std_logic_vector(3 downto 0);
    signal HDMI0_d, HDMI0_s, t_stmp, HDMI0_d_sysclk : std_logic_vector(31 downto 0);
    signal HDMI_clkout_320, HDMI_clk40 : std_logic;
    signal rd_status, st_rq, st_rq_cmd, hdmi_ready, hdmi_ready0, hdmi_ready1, hdmi_ready2, hdmi_ready_sysclk, PM_req, PM_req0, PM_req1, PM_req2, PM_rq, rq_irq0, rq_irq1, rq_irq2, rq_irq : std_logic;
    signal d_addr : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal d_sns : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal d_rd, d_rdy, adc_sel, adc_sel1 : std_logic;
	
-- TEST Module signals
	signal FSM_Clocks : FSM_Clocks_type;
    signal TESTM_status : FIT_GBT_status_type;
    signal TESTM_control : CONTROL_REGISTER_type;
	signal Laser_Signal_out, Laser_Signal_out_ff : std_logic;
	
	signal tt0_p, tt0_n, tt1_p, tt1_n, ta0_p, ta0_n, ta1_p, ta1_n, PM_TT0, PM_TT1, PM_TA0, PM_TA1, CLK_PM, CLK_PMi  : std_logic;
	signal tcm_sel, tcm_sck, tcm_miso, tcm_mosi, pm_spi_rdy, tcm_sc_rdy, clk320_tcm, pm_sel, pm_sck, pm_miso, pm_mosi, PM_rst, addr_sw : std_logic;
    signal cnt_rd, t40, t40_0, t40_1 : std_logic;
    signal TCM_bitcnt : std_logic_vector(2 downto 0);
    signal TAmpl, TTime : std_logic_vector(13 downto 0);
    signal T_cnt : std_logic_vector(15 downto 0);
    signal B_cnt : std_logic_vector(16 downto 0);
    signal Nchan : std_logic_vector(3 downto 0);
    signal T0, T1, A0, A1 : std_logic_vector(7 downto 0);
	
	

	
	
-- TESTs
	signal Data_Clk_strobe : STD_LOGIC;
	

   COMPONENT PmClockPll PORT(
      RESET: in std_logic;
      CLK_IN1_200: in std_logic;
      CLK_OUT1_200: out std_logic;
      CLK_OUT2_40: out std_logic;
      CLK_OUT3_320: out std_logic
   );
   END COMPONENT;
   
   COMPONENT CDM_Clk_pll PORT(
      RESET: in std_logic;
      CLK_IN1_40: in std_logic;
      CLK_OUT1_40: out std_logic;
      CLK_OUT2_320: out std_logic;
      LOCKED : out std_logic
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
           PM_rst : in STD_LOGIC
           );
           
   end component; 
   
   component tcm_sc is
   Port (CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DI : in STD_LOGIC_VECTOR (31 downto 0);
           DO : out STD_LOGIC_VECTOR (31 downto 0);
           A : in STD_LOGIC_VECTOR (8 downto 0);
           wr  : in STD_LOGIC;
           rd : in STD_LOGIC;
           cs : in STD_LOGIC;
           rdy : out STD_LOGIC;
           cnt_rd : out STD_LOGIC
            );
   end component;
   
   component tcm_sync is
       Port ( CLKA : in STD_LOGIC;
              TD_P : in STD_LOGIC_VECTOR (3 downto 0);
              TD_N : in STD_LOGIC_VECTOR (3 downto 0);
              RST : in STD_LOGIC;
              pllrdy : out STD_LOGIC;
              rdy : out STD_LOGIC;
              clkout : out STD_LOGIC;
              clkout_90 : out STD_LOGIC;
              bitcnt : out STD_LOGIC_VECTOR (2 downto 0);
              TDO : out STD_LOGIC_VECTOR (3 downto 0);
              Dready : out STD_LOGIC;
              rd_lock : in STD_LOGIC;
              DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0);
              status :  out STD_LOGIC_VECTOR (31 downto 0);
              PM_req : out STD_LOGIC
              );
   end component;
   
   component TCM_SPI is
       Port ( sck : in STD_LOGIC;
              sel : in STD_LOGIC;
              mosi : in STD_LOGIC;
              miso : out STD_LOGIC);
   end component;

   
   component TCM_PLL320
   port
    (-- Clock in ports
     -- Clock out ports
     clk_out1          : out    std_logic;
     -- Status and control signals
     reset             : in     std_logic;
     locked            : out    std_logic;
     clk_in1           : in     std_logic
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

   
begin

sw0: IBUF port map (O => addr_sw, I =>GPIO_DIP_SW0);

-- wiring ==============================================
-- PLL clocking source
source_gen <= USERCLK_gen;

-- CLOCK to FIT_GBT
-- SysClk_to_FIT_GBT <= SysClk_pll;   
-- DataClk_to_FIT_GBT <= DataClk_pll;   
-- MgtRefClk_to_FIT_GBT <= MgtRefClk_pll;   

SysClk_to_FIT_GBT <=  CDM_pll_SysClk;   
DataClk_to_FIT_GBT <=   CDM_pll_clk_A;
--DataClk_to_FIT_GBT <= CDM_clk_A;
MgtRefClk_to_FIT_GBT <= CDM_clk_200;   

FSM_Clocks.Data_Clk <= DataClk_to_FIT_GBT;
FSM_Clocks.System_Clk <= SysClk_to_FIT_GBT;
FSM_Clocks.GBT_RX_Clk <= GBT_RxFrameClk;
FSM_Clocks.IPBUS_Data_Clk <= ipb_clk;

		
-- USER OUTPUTS
-- GPIO_LED_0 <= TESTM_status.GBT_status.rxWordClkReady; -- from rxPgaseAlign_gen.rxBitSlipControl
-- GPIO_LED_1 <= TESTM_status.GBT_status.rxFrameClkReady; -- from latOpt_phalgnr_gen.phase_conm_inst
-- GPIO_LED_2 <= TESTM_status.GBT_status.mgtLinkReady; -- from FitGbtPrg/gbtBankDsgn/gbtExmplDsgn_inst/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/gt0_txresetfsm_i
-- GPIO_LED_3 <= TESTM_status.GBT_status.gbtRx_Ready; -- FitGbtPrg/gbtBankDsgn/gbtExmplDsgn_inst/gbtBank/gbtRx_param_package_src_gen.gbtRx_gen[1].gbtRx/status/statusLatOpt_gen.RX_READY_O_reg
-- GPIO_LED_4 <= TESTM_status.GBT_status.mgt_phalin_cplllock; -- CPLLLOCK from FitGbtPrg/gbtBankDsgn/gbtExmplDsgn_inst/gbtBank/mgt_param_package_src_gen.mgt/mgtLatOpt_gen.mgtLatOpt/gtxLatOpt_gen[1].xlx_k7v7_mgt_std_i/U0/xlx_k7v7_mgt_ip_i/gt0_xlx_k7v7_mgt_ip_i/gtxe2_i 
-- GPIO_LED_5 <= TESTM_status.GBT_status.tx_resetDone; -- TXRESETDONE from gtxe2_i
-- GPIO_LED_6 <= TESTM_status.GBT_status.tx_fsmResetDone; -- gt0_txresetfsm_i

SCOPE_I <= DataClk_to_FIT_GBT;

GPIO_SMA_J13 <= DataClk_to_FIT_GBT;
GPIO_SMA_J14 <= GBT_RxFrameClk;
-- ================================================

Laser_Signal_out_ff <= '1' when (TESTM_status.Trigger_from_CRU and TESTM_control.Data_Gen.trigger_resp_mask) /= 0 else '0';

 process (FSM_Clocks.Data_Clk)
  begin
  if (FSM_Clocks.Data_Clk'event and FSM_Clocks.Data_Clk='1') then
    Laser_Signal_out <= Laser_Signal_out_ff;
  end if;
  end process;



-- Clocking Buffers & Pll ==============================
-- SYSCLK IBUFGDS 
   sysClockIbufgds: ibufds
      generic map ( 
         DIFF_TERM => FALSE, -- Differential Termination 
         IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
         IOSTANDARD                                  => "LVDS_25")
      port map (     
         O                                           => SYSCLK_gen,   
         I                                           => SYS_CLK_P,  
         IB                                          => SYS_CLK_N 
      );

-- USER CLK
   userClockIbufgds: ibufds
      generic map (
         IBUF_LOW_PWR                                => FALSE,      
         IOSTANDARD                                  => "LVDS_25")
      port map (     
         O                                           => USERCLK_gen,   
         I                                           => USER_CLK_P,  
         IB                                          => USER_CLK_N 
      );

-- FMC HPC CLK A
   CDM_clk_A_Ibufgds: ibufds
     generic map (
		DIFF_TERM 									=> TRUE,
        IBUF_LOW_PWR                                => FALSE,      
        IOSTANDARD                                  => "LVDS_25")
      port map (     
         O                                           => CDM_clk_A,   
         I                                           => FMC_HPC_clk_A_p,  
         IB                                          => FMC_HPC_clk_A_n 
      );

-- Laser signal
    LAS_EN <= '1';
    
   Laser_Obufgds: obufds
     generic map (
		--DIFF_TERM 									=> FALSE,
--        IBUF_LOW_PWR                                => FALSE,      
        IOSTANDARD                                  => "LVDS_25")
      port map (     
         I                                           => Laser_Signal_out,   
         O                                           => LAS_D_P,  
         OB                                          => LAS_D_N 
      );



  CDM_clk_200_IbufdsGtxe2: ibufds_gte2
     port map (
        O                                           => CDM_clk_200,
        ODIV2                                       => open,
        CEB                                         => '0',
        I                                           => FMC_HPC_clk_200_p,
        IB                                          => FMC_HPC_clk_200_n
     );
	 
	 

-- IBUFGDS SMA MGT
  smaMgtRefClkIbufdsGtxe2: ibufds_gte2
     port map (
        O                                           => SMA_MGT_CLK,
        ODIV2                                       => open,
        CEB                                         => '0',
        I                                           => SMA_MGT_CLK_P,
        IB                                          => SMA_MGT_CLK_N
     );
	 
TT0i_buf: obufds generic map (IOSTANDARD => "LVDS_25")
           port map (I=> PM_TT0, O=> PM_TT0_P, OB=> PM_TT0_N);

TT1i_buf: obufds generic map (IOSTANDARD => "LVDS_25")
           port map (I=> PM_TT1, O=> PM_TT1_P, OB=> PM_TT1_N);

TA0i_buf: obufds generic map (IOSTANDARD => "LVDS_25")
           port map (I=> PM_TA0, O=> PM_TA0_P, OB=> PM_TA0_N);

TA1i_buf: obufds generic map (IOSTANDARD => "LVDS_25")
           port map (I=> PM_TA1, O=> PM_TA1_P, OB=> PM_TA1_N);

CLKi_buf: ibufds_diff_out generic map (DIFF_TERM =>TRUE,  IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS_25")
          port map (O=> CLK_PMi, OB=> open, I=> CLKPM_P, IB => CLKPM_N);

TCM_PLL : TCM_PLL320 port map (clk_out1 => clk320_TCM, reset => RESET, locked => open, clk_in1 => CLK_PM);

MCLKB1: BUFG 
      port map (O => CLK_PM, I => CLK_PMi);

SCOPE_buf: OBUF
      port map (O => SCOPE, I => SCOPE_I);


 process (CLK_PM)
  begin
  if (CLK_PM'event and CLK_PM='0') then
    t40<=not t40;
  end if;
  end process;

TAmpl<= std_logic_vector(to_signed(500, 14));
TTime(12 downto 0)<= std_logic_vector(to_signed(100, 13));
Nchan<= std_logic_vector(to_unsigned(2, 4));

TTime(13)<='1' when (B_cnt=0) else '0'; 

 process (CLK320_TCM)
  begin
  if (CLK320_TCM'event and CLK320_TCM='1') then
  
  rq_irq2<=rq_irq1; rq_irq1<=rq_irq0; rq_irq0<=st_rq_cmd;
  
  if (rq_irq2='0') and (rq_irq1='1') and (rq_irq='0') then rq_irq<='1'; end if;
  
  t40_1<=t40_0; t40_0<=t40;
  if (t40_1/=t40_0) then TCM_bitcnt<="000"; 
  else TCM_bitcnt<= TCM_bitcnt+1; end if;
  
  if (TCM_bitcnt="000") then
  
if (T_cnt/=0) and (B_cnt/=0) then 
      T1<=x"02"; A0<=x"02"; A1<=x"02";
     if (rq_irq='0') then T0<=x"02"; else T0<=x"00"; rq_irq<='0'; end if;  
else   
   if (T_cnt=0) then
        T0<=TTime(12) &TTime(10) &TTime(8) &TTime(6) &TTime(4) &TTime(2) & TTime(0) & Nchan(0);
        T1<=TTime(13) &TTime(11) &TTime(9) &TTime(7) &TTime(5) &TTime(1) & TTime(1) & Nchan(1);
        A0<=TAmpl(12) &TAmpl(10) &TAmpl(8) &TAmpl(6) &TAmpl(4) &TAmpl(2) & TAmpl(0) & Nchan(2);
        A1<=TAmpl(13) &TAmpl(11) &TAmpl(9) &TAmpl(7) &TAmpl(5) &TAmpl(1) & TAmpl(1) & Nchan(3);
     else
      T0<=x"01"; T1<=x"80"; A0<=x"01"; A1<=x"01";
   end if;
 end if;

   if (T_cnt=0) then T_cnt<=std_logic_vector(to_unsigned(39999, 16));
      else T_cnt<=T_cnt-1;
   end if; 
    
    if (B_cnt=0) then B_cnt<=std_logic_vector(to_unsigned(59999, 17));
     else B_cnt<=B_cnt-1;
    end if; 
    
  else 
  
  T0<='0'& T0(7 downto 1); T1<='0'& T1(7 downto 1); A0<='0'& A0(7 downto 1); A1<='0'& A1(7 downto 1);
  
  end if;
  
 PM_TT0<=T0(0); PM_TT1<=T1(0); PM_TA0<=A0(0); PM_TA1<=A1(0);

 end if;
 end process;
	 
TT0_buf: ibufds_diff_out generic map (DIFF_TERM =>TRUE,  IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS_25")
         port map (O=> HDMI0_P(0), OB=> HDMI0_N(0), I=> TCM_TT0_P, IB => TCM_TT0_N);
          
TT1_buf: ibufds_diff_out generic map (DIFF_TERM =>TRUE,  IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS_25")
         port map (O=> HDMI0_P(1), OB=> HDMI0_N(1), I=> TCM_TT1_P, IB => TCM_TT1_N);

TA0_buf: ibufds_diff_out generic map (DIFF_TERM =>TRUE,  IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS_25")
         port map (O=> HDMI0_P(2), OB=> HDMI0_N(2), I=> TCM_TA0_P, IB => TCM_TA0_N);
  
TA1_buf: ibufds_diff_out generic map (DIFF_TERM =>TRUE,  IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS_25")
         port map (O=> HDMI0_P(3), OB=> HDMI0_N(3), I=> TCM_TA1_P, IB => TCM_TA1_N);
                                 
Tspi_sck : OBUF Port map (O =>TCM_SPI_SCK , I => tcm_sck);
Tspi_sel : OBUF Port map (O =>TCM_SPI_SEL , I => tcm_sel);
Tspi_mosi : OBUF Port map (O =>TCM_SPI_MOSI , I => tcm_mosi);
Tspi_miso : IBUF Port map (O =>tcm_miso , I =>TCM_SPI_MISO);    

Pspi_sck : IBUF Port map (O =>pm_sck, I => PM_SPI_SCK);
Pspi_sel : IBUF Port map (O => pm_sel, I => PM_SPI_SEL);
Pspi_mosi : IBUF Port map (O => pm_mosi, I => PM_SPI_MOSI);
Pspi_miso : OBUF Port map (O =>PM_SPI_MISO, I =>pm_miso);    

PSPI: TCM_SPI port map(sck=>pm_sck, sel=>pm_sel, mosi=>pm_mosi, miso=>pm_miso);

ILA: for i in 0 to 15 generate
ILA0: OBUF
   port map (O => LA(i), I => LAI(i) );
end generate;
                              

-- PLL by KC705 generator 
PmClockPllcomp : PmClockPll
port map(
     RESET  => RESET,
     CLK_IN1_200  => source_gen,
	 CLK_OUT1_200  => MgtRefClk_pll,
	 CLK_OUT2_40  => DataClk_pll,
	 CLK_OUT3_320 => SysClk_pll
);

--  PLL by CDM clock A
CDMClkpllcomp : CDM_Clk_pll
port map(
     RESET  => RESET,
     locked=> SDclk_pll_ready,
     CLK_IN1_40  => CDM_clk_A,
	 CLK_OUT1_40  => CDM_pll_clk_A,
	 CLK_OUT2_320  => CDM_pll_SysClk
);
-- =====================================================


   IDL1 : IDELAYCTRL
   port map (
      RDY => dly_rdy,       -- 1-bit output: Ready output
      REFCLK => clk200, -- 1-bit input: Reference clock input
      RST => (RESET and (not clk200_rdy))        -- 1-bit input: Active high reset input
   );



HDMI0: tcm_sync 
  port map(
      CLKA => CDM_clk_A,
      TD_P=>HDMI0_P,
      TD_N=>HDMI0_N,
      RST=>RESET and (not dly_rdy),
      pllrdy =>open,
      rdy=>open,
      clkout=>HDMI_clkout_320,
      clkout_90=>open,
      bitcnt=>open,
      TDO=>HDMI0_o,
      Dready=>hdmi_ready, -- wren
      
      rd_lock=>rd_status,
      DATA_OUT=> HDMI0_d, -- to fifo
      status => HDMI0_s,
      PM_req => PM_req
  );
  
  
  process (HDMI_clkout_320)
  begin
  if (HDMI_clkout_320'event and HDMI_clkout_320='1') then
    
  LAI(3 downto 0)<=HDMI0_o;
  end if;
  end process;

  process (SysClk_to_FIT_GBT)
  begin
  if ( SysClk_to_FIT_GBT'event and  SysClk_to_FIT_GBT='1') then
  
  hdmi_ready2 <=hdmi_ready1; hdmi_ready1 <=hdmi_ready0; hdmi_ready0 <=hdmi_ready;
  if (hdmi_ready_sysclk='1') then HDMI0_d_sysclk <=HDMI0_d; end if; 

  end if;
  end process;
  
  hdmi_ready_sysclk<=(not hdmi_ready2) and hdmi_ready1;


-- IP-BUS module ===============================================

sfp_rate_sel(1 downto 0) <= B"00";
mac_addr <= X"020ddba11504"; -- Careful here, arbitrary addresses do not always work
--ip_addr <= X"ac144baf"; -- 172.20.75.175
--ip_addr <= X"ac144b5f"; -- 172.20.75.95
ip_addr <= X"c0a80029" when (addr_sw='1')  else -- 192.168.0.41  
           X"ac144baf"; -- 172.20.75.175

ipbus_module:  entity work.IPBUS_basex_infra 
generic map (USE_BUFG  => 1)
       
port map(
    eth_clk_p => eth_clk_p,
    eth_clk_n => eth_clk_n,
    eth_tx_p => eth_tx_p,
    eth_tx_n => eth_tx_n,
    eth_rx_p => eth_rx_p,
    eth_rx_n => eth_rx_n,
    
    clk_ipb_o => ipb_clk,
    rst_ipb_o => ipb_rst,
          
    RESET => FSM_Clocks.Reset,
    
    leds => open, -- status LEDs
    mac_addr => mac_addr,
    
    ip_addr => ip_addr,
    ipb_in => ipb_in,
    ipb_out => ipb_out,
    clk200 => clk200,
    locked=> clk200_rdy 
);


-- =============================================================
bus_select(0) <= ipb_str when ipb_addr(31 downto 3)= x"0000200" & '0'  else '0';
bus_select(1) <= ipb_str when ipb_addr(31 downto 12)= x"00001" else '0';
bus_select(2) <= ipb_str when ipb_addr(31 downto 9)=  x"00000" & "000" else '0';
bus_select(3) <= ipb_str when ipb_addr(31 downto 9)=  x"00000" & "001" else '0';
bus_select(4) <= ipb_str when ipb_addr(31 downto 9)=  x"00000" & "010" else '0';

ipb_data_out<=ipb_out.ipb_wdata; ipb_addr<=ipb_out.ipb_addr;
 ipb_in.ipb_rdata<=ipb_data_in; 
  
 ipb_iswr<=ipb_out.ipb_write and ipb_out.ipb_strobe; ipb_isrd<=(not ipb_out.ipb_write) and ipb_out.ipb_strobe; 

ipb_str<=ipb_out.ipb_strobe; ipb_wr<= ipb_out.ipb_write; 

rd_status <= '1' when (bus_select(4)='1') and (ipb_addr(8 downto 0)='0' & x"00") and (ipb_wr='0') else '0';
st_rq  <= '1' when (bus_select(4)='1') and (ipb_addr(8 downto 0)='0' & x"02") else '0'; 
st_rq_cmd  <= '1' when (bus_select(4)='1') and (ipb_addr(8 downto 0)='0' & x"02") and (ipb_wr='1') and (ipb_data_out(1)='1') else '0';
PM_rst <= '1' when (bus_select(4)='1') and (ipb_addr(8 downto 0)='0' & x"02") and (ipb_wr='1') and (ipb_data_out(2)='1') else '0';

 process (ipb_clk)
  begin
  if (ipb_clk'event and ipb_clk='1') then
  
  adc_sel1<=adc_sel and not d_rdy;
  
PM_req2<=PM_req1;  PM_req1<=PM_req0; PM_req0<=PM_req;
if (PM_req2='0') and (PM_req1='1') then PM_rq<='1';
 else
  if (st_rq='1') and (ipb_wr='0') then PM_rq<='0'; end if;
end if;
  
  end if;
  end process;
  
UA2 : USR_ACCESSE2   port map (CFGCLK => open, DATA => t_stmp, DATAVALID => open );

SNS : SENSOR  PORT MAP ( di_in => (others=>'0'), daddr_in => d_addr, den_in => d_rd, dwe_in => '0', drdy_out => d_rdy, do_out => d_sns, dclk_in => ipb_clk,
             reset_in => ipb_rst, vp_in => '0', vn_in => '0', channel_out => open,  eoc_out => open, alarm_out => open, eos_out => open, busy_out => open);

d_addr<="00000" & ipb_addr(1 downto 0);

adc_sel<= '1' when bus_select(4)='1' and ipb_addr(8 downto 2)="0000001" and ipb_addr(1 downto 0)/="11" and (ipb_wr='0') else '0';

d_rd<= adc_sel  and not adc_sel1;

loc_rdy<= d_rdy when adc_sel='1' else '1';  


loc_data<=   HDMI0_s when ipb_addr(8 downto 0) = '0' & x"00" else
             HDMI0_d when ipb_addr(8 downto 0) = '0' & x"01" else
             x"0000000" & "000" & PM_rq when ipb_addr(8 downto 0) = '0' & x"02" else
             t_stmp when ipb_addr(8 downto 0) =  '0' & x"03" else
             x"0000" & d_sns when adc_sel='1' else 
             x"00000000";



with bus_select select
ipb_in.ipb_ack<=    spi_ack when "00001",
                    ipb_ack_tm when "00010",
                    pm_spi_rdy when "00100",
                    tcm_sc_rdy when "01000",
                    loc_rdy when "10000",
                    '0' when others;


ipb_in.ipb_err<= spi_err or ipb_err_tm;

with bus_select select
      ipb_data_in<= spi_data_r  when "00001",
              ipb_data_in_tm    when "00010",
              pm_spi_data       when "00100",
              tcm_sc_data       when "01000",
              loc_data          when "10000",
              x"00000000"       when others;

              

slave_spi: entity work.ipbus_spi
		port map(
			clk => ipb_clk,
			rst => ipb_rst,
			ipb_data_w => ipb_data_out,
			ipb_data_r => spi_data_r,
			ipb_spi_adr =>ipb_addr(2 downto 0),
			ipb_sel=> bus_select(0),
			ipb_wr=> ipb_wr,
			ss => spi_ss,
			ipb_err=> spi_err,
			ipb_ack=> spi_ack,
			mosi => spi_mosi,
			miso => spi_miso,
			sclk => spi_sclk
		);
		
pm_sc:    pm_spi 
            Port map ( CLK => ipb_clk, 
                   RST  => ipb_rst, 
                   DI => ipb_data_out, 
                   DO => pm_spi_data,
                   A => ipb_addr(8 downto 0),
                   wr => ipb_iswr,
                   rd => ipb_isrd,
                   cs => bus_select(2),
                   rdy => pm_spi_rdy,
                   spi_sel =>tcm_sel,
                   spi_clk =>tcm_sck,
                   spi_mosi =>tcm_mosi,
                   spi_miso =>tcm_miso,
                   cnt_rd => cnt_rd,
                   PM_rst => PM_rst
                   );	
                   
 LAI(7) <= tcm_sel;
 LAI(6) <= tcm_sck;
 LAI(5) <= tcm_mosi;
 LAI(4) <= not tcm_miso;
 
 LAI(8) <= reset_aft_pllready;
 LAI(9) <= FSM_Clocks.Reset;
                    	

tcm_sc1:   tcm_sc 
            Port map ( CLK => ipb_clk, 
                   RST  => ipb_rst, 
                   DI => ipb_data_out, 
                   DO => tcm_sc_data,
                   A => ipb_addr(8 downto 0),
                   wr => ipb_iswr,
                   rd => ipb_isrd,
                   cs => bus_select(3),
                   rdy => tcm_sc_rdy,
                   cnt_rd => cnt_rd
                   );		

--LAI(0)<=cnt_rd;


-- Reset_Generator ===============================================
PLL_Reset_Generator_comp : entity work.PLL_Reset_Generator
port map (

		GRESET_I 		=> RESET,
		GDataClk_I 		=> CDM_clk_A,
		PLL_ready_I		=> SDclk_pll_ready,
		
		RESET_O 		=> reset_aft_pllready
);
-- =============================================================


-- Reset FSM =================================================
Reset_Generator_comp: entity work.Reset_Generator
port map(
			RESET_I => RESET,
			SysClk_I => FSM_Clocks.System_Clk,
			DataClk_I => FSM_Clocks.Data_Clk,
			Sys_Cntr_ready_I => Is_SysClkCounter_ready,
			Reset_DClk_O => reset_to_syscount,
			General_reset_O => FSM_Clocks.Reset,
			Reset_DClk40_O => reset_to_syscount40,
			General_reset40_O => FSM_Clocks.Reset40
		);
-- ===========================================================

-- Data Clk strobe ===========================================
DataClk_I_strobe_comp: entity work.DataClk_strobe
port map(
			RESET_I => reset_to_syscount,
			RESET40_I => FSM_Clocks.Reset40,
			SysClk_I => FSM_Clocks.System_Clk,
			DataClk_I => FSM_Clocks.Data_Clk,
			SysClk_count_O => FSM_Clocks.System_Counter,
			Counter_ready_O => Is_SysClkCounter_ready
		);

-- ===========================================================


-- IP-BUS data sender ==================================
FIT_TESTMODULE_IPBUS_sender_comp : entity work.FIT_TESTMODULE_IPBUS_sender
    Port map(
		FSM_Clocks_I 		=> FSM_Clocks,
		
		FIT_GBT_status_I	=> TESTM_status,
		Control_register_O	=> TESTM_control,
		
		GBTRX_IsData_rxclk_I => IsRxData_rxclk_from_GBT,
		GBTRX_Data_rxclk_I => RxData_rxclk_from_GBT,
		
		hdmi_fifo_datain_I => x"E" & TESTM_status.ORBIT_from_CRU & TESTM_status.BCID_from_CRU & HDMI0_d_sysclk,
        hdmi_fifo_wren_I => hdmi_ready_sysclk,
        hdmi_fifo_wrclk_I => SysClk_to_FIT_GBT,
		
		IPBUS_rst_I => ipb_rst,
		IPBUS_data_out_O => ipb_data_in_tm,
		IPBUS_data_in_I => ipb_data_out,
		IPBUS_addr_sel_I => bus_select(1),
		IPBUS_addr_I => ipb_addr(11 downto 0),
		IPBUS_iswr_I => ipb_iswr,
		IPBUS_isrd_I => ipb_isrd,
		IPBUS_ack_O => ipb_ack_tm,
		IPBUS_err_O => ipb_err_tm,
		IPBUS_base_addr_I => (others => '0')
	);
-- =====================================================


-- FIT GBT project =====================================
FitGbtPrg: entity work.FIT_GBT_project
	generic map(
		GENERATE_GBT_BANK	=> 1
	)
	
	Port map(
		RESET_I				=>	reset_to_syscount,
		SysClk_I			=>	FSM_Clocks.System_Clk,
		DataClk_I			=>	FSM_Clocks.Data_Clk,
		MgtRefClk_I			=>	MgtRefClk_to_FIT_GBT,
		RxDataClk_I			=>  GBT_RxFrameClk, -- 40MHz data clock in RX domain (loop back)
		GBT_RxFrameClk_O	=>  GBT_RxFrameClk,
		
		Board_data_I		=> board_data_test_const,
		Control_register_I	=> TESTM_control,
		
		MGT_RX_P_I => SFP_RX_P,
		MGT_RX_N_I => SFP_RX_N,
		MGT_TX_P_O => SFP_TX_P,
		MGT_TX_N_O => SFP_TX_N,
		MGT_TX_dsbl_O		=>	open,
		
		RxData_rxclk_to_FITrd_I 	=> RxData_rxclk_from_GBT, --loop back data
		IsRxData_rxclk_to_FITrd_I	=> IsRxData_rxclk_from_GBT, --loop back data
		Data_from_FITrd_O 			=> Data_from_FITrd,
		IsData_from_FITrd_O			=> IsData_from_FITrd,
		Data_to_GBT_I 				=> Data_from_FITrd, --loop back data
		IsData_to_GBT_I				=> IsData_from_FITrd, --loop back data
		
		RxData_rxclk_from_GBT_O	 	=> RxData_rxclk_from_GBT,
		IsRxData_rxclk_from_GBT_O	=> IsRxData_rxclk_from_GBT,
		rx_ph320 => open,
		ph_error320 => open, 

		FIT_GBT_status_O 	=> TESTM_status
		);		
-- =====================================================






end Behavioral;

