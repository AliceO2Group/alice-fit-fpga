--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX decoder GBT-Frame Reed-Solomon decoder error location polynomial evaluation
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Vendor agnostic                                                
-- Tool version:                                                                        
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:          
--
-- Versions history:      DATE         VERSION   AUTHOR                DESCRIPTION
--
--                        12/10/2006   0.1       A. Marchioro (CERN)   First .v module definition.   
--    
--                        06/10/2008   0.2       F. Marin (CPPM)       Translate from .v to .vhd.           
--
--                        18/11/2013   3.0       M. Barros Marin       - Cosmetic and minor modifications.   
--                                                                     - "gf16mult" and "gf16add" are functions instead of modules.
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

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_rx_decoder_gbtframe_elpeval is
   port (    
      
      --========--
      -- Inputs --
      --========--
      
      ALPHA_I                                   : in  std_logic_vector( 3 downto 0);
      ERRLOCPOLY_I                              : in  std_logic_vector(11 downto 0);
      
      --=========--
      -- Outputs --
      --=========--
      
      ZERO_O                                    : out std_logic
      
   );
end gbt_rx_decoder_gbtframe_elpeval;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_decoder_gbtframe_elpeval is

   --================================ Signal Declarations ================================--
   
   signal alpha2                                : std_logic_vector(3 downto 0);   
   signal alpha3                                : std_logic_vector(3 downto 0);  
   
   signal net1                                  : std_logic_vector(3 downto 0);
   signal net2                                  : std_logic_vector(3 downto 0);
   signal net3                                  : std_logic_vector(3 downto 0);
   signal net4                                  : std_logic_vector(3 downto 0);
   signal net5                                  : std_logic_vector(3 downto 0);   
   
   --=====================================================================================--

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--      

   --======================================--
   -- Error location polynomial evaluation --
   --======================================--
   
   alpha2                                       <= gf16mult(ALPHA_I, ALPHA_I);   
   alpha3                                       <= gf16mult( alpha2, ALPHA_I);
   ---------------------------------------------
   net1                                         <= gf16mult(ERRLOCPOLY_I(11 downto 8), alpha3);   
   net2                                         <= gf16mult(ERRLOCPOLY_I( 7 downto 4), alpha2);   
   net3                                         <= gf16mult(ERRLOCPOLY_I( 3 downto 0), ALPHA_I);   
   net4                                         <= gf16add(net1, net2);   
   net5                                         <= gf16add(net3, net4);
   
   --=========--
   -- Outputs --
   --=========--
   
   ZERO_O                                       <= '1' when net5 = x"0" else '0';

   --=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--