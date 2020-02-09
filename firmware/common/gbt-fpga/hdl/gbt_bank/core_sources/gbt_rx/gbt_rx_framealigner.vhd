--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)                            
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX frame aligner                                       
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Device agnostic                                                         
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
--                        04/07/2013   3.0       M. Barros Marin   - Cosmetic and minor modifications.
--                                                                 - Support for 20bit and 40bit words.
--                                                                 - Merged with the bitslip counter.
--                                                                 - Merged with pattern search.   
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

entity gbt_rx_framealigner is
   port (
   
      --===============--
      -- Reset & Clock --
      --===============--    
      
      -- Reset:
      ---------
    
      RX_RESET_I                                     : in  std_logic;
      
      -- Clock:
      ---------
      
      RX_WORDCLK_I                                   : in  std_logic;
      
      --=========--
      -- Control --
      --=========--
      
      RX_MGT_RDY_I                                   : in  std_logic;
      RX_HEADER_LOCKED_O                             : out std_logic;
      RX_HEADER_FLAG_O                               : out std_logic;       
      RX_BITSLIP_NBR_O                               : out std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      RX_WRITE_ADDRESS_O                             : out std_logic_vector(WORD_ADDR_MSB downto 0);            
      
      --======--
      -- Word --
      --======--
      
      RX_WORD_I                                      : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      ALIGNED_RX_WORD_O                              : out std_logic_vector(WORD_WIDTH-1 downto 0)      
      
   );
end gbt_rx_framealigner;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_rx_framealigner is

   --================================ Signal Declarations ================================--
   
   --=======================--
   -- Write Address Control --
   --=======================--
   
   signal rxPsWriteAddress_from_writeAddressCtrl     : std_logic_vector(WORD_ADDR_MSB downto 0);   
   
   --================--
   -- Pattern Search --
   --================--
   
   signal rxBitSlipCmd_from_patternSearch            : std_logic;
   signal rxGbWriteAddressRst_from_patternSearch     : std_logic;
   
   --=================--
   -- Bitslip counter --
   --=================--
   
   signal rxBitslipOverflowCmd_from_rxBitSlipCounter : std_logic;
   signal rxBitSlipCount_from_rxBitSlipCounter       : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);  
   
   --===============--
   -- Right shifter --
   --===============--
   
   signal ready_from_rightShifter                    : std_logic;
   signal shiftedRxWord_from_rightShifter            : std_logic_vector(WORD_WIDTH-1 downto 0);
   
   --=====================================================================================--
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================-- 
   
   --==================================== User Logic =====================================--
   
   --=======================--
   -- Write Address Control --
   --=======================--
   
   writeAddressCtrl: entity work.gbt_rx_framealigner_wraddr
      port map (
         RX_RESET_I                                  => RX_RESET_I,
         RX_WORDCLK_I                                => RX_WORDCLK_I,
         RX_BITSLIP_OVERFLOW_CMD_I                   => rxBitslipOverflowCmd_from_rxBitSlipCounter,
         RX_PS_WRITE_ADDRESS_O                       => rxPsWriteAddress_from_writeAddressCtrl,
         RX_GB_WRITE_ADDRESS_RST_I                   => rxGbWriteAddressRst_from_patternSearch,
         RX_GB_WRITE_ADDRESS_O                       => RX_WRITE_ADDRESS_O  
      );  
   
   --================--
   -- Pattern Search --
   --================--
   
   patternSearch: entity work.gbt_rx_framealigner_pattsearch
      port map (
         RX_RESET_I                                  => RX_RESET_I,
         RX_WORDCLK_I                                => RX_WORDCLK_I,
         ---------------------------------------     
         RIGHTSHIFTER_READY_I                        => ready_from_rightShifter,
         RX_WRITE_ADDRESS_I                          => rxPsWriteAddress_from_writeAddressCtrl,
         RX_BITSLIP_CMD_O                            => rxBitSlipCmd_from_patternSearch,
         RX_HEADER_LOCKED_O                          => RX_HEADER_LOCKED_O,
         RX_HEADER_FLAG_O                            => RX_HEADER_FLAG_O,
         RX_GB_WRITE_ADDRESS_RST_O                   => rxGbWriteAddressRst_from_patternSearch,
         ---------------------------------------     
         RX_WORD_I                                   => shiftedRxWord_from_rightShifter,
         RX_WORD_O                                   => ALIGNED_RX_WORD_O
      );  
   
   --=================--
   -- Bitslip counter --
   --=================--
   
   rxBitSlipCounter: entity work.gbt_rx_framealigner_bscounter
      port map (
         RX_RESET_I                                  => RX_RESET_I,
         RX_WORDCLK_I                                => RX_WORDCLK_I,
         RX_BITSLIP_CMD_I                            => rxBitSlipCmd_from_patternSearch,
         RX_BITSLIP_OVERFLOW_CMD_O                   => rxBitslipOverflowCmd_from_rxBitSlipCounter,
         RX_BITSLIP_NBR_O                            => rxBitSlipCount_from_rxBitSlipCounter
      );      
     
   RX_BITSLIP_NBR_O                                  <= rxBitSlipCount_from_rxBitSlipCounter; 
   
   --===============--
   -- Right shifter --
   --===============--
   
   rightShifter: entity work.gbt_rx_framealigner_rightshift
      port map (
         RX_RESET_I                                  => RX_RESET_I,
         RX_WORDCLK_I                                => RX_WORDCLK_I,
         RX_MGT_RDY_I                                => RX_MGT_RDY_I,
         READY_O                                     => ready_from_rightShifter,
         RX_BITSLIP_COUNT_I                          => rxBitSlipCount_from_rxBitSlipCounter,
         RX_WORD_I                                   => RX_WORD_I,
         SHIFTED_RX_WORD_O                           => shiftedRxWord_from_rightShifter
      );  
   
   --=====================================================================================--
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--