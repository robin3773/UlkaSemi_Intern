// Code your testbench here
// or browse Examples
//`include "../rtl/spi_top.v"
module spi_slave_tb; 

  parameter FRAME_SIZE = 8;
  logic clk, reset_n, ss, sclk, mosi; 
  wire miso; 

  logic [FRAME_SIZE-1:0] data_sent; 
  logic [FRAME_SIZE-1:0] data_received = 8'h0; 
  
  initial begin 
    clk <= 0; 
    reset_n <= 1; 
    ss <= 1; 
    sclk <= 0; 
    mosi <= 0; 
  end 
  
  always begin
    #1 
    clk <= ~clk; 
  end
  
  
  initial begin  
    @(posedge clk); 
    reset_n = 0; 
    @(posedge clk);
    reset_n = 1 ;
    repeat(100) begin
      data_sent = $random; 
      send_receive_frame(data_sent); 
      wait_2(); 
      send_receive_frame(data_sent);
      wait_2(); 
      check_case(); 
    end
    
    #10 
    $finish; 
  end 

  task wait_2(); 
    repeat(2) @(posedge clk); 
  endtask 

  task check_case(); 
    if(data_sent == data_received) 
      $display("Data Sent = %2h Data Received = %2h Status: Passed!!", data_sent, data_received);
    else 
      $display("Data Sent = %2h Data Received = %2h Status: Failed!!", data_sent, data_received);
  endtask 

  task send_receive_frame(input [7:0]data_sent); 
    ss <= 0; 
    wait_2(); 
    for(int i = 0; i < FRAME_SIZE; i++) begin
      sclk <= ~sclk; 
      mosi <= data_sent[i];
      data_received = {miso, data_received[7:1]}; 
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
  
  spi_slave DUT(
    .clk(clk), 
    .reset_n(reset_n), 
    .ss(ss), 
    .sclk(sclk), 
    .mosi(mosi), 
    .miso(miso));  
endmodule 