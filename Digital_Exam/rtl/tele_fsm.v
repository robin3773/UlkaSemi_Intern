module tele_fsm(
    input clk, reset_n, 
    input pickup_call, 
    input dial, cancel, end_call,
    input valid_cntct, 
    input dial_count_5, 
    input call_duration_count_250,

    output reg dial_tone, call_ended, 
    output reg dial_counter_clear, dial_counter_increament, 
    output reg call_counter_clear, call_counter_increament,
    output reg call_timeout, in_call, dial_timeout); 


    parameter IDLE          = 3'b000; 
    parameter DIAL          = 3'b001; 
    parameter DIAL_TIMEOUT  = 3'b010;
    parameter IN_CALL       = 3'b011; 
    parameter END_CALL      = 3'b100; 
    parameter CALL_TIMEOUT  = 3'b101; 


    reg [2:0] present_state, next_state; 

    always @(*) begin
        begin: NSL
            case(present_state)
                IDLE            : next_state = valid_cntct & dial ? DIAL : IDLE; 
                DIAL            : next_state = pickup_call ? IN_CALL : (dial_count_5 ? DIAL_TIMEOUT : DIAL);
                DIAL_TIMEOUT    : next_state = cancel ? IDLE : DIAL_TIMEOUT; 
                IN_CALL         : begin
                                    if(call_duration_count_250)
                                        next_state = CALL_TIMEOUT;
                                    else if(end_call)
                                        next_state = END_CALL; 
                                    else 
                                    	next_state = IN_CALL;
                                end
                END_CALL        : next_state = IDLE; 
                CALL_TIMEOUT    : next_state = cancel ? IDLE: CALL_TIMEOUT; 
            endcase
        end

        begin: OL
            case(present_state)
                IDLE        : begin
                                dial_counter_clear      = 1; 
                                dial_counter_increament = 0;
                                call_counter_clear      = 1; 
                                call_counter_increament = 0; 
                                dial_timeout            = 0; 
                                in_call                 = 0; 
                                call_timeout            = 0; 
                                dial_tone               = 0; 
                                call_ended              = 0; 
                end 
                DIAL        :  begin
                                dial_counter_clear      = dial_count_5; 
                                dial_counter_increament = 1;
                                call_counter_clear      = 1; 
                                call_counter_increament = 0; 
                                dial_timeout            = 0; 
                                in_call                 = 0; 
                                call_timeout            = 0; 
                                dial_tone               = 1; 
                                call_ended              = 0; 
                end 
                DIAL_TIMEOUT: begin
                                dial_counter_clear      = 1; 
                                dial_counter_increament = 0;
                                call_counter_clear      = 1; 
                                call_counter_increament = 0; 
                                dial_timeout            = 1; 
                                in_call                 = 0; 
                                call_timeout            = 0; 
                                dial_tone               = 0; 
                                call_ended              = 0; 
                end 
                IN_CALL     :  begin
                                dial_counter_clear      = 1; 
                                dial_counter_increament = 1;
                                call_counter_clear      = call_duration_count_250; 
                                call_counter_increament = 1; 
                                dial_timeout            = 0; 
                                in_call                 = 1; 
                                call_timeout            = 0; 
                                dial_tone               = 0; 
                                call_ended              = 0; 
                end 
                CALL_TIMEOUT: begin
                                dial_counter_clear      = 1; 
                                dial_counter_increament = 0;
                                call_counter_clear      = 1; 
                                call_counter_increament = 0; 
                                dial_timeout            = 0; 
                                in_call                 = 0; 
                                call_timeout            = 1; 
                                dial_tone               = 0; 
                                call_ended              = 1; 
                end 
                END_CALL     :  begin
                                dial_counter_clear      = 1; 
                                dial_counter_increament = 0;
                                call_counter_clear      = 1; 
                                call_counter_increament = 0;                                 
                                dial_timeout            = 0; 
                                in_call                 = 0; 
                                call_timeout            = 0; 
                                dial_tone               = 0; 
                                call_ended              = 1; 
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
