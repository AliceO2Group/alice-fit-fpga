--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                        
-- Company:               CERN (PH-ESE-BE)                                                        
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX decoder GBT-Frame Reed-Solomon decoder chien search
--                                                                                                
-- Language:              VHDL'93                                                              
--                                                                                                  
-- Target Device:         Vendor agnostic                                                
-- Tool version:                                                                        
--                                                                                                  
-- Version:               3.1                                                                      
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
--                                                                     - Remove "pri_encoderR" and "pri_encoderL" modules.
--                                                                     - "gf16inverse" is function instead of modules.
--
--                        02/04/2015   3.1       S.D. Goadhouse        - Made comparison constants the same bit size as
--                                                                       zero_from_errLocPolyEval. Libero/Synopsis says
--                                                                       that if they are different sizes, the
--                                                                       comparison is always FALSE.
--
--                        02/04/2015   4.1       J. Mendez             - Correction of a major bug in generation of the
--                                                                       out_from_primEncRight and out_from_primEncLeft
--                                                                       values.
--                        
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
 
entity gbt_rx_decoder_gbtframe_chnsrch is
   port (
     
      --========--
      -- Inputs --
      --========--
     
      ERROR_1_LOC_I                             : in  std_logic_vector(3 downto 0);
      ERROR_2_LOC_I                             : in  std_logic_vector(3 downto 0);
      DET_IS_ZERO_I                             : in  std_logic;
     
      --=========--
      -- Outputs --
      --=========--
     
      XX0_O                                     : out std_logic_vector(3 downto 0);
      XX1_O                                     : out std_logic_vector(3 downto 0)
     
   );
end gbt_rx_decoder_gbtframe_chnsrch;
 
--=================================================================================================--
--####################################   Architecture   ###########################################--
--=================================================================================================--
 
architecture behavioral of gbt_rx_decoder_gbtframe_chnsrch is
 
   --================================ Signal Declarations ================================--
   
   --===========================--
   -- Error location polynomial --
   --===========================--
   
   signal errorLocationPolynomial               : std_logic_vector(11 downto 0);
   
   --======================================--
   -- Error location polynomial evaluation --
   --======================================--
   
   signal zero_from_errLocPolyEval              : std_logic_vector(14 downto 0);
   
   --==================--
   -- Primary encoders --
   --==================--
   
   signal out_from_primEncRight                 : std_logic_vector(3 downto 0);
   signal out_from_primEncLeft                  : std_logic_vector(3 downto 0);
 
   --=====================================================================================--
 
--=================================================================================================--
begin                 --========####   Architecture Body   ####========--
--=================================================================================================--
   
   --==================================== User Logic =====================================--      
   
   --===========================--
   -- Error location polynomial --
   --===========================--
   
   errorLocationPolynomial                      <= (ERROR_2_LOC_I & ERROR_1_LOC_I & x"1") when DET_IS_ZERO_I = '0' else
                                                   --------------------------------------------------------------------
                                                   (x"0" & ERROR_1_LOC_I & x"1");  
 
   --======================================--
   -- Error location polynomial evaluation --
   --======================================--
   
   errLocPolyEval_gen: for i in 0 to 14 generate
   
      errLocPolyEval: entity work.gbt_rx_decoder_gbtframe_elpeval
         port map (
            ALPHA_I                             => ALPHAS((4*i)+3 downto 4*i),
            ERRLOCPOLY_I                        => errorLocationPolynomial,
            ZERO_O                              => zero_from_errLocPolyEval(i)
         );
 
   end generate;
 
   --==================--
   -- Primary encoders --
   --==================--
   
   -- Primary encoder right:
   -------------------------			
					
   out_from_primEncRight <= "0001" when (zero_from_errLocPolyEval(0) = '1') else
                            "0010" when (zero_from_errLocPolyEval(1 DOWNTO 0)  = "10") else
                            "0011" when (zero_from_errLocPolyEval(2 DOWNTO 0)  = "100") else
                            "0100" when (zero_from_errLocPolyEval(3 DOWNTO 0)  = "1000") else
                            "0101" when (zero_from_errLocPolyEval(4 DOWNTO 0)  = "10000") else
                            "0110" when (zero_from_errLocPolyEval(5 DOWNTO 0)  = "100000") else
                            "0111" when (zero_from_errLocPolyEval(6 DOWNTO 0)  = "1000000") else
                            "1000" when (zero_from_errLocPolyEval(7 DOWNTO 0)  = "10000000") else
                            "1001" when (zero_from_errLocPolyEval(8 DOWNTO 0)  = "100000000") else
                            "1010" when (zero_from_errLocPolyEval(9 DOWNTO 0)  = "1000000000") else
                            "1011" when (zero_from_errLocPolyEval(10 DOWNTO 0) = "10000000000") else
                            "1100" when (zero_from_errLocPolyEval(11 DOWNTO 0) = "100000000000") else
                            "1101" when (zero_from_errLocPolyEval(12 DOWNTO 0) = "1000000000000") else
                            "1110" when (zero_from_errLocPolyEval(13 DOWNTO 0) = "10000000000000") else
                            "1111" when (zero_from_errLocPolyEval(14 DOWNTO 0) = "100000000000000") else
                            "0000";              
   
   -- Primary encoder left:
   ------------------------
   
    out_from_primEncLeft <= "1111" when (zero_from_errLocPolyEval(14) = '1') else
                            "1110" when (zero_from_errLocPolyEval(14 DOWNTO 13) = "01") else
                            "1101" when (zero_from_errLocPolyEval(14 DOWNTO 12) = "001") else
                            "1100" when (zero_from_errLocPolyEval(14 DOWNTO 11) = "0001") else
                            "1011" when (zero_from_errLocPolyEval(14 DOWNTO 10) = "00001") else
                            "1010" when (zero_from_errLocPolyEval(14 DOWNTO 9)  = "000001") else
                            "1001" when (zero_from_errLocPolyEval(14 DOWNTO 8)  = "0000001") else
                            "1000" when (zero_from_errLocPolyEval(14 DOWNTO 7)  = "00000001") else
                            "0111" when (zero_from_errLocPolyEval(14 DOWNTO 6)  = "000000001") else
                            "0110" when (zero_from_errLocPolyEval(14 DOWNTO 5)  = "0000000001") else
                            "0101" when (zero_from_errLocPolyEval(14 DOWNTO 4)  = "00000000001") else
                            "0100" when (zero_from_errLocPolyEval(14 DOWNTO 3)  = "000000000001") else
                            "0011" when (zero_from_errLocPolyEval(14 DOWNTO 2)  = "0000000000001") else
                            "0010" when (zero_from_errLocPolyEval(14 DOWNTO 1)  = "00000000000001") else
                            "0001" when (zero_from_errLocPolyEval = "000000000000001") else
                            "0000";  
   --========--  
   -- Output --
   --========--
 
   XX0_O                                        <= gf16invr(out_from_primEncRight);  
   XX1_O                                        <= gf16invr(out_from_primEncLeft);
 
   --=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--