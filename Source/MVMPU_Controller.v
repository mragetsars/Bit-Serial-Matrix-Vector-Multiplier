module mvmpu_controller (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire       a_cnt_end,
    input  wire       b_cnt_end,
    input  wire       a_bit_cnt_end,
    input  wire       b_i_cnt_end,
    output reg        a_cnt_inc,
    output reg        b_cnt_inc,
    output reg        a_bit_cnt_inc,
    output reg        b_i_cnt_inc,
    output reg        pu_init,
    output reg        rgf_init,
    output reg        w_input_sel,
    output reg        a_w_en,
    output reg        b_w_en,
    output reg        a_rotate,
    output reg        r_w_sel,
    output reg        write,
    output reg        done
);

    parameter INIT               = 4'b0000,
              READ_A             = 4'b0001,
              WAIT_FOR_A_W_DATA  = 4'b0010, 
              INC_A              = 4'b0011,
              READ_B             = 4'b0100,
              WAIT_FOR_B_W_DATA  = 4'b0101,
              INC_B              = 4'b0110,
              INIT_PU            = 4'b0111,
              INC_A_BIT          = 4'b1000,
              CAL_A_BIT          = 4'b1001,
              WRITE_MEM          = 4'b1010,
              INC_RESULT_ADDRESS = 4'b1011,
              DONE               = 4'b1100;

    reg [3:0] p_state, n_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            p_state <= INIT;
        else
            p_state <= n_state;
    end

    always @(*) begin
        n_state = p_state;
        case (p_state)
            INIT:               if (start)         n_state = READ_A;
            READ_A:                                n_state = WAIT_FOR_A_W_DATA;
            WAIT_FOR_A_W_DATA:                     n_state = INC_A;
            INC_A:              if (a_cnt_end)     n_state = READ_B;
                                else               n_state = READ_A;
            READ_B:                                n_state = WAIT_FOR_B_W_DATA;
            WAIT_FOR_B_W_DATA:                     n_state = INC_B;
            INC_B:              if (b_cnt_end)     n_state = INIT_PU;
                                else               n_state = READ_B;
            INIT_PU:                               n_state = INC_A_BIT;
            INC_A_BIT:          if (a_bit_cnt_end) n_state = WRITE_MEM;
                                else               n_state = CAL_A_BIT;
            CAL_A_BIT:                             n_state = INC_A_BIT;
            WRITE_MEM:                             n_state = INC_RESULT_ADDRESS;
            INC_RESULT_ADDRESS: if(b_i_cnt_end)    n_state = DONE;
                                else               n_state = READ_B;
            DONE:                                  n_state = INIT;
        endcase
    end

    always @(*) begin
        pu_init = 0;
        rgf_init = 0;
        a_cnt_inc = 0;
        b_cnt_inc = 0;
        a_bit_cnt_inc = 0;
        b_i_cnt_inc = 0;
        w_input_sel = 0;
        a_w_en = 0;
        b_w_en = 0;
        a_rotate = 0;
        r_w_sel = 0;
        write = 0;
        done = 0;
        case (p_state)
            INIT: begin
                pu_init = 1;
                rgf_init = 1;
                r_w_sel = 0;
            end
            READ_A: begin
                w_input_sel = 0;
                r_w_sel = 0;
            end
            WAIT_FOR_A_W_DATA: begin
                a_w_en = 1;
            end
            INC_A:   begin
                a_cnt_inc = 1;
                w_input_sel = 0;
                r_w_sel = 0;
            end
            READ_B: begin
                b_w_en = 1;
                w_input_sel = 1;
            end
            WAIT_FOR_B_W_DATA: begin
                b_w_en = 1;
            end
            INC_B: begin
                b_cnt_inc = 1;
                w_input_sel = 1;
                r_w_sel = 0;
            end
            INIT_PU: begin
                pu_init = 1;
                r_w_sel = 0;
            end
            INC_A_BIT: begin
                a_bit_cnt_inc = 1;
                r_w_sel = 1;
            end
            CAL_A_BIT: begin
                a_rotate = 1;
                r_w_sel = 1;
            end
            WRITE_MEM: begin
                write = 1;
                r_w_sel = 1;
                a_rotate = 1;
            end
            INC_RESULT_ADDRESS: begin
                b_i_cnt_inc = 1;
                r_w_sel = 1;
            end
            DONE: begin
                done = 1;
            end
        endcase
    end

endmodule

