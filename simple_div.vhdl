------------------------------------------------------------------------------
----                                                                      ----
----  Simple Clock Divider                                                ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  This a very simple, and commonly used. circuit to divide the clock. ----
----  I put it here because this is used all the time and helps to make   ----
----  the cores easier to read.@p                                         ----
----  ena_i is an enable input to cascade dividers.@p                     ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Salvador E. Tropea, salvador en inti.gob.ar                     ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2009 Salvador E. Tropea <salvador en inti.gob.ar>      ----
----                                                                      ----
---- Distributed under the GPL v2 or newer license                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      SimpleDivider(RTL) (Entity and architecture)       ----
---- File name:        simple_div.vhdl                                    ----
---- Note:             None                                               ----
---- Limitations:      None known                                         ----
---- Errors:           None known                                         ----
---- Library:          utils                                              ----
---- Dependencies:     IEEE.std_logic_1164                                ----
---- Target FPGA:      Any                                                ----
---- Language:         VHDL                                               ----
---- Wishbone:         None                                               ----
---- Synthesis tools:  Xilinx Release 9.2.03i - xst J.39                  ----
---- Simulation tools: GHDL [Sokcho edition] (0.2x)                       ----
---- Text editor:      SETEdit 0.5.x                                      ----
----                                                                      ----
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity SimpleDivider is
   generic(
      DIV : positive:=2);
   port(
      clk_i  : in  std_logic;
      rst_i  : in  std_logic;
      ena_i  : in  std_logic:='1';
      div_o  : out std_logic);
end entity SimpleDivider;

architecture RTL of SimpleDivider is
   signal div_r : std_logic:='0';
   signal cnt_r : integer range 0 to DIV-1;
begin
   do_bt:
   process (clk_i)
   begin
      if rising_edge(clk_i) then
         div_r <= '0';
         if rst_i='1' then
            cnt_r <= 0;
         elsif ena_i='1' then
            if cnt_r=DIV-1 then
               cnt_r <= 0;
               div_r <= '1';
            else
               cnt_r <= cnt_r+1;
            end if; -- else cnt_r=DIV-1
         end if; -- else rst_i='1'
      end if; -- rising_edge(clk_i)
   end process do_bt;
   div_o <= div_r;
end architecture RTL; -- Entity: SimpleDivider

architecture RTL2 of SimpleDivider is
   signal cnt_r : integer range 0 to DIV-1;
begin
   do_bt:
   process (clk_i)
   begin
      if rising_edge(clk_i) then
         if rst_i='1' then
            cnt_r <= 0;
         elsif ena_i='1' then
            if cnt_r=DIV-1 then
               cnt_r <= 0;
            else
               cnt_r <= cnt_r+1;
            end if; -- else cnt_r=DIV-1
         end if; -- else rst_i='1'
      end if; -- rising_edge(clk_i)
   end process do_bt;
   div_o <= '1' when cnt_r=DIV-1 else '0';
end architecture RTL2; -- Entity: SimpleDivider

