module counter #(parameter BIT_LENGTH = 4)(
    input clk, 
    input reset_n, 
    input clear, 
    input increament, 
    output reg [BIT_LENGTH-1:0] count
); 

    always @(posedge clk or negedge reset_n) begin
       if (!reset_n) begin 
            count <= 'b0; 
       end
       else begin
            count <= clear ? 'b0: count + increament; 
       end  
    end
endmodule 