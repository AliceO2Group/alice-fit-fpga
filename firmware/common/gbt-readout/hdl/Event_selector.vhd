----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:42:21 04/12/2017 
-- Design Name: 
-- Module Name:    Test_Generator - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity Event_selector is
  port (
    FSM_Clocks_I : in FSM_Clocks_type;

    Status_register_I  : in FIT_GBT_status_type;
    Control_register_I : in CONTROL_REGISTER_type;

    header_fifo_data_i  : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    data_fifo_data_i    : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    header_fifo_rden_o  : out std_logic;
    data_fifo_rden_o    : out std_logic;
    header_fifo_empty_i : in  std_logic;
    no_raw_data_i       : in  boolean;

    slct_fifo_dout_o  : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    slct_fifo_empty_o : out std_logic;
    slct_fifo_rden_i  : in  std_logic;

    cntpck_fifo_dout_o  : out std_logic_vector(127 downto 0);
    cntpck_fifo_empty_o : out std_logic;
    cntpck_fifo_rden_i  : in  std_logic;

    slct_fifo_cnt_max_o : out std_logic_vector(15 downto 0);
    packets_dropped_o   : out std_logic_vector(15 downto 0);

    -- errors indicate unexpected FSM state, should be reset and debugged
    -- 0 - slct_fifo is not empty when run starts
    -- 1 - cntpck_fifo is not empty when run starts
    -- 2 - trg_fifo is not empty when run starts
    -- 3 - trg_fifo was full
    errors_o : out std_logic_vector(3 downto 0)
    );
end Event_selector;

architecture Behavioral of Event_selector is

  -- actual bcid is dalayed to take a chance to trigger go throught fifo
  constant bcid_delay   : natural := 32;
  constant max_rdh_size : natural := 512 - (4+10);

  signal data_ndwords, data_ndwords_reading : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  signal data_orbit                         : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal data_bc                            : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal curr_orbit, curr_orbit_sc          : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal curr_bc, curr_bc_sc                : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal trigger_select_val_sc              : std_logic_vector(Trigger_bitdepth-1 downto 0);

  signal trgfifo_dout, trgfifo_din                                               : std_logic_vector(75 downto 0);
  signal trgfifo_empty, trgfifo_re, trgfifo_we, trgfifo_full, trgfifo_full_latch : std_logic;
  signal trgfifo_out_trigger                                                     : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal trgfifo_out_orbit                                                       : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal trgfifo_out_bc                                                          : std_logic_vector(BC_id_bitdepth-1 downto 0);

  signal slct_fifo_din                    : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal slct_fifo_count_wr, fifo_cnt_max : std_logic_vector(14 downto 0);
  signal drop_counter                     : std_logic_vector(15 downto 0);

  signal slct_fifo_wren, slct_fifo_busy, slct_fifo_full, slct_fifo_empty : std_logic;

  signal cntpck_fifo_din                                       : std_logic_vector(127 downto 0);
  signal cntpck_fifo_wren, cntpck_fifo_full, cntpck_fifo_empty : std_logic;

  signal fifo_notempty_while_start : std_logic_vector(2 downto 0);

  type FSM_STATE_T is (s0_idle, s1_dread);
  signal FSM_STATE, FSM_STATE_NEXT : FSM_STATE_T;

  signal header_fifo_rd, data_fifo_rd         : std_logic;
  signal word_counter                         : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  signal rdh_size_counter, rdh_size_counter_actual, rdh_packet_counter : natural;

  signal rdh_trigger : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal rdh_orbit   : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal rdh_bc      : std_logic_vector(BC_id_bitdepth-1 downto 0);

  -- cru readout states
  signal send_mode_sc, send_mode_sc_ff, send_trg_mode_sc                      : boolean;
  -- data-trg comparison
  signal is_hbtrg, is_sel_trg, read_data, read_trigger, rdh_close             : boolean;
  signal data_is_old, trg_is_old, trg_eq_data, trg_later_data, data_later_trg : boolean;
  -- packet reading states
  signal start_reading_data, reading_header, reading_last_word                : boolean;
  -- pushing data to select fifo by TRG/CNT mode
  signal data_trg_reject                                                      : boolean;
  -- becames true after first rdh to not respond it; and becomes false after last rdh_close sent to do not send in continiosly
  signal send_gear_rdh                                                        : boolean;
  -- dropping data when select fifo is full
  signal dropping_data                                                        : boolean;
  signal is_hbtrg_lgc                                                         : std_logic;
  signal reset_drop_cnt_sc                                                    : boolean;

