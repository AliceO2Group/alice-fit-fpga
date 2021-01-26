-- Contains the instantiation of the Xilinx MAC & 1000baseX pcs/pma & GTP transceiver cores
--
-- Do not change signal names in here without corresponding alteration to the timing contraints file
--
-- Dave Newbold, April 2011
--
-- $Id$

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all ;

library unisim;
use unisim.VComponents.all;
use work.emac_hostbus_decl.all;
use work.all;

entity eth_7s_1000basex is
	Generic (
		constant POLARITY_SWAP: std_logic := '0'
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

end eth_7s_1000basex;

architecture rtl of eth_7s_1000basex is

	COMPONENT tri_mode_ethernet_mac_0
		PORT (
			gtx_clk : IN STD_LOGIC;
			glbl_rstn : IN STD_LOGIC;
			rx_axi_rstn : IN STD_LOGIC;
			tx_axi_rstn : IN STD_LOGIC;
			rx_statistics_vector : OUT STD_LOGIC_VECTOR(27 DOWNTO 0);
			rx_statistics_valid : OUT STD_LOGIC;
			rx_mac_aclk : OUT STD_LOGIC;
			rx_reset : OUT STD_LOGIC;
			rx_axis_mac_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			rx_axis_mac_tvalid : OUT STD_LOGIC;
			rx_axis_mac_tlast : OUT STD_LOGIC;
			rx_axis_mac_tuser : OUT STD_LOGIC;
			tx_ifg_delay : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			tx_statistics_vector : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			tx_statistics_valid : OUT STD_LOGIC;
			tx_mac_aclk : OUT STD_LOGIC;
			tx_reset : OUT STD_LOGIC;
			tx_axis_mac_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			tx_axis_mac_tvalid : IN STD_LOGIC;
			tx_axis_mac_tlast : IN STD_LOGIC;
			tx_axis_mac_tuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			tx_axis_mac_tready : OUT STD_LOGIC;
			pause_req : IN STD_LOGIC;
			pause_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			clk_enable : IN STD_LOGIC;
			speedis100 : OUT STD_LOGIC;
			speedis10100 : OUT STD_LOGIC;
			gmii_txd : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			gmii_tx_en : OUT STD_LOGIC;
			gmii_tx_er : OUT STD_LOGIC;
			gmii_rxd : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			gmii_rx_dv : IN STD_LOGIC;
			gmii_rx_er : IN STD_LOGIC;
			rx_configuration_vector : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
			tx_configuration_vector : IN STD_LOGIC_VECTOR(79 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT gig_ethernet_pcs_pma_0
      PORT (
        gtrefclk_bufg : IN STD_LOGIC;
        gtrefclk : IN STD_LOGIC;
        txn : OUT STD_LOGIC;
        txp : OUT STD_LOGIC;
        rxn : IN STD_LOGIC;
        rxp : IN STD_LOGIC;
        independent_clock_bufg : IN STD_LOGIC;
        txoutclk : OUT STD_LOGIC;
        rxoutclk : OUT STD_LOGIC;
        resetdone : OUT STD_LOGIC;
        cplllock : OUT STD_LOGIC;
        mmcm_reset : OUT STD_LOGIC;
        userclk : IN STD_LOGIC;
        userclk2 : IN STD_LOGIC;
        pma_reset : IN STD_LOGIC;
        mmcm_locked : IN STD_LOGIC;
        rxuserclk : IN STD_LOGIC;
        rxuserclk2 : IN STD_LOGIC;
        sgmii_clk_en : OUT STD_LOGIC;
        gmii_txd : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        gmii_tx_en : IN STD_LOGIC;
        gmii_tx_er : IN STD_LOGIC;
        gmii_rxd : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        gmii_rx_dv : OUT STD_LOGIC;
        gmii_rx_er : OUT STD_LOGIC;
        gmii_isolate : OUT STD_LOGIC;
        configuration_vector : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        an_interrupt : OUT STD_LOGIC;
        an_adv_config_vector : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        an_restart_config : IN STD_LOGIC;
        basex_or_sgmii : IN STD_LOGIC; 
        speed_is_10_100 : IN STD_LOGIC;
        speed_is_100 : IN STD_LOGIC;
        status_vector : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        reset : IN STD_LOGIC;
        signal_detect : IN STD_LOGIC;
        gt0_qplloutclk_in : IN STD_LOGIC;
        gt0_qplloutrefclk_in : IN STD_LOGIC

      );
    END COMPONENT;
    
    
    component MMCM125ETH
    port
     (clkout1          : out    std_logic;
      clkout2          : out    std_logic;
      reset             : in     std_logic;
      locked            : out    std_logic;
      clkin1           : in     std_logic
     );
    end component;
 

	signal gmii_txd, gmii_rxd: std_logic_vector(7 downto 0);
	signal gmii_tx_en, gmii_tx_er, gmii_rx_dv, gmii_rx_er: std_logic;
	signal gmii_rx_clk: std_logic;
	signal clk125, txoutclk_ub, txoutclk, clk125_ub, rxoutclk, rxoutclk_ub : std_logic;
	signal clk62_5_ub, clk62_5, clkfb: std_logic;
	signal rstn, pll_rst, phy_done, mmcm_locked, locked_int: std_logic;
	signal decoupled_clk: std_logic := '0';
	signal status_vector: std_logic_vector(15 downto 0);
	signal speed10100, speed100, clk_en, sgmii, rst_pcs, rdy : std_logic;
	signal to_cnt : std_logic_vector(22 downto 0);
	signal rst_cnt : std_logic_vector(2 downto 0);
	signal rx_config_vector, tx_config_vector : STD_LOGIC_VECTOR(79 DOWNTO 0);
	
begin
	
	clk125_out <= clk125; 
	link_ok<= status_vector(0) when (sgmii='0') else status_vector(7);
	
	bufh_tx: BUFH port map(
		i => txoutclk_ub,
		o => txoutclk
	);
    bufh_rx: BUFH port map(
		i => rxoutclk_ub,
		o => rxoutclk
       );
	
mmcm: MMCM125ETH port map(clkout1 => clk62_5, clkout2 => clk125, clkin1 => txoutclk, reset => pll_rst, locked => mmcm_locked);
	
	process(clk_gt125)
	begin
		if rising_edge(clk_gt125) then
			locked_int <= mmcm_locked and phy_done;
			
			if (rsti='1') then 
			 sgmii<='1'; to_cnt<= (others=>'0'); rst_cnt<= (others=>'1'); rdy<= '0';
			else
			if (rst_cnt/="111") then rst_cnt<= rst_cnt+1; end if;
			if (locked_int='1') then
			 if (to_cnt/= "111" & x"FFFFF") then to_cnt<= to_cnt+1;
			  else 
			   if (rdy='0') then rdy<= '1';
			     if (status_vector(0)='0')  then sgmii<='0'; rst_cnt<= (others =>'0');   end if;
			   end if;
			  end if; 
			 end if;
			end if;
		end if;
	end process;

	locked <= locked_int;
	rstn <= not (not locked_int or rsti);
	rst_pcs<= '1' when (rsti='1') or (rst_cnt/="111") else '0'; 

	mac: tri_mode_ethernet_mac_0
		port map(
			gtx_clk => clk125,
			glbl_rstn => rstn,
			rx_axi_rstn => '1',
			tx_axi_rstn => '1',
			rx_statistics_vector => open,
			rx_statistics_valid => open,
			rx_mac_aclk => open,
			rx_reset => open,
			rx_axis_mac_tdata => rx_data,
			rx_axis_mac_tvalid => rx_valid,
			rx_axis_mac_tlast => rx_last,
			rx_axis_mac_tuser => rx_error,
			tx_ifg_delay => X"00",
			tx_statistics_vector => open,
			tx_statistics_valid => open,
			tx_mac_aclk => open,
			tx_reset => open,
			tx_axis_mac_tdata => tx_data,
			tx_axis_mac_tvalid => tx_valid,
			tx_axis_mac_tlast => tx_last,
			tx_axis_mac_tuser(0) => tx_error,
			tx_axis_mac_tready => tx_ready,
			pause_req => '0',
			pause_val => X"0000",
			clk_enable => clk_en,
			speedis100 => speed100,
			speedis10100 => speed10100,
			gmii_txd => gmii_txd,
			gmii_tx_en => gmii_tx_en,
			gmii_tx_er => gmii_tx_er,
			gmii_rxd => gmii_rxd,
			gmii_rx_dv => gmii_rx_dv,
			gmii_rx_er => gmii_rx_er,
			rx_configuration_vector => rx_config_vector,
			tx_configuration_vector => tx_config_vector
		);

     rx_config_vector<= X"0000_0000_0000_0000" & "00" & status_vector(11 downto 10) & x"812";
     tx_config_vector<= X"0000_0000_0000_0000" & "00" & status_vector(11 downto 10) & x"012";

	-- Vivado generates a CRC error if you drive the CPLLLOCKDET circuitry with
	-- the same clock used to drive the transceiver PLL.  While this makes sense
	-- if the clk is derved from the CPLL (e.g. TXOUTCLK) it is less clear is 
	-- essential if you use the clock raw from the input pins.  The short story
	-- is that it has always worked in the past with ISE, but Vivado generates 
	-- DRC error.  Can be bypassed by decoupling the clock from the perpective 
	-- of the tools by just toggling a flip flop, which is what is done below.

--	process(clk_fr)
--	begin
--		if rising_edge(clk_fr) then
--			decoupled_clk <= not decoupled_clk;
--		end if;
--	end process;

	phy:gig_ethernet_pcs_pma_0
		port map(
			gtrefclk => gt_clk,
			gtrefclk_bufg => clk_gt125,
			txp => gt_txp,
			txn => gt_txn,
			rxp => gt_rxp,
			rxn => gt_rxn,
			txoutclk => txoutclk_ub,
			rxoutclk => rxoutclk_ub,
			resetdone => phy_done,
			mmcm_reset => pll_rst,
			mmcm_locked => mmcm_locked,
			userclk => clk62_5,
			userclk2 => clk125,
			rxuserclk => rxoutclk,
			rxuserclk2 => rxoutclk,
			independent_clock_bufg => clk_drp,
			pma_reset => rsti,
			sgmii_clk_en => clk_en,
			gmii_txd => gmii_txd,
			gmii_tx_en => gmii_tx_en,
			gmii_tx_er => gmii_tx_er,
			gmii_rxd => gmii_rxd,
			gmii_rx_dv => gmii_rx_dv,
			gmii_rx_er => gmii_rx_er,
			gmii_isolate => open,
			configuration_vector => "10000",
			an_adv_config_vector => x"0020",
			an_restart_config =>'0',
			basex_or_sgmii=>sgmii,
			speed_is_10_100 => speed10100,
			speed_is_100 => speed100,
			status_vector => status_vector,
			reset => rst_pcs,
			signal_detect => '1',
			gt0_qplloutclk_in => '0',
			gt0_qplloutrefclk_in => '0'
		);
		
end rtl;
