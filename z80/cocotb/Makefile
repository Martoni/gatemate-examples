# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# Makefile

# defaults
SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl
VHDL_SOURCES += $(PWD)/../src/top.vhd \
				$(PWD)/../lib/t80/T80.vhd \
				$(PWD)/../lib/t80/T80_ALU.vhd \
				$(PWD)/../lib/t80/T80_MCode.vhd \
				$(PWD)/../lib/t80/T80_Reg.vhd \
				$(PWD)/../lib/t80/T80pa.vhd \
				$(PWD)/../lib/t80/T80s.vhd \
				$(PWD)/../src/clock_divider.vhd \
				$(PWD)/../src/reset_gen.vhd \
				$(PWD)/../src/single_port_ram.vhd \
				$(PWD)/../src/single_port_rom.vhd

COMPILE_ARGS=--std=08 --ieee=synopsys -fexplicit
RUN_ARGS=$(COMPILE_ARGS)
EXTRA_ARGS=$(COMPILE_ARGS)
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = top 

# MODULE is the basename of the Python test file
MODULE = test_top

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
