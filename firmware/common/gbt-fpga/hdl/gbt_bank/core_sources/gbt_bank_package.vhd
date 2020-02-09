--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                       
-- Company:               CERN (PH-ESE-BE)                                                        
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by P. Vichoudis (CERN) & M. Barros Marin)                                                                                                   
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          GBT Bank package                                      
--                                                                                                 
-- Language:              VHDL'93                                                           
--                                                                                                 
-- Target Device:         Vendor agnostic                                                         
-- Tool version:                                                                          
--                                                                                                 
-- Revision:              3.2                                                                     
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        21/06/2013   1.0       M. Barros Marin   First .vhd package definition 
--
--                        04/07/2013   1.1       M. Barros Marin   Merged with Constant_Declaration.vhd
--                                                                 (Authors: F. Marin (CPPM), S. Baron (CERN))            
--
--                        12/02/2014   3.0       M. Barros Marin   Added internal modules of the GBT encoder as functions
--                                                                 (Original Verilog modules by A. Marchioro (CERN), translated to VHDL by F. Marin (CPPM)) 
--
--                        14/08/2014   3.2       M. Barros Marin   - Added constant "RX_GB_READ_DLY"
--                                                                 - Modified "rxReadyFsmStateLatOpt_T"  
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
use work.gbt_banks_user_setup.all;

--=================================================================================================--
--##################################   Package Declaration   ######################################--
--=================================================================================================--

