`include "./source/alu.v"
`include "./source/shift_reg.v"
`include "./source/controller.v"

module top #(parameter INSTR_LENGTH = 12)(
    input clk, 
    input reset_n, 
    input start, 
    input [INSTR_LENGTH-1:0] instruction, 

    output [3:0] result,
    output cb,
    output rvalid
); 

    wire [INSTR_LENGTH-1:0] data_out;
    wire in_cb; 
    wire [3:0] in_result; 
    wire rvalid;  
    wire [4:0] result_out;


    controller CONTROL(
        .clk(clk), 
        .reset_n(reset_n), 
        .start(start), 
        .exec_en(exec_en), 
        .rvalid(rvalid)
    ); 

    alu ALU(
        .a(instruction[10:7]), 
        .b(instruction[6:3]), 
        .opcode(instruction[2:0]), 
        .funct(instruction[11]),
        .exec_en(exec_en),
        .out(result),
        .cb(cb)
    ); 

    assign result = result_out[3:0]; 
    assign cb = result_out[4];

endmodule 

