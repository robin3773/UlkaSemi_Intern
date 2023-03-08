module memory_top_tb; 

  parameter FRAME_SIZE = 8;
  logic clk, reset_n; 
  logic ss, sclk, mosi; 

  wire miso; 

  logic [FRAME_SIZE-1:0] data_sent, expected_out, address_frame; 
  logic [FRAME_SIZE-1:0] data_received = 32'h0; 
  logic [3:0] address; 
  
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
		
		//send_receive_frame({$random, 4'b0000, 1'b1}); 
		wait_2(); 

	  	for(int i = 0; i < 10; i++) begin
			address = i; 
			address_frame = {27'b0, address, 1'b1}; 
			data_sent = i; 
			
			//Sending adress_frame
			send_receive_frame(address_frame[7:0]); 
			wait_2(); 
			//send_receive_frame(address_frame[15:8]); 
			//wait_2(); 
			//send_receive_frame(address_frame[23:16]); 
			//wait_2(); 
			//send_receive_frame(address_frame[31:24]); 
			//wait_2(); 
			
			//Sending data frame
			//send_receive_frame(data_sent[7:0]);
			//wait_2(); 
			//send_receive_frame(data_sent[15:8]);
			//wait_2(); 
			//send_receive_frame(data_sent[23:16]);
			//wait_2(); 
			//send_receive_frame(data_sent[31:24]);
			//wait_2(); 
	
			//address_frame[0] = 1'b0; 
			//send_receive_frame(address_frame); 
			//$display("[%4t] Data Received = %8h", $time, data_received); 
			//wait_2(); 
			///send_receive_frame(address_frame); 
			//check_case(); 
		end 
		#10;
		$finish;

    end 


     task wait_2(); 
    	repeat(2) @(posedge clk); 
 	 endtask 

  task check_case(); 
    if(data_sent == data_received) 
      $display("Data Sent = %8h Data Received = %8h Status: Passed!!", data_sent, data_received);
    else 
      $display("Data Sent = %8h Data Received = %8h Status: Failed!!", data_sent, data_received);
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

  
  memory_top DUT(
    .clk(clk), 
    .reset_n(reset_n), 
    .ss(ss), 
    .sclk(sclk), 
    .mosi(mosi), 

    .miso(miso)
  ); 

  endmodule
