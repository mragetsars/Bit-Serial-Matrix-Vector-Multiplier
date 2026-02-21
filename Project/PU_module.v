module pu_module #(
    parameter WIDTH  = 64,
    parameter NUMBER = 4
)(
    input  wire                            clk,
    input  wire                            rst,
    input  wire                            init,
    input  wire                            bit_cnt_inc,
    input  wire [WIDTH-1:0]                i_vec_b_1,
    input  wire [NUMBER-1:0]               i_vec_a_bits_1,
    input  wire [WIDTH-1:0]                i_vec_b_2,
    input  wire [NUMBER-1:0]               i_vec_a_bits_2,
    input  wire [(WIDTH/(NUMBER/2))+2-1:0] initial_sum,
    output wire [(WIDTH/(NUMBER/2))+2-1:0] o_dot_product,
    output wire                            bit_cnt_end
);

    wire mid_i_valid;
    wire mid_i_is_msb;
    wire mid_i_is_lsb;

    wire mid_pe_reset;

    wire [(WIDTH/(NUMBER/2))+2-1:0] o_dot_product_1;
    wire [(WIDTH/(NUMBER/2))+2-1:0] o_dot_product_2;


    pu_bit_cnt #(
        .WIDTH(NUMBER+1)
    ) bit_cnt (
        .clk(clk),
        .rst(rst),
        .init(init),
        .en(bit_cnt_inc),
        .pe_start(mid_pe_reset),
        .i_valid(mid_i_valid),
        .i_is_msb(mid_i_is_msb),
        .i_is_lsb(mid_i_is_lsb),
        .pe_end(bit_cnt_end)
    );

    strips_pe #(
        .WIDTH(WIDTH),
        .NUMBER(NUMBER)
    ) pe_module_1 (
        .clk(clk),
        .rst(rst),
        .init(init),
        .i_valid(mid_i_valid),
        .i_is_msb(mid_i_is_msb),
        .i_is_lsb(mid_i_is_lsb),
        .i_vec_b(i_vec_b_1),
        .i_vec_a_bits(i_vec_a_bits_1),
        .initial_sum(initial_sum),
        .o_dot_product(o_dot_product_1)
    );

    strips_pe #(
        .WIDTH(WIDTH),
        .NUMBER(NUMBER)
    ) pe_module_2 (
        .clk(clk),
        .rst(rst),
        .init(init),
        .i_valid(mid_i_valid),
        .i_is_msb(mid_i_is_msb),
        .i_is_lsb(mid_i_is_lsb),
        .i_vec_b(i_vec_b_2),
        .i_vec_a_bits(i_vec_a_bits_2),
        .initial_sum(initial_sum),
        .o_dot_product(o_dot_product_2)
    );
    
    adder_2to1 #(
        .WIDTH((WIDTH/(NUMBER/2))+2)
    ) adder_to_answe (
        .in_0(o_dot_product_1),
        .in_1(o_dot_product_2),
        .en(1'b1),
        .out(o_dot_product)
    );

endmodule