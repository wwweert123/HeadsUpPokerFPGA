`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 15:51:00
// Design Name: 
// Module Name: isPairChecker
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


module isPairChecker(
    input [3:0] card1, card2, card3, card4, card5, card6, card7,
    input isPairCheckerStarter,
    output reg isPair,
    output reg [3:0] pairCard,
    output reg [3:0] kicker,
    output reg [3:0] kicker2, kicker3,
    output reg isProcessDone
);

    reg [3:0] valueArray[6:0];
    reg [2:0] valueCounter[15:0]; 
    integer i, v;

    always @(posedge isPairCheckerStarter) begin
        isProcessDone = 0;
        for (v = 0; v < 15; v = v + 1) begin
            valueCounter[v] = 0;
        end
        
        if (card1 == 4'b0001 && card2 == 4'b0001) begin
            valueArray[6] = 4'b1110;
            valueArray[5] = 4'b1110;
            valueArray[0] = card3;
            valueArray[1] = card4;
            valueArray[2] = card5;
            valueArray[3] = card6;
            valueArray[4] = card7;
        end else if (card1 == 4'b0001) begin
            valueArray[6] = 4'b1110;
            valueArray[0] = card2;
            valueArray[1] = card3;
            valueArray[2] = card4;
            valueArray[3] = card5;
            valueArray[4] = card6;
            valueArray[5] = card7;
        end else begin
            valueArray[0] = card1;
            valueArray[1] = card2;
            valueArray[2] = card3;
            valueArray[3] = card4;
            valueArray[4] = card5;
            valueArray[5] = card6;
            valueArray[6] = card7;
        end

        for (i = 0; i < 7; i = i + 1) begin
            valueCounter[valueArray[i]] = valueCounter[valueArray[i]] + 1;
        end

        isPair = 1'b0;
        pairCard = 4'b0000;
        kicker = 4'b0000;
        kicker2 = 4'b0000;
        kicker3 = 4'b0000;
        for (v = 14; v >= 0; v = v - 1) begin
            if (valueCounter[v] == 2) begin
                isPair = 1'b1;
                pairCard = v;
            end else if (valueCounter[v] == 1) begin
                if (kicker == 4'b0000) begin
                    kicker = v;
                end else if (kicker2 == 4'b0000) begin
                    kicker2 = v;
                end else if (kicker3 == 4'b0000) begin
                    kicker3 = v;
                end
            end
        end
        isProcessDone = 1;
    end
endmodule

