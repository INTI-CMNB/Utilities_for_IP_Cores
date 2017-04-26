------------------------------------------------------------------------------
----                                                                      ----
----  Stdlib [Package]                                                    ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  General utility functions.                                          ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Salvador E. Tropea, salvador@inti.gov.ar                        ----
----    - Rodrigo A. Melo, rmelo@inti.gov.ar                              ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2007-2008 Salvador E. Tropea <salvador@inti.gov.ar>    ----
---- Copyright (c) 2007 Rodrigo A. Melo <rmelo@inti.gov.ar>               ----
---- Copyright (c) 2007 Instituto Nacional de Tecnología Industrial       ----
----                                                                      ----
---- Distributed under the GPL v2 or newer license                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      StdLib (Package)                                   ----
---- File name:        stdlib_pkg.vhdl                                    ----
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
--
-- CVS Revision History
--
-- $Log: stdlib_pkg.vhdl,v $
-- Revision 1.11  2017/04/26 12:31:54  salvador
-- * Modified: All the headers to mention FPGA Libre and to use GPL v2.0+
--
-- Revision 1.10  2012-01-13 14:00:06  francisco
-- * Added: Debounce filter component.
--
-- Revision 1.9  2009-11-19 19:48:11  ram
-- * Agregado: componentes SyncClkDomain y SyncClkdomainBase.
--
-- Revision 1.8  2009-06-26 12:10:13  salvador
-- * Added: A Simple Clock Divider, just to make the cores more readable.
--
-- Revision 1.7  2009-04-22 17:06:31  salvador
-- * Agregado: Módulo generador de reloj y reset.
--
-- Revision 1.6  2008-04-30 18:03:31  salvador
-- * Agregado: [Makefile stdlib_pkg.vhdl delay.vhdl] Nuevo módulo que
-- introduce una demora de un pulso de reloj.
--
-- Revision 1.5  2008-03-05 10:29:33  salvador
-- * Added: To_01 for bits, and operator between a vector and a bit and
-- functions to handle bidimensional arrays.
--
-- Revision 1.4  2008-01-22 13:05:07  salvador
-- * Modificado: La implementación de To_01 para que pueda sintetizarse con
-- Xilinx que no soportaba el mecanismo anterior.
--
-- Revision 1.3  2008-01-16 18:08:38  salvador
-- * Agregado: [stdlib.vhdl] To_01, similar a To_X01.
--
-- Revision 1.2  2007/02/13 17:28:00  salvador
-- * Fixed: Moved function/procedure bodies to the package body. GHDL crashes
-- if they aren't there.
--
-- Revision 1.1  2007/01/25 16:07:51  salvador
-- * Added: First functions from functions used in various projects.
--
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package StdLib is
   function sv2sint(v: in std_logic_vector) return integer;
   function sv2uint(v: in std_logic_vector) return integer;
   function sv2char(v: in std_logic_vector(7 downto 0)) return character;
   function To_01(s : std_logic_vector) return  std_logic_vector;
   function To_01(s : std_logic) return  std_logic;

   function "and"(l: std_logic_vector; r: std_logic) return std_logic_vector;
   function "and"(l: unsigned; r: std_logic) return unsigned;

   -- 1 clock delay
   component Delay1 is
      port(
         clk_i : in  std_logic;  -- Clock
         rst_i : in  std_logic;  -- Reset
         d_i   : in  std_logic;  -- Input
         d_o   : out std_logic); -- Output
   end component Delay1;

   -- Clock and reset for testbenches
   component SimpleClock is
      generic(
         FREQUENCY : positive:=25e6; -- Hz
         RESET_TM  : real:=1.5);     -- Reset duration expresed in clocks
      port(
         clk_o  : out std_logic;  -- Clock
         nclk_o : out std_logic;  -- Clock inverted
         rst_o  : out std_logic;  -- Reset
         stop_i : in  std_logic:='0');  -- Stop clock generation
   end component SimpleClock;

   -- Simple clock divider
   component SimpleDivider is
      generic(
         DIV : positive:=2);
      port(
         clk_i  : in  std_logic;
         rst_i  : in  std_logic;
         ena_i  : in  std_logic:='1';
         div_o  : out std_logic);
   end component SimpleDivider;

   component SyncClkDomainBase is
      generic(
         INBYLV  : integer range 0 to 1 := 1;  -- Input By Level
         FFCHAIN : natural              := 2); -- Flip Flop Chain
      port(
         rst_i  : in  std_logic;
         clkA_i : in  std_logic;
         clkB_i : in  std_logic;
         a_i    : in  std_logic;
         b_o    : out std_logic;
         ack_o  : out std_logic);
   end component SyncClkDomainBase;

   component SyncClkDomain is
      generic(
         INBYLV   : integer range 0 to 1 := 1;  -- Input By Level
         FFCHAIN  : natural              := 2;  -- Flip Flop Chain
         CHANNELS : positive             := 1); -- Channels
      port(
         rst_i  : in  std_logic;
         clkA_i : in  std_logic;
         clkB_i : in  std_logic;
         a_i    : in  std_logic_vector(CHANNELS-1 downto 0);
         b_o    : out std_logic_vector(CHANNELS-1 downto 0);
         ack_o  : out std_logic_vector(CHANNELS-1 downto 0));
   end component SyncClkDomain;

   component Debounce is
      generic(
         FREQUENCY : positive:=50e6; -- Clock frequency [Hz]
         DEB_TIME  : real:=50.0e-3); -- Debounce time [s]
      port(
         clk_i : in  std_logic;      -- Clock
         deb_i : in  std_logic;      -- Input signal
         deb_o : out std_logic);     -- Output signal
   end component Debounce;

   -- 2D arrays
   type std_logic_2d is array (natural range <>, natural range <>) of std_logic;
   type unsigned_2d is array (natural range <>, natural range <>) of std_logic;

   procedure set2d(signal v: out std_logic_2d; i: in natural; d:
                   in std_logic_vector);
   procedure set2d(signal v: out unsigned_2d; i: in natural; d: in unsigned);
   function get2d(v: in std_logic_2d; i: in natural) return std_logic_vector;
   function get2d(v: in unsigned_2d; i: in natural) return unsigned;
   procedure reset2d(v: out std_logic_2d);
   procedure reset2d(v: out unsigned_2d);
