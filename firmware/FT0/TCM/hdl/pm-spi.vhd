----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2018 10:36:31 PM
-- Design Name: 
-- Module Name: pm-spi - combined
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
library UNISIM;
use UNISIM.VComponents.all;

entity pm_spi is
 Port ( CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        DI : in STD_LOGIC_VECTOR (31 downto 0);
        DO : out STD_LOGIC_VECTOR (31 downto 0);
        A : in STD_LOGIC_VECTOR (8 downto 0);
        wr  : in STD_LOGIC;
        rd : in STD_LOGIC;
        cs : in STD_LOGIC;
        rdy : out STD_LOGIC;
        spi_sel : out STD_LOGIC;
        spi_clk : out STD_LOGIC;
        spi_mosi : out STD_LOGIC;
        spi_miso : in STD_LOGIC;
        cnt_rd : in STD_LOGIC
        );
        
end pm_spi;

architecture RTL of pm_spi is

signal count : STD_LOGIC_VECTOR (7 downto 0);
signal Dreg : STD_LOGIC_VECTOR (47 downto 0);
signal A_old, A_spi : STD_LOGIC_VECTOR (7 downto 0);
signal fifo_out : STD_LOGIC_VECTOR (31 downto 0);
signal A_cou : STD_LOGIC_VECTOR (4 downto 0);
signal cont, mode16, eoc, n_addr, rd_cou, smode, rd_spi, cs_spi, fifo_wr, fifo_rd, fifo_full, fifo_empty, reg_rd : STD_LOGIC;
signal fifo_cou : STD_LOGIC_VECTOR (9 downto 0);


COMPONENT COUNTER_FIFO
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT; 


begin

rdy<='1' when ((cs='1') and (eoc='1') and (smode='0')) or (fifo_rd='1') or (reg_rd='1') else '0';



cs_spi <='1' when (cs='1') and (A(8)='0') else '0';

DO <= fifo_out when (fifo_rd='1') else
      x"00000" & "00" & fifo_cou when (reg_rd='1') else
      x"0000" & Dreg(15 downto 0) when (mode16='1') else
      Dreg(31 downto 0);
      
reg_rd<='1' when  (cs='1') and (rd='1') and (A='1' & x"01") else '0';

spi_mosi<=Dreg(47);

A_spi<=A(7 downto 0) when (smode='0') else "110" & A_cou;
rd_spi<= rd when (smode='0') else '1';

spi_clk <= count(1) when (count(7 downto 2)/="000000") else '0';


mode16<= '1'  when A_spi(7 downto 4)<x"C" else '0';
eoc <= '1' when ((count=x"83") and (mode16='1')) or ((count=x"C3") and (mode16='0')) else '0';
n_addr <='1' when ((A_spi(7 downto 0)-A_old)="000000001") and (cont='1') else '0'; 

fifo1 : COUNTER_FIFO PORT MAP (clk => clk, srst => rst, din => Dreg(31 downto 0), wr_en => fifo_wr, rd_en => fifo_rd,  dout =>fifo_out, full =>fifo_full , empty => fifo_empty , data_count =>fifo_cou ); 

fifo_wr<='1' when (smode='1') and (eoc='1') and (fifo_full='0') else '0';
fifo_rd<='1' when (A='1' & x"00") and (cs='1') and (fifo_empty='0') and (rd='1') else '0';

process (CLK)
begin
if (CLK'event) and (CLK='1') then

if (rst='1') then rd_cou<='0'; smode<='0';
  else
 if (cnt_rd='1') and (fifo_cou<480) then rd_cou<='1'; A_cou<="00000"; end if; 
 
 if (rd_cou='1') then
  if (cs_spi='0') and (smode='0') then smode<='1'; end if;
  if ((cs_spi='1') or (A_cou=23)) and (smode='1') and (eoc='1') then smode<='0'; end if;
  if (A_cou=23) and (smode='1') and (eoc='1') then rd_cou<='0'; end if; 
  if (smode='1') and (eoc='1') then A_cou<=A_cou+1; end if;

 end if;  
end if;

 if (rst='1') or ((cs_spi='0') and (smode='0')) then count<=x"00"; spi_sel<='1';  Dreg(47)<='0'; cont<='0';
  else
 
 
 if (eoc='1') then count<=x"00"; if (smode='1') and (cs_spi='1') then cont<='0'; else cont<='1'; end if; 
   else 
    if (n_addr='1') and (count=x"01") then count<=x"46";
    else  count<=count+1; end if;
 end if;
 
 if (count=x"05") then 
         if (mode16='1') then Dreg(47 downto 16) <= rd_spi & '0' & A_spi & "000000" & DI(15 downto 0); else  Dreg <= rd_spi & '0' & A_spi & "000000" & DI; end if;
         A_old<=A_spi; spi_sel<='1'; 
   else
     if (count=x"01") then 
       if (n_addr='1') then A_old<=A_spi; else spi_sel<='0'; end if;
     end if;
     if (count=x"01") and (n_addr='1') and (rd_spi='0') then 
        if (mode16='1') then Dreg(47 downto 32) <= DI(15 downto 0); else Dreg(47 downto 16) <= DI; end if;
      else 
        if (count(1 downto 0)="01")  then Dreg<=Dreg(46 downto 0) & not spi_miso; end if; 
     end if;
 end if;
  
 end if;

end if;
end process;


end RTL;
