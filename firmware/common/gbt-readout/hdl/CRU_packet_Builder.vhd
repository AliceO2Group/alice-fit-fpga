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
-- use ieee.STD_LOGIC_ARITH.all;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity CRU_packet_Builder is
  port (
    FSM_Clocks_I : in rdclocks_t;

    Status_register_I  : in readout_status_t;
    Control_register_I : in readout_control_t;

    SLCTFIFO_data_word_I : in  std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
    SLCTFIFO_Is_Empty_I  : in  std_logic;
    SLCTFIFO_RE_O        : out std_logic;

    CNTPTFIFO_data_word_I : in  std_logic_vector(127 downto 0);
    CNTPFIFO_Is_Empty_I   : in  std_logic;
    CNTPFIFO_RE_O         : out std_logic;

    Is_Data_O : out std_logic;
    Data_O    : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0);

    -- errors indicate unexpected FSM state, should be reset and debugged
    -- 0 - slct_fifo is empty while reading data
    errors_o : out std_logic_vector(0 downto 0)
    );
end CRU_packet_Builder;

architecture Behavioral of CRU_packet_Builder is

  -- control 
  signal readout_bypass : boolean;

  -- PACKET format
  constant nwords_in_SOP : natural := 5;
  constant nwords_in_EOP : natural := 1;
  type SOP_format_type is array (0 to nwords_in_SOP-1) of std_logic_vector(GBT_data_word_bitdepth downto 0);
  type EOP_format_type is array (0 to nwords_in_EOP-1) of std_logic_vector(GBT_data_word_bitdepth downto 0);
  signal SOP_format      : SOP_format_type;
  signal EOP_format      : EOP_format_type;

  -- header data
  constant rdh_header_version : std_logic_vector(7 downto 0)  := x"07";
  constant rdh_header_size    : std_logic_vector(7 downto 0)  := x"40";
  constant rdh_detector_field : std_logic_vector(31 downto 0) := x"00000000";
  constant rdh_par            : std_logic_vector(15 downto 0) := x"0000";
  constant rdh_data_format    : std_logic_vector(7 downto 0) := x"02"; -- will be replaced by CRU

  signal rdh_feeid             : std_logic_vector(15 downto 0);
  signal rdh_sysid             : std_logic_vector(7 downto 0);
  signal rdh_priority_bit      : std_logic_vector(7 downto 0);
  signal rdh_orbit             : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
  signal rdh_bc                : std_logic_vector(BC_id_bitdepth-1 downto 0);
  signal rdh_trg               : std_logic_vector(Trigger_bitdepth-1 downto 0);
  signal rdh_stop              : std_logic_vector(7 downto 0);
  signal rdh_pages_counter     : std_logic_vector(15 downto 0);
  signal rdh_offset_new_packet : std_logic_vector(15 downto 0);

  -- FSM signals
  type FSM_STATE_T is (s0_wait, s1_sop, s2_data, s3_eop);
  signal FSM_STATE, FSM_STATE_NEXT    : FSM_STATE_T;
  signal word_counter, rdh_nwords     : natural range 0 to 512+5+1 +1;
  signal cntpck_fifo_re, slct_fifo_re : std_logic;


