`timescale 1ns/1ps

module tb_memory;

    parameter WORD_WIDTH     = 34;
    parameter MEM_DEPTH      = 128;
    parameter MEM_ADDR_WIDTH = 7;
    parameter MEM_INIT_FILE  = "input_memory (1).txt";

    reg clk;
    reg rst;
    reg [MEM_ADDR_WIDTH-1:0] address;
    reg [WORD_WIDTH-1:0] w_data;
    reg write;
    wire [WORD_WIDTH-1:0] r_data;

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


    // سناریوی تست
    initial begin
        rst     = 1'b1;
        address = {MEM_ADDR_WIDTH{1'b0}};
        w_data  = {WORD_WIDTH{1'b0}};
        write   = 1'b0;

        #20;     
        rst = 1'b0;
        #10;

        address = 7'd0; write = 1'b0; #10;
        address = 7'd1; write = 1'b0; #10;
        address = 7'd2; write = 1'b0; #10;
        address = 7'd3; write = 1'b0; #10;

        address = 7'h7f;
        w_data = 34'h1_2345_6789;
        write = 1'b1; #10;      
        write = 1'b0; #10;

        address = 7'd2; #10;

        address = 7'd5;
        w_data = 34'h0_0ABC_DEF0;
        write = 1'b1; #10;
        write = 1'b0; #10;

        address = 7'd5; #10;

        address = 7'd10;
        w_data = 34'h00FF_FFFF;
        write = 1'b1; #10;
        write = 1'b0; #10;
        address = 7'd10; #10;

        rst = 1'b1; #20;
        rst = 1'b0; #10;

        address = 7'd2; #10;
        address = 7'd5; #10;
        address = 7'd10; #10;

        address = 7'd127; #10;
        address = 7'd0;   #10;

        #50;
        $finish;
    end

endmodule
