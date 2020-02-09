--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT TX scrambler                                        
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
-- Versions history:      DATE         VERSION   AUTHOR                             DESCRIPTION
--                
--                        10/05/2009   0.1       F. Marin (CPPM)                    First .bdf entity definition.           
--                
--                        07/07/2009   0.2       S. Baron (CERN)                    Translate from .bdf to .vhd.
--                
--                        30/07/2009   0.3       S. Baron (CERN)                    Add a generic parameter to allow having different initialisation.
--                                                                                  constants in case of multiple instantiations of 'scrambling'.
--                                                                                  This modification is back-compatible with the previous scrambling entity.
--                
--                        02/10/2010   0.4       S. Muschter (Stockholm University) Remove the event statement to save latency and logic.
--
--                        13/06/2013   3.0       M.Barros Marin                     - Cosmetic and minor modifications.
--                                                                                  - Add Wide-Bus scrambling.
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
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_tx_scrambler is
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
      
      TX_RESET_I                                : in  std_logic;
      
      -- Clock:
      ---------
      
      TX_FRAMECLK_I                             : in  std_logic;
      
      --=========--                                
      -- Control --                                
      --=========-- 
      
      -- TX is data selector:
      -----------------------  
      
      TX_ISDATA_SEL_I                           : in  std_logic;
      
      -- Frame header:
      ----------------
      
      TX_HEADER_O                               : out std_logic_vector( 3 downto 0);
      
      --==============--           
      -- Data & Frame --           
      --==============--              
      
      -- Common:
      ----------
      
      TX_DATA_I                                 : in  std_logic_vector(83 downto 0);
      TX_COMMON_FRAME_O                         : out std_logic_vector(83 downto 0);
      
      -- Wide-Bus:
      ------------
      
      TX_EXTRA_DATA_WIDEBUS_I                   : in  std_logic_vector(31 downto 0);
      TX_EXTRA_FRAME_WIDEBUS_O                  : out std_logic_vector(31 downto 0)
      
   );
end gbt_tx_scrambler;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_tx_scrambler is   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--

   --==============--
   -- Frame header --
   --==============--
   
   headerSel: process(TX_RESET_I, TX_FRAMECLK_I)
   begin
      if TX_RESET_I = '1' then
         TX_HEADER_O                            <= (others => '0');
      elsif rising_edge(TX_FRAMECLK_I) then      
         if TX_ISDATA_SEL_I = '1' then
            TX_HEADER_O                         <= DATA_HEADER_PATTERN;
         else           
            TX_HEADER_O                         <= IDLE_HEADER_PATTERN;      
         end if; 
      end if;
   end process;
   
   --============--
   -- Scramblers --
   --============--
   
   -- 84 bit scrambler (GBT-Frame & Wide-Bus):
   -------------------------------------------
   
   gbtFrameOrWideBus_gen: if    (TX_ENCODING = GBT_FRAME)
                             or (TX_ENCODING = WIDE_BUS) generate 
   
      gbtTxScrambler84bit_gen: for i in 0 to 3 generate
        
         -- Comment: [83:63] & [62:42] & [41:21] & [20:0]
        
         gbtTxScrambler21bit: entity work.gbt_tx_scrambler_21bit
            port map(
               TX_RESET_I                       => TX_RESET_I,
               RESET_PATTERN_I                  => SCRAMBLER_21BIT_RESET_PATTERNS(i),
               ---------------------------------
               TX_FRAMECLK_I                    => TX_FRAMECLK_I,
               ---------------------------------
               TX_DATA_I                        => TX_DATA_I(((21*i)+20) downto (21*i)),
               TX_COMMON_FRAME_O                => TX_COMMON_FRAME_O(((21*i)+20) downto (21*i))
            );
      
      end generate;
      
   end generate;
   
   -- 32 bit scrambler (Wide-Bus):
   ------------------------------
   
   wideBus_gen: if TX_ENCODING = WIDE_BUS generate
   
      gbtTxScrambler32bit_gen: for i in 0 to 1 generate
         
         -- Comment: [31:16] & [15:0]
        
         gbtTxScrambler16bit: entity work.gbt_tx_scrambler_16bit
            port map(
               TX_RESET_I                       => TX_RESET_I,
               RESET_PATTERN_I                  => SCRAMBLER_16BIT_RESET_PATTERNS(i),
               ---------------------------------
               TX_FRAMECLK_I                    => TX_FRAMECLK_I,
               ---------------------------------
               TX_EXTRA_DATA_WIDEBUS_I          => TX_EXTRA_DATA_WIDEBUS_I(((16*i)+15) downto (16*i)),
               TX_EXTRA_FRAME_WIDEBUS_O         => TX_EXTRA_FRAME_WIDEBUS_O(((16*i)+15) downto (16*i))
            );

      end generate;
   
   end generate;
   
   wideBus_no_gen: if TX_ENCODING /= WIDE_BUS generate
   
      TX_EXTRA_FRAME_WIDEBUS_O                  <= (others => '0');
   
   end generate;
    
   
   --=====================================================================================--
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--