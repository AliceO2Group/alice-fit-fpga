-- clocks_7s_serdes
--
-- Input is a free-running 125MHz clock (taken straight from MGT clock buffer)
--
-- Dave Newbold, April 2011

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.VComponents.all;

entity clocks_7s_serdes is
	port(
	    gt_clk: in std_logic;
		clki_gt125: in std_logic; -- Input free-running clock (125MHz)
		clki_125: in std_logic; -- Ethernet domain clk125
		clko_ipb: out std_logic; -- ipbus domain clock (31MHz)
		clko_drp: out std_logic;
		eth_locked: in std_logic; -- ethernet locked signal
		locked: out std_logic; -- global locked signal
		nuke : in std_logic; -- hard reset input
		rsto_125: out std_logic; -- clk125 domain reset (held until ethernet locked)
		rsto_ipb: out std_logic; -- ipbus domain reset
		rsto_eth: out std_logic; -- ethernet startup reset (required!)
		rsto_ipb_ctrl: out std_logic; -- ipbus domain reset for controller
		rsto_fr: out std_logic; -- free-running clock domain reset
		onehz: out std_logic; -- blinkenlights output
		clk200: out std_logic
	);

end clocks_7s_serdes;

architecture rtl of clocks_7s_serdes is
	
	signal dcm_locked, sysclk, clk_ipb_i, clk_ipb_b, gt_clkbh : std_logic;
	signal clk_p40_i, clk_p40_b: std_logic;
	signal d17, d17_d: std_logic;
	signal nuke_i, nuke_d, nuke_d2, eth_done: std_logic := '0';
	signal rst, rst_ipb, rst_125, rst_ipb_ctrl: std_logic := '1';
	
	component PLL125
    port
     ( clkout1          : out    std_logic;
       clkout2          : out    std_logic;
       clkout3          : out    std_logic;
      reset             : in     std_logic;
      locked            : out    std_logic;
      clkin1           : in     std_logic
     );
    end component;
	
begin

sysclk <= clki_gt125; clko_ipb <= clk_ipb_b;

	bufh_pll125: BUFH port map(
            i => gt_clk,
            o => gt_clkbh
        );

pll: PLL125 port map(clkout1 => clk_ipb_b, clkout2 => clko_drp,  clkout3 => clk200, clkin1 => gt_clkbh, locked => dcm_locked, reset => '0');
	
	clkdiv: entity work.ipbus_clock_div port map(
		clk => sysclk,
		d17 => d17,
		d28 => onehz
	);
	
	process(sysclk)
	begin
		if rising_edge(sysclk) then
		
			if (nuke='1') then nuke_i <='1';
			 else if d17='1' and d17_d='0' then nuke_i <='0'; end if;
            end if;			 

			d17_d <= d17;
			if d17='1' and d17_d='0' then
				rst <= nuke_d2 or not dcm_locked;
				nuke_d <= nuke_i; -- ~1ms time bomb (allows return packet to be sent)
				nuke_d2 <= nuke_d;
				eth_done <= (eth_done or eth_locked) and not rst;
				rsto_eth <= rst; -- delayed reset for ethernet block to avoid startup issues
			end if;
		end if;
	end process;
	
	locked <= dcm_locked;
	
	process(clk_ipb_b)
	begin
		if rising_edge(clk_ipb_b) then
			rst_ipb <= rst;
		end if;
	end process;
	
	rsto_ipb <= rst_ipb;
	
	process(clk_ipb_b)
	begin
		if rising_edge(clk_ipb_b) then
			rst_ipb_ctrl <= rst;
		end if;
	end process;
	
	rsto_ipb_ctrl <= rst_ipb_ctrl;
	
	process(clki_125)
	begin
		if rising_edge(clki_125) then
			rst_125 <= rst or not eth_done;
		end if;
	end process;
	
	rsto_125 <= rst_125;
	
	rsto_fr <= rst;
		
end rtl;
