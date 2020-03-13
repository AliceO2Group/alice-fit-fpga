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


entity CRU_ORBC_Gen is
    Port ( 
		FSM_Clocks_I 		: in FSM_Clocks_type;
		
		FIT_GBT_status_I	: in FIT_GBT_status_type;
		Control_register_I	: in CONTROL_REGISTER_type;
				
		RX_IsData_I 		: in STD_LOGIC;
		RX_Data_I 			: in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
		
		RX_IsData_O 		: out STD_LOGIC;
		RX_Data_O 			: out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
		
		Current_BCID_from_O	: out std_logic_vector(BC_id_bitdepth-1 downto 0); -- BC ID from CRUS
		Current_ORBIT_from_O: out std_logic_vector(Orbit_id_bitdepth-1 downto 0); -- ORBIT from CRUS
        Current_Trigger_from_O	: out std_logic_vector(Trigger_bitdepth-1 downto 0)
	 );
end CRU_ORBC_Gen;

architecture Behavioral of CRU_ORBC_Gen is

	signal RX_Data_gen_ff, RX_Data_gen_ff_next 			: std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	signal RX_IsData_gen_ff, RX_IsData_gen_ff_next		: STD_LOGIC;
	
	signal EV_ID_counter_set : std_logic;
	signal EV_ID_counter		: std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
	signal IS_Orbit_trg_counter : std_logic;

	
    type readout_trg_type is (s0_wait_cmd, s1_trg_SOC, s1_trg_SOT, s1_trg_EOC, s1_trg_EOT, s2_cmd_send);
    signal rd_trg_send_mode, rd_trg_send_mode_next : readout_trg_type;
    signal is_rd_trg_send : std_logic;
    
	
    signal is_trigger_sending : std_logic; -- emulating CRU trigger messages
    signal TRG_evid	: std_logic_vector(Trigger_bitdepth-1 downto 0);
    signal TRG_readout_command	: std_logic_vector(Trigger_bitdepth-1 downto 0);
    signal TRG_result	: std_logic_vector(Trigger_bitdepth-1 downto 0);
	
	
	-- single trigger
	signal is_send_single_trg : std_logic;
	signal single_trg_val, single_trg_val_ff, single_trg_send_val : std_logic_vector(Trigger_bitdepth-1 downto 0);
	
	-- continious trigger
	signal cont_trg_value, cont_trg_send : std_logic_vector(Trigger_bitdepth-1 downto 0);
	signal cont_trg_bunch_mask : std_logic_vector(64 downto 0);
	signal cont_trg_bunch_mask_comp : std_logic;
	-- type cont_trg_bunch_mask_mux_type is array (0 to 64) of std_logic;
	-- signal cont_trg_bunch_mask_mux : cont_trg_bunch_mask_mux_type;
	signal bunch_freq : std_logic_vector(15 downto 0);
	signal bunch_freq_hboffset : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal reset_offset : std_logic;

	signal bfreq_counter, bfreq_counter_next : std_logic_vector(15 downto 0);
	signal bpattern_counter, bpattern_counter_next : integer := 0;
	signal is_boffset_sync, is_boffset_sync_next : std_logic;
	signal is_sentd_cont_trg : std_logic;

	-- single trigger
	signal trigger_single_val 	: std_logic_vector(Trigger_bitdepth-1 downto 0);	-- send this trigger (once then moved from 0->1)

	
	attribute keep : string;	
	attribute keep of bfreq_counter : signal is "true";
	attribute keep of bpattern_counter : signal is "true";
	attribute keep of is_sentd_cont_trg : signal is "true";
	attribute keep of is_boffset_sync : signal is "true";
	attribute keep of bunch_freq : signal is "true";


	

begin
	trigger_single_val <= Control_register_I.Trigger_Gen.trigger_single_val;
	cont_trg_value <= Control_register_I.Trigger_Gen.trigger_cont_value;
	cont_trg_bunch_mask <= '0' & Control_register_I.Trigger_Gen.trigger_pattern;
	bunch_freq <= Control_register_I.Trigger_Gen.bunch_freq; -- first packet in bunch = bunch_freq_hboffset + delay
	bunch_freq_hboffset <= Control_register_I.Trigger_Gen.bunch_freq_hboffset;

	single_trg_val <=  Control_register_I.Trigger_Gen.trigger_single_val;

