`include "./source/top.v"

module tb; 
    reg clk =0, reset_n = 1, start = 0; 

    wire red_on, yellow_on, green_on; 

    always begin
        #5; 
        clk = ~clk; 
    end

    initial begin
        clk = 0; 
        reset_n = 1; 
        start = 0; 
        @(posedge clk); 
        reset_n = 0; 
        @(posedge clk); 
        reset_n = 1; 
        @(posedge clk); 
        start = 1;

        $monitor("[%3t] red = %0b yellow = %0b green = %0b", $time, red_on, yellow_on, green_on); 
        #500
        $finish; 
    end 

    initial begin
        $dumpfile("./waveform/traffic.vcd"); 
        $dumpvars; 
    end 

    top DUT(
        .clk(clk), 
        .reset_n(reset_n), 
        .start(start), 
        .red_on(red_on), 
        .yellow_on(yellow_on), 
        .green_on(green_on)
    ); 

endmodule 