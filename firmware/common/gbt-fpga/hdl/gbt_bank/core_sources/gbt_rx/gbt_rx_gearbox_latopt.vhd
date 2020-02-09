--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX gearbox latency-optimized
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
-- Versions history:      DATE         VERSION   AUTHOR                               DESCRIPTION
--    
--                        10/05/2009   0.1       F. Marin (CPPM)                      First .bdf entity definition.           
--                                                                   
--                        08/07/2009   0.2       S. Baron (CERN)                      Translate from .bdf to .vhd.
--
--                        02/11/2010   0.3       S. Muschter (Stockholm University)   Optimization to low latency.
--
--                        04/07/2013   3.0       M. Barros Marin                      - Cosmetic and minor modifications.   
--                                                                                    - Support for 20bit and 40bit words. 
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

entity gbt_rx_gearbox_latopt is
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
      -- Frame & Word --
      --==============--
      
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      RX_FRAME_O                                : out std_logic_vector(119 downto 0)
   );
end gbt_rx_gearbox_latopt;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_gearbox_latopt is

   --==================================== User Logic =====================================--
  
   signal reg2                                  : std_logic_vector (119 downto 0);

   --=====================================================================================--     
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  

   --================================ Signal Declarations ================================--

   --=====================--
   -- Word width (20 Bit) --
   --=====================--
   
   gbLatOpt20b_gen: if WORD_WIDTH = 20 generate

      gbLatOpt20b: process(RX_RESET_I, RX_WORDCLK_I)
         variable reg1                          : std_logic_vector (99 downto 0);
      begin
         if RX_RESET_I = '1' then
            reg1                                := (others => '0');
            reg2                                <= (others => '0');
         elsif rising_edge(RX_WORDCLK_I) then
            case RX_WRITE_ADDRESS_I (2 downto 0) is
               when "000"                       => reg1 (19 downto  0) := RX_WORD_I;
               when "001"                       => reg1 (39 downto 20) := RX_WORD_I;
               when "010"                       => reg1 (59 downto 40) := RX_WORD_I;
               when "011"                       => reg1 (79 downto 60) := RX_WORD_I;
               when "100"                       => reg1 (99 downto 80) := RX_WORD_I; 
               when "101"                       => reg2                <= RX_WORD_I & reg1;            
               when others                      => null;
            end case;
         end if;
      end process;     
   
   end generate;   

   --=====================--
   -- Word width (40 Bit) --
   --=====================--
   
   gbLatOpt40b_gen: if WORD_WIDTH = 40 generate

      gbLatOpt40b: process(RX_RESET_I, RX_WORDCLK_I)
         variable reg1                          : std_logic_vector (79 downto 0);
      begin
         if RX_RESET_I = '1' then
            reg1                                := (others => '0');
            reg2                                <= (others => '0');
         elsif rising_edge(RX_WORDCLK_I) then
            case RX_WRITE_ADDRESS_I(1 downto 0) is
              when "00"                         => reg1 (39 downto  0)  := RX_WORD_I;
              when "01"                         => reg1 (79 downto 40)  := RX_WORD_I;
              when "10"                         => reg2                 <= RX_WORD_I & reg1;        
              when others                       => null;
            end case;
         end if;
      end process; 
   
   end generate;
   
   --==============--
   -- Common logic --
   --==============--
   
   -- Frame inverter:
   ------------------
   
   frameInverter: for i in 119 downto 0 generate
      RX_FRAME_O(i)                             <= reg2(119-i);
   end generate;
   
   -- Ready flag:
   --------------
   
   gbtRdyCtrl: process(RX_RESET_I, RX_FRAMECLK_I)
   begin
      if RX_RESET_I = '1' then
         READY_O                                <= '0';
      elsif rising_edge(RX_FRAMECLK_I) then     
         READY_O                                <= RX_HEADER_LOCKED_I;      
      end if;
   end process;   
   
   --=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--