----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/22/2021 07:40:08 PM
-- Design Name: 
-- Module Name: hyst - RTL
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.PM12_pkg.all; 


entity hyst is
  Port ( 
        clk320 : in std_logic;
        hyst_inp_data : in hyst_vector;
        hyst_a : in std_logic_vector(11 downto 0);
        hyst_t : in std_logic_vector(11 downto 0);
        hyst_st : in std_logic;
        cnt_clr : in std_logic;
        busy : out std_logic;
        hyst_addr_i : in std_logic_vector(16 downto 0);
        hyst_addr_o : out std_logic_vector(16 downto 0);
        wr_addr : in std_logic;
        hyst_data_o : out std_logic_vector(31 downto 0);
        n_addr : in std_logic;
        lock320 : in std_logic;
        stp : out std_logic
  );
end hyst;

architecture RTL of hyst is

type data1_vect is array (0 to 11) of STD_LOGIC_VECTOR (0 downto 0);
type data9_vect is array (0 to 11) of STD_LOGIC_VECTOR (8 downto 0);
type data13_vect is array (0 to 11) of STD_LOGIC_VECTOR (12 downto 0);
type data16_vect is array (0 to 11) of STD_LOGIC_VECTOR (15 downto 0);
type data32_vect is array (0 to 11) of STD_LOGIC_VECTOR (31 downto 0);

signal wr_mem_t, wr_mem_a, wr_mem_an : data1_vect;
signal t_in, t_out, a_in, a_out, an_in, an_out : data16_vect;
signal loc_addr :  std_logic_vector (16 downto 0);
signal t_rd, a_rd, an_rd : data32_vect;
signal ampln_addr : data9_vect;
signal ampl_addr : data13_vect;
signal clr, lock : std_logic;
signal wr_b :  std_logic_vector (0 downto 0);
signal hyst_a0, hyst_a1, hyst_a2, hyst_t0, hyst_t1, hyst_t2, ovf : std_logic_vector (11 downto 0);
signal hyst_data : hyst_vector;

COMPONENT hyst_mem4k
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    regceb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

COMPONENT hyst_mem8k
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    regceb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

COMPONENT hyst_mem512
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    regceb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

begin

busy<= clr; hyst_addr_o <= loc_addr; lock<= not lock320;

hyst_data_o<= a_rd(to_integer(unsigned(loc_addr(16 downto 13))))   when (loc_addr(12) = '0') else
              t_rd(to_integer(unsigned(loc_addr(16 downto 13))))  when (loc_addr(12 downto 11) = "10") else
              an_rd(to_integer(unsigned(loc_addr(16 downto 13))));
              
 stp<='1' when (ovf/=0)  else '0';               

mem: for i in 0 to 11 generate

mem4k: hyst_mem4k port map (clka =>clk320, wea=>wr_mem_t(i), addra => hyst_data(i)(11 downto 0), dina =>t_in(i), douta => t_out(i), clkb =>clk320, regceb =>lock, web =>wr_b, addrb=> loc_addr(10 downto 0), dinb=> (others=>'0'), doutb => t_rd(i)); 
mem8k: hyst_mem8k port map (clka =>clk320, wea=>wr_mem_a(i), addra => ampl_addr(i), dina =>a_in(i), douta => a_out(i), clkb =>clk320, regceb =>lock, web => wr_b, addrb=> loc_addr(11 downto 0), dinb=> (others=>'0'), doutb => a_rd(i)); 
mem512: hyst_mem512 port map (clka =>clk320, wea=>wr_mem_an(i), addra => ampln_addr(i), dina =>an_in(i), douta => an_out(i), clkb =>clk320, regceb =>lock, web => wr_b, addrb=> loc_addr(7 downto 0), dinb=> (others=>'0'), doutb => an_rd(i)); 

ampln_addr(i) <=  hyst_data(i)(25) & (not  hyst_data(i)(19 downto 12));
ampl_addr(i) <=  hyst_data(i)(25) & hyst_data(i)(23 downto 12);
wr_b(0)<=clr;


t_in(i)<=  x"FFFF" when (t_out(i)=x"FFFF") else
           t_out(i)+1;

a_in(i)<=  x"FFFF" when (a_out(i)=x"FFFF") else
           a_out(i)+1;

an_in(i)<= x"FFFF" when (an_out(i)=x"FFFF") else
           an_out(i)+1;
           
           
wr_mem_t(i)(0)<= hyst_t2(i);
wr_mem_a(i)(0)<= hyst_a2(i) and (not hyst_data(i)(24));
wr_mem_an(i)(0)<=hyst_a2(i) and hyst_data(i)(24);

end generate;


process (clk320)
begin
if (clk320'event and clk320='1') then

if (hyst_st='1') then hyst_t0<= hyst_t and (not hyst_t1);
  else hyst_t0<=(others=>'0');
end if;

hyst_t2<= hyst_t1; hyst_t1<= hyst_t0;

if (hyst_st='1') then hyst_a0<= hyst_a and (not hyst_a1);
  else hyst_a0<=(others=>'0');
end if;

hyst_a2<= hyst_a1; hyst_a1<= hyst_a0; 

for i in 0 to 11 loop

if (hyst_st='1') and  (hyst_t1(i)='0') then hyst_data(i)(11 downto 0) <= hyst_inp_data(i)(11 downto 0); end if; 
if (hyst_st='1') and  (hyst_a1(i)='0') then hyst_data(i)(25 downto 12) <= hyst_inp_data(i)(25 downto 12); end if;
if ((t_out(i)>=x"FFFE") and (wr_mem_t(i)(0)='1')) or ((a_out(i)>=x"FFFE") and (wr_mem_a(i)(0)='1')) or ((an_out(i)>=x"FFFE") and (wr_mem_an(i)(0)='1')) then ovf(i)<= '1' ; else ovf(i)<= '0'; end if;
end loop;

if (cnt_clr='1') then clr <='1'; 
   else 
   if (loc_addr(11 downto 0) = x"FFF") then clr<='0'; end if;
end if; 

if (cnt_clr='1') then loc_addr(11 downto 0)<= (others=>'0');
 else
  if (clr='1') then loc_addr(11 downto 0)<= loc_addr(11 downto 0)+1; 
    else
     if (wr_addr='1') then loc_addr<=hyst_addr_i;
       else 
       if (n_addr='1') then 
       if (loc_addr(12 downto 0)>='1' & x"8ff") then 
         loc_addr(12 downto 0)<=(others=>'0'); 
         if (loc_addr(16 downto 13)<11) then loc_addr(16 downto 13)<= loc_addr(16 downto 13)+1;
          else loc_addr(16 downto 13)<=x"0";
         end if;
        else
         loc_addr(12 downto 0)<=loc_addr(12 downto 0)+1;
       end if; 
      end if;
     end if;
  end if;
end if;

end if;
end process;

end RTL;
