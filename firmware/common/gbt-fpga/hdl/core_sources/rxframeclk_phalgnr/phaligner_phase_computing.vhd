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

entity phaligner_phase_computing is
  GENERIC (
      wordclk_freq          : integer
  );
  Port ( 
      RX_WORDCLK_I          : in std_logic;
      RESET_I               : in std_logic;
      
      RX_FRAMECLK           : in std_logic;
      SYNC_I                : in std_logic;
      
      DONE_O                : out std_logic;
      OUTPUT_O              : out std_logic_vector((wordclk_freq/40)-1 downto 0)
  );
end phaligner_phase_computing;

architecture Behavioral of phaligner_phase_computing is
    signal deserializerReset: std_logic;
    signal valueComputed: std_logic;
    signal serialToParallel: std_logic_vector((wordclk_freq/40)-1 downto 0);
begin

   --==================================--
   -- Frameclock deserializer          --
   --==================================--
   frameclockDeserializer_proc: process(deserializerReset, RX_WORDCLK_I)
   begin
       if deserializerReset = '1' then
           serialToParallel <= (others => '0');
           valueComputed <= '0';
       elsif falling_edge(RX_WORDCLK_I) then
           serialToParallel((wordclk_freq/40)-1 downto 1) <= serialToParallel((wordclk_freq/40)-2 downto 0);
           serialToParallel(0) <= RX_FRAMECLK;
           valueComputed <= '1';
       end if;
   end process;
   
   --==================================--
   -- Frameclock parallel latch        --
   --==================================--
   frameclock_latch_proc: process(RESET_I, RX_WORDCLK_I)
   begin
       if RESET_I = '1' then
           deserializerReset <= '1';
           DONE_O <= '0';
       elsif rising_edge(RX_WORDCLK_I) then
           if (SYNC_I = '1') then
               deserializerReset <= '0';
               OUTPUT_O <= serialToParallel;
               DONE_O <= valueComputed;
           end if;
       end if;
   end process;
   
end Behavioral;
