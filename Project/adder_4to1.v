module adder_4to1 #(
    parameter WIDTH = 16
)(
    input  wire signed [WIDTH-1:0] in_0,
    input  wire signed [WIDTH-1:0] in_1,
    input  wire signed [WIDTH-1:0] in_2,
    input  wire signed [WIDTH-1:0] in_3,
    input  wire                    en,
    output reg  signed [WIDTH+1:0] out
);

    always @(*) begin
        if (en)
            out = in_0 + in_1 + in_2 + in_3;
        else
            out = { (WIDTH+2){1'b0} };
    end

endmodule
