------------------------------------------------------------------------------
----                                                                      ----
----  Simple Clock module for testbenches                                 ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  A basic clock to simplify the testbenches.                          ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Salvador E. Tropea, salvador en inti gov ar                     ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2008 Salvador E. Tropea <salvador en inti gov ar>      ----
---- Copyright (c) 2008 Instituto Nacional de Tecnología Industrial       ----
----                                                                      ----
---- Distributed under the GPL v2 or newer license                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      SimpleClock(Simulator)                             ----
---- File name:        simple_clock.vhdl                                  ----
---- Note:             None                                               ----
---- Limitations:      None                                               ----
---- Errors:           None known                                         ----
---- Library:          usb                                                ----
---- Dependencies:     IEEE.std_logic_1164                                ----
---- Target FPGA:      None                                               ----
---- Language:         VHDL                                               ----
---- Wishbone:         None                                               ----
---- Synthesis tools:  N/A                                                ----
---- Simulation tools: GHDL [Sokcho edition] (0.2x)                       ----
---- Text editor:      SETEdit 0.5.x                                      ----
----                                                                      ----
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity SimpleClock is
   generic(
      FREQUENCY : positive:=25e6; -- Hz
      RESET_TM  : real:=1.5);     -- Reset duration expresed in clocks
   port(
      clk_o  : out std_logic;  -- Clock
      nclk_o : out std_logic;  -- Clock inverted
      rst_o  : out std_logic;  -- Reset
      stop_i : in  std_logic:='0');  -- Stop clock generation
end entity SimpleClock;

architecture Simulator of SimpleClock is
   signal clk     : std_logic:='0';
   signal nclk    : std_logic:='1';
   signal rst     : std_logic:='1';
begin
   do_clock:
   process
   begin
      clk  <= '0';
      nclk <= '1';
      wait for 1 sec/(2.0*real(FREQUENCY));
      clk  <= '1';
      nclk <= '0';
      wait for 1 sec/(2.0*real(FREQUENCY));
      if stop_i='1' then
         wait;
      end if;
   end process do_clock;
   clk_o <= clk;
   nclk_o <= nclk;

   do_rst:
   process
   begin
      rst <= '1';
      wait for RESET_TM*(1 sec/real(FREQUENCY));
      rst <= '0';
      wait;
   end process do_rst;
   rst_o <= rst;
end architecture Simulator; -- Entity: SimpleClock