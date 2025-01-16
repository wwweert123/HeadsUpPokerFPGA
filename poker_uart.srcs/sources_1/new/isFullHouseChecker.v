`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 15:35:48
// Design Name: 
// Module Name: isFullHouseChecker
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


module isFullHouseChecker(
    input [3:0] card1, card2, card3, card4, card5, card6, card7,
    input isFullHouseCheckerStarter,
    output reg isFullHouse,
    output reg [3:0] threeOfAKindCard,
    output reg [3:0] pairCard,
    output reg isProcessDone
);

    reg [3:0] valueArray[6:0];
    reg [2:0] valueCounter[15:0];
    integer i, v;
    reg foundThreeOfAKind;
    reg foundPair;

    always @(posedge isFullHouseCheckerStarter) begin
        for (v = 0; v < 15; v = v + 1) begin
            valueCounter[v] = 0;
        end

        valueArray[0] = card1;
        valueArray[1] = card2;
        valueArray[2] = card3;
        valueArray[3] = card4;
        valueArray[4] = card5;
        valueArray[5] = card6;
        valueArray[6] = card7;

        for (i = 0; i < 7; i = i + 1) begin
            valueCounter[valueArray[i]] = valueCounter[valueArray[i]] + 1;
        end

        isFullHouse = 1'b0;
        foundThreeOfAKind = 1'b0;
        foundPair = 1'b0;
        threeOfAKindCard = 4'b0000;
        pairCard = 4'b0000;
        isProcessDone = 0;
        for (v = 0; v < 15; v = v + 1) begin
            if (valueCounter[v] == 3 && v > threeOfAKindCard || (v == 4'b0001 && valueCounter[v] == 3)) begin
                foundThreeOfAKind = 1'b1;
                threeOfAKindCard = v;
                if (v == 4'b0001) begin
                    threeOfAKindCard = 4'b1110; // 14 to represent ace here
                end
            end else if (valueCounter [1] == 2) begin
                foundPair = 1'b1;
                pairCard = 4'b1110;
            end else if (valueCounter[v] >= 2 && !foundPair) begin
                foundPair = 1'b1;
                pairCard = v;
            end
        end

        if (foundThreeOfAKind && foundPair) begin
            isFullHouse = 1'b1;
        end
        isProcessDone = 1;
    end
endmodule

