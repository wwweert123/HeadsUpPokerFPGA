`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 16:03:39
// Design Name: 
// Module Name: card_number
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


module card_number(
    input clk,
    input [3:0] number,
    input [31:0] origin_x,
    input [31:0] origin_y,
    input [31:0] x,
    input [31:0] y,
    output reg [15:0] oled_data);
    
    parameter ACE = 4'b0001;
    parameter TWO = 4'b0010;
    parameter THREE = 4'b0011;
    parameter FOUR = 4'b0100;
    parameter FIVE = 4'b0101;
    parameter SIX = 4'b0110;
    parameter SEVEN = 4'b0111;
    parameter EIGHT = 4'b1000;
    parameter NINE = 4'b1001;
    parameter TEN = 4'b1010;
    parameter JACK = 4'b1011;
    parameter QUEEN = 4'b1100;
    parameter KING = 4'b1101;
    
    always @ (posedge clk) begin
        if (number == ACE) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((x >= origin_x + 5) && (x <= origin_x + 6) && (y >= origin_y + 5) && (y <= origin_y + 12)) || ((x >= origin_x + 11) && (x <= origin_x + 12) && (y >= origin_y + 5) && (y <= origin_y + 12)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 7) && (x <= origin_x + 10)) || (y >= origin_y + 7) && (y <= origin_y + 8) && (x >= origin_x + 7) && (x <= origin_x + 10)) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == TWO) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 7) && (y <= origin_y + 8) && (x >= origin_x + 9) && (x <= origin_x + 10)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 7) && (x <= origin_x + 8)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 5) && (x <= origin_x + 12))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == THREE) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 7) && (y <= origin_y + 8) && (x >= origin_x + 9) && (x <= origin_x + 10)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 7) && (x <= origin_x + 10))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == FOUR) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 7) && (y <= origin_y + 10) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 7) && (x <= origin_x + 8)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 7) && (x <= origin_x + 8)) || ((y >= origin_y + 3) && (y <= origin_y + 12) && (x >= origin_x + 9) && (x <= origin_x + 10)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 11) && (x <= origin_x + 12))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == FIVE) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 5) && (x <= origin_x + 12)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 7) && (y <= origin_y + 8) && (x >= origin_x + 5) && (x <= origin_x + 10)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 5) && (x <= origin_x + 10))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == SIX) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 7) && (y <= origin_y + 8) && (x >= origin_x + 5) && (x <= origin_x + 10)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 7) && (x <= origin_x + 10))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == SEVEN) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 5) && (x <= origin_x + 10)) || ((y >= origin_y + 5) && (y <= origin_y + 8) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 9) && (y <= origin_y + 12) && (x >= origin_x + 9) && (x <= origin_x + 10))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == EIGHT) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 7) && (y <= origin_y + 8) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 7) && (x <= origin_x + 10))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == NINE) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 7) && (y <= origin_y + 8) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 9) && (x <= origin_x + 10)) || ((y >= origin_y + 5) && (y <= origin_y + 10) && (x >= origin_x + 11) && (x <= origin_x + 12))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == TEN) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 2) && (x <= origin_x + 3)) || ((y >= origin_y + 3) && (y <= origin_y + 10) && (x >= origin_x + 4) && (x <= origin_x + 5)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 2) && (x <= origin_x + 7)) || ((y >= origin_y + 5) && (y <= origin_y + 10) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 10) && (x <= origin_x + 13)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 10) && (x <= origin_x + 13)) || ((y >= origin_y + 5) && (y <= origin_y + 10) && (x >= origin_x + 14) && (x <= origin_x + 15))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == JACK) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 3) && (y <= origin_y + 10) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 7) && (x <= origin_x + 10))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == QUEEN) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 5) && (y <= origin_y + 10) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 7) && (x <= origin_x + 10)) || ((y >= origin_y + 5) && (y <= origin_y + 8) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 9) && (x <= origin_x + 10)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 7) && (x <= origin_x + 8))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else if (number == KING) begin
            if (((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 16)) || ((x == origin_x) && (y >= origin_y) && (y <= origin_y + 14)) || ((x == origin_x + 17) && (y >= origin_y) && (y <= origin_y + 14)) || ((y >= origin_y + 3) && (y <= origin_y + 12) && (x >= origin_x + 5) && (x <= origin_x + 6)) || ((y >= origin_y + 7) && (y <= origin_y + 8) && (x >= origin_x + 7) && (x <= origin_x + 8)) || ((y >= origin_y + 9) && (y <= origin_y + 10) && (x >= origin_x + 9) && (x <= origin_x + 10)) || ((y >= origin_y + 11) && (y <= origin_y + 12) && (x >= origin_x + 11) && (x <= origin_x + 12)) || ((y >= origin_y + 5) && (y <= origin_y + 6) && (x >= origin_x + 9) && (x <= origin_x + 10)) || ((y >= origin_y + 3) && (y <= origin_y + 4) && (x >= origin_x + 11) && (x <= origin_x + 12))) oled_data = 0;
            else oled_data = 16'b1111111111111111;
        end else oled_data = 16'b00000_101000_00000;
    end
    
endmodule
