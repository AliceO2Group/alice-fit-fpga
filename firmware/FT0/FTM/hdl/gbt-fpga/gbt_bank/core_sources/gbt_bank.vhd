--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT Bank                                        
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Vendor agnostic                                                      
-- Tool version:                                                                             
--                                                                                                   
-- Version:               3.5                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        08/02/2013   3.0       M. Barros Marin   First .vhd module definition
--
--                        05/10/2014   3.5       M. Barros Marin   - Added port "TX_MGT_READY_I" to "gbtTx"
--                                                                 - Minor modifications
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

entity gbt_bank is 
   generic (   
      GBT_BANK_ID                               : integer := 0;
		NUM_LINKS											: integer := 1;
		TX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		RX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		TX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
		RX_ENCODING											: integer range 0 to 1 := GBT_FRAME
   );
   port (   
      
      --========--
      -- Clocks --     
      --========--
      
      CLKS_I                                    : in  gbtBankClks_i_R;                                        
      CLKS_O                                    : out gbtBankClks_o_R;
      
      --========--
      -- GBT TX --
      --========--
      
      GBT_TX_I                                  : in  gbtTx_i_R_A        (1 to NUM_LINKS); 
      GBT_TX_O                                  : out gbtTx_o_R_A        (1 to NUM_LINKS); 
      
      --==================================--
      -- Multi Gigabit Transceivers (MGT) --                              
      --==================================--
      
      MGT_I                                     : in  mgt_i_R;
      MGT_O                                     : out mgt_o_R; 
      
      --========--              
      -- GBT RX --              
      --========-- 
      
      GBT_RX_I                                  : in  gbtRx_i_R_A        (1 to NUM_LINKS); 
      GBT_RX_O                                  : out gbtRx_o_R_A        (1 to NUM_LINKS)
      
   );
