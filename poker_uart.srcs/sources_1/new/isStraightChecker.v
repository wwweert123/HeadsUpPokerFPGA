`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2024 20:14:01
// Design Name: 
// Module Name: isStraightChecker
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

/*
* pass in only value of each card + need to reset isStraightCheckerStart to 0 in the caller module. 
* isStraight will be 1 if straight is present, and [3:0]highCard will represent the highest value in the straight.
*/
module isStraightChecker(
    input [3:0] card1, card2, card3, card4, card5, card6, card7,
    output reg isStraight, input isStraightCheckerStarter, output reg [3:0] highCard,
    output reg isProcessDone
);
    reg [3:0] sorted_cards[6:0];
    integer i;
    reg [2:0] straightCounter;

    always @(posedge isStraightCheckerStarter) begin
        isStraight = 1'b0;
        highCard = 4'b0000;
        isProcessDone = 0;

        sorted_cards[0] = card1;
        sorted_cards[1] = card2;
        sorted_cards[2] = card3;
        sorted_cards[3] = card4;
        sorted_cards[4] = card5;
        sorted_cards[5] = card6;
        sorted_cards[6] = card7;

        // Check for straight
        straightCounter = 1; // Start with 1 as we always have at least one card in the sequence
        for (i = 1; i < 7; i = i + 1) begin
            if (sorted_cards[i] == sorted_cards[i-1] + 1) begin
                straightCounter = straightCounter + 1;
                if (straightCounter >= 5) begin
                    isStraight = 1'b1;
                    highCard = sorted_cards[i];
                end
            end else if (sorted_cards[i] != sorted_cards[i-1]) begin
                straightCounter = 1; 
            end
        end

        // Special case for Ace-high straight
        if (!isStraight && sorted_cards[6] == 4'b1110 && sorted_cards[0] == 4'b0001 && straightCounter == 4) begin
            isStraight = 1'b1;
            highCard = 4'b1110; // Ace is the high card
        end

        isProcessDone = 1;
    end
endmodule
