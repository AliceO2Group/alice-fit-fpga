--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                       
-- Company:               CERN (PH-ESE-BE)                                                        
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by P. Vichoudis (CERN)) 
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          GBT Bank reset                                   
--                                                                                                 
-- Language:              VHDL'93                                                           
--                                                                                                 
-- Target Device:         Device agnostic                                                         
-- Tool version:                                                                          
--                                                                                                 
-- Revision:              3.0                                                                     
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        17/06/2013   1.0       M. Barros Marin   First .vhd module definition           
--
--                        23/06/2013   3.0       M. Barros Marin   - Cosmetic modifications 
--                                                                 - Added generic to chose whether Tx or Rx is initialized first
--                                                                 - Added independent Tx and Rx resets.                                        
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

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_bank_reset is   
   generic ( 
   
      RX_INIT_FIRST                                : boolean := false;
      INITIAL_DELAY                                : natural := 1   * 40e6; -- Comment: * 1s    @ 40MHz    
      TIME_N                                       : natural := 1   * 40e5; --          * 100ms @ 40MHz
      GAP_DELAY                                    : natural := 3   * 40e6  --          * 3s    @ 40MHz

   );    
   port (       

      --=======-- 
      -- Clock -- 
      --=======-- 

      CLK_I                                        : in  std_logic;

      --===============--  
      -- Resets scheme --  
      --===============--  

      -- General reset: 
      ----------------- 

      GENERAL_RESET_I                              : in  std_logic;   

      -- Manual resets: 
      ----------------- 

      MANUAL_RESET_TX_I                            : in  std_logic;
      MANUAL_RESET_RX_I                            : in  std_logic;

      -- Reset outputs: 
      ----------------- 

      MGT_TX_RESET_O                               : out std_logic;       
      MGT_RX_RESET_O                               : out std_logic;    
      GBT_TX_RESET_O                               : out std_logic;   
      GBT_RX_RESET_O                               : out std_logic;         

      --=========--  
      -- Control --  
      --=========--  

      BUSY_O                                       : out std_logic;   
      DONE_O                                       : out std_logic 

   );
end gbt_bank_reset;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_bank_reset is      

   --================================ Signal Declarations ================================--   
   
   -- TX:
   ------
   
   signal mgtResetTx_from_generalRstFsm         : std_logic; 
   signal gbtResetTx_from_generalRstFsm         : std_logic; 
   
   signal gbtResetTx_from_txRstFsm              : std_logic;
   signal mgtResetTx_from_txRstFsm              : std_logic;
   ---------------------------------------------
   signal manual_reset_tx_r2                    : std_logic;
   signal manual_reset_tx_r                     : std_logic;
   
   -- RX:
   ------
   
   signal mgtResetRx_from_generalRstFsm         : std_logic; 
   signal gbtResetRx_from_generalRstFsm         : std_logic; 
   
   signal gbtResetRx_from_rxRstFsm              : std_logic;
   signal mgtResetRx_from_rxRstFsm              : std_logic;
   ---------------------------------------------
   signal manual_reset_rx_r2                    : std_logic;
   signal manual_reset_rx_r                     : std_logic;   
   
   --=====================================================================================--
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

