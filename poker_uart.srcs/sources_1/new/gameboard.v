`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2024 22:22:01
// Design Name: 
// Module Name: gameboard
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


module gameboard(
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
    input blind,
    input [7:0] action,
    input [31:0] amount,
    input [31:0] x,
    input [31:0] y,
    input [1:0] win_lose,
    input opp_signal,
    output [15:0] oled_data);
    
    wire signed [31:0] signed_y;
    wire signed [31:0] signed_start_y;
    
    wire [31:0] origin_start_x;
    wire [31:0] origin_start_y;
    wire [15:0] pixel_data_start;
    wire starting_animation_done;
    init_animation starting_animation (clk, clk_1k, origin_start_x, origin_start_y, x, y, starting_animation_done, pixel_data_start);

    assign signed_y = y;
    assign signed_start_y = origin_start_y;
    
    reg signed [31:0] origin_flop1_number_x = 1; 
    reg signed [31:0] origin_flop1_number_y = 1;
    reg signed [31:0] origin_flop1_suit_x = 1; 
    reg signed [31:0] origin_flop1_suit_y = 16;
    
    reg signed [31:0] origin_flop2_number_x = 20; 
    reg signed [31:0] origin_flop2_number_y = 1;
    reg signed [31:0] origin_flop2_suit_x = 20; 
    reg signed [31:0] origin_flop2_suit_y = 16;
    
    reg signed [31:0] origin_flop3_number_x = 39; 
    reg signed [31:0] origin_flop3_number_y = 1;
    reg signed [31:0] origin_flop3_suit_x = 39; 
    reg signed [31:0] origin_flop3_suit_y = 16;
    
    reg signed [31:0] origin_turn_number_x = 58; 
    reg signed [31:0] origin_turn_number_y = 1;
    reg signed [31:0] origin_turn_suit_x = 58; 
    reg signed [31:0] origin_turn_suit_y = 16;
    
    reg signed [31:0] origin_river_number_x = 77; 
    reg signed [31:0] origin_river_number_y = 1;
    reg signed [31:0] origin_river_suit_x = 77; 
    reg signed [31:0] origin_river_suit_y = 16;
    
    reg signed [31:0] origin_hole1_number_x = 58;
    reg signed [31:0] origin_hole1_number_y = 33;
    reg signed [31:0] origin_hole1_suit_x = 58;
    reg signed [31:0] origin_hole1_suit_y = 48;
    
    reg signed [31:0] origin_hole2_number_x = 77;
    reg signed [31:0] origin_hole2_number_y = 33;
    reg signed [31:0] origin_hole2_suit_x = 77;
    reg signed [31:0] origin_hole2_suit_y = 48;
   
    reg signed [31:0] origin_opp_hole1_number_x = 1;
    reg signed [31:0] origin_opp_hole1_number_y = 33;
    reg signed [31:0] origin_opp_hole1_suit_x = 1;
    reg signed [31:0] origin_opp_hole1_suit_y = 48;
     
    reg signed [31:0] origin_opp_hole2_number_x = 20;
    reg signed [31:0] origin_opp_hole2_number_y = 33;
    reg signed [31:0] origin_opp_hole2_suit_x = 20;
    reg signed [31:0] origin_opp_hole2_suit_y = 48;
    
//    move_card card_movement (clk_1k, flop1, flop2, flop3, turn, river, hole1, hole2, opp_hole1, opp_hole2,
//    origin_flop1_number_x, origin_flop1_number_y, origin_flop1_suit_x, origin_flop1_suit_y,
//    origin_flop2_number_x, origin_flop2_number_y, origin_flop2_suit_x, origin_flop2_suit_y,
//    origin_flop3_number_x, origin_flop3_number_y, origin_flop3_suit_x, origin_flop3_suit_y,
//    origin_turn_number_x, origin_turn_number_y, origin_turn_suit_x, origin_turn_suit_y,
//    origin_river_number_x, origin_river_number_y, origin_river_suit_x, origin_river_suit_y,
//    origin_hole1_number_x, origin_hole1_number_y, origin_hole1_suit_x, origin_hole1_suit_y,
//    origin_hole2_number_x, origin_hole2_number_y, origin_hole2_suit_x, origin_hole2_suit_y,
//    origin_opp_hole1_number_x, origin_opp_hole1_number_y, origin_opp_hole1_suit_x, origin_opp_hole1_suit_y,
//    origin_opp_hole2_number_x, origin_opp_hole2_number_y, origin_opp_hole2_suit_x, origin_opp_hole2_suit_y);
    
    reg [31:0] origin_blind_x = 48;
    reg [31:0] origin_blind_y = 33;
    
    reg [31:0] origin_pot_x = 1;
    reg [31:0] origin_pot_y = 33;
    
    reg [31:0] origin_action_x = 1;
    reg [31:0] origin_action_y = 43;
    
    wire [3:0] flop1_number;
    wire [2:0] flop1_suit;
    wire [3:0] flop2_number;
    wire [2:0] flop2_suit;
    wire [3:0] flop3_number;
    wire [2:0] flop3_suit;
    wire [3:0] turn_number;
    wire [2:0] turn_suit;
    wire [3:0] river_number;
    wire [2:0] river_suit;
    wire [3:0] hole1_number;
    wire [2:0] hole1_suit;
    wire [3:0] hole2_number;
    wire [2:0] hole2_suit;
    wire [3:0] opp_hole1_number;
    wire [2:0] opp_hole1_suit;
    wire [3:0] opp_hole2_number;
    wire [2:0] opp_hole2_suit;
    wire [7:0] opp_action;
    wire [5:0] raise_amount;
    
    assign flop1_number = flop1[3:0];
    assign flop1_suit[2] = (flop1 == 0) ? 0 : 1;
    assign flop1_suit[1:0] = flop1[6:5];
    assign flop2_number = flop2[3:0];
    assign flop2_suit[2] = (flop2 == 0) ? 0 : 1;
    assign flop2_suit[1:0] = flop2[6:5];
    assign flop3_number = flop3[3:0];
    assign flop3_suit[2] = (flop3 == 0) ? 0 : 1;
    assign flop3_suit[1:0] = flop3[6:5];
    assign turn_number = turn[3:0];
    assign turn_suit[2] = (turn == 0) ? 0 : 1;
    assign turn_suit[1:0] = turn[6:5];
    assign river_number = river[3:0];
    assign river_suit[2] = (river == 0) ? 0 : 1;
    assign river_suit[1:0] = river[6:5];
    assign hole1_number = hole1[3:0];
    assign hole1_suit[2] = (hole1 == 0) ? 0 : 1;
    assign hole1_suit[1:0] = hole1[6:5];
    assign hole2_number = hole2[3:0];
    assign hole2_suit[2] = (hole2 == 0) ? 0 : 1;
    assign hole2_suit[1:0] = hole2[6:5];
    assign opp_hole1_number = opp_hole1[3:0];
    assign opp_hole1_suit[2] = (opp_hole1 == 0) ? 0 : 1;
    assign opp_hole1_suit[1:0] = opp_hole1[6:5];
    assign opp_hole2_number = opp_hole2[3:0];
    assign opp_hole2_suit[2] = (opp_hole2 == 0) ? 0 : 1;
    assign opp_hole2_suit[1:0] = opp_hole2[6:5];
    assign opp_action = action;
    assign raise_amount = action[5:0];
    
    wire [15:0] pixel_data_flop1_number;
    wire [15:0] pixel_data_flop1_suit;
    wire [15:0] pixel_data_flop2_number;
    wire [15:0] pixel_data_flop2_suit;
    wire [15:0] pixel_data_flop3_number;
    wire [15:0] pixel_data_flop3_suit;
    wire [15:0] pixel_data_turn_number;
    wire [15:0] pixel_data_turn_suit;
    wire [15:0] pixel_data_river_number;
    wire [15:0] pixel_data_river_suit;
    wire [15:0] pixel_data_hole1_number;
    wire [15:0] pixel_data_hole1_suit;
    wire [15:0] pixel_data_hole2_number;
    wire [15:0] pixel_data_hole2_suit;
    wire [15:0] pixel_data_opp_hole1_number;
    wire [15:0] pixel_data_opp_hole1_suit;
    wire [15:0] pixel_data_opp_hole2_number;
    wire [15:0] pixel_data_opp_hole2_suit;
    wire [15:0] pixel_data_blind;
    wire [15:0] pixel_data_pot;
    wire [15:0] pixel_data_action;
    wire [15:0] pixel_data_win;
    wire [15:0] pixel_data_lose;
    
    card_number flop1_N (clk, flop1_number, origin_flop1_number_x, origin_flop1_number_y, x, y, pixel_data_flop1_number);
    card_suit flop1_S (clk, flop1_suit, origin_flop1_suit_x, origin_flop1_suit_y, x, y, pixel_data_flop1_suit);
    
    card_number flop2_N (clk, flop2_number, origin_flop2_number_x, origin_flop2_number_y, x, y, pixel_data_flop2_number);
    card_suit flop2_S (clk, flop2_suit, origin_flop2_suit_x, origin_flop2_suit_y, x, y, pixel_data_flop2_suit);
    
    card_number flop3_N (clk, flop3_number, origin_flop3_number_x, origin_flop3_number_y, x, y, pixel_data_flop3_number);
    card_suit flop3_S (clk, flop3_suit, origin_flop3_suit_x, origin_flop3_suit_y, x, y, pixel_data_flop3_suit);
    
    card_number turn_N (clk, turn_number, origin_turn_number_x, origin_turn_number_y, x, y, pixel_data_turn_number);
    card_suit turn_S (clk, turn_suit, origin_turn_suit_x, origin_turn_suit_y, x, y, pixel_data_turn_suit);
    
    card_number river_N (clk, river_number, origin_river_number_x, origin_river_number_y, x, y, pixel_data_river_number);
    card_suit river_S (clk, river_suit, origin_river_suit_x, origin_river_suit_y, x, y, pixel_data_river_suit);
    
    card_number hole1_N (clk, hole1_number, origin_hole1_number_x, origin_hole1_number_y, x, y, pixel_data_hole1_number);
    card_suit hole1_S (clk, hole1_suit, origin_hole1_suit_x, origin_hole1_suit_y, x, y, pixel_data_hole1_suit);
    
    card_number hole2_N (clk, hole2_number, origin_hole2_number_x, origin_hole2_number_y, x, y, pixel_data_hole2_number);
    card_suit hole2_S (clk, hole2_suit, origin_hole2_suit_x, origin_hole2_suit_y, x, y, pixel_data_hole2_suit);
    
    card_number opp_hole1_N (clk, opp_hole1_number, origin_opp_hole1_number_x, origin_opp_hole1_number_y, x, y, pixel_data_opp_hole1_number);
    card_suit opp_hole1_S (clk, opp_hole1_suit, origin_opp_hole1_suit_x, origin_opp_hole1_suit_y, x, y, pixel_data_opp_hole1_suit);
    
    card_number opp_hole2_N (clk, opp_hole2_number, origin_opp_hole2_number_x, origin_opp_hole2_number_y, x, y, pixel_data_opp_hole2_number);
    card_suit opp_hole2_S (clk, opp_hole2_suit, origin_opp_hole2_suit_x, origin_opp_hole2_suit_y, x, y, pixel_data_opp_hole2_suit);
    
    blind small_big (clk, blind, origin_blind_x, origin_blind_y, x, y, pixel_data_blind);
    
    pot_amount pot (clk, amount, origin_pot_x, origin_pot_y, x, y, pixel_data_pot);
    
    opponent_action opp (clk, opp_action, raise_amount, origin_action_x, origin_action_y, x, y, pixel_data_action);

    win_animation win (clk, x, y, pixel_data_win);
    lose_animation lose (clk, x, y, pixel_data_lose);

    parameter WON = 2'b01;
    parameter LOST = 2'b10;
    
    assign oled_data = 
    (win_lose == WON) ? pixel_data_win :
    (win_lose == LOST) ? pixel_data_lose :
    (!starting_animation_done) ? pixel_data_start : 
    (x >= origin_flop1_number_x && y >= origin_flop1_number_y && x <= (origin_flop1_number_x + 17) && y <= (origin_flop1_number_y + 14)) ? pixel_data_flop1_number : 
    (x >= origin_flop1_suit_x && y >= origin_flop1_suit_y && x <= (origin_flop1_suit_x + 17) && y <= (origin_flop1_suit_y + 14)) ? pixel_data_flop1_suit :
    (x >= origin_flop2_number_x && y >= origin_flop2_number_y && x <= (origin_flop2_number_x + 17) && y <= (origin_flop2_number_y + 14)) ? pixel_data_flop2_number :
    (x >= origin_flop2_suit_x && y >= origin_flop2_suit_y && x <= (origin_flop2_suit_x + 17) && y <= (origin_flop2_suit_y + 14)) ? pixel_data_flop2_suit :
    (x >= origin_flop3_number_x && y >= origin_flop3_number_y && x <= (origin_flop3_number_x + 17) && y <= (origin_flop3_number_y + 14)) ? pixel_data_flop3_number :
    (x >= origin_flop3_suit_x && y >= origin_flop3_suit_y && x <= (origin_flop3_suit_x + 17) && y <= (origin_flop3_suit_y + 14)) ? pixel_data_flop3_suit :
    (x >= origin_turn_number_x && y >= origin_turn_number_y && x <= (origin_turn_number_x + 17) && y <= (origin_turn_number_y + 14)) ? pixel_data_turn_number :
    (x >= origin_turn_suit_x && y >= origin_turn_suit_y && x <= (origin_turn_suit_x + 17) && y <= (origin_turn_suit_y + 14)) ? pixel_data_turn_suit :
    (x >= origin_river_number_x && y >= origin_river_number_y && x <= (origin_river_number_x + 17) && y <= (origin_river_number_y + 14)) ? pixel_data_river_number :
    (x >= origin_river_suit_x && y >= origin_river_suit_y && x <= (origin_river_suit_x + 17) && y <= (origin_river_suit_y + 14)) ? pixel_data_river_suit :
    (x >= origin_hole1_number_x && y >= origin_hole1_number_y && x <= (origin_hole1_number_x + 17) && y <= (origin_hole1_number_y + 14)) ? pixel_data_hole1_number :
    (x >= origin_hole1_suit_x && y >= origin_hole1_suit_y && x <= (origin_hole1_suit_x + 17) && y <= (origin_hole1_suit_y + 14)) ? pixel_data_hole1_suit :
    (x >= origin_hole2_number_x && y >= origin_hole2_number_y && x <= (origin_hole2_number_x + 17) && y <= (origin_hole2_number_y + 14)) ? pixel_data_hole2_number :
    (x >= origin_hole2_suit_x && y >= origin_hole2_suit_y && x <= (origin_hole2_suit_x + 17) && y <= (origin_hole2_suit_y + 14)) ? pixel_data_hole2_suit :
    (opp_signal && x >= origin_opp_hole1_number_x && y >= origin_opp_hole1_number_y && x <= (origin_opp_hole1_number_x + 17) && y <= (origin_opp_hole1_number_y + 14)) ? pixel_data_opp_hole1_number :
    (opp_signal && x >= origin_opp_hole1_suit_x && y >= origin_opp_hole1_suit_y && x <= (origin_opp_hole1_suit_x + 17) && y <= (origin_opp_hole1_suit_y + 14)) ? pixel_data_opp_hole1_suit :
    (opp_signal && x >= origin_opp_hole2_number_x && y >= origin_opp_hole2_number_y && x <= (origin_opp_hole2_number_x + 17) && y <= (origin_opp_hole2_number_y + 14)) ? pixel_data_opp_hole2_number :
    (opp_signal && x >= origin_opp_hole2_suit_x && y >= origin_opp_hole2_suit_y && x <= (origin_opp_hole2_suit_x + 17) && y <= (origin_opp_hole2_suit_y + 14)) ? pixel_data_opp_hole2_suit :
    (x >= origin_blind_x && y >= origin_blind_y && x <= (origin_blind_x + 8) && y <= (origin_blind_y + 8)) ? pixel_data_blind :
    (!opp_signal && x >= origin_pot_x && y >= origin_pot_y && x <= (origin_pot_x + 45) && y <= (origin_pot_y + 8)) ? pixel_data_pot :
    (!opp_signal && x >= origin_action_x && y >= origin_action_y && x <= (origin_action_x + 55) && y <= (origin_action_y + 19)) ? pixel_data_action :
    16'b00000_101000_00000;
    
endmodule
