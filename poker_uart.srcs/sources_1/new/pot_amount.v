`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 22:30:33
// Design Name: 
// Module Name: pot_amount
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


module pot_amount(
    input clk,
    input [31:0] amount,
    input [31:0] origin_x,
    input [31:0] origin_y,
    input [31:0] x,
    input [31:0] y,
    output reg [15:0] oled_data = 0);
    
    wire [3:0] first_digit;
    wire [3:0] second_digit;
    wire [3:0] third_digit;
    wire [3:0] fourth_digit;
    
    assign first_digit = amount / 1000;
    assign second_digit = (amount % 1000) / 100;
    assign third_digit = (amount % 100) / 10;
    assign fourth_digit = amount % 10;
    
    always @ (posedge clk) begin
        if (((x == origin_x) && (y >= origin_y) && (y <= origin_y + 8)) || ((x == origin_x + 45) && (y >= origin_y) && (y <= origin_y + 8)) || ((y == origin_y) && (x >= origin_x + 1) && (x <= origin_x + 44)) || ((y == origin_y + 8) && (x >= origin_x + 1) && (x <= origin_x + 44)) || ((x == origin_x + 2) && (y >= origin_y + 2) && (y <= origin_y + 6)) || ((y == origin_y + 2) && (x >= origin_x + 3) && (x <= origin_x + 4)) || ((y == origin_y + 4) && (x >= origin_x + 3) && (x <= origin_x + 4)) || ((x == origin_x + 5) && (y == origin_y + 3)) || ((x == origin_x + 7) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 10) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y == origin_y + 6) && (x >= origin_x + 8) && (x <= origin_x + 9)) || ((y == origin_y + 2) && (x >= origin_x + 12) && (x <= origin_x + 16)) || ((y >= origin_y + 3) && (y <= origin_y + 6) && (x == origin_x + 14)) || ((x == origin_x + 19) && (y == origin_y + 3)) || ((x == origin_x + 19) && (y == origin_y + 5))) oled_data = 0;
        else if (first_digit == 1 && (((x == origin_x + 24) && (y >= origin_y + 2) && (y <= origin_y + 5)) || ((x == origin_x + 23) && (y == origin_y + 3)) || ((y == origin_y + 6) && (x >= origin_x + 23) && (x <= origin_x + 25)))) oled_data = 0;
        else if (first_digit == 2 && (((x == origin_x + 22) && (y == origin_y + 3)) || ((x == origin_x + 25) && (y == origin_y + 3)) || ((x == origin_x + 24) && (y == origin_y + 4)) || ((x == origin_x + 23) && (y == origin_y + 5)) || ((y == origin_y + 6) && (x >= origin_x + 22) && (x <= origin_x + 25)) || ((y == origin_y + 2) && (x >= origin_x + 23) && (x <= origin_x + 24)))) oled_data = 0;
        else if (first_digit == 3 && (((x == origin_x + 22) && (y == origin_y + 3)) || ((x == origin_x + 25) && (y == origin_y + 3)) || ((x == origin_x + 24) && (y == origin_y + 4)) || ((x == origin_x + 22) && (y == origin_y + 5)) || ((x == origin_x + 25) && (y == origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 23) && (x <= origin_x + 24)) || ((y == origin_y + 6) && (x >= origin_x + 23) && (x <= origin_x + 24)))) oled_data = 0;
        else if (first_digit == 4 && (((x == origin_x + 24) && (y >= origin_y + 2) && (y <= origin_y + 6)) || ((y == origin_y + 5) && (x >= origin_x + 22) && (x <= origin_x + 25)) || ((x == origin_x + 22) && (y == origin_y + 4)) || ((x == origin_x + 23) && (y == origin_y + 3)))) oled_data = 0;
        else if (first_digit == 5 && (((y == origin_y + 2) && (x >= origin_x + 22) && (x <= origin_x + 25)) || ((y == origin_y + 4) && (x >= origin_x + 22) && (x <= origin_x + 24)) || ((y == origin_y + 6) && (x >= origin_x + 22) && (x <= origin_x + 24)) || ((y == origin_y + 5) && (x == origin_x + 25)) || ((y == origin_y + 3) && (x == origin_x + 22)))) oled_data = 0;
        else if (first_digit == 6 && (((y == origin_y + 2) && (x >= origin_x + 23) && (x <= origin_x + 24)) || ((y == origin_y + 4) && (x >= origin_x + 22) && (x <= origin_x + 24)) || ((y == origin_y + 6) && (x >= origin_x + 23) && (x <= origin_x + 24)) || ((y == origin_y + 5) && (x == origin_x + 25)) || ((y >= origin_y + 3) && (y <= origin_y + 5) && (x == origin_x + 22)))) oled_data = 0;
        else if (first_digit == 7 && (((y == origin_y + 2) && (x >= origin_x + 22) && (x <= origin_x + 24)) || ((x == origin_x + 25) && (y >= origin_y + 3) && (y <= origin_y + 4)) || ((x == origin_x + 24) && (y >= origin_y + 5) && (y <= origin_y + 6)))) oled_data = 0;
        else if (first_digit == 8 && (((x == origin_x + 22) && (y == origin_y + 3)) || ((x == origin_x + 25) && (y == origin_y + 3)) || ((x >= origin_x + 23) && (x <= origin_x + 24) && (y == origin_y + 4)) || ((x == origin_x + 22) && (y == origin_y + 5)) || ((x == origin_x + 25) && (y == origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 23) && (x <= origin_x + 24)) || ((y == origin_y + 6) && (x >= origin_x + 23) && (x <= origin_x + 24)))) oled_data = 0; 
        else if (first_digit == 9 && (((x == origin_x + 22) && (y == origin_y + 3)) || ((y == origin_y + 2) && (x >= origin_x + 23) && (x <= origin_x + 24)) || ((y == origin_y + 4) && (x >= origin_x + 23) && (x <= origin_x + 25)) || ((x == origin_x + 25) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 24) && (y == origin_y + 6)))) oled_data = 0; 
        else if (first_digit != 0 && second_digit == 0 && (((x == origin_x + 27) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 30) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 28) && (x <= origin_x + 29)) || ((y == origin_y + 6) && (x >= origin_x + 28) && (x <= origin_x + 29)))) oled_data = 0;  
        else if (second_digit == 1 && (((x == origin_x + 29) && (y >= origin_y + 2) && (y <= origin_y + 5)) || ((x == origin_x + 28) && (y == origin_y + 3)) || ((y == origin_y + 6) && (x >= origin_x + 28) && (x <= origin_x + 30)))) oled_data = 0;
        else if (second_digit == 2 && (((x == origin_x + 27) && (y == origin_y + 3)) || ((x == origin_x + 30) && (y == origin_y + 3)) || ((x == origin_x + 29) && (y == origin_y + 4)) || ((x == origin_x + 28) && (y == origin_y + 5)) || ((y == origin_y + 6) && (x >= origin_x + 27) && (x <= origin_x + 30)) || ((y == origin_y + 2) && (x >= origin_x + 28) && (x <= origin_x + 29)))) oled_data = 0;
        else if (second_digit == 3 && (((x == origin_x + 27) && (y == origin_y + 3)) || ((x == origin_x + 30) && (y == origin_y + 3)) || ((x == origin_x + 29) && (y == origin_y + 4)) || ((x == origin_x + 27) && (y == origin_y + 5)) || ((x == origin_x + 30) && (y == origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 28) && (x <= origin_x + 29)) || ((y == origin_y + 6) && (x >= origin_x + 28) && (x <= origin_x + 29)))) oled_data = 0;
        else if (second_digit == 4 && (((x == origin_x + 29) && (y >= origin_y + 2) && (y <= origin_y + 6)) || ((y == origin_y + 5) && (x >= origin_x + 27) && (x <= origin_x + 30)) || ((x == origin_x + 27) && (y == origin_y + 4)) || ((x == origin_x + 28) && (y == origin_y + 3)))) oled_data = 0;
        else if (second_digit == 5 && (((y == origin_y + 2) && (x >= origin_x + 27) && (x <= origin_x + 30)) || ((y == origin_y + 4) && (x >= origin_x + 27) && (x <= origin_x + 29)) || ((y == origin_y + 6) && (x >= origin_x + 27) && (x <= origin_x + 29)) || ((y == origin_y + 5) && (x == origin_x + 30)) || ((y == origin_y + 3) && (x == origin_x + 27)))) oled_data = 0;
        else if (second_digit == 6 && (((y == origin_y + 2) && (x >= origin_x + 28) && (x <= origin_x + 29)) || ((y == origin_y + 4) && (x >= origin_x + 27) && (x <= origin_x + 29)) || ((y == origin_y + 6) && (x >= origin_x + 28) && (x <= origin_x + 29)) || ((y == origin_y + 5) && (x == origin_x + 30)) || ((y >= origin_y + 3) && (y <= origin_y + 5) && (x == origin_x + 27)))) oled_data = 0;
        else if (second_digit == 7 && (((y == origin_y + 2) && (x >= origin_x + 27) && (x <= origin_x + 29)) || ((x == origin_x + 30) && (y >= origin_y + 3) && (y <= origin_y + 4)) || ((x == origin_x + 29) && (y >= origin_y + 5) && (y <= origin_y + 6)))) oled_data = 0;
        else if (second_digit == 8 && (((x == origin_x + 27) && (y == origin_y + 3)) || ((x == origin_x + 30) && (y == origin_y + 3)) || ((x >= origin_x + 28) && (x <= origin_x + 29) && (y == origin_y + 4)) || ((x == origin_x + 27) && (y == origin_y + 5)) || ((x == origin_x + 30) && (y == origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 28) && (x <= origin_x + 29)) || ((y == origin_y + 6) && (x >= origin_x + 28) && (x <= origin_x + 29)))) oled_data = 0; 
        else if (second_digit == 9 && (((x == origin_x + 27) && (y == origin_y + 3)) || ((y == origin_y + 2) && (x >= origin_x + 28) && (x <= origin_x + 29)) || ((y == origin_y + 4) && (x >= origin_x + 28) && (x <= origin_x + 30)) || ((x == origin_x + 30) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 29) && (y == origin_y + 6)))) oled_data = 0;
        else if ((first_digit != 0 || second_digit != 0) && third_digit == 0 && (((x == origin_x + 32) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 35) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 33) && (x <= origin_x + 34)) || ((y == origin_y + 6) && (x >= origin_x + 33) && (x <= origin_x + 34)))) oled_data = 0;
        else if (third_digit == 1 && (((x == origin_x + 34) && (y >= origin_y + 2) && (y <= origin_y + 5)) || ((x == origin_x + 33) && (y == origin_y + 3)) || ((y == origin_y + 6) && (x >= origin_x + 33) && (x <= origin_x + 35)))) oled_data = 0;
        else if (third_digit == 2 && (((x == origin_x + 32) && (y == origin_y + 3)) || ((x == origin_x + 35) && (y == origin_y + 3)) || ((x == origin_x + 34) && (y == origin_y + 4)) || ((x == origin_x + 33) && (y == origin_y + 5)) || ((y == origin_y + 6) && (x >= origin_x + 32) && (x <= origin_x + 35)) || ((y == origin_y + 2) && (x >= origin_x + 33) && (x <= origin_x + 34)))) oled_data = 0;
        else if (third_digit == 3 && (((x == origin_x + 32) && (y == origin_y + 3)) || ((x == origin_x + 35) && (y == origin_y + 3)) || ((x == origin_x + 34) && (y == origin_y + 4)) || ((x == origin_x + 32) && (y == origin_y + 5)) || ((x == origin_x + 35) && (y == origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 33) && (x <= origin_x + 34)) || ((y == origin_y + 6) && (x >= origin_x + 33) && (x <= origin_x + 34)))) oled_data = 0;
        else if (third_digit == 4 && (((x == origin_x + 34) && (y >= origin_y + 2) && (y <= origin_y + 6)) || ((y == origin_y + 5) && (x >= origin_x + 32) && (x <= origin_x + 35)) || ((x == origin_x + 32) && (y == origin_y + 4)) || ((x == origin_x + 33) && (y == origin_y + 3)))) oled_data = 0;
        else if (third_digit == 5 && (((y == origin_y + 2) && (x >= origin_x + 32) && (x <= origin_x + 35)) || ((y == origin_y + 4) && (x >= origin_x + 32) && (x <= origin_x + 34)) || ((y == origin_y + 6) && (x >= origin_x + 32) && (x <= origin_x + 34)) || ((y == origin_y + 5) && (x == origin_x + 35)) || ((y == origin_y + 3) && (x == origin_x + 32)))) oled_data = 0;
        else if (third_digit == 6 && (((y == origin_y + 2) && (x >= origin_x + 33) && (x <= origin_x + 34)) || ((y == origin_y + 4) && (x >= origin_x + 32) && (x <= origin_x + 34)) || ((y == origin_y + 6) && (x >= origin_x + 33) && (x <= origin_x + 34)) || ((y == origin_y + 5) && (x == origin_x + 35)) || ((y >= origin_y + 3) && (y <= origin_y + 5) && (x == origin_x + 32)))) oled_data = 0;
        else if (third_digit == 7 && (((y == origin_y + 2) && (x >= origin_x + 32) && (x <= origin_x + 34)) || ((x == origin_x + 35) && (y >= origin_y + 3) && (y <= origin_y + 4)) || ((x == origin_x + 34) && (y >= origin_y + 5) && (y <= origin_y + 6)))) oled_data = 0;
        else if (third_digit == 8 && (((x == origin_x + 32) && (y == origin_y + 3)) || ((x == origin_x + 35) && (y == origin_y + 3)) || ((x >= origin_x + 33) && (x <= origin_x + 34) && (y == origin_y + 4)) || ((x == origin_x + 32) && (y == origin_y + 5)) || ((x == origin_x + 35) && (y == origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 33) && (x <= origin_x + 34)) || ((y == origin_y + 6) && (x >= origin_x + 33) && (x <= origin_x + 34)))) oled_data = 0; 
        else if (third_digit == 9 && (((x == origin_x + 32) && (y == origin_y + 3)) || ((y == origin_y + 2) && (x >= origin_x + 33) && (x <= origin_x + 34)) || ((y == origin_y + 4) && (x >= origin_x + 33) && (x <= origin_x + 35)) || ((x == origin_x + 35) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 34) && (y == origin_y + 6)))) oled_data = 0;
        else if (fourth_digit == 0 && (((x == origin_x + 37) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 40) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 38) && (x <= origin_x + 39)) || ((y == origin_y + 6) && (x >= origin_x + 38) && (x <= origin_x + 39)))) oled_data = 0;
        else if (fourth_digit == 1 && (((x == origin_x + 39) && (y >= origin_y + 2) && (y <= origin_y + 5)) || ((x == origin_x + 38) && (y == origin_y + 3)) || ((y == origin_y + 6) && (x >= origin_x + 38) && (x <= origin_x + 39)))) oled_data = 0;
        else if (fourth_digit == 2 && (((x == origin_x + 37) && (y == origin_y + 3)) || ((x == origin_x + 40) && (y == origin_y + 3)) || ((x == origin_x + 39) && (y == origin_y + 4)) || ((x == origin_x + 38) && (y == origin_y + 5)) || ((y == origin_y + 6) && (x >= origin_x + 37) && (x <= origin_x + 40)) || ((y == origin_y + 2) && (x >= origin_x + 38) && (x <= origin_x + 39)))) oled_data = 0;
        else if (fourth_digit == 3 && (((x == origin_x + 37) && (y == origin_y + 3)) || ((x == origin_x + 40) && (y == origin_y + 3)) || ((x == origin_x + 39) && (y == origin_y + 4)) || ((x == origin_x + 37) && (y == origin_y + 5)) || ((x == origin_x + 40) && (y == origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 38) && (x <= origin_x + 39)) || ((y == origin_y + 6) && (x >= origin_x + 38) && (x <= origin_x + 39)))) oled_data = 0;
        else if (fourth_digit == 4 && (((x == origin_x + 39) && (y >= origin_y + 2) && (y <= origin_y + 6)) || ((y == origin_y + 5) && (x >= origin_x + 37) && (x <= origin_x + 40)) || ((x == origin_x + 37) && (y == origin_y + 4)) || ((x == origin_x + 38) && (y == origin_y + 3)))) oled_data = 0;
        else if (fourth_digit == 5 && (((y == origin_y + 2) && (x >= origin_x + 37) && (x <= origin_x + 40)) || ((y == origin_y + 4) && (x >= origin_x + 37) && (x <= origin_x + 39)) || ((y == origin_y + 6) && (x >= origin_x + 37) && (x <= origin_x + 39)) || ((y == origin_y + 5) && (x == origin_x + 40)) || ((y == origin_y + 3) && (x == origin_x + 37)))) oled_data = 0;
        else if (fourth_digit == 6 && (((y == origin_y + 2) && (x >= origin_x + 38) && (x <= origin_x + 39)) || ((y == origin_y + 4) && (x >= origin_x + 37) && (x <= origin_x + 39)) || ((y == origin_y + 6) && (x >= origin_x + 38) && (x <= origin_x + 39)) || ((y == origin_y + 5) && (x == origin_x + 40)) || ((y >= origin_y + 3) && (y <= origin_y + 5) && (x == origin_x + 37)))) oled_data = 0;
        else if (fourth_digit == 7 && (((y == origin_y + 2) && (x >= origin_x + 37) && (x <= origin_x + 39)) || ((x == origin_x + 40) && (y >= origin_y + 3) && (y <= origin_y + 4)) || ((x == origin_x + 39) && (y >= origin_y + 5) && (y <= origin_y + 6)))) oled_data = 0;
        else if (fourth_digit == 8 && (((x == origin_x + 37) && (y == origin_y + 3)) || ((x == origin_x + 40) && (y == origin_y + 3)) || ((x >= origin_x + 38) && (x <= origin_x + 39) && (y == origin_y + 4)) || ((x == origin_x + 37) && (y == origin_y + 5)) || ((x == origin_x + 40) && (y == origin_y + 5)) || ((y == origin_y + 2) && (x >= origin_x + 38) && (x <= origin_x + 39)) || ((y == origin_y + 6) && (x >= origin_x + 38) && (x <= origin_x + 39)))) oled_data = 0;
        else if (fourth_digit == 9 && (((x == origin_x + 37) && (y == origin_y + 3)) || ((y == origin_y + 2) && (x >= origin_x + 38) && (x <= origin_x + 39)) || ((y == origin_y + 4) && (x >= origin_x + 38) && (x <= origin_x + 40)) || ((x == origin_x + 40) && (y >= origin_y + 3) && (y <= origin_y + 5)) || ((x == origin_x + 39) && (y == origin_y + 6)))) oled_data = 0;
        else oled_data = 16'b1111111111111111;
    end
    
endmodule
