`include "./source/uni_shift_reg.v"

module uni_shift_reg_tb; 
    logic [7:0] Pin;
    logic [1:0] Op;
    logic clk; 
    logic reset_n; 
    wire Soot; 

    initial begin
        Pin = 8'b10101011; 
        Op = 2'b00; 
        clk = 0; 
        reset_n = 1; 

        forever begin
            #1 clk = ~clk; 
        end
    end

    initial begin
        @(negedge clk);
        reset_n = 0; 
        @(negedge clk);
        @(negedge clk); 

        reset_n = 1; 
        Op = 2'b11; 
        $display("---------------Checking Load Condition----------------");
        repeat(7) begin
            $display("Soot is %0d", Soot);
            @(negedge clk);
        end

        Op = 2'b00;
        $display("---------------Checking No change Condition----------------");
        repeat(7) begin
            $display("Soot is %0d", Soot);
            @(negedge clk);
        end

        Op = 2'b10;  
        $display("---------------Checking Right Shift Condition----------------");
        repeat(7) begin
            $display("Soot is %0d", Soot);
            @(negedge clk);
        end 

        Op = 2'b11; 
        @(negedge clk); 
        Op = 2'b01;  
        $display("---------------Checking Left Shift Condition----------------");
        repeat(7) begin
            $display("Soot is %0d", Soot);
            @(negedge clk);
        end 

    end 

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars; 
    end 


    uni_shift_reg DUT(
        .Pin(Pin), 
        .Op(Op), 
        .clk(clk), 
        .reset_n(reset_n), 
        .Soot(Soot)
    ); 
endmodule 