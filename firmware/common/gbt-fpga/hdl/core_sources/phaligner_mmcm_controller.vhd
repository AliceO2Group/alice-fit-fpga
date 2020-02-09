----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2016 17:21:58
-- Design Name: 
-- Module Name: xlx_k7v7_phaligner_mmcm_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity phaligner_mmcm_controller is
  Generic(
      SHIFT_CNTER           : integer
  );
  Port ( 
      RX_WORDCLK_I          : in std_logic;
      RESET_I               : in std_logic;
      
      PHASE_SHIFT_TO_MMCM   : out std_logic;
      SHIFT_DONE_FROM_MMCM  : in std_logic;
      
      PHASE_SHIFT           : in std_logic;
      SHIFT_DONE            : out std_logic
  );
end phaligner_mmcm_controller;

architecture Behavioral of phaligner_mmcm_controller is

    -- TYPES
    type phaseShift_FSM_T is (s0_waitForPhaseShift, s1_doPhaseShift, s3_waitForDone);

    -- CONSTANTS
    --constant phaseShiftCnter_const      : integer       := SHIFT_CNTER;
    
    -- SIGNALS
    signal phaseShift_FSM               : phaseShift_FSM_T;
    signal phaseShiftCnter              : integer;
    
	 signal phaseshift_r0					 : std_logic := '0';
	 signal phaseshift_r1					 : std_logic := '0';
	 
begin
   --==================================--
   -- PhaseShifter FSM                 --
   --==================================--
   shiftdone_latch_proc: process(RESET_I, RX_WORDCLK_I)
   begin
        if RESET_I = '1' then
            phaseShift_FSM <= s0_waitForPhaseShift;
            phaseShiftCnter <= 0;
            SHIFT_DONE <= '0';
            
				phaseshift_r1 <= '0';
				phaseshift_r0 <= '0';
				
        elsif rising_edge(RX_WORDCLK_I) then
        
				phaseshift_r1 <= phaseshift_r0;
				phaseshift_r0 <= PHASE_SHIFT;
				
            case (phaseShift_FSM) is
                when s0_waitForPhaseShift =>
                    SHIFT_DONE <= '0';
						  phaseShiftCnter <= 0;
						  
                    if (phaseshift_r1 = '0' and phaseshift_r0 = '1') then
                        phaseShift_FSM <= s1_doPhaseShift;
                    end if;
                
                when s1_doPhaseShift =>
                    PHASE_SHIFT_TO_MMCM <= '1';
                    phaseShiftCnter <= phaseShiftCnter + 1;
                    phaseShift_FSM <= s3_waitForDone;
							
                when s3_waitForDone =>
                    PHASE_SHIFT_TO_MMCM <= '0';
                    if (SHIFT_DONE_FROM_MMCM = '1') then
                        if (phaseShiftCnter >= SHIFT_CNTER) then
                            SHIFT_DONE <= '1';
                            phaseShift_FSM <= s0_waitForPhaseShift;
                        else 
                            phaseShift_FSM <= s1_doPhaseShift;
                       end if;
                    end if;
                    
            end case;
        end if;
   end process;
   
end Behavioral;
