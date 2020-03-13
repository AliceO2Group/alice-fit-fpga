----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    09/11/2017 
-- Design Name: 
-- Module Name:    RXDATA_CLKSync - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fit_gbt_common_package.all;
use ieee.std_logic_unsigned.all ;

entity PLL_Reset_Generator is
    Port ( 
		GRESET_I 		: in STD_LOGIC;
		GDataClk_I 		: in  STD_LOGIC;
		PLL_ready_I		: in  STD_LOGIC;
		
		RESET_O 		: out std_logic
		);
end PLL_Reset_Generator;

architecture Behavioral of PLL_Reset_Generator is

	signal delay_cntr, delay_cntr_next : std_logic_vector(3 downto 0);
	
	signal pll_ready_ff0, pll_ready_ff1 : std_logic;
	signal out_reset, out_reset_ff, out_reset_next : std_logic;

	attribute keep : string;	
	attribute keep of delay_cntr : signal is "true";
	attribute keep of pll_ready_ff0 : signal is "true";
	attribute keep of pll_ready_ff1 : signal is "true";
	attribute keep of out_reset_ff : signal is "true";
	
begin

RESET_O <= out_reset_ff;


-- Data clk ***********************************
	PROCESS (GDataClk_I)
	BEGIN
		IF rising_edge(GDataClk_I)THEN
			IF(GRESET_I = '1') THEN
			
				delay_cntr <= (others => '0');
				pll_ready_ff0 <= '0';
				pll_ready_ff1 <= '0';
				
				out_reset <= '1';
				out_reset_ff <= '1';
			
			ELSE
			
				delay_cntr <= delay_cntr_next;
				pll_ready_ff0 <= PLL_ready_I;
				pll_ready_ff1 <= pll_ready_ff0;
				
				out_reset <= out_reset_next;
				out_reset_ff <= out_reset;
				
			END IF;
		END IF;
	END PROCESS;
-- ********************************************



-- FSM ***********************************************
delay_cntr_next <= 	x"0"	WHEN (GRESET_I = '1') ELSE
					x"0"	WHEN (pll_ready_ff0 = '1') and (pll_ready_ff1 = '0') ELSE
					x"f"	WHEN (delay_cntr = x"f") ELSE	
					delay_cntr+1;

out_reset_next <= 	'1' WHEN (GRESET_I = '1') ELSE
					'0' WHEN delay_cntr = x"f" ELSE
					out_reset;
end Behavioral;

