----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: generate data test pattern for standalone tests
--
-- Revision: 07/2021
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;

entity Module_Data_Gen is
  port (
    FSM_Clocks_I : in FSM_Clocks_type;

    Status_register_I  : in FIT_GBT_status_type;
    Control_register_I : in CONTROL_REGISTER_type;

    Board_data_I      : in  board_data_type;
    Board_data_O      : out board_data_type;
    data_gen_report_O : out std_logic_vector(31 downto 0)
    );
end Module_Data_Gen;

architecture Behavioral of Module_Data_Gen is

  signal Board_data_gen_ff_next, Board_data_in_ff               : board_data_type;
  signal Board_data_header, Board_data_header_sc, Board_data_data, Board_data_void : board_data_type;
  
  -- simulating data delay in PM/TCM FEE logic to check start data rejection in selector
  type board_data_type_arr16   is array (0 to 15) of board_data_type;
  signal Board_data_gen_pipe : board_data_type_arr16;


  signal Trigger_from_CRU_sclk : std_logic_vector(Trigger_bitdepth-1 downto 0);  -- Trigger ID from CRUS

  signal trigger_resp_mask_sclk      : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal bunch_pattern               : std_logic_vector(31 downto 0);
  signal bunch_freq, bunch_freq_ff01 : std_logic_vector(15 downto 0);
  signal bc_start                    : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal reset_offset                : std_logic;
  signal use_gen_sclk                : Type_Gen_use_type;

  type n_words_in_packet_arr_type is array (0 to 8) of std_logic_vector(3 downto 0);
  signal n_words_in_packet_mask, n_words_in_packet_mask_sclk          : n_words_in_packet_arr_type;
  signal n_words_in_packet_send, n_words_in_packet_send_next          : std_logic_vector(3 downto 0);
  signal n_words_in_packet_send_tcm                                   : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  signal wchannel_counter, wchannel_counter_w2, wchannel_counter_next : std_logic_vector(tdwords_bitdepth-1 downto 0);


  type FSM_STATE_T is (s0_wait, s1_header, s2_data);
  signal FSM_STATE, FSM_STATE_NEXT : FSM_STATE_T;

  signal is_packet_send_for_cntr, is_packet_send_for_cntr_ff, is_packet_send_for_cntr_next : std_logic;
  signal bfreq_counter, bfreq_counter_next                                                 : std_logic_vector(15 downto 0);
  signal is_boffset_sync, is_boffset_sync_next                                             : std_logic;
  signal bpattern_counter, bpattern_counter_sclk, bpattern_counter_next                    : integer := 0;
  signal cnt_packet_counter, cnt_packet_counter_next                                       : std_logic_vector(data_word_bitdepth-tdwords_bitdepth-1 downto 0);  -- continious packet counter
  signal pword_counter, pword_counter_next                                                 : std_logic_vector(3 downto 0);

  signal data_gen_report : std_logic_vector(31 downto 0);  -- used only in simulation




begin
  bunch_pattern <= Control_register_I.Data_Gen.bunch_pattern;
  bunch_freq    <= Control_register_I.Data_Gen.bunch_freq;
  reset_offset  <= Control_register_I.reset_gen_offset;
  bc_start      <= x"deb" when Control_register_I.Data_Gen.bc_start = 0 else
              Control_register_I.Data_Gen.bc_start - 1;

  Board_data_O      <= Board_data_gen_pipe(15) when (use_gen_sclk = use_MAIN_generator) else Board_data_in_ff;
  data_gen_report_O <= data_gen_report;

-- ***************************************************  
  Board_data_header.is_header <= '1';
  Board_data_header.is_data   <= '1';
  Board_data_data.is_header   <= '0';
  Board_data_data.is_data     <= '1';
  Board_data_void.data_word   <= (others => '0');
  Board_data_void.is_header   <= '0';
  Board_data_void.is_data     <= '0';


  n_words_in_packet_mask(0) <= bunch_pattern(3 downto 0);
  n_words_in_packet_mask(1) <= bunch_pattern(7 downto 4);
  n_words_in_packet_mask(2) <= bunch_pattern(11 downto 8);
  n_words_in_packet_mask(3) <= bunch_pattern(15 downto 12);
  n_words_in_packet_mask(4) <= bunch_pattern(19 downto 16);
  n_words_in_packet_mask(5) <= bunch_pattern(23 downto 20);
  n_words_in_packet_mask(6) <= bunch_pattern(27 downto 24);
  n_words_in_packet_mask(7) <= bunch_pattern(31 downto 28);
  n_words_in_packet_mask(8) <= (others => '0');
-- ***************************************************



-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then

      data_gen_report <= x"0000_000" & n_words_in_packet_mask(bpattern_counter);
      Board_data_header.data_word <= func_FITDATAHD_get_header(x"0"&n_words_in_packet_send, Status_register_I.ORBIT_from_CRU_corrected,
                                                               Status_register_I.BCID_from_CRU_corrected, Status_register_I.rx_phase,
                                                               Status_register_I.GBT_status.Rx_Phase_error, '0');


      if (FSM_Clocks_I.Reset_dclk = '1') then

        bfreq_counter    <= (others => '0');
        bpattern_counter <= 0;
        is_boffset_sync  <= '0';
      else

        bfreq_counter    <= bfreq_counter_next;
        bpattern_counter <= bpattern_counter_next;
        is_boffset_sync  <= is_boffset_sync_next;

        bunch_freq_ff01 <= bunch_freq;
      end if;
    end if;

  end process;
