`include "top.v"

module tb; 
    reg clk, reset_n, rx_start, data_in; 
    wire frame_error; 
  	integer i, start_time, current_time, j;
  reg [4:0]data;

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
        @(posedge clk);
        reset_n = 0; 
        @(posedge clk);
        reset_n = 1; 
		
      	i = 0; 
        j = 0; 
        rx_start = 1; 
        start_time = $time; 
      	$display("[%0t] Start", $time); 
        repeat(100) begin
            current_time = $time; 
            data_in = $random;
            if (current_time - start_time == 50) begin
                $display("[%3t] rx_start = %0b data_in = %5b, frame_error = %0b", $time, rx_start, data_in, frame_error);
                data[i] = data_in; 
                i = i + 1;
                start_time = $time;
            end

            if ( i == 5) begin
                $display("---------------------------------------"); 
                $display("[%3t] rx_start = %0b data_in = %5b, frame_error = %0b", $time, rx_start, data, frame_error);
                $display("---------------------------------------");
                i = 0; 
            end

            
            @(posedge clk);
        end

        #10
        $finish; 
    end 


    initial begin
      $dumpfile("dump.vcd"); 
        $dumpvars; 
    end

    top DUT(
        .clk(clk), 
        .reset_n(reset_n), 
        .rx_start(rx_start), 
        .data_in(data_in), 
        .frame_error(frame_error)
    );

endmodule 