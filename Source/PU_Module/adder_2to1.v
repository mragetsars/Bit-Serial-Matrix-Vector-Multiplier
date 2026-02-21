module adder_2to1 #(
    parameter WIDTH = 34
)(
    input  wire [WIDTH-1:0] in_0,
    input  wire [WIDTH-1:0] in_1,
    input  wire             en,
    output reg  [WIDTH-1:0] out
);

    always @(*) begin
        if (en)
            out = in_0 + in_1;
        else
            out = { (WIDTH){1'b0} };
    end

endmodule