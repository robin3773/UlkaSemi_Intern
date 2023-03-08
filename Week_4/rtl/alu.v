module alu #(parameter BIT_LENGTH = 8, INSTR_LENGTH = 20, OPCODE_LENGTH = 4)(
    input exec_en,
    input [BIT_LENGTH-1:0] a, b,  
    input [OPCODE_LENGTH-1:0] opcode,

    output reg [INSTR_LENGTH-1:0] out
); 

    always @(*) begin
    if (exec_en) begin
        case(opcode)
            4'b0000: out    = a + b; 
            4'b1000: out    = a - b; 
            4'b0001: out    = a << b; 
            4'b0010: out    = a >> b; 
            4'b0011: out    = a & b; 
            4'b0100: out    = a | b;  
            4'b0101: out    = a ^ b;
            4'b0110: out    = a; 
            4'b0111: out    = b; 
            default: out    = 'bx; 
        endcase
    end
    else 
        out = 'b0; 
    end

endmodule 
