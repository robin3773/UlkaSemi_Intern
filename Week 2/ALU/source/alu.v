module alu #(parameter BIT_LENGTH = 4)(
    input [BIT_LENGTH-1:0] a, 
    input [BIT_LENGTH-1:0] b, 
    input [2:0] opcode, 
    input funct, 
    input exec_en, 
    output reg [BIT_LENGTH-1:0] out,
    output reg cb
);
    
    wire [3:0] operator; 
    assign operator = {funct, opcode}; 
    always @(*) begin
        //$display("[%0t] Operator %b",$time, operator); 
        if (exec_en) begin
            case(operator)
                4'b0000: {cb, out} = a + b; 
                4'b1000: {cb, out} = a - b; 
                4'b0001: {cb, out} = a & b; 
                4'b0010: {cb, out} = a | b; 
                4'b0011: {cb, out} = ~a; 
                4'b1100: {cb, out} = ~b; 
                4'b0101: begin
                    {cb, out} = a ^ b; 
                    //$display("[%0t] Inside XOR %b",$time, {cb, out}   );
                end
                4'b1101: {cb, out} = ~(a ^ b); 
                4'b1001: {cb, out} = ~(a & b); 
                4'b1010: {cb, out} = ~(a | b); 
                4'b0110: {cb, out} = a << b; 
                4'b0111: {cb, out} = a >> b; 
                default: {cb, out} = 'bx; 
            endcase
        end
        else 
            {cb, out} = 'b0; 
    end

endmodule