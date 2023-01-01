`include "alu.v"

module alu_tb; 
    logic [3:0] a, b;
    wire [3:0] out; 
    logic [2:0] opcode; 
    logic funct, exec_en; 
    wire cb; 

    initial begin 
        exec_en = 1; 
        a = $random; 
        b = $random; 
        opcode = 3'b000; 
        funct = 0;
        #1 
        $display("[%0t] A = %b ADD  B = %b  >> Expected Out = %b Resulted Out = %b", $time, a, b, a + b, out);

        a = $random; 
        b = $random; 
        opcode = 3'b000; 
        funct = 1; 
        #1
        $display("[%0t] A = %b SUB  B = %b  >> Expected Out = %b Resulted Out = %b", $time, a, b, a - b, out);

        a = $random; 
        b = $random; 
        opcode = 3'b001; 
        funct = 0; 
        #1
        $display("[%0t] A = %b AND  B = %b  >> Expected Out = %b Resulted Out = %b", $time, a, b, a & b, out);

        a = $random; 
        b = $random; 
        opcode = 3'b001; 
        funct = 1; 
        #1
        $display("[%0t] A = %b NAND B = %b  >> Expected Out = %b Resulted Out = %b", $time, a, b, ~(a & b), out);

        a = $random; 
        b = $random; 
        opcode = 3'b010; 
        funct = 0; 
        #1
        $display("[%0t] A = %b OR B = %b  >> Expected Out = %b Resulted Out = %b", $time, a, b, (a | b), out);

        a = $random; 
        b = $random; 
        opcode = 3'b010; 
        funct = 1; 
        #1
        $display("[%0t] A = %b NOR B = %b  >> Expected Out = %b Resulted Out = %b", $time, a, b, ~(a | b), out);

        a = $random; 
        b = $random; 
        opcode = 3'b011; 
        funct = 0; 
        #1
        $display("[%0t] A = %b NOTA B = %b  >> Expected Out = %b Resulted Out = %b", $time, a, b, ~a, out);

        a = $random; 
        b = $random; 
        opcode = 3'b100; 
        funct = 1; 
        #1
        $display("[%0t] A = %b NOTB B = %b  >> Expected Out = %b Resulted Out = %b", $time, a, b, ~b, out);

        a = $random; 
        b = $random; 
        opcode = 3'b101; 
        funct = 1; 
        #1
        $display("[%0t] A = %b XOR B = %b  >> Expected Out = %b Resulted Out = %b", $time, a, b, a ^ b, out);
    end 


    alu ALU(
        .a(a), 
        .b(b), 
        .opcode(opcode), 
        .funct(funct), 
        .exec_en(exec_en), 
        .out(out), 
        .cb(cb)
    ); 

endmodule 