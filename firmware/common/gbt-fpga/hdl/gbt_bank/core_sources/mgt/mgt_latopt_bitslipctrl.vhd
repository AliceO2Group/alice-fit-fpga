--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Multi Gigabit Transceivers latency-optimized bitslip control 
--                                                                                                 
-- Language:              VHDL'93                                                                 
--                                                                                                   
-- Target Device:         Vendor agnostic                                                         
-- Tool version:                                                                    
--                                                                                                   
-- Revision:              3.5                                                                      
--
-- Description:           
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        26/10/2011   3.0       M. Barros Marin   First .vhd module definition
--
--                        10/10/2014   3.5       M. Barros Marin   Added reset when odd bitslip
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

entity mgt_latopt_bitslipctrl is
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
      
      NUMBITSLIPS_I                             : in  std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      ENABLE_I                                  : in  std_logic;
      MGT_RX_ODD_RESET_EN_I                     : in  std_logic;
      BITSLIP_O                                 : out std_logic;
      RESET_MGT_RX_O                            : out std_logic;
      RESET_MGT_RX_ITERATIONS_O                 : out std_logic_vector(7 downto 0);
      DONE_O                                    : out std_logic
      
   );
end mgt_latopt_bitslipctrl;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of mgt_latopt_bitslipctrl is

    --/*/--
   -- attribute mark_debug : string;
   -- attribute mark_debug of NUMBITSLIPS_I : signal is "true";  
   -- attribute mark_debug of ENABLE_I : signal is "true";  
   -- attribute mark_debug of BITSLIP_O : signal is "true";  
   -- attribute mark_debug of RESET_MGT_RX_O : signal is "true";  
   -- attribute mark_debug of RESET_MGT_RX_ITERATIONS_O : signal is "true";   
   -- attribute mark_debug of DONE_O : signal is "true";    
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --============================ User Logic =============================--
      
   main_process: process(RX_RESET_I, RX_WORDCLK_I)
      variable state                            : rxBitSlipCtrlStateLatOpt_T;
      variable bitslips                         : unsigned(GBTRX_BITSLIP_NBR_MSB downto 0);
      variable timer                            : integer range 0 to GBTRX_BITSLIP_MGT_RX_RESET_DELAY-1;
      variable resetIterations                  : unsigned(7 downto 0);
   begin       
      if RX_RESET_I = '1' then      
         state                                  := e0_idle;
         bitslips                               := (others => '0');
         timer                                  := 0;
         resetIterations                        := (others => '0');
         RESET_MGT_RX_ITERATIONS_O              <= (others => '0');
         DONE_O                                 <= '0';
         BITSLIP_O                              <= '0';
         RESET_MGT_RX_O                         <= '0';
      elsif rising_edge(RX_WORDCLK_I) then    
         -- Finite State Machine(FSM):    
         case state is     
            when e0_idle =>      
               if ENABLE_I = '1' then     
                  DONE_O                        <= '0';
                  state                         := e1_evenOrOdd;
                  bitslips                      := unsigned(NUMBITSLIPS_I);                  
               end if;     
            when e1_evenOrOdd =>      
               if (MGT_RX_ODD_RESET_EN_I = '1') and ((bitslips mod 2) /= 0) then                                    
                  state                         := e2_gtxRxReset;
               else
                  state                         := e3_bitslipOrFinish;
               end if;
            when e2_gtxRxReset =>
                  RESET_MGT_RX_O                <= '1';
                  if timer = GBTRX_BITSLIP_MGT_RX_RESET_DELAY-1 then
                     RESET_MGT_RX_O             <= '0';
                     state                      := e0_idle;
                     resetIterations            := resetIterations + 1;
                     timer                      := 0;                     
                  else
                     timer                      := timer + 1;
                  end if;
            when e3_bitslipOrFinish =>                   
               if bitslips = 0 then    
                  DONE_O                        <= '1';
                  if ENABLE_I = '0' then                          
                     state                      := e0_idle;
                  end if;        
               else     
                  state                         := e4_doBitslip;
                  bitslips                      := bitslips - 1;
               end if;                    
            when e4_doBitslip =>                   
               state                            := e5_waitNcycles;
               BITSLIP_O                        <= '1';            
            when e5_waitNcycles =>    
               BITSLIP_O                        <= '0';
               if timer = GBTRX_BITSLIP_MIN_DLY - 1 then
                  state                         := e3_bitslipOrFinish;
                  timer                         := 0;
               else     
                  timer                         := timer + 1;
               end if;
         end case;
         RESET_MGT_RX_ITERATIONS_O              <= std_logic_vector(resetIterations);
      end if;
   end process;
   
   --=====================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--