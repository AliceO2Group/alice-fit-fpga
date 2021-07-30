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
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use std.env.stop;

use work.all;
use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;

entity testbench_readout is
end testbench_readout;

architecture behavior of testbench_readout is

  -- inputs file --------------------------------------
  file input_reg_file               : text open read_mode is "..\..\..\..\..\..\..\..\software\readout-sim\sim_data\sim_in_ctrlreg.txt";
  file output_dat_file               : text open write_mode is "..\..\..\..\..\..\..\..\software\readout-sim\sim_data\sim_out_data.txt";
  signal Control_register_from_file : ctrl_reg_t;
  -- ---------------------------------------------------

  --clocks
  constant Sys_period          : time      := 3.125 ns;
  constant ipbus_clock_period  : time      := 33.333 ns;
  signal RESET                 : std_logic := '0';
  signal SYS_CLK               : std_logic := '0';
  signal DATA_CLK              : std_logic := '0';
  signal IPBUS_CLK             : std_logic := '0';
  signal GBT_RxFrameClk        : std_logic := '0';
  signal FSM_Clocks_signal     : rdclocks_t;

  -- Inputs
  signal testbench_CONTROL_REG_dynamic : readout_control_t := test_CONTROL_REG;

  --Outputs
  signal GBT_status              : readout_status_t;
  signal GBT_status_reg          : stat_reg_sim_t;
  signal Data_from_FITrd         : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal IsData_from_FITrd       : std_logic;
  signal RxData_rxclk_from_GBT   : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
  signal IsRxData_rxclk_from_GBT : std_logic;

  -- debub
  signal sim_iter_num : std_logic_vector(63 downto 0);

begin

  FSM_Clocks_signal.Reset_dclk     <= RESET;
  FSM_Clocks_signal.Data_Clk       <= DATA_CLK;
  FSM_Clocks_signal.System_Clk     <= SYS_CLK;
  FSM_Clocks_signal.System_Counter <= x"0";


-- FIT GBT project =====================================
  FitGbtPrg : entity work.FIT_GBT_project
    generic map(
      GENERATE_GBT_BANK => 0
      )

    port map(
      RESET_I          => FSM_Clocks_signal.Reset_dclk,
      SysClk_I         => FSM_Clocks_signal.System_Clk,
      DataClk_I        => FSM_Clocks_signal.Data_Clk,
      MgtRefClk_I      => FSM_Clocks_signal.Data_Clk,
      RxDataClk_I      => GBT_RxFrameClk,  -- 40MHz data clock in RX domain (loop back)
      GBT_RxFrameClk_O => GBT_RxFrameClk,

      Board_data_I       => board_data_test_const,
      Control_register_I => testbench_CONTROL_REG_dynamic,

      MGT_RX_P_I    => '0',
      MGT_RX_N_I    => '0',
      MGT_TX_P_O    => open,
      MGT_TX_N_O    => open,
      MGT_TX_dsbl_O => open,

      RxData_rxclk_to_FITrd_I   => RxData_rxclk_from_GBT,    --loop back data
      IsRxData_rxclk_to_FITrd_I => IsRxData_rxclk_from_GBT,  --loop back data
      Data_from_FITrd_O         => Data_from_FITrd,
      IsData_from_FITrd_O       => IsData_from_FITrd,
      Data_to_GBT_I             => Data_from_FITrd,          --loop back data
      IsData_to_GBT_I           => IsData_from_FITrd,        --loop back data

      RxData_rxclk_from_GBT_O   => RxData_rxclk_from_GBT,
      IsRxData_rxclk_from_GBT_O => IsRxData_rxclk_from_GBT,

      readout_status_o => GBT_status
      );
-- =====================================================





-- system and data clocks ==============================        
  Sys1_process : process
    variable was_reset : integer := 0;
    variable counter   : integer := 0;

  begin

    -- reset counter
    if(was_reset < 32) then
      was_reset := was_reset + 1;
      RESET     <= '1';
    else
      RESET <= '0';
    end if;


    SYS_CLK <= '0';
    wait for Sys_period/2;

    counter := counter + 1;

    if(counter    <= 4) then DATA_CLK <= '0';
    else DATA_CLK <= '1'; end if;

    if(counter = 8) then counter := 0; end if;

    SYS_CLK <= '1';
    wait for Sys_period/2;

  end process;
-- =====================================================





-- simulation run ======================================        
  process (FSM_Clocks_signal.Data_Clk)

    -- file data ------------------
    variable iter_num : std_logic_vector(63 downto 0) := (others => '0');

    -- reading / writing
    constant infile_num_col : integer := ctrl_reg_size*2;
    variable file_line    : line;
    type infile_data_type is array (integer range <>) of integer;
    variable data_from_file : infile_data_type(0 to infile_num_col-1);
    variable is_gbt_data : std_logic_vector(3 downto 0) := x"0";
    -- -----------------------------

  begin
    if (rising_edge(FSM_Clocks_signal.Data_Clk)) then
    
      GBT_status_reg <= func_STATREG_getaddrreg_sim(GBT_status);


      if(FSM_Clocks_signal.Reset_dclk = '1') then

        data_from_file             := (others => 0);
        Control_register_from_file <= (others => (others => '0'));

      else

        -- clock counter
        iter_num     := iter_num + 1;
        sim_iter_num <= iter_num;


        -- reading control registers from file
        if(not endfile(input_reg_file)) then

          readline(input_reg_file, file_line);
          for irow in 0 to infile_num_col-1 loop
            read(file_line, data_from_file(irow));
          end loop;

          for irow in 0 to ctrl_reg_size-1 loop
            Control_register_from_file(irow)(15 downto 0)  <= std_logic_vector(to_unsigned(data_from_file(irow*2+1), 16));
            Control_register_from_file(irow)(31 downto 16) <= std_logic_vector(to_unsigned(data_from_file(irow*2), 16));
          end loop;

          testbench_CONTROL_REG_dynamic <= func_CNTRREG_getcntrreg(Control_register_from_file);

        else
          stop;
        end if;

        -- writing simulation status
        file_line := "";
        is_gbt_data(0) := IsData_from_FITrd;
		hwrite(file_line, is_gbt_data, left, 5);
		hwrite(file_line, Data_from_FITrd, left, 23);
        for ireg in 0 to stat_reg_size_sim-1 loop
          hwrite(file_line, GBT_status_reg(ireg), left, 11);
        end loop;
        writeline(output_dat_file, file_line);


      end if;


    end if;


  end process;
-- ****************************************************




end;
