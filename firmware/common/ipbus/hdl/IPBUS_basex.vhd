-- kc705_basex_infra
--
-- All board-specific stuff goes here.
--
-- Dave Newbold, June 2013

Library UNISIM;
use UNISIM.vcomponents.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ipbus.all;

entity IPBUS_basex_infra is
	port(
		eth_clk_p: in std_logic; -- 125MHz MGT clock
		eth_clk_n: in std_logic;
		eth_rx_p: in std_logic; -- Ethernet MGT input
		eth_rx_n: in std_logic;
		eth_tx_p: out std_logic; -- Ethernet MGT output
		eth_tx_n: out std_logic;
		clk_ipb_o: out std_logic; -- IPbus clock
		rst_ipb_o: out std_logic;
		RESET : in std_logic; -- The signal of doom
		leds: out std_logic_vector(1 downto 0); -- status LEDs
		mac_addr: in std_logic_vector(47 downto 0); -- MAC address
		ip_addr: in std_logic_vector(31 downto 0); -- IP address
		ipb_in: in ipb_rbus; -- ipbus
		ipb_out: out ipb_wbus;
		clk200: out std_logic;
		locked: out std_logic
		);

end IPBUS_basex_infra;

architecture rtl of IPBUS_basex_infra is

component eth_7s_1000basex is
	Generic (
    constant POLARITY_SWAP: std_logic
);
	port(
		gt_clk: in std_logic;
		gt_txp, gt_txn: out std_logic;
		gt_rxp, gt_rxn: in std_logic;
		clk125_out: out std_logic;
		clk_gt125: in std_logic;
		clk_drp: in std_logic;
		rsti: in std_logic;
		locked: out std_logic;
		tx_data: in std_logic_vector(7 downto 0);
		tx_valid: in std_logic;
		tx_last: in std_logic;
		tx_error: in std_logic;
		tx_ready: out std_logic;
		rx_data: out std_logic_vector(7 downto 0);
		rx_valid: out std_logic;
		rx_last: out std_logic;
		rx_error: out std_logic;
		link_ok: out std_logic
    	);
end component;	

	signal clk125, clk_ipb, clk_ipb_i, clk_locked, eth_locked, rst125, rst_ipb, rst_ipb_ctrl, rst_eth, onehz, pkt, link_ok, clk_drp, gt_clkin, clk_gt125: std_logic;
	signal mac_tx_data, mac_rx_data: std_logic_vector(7 downto 0);
	signal mac_tx_valid, mac_tx_last, mac_tx_error, mac_tx_ready, mac_rx_valid, mac_rx_last, mac_rx_error: std_logic;
	signal led_p : std_logic_vector(0 downto 0);
	
begin

	ibuf0: IBUFDS_GTE2 port map(
		i => eth_clk_p,
		ib => eth_clk_n,
		o => gt_clkin,
		ceb => '0'
	);
	
	bufh_gt: BUFH port map(
            i => gt_clkin,
            o => clk_gt125
        );
        

--	DCM clock generation for internal bus, ethernet

	clocks: entity work.clocks_7s_serdes
		port map(
		    gt_clk => gt_clkin,
		   	clki_gt125 => clk_gt125,
			clki_125 => clk125,
			clko_ipb => clk_ipb_i,
			clko_drp => clk_drp,
			eth_locked => eth_locked,
			locked => clk_locked,
			nuke => RESET,
			rsto_125 => rst125,
			rsto_ipb => rst_ipb,
			rsto_eth => rst_eth,
			rsto_ipb_ctrl => rst_ipb_ctrl,
			onehz => onehz,
			clk200=> clk200
		);

	clk_ipb <= clk_ipb_i; -- Best to align delta delays on all clocks for simulation
	clk_ipb_o <= clk_ipb_i;
	rst_ipb_o <= rst_ipb;

	locked <= clk_locked;-- and eth_locked;
	
	stretch: entity work.led_stretcher
		generic map(
			WIDTH => 1
		)
		port map(
			clk => clk125,
			d(0) => pkt,
			q => led_p
		);

	leds(1 downto 0) <= (led_p(0), link_ok);
--	leds(7 downto 4) <= gpio_dip_sw;
	
-- Ethernet MAC core and PHY interface
	
	eth: eth_7s_1000basex
		generic map(
			POLARITY_SWAP => '0'
		)
		port map(
			gt_clk => gt_clkin,
			gt_txp => eth_tx_p,
			gt_txn => eth_tx_n,
			gt_rxp => eth_rx_p,
			gt_rxn => eth_rx_n,
			clk125_out => clk125,
			clk_gt125 => clk_gt125,
			clk_drp => clk_drp,
			rsti => rst_eth,
			locked => eth_locked,
			tx_data => mac_tx_data,
			tx_valid => mac_tx_valid,
			tx_last => mac_tx_last,
			tx_error => mac_tx_error,
			tx_ready => mac_tx_ready,
			rx_data => mac_rx_data,
			rx_valid => mac_rx_valid,
			rx_last => mac_rx_last,
			rx_error => mac_rx_error,
			link_ok => link_ok

		);
	
-- ipbus control logic

	ipbus: entity work.ipbus_ctrl
		port map(
			mac_clk => clk125,
			rst_macclk => rst125,
			ipb_clk => clk_ipb,
			rst_ipb => rst_ipb_ctrl,
			mac_rx_data => mac_rx_data,
			mac_rx_valid => mac_rx_valid,
			mac_rx_last => mac_rx_last,
			mac_rx_error => mac_rx_error,
			mac_tx_data => mac_tx_data,
			mac_tx_valid => mac_tx_valid,
			mac_tx_last => mac_tx_last,
			mac_tx_error => mac_tx_error,
			mac_tx_ready => mac_tx_ready,
			ipb_out => ipb_out,
			ipb_in => ipb_in,
			mac_addr => mac_addr,
			ip_addr => ip_addr,
			pkt => pkt
		);

end rtl;
