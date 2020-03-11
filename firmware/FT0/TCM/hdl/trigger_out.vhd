----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/17/2019 07:01:25 PM
-- Design Name: 
-- Module Name: trigger_out - RTL
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trigger_out is 
   Port(clk320 : in STD_LOGIC;
        T_in : in STD_LOGIC;
        T_out : out STD_LOGIC;
        mode : in STD_LOGIC_VECTOR (2 downto 0);
        ipb_clk : in STD_LOGIC;
        DI : in STD_LOGIC_VECTOR (31 downto 0);
        DO : out STD_LOGIC_VECTOR (31 downto 0);
        CO : out STD_LOGIC_VECTOR (31 downto 0);
        A : in STD_LOGIC;
        wr  : in STD_LOGIC;
        c_rd  : in STD_LOGIC;
        c_clr  : in STD_LOGIC;
        mt_cnt : in STD_LOGIC_VECTOR (2 downto 0);
        T_r : out STD_LOGIC
        );
end trigger_out;

architecture RTL of trigger_out is

signal tgl, rndm, T_i, T_o, T_c, rfb : STD_LOGIC;
signal s_cou : STD_LOGIC_VECTOR (9 downto 0);
signal sgn : STD_LOGIC_VECTOR (21 downto 0);
signal ts : STD_LOGIC_VECTOR (13 downto 0);
signal rate, rreg : STD_LOGIC_VECTOR (30 downto 0);
signal count, c_buf : STD_LOGIC_VECTOR (31 downto 0);
begin

T_out<=T_o; CO<=c_buf;
 
T_r <= T_in when (mode="100") else '0';

DO<=x"0000" & "00" & ts when (A='0') else '0' & rate;

with mode select
T_i <= T_in when "100",
         tgl when "101",
         sgn(21) when "110",
         rndm when "111",
         '0' when others;
         
rfb<=not (rreg(27) xor rreg(30));         

process (ipb_clk)
begin
if (ipb_clk'event) and (ipb_clk='1') then

if (wr='1') then

if (A='0') then ts<=DI(13 downto 0); else rate<=DI(30 downto 0); end if;

end if; 

end if;
end process;


process (clk320)
begin
if (clk320'event) and (clk320='1') then

if (c_rd='1') then c_buf<=count; end if;  

if (c_clr='1') then count<=(others=>'0'); 
  else  if (T_c='1') and (mt_cnt="011") then count<=count+1; end if;
end if;


if (mt_cnt="010") then 

T_o<=T_i; T_c<=T_i; rreg<=rreg(29 downto 0) & rfb;

if (unsigned(rreg)<unsigned(rate)) then rndm<='1'; else rndm<='0'; end if; 

tgl<=not tgl; 

if (s_cou/=999) then 
    s_cou<=s_cou+1;
    sgn<=sgn(20 downto 0) & '0'; 

  else 
    s_cou<=(others=>'0'); 
    sgn<=x"B1" & ts;
 end if;
 
 
 
end if;
end if;
end process;

end RTL;
