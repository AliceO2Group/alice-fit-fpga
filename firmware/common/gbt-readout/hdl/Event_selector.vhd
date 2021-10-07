----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: Select detector data and collect it for RDH
--
-- Revision: 07/2021
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity Event_selector is
  port (
    FSM_Clocks_I : in rdclocks_t;

    Status_register_I  : in readout_status_t;
    Control_register_I : in readout_control_t;

    header_fifo_data_i  : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    data_fifo_data_i    : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    header_fifo_rden_o  : out std_logic;
    data_fifo_rden_o    : out std_logic;
    header_fifo_empty_i : in  std_logic;

    -- raw data for readout bypass mode
    raw_data_i   : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    raw_isdata_i : in std_logic;

    slct_fifo_dout_o  : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    slct_fifo_empty_o : out std_logic;
    slct_fifo_rden_i  : in  std_logic;

    cntpck_fifo_dout_o  : out std_logic_vector(127 downto 0);
    cntpck_fifo_empty_o : out std_logic;
    cntpck_fifo_rden_i  : in  std_logic;

    trg_fifo_empty_o : out std_logic;

    slct_fifo_cnt_o     : out std_logic_vector(15 downto 0);
    slct_fifo_cnt_max_o : out std_logic_vector(15 downto 0);
    packets_dropped_o   : out std_logic_vector(15 downto 0);
    event_counter_o     : out std_logic_vector(31 downto 0);

    no_data_o : out boolean;

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
  constant max_rdh_size : natural := 512 - (4+16);  -- 492, 0x1ec

  signal data_ndwords, data_ndwords_cmd : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  signal data_orbit                     : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal data_bc                        : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal curr_orbit, curr_orbit_sc      : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal curr_bc, curr_bc_sc            : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal trigger_select_val_sc          : std_logic_vector(Trigger_bitdepth-1 downto 0);

  signal trgfifo_dout, trgfifo_din                                               : std_logic_vector(75 downto 0);
  signal trgfifo_empty, trgfifo_re, trgfifo_we, trgfifo_full, trgfifo_full_latch : std_logic;
  signal trgfifo_out_trigger                                                     : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal trgfifo_out_orbit                                                       : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal trgfifo_out_bc                                                          : std_logic_vector(BC_id_bitdepth-1 downto 0);

  signal slct_fifo_din, slct_fifo_din_ff  : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal slct_fifo_count_wr, fifo_cnt_max : std_logic_vector(14 downto 0);
  signal drop_counter                     : std_logic_vector(15 downto 0);
  signal event_counter, event_counter_ff  : std_logic_vector(31 downto 0);
  signal event_counter_zero_counter       : std_logic_vector(31 downto 0);

  signal slct_fifo_wren, slct_fifo_wren_ff, slct_fifo_busy, slct_fifo_full, slct_fifo_empty : std_logic;

  signal cntpck_fifo_din, cntpck_fifo_din_ff                                        : std_logic_vector(127 downto 0);
  signal cntpck_fifo_wren, cntpck_fifo_wren_ff, cntpck_fifo_full, cntpck_fifo_empty : std_logic;

  signal trgfifo_empty_dc, cntpck_fifo_empty_sc, slct_fifo_empty_sc : std_logic;
  signal send_gear_rdh_dc, send_last_rdh_dc                         : boolean;
  signal fifo_notempty_while_start                                  : std_logic_vector(2 downto 0);

  type FSM_STATE_T is (s0_idle, s1_select, s2_dread);
  signal FSM_STATE, FSM_STATE_NEXT : FSM_STATE_T;
  signal select_timeout            : natural range 0 to 7;  -- min time between select states is 3 cycles to wait updated data from fifo.

  signal header_fifo_rd, data_fifo_rd         : std_logic;
  signal word_counter                         : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  signal rdh_size_counter, rdh_packet_counter : natural range 0 to max_rdh_size+2;

  signal rdh_trigger : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal rdh_orbit   : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal rdh_bc      : std_logic_vector(BC_id_bitdepth-1 downto 0);

  -- control options
  signal hb_rdh_response, readout_bypass, hb_reject : boolean;

  -- cru readout states
  signal data_enabled_sc, send_trg_mode_sc, start_of_run                                                        : boolean;
  -- trg_fifo set 'not_empty' after 2 cycles, is_readout should be delayed. is_readout_sc - actual
  signal is_readout_sc, is_readout_ff1, is_readout_ff2, is_readout_ff3, is_readout_ff3_sc                       : boolean;
  -- data-trg comparison
  signal is_hbtrg, is_hb_r_trg, is_sox, is_eox, is_hbtrg_cmd, is_sel_trg, read_data, read_trigger, start_select : boolean;
  signal read_data_cmd, read_trigger_cmd, rdh_close_cmd, hb_reject_cmd                                          : boolean;
  signal data_not_actual, trg_not_actual, trg_eq_data, trg_later_data, data_later_trg                           : boolean;
  -- packet reading states
  signal reading_header, reading_last_word                                                                      : boolean;
  -- pushing data to select fifo by TRG/CNT mode
  signal data_reject_cmd                                                                                        : boolean;
  -- send_gear_rdh becames true after first BC while readout and false after first BC while idle, used to do not send firs RDH response
  -- send_last_rdh used to send last RDH response after readout finished
  signal send_gear_rdh, send_last_rdh                                                                           : boolean;
  -- dropping data when select fifo is full
  signal dropping_data_cmd                                                                                      : boolean;
  signal stop_bit                                                                                               : std_logic;
  signal reset_dt_counters_sc                                                                                   : boolean;


  attribute mark_debug                         : string;
  -- attribute mark_debug of event_counter              : signal is "true";
  -- attribute mark_debug of event_counter_zero_counter : signal is "true";
--  attribute mark_debug of trgfifo_empty        : signal is "true";
--  attribute mark_debug of cntpck_fifo_empty_sc : signal is "true";
--  attribute mark_debug of slct_fifo_empty_sc   : signal is "true";
--  attribute mark_debug of send_gear_rdh        : signal is "true";
--  attribute mark_debug of send_last_rdh        : signal is "true";

  attribute mark_debug of FSM_STATE        : signal is "true";
--  attribute mark_debug of read_data_cmd    : signal is "true";
--  attribute mark_debug of read_trigger_cmd : signal is "true";
--  attribute mark_debug of start_select     : signal is "true";
--  attribute mark_debug of select_timeout   : signal is "true";

  attribute mark_debug of curr_orbit_sc     : signal is "true";
  attribute mark_debug of curr_bc_sc        : signal is "true";
--  attribute mark_debug of trgfifo_out_orbit : signal is "true";
--  attribute mark_debug of trgfifo_out_bc    : signal is "true";


begin

  -- inputs
  data_ndwords <= func_FITDATAHD_ndwords(header_fifo_data_i);
  data_orbit   <= func_FITDATAHD_orbit(header_fifo_data_i);
  data_bc      <= func_FITDATAHD_bc(header_fifo_data_i);

  -- outputs
  header_fifo_rden_o  <= header_fifo_rd;
  data_fifo_rden_o    <= data_fifo_rd;
  slct_fifo_cnt_o     <= '0'&slct_fifo_count_wr;
  slct_fifo_cnt_max_o <= '0'&fifo_cnt_max;
  slct_fifo_empty_o   <= slct_fifo_empty;
  cntpck_fifo_empty_o <= cntpck_fifo_empty;
  trg_fifo_empty_o    <= trgfifo_empty_dc;



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

  trgfifo_we <= '1' when (((Control_register_I.trg_data_select or TRG_const_HB) and Status_register_I.Trigger_from_CRU) /= TRG_const_void)
                and Status_register_I.Readout_Mode /= mode_IDLE else '0';
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
      DIN    => cntpck_fifo_din_ff,
      WR_EN  => cntpck_fifo_wren_ff,
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
      WR_EN         => slct_fifo_wren_ff,
      RD_EN         => slct_fifo_rden_i,
      DIN           => slct_fifo_din_ff,
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
      errors_o          <= trgfifo_full_latch & fifo_notempty_while_start;
      event_counter_o   <= event_counter;
      no_data_o         <= (trgfifo_empty_dc = '1') and (cntpck_fifo_empty = '1') and (slct_fifo_empty = '1') and not send_gear_rdh_dc and not send_last_rdh_dc;

      is_readout_ff1 <= Status_register_I.Readout_Mode /= mode_IDLE;
      is_readout_ff2 <= is_readout_ff1;
      is_readout_ff3 <= is_readout_ff2;

      trgfifo_empty_dc <= trgfifo_empty;
      send_gear_rdh_dc <= send_gear_rdh;
      send_last_rdh_dc <= send_last_rdh;

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
        if Control_register_I.reset_data_counters = '1' then
          fifo_cnt_max <= (others => '0');
        else
          if fifo_cnt_max < slct_fifo_count_wr then fifo_cnt_max <= slct_fifo_count_wr; end if;
        end if;

        -- trigger fifo full latching
        if (trgfifo_full = '1') and (Status_register_I.Readout_Mode /= mode_IDLE) then trgfifo_full_latch <= '1'; end if;

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
      data_enabled_sc       <= Status_register_I.data_enable = '1';
      is_readout_sc         <= Status_register_I.Readout_Mode /= mode_IDLE;
      is_readout_ff3_sc     <= is_readout_ff3;
      start_of_run          <= Status_register_I.Start_run = '1';
      trigger_select_val_sc <= Control_register_I.trg_data_select;
      reset_dt_counters_sc  <= Control_register_I.reset_data_counters = '1';
      hb_rdh_response       <= Control_register_I.is_hb_response = '1';
      readout_bypass        <= Control_register_I.readout_bypass = '1';
      hb_reject             <= Control_register_I.is_hb_reject = '1';
      event_counter_ff      <= event_counter;
      cntpck_fifo_empty_sc  <= cntpck_fifo_empty;
      slct_fifo_empty_sc    <= slct_fifo_empty;

      -- put raw data in select fifo for readout bypass mode
      if readout_bypass then
        slct_fifo_din_ff  <= raw_data_i;
        slct_fifo_wren_ff <= raw_isdata_i;
      else
        slct_fifo_din_ff  <= slct_fifo_din;
        slct_fifo_wren_ff <= slct_fifo_wren;
      end if;

      cntpck_fifo_din_ff  <= cntpck_fifo_din;
      cntpck_fifo_wren_ff <= cntpck_fifo_wren;
      start_select        <= read_data or read_trigger;

      -- readout mode is latched at the start of run, to select last data
      if start_of_run then send_trg_mode_sc <= Status_register_I.Readout_Mode = mode_TRG; end if;

      if(FSM_Clocks_I.Reset_sclk = '1') then
        FSM_STATE                 <= s0_idle;
        word_counter              <= (others => '0');
        drop_counter              <= (others => '0');
        fifo_notempty_while_start <= (others => '0');
        select_timeout            <= 7;


      else

        FSM_STATE <= FSM_STATE_NEXT;

        -- latching readout commands
        if FSM_STATE_NEXT = s1_select then

          select_timeout <= 0;

          read_data_cmd    <= read_data;
          read_trigger_cmd <= read_trigger;
          is_hbtrg_cmd     <= is_hbtrg and read_trigger;
          rdh_close_cmd    <= (is_hbtrg and read_trigger and hb_rdh_response) or (rdh_size_counter >= max_rdh_size) or send_last_rdh;
          --                      rejecting by trigger in TRG mode
          data_reject_cmd  <= (send_trg_mode_sc and not (trg_eq_data and is_sel_trg)) or (not data_enabled_sc);

          data_ndwords_cmd  <= data_ndwords;
          dropping_data_cmd <= (slct_fifo_full = '1') or (cntpck_fifo_full = '1');

          if is_hb_r_trg and read_trigger then hb_reject_cmd <= true;
          elsif is_hbtrg and read_trigger then hb_reject_cmd <= false; end if;

        else

          -- counting select timeout
          if select_timeout < 7 then select_timeout <= select_timeout + 1; end if;

        end if;


        if FSM_STATE = s1_select then

          word_counter <= (others => '0');

          if is_hbtrg_cmd then
            rdh_trigger <= trgfifo_out_trigger;
            rdh_orbit   <= trgfifo_out_orbit;
            rdh_bc      <= trgfifo_out_bc;
          end if;

          if rdh_close_cmd then
            if is_hbtrg_cmd then rdh_packet_counter <= 0; else rdh_packet_counter <= rdh_packet_counter + 1; end if;
            rdh_size_counter                        <= 0;
          end if;

          -- send_gear_rdh is true after first trigger read        
          send_last_rdh                                            <= false;
          if is_readout_sc and read_trigger_cmd then send_gear_rdh <= true; end if;

          if FSM_STATE_NEXT = s2_dread then reading_header <= true; end if;

        elsif FSM_STATE = s2_dread then

          reading_header <= false;

          -- iterating words while reading data
          word_counter <= word_counter + 1;

        elsif FSM_STATE = s0_idle then

          -- readout is idle (delayed to wait fifo empty), trg_fifo is empty, and send_gear_rdh is true, send last rdh response
          if not is_readout_ff3_sc and send_gear_rdh and (trgfifo_empty = '1') then send_gear_rdh <= false; send_last_rdh <= true; end if;


        end if;

        -- counting rdh payload
        if slct_fifo_wren = '1' then rdh_size_counter                                                       <= rdh_size_counter + 1; end if;
        -- dropping packets counter
        if reading_header and dropping_data_cmd and drop_counter < x"ffff" then drop_counter                <= drop_counter + 1; end if;
        if slct_fifo_wren = '1' and header_fifo_rd = '1' and event_counter < x"ffffffff" then event_counter <= event_counter + 1; end if;
        if reset_dt_counters_sc then drop_counter                                                           <= (others => '0'); event_counter <= (others => '0'); end if;
        -- errors if fifos are not empty while run starts
        if start_of_run then fifo_notempty_while_start                                                      <= (not trgfifo_empty) & (not cntpck_fifo_empty) & (not slct_fifo_empty); end if;


        -- zero event rate counter for ila triggering
        if reset_dt_counters_sc then event_counter_zero_counter                 <= (others => '0');
        elsif event_counter = event_counter_ff then event_counter_zero_counter  <= event_counter_zero_counter+1;
        elsif event_counter /= event_counter_ff then event_counter_zero_counter <= (others => '0'); end if;


      end if;
    end if;
  end process;
-- ****************************************************

-- SELECTOR decision
--    | TRG = 0    | DATA < CURR | read data             | no trigger for data
--    | TRG > DATA |             | read data             | no trigger for data
--    | TRG < DATA |             | read trigger          | no data for trigger
--    | DATA = 0   | TRG /= 0    | read trigger          | no data for trigger
--    | TRG = DATA |             | read trigger and data | data match trigger

  is_hbtrg        <= (trgfifo_empty = '0') and (trgfifo_out_trigger and TRG_const_HB) /= TRG_const_void;
  is_hb_r_trg     <= (trgfifo_empty = '0') and (trgfifo_out_trigger and TRG_const_HBr) /= TRG_const_void;
  is_sox          <= (trgfifo_empty = '0') and (trgfifo_out_trigger and (TRG_const_SOT or TRG_const_SOC)) /= TRG_const_void;
  is_eox          <= (trgfifo_empty = '0') and (trgfifo_out_trigger and (TRG_const_EOT or TRG_const_EOC)) /= TRG_const_void;
  is_sel_trg      <= (trgfifo_empty = '0') and (trgfifo_out_trigger and trigger_select_val_sc) /= TRG_const_void;
  trg_eq_data     <= (trgfifo_empty = '0') and (header_fifo_empty_i = '0') and (data_orbit = trgfifo_out_orbit) and (data_bc = trgfifo_out_bc) and (trgfifo_empty = '0') and (header_fifo_empty_i = '0');
  data_not_actual <= (header_fifo_empty_i = '0') and ((data_orbit > curr_orbit_sc+1) or(data_orbit < curr_orbit_sc) or ((data_orbit = curr_orbit_sc) and (data_bc < curr_bc_sc)));
  trg_not_actual  <= (trgfifo_empty = '0') and ((trgfifo_out_orbit > curr_orbit_sc+1) or (trgfifo_out_orbit < curr_orbit_sc) or ((trgfifo_out_orbit = curr_orbit_sc) and (trgfifo_out_bc < curr_bc_sc)));
  trg_later_data  <= (trgfifo_empty = '0') and (header_fifo_empty_i = '0') and ((data_orbit < trgfifo_out_orbit) or ((data_orbit = trgfifo_out_orbit) and (data_bc < trgfifo_out_bc)));
  data_later_trg  <= (trgfifo_empty = '0') and (header_fifo_empty_i = '0') and ((data_orbit > trgfifo_out_orbit) or ((data_orbit = trgfifo_out_orbit) and (data_bc > trgfifo_out_bc)));

-- no data in fifo
  read_data <= false when header_fifo_empty_i = '1' else
               -- no trigger for data
               true when (trgfifo_empty = '1') and data_not_actual else
               -- trigger equal data                                            
               true when trg_eq_data else
               -- no trigger for data
               true when (trgfifo_empty = '0') and trg_later_data else
               false;

-- no trigger in fifo
  read_trigger <= false when trgfifo_empty = '1' else
                  -- no data for trigger
                  true when header_fifo_empty_i = '1' and trg_not_actual else
                  true when data_later_trg else
                  -- trigger equal data 
                  true when trg_eq_data else
                  false;

  FSM_STATE_NEXT <=
    -- IDLE in BYPASS mode
    s0_idle  when readout_bypass else
    -- START READING
    s2_dread when (FSM_STATE = s1_select) and read_data_cmd else
    -- IDLE after SELECT (trg read)
    s0_idle  when (FSM_STATE = s1_select) and not read_data_cmd else

    -- SELECT from IDLE
    s1_select when (FSM_STATE = s0_idle) and start_select and (select_timeout > 2) else
    -- SELECT from DREAD
    s1_select when (FSM_STATE = s2_dread) and reading_last_word and start_select and (select_timeout > 2) else

    -- IDLE from DREAD
    s0_idle when (FSM_STATE = s2_dread) and reading_last_word else

    -- SELECT last rdh
    s1_select when (FSM_STATE = s0_idle) and send_last_rdh and (select_timeout > 2) else

    -- FSM state the same
    FSM_STATE;





-- reading data FSM
  --reading_header    <= word_counter = 0 and FSM_STATE = s2_dread;
  reading_last_word <= FSM_STATE = s2_dread and word_counter = data_ndwords_cmd;

-- stop bit for HB and last packet
  stop_bit <= '1' when is_hbtrg_cmd else
              '1' when send_last_rdh else
              '0';

-- not reading trigger
  trgfifo_re <= '1' when (FSM_STATE = s1_select) and read_trigger_cmd else '0';

-- pushing RDH info while closing RDH packet                     
  cntpck_fifo_din  <= std_logic_vector(to_unsigned(0, 128-97)) & stop_bit & std_logic_vector(to_unsigned(rdh_packet_counter, 8)) & std_logic_vector(to_unsigned(rdh_size_counter, 12)) & rdh_orbit & rdh_bc & rdh_trigger;
  cntpck_fifo_wren <= '1' when (FSM_STATE = s1_select) and rdh_close_cmd and (send_gear_rdh or send_last_rdh) else '0';

-- reading header when counter 0 and fsm state is reading data 
  header_fifo_rd <= '1' when reading_header                              else '0';
-- reading data when counter /= 0 and fsm state is reading data 
  data_fifo_rd   <= '1' when not reading_header and FSM_STATE = s2_dread else '0';

-- pushing data from raw to slct fifo
  slct_fifo_din  <= header_fifo_data_i               when reading_header                                                                      else data_fifo_data_i;
  slct_fifo_wren <= (header_fifo_rd or data_fifo_rd) when not data_reject_cmd and not (hb_reject_cmd and hb_reject) and not dropping_data_cmd else '0';

end Behavioral;





















