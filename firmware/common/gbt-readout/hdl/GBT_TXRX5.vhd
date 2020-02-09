--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Kintex 7 & Virtex 7 - GBT Bank example design                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Xilinx Kintex 7 & Virtex 7                                                         
-- Tool version:          ISE 14.5                                                               
--                                                                                                   
-- Version:               3.2                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        28/10/2013   3.0       M. Barros Marin   First .vhd module definition           
--
--                        14/08/2014   3.2       M. Barros Marin   Minor modifications
--
-- Additional Comments:   Note!! Only ONE GBT Bank with ONE link can be used in this example design.   
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

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;
use work.fit_gbt_common_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--
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
           IsRXData : out  STD_LOGIC;
           RX_ready : out  STD_LOGIC;
           RX_errors: out  STD_LOGIC;
           GBT_Status_O : out Type_GBT_status
           );
end GBT_TX_RX;




--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of GBT_TX_RX is  
   
   attribute keep : string;	

   
   --================================ Signal Declarations ================================--   
   -- GBT Bank 1:
   --------------
   
   
   signal to_gbtBank_clks                                 : gbtBankClks_i_R;                          
   signal from_gbtBank_clks                               : gbtBankClks_o_R;
   --------------------------------------------------------        
   signal to_gbtBank_gbtTx                                : gbtTx_i_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   signal from_gbtBank_gbtTx                              : gbtTx_o_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   --------------------------------------------------------        
   signal to_gbtBank_mgt                                  : mgt_i_R;
   signal from_gbtBank_mgt                                : mgt_o_R; 
   attribute keep of from_gbtBank_mgt : signal is "true";

   --------------------------------------------------------        
   signal to_gbtBank_gbtRx                                : gbtRx_i_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   signal from_gbtBank_gbtRx                              : gbtRx_o_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
   attribute keep of from_gbtBank_gbtRx : signal is "true";
     
  
	-- Resets:
	-----------
	signal mgtTxReset_from_gbtBank_gbtBankRst				  : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
	signal mgtRxReset_from_gbtBank_gbtBankRst				  : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
	signal gbtTxReset_from_gbtBank_gbtBankRst				  : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
	signal gbtRxReset_from_gbtBank_gbtBankRst				  : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
	signal reset_from_genRst									  : std_logic;
			
