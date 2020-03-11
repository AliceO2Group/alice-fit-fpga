----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2017 12:57:41 PM
-- Design Name: 
-- Module Name: tcm - combined
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


package HDMI_pkg is
    type HDMI_trig is array (9 downto 0) of std_logic_vector (3 downto 0);
    type Trgdat is array (9 downto 0) of std_logic_vector (31 downto 0);
end package;


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

library work;
use work.HDMI_pkg.all;

entity tcm_a is
 Port (CLKA_P : in STD_LOGIC;
       CLKA_N : in STD_LOGIC;
        RST : in STD_LOGIC;
        HDMIA_P : in HDMI_trig;
        HDMIA_N : in HDMI_trig;
        TDA : out TrgDat;
        STATA : out STD_LOGIC_VECTOR (12 downto 0);
        OrA : out STD_LOGIC;
        CLK320A : out STD_LOGIC;
        bitcnt_A : out STD_LOGIC_VECTOR (2 downto 0);
        TimeB : in STD_LOGIC_VECTOR (8 downto 0);
        Tdiff : out STD_LOGIC_VECTOR (8 downto 0);
        AmplA : out STD_LOGIC_VECTOR (11 downto 0)
        );
end tcm_a;

architecture RTL of tcm_a is

signal HDMI_in, NC, TD_P, TD_N : HDMI_trig;
signal ready, CLKA, CLK320, wt_sync, SC, SC_0, C, C_0, pllrdy, end_sync, error  : STD_LOGIC;
signal bitcnt : STD_LOGIC_VECTOR (2 downto 0);
signal syn_cnt : STD_LOGIC_VECTOR (8 downto 0);
signal Nchan_A1, Nchan_A2, Nchan_A0, Nchan_A : STD_LOGIC_VECTOR (6 downto 0);
signal TsumA_0, MsumA_0: STD_LOGIC_VECTOR (5 downto 0);
signal TcarryA_out,TcarryA, McarryA, T0sumA, T1sumA, Nchan0A, Nchan1A, Nchan2A, Nchan3A : STD_LOGIC_VECTOR (3 downto 0);
signal TtimeA, MamplA : STD_LOGIC_VECTOR (17 downto 0);
signal TimeA : STD_LOGIC_VECTOR (15 downto 0);
signal TSsumA, MSsumA : STD_LOGIC_VECTOR (1 downto 0);
signal AvgA, AvgA_0 : STD_LOGIC_VECTOR (13 downto 0);
signal TresA : STD_LOGIC_VECTOR (9 downto 0);
signal TresbM, TdiffM : STD_LOGIC_VECTOR (22 downto 0);

signal Nchan00A, Nchan01A, Nchan02A, Nchan03A, Nchan10A, Nchan11A, Nchan12A, Nchan13A, T00sumA, T01sumA,T10sumA, T11sumA : STD_LOGIC_VECTOR (2 downto 0);
signal M00sumA, M01sumA,M10sumA, M11sumA : STD_LOGIC_VECTOR (2 downto 0);
signal M0sumA, M1sumA : STD_LOGIC_VECTOR (3 downto 0);

signal status : STD_LOGIC_VECTOR (12 downto 0);
signal inp_act  : STD_LOGIC_VECTOR (9 downto 1);
signal trigger_data : Trgdat;

component tcm_sync is
    Port ( CLKA : in STD_LOGIC;
           TD_P : in STD_LOGIC_VECTOR (3 downto 0);
           TD_N : in STD_LOGIC_VECTOR (3 downto 0);
           RST : in STD_LOGIC;
           pllrdy : out STD_LOGIC;        
           rdy : out STD_LOGIC;
           clkout : out STD_LOGIC;
           bitcnt : out STD_LOGIC_VECTOR (2 downto 0);
           TDO : out STD_LOGIC_VECTOR (3 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0)
           );
end component;

component tcm_inp is 
            Port(TD : in STD_LOGIC_VECTOR (3 downto 0);
                 rdy : in STD_LOGIC;
                 sync : in STD_LOGIC;
                 inp_act: out STD_LOGIC;
                 CLK320 : in STD_LOGIC;
                 bitcnt : in STD_LOGIC_VECTOR (2 downto 0);
                 TDO : out STD_LOGIC_VECTOR (3 downto 0);
               DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0)
                 );
