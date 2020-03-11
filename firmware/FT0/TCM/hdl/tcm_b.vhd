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

entity tcm_b is
 Port (CLKB_P : in STD_LOGIC;
       CLKB_N : in STD_LOGIC;
        RST : in STD_LOGIC;
        HDMIB_P : in HDMI_trig;
        HDMIB_N : in HDMI_trig;
        TDB : out Trgdat;
        STATB : out STD_LOGIC_VECTOR (12 downto 0);
        OrB : out STD_LOGIC;
        TimeB : out STD_LOGIC_VECTOR (8 downto 0);
        AmplB : out STD_LOGIC_VECTOR (11 downto 0);
        B_rdy : out STD_LOGIC
        );
end tcm_b;

architecture RTL of tcm_b is

signal HDMI_in, NC, TD_P, TD_N : HDMI_trig;
signal ready, CLKB, CLK320, wt_sync, OrB_0,  pllrdy, end_sync, error, mul_en  : STD_LOGIC;
signal bitcnt : STD_LOGIC_VECTOR (2 downto 0);
signal syn_cnt : STD_LOGIC_VECTOR (8 downto 0);
signal Nchan_B1, Nchan_B2, Nchan_B0, Nchan_B : STD_LOGIC_VECTOR (6 downto 0);
signal TsumB_0, MsumB_0: STD_LOGIC_VECTOR (5 downto 0);
signal TcarryB_out,TcarryB, McarryB, T0sumB, T1sumB, Nchan0B, Nchan1B, Nchan2B, Nchan3B : STD_LOGIC_VECTOR (3 downto 0);
signal TtimeB, MamplB : STD_LOGIC_VECTOR (17 downto 0);
signal TimeB0 : STD_LOGIC_VECTOR (15 downto 0);
signal TSsumB, MSsumB : STD_LOGIC_VECTOR (1 downto 0);
signal Avgb, AvgB_0 : STD_LOGIC_VECTOR (13 downto 0);
signal TresB : STD_LOGIC_VECTOR (9 downto 0);

signal Nchan00B, Nchan01B, Nchan02B, Nchan03B, Nchan10B, Nchan11B, Nchan12B, Nchan13B, T00sumB, T01sumB,T10sumB, T11sumB : STD_LOGIC_VECTOR (2 downto 0);
signal M00sumB, M01sumB,M10sumB, M11sumB : STD_LOGIC_VECTOR (2 downto 0);
signal M0sumB, M1sumB : STD_LOGIC_VECTOR (3 downto 0);
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

