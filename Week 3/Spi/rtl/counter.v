module counter(
    input clk, 
    input reset_n, 
    input clear, 
    input increament, 
    output reg count
); 

    always @(posedge clk or negedge reset_n) begin 
        if(!reset_n) 
            count <= 'b0; 
        else 
            count <= clear ? 'b0: count + increament; 
    end 
endmodule 