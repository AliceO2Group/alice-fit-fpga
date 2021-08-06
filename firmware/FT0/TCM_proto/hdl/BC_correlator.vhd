----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/05/2021 08:02:13 PM
-- Design Name: 
-- Module Name: BC_correlator - Behavioral
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

entity BC_correlator is
    Port ( clk320  : in STD_LOGIC;
           BC_cou : in STD_LOGIC_VECTOR (11 downto 0);
           mt_cou : in STD_LOGIC_VECTOR (2 downto 0);
           inc : in STD_LOGIC; 
           clr : in STD_LOGIC;
           ipb_clk : in STD_LOGIC;
           rd : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (11 downto 0);
           data : out STD_LOGIC_VECTOR (31 downto 0)
           );
end BC_correlator;

architecture RTL of BC_correlator is

signal ack0, clr_mem, clr_req, inc_i, wea : STD_LOGIC;
signal m_rd, m_wr : STD_LOGIC_vector (31 downto 0);

COMPONENT BC_corr_mem
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;


begin

m0 : BC_corr_mem PORT MAP (clka => clk320, wea(0) => wea, addra => BC_cou, dina => m_wr, douta => m_rd, clkb => ipb_clk, web => "0", addrb => addr, dinb => (others=>'0'), doutb => data);


m_wr<= x"0000000" & "000" & inc_i when (clr_mem='1') 
else m_rd+1 when (m_rd/=x"FFFFFFFF") else x"FFFFFFFF";

wea<= '1' when ((clr_mem='1') or (inc='1')) and (mt_cou="100") else '0';

process(clk320)
begin
if (clk320'event and clk320='1') then

 if (clr='1') then clr_req<='1'; else 
  if (clr_req='1') and (BC_cou=0) and (mt_cou="010") then clr_req<='0'; end if; 
 end if;

if  (BC_cou=0) and (mt_cou="010") then clr_mem<=clr_req; end if;

if (mt_cou="011") then   inc_i<= inc; end if;

end if;
end process;

end RTL;
