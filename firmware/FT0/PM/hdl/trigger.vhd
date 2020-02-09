----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2019 05:07:54 PM
-- Design Name: 
-- Module Name: trigger - RTL
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

package PM12_pkg is
type trig_time is array (0 to 11)  of STD_LOGIC_VECTOR (9 downto 0);
type trig_ampl0 is array (0 to 11) of STD_LOGIC_VECTOR(12 downto 0);
end package; 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.PM12_pkg.all; 

entity trigger is
    Port ( clk320 : in STD_LOGIC;   -- main 320 MHz clock;
           mt_cou : in STD_LOGIC_VECTOR (2 downto 0); -- Global state counter (0-7)
           CH_trigt : in STD_LOGIC_VECTOR (11 downto 0); -- Timing information valid for trigger (mt=2)
           CH_triga : in STD_LOGIC_VECTOR (11 downto 0); -- Amplitude information valid for trigger (mt=1)
           CH_TIME_T : in trig_time; -- Timing information from channels (mt=2), 0 if not to be used in trigger
           CH_ampl0 : in trig_ampl0; -- Amplitude information from channels (mt=2), 0 if not to be used in trigger
           tt  : out STD_LOGIC_VECTOR (1 downto 0); -- trigger data outputs to OLOGIC 
           ta  : out STD_LOGIC_VECTOR (1 downto 0)
            );
end trigger;

architecture RTL of trigger is

type trig_ampl is array (0 to 11) of STD_LOGIC_VECTOR(9 downto 0);

signal TT_mode, Trig_onA0, Trig_on0 : STD_LOGIC;
signal CH_ampl : trig_ampl;
signal CH_TIME1_T : trig_time;

signal N_chans :  STD_LOGIC_VECTOR(3 downto 0);

signal tts, tas : STD_LOGIC_VECTOR (5 downto 0);
signal ta0s : STD_LOGIC_VECTOR (6 downto 0);
signal tts_c, tas_c : STD_LOGIC_VECTOR (3 downto 0);
signal tas00, tas01, tas10, tas11, tai00, tai01, tai10, tai11, tai20, tai21, tts00, tts01, tts10, tts11 : STD_LOGIC_VECTOR (2 downto 0);
signal N1_chans, N2_chans : STD_LOGIC_VECTOR (2 downto 0);

begin

