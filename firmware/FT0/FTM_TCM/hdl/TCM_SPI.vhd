----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2019 05:50:02 PM
-- Design Name: 
-- Module Name: TCM_SPI - RTL
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

entity TCM_SPI is
    Port ( sck : in STD_LOGIC;
           sel : in STD_LOGIC;
           mosi : in STD_LOGIC;
           miso : out STD_LOGIC);
end TCM_SPI;

architecture RTL of TCM_SPI is

signal spi_bit_count : STD_LOGIC_VECTOR (4 downto 0);
signal SPI_DATA, spi_wr_data : STD_LOGIC_VECTOR (15 downto 0);
signal mem_wr_data, mem_rd_data  : STD_LOGIC_VECTOR (31 downto 0);
signal spi_addr : STD_LOGIC_VECTOR (8 downto 0);
signal spi_na, spi_rd, spi_h, mosi_i : STD_LOGIC;
signal mem_wr : STD_LOGIC_VECTOR(0 DOWNTO 0);

COMPONENT spi_mem
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

begin

miso<=SPI_DATA(15); mosi_i<=not mosi;

buf: spi_mem  port map (clka=> sck, wea=> mem_wr, addra=> spi_addr(7 downto 0), dina=>mem_wr_data, douta=>mem_rd_data);

mem_wr_data<=SPI_DATA(14 downto 0) & mosi_i & spi_wr_data;

mem_wr(0)<='1' when (spi_rd='0') and (spi_bit_count="11111") and (spi_h='1') else '0';

process (sck, sel)
begin
if (sel='1') then spi_bit_count<="00000"; spi_na<='0'; 
else
if (SCK'event and SCK='1') then 

      if (spi_bit_count="11111") then  spi_bit_count<="10000";
              if  (spi_rd='0') then  spi_na<='1';
                 if (spi_h='0') then spi_wr_data<= SPI_DATA(14 downto 0) & mosi_i;
                 end if;
              end if;
      else 
        spi_bit_count<=spi_bit_count+1; 
      end if;
        
      if (spi_bit_count="10000") and (spi_na='1') then 
          if  (spi_h='1') then spi_addr <= spi_addr+1; end if;
          if  (spi_addr(7 downto 4)>=x"C") then spi_h<= not spi_h; end if;
      end if;
        
      if (spi_bit_count="00000") then spi_rd <= mosi_i; end if;
      if (spi_bit_count="01001") then spi_addr <= SPI_DATA(7 downto 0) & mosi_i; 
         if   (SPI_DATA(6 downto 3)>=x"C") then spi_h<='0';  else spi_h<='1'; end if;
      end if;
        
        if (spi_bit_count(3 downto 0)=x"F") and (spi_rd='1') then  spi_na<='1';
        if (spi_h='1') then SPI_DATA<=mem_rd_data(31 downto 16); else SPI_DATA<=mem_rd_data(15 downto 0); end if;
            else SPI_DATA<=SPI_DATA(14 downto 0) & mosi_i; 
        end if; 
        
end if;
end if;
end process;



end RTL;
