`default_nettype none

module uart_rx (
    input  wire clk,
    input  wire rst_n,
    input  wire rx,
    output reg [7:0] data,
    output reg valid
);

    parameter CLK_DIV = 434;

    reg [9:0] shift;
    reg [3:0] bit_cnt;
    reg [15:0] clk_cnt;
    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy    <= 1'b0;
            valid   <= 1'b0;
            clk_cnt <= 16'd0;
            bit_cnt <= 4'd0;
            shift   <= 10'd0;
            data    <= 8'd0;
        end else begin
            valid <= 1'b0;

            if (!busy && rx == 1'b0) begin
                busy    <= 1'b1;
                clk_cnt <= CLK_DIV >> 1;
                bit_cnt <= 4'd0;
            end else if (busy) begin
                if (clk_cnt == 0) begin
                    clk_cnt <= CLK_DIV;
                    shift   <= {rx, shift[9:1]};
                    bit_cnt <= bit_cnt + 1'b1;

                    if (bit_cnt == 4'd9) begin
                        busy  <= 1'b0;
                        data  <= shift[8:1];
                        valid <= 1'b1;
                    end
                end else begin
                    clk_cnt <= clk_cnt - 1'b1;
                end
            end
        end
    end

endmodule
