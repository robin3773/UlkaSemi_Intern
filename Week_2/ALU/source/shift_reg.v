module shift_reg #(parameter DATA_LENGTH = 12)(
    input clk, 
    input reset_n, 
    input shift_en, 
    input [DATA_LENGTH-1:0] data_in_p,
    output reg [DATA_LENGTH-1:0] data_out_p
); 

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)
            data_out_p <= 'b0; 
        else 
            data_out_p <= shift_en ? data_in_p: data_out_p; 
    end 
endmodule