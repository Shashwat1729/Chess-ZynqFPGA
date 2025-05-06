`timescale 1ns / 1ps

module chess_oled_display(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire data_valid,
    output wire data_ready,
    // Add score inputs
    input wire [3:0] white_score,
    input wire [3:0] black_score,
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

// King's Indian Defense moves
localparam KID_LENGTH = 15;
reg [7:0] kid_string [0:KID_LENGTH-1];

// State machine states
localparam IDLE = 3'b000;
localparam INIT = 3'b001;
localparam SEND_TITLE = 3'b010;
localparam SEND_SCORE = 3'b011;
localparam SEND_KID = 3'b100;
localparam DONE = 3'b101;
localparam WAIT = 3'b110;

reg [2:0] state;
reg [7:0] send_data;
reg send_data_valid;
wire send_done;
reg [3:0] byte_counter;
reg [7:0] init_counter;
reg [19:0] delay_count;

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

    // "KID: Nf6 g6"
    kid_string[0] = 8'h4B; // K
    kid_string[1] = 8'h49; // I
    kid_string[2] = 8'h44; // D
    kid_string[3] = 8'h3A; // :
    kid_string[4] = 8'h20; // space
    kid_string[5] = 8'h4E; // N
    kid_string[6] = 8'h66; // f
    kid_string[7] = 8'h36; // 6
    kid_string[8] = 8'h20; // space
    kid_string[9] = 8'h67; // g
    kid_string[10] = 8'h36; // 6
    kid_string[11] = 8'h20; // space
    kid_string[12] = 8'h42; // B
    kid_string[13] = 8'h67; // g
    kid_string[14] = 8'h37; // 7
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
        state <= INIT;
        send_data_valid <= 1'b0;
        byte_counter <= 4'b0;
        init_counter <= 8'd0;
        delay_count <= 20'd0;
    end else begin
        case (state)
            INIT: begin
                if (delay_count == 20'd1000000) begin
                    delay_count <= 20'd0;
                    state <= SEND_TITLE;
                    byte_counter <= 4'b0;
                end else begin
                    delay_count <= delay_count + 1;
                end
            end
            
            SEND_TITLE: begin
                if (!send_done) begin
                    send_data <= title_string[byte_counter];
                    send_data_valid <= 1'b1;
                end else begin
                    send_data_valid <= 1'b0;
                    byte_counter <= byte_counter + 1;
                    if (byte_counter < TITLE_LENGTH - 1) begin
                        state <= SEND_TITLE;
                    end else begin
                        state <= WAIT;
                        delay_count <= 20'd0;
                    end
                end
            end
            
            WAIT: begin
                if (delay_count == 20'd100000) begin
                    delay_count <= 20'd0;
                    if (state == SEND_TITLE) begin
                        state <= SEND_SCORE;
                        byte_counter <= 4'b0;
                    end else if (state == SEND_SCORE) begin
                        state <= SEND_KID;
                        byte_counter <= 4'b0;
                    end else if (state == SEND_KID) begin
                        state <= DONE;
                    end
                end else begin
                    delay_count <= delay_count + 1;
                end
            end
            
            SEND_SCORE: begin
                if (!send_done) begin
                    send_data <= score_string[byte_counter];
                    send_data_valid <= 1'b1;
                end else begin
                    send_data_valid <= 1'b0;
                    byte_counter <= byte_counter + 1;
                    if (byte_counter < SCORE_LENGTH - 1) begin
                        state <= SEND_SCORE;
                    end else begin
                        state <= WAIT;
                        delay_count <= 20'd0;
                    end
                end
            end

            SEND_KID: begin
                if (!send_done) begin
                    send_data <= kid_string[byte_counter];
                    send_data_valid <= 1'b1;
                end else begin
                    send_data_valid <= 1'b0;
                    byte_counter <= byte_counter + 1;
                    if (byte_counter < KID_LENGTH - 1) begin
                        state <= SEND_KID;
                    end else begin
                        state <= WAIT;
                        delay_count <= 20'd0;
                    end
                end
            end
            
            DONE: begin
                state <= DONE;
            end
            
            default: state <= INIT;
        endcase
    end
end

// Instantiate OLED control module
oledControl oled_ctrl (
    .clock(clk),
    .reset(reset),
    .sendData(send_data),
    .sendDataValid(send_data_valid),
    .sendDone(send_done),
    .oled_spi_clk(oled_spi_clk),
    .oled_spi_data(oled_spi_data),
    .oled_vdd(oled_vdd),
    .oled_vbat(oled_vbat),
    .oled_reset_n(oled_reset_n),
    .oled_dc_n(oled_dc_n)
);

// Connect data_ready to send_done
assign data_ready = send_done;

endmodule 