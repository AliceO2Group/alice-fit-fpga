--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:                CERN (PH-ESE-BE)                                                         
-- Engineer:               Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                            
--                                                                                                 
-- Project Name:           GBT-FPGA                                                                
-- Module Name:            GBT RX                                      
--                                                                                                 
-- Language:               VHDL'93                                                                  
--                                                                                                   
-- Target Device:          Device agnostic                                                         
-- Tool version:                                                                       
--                                                                                                   
-- Current version:        3.0                                                                      
--
-- Description:             
--
-- Versions history:       DATE         VERSION   AUTHOR              DESCRIPTION
--
--                         04/07/2013   3.0       M. Barros Marin     First .vhd module definition
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

entity gbt_rx is
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
      
      RX_RESET_I                                : in  std_logic;
      
      -- Clocks:
      ----------
      
      RX_WORDCLK_I                              : in  std_logic;
      RX_FRAMECLK_I                             : in  std_logic;

      --=========--                                
      -- Control --                                
      --=========--  
      
      RX_MGT_RDY_I                              : in  std_logic;
      ------------------------------------------
      RX_WORDCLK_READY_I                        : in  std_logic;  
      RX_FRAMECLK_READY_I                       : in  std_logic;        
      ------------------------------------------
      RX_BITSLIP_NBR_O                          : out std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      ------------------------------------------
      RX_HEADER_LOCKED_O                        : out std_logic;
      RX_HEADER_FLAG_O                          : out std_logic;
      ------------------------------------------
      RX_ISDATA_FLAG_O                          : out std_logic;
      ------------------------------------------      
      RX_READY_O                                : out std_logic;
      
      --=========--                                
      -- Status  --                                
      --=========--  
		
		RX_ERROR_DETECTED									: out std_logic;
		RX_BIT_MODIFIED_CNTER							: out std_logic_vector(7 downto 0);
		
      --=============--                                
      -- Word & Data --                                
      --=============--                                
      
      -- Common:
      ----------
      
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      RX_DATA_O                                 : out std_logic_vector(83 downto 0);

      -- Wide-Bus:
      ------------

      RX_EXTRA_DATA_WIDEBUS_O                   : out std_logic_vector(31 downto 0)
      
   );  
