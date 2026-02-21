module mvmpu_top_module #(
    parameter WIDTH  = 64,
    parameter NUMBER = 4
)  (
    input  wire                                   clk,
    input  wire                                   rst,
    input  wire                                   start,
    input  wire signed [(WIDTH/(NUMBER/2))+2-1:0] r_data,
    output wire signed [((2*NUMBER)-1)-1:0]       address,
    output wire signed [(WIDTH/(NUMBER/2))+2-1:0] w_data,
    output wire                                   write,
    output wire                                   done
);

    wire pu_init;
    wire rgf_init;
    wire a_cnt_end;
    wire b_cnt_end;
    wire a_bit_cnt_end;
    wire b_i_cnt_end;
    wire a_cnt_inc;
    wire b_cnt_inc;
    wire a_bit_cnt_inc;
    wire b_i_cnt_inc;
    wire w_input_sel;
    wire a_w_en;
    wire b_w_en;
    wire a_rotate;

    mvmpu_controller ctrl (
        .clk                     (clk),
        .rst                     (rst),
        .start                   (start),
        .a_cnt_end               (a_cnt_end),
        .b_cnt_end               (b_cnt_end),
        .a_bit_cnt_end           (a_bit_cnt_end),
        .b_i_cnt_end             (b_i_cnt_end),
        .a_cnt_inc               (a_cnt_inc),
        .b_cnt_inc               (b_cnt_inc),
        .a_bit_cnt_inc           (a_bit_cnt_inc),
        .b_i_cnt_inc             (b_i_cnt_inc),
        .pu_init                 (pu_init),
        .rgf_init                (rgf_init),
        .w_input_sel             (w_input_sel),
        .a_w_en                  (a_w_en),
        .b_w_en                  (b_w_en),
        .a_rotate                (a_rotate),
        .r_w_sel                 (r_w_sel),
        .write                   (write),
        .done                    (done)
    );

    mvmpu_datapath #(
        .WIDTH  (WIDTH),
        .NUMBER (NUMBER)
    ) dp (
        .clk                     (clk),
        .rst                     (rst),
        .pu_init                 (pu_init),
        .rgf_init                (rgf_init),
        .a_cnt_end               (a_cnt_end),
        .b_cnt_end               (b_cnt_end),
        .a_bit_cnt_end           (a_bit_cnt_end),
        .b_i_cnt_end             (b_i_cnt_end),
        .a_cnt_inc               (a_cnt_inc),
        .b_cnt_inc               (b_cnt_inc),
        .a_bit_cnt_inc           (a_bit_cnt_inc),
        .b_i_cnt_inc             (b_i_cnt_inc),
        .w_input_sel             (w_input_sel),
        .a_w_en                  (a_w_en),
        .b_w_en                  (b_w_en),
        .a_rotate                (a_rotate),
        .r_w_sel                 (r_w_sel),
        .r_data                  (r_data),
        .address                 (address),
        .w_data                  (w_data)
    );

endmodule
