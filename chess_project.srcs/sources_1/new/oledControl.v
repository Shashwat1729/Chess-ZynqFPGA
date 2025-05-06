`timescale 1ns / 1ps

module oledControl(
    input wire clock,
    input wire reset,
    input wire [7:0] sendData,
    input wire sendDataValid,
    output reg sendDone,
    output wire oled_spi_clk,
    output wire oled_spi_data,
    output reg oled_vdd,
    output reg oled_vbat,
    output reg oled_reset_n,
    output reg oled_dc_n
);

// State definitions
localparam IDLE = 4'b0000;
localparam DELAY = 4'b0001;
localparam INIT = 4'b0010;
localparam WAIT_SPI = 4'b0011;
localparam SEND_DATA = 4'b0100;
localparam PAGE_ADDR = 4'b0101;
localparam PAGE_ADDR1 = 4'b0110;
localparam PAGE_ADDR2 = 4'b0111;
localparam COLUMN_ADDR = 4'b1000;
localparam DONE = 4'b1001;

reg [3:0] state;
reg [3:0] nextState;
reg [7:0] spiData;
reg spiLoadData;
wire spiDone;
reg [7:0] currPage;
reg [7:0] columnAddr;
reg [7:0] byteCounter;
reg startDelay;
wire delayDone;

// Initialize OLED display
always @(posedge clock) begin
    if (reset) begin
        state <= DELAY;
        oled_vdd <= 1'b0;
        oled_vbat <= 1'b0;
        oled_reset_n <= 1'b0;
        oled_dc_n <= 1'b1;
        sendDone <= 1'b0;
        currPage <= 8'd0;
        columnAddr <= 8'd0;
        byteCounter <= 8'd0;
        startDelay <= 1'b0;
    end
    else begin
        case (state)
            DELAY: begin
                startDelay <= 1'b1;
                if (delayDone) begin
                    startDelay <= 1'b0;
                    state <= INIT;
                end
            end
            
            INIT: begin
                oled_dc_n <= 1'b0;
                case (currPage)
                    8'd0: begin // Display off
                        spiData <= 8'hAE;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd1: begin // Set memory addressing mode
                        spiData <= 8'h20;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd2: begin // Horizontal addressing mode
                        spiData <= 8'h00;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd3: begin // Set page start address
                        spiData <= 8'hB0;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd4: begin // Set COM output scan direction
                        spiData <= 8'hC8;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd5: begin // Set low column address
                        spiData <= 8'h00;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd6: begin // Set high column address
                        spiData <= 8'h10;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd7: begin // Set display start line
                        spiData <= 8'h40;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd8: begin // Set contrast control
                        spiData <= 8'h81;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd9: begin // Contrast value
                        spiData <= 8'hCF;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd10: begin // Set segment re-map
                        spiData <= 8'hA1;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd11: begin // Set normal display
                        spiData <= 8'hA6;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd12: begin // Set multiplex ratio
                        spiData <= 8'hA8;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd13: begin // 1/64 duty
                        spiData <= 8'h3F;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd14: begin // Set display offset
                        spiData <= 8'hD3;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd15: begin // No offset
                        spiData <= 8'h00;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd16: begin // Set display clock divide
                        spiData <= 8'hD5;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd17: begin // Set divide ratio
                        spiData <= 8'h80;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd18: begin // Set pre-charge period
                        spiData <= 8'hD9;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd19: begin // Pre-charge period
                        spiData <= 8'hF1;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd20: begin // Set COM pins hardware configuration
                        spiData <= 8'hDA;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd21: begin // COM pins config
                        spiData <= 8'h12;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd22: begin // Set VCOMH deselect level
                        spiData <= 8'hDB;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd23: begin // VCOM deselect level
                        spiData <= 8'h40;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd24: begin // Set charge pump
                        spiData <= 8'h8D;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd25: begin // Enable charge pump
                        spiData <= 8'h14;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd26: begin // Display on
                        spiData <= 8'hAF;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd27: begin // Set page address
                        spiData <= 8'h22;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd28: begin // Page start address
                        spiData <= 8'h00;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd29: begin // Page end address
                        spiData <= 8'h07;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd30: begin // Set column address
                        spiData <= 8'h21;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd31: begin // Column start address
                        spiData <= 8'h00;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= INIT;
                            currPage <= currPage + 1;
                        end
                    end
                    8'd32: begin // Column end address
                        spiData <= 8'h7F;
                        spiLoadData <= 1'b1;
                        if (spiDone) begin
                            spiLoadData <= 1'b0;
                            state <= WAIT_SPI;
                            nextState <= DONE;
                            currPage <= 8'd0;
                            oled_vdd <= 1'b1;
                            oled_vbat <= 1'b1;
                            oled_reset_n <= 1'b1;
                        end
                    end
                endcase
            end

            WAIT_SPI: begin
                startDelay <= 1'b1;
                if (delayDone) begin
                    startDelay <= 1'b0;
                    state <= nextState;
                end
            end

            PAGE_ADDR: begin
                spiData <= 8'h22;
                spiLoadData <= 1'b1;
                oled_dc_n <= 1'b0;
                if (spiDone) begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= PAGE_ADDR1;
                end
            end

            PAGE_ADDR1: begin
                spiData <= currPage;
                spiLoadData <= 1'b1;
                if (spiDone) begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    currPage <= currPage + 1;
                    nextState <= PAGE_ADDR2;
                end
            end

            PAGE_ADDR2: begin
                spiData <= currPage;
                spiLoadData <= 1'b1;
                if (spiDone) begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= COLUMN_ADDR;
                end
            end

            COLUMN_ADDR: begin
                spiData <= 8'h10;
                spiLoadData <= 1'b1;
                if (spiDone) begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= DONE;
                end
            end
            
            DONE: begin
                sendDone <= 1'b0;
                if (sendDataValid && columnAddr != 128 && !sendDone) begin
                    state <= SEND_DATA;
                    byteCounter <= 8;
                end
                else if (sendDataValid && columnAddr == 128 && !sendDone) begin
                    state <= PAGE_ADDR;
                    columnAddr <= 0;
                    byteCounter <= 8;
                end
            end
            
            SEND_DATA: begin
                spiData <= sendData;
                spiLoadData <= 1'b1;
                oled_dc_n <= 1'b1;
                if (spiDone) begin
                    columnAddr <= columnAddr + 1;
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    if (byteCounter != 1) begin
                        byteCounter <= byteCounter - 1;
                        nextState <= SEND_DATA;
                    end
                    else begin
                        nextState <= DONE;
                        sendDone <= 1'b1;
                    end
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

// Instantiate delay generator
delayGen delay_gen(
    .clock(clock),
    .reset(reset),
    .delayEn(startDelay),
    .delayDone(delayDone)
);

// Instantiate SPI control
spiControl spi_ctrl(
    .clock(clock),
    .reset(reset),
    .data_in(spiData),
    .load_data(spiLoadData),
    .done_send(spiDone),
    .spi_clock(oled_spi_clk),
    .spi_data(oled_spi_data)
);

endmodule 