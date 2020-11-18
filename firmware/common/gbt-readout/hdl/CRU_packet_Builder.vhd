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
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all ;
-- use ieee.STD_LOGIC_ARITH.all;

use work.fit_gbt_common_package.all;
use work.fit_gbt_board_package.all;


entity CRU_packet_Builder is
    Port ( 
		FSM_Clocks_I : in FSM_Clocks_type;

		FIT_GBT_status_I : in FIT_GBT_status_type;
		Control_register_I : in CONTROL_REGISTER_type;
		
		SLCTFIFO_data_word_I : in std_logic_vector(fifo_data_bitdepth-1 downto 0);
		SLCTFIFO_Is_Empty_I : in STD_LOGIC;
		SLCTFIFO_RE_O : out STD_LOGIC;
		
		CNTPTFIFO_data_word_I : in std_logic_vector(cntpckfifo_data_bitdepth-1 downto 0);
		CNTPFIFO_Is_Empty_I : in STD_LOGIC;
		CNTPFIFO_RE_O : out STD_LOGIC;
		
		Is_Data_O : out STD_LOGIC;
		Data_O : out std_logic_vector(GBT_data_word_bitdepth-1 downto 0)
	 );
end CRU_packet_Builder;

architecture Behavioral of CRU_packet_Builder is
	
	constant nwords_in_SOP	: integer := 5;
	constant nwords_in_EOP	: integer := 2;

	type SOP_format_type is array (0 to nwords_in_SOP-1) of std_logic_vector(GBT_data_word_bitdepth downto 0);
	type EOP_format_type is array (0 to nwords_in_EOP-1) of std_logic_vector(GBT_data_word_bitdepth downto 0);
    signal SOP_format : SOP_format_type;
    signal EOP_format : EOP_format_type;
	
	
	type FSM_STATE_T is (s0_start, s1_sop, s2_data, s3_eop);
	signal FSM_STATE, FSM_STATE_NEXT  : FSM_STATE_T;
	
	signal Word_Count, Word_Count_next : std_logic_vector(GEN_count_bitdepth-1 downto 0);
	signal cont_packet_count, cont_packet_count_next : std_logic_vector(63 downto 0);
	signal header_payload : std_logic_vector(GEN_count_bitdepth-1 downto 0);
	signal dwords_payload : std_logic_vector(GEN_count_bitdepth-1 downto 0);
	signal trailer_payload : std_logic_vector(GEN_count_bitdepth-1 downto 0);
	signal data_payload_bytes : integer;
	
	signal is_close_frame  : std_logic;
	signal header_size     : std_logic_vector(7 downto 0);
	signal block_lenght    : std_logic_vector(15 downto 0);
	signal pages_counter   : std_logic_vector(RDH_pages_counter_bitdepth-1 downto 0);
    signal HB_Orbit    : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
    signal HB_BC       : std_logic_vector(BC_id_bitdepth-1 downto 0);
    signal TRG_Orbit   : std_logic_vector(Orbit_id_bitdepth-1 downto 0);
    signal TRG_BC      : std_logic_vector(BC_id_bitdepth-1 downto 0);
	signal TRG_Type    : std_logic_vector(Trigger_bitdepth-1 downto 0);
	signal Link_ID 	   : std_logic_vector(7 downto 0);
	signal System_ID   : std_logic_vector(7 downto 0);
	signal Memory_size : std_logic_vector(15 downto 0);

	
	signal Data_ff, Data_ff_next : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	signal IsData_ff, IsData_ff_next : STD_LOGIC;

	-- signal dataheader_ff, dataheader_ff_next : std_logic_vector(GBT_data_word_bitdepth-1 downto 0); --header for first event in packets
	
	
	attribute keep : string;	
	attribute keep of Data_ff : signal is "true";
	attribute keep of IsData_ff : signal is "true";
	attribute keep of cont_packet_count : signal is "true";

begin

	Is_Data_O <= IsData_ff;
	Data_O <= Data_ff;

	header_payload <= std_logic_vector(to_unsigned((nwords_in_SOP-1), GEN_count_bitdepth));
	dwords_payload <= func_CNTPCKword_npwords(CNTPTFIFO_data_word_I);
	trailer_payload <= std_logic_vector(to_unsigned((nwords_in_EOP-1), GEN_count_bitdepth));

    data_payload_bytes <= (to_integer(unsigned(dwords_payload)) + 5) * 16;

