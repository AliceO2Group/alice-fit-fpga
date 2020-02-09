--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)                            
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX frame aligner pattern search
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Device agnostic                                                         
-- Tool version:                                                                       
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:           Searches 4-bits header pattern in the 4 LSB of a 120-bits word. The MSB of the header being the
--                        bit 0 and its LSB the bit 3. The header pattern can be the idle or data header pattern.
--                        If more than "Nb_Accepted_falseHeader" are found in "Nb_checkedHeader" checked header, a bit slip
--                        command is sent and the RX_HEADER_LOCKED_O state is set low. If more than "Desired_consecCorrectHeaders"
--                        correct consecutive headers are found, the RX_HEADER_LOCKED_O state is proclaimed.
--   
-- Versions history:      DATE         VERSION   AUTHOR                               DESCRIPTION
--
--                        25/09/2008   0.1       F. Marin (CPPM)                      First .vhd entity definition.
--
--                        07/04/2009   0.2       F. Marin (CPPM)                      Modification.
--
--                        02/11/2010   0.3       S. Muschter (Stockholm University)   Dataflow and counters optimized for low latency.
--
--                        04/07/2012   3.0       M. Barros Marin                      - Cosmetic and minor modifications.
--                                                                                    - Support for 20bit and 40bit words.
--                                                                                    - Uses "gbt_bank_package.vhd" instead of "Constant_Declaration.vhd".
--                                                                                    - Removed gearbox address control.
--
--                        26/05/2016	4.1		 P. Vicente Leitao (CERN)			  - Rewritten code to implement safe state-machine	
--                                                                                    - Optimized bitslip
--                                                                                    - Bug fixes
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
use work.vendor_specific_gbt_bank_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_rx_framealigner_pattsearch is
   port (   
      
      --===============--
      -- Reset & Clock --
      --===============--    
      
      -- Reset:
      ---------
      
      RX_RESET_I                                : in  std_logic;    
      
      -- Clock:
      ---------
      
      RX_WORDCLK_I                              : in  std_logic;      
      
      --=========--
      -- Control --
      --=========--
      
      RIGHTSHIFTER_READY_I                      : in  std_logic;
      RX_WRITE_ADDRESS_I                        : in  std_logic_vector(WORD_ADDR_MSB downto 0);
      RX_BITSLIP_CMD_O                          : out std_logic;    
      RX_HEADER_LOCKED_O                        : out std_logic;   
      RX_HEADER_FLAG_O                          : out std_logic; 
      RX_GB_WRITE_ADDRESS_RST_O                 : out std_logic;
      
      --======--
      -- Word --
      --======--
      
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);       
      RX_WORD_O                                 : out std_logic_vector(WORD_WIDTH-1 downto 0) 
      
   );  