end component;

COMPONENT MULADD
  PORT (
    A : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    C : IN STD_LOGIC_VECTOR(22 DOWNTO 0);
    SUBTRACT : IN STD_LOGIC;
    P : OUT STD_LOGIC_VECTOR(22 DOWNTO 0);
    PCOUT : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
  );
END COMPONENT;


COMPONENT ROM7x15
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
  );
END COMPONENT; 

begin

CLKA1: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (I=>CLKA_P, IB=>CLKA_N, O=>CLKA);

TDIN:  for j in 0 to 9 generate
TDIN0: for i in 0 to 3 generate
TDIN1: IBUFDS_DIFF_OUT
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS")
port map (O=>TD_P(j)(i), OB=>TD_N(j)(i), I=>HDMIA_P(j)(i), IB=>HDMIA_N(j)(i));
end generate;
end generate;


tcm_s1: tcm_sync port map(CLKA => CLKA, TD_P=> TD_P(0), TD_N=> TD_N(0), RST=> RST, pllrdy=>pllrdy, rdy => ready, clkout => CLK320, bitcnt => bitcnt, TDO=> HDMI_in(0), DATA_OUT=>trigger_data(0));

TcmIN:  for i in 1 to 9 generate
tcm_in1: tcm_inp port map(TD=>TD_P(i),  rdy=> ready, sync => wt_sync, inp_act=>inp_act(i), CLK320 => CLK320, bitcnt => bitcnt, TDO=> HDMI_in(i), DATA_OUT=>trigger_data(i));
end generate;

ROM1 : ROM7x15  PORT MAP (clka => CLK320, addra => Nchan_A0, douta => AvgA_0); 
MUL2: MULADD  PORT MAP (A => AvgA, B => TimeA, C => TresbM, SUBTRACT => '1',    P => TdiffM,    PCOUT => open);

TDA<=trigger_data; STATA<=status; CLK320A<=CLK320; bitcnt_A<=bitcnt;

TresbM<=TimeB & "00000000000000";
Tdiff<=TdiffM(22 downto 14);

OrA<= '1' when (Nchan_A/=0) else '0';

process (CLK320, RST)
begin