-- Data format ***************************************
	is_close_frame <= func_CNTPCKword_isclf(CNTPTFIFO_data_word_I);
	pages_counter <= func_CNTPCKword_pgcounter(CNTPTFIFO_data_word_I);
--	header_size <= std_logic_vector(to_unsigned((nwords_in_SOP-1), 8));
--	header_size <= x"28";
	header_size <= x"40";
	block_lenght <= std_logic_vector(to_unsigned((  data_payload_bytes ), 16));
	HB_Orbit    <= func_CNTPCKword_hborbit(CNTPTFIFO_data_word_I);
	HB_BC       <= func_CNTPCKword_hbbc(CNTPTFIFO_data_word_I);
	TRG_Orbit   <= func_CNTPCKword_trgorbit(CNTPTFIFO_data_word_I);
	TRG_BC      <= func_CNTPCKword_trgbc(CNTPTFIFO_data_word_I);
	TRG_Type    <= func_CNTPCKword_trigger(CNTPTFIFO_data_word_I);
	Link_ID		<= x"00";
	System_ID	<= x"00";
	Memory_size	<= x"0000";

	--             is data
	SOP_format(0) <= '0' & x"10000000000000000000"; -- SOP CRU
	--SOP_format(0) <= '0' & x"00000000000000000001"; -- SOP G-RORC
	--SOP_format(0) <= '0' & data_word_cnst_SOP;


    -- v4 ===================================================================================	
     --            is data      reserved      priority bit      FEE ID                 Block lenght    header size        header versions
    --SOP_format(1) <= '1' &      x"000000"&       x"01"&    Control_register_I.RDH_data.FEE_ID&  block_lenght&   header_size&       x"04";
    
    --SOP_format(2) <= '1' &      x"0000"&  HB_Orbit &  TRG_Orbit;
    
    --SOP_format(3) <= '1' &      x"0000"& TRG_Type   &   x"0"&HB_BC   &   x"0"&TRG_BC;
    --             is data      reserved     pages counter   stop bit                           PAR               detector field
    --SOP_format(4) <= '1' &      x"000000"&    pages_counter&       "0000000"&is_close_frame&   Control_register_I.RDH_data.PAR&   Control_register_I.RDH_data.DET_Field;
    -- ======================================================================================    
    
	
    -- v6 ===================================================================================
	
     --            is data                    reserved            priority bit     | FEE ID                                           header versions
    SOP_format(1) <= '1' &      block_lenght& x"0000"& System_ID&    x"01"&        Control_register_I.RDH_data.FEE_ID& header_size& x"06";
    --                                               reserved
    SOP_format(2) <= '1' &      x"0000"&  HB_Orbit & x"0000_0"&  HB_BC;
    --                                    reserved
    SOP_format(3) <= '1' &      x"0000"&  x"0000"&      x"0"&"000"&is_close_frame   &  pages_counter   &   TRG_Type;
	--                                    reserved
    SOP_format(4) <= '1' &      x"0000"&  x"0000"&   Control_register_I.RDH_data.PAR&   x"0000"&Control_register_I.RDH_data.DET_Field;
    -- ======================================================================================    
	
	
	
	
	EOP_format(0) <= '1' & x"ffff" & cont_packet_count; -- test trailer
	
	EOP_format(1) <= '0' & x"20000000000000000000"; -- eop CRU
	--EOP_format(1) <= '0' & x"00000000000000000002"; -- eop G-RORC
	--EOP_format(1) <= '0' & data_word_cnst_EOP
-- ***************************************************





