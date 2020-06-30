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
		
		FIFO_Data_ibclk_I : in std_logic_vector(159+32 downto 0);
		FIFO_empty_I : in std_logic;
		FIFO_RDEN_O : out std_logic;
		
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
	
	--   |  DataClk_I                                                 				|                                IPBUS clock		   		         |
    --  -|> FIT_GBT_status_I -#-> ipbus_status_reg_map -> ipbus_status_reg_map_dc  -|->  ipbus_status_reg_ipbclk -> IBBUS                                     |
    
    --  <|- Control_register_reg_dc                                                  <-|-   Control_register_reg_map_ipbclk <-#- ipbus_control_reg <- IBBUS |
    --  -|> Control_register_reg_dc -#-> Control_register_rdmap_dc                 -|->  Control_register_rdmap_ipbclk -> IBBUS                          |
	
	signal Control_register_reg_map_ipbclk, Control_register_reg_dc : CONTROL_REGISTER_type;
    signal    ipbus_control_reg, Control_register_rdmap_dc, Control_register_rdmap_ipbclk : cntr_reg_addrreg_type;
    signal    ipbus_status_reg_map, ipbus_status_reg_map_dc, ipbus_status_reg_ipbclk : status_reg_addrreg_type;
	signal ipbus_arrd_int : integer := 0;
    signal ipbus_base_arrd_int : integer := 0;

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

	attribute keep : string;
	attribute MARK_DEBUG of debug_ipb_rst : signal is "true";
	attribute MARK_DEBUG of debug_ipb_iswr : signal is "true";
	attribute MARK_DEBUG of debug_ipb_isrd : signal is "true";
	attribute MARK_DEBUG of debug_ipb_ack : signal is "true";
	attribute MARK_DEBUG of debug_ipb_err : signal is "true";
	attribute MARK_DEBUG of debug_ipb_data_O : signal is "true";
	attribute MARK_DEBUG of debug_ipb_data_I : signal is "true";
	attribute MARK_DEBUG of debug_ipb_addr : signal is "true";
	attribute MARK_DEBUG of debug_data_fifo_out : signal is "true";
	attribute MARK_DEBUG of debug_data_fifo_empty : signal is "true";
	attribute MARK_DEBUG of debug_data_fifo_rden : signal is "true";

	attribute MARK_DEBUG of ipbus_control_reg : signal is "true";
    attribute MARK_DEBUG of ipbus_status_reg_map_dc : signal is "true";
    attribute MARK_DEBUG of Is_DATA_Readign : signal is "true";
    
    attribute MARK_DEBUG of Control_register_rdmap_ipbclk : signal is "true";
    attribute MARK_DEBUG of Control_register_reg_map_ipbclk : signal is "true";
    attribute MARK_DEBUG of ipbus_status_reg_ipbclk : signal is "true";
    attribute MARK_DEBUG of ipbus_status_reg_map : signal is "true";
    attribute MARK_DEBUG of Control_register_reg_dc : signal is "true";

	attribute MARK_DEBUG of Data_FIFO_160bit_map_ff : signal is "true";
	attribute MARK_DEBUG of Data_FIFO_map_counter_ff : signal is "true";
	
	attribute MARK_DEBUG of gbt_word_counter : signal is "true";



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
 debug_data_fifo_empty <= FIFO_empty_I;


ipbus_di <= IPBUS_data_in_I;
IPBUS_data_out_O <= ipbus_do;
IPBUS_ack_O <= ipbus_ack;
IPBUS_err_O <= ipbus_err;
Control_register_O <= Control_register_reg_dc;




	
Control_register_reg_map_ipbclk <= func_CNTRREG_getcntrreg(ipbus_control_reg);
Control_register_rdmap_dc <= func_CNTRREG_getaddrreg(Control_register_reg_dc);
ipbus_status_reg_map <= func_STATREG_getaddrreg(FIT_GBT_status_I);

ipbus_arrd_int <= to_integer(unsigned(IPBUS_addr_I));
ipbus_base_arrd_int <= to_integer(unsigned(IPBUS_base_addr_I));


-- DATA FIFO 160 bit mapping to 32 bit words
Data_FIFO_160bit_map(5) <= FIFO_Data_ibclk_I(31 downto 0);
Data_FIFO_160bit_map(4) <= FIFO_Data_ibclk_I(63 downto 32);
--Data_FIFO_160bit_map(3) <= X"daf0" & FIFO_Data_ibclk_I(79 downto 64);
--Data_FIFO_160bit_map(3) <= gbt_word_counter & FIFO_Data_ibclk_I(79 downto 64);
Data_FIFO_160bit_map(3) <=  FIFO_Data_ibclk_I(95 downto 64);

