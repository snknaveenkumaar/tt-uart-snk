import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


CLK_DIV = 434


def set_rx(dut, level):
    value = int(dut.ui_in.value)
    if level:
        value |= 0x01
    else:
        value &= 0xFE
    dut.ui_in.value = value


async def reset_dut(dut):
    dut.ena.value = 1
    dut.uio_in.value = 0
    dut.ui_in.value = 0x01
    dut.rst_n.value = 0

    for _ in range(10):
        await ClockCycles(dut.clk, 1)

    dut.rst_n.value = 1
    for _ in range(10):
        await ClockCycles(dut.clk, 1)


async def uart_send_byte(dut, byte_val):
    set_rx(dut, 1)
    await ClockCycles(dut.clk, 2)

    set_rx(dut, 0)
    await ClockCycles(dut.clk, CLK_DIV)

    for i in range(8):
        set_rx(dut, (byte_val >> i) & 1)
        await ClockCycles(dut.clk, CLK_DIV)

    set_rx(dut, 1)
    await ClockCycles(dut.clk, CLK_DIV)


@cocotb.test()
async def test_basic(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)

    # enable
    dut.ui_in.value = 0x03

    # program PWM0 = 0
    await uart_send_byte(dut, 0x00)
    await uart_send_byte(dut, 0x00)

    for _ in range(20):
        await ClockCycles(dut.clk, 1)

    assert (int(dut.uo_out.value) & 0x01) == 0

    # program PWM1 = max
    await uart_send_byte(dut, 0x01)
    await uart_send_byte(dut, 0xFF)

    high_count = 0
    for _ in range(40):
        await ClockCycles(dut.clk, 1)
        if (int(dut.uo_out.value) >> 1) & 1:
            high_count += 1

    assert high_count > 30
