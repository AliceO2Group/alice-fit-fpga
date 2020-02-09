--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)                            
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT TX                                       
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Device agnostic                                                         
-- Tool version:                                                                       
--                                                                                                   
-- Version:               3.5                                                                    
--
-- Description:             
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/07/2013   3.0       M. Barros Marin   First .vhd module definition
--
--                        03/09/2014   3.5       M. Barros Marin   Added TX_MGT_READY_I
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

entity gbt_tx is
   generic (   
      GBT_BANK_ID                               : integer := 1;  
		NUM_LINKS											: integer := 1;
		TX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		RX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		TX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
		RX_ENCODING											: integer range 0 to 1 := GBT_FRAME   
   );
   port (
   
      --================--
      -- Reset & Clocks --
      --================--    
      
      -- Reset:
      ---------
      
      TX_RESET_I                                : in  std_logic;      
      
      -- Clocks:
      ----------
      
      TX_FRAMECLK_I                             : in  std_logic;
      TX_WORDCLK_I                              : in  std_logic;

      --=========--                                
      -- Control --                                
      --=========-- 
      
      -- MGT TX Ready:
      ----------------

      TX_MGT_READY_I                            : in  std_logic;
      
		-- Phase monitoring:
		--------------------
		
		PHASE_ALIGNED_O									: out std_logic;
		PHASE_COMPUTING_DONE_O							: out std_logic;
		
      -- TX is data selector:
      -----------------------      
      
      TX_ISDATA_SEL_I                           : in  std_logic;     
      
      --======--           
      -- Data --           
      --======--              
      
      -- Common:
      ----------
      
      TX_DATA_I                                 : in  std_logic_vector(83 downto 0);
      TX_WORD_O                                 : out std_logic_vector(WORD_WIDTH-1 downto 0); 
      
      -- Wide-Bus:
      ------------
      
      TX_EXTRA_DATA_WIDEBUS_I                   : in  std_logic_vector(31 downto 0)
    
   );  
end gbt_tx;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_tx is

   --================================ Signal Declarations ================================--
   
   --===========--
   -- Scrambler --
   --===========--   
   
   signal txHeader_from_scrambler               : std_logic_vector( 3 downto 0);
   signal txCommonFrame_from_scrambler          : std_logic_vector(83 downto 0);      
   signal txExtraFrameWidebus_from_scrambler    : std_logic_vector(31 downto 0);   
   
   --=========--
   -- Encoder --
   --=========--    
   
   signal txFrame_from_encoder                  : std_logic_vector(119 downto 0);   
  
   --=========--
   -- Gearbox --
   --=========--    
	
   signal txword_from_gearbox                 : std_logic_vector(WORD_WIDTH-1 downto 0); 
	signal ready_from_gearbox						 : std_logic;
	signal phaligned_from_gearbox					 : std_logic;
	signal phcomputed_from_gearbox				 : std_logic;
	
   --=====================================================================================--   
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

  
   --==================================== User Logic =====================================--
   
   --===========--
   -- Scrambler --
   --===========--   
   
   scrambler: entity work.gbt_tx_scrambler
      generic map (
         GBT_BANK_ID                            => GBT_BANK_ID,
				NUM_LINKS									=> NUM_LINKS,
				TX_OPTIMIZATION							=> TX_OPTIMIZATION,
				RX_OPTIMIZATION							=> RX_OPTIMIZATION,
				TX_ENCODING									=> TX_ENCODING,
				RX_ENCODING									=> RX_ENCODING
			)
      port map (                                
         TX_RESET_I                             => TX_RESET_I,
         TX_FRAMECLK_I                          => TX_FRAMECLK_I,
         ---------------------------------------  
         TX_ISDATA_SEL_I                        => TX_ISDATA_SEL_I,
         TX_HEADER_O                            => txHeader_from_scrambler,
         ---------------------------------------  
         TX_DATA_I                              => TX_DATA_I,
         TX_COMMON_FRAME_O                      => txCommonFrame_from_scrambler,
         ---------------------------------------
         TX_EXTRA_DATA_WIDEBUS_I                => TX_EXTRA_DATA_WIDEBUS_I,
         TX_EXTRA_FRAME_WIDEBUS_O               => txExtraFrameWidebus_from_scrambler
      );    

   --=========--
   -- Encoder --
   --=========--  
   
   encoder: entity work.gbt_tx_encoder
      generic map (
         GBT_BANK_ID                            => GBT_BANK_ID,
				NUM_LINKS									=> NUM_LINKS,
				TX_OPTIMIZATION							=> TX_OPTIMIZATION,
				RX_OPTIMIZATION							=> RX_OPTIMIZATION,
				TX_ENCODING									=> TX_ENCODING,
				RX_ENCODING									=> RX_ENCODING
			)
      port map (
         TX_RESET_I                             => TX_RESET_I,
         TX_FRAMECLK_I                          => TX_FRAMECLK_I,
         ---------------------------------------
         TX_HEADER_I                            => txHeader_from_scrambler,
         ---------------------------------------
         TX_COMMON_FRAME_I                      => txCommonFrame_from_scrambler,
         TX_EXTRA_FRAME_WIDEBUS_I               => txExtraFrameWidebus_from_scrambler,
         ---------------------------------------
         TX_FRAME_O                             => txFrame_from_encoder
      );    

   --=========--
   -- Gearbox --
   --=========--

   txGearbox: entity work.gbt_tx_gearbox    
      generic map (
         GBT_BANK_ID                            => GBT_BANK_ID,
				NUM_LINKS									=> NUM_LINKS,
				TX_OPTIMIZATION							=> TX_OPTIMIZATION,
				RX_OPTIMIZATION							=> RX_OPTIMIZATION,
				TX_ENCODING									=> TX_ENCODING,
				RX_ENCODING									=> RX_ENCODING
			)
      port map (
         TX_RESET_I                             => TX_RESET_I,         
         TX_FRAMECLK_I                          => TX_FRAMECLK_I,
         TX_WORDCLK_I                           => TX_WORDCLK_I,
         ---------------------------------------
         TX_MGT_READY_I                         => TX_MGT_READY_I,         
         ---------------------------------------
         TX_FRAME_I                             => txFrame_from_encoder,
         TX_WORD_O                              => txword_from_gearbox,
			---------------------------------------
			TX_GEARBOX_READY_O							=> ready_from_gearbox,
			TX_PHALIGNED_O									=> phaligned_from_gearbox,
			TX_PHCOMPUTED_O								=> phcomputed_from_gearbox
      );

	TX_WORD_O <= txword_from_gearbox;
	
	--=====================--
	-- TX phase monitoring --
	--=====================--
	txPhaseMon: entity work.gbt_tx_gearbox_phasemon
		port map(
			-- RESET
			RESET_I			=> not(ready_from_gearbox),
			CLK				=> TX_WORDCLK_I,
			-- MONITORING
			PHCOMPUTED_I	=> phcomputed_from_gearbox,
			PHALIGNED_I		=> phaligned_from_gearbox,
			
			-- OUTPUT
			GOOD_O			=> PHASE_ALIGNED_O,
			DONE_O			=> PHASE_COMPUTING_DONE_O
		);
		
   --=====================================================================================--  
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--