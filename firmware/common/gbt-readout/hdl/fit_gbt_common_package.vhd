----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D.A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    10:29:21 08/11/2017 
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
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all ;

package fit_gbt_common_package is

-- ===== CONSTANTS =============================================

	constant ENABLED										: integer := 1;
	constant DISABLED										: integer := 0;

-- data size constants -----------------------------------------
	constant GBT_data_word_bitdepth	: integer := 80;
	constant GBT_slowcntr_bitdepth	: integer := 4;
	constant Orbit_id_bitdepth		: integer := 32;
	constant BC_id_bitdepth			: integer := 12;
	constant Trigger_bitdepth		: integer := 32;
	constant rx_phase_bitdepth		: integer := 3;
	constant RDH_pages_counter_bitdepth	: integer := 16;
	constant FEE_ID_bitdepth		: integer := 16;
	constant PAR_bitdepth		    : integer := 16;
	constant DETFIELD_bitdepth		: integer := 16;
	
	constant n_pckt_wrds_bitdepth	: integer := 8;
	constant GEN_count_bitdepth		: integer := 16;
-- -------------------------------------------------------------

	constant GEN_const_void	       : std_logic_vector(GEN_count_bitdepth-1 downto 0) := x"0000";
	constant GEN_const_full	       : std_logic_vector(GEN_count_bitdepth-1 downto 0) := x"ffff";
	constant ORBIT_const_void      : std_logic_vector(Orbit_id_bitdepth-1 downto 0) := (others => '0');
	constant BC_const_void     	   : std_logic_vector(BC_id_bitdepth-1 downto 0) := (others => '0');


-- Trigger constants -------------------------------------------
	-- constant TRG_const_void		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000000";
	-- constant TRG_const_Orbit	: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000001";
	-- constant TRG_const_HB		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000002";
	-- constant TRG_const_HC		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000003";
	-- constant TRG_const_Ph		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000010";
	-- constant TRG_const_SOT		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000080";
	-- constant TRG_const_EOT		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000100";
	-- constant TRG_const_SOC		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000200";
	-- constant TRG_const_EOC		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000400";
	-- constant TRG_const_ORBCrsv	: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"0000000f";
	-- constant TRG_const_response	: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"ffffffff";
	
	constant TRG_const_void		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000000";
	constant TRG_const_Orbit	: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000001"; --0
	constant TRG_const_HB		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000002"; --1
	constant TRG_const_HBr		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000004"; --2
	constant TRG_const_HC		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000008"; --3
	constant TRG_const_Ph		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000010"; --4
	constant TRG_const_PP		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000020"; --5
	constant TRG_const_Cal		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000040"; --6
	constant TRG_const_SOT		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000080"; --7
	constant TRG_const_EOT		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000100"; --8
	constant TRG_const_SOC		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000200"; --9
	constant TRG_const_EOC		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000400"; --10
	constant TRG_const_TF		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000800"; -- time frame delimiter
	constant TRG_const_FErst	: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00001000"; -- FEE reset
	constant TRG_const_RT		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00002000"; -- Run Type; 1=Cont, 0=Trig
	constant TRG_const_RS		: std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00004000"; --Running State; 1=Running
-- -------------------------------------------------------------



-- Experiment constants ----------------------------------------
	constant LHC_BCID_max	       : std_logic_vector(BC_id_bitdepth-1 downto 0) := x"deb";
-- -------------------------------------------------------------


-- DAQ Constants -----------------------------------------------
--constant data_word_cnst_SOP : std_logic_vector(GBT_data_word_bitdepth-1 downto 0) := x"10000000000000000000"; -- SOP CRU
constant data_word_cnst_SOP : std_logic_vector(GBT_data_word_bitdepth-1 downto 0) :=   x"00000000000000000001"; -- SOP G-RORC

--constant data_word_cnst_EOP : std_logic_vector(GBT_data_word_bitdepth-1 downto 0) := x"20000000000000000000"; -- eop CRU
constant data_word_cnst_EOP : std_logic_vector(GBT_data_word_bitdepth-1 downto 0) :=   x"00000000000000000002"; -- eop G-RORC

-- -------------------------------------------------------------


