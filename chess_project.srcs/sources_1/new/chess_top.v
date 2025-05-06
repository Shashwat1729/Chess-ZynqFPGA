`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Alex Allsup & Kevin Wu
// 
// Create Date:    17:37:14 11/09/2016 
// Design Name: 
// Module Name:    chess_top 
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
module chess_top( MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS, // Disable the three memory chips
      ClkPort, // ClkPort will be the board's 100MHz clk
		BtnL, BtnU, BtnD, BtnR, BtnC,
		Sw0, // For reset   
		vga_hsync, vga_vsync, 
		vga_r0, vga_r1, vga_r2,
		vga_g0, vga_g1, vga_g2,
		vga_b0, vga_b1,
		// OLED interface
		disp1_spi_clk,
		disp1_spi_data,
		disp1_vdd,
		disp1_vbat,
		disp1_reset_n,
		disp1_dc_n,
		// LED outputs for debugging
		Ld0, Ld1, Ld2, Ld3, Ld4
    );
	 
/*  INPUTS */
// Clock & Reset I/O
input		Sw0;
input		BtnL, BtnU, BtnD, BtnR, BtnC;	
wire Reset;
assign Reset = Sw0;

/* OUTPUTS */
output wire	MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS; // just to disable them all
	assign MemOE = 0;
	assign MemWR = 0;
	assign RamCS = 0;
	assign FlashCS = 0;
	assign QuadSpiFlashCS = 0;
output wire vga_hsync, vga_vsync; 
output wire vga_r0, vga_r1, vga_r2;
output wire vga_g0, vga_g1, vga_g2;
output wire vga_b0, vga_b1;

// OLED outputs
output wire disp1_spi_clk;
output wire disp1_spi_data;
output wire disp1_vdd;
output wire disp1_vbat;
output wire disp1_reset_n;
output wire disp1_dc_n;

// LED outputs for debugging
output wire Ld0, Ld1, Ld2, Ld3, Ld4;

// connect the vga color buses to the top design's outputs
wire[2:0] vga_r;
wire[2:0] vga_g;
wire[1:0] vga_b;
assign vga_r0 = vga_r[2]; assign vga_r1 = vga_r[1]; assign vga_r2 = vga_r[0];
assign vga_g0 = vga_g[2]; assign vga_g1 = vga_g[1]; assign vga_g2 = vga_g[0];
assign vga_b0 = vga_b[1]; assign vga_b1 = vga_b[0];


/* Clocking */
input ClkPort;
reg[26:0] DIV_CLK;
wire full_clock;
BUFGP CLK_BUF(full_clock, ClkPort);

always @(posedge full_clock, posedge Reset)
begin
	if (Reset) DIV_CLK <= 0;
	else DIV_CLK <= DIV_CLK + 1'b1;
end

wire game_logic_clk, vga_clk, debounce_clk;
assign game_logic_clk = DIV_CLK[11]; // 24.4 kHz 
assign vga_clk = DIV_CLK[1]; // 25MHz for pixel freq
assign debounce_clk = DIV_CLK[11]; // 24.4 kHz; needs to match game_logic for the single clock pulses

/* Init debouncer */
wire BtnC_pulse, BtnU_pulse, BtnR_pulse, BtnL_pulse, BtnD_pulse;
input_debounce L_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnL), .Btn_pulse(BtnL_pulse));
input_debounce R_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnR), .Btn_pulse(BtnR_pulse));
input_debounce U_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnU), .Btn_pulse(BtnU_pulse));
input_debounce D_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnD), .Btn_pulse(BtnD_pulse));
input_debounce C_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnC), .Btn_pulse(BtnC_pulse));

/* Piece Definitions */
localparam PIECE_NONE   = 3'b000;
localparam PIECE_PAWN   = 3'b001;
localparam PIECE_KNIGHT = 3'b010;
localparam PIECE_BISHOP = 3'b011;
localparam PIECE_ROOK   = 3'b100;
localparam PIECE_QUEEN  = 3'b101;
localparam PIECE_KING   = 3'b110;

localparam COLOR_WHITE  = 0;
localparam COLOR_BLACK  = 1;

wire [255:0] board_out;
wire [255:0] passable_board;

// Connect board_out directly to passable_board
assign passable_board = board_out;

/* Init board initialization module */
board_init board_init_inst (
    .clk(game_logic_clk),
    .reset(Reset),
    .board_change_addr(board_change_addr),
    .board_change_piece(board_change_piece),
    .board_change_en(board_change_en_wire),
    .board_out(board_out)
);

/* Init game logic module and its output wires */
wire[5:0] board_change_addr;
wire[3:0] board_change_piece;
wire[5:0] cursor_addr;
wire[5:0] selected_piece_addr;
wire hilite_selected_square;
wire[3:0] logic_state;
wire board_change_en_wire;
wire is_in_initial_state;
wire[5:0] suggested_move_addr;
wire show_suggestion;

// Add OLED display and score tracking
wire [3:0] white_score;
wire [3:0] black_score;

// Instantiate the game logic module
game_logic game_logic_inst (
    .CLK(game_logic_clk),
    .RESET(Reset),
    .board_input(passable_board),
    .board_out_addr(board_change_addr),
    .board_out_piece(board_change_piece),
    .board_change_en_wire(board_change_en_wire),
    .cursor_addr(cursor_addr),
    .selected_addr(selected_piece_addr),
    .hilite_selected_square(hilite_selected_square),
    .BtnU(BtnU_pulse),
    .BtnL(BtnL_pulse),
    .BtnC(BtnC_pulse),
    .BtnR(BtnR_pulse),
    .BtnD(BtnD_pulse),
    .state(logic_state),
    .move_is_legal(Ld4),
    .is_in_initial_state(is_in_initial_state),
    .suggested_move_addr(suggested_move_addr),
    .show_suggestion(show_suggestion),
    .white_score(white_score),
    .black_score(black_score)
);

assign { Ld3, Ld2, Ld1, Ld0 } = logic_state; // useful for debugging, show state machine on LEDs

/* Init VGA interface */
display_interface display_interface(
	.CLK(vga_clk), // 25 MHz
	.RESET(Reset),
	.HSYNC(vga_hsync), // direct outputs to VGA monitor
	.VSYNC(vga_vsync),
	.R(vga_r),
	.G(vga_g),
	.B(vga_b),
	.BOARD(passable_board), // the 64x4 array for the board contents
	.CURSOR_ADDR(cursor_addr), // 6 bit address showing what square to hilite
	.SELECT_ADDR(selected_piece_addr), // 6b address showing the address of which piece is selected
	.SELECT_EN(hilite_selected_square), // binary flag to show a selected piece
	.SUGGESTED_MOVE_ADDR(suggested_move_addr), // 6b address showing suggested move
	.SHOW_SUGGESTION(show_suggestion) // binary flag to show suggested move
);

/* Init OLED interface */
chess_oled_display oled_display(
    .clk(game_logic_clk),
    .reset(Reset),
    .data_in(8'h00),  // Not used in new implementation
    .data_valid(1'b0), // Not used in new implementation
    .data_ready(),     // Not used in new implementation
    .white_score(white_score),  // Connect white score from game logic
    .black_score(black_score),  // Connect black score from game logic
    .oled_spi_clk(disp1_spi_clk),
    .oled_spi_data(disp1_spi_data),
    .oled_vdd(disp1_vdd),
    .oled_vbat(disp1_vbat),
    .oled_reset_n(disp1_reset_n),
    .oled_dc_n(disp1_dc_n)
);

// Piece display signals
reg [11:0] piece_color;
reg [3:0] piece_pattern;

// Piece display logic with distinct colors and patterns
always @(*) begin
	case (board_out[selected_piece_addr*4 +: 4])
		4'b0001: begin // White Pawn
			piece_color = 12'hFFF;  // White
			piece_pattern = 4'b0001; // Pawn pattern (small circle)
		end
		4'b0010: begin // White Rook
			piece_color = 12'hFFF;  // White
			piece_pattern = 4'b0010; // Rook pattern (square with corners)
		end
		4'b0011: begin // White Knight
			piece_color = 12'hFFF;  // White
			piece_pattern = 4'b0011; // Knight pattern (L-shape)
		end
		4'b0100: begin // White Bishop
			piece_color = 12'hFFF;  // White
			piece_pattern = 4'b0100; // Bishop pattern (diagonal cross)
		end
		4'b0101: begin // White Queen
			piece_color = 12'hFFF;  // White
			piece_pattern = 4'b0101; // Queen pattern (crown)
		end
		4'b0110: begin // White King
			piece_color = 12'hFFF;  // White
			piece_pattern = 4'b0110; // King pattern (cross with circle)
		end
		4'b1001: begin // Black Pawn
			piece_color = 12'hF00;  // Red
			piece_pattern = 4'b0001; // Pawn pattern (small circle)
		end
		4'b1010: begin // Black Rook
			piece_color = 12'hF00;  // Red
			piece_pattern = 4'b0010; // Rook pattern (square with corners)
		end
		4'b1011: begin // Black Knight
			piece_color = 12'hF00;  // Red
			piece_pattern = 4'b0011; // Knight pattern (L-shape)
		end
		4'b1100: begin // Black Bishop
			piece_color = 12'hF00;  // Red
			piece_pattern = 4'b0100; // Bishop pattern (diagonal cross)
		end
		4'b1101: begin // Black Queen
			piece_color = 12'hF00;  // Red
			piece_pattern = 4'b0101; // Queen pattern (crown)
		end
		4'b1110: begin // Black King
			piece_color = 12'hF00;  // Red
			piece_pattern = 4'b0110; // King pattern (cross with circle)
		end
		default: begin
			piece_color = 12'h000;  // Black (empty square)
			piece_pattern = 4'b0000; // No pattern
		end
	endcase
end

endmodule