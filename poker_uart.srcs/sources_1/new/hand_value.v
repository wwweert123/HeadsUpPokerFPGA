`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2024 17:18:58
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


module hand_value(input [7:0]playerHand1, playerHand2, flop1, flop2,
 flop3, turn, river, input moduleCall, output reg [7:0]handValue, output reg [3:0] kicker, kicker2, kicker3,
  kicker4, input CLOCK, output reg isDone = 0, input resetHandValue);

 reg isFlushCheckerStarter;
 reg isStraightFlushCheckerStarter;
 reg isFOAKCheckerStarter;
 reg isFullHouseCheckerStarter;
 reg isStraightCheckerStarter;
 reg isTOAKCheckerStarter;
 reg isTwoPairCheckerStarter;
 reg isPairCheckerStarter;
 reg highCardStarter;
 wire isFullHouse;
 wire isFlush; 
 wire isStraightFlush;
 wire isFOAK;
 wire isStraight;
 wire isTOAK;
 wire isTwoPair;
 wire isPair;
 reg [5:0] sorted_cards[6:0];
 integer i, j, k;
 reg [5:0] temp = 6'b000000;
 reg declaredDone = 0;
 
 wire isStraightFlushDone;
 wire [3:0]StraightFlushHighCard;
  
  isStraightFlushChecker isFlushAndStraightFlushFunction(sorted_cards[0], sorted_cards[1], sorted_cards[2], sorted_cards[3],
  sorted_cards[4], sorted_cards[5], sorted_cards[6], isStraightFlush, isStraightFlushCheckerStarter, StraightFlushHighCard
  , isStraightFlushDone
  );
  
  wire isFOAKDone;
  wire [3:0]FOAKCard;
  wire [3:0]FOAKKicker;
  
      isFOAKChecker isFOAKFunction(
        sorted_cards[0][3:0], sorted_cards[1][3:0], sorted_cards[2][3:0], sorted_cards[3][3:0], sorted_cards[4][3:0], 
        sorted_cards[5][3:0], sorted_cards[6][3:0],
        isFOAKCheckerStarter,
        FOAKCard,
        isFOAK,
        FOAKKicker,
        isFOAKDone
    );
    
    wire isFullHouseDone;
    wire [3:0]FHTOAKCard;
    wire [3:0]FHPairCard;

    isFullHouseChecker isFullHouseFunction(
        sorted_cards[0][3:0], sorted_cards[1][3:0], sorted_cards[2][3:0], sorted_cards[3][3:0], sorted_cards[4][3:0], 
        sorted_cards[5][3:0], sorted_cards[6][3:0],
        isFullHouseCheckerStarter,
        isFullHouse,
        FHTOAKCard,
        FHPairCard,
        isFullHouseDone
    );
    
    wire isFlushDone;
    wire [3:0]flushHighCard;
    
    isFlushChecker isFlushFunction(sorted_cards[0], sorted_cards[1], sorted_cards[2], sorted_cards[3], sorted_cards[4], 
            sorted_cards[5], sorted_cards[6],
            isFlush, isFlushCheckerStarter, flushHighCard,
            isFlushDone
    );
    
    wire isStraightDone;
    wire [3:0] straightHighCard;  
    
    isStraightChecker isStraightFunction( 
        sorted_cards[0][3:0], sorted_cards[1][3:0], sorted_cards[2][3:0], sorted_cards[3][3:0], sorted_cards[4][3:0], 
        sorted_cards[5][3:0], sorted_cards[6][3:0],
        isStraight, isStraightCheckerStarter, straightHighCard,
        isStraightDone
    );
    
    wire isTOAKDone;
    wire [3:0]TOAKCard;
    wire [3:0]TOAKKicker1;
    wire [3:0]TOAKKicker2;
    
    isTOAKChecker isTOAKFunction(
        sorted_cards[0][3:0], sorted_cards[1][3:0], sorted_cards[2][3:0], sorted_cards[3][3:0], sorted_cards[4][3:0], 
        sorted_cards[5][3:0], sorted_cards[6][3:0],
        isTOAKCheckerStarter,
        isTOAK,
        TOAKCard,
        TOAKKicker1, TOAKKicker2,
        isTOAKDone
    );
    
    wire isTwoPairDone;
    wire [3:0]highPairCard;
    wire [3:0] lowPairCard;
    wire [3:0] twoPairKicker;
    
    isTwoPairChecker isTwoPairFunction(
        sorted_cards[0][3:0], sorted_cards[1][3:0], sorted_cards[2][3:0], sorted_cards[3][3:0], sorted_cards[4][3:0], 
        sorted_cards[5][3:0], sorted_cards[6][3:0],
        isTwoPairCheckerStarter,
        isTwoPair,
        highPairCard,
        lowPairCard,
        twoPairKicker,
        isTwoPairDone
    );
    
    wire isPairDone;
    wire [3:0] pairCard;
    wire [3:0] pairKicker;
    wire [3:0] pairKicker2;
    wire [3:0] pairKicker3;
    
    isPairChecker isPairFunction(
        sorted_cards[0][3:0], sorted_cards[1][3:0], sorted_cards[2][3:0], sorted_cards[3][3:0], sorted_cards[4][3:0], 
        sorted_cards[5][3:0], sorted_cards[6][3:0],
        isPairCheckerStarter,
        isPair,
        pairCard,
        pairKicker,
        pairKicker2, pairKicker3,
        isPairDone
    );
    
    wire isHighCardDone;
    wire [3:0] highCard;
    wire [3:0] highCardKicker;
    wire [3:0] highCardKicker2;
    wire [3:0] highCardKicker3;
    wire [3:0] highCardKicker4;
    
    HighCards highCardFunction(
        sorted_cards[0][3:0], sorted_cards[1][3:0], sorted_cards[2][3:0], sorted_cards[3][3:0], sorted_cards[4][3:0], 
        sorted_cards[5][3:0], sorted_cards[6][3:0],
        highCardStarter,
        highCard, highCardKicker, highCardKicker2, highCardKicker3, highCardKicker4,
        isHighCardDone
    );
    
    reg [4:0] state;
    localparam STATE_STRAIGHT_FLUSH_CHECK = 5'b00000,
               STATE_FOAK_CHECK = 5'b00001,
               STATE_FULL_HOUSE_CHECK = 5'b00010,
               STATE_FLUSH_CHECK = 5'b00011,
               STATE_STRAIGHT_CHECK = 5'b00100,
               STATE_TOAK_CHECK = 5'b00101,
               STATE_TWO_PAIR_CHECK = 5'b00110,
               STATE_PAIR_CHECK = 5'b00111,
               STATE_HIGH_CARD_CHECK = 5'b01000,
               STATE_DONE = 5'b01001,
               STATE_INIT = 5'b01010;

// or posedge isStraightFlushDone or posedge isFOAKDone or
//     posedge isFullHouseDone or posedge isFlushDone or posedge isStraightDone or
//      posedge isTOAKDone or posedge isTwoPairDone or posedge isPairDone
//      or posedge isHighCardDone or posedge manualCall
    always @(posedge CLOCK) begin
    if (resetHandValue) begin
        isDone = 0;
         handValue = 8'b00000000;
        isStraightFlushCheckerStarter = 0;
        isFlushCheckerStarter = 0;
        isFOAKCheckerStarter = 0;
        isFullHouseCheckerStarter = 0;
        isStraightCheckerStarter = 0;
        isTOAKCheckerStarter = 0;
        isTwoPairCheckerStarter = 0;
        isPairCheckerStarter = 0;
        highCardStarter = 0;
        kicker = 4'b0000;
        kicker2 = 4'b0000;
        kicker3 = 4'b0000;
        kicker4 = 4'b0000;
    end
       
    if (moduleCall) begin
        isDone = 0;
        sorted_cards[0] = {playerHand1[6:5], playerHand1[3:0]};
        sorted_cards[1] = {playerHand2[6:5], playerHand2[3:0]};
        sorted_cards[2] = {flop1[6:5], flop1[3:0]};
        sorted_cards[3] = {flop2[6:5], flop2[3:0]};
        sorted_cards[4] = {flop3[6:5], flop3[3:0]};
        sorted_cards[5] = {turn[6:5], turn[3:0]};
        sorted_cards[6] = {river[6:5], river[3:0]};    
        
        // bubble sort the cards according to value
        for (i = 0; i < 6; i = i + 1) begin
            for (j = 0; j < 6 - i; j = j + 1) begin
                if (sorted_cards[j][3:0] > sorted_cards[j + 1][3:0]) begin
                    temp = sorted_cards[j];
                    sorted_cards[j] = sorted_cards[j + 1];
                    sorted_cards[j + 1] = temp;
                end
            end
        end
        state = STATE_INIT;
        handValue = 8'b00000000;
        isStraightFlushCheckerStarter = 0;
        isFlushCheckerStarter = 0;
        isFOAKCheckerStarter = 0;
        isFullHouseCheckerStarter = 0;
        isStraightCheckerStarter = 0;
        isTOAKCheckerStarter = 0;
        isTwoPairCheckerStarter = 0;
        isPairCheckerStarter = 0;
        highCardStarter = 0;
        kicker = 4'b0000;
        kicker2 = 4'b0000;
        kicker3 = 4'b0000;
        kicker4 = 4'b0000;
    end
    if (state != STATE_DONE) begin
    case (state)
            STATE_INIT: begin
                handValue = 8'b00000000;
                isStraightFlushCheckerStarter = 0;
                isFlushCheckerStarter = 0;
                isFOAKCheckerStarter = 0;
                isFullHouseCheckerStarter = 0;
                isStraightCheckerStarter = 0;
                isTOAKCheckerStarter = 0;
                isTwoPairCheckerStarter = 0;
                isPairCheckerStarter = 0;
                highCardStarter = 0;
                kicker = 4'b0000;
                kicker2 = 4'b0000;
                kicker3 = 4'b0000;
                kicker4 = 4'b0000;
                isDone = 0;
                isStraightFlushCheckerStarter = 1;
                state = STATE_STRAIGHT_FLUSH_CHECK;
            end
            STATE_STRAIGHT_FLUSH_CHECK: begin
                if (isStraightFlushDone) begin
                    isStraightFlushCheckerStarter = 0;
                    if (isStraightFlush) begin
                        handValue = {4'b1001, StraightFlushHighCard};
                        state = STATE_DONE;
                    end else begin
                        state = STATE_FOAK_CHECK;
                        isFOAKCheckerStarter = 1;
                    end
                end
            end
            STATE_FOAK_CHECK: begin
                if (isFOAKDone) begin
                    isFOAKCheckerStarter = 0;
                    if (isFOAK) begin
                        handValue = {4'b1000, FOAKCard};
                        kicker = FOAKKicker;
                        state = STATE_DONE;
                    end else begin
                        state = STATE_FULL_HOUSE_CHECK;
                        isFullHouseCheckerStarter = 1;
                    end
                end
            end
            STATE_FULL_HOUSE_CHECK: begin
                if (isFullHouseDone) begin
                    isFullHouseCheckerStarter = 0;
                    if (isFullHouse) begin
                        handValue = {4'b0111, FHTOAKCard};
                        kicker = FHPairCard;
                        state = STATE_DONE;
                    end else begin
                        state = STATE_FLUSH_CHECK;
                        isFlushCheckerStarter = 1;
                    end
                end
            end
            STATE_FLUSH_CHECK: begin
                if (isFlushDone) begin
                    isFlushCheckerStarter = 0;
                    if (isFlush) begin
                        handValue = {4'b0110, flushHighCard};
                        state = STATE_DONE;
                    end else begin
                        state = STATE_STRAIGHT_CHECK;
                        isStraightCheckerStarter = 1;
                    end
                end
            end
            STATE_STRAIGHT_CHECK: begin
                if (isStraightDone) begin
                    isStraightCheckerStarter = 0;
                    if (isStraight) begin
                        handValue = {4'b0101, straightHighCard};
                        state = STATE_DONE;
                    end else begin
                        state = STATE_TOAK_CHECK;
                        isTOAKCheckerStarter = 1;
                    end
                end
            end
            STATE_TOAK_CHECK: begin
                if (isTOAKDone) begin
                    isTOAKCheckerStarter = 0;
                    if (isTOAK) begin
                        handValue = {4'b0100, TOAKCard};
                        kicker = TOAKKicker1;
                        kicker2 = TOAKKicker2;
                        state = STATE_DONE;
                    end else begin
                        state = STATE_TWO_PAIR_CHECK;
                        isTwoPairCheckerStarter = 1;
                    end
                end
            end
            STATE_TWO_PAIR_CHECK: begin
                if (isTwoPairDone) begin
                    isTwoPairCheckerStarter = 0;
                    if (isTwoPair) begin
                        handValue = {4'b0011, highPairCard};
                        kicker = lowPairCard;
                        kicker2 = twoPairKicker;
                        state = STATE_DONE;
                    end else begin
                        state = STATE_PAIR_CHECK;
                        isPairCheckerStarter = 1;
                    end
                end
            end
            STATE_PAIR_CHECK: begin
                if (isPairDone) begin
                    isPairCheckerStarter = 0;
                    if (isPair) begin
                        handValue = {4'b0010, pairCard};
                        kicker = pairKicker;
                        kicker2 = pairKicker2;
                        kicker3 = pairKicker3;
                        state = STATE_DONE;
                    end else begin
                        state = STATE_HIGH_CARD_CHECK;
                        highCardStarter = 1;
                    end
                end
            end
            STATE_HIGH_CARD_CHECK: begin
                if (isHighCardDone) begin
                    highCardStarter = 0;
                    handValue = {4'b0001, highCard};
                    kicker = highCardKicker;
                    kicker2 = highCardKicker2;
                    kicker3 = highCardKicker3;
                    kicker4 = highCardKicker4;
                    state = STATE_DONE;
                end
            end
            default: begin
            end
        endcase
    end 
    if (state == STATE_DONE) begin
        isDone = 1;
    end

end
endmodule
