----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: convert data from FEE to RDH format
--
-- Revision: 09/2021
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

    header_fifo_data_o  : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    data_fifo_data_o    : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    header_fifo_rden_i  : in  std_logic;
    data_fifo_rden_i    : in  std_logic;
    header_fifo_empty_o : out std_logic;
    data_fifo_empty_o   : out std_logic;
    no_data_o           : out boolean;

    drop_ounter_o  : out std_logic_vector(15 downto 0);
    fifo_cnt_max_o : out std_logic_vector(15 downto 0);

    raw_data_o   : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    raw_isdata_o : out std_logic;
    data_bcid_o  : out std_logic_vector(BC_id_bitdepth-1 downto 0);
    data_bcen_o  : out std_logic;

    -- errors indicate unexpected FSM state, should be reset and debugged
    -- 0 - data_fifo is not empty while start of run
    -- 1 - header_fifo is not empty while start of run
    -- 2 - tcm_data_fifo is full (for tcm only)
    -- 3 - input packet corrupted: extra word 
    -- 4 - input packet corrupted: header too early
	pm_data_shreg_o : out std_logic_vector(errrep_pmdat_len*80-1 downto 0);
	rawdatfifo_wr_rate_o : out std_logic_vector(11 downto 0);
	rawdatfifo_rd_rate_o : out std_logic_vector(11 downto 0);
    errors_o : out std_logic_vector(4 downto 0)
    );
end DataConverter;

architecture Behavioral of DataConverter is

  constant board_data_void_const : board_data_type :=
    (
      is_header => '0',
      is_data   => '0',
      data_word => (others => '0')
      );

  signal header_pcklen, header_pcklen_ff, header_pcklen_latch, header_pcklen_latch_m1 : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  signal header_orbit                                         : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal header_bc                                            : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal header_word, header_word_latch, data_word            : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal is_header, is_data                                   : std_logic;
  signal zero_pck                                             : boolean;

  signal readout_bypass                                : boolean;
  signal data_enabled, data_enabled_sclk, start_of_run : boolean;
  signal reset_drop_counters                           : std_logic;
  signal drop_counter                                  : std_logic_vector(15 downto 0);

  signal data_rawfifo_cnt, rawfifo_cnt_max                    : std_logic_vector(12 downto 0);
  signal header_rawfifo_full, data_rawfifo_full, rawfifo_full : std_logic;


  signal sending_event, sending_event_dc : boolean;
  signal word_counter                    : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);

  signal header_fifo_din, data_fifo_din                                               : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal header_fifo_we, data_fifo_we                                                 : std_logic;
  signal header_fifo_empty, header_fifo_empty_dc, data_fifo_empty, data_fifo_empty_dc : std_logic;

  signal errors                           : std_logic_vector(1 downto 0);
  signal err_extra_word, err_extra_header : std_logic;

  signal header_fifo_data : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal data_fifo_data   : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal header_fifo_rden : std_logic;
  signal data_fifo_rden   : std_logic;
  
  signal pm_data_shreg, pm_data_shreg_dclk : std_logic_vector(errrep_pmdat_len*80-1 downto 0);
  
  signal rawdat_rate_cnt_cnt, rawdat_rate_cnt_wr, rawdat_rate_cnt_rd : std_logic_vector(11 downto 0);
  signal rawdat_rate_wr, rawdat_rate_rd : std_logic_vector(11 downto 0);
  signal rawdat_rate_wr_dc, rawdat_rate_rd_dc : std_logic_vector(11 downto 0);

  -- attribute mark_debug                      : string;
  -- attribute mark_debug of reset_drop_counters : signal is "true";
  -- attribute mark_debug of header_fifo_din     : signal is "true";
  -- attribute mark_debug of data_fifo_din       : signal is "true";
  -- attribute mark_debug of header_fifo_we      : signal is "true";
  -- attribute mark_debug of data_fifo_we        : signal is "true";
  -- attribute mark_debug of word_counter        : signal is "true";
  -- attribute mark_debug of sending_event     : signal is "true";
  -- attribute mark_debug of header_word         : signal is "true";
  -- attribute mark_debug of data_word           : signal is "true";
  -- attribute mark_debug of is_data             : signal is "true";
  -- attribute mark_debug of is_header           : signal is "true";
  -- attribute mark_debug of header_pcklen_ff    : signal is "true";
  -- attribute mark_debug of header_word_latch   : signal is "true";
  -- attribute mark_debug of header_pcklen_latch : signal is "true";
  -- attribute mark_debug of header_fifo_empty : signal is "true";
  -- attribute mark_debug of data_fifo_empty   : signal is "true";
  -- attribute mark_debug of header_rawfifo_full : signal is "true";
  -- attribute mark_debug of data_rawfifo_full   : signal is "true";
  -- attribute mark_debug of header_fifo_data    : signal is "true";
  -- attribute mark_debug of data_fifo_data      : signal is "true";
  -- attribute mark_debug of header_fifo_rden    : signal is "true";
  -- attribute mark_debug of data_fifo_rden      : signal is "true";
  -- attribute mark_debug of pm_data_shreg      : signal is "true";
  -- attribute mark_debug of err_extra_word      : signal is "true";
  -- attribute mark_debug of err_extra_header      : signal is "true";


