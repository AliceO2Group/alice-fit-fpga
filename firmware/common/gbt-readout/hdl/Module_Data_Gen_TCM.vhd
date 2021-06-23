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
		Board_data_O		: out board_data_type;
		data_gen_report_O   : out std_logic_vector(31 downto 0)
	 );
end Module_Data_Gen;

architecture Behavioral of Module_Data_Gen is

	signal Board_data_gen_ff, Board_data_gen_ff_next, Board_data_in_ff 	: board_data_type;
	signal Board_data_header, Board_data_data, Board_data_void	: board_data_type;

	
	signal Trigger_from_CRU_40ff, Trigger_from_CRU_320ff			: std_logic_vector(Trigger_bitdepth-1 downto 0); -- Trigger ID from CRUS

	
	signal trigger_resp_mask : std_logic_vector(Trigger_bitdepth-1 downto 0);
	signal bunch_pattern : std_logic_vector(31 downto 0);
	signal bunch_freq, bunch_freq_ff01 : std_logic_vector(15 downto 0);
	signal bunch_freq_hboffset : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal reset_offset : std_logic;
	
	type n_words_in_packet_arr_type is array (0 to 8) of std_logic_vector(3 downto 0);
    signal n_words_in_packet_mask : n_words_in_packet_arr_type;
	signal n_words_in_packet_send, n_words_in_packet_send_next : std_logic_vector(3 downto 0);
	signal n_words_in_packet_send_tcm : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
	
	type FSM_STATE_T is (s0_wait, s1_header, s2_data);
	signal FSM_STATE, FSM_STATE_NEXT  : FSM_STATE_T;

	signal is_packet_send_for_cntr, is_packet_send_for_cntr_ff, is_packet_send_for_cntr_next : std_logic;
	signal bfreq_counter, bfreq_counter_next : std_logic_vector(15 downto 0);
	signal is_boffset_sync, is_boffset_sync_next : std_logic;
	signal bpattern_counter, bpattern_counter_next : integer := 0;
	signal cnt_packet_counter, cnt_packet_counter_next : std_logic_vector(data_word_bitdepth/2-1 downto 0); -- continious packet counter
	signal pword_counter, pword_counter_next : std_logic_vector(3 downto 0);
	
	signal data_gen_report : std_logic_vector(31 downto 0); -- used only in simulation
	
	
	
	
	attribute keep : string;	
	attribute keep of Board_data_gen_ff : signal is "true";

	
begin
	trigger_resp_mask <= Control_register_I.Data_Gen.trigger_resp_mask;
	bunch_pattern <=Control_register_I.Data_Gen.bunch_pattern;
	bunch_freq <= Control_register_I.Data_Gen.bunch_freq;
	bunch_freq_hboffset <= Control_register_I.Data_Gen.bunch_freq_hboffset;
	
	n_words_in_packet_send_tcm <= x"0" & n_words_in_packet_send(2 downto 0) & "1";



    data_gen_report_O <= data_gen_report;
    data_gen_report <= x"0000_000" & n_words_in_packet_mask(bpattern_counter);

-- ***************************************************
	Board_data_O <= Board_data_gen_ff 	WHEN (Control_register_I.Data_Gen.usage_generator = use_MAIN_generator)	 ELSE Board_data_in_ff;
	
    Board_data_header.data_word <= func_FITDATAHD_get_header(n_words_in_packet_send_tcm, FIT_GBT_status_I.ORBIT_from_CRU_corrected,
	FIT_GBT_status_I.BCID_from_CRU_corrected, FIT_GBT_status_I.rx_phase, FIT_GBT_status_I.GBT_status.Rx_Phase_error, '1') & cnt_packet_counter;
--    Board_data_header.data_word <= (others => '0');
	Board_data_header.is_header <= '1';
	Board_data_header.is_data <= '1';
--	Board_data_header.is_packet <= '1';
	
	Board_data_data.data_word <= cnt_packet_counter & cnt_packet_counter;
	Board_data_data.is_header <= '0';
	Board_data_data.is_data <= '1';