-- ***************************************************

  bfreq_counter_next <= (others => '0') when (bfreq_counter = bunch_freq-1) else
                        (others => '0') when (bunch_freq = 0) else
                        (others => '0') when (is_boffset_sync = '0') else
                        x"0001"         when (Status_register_I.BCID_from_CRU = bc_start) and (Status_register_I.BCIDsync_Mode = mode_SYNC) else
                        bfreq_counter + 1;

  is_boffset_sync_next <= '0' when (reset_offset = '1') else
                          '1' when (is_boffset_sync = '0') and (Status_register_I.BCID_from_CRU = bc_start) and (Status_register_I.BCIDsync_Mode = mode_SYNC) else
                          is_boffset_sync;

  bpattern_counter_next <= 0 when (bfreq_counter = bunch_freq-1) else
                           8 when (is_boffset_sync = '0') else
                           8 when (bpattern_counter = 8) else
                           bpattern_counter + 1;

-- Data ff system clk **********************************
  process (FSM_Clocks_I.System_Clk)
  begin

    if(rising_edge(FSM_Clocks_I.System_Clk))then
      bpattern_counter_sclk       <= bpattern_counter;
      n_words_in_packet_mask_sclk <= n_words_in_packet_mask;
      Trigger_from_CRU_sclk       <= Status_register_I.Trigger_from_CRU;
      trigger_resp_mask_sclk      <= Control_register_I.Data_Gen.trigger_resp_mask;
      use_gen_sclk                <= Control_register_I.Data_Gen.usage_generator;
      Board_data_header_sc        <= Board_data_header;


      if (FSM_Clocks_I.Reset_sclk = '1') then
        Board_data_in_ff  <= Board_data_void;
        Board_data_gen_pipe <= (others => Board_data_void);

        FSM_STATE              <= s0_wait;
        pword_counter          <= (others => '0');
        n_words_in_packet_send <= (others => '0');
        wchannel_counter       <= (others => '0');

        is_packet_send_for_cntr    <= '0';
        is_packet_send_for_cntr_ff <= '0';
        cnt_packet_counter         <= (others => '0');

      else
        Board_data_in_ff  <= Board_data_I;
        Board_data_gen_pipe(0) <= Board_data_gen_ff_next;
		Board_data_gen_pipe(1 to 15) <= Board_data_gen_pipe(0 to 14);

        FSM_STATE              <= FSM_STATE_NEXT;
        pword_counter          <= pword_counter_next;
        n_words_in_packet_send <= n_words_in_packet_send_next;

        is_packet_send_for_cntr    <= is_packet_send_for_cntr_next;
        is_packet_send_for_cntr_ff <= is_packet_send_for_cntr;
        cnt_packet_counter         <= cnt_packet_counter_next;
        wchannel_counter           <= wchannel_counter_next;


      end if;
    end if;

  end process;
-- ***************************************************

  n_words_in_packet_send_tcm <= x"0" & n_words_in_packet_send(2 downto 0) & "1";


  cnt_packet_counter_next <= cnt_packet_counter + 1 when (is_packet_send_for_cntr = '1') and (is_packet_send_for_cntr_ff = '0') else
                             cnt_packet_counter;

  pword_counter_next <= (others => '0') when (FSM_STATE = s0_wait) else
                        (others => '0') when (FSM_STATE = s1_header) else
                        pword_counter + 1;

  FSM_STATE_NEXT <= s1_header when (FSM_STATE = s0_wait) and (FSM_Clocks_I.System_Counter = x"0") and (n_words_in_packet_mask_sclk(bpattern_counter_sclk) > 0) else
                    s1_header when (FSM_STATE = s0_wait) and (FSM_Clocks_I.System_Counter = x"0") and ((Trigger_from_CRU_sclk and trigger_resp_mask_sclk) > 0) else
                    s2_data   when (FSM_STATE = s1_header) else
                    s2_data   when (FSM_STATE = s2_data) and (n_words_in_packet_send > pword_counter_next) else
					
					s1_header when (FSM_STATE = s2_data) and (n_words_in_packet_send = pword_counter_next) and (FSM_Clocks_I.System_Counter = x"0") and (n_words_in_packet_mask_sclk(bpattern_counter_sclk) > 0) else
					s1_header when (FSM_STATE = s2_data) and (n_words_in_packet_send = pword_counter_next) and (FSM_Clocks_I.System_Counter = x"0") and ((Trigger_from_CRU_sclk and trigger_resp_mask_sclk) > 0) else
					
                    s0_wait   when (FSM_STATE = s2_data) and (n_words_in_packet_send = pword_counter_next) else
                    s0_wait;

  is_packet_send_for_cntr_next <= '1' when (FSM_STATE = s2_data) and (FSM_STATE_NEXT = s0_wait) else
                                  '0' when (FSM_Clocks_I.System_Counter = x"0") else
                                  is_packet_send_for_cntr;

  n_words_in_packet_send_next <= n_words_in_packet_mask_sclk(0) when (FSM_STATE = s0_wait) and (FSM_STATE_NEXT = s1_header) and ((Trigger_from_CRU_sclk and trigger_resp_mask_sclk) > 0) else
                                 n_words_in_packet_mask_sclk(bpattern_counter_sclk) when (FSM_STATE = s0_wait) and (FSM_STATE_NEXT = s1_header) else
                                 n_words_in_packet_send;

  wchannel_counter_next <= x"1" when (FSM_STATE = s0_wait) else
                           x"1" when (FSM_STATE = s1_header) else
                           wchannel_counter + x"2";

  wchannel_counter_w2       <= wchannel_counter + 1;
  Board_data_data.data_word <= wchannel_counter & cnt_packet_counter & wchannel_counter_w2 & cnt_packet_counter;

  Board_data_gen_ff_next <= Board_data_void when (FSM_STATE = s0_wait) else
                            Board_data_header_sc when (FSM_STATE = s1_header) else
                            Board_data_data      when (FSM_STATE = s2_data) else
                            Board_data_void;


end Behavioral;

