module dff #(parameter WIDTH = 32, RESET_VALUE = 32'b0)(
	input clk, reset_n, 
	input [WIDTH-1:0]d, 
	output reg [WIDTH-1:0] q); 
	
	always @(posedge clk or negedge reset_n) begin
		if(!reset_n) 
			q <= RESET_VALUE; 
		else 
			q <= d; 
	end 
	
endmodule 
