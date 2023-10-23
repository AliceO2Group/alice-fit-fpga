----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: IPBus interface for : FIT readout status/control, hdmi data, GBT data readout
--
-- Revision: 07/2021
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;


library work;
use work.fit_gbt_common_package.all;

entity ipbus_face is
  port (
    FSM_Clocks_I  : in rdclocks_t;
    ipbus_clock_i : in std_logic;

    FIT_GBT_status_I   : in  readout_status_t;
    Control_register_O : out readout_control_t;

    GBTRX_IsData_rxclk_I : in std_logic;
    GBTRX_Data_rxclk_I   : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);

    hdmi_fifo_datain_I : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    hdmi_fifo_wren_I   : in std_logic;
    hdmi_fifo_wrclk_I  : in std_logic;

    IPBUS_rst_I       : in  std_logic;
    IPBUS_data_out_O  : out std_logic_vector (31 downto 0);
    IPBUS_data_in_I   : in  std_logic_vector (31 downto 0);
    IPBUS_addr_sel_I  : in  std_logic;
    IPBUS_addr_I      : in  std_logic_vector(11 downto 0);
    IPBUS_iswr_I      : in  std_logic;
    IPBUS_isrd_I      : in  std_logic;
    IPBUS_ack_O       : out std_logic;
    IPBUS_err_O       : out std_logic;
    IPBUS_base_addr_I : in  std_logic_vector(11 downto 0)
    );
end ipbus_face;

architecture Behavioral of ipbus_face is

  signal rx_reset, ipb_reset : std_logic;

  signal hdmi_fifo_rden, hdmi_fifo_isempty : std_logic;
  signal hdmi_fifo_dout                    : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);

  signal data_fifo_din                                                   : std_logic_vector(95 downto 0);
  signal data_fifo_dout                                                  : std_logic_vector(191 downto 0);
  signal data_fifo_count                                                 : std_logic_vector(13 downto 0);
  signal data_fifo_wren, data_fifo_rden, data_fifo_full, data_fifo_empty : std_logic;

  type array32_type is array (natural range <>) of std_logic_vector(31 downto 0);
  signal fifo_to_ipbus_data_map                 : array32_type(0 to 5);
  signal fifo_to_ipbus_data_out                 : std_logic_vector(31 downto 0);
  signal data_map_counter                       : natural range 0 to 5          := 0;
  signal gbt_word_counter                       : std_logic_vector(15 downto 0) := x"0000";
  signal read_from_fifo_sgn, read_from_fifo_cmd : std_logic;

  signal ctrl_reg                          : ctrl_reg_t;
  signal stat_reg, stat_reg_ipbclk         : stat_reg_t;
  signal readout_control                   : readout_control_t;
  signal readout_status, readout_status_ff : readout_status_t;

  signal ipbus_addr_int, ipbus_base_addr_int : natural range 0 to 4095;

  -- ipbus fsm
  signal ipbus_di, ipbus_do   : std_logic_vector (31 downto 0);
  signal ipbus_ack, ipbus_err : std_logic;

  -- test debug signals
  signal debug_ipb_rst    : std_logic;
  signal debug_ipb_iswr   : std_logic;
  signal debug_ipb_isrd   : std_logic;
  signal debug_ipb_ack    : std_logic;
  signal debug_ipb_data_O : std_logic_vector (31 downto 0);
  signal debug_ipb_data_I : std_logic_vector (31 downto 0);
  signal debug_ipb_addr   : std_logic_vector (11 downto 0);

  -- attribute mark_debug                           : string;
  -- attribute MARK_DEBUG of debug_ipb_rst          : signal is "true";
  -- attribute MARK_DEBUG of debug_ipb_iswr         : signal is "true";
  -- attribute MARK_DEBUG of debug_ipb_isrd         : signal is "true";
  -- attribute MARK_DEBUG of debug_ipb_ack          : signal is "true";
  -- attribute MARK_DEBUG of debug_ipb_data_O       : signal is "true";
  -- attribute MARK_DEBUG of debug_ipb_data_I       : signal is "true";
  -- attribute MARK_DEBUG of debug_ipb_addr         : signal is "true";
  -- attribute MARK_DEBUG of readout_control        : signal is "true";
  -- attribute MARK_DEBUG of readout_status_ff      : signal is "true";
  -- attribute MARK_DEBUG of data_fifo_dout         : signal is "true";
  -- attribute MARK_DEBUG of data_fifo_rden         : signal is "true";
  -- attribute MARK_DEBUG of data_map_counter       : signal is "true";
  -- attribute MARK_DEBUG of fifo_to_ipbus_data_out : signal is "true";
  -- attribute MARK_DEBUG of data_fifo_count        : signal is "true";
  -- attribute MARK_DEBUG of ipbus_addr_int         : signal is "true";
  -- attribute MARK_DEBUG of stat_reg_ipbclk        : signal is "true";
  -- attribute MARK_DEBUG of ctrl_reg               : signal is "true";
  -- attribute MARK_DEBUG of ipbus_base_addr_int    : signal is "true";


