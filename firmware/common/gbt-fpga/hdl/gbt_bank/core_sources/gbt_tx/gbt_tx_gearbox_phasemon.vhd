library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity gbt_tx_gearbox_phasemon is
	Port (
		-- RESET
		RESET_I			: in  std_logic;
		CLK				: in  std_logic;
		
		-- MONITORING
		PHCOMPUTED_I	: in  std_logic;
		PHALIGNED_I		: in  std_logic;
		
		-- OUTPUT
		GOOD_O			: out std_logic;
		DONE_O			: out std_logic
	);
end gbt_tx_gearbox_phasemon;

architecture Behavioral of gbt_tx_gearbox_phasemon is
	
	signal matching_founded:				integer;	
	constant STAT_CSTE:						integer := 50;
	
begin

	main_fsm_proc: process(RESET_I, CLK)
	begin
	
		if (RESET_I = '1') then
			GOOD_O <= '0';
			DONE_O <= '0';			
			matching_founded <= 0;
			
		elsif rising_edge(CLK) then
		
			if (PHCOMPUTED_I = '1' and PHALIGNED_I = '1') then
				matching_founded <= matching_founded+1;
				
				if(matching_founded >= STAT_CSTE) then
					DONE_O <= '1';
					GOOD_O <= '1';
				end if;
				
			elsif(PHCOMPUTED_I = '1' and PHALIGNED_I = '0') then
				DONE_O <= '1';
				GOOD_O <= '0';
				matching_founded <= 0;
			end if;			
			
		end if;
	end process;
	
end Behavioral;