begin

  header_fifo_rden_o  <= header_fifo_rd;
  data_fifo_rden_o    <= data_fifo_rd;
  slct_fifo_cnt_max_o <= '0'&fifo_cnt_max;
  slct_fifo_empty_o   <= slct_fifo_empty;
  cntpck_fifo_empty_o <= cntpck_fifo_empty;


  data_ndwords <= func_FITDATAHD_ndwords(header_fifo_data_i);
  data_orbit   <= func_FITDATAHD_orbit(header_fifo_data_i);
  data_bc      <= func_FITDATAHD_bc(header_fifo_data_i);

  is_hbtrg       <= (trgfifo_empty = '0') and (trgfifo_out_trigger and TRG_const_HB) /= TRG_const_void;
  is_hbtrg_lgc   <= '1' when is_hbtrg else '0';
  is_sel_trg     <= (trgfifo_empty = '0') and (trgfifo_out_trigger and trigger_select_val_sc) /= TRG_const_void;
  trg_eq_data    <= (trgfifo_empty = '0') and (header_fifo_empty_i = '0') and (data_orbit = trgfifo_out_orbit) and (data_bc = trgfifo_out_bc) and (trgfifo_empty = '0') and (header_fifo_empty_i = '0');
  data_is_old    <= (header_fifo_empty_i = '0') and ((data_orbit < curr_orbit_sc) or ((data_orbit = curr_orbit_sc) and (data_bc < curr_bc_sc)));
  trg_is_old     <= (trgfifo_empty = '0') and ((trgfifo_out_orbit < curr_orbit_sc) or ((trgfifo_out_orbit = curr_orbit_sc) and (trgfifo_out_bc < curr_bc_sc)));
  trg_later_data <= (trgfifo_empty = '0') and (header_fifo_empty_i = '0') and ((data_orbit < trgfifo_out_orbit) or ((data_orbit = trgfifo_out_orbit) and (data_bc < trgfifo_out_bc)));
  data_later_trg <= (trgfifo_empty = '0') and (header_fifo_empty_i = '0') and ((data_orbit > trgfifo_out_orbit) or ((data_orbit = trgfifo_out_orbit) and (data_bc > trgfifo_out_bc)));


--    | TRG = 0    | DATA < CURR | read data             | no trigger for data
--    | TRG > DATA |             | read data             | no trigger for data
--    | TRG < DATA |             | read trigger          | no data for trigger
--    | DATA = 0   | TRG /= 0    | read trigger          | no data for trigger
--    | TRG = DATA |             | read trigger and data | data match trigger


  -- no data in fifo
  read_data <= false when header_fifo_empty_i = '1' else
               -- no trigger for data
               true when (trgfifo_empty = '1') and data_is_old else
               -- trigger equal data                                            
               true when trg_eq_data else
               -- no trigger for data
               true when (trgfifo_empty = '0') and trg_later_data else
               false;

  -- no trigger in fifo
  read_trigger <= false when trgfifo_empty = '1' else
                  -- no data for trigger
                  true when header_fifo_empty_i = '1' and trg_is_old else
                  true when data_later_trg else
                  -- trigger equal data 
                  true when trg_eq_data else
                  false;


-- TRG FIFO =============================================
  trg_fifo_comp_c : entity work.trg_fifo_comp
    port map(
      wr_clk => FSM_Clocks_I.Data_Clk,
      rd_clk => FSM_Clocks_I.System_Clk,
      rst    => FSM_Clocks_I.Reset_dclk,
      DIN    => trgfifo_din,
      WR_EN  => trgfifo_we,
      RD_EN  => trgfifo_re,

      DOUT  => trgfifo_dout,
      EMPTY => trgfifo_empty,
      FULL  => trgfifo_full
      );

  trgfifo_we          <= '1' when Status_register_I.Trigger_from_CRU /= 0 and Status_register_I.Readout_Mode /= mode_IDLE else '0';
  trgfifo_din         <= Status_register_I.Trigger_from_CRU & Status_register_I.ORBIT_from_CRU & Status_register_I.BCID_from_CRU;
  trgfifo_out_trigger <= trgfifo_dout(75 downto BC_id_bitdepth + Orbit_id_bitdepth);
  trgfifo_out_orbit   <= trgfifo_dout(BC_id_bitdepth + Orbit_id_bitdepth -1 downto BC_id_bitdepth);
  trgfifo_out_bc      <= trgfifo_dout(BC_id_bitdepth - 1 downto 0);
-- ===========================================================

