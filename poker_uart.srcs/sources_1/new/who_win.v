`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2024 21:41:39
// Design Name: 
// Module Name: who_win
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


module who_win(
    input [7:0] playerHand1, playerHand2, flop1, flop2, flop3, turn, river,
    oppHand1, oppHand2,
    input callWhoWin,
    output reg [1:0]result, // 10 if player win, 01 if opp win, 11 if chop pot (draw)
    input CLOCK,
    output reg isCheckDone = 0,
    output reg [3:0]where = 4'b0000
//    output reg [1:0]state = 2'b00
    );
    
    wire [7:0]playerHandValue, oppHandValue;
    wire [3:0]playerKicker, playerKicker2, playerKicker3, playerKicker4;
    wire [3:0]oppKicker, oppKicker2, oppKicker3, oppKicker4;
    wire isPlayerDone, isOppDone;
    reg moduleCall = 0;
    reg oppModuleCall = 0;
    integer i;
    reg resetHandValue = 0;
    reg isCallWinCalled = 0;
    
    hand_value playerHandValueFunction(playerHand1, playerHand2, flop1, flop2, flop3, turn, river,
    moduleCall, 
    playerHandValue,
    playerKicker, playerKicker2, playerKicker3, playerKicker4, 
    CLOCK,
    isPlayerDone,
    resetHandValue
    );
    
    hand_value oppHandValueFunction (oppHand1, oppHand2, flop1, flop2, flop3, turn, river,
    oppModuleCall,
    oppHandValue,
    oppKicker, oppKicker2, oppKicker3, oppKicker4,
    CLOCK,
    isOppDone,
    resetHandValue
    );
    
    reg [1:0] state = 2'b00;
    localparam STATE_BEGIN_CHECK = 0,
               STATE_CHECKING = 1,
               STATE_FINISH_BOTH_CHECK = 2,
               STATE_COMPLETE = 3;
    
    always @ (posedge CLOCK) begin
    if (callWhoWin && state == STATE_COMPLETE) begin
        state = STATE_BEGIN_CHECK;
        isCheckDone = 0;
        resetHandValue = 0;
        end
    if (callWhoWin) begin
        isCallWinCalled = 1;
    end
    if (isCallWinCalled == 1) begin
        case (state) 
            STATE_BEGIN_CHECK: begin
            where = 1;
                isCheckDone = 0;
                result = 2'b00;
                moduleCall = 1;
                oppModuleCall = 1;
                state = STATE_CHECKING;
            end
            STATE_CHECKING: begin
            where = 2;
                moduleCall = 0;
                oppModuleCall = 0;
                if (isPlayerDone && isOppDone && 
                playerHandValue != 8'b00000000 && oppHandValue != 8'b00000000) begin
                    state = STATE_FINISH_BOTH_CHECK;
                end
            end
            STATE_FINISH_BOTH_CHECK: begin
                if (playerHandValue[7:4] > oppHandValue[7:4]) begin
                where = 3;
                    result = 2'b10;
                    state = STATE_COMPLETE;
                end else if (playerHandValue[7:4] < oppHandValue[7:4]) begin
                where = 4;
                    result = 2'b01;
                    state = STATE_COMPLETE;
                end else if (playerHandValue[7:4] == oppHandValue[7:4]) begin
                where = 5;
                    if (playerHandValue[3:0] > oppHandValue[3:0]) begin
                        result = 2'b10;
                        state = STATE_COMPLETE;
                    end else if (playerHandValue[3:0] < oppHandValue[3:0]) begin
                        result = 2'b01;
                        state = STATE_COMPLETE;
                    end else begin
                        if (playerKicker && oppKicker != 4'b0000 && state != STATE_COMPLETE) begin
                        // where = 1;
                            if (playerKicker > oppKicker) begin
                                result = 2'b10;
                                state = STATE_COMPLETE;
                                // where  = 2;
                            end else if (playerKicker < oppKicker) begin
                                result = 2'b01;
                                state = STATE_COMPLETE;
                                // where = 3;
                            end
                        end
                        if (playerKicker2 && oppKicker2 != 4'b0000 && state != STATE_COMPLETE) begin
                            if (playerKicker2 > oppKicker2) begin
                                result = 2'b10;
                                state = STATE_COMPLETE;
                            end else if (playerKicker2 < oppKicker2) begin
                                result = 2'b01;
                                state = STATE_COMPLETE;
                            end
                        end
                        if (playerKicker3 && oppKicker3 != 4'b0000  && state != STATE_COMPLETE) begin
                            if (playerKicker3 > oppKicker3) begin
                                result = 2'b10;
                                state = STATE_COMPLETE;
                            end else if (playerKicker3 < oppKicker3) begin
                                result = 2'b01;
                                state = STATE_COMPLETE;
                            end
                        end
                        if (playerKicker4 && oppKicker4 != 4'b0000 && state != STATE_COMPLETE) begin
                            if (playerKicker4 > oppKicker4) begin
                                result = 2'b10;
                                state = STATE_COMPLETE;
                            end else if (playerKicker4 < oppKicker4) begin
                                result = 2'b01;
                                state = STATE_COMPLETE;
                            end
                        end else if (state != STATE_COMPLETE) begin
                            result = 2'b11;
                            state = STATE_COMPLETE;
                        end
                    end
                end
            end
            STATE_COMPLETE: begin
                isCheckDone = 1;
                resetHandValue = 1;
                isCallWinCalled = 0;
            end
        endcase
    end
    end
endmodule