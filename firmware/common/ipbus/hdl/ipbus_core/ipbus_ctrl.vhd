-- ipbus_ctrl
--
-- Top level of the ipbus bus master
--
-- Bridges ethernet MAC interface and / or out-of-band interfaces
-- to the ipbus.

-- Dave Newbold, Sep 2012

library ieee;
use ieee.std_logic_1164.all;
use work.ipbus.all;
use work.ipbus_trans_decl.all;

entity ipbus_ctrl is 
	generic(
		MAC_CFG: ipb_mac_cfg := EXTERNAL;
--		IP_CFG: ipb_ip_cfg := INTERNAL;
		IP_CFG: ipb_ip_cfg := EXTERNAL;
-- Number of address bits to select RX or TX buffer in UDP I/F
-- Number of RX and TX buffers is 2**BUFWIDTH
		BUFWIDTH: natural := 4;
-- Numer of address bits to select internal buffer in UDP I/F
-- Number of internal buffers is 2**INTERNALWIDTH
		INTERNALWIDTH: natural := 1;
-- Number of address bits within each buffer in UDP I/F
-- Size of each buffer is 2**ADDRWIDTH
		ADDRWIDTH: natural := 11;
-- UDP port for IPbus traffic in this instance of UDP I/F
		IPBUSPORT: std_logic_vector(15 DOWNTO 0) := x"C351";
-- Flag whether this UDP I/F instance ignores everything except IPBus traffic
		SECONDARYPORT: std_logic := '0';
		N_OOB: natural := 0
	);
	port(
		mac_clk: in std_logic; -- Ethernet MAC clock (125MHz)
		rst_macclk: in std_logic; -- MAC clock domain sync reset
		ipb_clk: in std_logic; -- IPbus clock
		rst_ipb: in std_logic; -- IPbus clock domain sync reset
		mac_rx_data: in std_logic_vector(7 downto 0); -- AXI4 style MAC signals
		mac_rx_valid: in std_logic;
		mac_rx_last: in std_logic;
		mac_rx_error: in std_logic;
		mac_tx_data: out std_logic_vector(7 downto 0);
		mac_tx_valid: out std_logic;
		mac_tx_last: out std_logic;
		mac_tx_error: out std_logic;
		mac_tx_ready: in std_logic;
		ipb_out: out ipb_wbus; -- IPbus bus signals
		ipb_in: in ipb_rbus;
		mac_addr: in std_logic_vector(47 downto 0) := X"000000000000"; -- Static MAC and IP addresses
		ip_addr: in std_logic_vector(31 downto 0) := X"00000000";
		pkt: out std_logic
	);

end ipbus_ctrl;

architecture rtl of ipbus_ctrl is

  signal trans_in, trans_in_udp: ipbus_trans_in;
  signal trans_out, trans_out_udp: ipbus_trans_out;
  signal udp_rxpacket_ignored, udp_rxpacket_dropped: std_logic;
  --signal cfg, cfg_out: std_logic_vector(127 downto 0);
  signal my_mac_addr: std_logic_vector(47 downto 0);
  signal my_ip_addr, my_ip_addr_udp: std_logic_vector(31 downto 0);
  signal udp_en, rarp_en: std_logic;
  signal buf_in_a: ipbus_trans_in_array(N_OOB downto 0);
  signal buf_out_a: ipbus_trans_out_array(N_OOB downto 0);
  signal mac_src_flag, ip_src_flag : std_logic;
  
begin

	udp_if: entity work.udp_if
		generic map(
			BUFWIDTH => BUFWIDTH,
			INTERNALWIDTH => INTERNALWIDTH,
			ADDRWIDTH => ADDRWIDTH,
			IPBUSPORT => IPBUSPORT,
			SECONDARYPORT => SECONDARYPORT
		)
		port map(
			mac_clk => mac_clk,
			rst_macclk => rst_macclk,
			ipb_clk => ipb_clk,
			rst_ipb => rst_ipb,
			IP_addr => my_ip_addr,
			MAC_addr => my_mac_addr,
			enable => udp_en,
			RARP => rarp_en,
			mac_rx_data => mac_rx_data,
			mac_rx_error => mac_rx_error,
			mac_rx_last => mac_rx_last,
			mac_rx_valid => mac_rx_valid,
			mac_tx_ready => mac_tx_ready,
			pkt_done_read => trans_out_udp.pkt_done,
			pkt_done_write => trans_out_udp.pkt_done,
			raddr => trans_out_udp.raddr,
			waddr => trans_out_udp.waddr,
			wdata => trans_out_udp.wdata,
			we => trans_out_udp.we,
			busy => trans_in_udp.busy,
			mac_tx_data => mac_tx_data,
			mac_tx_error => mac_tx_error,
			mac_tx_last => mac_tx_last,
			mac_tx_valid => mac_tx_valid,
			My_IP_addr => my_ip_addr_udp,
			Got_IP_addr => open,
			pkt_rdy => trans_in_udp.pkt_rdy,
			rdata => trans_in_udp.rdata,
			rxpacket_ignored => udp_rxpacket_ignored,
			rxpacket_dropped => udp_rxpacket_dropped
		);
	
	n_arb_gen: if N_OOB = 0 generate

		trans_in <= trans_in_udp;
		trans_out_udp <= trans_out;
		pkt <= trans_out_udp.pkt_done;

	end generate;
	
	trans: entity work.transactor
		port map(
			clk => ipb_clk,
			rst => rst_ipb,
			ipb_out => ipb_out,
			ipb_in => ipb_in,
			ipb_req => open,
			ipb_grant => '1',
			trans_in => trans_in,
			trans_out => trans_out
		);
	
  with MAC_CFG select mac_src_flag <=
    '1' when EXTERNAL,
    '0' when others;

  with IP_CFG select ip_src_flag <=
    '1' when EXTERNAL,
    '0' when others;

 -- cfg_out <= my_ip_addr_udp & X"00" & "000" & not rst_macclk & mac_src_flag & ip_src_flag & rarp_en & udp_en & my_mac_addr & X"00000000";

-- expose actual MAC and IP addresses
	
	 my_mac_addr <=	mac_addr;
		
	my_ip_addr <=ip_addr;
		
	udp_en <= '1';

	rarp_en <= '0';
			
end rtl;

