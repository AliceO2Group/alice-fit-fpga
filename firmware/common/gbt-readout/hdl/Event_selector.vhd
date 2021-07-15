----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:42:21 04/12/2017 
-- Design Name: 
-- Module Name:    Test_Generator - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity Event_selector is
  port (
    FSM_Clocks_I : in FSM_Clocks_type;

    Status_register_I  : in FIT_GBT_status_type;
    Control_register_I : in CONTROL_REGISTER_type;

    header_fifo_data_i  : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    data_fifo_data_i    : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    header_fifo_rden_o  : out std_logic;
    data_fifo_rden_o    : out std_logic;
    header_fifo_empty_i : in  std_logic;

    CNTPTFIFO_data_word_O : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    CNTPFIFO_Is_Empty_O   : out std_logic;
    CNTPFIFO_RE_I         : in  std_logic

    );
end Event_selector;

architecture Behavioral of Event_selector is

  -- actual bcid is dalayed to take a chance to trigger go throught fifo
  constant bcid_delay : natural := 32;

  signal data_ndwords, data_ndwords_reading : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);
  signal data_orbit                         : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal data_bc                            : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal curr_orbit, curr_orbit_sc          : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal curr_bc, curr_bc_sc                : std_logic_vector(BC_id_bitdepth-1 downto 0);

  signal trgfifo_dout, trgfifo_din             : std_logic_vector(75 downto 0);
  signal trgfifo_empty, trgfifo_re, trgfifo_we : std_logic;
  signal trgfifo_out_trigger                   : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal trgfifo_out_orbit                     : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal trgfifo_out_bc                        : std_logic_vector(BC_id_bitdepth-1 downto 0);

  type FSM_STATE_T is (s0_idle, s1_dread, s2_rdh);
  signal FSM_STATE, FSM_STATE_NEXT : FSM_STATE_T;

  signal is_hbtrg, read_data, read_trigger, start_reading_data, reading_header, reading_last_word : boolean;
  signal header_fifo_rd, data_fifo_rd                                             : std_logic;

  signal word_counter : std_logic_vector(n_pckt_wrds_bitdepth-1 downto 0);

begin

  header_fifo_rden_o <= header_fifo_rd;
  data_fifo_rden_o   <= data_fifo_rd;

  data_ndwords <= func_FITDATAHD_ndwords(header_fifo_data_i);
  data_orbit   <= func_FITDATAHD_orbit(header_fifo_data_i);
  data_bc      <= func_FITDATAHD_bc(header_fifo_data_i);

  is_hbtrg <= (trgfifo_out_trigger and TRG_const_HB) /= TRG_const_void;




--    | TRG = 0    | DATA < CURR | read data             | no trigger for data
--    | TRG > DATA |             | read data             | no trigger for data
--    | TRG < DATA |             | read trigger          | no data for trigger
--    | DATA = 0   | TRG /= 0    | read trigger          | no data for trigger
--    | TRG = DATA |             | read trigger and data | data match trigger


  -- no data in fifo
  read_data <= false when header_fifo_empty_i = '1' else
  -- no trigger for data
               true when (trgfifo_empty = '1') and (data_orbit < curr_orbit_sc) else
               true when (trgfifo_empty = '1') and (data_orbit = curr_orbit_sc) and (data_bc < curr_bc_sc) else
  -- trigger equal data                                            
               true when (trgfifo_empty = '0') and (data_orbit = trgfifo_out_orbit) and (data_bc = trgfifo_out_bc) else
  -- no trigger for data
               true when (trgfifo_empty = '0') and (data_orbit < trgfifo_out_orbit) else
               true when (trgfifo_empty = '0') and (data_orbit = trgfifo_out_orbit) and (data_bc < trgfifo_out_bc) else
               false;

  -- no trigger in fifo
  read_trigger <= false when trgfifo_empty = '1' else
  -- no data for trigger
                  true when header_fifo_empty_i = '1' else
                  true when (data_orbit > trgfifo_out_orbit) else
                  true when (data_orbit = trgfifo_out_orbit) and (data_bc > trgfifo_out_bc) else
  -- trigger equal data 
                  true when (data_orbit = trgfifo_out_orbit) and (data_bc = trgfifo_out_bc) else
                  false;


