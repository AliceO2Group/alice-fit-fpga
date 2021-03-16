library ieee;
use ieee.std_logic_1164.all;


package PM12_pkg is
type trig_time is array (0 to 11)  of STD_LOGIC_VECTOR (9 downto 0);
type trig_ampl0 is array (0 to 11) of STD_LOGIC_VECTOR(12 downto 0);
type hyst_vector is array (0 to 11) of STD_LOGIC_VECTOR(25 downto 0);
end package; 
