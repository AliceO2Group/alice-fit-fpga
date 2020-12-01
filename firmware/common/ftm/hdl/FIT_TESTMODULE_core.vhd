----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:15 01/30/2017 
-- Design Name: 
-- Module Name:    TX_Data_Gen - Behavioral 
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

entity FIT_TESTMODULE_core is
    Port (
		FSM_Clocks_I 	: in FSM_Clocks_type;
				
		GBTRX_IsData_rxclk_I 	: in STD_LOGIC;
		GBTRX_Data_rxclk_I 	: in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
		
		GBTTX_IsData_dataclk_O 	: out STD_LOGIC;
		GBTTX_Data_dataclk_O 	: out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
		
		hdmi_fifo_datain_I : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
        hdmi_fifo_wren_I : in std_logic;
        hdmi_fifo_wrclk_I : in std_logic;

		GBT_Status_I : in Type_GBT_status;

		TESTM_status_O : out FIT_GBT_status_type;
		Control_register_O	: out CONTROL_REGISTER_type;

		IPBUS_rst_I : in std_logic;
		IPBUS_data_out_O : out STD_LOGIC_VECTOR (31 downto 0);
		IPBUS_data_in_I : in STD_LOGIC_VECTOR (31 downto 0);
		IPBUS_addr_sel_I : in STD_LOGIC;
		IPBUS_addr_I : in STD_LOGIC_VECTOR(11 downto 0);
		IPBUS_iswr_I : in std_logic;
		IPBUS_isrd_I : in std_logic;
		IPBUS_ack_O : out std_logic;
		IPBUS_err_O : out std_logic;
		IPBUS_base_addr_I : in STD_LOGIC_VECTOR(11 downto 0)
	);
end FIT_TESTMODULE_core;

architecture Behavioral of FIT_TESTMODULE_core is



signal TESTM_control : CONTROL_REGISTER_type;
signal TESTM_status : FIT_GBT_status_type;


signal Module_data_from_gen : board_data_type;
signal CRU_ORBC_RXData_from_gen : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
signal CRU_ORBC_IsRXData_from_gen : std_logic;
signal Data_from_TXgen : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
signal IsData_from_TXgen : std_logic;

signal FIFO_WE_from_cnvr : STD_LOGIC;
signal FIFO_data_word_from_cnvr : std_logic_vector(fifo_data_bitdepth-1 downto 0);

signal DATA_from_FIFO : std_logic_vector(159+32 downto 0);
signal GBT_cntr_data : std_logic_vector(95 downto 0);
signal DATA_FIFO_empty : std_logic;
signal FIFO_RDEN : std_logic;

signal is_space_for_packet_from_dtsndr : STD_LOGIC;


signal raw_data_fifo_words_count_rd : std_logic_vector(rawfifo_count_bitdepth-1 downto 0);
signal raw_data_fifo_words_count_wr : std_logic_vector(rawfifo_count_bitdepth-1 downto 0);
signal raw_data_fifo_data_tofifo : std_logic_vector(fifo_data_bitdepth-1 downto 0);
signal raw_data_fifo_data_fromfifo : std_logic_vector(fifo_data_bitdepth-1 downto 0);
signal raw_data_fifo_isempty : std_logic;
signal raw_data_fifo_wren : std_logic;
signal raw_data_fifo_rden : std_logic;
signal raw_data_fifo_space_is_for_packet : STD_LOGIC;
signal raw_data_fifo_reset : std_logic;

signal data_fifo_datain : std_logic_vector(GBT_data_word_bitdepth+16-1 downto 0);
signal data_fifo_count : std_logic_vector(10 downto 0);
signal data_fifo_wren : std_logic;
signal data_fifo_full : std_logic;

signal hdmi_fifo_dataout : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
signal hdmi_fifo_datain : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
signal hdmi_fifo_rden : std_logic;
signal hdmi_fifo_wren : std_logic;
signal hdmi_fifo_isempty : std_logic;

signal gbt_word_counter, gbt_word_counter_next : std_logic_vector(15 downto 0);


attribute keep : string;
attribute keep of FIFO_RDEN : signal is "true";
attribute keep of DATA_from_FIFO : signal is "true";
attribute keep of TESTM_control : signal is "true";
attribute keep of TESTM_status : signal is "true";

attribute keep of raw_data_fifo_wren : signal is "true";
attribute keep of raw_data_fifo_rden : signal is "true";
attribute keep of raw_data_fifo_isempty : signal is "true";
attribute keep of raw_data_fifo_data_tofifo : signal is "true";
attribute keep of raw_data_fifo_data_fromfifo : signal is "true";

attribute keep of gbt_word_counter : signal is "true";


