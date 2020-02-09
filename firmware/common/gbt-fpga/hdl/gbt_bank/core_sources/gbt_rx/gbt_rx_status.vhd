--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX status                                    
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Device agnostic                                                         
-- Tool version:                                                                          
--                                                                                                   
-- Version:               3.2                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        07/07/2013   3.0       M. Barros Marin   First .vhd entity definition        
--
--                        15/08/2014   3.2       M. Barros Marin   RX_FRAMECLK_READY_I used as reset
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

entity gbt_rx_status is
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
      RX_FRAMECLK_READY_I                       : in  std_logic; 

      
      -- Clock:
      ---------
      
      RX_FRAMECLK_I                             : in  std_logic;                
      
      --========--
      -- Inputs --
      --========--
      
      -- Common:
      
      RX_DESCRAMBLER_READY_I                    : in  std_logic;  
      
      -- Latency-optimized:
      ---------------------
      
      RX_WORDCLK_READY_I                        : in  std_logic; 
      
      --=========--
      -- Outputs --
      --=========--
      
      RX_READY_O                                : out std_logic   
      
   );
end gbt_rx_status;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_status is

   --================================ Signal Declarations ================================--          
   
   --===========--
   -- Registers --
   --===========--
   
   -- Delay register:
   ------------------
   
   signal rxDescramblerReady_r                  : std_logic;
   
   -- Synchronizers:
   -----------------
   
   signal rxWordClkAligned_r2                   : std_logic;
   signal rxWordClkAligned_r                    : std_logic;
   
   --=====================================================================================--       
 
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   
   --==========--
   -- Standard --
   --==========--
   
   statusStd_gen: if RX_OPTIMIZATION = STANDARD generate
   
      statusStd: process(RX_RESET_I, RX_FRAMECLK_READY_I, RX_FRAMECLK_I)   
      begin                                                
         if (RX_RESET_I = '1') or (RX_FRAMECLK_READY_I = '0') then
            rxDescramblerReady_r                <= '0';
            ------------------------------------           
            RX_READY_O                          <= '0';
         elsif rising_edge(RX_FRAMECLK_I) then       
            
            --=========--
            -- Control --
            --=========--
            
            -- Comment: The register "rxDescramblerReady_r" is used to match the "RX_READY_O" flag with the first data valid.

            RX_READY_O                          <= rxDescramblerReady_r;                          
            rxDescramblerReady_r                <= RX_DESCRAMBLER_READY_I;                        

         end if;
      end process;
      
   end generate;
   
   --===================--
   -- Latency-optimized --
   --===================--
   
   statusLatOpt_gen: if RX_OPTIMIZATION = LATENCY_OPTIMIZED generate
   
      statusLatOpt: process(RX_RESET_I, RX_FRAMECLK_READY_I, RX_FRAMECLK_I)   
         variable state                         : rxReadyFsmStateLatOpt_T;
         variable timer                         : integer range 0 to GBT_READY_DLY-1;
      begin                                                
         if (RX_RESET_I = '1') or (RX_FRAMECLK_READY_I = '0') then
            state                               := s0_idle;
            timer                               := 0;
            ------------------------------------
            rxWordClkAligned_r2                 <= '0';
            rxWordClkAligned_r                  <= '0';
            ------------------------------------
            RX_READY_O                          <= '0';
         elsif rising_edge(RX_FRAMECLK_I) then 
            
            --============--
            -- Status FSM --
            --============--

            case state is 
               when s0_idle => 
                  if RX_DESCRAMBLER_READY_I = '1' then 
                     state                      := s1_rxWordClkCheck;                    
                  end if;
               when s1_rxWordClkCheck =>
                  if rxWordClkAligned_r2 = '1' then
                     if timer = GBT_READY_DLY-1 then
                        state                   := s2_gbtRxReadyMonitoring;
                        timer                   := 0;
                     else
                        timer                   := timer + 1;
                     end if;
                  end if;
               when s2_gbtRxReadyMonitoring =>
                  if (RX_DESCRAMBLER_READY_I = '1') and (rxWordClkAligned_r2 = '1') then
                     RX_READY_O                 <= '1';
                  else         
                     state                      := s0_idle;
                     RX_READY_O                 <= '0';              
                  end if;       
            end case;
            
            --===============--
            -- Synchronizers --
            --===============--
            
            rxWordClkAligned_r2                 <= rxWordClkAligned_r;
            rxWordClkAligned_r                  <= RX_WORDCLK_READY_I;           

         end if;
      end process;
      
   end generate;
   
   --=====================================================================================--   
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--