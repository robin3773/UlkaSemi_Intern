module shift_register #(parameter DATA_WIDTH = 5) (
    input clk, 
    input reset_n, 
    input shift_en, 
    input data_in, 
    output reg [DATA_WIDTH - 1: 0] data_out
); 

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin 
            data_out <= 'b0; 
        end 
        else begin
            data_out <= shift_en ? {data_in, data_out[DATA_WIDTH - 1: 1]} : data_out; 
        end 
    end 
endmodule