-- FIFO constants ----------------------------------------------
	-- raw_data_fifo
	constant fifo_data_bitdepth		: integer := GBT_data_word_bitdepth;
	constant rawfifo_depth			: integer := 4096;
	constant rawfifo_count_bitdepth	: integer := 13;
	constant slctfifo_depth			: integer := 4096;
	constant slctfifo_count_bitdepth	: integer := 13;
	-- trg_fifo_comt
	constant trgfifo_data_bitdepth	: integer := Orbit_id_bitdepth+BC_id_bitdepth+Trigger_bitdepth; --76
	constant trgfifo_depth			: integer := 512;
	constant trgfifo_count_bitdepth	: integer := 10;
	-- cntpck_fifo_comp
	constant cntpckfifo_data_bitdepth	: integer := GEN_count_bitdepth+RDH_pages_counter_bitdepth+Orbit_id_bitdepth+BC_id_bitdepth+Orbit_id_bitdepth+BC_id_bitdepth+Trigger_bitdepth + 8; -- 8+16+16+76 + 44 = 160
	constant cntpckfifo_depth			: integer := 128;
	constant cntpckfifo_count_bitdepth	: integer := 8;
	
	
	
-- -------------------------------------------------------------

-- =============================================================





-- ===== FIT GBT Readout types =================================
	type FSM_Clocks_type is record
		Reset 			: std_logic;
		Reset40 		: std_logic;
		Data_Clk 		: std_logic;
		System_Clk		: std_logic;
		System_Counter	: std_logic_vector(3 downto 0);
	end record;
	
-- FSM_Clocks_I.Reset
-- FSM_Clocks_I.Data_Clk
-- FSM_Clocks_I.System_Clk
-- FSM_Clocks_I.System_Counter
-- =============================================================




