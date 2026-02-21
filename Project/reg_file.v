module reg_file #(
    parameter DATA_WIDTH     = 16,
    parameter WORD_COUNT     = 8,  
    parameter ADDR_WIDTH     = 3, 
    parameter COUNT_WIDTH    = 3,  
    parameter MAX_COUNT      = 7,  
    parameter MEM_ADDR_WIDTH = 7  
)(
    input  wire                      clk,
    input  wire                      rst,
    input  wire                      a_w_en,
    input  wire                      b_w_en,
    input  wire                      a_rotate,
    input  wire [DATA_WIDTH-1:0]     data_in,
    input  wire                      a_cnt_increase,
    input  wire                      b_cnt_increase,
    input  wire                      b_i_cnt_increase,
    input  wire                      w_input_sel,
    output wire                      a_0_msb_out,
    output wire                      a_1_msb_out,
    output wire                      a_2_msb_out,
    output wire                      a_3_msb_out,
    output wire                      a_4_msb_out,
    output wire                      a_5_msb_out,
    output wire                      a_6_msb_out,
    output wire                      a_7_msb_out,
    output wire [DATA_WIDTH-1:0]     b_0_out,
    output wire [DATA_WIDTH-1:0]     b_1_out,
    output wire [DATA_WIDTH-1:0]     b_2_out,
    output wire [DATA_WIDTH-1:0]     b_3_out,
    output wire [DATA_WIDTH-1:0]     b_4_out,
    output wire [DATA_WIDTH-1:0]     b_5_out,
    output wire [DATA_WIDTH-1:0]     b_6_out,
    output wire [DATA_WIDTH-1:0]     b_7_out,
    output wire [MEM_ADDR_WIDTH-1:0] memory_r_addr,
    output wire [COUNT_WIDTH-1:0]    b_i_cnt_out,
    output wire                      b_i_cnt_end,
    output wire                      a_cnt_end,
    output wire                      b_cnt_end
);


    wire [ADDR_WIDTH-1:0] a_w_addr;
    wire [ADDR_WIDTH-1:0] b_w_addr;


    a_reg_file #(
        .DATA_WIDTH (DATA_WIDTH),
        .WORD_COUNT (WORD_COUNT),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) a_reg_file_inst (
        .clk         (clk),
        .reset       (rst),
        .w_en        (a_w_en),
        .w_addr      (a_w_addr),
        .w_data      (data_in),
        .rotate      (a_rotate),

        .a_0_msb_out (a_0_msb_out),
        .a_1_msb_out (a_1_msb_out),
        .a_2_msb_out (a_2_msb_out),
        .a_3_msb_out (a_3_msb_out),
        .a_4_msb_out (a_4_msb_out),
        .a_5_msb_out (a_5_msb_out),
        .a_6_msb_out (a_6_msb_out),
        .a_7_msb_out (a_7_msb_out)
    );


    b_reg_file #(
        .DATA_WIDTH (DATA_WIDTH),
        .WORD_COUNT (WORD_COUNT),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) b_reg_file_inst (
        .clk     (clk),
        .reset   (rst),
        .w_en    (b_w_en),
        .w_addr  (b_w_addr),
        .w_data  (data_in),

        .b_0_out (b_0_out),
        .b_1_out (b_1_out),
        .b_2_out (b_2_out),
        .b_3_out (b_3_out),
        .b_4_out (b_4_out),
        .b_5_out (b_5_out),
        .b_6_out (b_6_out),
        .b_7_out (b_7_out)
    );


    cnt_with_max #(
        .MAX_COUNT (MAX_COUNT),
        .WIDTH     (COUNT_WIDTH)
    ) a_cnt_inst (
        .clk       (clk),
        .reset     (rst),
        .increase  (a_cnt_increase),
        .count_out (a_w_addr),
        .count_end (a_cnt_end)
    );

    cnt_with_max #(
        .MAX_COUNT (MAX_COUNT),
        .WIDTH     (COUNT_WIDTH)
    ) b_cnt_inst (
        .clk       (clk),
        .reset     (rst),
        .increase  (b_cnt_increase),
        .count_out (b_w_addr),
        .count_end (b_cnt_end)
    );

    cnt_with_max #(
        .MAX_COUNT (MAX_COUNT),
        .WIDTH     (COUNT_WIDTH)
    ) b_i_cnt_inst (
        .clk       (clk),
        .reset     (rst),
        .increase  (b_i_cnt_increase),
        .count_out (b_i_cnt_out),
        .count_end (b_i_cnt_end)
    );


    wire [MEM_ADDR_WIDTH-1:0] memory_b_r_addr;

    adder_unsigned_2to1_param_width #(
        .WIDTH_A   (ADDR_WIDTH),
        .WIDTH_B   (COUNT_WIDTH + 3),
        .WIDTH_SUM (MEM_ADDR_WIDTH)
    ) adder_unsigned_inst (
        .A   (b_w_addr),
        .B   ({b_i_cnt_out, 3'b000}),
        .Sum (memory_b_r_addr)
    );


    mux_2to1 #(
        .WIDTH (MEM_ADDR_WIDTH)
    ) mux_2to1_inst (
        .a   ({ {(MEM_ADDR_WIDTH-ADDR_WIDTH){1'b0}} , a_w_addr }),
        .b   (memory_b_r_addr),
        .sel (w_input_sel),
        .y   (memory_r_addr)
    );

endmodule
