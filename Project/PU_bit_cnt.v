module pu_bit_cnt #(
    parameter             WIDTH = 5,
    parameter [WIDTH-1:0] INIT  = {WIDTH{1'b0}}
)  (
    input  wire clk,
    input  wire rst,
    input  wire init,
    input  wire en,
    output reg  pe_start,
    output reg  i_valid,
    output reg  i_is_msb,
    output reg  i_is_lsb,
    output reg  pe_end
);

    reg [WIDTH-1:0] count;

    initial count = {WIDTH{1'b0}};

    always @(posedge rst or posedge en or posedge init) begin
        if (rst) begin
            count <= {WIDTH{1'b0}};
        end else if (init) begin
            count <= INIT;
        end else if (en) begin
            count <= count + 1'b1;
        end
    end

    assign i_valid  = (count != 0 && count != 17) ? 1'b1 && en : 1'b0;

    assign pe_start = (init)        ? 1'b1       : 1'b0;
    assign i_is_msb = (count == 1)  ? 1'b1 && en : 1'b0;
    assign i_is_lsb = (count == 16) ? 1'b1 && en : 1'b0;
    assign pe_end   = (i_is_lsb)    ? 1'b1       : 1'b0;

endmodule