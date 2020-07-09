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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all ;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity Event_selector is
    Port ( 
		FSM_Clocks_I : in FSM_Clocks_type;

		FIT_GBT_status_I : in FIT_GBT_status_type;
		Control_register_I : in CONTROL_REGISTER_type;
		
		RAWFIFO_data_word_I : in std_logic_vector(fifo_data_bitdepth-1 downto 0);
		RAWFIFO_data_count_I	:in std_logic_vector(rawfifo_count_bitdepth-1 downto 0);
		RAWFIFO_Is_Empty_I : in STD_LOGIC;
		RAWFIFO_RE_O : out STD_LOGIC;
		RAWFIFO_RESET_O : out STD_LOGIC;
		
		SLCTFIFO_data_word_O : out std_logic_vector(fifo_data_bitdepth-1 downto 0);
		SLCTFIFO_Is_spacefpacket_I : in STD_LOGIC;
		SLCTFIFO_WE_O : out STD_LOGIC;
		SLCTFIFO_RESET_O : out STD_LOGIC;
		
		CNTPTFIFO_data_word_O : out std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0);
		CNTPFIFO_Is_Empty_O : out STD_LOGIC;
		CNTPFIFO_count_O : out std_logic_vector(cntpckfifo_count_bitdepth-1 downto 0);
		CNTPFIFO_RE_I : in STD_LOGIC;
		
		TRGFIFO_count_O : out std_logic_vector(trgfifo_count_bitdepth-1 downto 0);
		
		hits_rd_counter_selector_O 	: out hit_rd_counter_type

	 );
end Event_selector;

