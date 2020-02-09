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
		
		fifo_status_O 				: out FIFO_STATUS_type;
		hits_rd_counter_converter_O	: out hit_rd_counter_type;
		hits_rd_counter_selector_O 	: out hit_rd_counter_type;

		TX_Data_O : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
		TX_IsData_O : out STD_LOGIC;
		GPIO_O : out std_logic_vector(15 downto 0)

	 );
end Data_Packager;

architecture Behavioral of Data_Packager is

	signal data_from_cru_constructor : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	signal is_data_from_cru_constructor : STD_LOGIC;
	
	signal raw_data_fifo_words_count_rd : std_logic_vector(rawfifo_count_bitdepth-1 downto 0);
	signal raw_data_fifo_words_count_wr : std_logic_vector(rawfifo_count_bitdepth-1 downto 0);
	signal raw_data_fifo_data_tofifo : std_logic_vector(fifo_data_bitdepth-1 downto 0);
	signal raw_data_fifo_data_fromfifo : std_logic_vector(fifo_data_bitdepth-1 downto 0);
	signal raw_data_fifo_isempty : std_logic;
	signal raw_data_fifo_wren : std_logic;
	signal raw_data_fifo_rden : std_logic;
	signal raw_data_fifo_space_is_for_packet : STD_LOGIC;
	signal raw_data_fifo_reset : std_logic;

	signal slct_data_fifo_words_count_wr : std_logic_vector(slctfifo_count_bitdepth-1 downto 0);
	signal slct_data_fifo_data_tofifo : std_logic_vector(fifo_data_bitdepth-1 downto 0);
	signal slct_data_fifo_data_fromfifo : std_logic_vector(fifo_data_bitdepth-1 downto 0);
	signal slct_data_fifo_isempty : std_logic;
	signal slct_data_fifo_is_space_for_packet : std_logic;
	signal slct_data_fifo_wren : std_logic;
	signal slct_data_fifo_rden : std_logic;
	signal slct_data_fifo_space_is_for_packet : STD_LOGIC;
	signal slct_data_fifo_reset : std_logic;
	
	signal trg_fifo_count	: std_logic_vector(trgfifo_count_bitdepth-1 downto 0);
	signal cntr_fifo_count	: std_logic_vector(cntpckfifo_count_bitdepth-1 downto 0);

	signal cntpck_fifo_data_fromfifo : std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0);
	signal cntpck_fifo_isempty : std_logic;
	signal cntpck_fifo_rden : std_logic;

	
	attribute keep : string;
	attribute keep of raw_data_fifo_data_fromfifo : signal is "true";
	attribute keep of raw_data_fifo_rden : signal is "true";
	attribute keep of slct_data_fifo_data_fromfifo : signal is "true";
	attribute keep of slct_data_fifo_rden : signal is "true";
	attribute keep of raw_data_fifo_data_tofifo : signal is "true";
	attribute keep of slct_data_fifo_data_tofifo : signal is "true";	
	attribute keep of raw_data_fifo_isempty : signal is "true";
	attribute keep of slct_data_fifo_isempty : signal is "true";
	
	
	

begin
-- --Wiring =====================================================
-- TX_Data_O(83 downto 0) <= (others=>'0'); -- test generation
--raw_data_fifo_space_is_for_packet <= 	'1' when (unsigned(raw_data_fifo_words_count_wr) <= 150-total_data_words-1) else
raw_data_fifo_space_is_for_packet <= 	'1' when (unsigned(raw_data_fifo_words_count_wr) <= rawfifo_depth-total_data_words-1) else
										'0';
										
--slct_data_fifo_is_space_for_packet <= '1' when (unsigned(slct_data_fifo_words_count_wr) <= 150-total_data_words-1) else
slct_data_fifo_is_space_for_packet <= 	'1' when (unsigned(slct_data_fifo_words_count_wr) <= slctfifo_depth-total_data_words-1) else
										'0';

raw_data_fifo_reset <= FSM_Clocks_I.Reset;
slct_data_fifo_reset <= FSM_Clocks_I.Reset;

fifo_status_O.raw_fifo_count <= raw_data_fifo_words_count_wr;
fifo_status_O.slct_fifo_count <= slct_data_fifo_words_count_wr;
fifo_status_O.trg_fifo_count <= trg_fifo_count;
fifo_status_O.cntr_fifo_count <= cntr_fifo_count;

