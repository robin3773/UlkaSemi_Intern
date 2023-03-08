module alu_top_tb; 

    parameter FRAME_SIZE = 20;
    logic clk, reset_n; 
    logic ss, sclk, mosi; 
  logic [7:0] a, b; 
  logic [3:0] opcode; 

    wire miso, busy, rvalid; 

  	logic [FRAME_SIZE-1:0] data_sent, expected_out ; 
    logic [FRAME_SIZE-1:0] data_received = 20'h0; 

    initial begin
        clk <= 0; 
        reset_n <= 1; 
        ss <= 1; 
        sclk <= 0; 
        mosi <= 0; 
    end

    always begin
        #1 clk = ~clk; 
    end

    initial begin
        @(posedge clk); 
        reset_n <= 0; 
        @(posedge clk); 
        reset_n <= 1; 
        if(!busy) begin
          repeat(100) begin
            	a = $random; 
            	b = $random; 
            	opcode = $urandom_range( 8, 0 );
            	data_sent = {a, b, opcode}; 
                send_receive_frame(data_sent); 
                wait_2(); 
                send_receive_frame(data_sent); 
                wait_2(); 
                check_case(); 
            end 
        end 
		#10;
		$finish;

    end 


     task wait_2(); 
    repeat(2) @(posedge clk); 
  endtask 

  task check_case(); 
    
    if(expected_out == data_received) 
      $display("Data Sent = %5h Expected Data = %5h Data Received = %5h Status: Passed!!", data_sent, expected_out, data_received);
    else 
      $display("Data Sent = %5h Expected Data = %5h Data Received = %5h Status: Failed!!", data_sent, expected_out, data_received);
  endtask 

  task send_receive_frame(input [FRAME_SIZE-1:0]data_sent); 
    ss <= 0; 
    wait_2(); 
    for(int i = 0; i < FRAME_SIZE; i++) begin
      sclk <= ~sclk; 
      mosi <= data_sent[i];
      data_received <= {miso, data_received[FRAME_SIZE-1:1]}; 
      wait_2(); 
      sclk <= ~sclk; 
      wait_2(); 
    end 
    ss <= 1; 
    wait_2(); 
  endtask 

  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars; 
  end 
  
  alu test_alu(.exec_en(1'b1), 
               .a(data_sent[19:12]), 
               .b(data_sent[11:4]), 
               .opcode(data_sent[3:0]), 
               .out(expected_out)); 
  
  alu_top DUT(
    .clk(clk), 
    .reset_n(reset_n), 
    .ss(ss), 
    .sclk(sclk), 
    .mosi(mosi), 

    .miso(miso), 
    .busy(busy), 
    .rvalid(rvalid)
  ); 

  endmodule