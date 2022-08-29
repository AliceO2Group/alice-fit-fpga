----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: read RX data; read triggers, SOX/EOX command, ORBIT/BCID sync 
--
-- Revision: 06/2021
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;


entity ltu_rx_decoder is
  port (
    FSM_Clocks_I : in rdclocks_t;

    Status_register_I  : in readout_status_t;
    Control_register_I : in readout_control_t;

    -- RX data @ DataClk, ff in RX sync
    RX_Data_I   : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    RX_IsData_I : in std_logic;         -- unused in tests

    ORBC_ID_from_CRU_O           : out std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);  -- EVENT ID from CRU
    ORBC_ID_from_CRU_corrected_O : out std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);  -- EVENT ID to PM/TCM
    ORBC_ID_from_CRU_sync_O      : out std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);  -- EVENT ID sync compared for err report
    Trigger_O                    : out std_logic_vector(Trigger_bitdepth-1 downto 0);
    trg_match_resp_mask_o        : out std_logic;
    laser_start_o                : out std_logic;

    BCIDsync_Mode_O    : out bcid_sync_t;
    Readout_Mode_O     : out rdmode_t;
    CRU_Readout_Mode_O : out rdmode_t;
    Start_run_O        : out std_logic;
    Stop_run_O         : out std_logic;
    Data_enable_o      : out std_logic;
    apply_bc_delay_o   : out std_logic;

    bcsync_lost_inrun_o : out std_logic;
	
	bcsyncl_outrun_reset_i : in std_logic;
    bcsync_lost_outrun_o : out std_logic
    );
end ltu_rx_decoder;

architecture Behavioral of ltu_rx_decoder is

  signal post_reset_cnt : integer range 0 to 255 := 0;

  signal cru_orbit, cru_orbit_ff, sync_orbit, sync_orbit_corr : std_logic_vector(Orbit_id_bitdepth - 1 downto 0);
  signal cru_bc, cru_bc_ff, sync_bc, sync_bc_corr             : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal cru_trigger, cru_trigger_ff                          : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal cru_is_trg, cru_is_trg_ff, sync_is_trg               : boolean;
  signal cru_is_trg_bcidsync, cru_is_trg_bcidsync_ff          : boolean;
  signal cru_is_trg_crurmode, cru_is_trg_crurmode_ff          : boolean;

  signal sync_bc_int, bc_delay_int, bc_max_int : natural;
  signal bcsync_lost_inrun, bcsync_lost_outrun : std_logic;

  signal gbt_ready                                       : boolean;
  signal run_not_permit, bc_apply_permit                 : boolean;
  signal run_restore_permit                              : boolean;
  signal orbc_sync_mode, orbc_sync_mode_ff               : bcid_sync_t;
  signal readout_mode, readout_mode_ff : rdmode_t;
  signal cru_readout_mode, cru_readout_mode_prev, cru_rd_restore_cmd : rdmode_t;

  signal is_ORB, is_SOC, is_SOT, is_EOC, is_EOT, is_cru_run, is_cru_cnt : boolean;

  -- bc_delay should be changed out of run
  signal bc_delay, bc_delay_in, bc_delay_in_ff : std_logic_vector(BC_id_bitdepth-1 downto 0);
  type bc_apply_fsm_t is (s0_changed, s1_applied);
  signal bc_apply_fsm                          : bc_apply_fsm_t;
  signal apply_bc_delay, apply_bc_delay_ff     : std_logic;
  signal orbits_stb_counter                    : std_logic_vector(3 downto 0);  -- bc_apply switched after 16 stable (HB in cync) orbits 

  constant data_en_orbit_offset_cnt_max : natural := 1;
  signal data_en_orbit_offset_cnt       : natural range 0 to 15;



   -- attribute mark_debug                      : string;
   -- attribute MARK_DEBUG of orbc_sync_mode    : signal is "true";
  -- attribute MARK_DEBUG of orbc_sync_mode_ff : signal is "true";
  -- attribute MARK_DEBUG of bcsync_lost_inrun : signal is "true";
  -- attribute MARK_DEBUG of bcsync_lost_outrun : signal is "true";
  -- attribute MARK_DEBUG of cru_rd_restore_cmd    : signal is "true";

  -- attribute MARK_DEBUG of readout_mode     : signal is "true";
  -- attribute MARK_DEBUG of readout_mode_ff  : signal is "true";
  -- attribute MARK_DEBUG of cru_readout_mode : signal is "true";
  -- attribute MARK_DEBUG of cru_readout_mode_prev : signal is "true";
  -- attribute MARK_DEBUG of cru_readout_mode : signal is "true";
  -- attribute MARK_DEBUG of run_not_permit   : signal is "true";
  -- attribute MARK_DEBUG of run_restore_permit : signal is "true";
  
  -- attribute MARK_DEBUG of is_cru_run       : signal is "true";
  -- attribute MARK_DEBUG of is_cru_cnt       : signal is "true";
  -- attribute MARK_DEBUG of is_SOC           : signal is "true";
  -- attribute MARK_DEBUG of is_SOT           : signal is "true";
  -- attribute MARK_DEBUG of is_EOC           : signal is "true";
  -- attribute MARK_DEBUG of is_EOT           : signal is "true";

  -- attribute MARK_DEBUG of bc_apply_permit : signal is "true";
  -- attribute MARK_DEBUG of bc_apply_fsm    : signal is "true";
  -- attribute MARK_DEBUG of apply_bc_delay  : signal is "true";
  -- attribute MARK_DEBUG of bc_delay_in     : signal is "true";
  -- attribute MARK_DEBUG of bc_delay        : signal is "true";

  -- attribute MARK_DEBUG of cru_orbit   : signal is "true";
  -- attribute MARK_DEBUG of cru_bc      : signal is "true";
  -- attribute MARK_DEBUG of cru_trigger : signal is "true";
  -- attribute MARK_DEBUG of cru_is_trg  : signal is "true";
  -- attribute MARK_DEBUG of cru_is_trg_bcidsync  : signal is "true";
  -- attribute MARK_DEBUG of cru_is_trg_crurmode  : signal is "true";

   -- attribute MARK_DEBUG of sync_orbit  : signal is "true";
   -- attribute MARK_DEBUG of sync_bc  : signal is "true";
   -- attribute MARK_DEBUG of cru_orbit_ff  : signal is "true";
   -- attribute MARK_DEBUG of cru_bc_ff  : signal is "true";
   -- attribute MARK_DEBUG of cru_is_trg_bcidsync_ff  : signal is "true";


