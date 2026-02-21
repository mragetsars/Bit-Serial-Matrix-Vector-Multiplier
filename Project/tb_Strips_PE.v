`timescale 1ns/1ns
module tb_strips_pe;

    localparam WIDTH  = 64;
    localparam NUMBER = 4;

    reg                             clk;
    reg                             rst;
    reg                             init;
    reg                             i_valid;
    reg                             i_is_msb;
    reg                             i_is_lsb;
    reg  [WIDTH-1:0]                i_vec_b;
    reg  [NUMBER-1:0]               i_vec_a_bits;
    reg  [(WIDTH/(NUMBER/2))+2-1:0] initial_sum;
    wire [(WIDTH/(NUMBER/2))+2-1:0] o_dot_product;

    strips_pe #(
        .WIDTH(WIDTH),
        .NUMBER(NUMBER)
    ) dut (
        .clk(clk),
        .rst(rst),
        .init(init),
        .i_valid(i_valid),
        .i_is_msb(i_is_msb),
        .i_is_lsb(i_is_lsb),
        .i_vec_b(i_vec_b),
        .i_vec_a_bits(i_vec_a_bits),
        .initial_sum(initial_sum),
        .o_dot_product(o_dot_product)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        init = 1;
        i_is_msb   = 0;
        i_is_lsb   = 0;
        i_valid    = 0;
        initial_sum = 0;


        //  A                 .  B

        // [1]                  [3]               
        // [3]                  [5]               
        // [6]                . [5]                = 50
        // [2]                  [1]               

        // [0000000000000001]   [0000000000000011]
        // [0000000000000011]   [0000000000000101]
        // [0000000000000110] . [0000000000000101]
        // [0000000000000010]   [0000000000000001]

        #10 rst = 0;
        #10 init = 0;

        i_vec_b = 64'b0000000000000011_0000000000000101_0000000000000101_0000000000000001;

        #20 i_vec_a_bits = 4'b0000; #10 i_is_msb = 1; i_valid = 1;
        #10 i_is_msb = 0; i_valid = 0;

        repeat(10) begin
            #20 i_vec_a_bits = 4'b0000; #10 i_valid = 1;
            #10 i_valid = 0;
        end

        #20 i_vec_a_bits = 4'b0000; #10 i_valid = 1;
        #10 i_is_msb = 0; i_valid = 0;

        #20 i_vec_a_bits = 4'b0000; #10 i_valid = 1;
        #10 i_is_msb = 0; i_valid = 0;

        #20 i_vec_a_bits = 4'b0010; #10 i_valid = 1;
        #10 i_valid = 0;

        #20 i_vec_a_bits = 4'b0111; #10 i_valid = 1;
        #10 i_valid = 0;

        #20 i_vec_a_bits = 4'b1100; #10 i_is_lsb = 1; i_valid = 1;
        #10 i_is_lsb = 0; i_is_lsb = 0; i_valid = 0;

        #50

        rst = 1;
        i_is_msb   = 0;
        i_is_lsb   = 0;
        i_valid    = 0;
        initial_sum = 0;

        //  A                 .  B

        // [1 ]                 [2 ]               
        // [-4]                 [6 ]               
        // [6 ]               . [-1]               = -7
        // [3 ]                 [7 ]               

        // [0000000000000001]   [0000000000000010]
        // [1111111111111100]   [0000000000000110]
        // [0000000000000110] . [1111111111111111]
        // [0000000000000011]   [0000000000000111]

       

        #20 rst = 0;

        i_vec_b = 64'b0000000000000010_0000000000000110_1111111111111111_0000000000000111;

        #20 i_vec_a_bits = 4'b0100; #10 i_is_msb = 1; i_valid = 1;
        #10 i_is_msb = 0; i_valid = 0;

        repeat(10) begin
            #20 i_vec_a_bits = 4'b0100; #10 i_valid = 1;
            #10 i_valid = 0;
        end

        #20 i_vec_a_bits = 4'b0100; #10 i_valid = 1;
        #10 i_is_msb = 0; i_valid = 0;

        #20 i_vec_a_bits = 4'b0100; #10 i_valid = 1;
        #10 i_is_msb = 0; i_valid = 0;

        #20 i_vec_a_bits = 4'b0110; #10 i_valid = 1;
        #10 i_valid = 0;

        #20 i_vec_a_bits = 4'b0011; #10 i_valid = 1;
        #10 i_valid = 0;

        #20 i_vec_a_bits = 4'b1001; #10 i_is_lsb = 1; i_valid = 1;
        #10 i_is_lsb = 0; i_is_lsb = 0; i_valid = 0;

        #20

        $stop;
    end

endmodule