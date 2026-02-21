`timescale 1ns/1ns
module tb_mvmpu;

    localparam WIDTH  = 64;
    localparam NUMBER = 4;

    localparam WORD_WIDTH     = 34;
    localparam MEM_DEPTH      = 128;
    localparam MEM_ADDR_WIDTH = 7;
    localparam MEM_INIT_FILE  = "input_memory (1).txt";

    reg clk;
    reg rst;

    reg start;
    wire done;

    wire [MEM_ADDR_WIDTH-1:0] address;
    wire [WORD_WIDTH-1:0] w_data;
    wire write;
    wire [WORD_WIDTH-1:0] r_data;
 
    mvmpu_top_module #(
        .WIDTH(WIDTH),
        .NUMBER(NUMBER)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .r_data(r_data),
        .address(address),
        .w_data(w_data),
        .write(write),
        .done(done)
    );

    memory #(
        .WORD_WIDTH(WORD_WIDTH),
        .MEM_DEPTH(MEM_DEPTH),
        .MEM_ADDR_WIDTH(MEM_ADDR_WIDTH),
        .MEM_INIT_FILE(MEM_INIT_FILE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .w_data(w_data),
        .write(write),
        .r_data(r_data)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20 rst = 0;

        #20 start = 1;
        #20 start = 0;

        #5000

        $stop;
    end

endmodule