COMPONENT MULT14xS16
  PORT (
    CLK : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    CE : IN STD_LOGIC;
    P : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
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

CLKB1: IBUFDS
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS_25")
port map (I=>CLKB_P, IB=>CLKB_N, O=>CLKB);

TDIN:  for j in 0 to 9 generate
TDIN0: for i in 0 to 3 generate
TDIN1: IBUFDS_DIFF_OUT
generic map (DIFF_TERM => TRUE, IBUF_LOW_PWR => FALSE, IOSTANDARD => "LVDS_25")
port map (O=>TD_P(j)(i), OB=>TD_N(j)(i), I=>HDMIB_P(j)(i), IB=>HDMIB_N(j)(i));
end generate;
end generate;


tcm_s1: tcm_sync port map(CLKA => CLKB, TD_P=> TD_P(0), TD_N=> TD_N(0), RST=> RST, pllrdy=>pllrdy, rdy => ready, clkout => CLK320, bitcnt => bitcnt, TDO=> HDMI_in(0), DATA_OUT=>trigger_data(0));

TcmIN:  for i in 1 to 9 generate
tcm_in1: tcm_inp port map(TD=>TD_P(i),  rdy=> ready, sync => wt_sync, inp_act=>inp_act(i), CLK320 => CLK320, bitcnt => bitcnt, TDO=> HDMI_in(i), DATA_OUT=>trigger_data(i));
end generate;


ROM1 : ROM7x15  PORT MAP (clka => CLK320, addra => Nchan_B0, douta => AvgB_0); 
MUL2: MULT14xS16  PORT MAP (clk => CLK320, A => AvgB, B => TimeB0(15 downto 0), CE=>mul_en, P => TimeB);

TDB<=trigger_data; STATB<=status;

mul_en<= '1' when (bitcnt="000") else '0';
       
process (CLK320, RST)
begin

if (RST='1') then error<='0';  end_sync<='0'; 
    else 
    if (CLK320'event and CLK320='1') then
    
    if (wt_sync='0') and (syn_cnt="111111111") then end_sync<='1'; end if;

    if (end_sync='1') and (ready='0') then error<='1';  end_sync<='0'; end if;
    end if;
end if;
end process;
        
        
process (CLK320)
begin
if (CLK320'event and CLK320='1') then

AvgB<=AvgB_0;

if (bitcnt="000") then 

status(0)<=pllrdy; status(1)<=ready; status(2)<=end_sync; status(3)<=error;   

status(12 downto 4)<=inp_act(9 downto 1);

for i in 0 to 9 loop

NC(i)<=HDMI_in(i);
 
 end loop;

if (Nchan_B/=0) then OrB<='1'; else OrB<='0'; end if;
B_rdy<='1';
 

TtimeB(17 downto 14) <="0000"; MamplB(17 downto 14) <="0000";

else
  TtimeB<=TsumB_0 & TtimeB(13 downto 2) ;
  MamplB<=MsumB_0 & MamplB(13 downto 2) ;

end if;

if (bitcnt="001") then 

for i in 0 to 9 loop

if (NC(i))>x"C" then NC(i)<="0000"; end if;
 
 end loop;

 end if;

if (bitcnt="101") then Nchan_B<=Nchan_B0; B_rdy<='0'; end if; 


if (bitcnt="111") then 

  if (ready='1') then 
     if (syn_cnt/="111111111") then syn_cnt<=syn_cnt+1; wt_sync<='1'; 
     else wt_sync<='0'; end if;
    else syn_cnt<="000000000"; wt_sync<='0';
   end if;

AmplB<=MsumB_0 & MamplB(13 downto 8) ;
TimeB0<=TsumB_0(1 downto 0) & TtimeB(13 downto 0);

end if;

end if;
end process;

M00sumB<= ("00"&HDMI_in(5)(2))+("00"&HDMI_in(6)(2))+("00"&HDMI_in(7)(2))+("00"&HDMI_in(8)(2))+("00"&HDMI_in(9)(2));
M01sumB<= ("00"&HDMI_in(0)(3))+("00"&HDMI_in(1)(3))+("00"&HDMI_in(2)(3))+("00"&HDMI_in(3)(3))+("00"&HDMI_in(4)(3));
M10sumB<= ("00"&HDMI_in(5)(2))+("00"&HDMI_in(6)(2))+("00"&HDMI_in(7)(2))+("00"&HDMI_in(8)(2))+("00"&HDMI_in(9)(2));
M11sumB<= ("00"&HDMI_in(5)(3))+("00"&HDMI_in(6)(3))+("00"&HDMI_in(7)(3))+("00"&HDMI_in(8)(3))+("00"&HDMI_in(9)(3));


MsumB_0<= ("000"&M00sumB)+("00" & M01sumB&"0") +("000"&M10sumB)+("00" & M11sumB&"0") +("00"& MamplB(17 downto 14));


T00sumB<= ("00"&HDMI_in(0)(0))+("00"&HDMI_in(1)(0))+("00"&HDMI_in(2)(0))+("00"&HDMI_in(3)(0))+("00"&HDMI_in(4)(0));
T10sumB<= ("00"&HDMI_in(5)(0))+("00"&HDMI_in(6)(0))+("00"&HDMI_in(7)(0))+("00"&HDMI_in(8)(0))+("00"&HDMI_in(9)(0));
T01sumB<= ("00"&HDMI_in(0)(1))+("00"&HDMI_in(1)(1))+("00"&HDMI_in(2)(1))+("00"&HDMI_in(3)(1))+("00"&HDMI_in(4)(1));
T11sumB<= ("00"&HDMI_in(5)(1))+("00"&HDMI_in(6)(1))+("00"&HDMI_in(7)(1))+("00"&HDMI_in(8)(1))+("00"&HDMI_in(9)(1));


TsumB_0<=  ("000"&T00sumB) + ("00" & T01sumB&"0") + ("000"&T10sumB) + ("00" & T11sumB&"0")+("00"&TtimeB(17 downto 14));

Nchan00B<= ("00" & NC(0)(0))+ ("00" & NC(1)(0))+ ("00" & NC(2)(0))+ ("00" & NC(3)(0))+("00" & NC(4)(0));
Nchan10B<= ("00" & NC(5)(0))+ ("00" & NC(6)(0))+ ("00" & NC(7)(0))+ ("00" & NC(8)(0))+("00" & NC(9)(0));
Nchan01B<= ("00" & NC(0)(1))+ ("00" & NC(1)(1))+ ("00" & NC(2)(1))+ ("00" & NC(3)(1))+("00" & NC(4)(1));
Nchan11B<= ("00" & NC(5)(1))+ ("00" & NC(6)(1))+ ("00" & NC(7)(1))+ ("00" & NC(8)(1))+("00" & NC(9)(1));
Nchan02B<= ("00" & NC(0)(2))+ ("00" & NC(1)(2))+ ("00" & NC(2)(2))+ ("00" & NC(3)(2))+("00" & NC(4)(2));
Nchan12B<= ("00" & NC(5)(2))+ ("00" & NC(6)(2))+ ("00" & NC(7)(2))+ ("00" & NC(8)(2))+("00" & NC(9)(2));
Nchan03B<= ("00" & NC(0)(3))+ ("00" & NC(1)(3))+ ("00" & NC(2)(3))+ ("00" & NC(3)(3))+("00" & NC(4)(3));
Nchan13B<= ("00" & NC(5)(3))+ ("00" & NC(6)(3))+ ("00" & NC(7)(3))+ ("00" & NC(8)(3))+("00" & NC(9)(3));

Nchan_B0<= ("000" & Nchan01B & "0") + ("00" & Nchan02B & "00") + ("000" & Nchan11B & "0") + ("00" & Nchan12B & "00") + ("0"&Nchan03B & Nchan00B) + ("0"& Nchan13B & Nchan10B);

end RTL;
