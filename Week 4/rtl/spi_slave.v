module spi_slave#(parameter BIT_LENGTH = 20)(
    input clk, reset_n, 
    input ss, sclk, mosi,
  	input spi_load_en,
  	input [BIT_LENGTH-1:0] spi_load,
    
    output miso, 
    output transaction_done, 
    output [BIT_LENGTH-1:0] data_out
); 
  
    wire [4:0] count; 

    posedge_detect POSEDGE_DETECTOR(
        .clk(clk), 
        .reset_n(reset_n), 
        .sclk(sclk), 

        .is_posedge(is_posedge)
    ); 

    shift_reg SHIFT_REGISTER(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(shift_en),
     	.load_en(spi_load_en),
      	.parralel_in(spi_load), 
        .serial_in(mosi), 

        .Q(data_out)
    ); 

    counter BIT_COUNTER(
        .clk(clk), 
        .reset_n(reset_n), 
        .clear(clear), 
        .increament(increament), 

        .count(count)
    ); 

    cmprtr COMPARE(
        .value1(count), 
        .value2(5'b10100), 

        .is_equal(bit_count_eq_20)
    ); 

    fsm CONTROLLER(
        .clk(clk), 
        .reset_n(reset_n),
        .sclk_posedge(is_posedge), 
        .ss(ss),
        .bit_count_eq_20(bit_count_eq_20),  
        .shift_en(shift_en),
        .clear(clear), 
        .increament(increament),
        .transaction_done(transaction_done)
    );

    assign miso = data_out[0];  
endmodule
