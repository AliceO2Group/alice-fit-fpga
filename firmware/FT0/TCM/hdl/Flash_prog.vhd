----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2020 08:04:55 PM
-- Design Name: 
-- Module Name: Flash_prog - RTL
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

entity FLASH is

generic (   
      clk_freq                               : integer := 31250
   );

  Port (
    rst : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_out : out STD_LOGIC_VECTOR(31 DOWNTO 0);
    A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    wr_flshreg : IN STD_LOGIC;
    rd_flshreg : IN STD_LOGIC;
    flshreg_sel : IN STD_LOGIC;
    FSEL : out  STD_LOGIC;
    FMOSI : out  STD_LOGIC;
    FMISO : in  STD_LOGIC
    );
end FLASH;

architecture RTL of FLASH is

signal cmd_adr, fl_data, intCrc32Next, bin, icp_in  : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal end_adr : STD_LOGIC_VECTOR(23 DOWNTO 0);
signal timeout : STD_LOGIC_VECTOR(20 DOWNTO 0);
signal cmd_stat, clkcou : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal rbt_cou : STD_LOGIC_VECTOR(2 DOWNTO 0);
signal spi_in, spi_out, fl_inp : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal fl_ena, fl_ena_b, fl_unlock, miso, mosi, fcs, fl_rdy, fl_busy, spi_act, keep_state, bclr, b_wr, b_rd, b_full, b_empty, ovf, cs_icp : STD_LOGIC;
signal buf_count : STD_LOGIC_VECTOR(14 DOWNTO 0);

COMPONENT FLASH_FIFO
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    wr_data_count : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
  );
END COMPONENT;

begin

FI:  IBUF port map (O=>miso, I=>FMISO);
FO:  OBUFT port map (O=>FMOSI, I=>mosi, T=>fl_ena_b);
FC:  OBUFT port map (O=>FSEL, I=>fcs, T=>fl_ena_b);

fl_ena_b<=not fl_ena;

icp: ICAPE2 generic map ( DEVICE_ID => X"3651093", ICAP_WIDTH => "X32", SIM_CFG_FILE_NAME => "NONE" )
 port map (O => open, CLK => clk,  CSIB => cs_icp, I => icp_in, RDWRB => '0');
 
cs_icp<= '0' when  (fl_busy='1') and (fl_rdy='1') and (cmd_adr(26 downto 24)=4) else '1';

with rbt_cou select
  icp_in<= x"FFFFFFFF" when "000",
           x"5599aa66" when "001",
           x"04000000" when "010",
           x"0C400080" when "011",
           x"00" & cmd_adr(16) & cmd_adr(17) & cmd_adr(18) & cmd_adr(19) & cmd_adr(20) & cmd_adr(21) & cmd_adr(22) & cmd_adr(23) & cmd_adr(8) & cmd_adr(9) & cmd_adr(10) & cmd_adr(11) & cmd_adr(12) 
                 & cmd_adr(13) & cmd_adr(14) & cmd_adr(15) & cmd_adr(0) & cmd_adr(1) & cmd_adr(2) & cmd_adr(3) & cmd_adr(4) & cmd_adr(5) & cmd_adr(6) & cmd_adr(7) when "100",
           x"0C000180" when "101",
           x"000000F0" when "110",
           x"04000000" when "111";
           
 

SE2 : STARTUPE2 generic map (PROG_USR => "FALSE", SIM_CCLK_FREQ => 0.0 )
  port map (CFGCLK => open, CFGMCLK => open, EOS => open, PREQ => open, CLK => '0', GSR => '0', GTS => '0', KEYCLEARB => '1', PACK => '0', USRCCLKO => clkcou(0), USRCCLKTS => fl_ena_b, USRDONEO => '1', USRDONETS => '1');
  

BF: FLASH_FIFO PORT MAP (clk => clk, srst => bclr, din => bin,  wr_en => b_wr, rd_en => b_rd, dout => fl_inp, full => b_full, empty => b_empty,  wr_data_count => buf_count);

bin<= data_in(7 downto 0) & data_in(15 downto 8) & data_in(23 downto 16) & data_in(31 downto 24);
b_wr <= '1' when (wr_flshreg='1') and (flshreg_sel='1') and (A=1) and (cmd_adr(25 downto 24)=2) and (fl_busy='1') and (b_full='0') else '0';
bclr<= '1' when (rst='1') or (cmd_adr(25 downto 24)/=2) or (fl_busy='0') else '0';

mosi<=spi_out(7);

with A select 
  data_out <= cmd_adr              when "00",
              fl_data              when "01",
              x"00" & end_adr      when "10",
              x"000" & "00" & fl_busy & fl_rdy & ovf & buf_count when "11";

process(clk)
begin
if (clk'event and clk='1') then 

if (b_rd='1') then b_rd<='0'; end if;

if (rst='1') then
fl_ena<='0'; fl_unlock<='0'; cmd_adr<=(others=>'0'); fcs<='1'; fl_rdy<='0'; spi_act<='0';
 else
 if (b_full='1') then ovf<='1';
  else if (rd_flshreg='1') and (flshreg_sel='1') and (A=3) then ovf<='0'; end if;
 end if; 
 
 if (spi_act='0') then

clkcou<=(others=>'0');

if (fl_busy='1') and (fl_rdy='1') then

if (cmd_adr(26 downto 24)=4) then 
  if (rbt_cou/=7) then rbt_cou<=rbt_cou+1; else fl_busy<='0'; end if; 

else

 if (timeout=0) then
    if (cmd_stat=0) then fcs<='0'; spi_act<='1';
      if (cmd_adr(25 downto 24)=1) then spi_out<=x"9F"; end if;
      if (cmd_adr(25 downto 24)=2) then spi_out<=x"06"; end if;
      if (cmd_adr(25 downto 24)=3) then spi_out<=x"03"; end if;
    end if;
    
    if (cmd_adr(25 downto 24)=2) then
    
    case to_integer(unsigned(cmd_stat)) is
      when 1 => fcs<='0'; spi_act<='1'; spi_out<=x"D8"; 
      when 5 => fcs<='0'; spi_act<='1'; spi_out<=x"05";
      when 7 => fcs<='0'; spi_act<='1'; 
             if (spi_in(0)='1') then  cmd_stat<=x"5"; spi_out<=x"05";  else spi_out<=x"06"; end if; 
      when 8 => fcs<='0'; spi_act<='1'; spi_out<=x"02";
      when 11 =>  if (b_empty='0') then spi_act<='1'; spi_out<= fl_inp;  b_rd<='1'; end if;
      when 12 =>  fcs<='0'; spi_act<='1'; spi_out<=x"05";       
                 
      when 14 => fcs<='0'; spi_act<='1'; 
                 if (spi_in(0)='1') then  cmd_stat<=x"C"; spi_out<=x"05"; 
                  else spi_out<=x"06";
                    if (cmd_adr(15 downto 7)=0) then cmd_stat<=x"0"; else cmd_stat<=x"7"; end if;  
                 end if; 
 
      when others=> null;
   end case;
 end if; 

    
 else timeout<=timeout-1;
 end if;
end if;
end if;
  
if (fl_ena='1') and (fl_rdy='0') then spi_act<='1'; end if;


else 
 clkcou<=clkcou+1;
 if (clkcou(0)='0') then spi_in<=spi_in(6 downto 0) & miso; end if;
 
 if (clkcou=15) then
   if (fl_rdy='0') then fl_rdy<='1'; spi_act<='0';
    else 
     if  (keep_state='0') then cmd_stat<=cmd_stat+1; end if; 
 end if; 
 
 case cmd_adr(25 downto 24) is
    when "01" => 
       case to_integer(unsigned(cmd_stat)) is
        when 1 => fl_data(7 downto 0)<=spi_in;
        when 2 => fl_data(15 downto 8)<=spi_in;
        when 3 => fl_data(23 downto 16)<=spi_in; fcs<='1'; fl_busy<='0';  spi_act<='0'; 
        when others=> null;
       end case;
    when "10" => 
          case to_integer(unsigned(cmd_stat)) is
           when 0 => fcs<='1'; spi_act<='0'; timeout <= std_logic_vector(to_unsigned(2, 21));
           when 1 => spi_out<=cmd_adr(23 downto 16);
           when 2 => spi_out<=cmd_adr(15 downto 8);
           when 3 => spi_out<=cmd_adr(7 downto 0); 
           when 4 => fcs<='1'; spi_act<='0'; timeout <= std_logic_vector(to_unsigned(clk_freq*50, 21));  
           
           when 6 => fcs<='1'; spi_act<='0'; 
                         if (spi_in(0)='1') then timeout <= std_logic_vector(to_unsigned(clk_freq*50, 21)); end if;
           when 7 => fcs<='1'; spi_act<='0'; timeout <= std_logic_vector(to_unsigned(2, 21));
           when 8 => spi_out<=cmd_adr(23 downto 16);
           when 9 => spi_out<=cmd_adr(15 downto 8);
           when 10 => spi_out<=cmd_adr(7 downto 0);  keep_state<='1';
           when 11 => if (keep_state='1') then
                        if (cmd_adr(23 downto 0)/=end_adr) then cmd_adr(23 downto 0)<= cmd_adr(23 downto 0)+1; end if;
                        if (cmd_adr(23 downto 0)=end_adr) or (cmd_adr(7 downto 0)=x"FF") then keep_state<='0'; end if;
                        if (b_empty='0') then spi_out<= fl_inp;  b_rd<='1';
                          else spi_act<='0';
                        end if;
                     else
                        fcs<='1'; spi_act<='0';
                        if (cmd_adr(23 downto 0)=end_adr) then fl_busy<='0'; 
                          else timeout <= std_logic_vector(to_unsigned(clk_freq/5, 21));
                        end if;
                     end if;                      
           when 13 => fcs<='1'; spi_act<='0';
                                  if (spi_in(0)='1') then timeout <= std_logic_vector(to_unsigned(clk_freq/5, 21)); end if; 
                        
                              
           when others=> null;
          end case;
    when "11" =>
       case to_integer(unsigned(cmd_stat)) is
         when 0 => spi_out<=cmd_adr(23 downto 16); 
         when 1 => spi_out<=cmd_adr(15 downto 8);
         when 2 => spi_out<=cmd_adr(7 downto 0); 
         when 3 => fl_data<=(others=>'1'); keep_state<='1'; 
         when 4 => fl_data<=intCrc32Next;
                    if (cmd_adr(23 downto 0)/= end_adr(23 downto 0)) then cmd_adr(23 downto 0)<= cmd_adr(23 downto 0)+1; 
                      else fcs<='1'; spi_act<='0';   fl_busy<='0';
                   end if; 
     when others=> null;
    end case;
        
    
    when others => null;
    end case;
else 
    if (clkcou(0)='1') then spi_out<=spi_out(6 downto 0) & '0'; end if;  
end if;       

end if;

if (wr_flshreg='1') and (flshreg_sel='1') and (A=0) then

if (data_in(31 downto 24)=0) then fl_ena<='0'; fl_unlock<='0'; fcs<='1'; fl_rdy<='0'; fl_busy<='0'; cmd_adr<=(others=>'0'); spi_act<='0';
  else
  if (fl_rdy='1') and (fl_busy='0') then
   cmd_adr<=data_in; 
   if (data_in(31 downto 26)=0) then fl_busy<='1'; cmd_stat<=(others=>'0'); keep_state<='0'; timeout<=(others=>'0'); end if;
   if (data_in(31 downto 24)=4) then  rbt_cou<="000"; fl_busy<='1'; end if;
  end if;
end if;  

  if (data_in=x"12345678") and (fl_ena='0') and  (fl_unlock='0') then fl_unlock<='1'; end if;

    if (fl_unlock='1') and (fl_ena='0') then
     if (data_in=x"FEDCBA98")  then fl_ena<='1';  
        else fl_unlock<='0';
     end if;
    end if; 
 end if;
 
 
 if (wr_flshreg='1') and (flshreg_sel='1') and (A=1) and (fl_rdy='1') and (fl_busy='0') then  fl_data<=data_in; end if;
 if (wr_flshreg='1') and (flshreg_sel='1') and (A=2) and (fl_rdy='1') and (fl_busy='0') then  end_adr<=data_in(23 downto 0); end if;

 
end if;


end if;
end process;
            
 -- CRC calculations
  intCrc32Next(0)   <= spi_in(7) xor fl_data(30) xor spi_in(1) xor fl_data(24);
  intCrc32Next(1)   <= spi_in(7) xor fl_data(25) xor spi_in(1) xor fl_data(31) xor spi_in(6) xor fl_data(30) xor spi_in(0) xor fl_data(24);
  intCrc32Next(2)   <= spi_in(7) xor fl_data(25) xor spi_in(1) xor spi_in(5) xor fl_data(31) xor spi_in(6) xor fl_data(30) xor spi_in(0) xor fl_data(26) xor fl_data(24);
  intCrc32Next(3)   <= fl_data(25) xor spi_in(5) xor fl_data(31) xor fl_data(27) xor spi_in(6) xor spi_in(0) xor fl_data(26) xor spi_in(4);
  intCrc32Next(4)   <= spi_in(7) xor spi_in(1) xor spi_in(5) xor spi_in(3) xor fl_data(27) xor fl_data(30) xor fl_data(28) xor fl_data(26) xor fl_data(24) xor spi_in(4);
  intCrc32Next(5)   <= spi_in(7) xor fl_data(25) xor spi_in(1) xor fl_data(31) xor spi_in(3) xor fl_data(27) xor spi_in(2) xor spi_in(6) xor fl_data(29) xor fl_data(30) xor fl_data(28) xor spi_in(0) xor fl_data(24) xor spi_in(4);
  intCrc32Next(6)   <= fl_data(25) xor spi_in(5) xor spi_in(1) xor fl_data(31) xor spi_in(3) xor spi_in(2) xor spi_in(6) xor fl_data(29) xor fl_data(28) xor fl_data(30) xor spi_in(0) xor fl_data(26);
  intCrc32Next(7)   <= spi_in(7) xor spi_in(5) xor fl_data(31) xor fl_data(27) xor spi_in(2) xor fl_data(29) xor fl_data(26) xor spi_in(0) xor fl_data(24) xor spi_in(4);
  intCrc32Next(8)   <= spi_in(7) xor fl_data(25) xor fl_data(0) xor spi_in(3) xor fl_data(27) xor spi_in(6) xor fl_data(28) xor fl_data(24) xor spi_in(4);
  intCrc32Next(9)   <= fl_data(25) xor spi_in(5) xor spi_in(3) xor spi_in(2) xor spi_in(6) xor fl_data(29) xor fl_data(1) xor fl_data(28) xor fl_data(26);
  intCrc32Next(10)  <= spi_in(7) xor spi_in(5) xor fl_data(27) xor spi_in(2) xor fl_data(29) xor fl_data(26) xor fl_data(2) xor fl_data(24) xor spi_in(4);
  intCrc32Next(11)  <= spi_in(7) xor fl_data(25) xor spi_in(3) xor fl_data(27) xor spi_in(6) xor fl_data(28) xor fl_data(3) xor fl_data(24) xor spi_in(4);
  intCrc32Next(12)  <= spi_in(7) xor fl_data(4) xor fl_data(25) xor spi_in(1) xor spi_in(5) xor spi_in(3) xor spi_in(2) xor spi_in(6) xor fl_data(29) xor fl_data(30) xor fl_data(28) xor fl_data(26) xor fl_data(24);
  intCrc32Next(13)  <= fl_data(5) xor fl_data(25) xor spi_in(5) xor spi_in(1) xor fl_data(31) xor fl_data(27) xor spi_in(2) xor spi_in(6) xor fl_data(29) xor fl_data(30) xor spi_in(0) xor fl_data(26) xor spi_in(4);
  intCrc32Next(14)  <= spi_in(5) xor spi_in(1) xor spi_in(3) xor fl_data(31) xor fl_data(27) xor fl_data(28) xor fl_data(30) xor fl_data(26) xor spi_in(0) xor fl_data(6) xor spi_in(4);
  intCrc32Next(15)  <= fl_data(7) xor spi_in(3) xor fl_data(31) xor fl_data(27) xor spi_in(2) xor fl_data(29) xor fl_data(28) xor spi_in(0) xor spi_in(4);
  intCrc32Next(16)  <= spi_in(7) xor fl_data(8) xor spi_in(3) xor spi_in(2) xor fl_data(29) xor fl_data(28) xor fl_data(24);
  intCrc32Next(17)  <= fl_data(25) xor fl_data(9) xor spi_in(1) xor spi_in(2) xor spi_in(6) xor fl_data(29) xor fl_data(30);
  intCrc32Next(18)  <= fl_data(10) xor spi_in(5) xor spi_in(1) xor fl_data(31) xor fl_data(30) xor fl_data(26) xor spi_in(0);
  intCrc32Next(19)  <= fl_data(11) xor fl_data(31) xor fl_data(27) xor spi_in(0) xor spi_in(4);
  intCrc32Next(20)  <= spi_in(3) xor fl_data(12) xor fl_data(28);
  intCrc32Next(21)  <= fl_data(13) xor spi_in(2) xor fl_data(29);
  intCrc32Next(22)  <= spi_in(7) xor fl_data(14) xor fl_data(24);
  intCrc32Next(23)  <= spi_in(7) xor fl_data(25) xor spi_in(1) xor fl_data(15) xor spi_in(6) xor fl_data(30) xor fl_data(24);
  intCrc32Next(24)  <= fl_data(25) xor spi_in(5) xor fl_data(31) xor spi_in(6) xor fl_data(16) xor spi_in(0) xor fl_data(26);
  intCrc32Next(25)  <= fl_data(17) xor spi_in(5) xor fl_data(27) xor fl_data(26) xor spi_in(4);
  intCrc32Next(26)  <= spi_in(7) xor fl_data(18) xor spi_in(1) xor spi_in(3) xor fl_data(27) xor fl_data(30) xor fl_data(28) xor fl_data(24) xor spi_in(4);
  intCrc32Next(27)  <= fl_data(19) xor fl_data(25) xor fl_data(31) xor spi_in(3) xor spi_in(2) xor spi_in(6) xor fl_data(29) xor fl_data(28) xor spi_in(0);
  intCrc32Next(28)  <= fl_data(20) xor spi_in(5) xor spi_in(1) xor spi_in(2) xor fl_data(29) xor fl_data(30) xor fl_data(26);
  intCrc32Next(29)  <= fl_data(21) xor spi_in(1) xor fl_data(31) xor fl_data(27) xor fl_data(30) xor spi_in(0) xor spi_in(4);
  intCrc32Next(30)  <= fl_data(22) xor spi_in(3) xor fl_data(31) xor fl_data(28) xor spi_in(0);
  intCrc32Next(31)  <= spi_in(2) xor fl_data(23) xor fl_data(29);


end RTL;
