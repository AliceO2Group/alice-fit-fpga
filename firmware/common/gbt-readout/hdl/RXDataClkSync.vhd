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
	CLK_PH_ERROR_O			: out std_logic
	);
end RXDATA_CLKSync;

architecture Behavioral of RXDATA_CLKSync is

  -- rx clk ff by sysclk
  signal RX_CLK_from_ff00 : STD_LOGIC;
  signal RX_CLK_from_ff01 : STD_LOGIC;
  signal RX_CLK_from_ff02 : STD_LOGIC;
  
  -- I data ff by rx clk
  signal RX_IS_DATA_RXCLK_ffrxc, RX_IS_DATA_RXCLK_ffrxc_next	: STD_LOGIC;
  signal RX_DATA_RXCLK_ffrxc, RX_DATA_RXCLK_ffrxc_next 			: STD_LOGIC_VECTOR (GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0);

  -- data ff by sysclk
  signal RX_IS_DATA_DATACLK_ffsc, RX_IS_DATA_DATACLK_ffsc_next	: STD_LOGIC;
  signal RX_DATA_DATACLK_ffsc, RX_DATA_DATACLK_ffsc_next		: STD_LOGIC_VECTOR (GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0);

  -- data ff by data clk
  signal RX_IS_DATA_DATACLK_ffdc, RX_IS_DATA_DATACLK_ffdc_next	: STD_LOGIC;
  signal RX_DATA_DATACLK_ffdc, RX_DATA_DATACLK_ffdc_next		: STD_LOGIC_VECTOR (GBT_data_word_bitdepth+GBT_slowcntr_bitdepth-1 downto 0);


  signal CLK_PH_counter_ff_sc, CLK_PH_counter_ff_sc_next			: STD_LOGIC_VECTOR (rx_phase_bitdepth-1 downto 0);			
  signal CLK_PH_counter_max                             			: STD_LOGIC_VECTOR (rx_phase_bitdepth-1 downto 0);			
  signal CLK_PH_counter_stop_ff_sc, CLK_PH_counter_stop_ff_sc_next	: STD_LOGIC_VECTOR (rx_phase_bitdepth-1 downto 0);			
  signal CLK_PH_counter_ff_dc, CLK_PH_counter_ff01_dc, CLK_PH_counter_ff_dc_next			: STD_LOGIC_VECTOR(rx_phase_bitdepth-1 downto 0);	

  
  signal is_phase_changed, is_phase_changed_next : STD_LOGIC;
  signal reset_ph_chng : STD_LOGIC;


	attribute keep : string;	
	attribute keep of CLK_PH_counter_ff_sc : signal is "true";
	attribute keep of CLK_PH_counter_stop_ff_sc : signal is "true";
	attribute keep of RX_CLK_from_ff01 : signal is "true";
	attribute keep of RX_CLK_from_ff02 : signal is "true";
	attribute keep of RX_DATA_RXCLK_ffrxc : signal is "true";
	attribute keep of RX_DATA_DATACLK_ffsc : signal is "true";

begin

-- flip-flop connecting ******************************
	RX_IS_DATA_RXCLK_ffrxc_next <= RX_IS_DATA_RXCLK_I;
	RX_DATA_RXCLK_ffrxc_next <= RX_DATA_RXCLK_I;
	
	RX_IS_DATA_DATACLK_ffdc_next <= RX_IS_DATA_DATACLK_ffsc;
	RX_DATA_DATACLK_ffdc_next <= RX_DATA_DATACLK_ffsc;

	RX_IS_DATA_DATACLK_O <= RX_IS_DATA_DATACLK_ffdc;
	RX_DATA_DATACLK_O <= RX_DATA_DATACLK_ffdc;
	
	
	 CLK_PH_counter_ff_dc_next <= STD_LOGIC_VECTOR(CLK_PH_counter_stop_ff_sc);
	 CLK_PH_CNT_O <= CLK_PH_counter_ff_dc;
	 CLK_PH_counter_max <= (others => '1');
-- ***************************************************
	
	
	
