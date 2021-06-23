----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    06/11/2017 
-- Design Name: 
-- Module Name:    RXDATA_CLKSync - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision
-- Additional Comments: 
--
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;

entity RXDATA_CLKSync is
Port ( 
	FSM_Clocks_I : in FSM_Clocks_type;
	Control_register_I : in CONTROL_REGISTER_type;
	
	RX_CLK_I				: in  STD_LOGIC; -- 40MHz RX word clock

	RX_IS_DATA_RXCLK_I		: in STD_LOGIC; --       data@RX_CLK
	RX_DATA_RXCLK_I			: in  STD_LOGIC_VECTOR (GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0); --       data@RX_CLK
	
	RX_IS_DATA_DATACLK_O	: out STD_LOGIC; -- data@SYS_CLK
	RX_DATA_DATACLK_O 		: out  STD_LOGIC_VECTOR (GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0); -- data@SYS_CLK
	  
	CLK_PH_CNT_O 			: out std_logic_vector(rx_phase_bitdepth-1 downto 0);
	CLK_PH_ERROR_O			: out std_logic;
	
	rx_ph320              : out std_logic_vector(2 downto 0);
	ph_error320            : out std_logic                 
	);
end RXDATA_CLKSync;

architecture Behavioral of RXDATA_CLKSync is

  -- rx clk ff by sysclk
 signal RX_CLK_from00, RX_CLK_from01, RX_CLK_from02 : STD_LOGIC;
  
--  -- I data ff by rx clk

--  -- data ff by sysclk
 signal RX_IS_DATA_DATACLK	: STD_LOGIC;
 signal RX_DATA_DATACLK	: STD_LOGIC_VECTOR (GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0);

--  -- data ff by data clk
 signal CLK_PH_counter_stop	: STD_LOGIC_VECTOR (2 downto 0)  := "000";			
 signal CLK_PH_counter_dc, CLK_PH_counter_dcp, CLK_PH_counter_dcm	: STD_LOGIC_VECTOR(2 downto 0);	

  
  signal is_phase_changed : STD_LOGIC;
  signal reset_ph_chng, rx_clk_tg, c_locked : STD_LOGIC;


--	attribute keep : string;	
--	attribute keep of CLK_PH_counter_ff_sc : signal is "true";
--	attribute keep of CLK_PH_counter_stop_ff_sc : signal is "true";
--	attribute keep of RX_CLK_from_ff01 : signal is "true";
--	attribute keep of RX_CLK_from_ff02 : signal is "true";
--	attribute keep of RX_DATA_RXCLK_ffrxc : signal is "true";
--	attribute keep of RX_DATA_DATACLK_ffsc : signal is "true";

begin


	
-- ***************************************************
	rx_ph320 <= CLK_PH_counter_stop; ph_error320 <= is_phase_changed;
	
-- Data ff RX clk ************************************
	PROCESS (RX_CLK_I)
	BEGIN
		IF(RX_CLK_I'EVENT and RX_CLK_I = '1') THEN
					rx_clk_tg <=not rx_clk_tg;
					
		END IF;
	END PROCESS;
-- ***************************************************
	
	
-- Data ff data clk **********************************
	PROCESS (FSM_Clocks_I.Data_Clk)
	BEGIN
		IF(FSM_Clocks_I.Data_Clk'EVENT and FSM_Clocks_I.Data_Clk = '1') THEN
             CLK_PH_ERROR_O <= is_phase_changed;
             RX_DATA_DATACLK_O <=RX_DATA_DATACLK;
             RX_IS_DATA_DATACLK_O <= RX_IS_DATA_DATACLK;
             CLK_PH_CNT_O<= CLK_PH_counter_stop;
		END IF;
	END PROCESS;
-- ***************************************************
	
-- Async Registers, count ph *************************
	PROCESS (FSM_Clocks_I.System_Clk)
	BEGIN
IF(FSM_Clocks_I.System_Clk'EVENT and FSM_Clocks_I.System_Clk = '1') THEN
	RX_CLK_from00 <= rx_clk_tg; RX_CLK_from01 <= RX_CLK_from00; RX_CLK_from02 <= RX_CLK_from01;

 if ((Control_register_I.strt_rdmode_lock or Control_register_I.reset_rxph_error or FSM_Clocks_I.Reset_sclk)= '1') then is_phase_changed<='0'; c_locked<='0';
    else
    if (RX_CLK_from01 /= RX_CLK_from02) then
      CLK_PH_counter_stop<= FSM_Clocks_I.System_Counter(2 downto 0);
      if (c_locked='0') then CLK_PH_counter_dc <=FSM_Clocks_I.System_Counter(2 downto 0); c_locked<='1';
        else 
          if  (CLK_PH_counter_stop/=CLK_PH_counter_dc) and (CLK_PH_counter_stop/=CLK_PH_counter_dcm) and (CLK_PH_counter_stop/=CLK_PH_counter_dcp) then is_phase_changed<='1'; end if;
      end if;
    end if;
    
   if (FSM_Clocks_I.System_Counter(2 downto 0)=CLK_PH_counter_dcp) then
      RX_IS_DATA_DATACLK<= RX_IS_DATA_RXCLK_I;
      RX_DATA_DATACLK<= RX_DATA_RXCLK_I;
   end if;
    
  end if;
END IF;
END PROCESS;
-- ***************************************************
CLK_PH_counter_dcp <= CLK_PH_counter_dc+"001";
CLK_PH_counter_dcm <= CLK_PH_counter_dc-"001";



-- FSM ***********************************************

-- ***************************************************



end Behavioral;

