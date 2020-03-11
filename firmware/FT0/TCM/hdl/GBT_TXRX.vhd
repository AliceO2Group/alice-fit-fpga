----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:01:21 12/23/2016 
-- Design Name: 
-- Module Name:    GBT_bank_designe - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

entity GBT_TX_RX is
    Port ( RESET : in  STD_LOGIC;
           MgtRefClk : in  STD_LOGIC;
           MGT_RX_P : in  STD_LOGIC;
           MGT_RX_N : in  STD_LOGIC;
           MGT_TX_P : out  STD_LOGIC;
           MGT_TX_N : out  STD_LOGIC;
           TXDataClk : in  STD_LOGIC;
           TXData : in  STD_LOGIC_VECTOR (79 downto 0);
           TXData_SC : in  STD_LOGIC_VECTOR (3 downto 0);
           IsTXData : in  STD_LOGIC;
           RXDataClk : out  STD_LOGIC;
           RXData : out  STD_LOGIC_VECTOR (79 downto 0);
           RXData_SC : out  STD_LOGIC_VECTOR (3 downto 0);
           IsRXData : out  STD_LOGIC);
end GBT_TX_RX;

architecture Behavioral of GBT_TX_RX is

-- GBT BANK ***************************************
   signal to_gbtBank_1_clks                       : gbtBankClks_i_R;                          
   signal from_gbtBank_1_clks                     : gbtBankClks_o_R;
   -----------------------------------------------          
   signal to_gbtBank_1_gbtTx                      : gbtTx_i_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   signal from_gbtBank_1_gbtTx                    : gbtTx_o_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   -----------------------------------------------          
   signal to_gbtBank_1_mgt                        : mgt_i_R;
   signal from_gbtBank_1_mgt                      : mgt_o_R; 
   -----------------------------------------------          
   signal to_gbtBank_1_gbtRx                      : gbtRx_i_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   signal from_gbtBank_1_gbtRx                    : gbtRx_o_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
   -----------------------------------------------          
   signal mgtTxReset_from_gbtBankRst              : std_logic; 
   signal mgtRxReset_from_gbtBankRst              : std_logic; 
   signal gbtTxReset_from_gbtBankRst              : std_logic;
   signal gbtRxReset_from_gbtBankRst              : std_logic; 
	-----------------------------------------------    
   signal pllLocked_from_rxFrmClkPhAlgnr          : std_logic; 
   signal phaseAlignDone_from_rxFrmClkPhAlgnr     : std_logic;   
   signal rxFrameClkReady_staticMux               : std_logic;   
   signal rxFrameClk_from_rxFrmClkPhAlgnr         : std_logic;
-- ************************************************

begin
-- WIRING =========================================
-- MGT connection
MGT_TX_P                                       <= from_gbtBank_1_mgt.mgtLink(1).tx_p;
MGT_TX_N                                       <= from_gbtBank_1_mgt.mgtLink(1).tx_n;     
to_gbtBank_1_mgt.mgtLink(1).rx_p               <= MGT_RX_P;   
to_gbtBank_1_mgt.mgtLink(1).rx_n               <= MGT_RX_N;

-- DATA
to_gbtBank_1_gbtTx(1).isDataSel                <= IsTXData;
to_gbtBank_1_gbtTx(1).data <= TXData_SC & TXData;
IsRXData            <= from_gbtBank_1_gbtRx(1).isDataFlag;  
RXData                              <= from_gbtBank_1_gbtRx(1).data(79 downto 0);
RXData_SC                              <= from_gbtBank_1_gbtRx(1).data(83 downto 80);

