import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


CLK_DIV = 434  # must match RTL


async def reset_dut(dut):
    dut.ui_in.value = 0
    dut.rst_n.value = 0
    for _ in range(10):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    for _ in range(10):
        await RisingEdge(dut.clk)


async def uart_send_byte(dut, byte_val):
    # idle high already assumed on RX
    # start bit
    dut.ui_in.value = (int(dut.ui_in.value) | 0x00) & 0xFE
    for _ in range(CLK_DIV):
        await RisingEdge(dut.clk)

    # data bits, LSB first
    for i in range(8):
        bit = (byte_val >> i) & 1
        if bit:
            dut.ui_in.value = int(dut.ui_in.value) | 0x01
        else:
            dut.ui_in.value = int(dut.ui_in.value) & 0xFE
        for _ in range(CLK_DIV):
            await RisingEdge(dut.clk)

    # stop bit
    dut.ui_in.value = int(dut.ui_in.value) | 0x01
    for _ in range(CLK_DIV):
        await RisingEdge(dut.clk)


@cocotb.test()
async def test_reset_state(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)

    # After reset, PWM outputs should be low and UART TX should idle high
    out_val = int(dut.uo_out.value)
    assert out_val == 0x80, f"Expected 0x80 after reset, got 0x{out_val:02X}"


@cocotb.test()
async def test_uart_program_pwm(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset_dut(dut)

    # Enable operation
    dut.ui_in.value = 0x02  # ui_in[1] = enable, rx idles high on bit0

    # Program channel 0 to 0x00
    await uart_send_byte(dut, 0x00)
    await uart_send_byte(dut, 0x00)

    for _ in range(20):
        await RisingEdge(dut.clk)

    out_val = int(dut.uo_out.value)
    assert (out_val & 0x01) == 0, "PWM0 should be low for 0x00 duty"

    # Program channel 1 to 0xFF
    await uart_send_byte(dut, 0x01)
    await uart_send_byte(dut, 0xFF)

    high_count = 0
    for _ in range(40):
        await RisingEdge(dut.clk)
        out_val = int(dut.uo_out.value)
        if (out_val >> 1) & 1:
            high_count += 1

    assert high_count > 30, "PWM1 should be mostly high for 0xFF duty"
