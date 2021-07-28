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


entity RX_Data_Decoder is
  port (
    FSM_Clocks_I : in rdclocks_t;

    Status_register_I   : in readout_status_t;
    Control_register_I : in readout_control_t;

    -- RX data @ DataClk, ff in RX sync
    RX_Data_I   : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    RX_IsData_I : in std_logic;         -- unused in tests

    ORBC_ID_from_CRU_O           : out std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);  -- EVENT ID from CRU
    ORBC_ID_from_CRU_corrected_O : out std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);  -- EVENT ID to PM/TCM
    Trigger_O                    : out std_logic_vector(Trigger_bitdepth-1 downto 0);

    BCIDsync_Mode_O    : out bcid_sync_t;
    Readout_Mode_O     : out rdmode_t;
    CRU_Readout_Mode_O : out rdmode_t;
    Start_run_O        : out std_logic;
    Stop_run_O         : out std_logic
    );
end RX_Data_Decoder;

architecture Behavioral of RX_Data_Decoder is

  attribute keep : string;

  signal STATE_SYNC, STATE_SYNC_NEXT     : bcid_sync_t;
  signal STATE_RDMODE, STATE_RDMODE_NEXT : rdmode_t;
  signal Start_run_ff, Start_run_ff_next : std_logic;
  signal Stop_run_ff, Stop_run_ff_next   : std_logic;

  signal TRGTYPE_received_ff, TRGTYPE_received_ff_next : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal ORBC_ID_received_ff, ORBC_ID_received_ff_next : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);

  -- transform received rx data to trigger and evid, in FIT_Readout used: ORBC_ID = OrID(32) & BCID(12)
  signal ORBC_ID_received                            : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
  signal TRGTYPE_received                            : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal TRGTYPE_ORBCrsv_ff, TRGTYPE_ORBCrsv_ff_next : boolean;

  signal EV_ID_counter       : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
  signal EV_ID_counter_BC    : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal EV_ID_counter_ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);

  signal ORBC_counter_init : std_logic;


  signal ORBC_ID_from_CRU_ff, ORBC_ID_from_CRU_ff_next                     : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);  -- EVENT ID from CRU
  signal ORBC_ID_from_CRU_corrected_ff, ORBC_ID_from_CRU_corrected_ff_next : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);  -- EVENT ID to PM/TCM
  signal Trigger_ff, Trigger_ff_next                                       : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal Trigger_valid_bit                                                 : std_logic;
  signal CRU_readout_mode, CRU_readout_mode_next                           : rdmode_t;



  signal EV_ID_counter_corrected       : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
  signal EV_ID_delay                   : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal EV_ID_counter_BC_corrected    : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal EV_ID_counter_ORBIT_corrected : std_logic_vector(Orbit_id_bitdepth-1 downto 0);


  attribute keep of STATE_SYNC          : signal is "true";
  attribute keep of TRGTYPE_received_ff : signal is "true";
  attribute keep of ORBC_ID_received_ff : signal is "true";
  attribute keep of EV_ID_counter       : signal is "true";


begin

-- ***************************************************
  -- equetion define by CRU, must be also defined in RX data generator
  -- Orbit_ID(32) & x"0" & BC_IC(12) & TRGTYPE(32)

  TRGTYPE_received <= RX_Data_I(Trigger_bitdepth-1 downto 0) when (Trigger_valid_bit = '1') else
                      (others => '0');
					  
  ORBC_ID_received <= RX_Data_I(79 downto 48) & RX_Data_I(43 downto 32)
                      when (RX_IsData_I = '1') else (others => '0');

  Trigger_valid_bit <= '1' when (x"FFFF9FFF" and RX_Data_I(31 downto 0)) > 0 else '0';



  -- if recieved rx data contain Event counter
  TRGTYPE_ORBCrsv_ff_next  <= (TRGTYPE_received and x"0000000f") /= TRG_const_void;
  ORBC_ID_received_ff_next <= ORBC_ID_received;  -- delayed signal for comparison with counter

  BCIDsync_Mode_O    <= STATE_SYNC;
  Readout_Mode_O     <= STATE_RDMODE;
  CRU_Readout_Mode_O <= CRU_readout_mode;
  Start_run_O        <= Start_run_ff;
  Stop_run_O         <= Stop_run_ff;

  ORBC_ID_from_CRU_O           <= ORBC_ID_from_CRU_ff;
  ORBC_ID_from_CRU_corrected_O <= ORBC_ID_from_CRU_corrected_ff;
  Trigger_O                    <= Trigger_ff;

