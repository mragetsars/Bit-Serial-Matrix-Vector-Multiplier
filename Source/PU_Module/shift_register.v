module shift_register #(
    parameter             WIDTH = 16,
    parameter [WIDTH-1:0] INIT  = {WIDTH{1'b0}}
) (
    input  wire             clk,
    input  wire             rst,
    input  wire [WIDTH-1:0] in,
    input  wire             init,
    input  wire             load,
    output wire [WIDTH-1:0] out
);

    reg [WIDTH-1:0] data;

    initial data = {WIDTH{1'b0}};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data <= {WIDTH{1'b0}};
        end else if (init) begin
            data <= INIT;
        end else if (load) begin
            data <= in;
        end
    end


    assign out = data[WIDTH-1:0];

endmodule