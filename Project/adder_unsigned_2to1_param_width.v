module adder_unsigned_2to1_param_width
#(
    parameter WIDTH_A = 3, 
    parameter WIDTH_B = 6,
    parameter WIDTH_SUM = 7 
)
(
    input [WIDTH_A-1:0] A, 
    input [WIDTH_B-1:0] B, 

    output [WIDTH_SUM-1:0] Sum 
);


    localparam EXTEND_A = WIDTH_SUM - WIDTH_A;
    localparam EXTEND_B = WIDTH_SUM - WIDTH_B;

    wire [WIDTH_SUM-1:0] A_ext = {{EXTEND_A{1'b0}}, A};

    wire [WIDTH_SUM-1:0] B_ext = {{EXTEND_B{1'b0}}, B};


    assign Sum = A_ext + B_ext + 8;

endmodule