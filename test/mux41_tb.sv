`include "./source/mux41.v"

module mux41_tb; 
    logic a, b, c, d; 
    logic [1:0] select; 
    wire out; 


    initial begin
        a = $random; 
        b = $random; 
        c = $random; 
        d = $random; 
        select = $random; 

        repeat(20) begin
                a = $random; 
                b = $random; 
                c = $random; 
                d = $random; 
                select = $random;
                # 5; 
        end 
    end

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars; 
    end

      
    mux41 DUT(
        .a(a), 
        .b(b), 
        .c(c), 
        .d(d), 
        .select(select), 
        .out(out)
    ); 

endmodule 