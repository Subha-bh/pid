module intermediate_module (
    input [15:0] control_signal_0,
    input [15:0] control_signal_1,
    input [15:0] control_signal_2,
    input [15:0] control_signal_3,
    input [15:0] control_signal_4,
    input [15:0] control_signal_5,
    input [15:0] control_signal_6,
    input [15:0] control_signal_7,
    output reg [127:0] aes_input
);
    always @(*) begin
        aes_input = {control_signal_0, control_signal_1, control_signal_2, control_signal_3,
                     control_signal_4, control_signal_5, control_signal_6, control_signal_7};
    end
endmodule
