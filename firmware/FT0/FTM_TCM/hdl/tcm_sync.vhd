----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2017 05:35:47 PM
-- Design Name: 
-- Module Name: tcm - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity tcm_sync is
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
end tcm_sync;

architecture RTL of tcm_sync is

signal CLK320, CLK320B, clk320_90, clk320_90B, psen, psen_0, psenm, psd, psdone, psd_rdy, lock, TD_eq, TD_bits, TD_idle, done, clk_unst, link_ok, srst, err, sync_err, sync_err0 : STD_LOGIC; 
signal sig_lost0, sig_lost1, sig_lost2, sig_lost3, edge0, edge1, edge2, edge3, err0, err1, err2, err3, sig_stable0, sig_stable1, sig_stable2, sig_stable3, el0, el1, el2, el3  : STD_LOGIC;
signal dl_inc1, dl_ce1, dl_inc2, ph_inc, dl_ce2, dl_inc3, dl_ce3, dl_low1, dl_high1, dl_low2, dl_high2, dl_low3, dl_high3, rd_lock0, rd_lock1, rd_lock2 : STD_LOGIC;

attribute keep : string;
attribute keep of rd_lock0 : signal is "true";
attribute keep of rd_lock1 : signal is "true";

signal dl_cnt1, dl_cnt2, dl_cnt3 : STD_LOGIC_VECTOR (2 downto 0);
signal TDi, TDD_P, TDD_N, rstcount, ph_cnt : STD_LOGIC_VECTOR (3 downto 0);
signal sample0, sample1, sample2, sample3  : STD_LOGIC_VECTOR (7 downto 0); 
signal dvalue1, dvalue2, dvalue3 : STD_LOGIC_VECTOR (4 downto 0);
signal TDV, TDS : STD_LOGIC_VECTOR (7 downto 0);
signal TT0sr, TT1sr, TT2sr, TT3sr: STD_LOGIC_VECTOR (7 downto 0);
signal idle_cou  : STD_LOGIC_VECTOR (5 downto 0);
signal sig_loss_cou0, sig_loss_cou1, sig_loss_cou2, sig_loss_cou3  : STD_LOGIC_VECTOR (7 downto 0);
signal sig_stable_cou0, sig_stable_cou1, sig_stable_cou2, sig_stable_cou3 : STD_LOGIC_VECTOR (5 downto 0);
signal bit_cou, TD_pos, TD_nbt, TD_bpos, TD_bpos_0  : STD_LOGIC_VECTOR (2 downto 0);
signal trig_data, status_bits  : STD_LOGIC_VECTOR (31 downto 0);
signal DValid, PM_req0, PM_req1 : STD_LOGIC;


component MMCM320_PH
port
 (-- Clock in ports
  -- Clock out ports
  CLK320          : out    std_logic;
  CLK320_90       : out    std_logic;
  -- Dynamic phase shift ports
  psclk             : in     std_logic;
  psen              : in     std_logic;
  psincdec          : in     std_logic;
  psdone            : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  lock              : out    std_logic;
  MCLK              : in     std_logic
 );
end component;

attribute IODELAY_GROUP : STRING;
attribute IODELAY_GROUP of IDL0P, IDL0N, IDL1P, IDL1N, IDL2P, IDL2N, IDL3P, IDL3N: label is "TCM_DLY";


begin

rdy<=done;  bitcnt<=bit_cou; status<=status_bits; Dready<=DValid;
clkout<=CLK320; clkout_90<=CLK320_90; TDO<=TDi; pllrdy<=not clk_unst; DATA_OUT<=trig_data;
PM_req<=PM_req0 or PM_req1;

