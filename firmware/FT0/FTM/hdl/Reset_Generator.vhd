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

entity Reset_Generator is
    Port ( 
		RESET_I 		: in STD_LOGIC;
		SysClk_I 		: in  STD_LOGIC;
		DataClk_I 		: in  STD_LOGIC;
		Sys_Cntr_ready_I: in  STD_LOGIC;
		
		Reset_DClk_O	: out std_logic;
		General_reset_O : out std_logic
		);
end Reset_Generator;

architecture Behavioral of Reset_Generator is

	signal GenRes_DataClk_ff, GenRes_DataClk_ff1, GenRes_DataClk_ff_next :std_logic;
	signal General_reset_ff, General_reset_ff_next : std_logic;
	signal Cntr_reset_ff, Cntr_reset_ff1, Cntr_reset_ff_next : std_logic;

	attribute keep : string;	
	attribute keep of GenRes_DataClk_ff1 : signal is "true";
	
begin

Reset_DClk_O <= Cntr_reset_ff1;
General_reset_O <= GenRes_DataClk_ff1;


-- Sys clk ***********************************
	PROCESS (DataClk_I, RESET_I)
	BEGIN
	IF(RESET_I = '1') THEN
        GenRes_DataClk_ff <= '1';
        General_reset_ff <= '1';
        Cntr_reset_ff <= '1';
        GenRes_DataClk_ff1 <= '1';
        Cntr_reset_ff1 <= '1';
      else  
      IF rising_edge(DataClk_I)THEN
				GenRes_DataClk_ff <= GenRes_DataClk_ff_next;
				General_reset_ff <= General_reset_ff_next;
				Cntr_reset_ff <= Cntr_reset_ff_next;
				
				Cntr_reset_ff1 <= Cntr_reset_ff;
				GenRes_DataClk_ff1 <= GenRes_DataClk_ff;
			END IF;
    END IF;
	END PROCESS;
-- ********************************************

-- FSM ***********************************************
GenRes_DataClk_ff_next <= General_reset_ff;
	
Cntr_reset_ff_next <=	'0';
						
General_reset_ff_next <= 	'1' WHEN (General_reset_ff = '1') and (Sys_Cntr_ready_I = '0') ELSE
							'0';


end Behavioral;

