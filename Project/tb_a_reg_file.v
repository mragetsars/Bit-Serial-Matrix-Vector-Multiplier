`timescale 1ns/1ps

module tb_a_reg_file;

    reg clk;
    reg reset;
    reg w_en;
    reg [2:0] w_addr;
    reg [15:0] w_data;
    reg rotate;

    wire a_0_msb_out;
    wire a_1_msb_out;
    wire a_2_msb_out;
    wire a_3_msb_out;
    wire a_4_msb_out;
    wire a_5_msb_out;
    wire a_6_msb_out;
    wire a_7_msb_out;

    a_reg_file dut (
        .clk(clk),
        .reset(reset),
        .w_en(w_en),
        .w_addr(w_addr),
        .w_data(w_data),
        .rotate(rotate),
        .a_0_msb_out(a_0_msb_out),
        .a_1_msb_out(a_1_msb_out),
        .a_2_msb_out(a_2_msb_out),
        .a_3_msb_out(a_3_msb_out),
        .a_4_msb_out(a_4_msb_out),
        .a_5_msb_out(a_5_msb_out),
        .a_6_msb_out(a_6_msb_out),
        .a_7_msb_out(a_7_msb_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        w_en = 0;
        w_addr = 0;
        w_data = 0;
        rotate = 0;

        #12 reset = 0;

        @(posedge clk);
        w_en = 1; w_addr = 3'd0; w_data = 16'h3AA8;  
        @(posedge clk);
        w_en = 1; w_addr = 3'd1; w_data = 16'h1555;  
        @(posedge clk);
        w_en = 0;

        #10;
        // rotate = 1;
        #10;
        @(posedge clk);
        rotate = 0;
        #10;
        // rotate = 1;
        #10;
        @(posedge clk);
        rotate = 0;

        #10;
        @(posedge clk);
        w_en = 1; w_addr = 3'd2; w_data = 16'hFFFF;
        @(posedge clk);
        w_en = 0;

        #10;
        repeat (3) begin
            #10;
        end

        #20;
        $stop;
    end

endmodule
