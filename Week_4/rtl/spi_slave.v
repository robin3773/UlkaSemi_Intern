module spi_slave#(parameter BIT_LENGTH = 20)(
    input clk, reset_n, 
    input ss, sclk, mosi,
	input serial_in, 
    
    output miso, 
	output shift_en, 
    output transaction_done, 
	output serial_out
); 
  
    wire [4:0] count; 

    posedge_detect POSEDGE_DETECTOR(
        .clk(clk), 
        .reset_n(reset_n), 
        .sclk(sclk), 

        .is_posedge(is_posedge)
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

    assign miso = serial_in; 
	assign serial_out = mosi; 
endmodule