end gbt_rx_framealigner_pattsearch;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_framealigner_pattsearch is
  
   --================================ Signal Declarations ================================--  

   signal checkedHeader                         : integer range 0 to NBR_CHECKED_HEADER;
   signal falseHeader                           : integer range 0 to NBR_ACCEPTED_FALSE_HEADER;
   signal consecCorrectHeaders                  : integer range 0 to DESIRED_CONSEC_CORRECT_HEADERS;
   signal headerLocked                          : std_logic;
   
   signal RX_BITSLIP_CMD_O_pre                  : std_logic;
   signal RX_BITSLIP_CMD_O_now                  : std_logic;
   signal RX_GB_WRITE_ADDRESS_RST_O_pre         : std_logic;
   signal RX_GB_WRITE_ADDRESS_RST_O_now         : std_logic;
   --=====================================================================================--
   -- Pedro.Leitao@cern.ch // 2016 05 24
	--		Changed to a safe state machine 
	
	type machine is (UNLOCKED, TOGGLE_BITSLIP, GOING_LOCK, LOCKED, GOING_UNLOCK);
	signal state   : machine;

	-- Attribute "safe" implements a safe state machine.
	-- This is a state machine that can recover from an
	-- illegal state (by returning to the reset state).
	attribute syn_encoding : string;
	attribute syn_encoding of machine : type is "safe";
   --endof Pedro.Leitao@cern.ch // 2016 05 24

	
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--     
   
   --==================================== User Logic =====================================--   
   
   main: process (RX_RESET_I, RIGHTSHIFTER_READY_I, RX_WORDCLK_I)
      constant ZERO                             : std_logic_vector(WORD_ADDR_PS_CHECK_MSB downto 0) := (others => '0'); 
   begin    
      if (RX_RESET_I = '1') or (RIGHTSHIFTER_READY_I = '0') then
         checkedHeader                          <=  0 ;             -- counts the number of corrected headers while header goes "unlocking"; races falseHeader
         falseHeader                            <=  0 ;             -- counts the number of false headers while header goes "unlocking"; races checkedHeader
         consecCorrectHeaders                   <=  0 ;             -- counts the number of correct headers in a row while going_for_lock
         headerLocked                           <= '0';             -- headerLocked ; high if locked or losing_lock
         RX_HEADER_FLAG_O                       <= '0';             -- seems to work as "instantLock"
         state                                  <= UNLOCKED;
         RX_BITSLIP_CMD_O_pre                   <= '0';
         RX_BITSLIP_CMD_O_now                   <= '0';
         RX_GB_WRITE_ADDRESS_RST_O_pre          <= '0';
         RX_GB_WRITE_ADDRESS_RST_O_now          <= '0';
         
      elsif rising_edge(RX_WORDCLK_I) then 
			-- Comment: * "RX_WRITE_ADDRESS_I(WORD_ADDR_PS_CHECK_MSB downto 0)= ZERO" corresponds to the most significant word of the frame (header). 
			        
			if RX_WRITE_ADDRESS_I(WORD_ADDR_PS_CHECK_MSB downto 0)= ZERO then
				RX_HEADER_FLAG_O <= '1';
				case state is
					-- ---------------------------------------
					when UNLOCKED =>	-- should have header, if not, toggle RX_BITSLIP_CMD_O
						if (RX_WORD_I(3 downto 0) /= DATA_HEADER_PATTERN_REVERSED) and (RX_WORD_I(3 downto 0) /= IDLE_HEADER_PATTERN_REVERSED) then
							checkedHeader                          <=  0 ;
							falseHeader                            <=  0 ;
							consecCorrectHeaders                   <=  0 ;
							headerLocked                           <= '0';
							RX_GB_WRITE_ADDRESS_RST_O_now          <= '0';
							RX_BITSLIP_CMD_O_now                   <= '1'; 
							state 											<= TOGGLE_BITSLIP;
							
						else
							-- header position has been found
							checkedHeader                          <=  0 ;
							falseHeader                            <=  0 ;
							consecCorrectHeaders                   <=  0 ;
							headerLocked                           <= '0';
							RX_GB_WRITE_ADDRESS_RST_O_now          <= '0';
							RX_BITSLIP_CMD_O_now                   <= '0';         
							state 											<= GOING_LOCK;
							
						end if;
					-- ---------------------------------------
					when TOGGLE_BITSLIP =>
						checkedHeader                          <=  0 ;
						falseHeader                            <=  0 ;
						consecCorrectHeaders                   <=  0 ;
						headerLocked                           <= '0';
						RX_GB_WRITE_ADDRESS_RST_O_now          <= '0';
						RX_BITSLIP_CMD_O_now                   <= '0';         
						state 								   		<= UNLOCKED;
					-- ---------------------------------------
					when GOING_LOCK =>
						if (RX_WORD_I(3 downto 0) /= DATA_HEADER_PATTERN_REVERSED) and (RX_WORD_I(3 downto 0) /= IDLE_HEADER_PATTERN_REVERSED) then
							checkedHeader                          <=  0 ;
							falseHeader                            <=  0 ;
							consecCorrectHeaders                   <=  0 ;
							headerLocked                           <= '0';
							RX_GB_WRITE_ADDRESS_RST_O_now          <= '0';
							RX_BITSLIP_CMD_O_now                   <= '0';         
							state 											<= UNLOCKED;
							
						else
							checkedHeader                          <=  0 ;
							falseHeader                            <=  0 ;
							headerLocked                           <= '0';
							RX_BITSLIP_CMD_O_now                   <= '0';     
							
							if consecCorrectHeaders < DESIRED_CONSEC_CORRECT_HEADERS then
								consecCorrectHeaders          <= consecCorrectHeaders + 1;
								state <= GOING_LOCK;
                                RX_GB_WRITE_ADDRESS_RST_O_now              <= '0';
							else
								consecCorrectHeaders                   <=  0 ;
								state <= LOCKED;    -- it goes from going_lock to lock (one way trip!)
                                RX_GB_WRITE_ADDRESS_RST_O_now              <= '1';
							end if;
						end if;
					-- ---------------------------------------
					when LOCKED =>
						if (RX_WORD_I(3 downto 0) /= DATA_HEADER_PATTERN_REVERSED) and (RX_WORD_I(3 downto 0) /= IDLE_HEADER_PATTERN_REVERSED) then      
							state 										<= GOING_UNLOCK;							
						else
							state 										<= LOCKED;
						end if;
						
						checkedHeader                          <=  0 ;
						falseHeader                            <=  0 ;
						consecCorrectHeaders                   <=  0 ;
						headerLocked                           <= '1';
						RX_GB_WRITE_ADDRESS_RST_O_now          <= '0';
						RX_BITSLIP_CMD_O_now                   <= '0';   
						
					-- ---------------------------------------
					when GOING_UNLOCK =>	
						-- this is a race condition between falseHeader and checkedHeader
						if checkedHeader < NBR_CHECKED_HEADER then
							checkedHeader                    <= checkedHeader + 1;
							
							if (RX_WORD_I(3 downto 0) /= DATA_HEADER_PATTERN_REVERSED) and (RX_WORD_I(3 downto 0) /= IDLE_HEADER_PATTERN_REVERSED) then
								if falseHeader < NBR_ACCEPTED_FALSE_HEADER then
									falseHeader                <= falseHeader + 1;
									state <= GOING_UNLOCK;
								else
									falseHeader                <= 0;
									state <= UNLOCKED;
								end if;               
									
							else
								falseHeader             	<= falseHeader; 
								state 							<= GOING_UNLOCK;
							end if;
							consecCorrectHeaders                   <=  0 ;
							headerLocked                           <= '1';
							RX_GB_WRITE_ADDRESS_RST_O_now          <= '0';
							RX_BITSLIP_CMD_O_now                   <= '0';   

						else	-- returns to locked position, clears all counters
							checkedHeader						   <=  0 ;
							falseHeader                            <=  0 ;
							consecCorrectHeaders                   <=  0 ;
							headerLocked                           <= '1';
							RX_GB_WRITE_ADDRESS_RST_O_now          <= '0';
							RX_BITSLIP_CMD_O_now                   <= '0';   
							state 											<= LOCKED;
						end if;
					-- ---------------------------------------
					when OTHERS =>
						checkedHeader                          <=  0 ;
						falseHeader                            <=  0 ;
						consecCorrectHeaders                   <=  0 ;
						headerLocked                           <= '1';
						RX_GB_WRITE_ADDRESS_RST_O_now          <= '0';
						RX_BITSLIP_CMD_O_now                   <= '0';         
						state 								   		<= LOCKED;
				end case;
				
			else
				-- do nothing
				RX_HEADER_FLAG_O                       <= '0';

			end if;
            
			------------------------------------------------
			-- Comment: send bit slip command
			RX_BITSLIP_CMD_O_pre <= RX_BITSLIP_CMD_O_now; 
			
			------------------------------------------------
			--send out RX_GB_WRITE_ADDRESS_RST_O
			RX_GB_WRITE_ADDRESS_RST_O_pre <= RX_GB_WRITE_ADDRESS_RST_O_now;
            
            
		end if;
   end process;
	---------------------------- ---------------------------- ---------------------------- ----------------------------
	RX_BITSLIP_CMD_O <= '1' WHEN (RX_BITSLIP_CMD_O_pre = '0' and RX_BITSLIP_CMD_O_now = '1') ELSE '0'; -- avoid 1 bit skew..
	RX_GB_WRITE_ADDRESS_RST_O <= '1' WHEN (RX_GB_WRITE_ADDRESS_RST_O_pre = '0' and RX_GB_WRITE_ADDRESS_RST_O_now = '1') ELSE '0'; -- avoid 1 bit skew..
	
   RX_HEADER_LOCKED_O                           <= headerLocked;
   RX_WORD_O                                    <= RX_WORD_I;

   --=====================================================================================--      
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--