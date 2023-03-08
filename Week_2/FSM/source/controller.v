module controller(
    input clk, 
    input reset_n, 
    input rx_start, 
    input clk_count_eq_5, 
    input bit_count_eq_5, 

    output reg frame_error_gen, 
    output reg shift_en, 
    output reg clk_clear, 
    output reg clk_increament, 
    output reg bit_clear, 
    output reg bit_increament
); 

    reg [2:0] present_state, next_state; 

    parameter IDLE = 2'b00; 
    parameter WAIT = 2'b01; 
    parameter SAMPLE = 2'b10; 
    parameter CHECK = 2'b11; 


    always @(*) begin
      	case(present_state)
            IDLE : next_state = rx_start? WAIT : IDLE; 
            WAIT : next_state = clk_count_eq_5? SAMPLE: WAIT; 
            SAMPLE: next_state = bit_count_eq_5 ? CHECK : WAIT; 
            CHECK: next_state = IDLE; 
            default: next_state = 'bx; 
        endcase 
    end
      
      always @(*) begin
      	case (present_state)
            IDLE: begin
                frame_error_gen = 0; 
                shift_en = 0; 
                clk_clear = 1; 
                clk_increament = 1; 
                bit_clear = 1; 
                bit_increament = 0;
            end 
            WAIT: begin
                frame_error_gen = 0; 
                shift_en = 0; 
                clk_clear = clk_count_eq_5; 
                clk_increament = 1; 
                bit_clear = 0; 
                bit_increament = clk_count_eq_5;
            end 
            SAMPLE: begin
                frame_error_gen = 0; 
                shift_en = 1; 
                clk_clear = 0; 
                clk_increament = 1; 
                bit_clear = bit_count_eq_5; 
                bit_increament = 1;
            end 
            CHECK: begin
                frame_error_gen = 1; 
                shift_en = 0; 
                clk_clear = 0; 
                clk_increament = 1; 
                bit_clear = bit_count_eq_5; 
                bit_increament = 0;
            end 
        endcase 
    end 

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            present_state <= IDLE; 
        else begin 
            present_state <= next_state; 
        end

    end
endmodule