-- Data ff RX clk ************************************
	PROCESS (RX_CLK_I)
	BEGIN
		IF(RX_CLK_I'EVENT and RX_CLK_I = '1') THEN
			IF(FSM_Clocks_I.Reset = '1') THEN
				RX_IS_DATA_RXCLK_ffrxc <= '0';
				RX_DATA_RXCLK_ffrxc <= (others => '0');
			ELSE
					RX_IS_DATA_RXCLK_ffrxc <= RX_IS_DATA_RXCLK_ffrxc_next;
					RX_DATA_RXCLK_ffrxc <= RX_DATA_RXCLK_ffrxc_next;
			END IF;
		END IF;
	END PROCESS;
-- ***************************************************
	
	
-- Data ff data clk **********************************
	PROCESS (FSM_Clocks_I.Data_Clk)
	BEGIN
		IF(FSM_Clocks_I.Data_Clk'EVENT and FSM_Clocks_I.Data_Clk = '1') THEN
			IF(FSM_Clocks_I.Reset = '1') THEN
				RX_IS_DATA_DATACLK_ffdc <= '0';
				RX_DATA_DATACLK_ffdc <= (others => '0');
				CLK_PH_counter_ff_dc <= (others => '0');
				CLK_PH_counter_ff01_dc <= (others => '0');
				is_phase_changed <= '0';
			ELSE
					RX_IS_DATA_DATACLK_ffdc <= RX_IS_DATA_DATACLK_ffdc_next;
					RX_DATA_DATACLK_ffdc <= RX_DATA_DATACLK_ffdc_next;
					CLK_PH_counter_ff_dc <= CLK_PH_counter_ff_dc_next;
					CLK_PH_counter_ff01_dc <= CLK_PH_counter_ff_dc;
					is_phase_changed <= is_phase_changed_next;
			END IF;
		END IF;
	END PROCESS;
-- ***************************************************
	
	
	
-- Async Registers, count ph *************************
	PROCESS (FSM_Clocks_I.System_Clk)
	BEGIN
		IF(FSM_Clocks_I.System_Clk'EVENT and FSM_Clocks_I.System_Clk = '1') THEN
			IF(FSM_Clocks_I.Reset = '1') THEN
				RX_CLK_from_ff00 <= '0';
				RX_CLK_from_ff01 <= '0';
				RX_CLK_from_ff02 <= '0';
				
				RX_IS_DATA_DATACLK_ffsc <= '0';
				RX_DATA_DATACLK_ffsc <= (others => '0');
				
				CLK_PH_counter_ff_sc <= (others => '0');
			ELSE
				RX_CLK_from_ff00 <= RX_CLK_I;
				RX_CLK_from_ff01 <= RX_CLK_from_ff00;
				RX_CLK_from_ff02 <= RX_CLK_from_ff01;
				
				RX_IS_DATA_DATACLK_ffsc	<= RX_IS_DATA_DATACLK_ffsc_next;
				RX_DATA_DATACLK_ffsc	<= RX_DATA_DATACLK_ffsc_next;

				CLK_PH_counter_ff_sc		<= CLK_PH_counter_ff_sc_next;
				CLK_PH_counter_stop_ff_sc	<= CLK_PH_counter_stop_ff_sc_next;

			END IF;
			
			
		END IF;
	END PROCESS;
-- ***************************************************





-- FSM ***********************************************
CLK_PH_ERROR_O <= is_phase_changed;
reset_ph_chng <= Control_register_I.reset_rxph_error;

is_phase_changed_next <= 	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
							'0' WHEN (reset_ph_chng = '1') ELSE
							'1' WHEN (CLK_PH_counter_ff_dc /= CLK_PH_counter_ff01_dc) ELSE
							is_phase_changed;
					

RX_DATA_DATACLK_ffsc_next <= 	(others => '0') 		WHEN (FSM_Clocks_I.Reset = '1') ELSE
								RX_DATA_RXCLK_ffrxc 	WHEN ((RX_CLK_from_ff01 = '1') and (RX_CLK_from_ff02 = '0')) ELSE
								RX_DATA_DATACLK_ffsc;

RX_IS_DATA_DATACLK_ffsc_next <= '0' 					WHEN (FSM_Clocks_I.Reset = '1') ELSE
								RX_IS_DATA_RXCLK_ffrxc 	WHEN ((RX_CLK_from_ff01 = '1') and (RX_CLK_from_ff02 = '0')) ELSE
								RX_IS_DATA_DATACLK_ffsc;

CLK_PH_counter_ff_sc_next <= 	(others => '0') 		WHEN (FSM_Clocks_I.Reset = '1') ELSE
								(others => '0')			WHEN (FSM_Clocks_I.System_Counter = x"7") ELSE
								(others => '0')			WHEN (CLK_PH_counter_ff_sc = CLK_PH_counter_max) ELSE
								CLK_PH_counter_ff_sc + 1;

CLK_PH_counter_stop_ff_sc_next <=	(others => '0')		WHEN (FSM_Clocks_I.Reset = '1') ELSE
								CLK_PH_counter_ff_sc 	WHEN ((RX_CLK_from_ff01 = '1') and (RX_CLK_from_ff02 = '0')) ELSE
								CLK_PH_counter_stop_ff_sc;
-- ***************************************************



end Behavioral;

