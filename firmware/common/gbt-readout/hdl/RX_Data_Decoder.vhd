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


entity RX_Data_Decoder is
    Port ( 
		FSM_Clocks_I : in FSM_Clocks_type;
		
		FIT_GBT_status_I	: in FIT_GBT_status_type;
		Control_register_I	: in CONTROL_REGISTER_type;  
		
		-- RX data @ DataClk, ff in RX sync
		RX_Data_I			: in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
		RX_IsData_I			: in STD_LOGIC; -- unused in tests
		
		ORBC_ID_from_CRU_O				: out std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0); -- EVENT ID from CRU
		ORBC_ID_from_CRU_corrected_O	: out std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0); -- EVENT ID to PM/TCM
		Trigger_O						: out std_logic_vector(Trigger_bitdepth-1 downto 0);
		
		BCIDsync_Mode_O					: out Type_BCIDsync_Mode;
		Readout_Mode_O					: out Type_Readout_Mode;
		CRU_Readout_Mode_O					: out Type_Readout_Mode;
		Start_run_O						: out std_logic;
		Stop_run_O						: out std_logic
	 );
end RX_Data_Decoder;

architecture Behavioral of RX_Data_Decoder is

	attribute keep : string;	

	signal STATE_SYNC, STATE_SYNC_NEXT  : Type_BCIDsync_Mode;
	signal STATE_RDMODE, STATE_RDMODE_NEXT  : Type_Readout_Mode;
	signal Start_run_ff, Start_run_ff_next : std_logic;
	signal Stop_run_ff, Stop_run_ff_next : std_logic;
	
	signal TRGTYPE_received_ff, TRGTYPE_received_ff_next : std_logic_vector(Trigger_bitdepth-1 downto 0);
	signal ORBC_ID_received_ff, ORBC_ID_received_ff_next : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
	
	-- transform received rx data to trigger and evid, in FIT_Readout used: ORBC_ID = OrID(32) & BCID(12)
	signal ORBC_ID_received : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
	signal TRGTYPE_received : std_logic_vector(Trigger_bitdepth-1 downto 0);
	signal TRGTYPE_ORBCrsv_ff, TRGTYPE_ORBCrsv_ff_next : boolean;
	
	signal EV_ID_counter : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
	signal EV_ID_counter_BC : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal EV_ID_counter_ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);

	signal ORBC_counter_init : std_logic;
	
	
	signal ORBC_ID_from_CRU_ff, ORBC_ID_from_CRU_ff_next						:  std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0); -- EVENT ID from CRU
	signal ORBC_ID_from_CRU_corrected_ff, ORBC_ID_from_CRU_corrected_ff_next	:  std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0); -- EVENT ID to PM/TCM
	signal Trigger_ff, Trigger_ff_next											:  std_logic_vector(Trigger_bitdepth-1 downto 0);
	signal Trigger_valid_bit : std_logic;
	signal CRU_readout_mode, CRU_readout_mode_next : Type_Readout_Mode;
	

	
	signal EV_ID_counter_corrected : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
	signal EV_ID_delay : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal EV_ID_counter_BC_corrected : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal EV_ID_counter_ORBIT_corrected : std_logic_vector(Orbit_id_bitdepth-1 downto 0);

	
	attribute keep of STATE_SYNC : signal is "true";
	attribute keep of TRGTYPE_received_ff : signal is "true";
	attribute keep of ORBC_ID_received_ff : signal is "true";
	attribute keep of EV_ID_counter : signal is "true";


begin

