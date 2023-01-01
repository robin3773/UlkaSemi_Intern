`include "./source/top.v"

module top_tb; 
    reg clk = 0; 
    logic reset_n = 1; 
    logic start = 0; 
    logic [11:0] instruction; 

    wire [3:0] result;
    wire cb, rvalid; 

  	logic [3:0] a = 4'b1011; 
  	logic [3:0] b = 4'b1010; 
 	logic [2:0] opcode = 3'b010; 
    logic funct = 1; 

    logic [3:0] expected_result; 
    reg [15:0] operation; 


    initial begin
      	clk = 0; 
        forever begin
            #1; 
            clk = ~clk; 
        end
    end

    initial begin
        //repeat (20) begin
        a = $random; 
        b = $random; 
        instruction = {funct, a, b, opcode};
        @(negedge clk)
        reset_n = 0; 
        @(negedge clk)
      	reset_n = 1; 
      	@(negedge clk)
        start = 1; 
      
        opcode = 3'b000; 
        funct = 0;
        instruction = {funct, a, b, opcode};
        expected_result = a + b;
        operation = "+";
        @(posedge rvalid);
        //if(result != expected_result) 
            $display("[%0t] %b %s %b = %b >>>>> Got = %b", $time, a, operation, b, expected_result, result);

        opcode = 3'b000; 
        funct = 1; 
        instruction = {funct, a, b, opcode};
        expected_result = a - b;
        operation = "-";
        @(posedge rvalid);
        //if(result != expected_result) 
            $display("[%0t] %b %s %b = %b >>>>> Got = %b", $time, a, operation, b, expected_result, result);

       opcode = 3'b001; 
        funct = 0; 
        instruction = {funct, a, b, opcode};
        expected_result = a & b;
        operation = "&";
        @(posedge rvalid);
        //if(result != expected_result) 
            $display("[%0t] %b %s %b = %b >>>>> Got = %b", $time, a, operation, b, expected_result, result);

        opcode = 3'b001; 
        funct = 1; 
        instruction = {funct, a, b, opcode};
        expected_result = ~(a & b);
        operation = "~&";
        @(posedge rvalid);
        //if(result != expected_result) 
            $display("[%0t] %b %s %b = %b >>>>> Got = %b", $time, a, operation, b, expected_result, result);

        opcode = 3'b010; 
        funct = 0; 
        instruction = {funct, a, b, opcode};
        expected_result = a | b;
        operation = "|";
        @(posedge rvalid);
        //if(result != expected_result) 
            $display("[%0t] %b %s %b = %b >>>>> Got = %b", $time, a, operation, b, expected_result, result);

        opcode = 3'b010; 
        funct = 1; 
        instruction = {funct, a, b, opcode};
        expected_result = a ~| b;
        operation = "~|";
        @(posedge rvalid);
        //if(result != expected_result) 
            $display("[%0t] %b %s %b = %b >>>>> Got = %b", $time, a, operation, b, expected_result, result);


        opcode = 3'b011; 
        funct = 0; 
        instruction = {funct, a, b, opcode};
        expected_result = ~a;
        operation = "~";
        @(posedge rvalid);
        //if(result != expected_result) 
            $display("[%0t] a %s %b = %b >>>>> Got = %b", $time, operation, a, expected_result, result);


        opcode = 3'b100; 
        funct = 1; 
        instruction = {funct, a, b, opcode};
        expected_result = ~ b;
        operation = "~";
        @(posedge rvalid); 
        //if(result != expected_result) 
            $display("[%0t] %s %b = %b >>>>> Got = %b", $time, operation, b, expected_result, result);
 
        opcode = 3'b101; 
        funct = 0; 
        instruction = {funct, a, b, opcode};
        expected_result = a ^ b;
        operation = "^";
        @(posedge rvalid); 
        //if(result != expected_result) 
            $display("[%0t] %b %s %b = %b >>>>> Got = %b", $time, a, operation, b, expected_result, result);

        opcode = 3'b101; 
        funct = 1; 
        instruction = {funct, a, b, opcode};
        expected_result = a ~^ b;
        operation = "~^";
        @(posedge rvalid);
        if(result != expected_result) 
            $display("[%0t] %b %s %b = %b >>>>> Got = %b", $time, a, operation, b, expected_result, result);

        opcode = 3'b110; 
        funct = 0; 
        b = 4'b010; 
        instruction = {funct, a, b, opcode};
        expected_result = a << b; 
        operation = "<<"; 
        @(posedge rvalid); 
        //if(result != expected_result) 
            $display("[%0t] %b %s %b = %b >>>>> Got = %b", $time, a, operation, b, expected_result, result);
        //end
        #10 
        $finish; 

    end 

    initial begin
        $dumpfile("./waveform/top_tb.vcd");
        $dumpvars; 
    end 
  
  	top DUT(
        .clk(clk), 
        .reset_n(reset_n), 
        .start(start), 
        .instruction(instruction), 
        .result(result), 
      	.cb(cb), 
        .rvalid(rvalid)
    ); 

endmodule 