-- ===== CONTROL REGISTER ======================================
	constant cntr_reg_n_32word		: integer := 13;
	type cntr_reg_addrreg_type is array (0 to cntr_reg_n_32word-1) of std_logic_vector(31 downto 0);
	
	type Type_Gen_use_type is (use_NO_generator, use_MAIN_generator, use_TX_generator);
	type Data_Gen_CONTROL_type is record
		usage_generator 	: Type_Gen_use_type;
		trigger_resp_mask 	: std_logic_vector(Trigger_bitdepth-1 downto 0); 	-- data generated for this trigger
		bunch_pattern 		: std_logic_vector(31 downto 0);					-- pattern lenghts of packet 
		bunch_freq 			: std_logic_vector(15 downto 0);					-- pattern frequency
		bunch_freq_hboffset : std_logic_vector(BC_id_bitdepth-1 downto 0);		-- offset of freq counter to first Orbit TRG
	end record;
	
	
	type Type_trgGen_use_type is (use_NO_generator, use_CONT_generator);
	type Readout_command_type is (idle, continious, trigger);

	type Trigger_Gen_CONTROL_type is record
		usage_generator : Type_trgGen_use_type;
		Readout_command : Readout_command_type;
		trigger_single_val 	: std_logic_vector(Trigger_bitdepth-1 downto 0);	-- send this trigger (once then moved from 0->1)
		trigger_pattern 	: std_logic_vector(63 downto 0);					-- trigger pattern 32 BC lenght
		trigger_cont_value	: std_logic_vector(Trigger_bitdepth-1 downto 0);	-- trigger that sendign continious
		bunch_freq 			: std_logic_vector(15 downto 0);					-- trigger frequency
		bunch_freq_hboffset : std_logic_vector(BC_id_bitdepth-1 downto 0);		-- offset of freq counter to first Orbit TRG
	end record;
	
	type RDH_data_type is record
		FEE_ID 			: std_logic_vector(FEE_ID_bitdepth-1 downto 0);		
		PAR 			: std_logic_vector(PAR_bitdepth-1 downto 0);
		DET_Field 		: std_logic_vector(DETFIELD_bitdepth-1 downto 0);
	end record;
	
	type CONTROL_REGISTER_type is record
		Data_Gen 		: Data_Gen_CONTROL_type;
		Trigger_Gen 	: Trigger_Gen_CONTROL_type;
		RDH_data 		: RDH_data_type;
		
		readout_bypass  : std_logic;
		is_hb_response  : std_logic;
		trg_data_select : std_logic_vector(Trigger_bitdepth-1 downto 0);
		
		n_BCID_delay 	: std_logic_vector(BC_id_bitdepth-1 downto 0); -- delay between ID from TX and ID in module data
		crutrg_delay_comp 	: std_logic_vector(BC_id_bitdepth-1 downto 0); -- how long data keeped in raw fifo waiting trigger
		max_data_payload: std_logic_vector(GEN_count_bitdepth-1 downto 0);
		reset_orbc_synd : std_logic; -- sync ORBIT, BC to CRU then moved from 0->1
		reset_drophit_counter : std_logic; -- reset FIFO statistic then moved from 0->1
		reset_gen_offset: std_logic; -- reset generators offset
		reset_gbt_rxerror: std_logic; -- reset gbt rx error bit
		reset_gbt 		:std_logic; -- reset gbt (not ready)
		reset_rxph_error:std_logic; -- reset gbt (not ready)
		strt_rdmode_lock  : std_logic;
	end record;
	
	constant test_CONTROL_REG : CONTROL_REGISTER_type :=
	(
		Data_Gen => (
			usage_generator		=> use_TX_generator,
			--usage_generator	=> use_MAIN_generator,
			
			trigger_resp_mask 	=> TRG_const_void,
			bunch_pattern 		=> x"10e0766f",
			bunch_freq 			=> x"0deb",
			bunch_freq_hboffset => x"ddc"
			),
			
		Trigger_Gen => (
			usage_generator		=> use_CONT_generator,
			--usage_generator	=> use_NO_generator
			Readout_command		 => idle,
			trigger_single_val 		=> x"00000000",
			trigger_pattern 		=> x"0000000080000000",
			trigger_cont_value 			=> TRG_const_Ph,
			bunch_freq 				=> x"0deb",
			bunch_freq_hboffset 	=> x"ddc"
			),
		
		RDH_data => (
			FEE_ID 					=> x"0001",	
			PAR 					=> x"ffff",
			DET_Field 				=> x"1234"
			),
			
		readout_bypass              => '0',
	    is_hb_response              => '1',
        trg_data_select             => x"00000010",

		n_BCID_delay 				=> x"01f",
		crutrg_delay_comp 			=> x"00f",
		max_data_payload			=> x"00f0",
		reset_orbc_synd 			=> '0',
		reset_drophit_counter 		=> '0',
		reset_gen_offset			=> '0',
		reset_gbt_rxerror			=> '0',
		reset_gbt					=> '0',
		reset_rxph_error			=> '0',
		strt_rdmode_lock			=> '0'
	);	
-- =============================================================








