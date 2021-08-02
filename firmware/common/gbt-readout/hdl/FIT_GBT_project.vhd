----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: TOP FIT GBT readout module
--
-- Revision: 07/2021
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.all;
use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;

entity FIT_GBT_project is
  generic (
    GENERATE_GBT_BANK : integer := 1
    );

  port (
    RESET_I          : in  std_logic;
    SysClk_I         : in  std_logic;   -- 320MHz system clock
    DataClk_I        : in  std_logic;   -- 40MHz data clock
    MgtRefClk_I      : in  std_logic;   -- 200MHz ref clock
    RxDataClk_I      : in  std_logic;   -- 40MHz data clock in RX domain
    GBT_RxFrameClk_O : out std_logic;   --Rx GBT frame clk 40MHz
    FSM_Clocks_O     : out rdclocks_t;

    Board_data_I       : in board_data_type;        --PM or TCM data @320MHz
    Control_register_I : in readout_control_t;  -- control registers @DataClk

    MGT_RX_P_I    : in  std_logic;
    MGT_RX_N_I    : in  std_logic;
    MGT_TX_P_O    : out std_logic;
    MGT_TX_N_O    : out std_logic;
    MGT_TX_dsbl_O : out std_logic;

    -- GBT data to/from FIT readout 
    RxData_rxclk_to_FITrd_I   : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    IsRxData_rxclk_to_FITrd_I : in  std_logic;
    Data_from_FITrd_O         : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    IsData_from_FITrd_O       : out std_logic;

    -- GBT data to/from GBT project
    Data_to_GBT_I             : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    IsData_to_GBT_I           : in  std_logic;
    RxData_rxclk_from_GBT_O   : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    IsRxData_rxclk_from_GBT_O : out std_logic;

    -- FIT readour status, including BCOR_ID to PM/TCM
    readout_status_o : out readout_status_t
    );
end FIT_GBT_project;

architecture Behavioral of FIT_GBT_project is

-- reset signals
  signal FSM_Clocks : rdclocks_t;
  signal gbt_reset  : std_logic;

-- GBT data
  signal RX_IsData_DataClk            : std_logic;
  signal RX_exData_from_RXsync        : std_logic_vector(GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0);
  signal RX_Data_DataClk              : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal RX_IsData_from_orbcgen       : std_logic;
  signal RX_Data_from_orbcgen         : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal TX_IsData_from_txgen         : std_logic;
  signal TX_Data_from_txgen           : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal RX_IsData_rxclk_from_GBT     : std_logic;
  signal RX_Data_rxclk_from_GBT       : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal data_from_cru_constructor    : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal is_data_from_cru_constructor : std_logic;

-- status
  signal from_gbt_bank_prj_GBT_status     : gbt_status_t;
  signal FIT_GBT_STATUS                   : readout_status_t;
  signal ORBC_ID_from_RXdecoder           : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);  -- EVENT ID from CRUS
  signal ORBC_ID_corrected_from_RXdecoder : std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);  -- EVENT ID to PM/TCM




-- data packager 
  signal raw_header_dout, raw_data_dout                  : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal raw_heaer_rden, raw_data_rden, raw_header_empty : std_logic;
  signal no_raw_data                                     : boolean;

  signal slct_fifo_dout  : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal slct_fifo_empty : std_logic;
  signal slct_fifo_rden  : std_logic;

  signal cntpck_fifo_dout  : std_logic_vector(127 downto 0);
  signal cntpck_fifo_empty : std_logic;
  signal cntpck_fifo_rden  : std_logic;

-- from data generator
  signal Board_data_from_main_gen : board_data_type;




  attribute mark_debug                             : string;
  attribute mark_debug of Board_data_from_main_gen : signal is "true";
  attribute mark_debug of RX_Data_DataClk : signal is "true";
  attribute mark_debug of RX_IsData_DataClk : signal is "true";

begin
-- WIRING ======================================================
  FSM_Clocks_O          <= FSM_Clocks;
  FSM_Clocks.System_Clk <= SysClk_I;
  FSM_Clocks.Data_Clk   <= DataClk_I;
  FSM_Clocks.GBT_RX_Clk <= RxDataClk_I;

  -- SFP turned ON
  MGT_TX_dsbl_O <= '0';

  -- Status
  readout_status_o                        <= FIT_GBT_STATUS;
  FIT_GBT_STATUS.GBT_status               <= from_gbt_bank_prj_GBT_status;
  FIT_GBT_STATUS.BCID_from_CRU            <= ORBC_ID_from_RXdecoder(BC_id_bitdepth-1 downto 0);
  FIT_GBT_STATUS.ORBIT_from_CRU           <= ORBC_ID_from_RXdecoder(Orbit_id_bitdepth + BC_id_bitdepth-1 downto BC_id_bitdepth);
  FIT_GBT_STATUS.BCID_from_CRU_corrected  <= ORBC_ID_corrected_from_RXdecoder(BC_id_bitdepth-1 downto 0);
  FIT_GBT_STATUS.ORBIT_from_CRU_corrected <= ORBC_ID_corrected_from_RXdecoder(Orbit_id_bitdepth + BC_id_bitdepth-1 downto BC_id_bitdepth);
  FIT_GBT_STATUS.fsm_errors(15 downto 8)  <= (others => '0');





  RX_Data_DataClk           <= RX_exData_from_RXsync(GBT_data_word_bitdepth-1 downto 0);
  Data_from_FITrd_O         <= TX_Data_from_txgen   when (Control_register_I.Trigger_Gen.usage_generator /= use_TX_generator) else RX_Data_from_orbcgen;
  IsData_from_FITrd_O       <= TX_IsData_from_txgen when (Control_register_I.Trigger_Gen.usage_generator /= use_TX_generator) else RX_IsData_from_orbcgen;
  RxData_rxclk_from_GBT_O   <= RX_Data_rxclk_from_GBT;
  IsRxData_rxclk_from_GBT_O <= RX_IsData_rxclk_from_GBT;