begin

-- debug signal assignement
  debug_ipb_rst    <= IPBUS_rst_I;
  debug_ipb_iswr   <= IPBUS_iswr_I;
  debug_ipb_isrd   <= IPBUS_isrd_I;
  debug_ipb_ack    <= ipbus_ack;
  debug_ipb_data_O <= ipbus_do;
  debug_ipb_data_I <= IPBUS_data_in_I;
  debug_ipb_addr   <= IPBUS_addr_I;

-- ipbus wiring
  ipbus_di         <= IPBUS_data_in_I;
  IPBUS_data_out_O <= ipbus_do;
  IPBUS_ack_O      <= ipbus_ack;
  IPBUS_err_O      <= '0';


-- DATA FIFO 192 bit mapping to 6X32 bit words
  fifo_to_ipbus_data_map(5) <= data_fifo_dout(31 downto 0);
  fifo_to_ipbus_data_map(4) <= data_fifo_dout(63 downto 32);
  fifo_to_ipbus_data_map(3) <= data_fifo_dout(95 downto 64);
  fifo_to_ipbus_data_map(2) <= data_fifo_dout(127 downto 96);
  fifo_to_ipbus_data_map(1) <= data_fifo_dout(159 downto 128);
  fifo_to_ipbus_data_map(0) <= data_fifo_dout(191 downto 160);

-- address constants 
  ipbus_base_addr_int <= to_integer(unsigned(IPBUS_base_addr_I));
  ipbus_addr_int      <= to_integer(unsigned(IPBUS_addr_I)) - ipbus_base_addr_int;

-- ctrl / stat registers
  Control_register_O <= readout_control;

  -- reassign status to add ipbus count and data
  readout_status.GBT_status       <= FIT_GBT_status_I.GBT_status;
  readout_status.Readout_Mode     <= FIT_GBT_status_I.Readout_Mode;
  readout_status.CRU_Readout_Mode <= FIT_GBT_status_I.CRU_Readout_Mode;
  readout_status.BCIDsync_Mode    <= FIT_GBT_status_I.BCIDsync_Mode;
  readout_status.BCID_from_CRU    <= FIT_GBT_status_I.BCID_from_CRU;
  readout_status.ORBIT_from_CRU   <= FIT_GBT_status_I.ORBIT_from_CRU;
  readout_status.Trigger_from_CRU <= FIT_GBT_status_I.Trigger_from_CRU;
  readout_status.bcind_trg        <= FIT_GBT_status_I.bcind_trg;
  readout_status.bcind_evt        <= FIT_GBT_status_I.bcind_evt;
  readout_status.Stop_run         <= FIT_GBT_status_I.Stop_run;
  readout_status.Start_run        <= FIT_GBT_status_I.Start_run;
  readout_status.rx_phase         <= FIT_GBT_status_I.rx_phase;
  readout_status.cnv_fifo_max     <= FIT_GBT_status_I.cnv_fifo_max;
  readout_status.cnv_drop_cnt     <= FIT_GBT_status_I.cnv_drop_cnt;
  readout_status.sel_fifo_max     <= FIT_GBT_status_I.sel_fifo_max;
  readout_status.sel_drop_cnt     <= FIT_GBT_status_I.sel_drop_cnt;
  readout_status.gbt_data_cnt     <= FIT_GBT_status_I.gbt_data_cnt;
  readout_status.fsm_errors       <= FIT_GBT_status_I.fsm_errors;
  readout_status.ipbusrd_fifo_cnt <= "00"&data_fifo_count;
  readout_status.ipbusrd_fifo_out <= fifo_to_ipbus_data_out;




