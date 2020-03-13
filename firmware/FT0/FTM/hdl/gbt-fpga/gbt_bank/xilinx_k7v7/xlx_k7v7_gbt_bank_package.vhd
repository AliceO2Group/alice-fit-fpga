--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by P. Vichoudis (CERN) & M. Barros Marin)                                                                                                    
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Xilinx Kintex 7 & Virtex 7 - GBT Bank package                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Xilinx Kintex 7 & Virtex 7                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Revision:              3.6                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/10/2013   3.0       M. Barros Marin   First .vhd package definition    
--
--                        29/08/2014   3.2       M. Barros Marin   Moved "STABLE_CLOCK_PERIOD" to "gbt_bank_user_setup_R"
--
--                        11/09/2014   3.5       M. Barros Marin   - Added constant "RXFRAMECLK_STEPS_NBR_MAX"
--                                                                 - Changed "sysClk" for "mgtRstCtrlRefClk"
--                                                                 - Removed "eyeScanDataError"
--                                                                 - Removed allowed frequencies constants
--
--                        10/10/2014   3.6       M. Barros Marin   - Changed "rxBitSlip" to "rxBitSlip"
--                                                                 - Added new ports
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

--=================================================================================================--
--##################################   Package Declaration   ######################################--
--=================================================================================================--

