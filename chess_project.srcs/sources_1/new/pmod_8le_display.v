`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024
// Design Name: Pmod 8LE Interface
// Module Name: pmod_8le_display
// Project Name: Chess Game
// Target Devices: ZedBoard
// Tool versions: 
// Description: Interface for Pmod 8LE 7-segment display module
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module pmod_8le_display(
    input wire CLK,
    input wire RESET,
    input wire [15:0] display_data,
    output reg [7:0] segment,
    output reg [7:0] anode
);

    // Clock divider for multiplexing
    reg [16:0] clk_div = 0;
    reg [2:0] digit_select = 0;
    
    // BCD to 7-segment decoder
    reg [6:0] bcd_to_seg;
    always @(*) begin
        case(display_data[digit_select*4 +: 4])
            4'h0: bcd_to_seg = 7'b1000000; // 0
            4'h1: bcd_to_seg = 7'b1111001; // 1
            4'h2: bcd_to_seg = 7'b0100100; // 2
            4'h3: bcd_to_seg = 7'b0110000; // 3
            4'h4: bcd_to_seg = 7'b0011001; // 4
            4'h5: bcd_to_seg = 7'b0010010; // 5
            4'h6: bcd_to_seg = 7'b0000010; // 6
            4'h7: bcd_to_seg = 7'b1111000; // 7
            4'h8: bcd_to_seg = 7'b0000000; // 8
            4'h9: bcd_to_seg = 7'b0010000; // 9
            4'ha: bcd_to_seg = 7'b0001000; // A
            4'hb: bcd_to_seg = 7'b0000011; // b
            4'hc: bcd_to_seg = 7'b1000110; // C
            4'hd: bcd_to_seg = 7'b0100001; // d
            4'he: bcd_to_seg = 7'b0000110; // E
            4'hf: bcd_to_seg = 7'b0001110; // F
            default: bcd_to_seg = 7'b1111111; // All segments off
        endcase
    end

    // Clock divider and digit selection
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            clk_div <= 0;
            digit_select <= 0;
        end else begin
            clk_div <= clk_div + 1;
            if (clk_div == 0) begin
                digit_select <= digit_select + 1;
            end
        end
    end

    // Output logic
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            segment <= 8'b11111111;
            anode <= 8'b11111111;
        end else begin
            segment <= {1'b1, bcd_to_seg}; // Add decimal point bit
            anode <= ~(1 << digit_select); // Active low anode selection
        end
    end

endmodule 