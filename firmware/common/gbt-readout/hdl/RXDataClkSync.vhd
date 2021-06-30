----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    2017 
-- Description: GBT RX data clock domain crossing RX -> Data clocks; RX->Data_Clk phase counter @320MHz
--
-- Revision: 06/2021
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;

entity RXDATA_CLKSync is
  port (
    FSM_Clocks_I       : in FSM_Clocks_type;
    Control_register_I : in CONTROL_REGISTER_type;

    RX_CLK_I : in std_logic;            -- 40MHz RX word clock

    RX_IS_DATA_RXCLK_I : in std_logic;  --       data@RX_CLK
    RX_DATA_RXCLK_I    : in std_logic_vector (GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0);  --       data@RX_CLK

    RX_IS_DATA_DATACLK_O : out std_logic;  -- data@SYS_CLK
    RX_DATA_DATACLK_O    : out std_logic_vector (GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0);  -- data@SYS_CLK

    CLK_PH_CNT_O   : out std_logic_vector(rx_phase_bitdepth-1 downto 0);
    CLK_PH_ERROR_O : out std_logic
    );
end RXDATA_CLKSync;

architecture Behavioral of RXDATA_CLKSync is

  -- rx clk ff by sysclk
  signal RX_CLK_from00, RX_CLK_from01, RX_CLK_from02 : std_logic;

--  -- I data ff by rx clk

--  -- data ff by sysclk
  signal RX_IS_DATA_DATACLK : std_logic;
  signal RX_DATA_DATACLK    : std_logic_vector (GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0);

--  -- data ff by data clk
  signal CLK_PH_counter_stop                                       : std_logic_vector (2 downto 0) := "000";
  signal CLK_PH_counter_dc, CLK_PH_counter_dcp, CLK_PH_counter_dcm : std_logic_vector(2 downto 0) := "000";


  signal is_phase_changed                   : std_logic;
  signal reset_ph_chng, rx_clk_tg, c_locked : std_logic;
  signal rx_error_reset, rx_error_reset_sclk: std_logic;


--      attribute keep : string;        
--      attribute keep of CLK_PH_counter_ff_sc : signal is "true";
--      attribute keep of CLK_PH_counter_stop_ff_sc : signal is "true";
--      attribute keep of RX_CLK_from_ff01 : signal is "true";
--      attribute keep of RX_CLK_from_ff02 : signal is "true";
--      attribute keep of RX_DATA_RXCLK_ffrxc : signal is "true";
--      attribute keep of RX_DATA_DATACLK_ffsc : signal is "true";

begin

-- Data ff RX clk ************************************
  process (RX_CLK_I)
  begin
    if(RX_CLK_I'event and RX_CLK_I = '1') then
      rx_clk_tg <= not rx_clk_tg;

    end if;
  end process;
-- ***************************************************


-- Data ff data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(FSM_Clocks_I.Data_Clk'event and FSM_Clocks_I.Data_Clk = '1') then
      CLK_PH_ERROR_O       <= is_phase_changed;
      RX_DATA_DATACLK_O    <= RX_DATA_DATACLK;
      RX_IS_DATA_DATACLK_O <= RX_IS_DATA_DATACLK;
      CLK_PH_CNT_O         <= CLK_PH_counter_stop;
	  
	  rx_error_reset <= Control_register_I.strt_rdmode_lock or Control_register_I.reset_rxph_error;
    end if;
  end process;
-- ***************************************************

-- Async Registers, count ph *************************
  process (FSM_Clocks_I.System_Clk)
  begin
    if(FSM_Clocks_I.System_Clk'event and FSM_Clocks_I.System_Clk = '1') then
      RX_CLK_from00 <= rx_clk_tg; RX_CLK_from01 <= RX_CLK_from00; RX_CLK_from02 <= RX_CLK_from01;
	  rx_error_reset_sclk <= rx_error_reset;

      if ((rx_error_reset_sclk or FSM_Clocks_I.Reset_sclk) = '1') then is_phase_changed <= '0'; c_locked <= '0';
      else
        if (RX_CLK_from01 /= RX_CLK_from02) then
          CLK_PH_counter_stop                        <= FSM_Clocks_I.System_Counter(2 downto 0);
          if (c_locked = '0') then CLK_PH_counter_dc <= FSM_Clocks_I.System_Counter(2 downto 0); c_locked <= '1';
          else
            if (CLK_PH_counter_stop /= CLK_PH_counter_dc) and (CLK_PH_counter_stop /= CLK_PH_counter_dcm) and (CLK_PH_counter_stop /= CLK_PH_counter_dcp) then is_phase_changed <= '1'; end if;
          end if;
        end if;

        if (FSM_Clocks_I.System_Counter(2 downto 0) = CLK_PH_counter_dcp) then
          RX_IS_DATA_DATACLK <= RX_IS_DATA_RXCLK_I;
          RX_DATA_DATACLK    <= RX_DATA_RXCLK_I;
        end if;

      end if;
    end if;
  end process;
-- ***************************************************
  CLK_PH_counter_dcp <= CLK_PH_counter_dc+"001";
  CLK_PH_counter_dcm <= CLK_PH_counter_dc-"001";

end Behavioral;

