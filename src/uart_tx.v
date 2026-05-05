`default_nettype none

module uart_tx (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data,
    input wire send,
    output reg tx,
    output reg busy
);

    parameter CLK_DIV = 434;

    reg [9:0] shift;
    reg [3:0] bit_cnt;
    reg [15:0] clk_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx      <= 1'b1;
            busy    <= 1'b0;
            shift   <= 10'h3FF;
            bit_cnt <= 4'd0;
            clk_cnt <= 16'd0;
        end else begin
            if (send && !busy) begin
                shift   <= {1'b1, data, 1'b0};
                busy    <= 1'b1;
                bit_cnt <= 4'd0;
                clk_cnt <= CLK_DIV;
            end else if (busy) begin
                if (clk_cnt == 0) begin
                    tx      <= shift[0];
                    shift   <= {1'b1, shift[9:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                    clk_cnt <= CLK_DIV;

                    if (bit_cnt == 4'd9)
                        busy <= 1'b0;
                end else begin
                    clk_cnt <= clk_cnt - 1'b1;
                end
            end
        end
    end

endmodule
