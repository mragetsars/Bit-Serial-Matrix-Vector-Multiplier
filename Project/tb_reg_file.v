`timescale 1ns/1ps

module tb_reg_file;


  localparam integer DATA_WIDTH     = 16;
  localparam integer WORD_COUNT     = 8;
  localparam integer ADDR_WIDTH     = 3;
  localparam integer COUNT_WIDTH    = 3;
  localparam integer MAX_COUNT      = 7;
  localparam integer MEM_ADDR_WIDTH = 7;


  localparam real    CLK_PERIOD_NS  = 10.0; 


  reg                       clk;
  reg                       rst;


  reg                       a_w_en;
  reg                       a_rotate;
  wire                      a_0_msb_out;
  wire                      a_1_msb_out;
  wire                      a_2_msb_out;
  wire                      a_3_msb_out;
  wire                      a_4_msb_out;
  wire                      a_5_msb_out;
  wire                      a_6_msb_out;
  wire                      a_7_msb_out;


  reg                       b_w_en;
  wire [DATA_WIDTH-1:0]     b_0_out;
  wire [DATA_WIDTH-1:0]     b_1_out;
  wire [DATA_WIDTH-1:0]     b_2_out;
  wire [DATA_WIDTH-1:0]     b_3_out;
  wire [DATA_WIDTH-1:0]     b_4_out;
  wire [DATA_WIDTH-1:0]     b_5_out;
  wire [DATA_WIDTH-1:0]     b_6_out;
  wire [DATA_WIDTH-1:0]     b_7_out;


  reg  [DATA_WIDTH-1:0]     data_in;
  reg                       a_cnt_increase;
  reg                       b_cnt_increase;
  reg                       b_i_cnt_increase;


  wire [MEM_ADDR_WIDTH-1:0] memory_r_addr;
  wire [COUNT_WIDTH-1:0]    b_i_cnt_out;


  reg                       w_input_sel;


  reg_file #(
    .DATA_WIDTH     (DATA_WIDTH),
    .WORD_COUNT     (WORD_COUNT),
    .ADDR_WIDTH     (ADDR_WIDTH),
    .COUNT_WIDTH    (COUNT_WIDTH),
    .MAX_COUNT      (MAX_COUNT),
    .MEM_ADDR_WIDTH (MEM_ADDR_WIDTH)
  ) dut (
    .clk             (clk),
    .rst             (rst),

    .a_w_en          (a_w_en),
    .a_rotate        (a_rotate),
    .a_0_msb_out     (a_0_msb_out),
    .a_1_msb_out     (a_1_msb_out),
    .a_2_msb_out     (a_2_msb_out),
    .a_3_msb_out     (a_3_msb_out),
    .a_4_msb_out     (a_4_msb_out),
    .a_5_msb_out     (a_5_msb_out),
    .a_6_msb_out     (a_6_msb_out),
    .a_7_msb_out     (a_7_msb_out),

    .b_w_en          (b_w_en),
    .b_0_out         (b_0_out),
    .b_1_out         (b_1_out),
    .b_2_out         (b_2_out),
    .b_3_out         (b_3_out),
    .b_4_out         (b_4_out),
    .b_5_out         (b_5_out),
    .b_6_out         (b_6_out),
    .b_7_out         (b_7_out),

    .data_in         (data_in),
    .a_cnt_increase  (a_cnt_increase),
    .b_cnt_increase  (b_cnt_increase),
    .b_i_cnt_increase(b_i_cnt_increase),

    .memory_r_addr   (memory_r_addr),
    .b_i_cnt_out     (b_i_cnt_out),

    .w_input_sel     (w_input_sel)
  );


  initial clk = 1'b0;
  always #(CLK_PERIOD_NS/2.0) clk = ~clk;




  task automatic wait_clk(input integer n);
    integer i;
    begin
      for (i = 0; i < n; i = i + 1) @(posedge clk);
    end
  endtask


  task automatic pulse(input integer cycles, output reg sig);
    integer i;
    begin
      for (i = 0; i < cycles; i = i + 1) begin
        sig = 1'b1;
        @(posedge clk);
        sig = 1'b0;
        @(negedge clk);
      end
    end
  endtask


  task automatic inc_a_cnt(input integer k);
    integer i;
    begin
      for (i = 0; i < k; i = i + 1) begin
        a_cnt_increase = 1'b1;
        @(posedge clk);
        a_cnt_increase = 1'b0;
        @(negedge clk);
      end
    end
  endtask


  task automatic inc_b_cnt(input integer k);
    integer i;
    begin
      for (i = 0; i < k; i = i + 1) begin
        b_cnt_increase = 1'b1;
        @(posedge clk);
        b_cnt_increase = 1'b0;
        @(negedge clk);
      end
    end
  endtask


  task automatic inc_bi_cnt(input integer k);
    integer i;
    begin
      for (i = 0; i < k; i = i + 1) begin
        b_i_cnt_increase = 1'b1;
        @(posedge clk);
        b_i_cnt_increase = 1'b0;
        @(negedge clk);
      end
    end
  endtask


  task automatic write_a(input [DATA_WIDTH-1:0] din);
    begin
      data_in = din;
      a_w_en  = 1'b1;
      @(posedge clk);
      a_w_en  = 1'b0;
      @(negedge clk);
    end
  endtask


  task automatic write_b(input [DATA_WIDTH-1:0] din);
    begin
      data_in = din;
      b_w_en  = 1'b1;
      @(posedge clk);
      b_w_en  = 1'b0;
      @(negedge clk);
    end
  endtask


  task automatic rotate_a_once;
    begin
      a_rotate = 1'b1;
      @(posedge clk);
      a_rotate = 1'b0;
      @(negedge clk);
    end
  endtask


  function [DATA_WIDTH-1:0] patt;
    input [3:0] bank; 
    input [ADDR_WIDTH-1:0] index;
    begin
     
      patt = { {8{1'b0}} | (8'hA0 + bank), {5'b0, index} };
    end
  endfunction


  integer ia;
  integer ib;
  integer bi, bj;
  
  initial begin

    rst               = 1'b1;
    a_w_en            = 1'b0;
    a_rotate          = 1'b0;
    b_w_en            = 1'b0;
    data_in           = {DATA_WIDTH{1'b0}};
    a_cnt_increase    = 1'b0;
    b_cnt_increase    = 1'b0;
    b_i_cnt_increase  = 1'b0;
    w_input_sel       = 1'b0;


    wait_clk(4);
    rst = 1'b0;
    wait_clk(2);



    for (ia = 0; ia < WORD_COUNT; ia = ia + 1) begin
      write_a(patt(4'd0, ia[ADDR_WIDTH-1:0])); 
      inc_a_cnt(1);
    end

    inc_a_cnt(3);

    
    for (ib = 0; ib < WORD_COUNT; ib = ib + 1) begin
      write_b(patt(4'd1, ib[ADDR_WIDTH-1:0])); 
      inc_b_cnt(1);
    end

    wait_clk(3);
    inc_b_cnt(2);


    rotate_a_once();
    wait_clk(2);
    rotate_a_once();
    wait_clk(1);
    rotate_a_once();


    w_input_sel = 1'b0;
    wait_clk(2);
   
    inc_b_cnt(5);
    wait_clk(2);


    w_input_sel = 1'b1;
    wait_clk(2);

    
    for (bi = 0; bi < 4; bi = bi + 1) begin   

      inc_bi_cnt(1);
      wait_clk(1);
      for (bj = 0; bj < 6; bj = bj + 1) begin     
        inc_b_cnt(1);
        wait_clk(1);
      end
      wait_clk(2);
    end


    w_input_sel = 1'b0;
    wait_clk(2);


    for (ia = 0; ia < 4; ia = ia + 1) begin
      write_a(patt(4'd2, ia[ADDR_WIDTH-1:0])); 
      rotate_a_once();
      write_b(patt(4'd3, ia[ADDR_WIDTH-1:0]));
      inc_a_cnt(1);
      inc_b_cnt(1);
      wait_clk(1);
    end


    w_input_sel = 1'b1;
    inc_bi_cnt(3);
    inc_b_cnt(4);
    wait_clk(10);


    $finish;
  end

endmodule
