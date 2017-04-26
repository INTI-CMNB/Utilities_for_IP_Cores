------------------------------------------------------------------------------
----                                                                      ----
----  Str [Package]                                                       ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  String utility functions.                                           ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Salvador E. Tropea, salvador@inti.gov.ar                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2007 Salvador E. Tropea <salvador@inti.gov.ar>         ----
---- Copyright (c) 2007 Instituto Nacional de Tecnología Industrial       ----
----                                                                      ----
---- Distributed under the GPL v2 or newer license                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      Str (Package)                                      ----
---- File name:        str_pkg.vhdl                                       ----
---- Note:             None                                               ----
---- Limitations:      None known                                         ----
---- Errors:           None known                                         ----
---- Library:          utils                                              ----
---- Dependencies:     IEEE.std_logic_1164                                ----
----                   IEEE.numeric_std                                   ----
---- Target FPGA:      None                                               ----
---- Language:         VHDL                                               ----
---- Wishbone:         N/A                                                ----
---- Synthesis tools:  Xilinx Release 8.2.02i - xst I.33                  ----
---- Simulation tools: GHDL [Sokcho edition] (0.2x)                       ----
---- Text editor:      SETEdit 0.5.x                                      ----
----                                                                      ----
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package Str is
   procedure str2sv(s: in string; sv: out std_logic_vector;
                    line_n: in integer:=-1);
   procedure sv2str(sv: in std_logic_vector; s: out string);
   function pad0r(v: in std_logic_vector; size: in integer)
      return std_logic_vector;
   function pad0r(v: in unsigned; size: in integer)
      return unsigned;
   function pad0r(v: in signed; size: in integer)
      return signed;
   function hstr(slv: std_logic_vector) return string;
   function hstr(slv: unsigned) return string;
   function hstr(slv: signed) return string;
end package Str;

