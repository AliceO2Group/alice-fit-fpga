----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    07/11/2017 
-- Design Name: 
-- Module Name:   
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

-- TO DO: 
-- 		check packets from PM without space
--		FIFO full
-- 		FIFO reset
-- 320 CLock

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all ;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity DataConverter is
    Port ( 
		FSM_Clocks_I : in FSM_Clocks_type;
		
		FIT_GBT_status_I : in FIT_GBT_status_type;
		Control_register_I : in CONTROL_REGISTER_type;
		
		Board_data_I		: in board_data_type;
		
		FIFO_is_space_for_packet_I : in STD_LOGIC;
		
		FIFO_WE_O : out STD_LOGIC;
		FIFO_data_word_O : out std_logic_vector(fifo_data_bitdepth-1 downto 0);
--		FIFO_data_word_O : out std_logic_vector(160-1 downto 0);
		
		hits_rd_counter_converter_O : out hit_rd_counter_type
	 );
end DataConverter;

architecture Behavioral of DataConverter is

	constant board_data_void_const : board_data_type :=
	(						
		is_header => '0',
		is_data => '0',
		data_word => (others => '0')
	);

	-- type FSM_STATE_T is (s0_wait_header, s1_sending_data);
	-- signal FSM_STATE, FSM_STATE_NEXT  : FSM_STATE_T;
	
	signal data_fromfifo : std_logic_vector(fifo_data_bitdepth-1 downto 0);
	signal is_header_from_fifo : std_logic;
	signal is_data_from_fifo : std_logic;
	signal raw_data_fifo_isempty : std_logic;
	
	

	signal Board_data_sysclkff, Board_data_sysclkff_next 				:  Board_data_type;
	signal FIFO_is_space_for_packet_ff, FIFO_is_space_for_packet_ff_next:  std_logic;
	
--	signal word_counter_ff, word_counter_ff_next :  std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
	constant counter_zero :  std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0) := (others => '0');
	signal packet_lenght_fromheader :  std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
	--packet_lenght_ff, packet_lenght_ff_next :  std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
	
	signal header_orbit : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal header_bc : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal header_word, data_word 		: std_logic_vector(fifo_data_bitdepth-1 downto 0);

	signal sending_event, sending_event_next : std_logic;
	signal FIFO_WE_ff, FIFO_WE_ff_next : STD_LOGIC;
	signal FIFO_data_word_ff, FIFO_data_word_ff_next : std_logic_vector(fifo_data_bitdepth-1 downto 0);

	signal reset_drop_counters : std_logic;
	signal is_dropping_event : std_logic;--, is_dropping_event_next : std_logic;
	signal dropped_events, dropped_events_next : std_logic_vector(31 downto 0);
	signal first_dropped_orbit, first_dropped_orbit_next : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal first_dropped_bc, first_dropped_bc_next : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal last_dropped_orbit, last_dropped_orbit_next : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal last_dropped_bc,    last_dropped_bc_next : std_logic_vector(BC_id_bitdepth-1 downto 0);
	
	
	
	attribute keep : string;	
	attribute keep of Board_data_sysclkff : signal is "true";
	attribute keep of reset_drop_counters : signal is "true";
	attribute keep of dropped_events : signal is "true";
	attribute keep of first_dropped_orbit : signal is "true";
	attribute keep of first_dropped_bc : signal is "true";
	attribute keep of last_dropped_orbit: signal is "true";
	attribute keep of last_dropped_bc: signal is "true";
	
	
begin




-- Wiring ********************************************
	FIFO_WE_O <= FIFO_WE_ff;
    FIFO_data_word_O <= FIFO_data_word_ff;

--	FIFO_WE_O <= Board_data_sysclkff.is_data;
--	FIFO_data_word_O <= Board_data_sysclkff.data_word;
	
	
	hits_rd_counter_converter_O.hits_send_porbit 	<= (others => '0');
	hits_rd_counter_converter_O.hits_skipped 		<= dropped_events;
	hits_rd_counter_converter_O.first_orbit_hdrop	<= first_dropped_orbit;
	hits_rd_counter_converter_O.first_bc_hdrop 		<= first_dropped_bc;
	hits_rd_counter_converter_O.last_orbit_hdrop 	<= last_dropped_orbit;
	hits_rd_counter_converter_O.last_bc_hdrop 		<= last_dropped_bc;

-- ***************************************************




-- tcm_data_160to80bit_fifo =============================================
tcm_data_160to80bit_fifo_comp : entity work.tcm_data_160to80bit_fifo
port map(
           clk           => FSM_Clocks_I.System_Clk,
           srst          => FSM_Clocks_I.Reset,
           WR_EN 		 => Board_data_I.is_data,
           RD_EN         => not raw_data_fifo_isempty,
           DIN           => Board_data_I.data_word,
           DOUT          => data_fromfifo,
           FULL          => open,
           EMPTY         => raw_data_fifo_isempty,
     	   rd_data_count => open
        );
		
is_header_from_fifo <= '1' when (data_fromfifo(79 downto 76) = "1111") else '0';
is_data_from_fifo <= not raw_data_fifo_isempty;

