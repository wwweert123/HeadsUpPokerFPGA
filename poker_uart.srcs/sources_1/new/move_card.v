`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2024 00:52:52
// Design Name: 
// Module Name: move_card
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


module move_card(
    input clk,
    input clk_1k,
    input [7:0] flop1,
    input [7:0] flop2,
    input [7:0] flop3,
    input [7:0] turn,
    input [7:0] river,
    input [7:0] hole1,
    input [7:0] hole2,
    input [7:0] opp_hole1,
    input [7:0] opp_hole2,
    output reg signed [31:0] origin_flop1_number_x = 1,
    output reg signed [31:0] origin_flop1_number_y = -30,
    output reg signed [31:0] origin_flop1_suit_x = 1,
    output reg signed [31:0] origin_flop1_suit_y = -15,
    output reg signed [31:0] origin_flop2_number_x = 20,
    output reg signed [31:0] origin_flop2_number_y = -30,
    output reg signed [31:0] origin_flop2_suit_x = 20,
    output reg signed [31:0] origin_flop2_suit_y = -15,
    output reg signed [31:0] origin_flop3_number_x = 39,
    output reg signed [31:0] origin_flop3_number_y = -30,
    output reg signed [31:0] origin_flop3_suit_x = 39,
    output reg signed [31:0] origin_flop3_suit_y = -15,
    output reg signed [31:0] origin_turn_number_x = 58,
    output reg signed [31:0] origin_turn_number_y = -30,
    output reg signed [31:0] origin_turn_suit_x = 58,
    output reg signed [31:0] origin_turn_suit_y = -15,
    output reg signed [31:0] origin_river_number_x = 77,
    output reg signed [31:0] origin_river_number_y = -30,
    output reg signed [31:0] origin_river_suit_x = 77,
    output reg signed [31:0] origin_river_suit_y = -15,
    output reg signed [31:0] origin_hole1_number_x = 58,
    output reg signed [31:0] origin_hole1_number_y = 64,
    output reg signed [31:0] origin_hole1_suit_x = 58,
    output reg signed [31:0] origin_hole1_suit_y = 79,
    output reg signed [31:0] origin_hole2_number_x = 77,
    output reg signed [31:0] origin_hole2_number_y = 64,
    output reg signed [31:0] origin_hole2_suit_x = 77,
    output reg signed [31:0] origin_hole2_suit_y = 79,
    output reg signed [31:0] origin_opp_hole1_number_x = 20,
    output reg signed [31:0] origin_opp_hole1_number_y = 64,
    output reg signed [31:0] origin_opp_hole1_suit_x = 20,
    output reg signed [31:0] origin_opp_hole1_suit_y = 79,
    output reg signed [31:0] origin_opp_hole2_number_x = 39,
    output reg signed [31:0] origin_opp_hole2_number_y = 64,
    output reg signed [31:0] origin_opp_hole2_suit_x = 39,
    output reg signed [31:0] origin_opp_hole2_suit_y = 79);

    reg [31:0] count_1 = 0;
    reg [31:0] count_2 = 0;
    reg [31:0] count_3 = 0;
    reg [31:0] count_4 = 0;
    reg [31:0] count_5 = 0;
    reg [31:0] count_6 = 0;
    reg [31:0] count_7 = 0;
    reg [31:0] count_8 = 0;
    
    always @ (posedge clk_1k) begin
        if (flop1) begin
            count_1 <= (count_1 == 500) ? 0 : count_1 + 1;
            if (count_1 == 500) begin
                origin_flop1_number_y <= (origin_flop1_number_y == 1) ? 1 : origin_flop1_number_y + 1; 
                origin_flop1_suit_y <= (origin_flop1_suit_y == 16) ? 16 : origin_flop1_suit_y + 1; 
            end
        end
    end
    
    always @ (posedge clk_1k) begin
        if (flop2) begin
            count_2 <= (count_2 == 500) ? 0 : count_2 + 1;
            if (count_2 == 500) begin
                origin_flop2_number_y <= (origin_flop2_number_y == 1) ? 1 : origin_flop2_number_y + 1; 
                origin_flop2_suit_y <= (origin_flop2_suit_y == 16) ? 16 : origin_flop2_suit_y + 1; 
            end
        end
    end
    
    always @ (posedge clk_1k) begin
        if (flop3) begin
            count_3 <= (count_3 == 500) ? 0 : count_3 + 1;
            if (count_3 == 500) begin
                origin_flop3_number_y <= (origin_flop3_number_y == 1) ? 1 : origin_flop3_number_y + 1; 
                origin_flop3_suit_y <= (origin_flop3_suit_y == 16) ? 16 : origin_flop3_suit_y + 1; 
            end
        end
    end
    
    always @ (posedge clk_1k) begin
        if (turn) begin
            count_4 <= (count_4 == 500) ? 0 : count_4 + 1;
            if (count_4 == 500) begin
                origin_turn_number_y <= (origin_turn_number_y == 1) ? 1 : origin_turn_number_y + 1; 
                origin_turn_suit_y <= (origin_turn_suit_y == 16) ? 16 : origin_turn_suit_y + 1; 
            end
        end
    end
    
    always @ (posedge clk_1k) begin
        if (river) begin
            count_5 <= (count_5 == 500) ? 0 : count_5 + 1;
            if (count_5 == 500) begin
                origin_river_number_y <= (origin_river_number_y == 1) ? 1 : origin_river_number_y + 1; 
                origin_river_suit_y <= (origin_river_suit_y == 16) ? 16 : origin_river_suit_y + 1; 
            end
        end
    end
    
    always @ (posedge clk_1k) begin
        if (hole1) begin
            count_6 <= (count_6 == 500) ? 0 : count_6 + 1;
            if (count_6 == 500) begin
                origin_hole1_number_y <= (origin_hole1_number_y == 33) ? 33 : origin_hole1_number_y - 1; 
                origin_hole1_suit_y <= (origin_hole1_suit_y == 48) ? 48 : origin_hole1_suit_y - 1; 
            end
        end
    end
    
    always @ (posedge clk_1k) begin
        if (hole2) begin
            count_7 <= (count_7 == 500) ? 0 : count_7 + 1;
            if (count_7 == 500) begin
                origin_hole2_number_y <= (origin_hole2_number_y == 33) ? 33 : origin_hole2_number_y - 1; 
                origin_hole2_suit_y <= (origin_hole2_suit_y == 48) ? 48 : origin_hole2_suit_y - 1; 
            end
        end
    end
    
    always @ (posedge clk_1k) begin
        if (opp_hole1 && opp_hole2) begin
            count_8 <= (count_8 == 500) ? 0 : count_8 + 1;
            if (count_8 == 500) begin
                origin_opp_hole1_number_y <= (origin_opp_hole1_number_y == 33) ? 33 : origin_opp_hole1_number_y - 1; 
                origin_opp_hole1_suit_y <= (origin_opp_hole1_suit_y == 48) ? 48 : origin_opp_hole1_suit_y - 1; 
                origin_opp_hole2_number_y <= (origin_opp_hole2_number_y == 33) ? 33 : origin_opp_hole2_number_y - 1; 
                origin_opp_hole2_suit_y <= (origin_opp_hole2_suit_y == 48) ? 48 : origin_opp_hole2_suit_y - 1; 
            end
        end
    end
    
endmodule
