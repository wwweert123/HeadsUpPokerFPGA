`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 19:55:01
// Design Name: 
// Module Name: game_flow
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


module game_flow(
    input clk,
    input reset,
    input is_master,
    
    // rx stuff
    input rx_fifo_not_empty, //signal to tell if there is data in the FIFO
    input [7:0] receive_data, // data that the read pointer in the RX FIFO is pointing to
    output reg en_read_rx_fifo, // signal to the RX FIFO to move to the next pointer
    
    // tx stuff
    input check, // used for transmitting cards as well 
    input call,
    input fold,
    input raise,
    input [5:0] raise_am,
    
    output reg [7:0] tx_data = 0, // send to tx fifo
    
    output reg [31:0] game_state = 1,
    
    // cards
    output reg [7:0] flop1 = 0,
    output reg [7:0] flop2 = 0,
    output reg [7:0] flop3 = 0,
    output reg [7:0] turn = 0,
    output reg [7:0] river = 0,
    output reg [7:0] hole1 = 0,
    output reg [7:0] hole2 = 0,
    output reg [7:0] opp_hole1 = 0,
    output reg [7:0] opp_hole2 = 0,
    
    output reg [7:0] opponent_action = 0,
    
    // for calculating opponent contribution to pot
    output reg [5:0] opponent_raise_value = 0, // last raise value of opponent
    
    // for calculating own contribution to pot
    output reg [5:0] my_raise_value = 0,

    // pot amount
    output reg [7:0] total_pot = 0,
    
    // player current chips
    output reg [7:0] player_current_chips = 31,
    
    // opponent current chips
    output reg [7:0] opponent_current_chips = 31,
    
    output reg [7:0] LED,
    
    output [7:0] LED2,
    
    output reg tx_tick = 0,
    
    output reg opp_signal = 0,
    
    output reg [1:0] win_lose = 2'b00
    );
    


    parameter INITIAL = 1;
    parameter DEAL_OWN_CARDS = 2;
    parameter DEAL_SLAVE_CARDS = 3;
    parameter MASTER_PRE_FLOP_ACTION = 4;
    parameter SLAVE_PRE_FLOP_ACTION = 5;
    parameter MASTER_DEAL_FLOP = 6;
    parameter MASTER_SECOND_ACTION = 7;
    parameter SLAVE_SECOND_ACTION = 8;
    parameter MASTER_DEAL_TURN = 9;
    parameter MASTER_THIRD_ACTION = 10;
    parameter SLAVE_THIRD_ACTION = 11;
    parameter MASTER_DEAL_RIVER = 12;
    parameter MASTER_FOURTH_ACTION = 13;
    parameter SLAVE_FOURTH_ACTION = 14;
    parameter MASTER_SETTLE_POT = 15;
    parameter SHOW_OPP_CARD = 16;
    parameter WIN_SCREEN = 17;
    parameter LOSE_SCREEN = 18;
    
    parameter CHECK = 8'b00010000;
    parameter CHECK_TEST = 8'b01100011;
    parameter FOLD  = 8'b00100000;
    parameter CALL  = 2'b01; // remaining 6 bits is raise value
        
    parameter WIN   = 8'b11111111;
    parameter LOSE  = 8'b00000001;
    parameter SPLIT = 8'b00000011;
    
    reg [1:0] win_status = 0; // 0 for undecided, 1 for win, 2 for lose, 3 for split
    
    reg dont_read = 0;
    
//    reg [7:0] fake_card_1 = 8'b10000001;
//    reg [7:0] fake_card_2 = 8'b10000010;
//    reg [7:0] fake_card_3 = 8'b10000011;
//    reg [7:0] fake_card_4 = 8'b10000100;
//    reg [7:0] fake_card_5 = 8'b10000101;
//    reg [7:0] fake_card_6 = 8'b10000110;
//    reg [7:0] fake_card_7 = 8'b10000111;
//    reg [7:0] fake_card_8 = 8'b10001000;
//    reg [7:0] fake_card_9 = 8'b10001001;
      
      reg [7:0] gl_oppHand1 = 8'b11101010; // Player's first card
      reg [7:0] gl_oppHand2 = 8'b10001011; // Player's second card
      reg [7:0] gl_playerHand1 = 8'b11001001; // Opponent's first card
      reg [7:0] gl_playerHand2 = 8'b10100010; // Opponent's second card
      reg [7:0] gl_flop1 = 8'b10000011; // Flop card 1
      reg [7:0] gl_flop2 = 8'b10001001; // Flop card 2
      reg [7:0] gl_flop3 = 8'b10100010; // Flop card 3
      reg [7:0] gl_turn = 8'b11100011; // Turn card
      reg [7:0] gl_river = 8'b11100001; // River card

    reg [7:0] fake_card_1 = 8'b10000001;
    reg [7:0] fake_card_2 = 8'b10100001;
    reg [7:0] fake_card_3 = 8'b10001000;
    reg [7:0] fake_card_4 = 8'b10100100;
    reg [7:0] fake_card_5 = 8'b10000111;
    reg [7:0] fake_card_6 = 8'b11000011;
    reg [7:0] fake_card_7 = 8'b10100101;
    reg [7:0] fake_card_8 = 8'b10001000;
    reg [7:0] fake_card_9 = 8'b10001001;
    
    wire [7:0] hflop1;
    wire [7:0] hflop2;
    wire [7:0] hflop3;
    wire [7:0] hturn;
    wire [7:0] hriver;
    wire [7:0] hhole1;
    wire [7:0] hhole2;
    wire [7:0] hopp_hole1;
    wire [7:0] hopp_hole2;
    
    //seed that will be used to generate random cards
    wire [3:0] seed = 4'b0000;
        
    //reset the rng
    reg reset_rng;
    
    reg [1:0] wait_callWhoWin = 0;
    // reg generate_cards_signal = 0;
    
    //RNG module for generating cards
    CombinedLFSR rng (
    clk,
    reset_rng,
    seed,
    check,
    hflop1,
    hflop2,
    hflop3,
    hturn,
    hriver,
    hhole1,
    hhole2,
    hopp_hole1,
    hopp_hole2,
    );
    
    //generates seed when btn is pressed
    seedgen gen(
    clk,
    reset_rng,
    check,
    seed
    );
    
        // Winning Logic
    reg callWhoWin;
    wire [1:0] result;
    wire isCheckDone;
    
    who_win(hole1, hole2, flop1, flop2, flop3, turn, river,
        opp_hole1, opp_hole2,
        callWhoWin,
        result, // 10 if player win, 01 if opp win, 11 if chop pot (draw)
        clk,
        isCheckDone
        );
    
    reg [3:0] num_cards_dealt = 0;
    
    reg calledWinningLogic = 0;
    
    always @ (posedge clk)
    begin
        // tx_data <= 8'b00000000;
        // prevent multiple reads with one rx
        if (en_read_rx_fifo == 1)
        begin
            dont_read = 1;
        end
        en_read_rx_fifo = 0; // dont read again, only for 1 clock cycle
        
        tx_tick = 0;
        
        // callWhoWin = 0;
        
        // generate_cards_signal = 0;
        
        if (is_master)
        begin
            case (game_state)
                INITIAL:
                begin
                    if (wait_callWhoWin > 0)
                    begin
                        wait_callWhoWin = 0;
                    end
                    if (player_current_chips < 2)
                    begin
                        game_state <= LOSE_SCREEN;
                    end
                    if (opponent_current_chips < 2)
                    begin
                        game_state <= WIN_SCREEN;
                    end
                    
                    if (check)
                    begin
                        opponent_action = 8'b00000000;
                        tx_data = CHECK; // start signal  
                        tx_tick = 1; 
                        
                        // clear cards and num_cards dealt
                        flop1 = 0;
                        flop2 = 0;
                        flop3 = 0;
                        turn = 0;
                        river = 0;
                        hole1 = 0;
                        hole2 = 0;
                        opp_hole1 = 0;
                        opp_hole2 = 0;
                        num_cards_dealt = 0;
                        
                        LED = 0; // off the winning logic result
                        
                        opp_signal = 0;
                        
                        // generate_cards_signal = 1; // generate cards based on rng
                        
                        // winning logic
                        calledWinningLogic = 0;
                        
                        // dont need do update player balance, settle at the end
                        total_pot = 3; // small blind 1 big blind 1, 2 + 1 = 3          
                        opponent_raise_value = 1; // opponent is big blind raise value = 2 - 1
                        win_status = 0;
                        
                        // update chip count for player and opponent
                        player_current_chips <= player_current_chips - 1; // master is always small blind
                        opponent_current_chips <= opponent_current_chips - 2; // slave is always big blind
                        game_state <= DEAL_OWN_CARDS;
                    end
                end
                DEAL_OWN_CARDS:
                begin
                    // use rng to deal own cards, tx to slave, check button to tx
                    if (check)
                    begin
                        case (num_cards_dealt)
                            0:
                            begin
                                hole1 = hhole1;
                                // hole1 = gl_playerHand1;
                                num_cards_dealt = 1;
                                tx_data = hhole1; // tx card 
                                // tx_data = hhole1; 
                                tx_tick = 1; 
                            end
                            1:
                            begin
                                hole2 = hhole2;
                                // hole2 = gl_playerHand2;
                                num_cards_dealt = 2;
                                tx_data = hhole2; // tx card
                                tx_tick = 1;
                            end
                        endcase
                    end
                    if (num_cards_dealt == 2)
                    begin
                        game_state <= DEAL_SLAVE_CARDS;
                    end
                end
                DEAL_SLAVE_CARDS:
                begin
                    // use rng to deal slave cards, tx to slave
                    if (check)
                    begin
                        case (num_cards_dealt)
                            2:
                            begin
                                opp_hole1 = hopp_hole1;
                                // opp_hole1 = gl_oppHand1;
                                num_cards_dealt = 3;
                                tx_data = hopp_hole1; // tx card 
                                tx_tick = 1; 
                            end
                            3:
                            begin
                                opp_hole2 = hopp_hole2;
                                // opp_hole2 = gl_oppHand2;
                                num_cards_dealt = 4;
                                tx_data = hopp_hole2; // tx card
                                tx_tick = 1;
                            end
                        endcase
                    end
                    if (num_cards_dealt == 4)
                    begin
                        game_state <= MASTER_PRE_FLOP_ACTION;
                    end
                end
                MASTER_PRE_FLOP_ACTION:
                begin
                    // opponent_action = 8'b00000000; // clear here
                    // master action to call, raise or fold
                    // tx action to slave
                    // cannot check in this turn
                    if (call)
                    begin
                        tx_data = 8'b01000000;
                        tx_tick = 1;
                        total_pot = total_pot + opponent_raise_value;
                        player_current_chips = player_current_chips - opponent_raise_value;
                        
                        if (total_pot == 4)
                        begin
                            game_state = SLAVE_PRE_FLOP_ACTION;
                        end
                        else
                        begin
                            game_state = MASTER_DEAL_FLOP;
                        end
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (fold)
                    begin
                        tx_data = FOLD;
                        tx_tick = 1;
                        win_status = 2; // master loses
                        game_state = MASTER_SETTLE_POT;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (raise)
                    begin
                        if (raise_am + opponent_raise_value <= player_current_chips && raise_am <= opponent_current_chips)
                        begin
                            tx_data[7:6] = 2'b01;
                            tx_data[5:0] = raise_am;
                            tx_tick = 1;
                            my_raise_value = raise_am;
                            // TODO: add logic to check whether there is sufficient chips
                            total_pot = total_pot + raise_am + opponent_raise_value;
                            player_current_chips = player_current_chips - raise_am - opponent_raise_value;
                            
                            game_state = SLAVE_PRE_FLOP_ACTION;
                            opponent_action = 8'b00000000; // clear here
                        end
                    end
                end
                SLAVE_PRE_FLOP_ACTION:
                begin
                    // await slave action
                    // if action is raise, goes back to master pre flop action state 
                    if (rx_fifo_not_empty  && dont_read == 0)
                    begin
                        // check if is raise or call, if it is call, bits 5 to 0 would be 0 in value
                        if (receive_data[7:6] == 2'b01 && receive_data[5:0] > 0) // raise action
                        begin
                            total_pot <= total_pot + receive_data[5:0] + my_raise_value;
                            opponent_current_chips = opponent_current_chips - receive_data[5:0] - my_raise_value;
                            
                            opponent_raise_value = receive_data[5:0];
                            // opponent_action = {CALL, receive_data[5:0]};
                            opponent_action[7:6] = CALL;
                            opponent_action[5:0] = receive_data[5:0]; 
                            game_state = MASTER_PRE_FLOP_ACTION;
                        end
                        
                        if (receive_data == 8'b01000000 && my_raise_value > 0) // only allow call if we have raise beforehand
                        begin
                            total_pot <= total_pot + my_raise_value;
                            opponent_current_chips = opponent_current_chips - my_raise_value;
                            opponent_action = 8'b01000000;
                            opponent_raise_value = 8'b00000000;
                            game_state = MASTER_DEAL_FLOP;
                        end
                        
                        // If it is check
                        if (receive_data == CHECK  && my_raise_value == 0) // only allow if there is no raise value
                        begin
                            opponent_action = CHECK;
                            game_state <= MASTER_DEAL_FLOP;
                        end
                        
                        // If it is fold
                        if (receive_data == FOLD)
                        begin
                            opponent_action = FOLD;
                            win_status <= 1; // master win
                            game_state <= MASTER_SETTLE_POT;
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                MASTER_DEAL_FLOP:
                begin
                    // opponent_action = 8'b00000000; // clear here
                    // use rng to deal 3 flop cards, tx to slave
                    // opponent_action = 8'b00000000; Dont clear here
                    opponent_raise_value = 8'b00000000;
                    my_raise_value = 8'b00000000;
                    if (check)
                    begin
                        case (num_cards_dealt)
                            4:
                            begin
                                flop1 = hflop1;
                                // flop1 = gl_flop1;
                                num_cards_dealt = 5;
                                tx_data = hflop1; // tx card 
                                tx_tick = 1; 
                            end
                            5:
                            begin
                                flop2 = hflop2;
                                // flop2 = gl_flop2;
                                num_cards_dealt = 6;
                                tx_data = hflop2; // tx card
                                tx_tick = 1;
                            end
                            6:
                            begin
                                flop3 = hflop3;
                                // flop3 = gl_flop3;
                                num_cards_dealt = 7;
                                tx_data = hflop3; // tx card
                                tx_tick = 1;
                            end
                        endcase
                    end
                    if (num_cards_dealt == 7)
                    begin
                        game_state <= MASTER_SECOND_ACTION;
                    end
                end
                MASTER_SECOND_ACTION:
                begin
                    // master action to check, raise or fold
                    // tx action to slave
                    if (check && opponent_raise_value == 0)
                    begin
                        tx_data <= CHECK;
                        tx_tick = 1;
                        game_state <= SLAVE_SECOND_ACTION;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (call && opponent_raise_value > 0)
                    begin
                        tx_data <= 8'b01000000;
                        tx_tick = 1;
                        total_pot <= total_pot + opponent_raise_value;
                        player_current_chips <= player_current_chips - opponent_raise_value;
                        
                        game_state <= MASTER_DEAL_TURN;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (fold)
                    begin
                        tx_data <= FOLD;
                        tx_tick = 1;
                        win_status <= 2; // master loses
                        game_state <= MASTER_SETTLE_POT;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (raise)
                    begin
                        if (raise_am + opponent_raise_value <= player_current_chips && raise_am <= opponent_current_chips)
                        begin
                            tx_data[7:6] <= 2'b01;
                            tx_data[5:0] <= raise_am;
                            tx_tick = 1;
                            my_raise_value <= raise_am;
                            // TODO: add logic to check whether there is sufficient chips
                            total_pot <= total_pot + raise_am + opponent_raise_value;
                            player_current_chips <= player_current_chips - raise_am - opponent_raise_value;
                            
                            game_state <= SLAVE_SECOND_ACTION;
                            opponent_action = 8'b00000000; // clear here
                        end

                    end
                end
                SLAVE_SECOND_ACTION:
                begin
                    // await slave action
                    // if action is raise, goes back to master second action state
                    if (rx_fifo_not_empty  && dont_read == 0)
                    begin
                        // check if is raise or call, if it is call, bits 5 to 0 would be 0 in value
                        if (receive_data[7:6] == 2'b01 && receive_data[5:0] > 0) // raise action
                        begin
                            total_pot <= total_pot + receive_data[5:0] + my_raise_value;
                            opponent_current_chips = opponent_current_chips - receive_data[5:0] - my_raise_value;
                            
                            opponent_raise_value = receive_data[5:0];
                            // opponent_action = {CALL, receive_data[5:0]};
                            opponent_action[7:6] = CALL;
                            opponent_action[5:0] = receive_data[5:0]; 
                            game_state = MASTER_SECOND_ACTION;
                        end
                        
                        if (receive_data == 8'b01000000 && my_raise_value > 0) // only allow call if we have raise beforehand
                        begin
                            total_pot <= total_pot + my_raise_value;
                            opponent_current_chips = opponent_current_chips - my_raise_value;
                            opponent_action = 8'b01000000;
                            opponent_raise_value = 8'b00000000;
                            game_state = MASTER_DEAL_TURN;
                        end
                        
                        // If it is check
                        if (receive_data == CHECK  && my_raise_value == 0) // only allow if there is no raise value
                        begin
                            opponent_action = CHECK;
                            game_state <= MASTER_DEAL_TURN;
                        end
                        
                        // If it is fold
                        if (receive_data == FOLD)
                        begin
                            opponent_action = FOLD;
                            win_status <= 1; // master win
                            game_state <= MASTER_SETTLE_POT;
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                MASTER_DEAL_TURN:
                begin
                    // use rng to deal turn card, tx to slave
                    // opponent_action = 8'b00000000; Dont clear here
                    // opponent_action = 8'b00000000; // clear here
                    opponent_raise_value = 8'b00000000;
                    my_raise_value = 8'b00000000;
                    if (check)
                    begin
                        case (num_cards_dealt)
                            7:
                            begin
                                turn = hturn;
                                // turn = gl_turn;
                                num_cards_dealt = 8;
                                tx_data = hturn; // tx card 
                                tx_tick = 1; 
                            end
                        endcase
                    end
                    if (num_cards_dealt == 8)
                    begin
                        game_state <= MASTER_THIRD_ACTION;
                    end
                end
                MASTER_THIRD_ACTION:
                begin
                    // master action to check, raise or fold
                    // tx action to slave
                    if (check && opponent_raise_value == 0)
                    begin
                        tx_data <= CHECK;
                        tx_tick = 1;
                        game_state <= SLAVE_THIRD_ACTION;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (call && opponent_raise_value > 0)
                    begin
                        tx_data <= 8'b01000000;
                        tx_tick = 1;
                        total_pot <= total_pot + opponent_raise_value;
                        player_current_chips <= player_current_chips - opponent_raise_value;
                        
                        game_state <= MASTER_DEAL_RIVER;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (fold)
                    begin
                        tx_data <= FOLD;
                        tx_tick = 1;
                        win_status <= 2; // master loses
                        game_state <= MASTER_SETTLE_POT;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (raise)
                    begin
                        if (raise_am + opponent_raise_value <= player_current_chips && raise_am <= opponent_current_chips)
                        begin
                            tx_data[7:6] <= 2'b01;
                            tx_data[5:0] <= raise_am;
                            tx_tick = 1;
                            my_raise_value <= raise_am;
                            // TODO: add logic to check whether there is sufficient chips
                            total_pot <= total_pot + raise_am + opponent_raise_value;
                            player_current_chips <= player_current_chips - raise_am - opponent_raise_value;
                            
                            game_state <= SLAVE_THIRD_ACTION;
                            opponent_action = 8'b00000000; // clear here
                        end
                    end
                end
                SLAVE_THIRD_ACTION:
                begin
                    // await slave action
                    // if action is raise, goes back to master third action state
                    if (rx_fifo_not_empty  && dont_read == 0)
                    begin
                        // check if is raise or call, if it is call, bits 5 to 0 would be 0 in value
                        if (receive_data[7:6] == 2'b01 && receive_data[5:0] > 0) // raise action
                        begin
                            total_pot <= total_pot + receive_data[5:0] + my_raise_value;
                            opponent_current_chips = opponent_current_chips - receive_data[5:0] - my_raise_value;
                            
                            opponent_raise_value = receive_data[5:0];
                            // opponent_action = {CALL, receive_data[5:0]};
                            opponent_action[7:6] = CALL;
                            opponent_action[5:0] = receive_data[5:0]; 
                            game_state = MASTER_THIRD_ACTION;
                        end
                        
                        if (receive_data == 8'b01000000 && my_raise_value > 0) // only allow call if we have raise beforehand
                        begin
                            total_pot <= total_pot + my_raise_value;
                            opponent_current_chips = opponent_current_chips - my_raise_value;
                            opponent_action = 8'b01000000;
                            opponent_raise_value = 8'b00000000;
                            game_state = MASTER_DEAL_RIVER;
                        end
                        
                        // If it is check
                        if (receive_data == CHECK  && my_raise_value == 0) // only allow if there is no raise value
                        begin
                            opponent_action = CHECK;
                            game_state <= MASTER_DEAL_RIVER;
                        end
                        
                        // If it is fold
                        if (receive_data == FOLD)
                        begin
                            opponent_action = FOLD;
                            win_status <= 1; // master win
                            game_state <= MASTER_SETTLE_POT;
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                MASTER_DEAL_RIVER:
                begin
                    // use rng to deal river card, tx to slave
                    // opponent_action = 8'b00000000; dont clear here
                    opponent_raise_value = 8'b00000000;
                    my_raise_value = 8'b00000000;
                    // opponent_action = 8'b00000000; // clear here
                    if (check)
                    begin
                        case (num_cards_dealt)
                            8:
                            begin
                                river = hriver;
                                // river = gl_river;
                                num_cards_dealt = 9;
                                tx_data = hriver; // tx card 
                                tx_tick = 1; 
                            end
                        endcase
                    end
                    if (num_cards_dealt == 9)
                    begin
                        game_state <= MASTER_FOURTH_ACTION;
                    end
                end
                MASTER_FOURTH_ACTION:
                begin
                    // master action to check, raise or fold
                    // tx action to slave
                    if (check && opponent_raise_value == 0)
                    begin
                        tx_data <= CHECK;
                        tx_tick = 1;
                        game_state <= SLAVE_FOURTH_ACTION;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (call && opponent_raise_value > 0)
                    begin
                        tx_data <= 8'b01000000;
                        tx_tick = 1;
                        total_pot <= total_pot + opponent_raise_value;
                        player_current_chips <= player_current_chips - opponent_raise_value;
                        
                        game_state <= MASTER_SETTLE_POT;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (fold)
                    begin
                        tx_data <= FOLD;
                        tx_tick = 1;
                        win_status <= 2; // master loses
                        game_state <= MASTER_SETTLE_POT;
                        opponent_action = 8'b00000000; // clear here
                    end
                    if (raise)
                    begin
                        if (raise_am + opponent_raise_value <= player_current_chips && raise_am <= opponent_current_chips)
                        begin
                            tx_data[7:6] <= 2'b01;
                            tx_data[5:0] <= raise_am;
                            tx_tick = 1;
                            my_raise_value <= raise_am;
                            // TODO: add logic to check whether there is sufficient chips
                            total_pot <= total_pot + raise_am + opponent_raise_value;
                            player_current_chips <= player_current_chips - raise_am - opponent_raise_value;
                            
                            game_state <= SLAVE_FOURTH_ACTION;
                            opponent_action = 8'b00000000; // clear here
                        end
                    end
                end
                SLAVE_FOURTH_ACTION:
                begin
                    // await slave action
                    // if action is raise, goes back to master fourth action state
                    if (rx_fifo_not_empty  && dont_read == 0)
                    begin
                        // check if is raise or call, if it is call, bits 5 to 0 would be 0 in value
                        if (receive_data[7:6] == 2'b01 && receive_data[5:0] > 0) // raise action
                        begin
                            total_pot <= total_pot + receive_data[5:0] + my_raise_value;
                            opponent_current_chips = opponent_current_chips - receive_data[5:0] - my_raise_value;
                            
                            opponent_raise_value = receive_data[5:0];
                            // opponent_action = {CALL, receive_data[5:0]};
                            opponent_action[7:6] = CALL;
                            opponent_action[5:0] = receive_data[5:0]; 
                            game_state = MASTER_FOURTH_ACTION;
                        end
                        
                        if (receive_data == 8'b01000000 && my_raise_value > 0) // only allow call if we have raise beforehand
                        begin
                            total_pot <= total_pot + my_raise_value;
                            opponent_current_chips = opponent_current_chips - my_raise_value;
                            opponent_action = 8'b01000000;
                            opponent_raise_value = 8'b00000000;
                            game_state = MASTER_SETTLE_POT;
                        end
                        
                        // If it is check
                        if (receive_data == CHECK  && my_raise_value == 0) // only allow if there is no raise value
                        begin
                            opponent_action = CHECK;
                            game_state <= MASTER_SETTLE_POT;
                        end
                        
                        // If it is fold
                        if (receive_data == FOLD)
                        begin
                            opponent_action = FOLD;
                            win_status <= 1; // master win
                            game_state <= MASTER_SETTLE_POT;
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                MASTER_SETTLE_POT:
                begin
                   // if the win status is 0 then need to use winning logic
                   // gets winning logic from guanlin
                   // update player curent chips based on winning logic
                   // send signal to opponent
                   // go back to initial state
                   // if lose, then subtract player contri
                   // if win, then add pot
                   if (win_status == 0 && calledWinningLogic == 0)
                   begin
                       // use winning logic
                       callWhoWin = 1;
                       calledWinningLogic = 1;
                   end 
                   else if (calledWinningLogic == 1) begin
                        wait_callWhoWin = (wait_callWhoWin == 2'b11) ? wait_callWhoWin : wait_callWhoWin + 1;
                        if (wait_callWhoWin == 3) begin
                            callWhoWin = 0;
                        end
                   end
                   if (isCheckDone && calledWinningLogic && win_status == 0) begin
                       if (result == 2'b10) begin
                           LED[1:0] = result;
                           win_status = 1;
                       end else if (result == 2'b01) begin
                           LED[1:0] = result;
                           win_status = 2;
                       end else if (result == 2'b11) begin
                           LED[1:0] = result;
                           win_status = 3;
                       end
                   end
                   case (win_status)
                        1:  // player wins
                        begin
                            // transmit master win signal
                            tx_data = WIN;
                            tx_tick = 1;
                            player_current_chips = player_current_chips + total_pot;
                            total_pot = 0;
                            game_state <= SHOW_OPP_CARD;
                        end
                        2: // opponent wins
                        begin
                            // transmit slave win signal
                            tx_data = LOSE;
                            tx_tick = 1;
                            opponent_current_chips = opponent_current_chips + total_pot;
                            total_pot = 0;
                            game_state <= SHOW_OPP_CARD;
                        end
                        3: // split pot
                        begin
                            // transmit split pot signal
                            tx_data = SPLIT;
                            tx_tick = 1;
                            opponent_current_chips = opponent_current_chips + (total_pot / 2);
                            player_current_chips = player_current_chips + (total_pot / 2);
                            total_pot = 0;
                            game_state <= SHOW_OPP_CARD;
                        end
                        default:
                        begin
                        end
                   endcase
                end
                SHOW_OPP_CARD:
                begin
                    if (check)
                    begin
                        tx_data <= CHECK;
                        tx_tick = 1;
                        game_state <= INITIAL;
                        opponent_action = 8'b00000000; // clear here
                        // set show card signal
                        opp_signal = 1;
                    end
                end
                WIN_SCREEN:
                begin
                    win_lose = 2'b01;
                end
                LOSE_SCREEN:
                begin
                    win_lose = 2'b10;
                end
                default: game_state <= INITIAL;
            endcase
        end
        else
        begin
            case (game_state)
                INITIAL:
                begin
                    if (player_current_chips < 2)
                    begin
                        game_state <= LOSE_SCREEN;
                    end
                    if (opponent_current_chips < 2)
                    begin
                        game_state <= WIN_SCREEN;
                    end
                    
                    if (rx_fifo_not_empty && dont_read == 0)
                    begin
                        // receive start signal
                        if (receive_data == CHECK)
                        begin
                            opponent_action = 8'b00000000;
                            total_pot = 3; // small blind 1 big blind 1, 2 + 1 = 3          
                            opponent_raise_value = 0; // opponent is small blind raise value 
                            win_status = 0;
                            
                            my_raise_value = 1; // big minus small blind 2 -1 = 1
                            
                            // update chip count for player and opponent
                            player_current_chips <= player_current_chips - 2; // slave is always big blind
                            opponent_current_chips <= opponent_current_chips - 1; // master is always small blind
                            
                            // clear cards and num_cards dealt
                            flop1 = 0;
                            flop2 = 0;
                            flop3 = 0;
                            turn = 0;
                            river = 0;
                            hole1 = 0;
                            hole2 = 0;
                            opp_hole1 = 0;
                            opp_hole2 = 0;
                            num_cards_dealt = 0;
                            
                            opp_signal = 0;
                            
                            game_state <= DEAL_OWN_CARDS;
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                DEAL_OWN_CARDS:
                begin
                    // rx master cards from master
                    if (rx_fifo_not_empty && dont_read == 0)
                    begin
                        // receive start signal
                        if (receive_data[7] == 1) // check if it is a card
                        begin
                            case (num_cards_dealt)
                                0:
                                begin
                                    opp_hole1 = receive_data;
                                    num_cards_dealt = num_cards_dealt + 1;
                                end
                                1:
                                begin
                                    opp_hole2 = receive_data;
                                    num_cards_dealt = num_cards_dealt + 1;
                                end
                            endcase
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                    if (num_cards_dealt == 2)
                    begin
                        game_state <= DEAL_SLAVE_CARDS;
                    end
                end
                DEAL_SLAVE_CARDS:
                begin
                    // rx slave cards from master
                    if (rx_fifo_not_empty && dont_read == 0)
                    begin
                        // receive start signal
                        if (receive_data[7] == 1) // check if it is a card
                        begin
                            case (num_cards_dealt)
                                2:
                                begin
                                    hole1 = receive_data;
                                    num_cards_dealt = num_cards_dealt + 1;
                                end
                                3:
                                begin
                                    hole2 = receive_data;
                                    num_cards_dealt = num_cards_dealt + 1;
                                end
                            endcase
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                    if (num_cards_dealt == 4)
                    begin
                        game_state <= MASTER_PRE_FLOP_ACTION;
                    end
                end
                MASTER_PRE_FLOP_ACTION:
                begin
                    // await master action to call, raise or fold
                    // rx action from master
                    // based on master action set avilable actions for slave pre flop action
                    if (rx_fifo_not_empty  && dont_read == 0)
                    begin
                        // check if is raise or call, if it is call, bits 5 to 0 would be 0 in value
                        if (receive_data[7:6] == 2'b01 && my_raise_value > 0) // only allows if there is a raise value
                        begin
                            total_pot = total_pot + receive_data[5:0] + my_raise_value;
                            opponent_current_chips <= opponent_current_chips - receive_data[5:0] - my_raise_value;
                            
                            opponent_raise_value = receive_data[5:0];
                            if (receive_data[5:0] == 0)
                            begin
                                opponent_action = 8'b01000000;
                                opponent_raise_value = 8'b00000000;
                                if (total_pot == 4)
                                begin
                                    game_state = SLAVE_PRE_FLOP_ACTION;
                                end
                                else
                                begin
                                    game_state = MASTER_DEAL_FLOP;
                                end
                            end
                            else
                            begin
                                // opponent_action = {CALL, receive_data[5:0]};
                                opponent_action[7:6] = CALL;
                                opponent_action[5:0] = receive_data[5:0]; 
                                opponent_raise_value = receive_data[5:0];
                                game_state <= SLAVE_PRE_FLOP_ACTION;
                            end
                        end
                        
                        // Cant check here
                        
                        // If it is fold
                        if (receive_data == FOLD)
                        begin
                            opponent_action = FOLD;
                            win_status <= 1; // master win
                            game_state <= MASTER_SETTLE_POT;
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                SLAVE_PRE_FLOP_ACTION:
                begin
                    // slave action based on available actions
                    // tx action to master
                    // if slave raises, goes back to master pre flop action
                    // if slave checks or calls, goes to next deal state
                    if (check && opponent_raise_value == 0)
                    begin
                        tx_data <= CHECK;
                        tx_tick = 1;
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_DEAL_FLOP;
                    end
                    if (call && opponent_raise_value > 0)
                    begin
                        tx_data <= 8'b01000000;
                        tx_tick = 1;
                        total_pot <= total_pot + opponent_raise_value;
                        player_current_chips <= player_current_chips - opponent_raise_value;
                        opponent_action = 8'b00000000; // clear opponent action
                        
                        game_state <= MASTER_DEAL_FLOP;
                    end
                    if (fold)
                    begin
                        tx_data <= FOLD;
                        tx_tick = 1;
                        win_status <= 2; // slave loses
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_SETTLE_POT;
                    end
                    if (raise)
                    begin
                        if (raise_am + opponent_raise_value <= player_current_chips && raise_am <= opponent_current_chips)
                        begin
                            tx_data[7:6] = 2'b01;
                            tx_data[5:0] = raise_am;
                            tx_tick = 1;
                            my_raise_value <= raise_am;
                            // TODO: add logic to check whether there is sufficient chips
                            total_pot <= total_pot + raise_am + opponent_raise_value;
                            player_current_chips <= player_current_chips - raise_am - opponent_raise_value;
                            
                            opponent_action = 8'b00000000; // clear opponent action
                            game_state <= MASTER_PRE_FLOP_ACTION;
                        end
                    end
                end
                MASTER_DEAL_FLOP:
                begin
                    // rx 3 flop cards from master
                    // opponent_action = 8'b00000000;
                    opponent_raise_value = 8'b00000000;
                    my_raise_value = 8'b00000000;
                    
                    if (rx_fifo_not_empty && dont_read == 0)
                    begin
                        // receive start signal
                        if (receive_data[7] == 1) // check if it is a card
                        begin
                            case (num_cards_dealt)
                                4:
                                begin
                                    flop1 = receive_data;
                                    num_cards_dealt = num_cards_dealt + 1;
                                end
                                5:
                                begin
                                    flop2 = receive_data;
                                    num_cards_dealt = num_cards_dealt + 1;
                                end
                                6:
                                begin
                                    flop3 = receive_data;
                                    num_cards_dealt = num_cards_dealt + 1;
                                end
                            endcase
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                    if (num_cards_dealt == 7)
                    begin
                        game_state <= MASTER_SECOND_ACTION;
                    end
                end
                MASTER_SECOND_ACTION:
                begin
                    // await master action to check, raise or fold
                    // rx action from master
                    // based on master action set avilable actions for slave second action
                    if (rx_fifo_not_empty  && dont_read == 0)
                    begin
                        // check if is raise, bits 5 to 0 would be non zero
                        if (receive_data[7:6] == 2'b01 && receive_data[5:0] > 0) // here the master is allowed to initiate a raise
                        begin
                            total_pot = total_pot + receive_data[5:0] + my_raise_value;
                            opponent_current_chips <= opponent_current_chips - receive_data[5:0] - my_raise_value;
                            
                            opponent_raise_value = receive_data[5:0];
                            // opponent_action = {CALL, receive_data[5:0]};
                            opponent_action[7:6] = CALL;
                            opponent_action[5:0] = receive_data[5:0]; 
                            game_state <= SLAVE_SECOND_ACTION;
                        end
                        
                        // if master calls after a raise by the slave, go straight to next round
                        if (receive_data == 8'b01000000 && my_raise_value > 0)
                        begin
                            total_pot = total_pot + my_raise_value;
                            opponent_current_chips <= opponent_current_chips - my_raise_value;

                            opponent_action = 8'b01000000;
                            opponent_raise_value = 8'b00000000;
                            game_state <= MASTER_DEAL_TURN;
                        end
                        
                        // If it is check
                        if (receive_data == CHECK  && my_raise_value == 0) // only allow if there is no raise value
                        begin
                            opponent_action = CHECK;
                            game_state <= SLAVE_SECOND_ACTION;
                        end
                        
                        // If it is fold
                        if (receive_data == FOLD)
                        begin
                            opponent_action = FOLD;
                            win_status <= 1; // slave win
                            game_state <= MASTER_SETTLE_POT;
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                SLAVE_SECOND_ACTION:
                begin
                    // slave action based on available actions
                    // tx action to master
                    // if slave raises, goes back to master second action
                    // if slave checks or calls, goes to next deal state
                    if (check && opponent_raise_value == 0)
                    begin
                        tx_data <= CHECK;
                        tx_tick = 1;
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_DEAL_TURN;
                    end
                    if (call && opponent_raise_value > 0)
                    begin
                        tx_data <= 8'b01000000;
                        tx_tick = 1;
                        total_pot <= total_pot + opponent_raise_value;
                        player_current_chips <= player_current_chips - opponent_raise_value;
                        
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_DEAL_TURN;
                    end
                    if (fold)
                    begin
                        tx_data <= FOLD;
                        tx_tick = 1;
                        win_status <= 2; // slave loses
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_SETTLE_POT;
                    end
                    if (raise)
                    begin
                        if (raise_am + opponent_raise_value <= player_current_chips && raise_am <= opponent_current_chips)
                        begin
                            tx_data[7:6] <= 2'b01;
                            tx_data[5:0] <= raise_am;
                            tx_tick = 1;
                            my_raise_value <= raise_am;
                            // TODO: add logic to check whether there is sufficient chips
                            total_pot <= total_pot + raise_am + opponent_raise_value;
                            player_current_chips <= player_current_chips - raise_am - opponent_raise_value;
                            
                            opponent_action = 8'b00000000; // clear opponent action
                            game_state <= MASTER_SECOND_ACTION;
                        end
                    end
                end
                MASTER_DEAL_TURN:
                begin
                    // rx turn card from master
                    // opponent_action = 8'b00000000;
                    opponent_raise_value = 8'b00000000;
                    my_raise_value = 8'b00000000;
                    
                    if (rx_fifo_not_empty && dont_read == 0)
                    begin
                        // receive start signal
                        if (receive_data[7] == 1) // check if it is a card
                        begin
                            case (num_cards_dealt)
                                7:
                                begin
                                    turn = receive_data;
                                    num_cards_dealt = num_cards_dealt + 1;
                                end
                            endcase
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                    if (num_cards_dealt == 8)
                    begin
                        game_state <= MASTER_THIRD_ACTION;
                    end
                end
                MASTER_THIRD_ACTION:
                begin
                    // await master action to check, raise or fold
                    // rx action from master
                    // based on master action set avilable actions for slave third action
                    if (rx_fifo_not_empty  && dont_read == 0)
                    begin
                        // check if is raise, bits 5 to 0 would be non zero
                        if (receive_data[7:6] == 2'b01 && receive_data[5:0] > 0) // here the master is allowed to initiate a raise
                        begin
                            total_pot = total_pot + receive_data[5:0] + my_raise_value;
                            opponent_current_chips <= opponent_current_chips - receive_data[5:0] - my_raise_value;
                            
                            opponent_raise_value = receive_data[5:0];
                            // opponent_action = {CALL, receive_data[5:0]};
                            opponent_action[7:6] = CALL;
                            opponent_action[5:0] = receive_data[5:0]; 
                            game_state <= SLAVE_THIRD_ACTION;
                        end
                        
                        // if master calls after a raise by the slave, go straight to next round
                        if (receive_data == 8'b01000000 && my_raise_value > 0)
                        begin
                            total_pot = total_pot + my_raise_value;
                            opponent_current_chips <= opponent_current_chips - my_raise_value;

                            opponent_action = 8'b01000000;
                            opponent_raise_value = 8'b00000000;
                            game_state <= MASTER_DEAL_RIVER;
                        end
                        
                        // If it is check
                        if (receive_data == CHECK  && my_raise_value == 0) // only allow if there is no raise value
                        begin
                            opponent_action = CHECK;
                            game_state <= SLAVE_THIRD_ACTION;
                        end
                        
                        // If it is fold
                        if (receive_data == FOLD)
                        begin
                            opponent_action = FOLD;
                            win_status <= 1; // slave win
                            game_state <= MASTER_SETTLE_POT;
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                SLAVE_THIRD_ACTION:
                begin
                    // slave action based on available actions
                    // tx action to master
                    // if slave raises, goes back to master third action
                    // if slave checks or calls, goes to next deal state
                    if (check && opponent_raise_value == 0)
                    begin
                        tx_data <= CHECK;
                        tx_tick = 1;
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_DEAL_RIVER;
                    end
                    if (call && opponent_raise_value > 0)
                    begin
                        tx_data <= 8'b01000000;
                        tx_tick = 1;
                        total_pot <= total_pot + opponent_raise_value;
                        player_current_chips <= player_current_chips - opponent_raise_value;
                        
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_DEAL_RIVER;
                    end
                    if (fold)
                    begin
                        tx_data <= FOLD;
                        tx_tick = 1;
                        win_status <= 2; // slave loses
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_SETTLE_POT;
                    end
                    if (raise)
                    begin
                        if (raise_am + opponent_raise_value <= player_current_chips && raise_am <= opponent_current_chips)
                        begin
                            tx_data[7:6] <= 2'b01;
                            tx_data[5:0] <= raise_am;
                            tx_tick = 1;
                            my_raise_value <= raise_am;
                            // TODO: add logic to check whether there is sufficient chips
                            total_pot <= total_pot + raise_am + opponent_raise_value;
                            player_current_chips <= player_current_chips - raise_am - opponent_raise_value;
                            
                            opponent_action = 8'b00000000; // clear opponent action
                            game_state <= MASTER_THIRD_ACTION;
                        end
                    end
                end
                MASTER_DEAL_RIVER:
                begin
                    // use rng to deal river card, tx to slave
                    // opponent_action = 8'b00000000;
                    opponent_raise_value = 8'b00000000;
                    my_raise_value = 8'b00000000;
                    
                    if (rx_fifo_not_empty && dont_read == 0)
                    begin
                        // receive start signal
                        if (receive_data[7] == 1) // check if it is a card
                        begin
                            case (num_cards_dealt)
                                8:
                                begin
                                    river = receive_data;
                                    num_cards_dealt = num_cards_dealt + 1;
                                end
                            endcase
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                    if (num_cards_dealt == 9)
                    begin
                        game_state <= MASTER_FOURTH_ACTION;
                    end
                end
                MASTER_FOURTH_ACTION:
                begin
                    // await master action to check, raise or fold
                    // rx action from master
                    // based on master action set avilable actions for slave third action
                    if (rx_fifo_not_empty  && dont_read == 0)
                    begin
                        // check if is raise, bits 5 to 0 would be non zero
                        if (receive_data[7:6] == 2'b01 && receive_data[5:0] > 0) // here the master is allowed to initiate a raise
                        begin
                            total_pot = total_pot + receive_data[5:0] + my_raise_value;
                            opponent_current_chips <= opponent_current_chips - receive_data[5:0] - my_raise_value;
                            
                            opponent_raise_value = receive_data[5:0];
                            // opponent_action = {CALL, receive_data[5:0]};
                            opponent_action[7:6] = CALL;
                            opponent_action[5:0] = receive_data[5:0]; 
                            game_state <= SLAVE_FOURTH_ACTION;
                        end
                        
                        // if master calls after a raise by the slave, go straight to next round
                        if (receive_data == 8'b01000000 && my_raise_value > 0)
                        begin
                            total_pot = total_pot + my_raise_value;
                            opponent_current_chips <= opponent_current_chips - my_raise_value;

                            opponent_action = 8'b01000000;
                            opponent_raise_value = 8'b00000000;
                            game_state <= MASTER_SETTLE_POT;
                        end
                        
                        // If it is check
                        if (receive_data == CHECK  && my_raise_value == 0) // only allow if there is no raise value
                        begin
                            opponent_action = CHECK;
                            game_state <= SLAVE_FOURTH_ACTION;
                        end
                        
                        // If it is fold
                        if (receive_data == FOLD)
                        begin
                            opponent_action = FOLD;
                            win_status <= 1; // slave win
                            game_state <= MASTER_SETTLE_POT;
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                SLAVE_FOURTH_ACTION:
                begin
                    // slave action based on available actions
                    // tx action to master
                    // if slave raises, goes back to master fourth action
                    // if slave checks or calls, goes to next deal state
                    if (check && opponent_raise_value == 0)
                    begin
                        tx_data <= CHECK;
                        tx_tick = 1;
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_SETTLE_POT;
                    end
                    if (call && opponent_raise_value > 0)
                    begin
                        tx_data <= 8'b01000000;
                        tx_tick = 1;
                        total_pot <= total_pot + opponent_raise_value;
                        player_current_chips <= player_current_chips - opponent_raise_value;
                        
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_SETTLE_POT;
                    end
                    if (fold)
                    begin
                        tx_data <= FOLD;
                        tx_tick = 1;
                        win_status <= 2; // slave loses
                        opponent_action = 8'b00000000; // clear opponent action
                        game_state <= MASTER_SETTLE_POT;
                    end
                    if (raise)
                    begin
                        if (raise_am + opponent_raise_value <= player_current_chips && raise_am <= opponent_current_chips)
                        begin
                            tx_data[7:6] <= 2'b01;
                            tx_data[5:0] <= raise_am;
                            tx_tick = 1;
                            my_raise_value <= raise_am;
                            // TODO: add logic to check whether there is sufficient chips
                            total_pot <= total_pot + raise_am + opponent_raise_value;
                            player_current_chips <= player_current_chips - raise_am - opponent_raise_value;
                            
                            opponent_action = 8'b00000000; // clear opponent action
                            game_state <= MASTER_FOURTH_ACTION;
                        end
                    end
                end
                MASTER_SETTLE_POT:
                begin
                    // opponent_action = 8'b00000000; // clear opponent action
                   // rx result from master
                   // if the win status is 0 then need to use winning logic
                   // update player curent chips based on winning logic
                   // go back to initial state
                   // if (win_status == 0)
                   // begin
                       // use winning logic
                       // slave receive logic signal
                   // end
                   if (rx_fifo_not_empty && dont_read == 0)
                   begin
                        if (receive_data == WIN) // master won
                        begin
                            win_status = 2; // player loses  
                        end
                        else if (receive_data == LOSE)
                        begin
                            win_status = 1; // player wins
                        end
                        else if (receive_data == SPLIT)
                        begin
                            win_status = 3; // split
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                   end
                   case (win_status)
                        1:  // player wins
                        begin
                            player_current_chips = player_current_chips + total_pot;
                            total_pot = 0;
                            game_state = SHOW_OPP_CARD;
                        end
                        2: // opponent wins
                        begin
                            opponent_current_chips = opponent_current_chips + total_pot;
                            total_pot = 0;
                            game_state = SHOW_OPP_CARD;
                        end
                        3: // split pot
                        begin
                            opponent_current_chips = opponent_current_chips + (total_pot / 2);
                            player_current_chips = player_current_chips + (total_pot / 2);
                            total_pot = 0;
                            game_state = SHOW_OPP_CARD;
                        end
                   endcase
                end
                SHOW_OPP_CARD:
                begin
                    // If it is check
                    if (rx_fifo_not_empty && dont_read == 0)
                        begin
                        if (receive_data == CHECK) // only allow if there is no raise value
                        begin
                            opponent_action = 8'b00000000;
                            game_state <= INITIAL;
                            opp_signal = 1;
                            // set show opp card signal
                        end
                        en_read_rx_fifo = 1; // signal FIFO to go to next pointer
                    end
                end
                WIN_SCREEN:
                begin
                    win_lose = 2'b01;
                end
                LOSE_SCREEN:
                begin
                    win_lose = 2'b10;
                end
                default: game_state <= INITIAL;
            endcase
        end
        dont_read = 0;
    end
    
    assign LED2 = game_state;
endmodule
