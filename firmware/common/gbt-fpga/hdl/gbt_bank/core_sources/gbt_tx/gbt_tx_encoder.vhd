--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT TX encoder                                        
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
--                        10/05/2009   0.1       F. Marin (CPPM)   First .BDF entity definition.           
--
--                        07/07/2009   0.2       S. Baron (CERN)   Translate from .bdf to .vhd.
--
--                        04/07/2013   3.0       M. Barros Marin   - Cosmetic and minor modifications.   
--                                                                 - Add Wide-Bus encoding.               
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

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_tx_encoder is 
   generic (   
      GBT_BANK_ID                               : integer := 1;  
		NUM_LINKS											: integer := 1;
		TX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		RX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		TX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
		RX_ENCODING											: integer range 0 to 1 := GBT_FRAME   
   );
   port (
      
      --================--
      -- Reset & Clocks --
      --================--    
      
      -- Reset:
      ---------
      
      TX_RESET_I                                : in  std_logic;
      
      -- Clocks:
      ----------
      
      TX_FRAMECLK_I                             : in  std_logic;

      --==============--
      -- Frame header --
      --==============-- 
      
      TX_HEADER_I                               : in  std_logic_vector(  3 downto 0);      
      
      --=======--           
      -- Frame --           
      --=======--              
      
      -- Common:
      ----------
      
      TX_COMMON_FRAME_I                         : in  std_logic_vector( 83 downto 0);      
      
      -- Wide-Bus:
      ------------
      
      TX_EXTRA_FRAME_WIDEBUS_I                  : in  std_logic_vector( 31 downto 0);  
      
      -- Frame:
      ---------
      
      TX_FRAME_O                                : out std_logic_vector(119 downto 0)      

   );
end gbt_tx_encoder;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_tx_encoder is 


   --================================ Signal Declarations ================================--

   signal txFrame_from_rsEncoder                : std_logic_vector(119 downto 0);

   --=====================================================================================--  
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--   
   
   --==================================== User Logic =====================================--   
   
   --===========--
   -- GBT-Frame --
   --===========--
   
   gbtFrame_gen: if TX_ENCODING = GBT_FRAME generate
      
      -- Reed-Solomon encoder:
      ------------------------
      
      reedSolomonEncoder60to119: entity work.gbt_tx_encoder_gbtframe_rsencode
         port map (
            TX_COMMON_FRAME_I                   => TX_HEADER_I(3 DOWNTO 0) & TX_COMMON_FRAME_I(83 DOWNTO 44),
            TX_COMMON_FRAME_ENCODED_O           => txFrame_from_rsEncoder(119 DOWNTO 60)
         );
      
      reedSolomonEncoder0to59: entity work.gbt_tx_encoder_gbtframe_rsencode
         port map (
            TX_COMMON_FRAME_I                   => TX_COMMON_FRAME_I(43 DOWNTO 0),
            TX_COMMON_FRAME_ENCODED_O           => txFrame_from_rsEncoder(59 DOWNTO 0)
         );
      
      -- Interleaver:
      ---------------
      
      interleaver: entity work.gbt_tx_encoder_gbtframe_intlver
         port map (
            TX_FRAME_I                          => txFrame_from_rsEncoder,
            TX_FRAME_O                          => TX_FRAME_O
         );

   end generate;
   
   --==========--
   -- Wide-Bus --
   --==========--
   
   wideBus_gen: if TX_ENCODING = WIDE_BUS generate
      
      TX_FRAME_O                                <= TX_HEADER_I & TX_COMMON_FRAME_I & TX_EXTRA_FRAME_WIDEBUS_I;
   
   end generate;
   
   --=====================================================================================--
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--