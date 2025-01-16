`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2024 11:53:08
// Design Name: 
// Module Name: CircularCounter
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

module CircularCounter(
    input wire clk,      // Clock input
    input wire reset,    // Asynchronous reset input
    output reg [7:0] count = 1  // 5-bit counter to cover range from 1 to 13, initialized to 1
);
always @(posedge clk) begin
    if (reset) begin
        count <= 1;  // Reset counter to 1
    end else if (count == 13) begin
        count <= 1;  // Wrap back to 1 when counter reaches 13
    end else begin
        count <= count + 1;  // Increment counter
    end
end

endmodule
