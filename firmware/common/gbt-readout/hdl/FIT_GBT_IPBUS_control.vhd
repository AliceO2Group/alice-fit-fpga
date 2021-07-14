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

library unisim;
use unisim.vcomponents.all;

library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.fit_gbt_common_package.all;

entity FIT_GBT_IPBUS_control is
    Port (
        reset_i        : in std_logic;
		DataClk_I 	   : in  STD_LOGIC; -- 40MHz data clock
		RegClk_I       : in std_logic;
		
		Reg_status_O : out STD_LOGIC_VECTOR (31 downto 0);
		Rer_control_I : in STD_LOGIC_VECTOR (31 downto 0);

		FIT_Readout_status_I : in FIT_GBT_status_type;
		FIT_Readout_control_O	: out CONTROL_REGISTER_type
	);
end FIT_GBT_IPBUS_control;

architecture Behavioral of FIT_GBT_IPBUS_control is


	
	signal ipbus_di, ipbus_do, ipbus_do_next : STD_LOGIC_VECTOR (31 downto 0);
	signal ipbus_ack, ipbus_err :std_logic;
	
	--   |  DataClk_I                                                 				|                                IPBUS clock		   		         |
	--  -|> Status_register_I -#-> ipbus_status_reg_map -> ipbus_status_reg_map_dc  -|->  ipbus_status_reg_ipbclk -> IBBUS  						      	 |
	
	--  <|- Control_register_reg_dc      	              						  <-|-   Control_register_reg_map_ipbclk <-#- ipbus_control_reg <- IBBUS |
	--  -|> Control_register_reg_dc -#-> Control_register_rdmap_dc  			   -|->  Control_register_rdmap_ipbclk -> IBBUS                          |
	
	signal Control_register_reg_map_ipbclk, Control_register_reg_dc : CONTROL_REGISTER_type;
	signal	ipbus_control_reg, Control_register_rdmap_dc, Control_register_rdmap_ipbclk : cntr_reg_addrreg_type;
	signal	ipbus_status_reg_map, ipbus_status_reg_map_dc, ipbus_status_reg_ipbclk : status_reg_addrreg_type;
	signal ipbus_arrd_int : integer := 0;
	signal ipbus_base_arrd_int : integer := 0;
	
	-- test debug signals
	signal debug_ipb_clk :std_logic;
	signal debug_ipb_rst :std_logic;
	signal debug_ipb_iswr :std_logic;
	signal debug_ipb_isrd :std_logic;
	signal debug_ipb_ack  :std_logic;
	signal debug_ipb_err  :std_logic;
	signal debug_ipb_data_O : std_logic_vector (31 downto 0);
	signal debug_ipb_data_I :std_logic_vector (31 downto 0);
	signal debug_ipb_addr :std_logic_vector (11 downto 0);
	
	attribute keep : string;
	attribute keep of debug_ipb_clk : signal is "true";
	attribute keep of debug_ipb_rst : signal is "true";
	attribute keep of debug_ipb_iswr : signal is "true";
	attribute keep of debug_ipb_isrd : signal is "true";
	attribute keep of debug_ipb_ack : signal is "true";
	attribute keep of debug_ipb_err : signal is "true";
	attribute keep of debug_ipb_data_O : signal is "true";
	attribute keep of debug_ipb_data_I : signal is "true";
	attribute keep of debug_ipb_addr : signal is "true";

	attribute keep of ipbus_control_reg : signal is "true";
	attribute keep of ipbus_status_reg_map_dc : signal is "true";
	
	attribute keep of Control_register_rdmap_ipbclk : signal is "true";
	attribute keep of Control_register_reg_map_ipbclk : signal is "true";
	attribute keep of ipbus_status_reg_ipbclk : signal is "true";
	attribute keep of ipbus_status_reg_map : signal is "true";
	attribute keep of Control_register_reg_dc : signal is "true";

begin

