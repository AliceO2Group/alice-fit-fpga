----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D.A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    12:03:02 01/09/2017 
-- Design Name: 	FIT GBT
-- Module Name:    Data_Packager - Behavioral 
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;

use ieee.numeric_std.all;


entity Data_Packager is
    Port ( 
		FSM_Clocks_I : in FSM_Clocks_type;

		FIT_GBT_status_I : in FIT_GBT_status_type;
		Control_register_I : in CONTROL_REGISTER_type;  
		
		Board_data_I		: in board_data_type;
		
		TX_Data_O : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
		TX_IsData_O : out STD_LOGIC
	 );
end Data_Packager;

architecture Behavioral of Data_Packager is

	signal raw_fifo_dout : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	signal raw_fifo_empty : std_logic;
	signal raw_fifo_rden : std_logic;
	
	signal slct_fifo_cnt : std_logic_vector(12 downto 0);
	signal slct_fifo_din : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	signal slct_fifo_out : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	signal slct_fifo_empty : std_logic;
	signal slct_fifo_wren : std_logic;
	signal slct_fifo_rden : std_logic;
	signal slct_fifo_full : std_logic;
	
	
	signal data_from_cru_constructor : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	signal is_data_from_cru_constructor : STD_LOGIC;
	signal cntpck_fifo_data_fromfifo : std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0);
	signal cntpck_fifo_isempty : std_logic;
	signal cntpck_fifo_rden : std_logic;

	
	attribute keep : string;
	attribute keep of raw_fifo_cnt : signal is "true";
	
	
	

begin
--          readout_bypass_s <=Control_register_I.readout_bypass;

-- Data Converter ===============================================
DataConverter_comp: entity work.DataConverter
    port map(
		FSM_Clocks_I => FSM_Clocks_I,

		FIT_GBT_status_I => FIT_GBT_status_I,
		Control_register_I => Control_register_I,
		
		Board_data_I => Board_data_I,
		
		fifo_data_o => raw_fifo_dout,
		fifo_empty_o => raw_fifo_empty,
		fifo_rden_i => raw_fifo_rden,
		drop_ounter_o => open
		fifo_cnt_max_o => open
		);
-- ===========================================================


-- Slc_data_fifo =============================================
slct_data_fifo_comp : entity work.slct_data_fifo
port map(
           wr_clk        => FSM_Clocks_I.System_Clk,
           rd_clk        => FSM_Clocks_I.Data_Clk,
     	   wr_data_count => slct_data_fifo_words_count_wr,
           rst           => FSM_Clocks_I.Reset_dclk,
           WR_EN 		 => slct_data_fifo_wren,
           RD_EN         => slct_data_fifo_rden,
           DIN           => slct_data_fifo_data_tofifo,
           DOUT          => slct_data_fifo_data_fromfifo,
           FULL          => open,
           EMPTY         => slct_data_fifo_isempty
        );
-- ===========================================================

-- Event Selector ======================================
Event_Selector_comp : entity work.Event_Selector
port map	(
			FSM_Clocks_I => FSM_Clocks_I,
			
			FIT_GBT_status_I => FIT_GBT_status_I,
			Control_register_I => Control_register_I,
		
			RAWFIFO_data_word_I => raw_fifo_dout,
			RAWFIFO_Is_Empty_I => raw_fifo_empty,
			RAWFIFO_data_count_I => (others => '0'),
			RAWFIFO_RE_O => open,
			RAWFIFO_RESET_O => open,
			
			SLCTFIFO_data_word_O => slct_data_fifo_data_tofifo,
			SLCTFIFO_Is_spacefpacket_I => slct_data_fifo_is_space_for_packet,
			SLCTFIFO_WE_O => slct_data_fifo_wren,
			SLCTFIFO_RESET_O => slct_data_fifo_reset,
			
			CNTPTFIFO_data_word_O => cntpck_fifo_data_fromfifo,
            CNTPFIFO_Is_Empty_O => cntpck_fifo_isempty,
			CNTPFIFO_count_O => open,
            CNTPFIFO_RE_I => cntpck_fifo_rden,
			
			TRGFIFO_count_O => open,
			
			hits_rd_counter_selector_O => hits_rd_counter_selector_O
			);
-- ===========================================================

-- CRU Packet Constructer ======================================
CRU_packet_Builder_comp : entity work.CRU_packet_Builder
port map	(
			FSM_Clocks_I => FSM_Clocks_I,
			
			FIT_GBT_status_I => FIT_GBT_status_I,
			Control_register_I => Control_register_I,
		
			SLCTFIFO_data_word_I => slct_data_fifo_data_fromfifo,
			SLCTFIFO_Is_Empty_I => slct_data_fifo_isempty,
			SLCTFIFO_RE_O => slct_data_fifo_rden,
			
			CNTPTFIFO_data_word_I => cntpck_fifo_data_fromfifo,
			CNTPFIFO_Is_Empty_I => cntpck_fifo_isempty,
			CNTPFIFO_RE_O => cntpck_fifo_rden,
			
			Is_Data_O => is_data_from_cru_constructor,
			Data_O => data_from_cru_constructor
			);
-- ===========================================================



-- TX Data Gen ===============================================
TX_Data_Gen_comp : entity work.TX_Data_Gen
port map(
			FSM_Clocks_I => FSM_Clocks_I,
			
			Control_register_I => Control_register_I,
			FIT_GBT_status_I => FIT_GBT_status_I,
			
			TX_IsData_I => is_data_from_cru_constructor,
			TX_Data_I => data_from_cru_constructor,
			
			RAWFIFO_data_word_I => raw_data_fifo_data_fromfifo,
			RAWFIFO_Is_Empty_I => raw_data_fifo_isempty,
			RAWFIFO_RE_O => raw_data_fifo_rden_txgenerator,
			
			TX_IsData_O => TX_IsData_O,
			TX_Data_O => TX_Data_O
		);
-- ===========================================================

end Behavioral;