-- ===========================================================

-- Header format *************************************
	packet_lenght_fromheader <= func_PMHEADER_n_dwords( data_fromfifo );
	header_orbit <=func_PMHEADER_getORBIT(data_fromfifo);
	header_bc <= func_PMHEADER_getBC(data_fromfifo);
	header_word <= func_FITDATAHD_get_header(packet_lenght_fromheader, header_orbit, header_bc, FIT_GBT_status_I.rx_phase, FIT_GBT_status_I.GBT_status.Rx_Phase_error);
	data_word <= data_fromfifo;
-- ***************************************************




-- Data ff data clk ***********************************
	PROCESS (FSM_Clocks_I.System_Clk)
	BEGIN
		IF(FSM_Clocks_I.System_Clk'EVENT and FSM_Clocks_I.System_Clk = '1') THEN
			IF(FSM_Clocks_I.Reset = '1') THEN
				Board_data_sysclkff <= board_data_void_const;
				sending_event <= '0';
				FIFO_is_space_for_packet_ff <= '0';

				dropped_events <= (others => '0');
				first_dropped_orbit <= (others => '0');
				first_dropped_bc <= (others => '0');
				last_dropped_orbit <= (others => '0');
				last_dropped_bc <= (others => '0');
				FIFO_WE_ff <= '0';
                FIFO_data_word_ff <= (others => '0');
				
				--is_data_from_fifo <= '0';

			ELSE
				Board_data_sysclkff <= Board_data_sysclkff_next;
				sending_event <= sending_event_next;
				FIFO_is_space_for_packet_ff <= FIFO_is_space_for_packet_ff_next;
				FIFO_WE_ff <= FIFO_WE_ff_next;
				--if (is_data_from_fifo = '1') and (sending_event = '1') then FIFO_WE_ff <= '1'; else FIFO_WE_ff <= '0'; end if;
				FIFO_data_word_ff <= FIFO_data_word_ff_next;
				
				dropped_events <= dropped_events_next;
				first_dropped_orbit <= first_dropped_orbit_next;
				first_dropped_bc <= first_dropped_bc_next;
				last_dropped_orbit <= last_dropped_orbit_next;
				last_dropped_bc <= last_dropped_bc_next;
				
				--is_data_from_fifo <= not raw_data_fifo_isempty;
			END IF;
			
			
		END IF;
		
		
	END PROCESS;
-- ****************************************************


-- FSM ************************************************
--Board_data_sysclkff_next <= Board_data_I;
FIFO_is_space_for_packet_ff_next <= FIFO_is_space_for_packet_I;

reset_drop_counters <= Control_register_I.reset_drophit_counter;
-- reset_drop_counters <= 	  '1'	WHEN (FSM_Clocks_I.Reset = '1') ELSE
						  -- '1'	WHEN (FIT_GBT_status_I.Start_run = '1') ELSE
						  -- '0';
	
	
sending_event_next <= 	'0'	WHEN (FSM_Clocks_I.Reset = '1') ELSE
						'0'	WHEN (is_header_from_fifo = '1') and (FIT_GBT_status_I.Readout_Mode = mode_IDLE) and (Control_register_I.readout_bypass='1') ELSE
						'0'	WHEN (is_header_from_fifo = '1') and (FIFO_is_space_for_packet_ff = '0') ELSE
						'1'	WHEN (is_header_from_fifo = '1') ELSE
						sending_event;
		
FIFO_data_word_ff_next <= 	(others => '0')	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							header_word 	WHEN (sending_event = '1') and (is_header_from_fifo = '1') ELSE
							data_word		WHEN (sending_event = '1') and (is_data_from_fifo = '1') ELSE
							(others => '0');
							
FIFO_WE_ff_next <= 			'0' 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							'1'		WHEN (is_data_from_fifo = '1') and (sending_event = '1') ELSE
							'0';
							
-- Event counter ------------------------------------

is_dropping_event	<=  '0' 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
						'0'		WHEN (FIT_GBT_status_I.Readout_Mode = mode_IDLE) ELSE
						'1'		WHEN (is_header_from_fifo = '1') and (FIFO_is_space_for_packet_ff = '0') ELSE
						'0';

dropped_events_next <= 	(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
						(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
						dropped_events + 1	WHEN (is_dropping_event = '1') ELSE
						dropped_events;

last_dropped_orbit_next <= 	(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
							header_orbit		WHEN (is_dropping_event = '1') ELSE
							last_dropped_orbit;

last_dropped_bc_next <= 		(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
								(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
								header_bc			WHEN (is_dropping_event = '1') ELSE
								last_dropped_bc;

first_dropped_orbit_next <= (others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
							header_orbit		WHEN (is_dropping_event = '1') and (last_dropped_orbit = ORBIT_const_void) ELSE
							first_dropped_orbit;

first_dropped_bc_next <= 	(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
							header_bc			WHEN (is_dropping_event = '1') and (last_dropped_orbit = ORBIT_const_void) ELSE
							first_dropped_bc;
-- ****************************************************
							

end Behavioral;

