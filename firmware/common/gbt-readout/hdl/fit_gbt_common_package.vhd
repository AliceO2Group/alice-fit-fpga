----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D.A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    10:29:21 08/11/2017 
-- Design Name:         
-- Module Name:    
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package fit_gbt_common_package is



-- signal size constants ---------------------------------------
  constant GBT_data_word_bitdepth : integer := 80;
  constant GBT_slowcntr_bitdepth  : integer := 4;
  constant Orbit_id_bitdepth      : integer := 32;
  constant BC_id_bitdepth         : integer := 12;
  constant Trigger_bitdepth       : integer := 32;
  constant rx_phase_bitdepth      : integer := 3;
  constant n_pckt_wrds_bitdepth   : integer := 8;
-- -------------------------------------------------------------

-- Trigger constants -------------------------------------------
  constant TRG_const_void  : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000000";
  constant TRG_const_Orbit : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000001";  --0
  constant TRG_const_HB    : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000002";  --1
  constant TRG_const_HBr   : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000004";  --2
  constant TRG_const_HC    : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000008";  --3
  constant TRG_const_Ph    : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000010";  --4
  constant TRG_const_PP    : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000020";  --5
  constant TRG_const_Cal   : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000040";  --6
  constant TRG_const_SOT   : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000080";  --7
  constant TRG_const_EOT   : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000100";  --8
  constant TRG_const_SOC   : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000200";  --9
  constant TRG_const_EOC   : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000400";  --10
  constant TRG_const_TF    : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00000800";  -- time frame delimiter
  constant TRG_const_FErst : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00001000";  -- FEE reset
  constant TRG_const_RT    : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00002000";  -- Run Type; 1=Cont, 0=Trig
  constant TRG_const_RS    : std_logic_vector(Trigger_bitdepth-1 downto 0) := x"00004000";  --Running State; 1=Running

  constant LHC_BCID_max : std_logic_vector(BC_id_bitdepth-1 downto 0) := x"deb";
-- -------------------------------------------------------------

-- ===== FIT GBT Readout types =================================
  type FSM_Clocks_type is record
    Reset_dclk     : std_logic;         -- reset by gbt TX clock
    Reset_sclk     : std_logic;         -- reset system clock 320 MHz
    Data_Clk       : std_logic;
    System_Clk     : std_logic;
    System_Counter : std_logic_vector(3 downto 0);
    GBT_RX_Clk     : std_logic;         --used in TESTB
    IPBUS_Data_Clk : std_logic;         --used in TESTB
  end record;
-- =============================================================

