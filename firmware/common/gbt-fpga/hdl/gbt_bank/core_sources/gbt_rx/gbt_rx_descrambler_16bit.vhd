--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX descrambler 16bit                                        
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
--                        09/07/2013   3.0       M. Barros Marin   First .vhd module definition.                                                                                  
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

entity gbt_rx_descrambler_16bit is
   port (
      
      --===============--
      -- Reset & Clock --
      --===============--    
      
      -- Reset:
      ---------
      
      RX_RESET_I                                : in  std_logic;
      
      -- Clock:
      ---------
      
      RX_FRAMECLK_I                             : in  std_logic;
      
      --==============--           
      -- Frame & Data --           
      --==============--
      
      -- Wide-Bus extra frame:
      ------------------------
      
      RX_EXTRA_FRAME_WIDEBUS_I                  : in  std_logic_vector(15 downto 0);

       -- Wide-Bus extra data:
      ------------------------
      
      RX_EXTRA_DATA_WIDEBUS_O                   : out std_logic_vector(15 downto 0)
   
   );
end gbt_rx_descrambler_16bit;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_descrambler_16bit is
   
   --================================ Signal Declarations ================================--
 
   signal feedbackRegister                      : std_logic_vector(15 downto 0);
   
   --=====================================================================================--  
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--   
   
   desscrambler16bit: process(RX_RESET_I, RX_FRAMECLK_I)
   begin   
      if RX_RESET_I = '1' then
         feedbackRegister                       <= (others => '0');
      elsif RISING_EDGE(RX_FRAMECLK_I) then

         RX_EXTRA_DATA_WIDEBUS_O( 0) <= RX_EXTRA_FRAME_WIDEBUS_I( 0) xor feedbackRegister( 0) xor feedbackRegister        ( 2) xor feedbackRegister        ( 3) xor feedbackRegister        ( 5);
         RX_EXTRA_DATA_WIDEBUS_O( 1) <= RX_EXTRA_FRAME_WIDEBUS_I( 1) xor feedbackRegister( 1) xor feedbackRegister        ( 3) xor feedbackRegister        ( 4) xor feedbackRegister        ( 6);
         RX_EXTRA_DATA_WIDEBUS_O( 2) <= RX_EXTRA_FRAME_WIDEBUS_I( 2) xor feedbackRegister( 2) xor feedbackRegister        ( 4) xor feedbackRegister        ( 5) xor feedbackRegister        ( 7);
         RX_EXTRA_DATA_WIDEBUS_O( 3) <= RX_EXTRA_FRAME_WIDEBUS_I( 3) xor feedbackRegister( 3) xor feedbackRegister        ( 5) xor feedbackRegister        ( 6) xor feedbackRegister        ( 8);
         RX_EXTRA_DATA_WIDEBUS_O( 4) <= RX_EXTRA_FRAME_WIDEBUS_I( 4) xor feedbackRegister( 4) xor feedbackRegister        ( 6) xor feedbackRegister        ( 7) xor feedbackRegister        ( 9);
         RX_EXTRA_DATA_WIDEBUS_O( 5) <= RX_EXTRA_FRAME_WIDEBUS_I( 5) xor feedbackRegister( 5) xor feedbackRegister        ( 7) xor feedbackRegister        ( 8) xor feedbackRegister        (10);
         RX_EXTRA_DATA_WIDEBUS_O( 6) <= RX_EXTRA_FRAME_WIDEBUS_I( 6) xor feedbackRegister( 6) xor feedbackRegister        ( 8) xor feedbackRegister        ( 9) xor feedbackRegister        (11);
         RX_EXTRA_DATA_WIDEBUS_O( 7) <= RX_EXTRA_FRAME_WIDEBUS_I( 7) xor feedbackRegister( 7) xor feedbackRegister        ( 9) xor feedbackRegister        (10) xor feedbackRegister        (12);
         RX_EXTRA_DATA_WIDEBUS_O( 8) <= RX_EXTRA_FRAME_WIDEBUS_I( 8) xor feedbackRegister( 8) xor feedbackRegister        (10) xor feedbackRegister        (11) xor feedbackRegister        (13);
         RX_EXTRA_DATA_WIDEBUS_O( 9) <= RX_EXTRA_FRAME_WIDEBUS_I( 9) xor feedbackRegister( 9) xor feedbackRegister        (11) xor feedbackRegister        (12) xor feedbackRegister        (14);
         RX_EXTRA_DATA_WIDEBUS_O(10) <= RX_EXTRA_FRAME_WIDEBUS_I(10) xor feedbackRegister(10) xor feedbackRegister        (12) xor feedbackRegister        (13) xor feedbackRegister        (15);
         RX_EXTRA_DATA_WIDEBUS_O(11) <= RX_EXTRA_FRAME_WIDEBUS_I(11) xor feedbackRegister(11) xor feedbackRegister        (13) xor feedbackRegister        (14) xor RX_EXTRA_FRAME_WIDEBUS_I( 0);
         RX_EXTRA_DATA_WIDEBUS_O(12) <= RX_EXTRA_FRAME_WIDEBUS_I(12) xor feedbackRegister(12) xor feedbackRegister        (14) xor feedbackRegister        (15) xor RX_EXTRA_FRAME_WIDEBUS_I( 1);
         RX_EXTRA_DATA_WIDEBUS_O(13) <= RX_EXTRA_FRAME_WIDEBUS_I(13) xor feedbackRegister(13) xor feedbackRegister        (15) xor RX_EXTRA_FRAME_WIDEBUS_I( 0) xor RX_EXTRA_FRAME_WIDEBUS_I( 2);
         RX_EXTRA_DATA_WIDEBUS_O(14) <= RX_EXTRA_FRAME_WIDEBUS_I(14) xor feedbackRegister(14) xor RX_EXTRA_FRAME_WIDEBUS_I( 0) xor RX_EXTRA_FRAME_WIDEBUS_I( 1) xor RX_EXTRA_FRAME_WIDEBUS_I( 3);
         RX_EXTRA_DATA_WIDEBUS_O(15) <= RX_EXTRA_FRAME_WIDEBUS_I(15) xor feedbackRegister(15) xor RX_EXTRA_FRAME_WIDEBUS_I( 1) xor RX_EXTRA_FRAME_WIDEBUS_I( 2) xor RX_EXTRA_FRAME_WIDEBUS_I( 4);
         ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
         feedbackRegister                       <= RX_EXTRA_FRAME_WIDEBUS_I;
           
      end if;
   end process;  

   --=====================================================================================--   
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--