module cnt_with_max #(
    parameter WIDTH = 3,
    parameter MAX_COUNT = {WIDTH{1'b1}}
)  (
    input wire clk, 
    input wire reset, 
    input wire increase, 
    output wire [WIDTH-1:0] count_out,
    output wire             count_end
);

reg [WIDTH-1:0] count_reg;

assign count_out = count_reg;
assign count_end = (count_out == MAX_COUNT);

always @(posedge clk) begin

    if (reset) begin
        count_reg <= {WIDTH{1'b0}}; 
    end

    else if (increase) begin
        if (count_reg == MAX_COUNT) begin
        
            count_reg <= {WIDTH{1'b0}};
        end
        else begin
    
            count_reg <= count_reg + 1;
        end
    end
end

endmodule