-- MGTRefClk
to_gbtBank_1_clks.mgt_clks.mgtRefClk           <= MgtRefClk; 
--Frame Clock
to_gbtBank_1_clks.tx_frameClk(1)               <= TXDataClk; 
--reference clock    
to_gbtBank_1_clks.mgt_clks.mgtRstCtrlRefClk    <= TXDataClk;
--fabric clock
to_gbtBank_1_clks.mgt_clks.cpllLockDetClk      <= TXDataClk;
to_gbtBank_1_clks.mgt_clks.drpClk              <= TXDataClk;
--RX Data Clk out
RXDataClk <= rxFrameClk_from_rxFrmClkPhAlgnr;
-- Phase aligner
rxFrameClkReady_staticMux <= phaseAlignDone_from_rxFrmClkPhAlgnr when GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION = LATENCY_OPTIMIZED else
                             pllLocked_from_rxFrmClkPhAlgnr;
                                                  
to_gbtBank_1_gbtRx(1).rxFrameClkReady          <= rxFrameClkReady_staticMux;
to_gbtBank_1_clks.rx_frameClk(1)               <= rxFrameClk_from_rxFrmClkPhAlgnr;


-- RESET
to_gbtBank_1_gbtTx(1).reset                    <= gbtTxReset_from_gbtBankRst;   
to_gbtBank_1_mgt.mgtLink(1).tx_reset           <= mgtTxReset_from_gbtBankRst;
to_gbtBank_1_mgt.mgtLink(1).rx_reset           <= mgtRxReset_from_gbtBankRst;   
to_gbtBank_1_gbtRx(1).reset                    <= gbtRxReset_from_gbtBankRst;   

   -- Control assignments:                        
   -----------------------                        
   to_gbtBank_1_mgt.mgtLink(1).loopBack           <= "000"; -- normal operation

   -- Comment: The built-in PRBS generator/checker of the MGT(GTX) transceiver is not used in this example design.
   to_gbtBank_1_mgt.mgtLink(1).prbs_txSel         <= "000";
   to_gbtBank_1_mgt.mgtLink(1).prbs_rxSel         <= "000";
   to_gbtBank_1_mgt.mgtLink(1).prbs_txForceErr    <= '0';
   to_gbtBank_1_mgt.mgtLink(1).prbs_rxCntReset    <= '0'; 
   to_gbtBank_1_mgt.mgtLink(1).conf_diffCtrl      <= "1000";    -- Comment: 807 mVppd
   to_gbtBank_1_mgt.mgtLink(1).conf_postCursor    <= "00000";   -- Comment: 0.00 dB (default)
   to_gbtBank_1_mgt.mgtLink(1).conf_preCursor     <= "00000";   -- Comment: 0.00 dB (default)
   to_gbtBank_1_mgt.mgtLink(1).conf_txPol         <= '0';       -- Comment: Not inverted
   to_gbtBank_1_mgt.mgtLink(1).conf_rxPol         <= '0';       -- Comment: Not inverted           
                                                  
   -- Comment: The DRP port of the MGT(GTX) transceiver is not used in this example design.   
   to_gbtBank_1_mgt.mgtLink(1).drp_addr           <= "000000000";
   to_gbtBank_1_mgt.mgtLink(1).drp_en             <= '0';
   to_gbtBank_1_mgt.mgtLink(1).drp_di             <= x"0000";
   to_gbtBank_1_mgt.mgtLink(1).drp_we             <= '0';

   -- Comment: * The manual RX_WORDCLK phase alignment control of the MGT(GTX) transceivers is not used in this 
   --            reference design (auto RX_WORDCLK phase alignment is used instead).
   --
   --          * Note!! The manual RX_WORDCLK phase alignment control of the MGT(GTX) MUST be synchronous with RX_WORDCLK
   --                   (in this example design this clock is "to_gbtBank_1_clks.mgt_clks.rx_wordClk(1)").
   to_gbtBank_1_mgt.mgtLink(1).rxBitSlip_enable   <= '1'; 
   to_gbtBank_1_mgt.mgtLink(1).rxBitSlip_ctrl     <= '0'; 
   to_gbtBank_1_mgt.mgtLink(1).rxBitSlip_nbr      <= "000000";
   to_gbtBank_1_mgt.mgtLink(1).rxBitSlip_run      <= '0';
   to_gbtBank_1_mgt.mgtLink(1).rxBitSlip_oddRstEn <= '0';   -- Comment: If '1' resets the MGT RX when the the number of bitslips 
