module shift_reg #(parameter BIT_LENGTH = 8)(
    input clk, 
    input reset_n, 
    input shift_en, 
    input serial_in, 
    output serial_out
);

    reg [BIT_LENGTH - 1: 0] Q; 
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)
            Q <= 'b0; 
        else 
            Q <= shift_en? {serial_in, Q[BIT_LENGTH-1 : 1]}: Q; 
    end

    assign serial_out = Q[0]; 
endmodule 
