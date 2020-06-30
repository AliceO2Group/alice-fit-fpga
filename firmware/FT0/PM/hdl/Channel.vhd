----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2017 06:55:18 PM
-- Design Name: 
-- Module Name: Channel - Behavioral
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

entity Channel is
    Port ( CGE : in STD_LOGIC;
           clk320 : in STD_LOGIC;
           reset  : in STD_LOGIC;
           tdc_rdy_in : in STD_LOGIC;
           mt_cou : in STD_LOGIC_VECTOR (2 downto 0);
           bc_cou : in STD_LOGIC_VECTOR (5 downto 0);
           TR_bc : in STD_LOGIC_VECTOR (5 downto 0);          
           TDC : in STD_LOGIC_VECTOR (11 downto 0);
           CSTR : in STD_LOGIC;
           CH :  in STD_LOGIC_VECTOR(12 downto 0);
           CH_shift : in STD_LOGIC_VECTOR (11 downto 0);
           gate_time_low :  in STD_LOGIC_VECTOR (7 downto 0);
           gate_time_high :  in STD_LOGIC_VECTOR (7 downto 0);
           Ampl_sat :   in STD_LOGIC_VECTOR (11 downto 0);
           CH0_zero : in STD_LOGIC_VECTOR (11 downto 0);
           CH1_zero : in STD_LOGIC_VECTOR (11 downto 0);
           CH_trig_outt : out STD_LOGIC;
           CH_trig_outa : out STD_LOGIC;
           CH_trig_bgnd : out STD_LOGIC;
           CH_TIME : out STD_LOGIC_VECTOR (9 downto 0);
           CH_ampl  : out STD_LOGIC_VECTOR (12 downto 0);
           DATA_out : out STD_LOGIC_VECTOR (32 downto 0);
           DATA_ready  : out STD_LOGIC;
           DATA_rd : in STD_LOGIC;
           FIFO_dis  : in STD_LOGIC;
           Event_in  : out STD_LOGIC;
           Cal : in STD_LOGIC;
           Z0_cal : out STD_LOGIC_VECTOR (11 downto 0);
           Z1_cal : out STD_LOGIC_VECTOR (11 downto 0);
           Cal_done : out STD_LOGIC;
           spi_lock : in STD_LOGIC;
           R0_cal : out STD_LOGIC_VECTOR (11 downto 0);
           R1_cal : out STD_LOGIC_VECTOR (11 downto 0);
           R0_corr : in STD_LOGIC_VECTOR (11 downto 0);
           R1_corr : in STD_LOGIC_VECTOR (11 downto 0);
           pulse_in  : out STD_LOGIC;
           chan_ena  : in STD_LOGIC
            );
           
end Channel;

architecture RTL of Channel is

type vector4x9 is array (0 to 3) of STD_LOGIC_VECTOR (8 downto 0);

signal TDC_rdy320_0, TDC_rdy320, TDC_rdy320_1, TDC_rdy_en, TDC_out, CH_t_trig0, CH_t_trig1, CH_t_trig2, TDC_rdy, TDC_dt,CH_dt, CH_trig_f, EV, EV_0, EV_E, EV_de, EV_fl, EV_b1, EV_b0, CH_wait, CH_tr_en, CH_de, CH_ds, FIFO_rst, EV_rdy : STD_LOGIC; 
signal EVENTFIFO_wr, EVENTFIFO_rd, EVENTFIFO_empty, CH_trig_on, FEV_0, FEV_1,  EV_a0, CSTR_0, CSTR_1, CSTR_2, CSTR_3, CSTR_4, EV_am_fl, EV_am_fl0, EV_am_en, CH_rd, Evnt, Ampl_OK, Ampl_high, Time_OK, Time_OK_rd, Time_lost, Event_inp, CH_trig_a : STD_LOGIC;
signal CH_TIME0, CH_TIME1, CH_TIME2, CH_RTIME, R_corr : STD_LOGIC_VECTOR (11 downto 0);
signal EV_id :  STD_LOGIC_VECTOR(5 downto 0);
signal EV_dly : vector4x9;
signal EV_v : STD_LOGIC_VECTOR (8 downto 0);
signal C_FOUT,EVENTFIFO_in : STD_LOGIC_VECTOR (22 downto 0);
signal CH_0, CH_ampl0, CH_BS, ampl_fin :  STD_LOGIC_VECTOR(12 downto 0);
signal WD_count : STD_LOGIC_VECTOR(2 downto 0);
signal WD_rdy : STD_LOGIC_VECTOR(1 downto 0);
signal cal_0, RDF_wr, rd_empty : STD_LOGIC;
signal Z0, Z1 : STD_LOGIC_VECTOR(17 downto 0);
signal CH_R0, CH_R1 : STD_LOGIC_VECTOR(22 downto 0);
signal Ampl_corr : STD_LOGIC_VECTOR(25 downto 0);
signal RDF_in  : STD_LOGIC_VECTOR(32 downto 0);
signal Z_count : STD_LOGIC_VECTOR(7 downto 0);
signal TDC_pause : STD_LOGIC_VECTOR(5 downto 0);
signal TDC_load : STD_LOGIC_VECTOR(3 downto 0);