-- CNTPCK FIFO =============================================
  cntpck_fifo_comp_c : entity work.cntpck_fifo_comp
    port map(
      wr_clk => FSM_Clocks_I.System_Clk,
      rd_clk => FSM_Clocks_I.Data_Clk,
      rst    => FSM_Clocks_I.Reset_sclk,
      DIN    => cntpck_fifo_din,
      WR_EN  => cntpck_fifo_wren,
      RD_EN  => cntpck_fifo_rden_i,

      DOUT  => cntpck_fifo_dout_o,
      EMPTY => cntpck_fifo_empty,
      full  => cntpck_fifo_full
      );
-- ===========================================================

-- Slc_data_fifo =============================================
  slct_fifo_comp : entity work.slct_data_fifo
    port map(
      wr_clk        => FSM_Clocks_I.System_Clk,
      rd_clk        => FSM_Clocks_I.Data_Clk,
      rd_data_count => open,
      wr_data_count => slct_fifo_count_wr,
      rst           => FSM_Clocks_I.Reset_sclk,
      WR_EN         => slct_fifo_wren,
      RD_EN         => slct_fifo_rden_i,
      DIN           => slct_fifo_din,
      DOUT          => slct_fifo_dout_o,
      prog_full     => slct_fifo_full,
      EMPTY         => slct_fifo_empty,
      wr_rst_busy   => slct_fifo_busy,
      rd_rst_busy   => open
      );
-- ===========================================================

  -- Data ff data clk ***********************************
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then

      packets_dropped_o <= drop_counter;
      errors_o          <= (not trgfifo_full_latch) & fifo_notempty_while_start;

      if Status_register_I.BCID_from_CRU >= bcid_delay then
        curr_orbit <= Status_register_I.ORBIT_from_CRU;
        curr_bc    <= (Status_register_I.BCID_from_CRU - bcid_delay);
      else
        curr_orbit <= Status_register_I.ORBIT_from_CRU - 1;
        curr_bc    <= Status_register_I.BCID_from_CRU - bcid_delay + LHC_BCID_max + 1;
      end if;

      if(FSM_Clocks_I.Reset_dclk = '1') then

        fifo_cnt_max       <= (others => '0');
        trgfifo_full_latch <= '0';

      else

        -- select data fifo max count 
        if Control_register_I.reset_drophit_counter = '1' then
          fifo_cnt_max <= (others => '0');
        else
          if fifo_cnt_max < slct_fifo_count_wr then fifo_cnt_max <= slct_fifo_count_wr; end if;
        end if;

        -- trigger fifo full latching
        if trgfifo_full = '1' then trgfifo_full_latch <= '1'; end if;

      end if;

    end if;
  end process;
-- ****************************************************

-- Data ff sys clk ************************************
  process (FSM_Clocks_I.System_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.System_Clk))then

      curr_orbit_sc         <= curr_orbit;
      curr_bc_sc            <= curr_bc;
      send_mode_sc          <= Status_register_I.Readout_Mode /= mode_IDLE;
      send_mode_sc_ff       <= send_mode_sc;
      send_trg_mode_sc      <= Status_register_I.Readout_Mode = mode_TRG;
      trigger_select_val_sc <= Control_register_I.trg_data_select;
      reset_drop_cnt_sc     <= Control_register_I.reset_drophit_counter = '1';

      if(FSM_Clocks_I.Reset_sclk = '1') then
        FSM_STATE                 <= s0_idle;
        word_counter              <= (others => '0');
        drop_counter              <= (others => '0');
        fifo_notempty_while_start <= (others => '0');


      else

        -- latching packet size while reading header
        if word_counter = 0 then data_ndwords_reading <= data_ndwords; end if;

        -- reset counter when start reading packet
        if start_reading_data then word_counter                                     <= (others => '0');
        -- stop iterating if next is not rdata
        elsif FSM_STATE = s1_dread and FSM_STATE_NEXT /= s1_dread then word_counter <= (others => '0');
        -- iterating words while reading data
        elsif FSM_STATE = s1_dread and FSM_STATE_NEXT = s1_dread then word_counter  <= word_counter + 1; end if;


        -- start sending data after first rdh to not close it
        if not send_gear_rdh and is_hbtrg and trgfifo_re = '1' then send_gear_rdh                   <= true; end if;
        -- stop sending data after last rdh was closed to not close it continiosly
        if send_gear_rdh and rdh_close and no_raw_data_i and trgfifo_empty = '1' then send_gear_rdh <= false; end if;

        -- selectind data by trigger in TRG mode
        if start_reading_data then data_trg_reject <= send_trg_mode_sc and not (trg_eq_data and is_sel_trg); end if;

        if is_hbtrg and trgfifo_re = '1' then
          rdh_trigger <= trgfifo_out_trigger;
          rdh_orbit   <= trgfifo_out_orbit;
          rdh_bc      <= trgfifo_out_bc;
        end if;

        -- gbt words counter in RDH packet. increadin while reading header
        if rdh_close then rdh_size_counter                <= 0; elsif slct_fifo_wren = '1' then rdh_size_counter <= rdh_size_counter + 1; end if;
        -- RDH counter in timeframe
        if rdh_close and is_hbtrg then rdh_packet_counter <= 0; elsif rdh_close then rdh_packet_counter <= rdh_packet_counter + 1; end if;

        -- dropping packets when fifos are full
        if start_reading_data then dropping_data              <= (slct_fifo_full = '1') or (cntpck_fifo_full = '1'); end if;
        if reading_header and dropping_data then drop_counter <= drop_counter + 1; end if;
        if reset_drop_cnt_sc then drop_counter                <= (others => '0'); end if;

        -- errors if fifos are not empty while run starts
        if not send_mode_sc_ff and send_mode_sc then fifo_notempty_while_start <= (not trgfifo_empty) & (not cntpck_fifo_empty) & (not slct_fifo_empty); end if;

        FSM_STATE <= FSM_STATE_NEXT;

      end if;
    end if;
  end process;
