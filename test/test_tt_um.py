import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_basic(dut):

    # reset
    dut.rst_n.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # enable
    dut.ui_in.value = 0b00000010

    for _ in range(200):
        await RisingEdge(dut.clk)

    assert dut.uo_out.value is not None
