--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT TX scrambler 16bit                                        
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Vendor agnostic                                                      
-- Tool version:                                                                             
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        08/07/2013   3.0       M. Barros Marin   First .vhd module definition.                                                                                  
--
-- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!   (Note!! These parameters are vendor specific)                                           !!                    
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_bank_package.vhd").                                !! 
-- !!     (e.g. xlx_v6_gbt_bank_package.vhd)                                                    !!
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<vendor>_<device>_gbt_bank_user_setup.vhd".     !!
-- !!     (e.g. xlx_v6_gbt_bank_user_setup.vhd)                                                 !! 
-- !!                                                                                           !! 
-- !! * The "<vendor>_<device>_gbt_bank_user_setup.vhd" is the only file of the GBT Bank that   !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                                   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_tx_scrambler_16bit is
   port (
  
      --================--
      -- Reset & Clocks --
      --================--    
      
      -- Reset scheme:
      ----------------
      
      TX_RESET_I                                : in  std_logic;
      ------------------------------------------
      RESET_PATTERN_I                           : in  std_logic_vector(15 downto 0);      
      
      -- Clock:
      ---------
      
      TX_FRAMECLK_I                             : in  std_logic;
      
      --==============--           
      -- Data & Frame --           
      --==============--              
      
      -- Wide-Bus extra data:
      -----------------------
      
      TX_EXTRA_DATA_WIDEBUS_I                   : in  std_logic_vector(15 downto 0);
      
      -- Wide-Bus extra frame:
      ------------------------
      
      TX_EXTRA_FRAME_WIDEBUS_O                  : out std_logic_vector(15 downto 0)
   
   );
end gbt_tx_scrambler_16bit;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_tx_scrambler_16bit is

   --================================ Signal Declarations ================================--

   signal feedbackRegister                      : std_logic_vector(15 downto 0);

   --=====================================================================================--  
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--

   scrambler16bit: process(TX_RESET_I, TX_FRAMECLK_I)
   begin
      if TX_RESET_I = '1' then
         feedbackRegister                       <= RESET_PATTERN_I;
      elsif rising_edge(TX_FRAMECLK_I) then      

         feedbackRegister( 0) <= TX_EXTRA_DATA_WIDEBUS_I( 0) xor feedbackRegister( 0) xor feedbackRegister       ( 2) xor feedbackRegister       ( 3) xor feedbackRegister       ( 5);
         feedbackRegister( 1) <= TX_EXTRA_DATA_WIDEBUS_I( 1) xor feedbackRegister( 1) xor feedbackRegister       ( 3) xor feedbackRegister       ( 4) xor feedbackRegister       ( 6);
         feedbackRegister( 2) <= TX_EXTRA_DATA_WIDEBUS_I( 2) xor feedbackRegister( 2) xor feedbackRegister       ( 4) xor feedbackRegister       ( 5) xor feedbackRegister       ( 7);
         feedbackRegister( 3) <= TX_EXTRA_DATA_WIDEBUS_I( 3) xor feedbackRegister( 3) xor feedbackRegister       ( 5) xor feedbackRegister       ( 6) xor feedbackRegister       ( 8);
         feedbackRegister( 4) <= TX_EXTRA_DATA_WIDEBUS_I( 4) xor feedbackRegister( 4) xor feedbackRegister       ( 6) xor feedbackRegister       ( 7) xor feedbackRegister       ( 9);
         feedbackRegister( 5) <= TX_EXTRA_DATA_WIDEBUS_I( 5) xor feedbackRegister( 5) xor feedbackRegister       ( 7) xor feedbackRegister       ( 8) xor feedbackRegister       (10);
         feedbackRegister( 6) <= TX_EXTRA_DATA_WIDEBUS_I( 6) xor feedbackRegister( 6) xor feedbackRegister       ( 8) xor feedbackRegister       ( 9) xor feedbackRegister       (11);
         feedbackRegister( 7) <= TX_EXTRA_DATA_WIDEBUS_I( 7) xor feedbackRegister( 7) xor feedbackRegister       ( 9) xor feedbackRegister       (10) xor feedbackRegister       (12);
         feedbackRegister( 8) <= TX_EXTRA_DATA_WIDEBUS_I( 8) xor feedbackRegister( 8) xor feedbackRegister       (10) xor feedbackRegister       (11) xor feedbackRegister       (13);
         feedbackRegister( 9) <= TX_EXTRA_DATA_WIDEBUS_I( 9) xor feedbackRegister( 9) xor feedbackRegister       (11) xor feedbackRegister       (12) xor feedbackRegister       (14);
         feedbackRegister(10) <= TX_EXTRA_DATA_WIDEBUS_I(10) xor feedbackRegister(10) xor feedbackRegister       (12) xor feedbackRegister       (13) xor feedbackRegister       (15);
         feedbackRegister(11) <= TX_EXTRA_DATA_WIDEBUS_I(11) xor feedbackRegister(11) xor feedbackRegister       (13) xor feedbackRegister       (14) xor TX_EXTRA_DATA_WIDEBUS_I( 0) xor feedbackRegister(0) xor feedbackRegister(2) xor feedbackRegister       (3) xor feedbackRegister       (5);
         feedbackRegister(12) <= TX_EXTRA_DATA_WIDEBUS_I(12) xor feedbackRegister(12) xor feedbackRegister       (14) xor feedbackRegister       (15) xor TX_EXTRA_DATA_WIDEBUS_I( 1) xor feedbackRegister(1) xor feedbackRegister(3) xor feedbackRegister       (4) xor feedbackRegister       (6);
         feedbackRegister(13) <= TX_EXTRA_DATA_WIDEBUS_I(13) xor feedbackRegister(13) xor feedbackRegister       (15) xor TX_EXTRA_DATA_WIDEBUS_I( 0) xor feedbackRegister       ( 0) xor feedbackRegister(2) xor feedbackRegister(3) xor feedbackRegister       (5) xor TX_EXTRA_DATA_WIDEBUS_I(2) xor feedbackRegister(2) xor feedbackRegister(4) xor feedbackRegister(5) xor feedbackRegister       (7);
         feedbackRegister(14) <= TX_EXTRA_DATA_WIDEBUS_I(14) xor feedbackRegister(14) xor TX_EXTRA_DATA_WIDEBUS_I( 0) xor feedbackRegister       ( 0) xor feedbackRegister       ( 2) xor feedbackRegister(3) xor feedbackRegister(5) xor TX_EXTRA_DATA_WIDEBUS_I(1) xor feedbackRegister       (1) xor feedbackRegister(3) xor feedbackRegister(4) xor feedbackRegister(6) xor TX_EXTRA_DATA_WIDEBUS_I(3) xor feedbackRegister(3) xor feedbackRegister(5) xor feedbackRegister(6) xor feedbackRegister(8);
         feedbackRegister(15) <= TX_EXTRA_DATA_WIDEBUS_I(15) xor feedbackRegister(15) xor TX_EXTRA_DATA_WIDEBUS_I( 1) xor feedbackRegister       ( 1) xor feedbackRegister       ( 3) xor feedbackRegister(4) xor feedbackRegister(6) xor TX_EXTRA_DATA_WIDEBUS_I(2) xor feedbackRegister       (2) xor feedbackRegister(4) xor feedbackRegister(5) xor feedbackRegister(7) xor TX_EXTRA_DATA_WIDEBUS_I(4) xor feedbackRegister(4) xor feedbackRegister(6) xor feedbackRegister(7) xor feedbackRegister(9);                                             

      end if;
   end process;
  
   TX_EXTRA_FRAME_WIDEBUS_O                     <= feedbackRegister;

   --=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--