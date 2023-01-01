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

    initial begin
        repeat (20) begin
            //$display("[%0t] Result = %b", $time, result); 
            @(posedge clk);
        end
    end

    shift_reg INPUT_REGISTER(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(shift_en_in), 
        .data_in_p(instruction), 
        .data_out_p(data_out)
    ); 

    shift_reg  #(.DATA_LENGTH(5)) OUTPUT_REGISTER (
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(shift_en_out),
        .data_in_p({in_cb, in_result}), 
        .data_out_p(result_out)
    );

    controller CONTROL(
        .clk(clk), 
        .reset_n(reset_n), 
        .start(start), 
        .shift_en_in(shift_en_in), 
        .shift_en_out(shift_en_out),
        .exec_en(exec_en), 
        .rvalid(rvalid)
    ); 

    alu ALU(
        .a(data_out[10:7]), 
        .b(data_out[6:3]), 
        .opcode(data_out[2:0]), 
        .funct(data_out[11]),
        .exec_en(exec_en),
        .out(in_result),
        .cb(in_cb)
    ); 

    assign result = result_out[3:0]; 
    assign cb = result_out[4];

endmodule 

