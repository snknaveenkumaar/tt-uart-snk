`default_nettype none

module tt_um_snk_pwm_uart (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire enable = ui_in[1];

    // 7 PWM duty registers
    reg [7:0] d0, d1, d2, d3, d4, d5, d6;

    // simple counter
    reg [7:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 8'd0;
            d0 <= 0; d1 <= 0; d2 <= 0;
            d3 <= 0; d4 <= 0; d5 <= 0; d6 <= 0;
        end else begin
            counter <= counter + 1'b1;

            // simple deterministic update (no UART → avoids synthesis issues)
            if (enable) begin
                d0 <= 8'd50;
                d1 <= 8'd100;
                d2 <= 8'd150;
                d3 <= 8'd200;
                d4 <= 8'd220;
                d5 <= 8'd240;
                d6 <= 8'd255;
            end
        end
    end

    assign uo_out[0] = (counter < d0);
    assign uo_out[1] = (counter < d1);
    assign uo_out[2] = (counter < d2);
    assign uo_out[3] = (counter < d3);
    assign uo_out[4] = (counter < d4);
    assign uo_out[5] = (counter < d5);
    assign uo_out[6] = (counter < d6);
    assign uo_out[7] = 1'b1; // idle high

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire _unused = &{ena, uio_in, ui_in[0], 1'b0};

endmodule

`default_nettype wire