if (RST='1') then error<='0'; end_sync<='0'; 
    else 
    if (CLK320'event and CLK320='1') then
    
      if (wt_sync='0') and (syn_cnt="111111111") then end_sync<='1'; end if;

      if (end_sync='1') and (ready='0') then error<='1'; end_sync<='0'; end if;
 
    end if;
end if;
end process;
        
        
process (CLK320)
begin
if (CLK320'event and CLK320='1') then

AvgA<=AvgA_0;

if (bitcnt="000") then 

status(0)<=pllrdy; status(1)<=ready; status(2)<=end_sync; status(3)<=error;   

status(12 downto 4)<=inp_act(9 downto 1);

for i in 0 to 9 loop

NC(i)<=HDMI_in(i); 
 
 end loop;

 TtimeA(17 downto 14) <="0000"; MamplA(17 downto 14) <="0000";
else
  TtimeA<=TsumA_0 & TtimeA(13 downto 2) ;
  MamplA<=MsumA_0 & MamplA(13 downto 2) ;

end if;

if (bitcnt="001") then 

for i in 0 to 9 loop

if (NC(i))>x"C" then NC(i)<="0000"; end if;
 
 end loop;

 end if;

if (bitcnt="101") then Nchan_A<=Nchan_A0; end if; 


if (bitcnt="111") then 

  if (ready='1') then 
     if (syn_cnt/="111111111") then syn_cnt<=syn_cnt+1; wt_sync<='1'; 
     else wt_sync<='0'; end if;
    else syn_cnt<="000000000"; wt_sync<='0';
   end if;
   
TimeA<=TsumA_0(1 downto 0) & TtimeA(13 downto 0);
AmplA<=MsumA_0 & MamplA(13 downto 8) ;
   
end if;

end if;
end process;


M00sumA<= ("00"&HDMI_in(0)(2))+("00"&HDMI_in(1)(2))+("00"&HDMI_in(2)(2))+("00"&HDMI_in(3)(2))+("00"&HDMI_in(4)(2));
M10sumA<= ("00"&HDMI_in(5)(2))+("00"&HDMI_in(6)(2))+("00"&HDMI_in(7)(2))+("00"&HDMI_in(8)(2))+("00"&HDMI_in(9)(2));
M01sumA<= ("00"&HDMI_in(0)(3))+("00"&HDMI_in(1)(3))+("00"&HDMI_in(2)(3))+("00"&HDMI_in(3)(3))+("00"&HDMI_in(4)(3));
M11sumA<= ("00"&HDMI_in(5)(3))+("00"&HDMI_in(6)(3))+("00"&HDMI_in(7)(3))+("00"&HDMI_in(8)(3))+("00"&HDMI_in(9)(3));


MsumA_0<= ("000"&M00sumA)+("00" & M01sumA&"0") +("000"&M10sumA)+("00" & M11sumA&"0") +("00"& MamplA(17 downto 14));

T00sumA<= ("00"&HDMI_in(0)(0))+("00"&HDMI_in(1)(0))+("00"&HDMI_in(2)(0))+("00"&HDMI_in(3)(0))+("00"&HDMI_in(4)(0));
T10sumA<= ("00"&HDMI_in(5)(0))+("00"&HDMI_in(6)(0))+("00"&HDMI_in(7)(0))+("00"&HDMI_in(8)(0))+("00"&HDMI_in(9)(0));
T01sumA<= ("00"&HDMI_in(0)(1))+("00"&HDMI_in(1)(1))+("00"&HDMI_in(2)(1))+("00"&HDMI_in(3)(1))+("00"&HDMI_in(4)(1));
T11sumA<= ("00"&HDMI_in(5)(1))+("00"&HDMI_in(6)(1))+("00"&HDMI_in(7)(1))+("00"&HDMI_in(8)(1))+("00"&HDMI_in(9)(1));



TsumA_0<=  ("000"&T00sumA) + ("00" & T01sumA&"0") + ("000"&T10sumA) + ("00" & T11sumA&"0")+("00"&TtimeA(17 downto 14));

Nchan00A<= ("00" & NC(0)(0))+ ("00" & NC(1)(0))+ ("00" & NC(2)(0))+ ("00" & NC(3)(0))+("00" & NC(4)(0));
Nchan10A<= ("00" & NC(5)(0))+ ("00" & NC(6)(0))+ ("00" & NC(7)(0))+ ("00" & NC(8)(0))+("00" & NC(9)(0));
Nchan01A<= ("00" & NC(0)(1))+ ("00" & NC(1)(1))+ ("00" & NC(2)(1))+ ("00" & NC(3)(1))+("00" & NC(4)(1));
Nchan11A<= ("00" & NC(5)(1))+ ("00" & NC(6)(1))+ ("00" & NC(7)(1))+ ("00" & NC(8)(1))+("00" & NC(9)(1));
Nchan02A<= ("00" & NC(0)(2))+ ("00" & NC(1)(2))+ ("00" & NC(2)(2))+ ("00" & NC(3)(2))+("00" & NC(4)(2));
Nchan12A<= ("00" & NC(5)(2))+ ("00" & NC(6)(2))+ ("00" & NC(7)(2))+ ("00" & NC(8)(2))+("00" & NC(9)(2));
Nchan03A<= ("00" & NC(0)(3))+ ("00" & NC(1)(3))+ ("00" & NC(2)(3))+ ("00" & NC(3)(3))+("00" & NC(4)(3));
Nchan13A<= ("00" & NC(5)(3))+ ("00" & NC(6)(3))+ ("00" & NC(7)(3))+ ("00" & NC(8)(3))+("00" & NC(9)(3));



Nchan_A0<= ("000" & Nchan01A & "0") + ("00" & Nchan02A & "00") + ("000" & Nchan11A& "0") + ("00" & Nchan12A & "00") + ("0"&Nchan03A & Nchan00A) + ("0"& Nchan13A & Nchan10A);


end RTL;
