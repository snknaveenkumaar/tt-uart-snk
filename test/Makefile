TOPLEVEL_LANG = verilog

VERILOG_SOURCES = \
    $(PWD)/../src/uart_rx.v \
    $(PWD)/../src/uart_tx.v \
    $(PWD)/../src/pwm_gen.v \
    $(PWD)/../src/tt_um_snk_pwm_uart.v

TOPLEVEL = tt_um_snk_pwm_uart
MODULE = test_tt_um

SIM ?= iverilog

include $(shell cocotb-config --makefiles)/Makefile.sim
