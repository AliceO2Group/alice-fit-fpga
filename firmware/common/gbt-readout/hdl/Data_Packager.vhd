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

	
	
	

begin
--          readout_bypass_s <=Control_register_I.readout_bypass;

-- Data Converter ===============================================
DataConverter_comp: entity work.DataConverter
    port map(
		FSM_Clocks_I => FSM_Clocks_I,

		FIT_GBT_status_I => FIT_GBT_status_I,
		Control_register_I => Control_register_I,
		
		Board_data_I => Board_data_I,
		
		header_fifo_data_o => open,
		data_fifo_data_o => open,
		header_fifo_rden_i=>'0',
		data_fifo_rden_i=>'0',
		header_fifo_empty_o => open,
		
		drop_ounter_o => open,
		fifo_cnt_max_o => open
		);
-- ===========================================================


-- Slc_data_fifo =============================================
slct_data_fifo_comp : entity work.slct_data_fifo
port map(
           wr_clk        => FSM_Clocks_I.System_Clk,
           rd_clk        => FSM_Clocks_I.Data_Clk,
     	   wr_data_count => open,
           rst           => FSM_Clocks_I.Reset_dclk,
           WR_EN 		 => '0',
           RD_EN         => '0',
           DIN           => (others=>'0'),
           DOUT          => open,
           FULL          => open,
           EMPTY         => open
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
--			RAWFIFO_data_count_I => (others => '0'),
			RAWFIFO_RE_O => open,
			RAWFIFO_RESET_O => open,
			
			SLCTFIFO_data_word_O => open,
			SLCTFIFO_Is_spacefpacket_I => '0',
			SLCTFIFO_WE_O => open,
			SLCTFIFO_RESET_O => open,
			
			CNTPTFIFO_data_word_O => cntpck_fifo_data_fromfifo,
            CNTPFIFO_Is_Empty_O => cntpck_fifo_isempty,
			CNTPFIFO_count_O => open,
            CNTPFIFO_RE_I => cntpck_fifo_rden,
			
			TRGFIFO_count_O => open,
			
			hits_rd_counter_selector_O => open
			);
-- ===========================================================

-- CRU Packet Constructer ======================================
CRU_packet_Builder_comp : entity work.CRU_packet_Builder
port map	(
			FSM_Clocks_I => FSM_Clocks_I,
			
			FIT_GBT_status_I => FIT_GBT_status_I,
			Control_register_I => Control_register_I,
		
			SLCTFIFO_data_word_I => (others => '0'),
			SLCTFIFO_Is_Empty_I => '0',
			SLCTFIFO_RE_O => open,
			
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
			
			RAWFIFO_data_word_I => (others => '0'),
			RAWFIFO_Is_Empty_I => '0',
			RAWFIFO_RE_O => open,
			
			TX_IsData_O => TX_IsData_O,
			TX_Data_O => TX_Data_O
		);
-- ===========================================================

end Behavioral;

