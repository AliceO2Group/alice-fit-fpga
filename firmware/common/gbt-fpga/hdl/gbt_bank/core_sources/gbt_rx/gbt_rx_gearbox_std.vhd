--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX gearbox standard
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Vendor agnostic                                                      
-- Tool version:                                                                             
--                                                                                                   
-- Version:               3.2                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--                                                                  
--                        10/05/2009   0.1       F. Marin (CPPM)   First .BDF entity definition           
--
--                        08/07/2009   0.2       S. Baron (CERN)   Translate from .bdf to .vhd
--
--                        04/07/2013   3.0       M. Barros Marin   - Cosmetic and minor modifications
--                                                                 - Support for 20bit and 40bit words
--
--                        03/08/2014   3.2       M. Barros Marin   Removed port "RX_WORDCLK_I" from "readControl"
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

entity gbt_rx_gearbox_std is
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
      
      RX_HEADER_LOCKED_I                        : in  std_logic;
      RX_WRITE_ADDRESS_I                        : in  std_logic_vector(WORD_ADDR_MSB downto 0);
      READY_O                                   : out std_logic;
      
      --==============--
      -- Word & Frame --
      --==============--
      
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      RX_FRAME_O                                : out std_logic_vector(119 downto 0)      

   );
end gbt_rx_gearbox_std;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_rx_gearbox_std is   
   
   --================================ Signal Declarations ================================--   
   
   --==============--
   -- Read control --
   --==============--
   
   signal readAddress_from_readControl          : std_logic_vector(  2 downto 0);
   signal ready_from_readControl                : std_logic;   
   
   --=======--
   -- DPRAM --
   --=======--
   
   signal rxFrame_from_dpram                    : std_logic_vector(119 downto 0);
   
   --================--
   -- Frame inverter --
   --================--
   
   signal rxFrame_from_frameInverter            : std_logic_vector(119 downto 0);
   
   --=====================================================================================--         

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  
   
   --==================================== User Logic =====================================-- 
   
   --==============--
   -- Read control --
   --==============--
   
   readControl: entity work.gbt_rx_gearbox_std_rdctrl
      port map (
         RX_RESET_I                             => RX_RESET_I,
         RX_FRAMECLK_I                          => RX_FRAMECLK_I,
         ---------------------------------------
         RX_HEADER_LOCKED_I                     => RX_HEADER_LOCKED_I,
         READ_ADDRESS_O                         => readAddress_from_readControl,
         READY_O                                => ready_from_readControl
      );
   
   --=======--
   -- DPRAM --
   --=======--
   
   dpram: entity work.gbt_rx_gearbox_std_dpram
      port map   (
         WR_EN_I                                => RX_HEADER_LOCKED_I,        
         WR_CLK_I                               => RX_WORDCLK_I,
         WR_ADDRESS_I                           => RX_WRITE_ADDRESS_I,   
         WR_DATA_I                              => RX_WORD_I,
         ---------------------------------------
         RD_CLK_I                               => RX_FRAMECLK_I,
         RD_ADDRESS_I                           => readAddress_from_readControl,
         RD_DATA_O                              => rxFrame_from_dpram
      );
   
   --================--
   -- Frame inverter --
   --================--
   
   frameInverter: for i in 119 downto 0 generate
      rxFrame_from_frameInverter(i)             <= rxFrame_from_dpram(119-i);
   end generate;   
   
   --==================--
   -- Output registers --
   --==================--
   
   regs: process(RX_RESET_I, RX_FRAMECLK_I)
   begin
      if RX_RESET_I = '1' then
         READY_O                                <= '0';
         RX_FRAME_O                             <= (others => '0');
      elsif rising_edge(RX_FRAMECLK_I) then
         READY_O                                <= ready_from_readControl;      
         RX_FRAME_O                             <= rxFrame_from_frameInverter;
      end if;
   end process;    

   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--