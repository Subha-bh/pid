`timescale 1ns / 1ps

module pid_tb(
    output reg [15:0] control_signal_0,
    output reg [15:0] control_signal_1,
    output reg [15:0] control_signal_2,
    output reg [15:0] control_signal_3,
    output reg [15:0] control_signal_4,
    output reg [15:0] control_signal_5,
    output reg [15:0] control_signal_6,
    output reg [15:0] control_signal_7
);
    reg  clk = 0;
    reg  rst_n = 0;
    reg  [15:0] setpoint = 0;
    reg  [15:0] feedback = 0;
    reg  [15:0] Kp = 800;
    reg  [15:0] Ki = 1000;
    reg  [15:0] Kd = 0;
    reg  [15:0] clk_prescaler = 0;
    wire [15:0] control_signal;

    reg [3:0] index = 0; // Index to keep track of the control signals

    pid_controller DUT(
        .clk(clk),
        .rst_n(rst_n),
        .setpoint(setpoint),
        .feedback(feedback),
        .Kp(Kp),
        .Ki(Ki),
        .Kd(Kd),
        .clk_prescaler(clk_prescaler),
        .control_signal(control_signal)
    );

    initial begin
        rst_n <= 0; // Assert reset
        clk_prescaler <= 5; 
        setpoint <= 20;
        Kp <= 800;
        Ki <= 1000;
        Kd <= 0;
        #20 rst_n <= 1; // Deassert reset
    end

    always #1 clk = ~clk;

    always begin
        #20 feedback <= 1;
        #15 feedback <= 5;
        #15 feedback <= 8;
        #15 feedback <= 10; 
        #15 feedback <= 13;     
        #15 feedback <= 15;     
        #15 feedback <= 16;  
        #15 feedback <= 25;   
        #25 $finish;
    end

    always @(posedge clk) begin
        if (rst_n) begin
            case (index)
                0: control_signal_0 <= control_signal;
                1: control_signal_1 <= control_signal;
                2: control_signal_2 <= control_signal;
                3: control_signal_3 <= control_signal;
                4: control_signal_4 <= control_signal;
                5: control_signal_5 <= control_signal;
                6: control_signal_6 <= control_signal;
                7: control_signal_7 <= control_signal;
            endcase
            index <= index + 1;
        end
    end

    initial begin
        $monitor("Control signal is %d", control_signal);
    end
endmodule