architecture Behavioral of Event_selector is
	
	-- trg fifo -------------------
	signal trgfifo_data_fromff : std_logic_vector(trgfifo_data_bitdepth-1 downto 0);
	signal trgfifo_data_toff : std_logic_vector(trgfifo_data_bitdepth-1 downto 0);
	signal trgfifo_we :std_logic;
	signal trgfifo_we_ff01, trgfifo_we_ff02, trgfifo_we_ff03 :std_logic;
	signal trgfifo_re :std_logic;
	signal trgfifo_dcount_rd : std_logic_vector(trgfifo_count_bitdepth-1 downto 0);
	signal trgfifo_empty :std_logic;
	signal trgfifo_empty_real :std_logic;
	signal trgfifo_reset :std_logic;
	signal trgfifo_out_trigger : std_logic_vector(Trigger_bitdepth-1 downto 0);
	signal trgfifo_out_orbit : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal trgfifo_out_bc : std_logic_vector(BC_id_bitdepth-1 downto 0);

	signal is_trg_first_data_late : std_logic;
	signal is_trg_eq_data : std_logic;
	signal is_trg_late_data_first : std_logic;
	signal is_hb_response, is_hb_response_s : std_logic;
	
	-- TRG from CRU comp ----------
	signal fromcru_orbit_ff, fromcru_dec_orbit_ff, fromcru_dec_orbit_ff_next : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
    signal fromcru_bc_ff, fromcru_dec_bc_ff, fromcru_dec_bc_ff_next : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal is_trg_forrawdata_must_present : std_logic;
	
	
	
	-- raw fifo -------------------
	signal is_fullpacket_in_rawfifo : std_logic;
	signal rawfifo_packet_ndwords, rawfifo_packet_ndwords_ff : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
	signal rawfifo_packet_orbit, rawfifo_packet_orbit_ff : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal rawfifo_packet_bc, rawfifo_packet_bc_ff: std_logic_vector(BC_id_bitdepth-1 downto 0);
	
	
	
	-- cntpck fifo -------------------
	signal cntpckfifo_data_fromff : std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0);
	signal cntpckfifo_data_toff : std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0);
	signal cntpckfifo_we :std_logic;
	signal cntpckfifo_re :std_logic;
	signal cntpckfifo_empty :std_logic;
	signal cntpckfifo_reset :std_logic;
	signal cntpckfifo_dcount_rd : std_logic_vector(cntpckfifo_count_bitdepth-1 downto 0);
	
	
	
	-- FSM ---------------------
	signal 	Readout_Mode_ff00, Readout_Mode_ff01 : Type_Readout_Mode; -- delay for put EOC/EOT to trgfifo
	signal 	Readout_Mode_manage, Readout_Mode_manage_DtClk, Readout_Mode_manage_next : Type_Readout_Mode; -- delay for put EOC/EOT to trgfifo
	type FSM_STATE_T is (s0_DT_comp, s1_dread, s2_send_wpacket);
	signal FSM_STATE, FSM_STATE_NEXT  : FSM_STATE_T;
	type rdata_state_T is (s0_start, s1_header, s2_data, s3_lastw);
	signal rdata_state, rdata_state_next  : rdata_state_T;
	type cntpckws_state_T is (s0_simpl_pcw, s1_closefr_pcw);
	signal cntpckws_state, cntpckws_state_next  : cntpckws_state_T;
	signal is_frame_open, is_frame_open_next : std_logic;
	
	
	
	-- data packet -------------
	signal current_hb_orbit, current_hb_orbit_next : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal current_hb_bc, current_hb_bc_next : std_logic_vector(BC_id_bitdepth-1 downto 0);
	
	signal data_header_orbit_ff, data_header_orbit_ff_next : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal data_header_bc_ff, data_header_bc_ff_next : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal data_header_nwrd_ff, data_header_nwrd_ff_next : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
	signal wcnt_inpck, wcnt_inpck_next : std_logic_vector(GEN_count_bitdepth-1 downto 0);
	signal pages_counter, pages_counter_next : std_logic_vector(RDH_pages_counter_bitdepth-1 downto 0);
	signal wcnt_fullpck, wcnt_fullpck_next, wcnt_fullpck_ff : std_logic_vector(GEN_count_bitdepth-1 downto 0);
	signal max_data_packet_payload : std_logic_vector(GEN_count_bitdepth-1 downto 0);
	signal crutrg_delay_comp : std_logic_vector(BC_id_bitdepth-1 downto 0);
	
	signal is_sending_packet_ff, is_sending_packet_ff_next : std_logic;
	signal slck_fifo_we : std_logic;
	
	signal data_rate_counter, data_rate_counter_next : std_logic_vector(15 downto 0);
	signal hits_send_porbit, hits_send_porbit_next : std_logic_vector(15 downto 0);
	
	-- data drop counter
	signal reset_drop_counters : std_logic;
	signal is_dropping_event : std_logic;--, is_dropping_event_next : std_logic;
	signal dropped_events, dropped_events_next : std_logic_vector(31 downto 0);
	signal first_dropped_orbit, first_dropped_orbit_next : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal first_dropped_bc, first_dropped_bc_next : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal last_dropped_orbit, last_dropped_orbit_next : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal last_dropped_bc,    last_dropped_bc_next : std_logic_vector(BC_id_bitdepth-1 downto 0);
	
	


	
	attribute keep : string;	
	attribute keep of Readout_Mode_manage : signal is "true";
	attribute keep of FSM_STATE : signal is "true";
	attribute keep of rdata_state : signal is "true";
	attribute keep of cntpckws_state : signal is "true";
	attribute keep of is_frame_open: signal is "true";
	attribute keep of pages_counter: signal is "true";

	attribute keep of trgfifo_out_trigger : signal is "true";
	attribute keep of trgfifo_out_orbit : signal is "true";
	attribute keep of trgfifo_out_bc : signal is "true";
	
	attribute keep of data_header_orbit_ff : signal is "true";
	attribute keep of data_header_bc_ff : signal is "true";

	
	attribute keep of current_hb_orbit : signal is "true";
	attribute keep of current_hb_bc : signal is "true";
	
	attribute keep of is_trg_first_data_late : signal is "true";
	attribute keep of is_trg_eq_data : signal is "true";
	attribute keep of is_trg_late_data_first : signal is "true";
	attribute keep of is_hb_response : signal is "true";
	
	attribute keep of fromcru_dec_orbit_ff : signal is "true";
	attribute keep of fromcru_dec_bc_ff : signal is "true";
	attribute keep of is_trg_forrawdata_must_present : signal is "true";
	
	
	attribute keep of trgfifo_empty : signal is "true";
	attribute keep of trgfifo_we : signal is "true";
	attribute keep of trgfifo_data_toff : signal is "true";

	attribute keep of reset_drop_counters : signal is "true";
	attribute keep of dropped_events : signal is "true";
	attribute keep of first_dropped_orbit : signal is "true";
	attribute keep of first_dropped_bc : signal is "true";
	attribute keep of last_dropped_orbit: signal is "true";
	attribute keep of last_dropped_bc: signal is "true";

begin
	crutrg_delay_comp <= Control_register_I.crutrg_delay_comp;
	--crutrg_delay_comp <= x"00f";
	max_data_packet_payload <= Control_register_I.max_data_payload;
--	max_data_packet_payload <= x"01c2";
	Readout_Mode_ff00 <= FIT_GBT_status_I.Readout_Mode;
	
	SLCTFIFO_WE_O <= slck_fifo_we;
	
	CNTPTFIFO_data_word_O <= cntpckfifo_data_fromff;
	CNTPFIFO_Is_Empty_O <= cntpckfifo_empty;
	cntpckfifo_re <= CNTPFIFO_RE_I;

	CNTPFIFO_count_O <= cntpckfifo_dcount_rd;
	TRGFIFO_count_O <= trgfifo_dcount_rd;
	
	
	hits_rd_counter_selector_O.hits_send_porbit 	<= hits_send_porbit;
	hits_rd_counter_selector_O.hits_skipped 		<= dropped_events;
	hits_rd_counter_selector_O.first_orbit_hdrop	<= first_dropped_orbit;
	hits_rd_counter_selector_O.first_bc_hdrop 		<= first_dropped_bc;
	hits_rd_counter_selector_O.last_orbit_hdrop 	<= last_dropped_orbit;
	hits_rd_counter_selector_O.last_bc_hdrop 		<= last_dropped_bc;
	
	
