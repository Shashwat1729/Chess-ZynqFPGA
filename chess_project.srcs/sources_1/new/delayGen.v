`timescale 1ns / 1ps

module delayGen(
    input wire clock,
    input wire reset,
    input wire delayEn,
    output reg delayDone
);

// Counter for delay
reg [19:0] delayCount;

// Delay value (adjust based on your clock frequency)
// For 100MHz clock, 100,000 counts = 1ms
localparam DELAY_VALUE = 20'd100000;

always @(posedge clock) begin
    if (reset) begin
        delayCount <= 20'd0;
        delayDone <= 1'b0;
    end
    else begin
        if (delayEn) begin
            if (delayCount == DELAY_VALUE) begin
                delayCount <= 20'd0;
                delayDone <= 1'b1;
            end
            else begin
                delayCount <= delayCount + 1'b1;
                delayDone <= 1'b0;
            end
        end
        else begin
            delayCount <= 20'd0;
            delayDone <= 1'b0;
        end
    end
end

endmodule 