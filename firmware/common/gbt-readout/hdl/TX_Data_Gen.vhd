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
    Status_register_I : in FIT_GBT_status_type;
	
    TX_IsData_I       : in std_logic;
    TX_Data_I         : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);

    TX_IsData_O : out std_logic;
    TX_Data_O   : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	
	gbt_data_counter_o : out std_logic_vector(31 downto 0)
    );
end TX_Data_Gen;

architecture Behavioral of TX_Data_Gen is

  signal TX_generation        : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal Data_bypass          : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal TX_data_gen          : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal TX_IsData_generation : std_logic;

  signal gen_counter_ff, gen_counter_ff_next   : std_logic_vector(15 downto 0);
  signal cont_counter_ff, cont_counter_ff_next : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  
  signal is_rdmode, is_rdmode_ff : boolean;
  signal tx_isdata : std_logic;
  signal gbt_data_counter   : std_logic_vector(31 downto 0);

  constant count_val_void : std_logic_vector(15 downto 0) := x"0f00";
  constant count_val_data : std_logic_vector(15 downto 0) := x"0f0a";



begin

  TX_Data_O <= TX_generation when (Control_register_I.Data_Gen.usage_generator = use_TX_generator) else
               TX_Data_I;

  TX_IsData_O <= tx_isdata;
  tx_isdata   <= TX_IsData_generation when (Control_register_I.Data_Gen.usage_generator = use_TX_generator) else
                 TX_IsData_I;
				 
  gbt_data_counter_o <= gbt_data_counter;

  TX_data_gen <= cont_counter_ff;


-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin

    if(rising_edge(FSM_Clocks_I.Data_Clk))then
      if (FSM_Clocks_I.Reset_dclk = '1') then
	  
        gen_counter_ff  <= (others => '0');
        cont_counter_ff <= (others => '0');
        gbt_data_counter <= (others => '0');
		
      else
	  
	    -- counting gbt words, reset by start of run and reset_data_counters
	    is_rdmode <= Status_register_I.Readout_Mode /= mode_IDLE;
		is_rdmode_ff <= is_rdmode;
		if is_rdmode and not is_rdmode_ff then gbt_data_counter <= (others => '0');
		elsif Control_register_I.reset_data_counters = '1' then  gbt_data_counter <= (others => '0');
		elsif tx_isdata = '1' then gbt_data_counter <= gbt_data_counter + 1; end if;
		
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
                   x"10000000000000000000" when (gen_counter_ff = count_val_void) else
                   x"20000000000000000000" when (gen_counter_ff = count_val_data+1) else
                   TX_data_gen;
                                        --x"123456789abcdef01234";

  TX_IsData_generation <= '0' when (FSM_Clocks_I.Reset_dclk = '1') else
                          '0' when (gen_counter_ff < count_val_void) else
                          '0' when (gen_counter_ff = count_val_void) else
                          '0' when (gen_counter_ff = count_val_data+1) else
                          '1';
-- ***************************************************



end Behavioral;