package gbt_bank_package is  
  
   --=================================== GBT VERSION =====================================--
	
	-- Format: Major.MinorH.MinorL
	constant GBT_VERSION_MAJOR						  : std_logic_vector(7 downto 0) := x"05";	-- Major (7 downto 0)
	constant GBT_VERSION_MINOR						  : std_logic_vector(7 downto 0) := x"00";	-- MinorH (7 downto 4) / MinorL (3 downto 0)
	
   --================================ Record Declarations ================================--
   
   --===============--
   -- Clocks scheme --
   --===============--

   type gbtBankClks_i_R is
   record
      tx_frameClk                               : std_logic_vector(1 to MAX_NUM_GBT_LINK);
      rx_frameClk                               : std_logic_vector(1 to MAX_NUM_GBT_LINK);
      ------------------------------------------           
      mgt_clks                                  : gbtBankMgtClks_i_R;
   end record;     
       
   type gbtBankClks_o_R is  
   record       
      mgt_clks                                  : gbtBankMgtClks_o_R;
   end record; 
   
   --========--
   -- GBT Tx --
   --========--
      
   type gbtTx_i_R is   
   record   
      reset                                     : std_logic;
      ------------------------------------------
      isDataSel                                 : std_logic;
      ------------------------------------------         
      data                                      : std_logic_vector(83 downto 0);
      extraData_wideBus                         : std_logic_vector(31 downto 0);
   end record; 

   type gbtTx_o_R is   
   record 
      latOptGbtBank_tx                          : std_logic;
	   txGearboxAligned_o						      : std_logic;
	   txGearboxAligned_done						   : std_logic;
   end record; 
   
   --========--
   -- GBT Rx --
   --========--   
      
   type gbtRx_i_R is   
   record   
      reset                                     : std_logic;
      rxFrameClkReady                           : std_logic;
   end record;                
   
   type gbtRx_o_R is             
   record               
      latOptGbtBank_rx                          : std_logic;
      ------------------------------------------
      ready                                     : std_logic;
      ------------------------------------------        
      bitSlipNbr                                : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      ------------------------------------------        
      header_flag                               : std_logic;
      header_lockedFlag                         : std_logic;
      ------------------------------------------        
      isDataFlag                                : std_logic;
      ------------------------------------------
      data                                      : std_logic_vector(83 downto 0);
      extraData_wideBus                         : std_logic_vector(31 downto 0);
		------------------------------------------
		rxErrorDetected									: std_logic;
		rxBitModifiedCnter								: std_logic_vector(7 downto 0);
		
   end record;
   
   --==================================--
   -- Multi Gigabit Transceivers (MGT) --
   --==================================--
   
   type mgt_i_R is
   record
      mgtCommon                                 : mgtCommon_i_R;
      mgtLink                                   : mgtLink_i_R_A(1 to MAX_NUM_GBT_LINK);
   end record;  
   
   type mgt_o_R is
   record
      mgtCommon                                 : mgtCommon_o_R;
      mgtLink                                   : mgtLink_o_R_A(1 to MAX_NUM_GBT_LINK);
   end record;  
   
   --=====================================================================================--
   
   --================================= Array Declarations ================================--
   
   --========--
   -- Common --
   --========--     
   
   type data_nx84bit_A                          is array (natural range <>) of std_logic_vector(83 downto 0);    
   type extraDataWidebus_nx32bit_A              is array (natural range <>) of std_logic_vector(31 downto 0);    
   type extraDataGbt8b10b_nx4bit_A              is array (natural range <>) of std_logic_vector( 3 downto 0);    
   
   type word_mxnbit_A                           is array (natural range <>) of std_logic_vector(WORD_WIDTH-1 downto 0); 
   
	type gbt_reg8											is array (natural range <>) of std_logic_vector(7 downto 0);
	
   --========--         
   -- GBT Tx --         
   --========--            
   
   type gbtTx_i_R_A                             is array (natural range <>) of gbtTx_i_R;                              
   type gbtTx_o_R_A                             is array (natural range <>) of gbtTx_o_R;                              
   
   -- Scrambler:
   -------------
   
   type scramblerResetPatterns_21bit_A          is array (natural range <>) of std_logic_vector(20 downto 0);
   type scramblerResetPatterns_16bit_A          is array (natural range <>) of std_logic_vector(15 downto 0);
  
   -- GBT-Frame encoder:
   ---------------------

   type polyDivider_divider_15x4bit_A           is array(0 to 14) of std_logic_vector(3 downto 0);
   type polyDivider_divisor_5x4bit_A            is array(0 to  4) of std_logic_vector(3 downto 0);
   type polyDivider_quotient_11x4bit_A          is array(0 to 10) of std_logic_vector(3 downto 0);
   type polyDivider_remainder_4x4bit_A          is array(0 to  3) of std_logic_vector(3 downto 0);
   type polyDivider_net_89x4bit_A               is array(0 to 88) of std_logic_vector(3 downto 0);   
  
   --========--                                                                                       
   -- GBT Rx --               
   --========--                  
   
   type gbtRx_i_R_A                             is array (natural range <>) of gbtRx_i_R;
   type gbtRx_o_R_A                             is array (natural range <>) of gbtRx_o_R;
   
   -- GBT-Frame decoder:
   ---------------------
   
   type syndromes_alphaPower_4x60bit_A          is array(1 to  4         ) of std_logic_vector(59 downto 0); 
   type syndromes_net1_4x15x4bit_A              is array(1 to  4, 0 to 14) of std_logic_vector( 3 downto 0);
   type syndromes_net2_4x7x4bit_A               is array(1 to  4, 0 to  6) of std_logic_vector( 3 downto 0);
   type syndromes_net3_4x4x4bit_A               is array(1 to  4, 0 to  3) of std_logic_vector( 3 downto 0);
   type syndromes_net4_4x2x4bit_A               is array(1 to  4, 0 to  1) of std_logic_vector( 3 downto 0);
   type syndromes_syndrome_4x4bit_A             is array(1 to  4         ) of std_logic_vector( 3 downto 0);
   ---------------------------------------------
   type errlcpoly_invertedS_3x4bit_A            is array(1 to  3) of std_logic_vector( 3 downto 0);
   type errlcpoly_net_18x4bit_A                 is array(1 to 18) of std_logic_vector( 3 downto 0);
   ---------------------------------------------
   type rs2errcor_net_11x4bit_A                 is array(1 to 11) of std_logic_vector( 3 downto 0);
   type rs2errcor_temp_6x60bit_A                is array(1 to  6) of std_logic_vector(59 downto 0);
   ---------------------------------------------
   type gf16shift_g_4x15bit_A                   is array(0 to  3) of bit_vector(14 downto 0);  
   
   --=====================================================================================--   
   
   --========================== Finite State Machine (FSM) states ========================--
   
   --========--                                                                                       
   -- GBT Rx --               
   --========--
   
   -- GBT Rx status:
   -----------------
   
   type rxReadyFsmStateLatOpt_T                 is (s0_idle, s1_rxWordClkCheck, s2_gbtRxReadyMonitoring);

   --=====================================================================================--
   
   --=============================== Constant Declarations ===============================--
   
   --========--
   -- Common --
   --========--
   
   -- GBT-Frame header:
   --------------------
   
   constant DATA_HEADER_PATTERN                 : std_logic_vector(3 downto 0) := "0101";                   
   constant DATA_HEADER_PATTERN_REVERSED        : std_logic_vector(3 downto 0) := DATA_HEADER_PATTERN(0) &
                                                                                  DATA_HEADER_PATTERN(1) &
                                                                                  DATA_HEADER_PATTERN(2) &
                                                                                  DATA_HEADER_PATTERN(3);   
   
   constant IDLE_HEADER_PATTERN                 : std_logic_vector(3 downto 0) := "0110";                   
   constant IDLE_HEADER_PATTERN_REVERSED        : std_logic_vector(3 downto 0) := IDLE_HEADER_PATTERN(0) &
                                                                                  IDLE_HEADER_PATTERN(1) &
                                                                                  IDLE_HEADER_PATTERN(2) &
                                                                                  IDLE_HEADER_PATTERN(3);   

   -- Comment: * DESIRED_CONSEC_CORRECT_HEADERS: Number of correct headers found after which we
   --                                            declared to have found the correct boundary.
   --
   --          * NB_ACCEPTED_FALSE_HEADER: Number of false header we accept to find within "Nb_Checked_Header" 
   --                                      checked headers without declaring to have lost the boundary.
   
   constant NBR_CHECKED_HEADER                  : integer := 64;   
   constant NBR_ACCEPTED_FALSE_HEADER           : integer :=  4;
   constant DESIRED_CONSEC_CORRECT_HEADERS      : integer := 23;
   
   --========--
   -- GBT Tx -- 
   --========--
   
   -- 84bit scrambler (GBT-Frame & Wide-Bus):
   ------------------------------------------
   
   -- Comment: Value of SCRAMBLER_21BIT_RESET_PATTERNS[1:4] chosen arbitrarily except the
   --          last byte (=0 because it is OR-ed with i during multiple instantiations).
   
   constant SCRAMBLER_21BIT_RESET_PATTERNS      : scramblerResetPatterns_21bit_A := ('1' & x"A23E0",
                                                                                     '0' & x"F4350",
                                                                                     '1' & x"3EDC0",
                                                                                     '0' & x"78E20"); 

   -- 32bit scrambler (Wide-Bus):
   ------------------------------
   
   -- Comment: Value of SCRAMBLER_16BIT_RESET_PATTERNS[1:2] chosen arbitrarily except the 
   --          last byte (=0 because it is OR-ed with i during multiple instantiations).
   
   constant SCRAMBLER_16BIT_RESET_PATTERNS      : scramblerResetPatterns_16bit_A := (x"23E0",
                                                                                     x"4350");                                                                                
   
   --========--
   -- GBT Rx -- 
   --========--
   
   -- GBT-Frame decoder syndromes:
   -------------------------------
   
   constant ALPHAPOWER_S                        : syndromes_alphaPower_4x60bit_A := (x"9DFE7A5BC638421",
                                                                                     x"DEAB6829F75C341",
                                                                                     x"FAC81FAC81FAC81",
                                                                                     x"EB897C4DA62F531");
   -- GBT-Frame decider chien search:
   ----------------------------------
   
   constant ALPHAS                              : std_logic_vector(59 downto 0)  :=  x"fedcba987654321";
   
   -- GBT Rx Gearbox:
   ------------------
   
   constant RX_GB_READ_DLY                      : integer :=  5;  
   
   -- GBT Rx ready:
   ----------------
   
   constant GBT_READY_DLY                       : integer := 100;
   
   --=====================================================================================--  

   --======================== Function and Procedure Declarations ========================--
   
   --========--
   -- Common --
   --========--
   
   -- GBT-Frame encoding:
   ----------------------
   
   ---------------------------------------------------------------------------------------------------------
   function errCnter (signal   input            : in std_logic_vector( 83 downto 0)) return integer;
   ---------------------------------------------------------------------------------------------------------
   function gf16add  (signal   input1, input2   : in std_logic_vector( 3 downto 0)) return std_logic_vector;                                 
   ---------------------------------------------------------------------------------------------------------
   function gf16mult (signal   input1           : in std_logic_vector( 3 downto 0);
                      constant input2           : in std_logic_vector( 3 downto 0)) return std_logic_vector;
   ---------------------------------------------------------------------------------------------------------
   function gf16invr (signal   input            : in std_logic_vector( 3 downto 0)) return std_logic_vector;
   ---------------------------------------------------------------------------------------------------------
   function gf16loga (signal   input            : in std_logic_vector( 3 downto 0)) return std_logic_vector;
   ---------------------------------------------------------------------------------------------------------
   function gf16shift(signal   input            : in std_logic_vector(59 downto 0);
                      signal   shift            : in std_logic_vector( 3 downto 0)) return std_logic_vector;
   
   --=====================================================================================--   
