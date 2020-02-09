--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT TX gearbox standard read/write control  
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
--                        25/09/2008   0.1       F. Marin (CPPM)   First .vhd module definition.           
--                                                            
--                        09/08/2013   3.0       M. Barros Marin   - Cosmetic and minor modifications.                                                                   
--                                                                 - Support for 20bit and 40bit words. 
--                                                                 - Use "case" instead of "if/else".
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

entity gbt_tx_gearbox_std_rdwrctrl is
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
      
      --===========--
      -- Addresses --
      --===========--
      
      WRITE_ADDRESS_O                           : out std_logic_vector(2 downto 0);
      READ_ADDRESS_O                            : out std_logic_vector(WORD_ADDR_MSB downto 0)
      
   );   
end gbt_tx_gearbox_std_rdwrctrl;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behabioral of gbt_tx_gearbox_std_rdwrctrl is

   --================================ Signal Declarations ================================--

   signal writeAddress                          : integer range 0 to  7;
   signal readAddress                           : integer range 0 to 63;   
  
   --=====================================================================================--
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  
   
   --================================ Signal Declarations ================================--
  
   --===============--
   -- Write Address --
   --===============--   
   
   WRITE_ADDRESS_O                              <= std_logic_vector(to_unsigned(writeAddress,3));
   
   writeAddrCtrl: process(TX_RESET_I, TX_FRAMECLK_I, TX_MGT_READY_I)
   begin 
   if rising_edge(TX_FRAMECLK_I) then     
      if TX_RESET_I = '1' or TX_MGT_READY_I = '0' then
         writeAddress                           <= 6;   -- Comment: Note!! Do not modify (default value 6).
      else
         if writeAddress = 7 then
            writeAddress                        <= 0;
         else   
            writeAddress                        <= writeAddress + 1;
         end if;
      end if;
    end if;
   end process;   
   
   --==============--
   -- Read Address --
   --==============--
   
   READ_ADDRESS_O                               <= std_logic_vector(to_unsigned(readAddress,(WORD_ADDR_MSB+1)));
   
   -- Comment: The TX DPRAM is 160-bits wide but only 120-bits are used (the words of the last 40bit are not read).         
   
   -- Word width (20 Bit):
   -----------------------
   
   readAddrCtrl20b_gen: if WORD_WIDTH = 20 generate
 
      readAddrCtrl20b: process(TX_RESET_I, TX_WORDCLK_I, TX_MGT_READY_I)
      begin   
      if rising_edge(TX_WORDCLK_I) then 
         if TX_RESET_I = '1' or TX_MGT_READY_I = '0' then
            readAddress                         <= 0; 
         else 
            case readAddress is
               when  5                          => readAddress <=  8;          
               when 13                          => readAddress <= 16;   
               when 21                          => readAddress <= 24;
               when 29                          => readAddress <= 32;
               when 37                          => readAddress <= 40;
               when 45                          => readAddress <= 48;
               when 53                          => readAddress <= 56;
               when 61                          => readAddress <=  0;
               when others                      => readAddress <= readAddress + 1;
            end case;           
         end if;
       end if;  
      end process;

   end generate;
   
   -- Word width (40 Bit):
   -----------------------
   
   readAddrCtrl40b_gen: if WORD_WIDTH = 40 generate

      readAddrCtrl40b: process(TX_RESET_I, TX_WORDCLK_I, TX_MGT_READY_I)
      begin  
      if rising_edge(TX_WORDCLK_I) then  
         if TX_RESET_I = '1' or TX_MGT_READY_I = '0' then
            readAddress                         <= 0; 
         else   
            case readAddress is  
               when  2                          => readAddress <=  4;          
               when  6                          => readAddress <=  8;   
               when 10                          => readAddress <= 12;
               when 14                          => readAddress <= 16;
               when 18                          => readAddress <= 20;
               when 22                          => readAddress <= 24;
               when 26                          => readAddress <= 28;
               when 30                          => readAddress <=  0;
               when others                      => readAddress <= readAddress + 1;
            end case;            
         end if;
      end if;
   end process;
      
   end generate;

   --=====================================================================================--         
end behabioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--