IDL0P : IDELAYE2
   generic map (
      CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "FIXED", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
   port map (
      CNTVALUEOUT => open, DATAOUT => TDD_P(0), C => '0', CE => '0', CINVCTRL => '0', CNTVALUEIN => "00000", DATAIN => '0', IDATAIN => TD_P(0), INC => '0', LD => '0', LDPIPEEN => '0', REGRST => '0');
IDL0N : IDELAYE2
         generic map (
            CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "FIXED", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
         port map (
            CNTVALUEOUT => open, DATAOUT => TDD_N(0), C => '0', CE => '0', CINVCTRL => '0', CNTVALUEIN => "00000", DATAIN => '0', IDATAIN => TD_N(0), INC => '0', LD => '0', LDPIPEEN => '0', REGRST => '0');

IDL1P : IDELAYE2
         generic map (
            CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "VARIABLE", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
         port map (
            CNTVALUEOUT => open, DATAOUT => TDD_P(1), C => CLK320, CE => dl_ce1, CINVCTRL => '0', CNTVALUEIN => "10000", DATAIN => '0', IDATAIN => TD_P(1), INC => dl_inc1, LD => clk_unst, LDPIPEEN => '0', REGRST => '0');
IDL1N : IDELAYE2
         generic map (
            CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "VARIABLE", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
         port map (
            CNTVALUEOUT => dvalue1, DATAOUT => TDD_N(1), C => CLK320, CE => dl_ce1, CINVCTRL => '0', CNTVALUEIN => "10000", DATAIN => '0', IDATAIN => TD_N(1), INC => dl_inc1, LD => clk_unst, LDPIPEEN => '0', REGRST => '0');
                        
IDL2P : IDELAYE2
         generic map (
            CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "VARIABLE", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
         port map (
            CNTVALUEOUT => open, DATAOUT => TDD_P(2), C => CLK320, CE => dl_ce2, CINVCTRL => '0', CNTVALUEIN => "10000", DATAIN => '0', IDATAIN => TD_P(2), INC => dl_inc2, LD => clk_unst, LDPIPEEN => '0', REGRST => '0');
IDL2N : IDELAYE2
         generic map (
            CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "VARIABLE", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
         port map (
            CNTVALUEOUT => dvalue2, DATAOUT => TDD_N(2), C => CLK320, CE => dl_ce2, CINVCTRL => '0', CNTVALUEIN => "10000", DATAIN => '0', IDATAIN => TD_N(2), INC => dl_inc2, LD => clk_unst, LDPIPEEN => '0', REGRST => '0');

IDL3P : IDELAYE2
         generic map (
            CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "VARIABLE", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
         port map (
            CNTVALUEOUT => open, DATAOUT => TDD_P(3), C => CLK320, CE => dl_ce3, CINVCTRL => '0', CNTVALUEIN => "10000", DATAIN => '0', IDATAIN => TD_P(3), INC => dl_inc3, LD => clk_unst, LDPIPEEN => '0', REGRST => '0');
IDL3N : IDELAYE2
         generic map (
            CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "VARIABLE", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
         port map (
            CNTVALUEOUT => dvalue3, DATAOUT => TDD_N(3), C => CLK320, CE => dl_ce3, CINVCTRL => '0', CNTVALUEIN => "10000", DATAIN => '0', IDATAIN => TD_N(3), INC => dl_inc3, LD => clk_unst, LDPIPEEN => '0', REGRST => '0');
            
  
PLL1 : MMCM320_PH
   port map ( CLK320 => CLK320, CLK320_90=> CLK320_90,  psclk => CLK320, psen => psen, psincdec => ph_inc, psdone => open, reset => RST, lock => lock, MCLK => CLKA);
 
 CLK320B<= not CLK320; CLK320_90B<= not CLK320_90;    

ISERDES1 : ISERDESE2
   generic map (
      DATA_RATE => "DDR",           -- DDR, SDR
      DATA_WIDTH => 4,              -- Parallel data width (2-8,10,14)
      DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
      DYN_CLK_INV_EN => "FALSE",    -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
      -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
      INIT_Q1 => '0',
      INIT_Q2 => '0',
      INIT_Q3 => '0',
      INIT_Q4 => '0',
      INTERFACE_TYPE => "OVERSAMPLE",   -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
      IOBDELAY => "IFD",           -- NONE, BOTH, IBUF, IFD
      NUM_CE => 1,                  -- Number of clock enables (1,2)
      OFB_USED => "FALSE",          -- Select OFB path (FALSE, TRUE)
      SERDES_MODE => "MASTER",      -- MASTER, SLAVE
      -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
      SRVAL_Q1 => '0',
      SRVAL_Q2 => '0',
      SRVAL_Q3 => '0',
      SRVAL_Q4 => '0'  )
   port map ( O => open, Q1 => sample0(3), Q2 => sample0(1), Q3 => sample0(2),Q4 => sample0(0),
      Q5 => open, Q6 => open, Q7 => open, Q8 => open, SHIFTOUT1 => open, SHIFTOUT2 => open, BITSLIP => '0',
      CE1 => '1', CE2 => '1', CLKDIVP => '0',
		CLK => CLK320, CLKB => CLK320B,
      CLKDIV => '0',
      OCLK => CLK320_90, OCLKB => CLK320_90B, 
      DYNCLKDIVSEL => '0',  DYNCLKSEL => '0',
      D => '0',
      DDLY => TDD_N(0),  OFB => '0',             
      RST => '0', 
      SHIFTIN1 => '0',  SHIFTIN2 => '0' 
   );

ISERDES2 : ISERDESE2
   generic map (
      DATA_RATE => "DDR",           -- DDR, SDR
      DATA_WIDTH => 4,              -- Parallel data width (2-8,10,14)
      DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
      DYN_CLK_INV_EN => "FALSE",    -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
      -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
      INIT_Q1 => '0',
      INIT_Q2 => '0',
      INIT_Q3 => '0',
      INIT_Q4 => '0',
      INTERFACE_TYPE => "OVERSAMPLE",   -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
      IOBDELAY => "IFD",           -- NONE, BOTH, IBUF, IFD
      NUM_CE => 1,                  -- Number of clock enables (1,2)
      OFB_USED => "FALSE",          -- Select OFB path (FALSE, TRUE)
      SERDES_MODE => "MASTER",      -- MASTER, SLAVE
      -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
      SRVAL_Q1 => '0',
      SRVAL_Q2 => '0',
      SRVAL_Q3 => '0',
      SRVAL_Q4 => '0'  )
   port map ( O => open, Q1 => sample1(3), Q2 => sample1(1), Q3 => sample1(2),Q4 => sample1(0),
      Q5 => open, Q6 => open, Q7 => open, Q8 => open, SHIFTOUT1 => open, SHIFTOUT2 => open, BITSLIP => '0',
      CE1 => '1', CE2 => '1', CLKDIVP => '0',
		CLK => CLK320, CLKB => CLK320B,
      CLKDIV => '0',
      OCLK => CLK320_90, OCLKB => CLK320_90B, 
      DYNCLKDIVSEL => '0',  DYNCLKSEL => '0',
      D => '0',
      DDLY => TDD_N(1),  OFB => '0',             
      RST => '0', 
      SHIFTIN1 => '0',  SHIFTIN2 => '0' 
   );

ISERDES3 : ISERDESE2
   generic map (
      DATA_RATE => "DDR",           -- DDR, SDR
      DATA_WIDTH => 4,              -- Parallel data width (2-8,10,14)
      DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
      DYN_CLK_INV_EN => "FALSE",    -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
      -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
      INIT_Q1 => '0',
      INIT_Q2 => '0',
      INIT_Q3 => '0',
      INIT_Q4 => '0',
      INTERFACE_TYPE => "OVERSAMPLE",   -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
      IOBDELAY => "IFD",           -- NONE, BOTH, IBUF, IFD
      NUM_CE => 1,                  -- Number of clock enables (1,2)
      OFB_USED => "FALSE",          -- Select OFB path (FALSE, TRUE)
      SERDES_MODE => "MASTER",      -- MASTER, SLAVE
      -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
      SRVAL_Q1 => '0',
      SRVAL_Q2 => '0',
      SRVAL_Q3 => '0',
      SRVAL_Q4 => '0'  )
   port map ( O => open, Q1 => sample2(3), Q2 => sample2(1), Q3 => sample2(2),Q4 => sample2(0),
      Q5 => open, Q6 => open, Q7 => open, Q8 => open, SHIFTOUT1 => open, SHIFTOUT2 => open, BITSLIP => '0',
      CE1 => '1', CE2 => '1', CLKDIVP => '0',
		CLK => CLK320, CLKB => CLK320B,
      CLKDIV => '0',
      OCLK => CLK320_90, OCLKB => CLK320_90B, 
      DYNCLKDIVSEL => '0',  DYNCLKSEL => '0',
      D => '0',
      DDLY => TDD_N(2),  OFB => '0',             
      RST => '0', 
      SHIFTIN1 => '0',  SHIFTIN2 => '0' 
   );

ISERDES4 : ISERDESE2
   generic map (
      DATA_RATE => "DDR",           -- DDR, SDR
      DATA_WIDTH => 4,              -- Parallel data width (2-8,10,14)
      DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
      DYN_CLK_INV_EN => "FALSE",    -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
      -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
      INIT_Q1 => '0',
      INIT_Q2 => '0',
      INIT_Q3 => '0',
      INIT_Q4 => '0',
      INTERFACE_TYPE => "OVERSAMPLE",   -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
      IOBDELAY => "IFD",           -- NONE, BOTH, IBUF, IFD
      NUM_CE => 1,                  -- Number of clock enables (1,2)
      OFB_USED => "FALSE",          -- Select OFB path (FALSE, TRUE)
      SERDES_MODE => "MASTER",      -- MASTER, SLAVE
      -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
      SRVAL_Q1 => '0',
      SRVAL_Q2 => '0',
      SRVAL_Q3 => '0',
      SRVAL_Q4 => '0'  )
   port map ( O => open, Q1 => sample3(3), Q2 => sample3(1), Q3 => sample3(2),Q4 => sample3(0),
      Q5 => open, Q6 => open, Q7 => open, Q8 => open, SHIFTOUT1 => open, SHIFTOUT2 => open, BITSLIP => '0',
      CE1 => '1', CE2 => '1', CLKDIVP => '0',
		CLK => CLK320, CLKB => CLK320B,
      CLKDIV => '0',
      OCLK => CLK320_90, OCLKB => CLK320_90B, 
      DYNCLKDIVSEL => '0',  DYNCLKSEL => '0',
      D => '0',
      DDLY => TDD_N(3),  OFB => '0',             
      RST => '0', 
      SHIFTIN1 => '0',  SHIFTIN2 => '0' 
   );

process(CLKA, RST, lock)
begin
if (RST='1') or (lock ='0') then srst<='1'; rstcount<="0000"; else
if (CLKA'event) and (CLKA='1') then
if (rstcount="1111") then  srst<='0'; else rstcount<=rstcount+1; end if; 
end if;
end if;
end process;


process (CLK320)
begin
if (CLK320'event and CLK320='1') then

 
    sample0(7 downto 4)<=sample0(3 downto 0); sample1(7 downto 4)<=sample1(3 downto 0); sample2(7 downto 4)<=sample2(3 downto 0); sample3(7 downto 4)<=sample3(3 downto 0);
   
    dl_inc1<=el1; dl_inc2<=el2; dl_inc3<=el3; ph_inc<=el0;
    
    if ((bit_cou="000") and (TDi=x"0"))or (done='0') then TDi<=x"0"; else TDi<=TDD_P; end if; 
     
     rd_lock2<=rd_lock1; rd_lock1<=rd_lock0; rd_lock0<=rd_lock;
      
    clk_unst<=not sig_stable0; 

     if (rd_lock1='1') then status_bits<= err & sig_stable3 & sig_lost3 & dvalue3 & sync_err & sig_stable2 & sig_lost2  & dvalue2 & '0' & sig_stable1 & sig_lost1 & dvalue1 & '0' & sig_stable0 & sig_lost0 & x"0" & done ; end if;
     
     if (link_ok='0') then err<='1'; 
     else if (rd_lock1='0') and (rd_lock2='1') then err<='0'; end if;
     end if;
     
     if (sync_err0='1') then sync_err<='1'; 
     else if (rd_lock1='0') and (rd_lock2='1') then sync_err<='0'; end if;
     end if;
    
    if (edge0='1') then sig_loss_cou0<=x"00";
       else if (sig_lost0='0') then sig_loss_cou0<= sig_loss_cou0+1; end if;
    end if;
    if (edge1='1') then sig_loss_cou1<=x"00";
       else if (sig_lost1='0') then sig_loss_cou1<= sig_loss_cou1+1; end if;
    end if;
    if (edge2='1') then sig_loss_cou2<=x"00";
       else if (sig_lost2='0') then sig_loss_cou2<= sig_loss_cou2+1; end if;
    end if;
    if (edge3='1') then sig_loss_cou3<=x"00";
       else if (sig_lost3='0') then sig_loss_cou3<= sig_loss_cou3+1; end if;
    end if;
    
    if (srst='1') or (err0='1') or ((sig_lost0='1') and (done='0')) or (sync_err0='1') then sig_stable_cou0<="000000";
       else if (sig_stable0='0') and (edge0='1') then sig_stable_cou0<= sig_stable_cou0+1; end if;
    end if;
    if (srst='1') or (err1='1') or ((sig_lost1='1') and (done='0')) or (sync_err0='1') or (dl_high1='1') or (dl_low1='1') then sig_stable_cou1<="000000";
       else if (sig_stable1='0')  and (edge1='1') then sig_stable_cou1<= sig_stable_cou1+1; end if;
    end if;
    if (srst='1') or (err2='1') or ((sig_lost2='1') and (done='0')) or (sync_err0='1') or (dl_high2='1') or (dl_low2='1') then sig_stable_cou2<="000000";
       else if (sig_stable2='0') and (edge2='1') then sig_stable_cou2<= sig_stable_cou2+1; end if;
    end if;
    if (srst='1') or (err3='1') or ((sig_lost3='1') and (done='0')) or (sync_err0='1') or (dl_high3='1') or (dl_low3='1') then sig_stable_cou3<="000000";
       else if (sig_stable3='0') and (edge3='1') then sig_stable_cou3<= sig_stable_cou3+1; end if;
    end if;
    
     if (srst='1') or (sig_lost0='1') then ph_cnt<="0111";
          else 
           if (edge0='1') then 
             if (el0='1') then ph_cnt<=ph_cnt+1; else ph_cnt<=ph_cnt-1; end if;
           end if; 
        end if;  
       if ((ph_cnt="1111") and (el0='1')) or ((ph_cnt="0000") and (el0='0')) then psen<=edge0; else psen<='0'; end if;
    
    if (clk_unst='1') then dl_cnt1<="011";
       else 
        if (edge1='1') then 
          if (el1='1') then dl_cnt1<=dl_cnt1+1; else dl_cnt1<=dl_cnt1-1; end if;
        end if; 
     end if;  
    if ((dl_cnt1="111") and (el1='1') and (dl_high1='0')) or ((dl_cnt1="000") and (el1='0') and (dl_low1='0')) then dl_ce1<=edge1; else dl_ce1<='0'; end if;

    if (clk_unst='1') then dl_cnt2<="011";
       else 
        if (edge2='1') then 
          if (el2='1') then dl_cnt2<=dl_cnt2+1; else dl_cnt2<=dl_cnt2-1; end if;
        end if; 
     end if;  
    if ((dl_cnt2="111") and (el2='1') and (dl_high2='0')) or ((dl_cnt2="000") and (el2='0') and (dl_low2='0')) then dl_ce2<=edge2; else dl_ce2<='0'; end if;

    if (clk_unst='1') then dl_cnt3<="011";
       else 
        if (edge3='1') then 
          if (el3='1') then dl_cnt3<=dl_cnt3+1; else dl_cnt3<=dl_cnt3-1; end if;
        end if; 
     end if;  
    if ((dl_cnt3="111") and (el3='1') and (dl_high3='0')) or ((dl_cnt3="000") and (el3='0') and (dl_low3='0')) then dl_ce3<=edge3; else dl_ce3<='0'; end if;

   
   if (link_ok='0') or (srst='1') then done<='0'; 
    else if (done='0') and (TD_bpos="001") and (idle_cou>"010000") then done<='1'; end if;
   end if; 
   
   TT0sr<=(not sample0(3)) &  TT0sr(7 downto 1) ; TT1sr<=(not sample1(3)) & TT1sr(7 downto 1); TT2sr<= (not sample2(3)) & TT2sr(7 downto 1); TT3sr<=(not sample3(3)) & TT3sr(7 downto 1);
   
  
   if (bit_cou="010") then
      trig_data<=TT3sr(7) & TT2sr(7) & TT3sr(6) & TT2sr(6) & TT3sr(5) & TT2sr(5) & TT3sr(4) & TT2sr(4) & TT3sr(3) & TT2sr(3) & TT3sr(2) & TT2sr(2) & TT3sr(1) & TT2sr(1) & TT1sr(7) & TT0sr(7) & TT1sr(6) & TT0sr(6) & TT1sr(5) & TT0sr(5) & TT1sr(4) & TT0sr(4) & TT1sr(3) & TT0sr(3) & TT1sr(2) & TT0sr(2) & TT1sr(1) & TT0sr(1) & TT3sr(0) & TT2sr(0) & TT1sr(0) & TT0sr(0); 
      if (TD_eq and TD_bits and link_ok)='1' then TD_idle<='1'; TD_bpos<=TD_pos; TD_bpos_0<=TD_bpos; 
          else TD_idle<='0'; 
      end if;
         
      if (done='1')  then
        if (((TD_eq and TD_bits)='0') or (TD_bpos/="001")) and ((TT3sr(0) or TT2sr(0) or TT1sr(0) or TT0sr(0))='0') then 
            if (PM_req0='0') and ((TT3sr(1) and TT2sr(1) and TT1sr(1))='1') and (TT0sr(1)='0') then PM_req0<='1';
               else sync_err0<= '1';
            end if;
         end if;
        else sync_err0<='0';
      end if;
      
      if (PM_req0='1') then PM_req0<='0'; end if;
      
      PM_req1<=PM_req0;
      
   end if;
   
   if (done='1') and (bit_cou="010") and (TT3sr(0) or TT2sr(0) or TT1sr(0) or TT0sr(0))='1' then DValid<='1'; 
      else 
         if (DValid='1') and (bit_cou="110") then DValid<='0'; end if;
     end if; 

   if (link_ok='0') or (done='1') then idle_cou<="000000";
    else 
     if (bit_cou="011") and (TD_idle='1') then
       if (TD_bpos=TD_bpos_0) then  idle_cou<=idle_cou+1;
           else idle_cou<="000000"; end if;
       end if;
   end if;
   
   if (bit_cou="100") and (idle_cou="111111") and (done='0') then bit_cou<="110"-TD_bpos;  
     else bit_cou<=bit_cou+1; end if;
    
end if;
end process;

link_ok<= sig_stable0 and sig_stable1 and sig_stable2 and sig_stable3;

 

err0<= sample0(3) xor sample0(4);
err1<= sample1(3) xor sample1(4);
err2<= sample2(3) xor sample2(4);
err3<= sample3(3) xor sample3(4);

edge0<= (sample0(3) xor sample0(7)) or (sample0(4) xor sample0(7));  
edge1<= (sample1(3) xor sample1(7)) or (sample1(4) xor sample1(7));
edge2<= (sample2(3) xor sample2(7)) or (sample2(4) xor sample2(7));  
edge3<= (sample3(3) xor sample3(7)) or (sample3(4) xor sample3(7));

el0<= sample0(5) xor sample0(7);
el1<= sample1(5) xor sample1(7);
el2<= sample2(5) xor sample2(7);
el3<= sample3(5) xor sample3(7);

sig_lost0<= '1' when (sig_loss_cou0=x"FF") else '0'; 
sig_lost1<= '1' when (sig_loss_cou1=x"FF") else '0'; 
sig_lost2<= '1' when (sig_loss_cou2=x"FF") else '0'; 
sig_lost3<= '1' when (sig_loss_cou3=x"FF") else '0';
 
sig_stable0<= '1' when (sig_stable_cou0="111111") else '0'; 
sig_stable1<= '1' when (sig_stable_cou1="111111") else '0';
sig_stable2<= '1' when (sig_stable_cou2="111111") else '0'; 
sig_stable3<= '1' when (sig_stable_cou3="111111") else '0';

 
dl_low1<= '1' when (dvalue1="00000") else '0';
dl_high1<= '1' when (dvalue1="11111") else '0';
dl_low2<= '1' when (dvalue2="00000") else '0';
dl_high2<= '1' when (dvalue2="11111") else '0';
dl_low3<= '1' when (dvalue3="00000") else '0';
dl_high3<= '1' when (dvalue3="11111") else '0';

TLogic: for i in 0 to 7 generate
TDV(i)<= (TT0sr(i) and TT1sr(i) and TT2sr(i) and TT3sr(i));
TDS(i)<= TDV(i) or not (TT0sr(i) or TT1sr(i) or TT2sr(i) or TT3sr(i));
end generate;

TD_eq<=TDS(0) and TDS(1) and TDS(2) and TDS(3) and TDS(4) and TDS(5) and TDS(6) and TDS(7);
TD_nbt<=("00" & TDV(0))+("00" & TDV(1))+("00" & TDV(2))+("00" & TDV(3))+("00" & TDV(4))+("00" & TDV(5))+("00" & TDV(6))+("00" & TDV(7));
TD_bits<= '1' when (TD_nbt="001") else '0';
TD_pos<="000" when TDV(0)='1' else
        "001" when TDV(1)='1' else
        "010" when TDV(2)='1' else
        "011" when TDV(3)='1' else
        "100" when TDV(4)='1' else
        "101" when TDV(5)='1' else
        "110" when TDV(6)='1' else
        "111";


end RTL;
