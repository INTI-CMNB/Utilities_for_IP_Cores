#!/usr/bin/make
##############################################################################
#
#  Utils [Makefile]
#
#  This file is part FPGA Libre project http://fpgalibre.sf.net/
#
#  Description:
#  That's a GNU Make's Makefile used generate the utils library using ghdl.
#  To create the library just use "make".
#
#  To Do:
#  -
#
#  Author:
#    - Salvador E. Tropea, salvador@inti.gov.ar
#
##############################################################################
#
#  Copyright (c) 2007-2009 Salvador E. Tropea <salvador@inti.gov.ar>
#  Copyright (c) 2007-2009 Instituto Nacional de Tecnología Industrial
#
#  Distributed under the GPL v2 or newer license
#
##############################################################################

WORK=utils
LIBMODULES=stdlib_pkg str_pkg stdio_pkg delay simple_clock simple_div \
scdbase scd debounce math_pkg
#LIBS=../mems/

OBJDIR=Work
GHDL=ghdl
#LIBS_I=$(addsuffix Work,$(addprefix -P,$(LIBS)))
GHDLFLAGS=--work=$(WORK) --workdir=$(OBJDIR) $(LIBS_I)
LIBMODULES_O=$(addsuffix .o,$(LIBMODULES))
LIBMODULES_VHDL=$(addsuffix .vhdl,$(LIBMODULES))

vpath %.o $(OBJDIR)

all: $(OBJDIR) $(LIBMODULES_O)

%.o: %.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

stdio_pkg.o: str_pkg.o

%.o: testbench/%.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

$(OBJDIR)/%: %.o
	ghdl -e $(GHDLFLAGS) -o $@ $(@F)

$(OBJDIR):
	mkdir $(OBJDIR)

scd_tb.o: testbench/scd_tb.vhdl all

test: $(OBJDIR)/scd_tb
	$< --ieee-asserts=disable-at-0 --wave=$(OBJDIR)/scd.ghw

clean:
	-rm -fr $(OBJDIR)
	-rm -f *.bkp testbench/*.bkp
