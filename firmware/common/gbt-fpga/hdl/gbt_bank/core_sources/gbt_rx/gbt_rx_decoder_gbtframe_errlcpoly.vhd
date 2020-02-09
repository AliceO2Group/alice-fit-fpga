--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX decoder GBT-Frame Reed-Solomon decoder error location polynomial
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Vendor agnostic                                                
-- Tool version:                                                                        
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:           Computation of the error locator polynomials for the GBT-Frame encoding.
--
-- Versions history:      DATE         VERSION   AUTHOR                DESCRIPTION
--
--                        12/10/2006   0.1       A. Marchioro (CERN)   First .v module definition.   
--    
--                        06/10/2008   0.2       F. Marin (CPPM)       Translate from .v to .vhd.           
--
--                        18/11/2013   3.0       M. Barros Marin       - Cosmetic and minor modifications.   
--                                                                     - Remove "error1locpolynomial" and "error1locpolynomial" modules.
--                                                                     - "gf16mult", "gf16add" and "gf16inverse" are functions instead of modules.
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

entity gbt_rx_decoder_gbtframe_errlcpoly is
   port (
      
      --========--
      -- Inputs --
      --========--
      
      S1_I                                      : in  std_logic_vector(3 downto 0);
      S2_I                                      : in  std_logic_vector(3 downto 0);
      S3_I                                      : in  std_logic_vector(3 downto 0);
      S4_I                                      : in  std_logic_vector(3 downto 0);
      DET_IS_ZERO_I                             : in  std_logic;
      
      --=========--
      -- Outputs --
      --=========--
      
      ERROR_1_LOC_O                             : out std_logic_vector(3 downto 0);
      ERROR_2_LOC_O                             : out std_logic_vector(3 downto 0)     
      
   );
end gbt_rx_decoder_gbtframe_errlcpoly;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_decoder_gbtframe_errlcpoly is

   --================================ Signal Declarations ================================--
  
   signal location1b                            : std_logic_vector(3 downto 0);
   signal location1a                            : std_logic_vector(3 downto 0);
   signal location2a                            : std_logic_vector(3 downto 0);
      
   signal invertedS                             : errlcpoly_invertedS_3x4bit_A;
   signal net                                   : errlcpoly_net_18x4bit_A;
   signal invertedNet14                         : std_logic_vector(3 downto 0);
   
   --=====================================================================================--
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--      

   --==============================--
   -- Error 1 location  polynomial --
   --==============================--   
  
   invertedS(1)                                 <= gf16invr(S1_I);   
   location1b                                   <= gf16mult(invertedS(1),S2_I);        

   --==============================--
   -- Error 2 location  polynomial --
   --==============================--                   

   invertedS(2)                                 <= gf16invr(S2_I);      
   invertedS(3)                                 <= gf16invr(S3_I);  
   invertedNet14                                <= gf16invr(net(14));                 
   ---------------------------------------------
   net(1)                                       <= gf16mult(S3_I,S3_I);      
   net(3)                                       <= gf16mult(S1_I,S3_I);   
   net(6)                                       <= gf16mult(net(1),invertedS(2));      
   net(7)                                       <= gf16mult(invertedS(2),net(3));   
   net(9)                                       <= gf16mult(S3_I,invertedS(2));  
   net(10)                                      <= gf16mult(invertedS(2),S1_I);      
   net(11)                                      <= gf16mult(invertedS(3),S4_I);            
   net(12)                                      <= gf16mult(S3_I,invertedS(1));            
   net(17)                                      <= gf16mult(net(13),invertedNet14);            
   net(16)                                      <= gf16mult(net(17),net(10));            
   net(18)                                      <= gf16add(net(9),net(16));            
   net(13)                                      <= gf16add(S4_I,net(6));      
   net(14)                                      <= gf16add(net(7),S2_I);
   ---------------------------------------------
   location1a                                   <= net(11) when S2_I = x"0" else net(18);
   location2a                                   <= net(12) when S2_I = x"0" else net(17);  
   
   --=========--
   -- Outputs --
   --=========--   
   
   ERROR_1_LOC_O                                <= location1b when DET_IS_ZERO_I = '1' else location1a;
   ERROR_2_LOC_O                                <= x"0"       when DET_IS_ZERO_I = '1' else location2a; 
   
   --=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--