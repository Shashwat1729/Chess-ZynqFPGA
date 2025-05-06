// Improved piece definitions and constants for chess game
`ifndef IMPROVED_PIECES_V
`define IMPROVED_PIECES_V

// Piece type definitions
`define PIECE_NONE   3'b000
`define PIECE_PAWN   3'b001
`define PIECE_KNIGHT 3'b010
`define PIECE_BISHOP 3'b011
`define PIECE_ROOK   3'b100
`define PIECE_QUEEN  3'b101
`define PIECE_KING   3'b110

// Color definitions
`define COLOR_WHITE  1'b0
`define COLOR_BLACK  1'b1

// Board dimensions
`define BOARD_WIDTH  3'b111  // 8 squares
`define BOARD_HEIGHT 3'b111  // 8 squares

// Piece values for evaluation
`define PAWN_VALUE   32'd10
`define KNIGHT_VALUE 32'd30
`define BISHOP_VALUE 32'd30
`define ROOK_VALUE   32'd50
`define QUEEN_VALUE  32'd90
`define KING_VALUE   32'd900

// Move types
`define MOVE_NORMAL    2'b00
`define MOVE_CAPTURE   2'b01
`define MOVE_CASTLE    2'b10
`define MOVE_EN_PASSANT 2'b11

// Game states
`define STATE_INITIAL     3'b000
`define STATE_PIECE_SEL   3'b001
`define STATE_PIECE_MOVE  3'b010
`define STATE_WRITE_NEW   3'b011
`define STATE_ERASE_OLD   3'b100
`define STATE_SUGGEST     3'b101

// Monte Carlo parameters
`define MC_SIMULATIONS 16
`define MC_DEPTH      3

// Monte Carlo states
`define MC_IDLE     4'b0000
`define MC_INIT     4'b0001
`define MC_SIMULATE 4'b0010
`define MC_EVALUATE 4'b0011
`define MC_UPDATE   4'b0100
`define MC_DONE     4'b0101

`endif 