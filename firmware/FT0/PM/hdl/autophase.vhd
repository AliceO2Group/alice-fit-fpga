----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/30/2020 02:17:33 PM
-- Design Name: 
-- Module Name: autophase - RTL
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
library UNISIM;
use UNISIM.VComponents.all;

entity autophase is
Port ( clk : in STD_LOGIC;
       lock : in STD_LOGIC;
       jump : in STD_LOGIC;
       psen : out STD_LOGIC;
       psincdec :  out STD_LOGIC;
       done  :  out STD_LOGIC;
       shift : out STD_LOGIC_VECTOR (5 downto 0)
       );
end autophase;

architecture RTL of autophase is

signal ms_cou  : STD_LOGIC_VECTOR (18 downto 0);
signal t1ms, tstr, dir, done_i, lock_i, wasjmp : STD_LOGIC;
signal state  : STD_LOGIC_VECTOR (2 downto 0);
signal m0, ml : STD_LOGIC_VECTOR (6 downto 0);
signal mh0 : STD_LOGIC_VECTOR (7 downto 0);

begin

psincdec<=dir; done<=done_i;

mh0<= std_logic_vector(resize(signed(m0),8))+std_logic_vector(resize(signed(ml),8));
shift<=m0(5 downto 0);

process(clk, lock)
begin
if (lock='0') then lock_i<='0'; ms_cou <=(others=>'0'); state <=(others=>'0'); wasjmp <='0'; done_i<='0'; dir<='0'; m0 <=(others=>'0'); psen<='0'; tstr<='0'; t1ms<='0';
 else 
if (clk'event and clk='1') then lock_i<='1';

tstr<=t1ms;  psen<=tstr and (not done_i);

  
if (done_i='0') and (lock_i='1') then
   if (tstr='1') then
      if (dir='0') then  m0<=m0-1; else m0<=m0+1; end if;
     end if;
    
  if (jump='1') then wasjmp <='1'; 
    else if (tstr='1') then wasjmp<='0'; end if;
  end if; 

if (ms_cou=299999) then ms_cou <=(others=>'0'); t1ms<='1'; 
  else ms_cou<=ms_cou+1; t1ms<='0'; end if;

if (t1ms='1') then

 case to_integer(unsigned(state)) is
    when 0 => if (m0="1010110") then state<="110"; dir<='1';
              else
              if (wasjmp='1') then state<="001"; dir<='1'; end if;
              end if;
    when 1 => if (wasjmp='0')  then state<="010"; ml<= m0; end if;
    when 2 => if (wasjmp='1')  then state<="001";
              else
              if (m0=(ml+"0000111")) then  state<="011"; end if;
              end if;
    when 3 => if (m0="0101010") then state<="110"; dir<='0';
              else  
              if (wasjmp='1') then state<="100"; dir<='0';  end if;
              end if;
    when 4 => if (wasjmp='0')  then state<="101";
                if (mh0(7)='0') and (mh0(6 downto 1)>14) then ml<= mh0(7 downto 1)-28; 
                
                elsif (mh0(7)='1') and (mh0(6 downto 1)<"110010") then ml<= mh0(7 downto 1)+28; dir<='1'; 
                
                else 
                ml<= mh0(7 downto 1);
               end if; 
               end if;
    when 5 => if (m0=ml) then done_i<='1'; end if;
    when 6 => if (m0=0) then state<="000"; dir<='0'; end if;
    when others => null;
 end case;

 end if;

end if;

end if;

end if;
end process;

end RTL;
