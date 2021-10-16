----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: reset logic after PLL ready
--
-- Revision: 08/2021
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

    reset_pll_o : out std_logic;
    reset_lgc_o : out std_logic
    );
end PLL_Reset_Generator;

architecture Behavioral of PLL_Reset_Generator is

  signal reset_in, reset_lgc, reset_pll : std_logic;

  type FSM_STATE_T is (s0_reset, s1_waitpll, s2_ready);
  signal FSM_STATE : FSM_STATE_T;
  signal reset_cnt : natural range 0 to 15 := 0;
  signal pll_ready : std_logic;

  -- attribute mark_debug              : string;
  -- attribute mark_debug of reset_in  : signal is "true";
  -- attribute mark_debug of reset_cnt : signal is "true";
  -- attribute mark_debug of fsm_state : signal is "true";
  -- attribute mark_debug of reset_pll : signal is "true";
  -- attribute mark_debug of reset_lgc : signal is "true";
  -- attribute mark_debug of pll_ready : signal is "true";

begin

  process (GDataClk_I)
  begin
    if rising_edge(GDataClk_I)then

      reset_in    <= GRESET_I;
      pll_ready   <= PLL_ready_I;
      reset_lgc_o <= reset_lgc;
      reset_pll_o <= reset_pll;

      if(reset_in = '1') then
        fsm_state <= s0_reset;
      elsif fsm_state = s0_reset then
        fsm_state <= s1_waitpll;
        reset_cnt <= 0;
        reset_pll <= '1';
        reset_lgc <= '1';
      elsif fsm_state = s1_waitpll then
        if reset_cnt < 15 then reset_cnt                     <= reset_cnt+1; else reset_pll <= '0'; end if;
        if reset_cnt = 15 and pll_ready = '1' then fsm_state <= s2_ready; end if;
      elsif fsm_state = s2_ready then
        reset_lgc <= '0';
      end if;

    end if;
  end process;

end Behavioral;

