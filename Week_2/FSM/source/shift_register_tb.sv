`include "shift_register.v"
module shift_register_tb; 
    reg clk, reset_n, shift_en, data_in; 
    wire [4:0] data_out; 

    integer i;

    initial begin
        clk = 0; 
        reset_n = 1; 
        shift_en = 0; 
        data_in = 'bx; 
        
        forever begin
            clk = ~clk; 
            #1;
        end 
    end 

    initial begin 
        @(posedge clk); 
        reset_n = 0; 
        @(posedge clk); 
        shift_en = 0;
        reset_n = 1;  

        i = 0; 
        repeat(100) begin
            data_in = $random; 
            if (i == 4) begin
                shift_en = 1; 
                i = 0; 
            end 
            else shift_en = 0; 
            i = i + 1; 
            @(posedge clk); 
        end 

        #10
        $finish; 
    end 


    initial begin
        $dumpfile("shift.vcd"); 
        $dumpvars; 
    end 

    shift_register REG(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(shift_en), 
        .data_in(data_in), 
        .data_out(data_out)
    ); 

    endmodule