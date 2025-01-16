`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2024 11:26:17
// Design Name: 
// Module Name: suitgen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module suitgen(
    input wire clk,
    input wire start,
    input wire reset,
    input wire [1:0] seed,
    output reg [1:0] out = 1
);

reg enable = 0;
wire feedback = out[1] ^ out[0] ^ seed[1] ^ seed[0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        enable <= 0;
    end else if (start) begin
        enable <= 1;
    end else begin
        enable <= 0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        out <= seed;
    end else if (enable) begin
        out <= {out[0], feedback};
    end
end

endmodule