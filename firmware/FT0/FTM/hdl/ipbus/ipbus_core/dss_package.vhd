library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- 2015/07/14: spi types added

package dss is

	type dss_data_array is array(natural range <>) of std_logic_vector(31 downto 0);

-- The signals going from master to slaves
	type spi_mo is
    record
        clk: std_logic;
      	mosi: std_logic;
      	le: std_logic;
    end record;

-- The signals going from slaves to master	 
	type spi_mi is
    record
        miso: std_logic;
    end record;
	 
end dss;

