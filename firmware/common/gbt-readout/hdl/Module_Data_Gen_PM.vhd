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
  generic (
    IS_SIMULATION : integer := 0
    );

  port (
    FSM_Clocks_I : in rdclocks_t;

    Status_register_I  : in readout_status_t;
    Control_register_I : in readout_control_t;

    Board_data_I     : in  board_data_type;
    Board_data_O     : out board_data_type;
    datagen_report_o : out datagen_report_t
    );
end Module_Data_Gen;

architecture Behavioral of Module_Data_Gen is


  -- data generator bunch pattern 
  signal gen_sync_reset, gen_sync_reset_sc : boolean;
  signal bc_start                          : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal bunch_freq                        : natural range 0 to 65535;
  signal using_generator_sc                : boolean;

  type packet_size_mask_t is array (0 to 7) of std_logic_vector(3 downto 0);
  signal packet_size_mask                          : packet_size_mask_t;
  signal packet_size_select, packet_size_select_sc : natural range 0 to 15;

  -- fsm signals
  signal bunch_counter                                                        : natural range 0 to 65535;
  signal bunch_in_sync                                                        : boolean;
  signal event_orbit, event_orbit_sc                                          : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal event_bc, event_bc_sc                                                : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal event_rx_ph                                                          : std_logic_vector(rx_phase_bitdepth-1 downto 0);
  signal event_rx_ph_err                                                      : std_logic;
  signal event_size                                                           : natural range 0 to 15;
  signal word_counter                                                         : natural range 0 to 16;
  signal cnt_packet_counter                                                   : std_logic_vector(data_word_bitdepth-tdwords_bitdepth-1 downto 0);  -- continious packet counter
  signal Board_data_header, Board_data_data, Board_data_void, data_gen_result : board_data_type;
  signal datagen_report                                                       : datagen_report_t;


  -- simulating data delay in PM/TCM FEE logic to check start data rejection in selector
  type board_data_type_arr16 is array (0 to 15) of board_data_type;
  signal Board_data_gen_pipe : board_data_type_arr16;


begin

  Board_data_O <= Board_data_gen_pipe(15) when using_generator_sc else Board_data_I;

  gen_sync_reset <= Control_register_I.reset_gensync = '1';
  bunch_freq     <= to_integer(unsigned(Control_register_I.Data_Gen.bunch_freq));
  bc_start       <= x"deb" when Control_register_I.Data_Gen.bc_start = 0 else
              Control_register_I.Data_Gen.bc_start - 1;

-- ***************************************************  
  Board_data_header.is_header <= '1';
  Board_data_header.is_data   <= '1';
  Board_data_data.is_header   <= '0';
  Board_data_data.is_data     <= '1';
  Board_data_void.data_word   <= (others => '0');
  Board_data_void.is_header   <= '0';
  Board_data_void.is_data     <= '0';

  packet_size_mask(0) <= Control_register_I.Data_Gen.bunch_pattern(3 downto 0);
  packet_size_mask(1) <= Control_register_I.Data_Gen.bunch_pattern(7 downto 4);
  packet_size_mask(2) <= Control_register_I.Data_Gen.bunch_pattern(11 downto 8);
  packet_size_mask(3) <= Control_register_I.Data_Gen.bunch_pattern(15 downto 12);
  packet_size_mask(4) <= Control_register_I.Data_Gen.bunch_pattern(19 downto 16);
  packet_size_mask(5) <= Control_register_I.Data_Gen.bunch_pattern(23 downto 20);
  packet_size_mask(6) <= Control_register_I.Data_Gen.bunch_pattern(27 downto 24);
  packet_size_mask(7) <= Control_register_I.Data_Gen.bunch_pattern(31 downto 28);
-- ***************************************************

