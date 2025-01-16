`timescale 1ns / 1ps

module seedgen(
    input wire clk,         // Clock signal
    input wire reset,       // Reset signal
    input wire btnC,        // Button input signal (active high)
    output reg [3:0] seed  // Seed output, width depends on expected press duration
);
wire [7:0] count;
CircularCounter cc(clk, reset, count);

always @(posedge clk) begin
    if (reset) begin
        seed <= 0; // Reset seed
    end else if (btnC) begin
        seed = count[5:2];
    end
end
endmodule