module top_module (
    input wire [15:0] control_signal_0,
    input wire [15:0] control_signal_1,
    input wire [15:0] control_signal_2,
    input wire [15:0] control_signal_3,
    input wire [15:0] control_signal_4,
    input wire [15:0] control_signal_5,
    input wire [15:0] control_signal_6,
    input wire [15:0] control_signal_7,
    input wire clk,
    input wire reset_n,
    input wire init,
    input wire next,
    input wire mode,
    output wire ready,
    output wire [255:0] digest,
    output wire digest_valid
);
    // Internal signal to connect intermediate module output to sha256_core input
    wire [127:0] aes_input;

    // Instantiate the intermediate module
    intermediate_module intermediate_inst (
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

    // Instantiate the sha256_core module
    sha256_core sha256_inst (
        .clk(clk),
        .reset_n(reset_n),
        .init(init),
        .next(next),
        .mode(mode),
        .block({aes_input, aes_input}), // Concatenating aes_input to form 512-bit input block
        .ready(ready),
        .digest(digest),
        .digest_valid(digest_valid)
    );
endmodule
