----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2018 15:55:10
-- Design Name: 
-- Module Name: FIT_GBT_IPBUS_control - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


library work;
use work.fit_gbt_common_package.all;

entity FIT_TESTMODULE_IPBUS_sender is
    Port (
		FSM_Clocks_I 		: in FSM_Clocks_type;
		
		FIT_GBT_status_I : in FIT_GBT_status_type;
		Control_register_O	: out CONTROL_REGISTER_type;
		
		GBTRX_IsData_rxclk_I 	: in STD_LOGIC;
		GBTRX_Data_rxclk_I 	: in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
		
		hdmi_fifo_datain_I : in std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
        hdmi_fifo_wren_I : in std_logic;
        hdmi_fifo_wrclk_I : in std_logic;
		
		IPBUS_rst_I : in std_logic;
		IPBUS_data_out_O : out STD_LOGIC_VECTOR (31 downto 0);
		IPBUS_data_in_I : in STD_LOGIC_VECTOR (31 downto 0);
		IPBUS_addr_sel_I : in STD_LOGIC;
		IPBUS_addr_I : in STD_LOGIC_VECTOR(11 downto 0);
		IPBUS_iswr_I : in std_logic;
		IPBUS_isrd_I : in std_logic;
		IPBUS_ack_O : out std_logic;
		IPBUS_err_O : out std_logic;
		IPBUS_base_addr_I : in STD_LOGIC_VECTOR(11 downto 0)
	);
end FIT_TESTMODULE_IPBUS_sender;

architecture Behavioral of FIT_TESTMODULE_IPBUS_sender is
	
	signal ipbus_di, ipbus_do, ipbus_do_next : STD_LOGIC_VECTOR (31 downto 0);
	signal ipbus_ack, ipbus_err :std_logic;
	signal hdmi_fifo_rden, hdmi_fifo_isempty : STD_LOGIC;
	signal hdmi_fifo_dataout : std_logic_vector(GBT_data_word_bitdepth-1 downto 0);
	
	--   |  DataClk_I                                                 				|                                IPBUS clock		   		         |
    --  -|> FIT_GBT_status_I -#-> ipbus_status_reg_map -> ipbus_status_reg_map_dc  -|->  ipbus_status_reg_ipbclk -> IBBUS                                     |
    
    --  <|- Control_register_reg_dc                                                  <-|-   Control_register_reg_map_ipbclk <-#- ipbus_control_reg <- IBBUS |
    --  -|> Control_register_reg_dc -#-> Control_register_rdmap_dc                 -|->  Control_register_rdmap_ipbclk -> IBBUS                          |
	
	signal FIT_GBT_status : FIT_GBT_status_type;
	signal Control_register_reg_map_ipbclk, Control_register_reg_dc : CONTROL_REGISTER_type;
    signal ipbus_control_reg, Control_register_rdmap_dc, Control_register_rdmap_ipbclk : cntr_reg_addrreg_type;
    signal ipbus_status_reg_map, ipbus_status_reg_map_dc, ipbus_status_reg_ipbclk : status_reg_addrreg_type;
	signal ipbus_arrd_int : integer := 0;
    signal ipbus_base_arrd_int : integer := 0;

	signal data_fifo_datain : std_logic_vector(GBT_data_word_bitdepth+16-1 downto 0);
	signal data_fifo_count : std_logic_vector(slctfifo_count_bitdepth-1 downto 0);
	signal data_fifo_wren : std_logic;
	signal data_fifo_full : std_logic;
		
	signal DATA_from_FIFO : std_logic_vector(159+32 downto 0);
	signal GBT_cntr_data : std_logic_vector(95 downto 0);
	signal DATA_FIFO_empty : std_logic;
	signal FIFO_RDEN : std_logic;


	type array32_type is array (natural range <>) of std_logic_vector(31 downto 0);
	signal Data_FIFO_160bit_map, Data_FIFO_160bit_map_ff : array32_type(0 to 5);
	
	signal Data_FIFO_map_counter_ff, Data_FIFO_map_counter_ff_next : integer;
	signal Is_DATA_Readign : std_logic;
	
	signal gbt_word_counter, gbt_word_counter_next : std_logic_vector(15 downto 0);
	
	signal rst_ipbus_ff, rst_ipbus_ff_next, rst_dclk : std_logic;
	signal rst_counter, rst_counter_next : std_logic_vector(3 downto 0);
	
	
	-- test debug signals
	signal debug_ipb_rst :std_logic;
	signal debug_ipb_iswr :std_logic;
	signal debug_ipb_isrd :std_logic;
	signal debug_ipb_ack  :std_logic;
	signal debug_ipb_err  :std_logic;
	signal debug_ipb_data_O : std_logic_vector (31 downto 0);
	signal debug_ipb_data_I :std_logic_vector (31 downto 0);
	signal debug_ipb_addr :std_logic_vector (11 downto 0);

	signal debug_data_fifo_out : std_logic_vector(159 downto 0);
	signal debug_data_fifo_empty :std_logic;
	signal debug_data_fifo_rden :std_logic;
	
	attribute mark_debug : string;

    attribute MARK_DEBUG of Control_register_reg_dc : signal is "true";
    attribute MARK_DEBUG of FIT_GBT_status : signal is "true";

    attribute MARK_DEBUG of data_fifo_datain : signal is "true";
    attribute MARK_DEBUG of data_fifo_wren : signal is "true";


