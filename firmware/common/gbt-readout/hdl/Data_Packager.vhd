----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D.A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    12:03:02 01/09/2017 
-- Design Name:         FIT GBT
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
use IEEE.STD_LOGIC_1164.all;
use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;

use ieee.numeric_std.all;


entity Data_Packager is
  port (
    FSM_Clocks_I : in FSM_Clocks_type;

    Status_register_I   : in FIT_GBT_status_type;
    Control_register_I : in CONTROL_REGISTER_type;

    Board_data_I : in board_data_type;

    TX_Data_O   : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    TX_IsData_O : out std_logic
    );
end Data_Packager;

architecture Behavioral of Data_Packager is

  signal raw_header_dout, raw_data_dout                   : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal raw_heaer_rden, raw_data_rden, raw_header_empty : std_logic;

  signal slct_fifo_cnt   : std_logic_vector(12 downto 0);
  signal slct_fifo_din   : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal slct_fifo_out   : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal slct_fifo_empty : std_logic;
  signal slct_fifo_wren  : std_logic;
  signal slct_fifo_rden  : std_logic;
  signal slct_fifo_full  : std_logic;


  signal data_from_cru_constructor    : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal is_data_from_cru_constructor : std_logic;
  signal cntpck_fifo_data_fromfifo    : std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0);
  signal cntpck_fifo_isempty          : std_logic;
  signal cntpck_fifo_rden             : std_logic;





begin
--          readout_bypass_s <=Control_register_I.readout_bypass;

-- Data Converter ===============================================
  DataConverter_comp : entity work.DataConverter
    port map(
      FSM_Clocks_I => FSM_Clocks_I,

      Status_register_I   => Status_register_I,
      Control_register_I => Control_register_I,

      Board_data_I => Board_data_I,

      header_fifo_data_o  => raw_header_dout,
      data_fifo_data_o    => raw_data_dout,
      header_fifo_rden_i  => raw_heaer_rden,
      data_fifo_rden_i    => raw_data_rden,
      header_fifo_empty_o => raw_header_empty,

      drop_ounter_o  => open,
      fifo_cnt_max_o => open
      );
-- ===========================================================

-- Event Selector ======================================
  Event_Selector_comp : entity work.Event_Selector
    port map (
      FSM_Clocks_I => FSM_Clocks_I,

      Status_register_I   => Status_register_I,
      Control_register_I => Control_register_I,

      header_fifo_data_i  => raw_header_dout,
      data_fifo_data_i    => raw_data_dout,
      header_fifo_rden_o  => raw_heaer_rden,
      data_fifo_rden_o    => raw_data_rden,
      header_fifo_empty_i => raw_header_empty,

      CNTPFIFO_RE_I         => '0'

      );
-- ===========================================================

-- CRU Packet Constructer ======================================
  CRU_packet_Builder_comp : entity work.CRU_packet_Builder
    port map (
      FSM_Clocks_I => FSM_Clocks_I,

      Status_register_I   => Status_register_I,
      Control_register_I => Control_register_I,

      SLCTFIFO_data_word_I => (others => '0'),
      SLCTFIFO_Is_Empty_I  => '0',
      SLCTFIFO_RE_O        => open,

      CNTPTFIFO_data_word_I => cntpck_fifo_data_fromfifo,
      CNTPFIFO_Is_Empty_I   => cntpck_fifo_isempty,
      CNTPFIFO_RE_O         => cntpck_fifo_rden,

      Is_Data_O => is_data_from_cru_constructor,
      Data_O    => data_from_cru_constructor
      );
-- ===========================================================



-- TX Data Gen ===============================================
  TX_Data_Gen_comp : entity work.TX_Data_Gen
    port map(
      FSM_Clocks_I => FSM_Clocks_I,

      Control_register_I => Control_register_I,
      Status_register_I   => Status_register_I,

      TX_IsData_I => is_data_from_cru_constructor,
      TX_Data_I   => data_from_cru_constructor,

      RAWFIFO_data_word_I => (others => '0'),
      RAWFIFO_Is_Empty_I  => '0',
      RAWFIFO_RE_O        => open,

      TX_IsData_O => TX_IsData_O,
      TX_Data_O   => TX_Data_O
      );
-- ===========================================================

end Behavioral;

