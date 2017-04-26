------------------------------------------------------------------------------
----                                                                      ----
----  Delay                                                               ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  This file implements a generic 1 clock delay component.             ----
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
---- Design unit:      Delay1(RTL)                                        ----
---- File name:        delay.vhdl                                         ----
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

entity Delay1 is
   port(
      clk_i : in  std_logic;  -- Clock
      rst_i : in  std_logic;  -- Reset
      d_i   : in  std_logic;  -- Input
      d_o   : out std_logic); -- Output
end entity Delay1;

architecture RTL of Delay1 is
   signal d_r : std_logic:='0';
begin
   do_delay:
   process (clk_i)
   begin
      if rising_edge(clk_i) then
         if rst_i='1' then
            d_r <= '0';
         else
            d_r <= d_i;
         end if;
      end if;
   end process do_delay;
   d_o <= d_r;
end architecture RTL; -- Entity: Delay1
