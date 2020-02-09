--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)                            
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX frame aligner write address
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
--                                                                 - Use "case" instead of "if/else".
--                                                                 - Generates pattern search and gearbox addresses.  
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

entity gbt_rx_framealigner_wraddr is
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
      
      --===============================--
      -- Patter search address control --
      --===============================--
      
      RX_BITSLIP_OVERFLOW_CMD_I                 : in  std_logic; 
      RX_PS_WRITE_ADDRESS_O                     : out std_logic_vector(WORD_ADDR_MSB downto 0);      
      
      --============================--
      -- RX gearbox address control --
      --============================--
      
      RX_GB_WRITE_ADDRESS_RST_I                 : in  std_logic;
      RX_GB_WRITE_ADDRESS_O                     : out std_logic_vector(WORD_ADDR_MSB downto 0)
      
   );  
end gbt_rx_framealigner_wraddr;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

architecture behavioral of gbt_rx_framealigner_wraddr is
   
   --================================ Signal Declarations ================================--
   
   signal psWriteAddress                        : integer range 0 to 63;
   signal gbWriteAddress                        : integer range 0 to 63;
   
   --=====================================================================================--
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================-- 

   --==================================== User Logic =====================================--

   --==============--
   -- Common logic --
   --==============--
   
   RX_PS_WRITE_ADDRESS_O                        <= std_logic_vector(to_unsigned(psWriteAddress,(WORD_ADDR_MSB+1)));
   RX_GB_WRITE_ADDRESS_O                        <= std_logic_vector(to_unsigned(gbWriteAddress,(WORD_ADDR_MSB+1)));   
   
   --=====================--
   -- Word width (20 Bit) --
   --=====================--
   
   writeAddr20b_gen: if WORD_WIDTH = 20 generate
      
      process (RX_RESET_I, RX_WORDCLK_I)
      begin    
         if RX_RESET_I = '1' then
            psWriteAddress                      <= 0; 
            gbWriteAddress                      <= 2;   -- Comment: Note!! Do not modify (default value 2).
         elsif rising_edge(RX_WORDCLK_I) then
            
            -- Patter Search write address:
            -------------------------------
            
            if RX_BITSLIP_OVERFLOW_CMD_I = '0' then
               case psWriteAddress is
                  when  5                       => psWriteAddress <=  8;          
                  when 13                       => psWriteAddress <= 16;   
                  when 21                       => psWriteAddress <= 24;
                  when 29                       => psWriteAddress <= 32;
                  when 37                       => psWriteAddress <= 40;
                  when 45                       => psWriteAddress <= 48;
                  when 53                       => psWriteAddress <= 56;
                  when 61                       => psWriteAddress <=  0;
                  when others                   => psWriteAddress <= psWriteAddress+1;
               end case;
            else                             
               null;  -- Comment: psWriteAddress is not incremented when right shifting of 20b
            end if;
            
            -- Gearbox write address:
            -------------------------
            
            if RX_GB_WRITE_ADDRESS_RST_I = '1' then
               gbWriteAddress                   <= 2;   -- Comment: gbWriteAddress is reset to write the word with the header on the 
            else                                        --          position 0 of the gearbox (gbWriteAddress = 2 is due to two clk cycles
               case gbWriteAddress is                   --          of reset delay).
                  when 5                        => gbWriteAddress <=  8;          
                  when 13                       => gbWriteAddress <= 16;   
                  when 21                       => gbWriteAddress <= 24;
                  when 29                       => gbWriteAddress <= 32;
                  when 37                       => gbWriteAddress <= 40;
                  when 45                       => gbWriteAddress <= 48;
                  when 53                       => gbWriteAddress <= 56;
                  when 61                       => gbWriteAddress <=  0;
                  when others                   => gbWriteAddress <= gbWriteAddress + 1;
               end case;        
            end if;
            
         end if;
      end process;

   end generate;

   --=====================--
   -- Word width (40 Bit) --
   --=====================--
   
   writeAddr40b_gen: if WORD_WIDTH = 40 generate
   
      process (RX_RESET_I, RX_WORDCLK_I)
      begin    
         if RX_RESET_I = '1' then
            psWriteAddress                      <= 0; 
            gbWriteAddress                      <= 2;
         elsif rising_edge(RX_WORDCLK_I) then
            
            -- Patter Search write address:
            -------------------------------
            
            if RX_BITSLIP_OVERFLOW_CMD_I = '0' then
               case psWriteAddress is
                  when  2                       => psWriteAddress <=  4;          
                  when  6                       => psWriteAddress <=  8;   
                  when 10                       => psWriteAddress <= 12;
                  when 14                       => psWriteAddress <= 16;
                  when 18                       => psWriteAddress <= 20;
                  when 22                       => psWriteAddress <= 24;
                  when 26                       => psWriteAddress <= 28;
                  when 30                       => psWriteAddress <=  0;
                  when others                   => psWriteAddress <= psWriteAddress+1;
               end case;
            else                             
               null;  -- Comment: psWriteAddress is not incremented when right shifting of 40b
            end if;
            
            -- Gearbox write address:
            -------------------------
            
            if RX_GB_WRITE_ADDRESS_RST_I = '1' then
               gbWriteAddress                   <= 2;   -- Comment: gbWriteAddress is reset to write the word with the header on the  
            else                                        --          position 0 of the gearbox (gbWriteAddress = 2 is due to two clk cycles
               case gbWriteAddress is                   --          of reset delay).
                  when  2                       => gbWriteAddress <=  4;          
                  when  6                       => gbWriteAddress <=  8;   
                  when 10                       => gbWriteAddress <= 12;
                  when 14                       => gbWriteAddress <= 16;
                  when 18                       => gbWriteAddress <= 20;
                  when 22                       => gbWriteAddress <= 24;
                  when 26                       => gbWriteAddress <= 28;
                  when 30                       => gbWriteAddress <=  0;
                  when others                   => gbWriteAddress <= gbWriteAddress + 1;
               end case;
            end if;           
            
         end if;
      end process;   
   
   end generate; 

   --=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--