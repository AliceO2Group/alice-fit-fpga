----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: generate RX data from CRU/LTU for standalone tests
--
-- Revision: 06/2021
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity CRU_ORBC_Gen is
  port (
    FSM_Clocks_I : in FSM_Clocks_type;

    Status_register_I  : in FIT_GBT_status_type;
    Control_register_I : in CONTROL_REGISTER_type;

    RX_IsData_I : in std_logic;
    RX_Data_I   : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);

    RX_IsData_O : out std_logic;
    RX_Data_O   : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0)
    );
end CRU_ORBC_Gen;

architecture Behavioral of CRU_ORBC_Gen is

  signal RX_Data_gen_ff, RX_Data_gen_ff_next     : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal RX_IsData_gen_ff, RX_IsData_gen_ff_next : std_logic;

  signal EV_ID_counter_set    : std_logic;
  signal EV_ID_counter        : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
  signal IS_Orbit_trg_counter : std_logic;


  type readout_trg_type is (s0_idle, s1_trg_SOC, s1_trg_SOT, s1_trg_EOC, s1_trg_EOT);
  signal rd_trg_send_mode, rd_trg_send_mode_next : readout_trg_type;
  signal is_rd_trg_send                          : std_logic;
  signal readout_command_ff, readout_command_ff1 : Readout_command_type := idle;
  signal runType_mode, running_mode              : std_logic_vector(Trigger_bitdepth-1 downto 0);


  signal is_trigger_sending  : std_logic;  -- emulating CRU trigger messages
  signal TRG_evid            : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal TRG_readout_command : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal TRG_readout_state   : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal TRG_result          : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal isTRG_valid         : std_logic;


  -- single trigger
  signal is_send_single_trg                                     : std_logic;
  signal single_trg_val, single_trg_val_ff, single_trg_send_val : std_logic_vector(Trigger_bitdepth-1 downto 0);

  -- continious trigger
  signal cont_trg_value, cont_trg_send : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal cont_trg_bunch_mask           : std_logic_vector(64 downto 0);
  signal cont_trg_bunch_mask_comp      : std_logic;
  signal bunch_freq                    : std_logic_vector(15 downto 0);
  signal bc_start                      : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal reset_offset                  : std_logic;

  signal bfreq_counter, bfreq_counter_next       : std_logic_vector(15 downto 0);
  signal bpattern_counter, bpattern_counter_next : integer := 0;
  signal is_boffset_sync, is_boffset_sync_next   : std_logic;
  signal is_sentd_cont_trg                       : std_logic;


  attribute mark_debug                             : string;
  attribute mark_debug of rd_trg_send_mode         : signal is "true";
  attribute mark_debug of bpattern_counter         : signal is "true";
  attribute mark_debug of cont_trg_send            : signal is "true";
  attribute mark_debug of is_sentd_cont_trg        : signal is "true";
  attribute mark_debug of cont_trg_bunch_mask_comp : signal is "true";
  attribute mark_debug of TRG_result               : signal is "true";
  attribute mark_debug of is_trigger_sending       : signal is "true";
  attribute mark_debug of is_send_single_trg       : signal is "true";
  attribute mark_debug of single_trg_send_val      : signal is "true";
  attribute mark_debug of EV_ID_counter            : signal is "true";
  attribute mark_debug of is_boffset_sync          : signal is "true";




begin

  RX_Data_O   <= RX_Data_I   when (Control_register_I.Trigger_Gen.usage_generator = use_NO_generator) else RX_Data_gen_ff;
  RX_IsData_O <= RX_IsData_I when (Control_register_I.Trigger_Gen.usage_generator = use_NO_generator) else RX_IsData_gen_ff;

  single_trg_val      <= Control_register_I.Trigger_Gen.trigger_single_val;
  cont_trg_value      <= Control_register_I.Trigger_Gen.trigger_cont_value;
  cont_trg_bunch_mask <= '0' & Control_register_I.Trigger_Gen.trigger_pattern;
  bunch_freq          <= Control_register_I.Trigger_Gen.bunch_freq;  -- first packet in bunch = bc_start + delay
  readout_command_ff  <= Control_register_I.Trigger_Gen.Readout_command;
  reset_offset        <= Control_register_I.reset_gen_offset;

  bc_start <= x"deb" when Control_register_I.Trigger_Gen.bc_start = 0 else Control_register_I.Trigger_Gen.bc_start - 1;

-- BC Counter ==================================================
  BC_counter_datagen_comp : entity work.BC_counter
    port map (
      RESET_I    => FSM_Clocks_I.Reset_dclk,
      DATA_CLK_I => FSM_Clocks_I.Data_Clk,

      IS_INIT_I      => EV_ID_counter_set,
      ORBC_ID_INIT_I => (others => '0'),

      ORBC_ID_COUNT_O => EV_ID_counter,
      IS_Orbit_trg_O  => IS_Orbit_trg_counter
      );
-- =============================================================

  cont_trg_bunch_mask_comp <= cont_trg_bunch_mask(bpattern_counter);


