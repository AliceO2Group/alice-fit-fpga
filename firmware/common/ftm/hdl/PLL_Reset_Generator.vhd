----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: generate reset after PLL ready
--
-- Revision: 07/2021
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fit_gbt_common_package.all;
use ieee.std_logic_unsigned.all;

entity PLL_Reset_Generator is
  port (
    GRESET_I    : in std_logic;
    GDataClk_I  : in std_logic;
    PLL_ready_I : in std_logic;

    RESET_O : out std_logic
    );
end PLL_Reset_Generator;

architecture Behavioral of PLL_Reset_Generator is

  signal delay_cntr, delay_cntr_next : std_logic_vector(3 downto 0);

  signal pll_ready_ff0, pll_ready_ff1            : std_logic;
  signal out_reset, out_reset_ff, out_reset_next : std_logic;

  attribute keep                  : string;
  attribute keep of delay_cntr    : signal is "true";
  attribute keep of pll_ready_ff0 : signal is "true";
  attribute keep of pll_ready_ff1 : signal is "true";
  attribute keep of out_reset_ff  : signal is "true";

begin

  RESET_O <= out_reset_ff;


-- Data clk ***********************************
  process (GDataClk_I, GRESET_I)
  begin
    if(GRESET_I = '1') then

      delay_cntr    <= (others => '0');
      pll_ready_ff0 <= '0';
      pll_ready_ff1 <= '0';

      out_reset    <= '1';
      out_reset_ff <= '1';
    else

      if rising_edge(GDataClk_I)then

        delay_cntr    <= delay_cntr_next;
        pll_ready_ff0 <= PLL_ready_I;
        pll_ready_ff1 <= pll_ready_ff0;

        out_reset    <= out_reset_next;
        out_reset_ff <= out_reset;

      end if;
    end if;
  end process;
-- ********************************************



-- FSM ***********************************************
  delay_cntr_next <= x"0" when (pll_ready_ff0 = '0') or (pll_ready_ff1 = '0') else
                     x"f" when (delay_cntr = x"f") else
                     delay_cntr+1;

  out_reset_next <= '0' when delay_cntr = x"f" else
                    out_reset;
end Behavioral;

