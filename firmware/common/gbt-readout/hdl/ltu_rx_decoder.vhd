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
    Trigger_O                    : out std_logic_vector(Trigger_bitdepth-1 downto 0);
	trg_match_resp_mask_o        : out std_logic;

    BCIDsync_Mode_O    : out bcid_sync_t;
    Readout_Mode_O     : out rdmode_t;
    CRU_Readout_Mode_O : out rdmode_t;
    Start_run_O        : out std_logic;
    Stop_run_O         : out std_logic
    );
end ltu_rx_decoder;

architecture Behavioral of ltu_rx_decoder is

  signal cru_orbit, cru_orbit_ff, sync_orbit, sync_orbit_corr : std_logic_vector(Orbit_id_bitdepth - 1 downto 0);
  signal cru_bc, cru_bc_ff, sync_bc, sync_bc_corr             : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal cru_trigger, cru_trigger_ff                          : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal cru_is_trg, cru_is_trg_ff, sync_is_trg               : boolean;
  
  signal sync_bc_int, bc_delay_int, bc_max_int : natural;

  signal run_not_permit                 : boolean;
  signal orbc_sync_mode                 : bcid_sync_t;
  signal readout_mode, cru_readout_mode : rdmode_t;

  signal is_SOC, is_SOT, is_EOC, is_EOT, is_SOR_ff, is_cru_run, is_cru_cnt : boolean;
  signal bc_delay                                                          : std_logic_vector(BC_id_bitdepth-1 downto 0);


begin



  ORBC_ID_from_CRU_corrected_O <= sync_orbit_corr & sync_bc_corr;
  run_not_permit               <= (Control_register_I.force_idle = '1') or (orbc_sync_mode = mode_LOST) or (orbc_sync_mode = mode_STR) or (Status_register_I.fsm_errors > 0);

	sync_bc_int <= to_integer(unsigned(sync_bc));
	bc_delay_int <= to_integer(unsigned(bc_delay));
	bc_max_int <= to_integer(unsigned(LHC_BCID_max));


-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin

    if(rising_edge(FSM_Clocks_I.Data_Clk))then

      bc_delay <= Control_register_I.BCID_offset+1;

      ORBC_ID_from_CRU_O <= sync_orbit & sync_bc;
      BCIDsync_Mode_O    <= orbc_sync_mode;
      Readout_Mode_O     <= readout_mode;
      CRU_Readout_Mode_O <= cru_readout_mode;

      cru_orbit   <= RX_Data_I(79 downto 48);
      cru_bc      <= RX_Data_I(43 downto 32);
      cru_trigger <= RX_Data_I(31 downto 0);
      cru_is_trg  <= (x"FFFF9FFF" and RX_Data_I(31 downto 0)) /= TRG_const_void;

      cru_orbit_ff   <= cru_orbit;
      cru_bc_ff      <= cru_bc;
      cru_trigger_ff <= cru_trigger;
      cru_is_trg_ff  <= cru_is_trg;
      is_SOR_ff      <= is_SOC or is_SOT;

      if (FSM_Clocks_I.Reset_dclk = '1') then

        orbc_sync_mode   <= mode_STR;
        readout_mode     <= mode_IDLE;
        cru_readout_mode <= mode_IDLE;

        sync_orbit_corr <= (others => '0');
        sync_bc_corr    <= (others => '0');

      else

        if cru_is_trg_ff then Trigger_O                      <= cru_trigger_ff; else Trigger_O <= (others => '0'); end if;
        if is_SOR_ff and not run_not_permit then Start_run_O <= '1';            else Start_run_O <= '0'; end if;
        if is_EOC or is_EOT then Stop_run_O                  <= '1';            else Stop_run_O <= '0'; end if;
		if (cru_trigger_ff and Control_register_I.Data_Gen.trigger_resp_mask) /= TRG_const_void then trg_match_resp_mask_o <= '1'; else trg_match_resp_mask_o <= '0'; end if;

        -- syncronize orbc from cru to detector with first trigger
        if orbc_sync_mode = mode_STR and cru_is_trg then
          sync_orbit     <= cru_orbit;
          sync_bc        <= cru_bc;
          orbc_sync_mode <= mode_SYNC;
        -- check syncronisation each trigger
        elsif orbc_sync_mode = mode_SYNC and cru_is_trg_ff and ((sync_orbit /= cru_orbit_ff) or (sync_bc /= cru_bc_ff)) then
          orbc_sync_mode <= mode_LOST;
        -- incrementing sync counter then sync
        elsif orbc_sync_mode = mode_SYNC then
          if sync_bc < LHC_BCID_max then sync_bc <= sync_bc + 1;
          else sync_bc                           <= (others => '0'); sync_orbit <= sync_orbit + 1; end if;
        end if;

        -- orbc resync out of run
        if (orbc_sync_mode = mode_LOST) and (readout_mode = mode_IDLE) then orbc_sync_mode <= mode_STR;
        -- orbc resync by command
        elsif (Control_register_I.reset_orbc_sync = '1') then orbc_sync_mode               <= mode_STR; end if;

        -- CRU readout mode
        if (not is_cru_run) then cru_readout_mode <= mode_IDLE;
        elsif is_cru_cnt then cru_readout_mode    <= mode_CNT;
        else cru_readout_mode                     <= mode_TRG; end if;

        -- XOR FSM
        if run_not_permit then readout_mode                                                  <= mode_IDLE;
        elsif (readout_mode = mode_IDLE) and is_SOC then readout_mode                        <= mode_CNT;
        elsif (readout_mode = mode_CNT) and is_EOC then readout_mode                         <= mode_IDLE;
        elsif (readout_mode = mode_IDLE) and is_SOT then readout_mode                        <= mode_TRG;
        elsif (readout_mode = mode_TRG) and is_EOT then readout_mode                         <= mode_IDLE;
        elsif (readout_mode = mode_IDLE) and cru_readout_mode /= mode_IDLE then readout_mode <= cru_readout_mode;
        end if;
		

        -- evid corrected
        if (sync_bc_int + bc_delay_int) <= bc_max_int then
          sync_bc_corr    <= (sync_bc + bc_delay);
          sync_orbit_corr <= sync_orbit;
        else
          sync_bc_corr    <= sync_bc + bc_delay - LHC_BCID_max - 1;
          sync_orbit_corr <= sync_orbit + 1;
        end if;

      end if;
    end if;

  end process;
-- ***************************************************

  is_SOC     <= ((cru_trigger and TRG_const_SOC) /= TRG_const_void);
  is_SOT     <= ((cru_trigger and TRG_const_SOT) /= TRG_const_void);
  is_EOC     <= ((cru_trigger_ff and TRG_const_EOC) /= TRG_const_void);
  is_EOT     <= ((cru_trigger_ff and TRG_const_EOT) /= TRG_const_void);
  is_cru_run <= ((cru_trigger and TRG_const_RS) /= TRG_const_void);
  is_cru_cnt <= ((cru_trigger and TRG_const_RT) /= TRG_const_void);


end Behavioral;
























