-- debug signal assignement
 debug_ipb_clk <= DataClk_I;
 debug_ipb_rst <= IPBUS_rst_I;
 debug_ipb_iswr <= IPBUS_iswr_I;
 debug_ipb_isrd <= IPBUS_isrd_I;
 debug_ipb_ack  <= ipbus_ack;
 debug_ipb_err  <= ipbus_err;
 debug_ipb_data_O <= ipbus_do;
 debug_ipb_data_I <= IPBUS_data_in_I;
 debug_ipb_addr <= IPBUS_addr_I;


ipbus_di <= IPBUS_data_in_I;
IPBUS_data_out_O <= ipbus_do;
IPBUS_ack_O <= ipbus_ack;
IPBUS_err_O <= ipbus_err;
Control_register_O <= Control_register_reg_dc;


-- Control_register_reg_map_ipbclk <= test_CONTROL_REG WHEN (IPBUS_rst_I = '1') ELSE func_CNTRREG_getcntrreg(ipbus_control_reg);
Control_register_reg_map_ipbclk <= func_CNTRREG_getcntrreg(ipbus_control_reg);

Control_register_rdmap_dc <= func_CNTRREG_getaddrreg(Control_register_reg_dc);
ipbus_status_reg_map <= func_STATREG_getaddrreg(Status_register_I);

ipbus_arrd_int <= to_integer(unsigned(IPBUS_addr_I));
ipbus_base_arrd_int <= to_integer(unsigned(IPBUS_base_addr_I));


-- IP-BUS register ***********************************
	PROCESS (DataClk_I)
	BEGIN
		IF(DataClk_I'EVENT and DataClk_I = '1') THEN
		
			IF(IPBUS_rst_I = '1') THEN
				Control_register_reg_dc <= test_CONTROL_REG;
			ELSE
				Control_register_reg_dc <= Control_register_reg_map_ipbclk;
				ipbus_status_reg_map_dc <= ipbus_status_reg_map;
			END IF;
		
		END IF;
	END PROCESS;



-- IP-BUS register ***********************************
	PROCESS (IPBUS_clk_I)
	BEGIN
		IF(IPBUS_clk_I'EVENT and IPBUS_clk_I = '1') THEN
		
			ipbus_status_reg_ipbclk <= ipbus_status_reg_map_dc;
			Control_register_rdmap_ipbclk <= Control_register_rdmap_dc;
		
			IF(IPBUS_rst_I = '1') THEN
			         ipbus_control_reg <= func_CNTRREG_getaddrreg(test_CONTROL_REG);
			         
			ELSIF(IPBUS_isrd_I = '1') THEN
			
                -- if(ipbus_ack = '1') then
                    -- if(ipbus_arrd_int < cntr_reg_n_32word) then
                        -- ipbus_do <= Control_register_rdmap_ipbclk(ipbus_arrd_int);
                    -- else
                        -- ipbus_do <= ipbus_status_reg_ipbclk(ipbus_arrd_int - cntr_reg_n_32word);
                    -- end if;
                    
                -- end if;

			ELSIF(IPBUS_iswr_I = '1') THEN
			
			    if(ipbus_ack = '1') then
			         ipbus_control_reg(ipbus_arrd_int) <= ipbus_di;
			    end if;
			    
			ELSE
			
			END IF;
			
		END IF;
	END PROCESS;
-- ***************************************************


-- FSM ***********************************************
ipbus_err <= '0';
ipbus_ack <='0' WHEN (IPBUS_rst_I = '1') ELSE
			'1'		WHEN (IPBUS_isrd_I = '1') and (ipbus_arrd_int < (cntr_reg_n_32word + status_reg_n_32word) ) ELSE
			'1'		WHEN (IPBUS_iswr_I = '1') and (ipbus_arrd_int < (cntr_reg_n_32word) ) ELSE
			'0';
			
ipbus_do <= (others => '0') WHEN (IPBUS_rst_I = '1') ELSE
			(others => '0') WHEN ( ipbus_ack = '0') ELSE
			Control_register_rdmap_ipbclk(ipbus_arrd_int) WHEN (ipbus_arrd_int < cntr_reg_n_32word) ELSE
			ipbus_status_reg_ipbclk(ipbus_arrd_int - cntr_reg_n_32word);
			
			
end Behavioral;



