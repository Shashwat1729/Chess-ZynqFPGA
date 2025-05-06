`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2024
// Design Name: 
// Module Name: oled_display
// Project Name: Chess FPGA
// Target Devices: 
// Tool Versions: 
// Description: OLED display module for Chess FPGA project
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module oled_display(
    input wire clk,           // 100MHz clock
    input wire reset,         // Reset signal
    input wire [3:0] white_score,  // White player score
    input wire [3:0] black_score,  // Black player score
    // OLED interface
    output wire oled_spi_clk,
    output wire oled_spi_data,
    output wire oled_vdd,
    output wire oled_vbat,
    output wire oled_reset_n,
    output wire oled_dc_n
);

    // Title string "Chess FPGA"
    localparam TITLE_LENGTH = 10;
    reg [7:0] title_string [0:TITLE_LENGTH-1];
    
    // Score string "W:0 B:0"
    localparam SCORE_LENGTH = 7;
    reg [7:0] score_string [0:SCORE_LENGTH-1];
    
    // State machine states
    localparam IDLE = 3'b000;
    localparam SEND_TITLE = 3'b001;
    localparam SEND_SCORE = 3'b010;
    localparam DONE = 3'b011;
    
    reg [2:0] state;
    reg [7:0] send_data;
    reg send_data_valid;
    wire send_done;
    reg [3:0] byte_counter;
    
    // Initialize strings
    initial begin
        // "Chess FPGA"
        title_string[0] = 8'h43; // C
        title_string[1] = 8'h68; // h
        title_string[2] = 8'h65; // e
        title_string[3] = 8'h73; // s
        title_string[4] = 8'h73; // s
        title_string[5] = 8'h20; // space
        title_string[6] = 8'h46; // F
        title_string[7] = 8'h50; // P
        title_string[8] = 8'h47; // G
        title_string[9] = 8'h41; // A
        
        // "W:0 B:0" (will be updated with actual scores)
        score_string[0] = 8'h57; // W
        score_string[1] = 8'h3A; // :
        score_string[2] = 8'h30; // 0 (will be updated)
        score_string[3] = 8'h20; // space
        score_string[4] = 8'h42; // B
        score_string[5] = 8'h3A; // :
        score_string[6] = 8'h30; // 0 (will be updated)
    end
    
    // Update score string with current scores
    always @(posedge clk) begin
        if (reset) begin
            score_string[2] <= 8'h30 + white_score; // Convert score to ASCII
            score_string[6] <= 8'h30 + black_score; // Convert score to ASCII
        end else begin
            score_string[2] <= 8'h30 + white_score; // Convert score to ASCII
            score_string[6] <= 8'h30 + black_score; // Convert score to ASCII
        end
    end
    
    // State machine for sending data to OLED
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            send_data_valid <= 1'b0;
            byte_counter <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (!send_done) begin
                        send_data <= title_string[byte_counter];
                        send_data_valid <= 1'b1;
                        state <= SEND_TITLE;
                    end
                end
                
                SEND_TITLE: begin
                    if (send_done) begin
                        send_data_valid <= 1'b0;
                        byte_counter <= byte_counter + 1;
                        if (byte_counter < TITLE_LENGTH - 1) begin
                            state <= IDLE;
                        end else begin
                            state <= SEND_SCORE;
                            byte_counter <= 4'b0;
                        end
                    end
                end
                
                SEND_SCORE: begin
                    if (!send_done) begin
                        send_data <= score_string[byte_counter];
                        send_data_valid <= 1'b1;
                        state <= SEND_SCORE;
                    end else begin
                        send_data_valid <= 1'b0;
                        byte_counter <= byte_counter + 1;
                        if (byte_counter < SCORE_LENGTH - 1) begin
                            state <= SEND_SCORE;
                        end else begin
                            state <= DONE;
                        end
                    end
                end
                
                DONE: begin
                    state <= DONE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end
    
    // Instantiate OLED control module
    oledControl oled_ctrl (
        .clock(clk),
        .reset(reset),
        .oled_spi_clk(oled_spi_clk),
        .oled_spi_data(oled_spi_data),
        .oled_vdd(oled_vdd),
        .oled_vbat(oled_vbat),
        .oled_reset_n(oled_reset_n),
        .oled_dc_n(oled_dc_n),
        .sendData(send_data),
        .sendDataValid(send_data_valid),
        .sendDone(send_done)
    );
    
endmodule 