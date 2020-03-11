----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2017 07:23:37 PM
-- Design Name: 
-- Module Name: tcm_inp - Combined
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

entity tcm_inp is 
            Port(TD : in STD_LOGIC_VECTOR (3 downto 0);
                 rdy : in STD_LOGIC;
                 sync : in STD_LOGIC;
                 inp_act : out STD_LOGIC;
                 CLK320 : in STD_LOGIC;
                 bitcnt : in STD_LOGIC_VECTOR (2 downto 0);
                 TDO : out STD_LOGIC_VECTOR (3 downto 0);
                 DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0)
                 );
end tcm_inp;

architecture Combined of tcm_inp is

signal TD_eq, TD_bits, TD_idle, inp_on, sync_0 : STD_LOGIC;
signal TDi : STD_LOGIC_VECTOR (3 downto 0);
signal TDV, TDS : STD_LOGIC_VECTOR (7 downto 0);
signal TT0sr, TT1sr, TT2sr, TT3sr: STD_LOGIC_VECTOR (7 downto 0);
signal TD_pos, TD_nbt : STD_LOGIC_VECTOR (2 downto 0);
signal pcount : STD_LOGIC_VECTOR (5 downto 0);
signal trig_data  : STD_LOGIC_VECTOR (31 downto 0);

begin


TDO <= TDi; inp_act<=inp_on; DATA_OUT<=trig_data;


process (CLK320)
begin
if (CLK320'event and CLK320='1') then
sync_0<=sync;

if (inp_on='1') or (sync='1') then TDi<=TD; else TDi<="0000"; end if;  
 
TT0sr<=TDi(0) &  TT0sr(7 downto 1) ; TT1sr<=TDi(1) & TT1sr(7 downto 1); TT2sr<= TDi(2) & TT2sr(7 downto 1); TT3sr<=TDi(3) & TT3sr(7 downto 1);

if (rdy='0') then pcount<="000000"; inp_on<='0'; end if;
 
if (bitcnt="000") then 
 TD_idle<=TD_eq and TD_bits;
  trig_data<=TT3sr & TT2sr & TT1sr & TT0sr;
 end if;
 

if (bitcnt="001") and (sync='1') and (pcount/="111111") and (TD_idle='1') then pcount<=pcount+1; end if;

if (sync='0') and (sync_0='1') and (pcount="111111") then inp_on<='1';  end if;  

end if;
end process;

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


end Combined;
