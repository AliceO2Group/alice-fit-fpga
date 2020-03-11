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

entity hdmirx is
    Port ( TD_P : in STD_LOGIC_VECTOR (3 downto 0);
           TD_N : in STD_LOGIC_VECTOR (3 downto 0);
           
           RST : in STD_LOGIC;
           ena : in STD_LOGIC;
           link_rdy : out STD_LOGIC;
           trig_ena: in STD_LOGIC;
           clk320 : in STD_LOGIC;
           clk320_90 : in STD_LOGIC;
           TDO : out STD_LOGIC_VECTOR (3 downto 0);
           rd_lock : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0);
           status :  out STD_LOGIC_VECTOR (31 downto 0);
           master  : in STD_LOGIC;
           mt_cou : in STD_LOGIC_VECTOR (2 downto 0);
           bitpos : out STD_LOGIC_VECTOR (2 downto 0);
           bitpos_ok : out STD_LOGIC;
           ena_dly : in STD_LOGIC;
           inc_dly : in STD_LOGIC;
           ena_ph : out  STD_LOGIC;
           inc_ph : out  STD_LOGIC;
           is_idle : out  STD_LOGIC;
           bp_stable : out  STD_LOGIC;
           dl_low : out  STD_LOGIC;
           dl_high : out  STD_LOGIC;
           mast_dl_err : out  STD_LOGIC;
           mast_stable : out  STD_LOGIC;
           dly_ctrl_ena : in  STD_LOGIC
           );
end hdmirx;

architecture RTL of hdmirx is

type vect8_arr is array (3 downto 0) of std_logic_vector (7 downto 0);
type vect6_arr is array (3 downto 0) of std_logic_vector (5 downto 0);
type vect5_arr is array (3 downto 0) of std_logic_vector (4 downto 0);
type vect4_arr is array (3 downto 0) of std_logic_vector (3 downto 0);

signal CLK320B, clk320_90B, lock, TD_eq, TD_bits, TD_idle, l_rdy, bitpos_ok_i : STD_LOGIC; 
signal dly_clr, dl_ce0, dl_inc0, link_ok, link_lost, dly_clr0, dly_clr1, dly_ctrl_ena0, dly_ctrl_ena1, dl_low0, dl_high0, dl_low1, dl_high1, mast_stable_i : STD_LOGIC;

signal sample, sig_loss_cou, TTsr : vect8_arr;
signal sig_stable_cou : vect6_arr;
signal dvalue, ph_cnt : vect5_arr;
 
signal dl_ce, dl_inc, edge, el, err, sig_lost, sig_stable, dl_low_i, dl_high_i : STD_LOGIC_VECTOR (3 downto 0);


signal TDi, TDO_i, TDD_P, TDD_N, rstcount : STD_LOGIC_VECTOR (3 downto 0);
signal TDV, TDS : STD_LOGIC_VECTOR (7 downto 0);
signal idle_cou  : STD_LOGIC_VECTOR (5 downto 0);
signal TD_pos, TD_nbt, TD_bpos, TD_bpos_0  : STD_LOGIC_VECTOR (2 downto 0);
signal trig_data, status_bits  : STD_LOGIC_VECTOR (31 downto 0);
signal TD_bpstable, dis : STD_LOGIC;

attribute IODELAY_GROUP : STRING;


begin

link_rdy<= l_rdy; status<=status_bits; bitpos<=TD_bpos; bitpos_ok<=bitpos_ok_i; dl_low<=dl_low1; dl_high<=dl_high1;
DATA_OUT<=trig_data; ena_ph<=dl_ce0; inc_ph<= dl_inc0; is_idle<= TD_idle; bp_stable<= TD_bpstable; mast_stable<=mast_stable_i or (not master); 
 
TDO<=TDO_i;  

CLK320B<= not CLK320; CLK320_90B<= not CLK320_90;  
dl_ce(0) <= dl_ce0 when (master='0') else ena_dly; dl_inc(0) <= dl_inc0 when (master='0') else inc_dly;  

dly_clr<=((not dly_clr0) and dly_clr1) or (dly_ctrl_ena1 and (not dly_ctrl_ena0)) or rst; 

