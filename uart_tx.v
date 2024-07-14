module uart_tx (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire send,
    output reg tx,
    output reg ready
);
    parameter CLK_FREQ = 50000000;  // System clock frequency (50 MHz)
    parameter BAUD_RATE = 9600;     // Baud rate
    localparam BAUD_DIV = CLK_FREQ / BAUD_RATE;

    reg [3:0] bit_index;
    reg [15:0] baud_counter;
    reg [9:0] shift_reg;
    reg tx_busy;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1;
            ready <= 1'b1;
            tx_busy <= 1'b0;
            bit_index <= 4'b0;
            baud_counter <= 16'b0;
            shift_reg <= 10'b0;
        end else begin
            if (send && ready) begin
                // Start transmission
                ready <= 1'b0;
                tx_busy <= 1'b1;
                shift_reg <= {1'b1, data_in, 1'b0};  // {Stop bit, data_in, Start bit}
                bit_index <= 4'b0;
                baud_counter <= 16'b0;
            end else if (tx_busy) begin
                if (baud_counter < BAUD_DIV - 1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 16'b0;
                    tx <= shift_reg[bit_index];
                    bit_index <= bit_index + 1;
                    if (bit_index == 9) begin
                        tx_busy <= 1'b0;
                        ready <= 1'b1;
                    end
                end
            end
        end
    end
endmodule
