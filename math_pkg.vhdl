------------------------------------------------------------------------------
----                                                                      ----
----  Math [Package]                                                      ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----                                                                      ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Francisco Salomón, fsalomon inti.gob.ar                         ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2012 Francisco Salomón <fsalomon inti.gob.ar>          ----
----                                                                      ----
---- Distributed under the GPL v2 or newer license                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      Entity(architecture) (Entity and architecture)     ----
---- File name:        math_pkg.vhdl                                      ----
---- Note:             None                                               ----
---- Limitations:      None known                                         ----
---- Errors:           None known                                         ----
---- Library:          None                                               ----
---- Dependencies:     IEEE.std_logic_1164                                ----
----                   IEEE.numeric_std                                   ----
---- Target FPGA:      None                                               ----
---- Language:         VHDL                                               ----
---- Wishbone:         N/A                                                ----
---- Synthesis tools:  Xilinx Release 11.3                                ----
---- Simulation tools: GHDL [Sokcho edition] (0.2x)                       ----
---- Text editor:      SETEdit 0.5.x                                      ----
----                                                                      ----
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package Math is
   function minimum(left, right: in integer) return integer;
   function log2(a: integer) return integer;
end package Math;

package body Math is

   ---[txh]-------------------------------------------------------------------
   --
   --  Description:
   --  Returns the minimum value
   --
   ------------------------------------------------------------------[/txh]---
   function minimum (left, right: in integer) return integer is
   begin
     if left < right then return left;
     else return right;
     end if;
   end function minimum;
   
   ---[txh]-------------------------------------------------------------------
   --
   --  Description:
   --  Returns log2
   --
   ------------------------------------------------------------------[/txh]---
   function log2 (a : integer) return integer is
   begin
     if (a <= 1) then
        return 0;
     elsif (a > 1 and a <= 2) then
        return 1;
     elsif (a > 2 and a <= 4) then
        return 2;
     elsif (a > 4 and a <= 8) then
        return 3;
     elsif (a > 8 and a <= 16) then
        return 4;
     elsif (a > 16 and a <= 32) then
        return 5;
     elsif (a > 32 and a <= 64) then
        return 6;
     elsif (a > 64 and a <= 128) then
        return 7;
     elsif (a > 128 and a <= 256) then
        return 8;
     elsif (a > 256 and a <= 512) then
        return 9;
     elsif (a > 512 and a <= 1024) then
        return 10;
     elsif (a > 1024 and a <= 2048) then
        return 11;
     elsif (a > 2048 and a <= 4096) then
        return 12;
     elsif (a > 4096 and a <= 8192) then
        return 13;
     elsif (a > 8192 and a <= 16384) then
        return 14;
     elsif (a > 16384 and a <= 32768) then
        return 15;
     else
        return 16;
     end if;
   end function log2;

end package body Math;
