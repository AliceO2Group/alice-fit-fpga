----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:43 06/06/2017 
-- Design Name: 
-- Module Name:    pin_capt - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity pin_capt is
    Port ( pin_in : in  STD_LOGIC;
           pin_out : out  STD_LOGIC;
           clk600 : in  STD_LOGIC;
           clk600_90 : in  STD_LOGIC;
			  clk300 : in  STD_LOGIC;
           str : out  STD_LOGIC;
           ptime : out  STD_LOGIC_VECTOR (2 downto 0));
end pin_capt;

architecture RTL of pin_capt is

signal ISER_BITS : STD_LOGIC_VECTOR (3 downto 0);
signal ISER_BITS1, ISER_COUL : STD_LOGIC_VECTOR (2 downto 0);
signal ISER_COU : STD_LOGIC_VECTOR (1 downto 0);
signal clk600B, clk600B_90, PC_STR,  clk300t, clk300t1, clk300t2 : STD_LOGIC;


begin


clk600B<=not clk600; clk600B_90<=not clk600_90;

ISERDES_1 : ISERDESE2
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
   port map ( O => pin_out, Q1 => ISER_BITS(3), Q2 => ISER_BITS(1), Q3 => ISER_BITS(2),Q4 => ISER_BITS(0),
      Q5 => open, Q6 => open, Q7 => open, Q8 => open, SHIFTOUT1 => open, SHIFTOUT2 => open, BITSLIP => '0',
      CE1 => '1', CE2 => '1', CLKDIVP => '0',
		CLK => CLK600, CLKB => CLK600B,
      CLKDIV => '0',
      OCLK => CLK600_90, OCLKB => CLK600B_90, 
      DYNCLKDIVSEL => '0',  DYNCLKSEL => '0',
      D => pin_in,
      DDLY => '0',  OFB => '0',             
      RST => '0', 
      SHIFTIN1 => '0',  SHIFTIN2 => '0' 
   );
process(clk300)
begin

if (clk300'event and clk300='1') then  clk300t<=not clk300t; end if;

end process;

str<=PC_STR;

process(clk600)
begin

if (clk600'event and clk600='1') then  

ISER_BITS1<=ISER_COUL; clk300t2<=clk300t1; clk300t1<=clk300t; 
if (clk300t1/=clk300t2)  then 
		PC_STR<=ISER_BITS(0); 
		if (PC_STR='0') and (ISER_BITS(0)='1') then ptime(2)<=ISER_BITS1(2); ptime(1 downto 0)<= ISER_COU; end if; 
end if;

end if;
end process;


ISER_COUL(2)<=NOT (ISER_BITS(3) OR ISER_BITS(2) OR ISER_BITS(1) OR ISER_BITS(0));
ISER_COUL(1)<=NOT (ISER_BITS(3) OR ISER_BITS(2));
ISER_COUL(0)<=NOT ISER_BITS(3) AND (ISER_BITS(2) OR NOT ISER_BITS(1));
				 
ISER_COU(1)<= (ISER_BITS1(1) AND not ISER_BITS1(2)) or (ISER_COUL(1) AND ISER_BITS1(2)); 
ISER_COU(0)<= (ISER_BITS1(0) AND not ISER_BITS1(2)) or (ISER_COUL(0) AND ISER_BITS1(2));

end RTL;