begin

  header_fifo_empty_o <= header_fifo_empty;
  data_fifo_empty_o   <= data_fifo_empty;

  header_pcklen <= func_PMHEADER_n_dwords(Board_data_I.data_word);
  header_orbit  <= func_PMHEADER_getORBIT(Board_data_I.data_word);
  header_bc     <= func_PMHEADER_getBC(Board_data_I.data_word);

  raw_data_o   <= Board_data_I.data_word;
  raw_isdata_o <= Board_data_I.is_data;
  data_bcid_o  <= header_bc;
  data_bcen_o  <= Board_data_I.is_header;

  header_fifo_data_o <= header_fifo_data;
  data_fifo_data_o   <= data_fifo_data;
  header_fifo_rden   <= header_fifo_rden_i;
  data_fifo_rden     <= data_fifo_rden_i;
  
  pm_data_shreg_o <= pm_data_shreg_dclk;
  rawdatfifo_wr_rate_o <= rawdat_rate_wr_dc;
  rawdatfifo_rd_rate_o <= rawdat_rate_rd_dc;


---- Raw_header_fifo =============================================
  raw_header_fifo_comp : entity work.raw_data_fifo
    port map(
      clk        => FSM_Clocks_I.System_Clk,
      srst       => FSM_Clocks_I.Reset_sclk,
      WR_EN      => header_fifo_we,
      RD_EN      => header_fifo_rden,
      DIN        => header_fifo_din,
      DOUT       => header_fifo_data,
      data_count => open,
      prog_full  => header_rawfifo_full,
      FULL       => open,
      EMPTY      => header_fifo_empty
      );
---- ===========================================================


---- Raw_data_fifo =============================================
  raw_data_fifo_comp : entity work.raw_data_fifo
    port map(
      clk        => FSM_Clocks_I.System_Clk,
      srst       => FSM_Clocks_I.Reset_sclk,
      WR_EN      => data_fifo_we,
      RD_EN      => data_fifo_rden,
      DIN        => data_fifo_din,
      DOUT       => data_fifo_data,
      data_count => data_rawfifo_cnt,
      prog_full  => data_rawfifo_full,
      FULL       => open,
      EMPTY      => data_fifo_empty
      );
---- ===========================================================

  rawfifo_full <= header_rawfifo_full or data_rawfifo_full;

  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then
      header_fifo_empty_dc <= header_fifo_empty;
      data_fifo_empty_dc   <= data_fifo_empty;
      sending_event_dc     <= sending_event;

      data_enabled   <= Status_register_I.data_enable = '1';
      drop_ounter_o  <= drop_counter;
      fifo_cnt_max_o <= "000"&rawfifo_cnt_max;
      errors_o       <= err_extra_header&err_extra_word&'0'&errors;
      no_data_o      <= header_fifo_empty_dc = '1' and data_fifo_empty_dc = '1' and not sending_event_dc and not data_enabled;
	  
	  pm_data_shreg_dclk <= pm_data_shreg;
	  rawdat_rate_wr_dc <= rawdat_rate_wr;
	  rawdat_rate_rd_dc <= rawdat_rate_rd;
    end if;
  end process;