-- =============================================================

-- Reset FSM =================================================
  Reset_Generator_comp : entity work.Reset_Generator
    port map(
      RESET40_I => RESET_I,
      SysClk_I  => SysClk_I,
      DataClk_I => DataClk_I,

      Control_register_I => Control_register_I,

      SysClk_count_O => FSM_Clocks.System_Counter,

      Reset_DClk_O => FSM_Clocks.Reset_dclk,
      Reset_SClk_O => FSM_Clocks.Reset_sclk,
      ResetGBT_O   => gbt_reset
      );
-- =============================================================


-- RX Data Clk Sync ============================================
  RxData_ClkSync_comp : entity work.RXDATA_CLKSync
    port map (
      FSM_Clocks_I       => FSM_Clocks,
      Control_register_I => Control_register_I,

      RX_CLK_I => RxDataClk_I,

      RX_IS_DATA_RXCLK_I   => IsRxData_rxclk_to_FITrd_I,
      RX_DATA_RXCLK_I      => x"0" & RxData_rxclk_to_FITrd_I,
      RX_IS_DATA_DATACLK_O => RX_IsData_DataClk,
      RX_DATA_DataClk_O    => RX_exData_from_RXsync,
      CLK_PH_CNT_O         => FIT_GBT_STATUS.rx_phase,
      CLK_PH_ERROR_O       => FIT_GBT_STATUS.GBT_status.Rx_Phase_error
      );
-- =============================================================

-- RX Data Decoder ============================================
  ltu_rx_decoder_comp : entity work.ltu_rx_decoder
    port map (
      FSM_Clocks_I => FSM_Clocks,
      Control_register_I => Control_register_I,

      RX_IsData_I => RX_IsData_from_orbcgen,
      RX_Data_I   => RX_Data_from_orbcgen,

      ORBC_ID_from_CRU_O           => ORBC_ID_from_RXdecoder,
      ORBC_ID_from_CRU_corrected_O => ORBC_ID_corrected_from_RXdecoder,
      Trigger_O                    => FIT_GBT_STATUS.Trigger_from_CRU,

      Readout_Mode_O     => FIT_GBT_STATUS.Readout_Mode,
      CRU_Readout_Mode_O => FIT_GBT_STATUS.CRU_Readout_Mode,
      Start_run_O        => FIT_GBT_STATUS.Start_run,
      Stop_run_O         => FIT_GBT_STATUS.Stop_run,
      BCIDsync_Mode_O    => FIT_GBT_STATUS.BCIDsync_Mode
      );
-- =============================================================

-- DATA GENERATOR =====================================
  Module_Data_Gen_comp : entity work.Module_Data_Gen

    port map(
      FSM_Clocks_I => FSM_Clocks,

      Status_register_I  => FIT_GBT_STATUS,
      Control_register_I => Control_register_I,

      Board_data_I => Board_data_I,
      Board_data_O => Board_data_from_main_gen,

      datagen_report_o => FIT_GBT_STATUS.datagen_report
      );
-- =====================================================


-- CRU ORBC GENERATOR ==================================
  cru_ltu_emu_comp : entity work.cru_ltu_emu

    port map(
      FSM_Clocks_I => FSM_Clocks,

      Status_register_I  => FIT_GBT_STATUS,
      Control_register_I => Control_register_I,

      RX_IsData_I => RX_IsData_DataClk,
      RX_Data_I   => RX_Data_DataClk,

      RX_IsData_O => RX_IsData_from_orbcgen,
      RX_Data_O   => RX_Data_from_orbcgen
      );
-- =====================================================

