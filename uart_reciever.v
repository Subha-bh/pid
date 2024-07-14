module uart_receiver (
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [127:0] data,
    output reg valid
);

    // UART parameters
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000;
    parameter BIT_TIME = CLOCK_FREQ / BAUD_RATE;

    reg [15:0] bit_counter;
    reg [3:0] bit_index;
    reg receiving;
    reg [127:0] data_buffer;
    reg [3:0] byte_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 0;
            bit_index <= 0;
            receiving <= 0;
            data_buffer <= 0;
            data <= 0;
            valid <= 0;
            byte_index <= 0;
        end else begin
            if (!receiving) begin
                if (rx == 0) begin // Start bit detected
                    receiving <= 1;
                    bit_counter <= BIT_TIME / 2;
                    bit_index <= 0;
                end
            end else begin
                bit_counter <= bit_counter - 1;
                if (bit_counter == 0) begin
                    bit_counter <= BIT_TIME;
                    if (bit_index < 8) begin
                        data_buffer[(byte_index*8) + bit_index] <= rx;
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        byte_index <= byte_index + 1;
                        if (byte_index == 15) begin
                            data <= data_buffer;
                            valid <= 1;
                            receiving <= 0;
                        end
                    end
                end
            end
        end
    end
endmodule