end gbt_bank_package;

--=================================================================================================--
--#####################################   Package Body   ##########################################--
--=================================================================================================--

package body gbt_bank_package is

   --=========================== Function and Procedure Bodies ===========================--

   --========--
   -- Common --
   --========--
   
   -- GBT-Frame encoding:
   ----------------------
   
   function errCnter (signal   input            : in std_logic_vector( 83 downto 0)) return integer is
		variable cnter: integer range 0 to 83 := 0;
	begin 
		
		cnter := 0;
		
		cnt_loop: for i in 0 to 83 loop
			if input(i) = '1' then
				cnter := cnter + 1;
			end if;
      end loop;
		
		return cnter;
		
	end function;
	
   function gf16add(signal input1, input2 : in std_logic_vector(3 downto 0)) return std_logic_vector is
      variable output                           : std_logic_vector(3 downto 0);
   begin
      output(0)                                 := input1(0) xor input2(0);
      output(1)                                 := input1(1) xor input2(1);
      output(2)                                 := input1(2) xor input2(2);
      output(3)                                 := input1(3) xor input2(3);
      return output;
   end function;

   function gf16mult(signal   input1 : in std_logic_vector(3 downto 0);
                     constant input2 : in std_logic_vector(3 downto 0)) return std_logic_vector is       
      variable output                           : std_logic_vector(3 downto 0);
   begin
      output(0) := (input1(0) and input2(0)) xor (input1(3) and input2(1)) xor (input1(2) and input2(2)) xor (input1(1) and input2(3));
      output(1) := (input1(1) and input2(0)) xor (input1(0) and input2(1)) xor (input1(3) and input2(1)) xor (input1(2) and input2(2)) xor (input1(3) and input2(2)) xor (input1(1) and input2(3)) xor (input1(2) and input2(3));
      output(2) := (input1(2) and input2(0)) xor (input1(1) and input2(1)) xor (input1(0) and input2(2)) xor (input1(3) and input2(2)) xor (input1(2) and input2(3)) xor (input1(3) and input2(3));
      output(3) := (input1(3) and input2(0)) xor (input1(2) and input2(1)) xor (input1(1) and input2(2)) xor (input1(0) and input2(3)) xor (input1(3) and input2(3));
      return output;
   end function;  

   function gf16invr(signal input : in std_logic_vector(3 downto 0)) return std_logic_vector is
      variable output                           : std_logic_vector(3 downto 0);
   begin
      case input is
         when "0000" => output := "0000";   
         when "0001" => output := "0001";   
         when "0010" => output := "1001";   
         when "0011" => output := "1110";   
         when "0100" => output := "1101";   
         when "0101" => output := "1011";   
         when "0110" => output := "0111";   
         when "0111" => output := "0110";   
         when "1000" => output := "1111";   
         when "1001" => output := "0010";   
         when "1010" => output := "1100";   
         when "1011" => output := "0101";   
         when "1100" => output := "1010";   
         when "1101" => output := "0100";   
         when "1110" => output := "0011";   
         when "1111" => output := "1000";   
         when others => output := "0000";   -- Comment: Value selected randomly.   
      end case;      
      return output;
   end function;

   function gf16loga(signal input : in std_logic_vector(3 downto 0)) return std_logic_vector is    
      variable output                           : std_logic_vector(3 downto 0);
   begin
      case input is
         when "0000" => output := "0000";   
         when "0001" => output := "0000";   
         when "0010" => output := "0001";   
         when "0011" => output := "0100";   
         when "0100" => output := "0010";   
         when "0101" => output := "1000";   
         when "0110" => output := "0101";   
         when "0111" => output := "1010";   
         when "1000" => output := "0011";   
         when "1001" => output := "1110";   
         when "1010" => output := "1001";   
         when "1011" => output := "0111";   
         when "1100" => output := "0110";   
         when "1101" => output := "1101";   
         when "1110" => output := "1011";   
         when "1111" => output := "1100";   
         when others => output := "0000";   -- Comment: Value selected randomly. 
      end case;
      return output;
   end function; 
   
   function gf16shift(signal input : in std_logic_vector(59 downto 0); 
                      signal shift : in std_logic_vector( 3 downto 0)) return std_logic_vector is    
      variable ing                              : gf16shift_g_4x15bit_A;
      variable outg                             : gf16shift_g_4x15bit_A;                      
      variable output                           : std_logic_vector(59 downto 0);
   begin
      ing_loop1: for i in 0 to 3 loop
         ing_loop2: for j in 0 to 14 loop
            ing(i)(j)                           := to_bitvector(input)(i + j*4);
         end loop;
      end loop;
      ------------------------------------------
      outg_loop: for i in 0 to 3 loop
         outg(i)                                := ing(i) sll to_integer(unsigned(shift));   -- Comment: The operator "sll" shall be used with the type "bit_vector".
      end loop;
      ------------------------------------------
      output_loop: for i in 0 to 14 loop
         output((i*4)+3 downto i*4)             := to_stdlogicvector(outg(3)(i) & outg(2)(i) & outg(1)(i) & outg(0)(i));
      end loop;
      ------------------------------------------
      return output;
   end function;  
   
   --=====================================================================================--   
end gbt_bank_package;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--