-- ***************************************************
	RX_Data_O <= RX_Data_I 				WHEN (Control_register_I.Trigger_Gen.usage_generator = use_NO_generator) ELSE RX_Data_gen_ff;
	RX_IsData_O <= RX_IsData_I 			WHEN (Control_register_I.Trigger_Gen.usage_generator = use_NO_generator) ELSE RX_IsData_gen_ff;
-- ***************************************************

Current_BCID_from_O <= EV_ID_counter(BC_id_bitdepth-1 downto 0);
Current_ORBIT_from_O <= EV_ID_counter(Orbit_id_bitdepth + BC_id_bitdepth-1 downto BC_id_bitdepth);
Current_Trigger_from_O <= TRG_result;


-- BC Counter ==================================================
	BC_counter_datagen_comp : entity work.BC_counter
	port map (
		RESET_I			=> FSM_Clocks_I.Reset,
		DATA_CLK_I		=> FSM_Clocks_I.Data_Clk,
		
		IS_INIT_I		=> EV_ID_counter_set,
		ORBC_ID_INIT_I 	=> (others => '0'),
			
		ORBC_ID_COUNT_O => EV_ID_counter,
		IS_Orbit_trg_O	=> IS_Orbit_trg_counter
	);
-- =============================================================


-- MUX =========================================================
    -- process is
    -- begin
 
        -- for i in 0 to 63 loop
			-- cont_trg_bunch_mask_mux(i) <= cont_trg_bunch_mask(i);
        -- end loop;
        -- wait;
         
    -- end process;
    -- cont_trg_bunch_mask_mux(64) <= '0';
--    cont_trg_bunch_mask(64) <= '0';
	cont_trg_bunch_mask_comp <= cont_trg_bunch_mask(bpattern_counter);
-- =============================================================
	

-- Data ff data clk **********************************
	process (FSM_Clocks_I.Data_Clk)
	begin

		IF(rising_edge(FSM_Clocks_I.Data_Clk) )THEN
			IF (FSM_Clocks_I.Reset = '1') THEN
				RX_Data_gen_ff 		<= (others => '0');
				RX_IsData_gen_ff	<= '0';
--				phtrg_counter_ff		<= (others => '0');
				rd_trg_send_mode <= s0_wait_cmd;
				
				bfreq_counter <= (others => '0');
				bpattern_counter <= 0;
				is_boffset_sync <= '0';
				
				single_trg_val_ff <= (others => '0');
				
			ELSE
				RX_Data_gen_ff		<= RX_Data_gen_ff_next;
				RX_IsData_gen_ff	<= RX_IsData_gen_ff_next;
--				phtrg_counter_ff	 <= phtrg_counter_ff_next;
				rd_trg_send_mode    <= rd_trg_send_mode_next;
				
				bfreq_counter		<= bfreq_counter_next;
				bpattern_counter	<= bpattern_counter_next;
				is_boffset_sync <= is_boffset_sync_next;
				
				single_trg_val_ff <= single_trg_val;
			END IF;
		END IF;
		
	end process;
-- ***************************************************



-- ***************************************************



