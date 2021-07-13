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

    header_fifo_data_o  : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    data_fifo_data_o    : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    header_fifo_rden_i  : in  std_logic;
    data_fifo_rden_i    : in  std_logic;
    header_fifo_empty_o : out std_logic;

    drop_ounter_o  : out std_logic_vector(15 downto 0);
    fifo_cnt_max_o : out std_logic_vector(15 downto 0)
    );
end DataConverter;

architecture Behavioral of DataConverter is

  constant board_data_void_const : board_data_type :=
    (
      is_header => '0',
      is_data   => '0',
      data_word => (others => '0')
      );

  signal header_pcklen, header_pcklen_ff, header_pcklen_latch : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  signal header_orbit                                         : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal header_bc                                            : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal header_word, header_word_latch, data_word            : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal is_header, is_data                                   : std_logic;

  signal send_mode_ison, send_mode_ison_sclk : boolean;
  signal reset_drop_counters                 : std_logic;
  signal drop_counter                        : std_logic_vector(15 downto 0);

  signal data_rawfifo_cnt, rawfifo_cnt_max                    : std_logic_vector(12 downto 0);
  signal header_rawfifo_full, data_rawfifo_full, rawfifo_full : std_logic;


  signal sending_event : std_logic;
  signal word_counter  : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);


  signal header_fifo_din, data_fifo_din : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal header_fifo_we, data_fifo_we   : std_logic;


  attribute keep                        : string;
  attribute keep of reset_drop_counters : signal is "true";
  attribute keep of header_fifo_din     : signal is "true";
  attribute keep of data_fifo_din       : signal is "true";
  attribute keep of header_fifo_we      : signal is "true";
  attribute keep of data_fifo_we        : signal is "true";
  attribute keep of word_counter        : signal is "true";
  attribute keep of sending_event       : signal is "true";
  attribute keep of header_word         : signal is "true";
  attribute keep of data_word           : signal is "true";
  attribute keep of is_data             : signal is "true";
  attribute keep of is_header           : signal is "true";
  attribute keep of header_pcklen_ff    : signal is "true";
  attribute keep of header_word_latch   : signal is "true";
  attribute keep of header_pcklen_latch : signal is "true";

begin

  header_pcklen <= func_PMHEADER_n_dwords(Board_data_I.data_word);
  header_orbit  <= func_PMHEADER_getORBIT(Board_data_I.data_word);
  header_bc     <= func_PMHEADER_getBC(Board_data_I.data_word);


---- Raw_header_fifo =============================================
  raw_header_fifo_comp : entity work.raw_data_fifo
    port map(
      clk        => FSM_Clocks_I.System_Clk,
      srst       => FSM_Clocks_I.Reset_sclk,
      WR_EN      => header_fifo_we,
      RD_EN      => header_fifo_rden_i,
      DIN        => header_fifo_din,
      DOUT       => header_fifo_data_o,
      data_count => open,
      prog_full  => header_rawfifo_full,
      FULL       => open,
      EMPTY      => header_fifo_empty_o
      );
---- ===========================================================


---- Raw_data_fifo =============================================
  raw_data_fifo_comp : entity work.raw_data_fifo
    port map(
      clk        => FSM_Clocks_I.System_Clk,
      srst       => FSM_Clocks_I.Reset_sclk,
      WR_EN      => data_fifo_we,
      RD_EN      => data_fifo_rden_i,
      DIN        => data_fifo_din,
      DOUT       => data_fifo_data_o,
      data_count => data_rawfifo_cnt,
      prog_full  => data_rawfifo_full,
      FULL       => open,
      EMPTY      => open
      );
---- ===========================================================

  rawfifo_full <= header_rawfifo_full or data_rawfifo_full;

  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then
      send_mode_ison <= (FIT_GBT_status_I.Readout_Mode /= mode_IDLE) or (Control_register_I.readout_bypass = '1');
      drop_ounter_o  <= drop_counter;
      fifo_cnt_max_o <= "000"&rawfifo_cnt_max;
    end if;
  end process;


-- sys ff data clk ***********************************
  process (FSM_Clocks_I.System_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.System_Clk)) then

      reset_drop_counters <= Control_register_I.reset_drophit_counter;

      header_word      <= func_FITDATAHD_get_header(header_pcklen, header_orbit, header_bc, FIT_GBT_status_I.rx_phase, FIT_GBT_status_I.GBT_status.Rx_Phase_error, '0');
      data_word        <= Board_data_I.data_word;
      is_data          <= Board_data_I.is_data;
      is_header        <= Board_data_I.is_header;
      header_pcklen_ff <= header_pcklen;

      send_mode_ison_sclk <= send_mode_ison;

      if(FSM_Clocks_I.Reset_sclk = '1') then

        sending_event   <= '0';
        drop_counter    <= (others => '0');
        rawfifo_cnt_max <= (others => '0');
        word_counter    <= (others => '0');

      else

        if is_header = '1' then

          header_word_latch   <= header_word;
          header_pcklen_latch <= header_pcklen_ff;
          word_counter        <= (others => '0');

          if (rawfifo_full = '0') and send_mode_ison_sclk then
            sending_event <= '1';
          else
            sending_event <= '0';
          end if;

          if (rawfifo_full = '1') and send_mode_ison_sclk then
            drop_counter <= drop_counter + 1;
          end if;

        elsif is_data = '1' then

          word_counter <= word_counter + 1;

        else

          word_counter <= (others => '0');

        end if;



        if rawfifo_cnt_max < data_rawfifo_cnt then rawfifo_cnt_max <= data_rawfifo_cnt; end if;

        if reset_drop_counters = '1' then
          drop_counter    <= (others => '0');
          rawfifo_cnt_max <= (others => '0');
        end if;


      end if;

    end if;


  end process;
-- ****************************************************

  header_fifo_din <= header_word_latch;
  header_fifo_we  <= '1' when word_counter = header_pcklen_latch and sending_event = '1' else '0';

  data_fifo_din <= data_word;
  data_fifo_we  <= '1' when is_data = '1' and is_header = '0' and sending_event = '1' else '0';

end Behavioral;

