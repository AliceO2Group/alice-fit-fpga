----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: convert data from FEE to RDH format
--
-- Revision: 07/2021
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity DataConverter is
  port (
    FSM_Clocks_I : in FSM_Clocks_type;

    FIT_GBT_status_I   : in FIT_GBT_status_type;
    Control_register_I : in CONTROL_REGISTER_type;

    Board_data_I : in board_data_type;

    fifo_data_o  : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    fifo_empty_o : out std_logic;
    fifo_rden_i  : in  std_logic;

    drop_ounter_o  : out std_logic_vector(15 downto 0)
    fifo_cnt_max_o : out std_logic_vector(15 downto 0)
    );
end DataConverter;

architecture Behavioral of DataConverter is

  constant board_data_void_const : board_data_type :=
    (
      is_header => '0',
      is_data   => '0',
      is_packet => '0',
      data_word => (others => '0')
      );

  signal header_pcklen          : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  signal header_orbit           : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal header_bc              : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal header_word, data_word : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal is_header, is_data     : std_logic;

  signal send_mode, send_mode_sclk : boolean;
  signal reset_drop_counters       : std_logic;
  signal drop_counter              : std_logic_vector(15 downto 0);

  signal rawfifo_cnt, rawfifo_cnt_max : std_logic_vector(12 downto 0);
  signal rawfifo_full                 : std_logic;

  signal sending_event, dropping_event : std_logic;
  signal fifo_data                     : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal fifo_we                       : std_logic;


  attribute keep                        : string;
  attribute keep of reset_drop_counters : signal is "true";
  attribute keep of fifo_data           : signal is "true";
  attribute keep of fifo_we             : signal is "true";

begin

  header_pcklen <= func_PMHEADER_n_dwords(Board_data_I.data_word);
  header_orbit  <= func_PMHEADER_getORBIT(Board_data_I.data_word);
  header_bc     <= func_PMHEADER_getBC(Board_data_I.data_word);


---- Raw_data_fifo =============================================
  raw_data_fifo_comp : entity work.raw_data_fifo
    port map(
      clk        => FSM_Clocks_I.System_Clk,
      srst       => FSM_Clocks_I.Reset_sclk,
      WR_EN      => fifo_we,
      RD_EN      => fifo_rden_i,
      DIN        => fifo_data,
      DOUT       => fifo_data_o,
      data_count => rawfifo_cnt,
      prog_full  => rawfifo_full,
      FULL       => open,
      EMPTY      => fifo_empty_o
      );
---- ===========================================================



  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then
      send_mode      <= (FIT_GBT_status_I.Readout_Mode /= mode_IDLE) or (Control_register_I.readout_bypass = '1');
      drop_ounter_o  <= drop_counter;
      fifo_cnt_max_o <= "000"&rawfifo_cnt_max;
    end if;
  end process;


-- sys ff data clk ***********************************
  process (FSM_Clocks_I.System_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.System_Clk)) then

      reset_drop_counters <= Control_register_I.reset_drophit_counter;

      header_word <= func_FITDATAHD_get_header(header_pcklen, header_orbit, header_bc, FIT_GBT_status_I.rx_phase, FIT_GBT_status_I.GBT_status.Rx_Phase_error, '0');
      data_word   <= Board_data_I.data_word;
      is_data     <= Board_data_I.is_data;
      is_header   <= Board_data_I.is_header;

      send_mode_sclk <= send_mode;

      if(FSM_Clocks_I.Reset_sclk = '1') then

        sending_event   <= '0';
        drop_counter    <= (others => '0');
        rawfifo_cnt_max <= (others => '0');

      else

        if is_header = '1' then
          if (rawfifo_full = '0') and send_mode_sclk then
            sending_event <= '1';
          else
            sending_event <= '0';
            drop_counter  <= drop_counter + 1;
          end if;
        end if;

        if rawfifo_cnt_max < rawfifo_cnt then rawfifo_cnt_max <= rawfifo_cnt; end if;

        if reset_drop_counters = '1' then
          drop_counter    <= (others => '0');
          rawfifo_cnt_max <= (others => '0');
        end if;


      end if;


    end if;


  end process;
-- ****************************************************

  fifo_data <= header_word when (sending_event = '1') and (is_header = '1') else
               data_word when (sending_event = '1') and (is_data = '1') else
               (others => '0');

  fifo_we <= '1' when (is_data = '1' or is_header = '1') and (sending_event = '1') and (rawfifo_full = '0') and send_mode_sclk else '0';

end Behavioral;

