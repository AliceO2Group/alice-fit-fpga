----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2016 10:53:52
-- Design Name: 
-- Module Name: gbt_rx_frameclk_phalgnr - Behavioral
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

-- Custom libraries and packages:
    use work.gbt_bank_package.all;
    use work.vendor_specific_gbt_bank_package.all;
    use work.gbt_banks_user_setup.all;

entity gbt_rx_frameclk_phalgnr is
   Generic (
      RX_OPTIMIZATION                           : integer := 1;
      TX_OPTIMIZATION                           : integer := 1;
      WORDCLK_FREQ                              : integer := 120;
		SHIFT_CNTER											: integer;
      REF_MATCHING                              : integer_A
   );
   port ( 
      
      --=======--
      -- Reset --
      --=======-- 
   
      RESET_I                                   : in  std_logic;
      
      --===============--
      -- Clocks scheme --
      --===============--

      RX_WORDCLK_I                              : in  std_logic;  
      FRAMECLK_I                                : in  std_logic;            
      RX_FRAMECLK_O                             : out std_logic;   -- Comment: Phase aligned 40MHz output.     

      --=========--
      -- Control --
      --=========--
           
      SYNC_I                                    : in  std_logic;
      
      --=========--
      -- Status  --
      --=========--
      
      PLL_LOCKED_O                              : out std_logic;
      DONE_O                                    : out std_logic
      
   );
end gbt_rx_frameclk_phalgnr;


architecture Behavioral of gbt_rx_frameclk_phalgnr is

    signal reset_phaseshift_fsm: std_logic := '0';  
	signal phaseShift: std_logic := '0';
	signal shiftDone: std_logic := '0';  
    
    signal deserializerParallelOutput: std_logic_vector((WORDCLK_FREQ/40)-1 downto 0) := (others => '0');
    signal deserializerDone: std_logic := '0';
    signal deserializerSyncReset: std_logic := '0';
            
    signal frameclock_from_pll: std_logic := '0';
    signal pllLocked_from_pll: std_logic := '0';  
    signal phaseShift_to_pll: std_logic := '0';
    signal shiftDone_from_pll: std_logic := '0';  
        
begin
   
   latOpt_phalgnr_gen: if RX_OPTIMIZATION = LATENCY_OPTIMIZED generate
   
       mmc_ctrl_inst: entity work.phaligner_mmcm_controller
         Generic map (
             SHIFT_CNTER           => SHIFT_CNTER	-- ((56*VCO_FREQ)/wordclk_freq) for Xilinx and ((8*VCO_FREQ)/wordclk_freq) for Altera
         )
         Port map ( 
             RX_WORDCLK_I          => RX_WORDCLK_I,
             RESET_I               => reset_phaseshift_fsm,
             
             PHASE_SHIFT_TO_MMCM   => phaseShift_to_pll,
             SHIFT_DONE_FROM_MMCM  => shiftDone_from_pll,
             
             PHASE_SHIFT           => phaseShift,
             SHIFT_DONE            => shiftDone
         );
         
       phase_computing_inst: entity work.phaligner_phase_computing
           Generic map (
               wordclk_freq          => WORDCLK_FREQ
           )
           Port map ( 
               RX_WORDCLK_I          => RX_WORDCLK_I,
               RESET_I               => deserializerSyncReset,
               
               RX_FRAMECLK           => frameclock_from_pll,
               SYNC_I                => SYNC_I,
               
               DONE_O                => deserializerDone,
               OUTPUT_O              => deserializerParallelOutput
           );
       
          phase_comp_inst: entity work.phaligner_phase_comparator
              Generic map (
                  wordclk_freq          => WORDCLK_FREQ,
                  ref                   => REF_MATCHING
              )
              Port map ( 
                  RX_WORDCLK_I          => RX_WORDCLK_I,
                  RESET_I               => RESET_I or not(pllLocked_from_pll),
                  
                  PLL_LOCKED            => pllLocked_from_pll,
                  
                  RESET_MMCM_CTRL       => reset_phaseshift_fsm,
                  PHASE_SHIFT           => phaseShift,
                  SHIFT_DONE            => shiftDone,
                  
                  RESET_DESERIALIZER    => deserializerSyncReset,
                  DESERIALIZER_DONE     => deserializerDone,
                  DESERIALIZER_I        => deserializerParallelOutput,
                  
                  PHASE_ALIGNED         => DONE_O
              );
                          
         mmcm_inst: entity work.phaligner_std_pll
              Port map(
                 RX_WORDCLK_I       => RX_WORDCLK_I,
                 RX_FRAMECLK_O      => frameclock_from_pll,
                 
                 RESET_I            => RESET_I,
                 
                 PHASE_SHIFT        => phaseShift_to_pll,
                 SHIFT_DONE         => shiftDone_from_pll,
                 
                 LOCKED             => pllLocked_from_pll
               );
           
         PLL_LOCKED_O <= pllLocked_from_pll;    
         RX_FRAMECLK_O <= frameclock_from_pll; 
			
    end generate;
            
   std_phalgnr_gen: if RX_OPTIMIZATION = STANDARD generate
        RX_FRAMECLK_O <= FRAMECLK_I;
        PLL_LOCKED_O <= not(RESET_I); 
        DONE_O <= not(RESET_I);
   end generate;
    
    
end Behavioral;
