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
           bitcnt : out STD_LOGIC_VECTOR (2 downto 0);
           TDO : out STD_LOGIC_VECTOR (3 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0)
           );
end tcm_sync;

architecture combined of tcm_sync is

signal CLK320, CLK320_B, CLK320_90, CLK320_90B, psen, psen_0, psenm, psd, psdone, lock,PHd, PHd_0, PHd_1, PHd_2, psd_0, psd_rdy, TD_eq, TD_bits, TD_idle, pll_rdy,done, edg, TDi0  : STD_LOGIC;
signal TDi : STD_LOGIC_VECTOR (3 downto 1);
signal TDV, TDS : STD_LOGIC_VECTOR (7 downto 0);
signal TT0sr, TT1sr, TT2sr, TT3sr: STD_LOGIC_VECTOR (7 downto 0);
signal PH_cou  : STD_LOGIC_VECTOR (4 downto 0);
signal idle_cou  : STD_LOGIC_VECTOR (5 downto 0);
signal rdy_cou  : STD_LOGIC_VECTOR (6 downto 0);
signal bit_cou, TD_pos, TD_nbt, TD_bpos, TD_bpos_0  : STD_LOGIC_VECTOR (2 downto 0);
signal trig_data  : STD_LOGIC_VECTOR (31 downto 0);
signal QDR : STD_LOGIC_VECTOR (3 downto 0);

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

begin

rdy<=done;  bitcnt<=bit_cou;
clkout<=CLK320; TDO<=TDi & TDi0; pllrdy<=pll_rdy; DATA_OUT<=trig_data;

IDDR_inst : IDDR 
   generic map (
      DDR_CLK_EDGE => "SAME_EDGE", INIT_Q1 => '0', INIT_Q2 => '0',SRTYPE => "SYNC") 
   port map ( Q1 => TDi0, Q2 => PHd, C => CLK320, CE =>'1', D => TD_P(0), R => '0', S =>'0');
   
  CLK320_B<= not CLK320;  clk320_90B<=not clk320_90;
  
  
  
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
        IOBDELAY => "NONE",           -- NONE, BOTH, IBUF, IFD
        NUM_CE => 1,                  -- Number of clock enables (1,2)
        OFB_USED => "FALSE",          -- Select OFB path (FALSE, TRUE)
        SERDES_MODE => "MASTER",      -- MASTER, SLAVE
        -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
        SRVAL_Q1 => '0',
        SRVAL_Q2 => '0',
        SRVAL_Q3 => '0',
        SRVAL_Q4 => '0'  )
     port map ( O => open, Q1 => QDR(3), Q2 => QDR(1), Q3 => QDR(2),Q4 => QDR(0),
        Q5 => open, Q6 => open, Q7 => open, Q8 => open, SHIFTOUT1 => open, SHIFTOUT2 => open, BITSLIP => '0',
        CE1 => '1', CE2 => '1', CLKDIVP => '0',
          CLK => CLK320, CLKB => CLK320_B,
        CLKDIV => '0',
        OCLK => CLK320_90, OCLKB => CLK320_90B, 
        DYNCLKDIVSEL => '0',  DYNCLKSEL => '0',
        D => TD_N(0),
        DDLY => '0',  OFB => '0',             
        RST => '0', 
        SHIFTIN1 => '0',  SHIFTIN2 => '0' 
     );


PLL1 : MMCM320_PH
   port map ( CLK320 => CLK320, CLK320_90 => CLK320_90, psclk => CLK320, psen => psen, psincdec => psd_0, psdone => psdone, reset => RST, lock => lock, MCLK => CLKA);
   
process (CLK320, lock)
begin
if (lock='0') then psd_rdy<='1'; done<='0'; pll_rdy<='0'; rdy_cou<="0000000";
  else
  if (CLK320'event and CLK320='1') then
    if (psdone='1')  then psd_rdy<='1'; 
    else if (psen_0='1') then psd_rdy<='0'; end if;
   end if;
   if (pll_rdy='0') then done<='0'; 
    else if (done='0') and (TD_bpos="001") and (idle_cou>"010000") then done<='1'; end if;
   end if; 
    
  if (PH_cou="11111") then pll_rdy<='0'; rdy_cou<="0000000";
   else 
     if (rdy_cou/="1111111") then 
      if (edg='1') then rdy_cou<=rdy_cou+1; end if;
      else pll_rdy<='1';
      end if; 
     end if;
  end if;
end if;
end process;
 
process (CLK320)
begin
if (CLK320'event and CLK320='1') then

 TDi<=TD_P(3 downto 1); 
 
TT0sr<=TDi0 &  TT0sr(7 downto 1) ; TT1sr<=TDi(1) & TT1sr(7 downto 1); TT2sr<= TDi(2) & TT2sr(7 downto 1); TT3sr<=TDi(3) & TT3sr(7 downto 1);

if (bit_cou="000") then 
    if (TD_eq and TD_bits and pll_rdy)='1' then TD_idle<='1'; TD_bpos<=TD_pos; TD_bpos_0<=TD_bpos; 
        else TD_idle<='0'; end if;
  trig_data<=TT3sr & TT2sr & TT1sr & TT0sr;   
 end if;
 
 if (TD_idle='1') and (bit_cou="001") then
    if (TD_bpos=TD_bpos_0) then
       if (idle_cou/="111111") then idle_cou<=idle_cou+1; end if;
    else idle_cou<="000000"; end if;
end if;

if (idle_cou="111111") and (done='0') then bit_cou<="100"-TD_bpos;  idle_cou<="000000";
  else bit_cou<=bit_cou+1;
 end if;

PHd_0<=TDi0;

if (edg='1') then  

psd_0<=not psd; psen<=psen_0; 

  if (psd xor psd_0)='1' then PH_cou<="00000"; 
  else 
   if ((psd_rdy and lock)='1') and (PH_cou/="11111") then PH_cou<=PH_cou+1; end if; 
  end if;  
     
 end if;
 
end if;
end process; 

edg<=TDi0 XOR PHd_0;
psd<=not (PHd_0 XOR PHd);
psenm<='1' when (PH_cou>"00110") else '0';
psen_0<=psd_rdy and lock and psenm and edg;


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


end combined;
