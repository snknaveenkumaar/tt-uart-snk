`timescale 1ns/1ps
`default_nettype none

module tb;

    reg [7:0] ui_in;
    wire [7:0] uo_out;

    reg [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    reg ena;
    reg clk;
    reg rst_n;

    // DUT
    tt_um_snk_pwm_uart dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz sim clock

    // Init
    initial begin
        ena = 1'b1;
        rst_n = 1'b0;
        ui_in = 8'b00000001; // RX idle high
        uio_in = 8'b0;

        #100;
        rst_n = 1'b1;

        #500000;
        $finish;
    end

    // Waveform
`ifdef FST
    initial begin
        $dumpfile("tb.fst");
        $dumpvars(0, tb);
    end
`else
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end
`endif

endmodule

`default_nettype wire
