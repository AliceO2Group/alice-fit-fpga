----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/03/2017 09:02:28 PM
-- Design Name: 
-- Module Name: TDCCHAN - tdcchan
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TDCCHAN is
    Port ( pin_in : in STD_LOGIC;
           pin_out : out STD_LOGIC;
           clk300 : in STD_LOGIC;
           clk600 : in STD_LOGIC;
           clk600_90 : in STD_LOGIC;
           reset : in STD_LOGIC;
           tdcclk : in STD_LOGIC;
           rstr : in STD_LOGIC;
           rdata : in STD_LOGIC;
           tdc_count : in STD_LOGIC_VECTOR (3 downto 0);
           bc_time : in STD_LOGIC_VECTOR (6 downto 0);
           tdc_out : out STD_LOGIC_VECTOR (11 downto 0);
           tdc_rdy : out STD_LOGIC;
           fifo_full : out STD_LOGIC;
           tdc_raw : out STD_LOGIC_VECTOR (12 downto 0);
           tdc_raw_lock : in STD_LOGIC
           );
end TDCCHAN;

architecture RTL of TDCCHAN is

signal C_STR, C_STR1, C_STR2, TDCFIFO_wr,TDCFIFO_rd,TDCFIFO_full,TDCFIFO_empty,rs300_0,rs300_1,rs300_2,TDCF_cou_40,rs_1, TDC_rdy1, TDC_raw_wr, reset300 : STD_LOGIC;
signal C_BITS, TDC_bitcount : STD_LOGIC_VECTOR (2 downto 0);
signal C_TIME, C_PER, TDC : STD_LOGIC_VECTOR (6 downto 0);
signal C_FIFO, TDCF_cou : STD_LOGIC_VECTOR (5 downto 0);
signal CH_CORR : STD_LOGIC_VECTOR (4 downto 0);
signal tdc_raw_i : STD_LOGIC_VECTOR (12 downto 0);


component pin_capt
    Port ( pin_in : in  STD_LOGIC;
           pin_out : out  STD_LOGIC;
           clk600 : in  STD_LOGIC;
           clk600_90 : in  STD_LOGIC;
           clk300 : in  STD_LOGIC;
           str : out  STD_LOGIC;
           ptime : out  STD_LOGIC_VECTOR (2 downto 0));
end component;

component TDC_FIFO
	Port (  clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC);
   end component ;
   
begin

tdc_raw<=tdc_raw_i;

PINCAPT: pin_capt port map ( pin_in => pin_in, pin_out => pin_out, clk600 => clk600, clk600_90 => clk600_90, clk300 => clk300, str => C_STR, ptime => C_BITS);
TDCFIFO: TDC_FIFO port map (clk => clk300,  srst =>reset300, din =>C_TIME(6 downto 1), wr_en => TDCFIFO_wr, rd_en =>TDCFIFO_rd, dout => C_FIFO, full =>TDCFIFO_full, empty =>TDCFIFO_empty);

process (clk300)
begin
if (clk300'event and clk300='1') then 

reset300<=reset;
		
	C_STR1<=C_STR;  C_STR2<=C_STR1;  
	if (C_STR='1' and C_STR1='0') then C_PER<= tdc_count & C_BITS; end if;
	
	if (TDCFIFO_wr='1') then fifo_full<=TDCFIFO_full; end if;	
	if (rs300_1='0') or (TDCFIFO_empty='1') or (TDCF_cou_40='1') then TDCF_cou<="000000";
           else TDCF_cou <= TDCF_cou + 1; end if;
                          
     rs300_0<=rstr; rs300_2<=rs300_1; rs300_1<=rs300_0;
end if;
end process;

C_TIME<= (C_PER - bc_time);  TDCFIFO_wr<= C_STR1 and not C_STR2;

TDCF_cou_40<=TDCF_cou(5) and TDCF_cou(3);
TDCFIFO_rd<='1' when (rs300_1='0' and rs300_2='1') OR (TDCF_cou_40='1')  else '0';

process (tdcclk)
begin
if (tdcclk'event and tdcclk='1') then 
	rs_1<=rstr; 
	if  (rstr='0') and (rs_1='1') then TDC_bitcount<="111";  TDC_rdy1<='0'; TDC_raw_wr<='1'; end if;
	if (TDC_bitcount /="000") then TDC<= rdata & TDC(6 downto 1);  TDC_bitcount<= TDC_bitcount -1;
	  else if (TDC_raw_wr='1') then TDC_raw_wr<='0'; if (tdc_raw_lock='0') then TDC_raw_i<=C_FIFO(5 downto 0) & TDC(6 downto 0); end if; end if;  
	end if;
	if (TDC_bitcount="010") then TDC_rdy1<='1'; end if; 
	
end if;
if (tdcclk'event and tdcclk='0') then tdc_rdy<=TDC_rdy1; end if;
end process;

CH_CORR <= "00001" when (C_FIFO(0) ='1') and (TDC(6 downto 5)="00") else
				"11111" when (C_FIFO(0) ='0') and (TDC(6 downto 5)="11") else
				"00000";

tdc_out<=(C_FIFO(5 downto 1)+CH_CORR & TDC);
--tdc_out<=(C_FIFO(5 downto 0) & TDC(6 downto 1));
end RTL;
