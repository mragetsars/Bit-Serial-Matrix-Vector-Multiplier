module b_reg_file #(
    parameter DATA_WIDTH = 16,
    parameter WORD_COUNT = 8,
    parameter ADDR_WIDTH = 3
) (
    input  wire clk,
    input  wire reset,

    input  wire w_en,                          
    input  wire [ADDR_WIDTH-1:0] w_addr,       
    input  wire [DATA_WIDTH-1:0] w_data,       

    output wire [DATA_WIDTH-1:0] b_0_out,
    output wire [DATA_WIDTH-1:0] b_1_out,
    output wire [DATA_WIDTH-1:0] b_2_out,
    output wire [DATA_WIDTH-1:0] b_3_out,
    output wire [DATA_WIDTH-1:0] b_4_out,
    output wire [DATA_WIDTH-1:0] b_5_out,
    output wire [DATA_WIDTH-1:0] b_6_out,
    output wire [DATA_WIDTH-1:0] b_7_out
);

    reg [DATA_WIDTH-1:0] registers [0:WORD_COUNT-1];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < WORD_COUNT; i = i + 1) begin
                registers[i] <= {DATA_WIDTH{1'b0}};
            end
        end else if (w_en) begin
            registers[w_addr] <= w_data;
        end
    end

    assign b_0_out = registers[0];
    assign b_1_out = registers[1];
    assign b_2_out = registers[2];
    assign b_3_out = registers[3];
    assign b_4_out = registers[4];
    assign b_5_out = registers[5];
    assign b_6_out = registers[6];
    assign b_7_out = registers[7];

endmodule
