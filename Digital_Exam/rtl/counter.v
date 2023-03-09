module counter #(parameter BIT = 10) (
    input clk, 
    input reset_n, 
    input clear, 
    input increament, 

    output reg [BIT-1:0] count
);
    
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) 
            count <= 'b0; 
        else
            count <= clear ? 'b0 : count + increament;
    end 
endmodule