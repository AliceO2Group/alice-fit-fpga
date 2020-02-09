--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Kintex 7 & Virtex 7 - Multi Gigabit Transceivers standard
--                                                                                                 
-- Language:              VHDL'93                                                                 
--                                                                                                   
-- Target Device:         Xilinx Kintex 7 & Virtex 7                                                         
-- Tool version:          ISE 14.5                                                               
--                                                                                                   
-- Revision:              3.5                                                                      
--
-- Description:           
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/11/2013   3.0       M. Barros Marin   First .vhd module definition   
--
--                        04/11/2013   3.2       M. Barros Marin   Fixed reset issue
--
--                        11/09/2014   3.5       M. Barros Marin   Removed "eyeScanDataError" 
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

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity mgt_std is
   generic (
       GBT_BANK_ID                                 : integer := 1;
       NUM_LINKS                                   : integer := 1;
       TX_OPTIMIZATION                             : integer range 0 to 1 := STANDARD;
       RX_OPTIMIZATION                             : integer range 0 to 1 := STANDARD;
       TX_ENCODING                                 : integer range 0 to 1 := GBT_FRAME;
       RX_ENCODING                                 : integer range 0 to 1 := GBT_FRAME
   ); 
   port (      

      --===============--  
      -- Clocks scheme --  
      --===============--  

      MGT_CLKS_I                                  : in  gbtBankMgtClks_i_R;
      MGT_CLKS_O                                  : out gbtBankMgtClks_o_R;   
           
      --========--
      -- Clocks --
      --========--
      TX_WORDCLK_O                                        : out std_logic_vector      (1 to NUM_LINKS);
      RX_WORDCLK_O                                        : out std_logic_vector      (1 to NUM_LINKS);     

      --=========--  
      -- MGT I/O --  
      --=========--  

      MGT_I                                       : in  mgt_i_R;
      MGT_O                                       : out mgt_o_R;

      --=============-- 
      -- GBT Control -- 
      --=============-- 

      GBTTX_MGTTX_RDY_O                           : out std_logic_vector(1 to NUM_LINKS);
      
      GBTRX_MGTRX_RDY_O                           : out std_logic_vector(1 to NUM_LINKS);
      GBTRX_RXWORDCLK_READY_O                     : out std_logic_vector(1 to NUM_LINKS);
      
      --=======-- 
      -- Words -- 
      --=======-- 
 
      GBTTX_WORD_I                                : in  word_mxnbit_A   (1 to NUM_LINKS);     
      GBTRX_WORD_O                                : out word_mxnbit_A   (1 to NUM_LINKS) 
   
   );
