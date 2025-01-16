`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 15:51:00
// Design Name: 
// Module Name: isTOAKChecker
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


module isTOAKChecker(
    input [3:0] card1, card2, card3, card4, card5, card6, card7,
    input isTOAKCheckerStarter,
    output reg isTOAK,
    output reg [3:0] threeOfAKindCard,
    output reg [3:0] kicker, kicker2,
    output reg isProcessDone
);

    reg [3:0] valueArray[6:0];
    reg [2:0] valueCounter[15:0];
    integer i, v;

    always @(posedge isTOAKCheckerStarter) begin
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

        isTOAK = 1'b0;
        threeOfAKindCard = 4'b0000;
        kicker = 4'b0000;
        kicker2 = 4'b0000;
        isProcessDone = 0;
        for (v = 14; v >= 0; v = v - 1) begin
            if (valueCounter[v] == 1) begin
                if (kicker == 4'b0000) begin
                    kicker = v;
                end else if (kicker2 == 4'b0000) begin
                    kicker2 = v;
                end
            end else if (valueCounter[v] == 3) begin
                isTOAK = 1'b1;
                if (v == 4'b0001) begin
                    threeOfAKindCard = 4'b1110; // 14 to represent ace
                end else begin
                    threeOfAKindCard = v;
                end
            end
        end
        isProcessDone = 1;
    end
endmodule