process (clk320)
begin
if (clk320'event and clk320='1') then

if (mt_cou="001") then 
    TT_mode<='1';
    Trig_onA0 <=CH_triga(0) or CH_triga(1) or CH_triga(2) or CH_triga(3) or CH_triga(4) or CH_triga(5) or CH_triga(6) or CH_triga(7) or CH_triga(8) or CH_triga(9) or CH_triga(10) or CH_triga(11);
    tai00<=("00"&CH_ampl0(0)(0))+("00"&CH_ampl0(1)(0))+("00"&CH_ampl0(2)(0))+("00"&CH_ampl0(3)(0))+("00"&CH_ampl0(4)(0))+("00"&CH_ampl0(5)(0));
    tai01<=("00"&CH_ampl0(6)(0))+("00"&CH_ampl0(7)(0))+("00"&CH_ampl0(8)(0))+("00"&CH_ampl0(9)(0))+("00"&CH_ampl0(10)(0))+("00"&CH_ampl0(11)(0));
    tai10<=("00"&CH_ampl0(0)(1))+("00"&CH_ampl0(1)(1))+("00"&CH_ampl0(2)(1))+("00"&CH_ampl0(3)(1))+("00"&CH_ampl0(4)(1))+("00"&CH_ampl0(5)(1));
    tai11<=("00"&CH_ampl0(6)(1))+("00"&CH_ampl0(7)(1))+("00"&CH_ampl0(8)(1))+("00"&CH_ampl0(9)(1))+("00"&CH_ampl0(10)(1))+("00"&CH_ampl0(11)(1));
    tai20<=("00"&CH_ampl0(0)(2))+("00"&CH_ampl0(1)(2))+("00"&CH_ampl0(2)(2))+("00"&CH_ampl0(3)(2))+("00"&CH_ampl0(4)(2))+("00"&CH_ampl0(5)(2));
    tai21<=("00"&CH_ampl0(6)(2))+("00"&CH_ampl0(7)(2))+("00"&CH_ampl0(8)(2))+("00"&CH_ampl0(9)(2))+("00"&CH_ampl0(10)(2))+("00"&CH_ampl0(11)(2));

    else
    TT_mode<='0';
    end if;


if (mt_cou="010") then
     
   for i in 0 to 11 loop
CH_TIME1_T(i)<=CH_TIME_T(i);
CH_ampl(i)<=CH_ampl0(i)(12 downto 3);
end loop;

if (Trig_onA0='0') then tts_c<="0011"; tas_c<="0011";
  else tts_c<="0000";  tas_c<=ta0s(6 downto 3);
end if;
else 
for i in 0 to 11 loop
CH_TIME1_T(i)<=CH_TIME1_T(i)(9) & CH_TIME1_T(i)(9) & CH_TIME1_T(i)(9 downto 2);
CH_ampl(i)<=CH_ampl(i)(9) & CH_ampl(i)(9) & CH_ampl(i)(9 downto 2); 
end loop;

 tts_c<=tts(5 downto 2); tas_c<=tas(5 downto 2);    
end if;

end if;
end process;

Trig_on0 <=CH_trigt(0) or CH_trigt(1) or CH_trigt(2) or CH_trigt(3) or CH_trigt(4) or CH_trigt(5) or CH_trigt(6) or CH_trigt(7) or CH_trigt(8) or CH_trigt(9) or CH_trigt(10) or CH_trigt(11);

N1_chans<=("00"& CH_trigt(0)) + ("00"& CH_trigt(1))+ ("00"& CH_trigt(2))+ ("00"& CH_trigt(3))+("00"& CH_trigt(4)) + ("00"& CH_trigt(5));
N2_chans<= ("00"& CH_trigt(6)) + ("00"& CH_trigt(7)) + ("00"& CH_trigt(8)) + ("00"& CH_trigt(9))+ ("00"& CH_trigt(10))+ ("00"& CH_trigt(11));
N_chans<= x"D" when (Trig_on0='0') and (Trig_onA0='1') else ("0"& N1_chans) +("0"& N2_chans);

tts00<= ("00"&CH_TIME1_T(0)(0))+("00"&CH_TIME1_T(1)(0))+("00"&CH_TIME1_T(2)(0))+("00"&CH_TIME1_T(3)(0))+("00"&CH_TIME1_T(4)(0))+("00"&CH_TIME1_T(5)(0));
tts01<= ("00"&CH_TIME1_T(6)(0))+("00"&CH_TIME1_T(7)(0))+("00"&CH_TIME1_T(8)(0))+("00"&CH_TIME1_T(9)(0))+("00"&CH_TIME1_T(10)(0))+("00"&CH_TIME1_T(11)(0));
tts10<= ("00"&CH_TIME1_T(0)(1))+("00"&CH_TIME1_T(1)(1))+("00"&CH_TIME1_T(2)(1))+("00"&CH_TIME1_T(3)(1))+("00"&CH_TIME1_T(4)(1))+("00"&CH_TIME1_T(5)(1));
tts11<= ("00"&CH_TIME1_T(6)(1))+("00"&CH_TIME1_T(7)(1))+("00"&CH_TIME1_T(8)(1))+("00"&CH_TIME1_T(9)(1))+("00"&CH_TIME1_T(10)(1))+("00"&CH_TIME1_T(11)(1));

tas00<=("00"&CH_ampl(0)(0))+("00"&CH_ampl(1)(0))+("00"&CH_ampl(2)(0))+("00"&CH_ampl(3)(0))+("00"&CH_ampl(4)(0))+("00"&CH_ampl(5)(0));
tas01<=("00"&CH_ampl(6)(0))+("00"&CH_ampl(7)(0))+("00"&CH_ampl(8)(0))+("00"&CH_ampl(9)(0))+("00"&CH_ampl(10)(0))+("00"&CH_ampl(11)(0));
tas10<=("00"&CH_ampl(0)(1))+("00"&CH_ampl(1)(1))+("00"&CH_ampl(2)(1))+("00"&CH_ampl(3)(1))+("00"&CH_ampl(4)(1))+("00"&CH_ampl(5)(1));
tas11<=("00"&CH_ampl(6)(1))+("00"&CH_ampl(7)(1))+("00"&CH_ampl(8)(1))+("00"&CH_ampl(9)(1))+("00"&CH_ampl(10)(1))+("00"&CH_ampl(11)(1));


tts<= ("000"&tts00) + ("000"&tts01) + ("00"&tts10 &'0') + ("00"&tts11 & '0') + ("00"&tts_c);
tas<= ("000"&tas00) + ("000"&tas01) + ("00"&tas10 &'0') + ("00"&tas11 & '0') + ("00"&tas_c);
ta0s<= ("0000"&tai00) + ("0000"&tai01) + ("000"&tai10 &'0') + ("000"&tai11 & '0') + ("00"&tai20 &"00") + ("00"&tai21 & "00");

tt<= N_chans(1 downto 0) when (TT_mode='1')  else  tts(1 downto 0); 

ta<= N_chans(3 downto 2) when (TT_mode='1')  else  tas(1 downto 0);


end RTL;