-- Data clock flip-flops *****************************
	PROCESS (FSM_Clocks_I.Data_Clk)
	BEGIN
		IF(FSM_Clocks_I.Data_Clk'EVENT and FSM_Clocks_I.Data_Clk = '1') THEN
			IF(FSM_Clocks_I.Reset40 = '1') THEN
				IsData_ff <= '0';
				Data_ff <= (others => '0');
--				dataheader_ff <= (others => '0');
				
				FSM_STATE <= s0_start;
				Word_Count <= (others => '0');
				cont_packet_count <= (others => '0');
			ELSE
				IsData_ff <= IsData_ff_next;
				Data_ff <= Data_ff_next;
--				dataheader_ff <= dataheader_ff_next;
				
				FSM_STATE <= FSM_STATE_NEXT;
				Word_Count <= Word_Count_next;
				cont_packet_count <= cont_packet_count_next;
			END IF;
		END IF;
	END PROCESS;
-- ***************************************************




-- FSM ***********************************************
FSM_STATE_NEXT <=	s0_start 	WHEN (FSM_Clocks_I.Reset = '1') ELSE
	s1_sop		WHEN (FSM_STATE = s0_start) and (CNTPFIFO_Is_Empty_I = '0') ELSE
	s3_eop		WHEN (FSM_STATE = s1_sop)   and (Word_Count = header_payload) and (dwords_payload = GEN_const_void) ELSE
	s2_data		WHEN (FSM_STATE = s1_sop) 	and (Word_Count = header_payload) ELSE
	s3_eop		WHEN (FSM_STATE = s2_data) 	and (Word_Count+1 = dwords_payload) ELSE
	s0_start	WHEN (FSM_STATE = s3_eop) 	and (Word_Count = trailer_payload) ELSE
	FSM_STATE;

	
Word_Count_next <=	(others => '0')	WHEN (FSM_Clocks_I.Reset = '1') ELSE
        (others => '0') WHEN (FSM_STATE = s0_start)     ELSE
        (others => '0')    WHEN (FSM_STATE = s1_sop)     and (Word_Count = header_payload) ELSE
        (others => '0')    WHEN (FSM_STATE = s2_data)    and (Word_Count+1 = dwords_payload) ELSE
        (others => '0')    WHEN (FSM_STATE = s3_eop)     and (Word_Count = trailer_payload) ELSE
        Word_Count+1;
        
cont_packet_count_next <=	(others => '0')	WHEN (FSM_Clocks_I.Reset = '1') ELSE
            (others => '0')                 WHEN (FIT_GBT_status_I.Readout_Mode = mode_IDLE)     ELSE
            cont_packet_count+1             WHEN (FSM_STATE = s3_eop)     and (Word_Count = trailer_payload) ELSE
            cont_packet_count;
            
	
-- dataheader_ff_next <=	(others => '0')	 WHEN (FSM_Clocks_I.Reset = '1') ELSE
						-- FIFO_data_word_I WHEN (FSM_STATE = s1_sop) and (Word_Count = 0) ELSE
						-- dataheader_ff;
						
						
IsData_ff_next <= '0'	 													WHEN (FSM_Clocks_I.Reset = '1') ELSE
	SOP_format(to_integer(unsigned(Word_Count)))(GBT_data_word_bitdepth) 	WHEN (FSM_STATE = s1_sop) ELSE
	'1'					 													WHEN (FSM_STATE = s2_data) ELSE
	EOP_format(to_integer(unsigned(Word_Count)))(GBT_data_word_bitdepth)	WHEN (FSM_STATE = s3_eop) ELSE
	'0';

	
Data_ff_next <= (others => '0')	    							                    WHEN (FSM_Clocks_I.Reset = '1') ELSE
	SOP_format(to_integer(unsigned(Word_Count)))(GBT_data_word_bitdepth-1 downto 0)	WHEN (FSM_STATE = s1_sop) ELSE
	SLCTFIFO_data_word_I										                    WHEN (FSM_STATE = s2_data) ELSE
	EOP_format(to_integer(unsigned(Word_Count)))(GBT_data_word_bitdepth-1 downto 0)	WHEN (FSM_STATE = s3_eop) ELSE
	(others => '0');

	
SLCTFIFO_RE_O <= 	'0'	WHEN (FSM_Clocks_I.Reset = '1') ELSE
					'1' WHEN (FSM_STATE = s2_data)  	ELSE
					'0';

CNTPFIFO_RE_O <= 	'0'	WHEN (FSM_Clocks_I.Reset = '1') ELSE
					'1' WHEN (FSM_STATE = s3_eop) and (Word_Count = trailer_payload) ELSE
					'0';

-- ***************************************************
	
	
		
end Behavioral;

