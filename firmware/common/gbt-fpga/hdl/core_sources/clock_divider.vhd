----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2016 10:53:52
-- Design Name: 
-- Module Name: gbt_rx_frameclk_phalgnr - Behavioral
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

entity gbt_rx_frameclk_phalgnr is
   Generic (
		WORDCLK_FREQ											: integer
   );
   port ( 
      
      --=======--
      -- Reset --
      --=======-- 
      RESET_I                                   : in  std_logic;
      
      --===============--
      -- Clocks scheme --
      --===============--
      RX_WORDCLK                                : in  std_logic;     
      RX_FRAMECLK_O                             : out std_logic;   -- Comment: Phase aligned 40MHz output. 
      
		--===========--
		-- Control   --
		--===========--
		
		SYNC_I	   										: in std_logic;
		
      --=========--
      -- Status  --
      --=========--
      PLL_LOCKED_O                              : out std_logic
      
   );
end gbt_rx_frameclk_phalgnr;

architecture Behavioral of gbt_rx_frameclk_phalgnr is

    signal count: integer:=0;
	 signal tmp : std_logic := '1';
	 
begin

	clockengen_proc: process(RX_WORDCLK, RESET_I)
	begin
	
		if(RESET_I='1') then
			count<=0;
			tmp<='1';
			PLL_LOCKED_O <= '0';
			
		elsif rising_edge(RX_WORDCLK) then
		
			PLL_LOCKED_O <= '1';
			count <= count+1;
		
			if (count = 2) then
				tmp <= NOT tmp;
				count <= 0;
			end if;
		end if;
	
		RX_FRAMECLK_O <= tmp;
	end process;

end Behavioral;