begin
-- FSM_Clocks_I.Reset
-- FSM_Clocks_I.Data_Clk
-- FSM_Clocks_I.System_Clk
-- FSM_Clocks_I.System_Counter
-- FSM_Clocks_I.GBT_RX_Clk
-- FSM_Clocks_I.IPBUS_Data_Clk

-- debug signal assignement
 debug_ipb_rst <= IPBUS_rst_I;
 debug_ipb_iswr <= IPBUS_iswr_I;
 debug_ipb_isrd <= IPBUS_isrd_I;
 debug_ipb_ack  <= ipbus_ack;
 debug_ipb_err  <= ipbus_err;
 debug_ipb_data_O <= ipbus_do;
 debug_ipb_data_I <= IPBUS_data_in_I;
 debug_ipb_addr <= IPBUS_addr_I;
 debug_data_fifo_empty <= DATA_FIFO_empty;


ipbus_di <= IPBUS_data_in_I;
IPBUS_data_out_O <= ipbus_do;
IPBUS_ack_O <= ipbus_ack;
IPBUS_err_O <= ipbus_err;
Control_register_O <= Control_register_reg_dc;

	FIT_GBT_status.GBT_status 					<= FIT_GBT_status_I.GBT_status;
	FIT_GBT_status.Readout_Mode 				<= FIT_GBT_status_I.Readout_Mode;
	FIT_GBT_status.CRU_Readout_Mode				<= FIT_GBT_status_I.CRU_Readout_Mode;
	FIT_GBT_status.BCIDsync_Mode 				<= FIT_GBT_status_I.BCIDsync_Mode;
	FIT_GBT_status.Start_run 					<= FIT_GBT_status_I.Start_run;
	FIT_GBT_status.Stop_run 					<= FIT_GBT_status_I.Stop_run;
	
	FIT_GBT_status.Trigger_from_CRU 			<= FIT_GBT_status_I.Trigger_from_CRU;
	FIT_GBT_status.BCID_from_CRU 				<= FIT_GBT_status_I.BCID_from_CRU; 
	FIT_GBT_status.ORBIT_from_CRU 				<= FIT_GBT_status_I.ORBIT_from_CRU;
	FIT_GBT_status.BCID_from_CRU_corrected 		<= FIT_GBT_status_I.BCID_from_CRU_corrected;
	FIT_GBT_status.ORBIT_from_CRU_corrected 	<= FIT_GBT_status_I.ORBIT_from_CRU_corrected; 
		
	FIT_GBT_status.fifo_status.raw_fifo_count 		<= FIT_GBT_status_I.fifo_status.raw_fifo_count; 
	FIT_GBT_status.fifo_status.slct_fifo_count 		<= FIT_GBT_status_I.fifo_status.slct_fifo_count; 
	FIT_GBT_status.fifo_status.ftmipbus_fifo_count 	<= data_fifo_count;
	FIT_GBT_status.fifo_status.trg_fifo_count 		<= FIT_GBT_status_I.fifo_status.trg_fifo_count; 
	FIT_GBT_status.fifo_status.cntr_fifo_count 		<= FIT_GBT_status_I.fifo_status.cntr_fifo_count; 
	FIT_GBT_status.hits_rd_counter_converter 		<= FIT_GBT_status_I.hits_rd_counter_converter;
	FIT_GBT_status.hits_rd_counter_selector 		<= FIT_GBT_status_I.hits_rd_counter_selector;
	FIT_GBT_status.rx_phase 						<= FIT_GBT_status_I.rx_phase; 

	
	
Control_register_reg_map_ipbclk <= func_CNTRREG_getcntrreg(ipbus_control_reg);
Control_register_rdmap_dc <= func_CNTRREG_getaddrreg(Control_register_reg_dc);
ipbus_status_reg_map <= func_STATREG_getaddrreg(FIT_GBT_status);

