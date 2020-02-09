----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/18/2018 09:46:20 PM
-- Design Name: 
-- Module Name: counters - RTL
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

entity counters is
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
           hrd_en : in STD_LOGIC);
end counters;

architecture RTL of counters is

type count_arr is array (0 to 23) of STD_LOGIC_VECTOR (31 downto 0);
type count_buf is array (0 to 47) of STD_LOGIC_VECTOR (15 downto 0);

signal counters : count_arr;
signal trig_0 : STD_LOGIC_VECTOR (11 downto 0);
signal rd_en0, rd_en1, rd_en2, hrd_en0, hrd_en1, hrd_en2, hl_n : STD_LOGIC;

signal rd_vector, hrd_vector : count_buf;

begin

hl_n<=not hl;

process (clk)
begin
if (clk'event and clk='1') then

rd_en2<=rd_en1; rd_en1<=rd_en0; rd_en0<=rd_en; hrd_en2<=hrd_en1; hrd_en1<=hrd_en0; hrd_en0<=hrd_en;  

for i in 0 to 11 loop 
trig_0(i)<=trig(i);
end loop;

if (reset='1') then 
 for i in 0 to 23 loop 
 counters(i)<=x"00000000";
 end loop;
else

for i in 0 to 11 loop 
if (evnt(i)='1') then counters(2*i)<=counters(2*i)+1; end if;
if (trig(i)='1') and (trig_0(i)='0') then counters(2*i+1)<=counters(2*i+1)+1; end if;
end loop;
end if;

if (rd_en2='0') and (rd_en1='1') then 
for i in 0 to 23 loop 
rd_vector(i*2)<=counters(i)(15 downto 0);
rd_vector(i*2+1)<=counters(i)(31 downto 16);
end loop;
end if;

if (hrd_en2='0') and (hrd_en1='1') then 
for i in 0 to 23 loop 
hrd_vector(i*2)<=counters(i)(15 downto 0);
hrd_vector(i*2+1)<=counters(i)(31 downto 16);
end loop;
end if;

end if;
end process;

dout <= rd_vector(to_integer(unsigned(raddr))) when (raddr<"110000") else x"0000";
hdout <= hrd_vector(to_integer(unsigned(hraddr & hl_n))) when (hraddr<"11000") else x"0000"; 

end RTL;