end gbt_bank;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_bank is   

   --================================ Signal Declarations ================================--

   --========--
   -- GBT TX --
   --========--   
   
   -- Comment: TX word width is device dependent.
   
   signal tx_wordNbit_from_gbtTx                : word_mxnbit_A         (1 to NUM_LINKS);    
	signal phaligned_from_gbtTx						: std_logic_vector      (1 to NUM_LINKS); 
	signal phcomputing_from_gbtTx						: std_logic_vector      (1 to NUM_LINKS); 
	
	signal tx_wordclk										: std_logic_vector      (1 to NUM_LINKS);
	
   --==================================--              
   -- Multi Gigabit Transceivers (MGT) --          
   --==================================--                 

   -- Comment: RX word width is device dependent.

   signal txReady_from_mgt                      : std_logic_vector      (1 to NUM_LINKS); 
   signal rxReady_from_mgt                      : std_logic_vector      (1 to NUM_LINKS); 
   signal rxWordClkReady_from_mgt               : std_logic_vector      (1 to NUM_LINKS); 
   signal rx_wordNbit_from_mgt                  : word_mxnbit_A         (1 to NUM_LINKS);    
   
   --========--              
   -- GBT RX --              
   --========--     
   
   -- Comment: GBT RX bitslip width is device dependent.   
   
   signal rxBitSlipNbr_from_gbtRx               : rxBitSlipNbr_mxnbit_A (1 to NUM_LINKS);   
   signal rxHeaderLocked_from_gbtRx             : std_logic_vector      (1 to NUM_LINKS); 
   
	signal rx_wordclk										: std_logic_vector      (1 to NUM_LINKS);
	
   --=====================================================================================--
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--
   
   --========--
   -- GBT TX --
   --========--
	gbtTx_param_generic_src_gen: if GBT_BANK_ID = 0 generate		
		gbtTx_gen: for i in 1 to NUM_LINKS generate 
			gbtTx: entity work.gbt_tx        
				generic map (			
						GBT_BANK_ID                         => GBT_BANK_ID,
						NUM_LINKS									=> NUM_LINKS,
						TX_OPTIMIZATION							=> TX_OPTIMIZATION,
						RX_OPTIMIZATION							=> RX_OPTIMIZATION,
						TX_ENCODING									=> TX_ENCODING,
						RX_ENCODING									=> RX_ENCODING
				)
				port map (            
					-- Reset & Clocks:
					TX_RESET_I                          => GBT_TX_I(i).reset,
					TX_FRAMECLK_I                       => CLKS_I.tx_frameClk(i),
					TX_WORDCLK_I                        => tx_wordclk(i),
					-- Control:              
					TX_MGT_READY_I                      => txReady_from_mgt(i),
					PHASE_ALIGNED_O							=> phaligned_from_gbtTx(i),
					PHASE_COMPUTING_DONE_O					=> phcomputing_from_gbtTx(i),
					TX_ISDATA_SEL_I                     => GBT_TX_I(i).isDataSel, 
					-- Data & Word:        
					TX_DATA_I                           => GBT_TX_I(i).data,
					TX_WORD_O                           => tx_wordNbit_from_gbtTx(i),
					------------------------------------
					TX_EXTRA_DATA_WIDEBUS_I             => GBT_TX_I(i).extraData_widebus
				); 
            
				GBT_TX_O(i).txGearboxAligned_o			<= phaligned_from_gbtTx(i);
				GBT_TX_O(i).txGearboxAligned_done		<= phcomputing_from_gbtTx(i);
            
			end generate;
	end generate;   
    
	gbtTx_param_pacakge_src_gen: if GBT_BANK_ID > 0 generate	
		gbtTx_gen: for i in 1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS generate 
			gbtTx: entity work.gbt_tx        
				generic map (			
						GBT_BANK_ID                         => GBT_BANK_ID,
						NUM_LINKS									=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS,
						TX_OPTIMIZATION							=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_OPTIMIZATION,
						RX_OPTIMIZATION							=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_OPTIMIZATION,
						TX_ENCODING									=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_ENCODING,
						RX_ENCODING									=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_ENCODING
				)
				port map (            
					-- Reset & Clocks:
					TX_RESET_I                          => GBT_TX_I(i).reset,
					TX_FRAMECLK_I                       => CLKS_I.tx_frameClk(i),
					TX_WORDCLK_I                        => tx_wordclk(i),
					-- Control:              
					TX_MGT_READY_I                      => txReady_from_mgt(i),
					PHASE_ALIGNED_O							=> phaligned_from_gbtTx(i),
					PHASE_COMPUTING_DONE_O					=> phcomputing_from_gbtTx(i),
					TX_ISDATA_SEL_I                     => GBT_TX_I(i).isDataSel, 
					-- Data & Word:        
					TX_DATA_I                           => GBT_TX_I(i).data,
					TX_WORD_O                           => tx_wordNbit_from_gbtTx(i),
					------------------------------------
					TX_EXTRA_DATA_WIDEBUS_I             => GBT_TX_I(i).extraData_widebus
				); 
            
				GBT_TX_O(i).txGearboxAligned_o			<= phaligned_from_gbtTx(i);
				GBT_TX_O(i).txGearboxAligned_done		<= phcomputing_from_gbtTx(i);
      end generate;  
   end generate;

   --============================--  
   -- Multi Gigabit Transceivers --
   --============================--          
	mgt_param_generic_src_gen: if GBT_BANK_ID = 0 generate
		mgt: entity work.multi_gigabit_transceivers  
			generic map (
				GBT_BANK_ID                            => GBT_BANK_ID,
				NUM_LINKS										=> NUM_LINKS,
				TX_OPTIMIZATION								=> TX_OPTIMIZATION,
				RX_OPTIMIZATION								=> RX_OPTIMIZATION,
				TX_ENCODING										=> TX_ENCODING,
				RX_ENCODING										=> RX_ENCODING
			)
			port map (        
				-- Clocks:    
				MGT_CLKS_I                             => CLKS_I.mgt_clks,
				MGT_CLKS_O                             => CLKS_O.mgt_clks,
				-- MGT I/O:                
				MGT_I                                  => MGT_I,
				MGT_O                                  => MGT_O,
				
				-- Control:
				PHASE_ALIGNED_I								=> phaligned_from_gbtTx(1),
				PHASE_COMPUTING_DONE_I						=> phcomputing_from_gbtTx(1),
				
				TX_WORDCLK_O									=> tx_wordclk,
				RX_WORDCLK_O									=> rx_wordclk,
				
				GBTTX_MGTTX_RDY_O                      => txReady_from_mgt,
				---------------------------------------
				GBTRX_MGTRX_RDY_O                      => rxReady_from_mgt,
				GBTRX_RXWORDCLK_READY_O                => rxWordClkReady_from_mgt,
				GBTRX_HEADER_LOCKED_I                  => rxHeaderLocked_from_gbtRx,
				GBTRX_BITSLIP_NBR_I                    => rxBitSlipNbr_from_gbtRx,
				-- Words:      
				GBTTX_WORD_I                           => tx_wordNbit_from_gbtTx,      
				GBTRX_WORD_O                           => rx_wordNbit_from_mgt
			);
   end generate;
	 
	mgt_param_package_src_gen: if GBT_BANK_ID > 0 generate
		mgt: entity work.multi_gigabit_transceivers  
			generic map (
				GBT_BANK_ID                         => GBT_BANK_ID,
				NUM_LINKS									=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS,
				TX_OPTIMIZATION							=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_OPTIMIZATION,
				RX_OPTIMIZATION							=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_OPTIMIZATION,
				TX_ENCODING									=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_ENCODING,
				RX_ENCODING									=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_ENCODING
			)
			port map (        
				-- Clocks:    
				MGT_CLKS_I                             => CLKS_I.mgt_clks,
				MGT_CLKS_O                             => CLKS_O.mgt_clks,
				-- MGT I/O:                
				MGT_I                                  => MGT_I,
				MGT_O                                  => MGT_O,
				
				-- Control:
				PHASE_ALIGNED_I								=> phaligned_from_gbtTx(1),
				PHASE_COMPUTING_DONE_I						=> phcomputing_from_gbtTx(1),
				
				TX_WORDCLK_O									=> tx_wordclk,
				RX_WORDCLK_O									=> rx_wordclk,
				
				GBTTX_MGTTX_RDY_O                      => txReady_from_mgt,
				---------------------------------------
				GBTRX_MGTRX_RDY_O                      => rxReady_from_mgt,
				GBTRX_RXWORDCLK_READY_O                => rxWordClkReady_from_mgt,
				GBTRX_HEADER_LOCKED_I                  => rxHeaderLocked_from_gbtRx,
				GBTRX_BITSLIP_NBR_I                    => rxBitSlipNbr_from_gbtRx,
				-- Words:      
				GBTTX_WORD_I                           => tx_wordNbit_from_gbtTx,      
				GBTRX_WORD_O                           => rx_wordNbit_from_mgt
			);
   end generate;
   --========--              
   -- GBT RX --              
   --========--
	gbtRx_param_generic_src_gen: if GBT_BANK_ID = 0 generate
		gbtRx_gen: for i in 1 to NUM_LINKS generate    
		
			gbtRx: entity work.gbt_rx            
				generic map (
					GBT_BANK_ID                         => GBT_BANK_ID,
					NUM_LINKS									=> NUM_LINKS,
					TX_OPTIMIZATION							=> TX_OPTIMIZATION,
					RX_OPTIMIZATION							=> RX_OPTIMIZATION,
					TX_ENCODING									=> TX_ENCODING,
					RX_ENCODING									=> RX_ENCODING
				)         
				port map (              
					-- Reset & Clocks:
					RX_RESET_I                          => GBT_RX_I(i).reset,
					RX_WORDCLK_I                        => rx_wordclk(i),
					RX_FRAMECLK_I                       => CLKS_I.rx_frameClk(i),                  
					-- Control:    
					RX_MGT_RDY_I                        => rxReady_from_mgt(i),        
					RX_WORDCLK_READY_I                  => rxWordClkReady_from_mgt(i),
					RX_FRAMECLK_READY_I                 => GBT_RX_I(i).rxFrameClkReady,
					------------------------------------
					RX_BITSLIP_NBR_O                    => rxBitSlipNbr_from_gbtRx(i),            
					RX_HEADER_LOCKED_O                  => rxHeaderLocked_from_gbtRx(i),                 
					RX_HEADER_FLAG_O                    => GBT_RX_O(i).header_flag,
					RX_ISDATA_FLAG_O                    => GBT_RX_O(i).isDataFlag,            
					RX_READY_O                          => GBT_RX_O(i).ready,
					-- Word & Data:                  
					RX_WORD_I                           => rx_wordNbit_from_mgt(i),                  
					RX_DATA_O                           => GBT_RX_O(i).data,
					------------------------------------
					RX_EXTRA_DATA_WIDEBUS_O             => GBT_RX_O(i).extraData_widebus,
					------------------------------------
					RX_BIT_MODIFIED_CNTER					=> GBT_RX_O(i).rxBitModifiedCnter,
					RX_ERROR_DETECTED							=> GBT_RX_O(i).rxErrorDetected
				);             
            
			GBT_RX_O(i).bitSlipNbr                    <= rxBitSlipNbr_from_gbtRx(i);                         
			GBT_RX_O(i).header_lockedFlag             <= rxHeaderLocked_from_gbtRx(i);
	 
		end generate;
	end generate;

	gbtRx_param_package_src_gen: if GBT_BANK_ID > 0 generate
		gbtRx_gen: for i in 1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS generate    
		
			gbtRx: entity work.gbt_rx            
				generic map (
					GBT_BANK_ID                         => GBT_BANK_ID,
					NUM_LINKS									=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS,
					TX_OPTIMIZATION							=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_OPTIMIZATION,
					RX_OPTIMIZATION							=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_OPTIMIZATION,
					TX_ENCODING									=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_ENCODING,
					RX_ENCODING									=> GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_ENCODING
				)         
				port map (              
					-- Reset & Clocks:
					RX_RESET_I                          => GBT_RX_I(i).reset,
					RX_WORDCLK_I                        => rx_wordclk(i),
					RX_FRAMECLK_I                       => CLKS_I.rx_frameClk(i),                  
					-- Control:    
					RX_MGT_RDY_I                        => rxReady_from_mgt(i),        
					RX_WORDCLK_READY_I                  => rxWordClkReady_from_mgt(i),
					RX_FRAMECLK_READY_I                 => GBT_RX_I(i).rxFrameClkReady,
					------------------------------------
					RX_BITSLIP_NBR_O                    => rxBitSlipNbr_from_gbtRx(i),            
					RX_HEADER_LOCKED_O                  => rxHeaderLocked_from_gbtRx(i),                 
					RX_HEADER_FLAG_O                    => GBT_RX_O(i).header_flag,
					RX_ISDATA_FLAG_O                    => GBT_RX_O(i).isDataFlag,            
					RX_READY_O                          => GBT_RX_O(i).ready,
					-- Word & Data:                  
					RX_WORD_I                           => rx_wordNbit_from_mgt(i),                  
					RX_DATA_O                           => GBT_RX_O(i).data,
					------------------------------------
					RX_EXTRA_DATA_WIDEBUS_O             => GBT_RX_O(i).extraData_widebus,
					------------------------------------
					RX_BIT_MODIFIED_CNTER					=> GBT_RX_O(i).rxBitModifiedCnter,
					RX_ERROR_DETECTED							=> GBT_RX_O(i).rxErrorDetected   
				);             
            
			GBT_RX_O(i).bitSlipNbr                    <= rxBitSlipNbr_from_gbtRx(i);                         
			GBT_RX_O(i).header_lockedFlag             <= rxHeaderLocked_from_gbtRx(i);
	 
		end generate;
	end generate;
   --===================--
   -- Optimization flags--
   --===================--
	
	optFlag_param_generic_src_gen: if GBT_BANK_ID = 0 generate
		optFlag_gen: for i in 1 to NUM_LINKS generate   
		
			-- TX:
			------

			stdGbtBankTx_gen: if TX_OPTIMIZATION = STANDARD generate
				GBT_TX_O(i).latOptGbtBank_tx           <= '0';
			end generate;
			
			latOptGbtBankTx_gen: if TX_OPTIMIZATION = LATENCY_OPTIMIZED generate
				GBT_TX_O(i).latOptGbtBank_tx           <= '1';
			end generate;

			-- RX:
			------

			stdGbtBankRx_gen: if RX_OPTIMIZATION = STANDARD generate
				GBT_RX_O(i).latOptGbtBank_rx           <= '0';
			end generate;   
			
			latOptGbtBankRx_gen: if RX_OPTIMIZATION = LATENCY_OPTIMIZED generate
				GBT_RX_O(i).latOptGbtBank_rx           <= '1';
			end generate;
			
		end generate;
   end generate;
	
	optFlag_param_package_src_gen: if GBT_BANK_ID > 0 generate
		optFlag_gen: for i in 1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS generate   
		
			-- TX:
			------
			stdGbtBankTx_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_OPTIMIZATION = STANDARD generate
				GBT_TX_O(i).latOptGbtBank_tx           <= '0';
			end generate;
			
			latOptGbtBankTx_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_OPTIMIZATION = LATENCY_OPTIMIZED generate
				GBT_TX_O(i).latOptGbtBank_tx           <= '1';
			end generate;

			-- RX:
			------
			stdGbtBankRx_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_OPTIMIZATION = STANDARD generate
				GBT_RX_O(i).latOptGbtBank_rx           <= '0';
			end generate;   
			
			latOptGbtBankRx_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_OPTIMIZATION = LATENCY_OPTIMIZED generate
				GBT_RX_O(i).latOptGbtBank_rx           <= '1';
			end generate;
			
		end generate;
   end generate;
   --=====================================================================================--
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--