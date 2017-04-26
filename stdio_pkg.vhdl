------------------------------------------------------------------------------
----                                                                      ----
----  Stdio [Package]                                                     ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  Input/output utility functions.                                     ----
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
---- Design unit:      StdIO (Package)                                    ----
---- File name:        stdio_pkg.vhdl                                     ----
---- Note:             None                                               ----
---- Limitations:      None known                                         ----
---- Errors:           None known                                         ----
---- Library:          utils                                              ----
---- Dependencies:     IEEE.std_logic_1164                                ----
----                   std.textio                                         ----
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
library std;
use std.textio.all;
library utils;
use utils.str.all;

package StdIO is
   procedure write(l: inout line; v: in std_logic_vector);
   procedure write(l: inout line; v: in std_logic);
   procedure read(l: inout line; v: out std_logic_vector);
   procedure read(l: inout line; v: out std_logic_vector; good: out boolean);
   procedure read(l: inout line; r: out std_logic);
   procedure read(l: inout line; r: out std_logic; good: out boolean);
   procedure outwrite(mensage: in string);
   procedure see_time(mensage: in string; s_time: in time);
   -- Array of 8 bits std_logic_vector
   type slv8_array is array (natural range <>) of std_logic_vector(7 downto 0);
   procedure read( file_name : in  string; out_array : out slv8_array);
   type char_file is file of character; -- one byte each
   procedure readfc( file_name : in  string; out_array : out slv8_array);

end package StdIO;

package body StdIO is
   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  A version of the textio's write function that can print a
   --  std_logic_vector data type.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   procedure write(l: inout line; v: in std_logic_vector) is
      variable i : integer;
      variable s : string(3 downto 1);
   begin
      for i in v'range loop
          s:=std_logic'image(v(i));
          write(l,s(2));
      end loop;
   end procedure write;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  A version of the textio's write function that can print a
   --  std_logic data type.
   --  Author: Rodrigo A. Melo
   --
   -------------------------------------------------------------------[/txh]---
   procedure write(l: inout line; v: in std_logic) is
      variable s : string(3 downto 1);
   begin
      s:=std_logic'image(v);
      write(l,s(2));
   end procedure write;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  A version of the textio's read function that can read a
   --  std_logic_vector data type.
   --  Author: Rodrigo A. Melo
   --
   -------------------------------------------------------------------[/txh]---
   procedure read(l: inout line; v: out std_logic_vector) is
      variable s    : string(v'length downto 1);
   begin
      read(l,s);
      str2sv(s,v);
   end procedure read;

   procedure read(l: inout line; v: out std_logic_vector; good: out boolean) is
      variable s  : string(v'length downto 1);
      variable gd : boolean;
   begin
      read(l,s,gd);
      good:=gd;
      if gd then
         str2sv(s,v);
      end if;
   end procedure read;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  A version of the textio's read function that can read a
   --  std_logic data type.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   procedure read(l: inout line; r: out std_logic) is
      variable s : string(1 to 1);
      variable v : std_logic_vector(0 downto 0);
   begin
      read(l,s);
      str2sv(s,v);
      r:=v(0);
   end procedure read;

   procedure read(l: inout line; r: out std_logic; good: out boolean) is
      variable s  : string(1 to 1);
      variable v  : std_logic_vector(0 downto 0);
      variable gd : boolean;
   begin
      read(l,s,gd);
      good:=gd;
      if gd then
         str2sv(s,v);
         r:=v(0);
      end if;
   end procedure read;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Writes a string to the standard output.
   --  Author: Rodrigo A. Melo
   --
   -------------------------------------------------------------------[/txh]---
   procedure outwrite(mensage: in string) is
      variable lout : line;
   begin
      write(lout,mensage);
      writeline(output,lout);
   end procedure outwrite;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Writes a string and a time to the standard output.
   --  Author: Rodrigo A. Melo
   --
   -------------------------------------------------------------------[/txh]---
   procedure see_time(mensage: in string; s_time: in time) is
      variable lout : line;
   begin
      write(lout,mensage);
      write(lout,s_time);
      writeline(output,lout);
   end procedure see_time;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Reads a text file to an 8 bits std_logic_vector array.
   --  Author: Francisco Salomon
   --
   -------------------------------------------------------------------[/txh]---
   procedure read( file_name : in  string; out_array : out slv8_array) is
      variable byte_cnt : natural:=0;
      variable ldata    : line;
      variable dir      : character;
      variable ok       : boolean:=false;
      variable status   : file_open_status;
      variable i        : integer;
      file     data_f   : text;
   begin
      file_open(status, data_f, file_name, read_mode);
      assert status=open_ok report "Failed to open " & file_name
         severity failure;
      readline(data_f,ldata);
      for i in out_array'range loop
          if endfile(data_f) then
                exit;
          end if;
          read(ldata,dir,ok);
          if ok/=true then
             readline(data_f,ldata);
             read(ldata,dir,ok);
             assert ok=true report "Data reading error" severity failure;
          end if;
          out_array(i):=std_logic_vector(to_unsigned(character'pos(dir),8));
       end loop;
       file_close(data_f);
   end procedure read;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Reads a binary file to an 8 bits std_logic_vector array.
   --  Author: Francisco Salomon
   --
   -------------------------------------------------------------------[/txh]---
   procedure readfc( file_name : in  string; out_array : out slv8_array) is
      variable dir      : character;
      variable status   : file_open_status;
      file     data_f   : char_file;
   begin
      file_open(status, data_f, file_name, read_mode);
      assert status=open_ok report "Failed to open " & file_name
         severity failure;
      for i in out_array'range loop
          if endfile(data_f) then
                exit;
          end if;
          read(data_f,dir);
          out_array(i):=std_logic_vector(to_unsigned(character'pos(dir),8));
       end loop;
       file_close(data_f);
   end procedure readfc;

end package body StdIO;
