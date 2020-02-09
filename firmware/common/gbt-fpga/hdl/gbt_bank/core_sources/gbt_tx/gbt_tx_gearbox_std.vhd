--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT TX gearbox standard         
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
--                        10/05/2009   0.1       F. Marin (CPPM)   First .bdf entity definition.           
--                                                                   
--                        08/07/2009   0.2       S. Baron (CERN)   Translate from .bdf to .vhd.
--                                                                   
--                        09/08/2013   3.0       M. Barros Marin   - Cosmetic and minor modifications.                                                                   
--                                                                 - Support for 20bit and 40bit words. 
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

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_tx_gearbox_std is 
   port (
      
      --================--
      -- Reset & Clocks --
      --================--    
      
      -- Reset:
      ---------
      
      TX_RESET_I                                : in  std_logic;
      TX_MGT_READY_I                            : in  std_logic;
      
      -- Clocks:
      ----------
      
      TX_FRAMECLK_I                             : in  std_logic;
      TX_WORDCLK_I                              : in  std_logic;
      
      --==============--
      -- Frame & Word --
      --==============--
      
      TX_FRAME_I                                : in  std_logic_vector(119 downto 0);
      TX_WORD_O                                 : out std_logic_vector(WORD_WIDTH-1 downto 0);
		
      TX_GEARBOX_READY_O                        : out std_logic
      
   );
end gbt_tx_gearbox_std;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_tx_gearbox_std is 

   --================================ Signal Declarations ================================--
   
   --=========--
   -- Control --
   --=========--
   
   signal writeAddress_from_readWriteControl    : std_logic_vector(2 downto 0);
   signal readAddress_from_readWriteControl     : std_logic_vector(WORD_ADDR_MSB downto 0);
   
   --==========--
   -- Inverter --
   --==========--
   
   signal txFrame_from_frameInverter            : std_logic_vector(119 downto 0);   
   
   --=====================================================================================--

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  

   --==================================== User Logic =====================================--   
   
   --=========--
   -- Control --
   --=========--
   
   readWriteControl: entity work.gbt_tx_gearbox_std_rdwrctrl
      port map (
         TX_RESET_I                             => TX_RESET_I,   
         TX_MGT_READY_I                     	   => TX_MGT_READY_I,        
         TX_FRAMECLK_I                          => TX_FRAMECLK_I,
         TX_WORDCLK_I                           => TX_WORDCLK_I,          
         WRITE_ADDRESS_O                        => writeAddress_from_readWriteControl,
         READ_ADDRESS_O                         => readAddress_from_readWriteControl
      );

   --==========--
   -- Inverter --
   --==========--
   
   -- Comment: Bits are inverted to transmit the MSB first by the MGT.
   
   frameInverter: for i in 119 downto 0 generate
      txFrame_from_frameInverter(i)             <= TX_FRAME_I(119-i);      
   end generate;

   --==========--
   -- Inverter --
   --==========--   

   dpram: entity work.gbt_tx_gearbox_std_dpram
      port map (
         WR_CLK_I                               => TX_FRAMECLK_I,
         WR_ADDRESS_I                           => writeAddress_from_readWriteControl,   
         WR_DATA_I                              => txFrame_from_frameInverter,
         RD_CLK_I                               => TX_WORDCLK_I,
         RD_ADDRESS_I                           => readAddress_from_readWriteControl,
         RD_DATA_O                              => TX_WORD_O
      );   
   
	TX_GEARBOX_READY_O <= TX_MGT_READY_I and not(TX_RESET_I);
   --=====================================================================================--
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--