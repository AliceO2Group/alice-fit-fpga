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

entity DataCLK_strobe is
    Port ( 
		RESET_I 		: in STD_LOGIC;
		RESET40_I 		: in STD_LOGIC;
		SysClk_I 		: in  STD_LOGIC;
		DataClk_I 		: in  STD_LOGIC;
		SysClk_count_O	: out std_logic_vector(3 downto 0);
		Counter_ready_O : out  STD_LOGIC
		);
end DataCLK_strobe;

architecture Behavioral of DataCLK_strobe is

	signal DataClk_q_dataclk : std_logic := '0';
	signal DataClk_qff00_sysclk : std_logic;
	signal DataClk_front_sysclk : std_logic;

	signal count_ready : std_logic;
	signal sysclk_count_ff : std_logic_vector(2 downto 0);
begin
 
 SysClk_count_O <= '0' & sysclk_count_ff;

-- Data clk *********************************
PROCESS(DataClk_I)
BEGIN
	IF rising_edge(DataClk_I)THEN
		
		IF(RESET40_I = '1')THEN
			Counter_ready_O <= '0';
		ELSE
			Counter_ready_O <= count_ready;
			DataClk_q_dataclk <= not DataClk_q_dataclk;
		END IF;
		
	END IF;
END PROCESS;
-- ***************************************************


-- Clock clk *********************************
PROCESS(SysClk_I)
BEGIN
	IF rising_edge(SysClk_I)THEN
		
		IF(RESET_I = '1')THEN
			count_ready <= '0';
			
		ELSE
			DataClk_qff00_sysclk <= DataClk_q_dataclk;
			
			if (DataClk_front_sysclk='1') then sysclk_count_ff <= "001"; count_ready <='1';
			 else sysclk_count_ff <= sysclk_count_ff+1;
			end if;
			
		END IF;
		
	END IF;
END PROCESS;
-- ***************************************************

-- FSM ***********************************************
DataClk_front_sysclk <= DataClk_q_dataclk xor DataClk_qff00_sysclk;



end Behavioral;

