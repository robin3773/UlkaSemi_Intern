module counter(
    input clk, 
    input reset_n, 
    input clear, 
    input increament,
    output reg count
); 

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            count <= 0; 
        end 
        else begin
            count <= clear ? 1'b0 : count + 1; 
        end 
    end

endmodule 