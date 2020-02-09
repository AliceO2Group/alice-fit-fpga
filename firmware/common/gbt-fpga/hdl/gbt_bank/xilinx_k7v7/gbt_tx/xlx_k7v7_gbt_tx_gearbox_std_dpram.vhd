--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Kintex 7 & Virtex 7 - GBT TX gearbox standard DPRAM  
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Xilinx Kintex 7 & Virtex 7                                                   
-- Tool version:          ISE 14.5                                                                   
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--                                                                  
--                        26/11/2013   3.0       M. Barros Marin   First .vhd module definition.
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

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_tx_gearbox_std_dpram is
   port (
      
      --=================--
      -- Write interface --
      --=================--
      
      WR_CLK_I                                  : in  std_logic;
      WR_ADDRESS_I                              : in  std_logic_vector(  2 downto 0);
      WR_DATA_I                                 : in  std_logic_vector(119 downto 0);
      
      --================--
      -- Read interface --
      --================--
      
      RD_CLK_I                                  : in  std_logic;
      RD_ADDRESS_I                              : in  std_logic_vector(  4 downto 0);
      RD_DATA_O                                 : out std_logic_vector( 39 downto 0)
      
   );
end gbt_tx_gearbox_std_dpram;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_tx_gearbox_std_dpram is
  
   --================================ Signal Declarations ================================--
  
   signal writeData                             : std_logic_vector(159 downto 0);
   
   --=====================================================================================--
     
     COMPONENT xlx_k7v7_tx_dpram
        PORT (
          clka : IN STD_LOGIC;
          wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
          addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          dina : IN STD_LOGIC_VECTOR(159 DOWNTO 0);
          clkb : IN STD_LOGIC;
          addrb : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
          doutb : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)
        );
      END COMPONENT;
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  
   
   --==================================== User Logic =====================================--

   writeData                                    <= x"0000000000" & WR_DATA_I;

   dpram: xlx_k7v7_tx_dpram
      port map (
         CLKA                                   => WR_CLK_I,
         WEA(0)                                 => '1',
         ADDRA                                  => WR_ADDRESS_I,
         DINA                                   => writeData,
         CLKB                                   => RD_CLK_I,
         ADDRB                                  => RD_ADDRESS_I,
         DOUTB                                  => RD_DATA_O
      );

   --=====================================================================================--         
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--