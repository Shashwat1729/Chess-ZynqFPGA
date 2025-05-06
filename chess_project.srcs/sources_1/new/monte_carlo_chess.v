`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2024
// Design Name: Monte Carlo Chess Move Evaluator
// Module Name: monte_carlo_chess
// Project Name: Chess Game
// Target Devices: 
// Tool versions: 
// Description: Enhanced Monte Carlo implementation for chess move evaluation
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module monte_carlo_chess(
    input wire CLK,
    input wire RESET,
    input wire [255:0] BOARD,  // Current board state
    input wire [5:0] FROM_POS, // Position to move from
    input wire [5:0] TO_POS,   // Position to move to
    input wire EVALUATE_MOVE,  // Trigger evaluation
    output reg [7:0] SCORE,    // Move score (0-255)
    output reg EVALUATION_DONE // Evaluation complete flag
);

// Piece definitions
localparam PIECE_NONE   = 3'b000;
localparam PIECE_PAWN   = 3'b001;
localparam PIECE_KNIGHT = 3'b010;
localparam PIECE_BISHOP = 3'b011;
localparam PIECE_ROOK   = 3'b100;
localparam PIECE_QUEEN  = 3'b101;
localparam PIECE_KING   = 3'b110;

localparam COLOR_WHITE  = 0;
localparam COLOR_BLACK  = 1;

// Piece values for evaluation
localparam [7:0] PAWN_VALUE   = 8'd10;
localparam [7:0] KNIGHT_VALUE = 8'd30;
localparam [7:0] BISHOP_VALUE = 8'd30;
localparam [7:0] ROOK_VALUE   = 8'd50;
localparam [7:0] QUEEN_VALUE  = 8'd90;
localparam [7:0] KING_VALUE   = 8'd200;

// Position bonus values (center control is valuable)
localparam [7:0] CENTER_BONUS = 8'd5;
localparam [7:0] EDGE_PENALTY = 8'd2;

// State machine states
localparam IDLE = 2'b00;
localparam EVALUATING = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [7:0] simulation_count;
reg [15:0] total_score;  // Increased to handle more simulations
reg [3:0] board_copy [63:0];
reg [5:0] random_positions [15:0];  // Store random positions for simulations
reg [7:0] random_counter;  // Counter for generating pseudo-random numbers

// Convert board array to internal format
genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin : BOARD_CONV
        always @(posedge CLK) begin
            board_copy[i] <= BOARD[i*4+3 : i*4];
        end
    end
endgenerate

// Simple piece value evaluation
function [7:0] evaluate_position;
    input [3:0] piece;
    begin
        case (piece[2:0])
            PIECE_PAWN:   evaluate_position = piece[3] ? PAWN_VALUE : -PAWN_VALUE;
            PIECE_KNIGHT: evaluate_position = piece[3] ? KNIGHT_VALUE : -KNIGHT_VALUE;
            PIECE_BISHOP: evaluate_position = piece[3] ? BISHOP_VALUE : -BISHOP_VALUE;
            PIECE_ROOK:   evaluate_position = piece[3] ? ROOK_VALUE : -ROOK_VALUE;
            PIECE_QUEEN:  evaluate_position = piece[3] ? QUEEN_VALUE : -QUEEN_VALUE;
            PIECE_KING:   evaluate_position = piece[3] ? KING_VALUE : -KING_VALUE;
            default:      evaluate_position = 8'd0;
        endcase
    end
endfunction

// Position evaluation (center control is valuable)
function [7:0] evaluate_position_bonus;
    input [5:0] pos;
    begin
        // Center squares (e4, e5, d4, d5) are valuable
        if ((pos[5:3] == 3'b011 || pos[5:3] == 3'b100) && 
            (pos[2:0] == 3'b011 || pos[2:0] == 3'b100)) begin
            evaluate_position_bonus = CENTER_BONUS;
        end
        // Edge squares are less valuable
        else if (pos[5:3] == 3'b000 || pos[5:3] == 3'b111 || 
                 pos[2:0] == 3'b000 || pos[2:0] == 3'b111) begin
            evaluate_position_bonus = -EDGE_PENALTY;
        end
        else begin
            evaluate_position_bonus = 8'd0;
        end
    end
endfunction

// Generate a pseudo-random position (6-bit)
function [5:0] random_position;
    input [7:0] seed;
    begin
        // Simple LFSR-like algorithm for pseudo-random numbers
        random_position = {seed[3:0], seed[7:6]};
    end
endfunction

// Monte Carlo evaluation
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        state <= IDLE;
        SCORE <= 8'd0;
        EVALUATION_DONE <= 1'b0;
        simulation_count <= 8'd0;
        total_score <= 16'd0;
        random_counter <= 8'd1;  // Initialize with non-zero value
    end
    else begin
        case (state)
            IDLE: begin
                if (EVALUATE_MOVE) begin
                    state <= EVALUATING;
                    simulation_count <= 8'd0;
                    total_score <= 16'd0;
                    EVALUATION_DONE <= 1'b0;
                end
            end
            
            EVALUATING: begin
                if (simulation_count < 8'd16) begin  // Perform 16 simulations
                    // Generate random move
                    random_counter <= random_counter + 1;
                    random_positions[simulation_count] <= random_position(random_counter);
                    
                    // Evaluate position after move
                    // For computer moves (black), we want to maximize score
                    // For human moves (white), we want to minimize score
                    if (BOARD[FROM_POS*4+3] == COLOR_BLACK) begin
                        // Computer move - maximize score
                        total_score <= total_score + evaluate_position(board_copy[TO_POS]) + 
                                     evaluate_position_bonus(TO_POS);
                    end
                    else begin
                        // Human move - minimize score (negative evaluation)
                        total_score <= total_score - evaluate_position(board_copy[TO_POS]) - 
                                     evaluate_position_bonus(TO_POS);
                    end
                    
                    simulation_count <= simulation_count + 1;
                end
                else begin
                    // Calculate final score (average of all simulations)
                    // For computer moves, we want higher scores
                    // For human moves, we want lower scores
                    if (BOARD[FROM_POS*4+3] == COLOR_BLACK) begin
                        // Computer move - higher score is better
                        SCORE <= (total_score >> 4) + 8'd128;  // Center the score around 128
                    end
                    else begin
                        // Human move - lower score is better
                        SCORE <= 8'd128 - (total_score >> 4);  // Invert the score
                    end
                    
                    EVALUATION_DONE <= 1'b1;
                    state <= IDLE;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule 