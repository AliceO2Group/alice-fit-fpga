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

entity tcm_side is
 Port (CLKA : in STD_LOGIC;
        RST : in STD_LOGIC;
        SRST : in STD_LOGIC;
        TD_P : in HDMI_trig;
        TD_N : in HDMI_trig;
        Config : in STD_LOGIC_VECTOR (31 downto 0);
        Status : out STD_LOGIC_VECTOR (31 downto 0);
        stat_adr : in STD_LOGIC_VECTOR (3 downto 0);
        stat_clr : in STD_LOGIC;
        stat_chg : in STD_LOGIC;
        side_OK : out STD_LOGIC;
        TDD : out TrgDat;
        rd_lock : in STD_LOGIC;
        Or_o : out STD_LOGIC;
        CLK320_o : out STD_LOGIC;
		CLKsys40_o : out STD_LOGIC;
        pll_lock : out STD_LOGIC;
        mt_cou_o : out STD_LOGIC_VECTOR (2 downto 0);
        Time_o : out STD_LOGIC_VECTOR (15 downto 0);
        Ampl_o : out STD_LOGIC_VECTOR (16 downto 0);
        Avg_o : out STD_LOGIC_VECTOR (13 downto 0);
        Nchan : out STD_LOGIC_VECTOR (6 downto 0);
        req : out STD_LOGIC_VECTOR (9 downto 0);
        bkgnd : out STD_LOGIC 
        );
end tcm_side;

architecture RTL of tcm_side is

type vect3_arr is array (9 downto 0) of std_logic_vector (2 downto 0);

signal HDMI_in, NC : HDMI_trig;
signal SC, SC_0, C, C_0, bkgnd_0 : STD_LOGIC;
signal bitcnt : STD_LOGIC_VECTOR (2 downto 0);

signal Nchan_A1, Nchan_A2, Nchan_A0, Nchan_A : STD_LOGIC_VECTOR (6 downto 0);
signal TsumA_0, MsumA_0 : STD_LOGIC_VECTOR (5 downto 0);
signal MsumA_F : STD_LOGIC_VECTOR (4 downto 0);
signal TsumA_F : STD_LOGIC_VECTOR (3 downto 0);
signal TcarryA_out,TcarryA, McarryA, T0sumA, T1sumA, Nchan0A, Nchan1A, Nchan2A, Nchan3A : STD_LOGIC_VECTOR (3 downto 0);
signal TtimeA, MamplA : STD_LOGIC_VECTOR (17 downto 0);
signal TSsumA, MSsumA : STD_LOGIC_VECTOR (1 downto 0);
signal Avg, Avg_0 : STD_LOGIC_VECTOR (13 downto 0);
signal TresA : STD_LOGIC_VECTOR (9 downto 0);

signal Nchan00A, Nchan01A, Nchan02A, Nchan03A, Nchan10A, Nchan11A, Nchan12A, Nchan13A, T00sumA, T01sumA,T10sumA, T11sumA : STD_LOGIC_VECTOR (2 downto 0);
signal M00sumA, M01sumA,M10sumA, M11sumA : STD_LOGIC_VECTOR (2 downto 0);
signal M0sumA, M1sumA : STD_LOGIC_VECTOR (3 downto 0);

signal inp_act  : STD_LOGIC_VECTOR (9 downto 1);
signal HDMI_status : Trgdat;

signal clk320, clk320_90, trig_ena, done, done0, done_toggle, ena_dly, inc_dly, psen, ph_inc, link_OK, side_on, dly_inc, dly_dec, dly_err,dly_err_s,  bitpos_ok, mdl_err, mdl_err_s, dly_ctrl_ena, stat_clr0, stat_clr1, stat_clr2 : STD_LOGIC;
signal rd_lock1, rd_lock0 : STD_LOGIC;
signal idle_cou : STD_LOGIC_VECTOR (5 downto 0);
signal mt_cou  : STD_LOGIC_VECTOR (2 downto 0);
signal link_ena, link_OK_in, link_OK_act, master_sel, psen_o, ph_inc_o, is_idle, bp_stable, dl_low, dl_high, bitpos_ok_in, bitpos_ok_act, sig_empty, mast_dlerr, mast_stable, sync_err, sync_err_s: STD_LOGIC_VECTOR (9 downto 0);
signal bitpos : vect3_arr;
signal master_n, N_empty0 : STD_LOGIC_VECTOR (3 downto 0);
signal adj_count : STD_LOGIC_VECTOR (7 downto 0);

component hdmirx is
    Port ( TD_P : in STD_LOGIC_VECTOR (3 downto 0);
           TD_N : in STD_LOGIC_VECTOR (3 downto 0);
           
           RST : in STD_LOGIC;
           ena : in STD_LOGIC;
           link_rdy : out STD_LOGIC;
           trig_ena: in STD_LOGIC;
           clk320 : in STD_LOGIC;
           clk320_90 : in STD_LOGIC;
           TDO : out STD_LOGIC_VECTOR (3 downto 0);
           rd_lock : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0);
           status :  out STD_LOGIC_VECTOR (31 downto 0);
           master  : in STD_LOGIC;
           mt_cou : in STD_LOGIC_VECTOR (2 downto 0);
           bitpos : out STD_LOGIC_VECTOR (2 downto 0);
           bitpos_ok : out STD_LOGIC;
           ena_dly : in STD_LOGIC;
           inc_dly : in STD_LOGIC;
           ena_ph : out  STD_LOGIC;
           inc_ph : out  STD_LOGIC;
           is_idle : out  STD_LOGIC;
           bp_stable : out  STD_LOGIC;
           dl_low : out  STD_LOGIC;
           dl_high : out  STD_LOGIC;
           mast_dl_err : out  STD_LOGIC;
           mast_stable : out  STD_LOGIC;
           dly_ctrl_ena : in  STD_LOGIC;
           syn_err : out  STD_LOGIC;
           PM_req : out STD_LOGIC
            );
end component;

component MMCM320_PH
port
 (-- Clock in ports
  -- Clock out ports
  CLK320          : out    std_logic;
  CLK320_90          : out    std_logic;
  -- Dynamic phase shift ports
  psclk             : in     std_logic;
  clksys40          : out    std_logic;
  psen              : in     std_logic;
  psincdec          : in     std_logic;
  psdone            : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  lock              : out    std_logic;
  MCLK              : in     std_logic
 );
end component;

COMPONENT ROM7x15
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
  );
END COMPONENT; 

begin

mt_cou_o<=mt_cou; CLK320_o<=clk320; Avg_o<= Avg; side_OK<=done; Nchan<=Nchan_A;

PLL1 : MMCM320_PH
   port map ( CLK320 => CLK320, CLK320_90=> CLK320_90, psclk => CLK320, clksys40 => clksys40_o, psen => psen, psincdec => ph_inc, psdone => open, reset => rst, lock => pll_lock, MCLK => CLKA);

HDMIA:  for i in 0 to 9 generate

link_ena(i)<=config(i) and not stat_chg ;

HDMI_RX: hdmirx  port map(TD_P=>TD_P(i), TD_N=>TD_N(i), RST=>SRST, ena=>link_ena(i), link_rdy=>link_OK_in(i), trig_ena=>done, clk320=>clk320, clk320_90=>clk320_90, TDO=>HDMI_in(i), rd_lock=>rd_lock1, DATA_OUT=> TDD(i), 
            status => HDMI_status(i),  master=> master_sel(i), mt_cou=>mt_cou, bitpos=>bitpos(i), bitpos_ok=>bitpos_ok_in(i), ena_dly=>ena_dly, inc_dly=>inc_dly, ena_ph=>psen_o(i), inc_ph=>ph_inc_o(i), is_idle=>is_idle(i), bp_stable=>bp_stable(i),
            dl_low=> dl_low(i), dl_high=> dl_high(i), mast_dl_err=>mast_dlerr(i), mast_stable=>mast_stable(i), dly_ctrl_ena=>dly_ctrl_ena, syn_err=>sync_err(i), PM_req=>req(i));
end generate;

ROM1 : ROM7x15  PORT MAP (clka => CLK320, addra => Nchan_A, douta => Avg_0); 


master_n<=x"0" when config(0)='1'
       else x"1" when config(1)='1'
       else x"2" when config(2)='1'
       else x"3" when config(3)='1'
       else x"4" when config(4)='1'
       else x"5" when config(5)='1'
       else x"6" when config(6)='1'
       else x"7" when config(7)='1'
       else x"8" when config(8)='1'
       else x"9";
       
