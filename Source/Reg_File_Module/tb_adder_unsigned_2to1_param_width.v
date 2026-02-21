`timescale 1ns/1ps

module tb_adder_unsigned_2to1_param_width;

    parameter WIDTH_A   = 3;
    parameter WIDTH_B   = 6;
    parameter WIDTH_SUM = 7;

    reg  [WIDTH_A-1:0] A;
    reg  [WIDTH_B-1:0] B;
    wire [WIDTH_SUM-1:0] Sum;

    adder_2to1_param_width #(
        .WIDTH_A(WIDTH_A),
        .WIDTH_B(WIDTH_B),
        .WIDTH_SUM(WIDTH_SUM)
    ) dut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );

    initial begin

        A = 0;  B = 0;   #10;
        A = 3;  B = 12;  #10;
        A = 5;  B = 25;  #10;
        A = 7;  B = 63;  #10;
        A = 2;  B = 10;  #10;
        A = 1;  B = 50;  #10;
        A = 0;  B = 63;  #10;

        repeat (5) begin
            A = $random % (1 << WIDTH_A);
            B = $random % (1 << WIDTH_B);
            #10;
        end

        #10 $finish;
    end

endmodule
