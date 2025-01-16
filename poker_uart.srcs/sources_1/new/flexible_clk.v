`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 09:43:05
// Design Name: 
// Module Name: flexible_clk
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


module flexible_clk(input basys_clk, input [31:0] m, output reg clk = 0);

    reg [31:0] counter = 0;
    always @ (posedge basys_clk) begin
        counter <= (counter == m) ? 0 : counter + 1;
        clk <= (counter == 0) ? ~clk : clk;
    end

endmodule