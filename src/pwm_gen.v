`default_nettype none

module pwm_gen (
    input wire clk,
    input wire rst_n,
    input wire [7:0] d0,
    input wire [7:0] d1,
    input wire [7:0] d2,
    input wire [7:0] d3,
    input wire [7:0] d4,
    input wire [7:0] d5,
    input wire [7:0] d6,
    output wire [6:0] pwm_out
);

    reg [7:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 8'd0;
        else
            counter <= counter + 1'b1;
    end

    assign pwm_out[0] = (counter < d0);
    assign pwm_out[1] = (counter < d1);
    assign pwm_out[2] = (counter < d2);
    assign pwm_out[3] = (counter < d3);
    assign pwm_out[4] = (counter < d4);
    assign pwm_out[5] = (counter < d5);
    assign pwm_out[6] = (counter < d6);

endmodule
