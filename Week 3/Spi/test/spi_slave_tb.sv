// Code your testbench here
// or browse Examples
`include "../rtl/spi_top.v"
module spi_slave_tb; 
  logic clk, reset_n, ss, sclk, mosi; 
  wire miso; 
  
  initial begin 
    clk = 0; 
    reset_n = 1; 
    ss = 1; 
    sclk = 0; 
    mosi = 0; 
  end 
  
  always begin
    #1 
    clk = ~clk; 
  end
  
  initial begin 
    #1
    forever begin
      #8
      sclk = ~sclk;
    end
  end 
  
  initial begin  
    @(posedge clk); 
    reset_n = 0; 
    @(posedge clk);
    reset_n = 1 ;
    ss = 0; 
    repeat(8) begin 
      mosi = $random;
      @(posedge sclk); 
    end 
    ss = 1; 
    
    #10 
    $finish; 
  end 
  
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