ipbus_arrd_int <= to_integer(unsigned(IPBUS_addr_I));
ipbus_base_arrd_int <= to_integer(unsigned(IPBUS_base_addr_I));



-- DATA FIFO 160 bit mapping to 32 bit words
Data_FIFO_160bit_map(5) <= DATA_from_FIFO(31 downto 0);
Data_FIFO_160bit_map(4) <= DATA_from_FIFO(63 downto 32);
Data_FIFO_160bit_map(3) <=  DATA_from_FIFO(95 downto 64);

Data_FIFO_160bit_map(2) <=  DATA_from_FIFO(127 downto 96);
Data_FIFO_160bit_map(1) <= DATA_from_FIFO(159 downto 128);
Data_FIFO_160bit_map(0) <= DATA_from_FIFO(191 downto 160);

Control_register_reg_dc <= Control_register_reg_map_ipbclk;
ipbus_status_reg_map_dc <= ipbus_status_reg_map;




-- HDMI FIFO ===========================================
hdmi_fifo_rden <= '1' when (GBTRX_IsData_rxclk_I = '0') and (hdmi_fifo_isempty = '0') else '0';

hdmi_fifo_comp : entity work.hdmi_data_fifo
  PORT MAP (
    rst 	=> FSM_Clocks_I.Reset,
    wr_clk 	=> hdmi_fifo_wrclk_I,
    rd_clk 	=> FSM_Clocks_I.GBT_RX_Clk,
    din 	=> hdmi_fifo_datain_I,
    wr_en 	=> hdmi_fifo_wren_I,
    rd_en 	=> hdmi_fifo_rden,
    dout 	=> hdmi_fifo_dataout,
    full 	=> open,
    empty 	=> hdmi_fifo_isempty,
    rd_data_count => open,
    wr_rst_busy => open,
    rd_rst_busy => open
  );
-- =====================================================

-- DATA FIFO ===========================================
GBT_cntr_data <= gbt_word_counter & GBTRX_Data_rxclk_I;
data_fifo_datain <= GBT_cntr_data when (GBTRX_IsData_rxclk_I = '1') else gbt_word_counter & hdmi_fifo_dataout;
data_fifo_wren <= '1' when (GBTRX_IsData_rxclk_I = '1') or (hdmi_fifo_rden = '1') else '0';

ipbus_data_fifo_comp : entity work.ipbus_data_fifo
  PORT MAP (
    rst 	=> FSM_Clocks_I.Reset,
    wr_clk 	=> FSM_Clocks_I.GBT_RX_Clk,
    rd_clk 	=> FSM_Clocks_I.IPBUS_Data_Clk,
    din 	=> data_fifo_datain,
    wr_en 	=> data_fifo_wren,
    rd_en 	=> FIFO_RDEN,
    dout 	=> DATA_from_FIFO,
    full 	=> data_fifo_full,
    empty 	=> DATA_FIFO_empty,
    rd_data_count => data_fifo_count,
    wr_rst_busy => open,
    rd_rst_busy => open
  );
  
