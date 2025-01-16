`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 12:14:11
// Design Name: 
// Module Name: set_tx_data
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


module set_tx_data(
    input clk,
    input check,
    input call,
    input fold,
    input raise,
    
    input [5:0] raise_am,
    
    input [5:0] opponent_raise_value,
    
    output reg [7:0] tx_data = 0,
    
    output reg [7:0] player_pot_contri = 0, //accumulation of player's raise, call and blind
    
    output reg [5:0] my_raise_value = 0
    );
    
    parameter CHECK = 8'b01100011;
    parameter FOLD  = 8'b01100110;
    parameter CALL  = 8'b01100001;
    
    parameter TEST  = 8'b11101010;
    
    always @ (posedge clk)
    begin
        if (check)
        begin
            tx_data <= CHECK;
        end
        if (call)
        begin
            tx_data <= CALL;
            player_pot_contri <= player_pot_contri + opponent_raise_value;
        end
        if (fold)
        begin
            tx_data <= FOLD;
        end
        if (raise)
        begin
            tx_data[7:6] <= 2'b01;
            tx_data[5:0] <= raise_am;
            my_raise_value <= raise_am;
            // TODO: add logic to check whether there is sufficient chips
            player_pot_contri <= player_pot_contri + raise_am + opponent_raise_value;
        end
   end
endmodule