-- sys ff data clk ***********************************
  process (FSM_Clocks_I.System_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.System_Clk)) then

      reset_drop_counters <= Control_register_I.reset_data_counters;
      start_of_run        <= Status_register_I.Start_run = '1';
      readout_bypass      <= Control_register_I.readout_bypass = '1';


      header_word      <= func_FITDATAHD_get_header(header_pcklen, header_orbit, header_bc, Status_register_I.rx_phase, Status_register_I.Rx_Phase_error, '0');
      data_word        <= Board_data_I.data_word;
      is_data          <= Board_data_I.is_data;
      is_header        <= Board_data_I.is_header;
      header_pcklen_ff <= header_pcklen;
      zero_pck         <= false;

      data_enabled_sclk <= data_enabled;


      if(FSM_Clocks_I.Reset_sclk = '1') then

        sending_event    <= false;
        drop_counter     <= (others => '0');
        rawfifo_cnt_max  <= (others => '0');
        word_counter     <= (others => '1');
        errors           <= (others => '0');
        err_extra_word   <= '0';
        err_extra_header <= '0';

      else

        if is_header = '1' then

          if (word_counter < header_pcklen_latch) then  -- header is too early, skiping heade
            err_extra_header <= '1';
          else  -- header after prev packet - ok; or word_counter is max (start)
            header_word_latch                                                                          <= header_word;
            header_pcklen_latch                                                                        <= header_pcklen_ff;
            header_pcklen_latch_m1                                                                     <= header_pcklen_ff-1;
            zero_pck                                                                                   <= header_pcklen_ff = 0;
            word_counter                                                                               <= (others => '0');
            sending_event                                                                              <= (rawfifo_full = '0') and data_enabled_sclk;
            if (rawfifo_full = '1') and data_enabled_sclk and drop_counter /= x"ffff" then drop_counter <= drop_counter + 1; end if;
          end if;

        elsif is_data = '1' then

          if (word_counter = header_pcklen_latch) and (err_extra_header = '0') then err_extra_word <= '1'; end if;
          word_counter                                                                             <= word_counter + 1;

        end if;

        -- turning off sending_event while idle without data for clear error 'ready for run'            
        if not data_enabled_sclk and header_fifo_empty = '1' and data_fifo_empty = '1' and is_data = '0' then
          sending_event <= false; end if;

        if rawfifo_cnt_max < data_rawfifo_cnt then rawfifo_cnt_max <= data_rawfifo_cnt; end if;

        if reset_drop_counters = '1' then
          drop_counter    <= (others => '0');
          rawfifo_cnt_max <= (others => '0');
        end if;

        if start_of_run then errors <= (not header_fifo_empty) & (not data_fifo_empty); end if;
		
		-- circle pm data buffer for error report
		if (Board_data_I.is_data = '1') or (Board_data_I.is_header = '1') then 
		  pm_data_shreg <= pm_data_shreg((errrep_pmdat_len-1)*80-1 downto 0)&Board_data_I.data_word;
		end if;
		
		-- raw fifo wr/rd rate
		if rawdat_rate_cnt_cnt = x"3e8" then
		  rawdat_rate_rd <= rawdat_rate_cnt_rd;
		  rawdat_rate_wr <= rawdat_rate_cnt_wr;
		  rawdat_rate_cnt_rd <= (others => '0');
		  rawdat_rate_cnt_wr <= (others => '0');
		  rawdat_rate_cnt_cnt <= (others => '0');
		else
		  rawdat_rate_cnt_cnt <= rawdat_rate_cnt_cnt+1;
		  if data_fifo_we = '1' then rawdat_rate_cnt_wr <= rawdat_rate_cnt_wr+1; end if;
		  if data_fifo_rden = '1' then rawdat_rate_cnt_rd <= rawdat_rate_cnt_rd+1; end if;
		end if;

      end if;

    end if;


  end process;
-- ****************************************************
  header_fifo_din <= header_word_latch;
  header_fifo_we  <= '0' when readout_bypass else
                    '1' when ((word_counter = header_pcklen_latch_m1) or zero_pck) and sending_event else '0';

  data_fifo_din <= data_word;
  data_fifo_we  <= '0' when readout_bypass else
                  '1' when (is_data = '1' and is_header = '0') and (word_counter < header_pcklen_latch) and sending_event else '0';

end Behavioral;

