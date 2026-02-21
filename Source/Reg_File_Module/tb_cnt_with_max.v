`timescale 1ns/1ps

module tb_cnt_with_max;

    parameter MAX_COUNT = 7;
    parameter WIDTH = 3;

    reg clk;
    reg reset;
    reg increase;
    wire [WIDTH-1:0] count_out;

    cnt_with_max #(
        .MAX_COUNT(MAX_COUNT),
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .increase(increase),
        .count_out(count_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        increase = 0;

        #12;
        reset = 0;

        #10;
        repeat (10) begin
            increase = 1;
            #10;
            increase = 0;
            #10;
        end

        #20;
        reset = 1;
        #10;
        reset = 0;

        repeat (5) begin
            increase = 1;
            #10;
            increase = 0;
            #10;
        end

        #50;
        $finish;
    end

endmodule