-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then

      if (FSM_Clocks_I.Reset_dclk = '1') then

        bunch_counter <= 0;
        bunch_in_sync <= false;

      else

        if (bunch_counter > 0) and (bunch_counter <= 8) then
          packet_size_select <= to_integer(unsigned(packet_size_mask(bunch_counter-1)));
        elsif ((Status_register_I.Trigger_from_CRU and Control_register_I.Data_Gen.trigger_resp_mask) /= TRG_const_void) then
          packet_size_select <= to_integer(unsigned(packet_size_mask(0)));
        else packet_size_select <= 0; end if;

        -- bunch counter fsm
        -- reset by gensync
        if gen_sync_reset then bunch_counter                                                          <= 0;
        -- start since bc_start and not in sync
        elsif (not bunch_in_sync) and (Status_register_I.BCID_from_CRU = bc_start) then bunch_counter <= 1;
        -- bunch_in_sync rised next cycle after sync, reset if not
        elsif (not bunch_in_sync) then bunch_counter                                                  <= 0;
        -- generator is off, counter max
        elsif (bunch_freq = 0) or (bunch_counter = 65535) then bunch_counter                          <= 0;
        -- counter cycle
        elsif bunch_counter = bunch_freq-1 then bunch_counter                                         <= 0;
        -- counter iteration
        else bunch_counter                                                                            <= bunch_counter + 1; end if;

        -- reset sync
        if gen_sync_reset then bunch_in_sync                                                                                                            <= false;
        -- start sync when bc_start
        elsif (not bunch_in_sync) and (Status_register_I.BCID_from_CRU = bc_start) and (Status_register_I.BCIDsync_Mode = mode_SYNC) then bunch_in_sync <= true; end if;

        -- Event id latched to match fired bc
        event_orbit <= Status_register_I.ORBIT_from_CRU_corrected;
        event_bc    <= Status_register_I.BCID_from_CRU_corrected;

        datagen_report_o <= datagen_report;

      end if;

    end if;

  end process;
-- ***************************************************

-- Data ff system clk **********************************
  process (FSM_Clocks_I.System_Clk)
  begin

    if(rising_edge(FSM_Clocks_I.System_Clk))then


      if (FSM_Clocks_I.Reset_sclk = '1') then

        word_counter        <= 16;
        Board_data_gen_pipe <= (others => Board_data_void);
        using_generator_sc  <= false;
        gen_sync_reset_sc   <= gen_sync_reset;
        cnt_packet_counter  <= (others => '0');

        datagen_report.orbit      <= (others => '0');
        datagen_report.bc         <= (others => '0');
        datagen_report.size       <= (others => '0');
        datagen_report.packet_num <= (others => '0');


      else

        packet_size_select_sc <= packet_size_select;
        using_generator_sc    <= Control_register_I.Data_Gen.usage_generator = data_gen_on;

        Board_data_gen_pipe(0)       <= data_gen_result;
        Board_data_gen_pipe(1 to 15) <= Board_data_gen_pipe(0 to 14);

        -- start event
        if (FSM_Clocks_I.System_Counter = x"1") and (word_counter = 16 or word_counter = event_size) and (packet_size_select_sc > 0) then
          event_size         <= packet_size_select_sc;
          event_orbit_sc     <= event_orbit;
          event_bc_sc        <= event_bc;
          event_rx_ph        <= Status_register_I.rx_phase;
          event_rx_ph_err    <= Status_register_I.Rx_Phase_error;
          word_counter       <= 0;
          cnt_packet_counter <= cnt_packet_counter + 1;

        -- not sending
        elsif word_counter = 16 then word_counter           <= 16;
        -- stop event (event size -1 to send zero packets)
        elsif word_counter = event_size-1 then word_counter <= 16;
        -- sending event
        else word_counter                                   <= word_counter +1; end if;

        -- reset packet counter
        if gen_sync_reset_sc then cnt_packet_counter <= (others => '0'); end if;


        if IS_SIMULATION = 1 then
          -- datagenreport sync to output data. pipe(6) is the last 320 cycle before 40 cycle
          if Board_data_gen_pipe(3).is_header = '1' then
            datagen_report.orbit      <= func_FITDATAHD_orbit(Board_data_gen_pipe(3).data_word);
            datagen_report.bc         <= func_FITDATAHD_bc(Board_data_gen_pipe(3).data_word);
            datagen_report.size       <= func_FITDATAHD_ndwords(Board_data_gen_pipe(3).data_word)+1;  -- +1 for marking zero packets
            datagen_report.packet_num <= Board_data_gen_pipe(2).data_word(35 downto 0);
          else
            datagen_report.orbit      <= (others => '0');
            datagen_report.bc         <= (others => '0');
            datagen_report.size       <= (others => '0');
            datagen_report.packet_num <= (others => '0');
          end if;
        end if;

      end if;
    end if;

  end process;
-- ***************************************************
  Board_data_data.data_word   <= std_logic_vector(to_unsigned((word_counter+1), tdwords_bitdepth)) & cnt_packet_counter & std_logic_vector(to_unsigned((word_counter+1), tdwords_bitdepth)) & cnt_packet_counter;
  Board_data_header.data_word <= func_FITDATAHD_get_header(std_logic_vector(to_unsigned(event_size-1, n_pckt_wrds_bitdepth)), event_orbit_sc, event_bc_sc, event_rx_ph, event_rx_ph_err, '0');

  data_gen_result <= Board_data_void when (word_counter = 16) else
                     Board_data_header when (word_counter = 0) else
                     Board_data_data;


end Behavioral;

