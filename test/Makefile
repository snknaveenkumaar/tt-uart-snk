SIM           ?= icarus
TOPLEVEL_LANG ?= verilog

# Top module must match info.yaml
TOPLEVEL = tt_um_snk_pwm_uart

# Python test file name (test_tt_um.py)
MODULE = test_tt_um

COCOTB_RESULTS_FILE = results.xml
COCOTB_HDL_TIMEUNIT      = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps

# ── RTL Simulation ────────────────────────────────────────────────
VERILOG_SOURCES  = $(PWD)/../src/uart_rx.v
VERILOG_SOURCES += $(PWD)/../src/uart_tx.v
VERILOG_SOURCES += $(PWD)/../src/pwm_gen.v
VERILOG_SOURCES += $(PWD)/../src/tt_um_snk_pwm_uart.v

# Optional: keep tb.v if present (safe)
VERILOG_SOURCES += $(PWD)/tb.v

COMPILE_ARGS += -g2012

# ── Gate-Level Simulation (Tiny Tapeout CI uses this) ─────────────
ifeq ($(GATES),yes)

COMPILE_ARGS += -DFUNCTIONAL
COMPILE_ARGS += -DSIM
COMPILE_ARGS += -DUNIT_DELAY=\#1
COMPILE_ARGS += -DUSE_POWER_PINS

VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
VERILOG_SOURCES += gate_level_netlist.v

export GL_TEST = 1

endif

include $(shell cocotb-config --makefiles)/Makefile.sim
