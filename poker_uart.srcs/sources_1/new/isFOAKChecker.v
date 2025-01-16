`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 15:18:30
// Design Name: 
// Module Name: isFOAKChecker
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


module isFOAKChecker(
    input [3:0] card1, card2, card3, card4, card5, card6, card7,
    input isFOAKCheckerStarter,
    output reg [3:0] highCard,
    output reg isFOAK,
    output reg [4:0]kicker,
    output reg isProcessDone
);

    reg [3:0] valueArray[6:0];
    reg [2:0] valueCounter[15:0];
    integer i, v;

    always @(posedge isFOAKCheckerStarter) begin
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

        isFOAK = 1'b0;
        kicker = 4'b0000;
        isProcessDone = 0;
        for (v = 0; v < 15; v = v + 1) begin
            if ((valueCounter[v] >= 1 && valueCounter[v] != 4 && v > kicker && kicker != 4'b0001) || 
            valueCounter[v] >= 1 && valueCounter[v] != 4 && v == 4'b0001) begin
                kicker = v;
            end
            if (valueCounter[v] == 4) begin
                isFOAK = 1'b1;
                highCard = v;
                if (kicker == 4'b0001) begin
                    kicker = 4'b1110; // 14 to represent ace
                end
                if (v == 4'b0001) begin
                    highCard = 4'b1110; // 14 to represent ace
                end
            end
        end
        isProcessDone = 1;
    end
endmodule

