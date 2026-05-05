SIM           ?= icarus
TOPLEVEL_LANG ?= verilog

TOPLEVEL = tt_um_snk_pwm_uart
MODULE   = test_tt_um

COCOTB_RESULTS_FILE = results.xml
COCOTB_HDL_TIMEUNIT      = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps

VERILOG_SOURCES  = $(PWD)/../src/uart_rx.v
VERILOG_SOURCES += $(PWD)/../src/uart_tx.v
VERILOG_SOURCES += $(PWD)/../src/pwm_gen.v
VERILOG_SOURCES += $(PWD)/../src/tt_um_snk_pwm_uart.v

COMPILE_ARGS += -g2012

include $(shell cocotb-config --makefiles)/Makefile.sim
