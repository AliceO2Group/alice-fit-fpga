----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:15 01/30/2017 
-- Design Name: 
-- Module Name:    TX_Data_Gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all ;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TX_Data_Gen is
    Port (
		FSM_Clocks_I : in FSM_Clocks_type;
		
		Control_register_I : in CONTROL_REGISTER_type;
		
		FIT_GBT_status_I : in FIT_GBT_status_type;
		TX_IsData_I : in STD_LOGIC;
		TX_Data_I : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
		
		RAWFIFO_data_word_I : in std_logic_vector(fifo_data_bitdepth-1 downto 0);
		RAWFIFO_Is_Empty_I : in STD_LOGIC;
		RAWFIFO_RE_O : out STD_LOGIC;
		
		TX_IsData_O : out STD_LOGIC;
		TX_Data_O : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0)
	);
end TX_Data_Gen;

architecture Behavioral of TX_Data_Gen is

signal TX_generation : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
signal Data_bypass   : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
signal TX_data_gen : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
signal TX_IsData_generation : STD_LOGIC;
signal IsData_bypass : STD_LOGIC;

signal data320to40fifo_empty : std_logic;
signal data320to40fifo_WREN : std_logic;
signal data320to40fifo_RDEN : std_logic;

signal gen_counter_ff, gen_counter_ff_next: std_logic_vector(GEN_count_bitdepth-1 downto 0);
signal cont_counter_ff, cont_counter_ff_next: std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
signal count_val_void, count_val_data: std_logic_vector(GEN_count_bitdepth-1 downto 0);

-- signal rx_phase_latch : std_logic_vector(rx_phase_bitdepth-1 downto 0); 
attribute keep : string;	
attribute keep of gen_counter_ff : signal is "true";
attribute keep of cont_counter_ff : signal is "true";


begin

TX_Data_O <= 	TX_generation 	WHEN (Control_register_I.Data_Gen.usage_generator = use_TX_generator) ELSE
				Data_bypass		WHEN (Control_register_I.readout_bypass = '1') ELSE
			    TX_Data_I;
								
TX_IsData_O <= TX_IsData_generation WHEN (Control_register_I.Data_Gen.usage_generator = use_TX_generator) ELSE
			   IsData_bypass		WHEN (Control_register_I.readout_bypass = '1') ELSE
			   TX_IsData_I;

-- TX_data_gen <= x"01231111" & Control_register_I.PAR & x"1111" & Control_register_I.FEE_ID;
TX_data_gen <= cont_counter_ff;
count_val_void <= x"0f00";
count_val_data <= x"0f0a";



-- Slc_data_fifo =============================================
data320to40_fifo_comp : entity work.slct_data_fifo
port map(
           wr_clk        => FSM_Clocks_I.System_Clk,
           rd_clk        => FSM_Clocks_I.Data_Clk,
     	   wr_data_count => open,
           rst           => FSM_Clocks_I.Reset,
           WR_EN 		 => data320to40fifo_WREN,
           RD_EN         => data320to40fifo_RDEN,
           DIN           => RAWFIFO_data_word_I,
           DOUT          => Data_bypass,
           FULL          => open,
           EMPTY         => data320to40fifo_empty
        );
		
data320to40fifo_WREN <= not RAWFIFO_Is_Empty_I;
data320to40fifo_RDEN <= not data320to40fifo_empty;
RAWFIFO_RE_O <= not RAWFIFO_Is_Empty_I;
IsData_bypass <= not data320to40fifo_empty;
-- ===========================================================




-- Data ff data clk **********************************
	process (FSM_Clocks_I.Data_Clk)
	begin

		IF(rising_edge(FSM_Clocks_I.Data_Clk) )THEN
			IF (FSM_Clocks_I.Reset40 = '1') THEN
				gen_counter_ff		<= (others => '0');
				cont_counter_ff		<= (others => '0');
			ELSE
				gen_counter_ff		<= gen_counter_ff_next;
				cont_counter_ff		<= cont_counter_ff_next;
			END IF;
		END IF;
		
	end process;
-- ***************************************************




-- ***************************************************
gen_counter_ff_next <= 	(others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
						(others => '0')	WHEN (gen_counter_ff = count_val_data+1) ELSE
						gen_counter_ff + 1;
			
			
			
cont_counter_ff_next <= (others => '0')        WHEN (FSM_Clocks_I.Reset = '1') ELSE
					    (others => '0')        WHEN (Control_register_I.Data_Gen.usage_generator /= use_TX_generator) ELSE
					    cont_counter_ff         WHEN (gen_counter_ff < count_val_void) ELSE
                        cont_counter_ff         WHEN (gen_counter_ff = count_val_void) ELSE
                        cont_counter_ff         WHEN (gen_counter_ff = count_val_data+1) ELSE
                        cont_counter_ff + 1;
                                    

			
TX_generation <=	x"00000000000000000000" WHEN (FSM_Clocks_I.Reset = '1') ELSE
					x"00000000000000000000" WHEN (gen_counter_ff < count_val_void) ELSE
					data_word_cnst_SOP 		WHEN (gen_counter_ff = count_val_void) ELSE
					data_word_cnst_EOP 		WHEN (gen_counter_ff = count_val_data+1) ELSE
					TX_data_gen;
					--x"123456789abcdef01234";
					
TX_IsData_generation <=	'0' WHEN (FSM_Clocks_I.Reset = '1') ELSE
						'0' WHEN (gen_counter_ff < count_val_void) ELSE
						'0'	WHEN (gen_counter_ff = count_val_void) ELSE
						'0'	WHEN (gen_counter_ff = count_val_data+1) ELSE
						'1';
-- ***************************************************



end Behavioral;

