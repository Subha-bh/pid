module AES_Encrypt_tb;
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

    AES_Encrypt a(aes_input, key1, out1);
    AES_Encrypt #(192, 12, 6) b(aes_input, key2, out2);
    AES_Encrypt #(256, 14, 8) c(aes_input, key3, out3);

    initial begin
        // Initialize keys
        key1 = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        key2 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
        key3 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

        $monitor("AES input: %h", aes_input);

        #10;
        $monitor("in128= %h, key128= %h ,out128= %h", aes_input, key1, out1);
        #10;
        $monitor("in192= %h, key192= %h ,out192= %h", aes_input, key2, out2);
        #10;
        $monitor("in256= %h, key256= %h ,out256= %h", aes_input, key3, out3);
        #10;
    end
    
    
endmodule
