----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: generate test pattern for GBT tests
--
-- Revision: 07/2021
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;

entity TX_Data_Gen is
  port (
    FSM_Clocks_I : in FSM_Clocks_type;

    Control_register_I : in CONTROL_REGISTER_type;

    FIT_GBT_status_I : in FIT_GBT_status_type;
    TX_IsData_I      : in std_logic;
    TX_Data_I        : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);

    RAWFIFO_data_word_I : in  std_logic_vector(fifo_data_bitdepth-1 downto 0);
    RAWFIFO_Is_Empty_I  : in  std_logic;
    RAWFIFO_RE_O        : out std_logic;

    TX_IsData_O : out std_logic;
    TX_Data_O   : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0)
    );
end TX_Data_Gen;

architecture Behavioral of TX_Data_Gen is

  signal TX_generation        : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal Data_bypass          : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal TX_data_gen          : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal TX_IsData_generation : std_logic;
  signal IsData_bypass        : std_logic;

  signal data320to40fifo_empty : std_logic;
  signal data320to40fifo_WREN  : std_logic;
  signal data320to40fifo_RDEN  : std_logic;

  signal gen_counter_ff, gen_counter_ff_next   : std_logic_vector(GEN_count_bitdepth-1 downto 0);
  signal cont_counter_ff, cont_counter_ff_next : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal count_val_void, count_val_data        : std_logic_vector(GEN_count_bitdepth-1 downto 0);

-- signal rx_phase_latch : std_logic_vector(rx_phase_bitdepth-1 downto 0); 
  attribute keep                    : string;
  attribute keep of gen_counter_ff  : signal is "true";
  attribute keep of cont_counter_ff : signal is "true";


begin

  TX_Data_O <= TX_generation when (Control_register_I.Data_Gen.usage_generator = use_TX_generator) else
               Data_bypass when (Control_register_I.readout_bypass = '1') else
               TX_Data_I;

  TX_IsData_O <= TX_IsData_generation when (Control_register_I.Data_Gen.usage_generator = use_TX_generator) else
                 IsData_bypass when (Control_register_I.readout_bypass = '1') else
                 TX_IsData_I;

-- TX_data_gen <= x"01231111" & Control_register_I.PAR & x"1111" & Control_register_I.FEE_ID;
  TX_data_gen    <= cont_counter_ff;
  count_val_void <= x"0f00";
  count_val_data <= x"0f0a";



-- Slc_data_fifo =============================================
  data320to40_fifo_comp : entity work.slct_data_fifo
    port map(
      wr_clk        => FSM_Clocks_I.System_Clk,
      rd_clk        => FSM_Clocks_I.Data_Clk,
      wr_data_count => open,
      rst           => FSM_Clocks_I.Reset_sclk,
      WR_EN         => data320to40fifo_WREN,
      RD_EN         => data320to40fifo_RDEN,
      DIN           => RAWFIFO_data_word_I,
      DOUT          => Data_bypass,
      FULL          => open,
      EMPTY         => data320to40fifo_empty
      );

  data320to40fifo_WREN <= not RAWFIFO_Is_Empty_I;
  data320to40fifo_RDEN <= not data320to40fifo_empty;
  RAWFIFO_RE_O         <= not RAWFIFO_Is_Empty_I;
  IsData_bypass        <= not data320to40fifo_empty;
-- ===========================================================




-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin

    if(rising_edge(FSM_Clocks_I.Data_Clk))then
      if (FSM_Clocks_I.Reset_dclk = '1') then
        gen_counter_ff  <= (others => '0');
        cont_counter_ff <= (others => '0');
      else
        gen_counter_ff  <= gen_counter_ff_next;
        cont_counter_ff <= cont_counter_ff_next;
      end if;
    end if;

  end process;
-- ***************************************************




-- ***************************************************
  gen_counter_ff_next <= (others => '0') when (FSM_Clocks_I.Reset_dclk = '1') else
                         (others => '0') when (gen_counter_ff = count_val_data+1) else
                         gen_counter_ff + 1;



  cont_counter_ff_next <= (others => '0') when (FSM_Clocks_I.Reset_dclk = '1') else
                          (others => '0') when (Control_register_I.Data_Gen.usage_generator /= use_TX_generator) else
                          cont_counter_ff when (gen_counter_ff < count_val_void) else
                          cont_counter_ff when (gen_counter_ff = count_val_void) else
                          cont_counter_ff when (gen_counter_ff = count_val_data+1) else
                          cont_counter_ff + 1;



  TX_generation <= x"00000000000000000000" when (FSM_Clocks_I.Reset_dclk = '1') else
                   x"00000000000000000000" when (gen_counter_ff < count_val_void) else
                   data_word_cnst_SOP      when (gen_counter_ff = count_val_void) else
                   data_word_cnst_EOP      when (gen_counter_ff = count_val_data+1) else
                   TX_data_gen;
                                        --x"123456789abcdef01234";

  TX_IsData_generation <= '0' when (FSM_Clocks_I.Reset_dclk = '1') else
                          '0' when (gen_counter_ff < count_val_void) else
                          '0' when (gen_counter_ff = count_val_void) else
                          '0' when (gen_counter_ff = count_val_data+1) else
                          '1';
-- ***************************************************



end Behavioral;

