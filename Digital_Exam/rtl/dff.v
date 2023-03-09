module dff #(parameter WIDTH = 32)(
    input clk, 
    input reset_n, 
    input [WIDTH-1:0] D, 

    output reg [WIDTH-1:0] Q
); 

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)
            Q <= 0; 
        else   
            Q <= D; 
    end
endmodule 