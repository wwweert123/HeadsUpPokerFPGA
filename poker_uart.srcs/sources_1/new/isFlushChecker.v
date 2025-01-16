`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 11:04:50
// Design Name: 
// Module Name: isFlushChecker
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
* pass in the last 6 bits of each card (suit + number) + need to reset isFlushCheckerStart to 0 in the caller module. 
* isFlush will be 1 if flush is present, and highCard will return the highest card of the flush.
*/
module isFlushChecker(
    input [5:0] card1, card2, card3, card4, card5, card6, card7,
    output reg isFlush,
    input isFlushCheckerStarter,
    output reg [3:0] highCard,
    output reg isProcessDone
);

    reg [5:0] sorted_cards[6:0];
    reg [2:0] suitCounter[3:0];
    integer i, j;
    reg [1:0] flushSuit;
    reg [3:0] tempValue;
    reg foundFlush;

    always @(posedge isFlushCheckerStarter) begin
        isProcessDone = 0;
        sorted_cards[0] = card1;
        sorted_cards[1] = card2;
        sorted_cards[2] = card3;
        sorted_cards[3] = card4;
        sorted_cards[4] = card5;
        sorted_cards[5] = card6;
        sorted_cards[6] = card7;

        for (i = 0; i < 4; i = i + 1) begin
            suitCounter[i] = 0;
        end

        for (i = 0; i < 7; i = i + 1) begin
            suitCounter[sorted_cards[i][5:4]] = suitCounter[sorted_cards[i][5:4]] + 1;
        end

        isFlush = 1'b0;
        highCard = 4'b0000;
        flushSuit = 2'b00; // Initialize to an invalid suit
        foundFlush = 0;

        for (i = 0; i < 4 && !foundFlush; i = i + 1) begin
            if (suitCounter[i] >= 5) begin
                isFlush = 1'b1;
                flushSuit = i;
                foundFlush = 1;
            end
        end

        if (isFlush) begin
            // Find the highest card in the flush suit
            for (i = 0; i < 7; i = i + 1) begin
                if (sorted_cards[i][5:4] == flushSuit) begin
                    tempValue = sorted_cards[i][3:0];
                    if (tempValue > highCard) begin
                        highCard = tempValue;
                    end else if (tempValue == 4'b0001) begin
                        highCard = 4'b1110;
                    end
                end
            end
        end

        isProcessDone = 1;
    end
endmodule