-- ===== CONTROL REGISTER ======================================
  constant ctrl_reg_size : integer := 13;
  type ctrl_reg_t is array (0 to ctrl_reg_size-1) of std_logic_vector(31 downto 0);

  type Type_Gen_use_type is (use_NO_generator, use_MAIN_generator, use_TX_generator);
  type Type_trgGen_use_type is (use_NO_generator, use_CONT_generator, use_TX_generator);
  type Readout_command_type is (idle, continious, trigger);

  type Data_Gen_CONTROL_type is record
    usage_generator   : Type_Gen_use_type;
    trigger_resp_mask : std_logic_vector(Trigger_bitdepth-1 downto 0);  -- data generated for this trigger
    bunch_pattern     : std_logic_vector(31 downto 0);  -- pattern lenghts of packet 
    bunch_freq        : std_logic_vector(15 downto 0);  -- pattern frequency
    bc_start          : std_logic_vector(BC_id_bitdepth-1 downto 0);  -- offset of freq counter to first Orbit TRG
  end record;

  type Trigger_Gen_CONTROL_type is record
    usage_generator    : Type_trgGen_use_type;
    Readout_command    : Readout_command_type;
    trigger_pattern    : std_logic_vector(63 downto 0);  -- trigger pattern 32 BC lenght
    trigger_cont_value : std_logic_vector(Trigger_bitdepth-1 downto 0);  -- trigger that sendign continious
    bunch_freq         : std_logic_vector(15 downto 0);  -- trigger frequency
    bc_start           : std_logic_vector(BC_id_bitdepth-1 downto 0);  -- offset of freq counter to first Orbit TRG
  end record;

  type RDH_data_type is record
    FEE_ID  : std_logic_vector(15 downto 0);
    SYS_ID  : std_logic_vector(7 downto 0);
    PRT_BIT : std_logic_vector(7 downto 0);
  end record;

  type CONTROL_REGISTER_type is record
    Data_Gen    : Data_Gen_CONTROL_type;
    Trigger_Gen : Trigger_Gen_CONTROL_type;
    RDH_data    : RDH_data_type;

    readout_bypass  : std_logic;
    is_hb_response  : std_logic;
    force_idle      : std_logic;  -- reset phase error, sync move to start, lock CNT/TRG mode to IDLE
    trg_data_select : std_logic_vector(Trigger_bitdepth-1 downto 0);

    BCID_offset : std_logic_vector(BC_id_bitdepth-1 downto 0);  -- delay between ID from TX and ID in module data

    reset_orbc_sync     : std_logic;    -- sync ORBIT, BC to CRU
    reset_data_counters : std_logic;    -- reset FIFO statistic
    reset_gensync       : std_logic;    -- reset generators offset
    reset_gbt_rxerror   : std_logic;    -- reset gbt rx error bit
    reset_rxph_error    : std_logic;    -- reset gbt phase error
    reset_readout       : std_logic;    -- reset readout fsm
    reset_gbt           : std_logic;    -- reset gbt

  end record;

  constant test_CONTROL_REG : CONTROL_REGISTER_type :=
    (
      Data_Gen            => (
        usage_generator   => use_TX_generator,
        trigger_resp_mask => TRG_const_void,
        bunch_pattern     => x"10e0766f",
        bunch_freq        => x"0deb",
        bc_start          => x"ddc"
        ),

      Trigger_Gen          => (
        usage_generator    => use_CONT_generator,
        Readout_command    => idle,
        trigger_pattern    => x"0000000080000000",
        trigger_cont_value => TRG_const_Ph,
        bunch_freq         => x"0deb",
        bc_start           => x"ddc"
        ),

      RDH_data  => (
        FEE_ID  => x"0001",
        SYS_ID  => x"ff",
        PRT_BIT => x"00"
        ),

      readout_bypass  => '0',
      is_hb_response  => '1',
      trg_data_select => x"00000010",

      BCID_offset => x"01f",

      reset_orbc_sync     => '0',
      reset_data_counters => '0',
      reset_gensync       => '0',
      reset_gbt_rxerror   => '0',
      reset_readout       => '0',
      reset_gbt           => '0',
      reset_rxph_error    => '0',
      force_idle          => '0'
      );
-- =============================================================

-- ===== FIT GBT STATUS ========================================
  constant stat_reg_size         : integer := 9;
  constant stat_reg_size_sim     : integer := stat_reg_size+6;
  constant ipbusrd_fifo_out_addr : integer := 8;
  type stat_reg_t is array (0 to stat_reg_size-1) of std_logic_vector(31 downto 0);
  type stat_reg_sim_t is array (0 to stat_reg_size_sim-1) of std_logic_vector(31 downto 0);  -- extended status registers set for simulation (trigger added)

  type Type_Readout_Mode is (mode_IDLE, mode_CNT, mode_TRG);
  type Type_BCIDsync_Mode is (mode_STR, mode_SYNC, mode_LOST);

  type Type_GBT_status is record
    mgt_phalin_cplllock : std_logic;    --reg bit 0
    rxWordClkReady      : std_logic;    --reg bit 1
    rxFrameClkReady     : std_logic;    --reg bit 2
    mgtLinkReady        : std_logic;    --reg bit 3
    tx_resetDone        : std_logic;    --reg bit 4
    tx_fsmResetDone     : std_logic;    --reg bit 5
    gbtRx_Ready         : std_logic;    --reg bit 6
    gbtRx_ErrorDet      : std_logic;    --reg bit 7
    gbtRx_ErrorLatch    : std_logic;    --reg bit 8

    Rx_Phase_error : std_logic;         --reg bit 9
  end record;

  type Type_datagen_report is record
    orbit          : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
    bc             : std_logic_vector(BC_id_bitdepth-1 downto 0);
    size           : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
    packet_num     : std_logic_vector(35 downto 0);
    sel_fifo_count : std_logic_vector(15 downto 0);
  end record;


  type FIT_GBT_status_type is record
    GBT_status     : Type_GBT_status;
    datagen_report : Type_datagen_report;  -- header of generated data; used only in simulation

    Readout_Mode     : Type_Readout_Mode;
    CRU_Readout_Mode : Type_Readout_Mode;
    BCIDsync_Mode    : Type_BCIDsync_Mode;
    Start_run        : std_logic;
    Stop_run         : std_logic;

    Trigger_from_CRU         : std_logic_vector(Trigger_bitdepth-1 downto 0);  -- Trigger ID from CRUS
    BCID_from_CRU            : std_logic_vector(BC_id_bitdepth-1 downto 0);  -- BC ID from CRUS
    ORBIT_from_CRU           : std_logic_vector(Orbit_id_bitdepth-1 downto 0);  -- ORBIT from CRUS
    BCID_from_CRU_corrected  : std_logic_vector(BC_id_bitdepth-1 downto 0);  -- BC ID from CRUS
    ORBIT_from_CRU_corrected : std_logic_vector(Orbit_id_bitdepth-1 downto 0);  -- ORBIT from CRUS

    rx_phase     : std_logic_vector(rx_phase_bitdepth-1 downto 0);
    cnv_fifo_max : std_logic_vector(15 downto 0);
    cnv_drop_cnt : std_logic_vector(15 downto 0);
    sel_fifo_max : std_logic_vector(15 downto 0);
    sel_drop_cnt : std_logic_vector(15 downto 0);
    gbt_data_cnt : std_logic_vector(31 downto 0);

    -- readout via IPbus, used in FTM only
    ipbusrd_fifo_cnt : std_logic_vector(15 downto 0);
    ipbusrd_fifo_out : std_logic_vector(31 downto 0);

    -- errors indicate unexpected FSM state, should be reset and debugged
    -- 0 - [RDH builder] slct_fifo is empty while reading data
    -- 1 - [Selector] slct_fifo is not empty when run starts
    -- 2 - [Selector] cntpck_fifo is not empty when run starts
    -- 3 - [Selector] trg_fifo is not empty when run starts
    -- 4 - [Selector] trg_fifo was full
    -- 5 - [Converter] data_fifo is not empty while start of run
    -- 6 - [Converter] header_fifo is not empty while start of run
    fsm_errors : std_logic_vector(15 downto 0);
  end record;

  constant test_gbt_status_void : Type_GBT_status :=
    (
      mgt_phalin_cplllock => '0',

      rxWordClkReady  => '0',
      rxFrameClkReady => '0',

      mgtLinkReady    => '0',
      tx_resetDone    => '0',
      tx_fsmResetDone => '0',

      gbtRx_Ready      => '0',
      gbtRx_ErrorDet   => '0',
      gbtRx_ErrorLatch => '0',

      Rx_Phase_error => '0'
      );