-- ***************************************************




-- BC Counter ==================================================
  BC_counter_rxdecoder_comp : entity work.BC_counter
    port map (
      RESET_I    => FSM_Clocks_I.Reset_dclk,
      DATA_CLK_I => FSM_Clocks_I.Data_Clk,

      IS_INIT_I      => ORBC_counter_init,
      ORBC_ID_INIT_I => ORBC_ID_received,

      ORBC_ID_COUNT_O => EV_ID_counter,
      IS_Orbit_trg_O  => open
      );
-- =============================================================

--      type rdmode_t is (mode_CNT, mode_TRG, mode_IDLE);
--      type bcid_sync_t is (mode_STR, mode_SYNC, mode_LOST);

-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin

    if(rising_edge(FSM_Clocks_I.Data_Clk))then
      if (FSM_Clocks_I.Reset_dclk = '1') then
        STATE_SYNC       <= mode_STR;
        STATE_RDMODE     <= mode_IDLE;
        CRU_readout_mode <= mode_IDLE;

        Start_run_ff <= '0';
        Stop_run_ff  <= '0';

        TRGTYPE_ORBCrsv_ff <= false;

        TRGTYPE_received_ff <= (others => '0');
        ORBC_ID_received_ff <= (others => '0');



      else
        STATE_SYNC       <= STATE_SYNC_NEXT;
        STATE_RDMODE     <= STATE_RDMODE_NEXT;
        CRU_readout_mode <= CRU_readout_mode_next;

        Start_run_ff <= Start_run_ff_next;
        Stop_run_ff  <= Stop_run_ff_next;

        TRGTYPE_ORBCrsv_ff <= TRGTYPE_ORBCrsv_ff_next;

        TRGTYPE_received_ff <= TRGTYPE_received_ff_next;
        ORBC_ID_received_ff <= ORBC_ID_received_ff_next;

        ORBC_ID_from_CRU_ff           <= ORBC_ID_from_CRU_ff_next;
        ORBC_ID_from_CRU_corrected_ff <= ORBC_ID_from_CRU_corrected_ff_next;
        Trigger_ff                    <= Trigger_ff_next;

      end if;
    end if;

  end process;
-- ***************************************************



-- FSM ***********************************************
  STATE_RDMODE_NEXT <= mode_IDLE when (Control_register_I.force_idle = '1') else
                       mode_IDLE when (STATE_SYNC = mode_LOST) else

                       mode_TRG when (STATE_RDMODE = mode_IDLE) and ((TRGTYPE_received_ff and TRG_const_SOT) /= TRG_const_void) else
                       mode_TRG when (STATE_RDMODE = mode_IDLE) and ((Trigger_ff and TRG_const_SOT) /= TRG_const_void) else

                       mode_CNT when (STATE_RDMODE = mode_IDLE) and ((TRGTYPE_received_ff and TRG_const_SOC) /= TRG_const_void) else
                       mode_CNT when (STATE_RDMODE = mode_IDLE) and ((Trigger_ff and TRG_const_SOC) /= TRG_const_void) else

                       mode_IDLE when (STATE_RDMODE = mode_TRG) and ((Trigger_ff and TRG_const_EOT) /= TRG_const_void) else
                       mode_IDLE when (STATE_RDMODE = mode_CNT) and ((Trigger_ff and TRG_const_EOC) /= TRG_const_void) else

                                        -- auto run restore
                       mode_CNT when (STATE_RDMODE = mode_IDLE) and ((Trigger_ff and TRG_const_RS) /= TRG_const_void) and ((Trigger_ff and TRG_const_RT) /= TRG_const_void) else
                       mode_TRG when (STATE_RDMODE = mode_IDLE) and ((Trigger_ff and TRG_const_RS) /= TRG_const_void) and ((Trigger_ff and TRG_const_RT) = TRG_const_void) else

                       STATE_RDMODE;

  Start_run_ff_next <= '1' when ((Trigger_ff and TRG_const_SOC) /= TRG_const_void) else
                       '1' when ((Trigger_ff and TRG_const_SOT) /= TRG_const_void) else
                       '0';

  Stop_run_ff_next <= '1' when ((Trigger_ff and TRG_const_EOC) /= TRG_const_void) else
                      '1' when ((Trigger_ff and TRG_const_EOT) /= TRG_const_void) else
                      '0';