attribute mark_debug : string;
attribute MARK_DEBUG of data_fifo_datain : signal is "TRUE";
attribute MARK_DEBUG of data_fifo_wren : signal is "TRUE";
attribute MARK_DEBUG of FIFO_RDEN : signal is "TRUE";
attribute MARK_DEBUG of DATA_from_FIFO : signal is "TRUE";
attribute MARK_DEBUG of gbt_word_counter : signal is "TRUE";
attribute MARK_DEBUG of data_fifo_count : signal is "TRUE";
attribute MARK_DEBUG of data_fifo_full : signal is "TRUE";




   COMPONENT fifo_generator_0 PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(95 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(191 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    rd_data_count : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC
  );
   END COMPONENT;

   

	
	
begin

Control_register_O <= TESTM_control;

-- status not produced in FTM
TESTM_status_O <= TESTM_status;
TESTM_status.BCIDsync_Mode <= mode_SYNC;
TESTM_status.Readout_Mode <= mode_CNT;

TESTM_status.BCID_from_CRU_corrected <= TESTM_status.BCID_from_CRU;
TESTM_status.ORBIT_from_CRU_corrected <= TESTM_status.ORBIT_from_CRU;

TESTM_status.GBT_Status <= GBT_Status_I;

raw_data_fifo_space_is_for_packet <= 	'1' when (unsigned(raw_data_fifo_words_count_wr) <= rawfifo_depth-total_data_words-1) else
										'0';



--raw_data_fifo_wren <= GBTRX_IsData_rxclk_I;
--raw_data_fifo_data_tofifo <= GBTRX_Data_rxclk_I;



-- DATA GENERATOR =====================================
Module_Data_Gen_comp : entity work.Module_Data_Gen
	
	Port map(
		FSM_Clocks_I 		=> FSM_Clocks_I,
		
		FIT_GBT_status_I	=> TESTM_status,
		Control_register_I	=> TESTM_control,
		
		Board_data_I		=> board_data_test_const,
		Board_data_O		=> Module_data_from_gen
		);		
-- =====================================================

-- Data Converter ===============================================
DataConverter_comp: entity work.DataConverter
    port map(
		FSM_Clocks_I => FSM_Clocks_I,

		FIT_GBT_status_I => TESTM_status,
		Control_register_I => TESTM_control,
		
		Board_data_I => Module_data_from_gen,
		
		FIFO_is_space_for_packet_I => is_space_for_packet_from_dtsndr,
		
		FIFO_WE_O => FIFO_WE_from_cnvr,
		FIFO_data_word_O => FIFO_data_word_from_cnvr,
		
		hits_rd_counter_converter_O => TESTM_status.hits_rd_counter_converter
		);
-- ===========================================================


---- Raw_data_fifo =============================================
--raw_data_fifo_comp : entity work.raw_data_fifo
--port map(
--           wr_clk        => FSM_Clocks_I.System_Clk,
--           rd_clk        => FSM_Clocks_I.Data_Clk,
--     	   wr_data_count => raw_data_fifo_words_count_wr,
--     	   rd_data_count => raw_data_fifo_words_count_rd,
--           rst           => raw_data_fifo_reset,
--           WR_EN 		 => raw_data_fifo_wren,
--           RD_EN         => raw_data_fifo_rden,
--           DIN           => raw_data_fifo_data_tofifo,
--           DOUT          => raw_data_fifo_data_fromfifo,
--           FULL          => open,
--           EMPTY         => raw_data_fifo_isempty
--        );
---- ===========================================================



-- GBT data sender ===========================================
GBT_DATA_sender_comp : entity work.GBT_DATA_sender
port map(
	FSM_Clocks_I            => FSM_Clocks_I,

	FIT_GBT_status_I	    => TESTM_status,
    Control_register_I      => TESTM_control,
    
    Is_spade_for_packet_O     => is_space_for_packet_from_dtsndr,
    
    RX_IsData_ORBCgen_I     => CRU_ORBC_IsRXData_from_gen,
    RX_Data_ORBCgen_I       => CRU_ORBC_RXData_from_gen,
    
    DATA_converter_I        => FIFO_data_word_from_cnvr,
    FIFO_WE_converter_I     => FIFO_WE_from_cnvr,

	IsData_O   		    => GBTTX_IsData_dataclk_O,
    Data_O             => GBTTX_Data_dataclk_O
    );
-- ===========================================================

-- TX Data Gen ===============================================
TX_Data_Gen_comp : entity work.TX_Data_Gen
port map(
			FSM_Clocks_I => FSM_Clocks_I,
			
			FIT_GBT_status_I	    => TESTM_status,
			Control_register_I      => TESTM_control,
			
			TX_IsData_I => '0',
			TX_Data_I => (others => '0'),
			
			RAWFIFO_data_word_I => (others => '0'),
			RAWFIFO_Is_Empty_I => '1',
			RAWFIFO_RE_O => open,
			
			TX_IsData_O => IsData_from_TXgen,
			TX_Data_O => Data_from_TXgen
		);
-- ===========================================================


-- CRU ORBC GENERATOR ==================================
CRU_ORBC_Gen_comp : entity work.CRU_ORBC_Gen
	
	Port map(
		FSM_Clocks_I 		=> FSM_Clocks_I,
		
		FIT_GBT_status_I	=> TESTM_status,
		Control_register_I	=> TESTM_control,
		
		RX_IsData_I 		=> IsData_from_TXgen,
		RX_Data_I 			=> Data_from_TXgen,
		
		RX_IsData_O 		=> CRU_ORBC_IsRXData_from_gen,
		RX_Data_O 			=> CRU_ORBC_RXData_from_gen,
		
		Current_BCID_from_O => TESTM_status.BCID_from_CRU,
		Current_ORBIT_from_O=> TESTM_status.ORBIT_from_CRU,
		Current_Trigger_from_O => TESTM_status.Trigger_from_CRU

		);		
-- =====================================================

-- HDMI FIFO ===========================================
 hdmi_fifo_datain <= hdmi_fifo_datain_I;
 hdmi_fifo_wren <= hdmi_fifo_wren_I;
--hdmi_fifo_wren <= '1' when (gbt_word_counter(7 downto 4) = x"f") else '0';
--hdmi_fifo_datain <= x"daf0000000000000" & gbt_word_counter;


hdmi_fifo_rden <= '1' when (GBTRX_IsData_rxclk_I = '0') and (hdmi_fifo_isempty = '0') else '0';

hdmi_fifo_comp : entity work.raw_data_fifo
  PORT MAP (
    rst 	=> FSM_Clocks_I.Reset,
    wr_clk 	=> hdmi_fifo_wrclk_I,
    rd_clk 	=> FSM_Clocks_I.GBT_RX_Clk,
    din 	=> hdmi_fifo_datain,
    wr_en 	=> hdmi_fifo_wren,
    rd_en 	=> hdmi_fifo_rden,
    dout 	=> hdmi_fifo_dataout,
    full 	=> open,
    empty 	=> hdmi_fifo_isempty,
    rd_data_count => open,
    wr_rst_busy => open,
    rd_rst_busy => open
  );
-- =====================================================


-- DATA FIFO ===========================================
GBT_cntr_data <= gbt_word_counter & GBTRX_Data_rxclk_I;
data_fifo_datain <= GBT_cntr_data when (GBTRX_IsData_rxclk_I = '1') else gbt_word_counter & hdmi_fifo_dataout;
data_fifo_wren <= '1' when (GBTRX_IsData_rxclk_I = '1') or (hdmi_fifo_rden = '1') else '0';

fifo_generator_0_comp : fifo_generator_0
  PORT MAP (
    rst 	=> FSM_Clocks_I.Reset,
    wr_clk 	=> FSM_Clocks_I.GBT_RX_Clk,
    rd_clk 	=> FSM_Clocks_I.IPBUS_Data_Clk,
    din 	=> data_fifo_datain,
    wr_en 	=> data_fifo_wren,
    rd_en 	=> FIFO_RDEN,
    dout 	=> DATA_from_FIFO,
    full 	=> data_fifo_full,
    empty 	=> DATA_FIFO_empty,
    rd_data_count => TESTM_status.fifo_status.slct_fifo_count,
    wr_rst_busy => open,
    rd_rst_busy => open
  );
  -- TESTM_status.fifo_status.slct_fifo_count(10 downto 0) <= data_fifo_count;
  --TESTM_status.fifo_status.slct_fifo_count(slctfifo_count_bitdepth-1 downto 11) <= (others => '0');
  
  -- GBT counter ***********************************
      PROCESS (FSM_Clocks_I.GBT_RX_Clk)
      BEGIN
          IF(FSM_Clocks_I.GBT_RX_Clk'EVENT and FSM_Clocks_I.GBT_RX_Clk = '1') THEN
          
              IF(FSM_Clocks_I.Reset = '1') THEN
                  gbt_word_counter <= (others => '0');
              ELSE
                  gbt_word_counter <= gbt_word_counter_next;                  
              END IF;
              
          END IF;
      END PROCESS;
      
      gbt_word_counter_next <= (others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
                               gbt_word_counter WHEN (data_fifo_wren = '0') ELSE
                               (others => '0') WHEN (gbt_word_counter = x"ffff") ELSE
                               gbt_word_counter + 1;    

  -- ***************************************************

-- =====================================================







-- IP-BUS data sender ==================================
FIT_TESTMODULE_IPBUS_sender_comp : entity work.FIT_TESTMODULE_IPBUS_sender
    Port map(
		FSM_Clocks_I 		=> FSM_Clocks_I,
		
		FIT_GBT_status_I	=> TESTM_status,
		Control_register_O	=> TESTM_control,
		
		FIFO_Data_ibclk_I => DATA_from_FIFO,
		FIFO_empty_I => DATA_FIFO_empty,
		FIFO_RDEN_O => FIFO_RDEN,
		
		IPBUS_rst_I => IPBUS_rst_I,
		IPBUS_data_out_O => IPBUS_data_out_O,
		IPBUS_data_in_I => IPBUS_data_in_I,
		IPBUS_addr_sel_I => IPBUS_addr_sel_I,
		IPBUS_addr_I => IPBUS_addr_I,
		IPBUS_iswr_I => IPBUS_iswr_I,
		IPBUS_isrd_I => IPBUS_isrd_I,
		IPBUS_ack_O => IPBUS_ack_O,
		IPBUS_err_O => IPBUS_err_O,
		IPBUS_base_addr_I => IPBUS_base_addr_I
	);
-- =====================================================


end Behavioral;

