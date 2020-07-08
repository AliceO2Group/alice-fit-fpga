--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Multi Gigabit Transceivers
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
-- Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
--
--                        04/11/2013   3.0       M. Barros Marin     First .vhd module definition
--
--                        05/10/2014   3.5       M. Barros Marin     - Added port "GBTTX_MGTTX_RDY_O"
--                                                                   - Minor modifications
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

entity multi_gigabit_transceivers is
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
      -- Clocks scheme --
      --===============--
      
      MGT_CLKS_I                                : in  gbtBankMgtClks_i_R;
      MGT_CLKS_O                                : out gbtBankMgtClks_o_R;        
        
      --=========--
      -- MGT I/O --
      --=========--
      
      MGT_I                                     : in  mgt_i_R;
      MGT_O                                     : out mgt_o_R;
      
      
		-- Phase monitoring:
		--------------------
		
		PHASE_ALIGNED_I									: in  std_logic;
		PHASE_COMPUTING_DONE_I							: in  std_logic;
		
      --=============--
      -- GBT control --
      --=============--
      
      GBTTX_MGTTX_RDY_O                         : out std_logic_vector     (1 to NUM_LINKS);
      
      GBTRX_MGTRX_RDY_O                         : out std_logic_vector     (1 to NUM_LINKS);
      GBTRX_RXWORDCLK_READY_O                   : out std_logic_vector     (1 to NUM_LINKS);             
      ------------------------------------------
      GBTRX_HEADER_LOCKED_I                     : in  std_logic_vector     (1 to NUM_LINKS);
      GBTRX_BITSLIP_NBR_I                       : in  rxBitSlipNbr_mxnbit_A(1 to NUM_LINKS);
     
	   --========--
		-- Clocks --
		--========--
		TX_WORDCLK_O										: out std_logic_vector      (1 to NUM_LINKS);
      RX_WORDCLK_O										: out std_logic_vector      (1 to NUM_LINKS);
      
		--=======--
      -- Words --
      --=======--
      
      GBTTX_WORD_I                              : in  word_mxnbit_A        (1 to NUM_LINKS);     
      GBTRX_WORD_O                              : out word_mxnbit_A        (1 to NUM_LINKS)     

   );
end multi_gigabit_transceivers;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of multi_gigabit_transceivers is      

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
  
   --==================================== User Logic =====================================--   
   
   --============================--
   -- Multi-Gigabit Transceivers --
   --============================--
   
   -- Standard optimization:
   -------------------------
   
--   mgtStd_gen: if     TX_OPTIMIZATION = STANDARD
--                  and RX_OPTIMIZATION = STANDARD generate
   
--      mgtStd: entity work.mgt_std
--         generic map (
--            GBT_BANK_ID                         => GBT_BANK_ID,
--				NUM_LINKS									=> NUM_LINKS,
--				TX_OPTIMIZATION							=> TX_OPTIMIZATION,
--				RX_OPTIMIZATION							=> RX_OPTIMIZATION,
--				TX_ENCODING									=> TX_ENCODING,
--				RX_ENCODING									=> RX_ENCODING
--			)
--         port map (
--            -- Clocks:         
--            MGT_CLKS_I                          => MGT_CLKS_I,
--            MGT_CLKS_O                          => MGT_CLKS_O,
				
--				-- Clocks:
--				TX_WORDCLK_O								=> TX_WORDCLK_O,
--				RX_WORDCLK_O								=> RX_WORDCLK_O,
				
--            -- MGT I/O:                   
--            MGT_I                               => MGT_I,
--            MGT_O                               => MGT_O,
--            -- GBT control: 
--            GBTTX_MGTTX_RDY_O                   => GBTTX_MGTTX_RDY_O,
--            ------------------------------------
--            GBTRX_MGTRX_RDY_O                   => GBTRX_MGTRX_RDY_O,
--            GBTRX_RXWORDCLK_READY_O             => GBTRX_RXWORDCLK_READY_O,
--            -- Words:         
--            GBTTX_WORD_I                        => GBTTX_WORD_I,   
--            GBTRX_WORD_O                        => GBTRX_WORD_O
--         );
         
--   end generate;   
      
   -- Latency optimization:
   ------------------------
   
   mgtLatOpt_gen: if    TX_OPTIMIZATION = LATENCY_OPTIMIZED 
                     or RX_OPTIMIZATION = LATENCY_OPTIMIZED generate 

      mgtLatOpt: entity work.mgt_latopt
         generic map (
            GBT_BANK_ID                         => GBT_BANK_ID,
				NUM_LINKS									=> NUM_LINKS,
				TX_OPTIMIZATION							=> TX_OPTIMIZATION,
				RX_OPTIMIZATION							=> RX_OPTIMIZATION,
				TX_ENCODING									=> TX_ENCODING,
				RX_ENCODING									=> RX_ENCODING
			)
         port map (
            -- Clocks:         
            MGT_CLKS_I                          => MGT_CLKS_I,
            MGT_CLKS_O                          => MGT_CLKS_O,
				
            -- MGT I/O:                   
            MGT_I                               => MGT_I,
            MGT_O                               => MGT_O,
				
            -- GBT control: 
				PHASE_ALIGNED_I							=> PHASE_ALIGNED_I,
				PHASE_COMPUTING_DONE_I					=> PHASE_COMPUTING_DONE_I,
            GBTTX_MGTTX_RDY_O                   => GBTTX_MGTTX_RDY_O,
            ------------------------------------
            GBTRX_MGTRX_RDY_O                   => GBTRX_MGTRX_RDY_O,
            GBTRX_RXWORDCLK_READY_O             => GBTRX_RXWORDCLK_READY_O,
            GBTRX_HEADER_LOCKED_I               => GBTRX_HEADER_LOCKED_I,
            GBTRX_BITSLIP_NBR_I                 => GBTRX_BITSLIP_NBR_I, 
				
            -- Words:         
            GBTTX_WORD_I                        => GBTTX_WORD_I,   
            GBTRX_WORD_O                        => GBTRX_WORD_O,
				
				-- Clocks:
				TX_WORDCLK_O								=> TX_WORDCLK_O,
				RX_WORDCLK_O								=> RX_WORDCLK_O
         );
   
   end generate;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--