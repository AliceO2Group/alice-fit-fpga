--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:03:54 02/04/2017
-- Design Name:   
-- Module Name:   D:/DATA/ISE/FIT_GBT_kc705/FIT_GBT_project/testbench_ClkSync.vhd
-- Project Name:  FIT_GBT_kc705
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RXDATA_CLKSync
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

use work.all;
use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;
 
ENTITY testbench_DataPackager IS
END testbench_DataPackager;
 
ARCHITECTURE behavior OF testbench_DataPackager IS 

   --Generation
	constant Sys_period : time := 3.125 ns;
	signal RESET : std_logic := '0';
	signal RX_CLK : std_logic := '0';
	signal SYS_CLK : std_logic := '0';
	signal DATA_CLK : std_logic := '0';
	signal RX_IS_DATA_RXCLK : std_logic := '0';
	signal RX_DATA_RXCLK : std_logic_vector(79 downto 0) := (others => '0');

 	--Outputs
	signal GBT_RxFrameClk	: STD_LOGIC;
	signal FIT_GBT_status : FIT_GBT_status_type;
	signal Data_from_FITrd 			: std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	signal IsData_from_FITrd		: STD_LOGIC;
	signal RxData_rxclk_from_GBT 	: std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	signal IsRxData_rxclk_from_GBT	: STD_LOGIC;

   	
	constant testbench_CONTROL_REG_default : CONTROL_REGISTER_type :=
	(
		Data_Gen => (
--			usage_generator		=> use_TX_generator,
			usage_generator	=> use_MAIN_generator,
			
			trigger_resp_mask 	=> x"00f00000",
--			bunch_pattern 		=> x"10e0766f",
			bunch_pattern 		=> x"55555555",
			bunch_freq 			=> x"0dec",
--			bunch_freq 			=> x"00fc",
--			bunch_freq_hboffset => x"007"
			bunch_freq_hboffset => x"de8"
			),
			
		Trigger_Gen => (
			usage_generator		=> use_CONT_generator,
			--usage_generator	=> use_NO_generator
			Readout_command		 => command_off,
			trigger_single_val 		=> x"00000000",
			trigger_pattern 		=> x"0000000000000001",
			trigger_cont_value 			=> TRG_const_Ph,
			bunch_freq 				=> x"0dec",
			bunch_freq_hboffset 	=> x"de9"
			),
		
		RDH_data => (
			FEE_ID 					=> x"0001",	
			PAR 					=> x"ffff",
			DET_Field 				=> x"1234"
			),
	
	    is_hb_response              => '1',
        trg_data_select             => x"00000012",
	
		n_BCID_delay 				=> x"01f",
		crutrg_delay_comp 			=> x"00f",
		max_data_payload			=> x"000f",
		reset_orbc_synd 			=> '0',
		reset_drophit_counter 		=> '0',
		reset_gen_offset			=> '0',
		reset_gbt_rxerror			=> '0',
		reset_gbt					=> '0',
		reset_rxph_error			=> '0'
	);
	signal  testbench_CONTROL_REG_dynamic : CONTROL_REGISTER_type := testbench_CONTROL_REG_default;



BEGIN

 
-- FIT GBT project =====================================
FitGbtPrg : entity work.FIT_GBT_project
	generic map(
		GENERATE_GBT_BANK	=> 0
	)
	
	Port map(
		RESET_I				=>	RESET,
		SysClk_I			=>	SYS_CLK,
		DataClk_I			=>	DATA_CLK,
		MgtRefClk_I			=>	'0',
		RxDataClk_I			=> RX_CLK, -- 40MHz data clock in RX domain (loop back)
		FabricClk_I 		=> '0',
		GBT_RxFrameClk_O	=> open,
		
		Board_data_I		=> board_data_test_const,
		Control_register_I	=> testbench_CONTROL_REG_dynamic,
		
		MGT_RX_P_I			=>	'0',
		MGT_RX_N_I			=>	'0',
		MGT_TX_P_O			=>	open,
		MGT_TX_N_O			=>	open,
		MGT_TX_dsbl_O		=>	open,
		
		RxData_rxclk_to_FITrd_I 	=> RX_DATA_RXCLK, --loop back data
		IsRxData_rxclk_to_FITrd_I	=> RX_IS_DATA_RXCLK, --loop back data
		Data_from_FITrd_O 			=> Data_from_FITrd,
		IsData_from_FITrd_O			=> IsData_from_FITrd,
		
		Data_to_GBT_I 				=> (others => '0'), --loop back data
		IsData_to_GBT_I				=> '0', --loop back data
		RxData_rxclk_from_GBT_O	 	=> open,
		IsRxData_rxclk_from_GBT_O	=> open,

		FIT_GBT_status_O 	=> FIT_GBT_status
		);		