Data_FIFO_160bit_map(2) <=  FIFO_Data_ibclk_I(127 downto 96);
Data_FIFO_160bit_map(1) <= FIFO_Data_ibclk_I(159 downto 128);
--Data_FIFO_160bit_map(0) <= X"daf0" & FIFO_Data_ibclk_I(159 downto 144);
--Data_FIFO_160bit_map(0) <=gbt_word_counter & FIFO_Data_ibclk_I(159 downto 160);
Data_FIFO_160bit_map(0) <= FIFO_Data_ibclk_I(191 downto 160);



-- Data_FIFO_160bit_map(4) <= FIFO_Data_ibclk_I(31 downto 0);
-- Data_FIFO_160bit_map(3) <= FIFO_Data_ibclk_I(63 downto 32);
-- Data_FIFO_160bit_map(2) <= FIFO_Data_ibclk_I(95 downto 64);
-- Data_FIFO_160bit_map(1) <= FIFO_Data_ibclk_I(127 downto 96);
-- Data_FIFO_160bit_map(0) <= FIFO_Data_ibclk_I(159 downto 128);

-- IP-BUS register ***********************************
	PROCESS (FSM_Clocks_I.Data_Clk)
	BEGIN
		IF(FSM_Clocks_I.Data_Clk'EVENT and FSM_Clocks_I.Data_Clk = '1') THEN
		
		rst_dclk <= rst_ipbus_ff;
		
		IF(rst_dclk = '1') THEN
            Control_register_reg_dc <= test_CONTROL_REG;
        ELSE
            Control_register_reg_dc <= Control_register_reg_map_ipbclk;
            ipbus_status_reg_map_dc <= ipbus_status_reg_map;
        END IF;
		
		END IF;
	END PROCESS;



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
                gbt_word_counter <= (others => '0');
				ipbus_control_reg  <= func_CNTRREG_getaddrreg(test_CONTROL_REG);
                
            ELSIF (IPBUS_addr_sel_I = '0') THEN
            
            ELSIF (IPBUS_isrd_I = '1') THEN
                Data_FIFO_map_counter_ff <= Data_FIFO_map_counter_ff_next;
                gbt_word_counter <= gbt_word_counter_next;
                
                -- if(ipbus_ack = '1') then
                    -- if(ipbus_arrd_int < ipbus_base_arrd_int + cntr_reg_n_32word) then
                        -- ipbus_do <= Control_register_rdmap_ipbclk(ipbus_arrd_int - ipbus_base_arrd_int);
                    -- else
                        -- ipbus_do <= ipbus_status_reg_ipbclk(ipbus_arrd_int - ipbus_base_arrd_int - cntr_reg_n_32word);
                    -- end if;
                    
                -- end if;

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
			x"aaaa_aaaa"		                               WHEN (Is_DATA_Readign = '1') and (FIFO_empty_I = '1') ELSE
			Data_FIFO_160bit_map_ff(Data_FIFO_map_counter_ff)  WHEN (Is_DATA_Readign = '1') ELSE
			x"ffff_ffff";

FIFO_RDEN_O             <= 	'1' WHEN (Is_DATA_Readign = '1') and (Data_FIFO_map_counter_ff = 4) else '0';
debug_data_fifo_rden    <= 	'1' WHEN (Is_DATA_Readign = '1') and (Data_FIFO_map_counter_ff = 4) else '0';
				



Data_FIFO_map_counter_ff_next <= 	0                         		WHEN (Is_DATA_Readign = '0') 		ELSE
                                    --Data_FIFO_map_counter_ff		WHEN (Is_DATA_Readign = '0') 		ELSE
									0 								WHEN (FIFO_empty_I = '1') ELSE
									0 								WHEN (Data_FIFO_map_counter_ff = 5) ELSE
									Data_FIFO_map_counter_ff + 1;
			
gbt_word_counter_next <= (others => '0') WHEN (IPBUS_rst_I = '1') ELSE
                         gbt_word_counter WHEN (Data_FIFO_map_counter_ff /= 5) ELSE
                         (others => '0') WHEN (gbt_word_counter = x"ffff") ELSE
                         gbt_word_counter + 1;	
						 
						 
rst_counter_next <= x"0" WHEN (IPBUS_rst_I = '1') ELSE
					x"f" when (rst_counter = x"f") ELSE
					rst_counter + 1;
					
rst_ipbus_ff_next <= '1' WHEN (IPBUS_rst_I = '1') ELSE
					 '1' WHEN (rst_counter < x"f") ELSE
					 '0' WHEN (rst_counter = x"f") ELSE
					 '0';
			
end Behavioral;