--	Board_data_data.is_packet <= '1';
	
	Board_data_void.data_word <= (others => '0');
	Board_data_void.is_header <= '0';
	Board_data_void.is_data <= '0';
--	Board_data_void.is_packet <= '0';
	
		
	n_words_in_packet_mask(0) <= bunch_pattern(3 downto 0);
	n_words_in_packet_mask(1) <= bunch_pattern(7 downto 4);
	n_words_in_packet_mask(2) <= bunch_pattern(11 downto 8);
	n_words_in_packet_mask(3) <= bunch_pattern(15 downto 12);
	n_words_in_packet_mask(4) <= bunch_pattern(19 downto 16);
	n_words_in_packet_mask(5) <= bunch_pattern(23 downto 20);
	n_words_in_packet_mask(6) <= bunch_pattern(27 downto 24);
	n_words_in_packet_mask(7) <= bunch_pattern(31 downto 28);
	n_words_in_packet_mask(8) <= (others => '0');
-- ***************************************************



-- Data ff data clk **********************************
	process (FSM_Clocks_I.Data_Clk)
	begin


		IF(rising_edge(FSM_Clocks_I.Data_Clk) )THEN
			IF (FSM_Clocks_I.Reset_dclk = '1') THEN
				
				bfreq_counter			<= (others => '0');
				bpattern_counter		<= 0;
				is_boffset_sync 		<= '0';
				Trigger_from_CRU_40ff <=  (others => '0');
			ELSE

				bfreq_counter		<= bfreq_counter_next;
				bpattern_counter	<= bpattern_counter_next;
				is_boffset_sync 	<= is_boffset_sync_next;
				
				bunch_freq_ff01 <= bunch_freq;
				
				Trigger_from_CRU_40ff <= FIT_GBT_status_I.Trigger_from_CRU;
			END IF;
		END IF;
		
	end process;
-- ***************************************************


-- Data ff system clk **********************************
	process (FSM_Clocks_I.System_Clk)
	begin

		IF(rising_edge(FSM_Clocks_I.System_Clk) )THEN
			IF (FSM_Clocks_I.Reset_sclk = '1') THEN
				Board_data_in_ff	<= Board_data_void;
				Board_data_gen_ff	<= Board_data_void;
				
				FSM_STATE		<= s0_wait;
				pword_counter <= (others => '0');
				n_words_in_packet_send <= (others => '0');
				
				is_packet_send_for_cntr <= '0';
				is_packet_send_for_cntr_ff <= '0';
				cnt_packet_counter		<= (others => '0');
				Trigger_from_CRU_320ff	<= (others => '0');
			ELSE
				Board_data_in_ff <= Board_data_I;
				Board_data_gen_ff	<= Board_data_gen_ff_next;
			
				FSM_STATE <= FSM_STATE_NEXT;
				pword_counter <= pword_counter_next;
				n_words_in_packet_send <= n_words_in_packet_send_next;
				
				is_packet_send_for_cntr <= is_packet_send_for_cntr_next;
				is_packet_send_for_cntr_ff <= is_packet_send_for_cntr;
				cnt_packet_counter	<= cnt_packet_counter_next;
				
				Trigger_from_CRU_320ff <= Trigger_from_CRU_40ff;
			END IF;
		END IF;
		
	end process;
-- ***************************************************





-- ***************************************************



---------- Counters ---------------------------------
reset_offset <= Control_register_I.reset_gen_offset;
-- reset_offset <= '1' WHEN (FSM_Clocks_I.Reset = '1') ELSE
				-- '1' WHEN (bunch_freq /= bunch_freq_ff01) ELSE
				-- '0';


cnt_packet_counter_next <= 	(others => '0') WHEN (FSM_Clocks_I.Reset_sclk = '1') ELSE
							cnt_packet_counter + 1	WHEN (is_packet_send_for_cntr = '1') and (is_packet_send_for_cntr_ff = '0') ELSE
							cnt_packet_counter;

