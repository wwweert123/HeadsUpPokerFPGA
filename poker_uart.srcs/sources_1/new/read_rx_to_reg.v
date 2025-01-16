`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 10:43:38
// Design Name: 
// Module Name: read_rx_to_reg
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


module read_rx_to_reg(
    input clk,
    input reset,
    
    input rx_fifo_not_empty, //signal to tell if there is data in the FIFO
    
    input [7:0] receive_data, // data that the read pointer in the RX FIFO is pointing to
    
    input [5:0] my_raise_value,
    
    output reg en_read_rx_fifo, // signal to the RX FIFO to move to the next pointer
    
    output reg [7:0] value = 0, // placeholder to receive the 8 bit data
    
    output reg [7:0] opponent_pot_contri = 0, // accumulation of opponents raise and small blind and call
    
    output reg [5:0] opponent_raise_value,
    
    output [7:0] flop1,
    output [7:0] flop2,
    output [7:0] flop3,
    output [7:0] turn,
    output [7:0] river,
    output [7:0] hole1,
    output [7:0] hole2,
    output [7:0] opp_hole1,
    output [7:0] opp_hole2,
    
    output [7:0] LED2,
    
    output reg [7:0] opponent_action = 0
    );
    
    parameter CHECK = 8'b00010000;
    parameter CHECK_TEST = 8'b01100011;
    parameter FOLD  = 8'b00100000;
    parameter CALL  = 2'b01; // remaining 6 bits is raise value
        
    parameter WIN   = 8'b11111111;
    parameter LOSE  = 8'b00000001;
    
    reg [7:0] cards [8:0];

    reg [3:0] num_received = 0;
    
    reg [7:0] current_action = 0;
    
    reg dont_read = 0;
    
//    wire half_clk;
//    flexible_clk half_clk_module(clk, 0, half_clk);
    
    always @ (posedge clk)
    begin
        if (reset)
        begin
            cards[0] = 0;
            cards[1] = 0;
            cards[2] = 0;
            cards[3] = 0;
            cards[4] = 0;
            cards[5] = 0;
            cards[6] = 0;
            num_received = 0;
        end
        
        if (en_read_rx_fifo == 1)
        begin
            dont_read = 1;
        end
        
        en_read_rx_fifo = 0;
        
        if (rx_fifo_not_empty && dont_read == 0)
        begin
            // Receive card
            if (num_received < 9 && receive_data[7] == 1) // Check if it is a card
            begin
                cards[num_received] = receive_data;
                num_received = num_received + 1;
            end
            
            // check if is raise or call, if it is call, bits 5 to 0 would be 0 in value
            if (receive_data[7:6] == 2'b01)
            begin
                opponent_pot_contri = opponent_pot_contri + receive_data[5:0] + my_raise_value;
                opponent_raise_value = receive_data[5:0];
                if (receive_data[5:0] == 0)
                begin
                    opponent_action = 8'b01000000;
                end
                else
                begin
                    opponent_action = {CALL, receive_data[5:0]};
                end
            end
            
            // If it is check
            if (receive_data == CHECK_TEST)
            begin
                opponent_action = CHECK;
            end
            
            // If it is fold
            if (receive_data == FOLD)
            begin
                opponent_action = FOLD;
            end
            
            value = receive_data;
            en_read_rx_fifo = 1;
        end
        dont_read = 0;
    end
    
    assign hole1  = cards[2];
    assign hole2  = cards[3];
    
    assign opp_hole1 = cards[0];
    assign opp_hole2 = cards[1];
    
    assign flop1  = cards[4];
    assign flop2  = cards[5];
    assign flop3  = cards[6];
    assign turn   = cards[7];
    assign river  = cards[8];
    
    assign LED2[3:0] = num_received;
endmodule