-- TRG FIFO =============================================
  trg_fifo_comp_c : entity work.trg_fifo_comp
    port map(
      wr_clk => FSM_Clocks_I.Data_Clk,
      rd_clk => FSM_Clocks_I.System_Clk,
      rst    => FSM_Clocks_I.Reset_dclk,
      DIN    => trgfifo_din,
      WR_EN  => trgfifo_we,
      RD_EN  => trgfifo_re,

      DOUT  => trgfifo_dout,
      EMPTY => trgfifo_empty
      );

  trgfifo_we          <= '1' when Status_register_I.Trigger_from_CRU /= 0 and Status_register_I.Readout_Mode /= mode_IDLE else '0';
  trgfifo_din         <= Status_register_I.Trigger_from_CRU & Status_register_I.ORBIT_from_CRU & Status_register_I.BCID_from_CRU;
  trgfifo_out_trigger <= trgfifo_dout(75 downto BC_id_bitdepth + Orbit_id_bitdepth);
  trgfifo_out_orbit   <= trgfifo_dout(BC_id_bitdepth + Orbit_id_bitdepth -1 downto BC_id_bitdepth);
  trgfifo_out_bc      <= trgfifo_dout(BC_id_bitdepth - 1 downto 0);
-- ===========================================================


 -- Data ff data clk ***********************************
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then

      if Status_register_I.BCID_from_CRU >= bcid_delay then
        curr_orbit <= Status_register_I.ORBIT_from_CRU;
        curr_bc    <= (Status_register_I.BCID_from_CRU - bcid_delay);
      else
        curr_orbit <= Status_register_I.ORBIT_from_CRU - 1;
        curr_bc    <= Status_register_I.BCID_from_CRU - bcid_delay + LHC_BCID_max + 1;
      end if;



      if(FSM_Clocks_I.Reset_dclk = '1') then

      end if;

    end if;
  end process;
-- ****************************************************

-- Data ff sys clk ************************************
  process (FSM_Clocks_I.System_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.System_Clk))then

      curr_orbit_sc <= curr_orbit;
      curr_bc_sc    <= curr_bc;

      if(FSM_Clocks_I.Reset_sclk = '1') then
        FSM_STATE    <= s0_idle;
        word_counter <= (others => '0');

      else

        -- latching packet size while reading header
        if word_counter = 0 then data_ndwords_reading <= data_ndwords; end if;

        -- reset counter when start reading packet
        if start_reading_data then word_counter                                     <= (others => '0');
        -- stop iterating if next is not rdata
        elsif FSM_STATE = s1_dread and FSM_STATE_NEXT /= s1_dread then word_counter <= (others => '0');
        -- iterating words while reading data
        elsif FSM_STATE = s1_dread and FSM_STATE_NEXT = s1_dread then word_counter  <= word_counter + 1; end if;


        FSM_STATE <= FSM_STATE_NEXT;

      end if;
    end if;
  end process;
-- ****************************************************

  start_reading_data <= true when FSM_STATE /= s1_dread and FSM_STATE_NEXT = s1_dread else
                        true when reading_last_word and FSM_STATE_NEXT = s1_dread else
                        false;
  reading_header <= word_counter = 0 and FSM_STATE = s1_dread;					
  reading_last_word  <= FSM_STATE = s1_dread and word_counter = data_ndwords_reading;
				

-- RDH from IDLE
  FSM_STATE_NEXT <= s2_rdh when (FSM_STATE = s0_idle) and is_hbtrg and read_trigger else
-- RDH from DREAD
                    s2_rdh when (FSM_STATE = s1_dread) and is_hbtrg and reading_last_word and read_trigger else

-- READING from IDLE
                    s1_dread when (FSM_STATE = s0_idle) and read_data else
-- READING from DREAD
                    s1_dread when (FSM_STATE = s1_dread) and read_data and reading_last_word else
-- READING from RDH
                    s1_dread when (FSM_STATE = s2_rdh) and read_data else

-- IDLE from IDLE
                    s0_idle when (FSM_STATE = s0_idle) and not read_data else
-- IDLE from DREAD
                    s0_idle when (FSM_STATE = s1_dread) and reading_last_word and not read_data else
-- IDLE from RDH
                    s0_idle when (FSM_STATE = s2_rdh) and not read_data else
-- FSM state the same
                    FSM_STATE;

-- not reading trigger
  trgfifo_re <= '0' when not read_trigger else
-- reading trigger when not reading data
                '1' when (FSM_STATE = s0_idle) and not read_data and not is_hbtrg else 
-- reading trigger wiht data together
                '1' when (FSM_STATE = s1_dread) and read_data and reading_header and not is_hbtrg  else
                '1' when (FSM_STATE = s2_rdh)  and is_hbtrg  else
                '0';
  
-- reading header when counter 0 and fsm state is reading data 
  header_fifo_rd <= '1' when reading_header else '0';
-- reading data when counter /= 0 and fsm state is reading data 
  data_fifo_rd   <= '1' when word_counter /= 0 and FSM_STATE = s1_dread else '0';

end Behavioral;





















