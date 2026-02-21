module memory
#(
    parameter WORD_WIDTH     = 34,
    parameter MEM_DEPTH      = 128,
    parameter MEM_ADDR_WIDTH = 7,
    parameter MEM_INIT_FILE  = "input_memory (1).txt"
)
(
    input                        clk,
    input                        rst,
    input  [MEM_ADDR_WIDTH-1:0]    address,
    input  [WORD_WIDTH-1:0]        w_data,
    input                        write,
    output reg [WORD_WIDTH-1:0]    r_data
);

    reg [WORD_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    reg [WORD_WIDTH-1:0] init_mem [0:MEM_DEPTH-1];
    
    integer i;
    // بلاک Initial
    initial begin
         // <-- تعریف 'i' باید اینجا باشد
        
        if (MEM_INIT_FILE != "") begin
            $readmemh(MEM_INIT_FILE, init_mem);
            for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                mem[i] = init_mem[i];
            end
        end else begin
            for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                init_mem[i] = {WORD_WIDTH{1'b0}};
                mem[i] = {WORD_WIDTH{1'b0}};
            end
        end
    end

    // بلاک Always
    always @(posedge clk) begin
        
        if (rst) begin
            for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                mem[i] <= init_mem[i];
            end
            r_data <= {WORD_WIDTH{1'b0}};
        end else begin
            if (write) begin
                mem[address] <= w_data;
            end
            r_data <= mem[address];
        end
    end

endmodule