-- ***************************************************
	-- equetion define by CRU, must be also defined in RX data generator
	-- Orbit_ID(32) & x"0" & BC_IC(12) & TRGTYPE(32)
	
	
	ORBC_ID_received <= RX_Data_I(Trigger_bitdepth + Orbit_id_bitdepth + BC_id_bitdepth-1 downto Trigger_bitdepth) WHEN (RX_IsData_I = '1') ELSE
						(others => '0');
	TRGTYPE_received <= RX_Data_I(Trigger_bitdepth-1 downto 0) WHEN (Trigger_valid_bit = '1') ELSE
						(others => '0');
	Trigger_valid_bit <= (RX_Data_I(Trigger_bitdepth + Orbit_id_bitdepth + BC_id_bitdepth+1 downto Trigger_bitdepth + Orbit_id_bitdepth + BC_id_bitdepth) when (RX_IsData_I = '1') else '0';
	
						
	-- if recieved rx data contain Event counter
	TRGTYPE_ORBCrsv_ff_next <= (TRGTYPE_received and x"0000000f") /= TRG_const_void;
	ORBC_ID_received_ff_next <= ORBC_ID_received; -- delayed signal for comparison with counter
	
	BCIDsync_Mode_O <= STATE_SYNC;
	Readout_Mode_O <= STATE_RDMODE;
	CRU_Readout_Mode_O <= CRU_readout_mode;
	Start_run_O <= Start_run_ff;
	Stop_run_O <= Stop_run_ff;
		
	ORBC_ID_from_CRU_O <= ORBC_ID_from_CRU_ff;
	ORBC_ID_from_CRU_corrected_O <= ORBC_ID_from_CRU_corrected_ff;
	Trigger_O <= Trigger_ff;

-- ***************************************************
	
	
	

-- BC Counter ==================================================
	BC_counter_rxdecoder_comp : entity work.BC_counter
	port map (
		RESET_I			=> FSM_Clocks_I.Reset40,
		DATA_CLK_I		=> FSM_Clocks_I.Data_Clk,
		
		IS_INIT_I		=> ORBC_counter_init,
		ORBC_ID_INIT_I 	=> ORBC_ID_received,
			
		ORBC_ID_COUNT_O => EV_ID_counter,
		IS_Orbit_trg_O => open
	);
-- =============================================================

--	type Type_Readout_Mode is (mode_CNT, mode_TRG, mode_IDLE);
--	type Type_BCIDsync_Mode is (mode_STR, mode_SYNC, mode_LOST);

-- Data ff data clk **********************************
	process (FSM_Clocks_I.Data_Clk)
	begin

		IF(rising_edge(FSM_Clocks_I.Data_Clk) )THEN
			IF (FSM_Clocks_I.Reset40 = '1') THEN
				STATE_SYNC <= mode_STR;
				STATE_RDMODE <= mode_IDLE;
				CRU_readout_mode <= mode_IDLE;
				
				Start_run_ff <= '0';
				Stop_run_ff <= '0';
				
				TRGTYPE_ORBCrsv_ff <= false;
				
				TRGTYPE_received_ff <= (others => '0');
				ORBC_ID_received_ff <= (others => '0');
				
				
				
			ELSE
				STATE_SYNC <= STATE_SYNC_NEXT;
				STATE_RDMODE <= STATE_RDMODE_NEXT;
				CRU_readout_mode <= CRU_readout_mode_next;
				
				Start_run_ff <= Start_run_ff_next;
				Stop_run_ff <= Stop_run_ff_next;
				
				TRGTYPE_ORBCrsv_ff <= TRGTYPE_ORBCrsv_ff_next;
				
				TRGTYPE_received_ff <= TRGTYPE_received_ff_next;
				ORBC_ID_received_ff <= ORBC_ID_received_ff_next;
				
				ORBC_ID_from_CRU_ff <= ORBC_ID_from_CRU_ff_next;
				ORBC_ID_from_CRU_corrected_ff <= ORBC_ID_from_CRU_corrected_ff_next;
				Trigger_ff <= Trigger_ff_next;

			END IF;
		END IF;
		
	end process;
-- ***************************************************



-- FSM ***********************************************
STATE_RDMODE_NEXT <=	mode_IDLE WHEN (FSM_Clocks_I.Reset = '1') ELSE
						mode_IDLE WHEN (Control_register_I.strt_rdmode_lock = '1') ELSE
						mode_TRG WHEN (STATE_RDMODE = mode_IDLE) and ((TRGTYPE_received_ff and TRG_const_SOT) /= TRG_const_void) ELSE
						mode_TRG WHEN (STATE_RDMODE = mode_IDLE) and ((Trigger_ff and TRG_const_SOT) /= TRG_const_void) ELSE
						mode_CNT WHEN (STATE_RDMODE = mode_IDLE) and ((TRGTYPE_received_ff and TRG_const_SOC) /= TRG_const_void) ELSE
						mode_CNT WHEN (STATE_RDMODE = mode_IDLE) and ((Trigger_ff and TRG_const_SOC) /= TRG_const_void) ELSE
						mode_IDLE WHEN (STATE_RDMODE = mode_TRG) and ((Trigger_ff and TRG_const_EOT) /= TRG_const_void) ELSE
						mode_IDLE WHEN (STATE_RDMODE = mode_CNT) and ((Trigger_ff and TRG_const_EOC) /= TRG_const_void) ELSE
						STATE_RDMODE;

Start_run_ff_next <= 	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
						'1' WHEN ((Trigger_ff and TRG_const_SOC) /= TRG_const_void) ELSE
						'1' WHEN ((Trigger_ff and TRG_const_SOT) /= TRG_const_void) ELSE
						'0';

Stop_run_ff_next <= 	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
						'1' WHEN ((Trigger_ff and TRG_const_EOC) /= TRG_const_void) ELSE
						'1' WHEN ((Trigger_ff and TRG_const_EOT) /= TRG_const_void) ELSE
						'0';

-- SYNC FSM
STATE_SYNC_NEXT <=	mode_STR	WHEN (FSM_Clocks_I.Reset = '1') ELSE
--					mode_STR	WHEN (STATE_SYNC = mode_LOST) ELSE
					mode_STR    WHEN (Control_register_I.strt_rdmode_lock = '1') ELSE
					mode_STR	WHEN (Control_register_I.reset_orbc_synd = '1') ELSE
					mode_SYNC	WHEN TRGTYPE_ORBCrsv_ff_next and (STATE_SYNC = mode_STR) ELSE
					mode_LOST	WHEN (EV_ID_counter /= ORBC_ID_received_ff) and (STATE_SYNC = mode_SYNC) and TRGTYPE_ORBCrsv_ff ELSE
					STATE_SYNC;

ORBC_counter_init <=	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
						'1' WHEN TRGTYPE_ORBCrsv_ff_next and (STATE_SYNC = mode_STR) ELSE
						'0';
						
TRGTYPE_received_ff_next <= (others => '0')		WHEN (FSM_Clocks_I.Reset = '1') ELSE
							TRGTYPE_received	WHEN (STATE_SYNC = mode_SYNC) ELSE
							(others => '0');
						
ORBC_ID_from_CRU_ff_next <=	(others => '0')		WHEN (FSM_Clocks_I.Reset = '1') ELSE
						EV_ID_counter		WHEN STATE_SYNC = mode_SYNC ELSE
						(others => '0');
						
ORBC_ID_from_CRU_corrected_ff_next <=	(others => '0')		WHEN (FSM_Clocks_I.Reset = '1') ELSE
								EV_ID_counter_corrected		WHEN STATE_SYNC = mode_SYNC ELSE
								(others => '0');
						

						
-- Event ID delayed (corrected)
EV_ID_delay <= Control_register_I.n_BCID_delay;

EV_ID_counter_BC <= EV_ID_counter(BC_id_bitdepth-1 downto 0);
EV_ID_counter_ORBIT <= EV_ID_counter(Orbit_id_bitdepth + BC_id_bitdepth-1 downto BC_id_bitdepth);

EV_ID_counter_BC_corrected <= (EV_ID_counter_BC + EV_ID_delay) WHEN (EV_ID_counter_BC + EV_ID_delay) <= LHC_BCID_max ELSE
        EV_ID_counter_BC + EV_ID_delay - LHC_BCID_max - 1;

EV_ID_counter_ORBIT_corrected <= EV_ID_counter_ORBIT WHEN EV_ID_counter_BC + EV_ID_delay <= LHC_BCID_max ELSE
        EV_ID_counter_ORBIT + 1;

EV_ID_counter_corrected <= EV_ID_counter_ORBIT_corrected & EV_ID_counter_BC_corrected;
-- ***************************************************


Trigger_ff_next <= TRGTYPE_received_ff;


CRU_readout_mode_next <= CRU_readout_mode WHEN (STATE_SYNC /= mode_SYNC) or (Trigger_valid_bit = '0') ELSE
						 mode_IDLE WHEN (TRGTYPE_received and TRG_const_RS) = TRG_const_void ELSE
						 mode_TRG WHEN (TRGTYPE_received and TRG_const_RT) = TRG_const_void ELSE
						 mode_CNT WHEN (TRGTYPE_received and TRG_const_RT) /= TRG_const_void ELSE
						 CRU_readout_mode;
	
end Behavioral;
























































