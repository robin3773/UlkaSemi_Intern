`include "./source/d_flip_flop.v"

module dff_tb; 
    logic clk = 0; 
    logic rst_n = 1; 
    logic D = 1; 
    wire Q; 

    always #5 clk = ~clk; 

    initial begin
        @(negedge clk)
        rst_n = 1; 

        @(negedge clk)
        @(negedge clk)
        repeat(20) begin
            D = $random; 
            @(negedge clk); 
        end

        $finish; 

    end 

    initial begin
        $dumpfile("d_flip_flop.vcd"); 
        $dumpvars; 
    end 

    dff DUT(
        .clk(clk), 
        .rst_n(rst_n), 
        .D(D), 
        .Q(Q)
    ); 
endmodule 