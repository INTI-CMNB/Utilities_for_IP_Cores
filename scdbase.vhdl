------------------------------------------------------------------------------
----                                                                      ----
----  Synchronizer Clock Domains with a single channel                    ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  This core solves the communication between components working at    ----
----  different frequencies.                                              ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Rodrigo A. Melo, rmelo en inti gob ar                           ----
----    - Salvador E. Tropea, salvador en inti gob ar                     ----
----    - Based in a Gaisler's mechanism used in the GRLib IP library     ----
----      http://www.gaisler.com/                                         ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2009-2010 Rodrigo A. Melo <rmelo en inti gob ar>       ----
---- Copyright (c) 2009 Instituto Nacional de Tecnología Industrial       ----
----                                                                      ----
---- Distributed under the GPL v2 or newer license                        ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      SyncClkDomainBase(RTL_RAM)                         ----
---- File name:        scdbase.vhdl                                       ----
---- Note:             None                                               ----
---- Limitations:      None                                               ----
---- Errors:           None known                                         ----
---- Library:          utils                                              ----
---- Dependencies:     IEEE.std_logic_1164                                ----
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

entity SyncClkDomainBase is
   generic(
      INBYLV  : integer range 0 to 1 := 1;  -- Input By Level
      FFCHAIN : natural              := 2); -- Flip Flop Chain
   port(
      rst_i  : in  std_logic;
      clka_i : in  std_logic;
      clkb_i : in  std_logic;
      a_i    : in  std_logic;
      b_o    : out std_logic;
      ack_o  : out std_logic);
end entity SyncClkDomainBase;

architecture RTL_RAM of SyncClkDomainBase is

   signal a          : std_logic:='0';
   signal acka, ackb : std_logic_vector(FFCHAIN downto 0):=(others => '0');

begin

   in_by_level:
   if INBYLV = 1 generate
      a <= a_i;
   end generate in_by_level;

   in_no_level:
   if INBYLV = 0 generate
      sideA_in:
      process (clka_i)
      begin
         if rising_edge(clka_i) then
            if rst_i = '1' then
               a <= '0';
            else
               if a_i = '1' then
                  a <= not(a);
               end if;
            end if;
         end if;
      end process sideA_in;
   end generate in_no_level;

   sideB:
   process (clkb_i)
   begin
      if rising_edge(clkb_i) then
         if rst_i = '1' then
            ackb <= (others => '0');
         else
            ackb(0) <= a;
            if FFCHAIN > 0 then
               for i in 0 to FFCHAIN-1 loop
                   ackb(i+1) <= ackb(i);
               end loop;
            end if;
         end if;
      end if;
   end process sideB;

   sideA:
   process (clka_i)
   begin
      if rising_edge(clka_i) then
         if rst_i = '1' then
            acka <= (others => '0');
         else
            acka(0) <= ackb(FFCHAIN);
            if FFCHAIN > 0 then
               for i in 0 to FFCHAIN-1 loop
                   acka(i+1) <= acka(i);
               end loop;
            end if;
         end if;
      end if;
   end process sideA;

   WITHOUT_FF:
   if FFCHAIN = 0 generate
      b_o   <= a xor ackb(0);
      ack_o <= ackb(0) xor acka(0);
   end generate WITHOUT_FF;

   WITH_FF:
   if FFCHAIN /= 0 generate
      b_o   <= ackb(FFCHAIN-1) xor ackb(FFCHAIN);
      ack_o <= acka(FFCHAIN-1) xor acka(FFCHAIN);
   end generate WITH_FF;

end architecture RTL_RAM; -- Entity: SyncClkDomainBase

