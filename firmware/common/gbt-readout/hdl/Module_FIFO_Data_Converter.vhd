----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:42:21 04/12/2017 
-- Design Name: 
-- Module Name:    Test_Generator - Behavioral 
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
use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity Module_FIFO_Data_Converter is
    Port ( 
		FSM_Clocks_I : in FSM_Clocks_type;
		
		FIT_GBT_status_I : in FIT_GBT_status_type;
		Control_register_I : in CONTROL_REGISTER_type;
		
		MODULE_data_I : in module_data_type;
		FIFO_is_space_for_packet_I : in boolean;
		
		FIFO_WE_O : out STD_LOGIC;
		FIFO_data_word_O : out std_logic_vector(fifo_data_bitdepth-1 downto 0)
	 );
end Module_FIFO_Data_Converter;

architecture Behavioral of Module_FIFO_Data_Converter is
		
	type FSM_STATE_T is (s1_head, s2_word);
	signal FSM_STATE, FSM_STATE_NEXT  : FSM_STATE_T;
	signal Is_First_word, Is_First_word_next : boolean;
	
	signal N_Words_In_packet : std_logic_vector(tdwords_bitdepth-1 downto 0);
	signal FIFO_data_word : std_logic_vector(fifo_word_bitdeph-1 downto 0);
	signal FIFO_header_word : std_logic_vector(fifo_header_bitdepth-1 downto 0);

	signal FIFO_data_word_ff, FIFO_data_word_ff_next : std_logic_vector(fifo_data_bitdepth-1 downto 0);
	signal FIFO_WE_ff, FIFO_WE_ff_next  : STD_LOGIC;
	signal MODULE_data_I_ff, MODULE_data_I_ff_next : module_data_type;


	signal Data_Strobe_zero				: std_logic_vector(0 to total_data_words-1);
	signal Data_Strobe_input			: std_logic_vector(0 to total_data_words-1);
	signal Data_Strobe_to_sel			: std_logic_vector(0 to total_data_words-1);
	signal Data_Strobe_next_from_sel	: std_logic_vector(0 to total_data_words-1);
	
	signal Data_Strobe			: std_logic_vector(0 to total_data_words-1);

	signal Is_input_data_void : boolean;
	signal Is_strobe_data_void : boolean;
	signal Is_strobe_data_void_from_sel : boolean;
	
	signal First_n_words_from_strobe : words_to_write_type;
	signal First_n_words : words_to_write_type;

begin

	FIFO_data_word_O <= FIFO_data_word_ff;
	FIFO_WE_O <= FIFO_WE_ff;

	Data_Strobe_zero <= (others => '0');

	FIFO_header_word(event_id_bitdepth-1 downto 0) <= MODULE_data_I_ff.EVENT_ID;
	FIFO_header_word(event_id_bitdepth+rx_phase_bitdepth-1 downto event_id_bitdepth) <= MODULE_data_I_ff.rx_phase;
	FIFO_header_word(fifo_header_bitdepth-1 downto event_id_bitdepth+rx_phase_bitdepth) <= N_Words_In_packet;

	MODULE_data_I_ff_next <= MODULE_data_I;
	
-- Module Data Strobe ======================================
	Module_Data_Strobe_comp: entity work.Module_Data_Strobe
	port map ( 
		MODULE_data_I => MODULE_data_I_ff,
		
		Module_Data_Strobe_O => Data_Strobe_input,
		N_Words_In_packet_O => N_Words_In_packet,
		Is_Module_data_void_O => Is_input_data_void
	);
-- ===========================================================

-- Module Data Selector ======================================
	Module_Data_Selector_comp: entity work.Module_Data_Selector
	port map ( 
		Data_Strobe_I => Data_Strobe_to_sel,
		
		Data_Strobe_next_O => Data_Strobe_next_from_sel,
		First_n_words_O => First_n_words_from_strobe,
		Is_strobe_data_void_O => Is_strobe_data_void_from_sel
	);
-- ===========================================================

-- -- Module Data first n words by strobe =======================
	-- Module_Data_strobe_first_n_words_comp: entity work.Module_Data_strobe_first_n_words
	-- port map ( 
		-- Data_Strobe_I => Data_Strobe_to_sel,
		
		-- first_n_words_O => First_n_words_from_strobe
	-- );
-- -- ===========================================================

-- Module form FIFO Data  ====================================
	Module_Data_Form_FIFO_Word_comp: entity work.Module_Data_Form_FIFO_Word
	port map ( 
	MODULE_data_I => MODULE_data_I_ff,
	Words_to_write_I => First_n_words,
	
	FIFO_data_word_O => FIFO_data_word
	);
