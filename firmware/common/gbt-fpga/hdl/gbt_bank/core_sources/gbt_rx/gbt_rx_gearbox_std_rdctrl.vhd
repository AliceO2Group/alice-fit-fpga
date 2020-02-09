--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX gearbox          
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Vendor agnostic                                                      
-- Tool version:                                                                             
--                                                                                                   
-- Version:               3.2                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        01/10/2009   0.1       F. Marin (CPPM)   First .vhd module definition. 
--                                                                  
--                        12/11/2013   3.0       M. Barros Marin   Cosmetic and minor modifications. 
--
--                        03/07/2014   3.2       M. Barros Marin   - Use of only one clock domain (RX_FRAMECLK). 
--                                                                 - Fixed READY_O issue.
--
-- Additional Comments:                                                     
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!   (Note!! These parameters are vendor specific)                                           !!                    
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_bank_package.vhd").                                !! 
-- !!     (e.g. xlx_v6_gbt_bank_package.vhd)                                                    !!
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<vendor>_<device>_gbt_bank_user_setup.vhd".     !!
-- !!     (e.g. xlx_v6_gbt_bank_user_setup.vhd)                                                 !! 
-- !!                                                                                           !! 
-- !! * The "<vendor>_<device>_gbt_bank_user_setup.vhd" is the only file of the GBT Bank that   !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                                   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_rx_gearbox_std_rdctrl is
   port (
      
      --================--
      -- Reset & Clocks --
      --================--    
      
      -- Reset:
      ---------
      
      RX_RESET_I                                : in std_logic;
      
      -- Clocks
      ----------
      
      RX_FRAMECLK_I                             : in std_logic;
      
      --=========--
      -- Control --
      --=========--
      
      RX_HEADER_LOCKED_I                        : in std_logic;
      READ_ADDRESS_O                            : out std_logic_vector(2 downto 0);
      READY_O                                   : out std_logic
   
   ); 
end gbt_rx_gearbox_std_rdctrl;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_gearbox_std_rdctrl is

   --================================ Signal Declarations ================================--   

   signal ready_r                               : std_logic_vector(2 downto 0);
   
   --=====================================================================================--            
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  
  
   --==================================== User Logic =====================================-- 
  
   readAddr: process(RX_RESET_I, RX_HEADER_LOCKED_I, RX_FRAMECLK_I)
      variable counter                          : integer range 0 to RX_GB_READ_DLY-1;
      variable readAddress                      : unsigned(2 downto 0);
   begin    
      if (RX_RESET_I = '1') or (RX_HEADER_LOCKED_I = '0') then
         counter                                := 0;
         ready_r                                <= (others => '0');
         READY_O                                <= '0';
         readAddress                            := (others => '0');
         READ_ADDRESS_O                         <= (others => '0');
      elsif rising_edge(RX_FRAMECLK_I) then
         if counter = RX_GB_READ_DLY-1 then
            -- Comment: Registers to compensate the 2 cycles of delay of the DPRAM.
            READY_O                             <= ready_r(2);
            ready_r(2)                          <= ready_r(1);
            ready_r(1)                          <= ready_r(0);
            ready_r(0)                          <= '1';
            ------------------------------------
            READ_ADDRESS_O                      <= std_logic_vector(readAddress); 
            if readAddress = "111" then 
               readAddress                      := (others => '0');
            else
               readAddress                      := readAddress + 1;
            end if;
         else
            counter                             := counter + 1;
         end if;
      end if;
   end process;
   
   --=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--