begin

  -- continiosly reading select fifo in bypass mode
  SLCTFIFO_RE_O <= slct_fifo_re when not readout_bypass else not SLCTFIFO_Is_Empty_I;
  CNTPFIFO_RE_O <= cntpck_fifo_re;

  rdh_feeid             <= Control_register_I.RDH_data.FEE_ID;
  rdh_sysid             <= Control_register_I.RDH_data.SYS_ID;
  rdh_priority_bit      <= Control_register_I.RDH_data.PRT_BIT;
  rdh_offset_new_packet <= std_logic_vector(to_unsigned(((rdh_nwords+4)*16), 16)); -- will be replaced by CRU

  -- v6 ===================================================================================
  SOP_format(0) <= '0' & x"10000000000000000000";  -- SOP CRU
  -- RDH2[15 .. 0]  RDH1[31 .. 0]  RDH0 [31 .. 0]
  SOP_format(1) <= '1' & rdh_offset_new_packet & x"0000" & rdh_sysid & rdh_priority_bit & rdh_feeid & rdh_header_size & rdh_header_version; 
  -- RDH6[15 .. 0]  RDH5[31 .. 0]  RDH4 [31 .. 0]
  SOP_format(2) <= '1' & x"00" & rdh_data_format & rdh_orbit & x"0000_0" & rdh_bc;
  -- RDH10[15 .. 0] RDH9[31 .. 0]  RDH8 [31 .. 0]
  SOP_format(3) <= '1' & x"0000_00" & rdh_stop & rdh_pages_counter & rdh_trg;
  -- RDH14[15 .. 0] RDH13[31 .. 0] RDH12 [31 .. 0]
  SOP_format(4) <= '1' & x"0000_0000" & rdh_par & rdh_detector_field;
  EOP_format(0) <= '0' & x"20000000000000000000";  -- eop CRU
  -- ======================================================================================    


  -- Data ff data clk ***********************************
  process (FSM_Clocks_I.Data_Clk)
  begin
    if(rising_edge(FSM_Clocks_I.Data_Clk))then

      if(FSM_Clocks_I.Reset_dclk = '1') then

        FSM_STATE <= s0_wait;
        errors_o  <= (others => '0');

      else

        readout_bypass <= Control_register_I.readout_bypass = '1';

        FSM_STATE <= FSM_STATE_NEXT;

        -- latching RDH info from fifo
        if cntpck_fifo_re = '1' then
          rdh_trg           <= CNTPTFIFO_data_word_I(31 downto 0);
          rdh_bc            <= CNTPTFIFO_data_word_I(43 downto 32);
          rdh_orbit         <= CNTPTFIFO_data_word_I(75 downto 44);
          rdh_nwords        <= to_integer(unsigned(CNTPTFIFO_data_word_I(87 downto 76)));
          rdh_pages_counter <= x"00" & CNTPTFIFO_data_word_I(95 downto 88);
          rdh_stop          <= "0000000" & CNTPTFIFO_data_word_I(96);
        end if;

        -- word counter
        if (FSM_STATE_NEXT = s1_sop) and ((FSM_STATE = s0_wait) or (FSM_STATE = s3_eop)) then word_counter <= 0;
        elsif word_counter                                                                                 <= 512+5+1 +1 then word_counter <= word_counter + 1; end if;

        -- if select fifo becomes empty while reading data, raise error
        if (FSM_STATE = s2_data) and SLCTFIFO_Is_Empty_I = '1' then errors_o(0) <= '1'; end if;


      end if;

    end if;
  end process;
-- ****************************************************

  FSM_STATE_NEXT <= s1_sop when (FSM_STATE = s0_wait) and (CNTPFIFO_Is_Empty_I = '0') else
                    s3_eop  when (FSM_STATE = s1_sop) and (word_counter = nwords_in_SOP-1) and (rdh_nwords = 0) else
                    s2_data when (FSM_STATE = s1_sop) and (word_counter = nwords_in_SOP-1) else
                    s3_eop  when (FSM_STATE = s2_data) and (word_counter = rdh_nwords + nwords_in_SOP-1) else
                    s0_wait when (FSM_STATE = s3_eop) and (word_counter = rdh_nwords + nwords_in_SOP + nwords_in_EOP-1) and (CNTPFIFO_Is_Empty_I = '1') else
                    s1_sop  when (FSM_STATE = s3_eop) and (word_counter = rdh_nwords + nwords_in_SOP + nwords_in_EOP-1) and (CNTPFIFO_Is_Empty_I = '0') else
                    FSM_STATE;

  cntpck_fifo_re <= '1' when (FSM_STATE = s1_sop) and word_counter = 0 else '0';
  slct_fifo_re   <= '1' when (FSM_STATE = s2_data)                     else '0';

  Data_O <= SLCTFIFO_data_word_I when readout_bypass else
            SOP_format(word_counter)(GBT_data_word_bitdepth-1 downto 0)                              when (FSM_STATE = s1_sop) else
            SLCTFIFO_data_word_I                                                                     when (FSM_STATE = s2_data) else
            EOP_format(word_counter - rdh_nwords - nwords_in_SOP)(GBT_data_word_bitdepth-1 downto 0) when (FSM_STATE = s3_eop) else
            (others => '0');

  Is_Data_O <= not SLCTFIFO_Is_Empty_I when readout_bypass else
               SOP_format(word_counter)(GBT_data_word_bitdepth)                              when (FSM_STATE = s1_sop) else
               '1'                                                                           when (FSM_STATE = s2_data) else
               EOP_format(word_counter - rdh_nwords - nwords_in_SOP)(GBT_data_word_bitdepth) when (FSM_STATE = s3_eop) else
               '0';







end Behavioral;