Status<=HDMI_status(to_integer(unsigned(stat_adr))) when (stat_adr<x"A") else
        done & done_toggle & dly_err_s & side_on & mdl_err_s & sync_err_s & x"0" & "000" & config(9 downto 0) when (stat_adr=x"A") else       
        (others=>'0');
        
msel: for i in 0 to 9 generate
 master_sel(i)<='1' when (master_n=i) else '0';
 link_OK_act(i)<= link_OK_in(i) or (not config(i));
 bitpos_OK_act(i)<= bitpos_ok_in(i) or (not config(i));
  end generate;

side_on<='1' when (config(9 downto 0)/=0) else '0';
dly_dec<='1' when dl_high/=0 else '0';
dly_inc<='1' when dl_low/=0 else '0';
dly_err<= (dly_inc and dly_dec) or mdl_err; 


link_OK<= '1' when (link_OK_act="1111111111") and (side_on='1') else '0';
bitpos_OK<= '1' when (bitpos_ok_act="1111111111") and (side_on='1') else '0';
dly_ctrl_ena<='1' when (mast_stable="1111111111") else '0';

psen<= psen_o(to_integer(unsigned(master_n))) when (side_on='1') else '0'; 
ph_inc<= ph_inc_o(to_integer(unsigned(master_n))) when (side_on='1') else '0'; 
mdl_err<= mast_dlerr(to_integer(unsigned(master_n))) when (side_on='1') else '0';

  process (clk320)
  begin
    if (clk320'event and clk320='1') then
                    
       rd_lock1<=rd_lock0; rd_lock0<=rd_lock;
       stat_clr2<=stat_clr1; stat_clr1<=stat_clr0; stat_clr0<=stat_clr;
       done0<=done;
       if (done xor done0)='1' then done_toggle<='1';
         else if (stat_clr2='1') and (stat_clr1='0') then done_toggle<='0'; end if;
       end if;   
       if dly_err='1' then dly_err_s<='1';
         else if (stat_clr2='1') and (stat_clr1='0') then dly_err_s<='0'; end if;
       end if;   
       if mdl_err='1' then mdl_err_s<='1';
         else if (stat_clr2='1') and (stat_clr1='0') then mdl_err_s<='0'; end if;
       end if;   
       
 for i in 0 to 9 loop
       if sync_err(i)='1' then sync_err_s(i)<='1';
         else if (stat_clr2='1') and (stat_clr1='0') then sync_err_s(i)<='0'; end if;
       end if;   
 end loop;       

   if (idle_cou="111111") and (done='0') and (side_on='1') then mt_cou<="111"-bitpos(to_integer(unsigned(master_n))); idle_cou<="000000"; 
       else mt_cou<=mt_cou+1; end if;
    
if (side_on='1') and (srst='0') then  

    if (done='1') or (link_OK='0') then idle_cou<="000000";
     else
       if (mt_cou="100") and (is_idle(to_integer(unsigned(master_n)))='1') then 
                if (bp_stable(to_integer(unsigned(master_n)))='1') then idle_cou<=idle_cou+1; 
                  else idle_cou<="000000"; 
                end if;
       end if;
    end if;
       
     if (done='1') and ((link_OK='0') or (dly_err='1') or (bitpos_OK='0')) then done<='0'; 
        else if (done='0') and (bitpos_OK='1') and (idle_cou>"010000") then done<='1'; end if;
     end if; 
            
if (link_OK_in(to_integer(unsigned(master_n)))='1') and (dly_err='0') then 
   if (adj_count/=x"FF") then adj_count<=adj_count+1; 
    else  
         if (dly_inc or dly_dec)='1' then adj_count<=x"00"; ena_dly<=dly_ctrl_ena; inc_dly<=dly_inc; end if;
   end if;
 else adj_count<=x"00";
 end if;
  
    if (ena_dly='1') then ena_dly<='0'; end if;
 else done<='0'; idle_cou<="000000"; adj_count<=x"00";
end if;
  
 
 end if;
  end process;

Or_o<= '1' when (Nchan_A/=0) else '0';


     
        
process (CLK320)
begin
if (CLK320'event and CLK320='1') then

Avg<=Avg_0;

if (mt_cou="001") then 

for i in 0 to 9 loop

if HDMI_in(i)>x"C" then NC(i)<="0000"; else NC(i)<=HDMI_in(i); end if;
 
 end loop;

 TtimeA(17 downto 14) <="0000"; MamplA(17 downto 14) <="0000";
else
  TtimeA<=TsumA_0 & TtimeA(13 downto 2) ;
  MamplA<=MsumA_0 & MamplA(13 downto 2) ;

end if;


if (mt_cou="110") then Nchan_A<=Nchan_A0; end if; 


if (mt_cou="000") then 

Time_o<=TsumA_F & TtimeA(13 downto 2);
Ampl_o<= MsumA_F & MamplA(13 downto 2);
bkgnd<=bkgnd_0; 
   
end if;

end if;
end process;

bkgnd_0<= HDMI_in(0)(1) or HDMI_in(1)(1) or HDMI_in(2)(1) or HDMI_in(3)(1) or HDMI_in(4)(1) or HDMI_in(5)(1) or HDMI_in(6)(1) or HDMI_in(7)(1) or HDMI_in(8)(1) or HDMI_in(9)(1);

M00sumA<= ("00"&HDMI_in(0)(2))+("00"&HDMI_in(1)(2))+("00"&HDMI_in(2)(2))+("00"&HDMI_in(3)(2))+("00"&HDMI_in(4)(2));
M10sumA<= ("00"&HDMI_in(5)(2))+("00"&HDMI_in(6)(2))+("00"&HDMI_in(7)(2))+("00"&HDMI_in(8)(2))+("00"&HDMI_in(9)(2));
M01sumA<= ("00"&HDMI_in(0)(3))+("00"&HDMI_in(1)(3))+("00"&HDMI_in(2)(3))+("00"&HDMI_in(3)(3))+("00"&HDMI_in(4)(3));
M11sumA<= ("00"&HDMI_in(5)(3))+("00"&HDMI_in(6)(3))+("00"&HDMI_in(7)(3))+("00"&HDMI_in(8)(3))+("00"&HDMI_in(9)(3));


MsumA_0<= ("000"&M00sumA) + ("00" & M01sumA&"0") + ("000"&M10sumA) + ("00" & M11sumA&"0") + ("00"& MamplA(17 downto 14));

MsumA_F<= ("00" & M00sumA) + ("0" & M01sumA&"0") +("00" & M10sumA) + ("0" & M11sumA & "0") + ("0" & MamplA(17 downto 14)) + (M01sumA & "00") + (M11sumA & "00") + (M01sumA(1 downto 0) & "000") + (M11sumA(1 downto 0) & "000") +
          (M01sumA(0) & "0000") + ( M11sumA(0) & "0000");

T00sumA<= ("00"&HDMI_in(0)(0))+("00"&HDMI_in(1)(0))+("00"&HDMI_in(2)(0))+("00"&HDMI_in(3)(0))+("00"&HDMI_in(4)(0));
T10sumA<= ("00"&HDMI_in(5)(0))+("00"&HDMI_in(6)(0))+("00"&HDMI_in(7)(0))+("00"&HDMI_in(8)(0))+("00"&HDMI_in(9)(0));
T01sumA<= ("00"&HDMI_in(0)(1))+("00"&HDMI_in(1)(1))+("00"&HDMI_in(2)(1))+("00"&HDMI_in(3)(1))+("00"&HDMI_in(4)(1));
T11sumA<= ("00"&HDMI_in(5)(1))+("00"&HDMI_in(6)(1))+("00"&HDMI_in(7)(1))+("00"&HDMI_in(8)(1))+("00"&HDMI_in(9)(1));

TsumA_0<=  ("000"&T00sumA) + ("00" & T01sumA&"0") + ("000"&T10sumA) + ("00" & T11sumA&"0") + ("00" & TtimeA(17 downto 14));

TsumA_F<=  ("0" & T00sumA) + (T00sumA & "0") + ("0" & T10sumA) + (T10sumA & "0") + TtimeA(17 downto 14) + (T00sumA(0) & "000") + (T00sumA(1 downto 0) & "00") + (T10sumA(0) & "000") + (T10sumA(1 downto 0) & "00");

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