IDLY: for i in 0 to 3 generate
attribute IODELAY_GROUP of IDLP, IDLN : label is "TCM_DLY";
begin
IDLP : IDELAYE2
   generic map (
      CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "VARIABLE", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
   port map (
      CNTVALUEOUT => open, DATAOUT => TDD_P(i), C => CLK320, CE => dl_ce(i), CINVCTRL => '0', CNTVALUEIN => "00000", DATAIN => '0', IDATAIN => TD_P(i), INC => dl_inc(i), LD =>dly_clr, LDPIPEEN => '0', REGRST => '0');
IDLN : IDELAYE2
   generic map (
      CINVCTRL_SEL => "FALSE", DELAY_SRC => "IDATAIN", HIGH_PERFORMANCE_MODE => "TRUE", IDELAY_TYPE => "VARIABLE", IDELAY_VALUE => 16, PIPE_SEL => "FALSE", REFCLK_FREQUENCY => 200.0, SIGNAL_PATTERN => "DATA")
   port map (
      CNTVALUEOUT => dvalue(i), DATAOUT => TDD_N(i), C => CLK320, CE => dl_ce(i), CINVCTRL => '0', CNTVALUEIN => "00000", DATAIN => '0', IDATAIN => TD_N(i), INC => dl_inc(i), LD =>dly_clr , LDPIPEEN => '0', REGRST => '0');

ISERDES : ISERDESE2
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
   port map ( O => open, Q1 => sample(i)(3), Q2 => sample(i)(1), Q3 => sample(i)(2),Q4 => sample(i)(0),
      Q5 => open, Q6 => open, Q7 => open, Q8 => open, SHIFTOUT1 => open, SHIFTOUT2 => open, BITSLIP => '0',
      CE1 => '1', CE2 => '1', CLKDIVP => '0',
		CLK => CLK320, CLKB => CLK320B,
      CLKDIV => '0',
      OCLK => CLK320_90, OCLKB => CLK320_90B, 
      DYNCLKDIVSEL => '0',  DYNCLKSEL => '0',
      D => '0',
      DDLY => TDD_N(i),  OFB => '0',             
      RST => '0', 
      SHIFTIN1 => '0',  SHIFTIN2 => '0' 
   );  
   
end generate;             
  

process (CLK320)
begin
if (CLK320'event and CLK320='1') then
    
  for i in 0 to 3 loop 
    sample(i)(7 downto 4)<=sample(i)(3 downto 0);
    
    if (edge(i)='1') then sig_loss_cou(i)<=x"00";
       else if (sig_lost(i)='0') then sig_loss_cou(i)<= sig_loss_cou(i)+1; end if;
    end if;
       
    if (rst='1') or (err(i)='1') or (sig_lost(i)='1') or (ena='0') then sig_stable_cou(i)<="000000";
       else if (sig_stable(i)='0') and (edge(i)='1') then sig_stable_cou(i)<= sig_stable_cou(i)+1; end if;
    end if;
       
     
   TTsr(i)<=(not sample(i)(3)) &  TTsr(i)(7 downto 1) ; 

if (dvalue(i)="00000") then dl_low_i(i)<= '1'; else dl_low_i(i)<='0'; end if;
if (dvalue(i)="11111") then dl_high_i(i)<= '1'; else dl_high_i(i)<='0'; end if;

  end loop;     
    
  for i in 1 to 3 loop
   
  if (rst='1') or (sig_lost(i)='1') or (ena='0') or (dly_ctrl_ena='0') then ph_cnt(i)<="01111";
      else 
    if (edge(i)='1') then 
     if ((ph_cnt(i)="11111") and (el(i)='1') and (dl_high_i(i)='0')) or ((ph_cnt(i)="00000") and (el(i)='0') and (dl_low_i(i)='0')) then dl_ce(i)<='1'; dl_inc(i)<=el(i); ph_cnt(i)<="01111";
      else 
        if (el(i)='1') then ph_cnt(i)<=ph_cnt(i)+1; else ph_cnt(i)<=ph_cnt(i)-1; end if;
     end if; 
   end if;    
 end if;
 
 if (dl_ce(i)='1') then dl_ce(i)<='0'; end if;     

  end loop; 
  
  dly_clr1<=dly_clr0;  dly_clr0<= link_lost or (not ena);
  dly_ctrl_ena1<=dly_ctrl_ena0; dly_ctrl_ena0<=dly_ctrl_ena;
  l_rdy<=link_ok; dl_low1<=dl_low0; dl_high1<=dl_high0;
  mast_stable_i<=sig_stable(0);
  

  if (rst='1') or (sig_lost(0)='1') or (ena='0') then ph_cnt(0)<="01111";
      else 
    if (edge(0)='1') then 
      if ((ph_cnt(0)="11111") and (el(0)='1') and (dl_high_i(0)='0')) or ((ph_cnt(0)="00000") and (el(0)='0') and (dl_low_i(0)='0')) then dl_ce0<='1'; 
                dl_inc0<=el(0); ph_cnt(0)<="01111";
       else
          if (el(0)='1') then ph_cnt(0)<=ph_cnt(0)+1; else ph_cnt(0)<=ph_cnt(0)-1; end if;
      end if;
   end if;
 end if;
 
 if (dl_ce0='1') then dl_ce0<='0'; end if;  
    
  if ((ena and trig_ena)='0') then TDi<=x"0"; else TDi<=TDD_P; end if;
  
  if ((mt_cou="001") and (TDO_i=x"0")) then TDO_i<=x"0";  else TDO_i<=TDi; end if;
     
      
    if (rd_lock='0') then status_bits<= link_ok & sig_stable(3) & sig_lost(3) & dvalue(3) & bitpos_ok_i & sig_stable(2) & sig_lost(2)  & dvalue(2) & '0' & sig_stable(1) & sig_lost(1) & dvalue(1) & '0' & sig_stable(0) & sig_lost(0) & dvalue(0); end if;
     
         
   
    if (mt_cou="000") then 
       if (TD_eq and TD_bits and l_rdy)='1' then TD_idle<='1'; TD_bpos<=TD_pos; TD_bpos_0<=TD_bpos; 
           else TD_idle<='0'; end if;
    end if;
   
   if (mt_cou="001") then
       if (TD_idle='1') then 
           if (TD_bpos=TD_bpos_0) then TD_bpstable<='1';
            if (TD_bpos="011") then bitpos_ok_i<='1'; else bitpos_ok_i<='0'; end if; 
            else TD_bpstable<='0'; end if;
        end if;
   end if;

  
   if (mt_cou="010") then
      trig_data<=TTsr(3)(7) & TTsr(2)(7) & TTsr(3)(6) & TTsr(2)(6) & TTsr(3)(5) & TTsr(2)(5) & TTsr(3)(4) & TTsr(2)(4) & TTsr(3)(3) & TTsr(2)(3) & TTsr(3)(2) & TTsr(2)(2) & TTsr(3)(1) & TTsr(2)(1) & TTsr(1)(7) & TTsr(0)(7) & TTsr(1)(6) &
       TTsr(0)(6) & TTsr(1)(5) & TTsr(0)(5) & TTsr(1)(4) & TTsr(0)(4) & TTsr(1)(3) & TTsr(0)(3) & TTsr(1)(2) & TTsr(0)(2) & TTsr(1)(1) & TTsr(0)(1) & TTsr(3)(0) & TTsr(2)(0) & TTsr(1)(0) & TTsr(0)(0); 
   end if;
   
end if;
end process;

link_lost<='1' when sig_lost/="0000" else '0';
link_ok<= '1' when sig_stable="1111" else '0';

L1: for i in 0 to 3 generate 

err(i)<= (sample(i)(3) xor sample(i)(4)) or (sample(i)(2) xor sample(i)(3));
edge(i)<= el(i) or ((not sample(i)(5)) and sample(i)(4)) or ((not sample(i)(4)) and sample(i)(3)); 

el(i)<= ((not sample(i)(7)) and sample(i)(6)) or ((not sample(i)(6)) and sample(i)(5));

sig_lost(i)<= '1' when (sig_loss_cou(i)=x"FF") else '0'; 
 
sig_stable(i)<= '1' when (sig_stable_cou(i)="111111") else '0'; 


end generate;

dl_low0<= ena when (dl_low_i(3 downto 1)/="000") or ((master='0') and (dl_low_i(0)='1')) else '0';
dl_high0<= ena when (dl_high_i(3 downto 1)/="000") or ((master='0') and (dl_high_i(0)='1')) else '0';
mast_dl_err <= dl_low_i(0) or dl_high_i(0);

TLogic: for i in 0 to 7 generate
TDV(i)<= (TTsr(0)(i) and TTsr(1)(i) and TTsr(2)(i) and TTsr(3)(i));
TDS(i)<= TDV(i) or not (TTsr(0)(i) or TTsr(1)(i) or TTsr(2)(i) or TTsr(3)(i));
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
