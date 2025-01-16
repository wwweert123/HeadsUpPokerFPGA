`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2024 11:45:05
// Design Name: 
// Module Name: test_randomcards
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


module test_randomcards();
reg clk, btn;
reg reset;
wire [7:0] card1, card2, card3, card4,card5,card6,card7,card8,card9;
wire [3:0] seed;
seedgen y (clk, reset,btn, seed);

wire [3:0] out1;
wire [1:0] out2;

// Instantiate the LFSR module
CombinedLFSR x (
    clk,
    reset,
    seed,
    btn,
    card1,
    card2,
    card3,
    card4,
    card5,
    card6,
    card7,
    card8,
    card9,
    out1,
    out2
);

//reg start1 = 0;
//reg start2 = 0;

//numgen lfsr1(
//    clk,
//    start1,
//    reset,
//    seed[3:0],
//    out1
//);

//suitgen lfsr2(
//    clk,
//    start2,
//    reset,
//    seed[1:0],
//    out2
//);

// Generate clock (50MHz for example)
always begin
    clk = 0; #10; // Low for 10 ns
    clk = 1; #10; // High for 10 ns
end

initial begin
    btn = 1'b0; // Start with the button released
//    start1 = 1;
//    start2 = 1; #50;
//    start1 = 0;
//    start2 = 0; #50;
//    start1 = 1;
//    start2 = 1; #50;
//    reset = 1'b1; #55; // Apply reset
//    reset = 1'b0; // Release reset
    #85; // Wait for 100 ns
    btn = 1'b1; #50; // Press the button
    btn = 1'b0; #1000;

end

endmodule
