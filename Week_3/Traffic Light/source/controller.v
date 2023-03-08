module controller(
    input clk, 
    input reset_n, 
    input start, 
    input clk_count_eq_3, 
    input clk_count_eq_5, 
    input clk_count_eq_10,
    input clk_count_eq_11,

    output reg clear, increament,
    output reg red_en, green_en, yellow_en
);  
    
    reg [1:0] present_state, next_state; 

    parameter IDLE = 2'b00; 
    parameter RED = 2'b01; 
    parameter YELLOW = 2'b10; 
    parameter GREEN = 2'b11; 

    always @(*) begin
        begin: NSL
            case(present_state)
                IDLE    : next_state = start? RED: IDLE; 
                RED     : next_state = clk_count_eq_3? YELLOW: RED; 
                YELLOW  : next_state = clk_count_eq_5? GREEN: YELLOW; 
                GREEN   : next_state = clk_count_eq_10? RED: GREEN; 
            endcase
        end

        begin: OL
            case(present_state)
                IDLE    : begin
                    {red_en, green_en, yellow_en} = 3'b000;
                     clear = 1; 
                     increament = 0; 
                end
                RED     : begin
                    {red_en, green_en, yellow_en} = 3'b100;
                     clear = clk_count_eq_11; 
                     increament = 1; 
                end
                YELLOW  : begin
                    {red_en, green_en, yellow_en} = 3'b001;
                     clear = 0; 
                     increament = 1; 
                end 
                GREEN   : begin
                    {red_en, green_en, yellow_en} = 3'b010;
                     clear = 0; 
                     increament = 1; 
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