-- =====================================================


		
	Sys1_process :process
   variable was_reset : integer := 0;
   variable counter : integer := 0;
   begin
   
		if(was_reset < 8) then
			was_reset := was_reset + 1;
			RESET <= '1';
		else
			RESET <= '0';
		end if;
	
		SYS_CLK <= '0';
		wait for Sys_period/2;
		
		counter := counter + 1;
		if(counter <= 4) then DATA_CLK <= '0'; else  DATA_CLK <= '1'; end if;
		if(counter = 8) then counter := 0; end if;
		
		
		SYS_CLK <= '1';
		wait for Sys_period/2;
   end process;
   
   
     Sys2_process :process
	 variable parity : boolean := true;
	 variable first : boolean := true;
	 variable cont_counter : integer := 0;
	 
   begin
	if(first)then wait for Sys_period*3.7; first := false; end if;
		RX_CLK <= '0';
		wait for Sys_period*4; --.00001; --phase shift
		RX_CLK <= '1';
		
		if(parity)then
			RX_IS_DATA_RXCLK <= '1';
			RX_DATA_RXCLK <= x"11111111111111111111";
			parity:= false;
		else
			RX_IS_DATA_RXCLK <= '0';
			RX_DATA_RXCLK <= x"00000000000000000000";
			parity:= true;
		end if;
		
		cont_counter := cont_counter + 1;
		if(cont_counter = 10000) then testbench_CONTROL_REG_dynamic.Trigger_Gen.Readout_command <= send_SOT; end if;
		
		if(cont_counter = 10001) then testbench_CONTROL_REG_dynamic.reset_gen_offset <= '1'; end if;
		if(cont_counter = 10003) then testbench_CONTROL_REG_dynamic.reset_gen_offset <= '0'; end if;		
		if(cont_counter = 10001) then testbench_CONTROL_REG_dynamic.reset_rxph_error <= '1'; end if;
		if(cont_counter = 10003) then testbench_CONTROL_REG_dynamic.reset_rxph_error <= '0'; end if;		
		
		if(cont_counter = 20000) then testbench_CONTROL_REG_dynamic.Trigger_Gen.Readout_command <= command_off; end if;
		
		
		
		if(cont_counter = 20100) then testbench_CONTROL_REG_dynamic.Trigger_Gen.trigger_single_val <= x"00f00000"; end if;
		if(cont_counter = 20110) then testbench_CONTROL_REG_dynamic.Trigger_Gen.trigger_single_val <= x"00f00000"; end if;		
		
		
		
		if(cont_counter = 30000) then testbench_CONTROL_REG_dynamic.Trigger_Gen.Readout_command <= send_EOT; end if;
		if(cont_counter = 40000) then testbench_CONTROL_REG_dynamic.Trigger_Gen.Readout_command <= command_off; end if;
		
		if(cont_counter = 50000) then testbench_CONTROL_REG_dynamic.Trigger_Gen.Readout_command <= send_SOC; end if;
		if(cont_counter = 60000) then testbench_CONTROL_REG_dynamic.Trigger_Gen.Readout_command <= command_off; end if;
		if(cont_counter = 100000) then testbench_CONTROL_REG_dynamic.Trigger_Gen.Readout_command <= send_EOC; end if;
		if(cont_counter = 110000) then testbench_CONTROL_REG_dynamic.Trigger_Gen.Readout_command <= command_off; end if;
		
		wait for Sys_period*4;
   end process;




END;
