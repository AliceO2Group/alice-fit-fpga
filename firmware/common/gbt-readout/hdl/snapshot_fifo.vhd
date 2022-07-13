----------------------------------------------------------------------------------
-- Company: INR RAS
-- Engineer: Finogeev D. A. dmitry-finogeev@yandex.ru
-- 
-- Create Date:    07/2022 
-- Description: writes register n*32 to clk1. registers are read by clk2 with bus width 32 bits
--
-- Revision: 07/2021
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity snapshot_fifo is

  generic (
    n32_size : integer := 5
    );

  port (
    wr_clk_i  : in std_logic;
    rd_clk_i  : in std_logic;
    asreset_i : in std_logic;

    di_i : in std_logic_vector(n32_size*32-1 downto 0);
    do_o : out std_logic_vector(31 downto 0);

    wren_i : in std_logic;
    rden_i : in std_logic
    );
end snapshot_fifo;

architecture Behavioral of snapshot_fifo is

  signal reset_wclk, reset_rclk : std_logic;

  signal ireg_wrclk, ireg_rdclk : std_logic_vector(n32_size*32-1 downto 0);

  signal is_empty_wrclk, is_empty_rdclk       : boolean;
  signal end_reached_rdclk, end_reached_wrclk : boolean;
  signal rd_cnt                               : integer range 0 to n32_size-1 := 0;

--  attribute mark_debug              : string;
--  attribute mark_debug of reset     : signal is "true";


begin

-- reset write clock
  process (wr_clk_i, asreset_i)
  begin
    if(asreset_i = '1') then reset_wclk <= '1'; end if;
    if(rising_edge(wr_clk_i))then
      if (reset_wclk = '1' and asreset_i = '0') then reset_wclk <= '0'; end if;
    end if;
  end process;

-- reset read clock
  process (rd_clk_i, asreset_i)
  begin
    if(asreset_i = '1') then reset_rclk <= '1'; end if;
    if(rising_edge(rd_clk_i))then
      if (reset_rclk = '1' and asreset_i = '0') then reset_rclk <= '0'; end if;
    end if;
  end process;



-- writing to reg --------------------------------
  process (wr_clk_i)
  begin

    if(rising_edge(wr_clk_i))then

      end_reached_wrclk <= end_reached_rdclk;

      if (reset_wclk = '1') then

        ireg_wrclk     <= (others => '0');
        is_empty_wrclk <= true;

      else

        if wren_i = '1' and is_empty_wrclk then
          ireg_wrclk     <= di_i;
          is_empty_wrclk <= false;
        elsif end_reached_wrclk then
          is_empty_wrclk <= true;
        end if;


      end if;

    end if;

  end process;

-- not is_empty_wrclk -> rd_cnt=n32_size-1 -> end_reached -> is_empty<=true

-- reading from reg ------------------------------
  process (rd_clk_i)
  begin

    if(rising_edge(rd_clk_i))then

      is_empty_rdclk <= is_empty_wrclk;
      ireg_rdclk     <= ireg_wrclk;

      if (reset_rclk = '1') then

        rd_cnt            <= 0;
        end_reached_rdclk <= false;

      else

        if rden_i = '1' and not is_empty_rdclk then
          if rd_cnt /= n32_size-1 then rd_cnt <= rd_cnt+1;
          else end_reached_rdclk              <= true; end if;
        elsif is_empty_rdclk then
          end_reached_rdclk <= false;
          rd_cnt            <= 0;
        end if;

      end if;

    end if;

  end process;


  do_o <= ireg_rdclk(rd_cnt*32 + 31 downto rd_cnt*32) when not end_reached_rdclk else (others => '0');



end Behavioral;

