module controller(
    input clk, 
    input reset_n, 
    input start, 
    
    output reg shift_en_in, shift_en_out,  
    output reg exec_en, 
    output reg rvalid
); 

    reg [1:0] present_state, next_state; 

    parameter IDLE = 2'b00; 
    parameter LOAD = 2'b01; 
    parameter EXECUTE = 2'b10; 
    parameter MEM_WRITE = 2'b11; 


    always @(*) begin
        begin: NSL
            case(present_state)
                IDLE: next_state = start? LOAD: IDLE; 
                LOAD: next_state = EXECUTE; 
                EXECUTE: next_state = MEM_WRITE;
                MEM_WRITE: next_state = IDLE;  
                default: next_state = 'bx; 
        endcase
        end 

        begin: OL
            case(present_state)
                IDLE: begin
                    shift_en_in = 0; 
                    shift_en_out = 0; 
                    rvalid = 0; 
                    exec_en = 0; 
                end
                LOAD: begin
                    shift_en_in = 1; 
                    shift_en_out = 0; 
                    rvalid = 0; 
                    exec_en = 0; 
                end 
                EXECUTE: begin
                    shift_en_in = 0; 
                    shift_en_out = 1;
                    rvalid = 0; 
                    exec_en = 1; 
                end 
                MEM_WRITE: begin
                    shift_en_in = 0; 
                    shift_en_out = 0;
                    rvalid = 1; 
                    exec_en = 0; 
                end 


            endcase
    end 

    end 

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)
            present_state <= IDLE; 
        else 
            present_state <= next_state; 
        
    end

endmodule 