-- ===== FIT GBT STATUS ========================================
	constant status_reg_n_32word		: integer := 8;
	type status_reg_addrreg_type is array (0 to status_reg_n_32word-1) of std_logic_vector(31 downto 0);
	
	type Type_Readout_Mode is (mode_IDLE, mode_CNT, mode_TRG);
	type Type_BCIDsync_Mode is (mode_STR, mode_SYNC, mode_LOST);
	
	type Type_GBT_status is record
		txWordClk             	: std_logic;	
		rxFrameClk            	: std_logic;	
		rxWordClk             	: std_logic;	
		txOutClkFabric			: std_logic;	
		
		mgt_phalin_cplllock		: std_logic;	--reg bit 0

		rxWordClkReady			: std_logic; 	--reg bit 1
		rxFrameClkReady       	: std_logic; 	--reg bit 2

		mgtLinkReady 			:std_logic;		--reg bit 3
		tx_resetDone 			:std_logic;		--reg bit 4
		tx_fsmResetDone 		:std_logic;		--reg bit 5
		
		gbtRx_Ready				:std_logic;		--reg bit 6
		gbtRx_ErrorDet	    	:std_logic;		--reg bit 7
		gbtRx_ErrorLatch    	:std_logic;		--reg bit 8
		
		Rx_Phase_error	    	:std_logic;		--reg bit 9
	end record;

	
	type FIFO_STATUS_type is record
		raw_fifo_count 				: std_logic_vector(rawfifo_count_bitdepth-1 downto 0);
		slct_fifo_count				: std_logic_vector(slctfifo_count_bitdepth-1 downto 0);
		trg_fifo_count				: std_logic_vector(trgfifo_count_bitdepth-1 downto 0);
		cntr_fifo_count				: std_logic_vector(cntpckfifo_count_bitdepth-1 downto 0);
	end record;
	
	type hit_rd_counter_type is record
		hits_send_porbit			: std_logic_vector(15 downto 0);
		hits_skipped				: std_logic_vector(31 downto 0);
		first_orbit_hdrop			: std_logic_vector(Orbit_id_bitdepth-1 downto 0);
		first_bc_hdrop				: std_logic_vector(BC_id_bitdepth-1 downto 0);
		last_orbit_hdrop			: std_logic_vector(Orbit_id_bitdepth-1 downto 0);
		last_bc_hdrop				: std_logic_vector(BC_id_bitdepth-1 downto 0);
	end record;
	
	
		
	type FIT_GBT_status_type is record
		GBT_status 					: Type_GBT_status;
		Readout_Mode 				: Type_Readout_Mode;
		CRU_Readout_Mode			: Type_Readout_Mode;
		BCIDsync_Mode 				: Type_BCIDsync_Mode;
		Start_run 					: std_logic;
		Stop_run 					: std_logic;
		
		Trigger_from_CRU 			: std_logic_vector(Trigger_bitdepth-1 downto 0); -- Trigger ID from CRUS
		BCID_from_CRU 				: std_logic_vector(BC_id_bitdepth-1 downto 0); -- BC ID from CRUS
		ORBIT_from_CRU 				: std_logic_vector(Orbit_id_bitdepth-1 downto 0); -- ORBIT from CRUS
		BCID_from_CRU_corrected 	: std_logic_vector(BC_id_bitdepth-1 downto 0); -- BC ID from CRUS
		ORBIT_from_CRU_corrected 	: std_logic_vector(Orbit_id_bitdepth-1 downto 0); -- ORBIT from CRUS
		
		fifo_status 				: FIFO_STATUS_type;
		hits_rd_counter_converter	: hit_rd_counter_type;
		hits_rd_counter_selector 	: hit_rd_counter_type;
		
		
		rx_phase : std_logic_vector(rx_phase_bitdepth-1 downto 0);

	end record;
-- =============================================================







-- ###################### CONVERSION FUNCTION ##############################
-- FIT data header, formed in converter ---------------------------
function func_FITDATAHD_get_header
(
        channel_n_words: std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
        ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);        
        BCID : std_logic_vector(BC_id_bitdepth-1 downto 0);
		rx_phase : std_logic_vector(rx_phase_bitdepth-1 downto 0);
		rx_phase_error : std_logic
)
return std_logic_vector;

