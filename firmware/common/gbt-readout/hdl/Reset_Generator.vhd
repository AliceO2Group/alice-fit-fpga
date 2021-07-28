----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: generate reset signals and sysclk counter
--
-- Revision: 06/2021
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fit_gbt_common_package.all;
use ieee.std_logic_unsigned.all;

entity Reset_Generator is
  port (
    RESET40_I : in std_logic;
    SysClk_I  : in std_logic;
    DataClk_I : in std_logic;

    Control_register_I : in readout_control_t;

    SysClk_count_O : out std_logic_vector(3 downto 0);

    Reset_DClk_O : out std_logic;
    Reset_SClk_O : out std_logic;
    ResetGBT_O   : out std_logic
    );
end Reset_Generator;

architecture Behavioral of Reset_Generator is


  signal reset_sclk, reset_fsm, reset_gbt : std_logic;
  signal DataClk_q_dataclk                : std_logic := '0';
  signal DataClk_qff00_sysclk             : std_logic;
  signal DataClk_front_sysclk             : std_logic;

  signal count_ready, count_ready_clk40 : std_logic;
  signal sysclk_count_ff                : std_logic_vector(2 downto 0);

  --attribute keep : string;
  --attribute keep of  : signal is "true";

begin

  ResetGBT_O     <= reset_gbt;
  Reset_DClk_O   <= reset_fsm;
  SysClk_count_O <= '0' & sysclk_count_ff;

-- Data clk *********************************
  process(DataClk_I)
  begin
    if rising_edge(DataClk_I)then

      count_ready_clk40 <= count_ready;
      DataClk_q_dataclk <= not DataClk_q_dataclk;
      reset_gbt         <= RESET40_I or Control_register_I.reset_gbt;
      reset_fsm         <= reset_gbt or Control_register_I.reset_readout or not count_ready_clk40;

      if(RESET40_I = '1')then
      else

      end if;

    end if;
  end process;
-- ***************************************************


-- Clock clk *********************************
  process(SysClk_I)
  begin
    if rising_edge(SysClk_I)then

      reset_sclk   <= RESET40_I;
      Reset_SClk_O <= reset_fsm;

      if(reset_sclk = '1')then
        count_ready <= '0';

      else
        DataClk_qff00_sysclk <= DataClk_q_dataclk;

        if (DataClk_front_sysclk = '1') then sysclk_count_ff <= "001"; count_ready <= '1';
        else sysclk_count_ff                                 <= sysclk_count_ff+1;
        end if;

      end if;

    end if;
  end process;
-- ***************************************************

-- FSM ***********************************************
  DataClk_front_sysclk <= DataClk_q_dataclk xor DataClk_qff00_sysclk;


end Behavioral;