-- ===========================================================

	PROCESS (SysClk_I)
	BEGIN

		IF(SysClk_I'EVENT and SysClk_I = '1') THEN
		
			IF(RESET_I = '1') THEN
				FSM_STATE <= s2_word;
				Is_First_word <= false;
				Data_Strobe <= Data_Strobe_zero;
				Is_strobe_data_void <= true;
				
			ELSE
				FSM_STATE <= FSM_STATE_NEXT;
				Is_First_word <= Is_First_word_next;
				First_n_words <= First_n_words_from_strobe;
				Data_Strobe <= Data_Strobe_next_from_sel;
				Is_strobe_data_void <= Is_strobe_data_void_from_sel;
				
				FIFO_data_word_ff <= FIFO_data_word_ff_next;
				FIFO_WE_ff <= FIFO_WE_ff_next;
				
				MODULE_data_I_ff <= MODULE_data_I_ff_next;
			END IF;
			
		END IF;
		
		
			FIFO_WE_ff_next <= '0';
	
		case FSM_STATE is
		
			when s1_head =>
				FSM_STATE_NEXT <= s2_word;
				Is_First_word_next <= true;
				Data_Strobe_to_sel <= Data_Strobe_input;
				
				FIFO_data_word_ff_next <= (others => '0');
				FIFO_data_word_ff_next(fifo_header_bitdepth-1 downto 0) <= FIFO_header_word;
					
				-- if( not Is_input_data_void) then
				if(
					(not Is_input_data_void) or
					((MODULE_data_I_ff.EVENT_ID(event_id_bitdepth-1 downto event_id_bitdepth - Trigger_bitdepth)
						and x"ffffffff") /= TRG_const_void)
				) then
					FIFO_WE_ff_next <= '1';
				else 
				-- change to 1 for whaiting header of void data
					FIFO_WE_ff_next <= '0';
				end if;
				
			when s2_word =>			
				Is_First_word_next <= false;
				Data_Strobe_to_sel <= Data_Strobe;
				
				FIFO_data_word_ff_next <= (others => '0');
				FIFO_data_word_ff_next(fifo_word_bitdeph-1 downto 0) <= FIFO_data_word;
				
				if( not Is_strobe_data_void ) then
					FIFO_WE_ff_next <= '1';
				else 
					FIFO_WE_ff_next <= '0';
				end if;
				
--				if(Is_strobe_data_void and (Data_Clk_strobe_I = '1')) then
				if(Is_strobe_data_void and (SysClk_count_I = x"0")) then
					FSM_STATE_NEXT <= s1_head;
				else
					FSM_STATE_NEXT <= s2_word;
				end if;
		end case;

		
	END PROCESS;
	
		
	-- process (FSM_STATE, Data_Strobe_input, Data_Strobe, Is_input_data_void, Is_strobe_data_void, FIFO_is_space_for_packet_I, SysClk_count_I, FIFO_header_word, FIFO_data_word)
	-- begin
	-- FIFO_WE_ff_next <= '0';
	
		-- case FSM_STATE is
		
			-- when s1_head =>
				-- FSM_STATE_NEXT <= s2_word;
				-- Is_First_word_next <= true;
				-- Data_Strobe_to_sel <= Data_Strobe_input;
				
				-- FIFO_data_word_ff_next <= (others => '0');
				-- FIFO_data_word_ff_next(fifo_header_bitdepth-1 downto 0) <= FIFO_header_word;
					
				-- -- if( not Is_input_data_void) then
				-- if(
					-- (not Is_input_data_void) or
					-- ((MODULE_data_I_ff.EVENT_ID(event_id_bitdepth-1 downto event_id_bitdepth - Trigger_bitdepth)
						-- and TRG_const_response) /= TRG_const_void)
				-- ) then
					-- FIFO_WE_ff_next <= '1';
				-- else 
				-- -- change to 1 for whaiting header of void data
					-- FIFO_WE_ff_next <= '0';
				-- end if;
				
			-- when s2_word =>			
				-- Is_First_word_next <= false;
				-- Data_Strobe_to_sel <= Data_Strobe;
				
				-- FIFO_data_word_ff_next <= (others => '0');
				-- FIFO_data_word_ff_next(fifo_word_bitdeph-1 downto 0) <= FIFO_data_word;
				
				-- if( not Is_strobe_data_void ) then
					-- FIFO_WE_ff_next <= '1';
				-- else 
					-- FIFO_WE_ff_next <= '0';
				-- end if;
				
-- --				if(Is_strobe_data_void and (Data_Clk_strobe_I = '1')) then
				-- if(Is_strobe_data_void and (SysClk_count_I = 0)) then
					-- FSM_STATE_NEXT <= s1_head;
				-- else
					-- FSM_STATE_NEXT <= s2_word;
				-- end if;
		-- end case;

	
	-- end process;


		
end Behavioral;

