`timescale 1ns/1ps

module tb_b_reg_file;

    parameter DATA_WIDTH = 16;
    parameter WORD_COUNT  = 8;
    parameter ADDR_WIDTH  = 3;

    reg clk;
    reg reset;
    reg w_en;
    reg [ADDR_WIDTH-1:0] w_addr;
    reg [DATA_WIDTH-1:0] w_data;

    wire [DATA_WIDTH-1:0] b_0_out;
    wire [DATA_WIDTH-1:0] b_1_out;
    wire [DATA_WIDTH-1:0] b_2_out;
    wire [DATA_WIDTH-1:0] b_3_out;
    wire [DATA_WIDTH-1:0] b_4_out;
    wire [DATA_WIDTH-1:0] b_5_out;
    wire [DATA_WIDTH-1:0] b_6_out;
    wire [DATA_WIDTH-1:0] b_7_out;

    // DUT
    b_reg_file #(
        .DATA_WIDTH(DATA_WIDTH),
        .WORD_COUNT(WORD_COUNT),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .w_en(w_en),
        .w_addr(w_addr),
        .w_data(w_data),

        .b_0_out(b_0_out),
        .b_1_out(b_1_out),
        .b_2_out(b_2_out),
        .b_3_out(b_3_out),
        .b_4_out(b_4_out),
        .b_5_out(b_5_out),
        .b_6_out(b_6_out),
        .b_7_out(b_7_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        reset = 0;
        w_en  = 0;
        w_addr = 0;
        w_data = 0;

        #5 reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;

        #10;
        w_en = 1;
        #15;
        w_addr = 3'd0; w_data = 16'hAAAA;
        #15;
        w_addr = 3'd1; w_data = 16'hBBBB; 
        #15;
        w_addr = 3'd2; w_data = 16'hCCCC;
        #15;
        w_addr = 3'd3; w_data = 16'hDDDD;
        #15;
        w_addr = 3'd4; w_data = 16'hEEEE; 
        #15;
        w_addr = 3'd5; w_data = 16'hFFFF; 
        #15;
        w_addr = 3'd6; w_data = 16'hAAAA; 
        #15;
        w_addr = 3'd7; w_data = 16'h6789;
        #15;
        w_en = 0;

        #50;

        $finish;
    end

endmodule
