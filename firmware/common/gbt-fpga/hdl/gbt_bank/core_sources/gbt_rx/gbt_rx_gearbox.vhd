--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX gearbox          
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
--                        27/06/2013   3.0       M. Barros Marin   First .vhd module definition. 
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

entity gbt_rx_gearbox is
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
      
      RX_RESET_I                                : in  std_logic;
      
      -- Clocks:
      ----------
      
      RX_WORDCLK_I                              : in  std_logic;
      RX_FRAMECLK_I                             : in  std_logic;
      
      --=========--
      -- Control --
      --=========--
      
      RX_HEADER_LOCKED_I                        : in  std_logic;
      RX_WRITE_ADDRESS_I                        : in  std_logic_vector(WORD_ADDR_MSB downto 0);
      READY_O                                   : out std_logic;

      --==============--
      -- Word & Frame --
      --==============--
      
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      RX_FRAME_O                                : out std_logic_vector(119 downto 0)      
      
   );   
end gbt_rx_gearbox;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_rx_gearbox is
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  
   
   --==================================== User Logic =====================================--
   
   --==========--
   -- Standard --
   --==========--
   
   rxGearboxStd_gen: if RX_OPTIMIZATION = STANDARD generate
   
      rxGearboxStd: entity work.gbt_rx_gearbox_std
         port map (      
            RX_RESET_I                          => RX_RESET_I,     
            RX_WORDCLK_I                        => RX_WORDCLK_I, 
            RX_FRAMECLK_I                       => RX_FRAMECLK_I, 
            ------------------------------------
            RX_HEADER_LOCKED_I                  => RX_HEADER_LOCKED_I,
            RX_WRITE_ADDRESS_I                  => RX_WRITE_ADDRESS_I,
            READY_O                             => READY_O,
            ------------------------------------
            RX_WORD_I                           => RX_WORD_I,
            RX_FRAME_O                          => RX_FRAME_O      
         );   
      
   end generate;   
   
   --===================--
   -- Latency-optimized --
   --===================--
   
   rxGearboxLatOpt_gen: if RX_OPTIMIZATION = LATENCY_OPTIMIZED generate   
   
      rxGearboxLatOpt: entity work.gbt_rx_gearbox_latopt
         port map (
            RX_RESET_I                          => RX_RESET_I,     
            RX_WORDCLK_I                        => RX_WORDCLK_I, 
            RX_FRAMECLK_I                       => RX_FRAMECLK_I, 
            ------------------------------------
            RX_HEADER_LOCKED_I                  => RX_HEADER_LOCKED_I,
            RX_WRITE_ADDRESS_I                  => RX_WRITE_ADDRESS_I,
            READY_O                             => READY_O,
            ------------------------------------
            RX_WORD_I                           => RX_WORD_I,
            RX_FRAME_O                          => RX_FRAME_O      
         );   
      
   end generate;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--