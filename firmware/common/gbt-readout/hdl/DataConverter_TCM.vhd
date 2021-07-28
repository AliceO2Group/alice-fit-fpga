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
    FSM_Clocks_I : in rdclocks_t;

    Status_register_I  : in readout_status_t;
    Control_register_I : in readout_control_t;

    Board_data_I : in board_data_type;

    FIFO_is_space_for_packet_I : in std_logic;

    FIFO_WE_O        : out std_logic;
    FIFO_data_word_O : out std_logic_vector(fifo_data_bitdepth-1 downto 0);
--              FIFO_data_word_O : out std_logic_vector(160-1 downto 0);

    hits_rd_counter_converter_O : out hit_rd_counter_type
    );
end DataConverter;

architecture Behavioral of DataConverter is

  constant board_data_void_const : board_data_type :=
    (
      is_header => '0',
      is_data   => '0',
      data_word => (others => '0')
      );

  -- type FSM_STATE_T is (s0_wait_header, s1_sending_data);
  -- signal FSM_STATE, FSM_STATE_NEXT  : FSM_STATE_T;

  signal data_fromfifo         : std_logic_vector(fifo_data_bitdepth-1 downto 0);
  signal is_header_from_fifo   : std_logic;
  signal is_data_from_fifo     : std_logic;
  signal raw_data_fifo_isempty : std_logic;



  signal Board_data_sysclkff, Board_data_sysclkff_next                 : Board_data_type;
  signal FIFO_is_space_for_packet_ff, FIFO_is_space_for_packet_ff_next : std_logic;

--      signal word_counter_ff, word_counter_ff_next :  std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  constant counter_zero           : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0) := (others => '0');
  signal packet_lenght_fromheader : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  --packet_lenght_ff, packet_lenght_ff_next :  std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);

  signal header_orbit           : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal header_bc              : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal header_word, data_word : std_logic_vector(fifo_data_bitdepth-1 downto 0);

  signal sending_event, sending_event_next         : std_logic;
  signal FIFO_WE_ff, FIFO_WE_ff_next               : std_logic;
  signal FIFO_data_word_ff, FIFO_data_word_ff_next : std_logic_vector(fifo_data_bitdepth-1 downto 0);

  signal reset_drop_counters                           : std_logic;
  signal is_dropping_event                             : std_logic;  --, is_dropping_event_next : std_logic;
  signal dropped_events, dropped_events_next           : std_logic_vector(31 downto 0);
  signal first_dropped_orbit, first_dropped_orbit_next : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal first_dropped_bc, first_dropped_bc_next       : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal last_dropped_orbit, last_dropped_orbit_next   : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal last_dropped_bc, last_dropped_bc_next         : std_logic_vector(BC_id_bitdepth-1 downto 0);



  attribute keep                        : string;
  attribute keep of Board_data_sysclkff : signal is "true";
  attribute keep of reset_drop_counters : signal is "true";
  attribute keep of dropped_events      : signal is "true";
  attribute keep of first_dropped_orbit : signal is "true";
  attribute keep of first_dropped_bc    : signal is "true";
  attribute keep of last_dropped_orbit  : signal is "true";
  attribute keep of last_dropped_bc     : signal is "true";


begin




-- Wiring ********************************************
  FIFO_WE_O        <= FIFO_WE_ff;
  FIFO_data_word_O <= FIFO_data_word_ff;

--      FIFO_WE_O <= Board_data_sysclkff.is_data;
--      FIFO_data_word_O <= Board_data_sysclkff.data_word;


  hits_rd_counter_converter_O.hits_send_porbit  <= (others => '0');
  hits_rd_counter_converter_O.hits_skipped      <= dropped_events;
  hits_rd_counter_converter_O.first_orbit_hdrop <= first_dropped_orbit;
  hits_rd_counter_converter_O.first_bc_hdrop    <= first_dropped_bc;
  hits_rd_counter_converter_O.last_orbit_hdrop  <= last_dropped_orbit;
  hits_rd_counter_converter_O.last_bc_hdrop     <= last_dropped_bc;

-- ***************************************************




-- tcm_data_160to80bit_fifo =============================================
  tcm_data_160to80bit_fifo_comp : entity work.tcm_data_160to80bit_fifo
    port map(
      clk           => FSM_Clocks_I.System_Clk,
      srst          => FSM_Clocks_I.Reset_sclk,
      WR_EN         => Board_data_I.is_data,
      RD_EN         => not raw_data_fifo_isempty,
      DIN           => Board_data_I.data_word,
      DOUT          => data_fromfifo,
      FULL          => open,
      EMPTY         => raw_data_fifo_isempty,
      rd_data_count => open
      );

  is_header_from_fifo <= '1' when (data_fromfifo(79 downto 76) = "1111") else '0';
  is_data_from_fifo   <= not raw_data_fifo_isempty;

-- ===========================================================

-- Header format *************************************
  packet_lenght_fromheader <= func_PMHEADER_n_dwords(data_fromfifo);
  header_orbit             <= func_PMHEADER_getORBIT(data_fromfifo);
  header_bc                <= func_PMHEADER_getBC(data_fromfifo);
  header_word              <= func_FITDATAHD_get_header(packet_lenght_fromheader, header_orbit, header_bc, Status_register_I.rx_phase, Status_register_I.GBT_status.Rx_Phase_error, '1');
  data_word                <= data_fromfifo;
