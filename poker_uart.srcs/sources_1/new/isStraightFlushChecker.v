`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 13:41:02
// Design Name: 
// Module Name: isStraightFlushChecker
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


module isStraightFlushChecker(
    input [5:0] card1, card2, card3, card4, card5, card6, card7,
    output reg isStraightFlush, input isStraightFlushCheckerStarter, output reg [3:0] highCard, output reg isProcessDone = 0);

    reg [5:0] sorted_cards[6:0];
    reg [3:0] valueArray[6:0];
    reg [2:0] suitCounter[3:0];
    integer i, j, k;
    reg [1:0] flushSuit;
    reg foundStraight;
    reg isFlush;
    reg foundFlush;

    always @(posedge isStraightFlushCheckerStarter) begin
        isStraightFlush = 1'b0;
        highCard = 4'b0000;
        isFlush = 1'b0;
        isProcessDone = 0;
        foundFlush = 0;

        // Initialize suitCounter
        for (i = 0; i < 4; i = i + 1) begin
            suitCounter[i] = 0;
        end

        sorted_cards[0] = card1;
        sorted_cards[1] = card2;
        sorted_cards[2] = card3;
        sorted_cards[3] = card4;
        sorted_cards[4] = card5;
        sorted_cards[5] = card6;
        sorted_cards[6] = card7;

        for (i = 0; i < 7; i = i + 1) begin
            valueArray[i] = sorted_cards[i][3:0];
            suitCounter[sorted_cards[i][5:4]] = suitCounter[sorted_cards[i][5:4]] + 1;
        end

        flushSuit = 2'b00;
        for (i = 0; i < 4 && !foundFlush; i = i + 1) begin
            if (suitCounter[i] >= 5) begin
                flushSuit = i;
                isFlush = 1'b1;
                foundFlush = 1;
            end
        end

        if (isFlush) begin
            foundStraight = 1'b0;
            for (i = 6; i >= 4 && !foundStraight; i = i - 1) begin
                if (valueArray[i] == valueArray[i - 1] + 1 &&
                    valueArray[i - 1] == valueArray[i - 2] + 1 &&
                    valueArray[i - 2] == valueArray[i - 3] + 1 &&
                    valueArray[i - 3] == valueArray[i - 4] + 1 &&
                    sorted_cards[i][5:4] == flushSuit &&
                    sorted_cards[i - 1][5:4] == flushSuit &&
                    sorted_cards[i - 2][5:4] == flushSuit &&
                    sorted_cards[i - 3][5:4] == flushSuit &&
                    sorted_cards[i - 4][5:4] == flushSuit) begin
                    isStraightFlush = 1'b1;
                    highCard = valueArray[i];
                    foundStraight = 1'b1;
                end
            end
            if (!foundStraight && valueArray[0] == 4'b0001 && valueArray[1] == 4'b0010 &&
                valueArray[2] == 4'b0011 && valueArray[3] == 4'b0100 && valueArray[4] == 4'b0101 &&
                sorted_cards[0][5:4] == flushSuit &&
                sorted_cards[1][5:4] == flushSuit &&
                sorted_cards[2][5:4] == flushSuit &&
                sorted_cards[3][5:4] == flushSuit &&
                sorted_cards[4][5:4] == flushSuit) begin
                isStraightFlush = 1'b1;
                highCard = 4'b0101; // High card is 5 for Ace-low straight flush
            end
        end
        isProcessDone = 1;
    end
endmodule