-- -- ===========================================================



-- Data Converter ===============================================
-- PM data already formed
DataConverter_gen: if (Board_DataConversion_type = one_word) or (Board_DataConversion_type = one_word) generate

DataConverter_comp: entity work.DataConverter
    port map(
		FSM_Clocks_I => FSM_Clocks_I,

		FIT_GBT_status_I => FIT_GBT_status_I,
		Control_register_I => Control_register_I,
		
		Board_data_I => Board_data_I,
		
		FIFO_is_space_for_packet_I => raw_data_fifo_space_is_for_packet,
		
		FIFO_WE_O => raw_data_fifo_wren,
		FIFO_data_word_O => raw_data_fifo_data_tofifo,
		
		hits_rd_counter_converter_O => hits_rd_counter_converter_O

		);
		
end generate;
-- ===========================================================





-- Raw_data_fifo =============================================
raw_data_fifo_comp : entity work.raw_data_fifo
port map(
           wr_clk        => FSM_Clocks_I.System_Clk,
           rd_clk        => FSM_Clocks_I.System_Clk,
     	   wr_data_count => raw_data_fifo_words_count_wr,
     	   rd_data_count => raw_data_fifo_words_count_rd,
           rst           => raw_data_fifo_reset,
           WR_EN 		 => raw_data_fifo_wren,
           RD_EN         => raw_data_fifo_rden,
           DIN           => raw_data_fifo_data_tofifo,
           DOUT          => raw_data_fifo_data_fromfifo,
           FULL          => open,
           EMPTY         => raw_data_fifo_isempty
        );
GPIO_O(15) <= raw_data_fifo_wren;
GPIO_O(14) <= raw_data_fifo_rden;
GPIO_O(4 downto 0) <= raw_data_fifo_words_count_rd(4 downto 0);

-- ===========================================================

---- Raw_data_fifo =============================================
--raw_data_fifo_comp : entity work.raw_data_fifo
--port map(
--           clk        => FSM_Clocks_I.System_Clk,
--     	   data_count => raw_data_fifo_words_count_wr,
--           srst           => raw_data_fifo_reset,
--           WR_EN 		 => raw_data_fifo_wren,
--           RD_EN         => raw_data_fifo_rden,
--           DIN           => raw_data_fifo_data_tofifo,
--           DOUT          => raw_data_fifo_data_fromfifo,
--           FULL          => open,
--           EMPTY         => raw_data_fifo_isempty
--        );
--raw_data_fifo_words_count_rd <= raw_data_fifo_words_count_wr;
---- ===========================================================




-- Slc_data_fifo =============================================
slct_data_fifo_comp : entity work.slct_data_fifo
port map(
           wr_clk        => FSM_Clocks_I.System_Clk,
           rd_clk        => FSM_Clocks_I.Data_Clk,
     	   wr_data_count => slct_data_fifo_words_count_wr,
           rst           => slct_data_fifo_reset,
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
		
			RAWFIFO_data_word_I => raw_data_fifo_data_fromfifo,
			RAWFIFO_Is_Empty_I => raw_data_fifo_isempty,
			RAWFIFO_data_count_I => raw_data_fifo_words_count_rd,
			RAWFIFO_RE_O => raw_data_fifo_rden,
			RAWFIFO_RESET_O => raw_data_fifo_reset,
			
			SLCTFIFO_data_word_O => slct_data_fifo_data_tofifo,
			SLCTFIFO_Is_spacefpacket_I => slct_data_fifo_is_space_for_packet,
			SLCTFIFO_WE_O => slct_data_fifo_wren,
			SLCTFIFO_RESET_O => slct_data_fifo_reset,
			
			CNTPTFIFO_data_word_O => cntpck_fifo_data_fromfifo,
            CNTPFIFO_Is_Empty_O => cntpck_fifo_isempty,
			CNTPFIFO_count_O => cntr_fifo_count,
            CNTPFIFO_RE_I => cntpck_fifo_rden,
			
			TRGFIFO_count_O => trg_fifo_count,
			
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
			
			TX_IsData_O => TX_IsData_O,
			TX_Data_O => TX_Data_O
		);
-- ===========================================================

end Behavioral;