-- ***************************************************




-- Data ff data clk ***********************************
  process (FSM_Clocks_I.System_Clk)
  begin
    if(FSM_Clocks_I.System_Clk'event and FSM_Clocks_I.System_Clk = '1') then
      if(FSM_Clocks_I.Reset_sclk = '1') then
        Board_data_sysclkff         <= board_data_void_const;
        sending_event               <= '0';
        FIFO_is_space_for_packet_ff <= '0';

        dropped_events      <= (others => '0');
        first_dropped_orbit <= (others => '0');
        first_dropped_bc    <= (others => '0');
        last_dropped_orbit  <= (others => '0');
        last_dropped_bc     <= (others => '0');
        FIFO_WE_ff          <= '0';
        FIFO_data_word_ff   <= (others => '0');

        --is_data_from_fifo <= '0';

      else
        Board_data_sysclkff         <= Board_data_sysclkff_next;
        sending_event               <= sending_event_next;
        FIFO_is_space_for_packet_ff <= FIFO_is_space_for_packet_ff_next;
        FIFO_WE_ff                  <= FIFO_WE_ff_next;
        --if (is_data_from_fifo = '1') and (sending_event = '1') then FIFO_WE_ff <= '1'; else FIFO_WE_ff <= '0'; end if;
        FIFO_data_word_ff           <= FIFO_data_word_ff_next;

        dropped_events      <= dropped_events_next;
        first_dropped_orbit <= first_dropped_orbit_next;
        first_dropped_bc    <= first_dropped_bc_next;
        last_dropped_orbit  <= last_dropped_orbit_next;
        last_dropped_bc     <= last_dropped_bc_next;

      --is_data_from_fifo <= not raw_data_fifo_isempty;
      end if;


    end if;


  end process;
-- ****************************************************


-- FSM ************************************************
--Board_data_sysclkff_next <= Board_data_I;
  FIFO_is_space_for_packet_ff_next <= FIFO_is_space_for_packet_I;

  reset_drop_counters <= Control_register_I.reset_data_counters;


  sending_event_next <= '0' when (FSM_Clocks_I.Reset_sclk = '1') else
                        '0' when (is_header_from_fifo = '1') and (FIFO_is_space_for_packet_ff = '0') else
--                                              '1'     WHEN (is_header_from_fifo = '1') and (Status_register_I.Readout_Mode = mode_IDLE) and (Control_register_I.readout_bypass='1') ELSE
                        '1' when (is_header_from_fifo = '1') and (Control_register_I.readout_bypass = '1') else
                        '0' when (is_header_from_fifo = '1') and (Status_register_I.Readout_Mode = mode_IDLE) else
                        '1' when (is_header_from_fifo = '1') else
                        sending_event;

  FIFO_data_word_ff_next <= (others => '0') when (FSM_Clocks_I.Reset_sclk = '1') else
                            header_word when ((sending_event = '1')or(sending_event_next = '1')) and (is_header_from_fifo = '1') else
                            data_word   when ((sending_event = '1')or(sending_event_next = '1')) and (is_data_from_fifo = '1') else
                            (others => '0');

  FIFO_WE_ff_next <= '0' when (FSM_Clocks_I.Reset_sclk = '1') else
--                                                      '1'             WHEN (is_data_from_fifo = '1') and ((sending_event = '1')or(sending_event_next = '1')) ELSE
                     '1' when (is_data_from_fifo = '1') and (sending_event_next = '1') else
                     '0';

-- Event counter ------------------------------------

  is_dropping_event <= '0' when (FSM_Clocks_I.Reset_sclk = '1') else
                       '0' when (Status_register_I.Readout_Mode = mode_IDLE) else
                       '1' when (is_header_from_fifo = '1') and (FIFO_is_space_for_packet_ff = '0') else
                       '0';

  dropped_events_next <= (others => '0') when (FSM_Clocks_I.Reset_sclk = '1') else
                         (others => '0')    when (reset_drop_counters = '1') else
                         dropped_events + 1 when (is_dropping_event = '1') else
                         dropped_events;

  last_dropped_orbit_next <= (others => '0') when (FSM_Clocks_I.Reset_sclk = '1') else
                             (others => '0') when (reset_drop_counters = '1') else
                             header_orbit    when (is_dropping_event = '1') else
                             last_dropped_orbit;

  last_dropped_bc_next <= (others => '0') when (FSM_Clocks_I.Reset_sclk = '1') else
                          (others => '0') when (reset_drop_counters = '1') else
                          header_bc       when (is_dropping_event = '1') else
                          last_dropped_bc;

  first_dropped_orbit_next <= (others => '0') when (FSM_Clocks_I.Reset_sclk = '1') else
                              (others => '0') when (reset_drop_counters = '1') else
                              header_orbit    when (is_dropping_event = '1') and (last_dropped_orbit = ORBIT_const_void) else
                              first_dropped_orbit;

  first_dropped_bc_next <= (others => '0') when (FSM_Clocks_I.Reset_sclk = '1') else
                           (others => '0') when (reset_drop_counters = '1') else
                           header_bc       when (is_dropping_event = '1') and (last_dropped_orbit = ORBIT_const_void) else
                           first_dropped_bc;
-- ****************************************************


end Behavioral;