component EVENT_FIFO
	Port (  clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(22 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(22 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC);
   end component ;

component CHAN_RD_FIFO
       Port (  clk : IN STD_LOGIC;
       srst : IN STD_LOGIC;
       din : IN STD_LOGIC_VECTOR(32 DOWNTO 0);
       wr_en : IN STD_LOGIC;
       rd_en : IN STD_LOGIC;
       dout : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);
       full : OUT STD_LOGIC;
       empty : OUT STD_LOGIC);
      end component ;
      
COMPONENT MULS13x12
        PORT (
          A : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
          B : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
          P : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
        );
END COMPONENT;      
   
 
begin
CH_ampl<=CH_ampl0;
CH_trig_outt<=CH_trig_f;
CH_trig_outa<=CH_trig_a; 

Z0_cal<=Z0(17 downto 6); Z1_cal<=Z1(17 downto 6); pulse_in<=EV_E; Cal_done<=Z_count(7);

R0_cal<= CH_R0(21 downto 10) when (CH_R0(22)='0') else x"000";
R1_cal<= CH_R1(21 downto 10) when (CH_R1(22)='0') else x"000";

EVENTFIFO: EVENT_FIFO port map (clk => clk320, srst =>RESET, din =>EVENTFIFO_in, wr_en => EVENTFIFO_wr, rd_en =>EVENTFIFO_rd, dout => C_FOUT, full =>open, empty =>EVENTFIFO_empty);

EVENTFIFO_in <=CH_0(12)& Ampl_fin & EV_am_fl & EV_dly(3)(7 downto 0);

RD_FIFO:  CHAN_RD_FIFO port map (clk => clk320, srst =>FIFO_rst, din =>RDF_in, wr_en => RDF_wr, rd_en =>DATA_rd, dout => DATA_out, full =>open, empty =>rd_empty);

DATA_ready<=not rd_empty;

RDF_in<=Time_lost & CH_trig_f & Ampl_high & Time_OK_rd & C_FOUT(8 downto 6) & C_FOUT(22 downto 9) & CH_RTIME;

FIFO_rst<=FIFO_dis or RESET;
process (clk320)
begin
if (clk320'event and clk320='1') then

TDC_rdy320_0<=TDC_rdy_in; TDC_rdy320<=TDC_rdy320_0; TDC_rdy320_1<=TDC_rdy320;

if (chan_ena='1') then EV_0<=CGE; else EV_0<='0'; end if;
 
EV_rdy<= EV; EV<=EV_0; 

CSTR_0<=CSTR; CSTR_1<=CSTR_0; CSTR_2<=CSTR_1; CSTR_3<=CSTR_2; CSTR_4<=CSTR_3;
if (CSTR_1='1') and (CSTR_2='0') then CH_0<=CH; end if;

cal_0<=Cal;

if (cal_0='0') and (Cal='1') then Z0<="00" & x"0000"; Z1<="00" & x"0000"; Z_count<=(others=>'0');
 else 
  if (Cal='1') and (CSTR_2='1') and (CSTR_3='0') and (Z_count(7)='0') then 
    if (CH_0(12)='0') then Z0<=Z0+ ("000000"& CH_0(11 downto 0)); else Z1<=Z1+ ("000000" & CH_0(11 downto 0)); end if;
    Z_count<=Z_count+1;
  end if;
end if;

if (spi_lock='0') and (CSTR_3='1') and (CSTR_4='0') then
 if (CH_0(12)='0') then CH_R0<=CH_R0-std_logic_vector(resize(signed(CH_R0(22 downto 10)), 23)-resize(signed(CH_BS),23));
               else     CH_R1<=CH_R1-std_logic_vector(resize(signed(CH_R1(22 downto 10)), 23)-resize(signed(CH_BS),23));
 end if;
end if;

if (TDC_rdy_en='1') then CH_TIME2<=CH_TIME1; CH_TIME1<=CH_TIME0; CH_t_trig2 <= CH_t_trig1; CH_t_trig1 <= CH_t_trig0; 

    if (mt_cou/="001") or (CH_wait='0') then  TDC_rdy<='1';
        if (TDC_rdy='1') then TDC_dt<='1'; end if;
    end if;
 TDC_pause<=(others=>'0');
  else
  if (EV_a0='1') then
   if (FEV_0='1') and (FEV_1='1') and (EV_E='1') then TDC_pause<=(others=>'0');  FEV_1<='0'; else TDC_pause<=TDC_pause+1; end if;
   if (TDC_pause=15) and (FEV_0='0') then FEV_0<='1'; FEV_1<='1'; end if;          
   if (TDC_pause=45) and (FEV_0='1') and (FEV_1='0') then TDC_load<=(others=>'0'); FEV_0<='0'; end if;
  else FEV_0<='0'; FEV_1<='0';
  end if;    
end if;

 if (RESET='1') then TDC_load<=(others=>'0');
 else   
  if (EV_a0='0') then 
    if (EV_E='1') and (TDC_out='0') then  TDC_load<=TDC_load+1;  end if;
    if (EV_E='0') and (TDC_out='1') and (TDC_load/=0) then TDC_load<=TDC_load-1; end if;
  end if;
 end if;

if (mt_cou="001") then 
    
    EV_dly<= EV_v & EV_dly(0 to 2); Time_OK_rd<= not Time_OK; Ampl_high<= (not Ampl_OK) and C_FOUT(8);
    
    if (Event_inp='1') then EV_id<=BC_COU; EV_de<=EV_b1 OR (EV_E AND EV_b0); EV_fl<='1';
        else EV_fl<='0'; end if;
    EV_b0<='0'; EV_b1<='0';
 
    if (TDC_rdy='1') and (CH_wait='0') then  WD_rdy<=WD_rdy+1; else WD_rdy<="00"; end if;
    if (WD_rdy="11") then TDC_rdy<='0'; TDC_dt<='0'; end if; 
    
    if ((CH_wait='1') and ((TDC_rdy='1') or (TDC_rdy_en='1'))) or (Time_lost='1') then Evnt<='1'; else  Evnt<='0'; end if; 
    
    if (CH_wait='1') and ((TDC_rdy='1') or (TDC_rdy_en='1'))then 
    
           if (TDC_dt='0') and ((TDC_rdy='0') or (TDC_rdy_en='0')) then
               TDC_rdy<='0';
               if (CH_de='0') then CH_wait<='0'; else CH_de<='0'; end if;
               if (TDC_rdy_en='1') then CH_trig_f<=CH_t_trig0 and CH_tr_en; else CH_trig_f<= CH_t_trig1 and CH_tr_en; end if;
               
           else CH_wait<='0'; CH_de<='0';  CH_dt<='1'; TDC_dt<='0';
             if (CH_de='1') then CH_ds<='1'; TDC_rdy<='0'; 
                 if (TDC_rdy_en='1') then CH_trig_f<=(CH_t_trig1 or CH_t_trig0) and CH_tr_en; else CH_trig_f<=(CH_t_trig2 or CH_t_trig1) and CH_tr_en; end if;
           else 
                 if (TDC_rdy_en='1') then CH_trig_f<=CH_t_trig1 and CH_tr_en; else CH_trig_f<=CH_t_trig2 and CH_tr_en; end if;
                 end if; 
           end if;
            
    end if;
  
else 
    if (EV_E='1') then EV_b0<='1'; if (EV_b0='1') then EV_b1<='1'; end if; end if;
end if;

if (mt_cou="010") then
   CH_ds<='0'; CH_dt<='0'; CH_trig_f<='0'; CH_trig_a<='0'; Time_lost<='0';
end if;

if (mt_cou="011") then 
    EV_am_en<=EV_dly(2)(8); 
end if;

if (mt_cou="100") then EV_am_fl0<='0'; EV_am_fl<=EV_am_fl0; CH_trig_a<=EV_dly(3)(8) and  EV_am_fl0; CH_trig_bgnd<= EV_dly(3)(8) and  not EV_am_fl0;
   else if (CSTR_1='1') and (CSTR_2='0') then  EV_am_fl0<=EV_am_en; end if;
end if;


if (mt_cou="101") then 
        if (CH_trig_a='1') then CH_ampl0<= Ampl_fin; else CH_ampl0<= (others=>'0'); end if; 
         
end if;  

if (mt_cou="110") then 
       if  (CH_wait='1') then  
        if (WD_count="101")  then  WD_count<="000"; CH_wait<='0'; Time_lost<='1'; else WD_count<=WD_count+1; end if;
       else 
        WD_count<="000";
        if (EVENTFIFO_empty='0') then CH_wait<='1'; CH_rd<='1'; end if;  
       end if;
        
end if;  

if (mt_cou="111") then
     if (RESET='1') then CH_de<='0'; CH_wait<='0'; 
      else
        if (CH_rd='1') and (C_FOUT(6)='1') then CH_de<='1';  end if;
    end if;
    CH_rd<='0';
 end if;

end if;
end process;

EV_a0<= '1' when (TDC_load>14) else '0'; 

EV_v <= EV_fl & EV_a0 & EV_de & EV_id;

EVENTFIFO_wr<= '1' when (mt_cou="101") and (EV_dly(3)(8)='1') else '0';
EVENTFIFO_rd<= '1' when (mt_cou="110") and (CH_wait='0') and (EVENTFIFO_empty='0') else '0';
RDF_wr<= '1' when (mt_cou="010") and (Evnt='1') and (FIFO_dis='0') else '0';

CH_TIME0<=TDC - CH_shift;

CH_t_trig0<= '1' when ((CH_TIME0 > "1111" & gate_time_low) OR (CH_TIME0 < "0000" & gate_time_high)) else '0';  

TDC_rdy_en<=TDC_rdy320 and not TDC_rdy320_1;
TDC_out<=(not TDC_rdy320) and TDC_rdy320_1;

EV_E<=EV and not EV_rdy;
Event_inp<= EV_E or EV_b0 or EV_b1;

Time_OK<='1' when (C_FOUT(5 downto 0)=TR_BC) else '0';
CH_tr_en<=C_FOUT(8) and Ampl_OK and Time_OK and not C_FOUT(7);
--CH_trig_f<= ((CH_t_trig1 and (not TDC_dt or CH_ds)) or (CH_t_trig2 and (TDC_dt or CH_ds)));


CH_BS<=('0'& CH_0(11 downto 0)) - ('0'&CH0_zero) when (CH_0(12)='0') else
       ('0'& CH_0(11 downto 0)) - ('0'&CH1_zero);

CH_TIME<=CH_TIME1 (9 downto 0) when (CH_trig_f='1') and (((CH_dt='0') and (CH_ds='0')) or ((CH_t_trig1='1') and (CH_ds='1'))) else
           CH_TIME2 (9 downto 0) when (CH_trig_f='1') and (((CH_dt='1') and (CH_ds='0')) or ((CH_t_trig2='1') and (CH_ds='1'))) else
          "0000000000";
          
CH_RTIME<=  CH_TIME2 when  (((CH_dt='1') and (CH_ds='0')) or ((CH_t_trig2='1') and (CH_ds='1'))) else CH_TIME1;
   
          
R_corr<=R0_corr when (CH_0(12)='0') else R1_corr; 
Ampl_corr<= std_logic_vector(signed(CH_BS) * signed('0'& R_corr));

Ampl_fin<= Ampl_corr(23 downto 11) when (signed(Ampl_corr(25 downto 23))<1) else '0' & x"FFF";

Ampl_OK<='1' when (signed(C_FOUT(21 downto 9)) < signed('0' & Ampl_sat)) else '0';
 
Event_in<=Event_inp;

end RTL;
