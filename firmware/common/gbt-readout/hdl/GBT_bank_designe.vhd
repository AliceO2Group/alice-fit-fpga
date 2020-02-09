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
use work.fit_gbt_common_package.all;


entity GBT_bank_designe is
    Port ( RESET_I : in  STD_LOGIC;
		   FabricClk_I : in STD_LOGIC;
           MgtRefClk_I : in  STD_LOGIC;
           SFP_RX_P_I : in  STD_LOGIC;
           SFP_RX_N_I : in  STD_LOGIC;
           SFP_TX_P_O : out  STD_LOGIC;
           SFP_TX_N_O : out  STD_LOGIC;
           TXDataClk_I : in  STD_LOGIC;
           TXData_I : in  STD_LOGIC_VECTOR (GBT_data_word_bitdepth-1 downto 0);
           IsTXData_I : in  STD_LOGIC;
           RXDataClk_O : out  STD_LOGIC;
           RXData_O : out  STD_LOGIC_VECTOR (GBT_data_word_bitdepth-1 downto 0);
           IsRXData_O : out  STD_LOGIC;
		   GBT_Status_O : out Type_GBT_status);
end GBT_bank_designe;

architecture Behavioral of GBT_bank_designe is
		
   signal RXData_from_gbtExmplDsgn : STD_LOGIC_VECTOR (83 downto 0);


   signal txFrameClk_from_gbtExmplDsgn               : std_logic;
   signal txWordClk_from_gbtExmplDsgn                : std_logic;
   signal rxFrameClk_from_gbtExmplDsgn               : std_logic;
   signal rxWordClk_from_gbtExmplDsgn                : std_logic;
   signal txOutClkFabric_from_gbtExmplDsgn           : std_logic;
   signal mgt_cplllock_from_gbtExmplDsgn             : std_logic;

   
   signal rxWordClkReady_from_gbtExmplDsgn           : std_logic; 
   signal rxFrameClkReady_from_gbtExmplDsgn          : std_logic; 
   
   
   signal tx_resetDone_from_gbtExmplDsgn          : std_logic; 
   signal tx_fsmResetDone_from_gbtExmplDsgn          : std_logic; 
   
   signal mgtLinkReady_from_gbtExmplDsgn 				:std_logic;
   signal gbt_bitSlipNbr_from_gbt_ExmplDsgn 				: std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
   signal gbtRx_Ready_from_gbt_ExmplDsgn				 :std_logic;
   signal gbtTx_Ready_from_gbt_ExmplDsgn				 :std_logic;
   signal gbtRx_ErrorDet_from_gbt_ExmplDsgn				 :std_logic;
   
   signal rxExtraDataWidebus_from_gbtExmplDsgn       : std_logic_vector(31 downto 0);

 begin   
   
   -- #####################################################################
   -- ######################## GBT BANK ###################################
   -- #####################################################################
   
   RXData_O <= RXData_from_gbtExmplDsgn(GBT_data_word_bitdepth-1 downto 0);
   RXDataClk_O <= rxFrameClk_from_gbtExmplDsgn;
   
	GBT_Status_O.txFrameClk_from_gbtExmplDsgn <= txFrameClk_from_gbtExmplDsgn;
	GBT_Status_O.txWordClk_from_gbtExmplDsgn <= txWordClk_from_gbtExmplDsgn;
	GBT_Status_O.rxFrameClk_from_gbtExmplDsgn <= rxFrameClk_from_gbtExmplDsgn;
	GBT_Status_O.rxWordClk_from_gbtExmplDsgn <= rxWordClk_from_gbtExmplDsgn;
	GBT_Status_O.txOutClkFabric_from_gbtExmplDsgn <= txOutClkFabric_from_gbtExmplDsgn;
	
	GBT_Status_O.mgt_cplllock_from_gbtExmplDsgn <= mgt_cplllock_from_gbtExmplDsgn;
	
	GBT_Status_O.rxWordClkReady_from_gbtExmplDsgn <= rxWordClkReady_from_gbtExmplDsgn;
	GBT_Status_O.rxFrameClkReady_from_gbtExmplDsgn <= rxFrameClkReady_from_gbtExmplDsgn;

	GBT_Status_O.mgtLinkReady_from_gbtExmplDsgn <= mgtLinkReady_from_gbtExmplDsgn;
	GBT_Status_O.gbtRx_Ready_from_gbt_ExmplDsgn <= gbtRx_Ready_from_gbt_ExmplDsgn;
	GBT_Status_O.gbtTx_Ready_from_gbt_ExmplDsgn	<= gbtTx_Ready_from_gbt_ExmplDsgn;

	
	GBT_Status_O.tx_resetDone_from_gbtExmplDsgn	<= tx_resetDone_from_gbtExmplDsgn;
	GBT_Status_O.tx_fsmResetDone_from_gbtExmplDsgn	<= tx_fsmResetDone_from_gbtExmplDsgn;
	GBT_Status_O.gbtRx_ErrorDet_from_gbt_ExmplDsgn	<= gbtRx_ErrorDet_from_gbt_ExmplDsgn;
	
	
   gbtExmplDsgn_inst: entity work.xlx_k7v7_gbt_example_design
       generic map(
           GBT_BANK_ID                                            => 1,
           NUM_LINKS                                              => GBT_BANKS_USER_SETUP(1).NUM_LINKS,
           TX_OPTIMIZATION                                        => GBT_BANKS_USER_SETUP(1).TX_OPTIMIZATION,
           RX_OPTIMIZATION                                        => GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION,
           TX_ENCODING                                            => GBT_BANKS_USER_SETUP(1).TX_ENCODING,
           RX_ENCODING                                            => GBT_BANKS_USER_SETUP(1).RX_ENCODING,
		   
		   DATA_GENERATOR_ENABLE								  => 0,
		   DATA_CHECKER_ENABLE								  => 0,
		   MATCH_FLAG_ENABLE								  => 0
       )
     port map (

       --==============--
       -- Clocks       --
       --==============--
       FRAMECLK_40MHZ                                             => TXDataClk_I,
       XCVRCLK                                                    => MgtRefClk_I,
       
       TX_FRAMECLK_O(1)                                              => txFrameClk_from_gbtExmplDsgn,        
       TX_WORDCLK_O(1)                                               => txWordClk_from_gbtExmplDsgn,          
       RX_FRAMECLK_O(1)                                              => rxFrameClk_from_gbtExmplDsgn,         
       RX_WORDCLK_O(1)                                               => rxWordClk_from_gbtExmplDsgn,      
       
       RX_WORDCLK_RDY_O(1)                                           => rxWordClkReady_from_gbtExmplDsgn,
       RX_FRAMECLK_RDY_O(1)                                          => rxFrameClkReady_from_gbtExmplDsgn,
       
	   MGT_OUTCLKFABRIC_O(1)										=> txOutClkFabric_from_gbtExmplDsgn,
	   
	   MGT_CPLLLOCK_O(1)										=> mgt_cplllock_from_gbtExmplDsgn,
       --==============--
       -- Reset        --
       --==============--
       GBTBANK_GENERAL_RESET_I                                    => RESET_I,
       GBTBANK_MANUAL_RESET_TX_I                                  => '0',
       GBTBANK_MANUAL_RESET_RX_I                                  => '0',
       
       --==============--
       -- Serial lanes --
       --==============--
       GBTBANK_MGT_RX_P(1)                                        => SFP_RX_P_I,
       GBTBANK_MGT_RX_N(1)                                        => SFP_RX_N_I,
       GBTBANK_MGT_TX_P(1)                                        => SFP_TX_P_O,
       GBTBANK_MGT_TX_N(1)                                        => SFP_TX_N_O,
       
       --==============--
       -- Data             --
       --==============--      
       -- TX in data
	   GBTBANK_GBT_DATA_I(1)                                      => (x"0" & TXData_I), --is array (natural range <>) of std_logic_vector(83  downto 0);
       GBTBANK_WB_DATA_I(1)                                       => (others => '0'), --is array (natural range <>) of std_logic_vector(115 downto 0);
       
	   -- loop back tx data
       -- TX_DATA_O(1)                                               => open, --txData_from_gbtExmplDsgn,            
       -- WB_DATA_O(1)                                               => open, -- txExtraDataWidebus_from_gbtExmplDsgn,
       
	   -- RX data out
       GBTBANK_GBT_DATA_O(1)                                      => RXData_from_gbtExmplDsgn,
       GBTBANK_WB_DATA_O(1)                                       => rxExtraDataWidebus_from_gbtExmplDsgn,
       --==============--
       -- Reconf.         --
       --==============--
       GBTBANK_MGT_DRP_RST                                        => '0', --not used
       GBTBANK_MGT_DRP_CLK                                        => FabricClk_I,
       
       --==============--
       -- TX ctrl        --
       --==============--
       GBTBANK_TX_ISDATA_SEL_I(1)                                => IsTXData_I, -- isData to GBT
       GBTBANK_TEST_PATTERN_SEL_I                                => "11", --no gen

       --==============--
       -- RX ctrl      --
       --==============--
       GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I(1)                   => '0', -- to disabled chcker
       GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I(1)                    => '0', -- to disabled checker
       
       --==============--
       -- TX Status    --
       --==============--
		GBTBANK_GBTTX_READY_O(1)									 => gbtTx_Ready_from_gbt_ExmplDsgn,  -- <= '1'; --from_gbtBank_gbtTx(1).ready; JM: To be modified

		GBTBANK_LINK_READY_O(1)                                  => mgtLinkReady_from_gbtExmplDsgn, -- from_gbtBank_mgt.mgtLink(i).ready
--       GBTBANK_TX_MATCHFLAG_O                                    => open, -- from disabled checker
       
	   	GBTBANK_TX_RESET_DONE_R2_O(1)	=> tx_resetDone_from_gbtExmplDsgn,
		GBTBANK_TX_FSM_RESET_DONE_O(1) => 	tx_fsmResetDone_from_gbtExmplDsgn,

       --==============--
       -- RX Status    --
       --==============--
       GBTBANK_GBTRX_READY_O(1)                                  => gbtRx_Ready_from_gbt_ExmplDsgn, -- from_gbtBank_gbtRx(i).ready
       GBTBANK_LINK1_BITSLIP_O                                   => gbt_bitSlipNbr_from_gbt_ExmplDsgn,  -- from from_gbtBank_gbtRx(1).bitSlipNbr;
       -- GBTBANK_GBTRXREADY_LOST_FLAG_O(1)                         => open, -- from disabled checker
       -- GBTBANK_RXDATA_ERRORSEEN_FLAG_O(1)                        => open, -- from disabled checker
       -- GBTBANK_RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O(1)           => open, -- from disabled checker
       -- GBTBANK_RX_MATCHFLAG_O(1)                                 => open, -- from disabled checker
       GBTBANK_RX_ISDATA_SEL_O(1)                                => IsRXData_O, -- RX is data out
       -- RXDATA_WORD_CNT                                           => open,  -- from disabled checker
       -- RXDATA_ERROR_CNT                                          => open,  -- from disabled checker
       GBTBANK_RX_ERRORDETECTED_O(1)                                => gbtRx_ErrorDet_from_gbt_ExmplDsgn, 
       
       --==============--
       -- XCVR ctrl    --
       --==============--
	  -- UG366 page 123 : LOOPBACK[2:0] In Async 000: Normal operation
	  -- MGT_I.mgtLink(n).loopBack (?)
       GBTBANK_LOOPBACK_I                                        => "000", -- to_gbtBank_mgt.mgtLink(i).loopBack        
       GBTBANK_TX_POL(1)                                        => '0', -- to_gbtBank_mgt.mgtLink(i).conf_txPol         <= GBTBANK_TX_POL(i);       -- Comment: Not inverted
       GBTBANK_RX_POL(1)                                        => '0' -- to_gbtBank_mgt.mgtLink(i).conf_rxPol         <= GBTBANK_RX_POL(i);       -- Comment: Not inverted 
	   
	           
            

  ); 

   
end Behavioral;

