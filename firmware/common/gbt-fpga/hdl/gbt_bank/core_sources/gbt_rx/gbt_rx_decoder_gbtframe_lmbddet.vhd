--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX decoder GBT-Frame Reed-Solomon decoder lambda determinant
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Vendor agnostic                                                
-- Tool version:                                                                        
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:           This circuit computes the lambda determinant needed for correcting errors for Reed Solomon codec for GBT-Frame encoding. 
--
-- Versions history:      DATE         VERSION   AUTHOR                DESCRIPTION
--
--                        12/10/2006   0.1       A. Marchioro (CERN)   First .v module definition.   
--    
--                        03/10/2008   0.2       F. Marin (CPPM)       Translate from .v to .vhd.           
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

entity gbt_rx_decoder_gbtframe_lmbddet is
   port (
   
      --========--
      -- Inputs --
      --========--
      
      S1_I                                      : in  std_logic_vector(3 downto 0);
      S2_I                                      : in  std_logic_vector(3 downto 0);
      S3_I                                      : in  std_logic_vector(3 downto 0);
      
      --========--
      -- Output --
      --========--
      
      DET_IS_ZERO_O                             : out std_logic
      
   );
end gbt_rx_decoder_gbtframe_lmbddet;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_decoder_gbtframe_lmbddet is

   --================================ Signal Declarations ================================--

   --=============--
   -- Multipliers --
   --=============--

   signal mult1_out                             : std_logic_vector(3 downto 0);
   signal mult2_out                             : std_logic_vector(3 downto 0);

   --=======--
   -- Adder --
   --=======--
   
   signal add_out                               : std_logic_vector(3 downto 0);   
   
   --=====================================================================================--   
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--      

   --=============--
   -- Multipliers --
   --=============--

   mult1_out                                    <= gf16mult(S2_I,S3_I);
   mult2_out                                    <= gf16mult(S1_I,S2_I);      
   
   --=======--
   -- Adder --
   --=======--
   
   add_out                                      <= gf16add(mult1_out, mult2_out);
   
   --=============--
   -- Determinant --
   --=============--
   
   DET_IS_ZERO_O                                <= '1' when add_out = "0000" else '0'; 
   
   --=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--