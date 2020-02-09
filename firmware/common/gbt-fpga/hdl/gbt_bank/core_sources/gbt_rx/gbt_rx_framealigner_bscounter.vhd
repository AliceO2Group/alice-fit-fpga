--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)                            
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX frame aligner bitslip counter
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
--                        25/09/2008   0.1       F. Marin (CPPM)   First .vhd entity definition.
--
--                        26/11/2013   3.0       M. Barros Marin   - Cosmetic and minor modifications.
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

entity gbt_rx_framealigner_bscounter is
   port ( 
      
      --===============--
      -- Reset & Clock --
      --===============--    
      
      -- Reset:
      ---------
      
      RX_RESET_I                                : in  std_logic;
      
      -- Clock:
      ---------
      
      RX_WORDCLK_I                              : in  std_logic;
      
      --=========--
      -- Control --
      --=========--
   
      RX_BITSLIP_CMD_I                          : in  std_logic;
      RX_BITSLIP_OVERFLOW_CMD_O                 : out std_logic;
      RX_BITSLIP_NBR_O                          : out std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0)
  
   );  
end gbt_rx_framealigner_bscounter;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_framealigner_bscounter is 
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--     

   --==================================== User Logic =====================================--   

   main: process (RX_RESET_I, RX_WORDCLK_I)
      variable count                            : unsigned(GBTRX_BITSLIP_NBR_MSB downto 0);
   begin    
      if RX_RESET_I = '1' then
         count                                  := (others => '0');
         RX_BITSLIP_OVERFLOW_CMD_O              <= '0';
         RX_BITSLIP_NBR_O                       <= (others => '0');
      elsif rising_edge(RX_WORDCLK_I) then
         RX_BITSLIP_OVERFLOW_CMD_O              <= '0';
         if RX_BITSLIP_CMD_I = '1' then
           if count = GBTRX_BITSLIP_NBR_MAX then
             count                              := (others => '0');
             RX_BITSLIP_OVERFLOW_CMD_O          <= '1';
           else
             count                              := count + 1;
           end if;
         end if;
         RX_BITSLIP_NBR_O                       <= std_logic_vector(count);
      end if;
   end process;
   
   --=====================================================================================--   
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--