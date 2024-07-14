module uart_transmitter (
    input wire clk,           // System clock
    input wire reset,         // Reset signal
    input wire start,         // Start transmission signal
    input wire [127:0] data,  // Data to transmit
    output wire tx,           // UART transmit pin
    output reg busy           // UART busy signal
);

    // UART parameters
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000;
    parameter BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;

    reg [3:0] bit_index;
    reg [127:0] shift_reg;
    reg [15:0] baud_counter;

    assign tx = shift_reg[0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            bit_index <= 0;
            shift_reg <= 128'b1111111111111111111111111111111111111111111111111111111111111111;
            baud_counter <= 0;
        end else if (start && !busy) begin
            busy <= 1;
            bit_index <= 0;
            shift_reg <= {1'b1, data, 1'b0};  // Add start and stop bits
            baud_counter <= 0;
        end else if (busy) begin
            if (baud_counter < BIT_PERIOD - 1) begin
                baud_counter <= baud_counter + 1;
            end else begin
                baud_counter <= 0;
                shift_reg <= {1'b1, shift_reg[127:1]};  // Shift data
                if (bit_index == 8) begin
                    busy <= 0;
                end else begin
                    bit_index <= bit_index + 1;
                end
            end
        end
    end
endmodule
