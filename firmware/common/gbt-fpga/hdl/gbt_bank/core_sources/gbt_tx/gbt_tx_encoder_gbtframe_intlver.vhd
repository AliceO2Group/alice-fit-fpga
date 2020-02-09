--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT TX encoder GBT-Frame interleaver          
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
--                        24/09/2008   0.1       F. Marin (CPPM)   First .vhd module definition (bit based).           
--                                                                   
--                        06/04/2009   0.2       S. Baron (CERN)   Modification to make it nibble based.
--                                                                   
--                        04/07/2013   3.0       M. Barros Marin   Cosmetic and minor modifications.                                                                   
--                                                                       
--
-- Additional Comments:   * Interleaves two buses of 60 bits. TX_FRAME_O is then on 120 bits.
--
--                        * It's a 4-bits (= word) interleaving (nibble-based). No clock cycle.                                                     
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

entity gbt_tx_encoder_gbtframe_intlver is
   port (
   
      TX_FRAME_I                                : in  std_logic_vector(119 downto 0);
      TX_FRAME_O                                : out std_logic_vector(119 downto 0)
      
   );   
end gbt_tx_encoder_gbtframe_intlver;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_tx_encoder_gbtframe_intlver is
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  

   --==================================== User Logic =====================================--
   
   gbtFrameInterleaving_gen: for i in 0 to 14 generate
   
      TX_FRAME_O(119-(8*i) downto 116-(8*i))    <= TX_FRAME_I(119-(4*i) downto 116-(4*i));
      TX_FRAME_O(115-(8*i) downto 112-(8*i))    <= TX_FRAME_I( 59-(4*i) downto  56-(4*i));
      
   end generate;
  
   --=====================================================================================--     
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--