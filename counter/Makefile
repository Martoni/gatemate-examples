include config.mk

PRFLAGS +=-ccf src/blink.ccf
TOP = top

VHDLDIR=src

VLOG_SRC = src/$(TOP).v

mrproper:
	rm -f $(TOP).json $(TOP).asc $(VERILOGDIR)/$(TOP).v
