-- ipbus_spi
--
-- Wrapper for opencores spi wishbone slave
--
-- http://opencores.org/project/spi
--
-- Dave Newbold, Jul 2015

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ipbus.all;
--use work.ipbus_reg_types.all;

entity ipbus_spi is
	port(
		clk: in std_logic;
		rst: in std_logic;
		ipb_data_w: in std_logic_vector(31 downto 0);
		ipb_data_r: out std_logic_vector(31 downto 0);
		ipb_spi_adr: in std_logic_vector(2 downto 0);
		ipb_sel : in std_logic;
		ipb_wr :  in std_logic;
		ipb_err :  out std_logic;
		ipb_ack :  out std_logic;
		ss: out std_logic;
		mosi: out std_logic;
		miso: in std_logic;
		sclk: out std_logic
	);
	
end ipbus_spi;

architecture rtl of ipbus_spi is

    component spi_top port (
        wb_clk_i : in std_logic;
        wb_rst_i : in std_logic;
        wb_adr_i : in std_logic_vector(4 downto 0);
        wb_dat_i : in std_logic_vector(31 downto 0);
        wb_dat_o : out std_logic_vector(31 downto 0);
        wb_sel_i : in std_logic_vector(3 downto 0);
        wb_we_i : in std_logic;
        wb_stb_i : in std_logic;
        wb_cyc_i : in std_logic;
		wb_ack_o : out std_logic;
        wb_err_o : out std_logic;
        wb_int_o : out std_logic;
        ss_pad_o : out std_logic;
        sclk_pad_o : out std_logic;
        mosi_pad_o : out std_logic;
        miso_pad_i : in std_logic
    );
    end component;

	signal stb, ack, err: std_logic;
	constant BIT_00 : std_logic_vector := "00";
	constant BIT_1 : std_logic := '1';
	constant BIT_1111 : std_logic_vector := "1111";

begin

	stb <= ipb_sel and not (ack or err);
--	spi: entity work.spi_top
	spi: spi_top
		port map(
			wb_clk_i => clk,
			wb_rst_i => rst,
			wb_adr_i(4 downto 2) => ipb_spi_adr,
			wb_adr_i(1 downto 0) => BIT_00,
			wb_dat_i => ipb_data_w,
			wb_dat_o => ipb_data_r,
			wb_sel_i => BIT_1111,
			wb_we_i => ipb_wr,
			wb_stb_i => stb,
			wb_cyc_i => BIT_1,
			wb_ack_o => ack,
			wb_err_o => err,
			wb_int_o => open,
			ss_pad_o => ss,
			sclk_pad_o => sclk,
			mosi_pad_o => mosi,
			miso_pad_i => miso
		);
	
	ipb_ack <= ack;
	ipb_err <= err;
	
end rtl;

