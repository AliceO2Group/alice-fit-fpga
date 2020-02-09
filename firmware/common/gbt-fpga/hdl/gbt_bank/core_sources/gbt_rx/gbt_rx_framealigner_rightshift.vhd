--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)                            
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX frame aligner right shifter
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

entity gbt_rx_framealigner_rightshift is
   port(   
      
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
      
      RX_MGT_RDY_I                              : in  std_logic;
      READY_O                                   : out std_logic;
      RX_BITSLIP_COUNT_I                        : in  std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);               
      
      --======--
      -- Word --
      --======--
      
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      SHIFTED_RX_WORD_O                         : out std_logic_vector(WORD_WIDTH-1 downto 0)
      
   );   
end gbt_rx_framealigner_rightshift;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_framealigner_rightshift is
   
   --================================ Signal Declarations ================================--   
   
   signal rxMgtRdy_r                            : std_logic;
   signal previousWord                          : std_logic_vector(WORD_WIDTH-1 downto 0);

   --=====================================================================================--      
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--    
   
   --==================================== User Logic =====================================--      
   
   --=====================--
   -- Word width (20 Bit) --
   --=====================--
   
   rightShifter20b_gen: if WORD_WIDTH = 20 generate   
   
      rightShifter20b: process(RX_RESET_I, RX_WORDCLK_I)   
         variable rxBitSlipCount                : integer range 0 to WORD_WIDTH;
      begin      
         if RX_RESET_I = '1' then
            rxBitSlipCount                      := 0;
            rxMgtRdy_r                          <= '0';
            READY_O                             <= '0';
            previousWord                        <= (others => '0');
            SHIFTED_RX_WORD_O                   <= (others => '0');
        elsif rising_edge(RX_WORDCLK_I) then
            rxBitSlipCount                      := to_integer(unsigned(RX_BITSLIP_COUNT_I));
            READY_O                             <= rxMgtRdy_r;
            rxMgtRdy_r                          <= RX_MGT_RDY_I;
            previousWord                        <= RX_WORD_I;
            case rxBitSlipCount is
               when  0 => 
                  SHIFTED_RX_WORD_O             <= previousWord;
               when  1 =>       
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 0 downto 0) & previousWord(19 downto  1);
               when  2 =>         
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 1 downto 0) & previousWord(19 downto  2);
               when  3 =>          
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 2 downto 0) & previousWord(19 downto  3);
               when  4 =>          
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 3 downto 0) & previousWord(19 downto  4);
               when  5 =>          
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 4 downto 0) & previousWord(19 downto  5);
               when  6 =>          
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 5 downto 0) & previousWord(19 downto  6);
               when  7 =>         
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 6 downto 0) & previousWord(19 downto  7);
               when  8 =>          
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 7 downto 0) & previousWord(19 downto  8);
               when  9 =>          
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 8 downto 0) & previousWord(19 downto  9);
               when 10 =>             
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 9 downto 0) & previousWord(19 downto 10);
               when 11 =>            
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(10 downto 0) & previousWord(19 downto 11);
               when 12 =>            
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(11 downto 0) & previousWord(19 downto 12);
               when 13 =>             
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(12 downto 0) & previousWord(19 downto 13);
               when 14 =>            
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(13 downto 0) & previousWord(19 downto 14);
               when 15 =>             
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(14 downto 0) & previousWord(19 downto 15);
               when 16 =>            
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(15 downto 0) & previousWord(19 downto 16);
               when 17 =>             
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(16 downto 0) & previousWord(19 downto 17);
               when 18 =>            
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(17 downto 0) & previousWord(19 downto 18);
               when others  =>             
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(18 downto 0) & previousWord(19 downto 19);               
            end case;
         end if;
      end process;

   end generate;
   
   --=====================--
   -- Word width (40 Bit) --
   --=====================--
   
   rightShifter40b_gen: if WORD_WIDTH = 40 generate     
   
      rightShifter40b: process(RX_RESET_I, RX_WORDCLK_I)      
         variable rxBitSlipCount                : integer range 0 to WORD_WIDTH;
      begin         
         if RX_RESET_I = '1' then
            rxBitSlipCount                      := 0;
            rxMgtRdy_r                          <= '0';
            READY_O                             <= '0';
            previousWord                        <= (others => '0');
            SHIFTED_RX_WORD_O                   <= (others => '0');            
         elsif rising_edge(RX_WORDCLK_I) then
            rxBitSlipCount                      := to_integer(unsigned(RX_BITSLIP_COUNT_I));
            READY_O                             <= rxMgtRdy_r;
            rxMgtRdy_r                          <= RX_MGT_RDY_I;
            previousWord                        <= RX_WORD_I;           
            case rxBitSlipCount is
               when  0 => 
                  SHIFTED_RX_WORD_O             <= previousWord;
               when  1 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 0 downto 0) & previousWord(39 downto  1);
               when  2 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 1 downto 0) & previousWord(39 downto  2);
               when  3 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 2 downto 0) & previousWord(39 downto  3);
               when  4 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 3 downto 0) & previousWord(39 downto  4);
               when  5 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 4 downto 0) & previousWord(39 downto  5);
               when  6 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 5 downto 0) & previousWord(39 downto  6);
               when  7 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 6 downto 0) & previousWord(39 downto  7);
               when  8 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 7 downto 0) & previousWord(39 downto  8);
               when  9 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 8 downto 0) & previousWord(39 downto  9);
               when 10 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I( 9 downto 0) & previousWord(39 downto 10);
               when 11 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(10 downto 0) & previousWord(39 downto 11);
               when 12 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(11 downto 0) & previousWord(39 downto 12);
               when 13 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(12 downto 0) & previousWord(39 downto 13);
               when 14 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(13 downto 0) & previousWord(39 downto 14);
               when 15 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(14 downto 0) & previousWord(39 downto 15);
               when 16 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(15 downto 0) & previousWord(39 downto 16);
               when 17 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(16 downto 0) & previousWord(39 downto 17);
               when 18 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(17 downto 0) & previousWord(39 downto 18);
               when 19 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(18 downto 0) & previousWord(39 downto 19);
               when 20 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(19 downto 0) & previousWord(39 downto 20);
               when 21 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(20 downto 0) & previousWord(39 downto 21);
               when 22 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(21 downto 0) & previousWord(39 downto 22);
               when 23 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(22 downto 0) & previousWord(39 downto 23);
               when 24 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(23 downto 0) & previousWord(39 downto 24);
               when 25 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(24 downto 0) & previousWord(39 downto 25);
               when 26 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(25 downto 0) & previousWord(39 downto 26);
               when 27 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(26 downto 0) & previousWord(39 downto 27);
               when 28 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(27 downto 0) & previousWord(39 downto 28);
               when 29 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(28 downto 0) & previousWord(39 downto 29);
               when 30 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(29 downto 0) & previousWord(39 downto 30);
               when 31 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(30 downto 0) & previousWord(39 downto 31);
               when 32 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(31 downto 0) & previousWord(39 downto 32);
               when 33 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(32 downto 0) & previousWord(39 downto 33);
               when 34 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(33 downto 0) & previousWord(39 downto 34);
               when 35 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(34 downto 0) & previousWord(39 downto 35);
               when 36 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(35 downto 0) & previousWord(39 downto 36);
               when 37 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(36 downto 0) & previousWord(39 downto 37);
               when 38 =>           
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(37 downto 0) & previousWord(39 downto 38);
               when others =>             
                  SHIFTED_RX_WORD_O             <= RX_WORD_I(38 downto 0) & previousWord(39);
            end case;
         end if;
      end process; 

   end generate;
   
   --=====================================================================================--     
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--