end package StdLib;

package body StdLib is
   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Converts a std_logic_vector (@<v>{v}) to integer assuming that the
   --  argument represents a signed value (2's complement).
   --  Return: integer representation.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   function sv2sint(v: in std_logic_vector) return integer is
   begin
      return to_integer(signed(v));
   end function sv2sint;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Converts a std_logic_vector (@<v>{v}) to integer assuming that the
   --  argument represents a unsigned value.
   --  Return: integer representation.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   function sv2uint(v: in std_logic_vector) return integer is
   begin
      return to_integer(unsigned(v));
   end function sv2uint;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Converts a std_logic_vector (@<v>{v}) to a character assuming that the
   --  argument represents a unsigned value.
   --  Return: character representation.
   --  Author: Rodrigo A. Melo
   --
   -------------------------------------------------------------------[/txh]---
   function sv2char(v: in std_logic_vector(7 downto 0)) return character is
   begin
      return character'val(to_integer(unsigned(v)));
   end function sv2char;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Converts a std_logic_vector (@<v>{s}) to all 0's and 1's avoiding other
   --  values.
   --  Return: the normalized vector.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   function To_01(s : std_logic_vector) return  std_logic_vector is
      alias sv : std_logic_vector(1 to s'length) is s;
      variable result : std_logic_vector(1 to s'length);
   begin
      for i in result'range loop
          if sv(i)='1' or sv(i)='H' then
             result(i):='1';
          else
             result(i):='0';
          end if;
      end loop;
      return result;
   end;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Converts the provided value to '0' or '1'.
   --  Return: the normalized value.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   function To_01(s : std_logic) return  std_logic is
   begin
      if s='1' or s='H' then
         return '1';
      end if;
      return '0';
   end;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Assigns @<v>{d} to the element @<v>{i} of the @<v>{v} 2D array.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   procedure set2d(signal v: out std_logic_2d; i: in natural;
                   d: in std_logic_vector) is
   begin
      assert v'left(2)=d'left and v'right(2)=d'right
         report "set2d: array ranges doesn't match"
         severity error;
      for j in d'range loop
          v(i,j) <= d(j);
      end loop;
   end set2d;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Assigns @<v>{d} to the element @<v>{i} of the @<v>{v} 2D array.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   procedure set2d(signal v: out unsigned_2d; i: in natural;
                   d: in unsigned) is
   begin
      assert v'left(2)=d'left and v'right(2)=d'right
         report "set2d: array ranges doesn't match"
         severity error;
      for j in d'range loop
          v(i,j) <= d(j);
      end loop;
   end set2d;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Returns the element @<v>{i} of the @<v>{v} 2D array.
   --  Return: the selected vector.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   function get2d(v: in std_logic_2d; i: in natural)
      return std_logic_vector is
      variable ret : std_logic_vector(v'range(2));
   begin
      for j in v'range(2) loop
          ret(j):=v(i,j);
      end loop;
      return ret;
   end get2d;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Returns the element @<v>{i} of the @<v>{v} 2D array.
   --  Return: the selected vector.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   function get2d(v: in unsigned_2d; i: in natural)
      return unsigned is
      variable ret : unsigned(v'range(2));
   begin
      for j in v'range(2) loop
          ret(j):=v(i,j);
      end loop;
      return ret;
   end get2d;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Inits the 2D array with 0s.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   procedure reset2d(v: out std_logic_2d) is
   begin
      for i in v'range(1) loop
          for j in v'range(2) loop
              v(i,j):='0';
          end loop;
      end loop;
   end reset2d;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  Inits the 2D array with 0s.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   procedure reset2d(v: out unsigned_2d) is
   begin
      for i in v'range(1) loop
          for j in v'range(2) loop
              v(i,j):='0';
          end loop;
      end loop;
   end reset2d;

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  This is a bus enable and operation.
   --  Return: the provided vector if the right bit is 1, all 0s otherwise.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   function "and"(l: std_logic_vector; r: std_logic)
      return std_logic_vector is
      variable aux : std_logic_vector(l'range):=(others => '0');
   begin
      if r='1' then
         return l;
      end if;
      return aux;
   end "and";

   ---[txh]--------------------------------------------------------------------
   --
   --  Description:
   --  This is a bus enable and operation.
   --  Return: the provided vector if the right bit is 1, all 0s otherwise.
   --  Author: Salvador E. Tropea
   --
   -------------------------------------------------------------------[/txh]---
   function "and"(l: unsigned; r: std_logic) return unsigned is
   begin
      return unsigned(std_logic_vector(l) and r);
   end "and";

end package body StdLib;
