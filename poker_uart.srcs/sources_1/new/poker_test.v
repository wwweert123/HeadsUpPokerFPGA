`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2024 11:19:29
// Design Name: 
// Module Name: poker_uart
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


module poker_uart(
    input clk_100MHz,       // basys 3 FPGA clock signal
    input reset,            // btnR    
    input rx,               // USB-RS232 Rx
    
    input call,              // btnL (write FIFO operation)
    input check,             // btnC (write FIFO operation)
    input fold,              // btnD (write FIFO operation)
    input raise,             // btnU (write FIFO operation)
    
    input [5:0] raise_am,    // sw[5:0]
    
    output tx,              // USB-RS232 Tx
    output [3:0] an,        // 7 segment display digits
    output [6:0] seg,       // 7 segment display segments
    output dp,
    output [7:0] LED,        // data byte display
    output [7:0] JC,
    output [7:0] LED2,
    
    input master_sw
    );
    assign dp = 1;
    
    // Connection Signals
    wire rx_full, rx_empty, tx_tick;
    wire [7:0] rec_data, trans_data;
    
    wire en_rx_receive;
    
    // Complete UART Core
    uart_top UART_UNIT
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .read_uart(en_rx_receive),
            .write_uart(tx_tick),
            .rx(rx),
            .write_data(trans_data),
            .rx_full(rx_full),
            .rx_empty(rx_empty),
            .read_data(rec_data),
            .tx(tx)
        );
    
    wire call_tick;
    // Button Debouncer
    debounce_explicit CALL_DEBOUNCER
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(call),         
            .db_level(),  
            .db_tick(call_tick)
        );
        
    wire check_tick;
    // Button Debouncer
    debounce_explicit check_DEBOUNCER
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(check),         
            .db_level(),  
            .db_tick(check_tick)
        );
    
    wire fold_tick;
    // Button Debouncer
    debounce_explicit fold_DEBOUNCER
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(fold),         
            .db_level(),  
            .db_tick(fold_tick)
        );
    
    wire raise_tick;
    // Button Debouncer
    debounce_explicit raise_DEBOUNCER
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(raise),         
            .db_level(),  
            .db_tick(raise_tick)
        );
        
    // assign tx_tick = call_tick | check_tick | raise_tick | fold_tick;
    
    wire rx_fifo_not_empty;
    assign rx_fifo_not_empty = ~rx_empty;
    
    wire [5:0] opponent_raise_value;
    wire [5:0] my_raise_value;
    
    wire [7:0] player_chip; // decided by initial chips, to settle subtract player's pot contribution and add pot total (if win, else just subtract)
    
    wire [7:0] flop1;
    wire [7:0] flop2;
    wire [7:0] flop3;
    wire [7:0] turn;
    wire [7:0] river;
    wire [7:0] hole1;
    wire [7:0] hole2;
    wire [7:0] opp_hole1;
    wire [7:0] opp_hole2;
    
    wire [7:0] opponent_action;
    
//    wire [7:0] opponent_pot_contri;
//    read_rx_to_reg reader
//        (
//            clk_100MHz, 
//            reset,
//            rx_fifo_not_empty,
//            rec_data,
//            my_raise_value,
//            en_rx_receive, 
//            LED, 
//            opponent_pot_contri, 
//            opponent_raise_value,
//            flop1,
//            flop2,
//            flop3,
//            turn,
//            river,
//            hole1,
//            hole2,
//            opp_hole1,
//            opp_hole2,
//            LED2,
//            opponent_action
//        );
    
//    wire [7:0] player_pot_contri;
//    set_tx_data(clk_100MHz, check, call, fold, raise, raise_am, opponent_raise_value, trans_data, player_pot_contri, my_raise_value);
    

//    assign pot_total = player_pot_contri + opponent_pot_contri;
    
    wire [7:0] pot_total;
    wire [7:0] player_current_chips;
    wire [7:0] opponent_current_chips;
//    assign player_current_chips = player_chip - player_pot_contri;

    wire [31:0] game_state;

    wire opp_signal;   
    wire [1:0] win_lose;
    
    game_flow poker
    (
        clk_100MHz,
        reset,
        master_sw,
        rx_fifo_not_empty,
        rec_data,
        en_rx_receive,
        check_tick,
        call_tick,
        fold_tick,
        raise_tick,
        raise_am,
        trans_data,
        game_state,
        flop1,
        flop2,
        flop3,
        turn,
        river,
        hole1,
        hole2,
        opp_hole1,
        opp_hole2,
        opponent_action,
        opponent_raise_value,
        my_raise_value,
        pot_total,
        player_current_chips,
        opponent_current_chips,
        LED,
        LED2,
        tx_tick,
        opp_signal,
        win_lose
    );
        
    
    // Graphics Control
    wire clk_6p25;
    flexible_clk clk6p25Hz (clk_100MHz, 7, clk_6p25);
    wire clk_1k;
    flexible_clk clk1kHz (clk_100MHz, 4999, clk_1k);
       
    anode_display money (clk_100MHz, clk_1k, player_current_chips, an, seg);
       
    wire fb;
    wire sending_pixels;
    wire sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] pixel_data;
       
    Oled_Display oled(
     .clk(clk_6p25), 
     .reset(0), 
     .frame_begin(fb), 
     .sending_pixels(sending_pixels),
     .sample_pixel(sample_pixel),
     .pixel_index(pixel_index), 
     .pixel_data(pixel_data), 
     .cs(JC[0]), 
     .sdin(JC[1]),
     .sclk(JC[3]), 
     .d_cn(JC[4]), 
     .resn(JC[5]), 
     .vccen(JC[6]),
     .pmoden(JC[7])
    );
       
       //init_screen starting (clk, pixel_index, pixel_data);
       //init_animation starting_animation (clk, pixel_index, pixel_data);
       //test testing (clk, pixel_index, pixel_data);
       
    wire [31:0] x;
    wire [31:0] y;
       
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
   
    wire blind;


    assign blind = ~master_sw;
       
    gameboard gameplay 
    (
        clk_100MHz, 
        clk_1k, 
        flop1, 
        flop2, 
        flop3, 
        turn, 
        river, 
        hole1, 
        hole2, 
        opp_hole1, 
        opp_hole2, 
        blind, 
        opponent_action,
        pot_total,
        x, 
        y,
        win_lose,
        opp_signal,
        pixel_data);
endmodule
