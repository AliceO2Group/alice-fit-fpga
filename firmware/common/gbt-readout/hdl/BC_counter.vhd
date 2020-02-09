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
use ieee.std_logic_unsigned.all ;

use work.fit_gbt_common_package.all;

entity BC_counter is
Port ( 
	RESET_I					: in STD_LOGIC;
	DATA_CLK_I				: in  STD_LOGIC; -- 40MHz board clk
	
	IS_INIT_I				: in STD_LOGIC;
	ORBC_ID_INIT_I 			: in std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
		
	ORBC_ID_COUNT_O 		: out std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
	IS_Orbit_trg_O			: out std_logic
	);
end BC_counter;

architecture Behavioral of BC_counter is

	signal ORBC_ID_COUNT_ff, ORBC_ID_COUNT_ff_next	: std_logic_vector(Orbit_id_bitdepth + BC_id_bitdepth-1 downto 0);
	signal IS_Orbit_trg_ff, IS_Orbit_trg_ff_next	: std_logic;
	
	signal Orbit_ID 								: std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal Orbit_ID_max								: std_logic_vector(Orbit_id_bitdepth-1 downto 0);
	signal BC_ID									: std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal BC_ID_start								: std_logic_vector(BC_id_bitdepth-1 downto 0);

begin

-- flip-flop connecting ******************************
	Orbit_ID_max       <= (others => '1');
	BC_ID_start        <= (others => '0');

	ORBC_ID_COUNT_O    <= ORBC_ID_COUNT_ff;
	IS_Orbit_trg_O	   <= IS_Orbit_trg_ff;
	Orbit_ID           <= ORBC_ID_COUNT_ff(Orbit_id_bitdepth + BC_id_bitdepth - 1 downto BC_id_bitdepth);
	BC_ID              <= ORBC_ID_COUNT_ff(BC_id_bitdepth - 1 downto 0);
-- ***************************************************
	
	
		
-- Data ff data clk **********************************
	PROCESS (DATA_CLK_I)
	BEGIN
		IF(DATA_CLK_I'EVENT and DATA_CLK_I = '1') THEN
			IF(RESET_I = '1') THEN
				ORBC_ID_COUNT_ff <= (others => '0');
				IS_Orbit_trg_ff <= '0';
			ELSE
					ORBC_ID_COUNT_ff	<= ORBC_ID_COUNT_ff_next;
					IS_Orbit_trg_ff		<= IS_Orbit_trg_ff_next;
			END IF;
		END IF;
	END PROCESS;
-- ***************************************************
	




-- FSM ***********************************************
ORBC_ID_COUNT_ff_next <= 	(others => '0') 		WHEN (RESET_I = '1') 	ELSE
							ORBC_ID_INIT_I 			WHEN (IS_INIT_I = '1')  ELSE
							
							(others => '0')						WHEN (Orbit_ID = Orbit_ID_max) ELSE
							( (Orbit_ID + 1) &  BC_ID_start)	WHEN (BC_ID = (LHC_BCID_max + BC_ID_start)) ELSE
							( Orbit_ID &  (BC_ID+1) );
						
IS_Orbit_trg_ff_next <=	'0' 					WHEN (RESET_I = '1') 	ELSE
						'1'						WHEN (Orbit_ID = Orbit_ID_max) ELSE
						'1'						WHEN (BC_ID = (LHC_BCID_max + BC_ID_start)) ELSE
						'0';
-- ***************************************************



end Behavioral;

