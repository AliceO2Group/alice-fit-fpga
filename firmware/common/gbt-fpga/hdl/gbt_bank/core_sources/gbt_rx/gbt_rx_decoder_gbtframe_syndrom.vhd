--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX decoder GBT-Frame Reed-Solomon decoder syndromes
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
--                        07/10/2008   0.2       F. Marin (CPPM)       Translate from .v to .vhd.           
--
--                        18/11/2013   3.0       M. Barros Marin       - Cosmetic and minor modifications.   
--                                                                     - "gf16mult" and "gf16add" are functions instead of modules.
--                                                                     - Use of process instead of "syndrome_evaluator" .vhd module.
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

entity gbt_rx_decoder_gbtframe_syndrom is
   port (
   
      --=======--
      -- Input --
      --=======--
   
      POLY_COEFFS_I                             : in  std_logic_vector(59 downto 0);
   
      --=========--
      -- Outputs --
      --=========--
   
      S1_O                                      : out std_logic_vector( 3 downto 0);
      S2_O                                      : out std_logic_vector( 3 downto 0);
      S3_O                                      : out std_logic_vector( 3 downto 0);
      S4_O                                      : out std_logic_vector( 3 downto 0)
      
   );
end gbt_rx_decoder_gbtframe_syndrom;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_decoder_gbtframe_syndrom is

   --================================ Signal Declarations ================================--
   
   signal net1                                  : syndromes_net1_4x15x4bit_A; 
   signal net2                                  : syndromes_net2_4x7x4bit_A;
   signal net3                                  : syndromes_net3_4x4x4bit_A;
   signal net4                                  : syndromes_net4_4x2x4bit_A; 
   ---------------------------------------------
   signal syndrome_from_syndromeEvaluator       : syndromes_syndrome_4x4bit_A;

   --=====================================================================================--   
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--      

   --====================--
   -- Syndrome evaluator --
   --====================--   
   
   syndromeEvaluator_gen: for i in 1 to 4 generate   
   
      net1_gen: for j in 0 to 14 generate
         net1(i,j)                              <= gf16mult(POLY_COEFFS_I(59-(4*j) downto 56-(4*j)),ALPHAPOWER_S(i)(59-(4*j) downto 56-(4*j)));      
      end generate;
      
      net2_gen: for j in 0 to 6 generate
         net2(i,j)                              <= gf16add(net1(i,((2*j)+1)),net1(i,(2*j)));         
      end generate;
      
      net3_gen: for j in 0 to 2 generate
         net3(i,j)                              <= gf16add(net2(i,((2*j)+1)),net2(i,(2*j)));
      end generate;
      
      net3(i,3)                                 <= gf16add(net1(i,14),net2(i,6));
        
      net4_gen: for j in 0 to 1 generate
         net4(i,j)                              <= gf16add(net3(i,((2*j)+1)),net3(i,(2*j)));        
      end generate;
      
      syndrome_from_syndromeEvaluator(i)        <=  gf16add(net4(i,1),net4(i,0)); 

   end generate;
   
   --=========--
   -- Outputs --
   --=========--
   
   S1_O                                         <= syndrome_from_syndromeEvaluator(1);
   S2_O                                         <= syndrome_from_syndromeEvaluator(2);
   S3_O                                         <= syndrome_from_syndromeEvaluator(3);
   S4_O                                         <= syndrome_from_syndromeEvaluator(4);

   --=====================================================================================--      
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--