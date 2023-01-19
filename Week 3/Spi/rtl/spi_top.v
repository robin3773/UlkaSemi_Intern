`include "posedge_detector.v"
`include "shift_reg.v"
`include "spi_fsm.v"
`include "counter.v"
`include "comparator.v"

module spi_slave(
    input clk, reset_n, 
    input ss, sclk, mosi,
    output miso
); 


    wire transaction_done; 
    wire [2:0] count; 

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
        .serial_in(mosi), 
        .serial_out(miso)
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
        .value2(3'b111), 
        .is_equal(bit_count_eq_8)
    ); 

    fsm CONTROLLER(
        .clk(clk), 
        .reset_n(reset_n),
        .sclk_posedge(is_posedge), 
        .ss(ss), 
        .shift_en(shift_en),
        .clear(clear), 
        .increament(increament),
        .transaction_done(transaction_done)
    ); 
endmodule