-- ****************************************************

  start_reading_data <= true when FSM_STATE /= s1_dread and FSM_STATE_NEXT = s1_dread else
                        true when reading_last_word and FSM_STATE_NEXT = s1_dread else
                        false;
  reading_header    <= word_counter = 0 and FSM_STATE = s1_dread;
  reading_last_word <= FSM_STATE = s1_dread and word_counter = data_ndwords_reading;



  FSM_STATE_NEXT <=
    -- READING from IDLE
    s1_dread when (FSM_STATE = s0_idle) and read_data else
    -- READING from DREAD
    s1_dread when (FSM_STATE = s1_dread) and read_data and reading_last_word else

    -- IDLE from IDLE
    s0_idle when (FSM_STATE = s0_idle) and not read_data else
    -- IDLE from DREAD
    s0_idle when (FSM_STATE = s1_dread) and reading_last_word and not read_data else
    -- FSM state the same
    FSM_STATE;

  -- not reading trigger
  trgfifo_re <= '0' when not read_trigger else
                -- reading trigger when not reading data
                '1' when (FSM_STATE = s0_idle) and not read_data else
                -- reading trigger wiht data together while header
                '1' when (FSM_STATE = s1_dread) and reading_header else
                '0';

  -- closing rdh by HB while void
  rdh_close <= true when send_gear_rdh and (trgfifo_re = '1') and (FSM_STATE = s0_idle) and is_hbtrg else
               -- closing rdh by HB while reading data
               true when send_gear_rdh and start_reading_data and read_trigger and is_hbtrg else
               -- closing rdh by size limit
               true when send_gear_rdh and start_reading_data and rdh_size_counter >= max_rdh_size else
               -- closing rdh with last punch of data in run
               true when send_gear_rdh and no_raw_data_i and trgfifo_empty = '1' else
               false;


  -- if closing rdh while readind data, rdh_size is one more than counter
  rdh_size_counter_actual <= rdh_size_counter+1 when slct_fifo_wren = '1' else rdh_size_counter;
  -- pushing RDH info while closing RDH packet                     
  cntpck_fifo_din  <= std_logic_vector(to_unsigned(0, 128-97)) & is_hbtrg_lgc & std_logic_vector(to_unsigned(rdh_packet_counter, 8)) & std_logic_vector(to_unsigned(rdh_size_counter_actual, 12)) & rdh_orbit & rdh_bc & rdh_trigger;
  cntpck_fifo_wren <= '1' when rdh_close else '0';



  -- reading header when counter 0 and fsm state is reading data 
  header_fifo_rd <= '1' when reading_header                             else '0';
  -- reading data when counter /= 0 and fsm state is reading data 
  data_fifo_rd   <= '1' when word_counter /= 0 and FSM_STATE = s1_dread else '0';





-- pushing data from raw to slct fifo
  slct_fifo_din  <= header_fifo_data_i               when header_fifo_rd = '1'                                                                             else data_fifo_data_i;
  slct_fifo_wren <= (header_fifo_rd or data_fifo_rd) when not data_trg_reject and (send_gear_rdh or (is_hbtrg and trgfifo_re = '1')) and not dropping_data else '0';
end Behavioral;





















