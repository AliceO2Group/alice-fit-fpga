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
		SysClk_I 		: in  STD_LOGIC;
		DataClk_I 		: in  STD_LOGIC;
		SysClk_count_O	: out std_logic_vector(3 downto 0);
		Counter_ready_O : out  STD_LOGIC
		);
end DataCLK_strobe;

architecture Behavioral of DataCLK_strobe is

	signal DataClk_q_dataclk : std_logic;
	signal DataClk_qff00_sysclk : std_logic;
	signal DataClk_qff01_sysclk : std_logic;
	signal DataClk_qff02_sysclk : std_logic;
	signal DataClk_front_sysclk : std_logic;

	signal count_ready, count_ready_next : std_logic;
	signal count_ready_dtclk_ff : std_logic;
	signal sysclk_count_ff, sysclk_count_ff_next : std_logic_vector(3 downto 0);
begin
Counter_ready_O <= count_ready_dtclk_ff;
SysClk_count_O <= sysclk_count_ff WHEN (count_ready = '1') ELSE x"0";

-- Data clk *********************************
PROCESS(DataClk_I)
BEGIN
	IF rising_edge(DataClk_I)THEN
		
		IF(RESET_I = '1')THEN
			count_ready_dtclk_ff <= '0';
			DataClk_q_dataclk <= '0';
		ELSE
			count_ready_dtclk_ff <= count_ready;
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
			sysclk_count_ff <= x"0";
			
			DataClk_qff00_sysclk <= '0';
			DataClk_qff01_sysclk <= '0';
			DataClk_qff02_sysclk <= '0';
		ELSE
			count_ready <= count_ready_next;
			sysclk_count_ff <= sysclk_count_ff_next;
			
			DataClk_qff00_sysclk <= DataClk_q_dataclk;
			DataClk_qff01_sysclk <= DataClk_qff00_sysclk;
			DataClk_qff02_sysclk <= DataClk_qff01_sysclk;
		END IF;
		
	END IF;
END PROCESS;
-- ***************************************************

-- FSM ***********************************************
DataClk_front_sysclk <= DataClk_qff01_sysclk xor DataClk_qff02_sysclk;


--sysclk_count_ff_next <=	x"0" 	WHEN (RESET_I = '1') ELSE
--					x"3"	WHEN (count_ready = '0') and (DataClk_front_sysclk = '1') ELSE
--					x"0" 	WHEN (sysclk_count_ff = x"7") and (count_ready = '1') ELSE
--					sysclk_count_ff + 1 WHEN (count_ready = '1') ELSE
--					x"0";

sysclk_count_ff_next <=	x"0" 	WHEN (RESET_I = '1') ELSE
                    x"0"    WHEN (count_ready_dtclk_ff = '0') ELSE
					x"3"	WHEN (DataClk_front_sysclk = '1') ELSE
					x"0" 	WHEN (sysclk_count_ff = x"7") ELSE
					sysclk_count_ff + 1;

count_ready_next <=	'0' 	WHEN (RESET_I = '1') ELSE
					'1'		WHEN (count_ready = '0') and (DataClk_front_sysclk = '1') ELSE
					'1' 	WHEN (count_ready = '1') ELSE
					'0';

 







end Behavioral;