---------- Counters ---------------------------------
reset_offset <= Control_register_I.reset_gen_offset; 
-- phtrg_counter_ff_next <= 	(others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
							-- (others => '0')	WHEN (phtrg_counter_ff = Control_register_I.Trigger_Gen.trigger_rate) ELSE
							-- phtrg_counter_ff + 1;

bfreq_counter_next <= 	(others => '0') 		WHEN (FSM_Clocks_I.Reset = '1') ELSE
						(others => '0') 		WHEN (bfreq_counter = bunch_freq-1) ELSE
						(others => '0') 		WHEN (bunch_freq = 0) ELSE
						bfreq_counter + 1 		WHEN (is_boffset_sync = '1') ELSE
						x"0001"			 		WHEN (is_boffset_sync = '0') and (EV_ID_counter(11 downto 0) = bunch_freq_hboffset) and (FIT_GBT_status_I.BCIDsync_Mode = mode_SYNC) ELSE
						(others => '0');

is_boffset_sync_next <= '0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
						'0' WHEN (reset_offset = '1') ELSE
						'1' WHEN (is_boffset_sync = '0') and (EV_ID_counter(11 downto 0) = bunch_freq_hboffset) and (FIT_GBT_status_I.BCIDsync_Mode = mode_SYNC) ELSE
						is_boffset_sync;

						
bpattern_counter_next <= 	0 		WHEN (FSM_Clocks_I.Reset = '1') ELSE
							0		WHEN (bfreq_counter = bunch_freq-1) ELSE
							64 		WHEN (is_boffset_sync = '0') ELSE
							64 		WHEN (bpattern_counter = 64) ELSE
							bpattern_counter + 1;
						
is_sentd_cont_trg <= 		'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
							'0' WHEN (FIT_GBT_status_I.BCIDsync_Mode /= mode_SYNC) ELSE
							'0' WHEN cont_trg_bunch_mask_comp = '0' ELSE
							'1' WHEN cont_trg_bunch_mask_comp = '1';
							
cont_trg_send <= 			(others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
							(others => '0') WHEN is_sentd_cont_trg = '0' ELSE
							cont_trg_value;
							
-- Event ID counter start
EV_ID_counter_set <=	'1' WHEN (bpattern_counter < 2) and (EV_ID_counter = x"00000000_000") ELSE
						'0';
						
---------- CRU TX data gen  -------------------------
TRG_result <= TRG_readout_command or TRG_evid or cont_trg_send or single_trg_send_val;
is_trigger_sending <= IS_Orbit_trg_counter or is_rd_trg_send or is_sentd_cont_trg or is_send_single_trg;





-- RX data
TRG_evid <=  (TRG_const_HB) WHEN (IS_Orbit_trg_counter = '1') ELSE
            (others => '0');


RX_Data_gen_ff_next <=	(others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
						(others => '0') WHEN (is_trigger_sending = '0') ELSE
						EV_ID_counter(Orbit_id_bitdepth + BC_id_bitdepth-1 downto BC_id_bitdepth) & x"0" & EV_ID_counter(BC_id_bitdepth-1 downto 0) & TRG_result;	

RX_IsData_gen_ff_next <=	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
							'1' WHEN (is_trigger_sending = '1') ELSE
							'0';

							
							
-- single trigger
is_send_single_trg <= '0' WHEN  (FSM_Clocks_I.Reset = '1') ELSE
					  '1' WHEN (single_trg_val /= x"00000000") and (single_trg_val_ff = x"00000000") ELSE
					  '0';
							
single_trg_send_val <= 	(others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
						single_trg_val  WHEN (single_trg_val /= x"00000000") and (single_trg_val_ff = x"00000000") ELSE
						(others => '0');
							
							
							
-- Readout trigger send
is_rd_trg_send <=   '1' WHEN (TRG_readout_command /= TRG_const_void) ELSE
                    '0';

TRG_readout_command <=  TRG_const_SOT WHEN (rd_trg_send_mode = s1_trg_SOT) and (IS_Orbit_trg_counter = '1') ELSE
                        TRG_const_EOT WHEN (rd_trg_send_mode = s1_trg_EOT) and (IS_Orbit_trg_counter = '1') ELSE
                        TRG_const_SOC WHEN (rd_trg_send_mode = s1_trg_SOC) and (IS_Orbit_trg_counter = '1') ELSE
                        TRG_const_EOC WHEN (rd_trg_send_mode = s1_trg_EOC) and (IS_Orbit_trg_counter = '1') ELSE
                        (others => '0');

rd_trg_send_mode_next <= s0_wait_cmd WHEN (FSM_Clocks_I.Reset = '1') ELSE
    s1_trg_SOT WHEN ((rd_trg_send_mode = s0_wait_cmd) and (Control_register_I.Trigger_Gen.Readout_command = send_SOT)) ELSE
    s1_trg_SOC WHEN ((rd_trg_send_mode = s0_wait_cmd) and (Control_register_I.Trigger_Gen.Readout_command = send_SOC)) ELSE
    s1_trg_EOT WHEN ((rd_trg_send_mode = s0_wait_cmd) and (Control_register_I.Trigger_Gen.Readout_command = send_EOT)) ELSE
    s1_trg_EOC WHEN ((rd_trg_send_mode = s0_wait_cmd) and (Control_register_I.Trigger_Gen.Readout_command = send_EOC)) ELSE
	s2_cmd_send WHEN ((rd_trg_send_mode = s1_trg_SOT) or (rd_trg_send_mode = s1_trg_SOC) or (rd_trg_send_mode = s1_trg_EOT) or (rd_trg_send_mode = s1_trg_EOC)) and (is_rd_trg_send = '1') ELSE
    s0_wait_cmd WHEN (rd_trg_send_mode = s2_cmd_send) and (Control_register_I.Trigger_Gen.Readout_command = command_off) ELSE
    rd_trg_send_mode;




-- ***************************************************

end Behavioral;

