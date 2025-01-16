`timescale 1ns / 1ps

module numgen(
    input wire clk,
    input wire start,
    input wire reset,
    input wire [3:0] seed,
    output reg [3:0] out = 1
);

reg enable = 0; // Enable signal for controlling LFSR stepping
wire feedback = out[3] ^ out[2] ^ seed[1] ^ seed[0];

always @(posedge clk or posedge reset) begin
    if (reset)
        enable <= 0;
    else if (start)
        enable <= 1;
    else
        enable <= 0;
end

always @(posedge clk) begin
    if (reset) begin
        out <= seed;
    end else if (enable) begin
        if ({out[2:0], feedback} > 13)
        begin
            out <= {out[2:0], feedback} - 2;
        end
        else
        begin
            out <= {out[2:0], feedback};
        end
    end
end

endmodule