end mgt_std;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of mgt_std is

    signal rx_wordclk_sig                         : std_logic_vector(1 to NUM_LINKS);
    signal tx_wordclk_sig                         : std_logic;
    
    signal rxoutclk_sig                           : std_logic_vector(1 to NUM_LINKS);
    signal txoutclk_sig                           : std_logic_vector(1 to NUM_LINKS);
    
    signal rx_reset_done                          : std_logic_vector(1 to NUM_LINKS);
    signal tx_reset_done                          : std_logic_vector(1 to NUM_LINKS);
        
    signal rxfsm_reset_done                          : std_logic_vector(1 to NUM_LINKS);
    signal txfsm_reset_done                          : std_logic_vector(1 to NUM_LINKS);
    
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   gtxStd_gen: for i in 1 to NUM_LINKS generate
          
       RX_WORDCLK_O(i)                  <= rx_wordclk_sig(i);
       TX_WORDCLK_O(i)                  <= tx_wordclk_sig;
       
       MGT_CLKS_O.tx_wordClk(i)         <= tx_wordclk_sig;     
       MGT_CLKS_O.rx_wordClk(i)         <= rx_wordclk_sig(i);
       
       GBTRX_RXWORDCLK_READY_O(i)       <= rx_reset_done(i);
       GBTRX_MGTRX_RDY_O(i)             <= rx_reset_done(i);
       MGT_O.mgtLink(i).rx_resetDone    <= rx_reset_done(i);
       MGT_O.mgtLink(i).rx_fsmResetDone <= rxfsm_reset_done(i);
       MGT_O.mgtLink(i).rxWordClkReady  <=    rxfsm_reset_done(i); 
             
       GBTTX_MGTTX_RDY_O(i)             <= tx_reset_done(i);
       MGT_O.mgtLink(i).tx_resetDone    <= tx_reset_done(i);
       MGT_O.mgtLink(i).tx_fsmResetDone <= txfsm_reset_done(i);
              
       MGT_O.mgtLink(i).ready           <= txfsm_reset_done(i) and rxfsm_reset_done(i) and rx_reset_done(i) and tx_reset_done(i);
       
       xlx_k7v7_mgt_std_i: entity  work.xlx_k7v7_mgt_ip
            port map
            (
                SYSCLK_IN                       =>      MGT_CLKS_I.mgtRstCtrlRefClk,
                SOFT_RESET_TX_IN                =>      MGT_I.mgtLink(i).tx_reset,
                SOFT_RESET_RX_IN                =>      MGT_I.mgtLink(i).rx_reset,
                DONT_RESET_ON_DATA_ERROR_IN     =>      '1',
                GT0_TX_FSM_RESET_DONE_OUT       =>      txfsm_reset_done(i),
                GT0_RX_FSM_RESET_DONE_OUT       =>      rxfsm_reset_done(i),
                GT0_DATA_VALID_IN               =>      '1',
       
           --_________________________________________________________________________
           --GT0  (X0Y0)
           --____________________________CHANNEL PORTS________________________________
               gt0_loopback_in                 =>      MGT_I.mgtLink(i).loopBack,
           --------------------------------- CPLL Ports -------------------------------
               gt0_cpllfbclklost_out           =>      open,
               gt0_cplllock_out                =>      MGT_O.mgtLink(i).cpllLock,
               gt0_cplllockdetclk_in           =>      MGT_CLKS_I.cpllLockDetClk,
               gt0_cpllreset_in                =>      '0', --Internally managed by the TX startup FSM
           -------------------------- Channel - Clocking Ports ------------------------
               gt0_gtrefclk0_in                =>      MGT_CLKS_I.mgtRefClk,
               gt0_gtrefclk1_in                =>      '0',
           ---------------------------- Channel - DRP Ports  --------------------------
               gt0_drpaddr_in                  =>      MGT_I.mgtLink(i).drp_addr,
               gt0_drpclk_in                   =>      MGT_CLKS_I.drpClk,
               gt0_drpdi_in                    =>      MGT_I.mgtLink(i).drp_di,
               gt0_drpdo_out                   =>      MGT_O.mgtLink(i).drp_do,
               gt0_drpen_in                    =>      MGT_I.mgtLink(i).drp_en,
               gt0_drprdy_out                  =>      MGT_O.mgtLink(i).drp_rdy,
               gt0_drpwe_in                    =>      MGT_I.mgtLink(i).drp_we,
           --------------------------- Digital Monitor Ports --------------------------
               gt0_dmonitorout_out             =>      open,
           --------------------- RX Initialization and Reset Ports --------------------
               gt0_eyescanreset_in             =>      '0',
               gt0_rxuserrdy_in                =>      '0',
           -------------------------- RX Margin Analysis Ports ------------------------
               gt0_eyescandataerror_out        =>      open,
               gt0_eyescantrigger_in           =>      '0',
           ------------------ Receive Ports - FPGA RX Interface Ports -----------------
               gt0_rxusrclk_in                 =>      rx_wordClk_sig(i),
               gt0_rxusrclk2_in                =>      rx_wordClk_sig(i),
           ------------------ Receive Ports - FPGA RX interface Ports -----------------
               gt0_rxdata_out                  =>      GBTRX_WORD_O(i),
           --------------------------- Receive Ports - RX AFE -------------------------
               gt0_gtxrxp_in                   =>      MGT_I.mgtLink(i).rx_p,
           ------------------------ Receive Ports - RX AFE Ports ----------------------
               gt0_gtxrxn_in                   =>      MGT_I.mgtLink(i).rx_n,
           --------------------- Receive Ports - RX Equalizer Ports -------------------
               gt0_rxdfelpmreset_in            =>      '0',
               gt0_rxmonitorout_out            =>      open,
               gt0_rxmonitorsel_in             =>      "00",
           --------------- Receive Ports - RX Fabric Output Control Ports -------------
               gt0_rxoutclk_out                =>      rxoutclk_sig(i),
           ------------- Receive Ports - RX Initialization and Reset Ports ------------
               gt0_gtrxreset_in                =>      '0', --Internally managed by the RX startup FSM
               gt0_rxpmareset_in               =>      '0',
           ----------------- Receive Ports - RX Polarity Control Ports ----------------
               gt0_rxpolarity_in               =>      MGT_I.mgtLink(i).conf_rxPol,
           ---------------------- Receive Ports - RX gearbox ports --------------------
               gt0_rxslide_in                  =>      '0',
           -------------- Receive Ports -RX Initialization and Reset Ports ------------
               gt0_rxresetdone_out             =>      rx_reset_done(i),
           ------------------------ TX Configurable Driver Ports ----------------------
               gt0_txpostcursor_in             =>      MGT_I.mgtLink(i).conf_postCursor,
               gt0_txprecursor_in              =>      MGT_I.mgtLink(i).conf_preCursor,
           --------------------- TX Initialization and Reset Ports --------------------
               gt0_gttxreset_in                =>      '0', --Internally managed by the TX startup FSM
               gt0_txuserrdy_in                =>      '0', --Internally managed by the TX startup FSM
           ------------------ Transmit Ports - FPGA TX Interface Ports ----------------
               gt0_txusrclk_in                 =>      tx_wordClk_sig,
               gt0_txusrclk2_in                =>      tx_wordClk_sig,
           --------------- Transmit Ports - TX Configurable Driver Ports --------------
               gt0_txdiffctrl_in               =>      MGT_I.mgtLink(i).conf_diffCtrl,
           ------------------ Transmit Ports - TX Data Path interface -----------------
               gt0_txdata_in                   =>      GBTTX_WORD_I(i), 
           ---------------- Transmit Ports - TX Driver and OOB signaling --------------
               gt0_gtxtxn_out                  =>      MGT_O.mgtLink(i).tx_n,
               gt0_gtxtxp_out                  =>      MGT_O.mgtLink(i).tx_p,
           ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
               gt0_txoutclk_out                =>      txoutclk_sig(i),
               gt0_txoutclkfabric_out          =>      open,
               gt0_txoutclkpcs_out             =>      open,
           ------------- Transmit Ports - TX Initialization and Reset Ports -----------
               gt0_txresetdone_out             =>      tx_reset_done(i),
           ----------------- Transmit Ports - TX Polarity Control Ports ---------------
               gt0_txpolarity_in               =>      MGT_I.mgtLink(i).conf_txPol,
       
           --____________________________COMMON PORTS________________________________
            GT0_QPLLOUTCLK_IN  => '0',
            GT0_QPLLOUTREFCLK_IN => '0' 
       );
       
       rxWordClkBufg: bufg
           port map (
                 O                                        => rx_wordClk_sig(i), 
                 I                                        => rxoutclk_sig(i)
           ); 
   end generate;
   
      txWordClkBufg: bufg
          port map (
                O                                        => tx_wordClk_sig, 
                I                                        => txoutclk_sig(1)
          ); 
   
   
   --=====================================================================================--
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--