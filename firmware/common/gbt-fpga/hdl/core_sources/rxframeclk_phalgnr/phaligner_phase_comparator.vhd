----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2016 18:20:13
-- Design Name: 
-- Module Name: xlx_k7v7_phaligner_phase_comparator - Behavioral
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
USE ieee.numeric_std.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;

entity phaligner_phase_comparator is
    Generic (
        wordclk_freq:   integer;
        ref         :   integer_A
    );
    Port ( 
        RX_WORDCLK_I            : in std_logic;
        RESET_I                 : in std_logic;
        
        PLL_LOCKED              : in std_logic;
        
        RESET_MMCM_CTRL         : out std_logic;
        PHASE_SHIFT             : out std_logic;
        SHIFT_DONE              : in std_logic;
        
        RESET_DESERIALIZER      : out std_logic;
        DESERIALIZER_DONE       : in std_logic;
        DESERIALIZER_I          : in std_logic_vector((wordclk_freq/40)-1 downto 0);
        
        PHASE_ALIGNED           : out std_logic
    );
end phaligner_phase_comparator;

architecture Behavioral of phaligner_phase_comparator is

    type phalgnr_FSM_T is (s0_waitForPLLLocked, s1_waitForChecking, s2_CheckValue, s3_waitForShiftDone);
    signal phalgnr_FSM: phalgnr_FSM_T;
    
    signal ph_aligned_buf: std_logic;
begin

    
   --==================================--
   -- Phase shift calculation          --
   --==================================--   
     phalgnr_process: process(RX_WORDCLK_I, RESET_I)
     begin
            if RESET_I = '1' then
                phalgnr_FSM <= s0_waitForPLLLocked;
                RESET_DESERIALIZER <= '1';
                RESET_MMCM_CTRL <= '1';
                ph_aligned_buf <= '0';
                RESET_MMCM_CTRL <= '1';
                
            elsif falling_edge(RX_WORDCLK_I) then
    
                case phalgnr_FSM is
                    when s0_waitForPLLLocked =>
                        RESET_MMCM_CTRL <= '0';
                        if (PLL_LOCKED = '1') then
                          phalgnr_FSM <= s1_waitForChecking;
                        end if;
                        
                    when s1_waitForChecking =>
                        RESET_DESERIALIZER <= '0';
                        if DESERIALIZER_DONE = '1' then
                            RESET_DESERIALIZER <= '1';
                            phalgnr_FSM <= s2_CheckValue;
                        end if;
    
                    when s2_CheckValue =>
                    
                        ph_aligned_buf <= '0';
                        PHASE_SHIFT <= '1';
                        phalgnr_FSM <= s3_waitForShiftDone;
                        
                        for i in ref' range loop
                            if (to_integer(unsigned(DESERIALIZER_I)) = ref(i)) then
                                ph_aligned_buf <= '1';
                                PHASE_SHIFT <= '0';
                                phalgnr_FSM <= s1_waitForChecking;
                            end if;
                        end loop;
								
                    when s3_waitForShiftDone =>
                        PHASE_SHIFT <= '0';
                        if (SHIFT_DONE = '1') then
                            phalgnr_FSM <= s0_waitForPLLLocked;
                        end if;
                end case;                    
            end if;
    
     end process;
     
   PHASE_ALIGNED <= ph_aligned_buf;
   
end Behavioral;