-- SYNC FSM
  STATE_SYNC_NEXT <= mode_STR  when (Control_register_I.force_idle = '1') else
                     mode_STR  when (Control_register_I.reset_orbc_sync = '1') else
                     mode_STR  when (STATE_SYNC = mode_LOST) and (STATE_RDMODE = mode_IDLE) else -- 30/06/21 - auto resync out of RUN
                     mode_SYNC when TRGTYPE_ORBCrsv_ff_next and (STATE_SYNC = mode_STR) else
                     mode_LOST when (EV_ID_counter /= ORBC_ID_received_ff) and (STATE_SYNC = mode_SYNC) and TRGTYPE_ORBCrsv_ff else
                     STATE_SYNC;

  ORBC_counter_init <= '1' when TRGTYPE_ORBCrsv_ff_next and (STATE_SYNC = mode_STR) else
                       '0';

  TRGTYPE_received_ff_next <= TRGTYPE_received when (STATE_SYNC = mode_SYNC) else
                              (others => '0');

  ORBC_ID_from_CRU_ff_next <= EV_ID_counter when STATE_SYNC = mode_SYNC else
                              (others => '0');

  ORBC_ID_from_CRU_corrected_ff_next <= EV_ID_counter_corrected when STATE_SYNC = mode_SYNC else
                                        (others => '0');



-- Event ID delayed (corrected)
  EV_ID_delay <= Control_register_I.BCID_offset;

  EV_ID_counter_BC    <= EV_ID_counter(BC_id_bitdepth-1 downto 0);
  EV_ID_counter_ORBIT <= EV_ID_counter(Orbit_id_bitdepth + BC_id_bitdepth-1 downto BC_id_bitdepth);

  EV_ID_counter_BC_corrected <= (EV_ID_counter_BC + EV_ID_delay) when (EV_ID_counter_BC + EV_ID_delay) <= LHC_BCID_max else
                                EV_ID_counter_BC + EV_ID_delay - LHC_BCID_max - 1;

  EV_ID_counter_ORBIT_corrected <= EV_ID_counter_ORBIT when EV_ID_counter_BC + EV_ID_delay <= LHC_BCID_max else
                                   EV_ID_counter_ORBIT + 1;

  EV_ID_counter_corrected <= EV_ID_counter_ORBIT_corrected & EV_ID_counter_BC_corrected;
-- ***************************************************


  Trigger_ff_next <= TRGTYPE_received_ff;


  CRU_readout_mode_next <= CRU_readout_mode when (Trigger_valid_bit = '0') else
                           mode_IDLE        when (TRGTYPE_received and TRG_const_RS) = TRG_const_void else
                           mode_TRG         when (TRGTYPE_received and TRG_const_RT) = TRG_const_void else
                           mode_CNT         when (TRGTYPE_received and TRG_const_RT) /= TRG_const_void else
                           CRU_readout_mode;

end Behavioral;
























































