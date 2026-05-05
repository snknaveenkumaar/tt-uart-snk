`default_nettype none

module tt_um_snk_pwm_uart (
    input  wire clk,
    input  wire rst_n,

    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    inout  wire [7:0] uio
);

    // ---- INPUTS ----
    wire rx     = ui_in[0];
    wire enable = ui_in[1];

    // ---- UNUSED INPUTS SAFE ----
    wire _unused_ok = &{ui_in[7:2]};

    // ---- UART RX ----
    wire [7:0] rx_data;
    wire rx_valid;

    uart_rx u_rx (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .data(rx_data),
        .valid(rx_valid)
    );

    // ---- DUTY REGISTERS ----
    reg [7:0] d0, d1, d2, d3, d4, d5, d6;

    reg state;
    reg [2:0] channel;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= 1'b0;
            channel <= 3'd0;
            d0 <= 0; d1 <= 0; d2 <= 0; d3 <= 0;
            d4 <= 0; d5 <= 0; d6 <= 0;
        end else if (enable && rx_valid) begin
            if (!state) begin
                channel <= rx_data[2:0];
                state   <= 1'b1;
            end else begin
                case (channel)
                    3'd0: d0 <= rx_data;
                    3'd1: d1 <= rx_data;
                    3'd2: d2 <= rx_data;
                    3'd3: d3 <= rx_data;
                    3'd4: d4 <= rx_data;
                    3'd5: d5 <= rx_data;
                    3'd6: d6 <= rx_data;
                    default: ;
                endcase
                state <= 1'b0;
            end
        end
    end

    // ---- PWM ----
    wire [6:0] pwm;

    pwm_gen u_pwm (
        .clk(clk),
        .rst_n(rst_n),
        .d0(d0), .d1(d1), .d2(d2),
        .d3(d3), .d4(d4), .d5(d5), .d6(d6),
        .pwm_out(pwm)
    );

    assign uo_out[6:0] = pwm;

    // ---- UART TX (ACK) ----
    wire tx;
    wire tx_busy;

    uart_tx u_tx (
        .clk(clk),
        .rst_n(rst_n),
        .data(8'hAA),
        .send(rx_valid && enable),
        .tx(tx),
        .busy(tx_busy)
    );

    assign uo_out[7] = tx;

    // ---- UNUSED IO ----
    assign uio = 8'b00000000;

endmodule