-- TRG FIFO ******************************************
	trgfifo_data_toff <= FIT_GBT_status_I.Trigger_from_CRU & FIT_GBT_status_I.ORBIT_from_CRU & FIT_GBT_status_I.BCID_from_CRU;
	
	trgfifo_out_trigger <= trgfifo_data_fromff(trgfifo_data_bitdepth-1 downto BC_id_bitdepth + Orbit_id_bitdepth);
	trgfifo_out_orbit <= trgfifo_data_fromff(BC_id_bitdepth + Orbit_id_bitdepth -1 downto BC_id_bitdepth);
	trgfifo_out_bc <= trgfifo_data_fromff(BC_id_bitdepth - 1 downto 0);
	
						
	is_trg_eq_data <= 	'0' WHEN (trgfifo_empty = '1') ELSE
						'0' WHEN (RAWFIFO_Is_Empty_I = '1') ELSE
						'0' WHEN (trgfifo_out_orbit = ORBIT_const_void) ELSE
						'0' WHEN (rawfifo_packet_orbit_ff = ORBIT_const_void) ELSE
		--				'1' WHEN (  (trgfifo_out_orbit = rawfifo_packet_orbit_ff) and (trgfifo_out_bc = rawfifo_packet_bc_ff)  and (trgfifo_out_trigger = Control_register_I.trg_data_select) ) ELSE
						'1' WHEN (  (trgfifo_out_orbit = rawfifo_packet_orbit_ff) and (trgfifo_out_bc = rawfifo_packet_bc_ff)   ) ELSE
						'0';
						
	is_trg_first_data_late <= 	'0' WHEN (trgfifo_empty = '1') ELSE
								'0' WHEN (RAWFIFO_Is_Empty_I = '1') ELSE
								'0' WHEN (trgfifo_out_orbit = ORBIT_const_void) ELSE
								'0' WHEN (rawfifo_packet_orbit_ff = ORBIT_const_void) ELSE
								'1' WHEN (  (trgfifo_out_orbit < rawfifo_packet_orbit_ff)  ) ELSE
								'1' WHEN (  (trgfifo_out_orbit = rawfifo_packet_orbit_ff) and (trgfifo_out_bc < rawfifo_packet_bc_ff) ) ELSE
								'0';
	
	-- trigger always late
	is_trg_late_data_first <= 	'0' WHEN (trgfifo_empty = '1') ELSE
								'0' WHEN (RAWFIFO_Is_Empty_I = '1') ELSE
								'0' WHEN (trgfifo_out_orbit = ORBIT_const_void) ELSE
								'0' WHEN (rawfifo_packet_orbit_ff = ORBIT_const_void) ELSE
								'1' WHEN (  (trgfifo_out_orbit > rawfifo_packet_orbit_ff)  ) ELSE
								'1' WHEN (  (trgfifo_out_orbit = rawfifo_packet_orbit_ff) and (trgfifo_out_bc > rawfifo_packet_bc_ff) ) ELSE
								'0';
								
	trgfifo_empty_real <= 		'1'	WHEN (FSM_Clocks_I.Reset = '1') ELSE
								'0' WHEN (trgfifo_empty = '0') ELSE
								'0' WHEN (trgfifo_we = '1') ELSE
								'0' WHEN (trgfifo_we_ff01 = '1') ELSE
								'0' WHEN (trgfifo_we_ff02 = '1') ELSE
								'0' WHEN (trgfifo_we_ff03 = '1') ELSE
								trgfifo_empty;
								
	is_hb_response <= 			'0'	WHEN (FSM_Clocks_I.Reset = '1') ELSE
								'0' WHEN (trgfifo_empty = '1') ELSE
								'1' WHEN ((trgfifo_out_trigger and TRG_const_HB) > 0) ELSE
								'0';
-- ***************************************************
 
 
 
-- RAW FIFO ******************************************
is_fullpacket_in_rawfifo <= 	'0' WHEN (RAWFIFO_Is_Empty_I = '1') ELSE
								'1' when (unsigned(RAWFIFO_data_count_I) > unsigned(rawfifo_packet_ndwords_ff)) else
								'0';

rawfifo_packet_ndwords <= func_FITDATAHD_ndwords(RAWFIFO_data_word_I);
rawfifo_packet_orbit <= func_FITDATAHD_orbit(RAWFIFO_data_word_I);
rawfifo_packet_bc <= func_FITDATAHD_bc(RAWFIFO_data_word_I);


