module mvmpu_datapath #(
    parameter WIDTH  = 64,
    parameter NUMBER = 4
) (
    input  wire                      clk,
    input  wire                      rst,
    input  wire                      pu_init,
    input  wire                      rgf_init,
    input  wire                      a_cnt_end,
    input  wire                      b_cnt_end,
    input  wire                      a_bit_cnt_end,
    input  wire                      b_i_cnt_end,
    input  wire                      a_cnt_inc,
    input  wire                      b_cnt_inc,
    input  wire                      a_bit_cnt_inc,
    input  wire                      b_i_cnt_inc,
    input  wire                      w_input_sel,
    input  wire                      a_w_en,
    input  wire                      b_w_en,
    input  wire                      a_rotate,
    input  wire                      r_w_sel,
    input  wire [33:0]               r_data,
    output wire [6:0]                address,
    output wire [33:0]               w_data
);

    wire a_bit_wire_0;
    wire a_bit_wire_1;
    wire a_bit_wire_2;
    wire a_bit_wire_3;
    wire a_bit_wire_4;
    wire a_bit_wire_5;
    wire a_bit_wire_6;
    wire a_bit_wire_7;

    wire [15:0] b_wire_0;
    wire [15:0] b_wire_1;
    wire [15:0] b_wire_2;
    wire [15:0] b_wire_3;
    wire [15:0] b_wire_4;
    wire [15:0] b_wire_5;
    wire [15:0] b_wire_6;
    wire [15:0] b_wire_7;

    wire [2:0] b_i_cnt_out;

    wire [6:0] r_address;
    wire [6:0] w_address;

    pu_module #(
        .WIDTH  (WIDTH),
        .NUMBER (NUMBER)
    ) pu (
        .clk            (clk),
        .rst            (rst),
        .init           (pu_init),
        .bit_cnt_inc    (a_bit_cnt_inc),
        .i_vec_b_1      ({b_wire_0, b_wire_1, b_wire_2, b_wire_3}),
        .i_vec_a_bits_1 ({a_bit_wire_0, a_bit_wire_1, a_bit_wire_2, a_bit_wire_3}),
        .i_vec_b_2      ({b_wire_4, b_wire_5, b_wire_6, b_wire_7}),
        .i_vec_a_bits_2 ({a_bit_wire_4, a_bit_wire_5, a_bit_wire_6, a_bit_wire_7}),
        .initial_sum    (34'b0000000000000000000000000000000000),
        .o_dot_product  (w_data),
        .bit_cnt_end    (a_bit_cnt_end)
    );

    reg_file #(
        .DATA_WIDTH     (WIDTH/NUMBER),
        .WORD_COUNT     (2*NUMBER),
        .ADDR_WIDTH     (NUMBER-1),
        .COUNT_WIDTH    (NUMBER-1),
        .MAX_COUNT      ((2*NUMBER)-1),
        .MEM_ADDR_WIDTH ((2*NUMBER)-1)
    ) reg_file (
        .clk              (clk),
        .rst              (rst),
        .a_w_en           (a_w_en),
        .b_w_en           (b_w_en),
        .a_rotate         (a_rotate),
        .data_in          (r_data),
        .a_cnt_increase   (a_cnt_inc),
        .b_cnt_increase   (b_cnt_inc),
        .b_i_cnt_increase (b_i_cnt_inc),
        .w_input_sel      (w_input_sel),
        .a_0_msb_out      (a_bit_wire_0),
        .a_1_msb_out      (a_bit_wire_1),
        .a_2_msb_out      (a_bit_wire_2),
        .a_3_msb_out      (a_bit_wire_3),
        .a_4_msb_out      (a_bit_wire_4),
        .a_5_msb_out      (a_bit_wire_5),
        .a_6_msb_out      (a_bit_wire_6),
        .a_7_msb_out      (a_bit_wire_7),
        .b_0_out          (b_wire_0),
        .b_1_out          (b_wire_1),
        .b_2_out          (b_wire_2),
        .b_3_out          (b_wire_3),
        .b_4_out          (b_wire_4),
        .b_5_out          (b_wire_5),
        .b_6_out          (b_wire_6),
        .b_7_out          (b_wire_7),
        .memory_r_addr    (r_address),
        .b_i_cnt_out      (b_i_cnt_out),
        .b_i_cnt_end      (b_i_cnt_end),
        .a_cnt_end        (a_cnt_end),
        .b_cnt_end        (b_cnt_end)
    );

    assign w_address = {4'b0000,b_i_cnt_out} + 7'b1001000;

    mux_2to1 #(
        .WIDTH ((2*NUMBER)-1)
    ) mux_to_addr (
        .a   (r_address),
        .b   (w_address),
        .sel (r_w_sel),
        .y   (address)
    );

endmodule