--=================================================


-- GBT BANK RESET =================================
   gbtBankRst: entity work.gbt_bank_reset    
      generic map (
         RX_INIT_FIRST                            => false,
         INITIAL_DELAY                            => 1 * 40e6,  -- Comment: * 1s@40MHz  
         TIME_N                                   => 1 * 40e6,  --          * 1s@40MHz  
         GAP_DELAY                                => 1 * 40e6)  --          * 1s@40MHz  
      port map (                                  
         CLK_I                                    => TXDataClk,                                                
         -----------------------------------------  
         GENERAL_RESET_I                          => RESET,                                                                 
         MANUAL_RESET_TX_I                        => '0',
         MANUAL_RESET_RX_I                        => '0',
         -----------------------------------------       
         MGT_TX_RESET_O                           => mgtTxReset_from_gbtBankRst,                              
         MGT_RX_RESET_O                           => mgtRxReset_from_gbtBankRst,                             
         GBT_TX_RESET_O                           => gbtTxReset_from_gbtBankRst,                                      
         GBT_RX_RESET_O                           => gbtRxReset_from_gbtBankRst,                              
         -----------------------------------------        
         BUSY_O                                   => open,                                                                         
         DONE_O                                   => open                                                                          
      );          
--=================================================




-- PH ALIGNER =====================================
   rxFrmClkPhAlgnr: entity work.gbt_rx_frameclk_phalgnr
      port map (
         RESET_I                                  => gbtRxReset_from_gbtBankRst,
         -----------------------------------------        
         RX_WORDCLK_I                             => to_gbtBank_1_clks.mgt_clks.rx_wordClk(1),
         RX_FRAMECLK_O                            => rxFrameClk_from_rxFrmClkPhAlgnr,         
         -----------------------------------------        
         SYNC_ENABLE_I                            => from_gbtBank_1_gbtRx(1).latOptGbtBank_rx and from_gbtBank_1_mgt.mgtLink(1).rxWordClkReady,
         SYNC_I                                   => from_gbtBank_1_gbtRx(1).header_flag,         
         -----------------------------------------  
         PLL_LOCKED_O                             => pllLocked_from_rxFrmClkPhAlgnr,
         DONE_O                                   => phaseAlignDone_from_rxFrmClkPhAlgnr
      );                                          
--=================================================



-- GBT Bank Clks Buffers ===========================

-- RX WORD CLK BUFF
   rxWordClkBufg: bufg
      port map (
         O                                        => to_gbtBank_1_clks.mgt_clks.rx_wordClk(1), 
         I                                        => from_gbtBank_1_clks.mgt_clks.rx_wordClk_noBuff(1) 
      );   
-- TX WORD CLK BUFF 
   txWordClkBufg: bufg
      port map (
         O                                        => to_gbtBank_1_clks.mgt_clks.tx_wordClk(1), 
         I                                        => from_gbtBank_1_clks.mgt_clks.tx_wordClk_noBuff(1)
      ); 
-- =================================================




-- GBT BANK =======================================
-- GBT BANK
   gbtBank_1: entity work.gbt_bank
      generic map (
         GBT_BANK_ID                              => 1)
      port map (                                  
         CLKS_I                                   => to_gbtBank_1_clks,                                  
         CLKS_O                                   => from_gbtBank_1_clks,               
         -----------------------------------------            
         GBT_TX_I                                 => to_gbtBank_1_gbtTx,             
         GBT_TX_O                                 => from_gbtBank_1_gbtTx,         
         -----------------------------------------            
         MGT_I                                    => to_gbtBank_1_mgt,              
         MGT_O                                    => from_gbtBank_1_mgt,              
         -----------------------------------------            
         GBT_RX_I                                 => to_gbtBank_1_gbtRx,              
         GBT_RX_O                                 => from_gbtBank_1_gbtRx         
      );
-- =================================================

end Behavioral;