is_trg_forrawdata_must_present <= 	'0' WHEN (RAWFIFO_Is_Empty_I = '1') ELSE
									'1' WHEN (  rawfifo_packet_orbit_ff < fromcru_dec_orbit_ff  ) ELSE
									'1' WHEN (  (rawfifo_packet_orbit_ff = fromcru_dec_orbit_ff) and (rawfifo_packet_bc_ff < fromcru_dec_bc_ff) ) ELSE
									'0';
									
									
fromcru_dec_bc_ff_next <= (fromcru_bc_ff - crutrg_delay_comp) WHEN (fromcru_bc_ff >= crutrg_delay_comp) ELSE
        fromcru_bc_ff - crutrg_delay_comp + LHC_BCID_max + 1;

fromcru_dec_orbit_ff_next <= fromcru_orbit_ff WHEN (fromcru_bc_ff >= crutrg_delay_comp) ELSE
        fromcru_orbit_ff - 1;
-- ***************************************************





-- TRG FIFO =============================================
trg_fifo_comp_c : entity work.trg_fifo_comp
port map(
   wr_clk        => FSM_Clocks_I.Data_Clk,
   rd_clk        => FSM_Clocks_I.System_Clk,
   rst          => trgfifo_reset,
   DIN           => trgfifo_data_toff,
   WR_EN 		 => trgfifo_we,
   RD_EN         => trgfifo_re,
   
   DOUT          => trgfifo_data_fromff,
   rd_data_count => trgfifo_dcount_rd,
   EMPTY         => trgfifo_empty
   );
-- ===========================================================




-- CNTPCK FIFO =============================================
cntpck_fifo_comp_c : entity work.cntpck_fifo_comp
port map(
   wr_clk        => FSM_Clocks_I.System_Clk,
   rd_clk        => FSM_Clocks_I.Data_Clk,
   rst           => cntpckfifo_reset,
   DIN           => cntpckfifo_data_toff,
   WR_EN 		 => cntpckfifo_we,
   RD_EN         => cntpckfifo_re,
   
   DOUT          => cntpckfifo_data_fromff,
   rd_data_count => cntpckfifo_dcount_rd,
   EMPTY         => cntpckfifo_empty
   );
