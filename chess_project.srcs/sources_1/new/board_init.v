`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:40:01 11/09/2016 
// Design Name: 
// Module Name:    board_init 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module board_init(
    input wire clk,
    input wire reset,
    input wire [5:0] board_change_addr,
    input wire [3:0] board_change_piece,
    input wire board_change_en,
    output reg [255:0] board_out
);

    // Piece Definitions
    localparam PIECE_NONE   = 3'b000;
    localparam PIECE_PAWN   = 3'b001;
    localparam PIECE_KNIGHT = 3'b010;
    localparam PIECE_BISHOP = 3'b011;
    localparam PIECE_ROOK   = 3'b100;
    localparam PIECE_QUEEN  = 3'b101;
    localparam PIECE_KING   = 3'b110;

    localparam COLOR_WHITE  = 0;
    localparam COLOR_BLACK  = 1;

    // Initialize the board
    always @(posedge clk) begin
        if (reset) begin
            // White pieces
            board_out[6'b111_000*4 +: 4] <= { COLOR_WHITE, PIECE_ROOK };
            board_out[6'b111_001*4 +: 4] <= { COLOR_WHITE, PIECE_KNIGHT };
            board_out[6'b111_010*4 +: 4] <= { COLOR_WHITE, PIECE_BISHOP };
            board_out[6'b111_011*4 +: 4] <= { COLOR_WHITE, PIECE_QUEEN };
            board_out[6'b111_100*4 +: 4] <= { COLOR_WHITE, PIECE_KING };
            board_out[6'b111_101*4 +: 4] <= { COLOR_WHITE, PIECE_BISHOP };
            board_out[6'b111_110*4 +: 4] <= { COLOR_WHITE, PIECE_KNIGHT };
            board_out[6'b111_111*4 +: 4] <= { COLOR_WHITE, PIECE_ROOK };
            
            board_out[6'b110_000*4 +: 4] <= { COLOR_WHITE, PIECE_PAWN };
            board_out[6'b110_001*4 +: 4] <= { COLOR_WHITE, PIECE_PAWN };
            board_out[6'b110_010*4 +: 4] <= { COLOR_WHITE, PIECE_PAWN };
            board_out[6'b110_011*4 +: 4] <= { COLOR_WHITE, PIECE_PAWN };
            board_out[6'b110_100*4 +: 4] <= { COLOR_WHITE, PIECE_PAWN };
            board_out[6'b110_101*4 +: 4] <= { COLOR_WHITE, PIECE_PAWN };
            board_out[6'b110_110*4 +: 4] <= { COLOR_WHITE, PIECE_PAWN };
            board_out[6'b110_111*4 +: 4] <= { COLOR_WHITE, PIECE_PAWN };
            
            // Empty squares
            board_out[6'b101_000*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b101_001*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b101_010*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b101_011*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b101_100*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b101_101*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b101_110*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b101_111*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            
            board_out[6'b100_000*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b100_001*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b100_010*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b100_011*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b100_100*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b100_101*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b100_110*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b100_111*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            
            board_out[6'b011_000*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b011_001*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b011_010*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b011_011*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b011_100*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b011_101*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b011_110*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b011_111*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            
            board_out[6'b010_000*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b010_001*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b010_010*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b010_011*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b010_100*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b010_101*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b010_110*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            board_out[6'b010_111*4 +: 4] <= { COLOR_WHITE, PIECE_NONE };
            
            // Black pieces
            board_out[6'b001_000*4 +: 4] <= { COLOR_BLACK, PIECE_PAWN };
            board_out[6'b001_001*4 +: 4] <= { COLOR_BLACK, PIECE_PAWN };
            board_out[6'b001_010*4 +: 4] <= { COLOR_BLACK, PIECE_PAWN };
            board_out[6'b001_011*4 +: 4] <= { COLOR_BLACK, PIECE_PAWN };
            board_out[6'b001_100*4 +: 4] <= { COLOR_BLACK, PIECE_PAWN };
            board_out[6'b001_101*4 +: 4] <= { COLOR_BLACK, PIECE_PAWN };
            board_out[6'b001_110*4 +: 4] <= { COLOR_BLACK, PIECE_PAWN };
            board_out[6'b001_111*4 +: 4] <= { COLOR_BLACK, PIECE_PAWN };
            
            board_out[6'b000_000*4 +: 4] <= { COLOR_BLACK, PIECE_ROOK };
            board_out[6'b000_001*4 +: 4] <= { COLOR_BLACK, PIECE_KNIGHT };
            board_out[6'b000_010*4 +: 4] <= { COLOR_BLACK, PIECE_BISHOP };
            board_out[6'b000_011*4 +: 4] <= { COLOR_BLACK, PIECE_QUEEN };
            board_out[6'b000_100*4 +: 4] <= { COLOR_BLACK, PIECE_KING };
            board_out[6'b000_101*4 +: 4] <= { COLOR_BLACK, PIECE_BISHOP };
            board_out[6'b000_110*4 +: 4] <= { COLOR_BLACK, PIECE_KNIGHT };
            board_out[6'b000_111*4 +: 4] <= { COLOR_BLACK, PIECE_ROOK };
        end else if (board_change_en) begin
            board_out[board_change_addr*4 +: 4] <= board_change_piece;
        end
    end

endmodule 