----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2020 12:39:12 AM
-- Design Name: 
-- Module Name: counter32 - RTL
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter32 is
 Port (clk320 : in STD_LOGIC;
       cout : out STD_LOGIC_VECTOR (31 downto 0);
       rd : in STD_LOGIC;
       clr : in STD_LOGIC;
       inc : in STD_LOGIC
       );
end counter32;

architecture RTL of counter32 is

signal count :  STD_LOGIC_VECTOR (31 downto 0);

begin


process (clk320)
begin
if (clk320'event) and (clk320='1') then

if (rd='1') then cout<=count; end if;  

if (clr='1') then count<=(others=>'0'); 
  else  if (inc='1') then count<=count+1; end if;
end if;

end if;
end process;

end RTL;