-- ===========================================================




  
  -- Data ff data clk ***********************************
	PROCESS (FSM_Clocks_I.Data_Clk)
	BEGIN
		IF(FSM_Clocks_I.Data_Clk'EVENT and FSM_Clocks_I.Data_Clk = '1') THEN
		
		is_hb_response_s<=Control_register_I.is_hb_response;
		
			IF(FSM_Clocks_I.Reset40 = '1') THEN
				Readout_Mode_ff01 <= mode_IDLE;
				
				trgfifo_we_ff01 <= '0';
				trgfifo_we_ff02 <= '0';
				trgfifo_we_ff03 <= '0';
				
				--Readout_Mode_manage_DtClk <= mode_IDLE;

				fromcru_orbit_ff <= (others => '0');
				fromcru_bc_ff <= (others => '0');
				fromcru_dec_orbit_ff <= (others => '0');
				fromcru_dec_bc_ff <= (others => '0');
				
			ELSE
				Readout_Mode_ff01 <= Readout_Mode_ff00;
				
				trgfifo_we_ff01 <= trgfifo_we;
				trgfifo_we_ff02 <= trgfifo_we_ff01;
				trgfifo_we_ff03 <= trgfifo_we_ff02;
				
				--Readout_Mode_manage_DtClk <= Readout_Mode_manage;
				
				fromcru_orbit_ff <= FIT_GBT_status_I.ORBIT_from_CRU;
				fromcru_bc_ff <= FIT_GBT_status_I.BCID_from_CRU;
				fromcru_dec_orbit_ff <= fromcru_dec_orbit_ff_next;
				fromcru_dec_bc_ff <= fromcru_dec_bc_ff_next;
				
				
			END IF;
		END IF;
	END PROCESS;
-- ****************************************************

-- Data ff sys clk ************************************
	PROCESS (FSM_Clocks_I.System_Clk)
	BEGIN
		IF(FSM_Clocks_I.System_Clk'EVENT and FSM_Clocks_I.System_Clk = '1') THEN
			IF(FSM_Clocks_I.Reset = '1') THEN
			
				cntpckws_state <= s0_simpl_pcw;
				rdata_state <= s0_start;
				FSM_STATE <= s0_DT_comp;
				Readout_Mode_manage <= mode_IDLE;

				current_hb_orbit <= (others => '0');
				current_hb_bc <= (others => '0');
				data_header_orbit_ff <= (others => '0');
				data_header_bc_ff <= (others => '0');
				data_header_nwrd_ff <= (others => '0');
				wcnt_inpck <= (others => '0');
				wcnt_fullpck <= (others => '0');
				wcnt_fullpck_ff <= (others => '0');
				is_sending_packet_ff <= '0';
				is_frame_open <= '0';
				pages_counter <= (others => '0');

				data_rate_counter <= (others => '0');
				hits_send_porbit <= (others => '0');

				dropped_events <= (others => '0');
				first_dropped_orbit <= (others => '0');
				first_dropped_bc <= (others => '0');
				last_dropped_orbit <= (others => '0');
				last_dropped_bc <= (others => '0');
				
			ELSE
				cntpckws_state <= cntpckws_state_next;
				rdata_state <= rdata_state_next;
				FSM_STATE <= FSM_STATE_NEXT;

					if(Readout_Mode_ff00 /= mode_IDLE) then
						Readout_Mode_manage <= Readout_Mode_ff00;
					else
						Readout_Mode_manage <= Readout_Mode_manage_next;
					end if;
				
				current_hb_orbit <= current_hb_orbit_next;
				current_hb_bc <= current_hb_bc_next;
				data_header_orbit_ff <= data_header_orbit_ff_next;
				data_header_bc_ff <= data_header_bc_ff_next;
				data_header_nwrd_ff <= data_header_nwrd_ff_next;
				wcnt_inpck <= wcnt_inpck_next;
				wcnt_fullpck <= wcnt_fullpck_next;
				wcnt_fullpck_ff <= wcnt_fullpck;
				is_sending_packet_ff <= is_sending_packet_ff_next;
				is_frame_open <= is_frame_open_next;
				pages_counter <= pages_counter_next;
				
				data_rate_counter <= data_rate_counter_next;
				hits_send_porbit <= hits_send_porbit_next;
				
				dropped_events <= dropped_events_next;
				first_dropped_orbit <= first_dropped_orbit_next;
				first_dropped_bc <= first_dropped_bc_next;
				last_dropped_orbit <= last_dropped_orbit_next;
				last_dropped_bc <= last_dropped_bc_next;				
			END IF;
		END IF;
	END PROCESS;
-- ****************************************************

	rawfifo_packet_ndwords_ff <= rawfifo_packet_ndwords;
	rawfifo_packet_orbit_ff <= rawfifo_packet_orbit;
	rawfifo_packet_bc_ff <= rawfifo_packet_bc;
  
  -- FSM ***********************************************
  Readout_Mode_manage_next <=	mode_IDLE 			WHEN (FSM_Clocks_I.Reset = '1') ELSE
								Readout_Mode_ff00 	WHEN (Readout_Mode_ff00 /= mode_IDLE) ELSE
								Readout_Mode_ff01 	WHEN (Readout_Mode_ff01 /= mode_IDLE) ELSE
								Readout_Mode_manage	WHEN (trgfifo_empty_real = '0') ELSE
								Readout_Mode_ff01;
  
  
  
	FSM_STATE_NEXT <= s0_DT_comp 		WHEN (FSM_Clocks_I.Reset = '1') ELSE
	
					-- ------------------- IDL -------------------
					  s0_DT_comp		WHEN (Readout_Mode_manage = mode_IDLE) ELSE
					  s0_DT_comp		WHEN (FIT_GBT_status_I.BCIDsync_Mode = mode_STR) ELSE
					  s0_DT_comp		WHEN (FIT_GBT_status_I.BCIDsync_Mode = mode_LOST) ELSE
					  
					  s1_dread			WHEN (FSM_STATE = s1_dread)   and (rdata_state /= s3_lastw)  ELSE -- reading data
					  s0_DT_comp		WHEN (FSM_STATE = s1_dread)   and (rdata_state = s3_lastw)  ELSE -- return to s0
					  
					  
					  s0_DT_comp		WHEN (FSM_STATE = s0_DT_comp) and (trgfifo_empty = '1') and (RAWFIFO_Is_Empty_I = '1') ELSE -- wait
					  s2_send_wpacket	WHEN (FSM_STATE = s0_DT_comp) and (trgfifo_empty = '0') and (RAWFIFO_Is_Empty_I = '1') ELSE -- no data send response
				
					  s1_dread			WHEN (FSM_STATE = s0_DT_comp) and (is_trg_eq_data = '1') and (is_hb_response = '0') ELSE -- read data for trigger
					  s2_send_wpacket	WHEN (FSM_STATE = s0_DT_comp) and (is_trg_eq_data = '1') and (cntpckws_state = s0_simpl_pcw)   and (is_hb_response = '1') ELSE -- no read HB data; send SF first
					  s1_dread			WHEN (FSM_STATE = s0_DT_comp) and (is_trg_eq_data = '1') and (cntpckws_state = s1_closefr_pcw) and (is_hb_response = '1') ELSE -- read HB data after SF
					  s2_send_wpacket	WHEN (FSM_STATE = s0_DT_comp) and (is_trg_eq_data = '1') ELSE -- send trg+data
					  
					  s2_send_wpacket	WHEN (FSM_STATE = s0_DT_comp) and (is_trg_first_data_late = '1') ELSE -- send trg
					  
					  s2_send_wpacket	WHEN (FSM_STATE = s0_DT_comp) and (wcnt_fullpck_ff >= max_data_packet_payload)  ELSE -- send by payload
					  
					  
					  s1_dread			WHEN (FSM_STATE = s0_DT_comp) and (is_trg_late_data_first = '1') ELSE -- send data
					  s1_dread			WHEN (FSM_STATE = s0_DT_comp) and (trgfifo_empty = '1') and (RAWFIFO_Is_Empty_I = '0') and (is_trg_forrawdata_must_present = '1') ELSE -- no trg, send data
					  s0_DT_comp;
					  					  
					  
					  
					  
					  
	is_sending_packet_ff_next <= 	'0'	WHEN (FSM_Clocks_I.Reset = '1') ELSE
					-- ------------------- IDL -------------------
									'0'	WHEN (Readout_Mode_manage = mode_IDLE) ELSE
					-- ------------------- SLCT FIFO FULL -------------------
									'0' WHEN 												(FSM_STATE = s1_dread) and (rdata_state = s0_start) and (SLCTFIFO_Is_spacefpacket_I = '0') ELSE
--									'0' WHEN 												(FSM_STATE = s1_dread) and (rdata_state = s0_start) and (data_header_orbit_ff /= current_hb_orbit) ELSE
					-- ------------------- TRG -------------------
									'1' WHEN (is_trg_eq_data = '1')	and ((trgfifo_out_trigger and Control_register_I.trg_data_select) > 1) 					and (FSM_STATE = s1_dread) and (rdata_state = s0_start) and (Readout_Mode_manage = mode_TRG) ELSE
									'0' WHEN (is_trg_first_data_late = '1') 			and (FSM_STATE = s1_dread) and (rdata_state = s0_start) and (Readout_Mode_manage = mode_TRG) ELSE
									'0' WHEN (is_trg_late_data_first = '1') 			and (FSM_STATE = s1_dread) and (rdata_state = s0_start) and (Readout_Mode_manage = mode_TRG) ELSE
									'0' WHEN (is_trg_forrawdata_must_present = '1') 	and (FSM_STATE = s1_dread) and (rdata_state = s0_start) and (Readout_Mode_manage = mode_TRG) ELSE
					-- ------------------- CNT -------------------
									'1' WHEN 												(FSM_STATE = s1_dread) and (rdata_state = s0_start) and (Readout_Mode_manage = mode_CNT) ELSE
					-- ------------------- --- -------------------
									is_sending_packet_ff;
					  
					  
					  
	rdata_state_next <= s0_start	WHEN (FSM_Clocks_I.Reset = '1') ELSE
--						s0_start    WHEN (Readout_Mode_manage = mode_IDLE) ELSE
						s0_start	WHEN (FSM_STATE = s1_dread) and (rdata_state = s0_start) and (is_fullpacket_in_rawfifo = '0') ELSE
						s1_header	WHEN (FSM_STATE = s1_dread) and (rdata_state = s0_start) ELSE
						s3_lastw	WHEN (FSM_STATE = s1_dread) and (rdata_state = s1_header) and (data_header_nwrd_ff=1) ELSE
						s2_data		WHEN (FSM_STATE = s1_dread) and (rdata_state = s1_header) ELSE
						s2_data		WHEN (FSM_STATE = s1_dread) and (rdata_state = s2_data) and (wcnt_inpck < data_header_nwrd_ff-1) ELSE
						s3_lastw	WHEN (FSM_STATE = s1_dread) and (rdata_state = s2_data) and (wcnt_inpck = data_header_nwrd_ff-1) ELSE
						s0_start;
						
						
	cntpckws_state_next <= 	s0_simpl_pcw	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							s0_simpl_pcw	WHEN (FSM_STATE_NEXT = s2_send_wpacket) and (cntpckws_state = s1_closefr_pcw) ELSE
							s1_closefr_pcw	WHEN (FSM_STATE_NEXT = s2_send_wpacket) and (is_hb_response = '1') and (is_frame_open = '1') ELSE
							s0_simpl_pcw	WHEN (FSM_STATE_NEXT = s2_send_wpacket) and (wcnt_fullpck_ff >= max_data_packet_payload) ELSE
							cntpckws_state;
	

	is_frame_open_next <= '0' WHEN (FSM_Clocks_I.Reset = '1') ELSE 
						  '0' WHEN (Readout_Mode_manage = mode_IDLE) ELSE
						  '1' WHEN (FSM_STATE_NEXT = s2_send_wpacket) and (is_hb_response = '1') ELSE
						  '0' WHEN (FSM_STATE_NEXT = s2_send_wpacket) and (cntpckws_state = s1_closefr_pcw) ELSE
						  is_frame_open;

	-- pages_counter_next <= (others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE 
						  -- (others => '0') WHEN (Readout_Mode_ff00 = mode_IDLE) ELSE
						  -- (others => '0') WHEN (FSM_STATE_NEXT = s2_send_wpacket) and (is_hb_response = '1') and (cntpckws_state_next /= s1_closefr_pcw) ELSE
						  -- pages_counter + 1 WHEN (FSM_STATE_NEXT = s2_send_wpacket) ELSE
						  -- pages_counter;

	pages_counter_next <= (others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE 
						  (others => '0') WHEN (Readout_Mode_manage = mode_IDLE) ELSE
						  (others => '0') WHEN (cntpckfifo_we = '1') and (cntpckws_state = s1_closefr_pcw) ELSE
						  pages_counter + 1 WHEN (cntpckfifo_we = '1') ELSE
						  pages_counter;






	current_hb_orbit_next <= 	(others => '0') 					WHEN (FSM_Clocks_I.Reset = '1') ELSE
								FIT_GBT_status_I.ORBIT_from_CRU 	WHEN (Readout_Mode_manage = mode_IDLE) and ((FIT_GBT_status_I.Trigger_from_CRU and TRG_const_HB) > 0) ELSE
								trgfifo_out_orbit 					WHEN (is_hb_response = '1') and (cntpckws_state = s1_closefr_pcw) ELSE
								current_hb_orbit;
	
	current_hb_bc_next <= 	(others => '0') 						WHEN (FSM_Clocks_I.Reset = '1') ELSE
								FIT_GBT_status_I.BCID_from_CRU 		WHEN (Readout_Mode_manage = mode_IDLE) and ((FIT_GBT_status_I.Trigger_from_CRU and TRG_const_HB) > 0) ELSE
								trgfifo_out_bc 						WHEN (is_hb_response = '1') and (cntpckws_state = s1_closefr_pcw) ELSE
								current_hb_bc;

	
	wcnt_inpck_next <=  (others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
						(others => '0') WHEN (rdata_state = s0_start) ELSE
						wcnt_inpck + 1 	WHEN (FSM_STATE = s1_dread) ELSE
						(others => '0');
	
--	wcnt_fullpck_next <=  	(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
--                                                (others => '0')     WHEN (FSM_STATE = s2_send_wpacket) and (Readout_Mode_manage = mode_CNT) ELSE
--                                                wcnt_fullpck         WHEN (FSM_STATE = s2_send_wpacket) and (cntpckws_state = s1_closefr_pcw) and (Readout_Mode_manage = mode_TRG) ELSE
--                                                (others => '0')        WHEN (FSM_STATE = s2_send_wpacket) and (cntpckws_state = s0_simpl_pcw) and (Readout_Mode_manage = mode_TRG) ELSE
--                                                wcnt_fullpck + 1     WHEN (slck_fifo_we = '1') ELSE
--                                                wcnt_fullpck;
                        
	wcnt_fullpck_next <=  	(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
                            (others => '0')     WHEN (FSM_STATE = s2_send_wpacket) and (cntpckfifo_we = '1') ELSE
                            wcnt_fullpck + 1    WHEN (slck_fifo_we = '1') ELSE
                            wcnt_fullpck;
    
	data_header_nwrd_ff_next <= (others => '0')		WHEN (FSM_Clocks_I.Reset = '1') ELSE
							rawfifo_packet_ndwords_ff	WHEN (FSM_STATE = s1_dread) and (rdata_state = s0_start) ELSE
							data_header_nwrd_ff;
		
	data_header_orbit_ff_next <= (others => '0')	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							rawfifo_packet_orbit_ff	WHEN (FSM_STATE = s1_dread) and (rdata_state = s0_start) ELSE
							data_header_orbit_ff;
							
	data_header_bc_ff_next <= (others => '0')		WHEN (FSM_Clocks_I.Reset = '1') ELSE
							rawfifo_packet_bc_ff		WHEN (FSM_STATE = s1_dread) and (rdata_state = s0_start) ELSE
							data_header_bc_ff;
						
				

				
				
				
	trgfifo_reset <= FSM_Clocks_I.Reset;
	RAWFIFO_RESET_O <= FSM_Clocks_I.Reset;
	SLCTFIFO_RESET_O <= FSM_Clocks_I.Reset;
	cntpckfifo_reset <= FSM_Clocks_I.Reset;

				
	trgfifo_we <= 	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
					'1' WHEN ((x"ffffffff" and FIT_GBT_status_I.Trigger_from_CRU) > 0) and (Readout_Mode_ff00 /= mode_IDLE) ELSE
					'0';
					
	trgfifo_re  <=	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
					'1' WHEN (FSM_STATE = s2_send_wpacket) and (cntpckws_state = s0_simpl_pcw) ELSE
					'0' WHEN (FSM_STATE = s2_send_wpacket) and (cntpckws_state = s0_simpl_pcw) and (wcnt_fullpck_ff >= max_data_packet_payload) ELSE
					'0';
					
						
						
						
	RAWFIFO_RE_O <= '0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
					'1' WHEN (FSM_STATE = s1_dread)	and (rdata_state /= s0_start) ELSE 
					'0';
					
				  
					  
					  
	slck_fifo_we <=	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
					'1' WHEN (FSM_STATE = s1_dread) and (rdata_state /= s0_start) and (is_sending_packet_ff = '1') ELSE
					'0';
	
	SLCTFIFO_data_word_O <= RAWFIFO_data_word_I;
	
						
	cntpckfifo_we <=	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
						'0' WHEN (Readout_Mode_manage = mode_IDLE) ELSE
						'1' WHEN (FSM_STATE = s2_send_wpacket) and (is_hb_response = '1') and (is_hb_response_s = '1') ELSE
						'1' WHEN (FSM_STATE = s2_send_wpacket) and (wcnt_fullpck_ff >= max_data_packet_payload) ELSE
						'0';
						

						
	cntpckfifo_data_toff <= (others => '0')		WHEN (FSM_Clocks_I.Reset = '1') ELSE
	
		func_CNTPCKword_get_word('1', pages_counter, wcnt_fullpck, TRG_const_void, ORBIT_const_void, BC_const_void, current_hb_orbit, current_hb_bc) 	-- close frame
		WHEN (FSM_STATE = s2_send_wpacket) and (cntpckws_state = s1_closefr_pcw) ELSE
				
		func_CNTPCKword_get_word('0', pages_counter, wcnt_fullpck, TRG_const_void, ORBIT_const_void, BC_const_void, current_hb_orbit, current_hb_bc)	-- data overload 
		WHEN (FSM_STATE = s2_send_wpacket) and (wcnt_fullpck_ff >= max_data_packet_payload) ELSE
		
		func_CNTPCKword_get_word('0', pages_counter, wcnt_fullpck, trgfifo_out_trigger, trgfifo_out_orbit, trgfifo_out_bc, current_hb_orbit, current_hb_bc)	-- trigger response
		WHEN (FSM_STATE = s2_send_wpacket) ELSE
		
		
		(others => '0');

							
							

							
							
-- Event counter ------------------------------------
reset_drop_counters <= Control_register_I.reset_drophit_counter;
-- reset_drop_counters <= 	  '1'	WHEN (FSM_Clocks_I.Reset = '1') ELSE
						  -- '1'	WHEN (FIT_GBT_status_I.Start_run = '1') ELSE
						  -- '0';
						  
data_rate_counter_next <= (others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
						  (others => '0') WHEN (FIT_GBT_status_I.BCID_from_CRU = x"001") ELSE
						  data_rate_counter + 1 WHEN (FSM_STATE = s1_dread) and (rdata_state = s1_header) and (is_sending_packet_ff = '1') ELSE
						  data_rate_counter;
						  
hits_send_porbit_next <= (others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
						data_rate_counter WHEN (FIT_GBT_status_I.BCID_from_CRU = x"000") ELSE
						hits_send_porbit;
							
						  

is_dropping_event	<=  '0' 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
						'0'		WHEN (Readout_Mode_manage = mode_IDLE) ELSE
						'1'		WHEN (FSM_STATE = s1_dread) and (rdata_state = s1_header) and (SLCTFIFO_Is_spacefpacket_I = '0') ELSE
--						'1'		WHEN (FSM_STATE = s1_dread) and (rdata_state = s1_header) and (data_header_orbit_ff /= current_hb_orbit) ELSE
						'0';

dropped_events_next <= 	(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
						(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
						dropped_events + 1	WHEN (is_dropping_event = '1') ELSE
						dropped_events;

last_dropped_orbit_next <= 	(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
							data_header_orbit_ff		WHEN (is_dropping_event = '1') ELSE
							last_dropped_orbit;

last_dropped_bc_next <= 		(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
								(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
								data_header_bc_ff			WHEN (is_dropping_event = '1') ELSE
								last_dropped_bc;

first_dropped_orbit_next <= (others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
							data_header_orbit_ff		WHEN (is_dropping_event = '1') and (last_dropped_orbit = ORBIT_const_void) ELSE
							first_dropped_orbit;

first_dropped_bc_next <= 	(others => '0') 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
							(others => '0') 	WHEN (reset_drop_counters = '1') ELSE
							data_header_bc_ff			WHEN (is_dropping_event = '1') and (last_dropped_orbit = ORBIT_const_void) ELSE
							first_dropped_bc;
							
							
  -- ****************************************************




end Behavioral;





















