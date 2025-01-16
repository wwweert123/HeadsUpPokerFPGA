`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 16:11:36
// Design Name: 
// Module Name: HighCards
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


module HighCards(
    input [3:0] card1, card2, card3, card4, card5, card6, card7,
    input highCardStarter,
    output reg [3:0] highCard, kicker, kicker2, kicker3, kicker4,
    output reg isProcessDone
);


    reg [3:0] sorted_cards[6:0];
    integer i, j;
    reg [3:0] temp;

    always @(posedge highCardStarter) begin
        kicker = 4'b0000;
        kicker2 = 4'b0000;
        kicker3 = 4'b0000;
        kicker4 = 4'b0000;
        isProcessDone = 0;
        if (card1 == 4'b0001) begin
                sorted_cards[6] = 4'b1110;
                sorted_cards[0] = card2;
                sorted_cards[1] = card3;
                sorted_cards[2] = card4;
                sorted_cards[3] = card5;
                sorted_cards[4] = card6;
                sorted_cards[5] = card7;
            end else begin
                sorted_cards[0] = card1;
                sorted_cards[1] = card2;
                sorted_cards[2] = card3;
                sorted_cards[3] = card4;
                sorted_cards[4] = card5;
                sorted_cards[5] = card6;
                sorted_cards[6] = card7;
            end
        highCard = sorted_cards[6];
        kicker = sorted_cards[5];
        kicker2 = sorted_cards[4];
        kicker3 = sorted_cards[3];
        kicker4 = sorted_cards[2];
        isProcessDone = 1;
    end
endmodule
