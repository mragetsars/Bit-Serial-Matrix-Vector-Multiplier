module adder_for_pe #(
    parameter WIDTH = 34
)(
    input  wire signed [WIDTH/2:0] in_0,
    input  wire signed [WIDTH-1:0] in_1,
    input  wire                    en,
    output reg  signed [WIDTH-1:0] out
);

    always @(*) begin
        if (en)
            out = in_1 + {{(WIDTH-(WIDTH/2+1)){in_0[WIDTH/2]}}, in_0};
        else
            out = {WIDTH{1'b0}};
    end

endmodule

