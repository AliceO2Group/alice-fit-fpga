-- Calculates 16 bit 1's compliment or 2's compliment sum a byte at a time
-- For 2's compliment first byte is the high byte
--
-- Dave Sankey, June 2012

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity udp_byte_sum is
  port (
    mac_clk: in std_logic;
    do_sum: in std_logic;
    clr_sum: in std_logic;
    my_rx_data: in std_logic_vector(7 downto 0);
    my_rx_valid: in std_logic;
    int_data: in std_logic_vector(7 downto 0);
    int_valid: in std_logic;
    cksum: in std_logic;
    run_byte_sum: in std_logic;
    outbyte: out std_logic_vector(7 downto 0)
  );
end udp_byte_sum;

architecture rtl of udp_byte_sum is

  signal carry_bit: std_logic;
  signal hi_byte, lo_byte: unsigned(8 downto 0);

begin

  outbyte <= std_logic_vector(hi_byte(7 downto 0));

lo_byte_calc: process (mac_clk)
  variable hi_byte_int, lo_byte_int : unsigned(8 downto 0);
  variable int_data_buf: std_logic_vector(7 downto 0);
  variable clr_sum_buf, int_valid_buf: std_logic;
  begin
    if rising_edge(mac_clk) then
      if do_sum = '1' and clr_sum = '1' then
        clr_sum_buf := '1';
      end if;
      if do_sum = '1' and int_valid = '1' then
        int_data_buf := int_data;
	int_valid_buf := '1';
      end if;
      if my_rx_valid = '1' or run_byte_sum = '1' then
        if clr_sum_buf = '1' then
          hi_byte_int := (Others => '0');
	  clr_sum_buf := '0';
        else
          hi_byte_int := hi_byte;
        end if;
        if do_sum = '1' then
	  if int_valid_buf = '1' then
            lo_byte_int := unsigned('0' & int_data_buf);
	    int_valid_buf := '0';
	  else
            lo_byte_int := unsigned('0' & my_rx_data);
	  end if;
        else
          lo_byte_int := (Others => '0');
        end if;
      end if;
      lo_byte <= hi_byte_int + lo_byte_int;
    end if;
  end process;

hi_byte_calc: process (mac_clk)
  variable carry_bit_int, hi_lo, clr_sum_buf : std_logic;
  variable hi_byte_int : unsigned(8 downto 0);
  begin
    if rising_edge(mac_clk) then
      if do_sum = '1' and clr_sum = '1' then
        clr_sum_buf := '1';
      end if;
      if my_rx_valid = '1' or run_byte_sum = '1' then
        if clr_sum_buf = '1' then
          hi_byte_int := (Others => '0');
          carry_bit_int := '0';
	  hi_lo := '1';
	  clr_sum_buf := '0';
	else
          if carry_bit = '1' and hi_lo = '1' then
            hi_byte_int := unsigned('0' & lo_byte(7 downto 0)) + 1;
          else
            hi_byte_int := unsigned('0' & lo_byte(7 downto 0));
          end if;
	  carry_bit_int := lo_byte(8);
	  hi_lo := cksum or not hi_lo;
        end if;
      end if;
      carry_bit <= carry_bit_int;
      hi_byte <= hi_byte_int;
    end if;
  end process;

end rtl;
