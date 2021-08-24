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

entity bc_indicator is

  generic (
    USE_SYSCLK : boolean := false
    );

  port (
    FSM_Clocks_I       : in rdclocks_t;
    Control_register_I : in readout_control_t;

    bcid_i : in std_logic_vector(BC_id_bitdepth-1 downto 0);
    bcen_i : in std_logic;

    indicator_o : out bc_indicator_t
    );
end bc_indicator;

architecture Behavioral of bc_indicator is

  signal clock, reset, bcid_en     : std_logic;
  signal bcid_in, bc_value, bc_out : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal bc_count, bc_rate         : std_logic_vector(3 downto 0);
  signal count_tot, count_sel      : std_logic_vector(5 downto 0);

  attribute mark_debug              : string;
  attribute mark_debug of reset     : signal is "true";
  attribute mark_debug of bcid_en   : signal is "true";
  attribute mark_debug of bcid_in   : signal is "true";
  attribute mark_debug of bc_value  : signal is "true";
  attribute mark_debug of bc_count  : signal is "true";
  attribute mark_debug of count_tot : signal is "true";
  attribute mark_debug of count_sel : signal is "true";

begin

  datackl_switch1 : if USE_SYSCLK generate
    clock <= FSM_Clocks_I.System_Clk;
  end generate datackl_switch1;

  datackl_switch0 : if not USE_SYSCLK generate
    clock <= FSM_Clocks_I.Data_Clk;
  end generate datackl_switch0;


  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then
      indicator_o.bc    <= bc_out;
      indicator_o.count <= bc_rate;
    end if;
  end process;


  process (clock)
  begin

    if(rising_edge(clock))then

      reset   <= Control_register_I.reset_data_counters;
      bcid_en <= bcen_i;
      bcid_in <= bcid_i;

      if (reset = '1') then
        bc_value  <= (others => '0');
        bc_count  <= (others => '0');
        count_tot <= (others => '0');
        count_sel <= (others => '0');
        bc_rate   <= (others => '0');
        bc_out    <= (others => '0');
      else


        if bcid_en = '1' then
		
          count_tot <= count_tot + 1;

          if bc_value = bcid_in then
            if  bc_count < x"F" then bc_count  <= bc_count + 1; end if;
            count_sel <= count_sel + 1;
          elsif bc_count = x"0" then
            bc_value  <= bcid_in;
            bc_rate   <= (others => '0');
            count_tot <= (others => '0');
            count_sel <= (others => '0');
            bc_out    <= (others => '0');
          elsif bc_value /= bcid_in then
            bc_count <= bc_count - 1;
          end if;

          if count_tot = x"3f" then
            bc_rate   <= count_sel(5 downto 2);
            bc_out    <= bc_value;
            count_tot <= (others => '0');
            count_sel <= (others => '0');
          end if;

        end if;


      end if;
    end if;

  end process;
-- ***************************************************





end Behavioral;

