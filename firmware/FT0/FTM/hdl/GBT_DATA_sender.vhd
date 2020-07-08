----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2019 11:51:36
-- Design Name: 
-- Module Name: GBT_DATA_sender - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

entity GBT_DATA_sender is
    Port ( 
    
	FSM_Clocks_I            : in FSM_Clocks_type;
    
    FIT_GBT_status_I        : in FIT_GBT_status_type;
    Control_register_I      : in CONTROL_REGISTER_type;
    
    
	RX_IsData_ORBCgen_I     : in STD_LOGIC;
    RX_Data_ORBCgen_I       : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    
    DATA_converter_I        : in std_logic_vector(fifo_data_bitdepth-1 downto 0);
    FIFO_WE_converter_I     : in std_logic;
    
    Is_spade_for_packet_O   : out STD_LOGIC;
	IsData_O                : out STD_LOGIC;
    Data_O                  : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0)
    );
    
end GBT_DATA_sender;

architecture Behavioral of GBT_DATA_sender is



signal send_data_fifo_words_count_rd : std_logic_vector(rawfifo_count_bitdepth-1 downto 0);
signal send_data_fifo_words_count_wr : std_logic_vector(rawfifo_count_bitdepth-1 downto 0);
signal send_data_fifo_data_tofifo : std_logic_vector(fifo_data_bitdepth-1 downto 0);
signal send_data_fifo_data_fromfifo : std_logic_vector(fifo_data_bitdepth-1 downto 0);
signal send_data_fifo_isempty : std_logic;
signal send_data_fifo_wren : std_logic;
signal send_data_fifo_rden : std_logic;
signal send_data_fifo_space_is_for_packet : STD_LOGIC;
signal send_data_fifo_reset : std_logic;

attribute keep : string;

attribute keep of send_data_fifo_wren : signal is "true";
attribute keep of send_data_fifo_rden : signal is "true";
attribute keep of send_data_fifo_isempty : signal is "true";
attribute keep of send_data_fifo_data_tofifo : signal is "true";
attribute keep of send_data_fifo_data_fromfifo : signal is "true";

begin


Data_O      <= send_data_fifo_data_fromfifo 				WHEN (Control_register_I.Data_Gen.usage_generator = use_MAIN_generator) ELSE RX_Data_ORBCgen_I;
IsData_O    <= send_data_fifo_rden             WHEN (Control_register_I.Data_Gen.usage_generator = use_MAIN_generator) ELSE RX_IsData_ORBCgen_I;

Is_spade_for_packet_O <= 	'1' when (unsigned(send_data_fifo_words_count_wr) <= rawfifo_depth-total_data_words-1) else
										'0';


send_data_fifo_data_tofifo <= DATA_converter_I;
send_data_fifo_wren <= FIFO_WE_converter_I;
send_data_fifo_reset <= '1' WHEN (Control_register_I.Data_Gen.usage_generator /= use_MAIN_generator) or (FSM_Clocks_I.Reset = '1') ELSE '0';

send_data_fifo_rden <= not send_data_fifo_isempty;


-- data_fifo =============================================
send_data_fifo_comp : entity work.raw_data_fifo
port map(
           wr_clk        => FSM_Clocks_I.System_Clk,
           rd_clk        => FSM_Clocks_I.Data_Clk,
     	   wr_data_count => send_data_fifo_words_count_wr,
     	   rd_data_count => send_data_fifo_words_count_rd,
           rst           => send_data_fifo_reset,
           WR_EN 		 => send_data_fifo_wren,
           RD_EN         => send_data_fifo_rden,
           DIN           => send_data_fifo_data_tofifo,
           DOUT          => send_data_fifo_data_fromfifo,
           FULL          => open,
           EMPTY         => send_data_fifo_isempty
        );
-- ===========================================================


-- Data ff data clk **********************************
--	process (FSM_Clocks_I.Data_Clk)
--	begin

--		IF(rising_edge(FSM_Clocks_I.Data_Clk) )THEN
--			IF (FSM_Clocks_I.Reset = '1') THEN
--                send_data_fifo_rden <= '0';
--			ELSE
--                send_data_fifo_rden <= not send_data_fifo_isempty;
--			END IF;
--		END IF;
		
--	end process;
-- ***************************************************




end Behavioral;
