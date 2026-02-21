module strips_pe #(
    parameter WIDTH  = 64,
    parameter NUMBER = 4
) (
    input  wire                            clk,
    input  wire                            rst,
    input  wire                            init,
    input  wire                            i_valid,
    input  wire                            i_is_msb,
    input  wire                            i_is_lsb,
    input  wire [WIDTH-1:0]                i_vec_b,
    input  wire [NUMBER-1:0]               i_vec_a_bits,
    input  wire [(WIDTH/(NUMBER/2))+2-1:0] initial_sum,
    output wire [(WIDTH/(NUMBER/2))+2-1:0] o_dot_product
);

    wire [(WIDTH/NUMBER)-1:0]       vec_b         [0:NUMBER-1];
    wire [(WIDTH/NUMBER)-1:0]       not_vec_b     [0:NUMBER-1];
    wire [(WIDTH/NUMBER)-1:0]       a_bit_x_vec_b [0:NUMBER-1];
    wire [(WIDTH/NUMBER)+2-1:0]     a_x_b;
    wire [(WIDTH/(NUMBER/2))+2-1:0] accumulator_in;
    wire [(WIDTH/(NUMBER/2))+2-1:0] accumulator_out;

    assign vec_b[0] = i_vec_b[(WIDTH/NUMBER)-1:0];
    assign vec_b[1] = i_vec_b[2*(WIDTH/NUMBER)-1:(WIDTH/NUMBER)];
    assign vec_b[2] = i_vec_b[3*(WIDTH/NUMBER)-1:2*(WIDTH/NUMBER)];
    assign vec_b[3] = i_vec_b[4*(WIDTH/NUMBER)-1:3*(WIDTH/NUMBER)];

    assign not_vec_b[0] = - vec_b[0];
    assign not_vec_b[1] = - vec_b[1];
    assign not_vec_b[2] = - vec_b[2];
    assign not_vec_b[3] = - vec_b[3];

    mux_4to1 #(
        .WIDTH(WIDTH/NUMBER)
    ) mux_4to1_0 (
        .in_0({(WIDTH/NUMBER){1'b0}}),
        .in_1({(WIDTH/NUMBER){1'b0}}),
        .in_2(vec_b[0]),
        .in_3(not_vec_b[0]),
        .sel({i_vec_a_bits[0],i_is_msb}),
        .out(a_bit_x_vec_b[0])
    );

    mux_4to1 #(
        .WIDTH(WIDTH/NUMBER)
    ) mux_4to1_1 (
        .in_0({(WIDTH/NUMBER){1'b0}}),
        .in_1({(WIDTH/NUMBER){1'b0}}),
        .in_2(vec_b[1]),
        .in_3(not_vec_b[1]),
        .sel({i_vec_a_bits[1],i_is_msb}),
        .out(a_bit_x_vec_b[1])
    );

    mux_4to1 #(
        .WIDTH(WIDTH/NUMBER)
    ) mux_4to1_2 (
        .in_0({(WIDTH/NUMBER){1'b0}}),
        .in_1({(WIDTH/NUMBER){1'b0}}),
        .in_2(vec_b[2]),
        .in_3(not_vec_b[2]),
        .sel({i_vec_a_bits[2],i_is_msb}),
        .out(a_bit_x_vec_b[2])
    );

    mux_4to1 #(
        .WIDTH(WIDTH/NUMBER)
    ) mux_4to1_3 (
        .in_0({(WIDTH/NUMBER){1'b0}}),
        .in_1({(WIDTH/NUMBER){1'b0}}),
        .in_2(vec_b[3]),
        .in_3(not_vec_b[3]),
        .sel({i_vec_a_bits[3],i_is_msb}),
        .out(a_bit_x_vec_b[3])
    );

    adder_4to1 #(
        .WIDTH(WIDTH/NUMBER)
    ) adder_4to1_4 (
        .in_0(a_bit_x_vec_b[0]),
        .in_1(a_bit_x_vec_b[1]),
        .in_2(a_bit_x_vec_b[2]),
        .in_3(a_bit_x_vec_b[3]),
        .en(1'b1),
        .out(a_x_b)
    );

    adder_for_pe #(
        .WIDTH((WIDTH/(NUMBER/2))+2)
    ) adder_to_reg (
        .in_0(a_x_b),
        .in_1({accumulator_out[(WIDTH/(NUMBER/2)):0], 1'b0}),
        .en(1'b1),
        .out(accumulator_in)
    );

    shift_register #(
        .WIDTH((WIDTH/(NUMBER/2))+2),
        .INIT({((WIDTH/(NUMBER/2))+2){1'b0}})
    ) accumulator_shift_register (
        .clk(clk),
        .rst(rst),
        .in(accumulator_in),
        .init(init),
        .load(i_valid),
        .out(accumulator_out)
    );

    adder_2to1 #(
        .WIDTH((WIDTH/(NUMBER/2))+2)
    ) adder_to_answer (
        .in_0(initial_sum),
        .in_1(accumulator_out),
        .en(1'b1),
        .out(o_dot_product)
    );

endmodule