-- Data Converter ===============================================
  DataConverter_comp : entity work.DataConverter
    port map(
      FSM_Clocks_I => FSM_Clocks,

      Status_register_I  => FIT_GBT_STATUS,
      Control_register_I => Control_register_I,

      Board_data_I => Board_data_from_main_gen,

      header_fifo_data_o  => raw_header_dout,
      data_fifo_data_o    => raw_data_dout,
      header_fifo_rden_i  => raw_heaer_rden,
      data_fifo_rden_i    => raw_data_rden,
      header_fifo_empty_o => raw_header_empty,
      no_data_o           => no_raw_data,

      drop_ounter_o  => FIT_GBT_STATUS.cnv_drop_cnt,
      fifo_cnt_max_o => FIT_GBT_STATUS.cnv_fifo_max,
      errors_o       => FIT_GBT_STATUS.fsm_errors(7 downto 5)
      );
-- ===========================================================

-- Event Selector ======================================
  Event_Selector_comp : entity work.Event_Selector
    port map (
      FSM_Clocks_I => FSM_Clocks,

      Status_register_I  => FIT_GBT_STATUS,
      Control_register_I => Control_register_I,

      header_fifo_data_i  => raw_header_dout,
      data_fifo_data_i    => raw_data_dout,
      header_fifo_rden_o  => raw_heaer_rden,
      data_fifo_rden_o    => raw_data_rden,
      header_fifo_empty_i => raw_header_empty,
      no_raw_data_i       => no_raw_data,


      slct_fifo_dout_o  => slct_fifo_dout,
      slct_fifo_empty_o => slct_fifo_empty,
      slct_fifo_rden_i  => slct_fifo_rden,

      cntpck_fifo_dout_o  => cntpck_fifo_dout,
      cntpck_fifo_empty_o => cntpck_fifo_empty,
      cntpck_fifo_rden_i  => cntpck_fifo_rden,

      slct_fifo_cnt_o     => open,
      slct_fifo_cnt_max_o => FIT_GBT_STATUS.sel_fifo_max,
      packets_dropped_o   => FIT_GBT_STATUS.sel_drop_cnt,
      errors_o            => FIT_GBT_STATUS.fsm_errors(4 downto 1)
      );
-- ===========================================================

-- CRU Packet Constructer ======================================
  CRU_packet_Builder_comp : entity work.CRU_packet_Builder
    port map (
      FSM_Clocks_I => FSM_Clocks,

      Status_register_I  => FIT_GBT_STATUS,
      Control_register_I => Control_register_I,

      SLCTFIFO_data_word_I => slct_fifo_dout,
      SLCTFIFO_Is_Empty_I  => slct_fifo_empty,
      SLCTFIFO_RE_O        => slct_fifo_rden,

      CNTPTFIFO_data_word_I => cntpck_fifo_dout,
      CNTPFIFO_Is_Empty_I   => cntpck_fifo_empty,
      CNTPFIFO_RE_O         => cntpck_fifo_rden,

      Is_Data_O => is_data_from_cru_constructor,
      Data_O    => data_from_cru_constructor,

      errors_o => FIT_GBT_STATUS.fsm_errors(0 downto 0)
      );
-- ===========================================================



-- TX Data Gen ===============================================
  TX_Data_Gen_comp : entity work.TX_Data_Gen
    port map(
      FSM_Clocks_I => FSM_Clocks,

      Control_register_I => Control_register_I,
      Status_register_I  => FIT_GBT_STATUS,

      TX_IsData_I => is_data_from_cru_constructor,
      TX_Data_I   => data_from_cru_constructor,

      TX_IsData_O => TX_IsData_from_txgen,
      TX_Data_O   => TX_Data_from_txgen,

      gbt_data_counter_o => FIT_GBT_STATUS.gbt_data_cnt
      );
-- ===========================================================


-- =============================================================
  gbt_bank_gen : if GENERATE_GBT_BANK = 1 generate
    gbtBankDsgn : entity work.GBT_TX_RX
      port map (
        RESET           => gbt_reset,
        MgtRefClk       => MgtRefClk_I,
        MGT_RX_P        => MGT_RX_P_I,
        MGT_RX_N        => MGT_RX_N_I,
        MGT_TX_P        => MGT_TX_P_O,
        MGT_TX_N        => MGT_TX_N_O,
        TXDataClk       => DataClk_I,
        TXData          => Data_to_GBT_I,
        TXData_SC       => x"0",
        IsTXData        => IsData_to_GBT_I,
        RXDataClk       => GBT_RxFrameClk_O,
        RXData          => RX_Data_rxclk_from_GBT,
        RXData_SC       => open,
        IsRXData        => RX_IsData_rxclk_from_GBT,
        reset_rx_errors => Control_register_I.reset_gbt_rxerror,
        GBT_Status_O    => from_gbt_bank_prj_GBT_status
        );
  end generate gbt_bank_gen;

  gbt_bank_gen_sim : if GENERATE_GBT_BANK = 0 generate
    MGT_TX_P_O                   <= '0';
    MGT_TX_N_O                   <= '0';
    GBT_RxFrameClk_O             <= DataClk_I;
    RX_Data_rxclk_from_GBT       <= (others => '0');
    RX_IsData_rxclk_from_GBT     <= '0';
    from_gbt_bank_prj_GBT_status <= test_gbt_status_void;
  end generate gbt_bank_gen_sim;
  -- =============================================================

end Behavioral;