-- Comment:
--
-- * The following timing diagram shows the reset sequence when the GENERAL_RESET_I is deasserted.
-- 
-- * Note!! In this example TX is initialized first. If RX is initialized first, the sequence is the same but swapping TX signals for RX signals.
--
--
-- TIMING DIAGRAM:
--                                                    .
--                                                    .                                 |                   |                        
--                        +-----------------------------------------------------------..+                   +..---------------------------------------+
--  BUSY_O                |                           .                                 |                   |                                         |                                                                                                                         |  
--                  ...---+                           .                                 |                   |                                         +------------------...                                                                                                                                                                                                                                                   +------
--                                                    .                                 |                   | 
--                                                    .                                 |                   |                                         +------------------...                                                                                                                           +------
--  DONE_O                                            .                                 |                   |                                         |                                                                                                                           |
--                  ...---------------------------------------------------------------..+                   +..---------------------------------------+
--                                                    .                                 |                   |      
--                                                    .                                 |                   |
--                                                    .                                 |                   |
--                                                    .                                 |                   |
--                                                    .                                 |                   | 
--                  ...-------------------------------+                                 |                   |                      
--  GBT_TX_RESET_O                                    |                                 |                   |                      
--                                                    +-------------------------------..+                   +..----------------------------------------------------------...
--                                                    .                                 |                   |
--                                                    .                                 |                   |                      
--                                                    .                                 |                   |
--                                                    .                                 |                   |
--                                                    .                                 |                   |
--  MGT_TX_RESET_O  ...--------------------------------------------------------------+  |                   |
--                                                    .                              |  |                   |
--                                                    .                              +..+                   +..+---------------------------------------------------------... 
--                                                    .                                 |                   |                      
--                                                    .                                 |                   |
--                                                    .                                 |                   |
--                  ...---------------------------------------------------------------..+                   +..+                                         
--  MGT_RX_RESET_O                                    .                                 |                   |  |   
--                                                    .                                 |                   |  +---------------------------------------------------------...
--                                                    .                                 |                   |
--                                                    .                                 |                   |    
--                                                    .                                 |                   |                      
--                  ...---------------------------------------------------------------..+                   +..--------------------------------+
--  GBT_RX_RESET_O                                    .                                 |                   |                                  |  
--                                                    .                                 |                   |                                  +-------------------------...
--                                                    .                                 |     GAP_DELAY     | 
--                                                    .                                 |                   |
--  * TIME *                                          .                                 |  <=====/  /====>  |           
-- -----------------------+---------------------------+------------------------------+..+                   +..+-------------------------------+-------------------------...
--                        time = -(INITIAL_DELAY)     time = 0                       time = n                  time = n + GAP_DELAY            time = 2n + GAP_DELAY        
--
--                        
--========================================================================================================================================================================--   

   --==================================== User Logic =====================================--
   
   generalRstCtrlFsm: process(GENERAL_RESET_I, CLK_I)   
      type general_stateT                          is (s0_idle, s1_firstResetDeassert, s2_secondResetDeassert,
                                                       s3_thirdResetDeassert, s4_fourthResetDeassert, s5_done);
      variable general_state                       : general_stateT;      
      variable general_timer                       : integer range 0 to (INITIAL_DELAY + GAP_DELAY);   -- Comment: This value is not used but ensures a good constraint if GAP_DELAY = 0   
      ---------------------------------------------
      type tx_stateT                               is (s0_idle, s1_assertTxResets, s2_deassertGbtTxReset, s3_deassertMgtTxReset);
      variable tx_state                            : tx_stateT;      
      variable tx_timer                            : integer range 0 to TIME_N;   
      ---------------------------------------------
      type rx_stateT                               is (s0_idle, s1_assertRxResets, s2_deassertMgtRxReset, s3_deassertGbtRxReset);
      variable rx_state                            : rx_stateT;      
      variable rx_timer                            : integer range 0 to TIME_N;   
  begin 
      if GENERAL_RESET_I = '1' then   
         general_state                             := s0_idle;
         general_timer                             := 0;   
         mgtResetTx_from_generalRstFsm             <= '1';         
         gbtResetTx_from_generalRstFsm             <= '1';   
         mgtResetRx_from_generalRstFsm             <= '1';         
         gbtResetRx_from_generalRstFsm             <= '1';   
         BUSY_O                                    <= '0';
         DONE_O                                    <= '0';
         ------------------------------------------
         tx_state                                  := s0_idle;
         tx_timer                                  := 0;   
         gbtResetTx_from_txRstFsm                  <= '0';
         mgtResetTx_from_txRstFsm                  <= '0';
         ------------------------------------------
         rx_state                                  := s0_idle;
         rx_timer                                  := 0;   
         gbtResetRx_from_rxRstFsm                  <= '0';
         mgtResetRx_from_rxRstFsm                  <= '0';
         ------------------------------------------
         manual_reset_tx_r2                        <= '0';
         manual_reset_tx_r                         <= '0';
         manual_reset_rx_r2                        <= '0';
         manual_reset_rx_r                         <= '0';
      elsif rising_edge(CLK_I) then       
         
         --============================================--
         -- General reset - Finite State Machine (FSM) --
         --============================================--
         
         case general_state is  
            when s0_idle =>                                                     
               BUSY_O                              <= '1';                       -- Comment: time = (-initial delay)
               if general_timer = INITIAL_DELAY-1 then                           -- Comment: time = 0   
                  general_state                    := s1_firstResetDeassert;
                  general_timer                    := 0; 
                  if RX_INIT_FIRST = true then
                     mgtResetRx_from_generalRstFsm <= '0';  
                  else
                     gbtResetTx_from_generalRstFsm <= '0';
                  end if;
               else      
                  general_timer                    := general_timer + 1;
               end if;   
            when s1_firstResetDeassert =>         
               if general_timer = TIME_N then                                    -- Comment: time = n   
                  general_state                    := s2_secondResetDeassert;
                  general_timer                    := 0;
                  if RX_INIT_FIRST = true then
                     gbtResetRx_from_generalRstFsm <= '0';   
                  else
                     mgtResetTx_from_generalRstFsm <= '0';
                  end if;                  
               else
                  general_timer                    := general_timer + 1;
               end if;              
            when s2_secondResetDeassert =>                                         
               if general_timer = GAP_DELAY then                                 -- Comment: time = n + GAP_DELAY           
                  general_state                    := s3_thirdResetDeassert;   
                  general_timer                    := 0;                
                  if RX_INIT_FIRST = true then
                     gbtResetTx_from_generalRstFsm <= '0';    
                  else
                     mgtResetRx_from_generalRstFsm <= '0';    
                  end if;
               else        
                  general_timer                    := general_timer + 1;
               end if;                                
            when s3_thirdResetDeassert =>      
               if general_timer = TIME_N then                                    -- Comment: time = 2n + GAP_DELAY               
                  general_state                    := s4_fourthResetDeassert; 
                  general_timer                     := 0;                              
                  if RX_INIT_FIRST = true then
                     mgtResetTx_from_generalRstFsm <= '0';     
                  else
                     gbtResetRx_from_generalRstFsm <= '0';   
                  end if;
               else
                  general_timer                    := general_timer + 1;
               end if;  
            when s4_fourthResetDeassert =>            
                  general_state                    := s5_done; 
                  BUSY_O                           <= '0';
                  DONE_O                           <= '1';
            when s5_done =>         
               null;                                             
         end case;
         
         --==============================================--
         -- Manual TX reset - Finite State Machine (FSM) --
         --==============================================--
         
         -- Comment: TX reset is synchronous with "CLK_I".
         
         case tx_state is
            when s0_idle =>
               if (manual_reset_tx_r2 = '0') and (manual_reset_tx_r = '1') then
                  tx_state                         := s1_assertTxResets;
                  gbtResetTx_from_txRstFsm         <= '1';
                  mgtResetTx_from_txRstFsm         <= '1';
               end if;
            when s1_assertTxResets =>
               if (manual_reset_tx_r2 = '1') and (manual_reset_tx_r = '0') then
                  tx_state                         := s2_deassertGbtTxReset;
               end if;
            when s2_deassertGbtTxReset => 
               if tx_timer = TIME_N then
                  tx_state                         := s3_deassertMgtTxReset;
                  tx_timer                         := 0;
                  gbtResetTx_from_txRstFsm         <= '0';
               else
                  tx_timer                         := tx_timer + 1;
               end if;
            when s3_deassertMgtTxReset => 
               if tx_timer = TIME_N then
                  tx_state                         := s0_idle;
                  tx_timer                         := 0;
                  mgtResetTx_from_txRstFsm         <= '0';
               else
                  tx_timer                         := tx_timer + 1;
               end if;
         end case;
         
         --==============================================--
         -- Manual RX reset - Finite State Machine (FSM) --
         --==============================================--
         
          -- Comment: RX reset is synchronous with "CLK_I".
         
         case rx_state is
            when s0_idle =>
               if (manual_reset_rx_r2 = '0') and (manual_reset_rx_r = '1') then
                  rx_state                         := s1_assertRxResets;
                  mgtResetRx_from_rxRstFsm         <= '1';
                  gbtResetRx_from_rxRstFsm         <= '1';
               end if;
             when s1_assertRxResets =>
               if (manual_reset_rx_r2 = '1') and (manual_reset_rx_r = '0') then
                  rx_state                         := s2_deassertMgtRxReset;
               end if;
            when s2_deassertMgtRxReset => 
               if rx_timer = TIME_N then
                  rx_state                         := s3_deassertGbtRxReset;
                  rx_timer                         := 0;
                  mgtResetRx_from_rxRstFsm         <= '0';
               else
                  rx_timer                         := rx_timer + 1;
               end if;
            when s3_deassertGbtRxReset => 
               if rx_timer = TIME_N then
                  rx_state                         := s0_idle;
                  rx_timer                         := 0;
                  gbtResetRx_from_rxRstFsm         <= '0';
               else
                  rx_timer                         := rx_timer + 1;
               end if;
         end case;
         
         --================--
         -- Edge detectors --
         --================--
         
         manual_reset_tx_r2                        <= manual_reset_tx_r;
         manual_reset_tx_r                         <= MANUAL_RESET_TX_I;
         ------------------------------------------
         manual_reset_rx_r2                        <= manual_reset_rx_r;
         manual_reset_rx_r                         <= MANUAL_RESET_RX_I;
         
      end if;
   end process;      
   
   --=========--
   -- Outputs --
   --=========--
   
   -- TX:
   ------
   
   MGT_TX_RESET_O                                  <= mgtResetTx_from_generalRstFsm or mgtResetTx_from_txRstFsm;
   GBT_TX_RESET_O                                  <= gbtResetTx_from_generalRstFsm or gbtResetTx_from_txRstFsm;

   -- RX:   
   ------   

   MGT_RX_RESET_O                                  <= mgtResetRx_from_generalRstFsm or mgtResetRx_from_rxRstFsm;
   GBT_RX_RESET_O                                  <= gbtResetRx_from_generalRstFsm or gbtResetRx_from_rxRstFsm;
   
   --=====================================================================================--   
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--