package body Str is
   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  String to std_logic_vector. This procedure takes a string @<v>{s} and
   --  fills the std_logic_vector @<v>{sv}. When the strings are from an input
   --  file and you want to report the line where an error was detected use the
   --  @<v>{line_n} argument. This procedure aborts execution if the string and
   --  std_logic_vector doesn't have the same length or if the it finds a
   --  character that isn't an std_logic symbol's.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   procedure str2sv(s: in string; sv: out std_logic_vector;
                    line_n: in integer:=-1) is
      variable i : integer;
   begin
      assert s'length=sv'length report "Range missmatch (s:"&
         integer'image(s'length)&" sv:"&integer'image(sv'length)&")"
         severity failure;
      for i in s'range loop
          if s(i)='U' then
             sv(i-1):='U';
          elsif s(i)='X' then
             sv(i-1):='X';
          elsif s(i)='0' then
             sv(i-1):='0';
          elsif s(i)='1' then
             sv(i-1):='1';
          elsif s(i)='Z' then
             sv(i-1):='Z';
          elsif s(i)='W' then
             sv(i-1):='W';
          elsif s(i)='L' then
             sv(i-1):='L';
          elsif s(i)='H' then
             sv(i-1):='H';
          elsif s(i)='-' then
             sv(i-1):='-';
          else
             if line_n=-1 then
                report "Unknown element in string: '" & s(i) & "' (i=" &
                   integer'image(i) & ")" severity failure;
             else
                report "[line "& integer'image(line_n) &
                   "]: Unknown element in string: '" & s(i) & "' (i=" &
                   integer'image(i) & ")" severity failure;
             end if;
          end if;
      end loop;
   end procedure str2sv;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Std_logic_vector to String. This procedure takes a std_logic_vector
   --  @<v>{sv} and fills the string @<v>{s}. This procedure aborts execution
   --  if the string and std_logic_vector doesn't have the same length.
   --  Author: Rodrigo A. Melo
   --
   -------------------------------------------------------------------[/txh]---
   procedure sv2str(sv: in std_logic_vector; s: out string) is
      variable i : integer;
   begin
      assert s'length=sv'length report "Range missmatch (sv:"&
         integer'image(sv'length)&" s:"&integer'image(s'length)&")"
         severity failure;
      for i in sv'range loop
          if sv(i)='U' then
             s(i+1):='U';
          elsif sv(i)='X' then
             s(i+1):='X';
          elsif sv(i)='0' then
             s(i+1):='0';
          elsif sv(i)='1' then
             s(i+1):='1';
          elsif sv(i)='Z' then
             s(i+1):='Z';
          elsif sv(i)='W' then
             s(i+1):='W';
          elsif sv(i)='L' then
             s(i+1):='L';
          elsif sv(i)='H' then
             s(i+1):='H';
          else
             s(i+1):='-';
          end if;
      end loop;
   end procedure sv2str;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Adds as many 0s to the right of @<v>{v} to obtain the desired @<v>{size}
   --  If the size of the input is bigger than the specified this function
   --  returns the MSBs.@p
   --  The vectors must be in downto order and use 0 as right bound.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   function pad0r(v: in std_logic_vector; size: in integer)
                  return std_logic_vector is
      variable aux : std_logic_vector(size-1 downto 0):=(others => '0');
      constant len : integer:=v'length;
   begin
      if len>=size then
         return v(len-1 downto len-size);
      end if;
      aux(size-1 downto size-len):=v;
      return aux;
   end function pad0r;

   function pad0r(v: in unsigned; size: in integer)
                  return unsigned is
   begin
      return unsigned(pad0r(std_logic_vector(v),size));
   end function pad0r;

   function pad0r(v: in signed; size: in integer)
                  return signed is
   begin
      return signed(pad0r(std_logic_vector(v),size));
   end function pad0r;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Converts a std_logic_vector into a hex string.
   --  Author: Øyvind Harboe
   --
   -------------------------------------------------------------------[/txh]---
   function hstr(slv: std_logic_vector) return string is
      variable hexlen  : integer;
      variable longslv : std_logic_vector(slv'left+3 downto 0):=(others => '0');
      variable hex     : string(1 to (slv'left+1)/4+1);
      variable fourbit : std_logic_vector(3 downto 0);
   begin
      hexlen:=(slv'left+1)/4;
      if (slv'left+1) mod 4/=0 then
         hexlen:=hexlen+1;
      end if;
      longslv(slv'left downto 0):=slv;
      for i in (hexlen-1) downto 0 loop
          fourbit:=longslv(((i*4)+3) downto (i*4));
          case fourbit is
               when "0000" => hex(hexlen-I):='0';
               when "0001" => hex(hexlen-I):='1';
               when "0010" => hex(hexlen-I):='2';
               when "0011" => hex(hexlen-I):='3';
               when "0100" => hex(hexlen-I):='4';
               when "0101" => hex(hexlen-I):='5';
               when "0110" => hex(hexlen-I):='6';
               when "0111" => hex(hexlen-I):='7';
               when "1000" => hex(hexlen-I):='8';
               when "1001" => hex(hexlen-I):='9';
               when "1010" => hex(hexlen-I):='A';
               when "1011" => hex(hexlen-I):='B';
               when "1100" => hex(hexlen-I):='C';
               when "1101" => hex(hexlen-I):='D';
               when "1110" => hex(hexlen-I):='E';
               when "1111" => hex(hexlen-I):='F';
               when "ZZZZ" => hex(hexlen-I):='z';
               when "UUUU" => hex(hexlen-I):='u';
               when "XXXX" => hex(hexlen-I):='x';
               when others => hex(hexlen-I):='?';
          end case;
      end loop;
      return hex(1 to hexlen);
   end function hstr;

   function hstr(slv: unsigned) return string is
   begin
      return hstr(std_logic_vector(slv));
   end function hstr;

   function hstr(slv: signed) return string is
   begin
      return hstr(std_logic_vector(slv));
   end function hstr;

end package body Str;
