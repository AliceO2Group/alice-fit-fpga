----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/23/2019 04:23:56 PM
-- Design Name: 
-- Module Name: tsm_sc - RTL
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

entity cnt_ctrl is
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
end cnt_ctrl;

architecture RTL of cnt_ctrl is

signal c50ms : STD_LOGIC_VECTOR (20 downto 0);
signal cnt_md : STD_LOGIC_VECTOR (2 downto 0);
signal t100ms, t200ms, t1s, t2s, t10s, p, p0, p1  : STD_LOGIC;
signal t500ms, t5s : STD_LOGIC_VECTOR (2 downto 0);

begin

rdy<=cs;
DO(2 downto 0)<= cnt_md when (A=0) else "000";
DO(31 downto 3)<= (others=>'0');

with cnt_md select
 p<= t100ms when "001",
     t200ms when "010",
     t500ms(2) when "011",
     t1s when "100",
     t2s when "101",
     t5s(2) when "110",
     t10s when "111",
     '0' when others;
     
cnt_rd <='1' when (p1='0') and (p0='1') else '0';

process (CLK)
begin
if (CLK'event) and (CLK='1') then 

if (c50ms/=1562499) then c50ms <= c50ms+1; 
  else c50ms <= (others=>'0'); 
   t100ms<= not t100ms; 
  if  (t100ms='1') then t200ms <= not t200ms; if (t500ms/=4) then t500ms<=t500ms+1; 
   else t500ms<="000"; t1s<= not t1s;
    if  (t1s='1') then t2s <= not t2s; if (t5s/=4) then t5s<=t5s+1;
       else t5s<="000"; t10s<= not t10s;
       end if;
     end if; 
    end if;  
   end if;
end if;

if (rst='1') then cnt_md<="000"; 
  else
  if (wr='1') and (cs='1') and (A=0) then cnt_md<=DI(2 downto 0); end if;
end if;

p1<=p0; p0<=p;

end if;
end process;


end RTL;
