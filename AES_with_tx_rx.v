module AES_with_tx_rx;
    wire [15:0] control_signal_0;
    wire [15:0] control_signal_1;
    wire [15:0] control_signal_2;
    wire [15:0] control_signal_3;
    wire [15:0] control_signal_4;
    wire [15:0] control_signal_5;
    wire [15:0] control_signal_6;
    wire [15:0] control_signal_7;
    wire [127:0] aes_input;

    // Instantiate the PID testbench
    pid_tb pid_instance (
        .control_signal_0(control_signal_0),
        .control_signal_1(control_signal_1),
        .control_signal_2(control_signal_2),
        .control_signal_3(control_signal_3),
        .control_signal_4(control_signal_4),
        .control_signal_5(control_signal_5),
        .control_signal_6(control_signal_6),
        .control_signal_7(control_signal_7)
    );

    // Instantiate the intermediate module
    intermediate_module im (
        .control_signal_0(control_signal_0),
        .control_signal_1(control_signal_1),
        .control_signal_2(control_signal_2),
        .control_signal_3(control_signal_3),
        .control_signal_4(control_signal_4),
        .control_signal_5(control_signal_5),
        .control_signal_6(control_signal_6),
        .control_signal_7(control_signal_7),
        .aes_input(aes_input)
    );

    wire [127:0] out1, out2, out3;
    reg [127:0] key1;
    reg [191:0] key2;
    reg [255:0] key3;

    AES_Encrypt aes128(aes_input, key1, out1);
    AES_Encrypt #(192, 12, 6) aes192(aes_input, key2, out2);
    AES_Encrypt #(256, 14, 8) aes256(aes_input, key3, out3);

    // UART signals
    reg clk;
    reg reset;
    wire uart_tx;
    wire tx_busy;
    wire [127:0] received_data;
    wire data_valid;

    // UART transmitter instance
    uart_transmitter uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .start(tx_start),
        .data(uart_data),
        .tx(uart_tx),
        .busy(tx_busy)
    );

    // UART receiver instance
    uart_receiver uart_rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(uart_tx),
        .data(received_data),
        .valid(data_valid)
    );

    reg [127:0] uart_data;
    reg tx_start;

    initial begin
        // Initialize keys
        key1 = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        key2 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
        key3 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

        // Initialize signals
        clk = 0;
        reset = 1;
        tx_start = 0;
        uart_data = 0;

        #10 reset = 0;

        $monitor("AES input: %h", aes_input);

        // Send AES outputs via UART
        #20;
        uart_data = out1;
        tx_start = 1;
        #20 tx_start = 0;

        #20;
        uart_data = out2;
        tx_start = 1;
        #20 tx_start = 0;

        #20;
        uart_data = out3;
        tx_start = 1;
        #20 tx_start = 0;

        #100 $finish;
    end

    always #5 clk = ~clk;

endmodule
