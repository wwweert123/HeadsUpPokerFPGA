`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 21:28:57
// Design Name: 
// Module Name: blind
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


module blind(
    input clk,
    input blind,
    input [31:0] origin_x,
    input [31:0] origin_y,
    input [31:0] x,
    input [31:0] y,
    output reg [15:0] oled_data);
    
    parameter SMALL_BLIND = 0;
    parameter BIG_BLIND = 1;
    
    always @ (posedge clk) begin
        if (blind == SMALL_BLIND) begin
            if (((y == origin_y) && (x >= origin_x) && (x <= origin_x + 2)) || ((y == origin_y) && (x >= origin_x + 6) && (x <= origin_x + 8)) || ((x == origin_x) && (y >= origin_y + 1) && (y <= origin_y + 2)) || ((x == origin_x + 8) && (y >= origin_y + 1) && (y <= origin_y + 2)) || ((y == origin_y + 8) && (x >= origin_x) && (x <= origin_x + 2)) || ((y == origin_y + 8) && (x >= origin_x + 6) && (x <= origin_x + 8)) || ((x == origin_x) && (y >= origin_y + 6) && (y <= origin_y + 7)) || ((x == origin_x + 8) && (y >= origin_y + 6) && (y <= origin_y + 7))) oled_data = 16'b00000_101000_00000;
            else if (((x == origin_x) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 1) && (y >= origin_y + 1) && (y <= origin_y + 2)) || ((x == origin_x + 2) && (y == origin_y + 1)) || ((x >= origin_x + 3) && (x <= origin_x + 5) && (y == origin_y)) || ((x == origin_x + 6) && (y == origin_y + 1)) || ((x == origin_x + 7) && (y >= origin_y + 1) && (y <= origin_y + 2)) || ((x == origin_x + 8) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((y == origin_y + 8) && (x >= origin_x + 3) && (x <= origin_x + 5)) || ((y == origin_y + 7) && (((x >= origin_x + 1) && (x <= origin_x + 2)) || ((x >= origin_x + 6) && (x <= origin_x + 7)))) || ((x == origin_x + 1) && (y == origin_y + 6)) || ((x == origin_x + 7) && (y == origin_y + 6)) || ((y == origin_y + 2) && (x >= origin_x + 4) && (x <= origin_x + 5)) || ((y == origin_y + 3) && (x == origin_x + 3)) || ((y == origin_y + 4) && (x == origin_x + 4)) || ((y == origin_y + 5) && (x == origin_x + 5)) || ((y == origin_y + 6) && (x >= origin_x + 3) && (x <= origin_x + 4))) oled_data = 0;
            else oled_data = 16'b01010_111001_11111;
        end else if (blind == BIG_BLIND) begin
            if (((y == origin_y) && (x >= origin_x) && (x <= origin_x + 2)) || ((y == origin_y) && (x >= origin_x + 6) && (x <= origin_x + 8)) || ((x == origin_x) && (y >= origin_y + 1) && (y <= origin_y + 2)) || ((x == origin_x + 8) && (y >= origin_y + 1) && (y <= origin_y + 2)) || ((y == origin_y + 8) && (x >= origin_x) && (x <= origin_x + 2)) || ((y == origin_y + 8) && (x >= origin_x + 6) && (x <= origin_x + 8)) || ((x == origin_x) && (y >= origin_y + 6) && (y <= origin_y + 7)) || ((x == origin_x + 8) && (y >= origin_y + 6) && (y <= origin_y + 7))) oled_data = 16'b00000_101000_00000;
            else if (((x == origin_x) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 1) && (y >= origin_y + 1) && (y <= origin_y + 2)) || ((x == origin_x + 2) && (y == origin_y + 1)) || ((x >= origin_x + 3) && (x <= origin_x + 5) && (y == origin_y)) || ((x == origin_x + 6) && (y == origin_y + 1)) || ((x == origin_x + 7) && (y >= origin_y + 1) && (y <= origin_y + 2)) || ((x == origin_x + 8) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((y == origin_y + 8) && (x >= origin_x + 3) && (x <= origin_x + 5)) || ((y == origin_y + 7) && (((x >= origin_x + 1) && (x <= origin_x + 2)) || ((x >= origin_x + 6) && (x <= origin_x + 7)))) || ((x == origin_x + 1) && (y == origin_y + 6)) || ((x == origin_x + 7) && (y == origin_y + 6)) || ((x == origin_x + 3) && (y >= origin_y +2) && (y <= origin_y + 6)) || ((y == origin_y + 2) && (x == origin_x + 4)) || ((y == origin_y + 4) && (x == origin_x + 4)) || ((y == origin_y + 6) && (x == origin_x + 4)) || ((y == origin_y + 3) && (x == origin_x + 5)) || ((y == origin_y + 5) && (x == origin_x + 5))) oled_data = 0;
            else oled_data = 16'b11110_111101_10000;
        end else oled_data = 16'b00000_101000_00000;
    end

endmodule
