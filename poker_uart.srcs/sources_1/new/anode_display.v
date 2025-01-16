`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2024 14:55:01
// Design Name: 
// Module Name: anode_display
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


module anode_display(
    input clk,
    input clk_1k,
    input [31:0] money,
    output [3:0] an,
    output reg [6:0] seg = 0);
    
    parameter OFF = 7'b1111111;
    parameter ZERO = 7'b1000000;
    parameter ONE = 7'b1111001;
    parameter TWO = 7'b0100100;
    parameter THREE = 7'b0110000;
    parameter FOUR = 7'b0011001;
    parameter FIVE = 7'b0010010;
    parameter SIX = 7'b0000010;
    parameter SEVEN = 7'b1111000;
    parameter EIGHT = 7'b0000000;
    parameter NINE = 7'b0010000;
    
    wire [3:0] first_digit;
    wire [3:0] second_digit;
    wire [3:0] third_digit;
    wire [3:0] fourth_digit;
    
    assign first_digit = money / 1000;
    assign second_digit = (money % 1000) / 100;
    assign third_digit = (money % 100) / 10;
    assign fourth_digit = money % 10;
    
    reg [1:0] state = 0;
    reg [1:0] nextstate = 0;
    
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    parameter an3 = 4'b0111, an2 = 4'b1011, an1 = 4'b1101, an0 = 4'b1110;
    
    always @ (*) begin
        case (state)
            S0: nextstate = S1;
            S1: nextstate = S2;
            S2: nextstate = S3;
            S3: nextstate = S0;
        endcase
    end
    
    always @ (posedge clk_1k) begin
        state <= nextstate;
    end
    
    assign an = (state == S0) ? an3 : (state == S1) ? an2 : (state == S2) ? an1 : an0;
    
    always @ (posedge clk) begin
        if (an == an3) begin
            case (first_digit)
                0: seg = OFF;
                1: seg = ONE;
                2: seg = TWO;
                3: seg = THREE;
                4: seg = FOUR;
                5: seg = FIVE;
                6: seg = SIX;
                7: seg = SEVEN;
                8: seg = EIGHT;
                9: seg = NINE;
            endcase
        end else if (an == an2) begin
            case (second_digit)
                0: seg = (first_digit) ? ZERO : OFF;
                1: seg = ONE;
                2: seg = TWO;
                3: seg = THREE;
                4: seg = FOUR;
                5: seg = FIVE;
                6: seg = SIX;
                7: seg = SEVEN;
                8: seg = EIGHT;
                9: seg = NINE;
            endcase
        end else if (an == an1) begin
            case (third_digit)
                0: seg = (first_digit || second_digit) ? ZERO : OFF;
                1: seg = ONE;
                2: seg = TWO;
                3: seg = THREE;
                4: seg = FOUR;
                5: seg = FIVE;
                6: seg = SIX;
                7: seg = SEVEN;
                8: seg = EIGHT;
                9: seg = NINE;
            endcase
        end else if (an == an0) begin
                case (fourth_digit)
                0: seg = ZERO;
                1: seg = ONE;
                2: seg = TWO;
                3: seg = THREE;
                4: seg = FOUR;
                5: seg = FIVE;
                6: seg = SIX;
                7: seg = SEVEN;
                8: seg = EIGHT;
                9: seg = NINE;
            endcase
        end
    end
    
endmodule