package vendor_specific_gbt_bank_package is
   
   --=================================== GBT Bank setup ==================================--
   --/*/--
   --constant MAX_NUM_GBT_LINK                    : integer :=  4;
   constant MAX_NUM_GBT_LINK                    : integer :=  1; --new
   constant WORD_WIDTH                          : integer := 40; 
   constant WORD_ADDR_MSB                       : integer :=  4;
   constant WORD_ADDR_PS_CHECK_MSB              : integer :=  1;
   constant GBTRX_BITSLIP_NBR_MSB               : integer :=  5;
   constant GBTRX_BITSLIP_NBR_MAX               : integer := 39;
   constant GBTRX_BITSLIP_MIN_DLY               : integer := 40;   -- Comment: GBTRX_BITSLIP_MIN_DLY >= 32 RXUSRCLK2 cycles
   constant GBTRX_BITSLIP_MGT_RX_RESET_DELAY    : integer := 25e3;
   constant RXFRAMECLK_STEPS_MSB                : integer :=  1;
   constant RXFRAMECLK_STEPS_NBR_MAX            : integer :=  3;
   
   --=====================================================================================--
   
   --================================ Record Declarations ================================--   
   
   --====================--
   -- User setup package --
   --====================--
      
   type gbt_bank_user_setup_R is 
   record
   
      -- Number of links:
      -------------------
      
      -- Comment:   The number of links per GBT Bank is device dependant (up to FOUR links on Kintex 7 & Virtex 7).  
      
      NUM_LINKS                                 : integer;
      
      -- GBT Bank optimization:
      -------------------------

      -- Comment:   (0 -> STANDARD | 1 -> LATENCY)  
      
      TX_OPTIMIZATION                           : integer range 0 to 1; 
      RX_OPTIMIZATION                           : integer range 0 to 1; 
      
      -- GBT encodings:
      -----------------
      
      -- Comment:   (0 -> GBT_FRAME | 1 -> WIDE_BUS | 2 -> GBT_8B10B)
      
      TX_ENCODING                               : integer range 0 to 2;
      RX_ENCODING                               : integer range 0 to 2;
      
      -- GTX reference clock:
      -----------------------
      
      -- Comment:   * Allowed STANDARD GTX frequencies: 96MHz, 120MHz, 150MHz, 160MHz, 192MHz, 200MHz, 240MHz,
      --                                                300MHz, 320MHz, 400MHz, 480MHz and 600MHz   
      --  
      --            * Note!! The reference clock frequency of the LATENCY-OPTIMIZED MGT can not be set by 
      --              the user. For Kintex 7 & Virtex 7 GTX, it is fixed to 120MHz.   
      
--    STD_MGT_REFCLK_FREQ                       : integer; 
      
      -- GTX buffer bypass alignment mode: 
      ------------------------------------
      
      RX_GTX_BUFFBYPASS_MANUAL                  : boolean;
      
      -- GTX reset FSMs reference clock:
      ----------------------------------
      
      STABLE_CLOCK_PERIOD                       : integer;
      
      -- Simulation:        
      -------------- 
      
      SIMULATION                                : boolean;
   	SIM_GTRESET_SPEEDUP                       : boolean;        

   end record;  
   
   --================--
   -- GTX quad (MGT) --
   --================--
   
   -- Clocks scheme:
   -----------------
   
   type gbtBankMgtClks_i_R is
   record         
      mgtRefClk                                 : std_logic;
      ------------------------------------------
      mgtRstCtrlRefClk                          : std_logic;
      cpllLockDetClk                            : std_logic;   
      drpClk                                    : std_logic;
      ------------------------------------------
      --tx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);
      --rx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);
   end record;   
   
   type gbtBankMgtClks_o_R is
   record
      tx_wordClk                         : std_logic_vector(1 to MAX_NUM_GBT_LINK);
      tx_outclkfabric                    : std_logic_vector(1 to MAX_NUM_GBT_LINK);         
      rx_wordClk                         : std_logic_vector(1 to MAX_NUM_GBT_LINK);         
   end record;   

   -- Common I/O:
   --------------
   
   -- Comment: GTX in Kintex 7 and Virtex 7 do not share any control port.
   
   type mgtCommon_i_R is
   record
      dummy_i                                   : std_logic;                                         
   end record;   
   
   type mgtCommon_o_R is
   record
      dummy_o                                   : std_logic;                                         
   end record;      
   
   -- Links I/O:
   -------------
   
   type mgtLink_i_R is
   record
      rx_p                                      : std_logic;                                 
      rx_n                                      : std_logic;         
      ------------------------------------------     
      loopBack                                  : std_logic_vector( 2 downto 0);              
      ------------------------------------------
      tx_reset                                  : std_logic; 
      rx_reset                                  : std_logic;             
      ------------------------------------------
      rxBitSlip_enable                          : std_logic; 
      rxBitSlip_ctrl                            : std_logic; 
      rxBitSlip_nbr                             : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      rxBitSlip_run                             : std_logic;
      rxBitSlip_oddRstEn                        : std_logic;
      ------------------------------------------               
      conf_diffCtrl                             : std_logic_vector( 3 downto 0);
      conf_postCursor                           : std_logic_vector( 4 downto 0);
      conf_preCursor                            : std_logic_vector( 4 downto 0);
      conf_txPol                                : std_logic;
      conf_rxPol                                : std_logic;
      ------------------------------------------      
      drp_addr                                  : std_logic_vector( 8 downto 0);  
      drp_en                                    : std_logic;   
      drp_di                                    : std_logic_vector(15 downto 0); 
      drp_we                                    : std_logic;      
      ------------------------------------------      
      prbs_txSel                                : std_logic_vector( 2 downto 0);
      prbs_rxSel                                : std_logic_vector( 2 downto 0);
      prbs_txForceErr                           : std_logic;
      prbs_rxCntReset                           : std_logic;       
   end record;

   type mgtLink_o_R is
   record
      tx_p                                      : std_logic;
      tx_n                                      : std_logic;
      ------------------------------------------                  
      cpllLock                                  : std_logic;
      ------------------------------------------                  
      tx_resetDone                              : std_logic;      
      rx_resetDone                              : std_logic;      
      tx_fsmResetDone                           : std_logic; 
      rx_fsmResetDone                           : std_logic; 
      ------------------------------------------
      rxCdrLock                                 : std_logic; 
      ------------------------------------------
      rx_phMonitor                              : std_logic_vector(4 downto 0);
      rx_phSlipMonitor                          : std_logic_vector(4 downto 0);  
      ------------------------------------------
      rxBitSlip_oddRstNbr                       : std_logic_vector(7 downto 0);
      ------------------------------------------            
      rxWordClkReady                            : std_logic;      
      ------------------------------------------
      ready                                     : std_logic;
      ------------------------------------------                  
      drp_rdy                                   : std_logic;  
      drp_do                                    : std_logic_vector(15 downto 0);      
      ------------------------------------------                  
      prbs_rxErr                                : std_logic;
   end record;   
   
   --=====================================================================================-- 
   
   --================================= Array Declarations ================================--
   
   --====================--
   -- User setup package --
   --====================--   
   
   type integer_A                               is array (natural range <>) of integer;   
   
   type gbtframe_A                   				is array (natural range <>) of std_logic_vector(83  downto 0);
   type wbframe_A				                     is array (natural range <>) of std_logic_vector(115 downto 0);
   type wbframe_extra_A		                     is array (natural range <>) of std_logic_vector(31  downto 0);
	
   --====================--
   -- User setup package --
   --====================--   
   
   type gbt_bank_user_setup_R_A                 is array (natural range <>) of gbt_bank_user_setup_R;   
   
   --================--
   -- GTX quad (MGT) --
   --================--
   
   type mgtLink_i_R_A                           is array (natural range <>) of mgtLink_i_R;                          
   type mgtLink_o_R_A                           is array (natural range <>) of mgtLink_o_R;    
   
   type gtxTxDiffCtrl_nx4bit_A                  is array (natural range <>) of std_logic_vector( 3 downto 0); 
   type gtxTxCursor_nx5bit_A                    is array (natural range <>) of std_logic_vector( 4 downto 0); 
   ---------------------------------------------
   type gtxDrpAddr_nx8bit_A                     is array (natural range <>) of std_logic_vector( 7 downto 0); 
   type gtxDrpData_nx16bit_A                    is array (natural range <>) of std_logic_vector(15 downto 0); 
   ---------------------------------------------       
   type gtxLoopBack_nx3bit_A                    is array (natural range <>) of std_logic_vector( 2 downto 0); 
   ---------------------------------------------       
   type gtxPrbsSel_nx3bit_A                     is array (natural range <>) of std_logic_vector( 2 downto 0); 
   
   type rxBitSlipNbr_mxnbit_A                   is array (natural range <>) of std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
   type rxBitSlipRstNbr_nx16bit_A               is array (natural range <>) of std_logic_vector(15 downto 0);
   
   type mgtRefClkConf_bitVector_8x8bit_A        is array (0 to 7) of bit_vector(7 downto 0);
   type mgtRefClkConf_integer_8x32bitA          is array (0 to 7) of integer;     

   --=====================================================================================--   
   
   --========================== Finite State Machine (FSM) states ========================--
   
   --========--                                                                                       
   -- GBT Rx --               
   --========--

   -- GBT Rx bitslip:
   -----------------

   type rxBitSlipCtrlStateLatOpt_T is (e0_idle, e1_evenOrOdd, e2_gtxRxReset, e3_bitslipOrFinish, e4_doBitslip, e5_waitNcycles);

   --=====================================================================================--
   
   --=============================== Constant Declarations ===============================--
  
   --====================--
   -- User setup package --
   --====================--
   -- Common:
	----------
	constant ENABLED										: integer := 1;
	constant DISABLED										: integer := 0;
	
   -- Optimization:
   ----------------
   
   constant STANDARD                            : integer := 0;
   constant LATENCY_OPTIMIZED                   : integer := 1;
   
   -- Encoding:
   ------------
   
   constant GBT_FRAME                           : integer := 0;
   constant WIDE_BUS                            : integer := 1;
   constant GBT_8B10B                           : integer := 2;
   
   --================--
   -- GTX quad (MGT) --
   --================-- 
   
   -- Common:
   ----------
   
   constant DLY                                 : time    :=  1 ns;
   constant QPLL_FBDIV_TOP                      : integer := 16;
   
   --======================== Function and Procedure Declarations ========================--
   
   --================--
   -- GTX quad (MGT) --
   --================-- 
   
   -- Common:
   ----------
   
   function speedUp(constant simGtesetSpeedup               : in boolean) return string;
   -------------------------------------------------------------------------------------
   function getCdrLockTime(constant isSim                   : in boolean) return integer;
   --------------------------------------------------------------------------------------
   impure function convQpllFbDivTop(constant qpllFbDivTop   : in integer) return bit_vector;
   -----------------------------------------------------------------------------------------
   impure function convQpllFbDivRatio(constant qpllFbDivTop : in integer) return bit;
  
   -- Latency- optimized:
   ----------------------
   
   function txGtxBuffBypassManual(constant numLinks         : in integer) return boolean;       
   --------------------------------------------------------------------------------------
   function rxGtxBuffBypassManual(constant manual           : in boolean;
                                  constant numLinks         : in integer) return boolean; 
   --------------------------------------------------------------------------------------
   function orGate(signal signalBus                         : in std_logic_vector) return std_logic; 

   --=====================================================================================--   
end vendor_specific_gbt_bank_package;

--=================================================================================================--
--#####################################   Package Body   ##########################################--
--=================================================================================================--

package body vendor_specific_gbt_bank_package is

   --=========================== Function and Procedure Bodies ===========================--
   
   --================--
   -- GTX quad (MGT) --
   --================-- 
   
   -- Common:
   ----------
   
   function speedUp(constant simGteSetSpeedup : in boolean) return string is 
      constant TEMP_TRUE                        : string(1 to 4) := "TRUE";  
      constant TEMP_FALSE                       : string(1 to 5) := "FALSE";  
   begin                                          
      if simGtesetSpeedup = true then             
         return TEMP_TRUE;                        
      elsif simGtesetSpeedup = false then         
         return TEMP_FALSE;                       
      end if;                                     
   end function;         
   
   function getCdrLockTime(constant isSim : in boolean) return integer is
      variable lockTime                         : integer;
   begin                                         
      if isSim = true then                      
         lockTime                               := 1000;
      else                                       
         lockTime                               := 50000 / integer(4.8);   -- Comment: Typical CDR lock time is 50,000UI as per DS183.
      end if;                                    
      return lockTime;                          
   end function;          
   
   impure function convQpllFbDivTop(constant qpllFbDivTop : in integer) return bit_vector is
   begin
      if qpllfbdivTop = 16 then
         return "0000100000";
      elsif qpllfbdivTop = 20 then
         return "0000110000";
      elsif qpllfbdivTop = 32 then
         return "0001100000";
      elsif qpllfbdivTop = 40 then
         return "0010000000";
      elsif qpllfbdivTop = 64 then
         return "0011100000";
      elsif qpllfbdivTop = 66 then
         return "0101000000";
      elsif qpllfbdivTop = 80 then
         return "0100100000";
      elsif qpllfbdivTop = 100 then
         return "0101110000";
      else 
         return "0000000000";
      end if;
   end function;

   impure function convQpllFbDivRatio (constant qpllFbDivTop : in integer) return bit is
   begin
      if qpllFbDivTop = 16 then
         return '1';
      elsif qpllFbDivTop = 20 then
         return '1';
      elsif qpllFbDivTop = 32 then
         return '1';
      elsif qpllFbDivTop = 40 then
         return '1';
      elsif qpllFbDivTop = 64 then
         return '1';
      elsif qpllFbDivTop = 66 then
         return '0';
      elsif qpllFbDivTop = 80 then
         return '1';
      elsif qpllFbDivTop = 100 then
         return '1';
      else 
         return '1';
      end if;
   end function; 

   -- Latency- optimized:
   ----------------------
   
   function txGtxBuffBypassManual(constant numLinks : in integer) return boolean is 
   begin 
      if numLinks > 1 then  
         return true;                       
      elsif numLinks = 1 then 
         return false;                      
      end if;  
   end function;      
 
   function rxGtxBuffBypassManual(constant manual   : in boolean;
                                  constant numLinks : in integer) return boolean is 
   begin 
      if (manual = true) and (numLinks > 1) then  
         return true;                       
      else 
         return false;                      
      end if;  
   end function;
   
   function orGate(signal signalBus : in std_logic_vector) return std_logic is 
   begin
      for i in 1 to signalBus'length loop
         if signalBus(i) = '1' then  
            return '1';                       
         else 
            return '0';                      
         end if;  
      end loop;
   end function;
   
   --=====================================================================================--   
end vendor_specific_gbt_bank_package;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--