function func_FITDATAHD_ndwords (header_w: std_logic_vector(fifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
function func_FITDATAHD_orbit (header_w: std_logic_vector(fifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
function func_FITDATAHD_bc (header_w: std_logic_vector(fifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
-- ----------------------------------------------------------------




-- Control word for FIT packet ------------------------------------
function func_CNTPCKword_get_word
(
		is_close_frame : std_logic;
		pages_counter : std_logic_vector(RDH_pages_counter_bitdepth-1 downto 0);
		n_words_in_packet : std_logic_vector(GEN_count_bitdepth-1 downto 0);
        TRIGGER: std_logic_vector(Trigger_bitdepth-1 downto 0);
        TRG_ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
        TRG_BCID : std_logic_vector(BC_id_bitdepth-1 downto 0);
        HB_ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);        
        HB_BCID : std_logic_vector(BC_id_bitdepth-1 downto 0)
)
return std_logic_vector;

function func_CNTPCKword_isclf (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic;
function func_CNTPCKword_npwords (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
function func_CNTPCKword_pgcounter (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
function func_CNTPCKword_trigger (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
function func_CNTPCKword_trgorbit (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
function func_CNTPCKword_trgbc (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
function func_CNTPCKword_hborbit (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
function func_CNTPCKword_hbbc (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector;
-- ----------------------------------------------------------------



-- Control Register addres reg ------------------------------------
function func_CNTRREG_getaddrreg (cntrl_reg: CONTROL_REGISTER_type ) return cntr_reg_addrreg_type;
function func_CNTRREG_getcntrreg (cntrl_reg_addrreg: cntr_reg_addrreg_type) return CONTROL_REGISTER_type;
function func_STATREG_getaddrreg (status_reg: FIT_GBT_status_type ) return status_reg_addrreg_type;
-- ----------------------------------------------------------------





-- #########################################################################

end fit_gbt_common_package;



package body fit_gbt_common_package is

-- ###################### CONVERSION FUNCTION ##############################



-- FIT data header, formed in converter ---------------------------
function func_FITDATAHD_get_header
(
        channel_n_words: std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
		ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);        
		BCID : std_logic_vector(BC_id_bitdepth-1 downto 0);
		rx_phase : std_logic_vector(rx_phase_bitdepth-1 downto 0);
		rx_phase_error : std_logic
)
return std_logic_vector is

begin
    --return  channel_n_words & x"000_0000" & ORBIT & BCID;
      return  x"F"&channel_n_words(3 downto 0) & x"000_00" & "000" & rx_phase_error & "0"&rx_phase & ORBIT & BCID;

end function;



function func_FITDATAHD_ndwords (header_w: std_logic_vector(fifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return x"0"&header_w(fifo_data_bitdepth-1-4 downto fifo_data_bitdepth-n_pckt_wrds_bitdepth); end function;

function func_FITDATAHD_orbit (header_w: std_logic_vector(fifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return header_w(BC_id_bitdepth+Orbit_id_bitdepth-1 downto BC_id_bitdepth); end function;

function func_FITDATAHD_bc (header_w: std_logic_vector(fifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return header_w(BC_id_bitdepth-1 downto 0); end function;
-- ----------------------------------------------------------------







-- Control word for FIT packet ------------------------------------
function func_CNTPCKword_get_word
(
		is_close_frame : std_logic;
		pages_counter : std_logic_vector(RDH_pages_counter_bitdepth-1 downto 0);
		n_words_in_packet : std_logic_vector(GEN_count_bitdepth-1 downto 0);
        TRIGGER: std_logic_vector(Trigger_bitdepth-1 downto 0);
        TRG_ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);        
        TRG_BCID : std_logic_vector(BC_id_bitdepth-1 downto 0);
        HB_ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);        
        HB_BCID : std_logic_vector(BC_id_bitdepth-1 downto 0)
)
return std_logic_vector is

begin
    return  "0000000" & is_close_frame & pages_counter & n_words_in_packet & TRIGGER & TRG_ORBIT & TRG_BCID & HB_ORBIT & HB_BCID;
end function;



function func_CNTPCKword_isclf (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic is
begin return cntpck_w(cntpckfifo_data_bitdepth-8); end function;

function func_CNTPCKword_npwords (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return cntpck_w(BC_id_bitdepth+Orbit_id_bitdepth+Trigger_bitdepth+GEN_count_bitdepth+BC_id_bitdepth+Orbit_id_bitdepth-1 downto BC_id_bitdepth+Orbit_id_bitdepth+Trigger_bitdepth+BC_id_bitdepth+Orbit_id_bitdepth); end function;

function func_CNTPCKword_pgcounter (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return cntpck_w(cntpckfifo_data_bitdepth-8-1 downto cntpckfifo_data_bitdepth-8-RDH_pages_counter_bitdepth); end function;

function func_CNTPCKword_trigger (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return cntpck_w(BC_id_bitdepth+Orbit_id_bitdepth+Trigger_bitdepth+BC_id_bitdepth+Orbit_id_bitdepth-1 downto BC_id_bitdepth+Orbit_id_bitdepth+BC_id_bitdepth+Orbit_id_bitdepth); end function;

function func_CNTPCKword_trgorbit (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return cntpck_w(BC_id_bitdepth+Orbit_id_bitdepth+BC_id_bitdepth+Orbit_id_bitdepth-1 downto BC_id_bitdepth+BC_id_bitdepth+Orbit_id_bitdepth); end function;

function func_CNTPCKword_trgbc (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return cntpck_w(BC_id_bitdepth+BC_id_bitdepth+Orbit_id_bitdepth-1 downto BC_id_bitdepth+Orbit_id_bitdepth); end function;

function func_CNTPCKword_hborbit (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return cntpck_w(BC_id_bitdepth+Orbit_id_bitdepth-1 downto BC_id_bitdepth); end function;

function func_CNTPCKword_hbbc (cntpck_w: std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0) ) return std_logic_vector is
begin return cntpck_w(BC_id_bitdepth-1 downto 0); end function;

-- ----------------------------------------------------------------











-- Control Register addres reg ------------------------------------
function func_CNTRREG_getaddrreg (cntrl_reg: CONTROL_REGISTER_type ) return cntr_reg_addrreg_type is

	variable cntr_reg_addrreg : cntr_reg_addrreg_type;
	variable data_gen_cntr : std_logic_vector( 3 downto 0 );
	variable trg_gen_cntr : std_logic_vector( 3 downto 0 );
	variable start_rd_command : std_logic_vector( 3 downto 0 );
	variable reset_contr	:std_logic_vector( 7 downto 0);
	

begin

	if cntrl_reg.Data_Gen.usage_generator = use_NO_generator then
		data_gen_cntr := x"0";
	elsif cntrl_reg.Data_Gen.usage_generator = use_MAIN_generator then
		data_gen_cntr := x"1";
	elsif cntrl_reg.Data_Gen.usage_generator = use_TX_generator then
		data_gen_cntr := x"2";
	else
		data_gen_cntr := x"f";
	end if;

	if cntrl_reg.Trigger_Gen.Readout_command = idle then
		start_rd_command := x"0";
	elsif cntrl_reg.Trigger_Gen.Readout_command = continious then
		start_rd_command := x"1";
	elsif cntrl_reg.Trigger_Gen.Readout_command = trigger then
		start_rd_command := x"2";
	else
		start_rd_command := x"f";
	end if;

	if cntrl_reg.Trigger_Gen.usage_generator = use_NO_generator then
		trg_gen_cntr := x"0";
	elsif cntrl_reg.Trigger_Gen.usage_generator = use_CONT_generator then
		trg_gen_cntr := x"1";
	else
		trg_gen_cntr := x"f";
	end if;

		
	reset_contr := "00" & cntrl_reg.reset_rxph_error & cntrl_reg.reset_gbt & cntrl_reg.reset_gbt_rxerror & cntrl_reg.reset_gen_offset & cntrl_reg.reset_drophit_counter & cntrl_reg.reset_orbc_synd;

	

cntr_reg_addrreg(0) := x"00" & "0"&cntrl_reg.strt_rdmode_lock&cntrl_reg.readout_bypass&cntrl_reg.is_hb_response & start_rd_command & reset_contr & trg_gen_cntr & data_gen_cntr;

cntr_reg_addrreg(1) := cntrl_reg.Data_Gen.trigger_resp_mask;
cntr_reg_addrreg(2) := cntrl_reg.Data_Gen.bunch_pattern;
cntr_reg_addrreg(3) := cntrl_reg.Trigger_Gen.trigger_single_val;
cntr_reg_addrreg(4) := cntrl_reg.Trigger_Gen.trigger_pattern(63 downto 32);
cntr_reg_addrreg(5) := cntrl_reg.Trigger_Gen.trigger_pattern(31 downto 0);
cntr_reg_addrreg(6) := cntrl_reg.Trigger_Gen.trigger_cont_value;
cntr_reg_addrreg(7) := cntrl_reg.Trigger_Gen.bunch_freq & cntrl_reg.Data_Gen.bunch_freq;
cntr_reg_addrreg(8) := x"0"&cntrl_reg.Trigger_Gen.bunch_freq_hboffset & x"0"&cntrl_reg.Data_Gen.bunch_freq_hboffset;

cntr_reg_addrreg(9) := cntrl_reg.RDH_data.FEE_ID & cntrl_reg.RDH_data.PAR;
cntr_reg_addrreg(10) := cntrl_reg.max_data_payload & cntrl_reg.RDH_data.DET_Field;

cntr_reg_addrreg(11) := x"0"&cntrl_reg.crutrg_delay_comp & x"0"&cntrl_reg.n_BCID_delay;
cntr_reg_addrreg(12) := cntrl_reg.trg_data_select;

return cntr_reg_addrreg;

end function;





function func_CNTRREG_getcntrreg (cntrl_reg_addrreg: cntr_reg_addrreg_type) return CONTROL_REGISTER_type is

variable cntr_reg : CONTROL_REGISTER_type;

begin

	if( cntrl_reg_addrreg(0)(3 downto 0) = x"0" ) then
		cntr_reg.Data_Gen.usage_generator := use_NO_generator;
	elsif( cntrl_reg_addrreg(0)(3 downto 0) = x"1" ) then
		cntr_reg.Data_Gen.usage_generator := use_MAIN_generator;
	elsif( cntrl_reg_addrreg(0)(3 downto 0) = x"2" ) then
		cntr_reg.Data_Gen.usage_generator := use_TX_generator;
	else
		cntr_reg.Data_Gen.usage_generator := use_NO_generator;
	end if;

	
	
	if( cntrl_reg_addrreg(0)(19 downto 16) = x"0" ) then
		cntr_reg.Trigger_Gen.Readout_command := idle;
	elsif( cntrl_reg_addrreg(0)(19 downto 16) = x"1" ) then
		cntr_reg.Trigger_Gen.Readout_command := continious;
	elsif( cntrl_reg_addrreg(0)(19 downto 16) = x"2" ) then
		cntr_reg.Trigger_Gen.Readout_command := trigger;
	else
		cntr_reg.Trigger_Gen.Readout_command := idle;
	end if;

	

	if( cntrl_reg_addrreg(0)(7 downto 4) = x"0" ) then
		cntr_reg.Trigger_Gen.usage_generator := use_NO_generator;
	elsif( cntrl_reg_addrreg(0)(7 downto 4) = x"1" ) then
		cntr_reg.Trigger_Gen.usage_generator := use_CONT_generator;
	else
		cntr_reg.Trigger_Gen.usage_generator := use_NO_generator;
	end if;

	cntr_reg.is_hb_response 				:=  cntrl_reg_addrreg(0)(20);
    cntr_reg.readout_bypass                 :=  cntrl_reg_addrreg(0)(21);
    cntr_reg.strt_rdmode_lock               :=  cntrl_reg_addrreg(0)(22);
	
	cntr_reg.reset_orbc_synd 				:=  cntrl_reg_addrreg(0)(8);
	cntr_reg.reset_drophit_counter			:=  cntrl_reg_addrreg(0)(9);
	cntr_reg.reset_gen_offset				:=  cntrl_reg_addrreg(0)(10);
	cntr_reg.reset_gbt_rxerror				:=  cntrl_reg_addrreg(0)(11);
	cntr_reg.reset_gbt						:=  cntrl_reg_addrreg(0)(12);
	cntr_reg.reset_rxph_error				:=  cntrl_reg_addrreg(0)(13);

	
	cntr_reg.Data_Gen.trigger_resp_mask 		:= cntrl_reg_addrreg(1);
	cntr_reg.Data_Gen.bunch_pattern 			:= cntrl_reg_addrreg(2);
	cntr_reg.Trigger_Gen.trigger_single_val 	:= cntrl_reg_addrreg(3);
	cntr_reg.Trigger_Gen.trigger_pattern(63 downto 32) 		:= cntrl_reg_addrreg(4);
	cntr_reg.Trigger_Gen.trigger_pattern(31 downto 0) 		:= cntrl_reg_addrreg(5);
	cntr_reg.Trigger_Gen.trigger_cont_value 	:= cntrl_reg_addrreg(6);

	
	cntr_reg.Trigger_Gen.bunch_freq			    :=  cntrl_reg_addrreg(7)(31 downto 16);
	cntr_reg.Data_Gen.bunch_freq				:=  cntrl_reg_addrreg(7)(15 downto 0);
	
	cntr_reg.Trigger_Gen.bunch_freq_hboffset	:=  cntrl_reg_addrreg(8)(27 downto 16);
	cntr_reg.Data_Gen.bunch_freq_hboffset		:=  cntrl_reg_addrreg(8)(11 downto 0);
	
	cntr_reg.RDH_data.FEE_ID					:=  cntrl_reg_addrreg(9)(31 downto 16);
	cntr_reg.RDH_data.PAR						:=  cntrl_reg_addrreg(9)(15 downto 0);
	
	cntr_reg.max_data_payload			        :=  cntrl_reg_addrreg(10)(31 downto 16);
	cntr_reg.RDH_data.DET_Field				    :=  cntrl_reg_addrreg(10)(15 downto 0);
	
	cntr_reg.crutrg_delay_comp					:=  cntrl_reg_addrreg(11)(27 downto 16);
	cntr_reg.n_BCID_delay						:=  cntrl_reg_addrreg(11)(11 downto 0);
	
	cntr_reg.trg_data_select                    :=  cntrl_reg_addrreg(12)(31 downto 0);
	
	return cntr_reg;
end function;





function func_STATREG_getaddrreg (status_reg: FIT_GBT_status_type ) return status_reg_addrreg_type is
	variable status_reg_addrreg : status_reg_addrreg_type;
	variable gbt_status		: std_logic_vector(15 downto 0);
	variable bcid_sync_mode	: std_logic_vector( 3 downto 0 );
	variable rd_mode 		: std_logic_vector( 3 downto 0 );
	variable cru_rd_mode 		: std_logic_vector( 3 downto 0 );
	variable slct_fifo_count_reg	: std_logic_vector(15 downto 0);
	variable raw_fifo_count_reg		: std_logic_vector(15 downto 0);

begin


	gbt_status :=	"000000" 
				&	status_reg.GBT_status.Rx_Phase_error
				&	status_reg.GBT_status.gbtRx_ErrorLatch
				&	status_reg.GBT_status.gbtRx_ErrorDet
				&	status_reg.GBT_status.gbtRx_Ready
				&	status_reg.GBT_status.tx_fsmResetDone
				&	status_reg.GBT_status.tx_resetDone
				&	status_reg.GBT_status.mgtLinkReady
				&	status_reg.GBT_status.rxFrameClkReady
				&	status_reg.GBT_status.rxWordClkReady
				&	status_reg.GBT_status.mgt_phalin_cplllock;
				
				
	if status_reg.Readout_Mode = mode_IDLE then
		rd_mode := x"0";
	elsif status_reg.Readout_Mode = mode_CNT then
		rd_mode := x"1";
	elsif status_reg.Readout_Mode = mode_TRG then
		rd_mode := x"2";
	else
		rd_mode := x"f";
	end if;

	if status_reg.CRU_Readout_Mode = mode_IDLE then
		cru_rd_mode := x"0";
	elsif status_reg.CRU_Readout_Mode = mode_CNT then
		cru_rd_mode := x"1";
	elsif status_reg.CRU_Readout_Mode = mode_TRG then
		cru_rd_mode := x"2";
	else
		cru_rd_mode := x"f";
	end if;

	if status_reg.BCIDsync_Mode = mode_STR then
		bcid_sync_mode := x"0";
	elsif status_reg.BCIDsync_Mode = mode_SYNC then
		bcid_sync_mode := x"1";
	elsif status_reg.BCIDsync_Mode = mode_LOST then
		bcid_sync_mode := x"2";
	else
		bcid_sync_mode := x"f";
	end if;
	
    slct_fifo_count_reg := "000" & status_reg.fifo_status.slct_fifo_count;
    raw_fifo_count_reg  := "000" & status_reg.fifo_status.raw_fifo_count;
    
    
    status_reg_addrreg(0) := cru_rd_mode & "0"&status_reg.rx_phase & bcid_sync_mode & rd_mode & gbt_status;
    status_reg_addrreg(1) := status_reg.ORBIT_from_CRU;
    status_reg_addrreg(2) :=  "00000" & status_reg.BCID_from_CRU;
    status_reg_addrreg(3) := slct_fifo_count_reg & raw_fifo_count_reg;
    status_reg_addrreg(4) := status_reg.hits_rd_counter_selector.first_orbit_hdrop;
    status_reg_addrreg(5) := status_reg.hits_rd_counter_selector.last_orbit_hdrop;
    status_reg_addrreg(6) := status_reg.hits_rd_counter_selector.hits_skipped;
    status_reg_addrreg(7) := x"0000" & status_reg.hits_rd_counter_selector.hits_send_porbit;


return status_reg_addrreg;
end function;


-- ----------------------------------------------------------------





-- #########################################################################
end fit_gbt_common_package;