begin

  ORBC_ID_from_CRU_corrected_O <= sync_orbit_corr & sync_bc_corr;
  run_not_permit               <= (Control_register_I.force_idle = '1') or (orbc_sync_mode = mode_LOST) or (orbc_sync_mode = mode_STR) or ((x"04FF" and Status_register_I.fsm_errors) /= x"0000");
  bc_apply_permit              <= Status_register_I.fsm_errors(15) = '0' and cru_readout_mode = mode_IDLE and readout_mode = mode_IDLE and orbc_sync_mode = mode_SYNC and (orbits_stb_counter = x"F");
  run_restore_permit           <= Status_register_I.fifos_empty(4 downto 0) = "11111";

  sync_bc_int  <= to_integer(unsigned(sync_bc));
  bc_delay_int <= to_integer(unsigned(bc_delay));
  bc_max_int   <= to_integer(unsigned(LHC_BCID_max));
  


-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin

    if(rising_edge(FSM_Clocks_I.Data_Clk))then

      gbt_ready <= Status_register_I.GBT_status.gbtRx_Ready = '1';

      bc_delay_in       <= Control_register_I.BCID_offset;
      bc_delay_in_ff    <= bc_delay_in;
      apply_bc_delay_ff <= apply_bc_delay;

      ORBC_ID_from_CRU_O  <= sync_orbit & sync_bc;
	  ORBC_ID_from_CRU_sync_O <= cru_orbit_ff & cru_bc_ff;
      BCIDsync_Mode_O     <= orbc_sync_mode;
      Readout_Mode_O      <= readout_mode;
      apply_bc_delay_o    <= apply_bc_delay_ff;
      bcsync_lost_inrun_o <= bcsync_lost_inrun;
      bcsync_lost_outrun_o <= bcsync_lost_outrun;

      cru_orbit   <= RX_Data_I(79 downto 48);
      cru_bc      <= RX_Data_I(43 downto 32);
      cru_trigger <= RX_Data_I(31 downto 0);
      cru_is_trg  <= ((x"FFFF9FFF" and RX_Data_I(31 downto 0)) /= TRG_const_void) and (RX_IsData_I = '1');
      cru_is_trg_bcidsync  <= ((x"00000017" and RX_Data_I(31 downto 0)) /= TRG_const_void) and (RX_IsData_I = '1'); -- 0x17 = 0b10111 (Ph, HBr, HB, Orbit)
      cru_is_trg_crurmode  <= ((x"00000003" and RX_Data_I(31 downto 0)) /= TRG_const_void) and (RX_IsData_I = '1'); -- cru readout mode (HB, Orbit)

      cru_orbit_ff   <= cru_orbit;
      cru_bc_ff      <= cru_bc;
      cru_trigger_ff <= cru_trigger;
      cru_is_trg_ff  <= cru_is_trg;
      cru_is_trg_bcidsync_ff  <= cru_is_trg_bcidsync;
	  cru_is_trg_crurmode_ff <= cru_is_trg_crurmode;

      readout_mode_ff   <= readout_mode;
      orbc_sync_mode_ff <= orbc_sync_mode;  -- ila triggering

      if (FSM_Clocks_I.Reset_dclk = '1') then

        post_reset_cnt <= 0;

        orbc_sync_mode    <= mode_STR;
        orbc_sync_mode_ff <= mode_STR;
        readout_mode      <= mode_IDLE;
        readout_mode_ff   <= mode_IDLE;
        cru_readout_mode  <= mode_IDLE;

        sync_orbit_corr    <= (others => '0');
        sync_bc_corr       <= (others => '0');
        bc_delay           <= (others => '0');
        bc_apply_fsm       <= s0_changed;
        orbits_stb_counter <= (others => '0');

        bcsync_lost_inrun <= '0';
        bcsync_lost_outrun <= '0';

      else

        if post_reset_cnt < 255 then post_reset_cnt <= post_reset_cnt + 1; end if;

        if readout_mode /= mode_IDLE and readout_mode_ff = mode_IDLE then Start_run_O <= '1'; else Start_run_O <= '0'; end if;
        if readout_mode = mode_IDLE and readout_mode_ff /= mode_IDLE then Stop_run_O  <= '1'; else Stop_run_O <= '0'; end if;

        if cru_is_trg_ff and (orbc_sync_mode = mode_SYNC) then Trigger_O <= cru_trigger_ff; else Trigger_O <= (others => '0'); end if;
        if ((cru_trigger_ff and Control_register_I.Data_Gen.trigger_resp_mask) /= TRG_const_void) and (orbc_sync_mode = mode_SYNC) and cru_is_trg_ff then
          trg_match_resp_mask_o <= '1'; else trg_match_resp_mask_o <= '0'; end if;

          if ((cru_trigger_ff and TRG_LASER_STR) /= TRG_const_void) and (orbc_sync_mode = mode_SYNC) and cru_is_trg_ff and gbt_ready then
            laser_start_o <= '1'; else laser_start_o <= '0'; end if;

            -- wait time after fsm reset to skip trash
            if post_reset_cnt /= 255 then orbc_sync_mode <= mode_STR;
            -- syncronize orbc from cru to detector with first trigger
            elsif orbc_sync_mode = mode_STR and cru_is_trg_bcidsync then
              sync_orbit     <= cru_orbit;
              sync_bc        <= cru_bc;
              orbc_sync_mode <= mode_SYNC;
            -- check syncronisation each trigger
            elsif orbc_sync_mode = mode_SYNC and cru_is_trg_bcidsync_ff and ((sync_orbit /= cru_orbit_ff) or (sync_bc /= cru_bc_ff)) then
              orbc_sync_mode                                      <= mode_LOST;
              if readout_mode /= mode_IDLE then bcsync_lost_inrun <= '1'; else bcsync_lost_outrun <= '1'; end if;
            -- incrementing sync counter then sync
            elsif orbc_sync_mode = mode_SYNC then
              if sync_bc < LHC_BCID_max then sync_bc <= sync_bc + 1;
              else sync_bc                           <= (others => '0'); sync_orbit <= sync_orbit + 1; end if;
			  if bcsyncl_outrun_reset_i = '1' then bcsync_lost_outrun <= '0'; end if;
            end if;

            -- orbc resync out of run
            if (orbc_sync_mode = mode_LOST) and (readout_mode = mode_IDLE) then orbc_sync_mode <= mode_STR;
            -- orbc resync by command
            elsif (Control_register_I.reset_orbc_sync = '1') then orbc_sync_mode               <= mode_STR; end if;

            -- CRU readout mode (get value for 1 cycle next to BC trigger)
            if (not is_cru_run) then cru_readout_mode <= mode_IDLE;
            elsif is_cru_cnt then cru_readout_mode    <= mode_CNT;
            else cru_readout_mode                     <= mode_TRG; end if;
			
            -- CRU readout mode prev, latch previous value while BC trigger, reset by EOx
			if cru_is_trg_crurmode_ff then
			  if is_EOC or is_EOT then
			    cru_readout_mode_prev <= mode_IDLE;
				CRU_Readout_Mode_O <= mode_IDLE;
			  else
			    cru_readout_mode_prev <= cru_readout_mode;
				CRU_Readout_Mode_O <= cru_readout_mode;
			  end if;			  
			end if;
			
            -- XOR FSM
            if run_not_permit then readout_mode                                                  <= mode_IDLE;
            elsif (readout_mode = mode_IDLE) and is_SOC then readout_mode                        <= mode_CNT;
            elsif (readout_mode = mode_CNT) and is_EOC then readout_mode                         <= mode_IDLE;
            elsif (readout_mode = mode_IDLE) and is_SOT then readout_mode                        <= mode_TRG;
            elsif (readout_mode = mode_TRG) and is_EOT then readout_mode                         <= mode_IDLE;
            elsif (readout_mode = mode_IDLE) and cru_rd_restore_cmd /= mode_IDLE then readout_mode <= cru_rd_restore_cmd;
            end if;


            -- evid corrected
            if (sync_bc_int + bc_delay_int) <= bc_max_int then
              sync_bc_corr    <= (sync_bc + bc_delay);
              sync_orbit_corr <= sync_orbit;
            else
              sync_bc_corr    <= sync_bc + bc_delay - LHC_BCID_max - 1;
              sync_orbit_corr <= sync_orbit + 1;
            end if;

            -- data enabled since n orbit
            if (readout_mode = mode_IDLE) then
              data_en_orbit_offset_cnt <= 0;
              Data_enable_o            <= '0';
            elsif is_ORB and (readout_mode /= mode_IDLE) then

              if data_en_orbit_offset_cnt < data_en_orbit_offset_cnt_max then
                data_en_orbit_offset_cnt <= data_en_orbit_offset_cnt + 1;
              else
                data_en_orbit_offset_cnt <= data_en_orbit_offset_cnt_max;
                Data_enable_o            <= '1';
              end if;

            end if;

            -- BC delay is applied only when out of run and with sync
            if bc_apply_fsm = s0_changed and bc_apply_permit then
              bc_apply_fsm   <= s1_applied;
              bc_delay       <= bc_delay_in;
              apply_bc_delay <= '1';
            elsif bc_apply_fsm = s1_applied and ((bc_delay_in /= bc_delay_in_ff) or (orbc_sync_mode = mode_STR)) then
              bc_apply_fsm       <= s0_changed;
              orbits_stb_counter <= (others => '0');
              apply_bc_delay     <= '0';
            else
              apply_bc_delay <= '0';
            end if;

            -- counting orbits while stable sync
            if is_ORB and (orbc_sync_mode = mode_SYNC) and (bc_apply_fsm = s0_changed) and orbits_stb_counter /= x"F" then
              orbits_stb_counter <= orbits_stb_counter+1;
            elsif (orbc_sync_mode /= mode_SYNC) then
              orbits_stb_counter <= (others => '0');
            end if;


          end if;
        end if;

      end process;
-- ***************************************************

      is_ORB     <= ((cru_trigger and TRG_const_Orbit) /= TRG_const_void) and cru_is_trg;
      is_SOC     <= ((cru_trigger and TRG_const_SOC) /= TRG_const_void) and cru_is_trg;
      is_SOT     <= ((cru_trigger and TRG_const_SOT) /= TRG_const_void) and cru_is_trg;
      is_EOC     <= ((cru_trigger_ff and TRG_const_EOC) /= TRG_const_void) and cru_is_trg_ff;
      is_EOT     <= ((cru_trigger_ff and TRG_const_EOT) /= TRG_const_void) and cru_is_trg_ff;
      is_cru_run <= ((cru_trigger and TRG_const_RS) /= TRG_const_void) and cru_is_trg_crurmode;
      is_cru_cnt <= ((cru_trigger and TRG_const_RT) /= TRG_const_void) and cru_is_trg_crurmode;
	  
	  -- restoring run by CRU RUN status. If CRU currently run and prev BC was run -> restore readout if fifos are empty
      cru_rd_restore_cmd <= cru_readout_mode when cru_readout_mode = cru_readout_mode_prev and run_restore_permit else mode_IDLE;

    end Behavioral;
























































