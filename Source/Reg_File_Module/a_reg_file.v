module a_reg_file #(
    parameter DATA_WIDTH = 16,
    parameter WORD_COUNT = 8,
    parameter ADDR_WIDTH = 3
) (
    input  wire clk,
    input  wire reset,

    input  wire w_en,
    input  wire [ADDR_WIDTH-1:0] w_addr,
    input  wire [DATA_WIDTH-1:0] w_data,

    input  wire rotate,

    output wire a_0_msb_out,
    output wire a_1_msb_out,
    output wire a_2_msb_out,
    output wire a_3_msb_out,
    output wire a_4_msb_out,
    output wire a_5_msb_out,
    output wire a_6_msb_out,
    output wire a_7_msb_out
);

    reg [DATA_WIDTH-1:0] registers [0:WORD_COUNT-1];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < WORD_COUNT; i = i + 1) begin
                registers[i] <= {DATA_WIDTH{1'b0}};
            end
        end else if (rotate) begin
            for (i = 0; i < WORD_COUNT; i = i + 1) begin
                registers[i] <= {registers[i][DATA_WIDTH-2:0], registers[i][DATA_WIDTH-1]};
            end
        end else if (w_en) begin
            registers[w_addr] <= w_data;
        end
    end

    assign a_0_msb_out = registers[0][DATA_WIDTH-1];
    assign a_1_msb_out = registers[1][DATA_WIDTH-1];
    assign a_2_msb_out = registers[2][DATA_WIDTH-1];
    assign a_3_msb_out = registers[3][DATA_WIDTH-1];
    assign a_4_msb_out = registers[4][DATA_WIDTH-1];
    assign a_5_msb_out = registers[5][DATA_WIDTH-1];
    assign a_6_msb_out = registers[6][DATA_WIDTH-1];
    assign a_7_msb_out = registers[7][DATA_WIDTH-1];

endmodule
