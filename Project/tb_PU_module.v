`timescale 1ns/1ns
module tb_pu_module;

    localparam WIDTH  = 64;
    localparam NUMBER = 4;

    reg                             clk;
    reg                             rst;
    reg                             init;
    reg                             bit_cnt_inc;
    reg  [WIDTH-1:0]                i_vec_b_1;
    reg  [NUMBER-1:0]               i_vec_a_bits_1;
    reg  [WIDTH-1:0]                i_vec_b_2;
    reg  [NUMBER-1:0]               i_vec_a_bits_2;
    reg  [(WIDTH/(NUMBER/2))+2-1:0] initial_sum;
    wire [(WIDTH/(NUMBER/2))+2-1:0] o_dot_product;
    wire                            bit_cnt_end;
 
    pu_module #(
        .WIDTH(WIDTH),
        .NUMBER(NUMBER)
    ) dut (
        .clk(clk),
        .rst(rst),
        .init(init),
        .bit_cnt_inc(bit_cnt_inc),
        .i_vec_b_1(i_vec_b_1),
        .i_vec_a_bits_1(i_vec_a_bits_1),
        .i_vec_b_2(i_vec_b_2),
        .i_vec_a_bits_2(i_vec_a_bits_2),
        .initial_sum(initial_sum),
        .o_dot_product(o_dot_product),
        .bit_cnt_end(bit_cnt_end)
    );

initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        initial_sum = 0;
        init = 0;


        //  A                 .  B

        // [1]                  [3]               
        // [3]                  [5]               
        // [6]                . [5]                = 50
        // [2]                  [1]               

        // [0000000000000001]   [0000000000000011]
        // [0000000000000011]   [0000000000000101]
        // [0000000000000110] . [0000000000000101]
        // [0000000000000010]   [0000000000000001]

        //  A                 .  B

        // [1 ]                 [2 ]               
        // [-4]                 [6 ]               
        // [6 ]               . [-1]               = -7
        // [3 ]                 [7 ]               

        // [0000000000000001]   [0000000000000010]
        // [1111111111111100]   [0000000000000110]
        // [0000000000000110] . [1111111111111111]
        // [0000000000000011]   [0000000000000111]

        #10 rst = 0;
        #10 init = 1;
        #10 init = 0;
    
        i_vec_b_1 = 64'b0000000000000011_0000000000000101_0000000000000101_0000000000000001;
        i_vec_b_2 = 64'b0000000000000010_0000000000000110_1111111111111111_0000000000000111;
        
        #10 i_vec_a_bits_1 = 4'b0000; i_vec_a_bits_2 = 4'b0100;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        repeat(10) begin
            #10 i_vec_a_bits_1 = 4'b0000; i_vec_a_bits_2 = 4'b0100;
            bit_cnt_inc = 1; #10  bit_cnt_inc = 0;
        end

        #10 i_vec_a_bits_1 = 4'b0000; i_vec_a_bits_2 = 4'b0100;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #10 i_vec_a_bits_1 = 4'b0000; i_vec_a_bits_2 = 4'b0100;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #10 i_vec_a_bits_1 = 4'b0010; i_vec_a_bits_2 = 4'b0110;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #10 i_vec_a_bits_1 = 4'b0111; i_vec_a_bits_2 = 4'b0011;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #10 i_vec_a_bits_1 = 4'b1100; i_vec_a_bits_2 = 4'b1001;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #80


        //  A                 .  B

        // [1]                  [3]               
        // [3]                  [5]               
        // [6]                . [5]                = 50
        // [2]                  [1]               

        // [0000000000000001]   [0000000000000011]
        // [0000000000000011]   [0000000000000101]
        // [0000000000000110] . [0000000000000101]
        // [0000000000000010]   [0000000000000001]

        //  A                 .  B

        // [1 ]                 [2 ]               
        // [-4]                 [6 ]               
        // [6 ]               . [-1]               = -7
        // [3 ]                 [7 ]               

        // [0000000000000001]   [0000000000000010]
        // [1111111111111100]   [0000000000000110]
        // [0000000000000110] . [1111111111111111]
        // [0000000000000011]   [0000000000000111]

        #10 init = 1;
        #10 init = 0;
    
        i_vec_b_1 = 64'b0000000000000011_0000000000000101_0000000000000101_0000000000000001;
        i_vec_b_2 = 64'b0000000000000010_0000000000000110_1111111111111111_0000000000000111;
        
        #10 i_vec_a_bits_1 = 4'b0000; i_vec_a_bits_2 = 4'b0100;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        repeat(10) begin
            #10 i_vec_a_bits_1 = 4'b0000; i_vec_a_bits_2 = 4'b0100;
            bit_cnt_inc = 1; #10  bit_cnt_inc = 0;
        end

        #10 i_vec_a_bits_1 = 4'b0000; i_vec_a_bits_2 = 4'b0100;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #10 i_vec_a_bits_1 = 4'b0000; i_vec_a_bits_2 = 4'b0100;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #10 i_vec_a_bits_1 = 4'b0010; i_vec_a_bits_2 = 4'b0110;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #10 i_vec_a_bits_1 = 4'b0111; i_vec_a_bits_2 = 4'b0011;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #10 i_vec_a_bits_1 = 4'b1100; i_vec_a_bits_2 = 4'b1001;
        bit_cnt_inc = 1; #10  bit_cnt_inc = 0;

        #80

        $stop;
    end

endmodule
