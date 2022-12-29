`include "./source/d_flip_flop.v"
`include "./source/mux41.v"

module uni_shift_reg(
    input [7:0] Pin, 
    input [1:0] Op, 
    input clk, 
    input reset_n,
    output reg Soot
); 

    wire [7:0] D; 
    wire [7:0] Q; 

    dff DFF7(.clk(clk), .rst_n(reset_n), .D(D[7]), .Q(Q[7]));
    dff DFF6(.clk(clk), .rst_n(reset_n), .D(D[6]), .Q(Q[6]));    
    dff DFF5(.clk(clk), .rst_n(reset_n), .D(D[5]), .Q(Q[5]));    
    dff DFF4(.clk(clk), .rst_n(reset_n), .D(D[4]), .Q(Q[4]));     
    dff DFF3(.clk(clk), .rst_n(reset_n), .D(D[3]), .Q(Q[3]));    
    dff DFF2(.clk(clk), .rst_n(reset_n), .D(D[2]), .Q(Q[2])); 
    dff DFF1(.clk(clk), .rst_n(reset_n), .D(D[1]), .Q(Q[1])); 
    dff DFF0(.clk(clk), .rst_n(reset_n), .D(D[0]), .Q(Q[0])); 

    mux41 MUX7(.a(Q[7]), .b(Q[6]), .c(1'b0), .d(Pin[7]), .select(Op), .out(D[7]));
    mux41 MUX6(.a(Q[6]), .b(Q[5]), .c(Q[7]), .d(Pin[6]), .select(Op), .out(D[6]));
    mux41 MUX5(.a(Q[5]), .b(Q[4]), .c(Q[6]), .d(Pin[5]), .select(Op), .out(D[5]));
    mux41 MUX4(.a(Q[4]), .b(Q[3]), .c(Q[5]), .d(Pin[4]), .select(Op), .out(D[4]));
    mux41 MUX3(.a(Q[3]), .b(Q[2]), .c(Q[4]), .d(Pin[3]), .select(Op), .out(D[3]));
    mux41 MUX2(.a(Q[2]), .b(Q[1]), .c(Q[3]), .d(Pin[2]), .select(Op), .out(D[2])); 
    mux41 MUX1(.a(Q[1]), .b(Q[0]), .c(Q[2]), .d(Pin[1]), .select(Op), .out(D[1]));
    mux41 MUX0(.a(Q[0]), .b(1'b0), .c(Q[1]), .d(Pin[0]), .select(Op), .out(D[0])); 

    always @(*) begin
        if (Op == 2'b01)
            assign Soot = Q[0];
        else
            assign Soot = Q[7];
    end

    endmodule