bfreq_counter_next <= 	(others => '0') 		WHEN (FSM_Clocks_I.Reset_dclk = '1') ELSE
						(others => '0') 		WHEN (bfreq_counter = bunch_freq-1) ELSE
						(others => '0') 		WHEN (bunch_freq = 0) ELSE
						(others => '0') 		WHEN (is_boffset_sync = '0') ELSE
						x"0001"			 		WHEN (FIT_GBT_status_I.BCID_from_CRU_corrected = bunch_freq_hboffset) and (FIT_GBT_status_I.BCIDsync_Mode = mode_SYNC) and (is_boffset_sync = '0') ELSE
						bfreq_counter + 1;

is_boffset_sync_next <= '0' WHEN (FSM_Clocks_I.Reset_dclk = '1') ELSE
						'0' WHEN (reset_offset = '1') ELSE
						'1' WHEN (is_boffset_sync = '0') and (FIT_GBT_status_I.BCID_from_CRU_corrected = bunch_freq_hboffset) and (FIT_GBT_status_I.BCIDsync_Mode = mode_SYNC) ELSE
						is_boffset_sync;
						
bpattern_counter_next <= 	0 		WHEN (FSM_Clocks_I.Reset_dclk = '1') ELSE
							0		WHEN (bfreq_counter = bunch_freq-1) ELSE
							8 		WHEN (is_boffset_sync = '0') ELSE
							8 		WHEN (bpattern_counter = 8) ELSE
							bpattern_counter + 1;

							
							
pword_counter_next <= 	(others => '0') WHEN (FSM_Clocks_I.Reset_sclk = '1') ELSE
						(others => '0')	WHEN (FSM_STATE = s0_wait) ELSE
						(others => '0')	WHEN (FSM_STATE = s1_header) ELSE
						pword_counter + 1;

											

FSM_STATE_NEXT <= 	s0_wait		WHEN (FSM_Clocks_I.Reset_sclk = '1') ELSE	
					s1_header	WHEN (FSM_STATE = s0_wait) and (FSM_Clocks_I.System_Counter = x"0") and (n_words_in_packet_mask(bpattern_counter)  > 0) ELSE
					s1_header	WHEN (FSM_STATE = s0_wait) and (FSM_Clocks_I.System_Counter = x"0") and ((Trigger_from_CRU_320ff and trigger_resp_mask) > 0) ELSE
					s2_data		WHEN (FSM_STATE = s1_header) ELSE
					s2_data		WHEN (FSM_STATE = s2_data) and (n_words_in_packet_send > pword_counter_next) ELSE
					s0_wait		WHEN (FSM_STATE = s2_data) and (n_words_in_packet_send = pword_counter_next) ELSE
					s0_wait;
						
is_packet_send_for_cntr_next <=  '0' WHEN (FSM_Clocks_I.Reset_sclk = '1') ELSE
                                '1' WHEN (FSM_STATE = s2_data) and (FSM_STATE_NEXT = s0_wait) ELSE
                                '0' WHEN (FSM_Clocks_I.System_Counter = x"0")  ELSE
                                is_packet_send_for_cntr;
						
n_words_in_packet_send_next <= 	(others => '0')         					WHEN (FSM_Clocks_I.Reset_sclk = '1') ELSE
								n_words_in_packet_mask(0) 					WHEN (FSM_STATE = s0_wait) and (FSM_STATE_NEXT = s1_header) and ((Trigger_from_CRU_320ff and trigger_resp_mask) > 0) ELSE
								n_words_in_packet_mask(bpattern_counter) 	WHEN (FSM_STATE = s0_wait) and (FSM_STATE_NEXT = s1_header) ELSE
								n_words_in_packet_send;



---------- Board data gen ---------------------------
Board_data_gen_ff_next <=	Board_data_void 	WHEN (FSM_Clocks_I.Reset_sclk = '1') ELSE
							Board_data_void 	WHEN (FSM_STATE = s0_wait) ELSE
							Board_data_header 	WHEN (FSM_STATE = s1_header) ELSE
							Board_data_data 	WHEN (FSM_STATE = s2_data) ELSE
							Board_data_void;
-- ***************************************************

end Behavioral;

