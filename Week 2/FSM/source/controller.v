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

    reg present_state, next_state; 

    parameter IDLE = 2'b00; 
    parameter WAIT = 2'b01; 
    parameter SAMPLE = 2'b10; 
    parameter CHECK = 2'b11; 


    always @(*) begin
      	case(present_state)
            IDLE : begin
              $display("[%0t] rx_start = %0d", $time, rx_start); 
                next_state = rx_start ? WAIT : IDLE; 
              $display("[%0t] IDLE: present_state = %0H next_state = %0H", $time, present_state, next_state);
            end
            WAIT : begin 
              	$display("[%0t] clk_count_eq_5 = %0d", $time, clk_count_eq_5); 
                //next_state = clk_count_eq_5 ? SAMPLE : WAIT;
              if (clk_count_eq_5 == 1) begin
                next_state = 2'b10; 
                $display("next_state = %0h", next_state); 
              end 
              else begin
                next_state = WAIT;
              end 
             	$display("[%0t] WAIT: present_state = %0H next_state = %0H", $time, present_state, next_state);
            end
            SAMPLE: begin
                //$display("[%0t] present_state = %0H next_state = %0H", $time, present_state, next_state);
                next_state = bit_count_eq_5 ? CHECK : WAIT; 
                $display("[%0t] present_state = %0H next_state = %0H", $time, present_state, next_state);
            end
            CHECK: begin 
                //$display("[%0t] present_state = %0H next_state = %0H", $time, present_state, next_state);
                next_state = IDLE; 
                $display("[%0t] present_state = %0H next_state = %0H", $time, present_state, next_state);
            end
            default: next_state = 'bx; 
        endcase 
    end
      
      always @(*) begin
      	case (present_state)
            IDLE: begin
              	//$display("[%0t] IDLE %0H", $time, present_state); 
                frame_error_gen = 0; 
                shift_en = 0; 
                clk_clear = 1; 
                clk_increament = 1; 
                bit_clear = 1; 
                bit_increament = 0;
            end 
            WAIT: begin
              	//$display("[%0t] WAIT", $time); 
                frame_error_gen = 0; 
                shift_en = 0; 
                clk_clear = 0; 
                clk_increament = 1; 
                bit_clear = 0; 
                bit_increament = 0;
            end 
            SAMPLE: begin
              	//$display("[%0t] Sample", $time); 
                frame_error_gen = 0; 
                shift_en = 1; 
                clk_clear = 1; 
                clk_increament = 1; 
                bit_clear = 0; 
                bit_increament = 1;
            end 
            CHECK: begin
             // $display("[%0t] CHECK", $time); 
                frame_error_gen = 1; 
                shift_en = 0; 
                clk_clear = 1; 
                clk_increament = 1; 
                bit_clear = 0; 
                bit_increament = 0;
            end 
        endcase 
    end 

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            present_state <= IDLE; 
        else begin 
            $display("[%0t] SEQUENTIAL BLOCK: next_state = %0H", $time, next_state); 
            present_state <= next_state; 
        end

    end
  initial begin
  //$monitor("[%0t] present state = %0h, next_state = %0h", $time, present_state,next_state); 
  end
endmodule