-- HDMI FIFO ===========================================
  hdmi_fifo_comp : entity work.hdmi_data_fifo
    port map (
      rst           => FSM_Clocks_I.Reset_sclk,
      wr_clk        => hdmi_fifo_wrclk_I,
      rd_clk        => FSM_Clocks_I.GBT_RX_Clk,
      din           => hdmi_fifo_datain_I,
      wr_en         => hdmi_fifo_wren_I,
      rd_en         => hdmi_fifo_rden,
      dout          => hdmi_fifo_dout,
      full          => open,
      empty         => hdmi_fifo_isempty,
      rd_data_count => open,
      wr_rst_busy   => open,
      rd_rst_busy   => open
      );

  hdmi_fifo_rden <= '1' when (GBTRX_IsData_rxclk_I = '0') and (hdmi_fifo_isempty = '0') else '0';
-- =====================================================



-- DATA FIFO ===========================================
  ipbus_data_fifo_comp : entity work.ipbus_data_fifo
    port map (
      rst           => ipb_reset,
      wr_clk        => FSM_Clocks_I.GBT_RX_Clk,
      rd_clk        => ipbus_clock_i,
      din           => data_fifo_din,
      wr_en         => data_fifo_wren,
      rd_en         => data_fifo_rden,
      dout          => data_fifo_dout,
      full          => data_fifo_full,
      empty         => data_fifo_empty,
      rd_data_count => data_fifo_count,
      wr_rst_busy   => open,
      rd_rst_busy   => open
      );

  data_fifo_din          <= gbt_word_counter & GBTRX_Data_rxclk_I    when (GBTRX_IsData_rxclk_I = '1')                           else gbt_word_counter & hdmi_fifo_dout;
  data_fifo_wren         <= '1'                                      when (GBTRX_IsData_rxclk_I = '1') or (hdmi_fifo_rden = '1') else '0';
  data_fifo_rden         <= '1'                                      when read_from_fifo_sgn = '1' and data_map_counter = 5      else '0';
  read_from_fifo_sgn     <= '1'                                      when read_from_fifo_cmd = '1' and data_fifo_empty = '0'     else '0';
  read_from_fifo_cmd     <= '1'                                      when ipbus_addr_int = ipbusrd_fifo_out_addr                 else '0';
  fifo_to_ipbus_data_out <= fifo_to_ipbus_data_map(data_map_counter) when data_fifo_empty = '0'                                  else x"aaaa_aaaa";


  process (FSM_Clocks_I.GBT_RX_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.GBT_RX_Clk))then
      rx_reset                                                                <= FSM_Clocks_I.Reset_dclk;
      if rx_reset = '1' or (gbt_word_counter = x"ffff") then gbt_word_counter <= (others => '0');
      elsif (data_fifo_wren = '1') then gbt_word_counter                      <= gbt_word_counter +1; end if;
    end if;
  end process;
-- =====================================================

  -- status and control by data clock
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then
      readout_control   <= func_CNTRREG_getcntrreg(ctrl_reg);
      -- extra latch for ila
      readout_status_ff <= readout_status;
      stat_reg          <= func_STATREG_getaddrreg(readout_status_ff);
    end if;
  end process;


-- IPbus clock *****************************************
  process (ipbus_clock_i)
  begin
    if(rising_edge(ipbus_clock_i))then
      ipb_reset       <= IPBUS_rst_I;
      stat_reg_ipbclk <= stat_reg;

      if (ipb_reset = '1') then

        data_map_counter <= 0;
        ctrl_reg         <= (others => (others => '0'));

      else

        if read_from_fifo_sgn = '1' then
          if data_map_counter < 5 then data_map_counter <= data_map_counter+1; else data_map_counter <= 0; end if;
        end if;

        if(IPBUS_iswr_I = '1') and (ipbus_addr_int < ctrl_reg_size) then ctrl_reg(ipbus_addr_int) <= ipbus_di; end if;


      end if;
    end if;

  end process;
-- ***************************************************
  ipbus_ack <= '1' when (IPBUS_isrd_I = '1') and (ipbus_addr_int < ipbusrd_stat_addr_offset + stat_reg_size) else  -- reading
               '1' when (IPBUS_iswr_I = '1') and (ipbus_addr_int < ctrl_reg_size) else  -- writing
               '0';


  ipbus_do <= (others => '0') when (ipbus_ack = '0') or (IPBUS_isrd_I = '0') else
              ctrl_reg(ipbus_addr_int)                      when (ipbus_addr_int < ctrl_reg_size) else
              stat_reg_ipbclk(ipbus_addr_int-ipbusrd_stat_addr_offset) when (ipbus_addr_int >= ipbusrd_stat_addr_offset) and (ipbus_addr_int < ipbusrd_stat_addr_offset + stat_reg_size) else
              x"00000000";

end Behavioral;



