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


entity cru_ltu_emu is
  port (
    FSM_Clocks_I : in rdclocks_t;

    Status_register_I  : in readout_status_t;
    Control_register_I : in readout_control_t;

    RX_IsData_I : in std_logic;
    RX_Data_I   : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);

    RX_IsData_O : out std_logic;
    RX_Data_O   : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0)
    );
end cru_ltu_emu;

architecture Behavioral of cru_ltu_emu is

  signal bunch_freq          : natural range 0 to 65535;
  signal bc_start            : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal hbr_rate, hbr_count : std_logic_vector(3 downto 0);

  -- Event ID
  signal orbit_gen : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal bc_gen    : std_logic_vector(BC_id_bitdepth-1 downto 0);

  -- fsm signals
  signal run_state, run_state_ff, run_command                : rdcmd_t := idle;
  signal bunch_counter                                       : natural range 0 to 65535;
  signal bunch_in_sync                                       : boolean;
  signal send_trgcnt, send_soc, send_eoc, send_sot, send_eot : boolean;

  signal trggen_cnt, trggen_sox, trggen_hb, trggen_rdstate : std_logic_vector(Trigger_bitdepth-1 downto 0);

  signal rx_data_gen   : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal rx_isdata_gen : std_logic;


begin

  RX_Data_O   <= RX_Data_I   when (Control_register_I.Trigger_Gen.usage_generator = gen_off) else rx_data_gen;
  RX_IsData_O <= RX_IsData_I when (Control_register_I.Trigger_Gen.usage_generator = gen_off) else rx_isdata_gen;


  run_command <= Control_register_I.Trigger_Gen.Readout_command;
  bunch_freq  <= to_integer(unsigned(Control_register_I.Trigger_Gen.bunch_freq));
  bc_start    <= x"deb" when Control_register_I.Trigger_Gen.bc_start = 0 else
              Control_register_I.Trigger_Gen.bc_start - 1;
  hbr_rate <= Control_register_I.Trigger_Gen.hbr_rate;


-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then

      if (FSM_Clocks_I.Reset_dclk = '1') then

        orbit_gen     <= (others => '0');
        bc_gen        <= (others => '0');
        hbr_count     <= (others => '0');
        run_state     <= idle;
        bunch_counter <= 0;
        bunch_in_sync <= false;

      else
        -- last cycle with EOR trigger is also with RS/RT
        run_state_ff <= run_state;

        -- Event ID generator
        if bc_gen < LHC_BCID_max then bc_gen <= bc_gen + 1;
        else bc_gen                          <= (others => '0'); orbit_gen <= orbit_gen + 1; end if;


        -- Continious trigger
        -- reset by gensync
        if Control_register_I.reset_gensync = '1' then bunch_counter         <= 0;
        -- start since bc_start and not in sync
        elsif (not bunch_in_sync) and (bc_gen = bc_start) then bunch_counter <= 1;
        -- bunch_in_sync rised next cycle after sync, reset if not
        elsif (not bunch_in_sync) then bunch_counter                         <= 0;
        -- generator is off, counter max
        elsif (bunch_freq = 0) or (bunch_counter = 65535) then bunch_counter <= 0;
        -- counter cycle
        elsif bunch_counter = bunch_freq-1 then bunch_counter                <= 0;
        -- counter iteration
        else bunch_counter                                                   <= bunch_counter + 1; end if;
        -- reset sync
        if Control_register_I.reset_gensync = '1' then bunch_in_sync         <= false;
        -- start sync when bc_start
        elsif (not bunch_in_sync) and (bc_gen = bc_start) then bunch_in_sync <= true; end if;


        -- HBr generator
        if bc_gen = x"000" then
          if hbr_rate = x"0" then hbr_count         <= x"F";
          elsif hbr_count = hbr_rate then hbr_count <= x"0";
          else hbr_count                            <= hbr_count + 1; end if;
        end if;


        -- SOX / EOX generator
        if bc_gen = LHC_BCID_max then

          if run_state = idle and run_command = continious then send_soc <= true; run_state <= continious; end if;
          if run_state = continious and run_command = idle then send_eoc <= true; run_state <= idle; end if;
          if run_state = idle and run_command = trigger then send_sot    <= true; run_state <= trigger; end if;
          if run_state = trigger and run_command = idle then send_eot    <= true; run_state <= idle; end if;

        else
          send_soc <= false;
          send_eoc <= false;
          send_sot <= false;
          send_eot <= false;
        end if;



      end if;

    end if;

  end process;
-- ***************************************************

  send_trgcnt <= false                                             when (bunch_counter = 0) or (bunch_counter > 64) else Control_register_I.Trigger_Gen.trigger_pattern(bunch_counter-1) = '1';
  trggen_cnt  <= Control_register_I.Trigger_Gen.trigger_cont_value when send_trgcnt                                 else (others => '0');

  trggen_sox <= TRG_const_SOC when send_soc else
                TRG_const_EOC when send_eoc else
                TRG_const_SOT when send_sot else
                TRG_const_EOT when send_eot else
                (others => '0');

  trggen_hb <= TRG_const_Orbit or TRG_const_HB or TRG_const_HBr or TRG_const_TF when bc_gen = x"000" and (hbr_count = hbr_rate) else
               TRG_const_Orbit or TRG_const_HB or TRG_const_TF when bc_gen = x"000" and (hbr_count /= hbr_rate) else
               (others => '0');

  trggen_rdstate <= TRG_const_RS when (run_state = trigger) or (run_state_ff = trigger) else
                    TRG_const_RS or TRG_const_RT when (run_state = continious) or (run_state_ff = continious) else
                    (others => '0');

  rx_data_gen   <= orbit_gen & x"0"&bc_gen & (trggen_hb or trggen_sox or trggen_rdstate or trggen_cnt);
  rx_isdata_gen <= '1' when (trggen_hb or trggen_sox or trggen_cnt) /= TRG_const_void else '0';

end Behavioral;
















































