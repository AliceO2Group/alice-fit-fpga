----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    07/11/2017 
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all ;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;

entity Module_Data_Gen is
    Port ( 
		FSM_Clocks_I 		: in FSM_Clocks_type;
		
		FIT_GBT_status_I	: in FIT_GBT_status_type;
		Control_register_I	: in CONTROL_REGISTER_type;
		
		Board_data_I		: in board_data_type;
		Board_data_O		: out board_data_type
	 );
end Module_Data_Gen;

architecture Behavioral of Module_Data_Gen is

	signal Board_data_gen_ff, Board_data_gen_ff_next	: board_data_type;
	signal Board_data_header, Board_data_data, Board_data_void	: board_data_type;

	signal gen_counter_ff, gen_counter_ff_next : std_logic_vector(GEN_count_bitdepth-1 downto 0); -- gen counter 0 to n_cycle_data
	signal packets_counter_ff, packets_counter_ff_next : std_logic_vector(GEN_count_bitdepth-1 downto 0); -- continious packet counter
	signal channel_counter_ff, channel_counter_ff_next, channel_counter2_signal : std_logic_vector(7 downto 0); -- channel counter
	signal channel_n_words : std_logic_vector(GEN_count_bitdepth-1 downto 0);
	

begin


-- ***************************************************
	Board_data_O <= Board_data_gen_ff 	WHEN (Control_register_I.Data_Gen.usage_generator = use_MAIN_generator)	 ELSE Board_data_I;
	
    Board_data_header.data_word <= x"F" & channel_n_words(3 downto 0) & x"000_0000" & FIT_GBT_status_I.ORBIT_from_CRU  & FIT_GBT_status_I.BCID_from_CRU;
	Board_data_header.is_data <= '1';
	
	Board_data_data.data_word <= '0' & channel_counter_ff(2 downto 0) & x"0000_0" & packets_counter_ff	& '0' &	channel_counter2_signal(2 downto 0) & x"0000_0" & packets_counter_ff;
	Board_data_data.is_data <= '1';
	
	Board_data_void.data_word <= (others => '0');
	Board_data_void.is_data <= '0';
	
	channel_counter2_signal <= channel_counter_ff + 1;
	channel_n_words <= Control_register_I.Data_Gen.n_cycle_data - Control_register_I.Data_Gen.n_cycle_void - 1;
-- ***************************************************




-- Data ff data clk **********************************
	process (FSM_Clocks_I.Data_Clk)
	begin

		IF(rising_edge(FSM_Clocks_I.Data_Clk) )THEN
			IF (FSM_Clocks_I.Reset = '1') THEN
				Board_data_gen_ff	<= Board_data_void;
				
				gen_counter_ff		<= (others => '0');
				packets_counter_ff		<= (others => '0');
				channel_counter_ff		<= (others => '0');
			ELSE
				Board_data_gen_ff	<= Board_data_gen_ff_next;

				gen_counter_ff		<= gen_counter_ff_next;
				packets_counter_ff	<= packets_counter_ff_next;
				channel_counter_ff	<= channel_counter_ff_next;
			END IF;
		END IF;
		
	end process;
-- ***************************************************



-- ***************************************************



---------- Counters ---------------------------------
packets_counter_ff_next <= (others => '0') 		WHEN (FSM_Clocks_I.Reset = '1') ELSE
						(others => '0') 		WHEN (packets_counter_ff = GEN_const_full) ELSE
						packets_counter_ff + 1 	WHEN (gen_counter_ff = Control_register_I.Data_Gen.n_cycle_void) ELSE
						packets_counter_ff;
						
gen_counter_ff_next <= 	(others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
						(others => '0')	WHEN (gen_counter_ff = Control_register_I.Data_Gen.n_cycle_data) ELSE
						gen_counter_ff + 1;
						
channel_counter_ff_next <= 	(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
						(others => '0')			WHEN (gen_counter_ff <= Control_register_I.Data_Gen.n_cycle_void) ELSE
						channel_counter_ff + x"02"	WHEN (gen_counter_ff < Control_register_I.Data_Gen.n_cycle_data) ELSE
						(others => '0');
						
						
						

---------- Board data gen ---------------------------
Board_data_gen_ff_next <=	Board_data_void WHEN (FSM_Clocks_I.Reset = '1') ELSE
							Board_data_void WHEN (gen_counter_ff < Control_register_I.Data_Gen.n_cycle_void) ELSE
							Board_data_header WHEN (gen_counter_ff = Control_register_I.Data_Gen.n_cycle_void) ELSE
							Board_data_data WHEN (gen_counter_ff < Control_register_I.Data_Gen.n_cycle_data) ELSE
							Board_data_void;
-- ***************************************************

end Behavioral;

