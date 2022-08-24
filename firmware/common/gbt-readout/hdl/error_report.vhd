----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    07/2022 
-- Description: provides error reporting via check registers
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.all;
use work.fit_gbt_common_package.all;


entity error_report is
  port (
    RESET_I      : in std_logic;
    FSM_Clocks_I : in rdclocks_t;

    Status_register_I  : in readout_status_t;
    Control_register_I : in readout_control_t;

    RX_IsData_I : in std_logic;
    RX_Data_I   : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);

    err_report_fifo_rden_i : in  std_logic;
    report_fifo_o          : out std_logic_vector(31 downto 0)
    );
end error_report;

architecture Behavioral of error_report is

  -- shift registers for data history report
  signal gbt_data_shreg   : std_logic_vector(errrep_crugbt_len*96-1 downto 0);
  signal gbt_data_counter : std_logic_vector(15 downto 0);

  -- error report register
  signal err_rep_pmdat, err_rep_gbtcru, err_rep_mux : std_logic_vector(errrep_fifo_len*32-1 downto 0);

  -- report fifo output
  signal report_fifo_full, snshot_fifo_emtpy, snshot_fifo_rden, report_fifo_rden : std_logic;
  signal snshot_fifo_do, report_fifo_do                        : std_logic_vector(31 downto 0);

  -- trigger for error
  signal err_trg_bclost, err_trg_pmhd                  : std_logic;
  signal bcsync_lost_inrun, bcsync_lost_inrun_ff       : std_logic;
  signal pm_data_early_header, pm_data_early_header_ff : std_logic;
  
  -- reset signal
  signal reset : std_logic;

  -- attribute mark_debug                      : string;
  -- attribute mark_debug of gbt_data_shreg    : signal is "true";
  -- attribute mark_debug of err_rep_pmdat     : signal is "true";
  -- attribute mark_debug of err_rep_gbtcru    : signal is "true";
  -- attribute mark_debug of err_rep_mux       : signal is "true";
  -- attribute mark_debug of report_fifo_do    : signal is "true";
  -- attribute mark_debug of err_trg_bclost    : signal is "true";
  -- attribute mark_debug of err_trg_pmhd      : signal is "true";
  -- attribute mark_debug of snshot_fifo_do    : signal is "true";
  -- attribute mark_debug of snshot_fifo_emtpy : signal is "true";
  -- attribute mark_debug of snshot_fifo_rden  : signal is "true";
  -- attribute mark_debug of report_fifo_full  : signal is "true";
  -- attribute mark_debug of report_fifo_rden  : signal is "true";


begin

-- signal mapping ------------------------------------------
  report_fifo_o        <= report_fifo_do;
  report_fifo_rden     <= err_report_fifo_rden_i;
  bcsync_lost_inrun    <= Status_register_I.fsm_errors(10);
  pm_data_early_header <= Status_register_I.fsm_errors(9);

  -- errors report mapping
  err_rep_gbtcru(31 downto 0)                       <= x"EEEE000A";  -- header
  err_rep_gbtcru(errrep_crugbt_len*96+31 downto 32) <= gbt_data_shreg;

  err_rep_pmdat(31 downto 0)                                        <= x"EEEE0009";  -- header
  err_rep_pmdat(errrep_pmdat_len*80+31 downto 32)                   <= Status_register_I.pm_data_buff;
  err_rep_pmdat(errrep_fifo_len*32-1 downto errrep_pmdat_len*80+32) <= (others => '0');


-- triggering bcid sync lost error snapshot
  err_trg_bclost <= '1' when bcsync_lost_inrun = '1' and bcsync_lost_inrun_ff = '0'       else '0';
  err_trg_pmhd   <= '1' when pm_data_early_header = '1' and pm_data_early_header_ff = '0' else '0';

  err_rep_mux <= err_rep_gbtcru when err_trg_bclost='1' else
                 err_rep_pmdat  when err_trg_pmhd = '1' else
				 (others => '0');





-- shapshot fifo =============================================
  error_rep_fifo_cmp : entity work.snapshot_fifo
    generic map(n32_size => errrep_fifo_len)
    port map(
      wr_clk_i  => FSM_Clocks_I.Data_Clk,
      rd_clk_i  => FSM_Clocks_I.ipbus_clk,
      asreset_i => reset,

      di_i    => err_rep_mux,
      do_o    => snshot_fifo_do,
      empty_o => snshot_fifo_emtpy,

      wren_i => err_trg_bclost or err_trg_pmhd,
      rden_i => snshot_fifo_rden
      );
  snshot_fifo_rden <= '1' when snshot_fifo_emtpy = '0' and report_fifo_full = '0' else '0';
-- ===========================================================

-- error report fifo =========================================
  err_report_fifo_comp : entity work.err_report_fifo
    port map(
      clk   => FSM_Clocks_I.ipbus_clk,
      srst  => reset,
      WR_EN => snshot_fifo_rden,
      RD_EN => report_fifo_rden,
      DIN   => snshot_fifo_do,
      DOUT  => report_fifo_do,
      FULL  => report_fifo_full,
      EMPTY => open
      );
-- ===========================================================





-- data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then
	
	  -- reset
	  reset <= Control_register_I.reset_err_report or RESET_I;

      -- errors signals
      bcsync_lost_inrun_ff    <= bcsync_lost_inrun;
      pm_data_early_header_ff <= pm_data_early_header;

      -- errors report mapping (delayed)
      err_rep_gbtcru((errrep_crugbt_len*96)+32*2-1 downto (errrep_crugbt_len*96)+32*1) <= x"0"&Status_register_I.BCID_from_CRU & x"0"&Status_register_I.ORBC_from_CRU_sync(11 downto 0);
      err_rep_gbtcru((errrep_crugbt_len*96)+32*3-1 downto (errrep_crugbt_len*96)+32*2) <= Status_register_I.ORBIT_from_CRU;
      err_rep_gbtcru((errrep_crugbt_len*96)+32*4-1 downto (errrep_crugbt_len*96)+32*3) <= Status_register_I.ORBC_from_CRU_sync(32+12-1 downto 12);
      err_rep_gbtcru(errrep_fifo_len*32-1 downto (errrep_crugbt_len*96)+32*4)          <= (others => '0');


      if (reset = '1') then

        gbt_data_counter        <= (others => '0');
        gbt_data_shreg          <= (others => '0');
        bcsync_lost_inrun_ff    <= '0';
        pm_data_early_header_ff <= '0';

      else

        gbt_data_counter <= gbt_data_counter+1;

        -- shift registers for error reporting
        --if RX_IsData_I = '1' then
        gbt_data_shreg <= gbt_data_shreg(errrep_crugbt_len*96-97 downto 0) & "000" & RX_IsData_I & gbt_data_counter(11 downto 0) & RX_Data_I;
        --end if;


      end if;

    end if;

  end process;
-- ***************************************************

end Behavioral;
















