-- =============================================================

-- ###################### CONVERSION FUNCTION ##############################
-- FIT data header, formed in converter ---------------------------
  function func_FITDATAHD_get_header
    (
      channel_n_words : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
      ORBIT           : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
      BCID            : std_logic_vector(BC_id_bitdepth-1 downto 0);
      rx_phase        : std_logic_vector(rx_phase_bitdepth-1 downto 0);
      rx_phase_error  : std_logic;
      is_tcm          : std_logic
      )
    return std_logic_vector;

  function func_FITDATAHD_ndwords (header_w : std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector;
  function func_FITDATAHD_orbit (header_w   : std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector;
  function func_FITDATAHD_bc (header_w      : std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector;
-- ----------------------------------------------------------------



-- Control Register addres reg ------------------------------------
  function func_CNTRREG_getcntrreg (cntrl_reg_addrreg : ctrl_reg_t) return CONTROL_REGISTER_type;
  function func_STATREG_getaddrreg (status_reg        : FIT_GBT_status_type) return stat_reg_t;
  function func_STATREG_getaddrreg_sim (status_reg    : FIT_GBT_status_type) return stat_reg_sim_t;
-- ----------------------------------------------------------------

end fit_gbt_common_package;



package body fit_gbt_common_package is

-- ###################### CONVERSION FUNCTION ##############################

-- FIT data header, formed in converter ---------------------------
  function func_FITDATAHD_get_header
    (
      channel_n_words : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
      ORBIT           : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
      BCID            : std_logic_vector(BC_id_bitdepth-1 downto 0);
      rx_phase        : std_logic_vector(rx_phase_bitdepth-1 downto 0);
      rx_phase_error  : std_logic;
      is_tcm          : std_logic
      )
    return std_logic_vector is

  begin
    return x"F"&channel_n_words(3 downto 0) & x"000_00" & "000" & is_tcm & rx_phase_error & rx_phase & ORBIT & BCID;

  end function;

  function func_FITDATAHD_ndwords (header_w : std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector is
  begin return x"0"&header_w(GBT_data_word_bitdepth-1-4 downto GBT_data_word_bitdepth-n_pckt_wrds_bitdepth); end function;

  function func_FITDATAHD_orbit (header_w : std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector is
  begin return header_w(BC_id_bitdepth+Orbit_id_bitdepth-1 downto BC_id_bitdepth); end function;

  function func_FITDATAHD_bc (header_w : std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector is
  begin return header_w(BC_id_bitdepth-1 downto 0); end function;
-- ----------------------------------------------------------------



  function func_CNTRREG_getcntrreg (cntrl_reg_addrreg : ctrl_reg_t) return CONTROL_REGISTER_type is

    variable cntr_reg : CONTROL_REGISTER_type;

  begin

    if(cntrl_reg_addrreg(0)(3 downto 0) = x"0") then
      cntr_reg.Data_Gen.usage_generator := use_NO_generator;
    elsif(cntrl_reg_addrreg(0)(3 downto 0) = x"1") then
      cntr_reg.Data_Gen.usage_generator := use_MAIN_generator;
    elsif(cntrl_reg_addrreg(0)(3 downto 0) = x"2") then
      cntr_reg.Data_Gen.usage_generator := use_TX_generator;
    else
      cntr_reg.Data_Gen.usage_generator := use_NO_generator;
    end if;



    if(cntrl_reg_addrreg(0)(19 downto 16) = x"0") then
      cntr_reg.Trigger_Gen.Readout_command := idle;
    elsif(cntrl_reg_addrreg(0)(19 downto 16) = x"1") then
      cntr_reg.Trigger_Gen.Readout_command := continious;
    elsif(cntrl_reg_addrreg(0)(19 downto 16) = x"2") then
      cntr_reg.Trigger_Gen.Readout_command := trigger;
    else
      cntr_reg.Trigger_Gen.Readout_command := idle;
    end if;



    if(cntrl_reg_addrreg(0)(7 downto 4) = x"0") then
      cntr_reg.Trigger_Gen.usage_generator := use_NO_generator;
    elsif(cntrl_reg_addrreg(0)(7 downto 4) = x"1") then
      cntr_reg.Trigger_Gen.usage_generator := use_CONT_generator;
    elsif(cntrl_reg_addrreg(0)(7 downto 4) = x"2") then
      cntr_reg.Trigger_Gen.usage_generator := use_TX_generator;
    else
      cntr_reg.Trigger_Gen.usage_generator := use_NO_generator;
    end if;

    cntr_reg.is_hb_response := cntrl_reg_addrreg(0)(20);
    cntr_reg.readout_bypass := cntrl_reg_addrreg(0)(21);
    cntr_reg.force_idle     := cntrl_reg_addrreg(0)(22);

    cntr_reg.reset_orbc_sync     := cntrl_reg_addrreg(0)(8);
    cntr_reg.reset_data_counters := cntrl_reg_addrreg(0)(9);
    cntr_reg.reset_gensync       := cntrl_reg_addrreg(0)(10);
    cntr_reg.reset_gbt_rxerror   := cntrl_reg_addrreg(0)(11);
    cntr_reg.reset_gbt           := cntrl_reg_addrreg(0)(12);
    cntr_reg.reset_rxph_error    := cntrl_reg_addrreg(0)(13);
    cntr_reg.reset_readout       := cntrl_reg_addrreg(0)(14);


    cntr_reg.Data_Gen.trigger_resp_mask                := cntrl_reg_addrreg(1);
    cntr_reg.Data_Gen.bunch_pattern                    := cntrl_reg_addrreg(2);
    -- reg3 is empty
    cntr_reg.Trigger_Gen.trigger_pattern(63 downto 32) := cntrl_reg_addrreg(4);
    cntr_reg.Trigger_Gen.trigger_pattern(31 downto 0)  := cntrl_reg_addrreg(5);
    cntr_reg.Trigger_Gen.trigger_cont_value            := cntrl_reg_addrreg(6);


    cntr_reg.Trigger_Gen.bunch_freq := cntrl_reg_addrreg(7)(31 downto 16);
    cntr_reg.Data_Gen.bunch_freq    := cntrl_reg_addrreg(7)(15 downto 0);
    cntr_reg.Trigger_Gen.bc_start   := cntrl_reg_addrreg(8)(27 downto 16);
    cntr_reg.Data_Gen.bc_start      := cntrl_reg_addrreg(8)(11 downto 0);

    cntr_reg.RDH_data.FEE_ID  := cntrl_reg_addrreg(9)(15 downto 0);
    cntr_reg.RDH_data.SYS_ID  := cntrl_reg_addrreg(9)(23 downto 16);
    cntr_reg.RDH_data.PRT_BIT := cntrl_reg_addrreg(9)(31 downto 24);

    cntr_reg.BCID_offset     := cntrl_reg_addrreg(11)(11 downto 0);
    cntr_reg.trg_data_select := cntrl_reg_addrreg(12)(31 downto 0);

    return cntr_reg;
  end function;





  function func_STATREG_getaddrreg (status_reg : FIT_GBT_status_type) return stat_reg_t is
    variable status_reg_addrreg : stat_reg_t;
    variable gbt_status         : std_logic_vector(15 downto 0);
    variable bcid_sync_mode     : std_logic_vector(3 downto 0);
    variable rd_mode            : std_logic_vector(3 downto 0);
    variable cru_rd_mode        : std_logic_vector(3 downto 0);

  begin


    gbt_status := "000000"
                  & status_reg.GBT_status.Rx_Phase_error
                  & status_reg.GBT_status.gbtRx_ErrorLatch
                  & status_reg.GBT_status.gbtRx_ErrorDet
                  & status_reg.GBT_status.gbtRx_Ready
                  & status_reg.GBT_status.tx_fsmResetDone
                  & status_reg.GBT_status.tx_resetDone
                  & status_reg.GBT_status.mgtLinkReady
                  & status_reg.GBT_status.rxFrameClkReady
                  & status_reg.GBT_status.rxWordClkReady
                  & status_reg.GBT_status.mgt_phalin_cplllock;


    if status_reg.Readout_Mode = mode_IDLE then
      rd_mode := x"0";
    elsif status_reg.Readout_Mode = mode_CNT then
      rd_mode := x"1";
    elsif status_reg.Readout_Mode = mode_TRG then
      rd_mode := x"2";
    else
      rd_mode := x"f";
    end if;

    if status_reg.CRU_Readout_Mode = mode_IDLE then
      cru_rd_mode := x"0";
    elsif status_reg.CRU_Readout_Mode = mode_CNT then
      cru_rd_mode := x"1";
    elsif status_reg.CRU_Readout_Mode = mode_TRG then
      cru_rd_mode := x"2";
    else
      cru_rd_mode := x"f";
    end if;

    if status_reg.BCIDsync_Mode = mode_STR then
      bcid_sync_mode := x"0";
    elsif status_reg.BCIDsync_Mode = mode_SYNC then
      bcid_sync_mode := x"1";
    elsif status_reg.BCIDsync_Mode = mode_LOST then
      bcid_sync_mode := x"2";
    else
      bcid_sync_mode := x"f";
    end if;



    status_reg_addrreg(0)                     := cru_rd_mode & "0"&status_reg.rx_phase & bcid_sync_mode & rd_mode & gbt_status;
    status_reg_addrreg(1)                     := status_reg.ORBIT_from_CRU;
    status_reg_addrreg(2)                     := status_reg.fsm_errors & x"0" & status_reg.BCID_from_CRU;
    status_reg_addrreg(3)                     := status_reg.cnv_fifo_max & status_reg.cnv_drop_cnt;
    status_reg_addrreg(4)                     := status_reg.sel_fifo_max & status_reg.sel_drop_cnt;
    status_reg_addrreg(5)                     := status_reg.gbt_data_cnt;
    status_reg_addrreg(6)                     := x"00000000";
    status_reg_addrreg(7)                     := ipbusrd_fifo_cnt & x"0000";
    status_reg_addrreg(ipbusrd_fifo_out_addr) := ipbusrd_fifo_out;  --8


    return status_reg_addrreg;
  end function;

  function func_STATREG_getaddrreg_sim (status_reg : FIT_GBT_status_type) return stat_reg_sim_t is
    variable status_reg_addrreg     : stat_reg_t;
    variable status_reg_addrreg_sim : stat_reg_sim_t;

  begin
    status_reg_addrreg := func_STATREG_getaddrreg(status_reg);
    for i in 0 to stat_reg_size-1 loop
      status_reg_addrreg_sim(i) := status_reg_addrreg(i);
    end loop;

    status_reg_addrreg_sim(9)  := status_reg.ORBIT_from_CRU_corrected;
    status_reg_addrreg_sim(10) := x"00000" & status_reg.BCID_from_CRU_corrected;
    status_reg_addrreg_sim(11) := status_reg.Trigger_from_CRU;
    status_reg_addrreg_sim(12) := status_reg.datagen_report.orbit;
    status_reg_addrreg_sim(13) := x"00" & status_reg.datagen_report.size & x"0" & status_reg.datagen_report.bc;
    status_reg_addrreg_sim(14) := status_reg.datagen_report.packet_num(31 downto 0);
    --packet_num
    return status_reg_addrreg_sim;
  end function;
-- ----------------------------------------------------------------

-- #########################################################################
end fit_gbt_common_package;