-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin

    if(rising_edge(FSM_Clocks_I.Data_Clk))then
      if (FSM_Clocks_I.Reset_dclk = '1') then
        RX_Data_gen_ff   <= (others => '0');
        RX_IsData_gen_ff <= '0';
        rd_trg_send_mode <= s0_idle;

        bfreq_counter    <= (others => '0');
        bpattern_counter <= 0;
        is_boffset_sync  <= '0';

        single_trg_val_ff <= (others => '0');

        readout_command_ff1 <= idle;

      else
        RX_Data_gen_ff   <= RX_Data_gen_ff_next;
        RX_IsData_gen_ff <= RX_IsData_gen_ff_next;
        rd_trg_send_mode <= rd_trg_send_mode_next;

        bfreq_counter    <= bfreq_counter_next;
        bpattern_counter <= bpattern_counter_next;
        is_boffset_sync  <= is_boffset_sync_next;


        single_trg_val_ff   <= single_trg_val;
        readout_command_ff1 <= readout_command_ff;
      end if;
    end if;

  end process;
-- ***************************************************



-- ***************************************************



---------- Counters ---------------------------------

  bfreq_counter_next <= (others => '0') when (bfreq_counter = bunch_freq-1) else
                        (others => '0') when (bunch_freq = 0) else
                        (others => '0') when (is_boffset_sync = '0') else
                        x"0001"         when (EV_ID_counter(11 downto 0) = bc_start) and (Status_register_I.BCIDsync_Mode = mode_SYNC) else
                        bfreq_counter + 1;

  is_boffset_sync_next <= '0' when (reset_offset = '1') else
                          '1' when (is_boffset_sync = '0') and (EV_ID_counter(11 downto 0) = bc_start) and (Status_register_I.BCIDsync_Mode = mode_SYNC) else
                          is_boffset_sync;


  bpattern_counter_next <= 0 when (bfreq_counter >= bunch_freq-1) else
                           64 when (is_boffset_sync = '0') else
                           64 when (bpattern_counter = 64) else
                           bpattern_counter + 1;

  is_sentd_cont_trg <= '0' when (Status_register_I.BCIDsync_Mode /= mode_SYNC) else
                       '0' when cont_trg_bunch_mask_comp = '0' else
                       '1' when cont_trg_bunch_mask_comp = '1';

  cont_trg_send <= (others => '0') when is_sentd_cont_trg = '0' else
                   cont_trg_value;

-- Event ID counter start
  EV_ID_counter_set <= '1' when (bpattern_counter < 2) and (EV_ID_counter = x"00000000_000") else
                       '0';

---------- CRU TX data gen  -------------------------
  TRG_result         <= TRG_readout_command or TRG_readout_state or TRG_evid or cont_trg_send or single_trg_send_val;
  is_trigger_sending <= IS_Orbit_trg_counter or is_rd_trg_send or is_sentd_cont_trg or is_send_single_trg;
  isTRG_valid        <= is_trigger_sending;




-- RX data
  TRG_evid <= (TRG_const_HB or TRG_const_Orbit) when (IS_Orbit_trg_counter = '1') else
              (others => '0');

  RX_Data_gen_ff_next <= (others => '0') when (is_trigger_sending = '0') else
                         EV_ID_counter(Orbit_id_bitdepth + BC_id_bitdepth-1 downto BC_id_bitdepth) & x"0" & EV_ID_counter(BC_id_bitdepth-1 downto 0) & TRG_result;
  RX_IsData_gen_ff_next <= '1' when (is_trigger_sending = '1') else '0';



-- single trigger
  is_send_single_trg <= '1' when (single_trg_val /= x"00000000") and (single_trg_val_ff = x"00000000") else
                        '0';

  single_trg_send_val <= single_trg_val when (single_trg_val /= x"00000000") and (single_trg_val_ff = x"00000000") else
                         (others => '0');





-- Readout trigger send
  is_rd_trg_send <= '1' when (TRG_readout_command /= TRG_const_void) else
                    '0';

  TRG_readout_command <= TRG_const_SOT when (rd_trg_send_mode = s1_trg_SOT) and (IS_Orbit_trg_counter = '1') else
                         TRG_const_EOT when (rd_trg_send_mode = s1_trg_EOT) and (IS_Orbit_trg_counter = '1') else
                         TRG_const_SOC when (rd_trg_send_mode = s1_trg_SOC) and (IS_Orbit_trg_counter = '1') else
                         TRG_const_EOC when (rd_trg_send_mode = s1_trg_EOC) and (IS_Orbit_trg_counter = '1') else
                         (others => '0');



-- type readout_trg_type is (s0_idle, s1_trg_SOC, s1_trg_SOT, s1_trg_EOC, s1_trg_EOT);
-- type Readout_command_type is (idle, continious, trigger);
  rd_trg_send_mode_next <= s1_trg_SOC when ((Control_register_I.Trigger_Gen.Readout_command = continious) and (readout_command_ff1 = idle)) else
                           s1_trg_EOC when ((Control_register_I.Trigger_Gen.Readout_command = idle) and (readout_command_ff1 = continious)) else
                           s1_trg_SOT when ((Control_register_I.Trigger_Gen.Readout_command = trigger) and (readout_command_ff1 = idle)) else
                           s1_trg_EOT when ((Control_register_I.Trigger_Gen.Readout_command = idle) and (readout_command_ff1 = trigger)) else
                           s0_idle    when (is_rd_trg_send = '1') else
                           rd_trg_send_mode;

  runType_mode      <= TRG_const_RT when (readout_command_ff1 = continious) and (rd_trg_send_mode = s0_idle)                                      else (others => '0');
  running_mode      <= TRG_const_RS when ((readout_command_ff1 = continious) or (readout_command_ff1 = trigger)) and (rd_trg_send_mode = s0_idle) else (others => '0');
  TRG_readout_state <= runType_mode or running_mode;
-- ***************************************************

end Behavioral;
















































