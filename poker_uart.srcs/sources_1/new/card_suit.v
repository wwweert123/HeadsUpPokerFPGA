`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 19:06:01
// Design Name: 
// Module Name: card_suit
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


module card_suit(
    input clk,
    input [2:0] suit,
    input [31:0] origin_x,
    input [31:0] origin_y,
    input [31:0] x,
    input [31:0] y,
    output reg [15:0] oled_data);
    
    parameter DIAMOND = 3'b100;
    parameter CLUBS = 3'b101;
    parameter HEARTS = 3'b110;
    parameter SPADES = 3'b111;
    
    always @ (posedge clk) begin
        if (suit == DIAMOND) begin
            if (((y == origin_y + 14) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y == origin_y + 3) && (x == origin_x + 10)) || ((y == origin_y + 4) && (x == origin_x + 11)) || ((y == origin_y + 5) && (x == origin_x + 12)) || ((y == origin_y + 8) && (x == origin_x + 12)) || ((y == origin_y + 9) && (x == origin_x + 11)) || ((y == origin_y + 10) && (x == origin_x + 10)) || ((y == origin_y + 10) && (x == origin_x + 7)) || ((y == origin_y + 9) && (x == origin_x + 6)) || ((y == origin_y + 8) && (x == origin_x + 5)) || ((y == origin_y + 5) && (x == origin_x + 5)) || ((y == origin_y + 4) && (x == origin_x + 6)) || ((y == origin_y + 3) && (x == origin_x + 7)) || ((y == origin_y + 2) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y == origin_y + 11) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y >= origin_y + 6) && (y <= origin_y + 7) && (x == origin_x + 4)) || ((y >= origin_y + 6) && (y <= origin_y + 7) && (x == origin_x + 13))) oled_data = 0;
            else if (((y == origin_y + 3) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y == origin_y + 4) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y == origin_y + 5) && (x >= origin_x + 6) && (x <= origin_x + 11)) || ((y >= origin_y + 6) && (y <= origin_y + 7) && (x >= origin_x + 5) && (x <= origin_x + 12)) || ((y == origin_y + 8) && (x >= origin_x + 6) && (x <= origin_x + 11)) || ((y == origin_y + 9) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y == origin_y + 10) && (x >= origin_x + 8) && (x <= origin_x + 9))) oled_data = 16'b1111100000000000;
            else oled_data = 16'b1111111111111111;
        end else if (suit == CLUBS) begin
            if (((y == origin_y + 14) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y == origin_y + 2) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y >= origin_y + 3) && (y <= origin_y + 5) && (x >= origin_x + 6) && (x <= origin_x + 11)) || ((y == origin_y + 6) && (x >= origin_x + 4) && (x <= origin_x + 5)) || ((y == origin_y + 6) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y == origin_y + 6) && (x >= origin_x + 12) && (x <= origin_x + 13)) ||  ((y >= origin_y + 7) && (y <= origin_y + 9) && (x >= origin_x + 3) && (x <= origin_x + 14)) || ((y == origin_y + 10) && (x >= origin_x + 4) && (x <= origin_x + 6)) || ((y == origin_y + 10) && (x >= origin_x + 11) && (x <= origin_x + 13)) || ((y == origin_y + 10) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y == origin_y + 11) && (x >= origin_x + 7) && (x <= origin_x + 10))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (suit == HEARTS) begin
            if (((y == origin_y + 14) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 4) && (y <= origin_y + 6) && (x == origin_x + 3)) || ((y == origin_y + 3) && (x == origin_x + 4)) || ((y == origin_y + 7) && (x == origin_x + 4)) || ((y == origin_y + 8) && (x == origin_x + 5)) || ((y == origin_y + 9) && (x == origin_x + 6)) || ((y == origin_y + 10) && (x == origin_x + 7)) || ((y == origin_y + 3) && (x == origin_x + 7)) || ((y == origin_y + 3) && (x == origin_x + 10)) || ((y == origin_y + 3) && (x == origin_x + 13)) || ((y == origin_y + 10) && (x == origin_x + 10)) || ((y == origin_y + 9) && (x == origin_x + 11)) || ((y == origin_y + 8) && (x == origin_x + 12)) || ((y == origin_y + 7) && (x == origin_x + 13)) || ((y >= origin_y + 4) && (y <= origin_y + 6) && (x == origin_x + 14)) || ((y == origin_y + 4) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y == origin_y + 11) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y == origin_y + 2) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y == origin_y + 2) && (x >= origin_x + 11) && (x <= origin_x + 12))) oled_data = 0;
            else if (((y == origin_y + 3) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y == origin_y + 3) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y == origin_y + 4) && (x >= origin_x + 4) && (x <= origin_x + 7)) || ((y == origin_y + 4) && (x >= origin_x + 10) && (x <= origin_x + 13)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 4) && (x <= origin_x + 13)) || ((y == origin_y + 7) && (x >= origin_x + 5) && (x <= origin_x + 12)) || ((y == origin_y + 8) && (x >= origin_x + 6) && (x <= origin_x + 11)) || ((y == origin_y + 9) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y == origin_y + 10) && (x >= origin_x + 8) && (x <= origin_x + 9))) oled_data = 16'b1111100000000000;
            else oled_data = 16'b1111111111111111;
        end else if (suit == SPADES) begin
            if (((y == origin_y + 14) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y == origin_y + 2) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y == origin_y + 3) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y == origin_y + 4) && (x >= origin_x + 6) && (x <= origin_x + 11)) || ((y == origin_y + 5) && (x >= origin_x + 5) && (x <= origin_x + 12)) || ((y == origin_y + 6) && (x >= origin_x + 4) && (x <= origin_x + 13) || ((y >= origin_y + 7) && (y <= origin_y + 9) && (x >= origin_x + 3) && (x <= origin_x + 14)) || ((y == origin_y + 10) && (x >= origin_x + 4) && (x <= origin_x + 6)) || ((y == origin_y + 10) && (x >= origin_x + 11) && (x <= origin_x + 13)) || ((y == origin_y + 10) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y == origin_y + 11) && (x >= origin_x + 7) && (x <= origin_x + 10)))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else oled_data = 16'b00000_101000_00000;
    end
    
endmodule
