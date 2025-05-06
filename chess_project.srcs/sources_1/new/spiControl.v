`timescale 1ns / 1ps

module spiControl(
    input wire clock,
    input wire reset,
    input wire [7:0] data_in,
    input wire load_data,
    output reg done_send,
    output reg spi_clock,
    output reg spi_data
);

// State definitions
localparam IDLE = 2'b00;
localparam SEND = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [3:0] bit_count;
reg [7:0] shift_reg;

// SPI clock divider (for 100MHz input clock, divide by 10 for 10MHz SPI clock)
reg [3:0] clk_div;
reg spi_clk_en;

// Clean output signals
always @(posedge clock) begin
    if (reset) begin
        state <= IDLE;
        bit_count <= 4'd0;
        shift_reg <= 8'd0;
        spi_clock <= 1'b0;
        spi_data <= 1'b0;
        done_send <= 1'b0;
        clk_div <= 4'd0;
        spi_clk_en <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                done_send <= 1'b0;
                if (load_data) begin
                    state <= SEND;
                    shift_reg <= data_in;
                    bit_count <= 4'd0;
                    clk_div <= 4'd0;
                    spi_clk_en <= 1'b1;
                end
            end
            
            SEND: begin
                if (spi_clk_en) begin
                    if (clk_div == 4'd9) begin
                        clk_div <= 4'd0;
                        spi_clock <= ~spi_clock;
                        
                        if (spi_clock) begin
                            spi_data <= shift_reg[7];
                            shift_reg <= {shift_reg[6:0], 1'b0};
                            bit_count <= bit_count + 1'b1;
                            
                            if (bit_count == 4'd7) begin
                                state <= DONE;
                                spi_clk_en <= 1'b0;
                            end
                        end
                    end
                    else begin
                        clk_div <= clk_div + 1'b1;
                    end
                end
            end
            
            DONE: begin
                done_send <= 1'b1;
                state <= IDLE;
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule 