--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX descrambler                                        
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
--                        13/06/2013   3.0       M.Barros Marin    - Cosmetic and minor modifications.
--                                                                 - Add Wide-Bus scrambling.
--
--                        01/09/2014   3.2       M. Barros Marin   Fixed generic issue (TX_ENCODING -> RX_ENCODING).  
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

entity gbt_rx_descrambler is 
   generic (   
      GBT_BANK_ID                               : integer := 1;
		NUM_LINKS											: integer := 1;
		TX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		RX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		TX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
		RX_ENCODING											: integer range 0 to 1 := GBT_FRAME    
   );             
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
      
      --=========--                                
      -- Control --                                
      --=========-- 
      
      -- Ready flag:
      --------------
      
      RX_DECODER_READY_I                        : in  std_logic;        
      READY_O                                   : out std_logic;
      
      -- RX is data flag:
      -------------------  
      
      RX_ISDATA_FLAG_I                          : in  std_logic;
      RX_ISDATA_FLAG_O                          : out std_logic;
      
      --==============--           
      -- Frame & Data --           
      --==============-- 
      
      -- Common:
      ----------
      
      RX_COMMON_FRAME_I                         : in  std_logic_vector(83 downto 0);
      RX_DATA_O                                 : out std_logic_vector(83 downto 0);
      
      -- Wide-Bus:
      ------------
      
      RX_EXTRA_FRAME_WIDEBUS_I                  : in  std_logic_vector(31 downto 0);
      RX_EXTRA_DATA_WIDEBUS_O                   : out std_logic_vector(31 downto 0)
      
   );
end gbt_rx_descrambler;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_rx_descrambler is 

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
  
   --==================================== User Logic =====================================--
   
   --===========--
   -- Registers --
   --===========--
   
   regs: process(RX_FRAMECLK_I, RX_RESET_I)
   begin
      if RX_RESET_I = '1' then
         RX_ISDATA_FLAG_O                       <= '0';
         READY_O                                <= '0';
      elsif rising_edge(RX_FRAMECLK_I) then
         RX_ISDATA_FLAG_O                       <= RX_ISDATA_FLAG_I;
         READY_O                                <= RX_DECODER_READY_I;
      end if;
   end process;
   
   --============--
   -- Scramblers --
   --============--
   
   -- 84 bit scrambler (GBT-Frame & Wide-Bus):
   -------------------------------------------
   
   gbtFrameOrWideBus_gen: if    (RX_ENCODING = GBT_FRAME)
                             or (RX_ENCODING = WIDE_BUS) generate 

      gbtRxDescrambler84bit_gen: for i in 0 to 3 generate
         
         -- Comment: [83:63] & [62:42] & [41:21] & [20:0]
         
         gbtRxDescrambler21bit: entity work.gbt_rx_descrambler_21bit
            port map(
               RX_RESET_I                       => RX_RESET_I,
               RX_FRAMECLK_I                    => RX_FRAMECLK_I,
               RX_COMMON_FRAME_I                => RX_COMMON_FRAME_I(((21*i)+20) downto (21*i)), 
               RX_DATA_O                        => RX_DATA_O(((21*i)+20) downto (21*i))
            );
            
      end generate;
      
   end generate;
   
   -- 32 bit scrambler (Wide-Bus):
   ------------------------------
   
    wideBus_gen: if RX_ENCODING = WIDE_BUS generate
      
      gbtRxDescrambler32bit_gen: for i in 0 to 1 generate
      
      -- Comment: [31:16] & [15:0]
      
         gbtRxDescrambler16bit: entity work.gbt_rx_descrambler_16bit
            port map(
               RX_RESET_I                       => RX_RESET_I,
               RX_FRAMECLK_I                    => RX_FRAMECLK_I,
               RX_EXTRA_FRAME_WIDEBUS_I         => RX_EXTRA_FRAME_WIDEBUS_I(((16*i)+15) downto (16*i)),
               RX_EXTRA_DATA_WIDEBUS_O          => RX_EXTRA_DATA_WIDEBUS_O(((16*i)+15) downto (16*i))
            );
         
      end generate; 
     
   end generate;     
   
   wideBus_no_gen: if RX_ENCODING /= WIDE_BUS generate
   
      RX_EXTRA_DATA_WIDEBUS_O                   <= (others => '0');
   
   end generate;
   --=====================================================================================--
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--