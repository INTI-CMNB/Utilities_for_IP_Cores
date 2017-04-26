------------------------------------------------------------------------------
----                                                                      ----
----  Debounce                                                            ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  This file implements a configurable debounce filter.                ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Francisco Salomón, fsalomon en inti gob ar                      ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2012 Francisco Salomón <fsalomon en inti gob ar>       ----
---- Copyright (c) 2012 Instituto Nacional de Tecnología Industrial       ----
----                                                                      ----
---- Distributed under the GPL v2 or newer license                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      Debounce(RTL)                                      ----
---- File name:        debounce.vhdl                                      ----
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

entity Debounce is
   generic(
      FREQUENCY : positive:=50e6; -- Clock frequency [Hz]
      DEB_TIME  : real:=50.0e-3   -- Debounce time [s]
      );
   port(
      clk_i : in  std_logic;      -- Clock
      deb_i : in  std_logic;      -- Input signal
      deb_o : out std_logic       -- Output signal
      );
end entity Debounce;

architecture RTL of Debounce is
begin
   do_debounce:
   process (clk_i)
      variable cnt : natural:=0;
   begin
      if rising_edge(clk_i) then
         if deb_i='1' then
            if cnt=natural(real(FREQUENCY)*DEB_TIME) then
               deb_o <= '1';
               cnt:=0;
            else
               cnt:=cnt+1;
            end if;
         else
            deb_o <= '0';
            cnt:=0;
         end if;
      end if;
   end process do_debounce;
end architecture RTL; -- Entity: Debounce