end gbt_rx;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_rx is

   --================================ Signal Declarations ================================--
   
   --===============--
   -- Frame aligner --
   --===============--
   
   signal rxHeaderLocked_from_frameAligner      : std_logic;
   signal rxWriteAddress_from_frameAligner  	   : std_logic_vector(WORD_ADDR_MSB downto 0);
   signal alignedRxWord_from_frameAligner       : std_logic_vector(WORD_WIDTH-1 downto 0);  
   
   --=========--
   -- Gearbox --
   --=========--
   
   signal ready_from_rxGearbox                  : std_logic;
   signal rxFrame_from_rxGearbox                : std_logic_vector(119 downto 0);
  
   --=========--
   -- Decoder --
   --=========-- 
   
   signal ready_from_decoder                    : std_logic;
   signal rxIsDataFlag_from_decoder             : std_logic;
   signal rxCommonFrame_from_decoder            : std_logic_vector(83 downto 0);
   signal rxExtraFrameWidebus_from_decoder      : std_logic_vector(31 downto 0);   
   
   --=============--
   -- Descrambler --
   --=============-- 
   
   signal ready_from_descrambler                : std_logic;
   
   --========--
   -- Status --
   --========-- 
   
   signal rxReady_from_status                   : std_logic;
   
   --=====================================================================================-- 
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
  
   --==================================== User Logic =====================================--
   
   --===============--
   -- Frame aligner --
   --===============--
   
   frameAligner: entity work.gbt_rx_framealigner   
      port map (
         RX_RESET_I                             => RX_RESET_I,
         RX_WORDCLK_I                           => RX_WORDCLK_I,
         ---------------------------------------
         RX_MGT_RDY_I                           => RX_MGT_RDY_I,
         ---------------------------------------
         RX_HEADER_LOCKED_O                     => rxHeaderLocked_from_frameAligner,
         RX_HEADER_FLAG_O                       => RX_HEADER_FLAG_O,
         ---------------------------------------
         RX_BITSLIP_NBR_O                       => RX_BITSLIP_NBR_O,
         ---------------------------------------         
         RX_WRITE_ADDRESS_O                     => rxWriteAddress_from_frameAligner,
         ---------------------------------------
         RX_WORD_I                              => RX_WORD_I,
         ALIGNED_RX_WORD_O                      => alignedRxWord_from_frameAligner
      );
      
   RX_HEADER_LOCKED_O                           <= rxHeaderLocked_from_frameAligner;  

   --=========--
   -- Gearbox --
   --=========--
   
   rxGearbox: entity work.gbt_rx_gearbox
      generic map (
         GBT_BANK_ID                            => GBT_BANK_ID,
			NUM_LINKS										=> NUM_LINKS,
			TX_OPTIMIZATION								=> TX_OPTIMIZATION,
			RX_OPTIMIZATION								=> RX_OPTIMIZATION,
			TX_ENCODING										=> TX_ENCODING,
			RX_ENCODING										=> RX_ENCODING
		)
      port map (              
         RX_RESET_I                             => RX_RESET_I, 
         RX_WORDCLK_I                           => RX_WORDCLK_I, 
         RX_FRAMECLK_I                          => RX_FRAMECLK_I, 
         ---------------------------------------
         RX_HEADER_LOCKED_I                     => rxHeaderLocked_from_frameAligner,
         RX_WRITE_ADDRESS_I                     => rxWriteAddress_from_frameAligner,
         READY_O                                => ready_from_rxGearbox,
         ---------------------------------------
         RX_WORD_I                              => alignedRxWord_from_frameAligner,
         RX_FRAME_O                             => rxFrame_from_rxGearbox
      );  
  
   --=========--
   -- Decoder --
   --=========--       
  
   decoder: entity work.gbt_rx_decoder 
      generic map (
         GBT_BANK_ID                            => GBT_BANK_ID,
			NUM_LINKS										=> NUM_LINKS,
			TX_OPTIMIZATION								=> TX_OPTIMIZATION,
			RX_OPTIMIZATION								=> RX_OPTIMIZATION,
			TX_ENCODING										=> TX_ENCODING,
			RX_ENCODING										=> RX_ENCODING
		)
      port map (
         RX_RESET_I                             => RX_RESET_I,
         RX_FRAMECLK_I                          => RX_FRAMECLK_I, 
         ---------------------------------------
         RX_GEARBOX_READY_I                     => ready_from_rxGearbox,
         READY_O                                => ready_from_decoder,         
         ---------------------------------------
         RX_ISDATA_FLAG_ENABLE_I                => rxReady_from_status,
         RX_ISDATA_FLAG_O                       => rxIsDataFlag_from_decoder,
         ---------------------------------------
         RX_FRAME_I                             => rxFrame_from_rxGearbox,
         ---------------------------------------
         RX_COMMON_FRAME_O                      => rxCommonFrame_from_decoder,
         RX_EXTRA_FRAME_WIDEBUS_O               => rxExtraFrameWidebus_from_decoder,
			---------------------------------------
			RX_ERROR_DETECTED								=> RX_ERROR_DETECTED,
			RX_BIT_MODIFIED_CNTER						=> RX_BIT_MODIFIED_CNTER
		
      ); 
      
   --=============--
   -- Descrambler --
   --=============--   
   
   descrambler: entity work.gbt_rx_descrambler
      generic map (
         GBT_BANK_ID                            => GBT_BANK_ID,
			NUM_LINKS										=> NUM_LINKS,
			TX_OPTIMIZATION								=> TX_OPTIMIZATION,
			RX_OPTIMIZATION								=> RX_OPTIMIZATION,
			TX_ENCODING										=> TX_ENCODING,
			RX_ENCODING										=> RX_ENCODING
		)
      port map (
         RX_RESET_I                             => RX_RESET_I, 
         RX_FRAMECLK_I                          => RX_FRAMECLK_I, 
         ---------------------------------------
         RX_DECODER_READY_I                     => ready_from_decoder,
         READY_O                                => ready_from_descrambler,
         ---------------------------------------
         RX_ISDATA_FLAG_I                       => rxIsDataFlag_from_decoder,
         RX_ISDATA_FLAG_O                       => RX_ISDATA_FLAG_O,
         ---------------------------------------
         RX_COMMON_FRAME_I                      => rxCommonFrame_from_decoder,
         RX_DATA_O                              => RX_DATA_O,
         ---------------------------------------
         RX_EXTRA_FRAME_WIDEBUS_I               => rxExtraFrameWidebus_from_decoder,
         RX_EXTRA_DATA_WIDEBUS_O                => RX_EXTRA_DATA_WIDEBUS_O
      );

   --========--
   -- Status --
   --========--       
   
   status: entity work.gbt_rx_status
      generic map (
         GBT_BANK_ID                            => GBT_BANK_ID,
			NUM_LINKS										=> NUM_LINKS,
			TX_OPTIMIZATION								=> TX_OPTIMIZATION,
			RX_OPTIMIZATION								=> RX_OPTIMIZATION,
			TX_ENCODING										=> TX_ENCODING,
			RX_ENCODING										=> RX_ENCODING
		)
      port map (     
         RX_RESET_I                             => RX_RESET_I,
         RX_FRAMECLK_I                          => RX_FRAMECLK_I,
         ---------------------------------------
         RX_DESCRAMBLER_READY_I                 => ready_from_descrambler,
         RX_WORDCLK_READY_I                     => RX_WORDCLK_READY_I, 
         RX_FRAMECLK_READY_I                    => RX_FRAMECLK_READY_I,
         ---------------------------------------
         RX_READY_O                             => rxReady_from_status
      );        
   
   RX_READY_O                                   <= rxReady_from_status;
   
   --=====================================================================================--  
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--