----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    07/2022 
-- Description: provides error reporting via check registers
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.all;
use work.fit_gbt_common_package.all;


entity error_report is
  port (
    FSM_Clocks_I : in rdclocks_t;

    Status_register_I  : in readout_status_t;
    Control_register_I : in readout_control_t;

    RX_IsData_I : in std_logic;
    RX_Data_I   : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);

	err_report_fifo_rden_i : in std_logic;
    report_fifo_o : out std_logic_vector(31 downto 0)
    );
end error_report;

architecture Behavioral of error_report is

  -- shift registers for data history report
  constant gbt_arr_num    : integer := 10;
  type gbt_data_arr_t is array (natural range <>) of std_logic_vector(95 downto 0);
  signal gbt_data_shreg : gbt_data_arr_t(0 to gbt_arr_num-1);
  signal gbt_data_counter : std_logic_vector(15 downto 0);
  signal rxphase_shreg  : std_logic_vector(63 downto 0);

  -- error report register
  -- 15*32 gbt; 2*32 rx_phase; 3*32 bc_sync bcid [639:0]
  signal err_rep : std_logic_vector((gbt_arr_num*96)+32*5-1 downto 0);

  -- report fifo output
  signal report_fifo_do : std_logic_vector(31 downto 0);

  -- trigger for error
  signal err_trigger                             : std_logic;
  signal bcsync_lost_inrun, bcsync_lost_inrun_ff : std_logic;
  
  -- attribute mark_debug              : string;
  -- attribute mark_debug of gbt_data_shreg     : signal is "true";
  -- attribute mark_debug of rxphase_shreg     : signal is "true";
  -- attribute mark_debug of err_rep     : signal is "true";
  -- attribute mark_debug of report_fifo_do     : signal is "true";
  -- attribute mark_debug of err_trigger     : signal is "true";


begin

-- signal mapping ------------------------------------------
  report_fifo_o     <= report_fifo_do;
  bcsync_lost_inrun <= Status_register_I.fsm_errors(10);

-- mapping gbt shift register to error report bus
  gbt_shreg_map : for ireg in 0 to gbt_arr_num-1 generate
    err_rep((ireg+1)*96-1 downto ireg*96) <= gbt_data_shreg(ireg);
  end generate gbt_shreg_map;

-- mapping rx_phase shift register to error report bus
  err_rep((gbt_arr_num*96)+63 downto (gbt_arr_num*96)) <= rxphase_shreg;


-- triggering bcid sync lost error snapshot
  err_trigger <= '1' when bcsync_lost_inrun = '1' and bcsync_lost_inrun_ff = '0' else '0';





-- shapshot fifo =============================================
  error_rep_fifo_cmp : entity work.snapshot_fifo
    generic map(n32_size => (gbt_arr_num*3)+5)
    port map(
      wr_clk_i  => FSM_Clocks_I.Data_Clk,
      rd_clk_i  => FSM_Clocks_I.ipbus_clk,
      asreset_i => Control_register_I.reset_err_report,

      di_i => err_rep,
      do_o => report_fifo_do,

      wren_i => err_trigger,
      rden_i => err_report_fifo_rden_i
      );
-- ===========================================================




-- data clk **********************************
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then

      bcsync_lost_inrun_ff <= bcsync_lost_inrun;
	  
	  -- mapping bcid sync to error report bus BC [575 : 544] ORBIT [607:576], [639:608] (delayed)
      err_rep((gbt_arr_num*96)+32*3-1 downto (gbt_arr_num*96)+32*2) <= x"0"&Status_register_I.BCID_from_CRU & x"0"&Status_register_I.ORBC_from_CRU_sync(11 downto 0);
      err_rep((gbt_arr_num*96)+32*4-1 downto (gbt_arr_num*96)+32*3) <= Status_register_I.ORBIT_from_CRU;
      err_rep((gbt_arr_num*96)+32*5-1 downto (gbt_arr_num*96)+32*4) <= Status_register_I.ORBC_from_CRU_sync(32+12-1 downto 12);


      if (Control_register_I.reset_err_report = '1') then

        gbt_data_shreg <= (others => (others => '0'));
        rxphase_shreg  <= (others => '0');
		bcsync_lost_inrun_ff <= '0';

      else
	  
		gbt_data_counter       <= gbt_data_counter+1;

        -- shift registers for error reporting
        --if RX_IsData_I = '1' then
		  -- for some reason it doesn't work:
          -- gbt_data_shreg(5 to 1) <= gbt_data_shreg(4 to 0);
          -- gbt_data_shreg(0)      <= RX_Data_I;
		  
          --gbt_data_shreg(0)      <= gbt_data_counter&RX_Data_I;
          gbt_data_shreg(0)      <= "000" & RX_IsData_I & gbt_data_counter(11 downto 0) & RX_Data_I;
          gbt_data_shreg(1)      <= gbt_data_shreg(0);
          gbt_data_shreg(2)      <= gbt_data_shreg(1);
          gbt_data_shreg(3)      <= gbt_data_shreg(2);
          gbt_data_shreg(4)      <= gbt_data_shreg(3);
          gbt_data_shreg(5)      <= gbt_data_shreg(4);
          gbt_data_shreg(6)      <= gbt_data_shreg(5);
          gbt_data_shreg(7)      <= gbt_data_shreg(6);
          gbt_data_shreg(8)      <= gbt_data_shreg(7);
          gbt_data_shreg(9)      <= gbt_data_shreg(8);
		  
        --end if;
		
		
        rxphase_shreg(63 downto 0) <= rxphase_shreg(59 downto 0) & '0'&Status_register_I.rx_phase;

      end if;

    end if;

  end process;
-- ***************************************************

end Behavioral;
















































