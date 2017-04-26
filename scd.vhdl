------------------------------------------------------------------------------
----                                                                      ----
----  Synchronizer Clock Domains with multiple channels                   ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  This core, that drive multiples channels, solves the communication  ----
----  between components working at different frequencies.                ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Rodrigo A. Melo, rmelo en inti gob ar                           ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2009 Rodrigo A. Melo <rmelo en inti gob ar>            ----
---- Copyright (c) 2009 Instituto Nacional de Tecnología Industrial       ----
----                                                                      ----
---- Distributed under the GPL v2 or newer license                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      SyncClkDomain(RTL_RAM)                             ----
---- File name:        scd.vhdl                                           ----
---- Note:             None                                               ----
---- Limitations:      None                                               ----
---- Errors:           None known                                         ----
---- Library:          utils                                              ----
---- Dependencies:     IEEE.std_logic_1164                                ----
----                   UTILS.STDLIB                                       ----
---- Target FPGA:      Any                                                ----
---- Language:         VHDL                                               ----
---- Wishbone:         None                                               ----
---- Synthesis tools:  N/A                                                ----
---- Simulation tools: GHDL [Sokcho edition] (0.2x)                       ----
---- Text editor:      SETEdit 0.5.x                                      ----
----                                                                      ----
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
library UTILS;
use UTILS.STDLIB.all;

entity SyncClkDomain is
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
end entity SyncClkDomain;

architecture RTL_RAM of SyncClkDomain is

begin

   make_channels:
   for i in 0 to CHANNELS-1 generate
       SCDB: SyncClkDomainBase
          generic map(INBYLV => INBYLV, FFCHAIN => FFCHAIN)
          port map(rst_i => rst_i, clkA_i => clkA_i , clkB_i => clkB_i,
                   a_i => a_i(i), b_o => b_o(i), ack_o => ack_o(i));
   end generate make_channels;

end architecture RTL_RAM; -- Entity: SyncClkDomain
