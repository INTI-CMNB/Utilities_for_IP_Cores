------------------------------------------------------------------------------
----                                                                      ----
----  Testbench to SyncClkDomain component                                ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  A single testbench to test SyncClkDomain component                  ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Rodrigo A. Melo, rmelo en inti gob ar                           ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2009-2010 Rodrigo A. Melo <rmelo en inti gob ar>       ----
---- Copyright (c) 2009-2010 Instituto Nacional de Tecnología Industrial  ----
----                                                                      ----
---- Distributed under the GPL v2 or newer license                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      SCD_tb(Simul)                                      ----
---- File name:        scd_tb.vhdl                                        ----
---- Note:             None                                               ----
---- Limitations:      None                                               ----
---- Errors:           None known                                         ----
---- Library:          utils                                              ----
---- Dependencies:     IEEE.std_logic_1164                                ----
----                   UTILS.STDLIB                                       ----
----                   UTILS.STDIO                                        ----
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
library utils;
use utils.stdlib.all;
use utils.stdio.all;

entity SCD_tb is
end entity SCD_tb;

architecture Simul of SCD_tb is

   constant F_CLKA  : natural:=150; -- in MHz.
   constant F_CLKB  : natural:=100; -- in MHz.
   constant FFCHAIN : natural:=2;

   signal clka, clkb, rst : std_logic;
   signal endsimulation : std_logic:='0';

   signal ch1_a, ch2_a, ch3_a       : std_logic;
   signal ch1_b, ch2_b, ch3_b       : std_logic;
   signal ch1_ack, ch2_ack, ch3_ack : std_logic;

   procedure test_signal(signal s1  : in std_logic;
                         signal s2  : in std_logic;
                         signal clk : in std_logic) is
      variable i : natural;
   begin
      i:=0;
      while s1 = '0' and s2 = '0' loop
         assert i <= FFCHAIN report "More FF than the especified."
                             severity failure;
         wait until rising_edge(clk);
         i:=i+1;
      end loop;
      assert i-1 = FFCHAIN report "Less FF than the especified."
                           severity failure;
   end procedure test_signal;

--*****************************************************************************
begin
--*****************************************************************************

   gen_clkA : SimpleClock
      generic map(FREQUENCY => F_CLKA)
      port map(
         clk_o => clka, nclk_o => open, rst_o => rst, stop_i => endsimulation);

   gen_clkB : SimpleClock
      generic map(FREQUENCY => F_CLKB)
      port map(
         clk_o => clkb, nclk_o => open, rst_o => open, stop_i => endsimulation);

   levels: SyncClkDomain
      generic map(CHANNELS => 2)
      port map(rst_i => rst, clka_i => clka, clkb_i => clkb,
               a_i(0) => ch1_a, a_i(1) => ch2_a,
               b_o(0) => ch1_b, b_o(1) => ch2_b,
               ack_o(0) => ch1_ack, ack_o(1) => ch2_ack);

   pulses: SyncClkDomainBase
      generic map(INBYLV => 0)
      port map(rst_i => rst, clka_i => clka, clkb_i => clkb,
               a_i => ch3_a, b_o => ch3_b, ack_o => ch3_ack);

   test:
   process
      variable i : natural;
   begin
      ch1_a <= '0';
      ch2_a <= '0';
      ch3_a <= '0';
      OutWrite("### Testing SyncClkDomain ###");
      wait until rising_edge(clka) and rst='0';
      -------------------------------------------------------------------------
      OutWrite("** Testing Channel 1");
      ch1_a <= '1';
      OutWrite("- Testing b_o");
      test_signal(ch1_b, ch1_b, clkb);
      OutWrite("- Testing ack_o");
      test_signal(ch1_ack, ch1_ack, clka);
      -------------------------------------------------------------------------
      OutWrite("** Testing Channel 2");
      ch2_a <= '1';
      OutWrite("- Testing b_o");
      test_signal(ch2_b, ch2_b, clkb);
      OutWrite("- Testing ack_o");
      test_signal(ch2_ack, ch2_ack, clka);
      -------------------------------------------------------------------------
      OutWrite("** Testing Channel 1 + 2");
      ch1_a <= '0';
      ch2_a <= '0';
      OutWrite("- Testing b_o");
      test_signal(ch1_b, ch2_b, clkb);
      OutWrite("- Testing ack_o");
      test_signal(ch1_ack, ch2_ack, clka);
      -------------------------------------------------------------------------
      -- To see Wave Form
      ch3_a <= '1';
      wait until rising_edge(clka);
      ch3_a <= '0';
      wait until rising_edge(clka);
      wait until rising_edge(clka);
      ch3_a <= '1';
      wait until rising_edge(clka);
      ch3_a <= '0';
      wait for 50 ms;
      -------------------------------------------------------------------------
      OutWrite("### SyncClkDomain Works fine ###");
      endsimulation <= '1';
      wait;
   end process test;

end architecture Simul;