-- RX frameclk aligner:
        -----------------------
    signal phaseAlignDone_from_gbtBank_rxFrmClkPhAlgnr        : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
    signal pllLocked_from_gbtBank_rxFrmClkPhAlgnr            : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
    signal gbtBank_rxFrameClkReady_staticMux                    : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
    signal rxFrameClk_from_gbtBank_rxFrmClkPhAlgnr            : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
        
    signal latOptGbtBank_rx                                            : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
    signal rxWordClkReady                                            : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
    signal mgt_cpllLock                                                : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
    signal mgt_outclkfabric                                                : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
    signal header_flag                                                : std_logic_vector(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--

      --##############################################################################--
    --##################################################################################--
   --##################################              #####################################--
   --##################################  GBT Bank    #####################################--
   --##################################              #####################################--
    --##################################################################################--
      --##############################################################################--  

	--============--
	-- Clocks     --
	--============--	          	        
        
        gbtBank_rxFrmClkPhAlgnr: entity work.gbt_rx_frameclk_phalgnr
            generic map(
                TX_OPTIMIZATION                               => GBT_BANKS_USER_SETUP(1).TX_OPTIMIZATION,
                RX_OPTIMIZATION                               => GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION,
                
                WORDCLK_FREQ                                  => 120,
                
                SHIFT_CNTER                                   => 280, -- ((8*VCO_FREQ)/wordclk_freq) for Altera
                REF_MATCHING                                  => (4 ,6)
            )
            port map (            
            
                RESET_I                                   => gbtRxReset_from_gbtBank_gbtBankRst(1),

                RX_WORDCLK_I                              => from_gbtBank_clks.mgt_clks.rx_wordClk(1),
                FRAMECLK_I                                => TXDataClk,         
                RX_FRAMECLK_O                             => rxFrameClk_from_gbtBank_rxFrmClkPhAlgnr(1), 
                      
                SYNC_I                                    => header_flag(1),
                
                PLL_LOCKED_O                              => pllLocked_from_gbtBank_rxFrmClkPhAlgnr(1),
                DONE_O                                    => phaseAlignDone_from_gbtBank_rxFrmClkPhAlgnr(1)
            );      
    
        latOptGbtBank_rx(1)                       <= from_gbtBank_gbtRx(1).latOptGbtBank_rx;
        rxWordClkReady(1)                         <= from_gbtBank_mgt.mgtLink(1).rxWordClkReady;
        header_flag(1)                            <= from_gbtBank_gbtRx(1).header_flag;
        mgt_cpllLock(1) 						  <= from_gbtBank_mgt.mgtLink(1).cpllLock;
		
        RXDataClk                          <= rxFrameClk_from_gbtBank_rxFrmClkPhAlgnr(1);
        mgt_outclkfabric(1)						<= from_gbtBank_clks.mgt_clks.tx_outclkfabric(1);

        to_gbtBank_clks.tx_frameClk(1)            <= TXDataClk;
        to_gbtBank_clks.rx_frameClk(1)            <= rxFrameClk_from_gbtBank_rxFrmClkPhAlgnr(1);
        
        
        gbtBank_rxFrameClkReady_staticMux(1)   <= phaseAlignDone_from_gbtBank_rxFrmClkPhAlgnr(1) when GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION = LATENCY_OPTIMIZED else
                                                  pllLocked_from_gbtBank_rxFrmClkPhAlgnr(1);
                                              
        

	
	
    to_gbtBank_clks.mgt_clks.mgtRefClk             <= MgtRefClk; -- 200MHz
    to_gbtBank_clks.mgt_clks.mgtRstCtrlRefClk      <= TXDataClk;
    to_gbtBank_clks.mgt_clks.cpllLockDetClk        <= TXDataClk; 
    to_gbtBank_clks.mgt_clks.drpClk                <= TXDataClk;
  
    --============--
    -- Resets     --
    --============--
    -- General reset:
   -----------------
        
      
 gbtBank_gbtBankRst: entity work.gbt_bank_reset    
            generic map (
                RX_INIT_FIRST                                     => false,
                INITIAL_DELAY                                     => 1 * 40e6,   -- Comment: * 1s  
                TIME_N                                            => 1 * 40e6,   --          * 1s
                GAP_DELAY                                         => 1 * 40e6)   --          * 1s
            port map (     
                CLK_I                                             => TXDataClk,                                               
                --------------------------------------------------
                GENERAL_RESET_I                                   => RESET,                                                                 
                MANUAL_RESET_TX_I                                 => '0',
                MANUAL_RESET_RX_I                                 => '0',
                --------------------------------------------------         
                MGT_TX_RESET_O                                    => mgtTxReset_from_gbtBank_gbtBankRst(1),                              
                MGT_RX_RESET_O                                    => mgtRxReset_from_gbtBank_gbtBankRst(1),                             
                GBT_TX_RESET_O                                    => gbtTxReset_from_gbtBank_gbtBankRst(1),                                      
                GBT_RX_RESET_O                                    => gbtRxReset_from_gbtBank_gbtBankRst(1),                              
                --------------------------------------------------          
                BUSY_O                                            => open,                                                                         
                DONE_O                                            => open                                                                          
            ); 
            
      
    --============--
    -- GBT Tx     --
    --============--
        to_gbtBank_gbtTx(1).reset                 <= gbtTxReset_from_gbtBank_gbtBankRst(1);
        to_gbtBank_gbtTx(1).isDataSel             <= IsTXData;
        to_gbtBank_gbtTx(1).data                  <= TXData_SC & TXData;
        to_gbtBank_gbtTx(1).extraData_wideBus     <= x"00000000";
	

                
    --============--
    -- GBT Rx     --
    --============--
    
        to_gbtBank_gbtRx(1).reset                 <= gbtRxReset_from_gbtBank_gbtBankRst(1);  
        to_gbtBank_gbtRx(1).rxFrameClkReady       <= gbtBank_rxFrameClkReady_staticMux(1);
        RX_ready                  <= from_gbtBank_gbtRx(1).ready;
        
        RXData                     <= from_gbtBank_gbtRx(1).data(79 downto 0);
        RXData_SC                     <= from_gbtBank_gbtRx(1).data(83 downto 80);
       
        IsRXData                <= from_gbtBank_gbtRx(1).isDataFlag;
        RX_errors                <= from_gbtBank_gbtRx(1).rxErrorDetected;
        
 
        
    --=============--
    -- Transceiver --
    --=============--
    
            
    
        to_gbtBank_mgt.mgtLink(1).drp_addr           <= "000000000";
        to_gbtBank_mgt.mgtLink(1).drp_en             <= '0';
        to_gbtBank_mgt.mgtLink(1).drp_di             <= x"0000";
        to_gbtBank_mgt.mgtLink(1).drp_we             <= '0';
       
        to_gbtBank_mgt.mgtLink(1).prbs_txSel         <= "000";
        to_gbtBank_mgt.mgtLink(1).prbs_rxSel         <= "000";
        to_gbtBank_mgt.mgtLink(1).prbs_txForceErr    <= '0';
        to_gbtBank_mgt.mgtLink(1).prbs_rxCntReset    <= '0';
        
        to_gbtBank_mgt.mgtLink(1).conf_diffCtrl      <= "1000";    -- Comment: 807 mVppd
        to_gbtBank_mgt.mgtLink(1).conf_postCursor    <= "00000";   -- Comment: 0.00 dB (default)
        to_gbtBank_mgt.mgtLink(1).conf_preCursor     <= "00000";   -- Comment: 0.00 dB (default)
        to_gbtBank_mgt.mgtLink(1).conf_txPol         <= '0';       -- Comment: Not inverted
        to_gbtBank_mgt.mgtLink(1).conf_rxPol         <= '0';       -- Comment: Not inverted     
        
        to_gbtBank_mgt.mgtLink(1).rxBitSlip_enable   <= '1'; 
        to_gbtBank_mgt.mgtLink(1).rxBitSlip_ctrl     <= '0'; 
        to_gbtBank_mgt.mgtLink(1).rxBitSlip_nbr      <= "000000";
        to_gbtBank_mgt.mgtLink(1).rxBitSlip_run      <= '0';
        to_gbtBank_mgt.mgtLink(1).rxBitSlip_oddRstEn <= '0';   -- Comment: If '1' resets the MGT RX when the the number of bitslips 
                                                               --          is odd (GTX only performs a number of bitslips multiple of 2). 
        
        to_gbtBank_mgt.mgtLink(1).loopBack           <= "000";
          
        to_gbtBank_mgt.mgtLink(1).rx_p               <= MGT_RX_P;   
        to_gbtBank_mgt.mgtLink(1).rx_n               <= MGT_RX_N;
                                                                 
        MGT_TX_P                          <= from_gbtBank_mgt.mgtLink(1).tx_p;  
        MGT_TX_N                          <= from_gbtBank_mgt.mgtLink(1).tx_n;                                                         
                                                                                                                                     
        to_gbtBank_mgt.mgtLink(1).tx_reset           <= mgtTxReset_from_gbtBank_gbtBankRst(1);
        to_gbtBank_mgt.mgtLink(1).rx_reset           <= mgtRxReset_from_gbtBank_gbtBankRst(1);
        to_gbtBank_mgt.mgtCommon.dummy_i <='0';

     
   --============--
   -- GBT Bank 1 --
   --============--
   
   -- Comment: Note!! This example design instantiates two GBT Banks:
   --
   --          - GBT Bank 1: One GBT Link (Standard GBT TX and Latency-Optimized GBT RX).
   --
   --          - GBT Bank 2: Three GBT Links (Latency-Optimized GBT TX and Standard GBT RX).  
   
   gbtBank: entity work.gbt_bank
      generic map (
         GBT_BANK_ID                         => 1,
            NUM_LINKS                                    => GBT_BANKS_USER_SETUP(1).NUM_LINKS,
            TX_OPTIMIZATION                            => GBT_BANKS_USER_SETUP(1).TX_OPTIMIZATION,
            RX_OPTIMIZATION                            => GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION,
            TX_ENCODING                                    => GBT_BANKS_USER_SETUP(1).TX_ENCODING,
            RX_ENCODING                                    => GBT_BANKS_USER_SETUP(1).RX_ENCODING)
      port map (                       
         CLKS_I                              => to_gbtBank_clks,                                  
         CLKS_O                              => from_gbtBank_clks,               
         --------------------------------------------------               
         GBT_TX_I                            => to_gbtBank_gbtTx,             
         GBT_TX_O                            => from_gbtBank_gbtTx,         
         --------------------------------------------------               
         MGT_I                               => to_gbtBank_mgt,              
         MGT_O                               => from_gbtBank_mgt,              
         --------------------------------------------------               
         GBT_RX_I                            => to_gbtBank_gbtRx,              
         GBT_RX_O                            => from_gbtBank_gbtRx         
      ); 
   
   
   --============--
     -- Status --
   --============--
   
   
   
   GBT_Status_O.txWordClk <= from_gbtBank_clks.mgt_clks.tx_wordClk(1);
   GBT_Status_O.rxFrameClk <= rxFrameClk_from_gbtBank_rxFrmClkPhAlgnr(1);
   GBT_Status_O.rxWordClk <= from_gbtBank_clks.mgt_clks.rx_wordClk(1);
   GBT_Status_O.txOutClkFabric <= from_gbtBank_clks.mgt_clks.tx_outclkfabric(1);
   
   GBT_Status_O.mgt_phalin_cplllock <= pllLocked_from_gbtBank_rxFrmClkPhAlgnr(1);
   
   GBT_Status_O.rxWordClkReady <= from_gbtBank_mgt.mgtLink(1).rxWordClkReady;
   GBT_Status_O.rxFrameClkReady <= phaseAlignDone_from_gbtBank_rxFrmClkPhAlgnr(1);

   GBT_Status_O.mgtLinkReady <= from_gbtBank_mgt.mgtLink(1).ready;
   GBT_Status_O.tx_resetDone <= from_gbtBank_mgt.mgtLink(1).tx_resetDone;
   GBT_Status_O.tx_fsmResetDone    <= from_gbtBank_mgt.mgtLink(1).tx_fsmResetDone;

   
   GBT_Status_O.gbtRx_Ready    <= from_gbtBank_gbtRx(1).ready;
   GBT_Status_O.gbtRx_ErrorDet    <= from_gbtBank_gbtRx(1).rxErrorDetected;
  
  
  
  
  
  
  
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--