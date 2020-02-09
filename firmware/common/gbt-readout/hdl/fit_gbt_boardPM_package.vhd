----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D.A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    10:29:21 08/11/2017 
-- Design Name: 	
-- Module Name:    
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all ;
use work.fit_gbt_common_package.all;

package fit_gbt_board_package is

	type Board_DataConversion_type_t is (one_word, two_words);

-- ===== CONSTANTS =============================================

-- data constants ----------------------------------------------
		constant Board_DataConversion_type	: Board_DataConversion_type_t := one_word;
		constant data_word_bitdepth			: integer := 40; -- max is 80 for TCM, 80/2 for PM
		constant tdwords_bitdepth			: integer := 4;
		constant total_data_words			: integer := 7; -- max data words in packet
-- -------------------------------------------------------------

-- =============================================================



-- Board data type =============================================
	type board_data_type is record
		is_header		: std_logic;
		is_data		: std_logic;
		is_packet		: std_logic;
		data_word	: std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	end record;
	
	constant board_data_test_const : board_data_type :=
	(						
		is_header => '0',
		is_data => '0',
		is_packet => '0',
		data_word => (others => '0')
	);
-- =============================================================




-- ###################### CONVERSION FUNCTION ##############################
function func_PMHEADER_get_header
(
        channel_n_words: std_logic_vector(tdwords_bitdepth-1 downto 0);
        ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);        
        BCID : std_logic_vector(BC_id_bitdepth-1 downto 0)
)
return std_logic_vector;

--function func_PMHEADER_is_header (pm_word : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic;
function func_PMHEADER_n_dwords (pm_word : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector;
function func_PMHEADER_getORBIT (pm_word : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector;
function func_PMHEADER_getBC (pm_word : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector;


-- #########################################################################


end fit_gbt_board_package;



package body fit_gbt_board_package is

-- ###################### CONVERSION FUNCTION ##############################
function func_PMHEADER_get_header
(
        channel_n_words: std_logic_vector(tdwords_bitdepth-1 downto 0);
		ORBIT : std_logic_vector(Orbit_id_bitdepth-1 downto 0);        
		BCID : std_logic_vector(BC_id_bitdepth-1 downto 0)
)
return std_logic_vector is

begin
    return x"F" & channel_n_words(tdwords_bitdepth-1 downto 0) & x"000_0000" & ORBIT & BCID;
end function;


-- function func_PMHEADER_is_header (pm_word : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic is
-- begin
-- if(pm_word(GBT_data_word_bitdepth-1 downto GBT_data_word_bitdepth-4) = x"f") then return '1'; else return '0'; end if;
-- end function;

function func_PMHEADER_getORBIT (pm_word : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector is
begin
return pm_word(Orbit_id_bitdepth+BC_id_bitdepth-1 downto BC_id_bitdepth);
end function;

function func_PMHEADER_getBC (pm_word : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector is
begin
return pm_word(BC_id_bitdepth-1 downto 0);
end function;

function func_PMHEADER_n_dwords (pm_word : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0)) return std_logic_vector is
variable void_add : std_logic_vector(n_pckt_wrds_bitdepth-1 - 4 downto 0);
variable ret_val : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);

begin
void_add := (others => '0');
ret_val := void_add & pm_word(GBT_data_word_bitdepth-1-4 downto GBT_data_word_bitdepth-8);

return ret_val;
end function;


-- #########################################################################

end fit_gbt_board_package;
