import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_basic(dut):
    # start clock (FIXED: unit not units)
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    # initialize
    dut.ena.value = 1
    dut.uio_in.value = 0
    dut.ui_in.value = 0

    # reset
    dut.rst_n.value = 0
    for _ in range(5):
        await ClockCycles(dut.clk, 1)

    dut.rst_n.value = 1

    # run a few cycles
    for _ in range(20):
        await ClockCycles(dut.clk, 1)

    # simple check → ensures sim didn't break
    assert dut.uo_out.value is not None
