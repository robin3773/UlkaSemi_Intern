`include "top.v"

module tb; 
    reg clk, reset_n, rx_start, data_in; 
    wire frame_error; 

    initial begin
        clk = 0; 
        reset_n = 1; 
        rx_start = 0; 
        data_in = 'bx; 
        forever begin
            #5 
            clk = ~clk; 
        end
    end

    initial begin
        @(negedge clk);
        reset_n = 0; 
        @(negedge clk);
        reset_n = 1; 

        rx_start = 1; 
        repeat(20) begin
            data_in = $random; 
            @(negedge clk);
        end

        #10
        $finish; 
    end 


    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars; 
    end

endmodule 