-- GBT counter ***********************************
  PROCESS (FSM_Clocks_I.GBT_RX_Clk)
  BEGIN
	  IF(FSM_Clocks_I.GBT_RX_Clk'EVENT and FSM_Clocks_I.GBT_RX_Clk = '1') THEN
	  
		  IF(FSM_Clocks_I.Reset = '1') THEN
			  gbt_word_counter <= (others => '0');
		  ELSE
			  gbt_word_counter <= gbt_word_counter_next;                  
		  END IF;
		  
	  END IF;
  END PROCESS;
  
  gbt_word_counter_next <= (others => '0') WHEN (FSM_Clocks_I.Reset = '1') ELSE
						   gbt_word_counter WHEN (data_fifo_wren = '0') ELSE
						   (others => '0') WHEN (gbt_word_counter = x"ffff") ELSE
						   gbt_word_counter + 1;    
-- ***************************************************

-- =====================================================






-- IP-BUS register ***********************************
	PROCESS (FSM_Clocks_I.IPBUS_Data_Clk)
	BEGIN
		IF(FSM_Clocks_I.IPBUS_Data_Clk'EVENT and FSM_Clocks_I.IPBUS_Data_Clk = '1') THEN
		
			ipbus_status_reg_ipbclk <= ipbus_status_reg_map_dc;
            Control_register_rdmap_ipbclk <= Control_register_rdmap_dc;
			Data_FIFO_160bit_map_ff <= Data_FIFO_160bit_map;
			
			rst_ipbus_ff <= rst_ipbus_ff_next;
			rst_counter <= rst_counter_next;
		
			IF(IPBUS_rst_I = '1') THEN
                Data_FIFO_map_counter_ff <= 0;
                -- gbt_word_counter <= (others => '0');
				ipbus_control_reg  <= func_CNTRREG_getaddrreg(test_CONTROL_REG);
                
            ELSIF (IPBUS_addr_sel_I = '0') THEN
            
            ELSIF (IPBUS_isrd_I = '1') THEN
                Data_FIFO_map_counter_ff <= Data_FIFO_map_counter_ff_next;
                -- gbt_word_counter <= gbt_word_counter_next;
                
            ELSIF (IPBUS_iswr_I = '1') THEN
            
                if(ipbus_ack = '1') then
                     ipbus_control_reg(ipbus_arrd_int - ipbus_base_arrd_int) <= ipbus_di;
                end if;
                
            ELSE
            
            END IF;
			
		END IF;
	END PROCESS;
-- ***************************************************


-- FSM ***********************************************
ipbus_err <= '0';

Is_DATA_Readign <= 	'1'		WHEN (IPBUS_isrd_I = '1') and (IPBUS_addr_sel_I = '1') and (ipbus_arrd_int = (ipbus_base_arrd_int + cntr_reg_n_32word + status_reg_n_32word)) ELSE  '0';

ipbus_ack <='0'     WHEN (IPBUS_rst_I = '1') ELSE
            '0'     WHEN (IPBUS_addr_sel_I = '0') else
			'0'		WHEN (ipbus_arrd_int < ipbus_base_arrd_int ) ELSE
			'1'		WHEN (IPBUS_isrd_I = '1') and (ipbus_arrd_int < (ipbus_base_arrd_int + cntr_reg_n_32word + status_reg_n_32word) ) ELSE
			'1'		WHEN (IPBUS_iswr_I = '1') and (ipbus_arrd_int < (ipbus_base_arrd_int + cntr_reg_n_32word) ) ELSE
			'1'		WHEN (Is_DATA_Readign = '1') ELSE	
			'0';


ipbus_do <= (others => '0') WHEN (IPBUS_rst_I = '1') ELSE
            (others => '0') WHEN ( ipbus_ack = '0') ELSE
            Control_register_rdmap_ipbclk(ipbus_arrd_int - ipbus_base_arrd_int) WHEN (ipbus_arrd_int < ipbus_base_arrd_int + cntr_reg_n_32word) ELSE
            ipbus_status_reg_ipbclk(ipbus_arrd_int - ipbus_base_arrd_int - cntr_reg_n_32word) WHEN (ipbus_arrd_int < (ipbus_base_arrd_int + cntr_reg_n_32word + status_reg_n_32word) ) ELSE
			
-- DATA READOUT ==========================================
			x"aaaa_aaaa"		                               WHEN (Is_DATA_Readign = '1') and (DATA_FIFO_empty = '1') ELSE
			Data_FIFO_160bit_map_ff(Data_FIFO_map_counter_ff)  WHEN (Is_DATA_Readign = '1') ELSE
			x"ffff_ffff";

FIFO_RDEN             <= 	'1' WHEN (Is_DATA_Readign = '1') and (Data_FIFO_map_counter_ff = 4) else '0';
debug_data_fifo_rden    <= 	'1' WHEN (Is_DATA_Readign = '1') and (Data_FIFO_map_counter_ff = 4) else '0';
				



Data_FIFO_map_counter_ff_next <= 	0                         		WHEN (Is_DATA_Readign = '0') 		ELSE
                                    --Data_FIFO_map_counter_ff		WHEN (Is_DATA_Readign = '0') 		ELSE
									0 								WHEN (DATA_FIFO_empty = '1') ELSE
									0 								WHEN (Data_FIFO_map_counter_ff = 5) ELSE
									Data_FIFO_map_counter_ff + 1;
			
-- gbt_word_counter_next <= (others => '0') WHEN (IPBUS_rst_I = '1') ELSE
                         -- gbt_word_counter WHEN (Data_FIFO_map_counter_ff /= 5) ELSE
                         -- (others => '0') WHEN (gbt_word_counter = x"ffff") ELSE
                         -- gbt_word_counter + 1;	
						 
						 
rst_counter_next <= x"0" WHEN (IPBUS_rst_I = '1') ELSE
					x"f" when (rst_counter = x"f") ELSE
					rst_counter + 1;
					
rst_ipbus_ff_next <= '1' WHEN (IPBUS_rst_I = '1') ELSE
					 '1' WHEN (rst_counter < x"f") ELSE
					 '0' WHEN (rst_counter = x"f") ELSE
					 '0';
			
end Behavioral;



