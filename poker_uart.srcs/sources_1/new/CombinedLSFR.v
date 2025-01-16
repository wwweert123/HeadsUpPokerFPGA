`timescale 1ns / 1ps

module CombinedLFSR(
    input wire clk,
    input wire reset,
    input wire [3:0] seed,
    input wire btn,
    output reg [7:0] card1 = 0,
    output reg [7:0] card2 = 0,
    output reg [7:0] card3 = 0,
    output reg [7:0] card4 = 0,
    output reg [7:0] card5 = 0,
    output reg [7:0] card6 = 0,
    output reg [7:0] card7 = 0,
    output reg [7:0] card8 = 0,
    output reg [7:0] card9 = 0,
    output [3:0] out1,
    output [1:0] out2
);

wire slowed_clk;
flexible_clk cc(clk, 0 ,slowed_clk);

reg [4:0] state = 0;
reg [4:0] nextState = 0;

// Outputs from LFSRs
//wire [1:0] out1;
//wire [3:0] out2;

// Control signals for LFSRs
reg start1 = 0, start2 = 0;
reg enable = 0;

// Instantiate the LFSRs
numgen lfsr1(
    .clk(clk),
    .start(start1),
    .reset(reset),
    .seed(seed[3:0]),
    .out(out1)
);

suitgen lfsr2(
    .clk(clk),
    .start(start2),
    .reset(reset),
    .seed(seed[1:0]),
    .out(out2)
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        enable <= 0;
    end else if (btn) begin
        enable <= 1;
    end
end

always @(posedge slowed_clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        start1 <= 0;
        start2 <= 0;
        card1 <= 0; card2 <= 0; card3 <= 0; card4 <= 0;
        card5 <= 0; card6 <= 0; card7 <= 0; card8 <= 0; card9 <= 0;
    end else begin
        case (state)
            0: if (~btn && enable) nextState = 1;// Button pressed, initiate sequence
            // Activate LFSRs
            1, 3, 5, 7, 9, 11, 13, 15, 17: begin
                start1 <= 1; // Signal to generate next LFSR output
                start2 <= 1;
                nextState = state + 1;
            end
            // Deactivate LFSRs and capture outputs for each card
            2: begin card1 <= {1'b1, out2, 1'b0, out1}; start1 <= 0; start2 <= 0; nextState = state + 1; end
            4: begin card2 <= {1'b1, out2, 1'b0, out1}; start1 <= 0; start2 <= 0; nextState = state + 1; end
            6: begin card3 <= {1'b1, out2, 1'b0, out1}; start1 <= 0; start2 <= 0; nextState = state + 1; end
            8: begin card4 <= {1'b1, out2, 1'b0, out1}; start1 <= 0; start2 <= 0; nextState = state + 1; end
            10: begin card5 <= {1'b1, out2, 1'b0, out1}; start1 <= 0; start2 <= 0; nextState = state + 1; end
            12: begin card6 <= {1'b1, out2, 1'b0, out1}; start1 <= 0; start2 <= 0; nextState = state + 1; end
            14: begin card7 <= {1'b1, out2, 1'b0, out1}; start1 <= 0; start2 <= 0; nextState = state + 1; end
            16: begin card8 <= {1'b1, out2, 1'b0, out1}; start1 <= 0; start2 <= 0; nextState = state + 1; end
            18: begin
                card9 <= {1'b1, out2, 1'b0, out1};
                start1 <= 0; // Reset LFSRs
                start2 <= 0;
                nextState = 0; // Reset state for potential next button press
            end
            default: nextState <= 0;
        endcase
        if (nextState != state) state <= nextState;
    end
end


endmodule
