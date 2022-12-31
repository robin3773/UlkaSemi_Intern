module top(
    input clk, 
    input reset_n, 
    input rx_start, 
    input data_in, 
    output frame_error
); 

    wire clk_count, bit_count; 
    wire [4:0] data_out; 

    counter clk_counter(
        .clk(clk), 
        .reset_n(reset_n), 
        .clear(clk_clear), 
        .increament(clk_increament), 
        .count(clk_count)
    ); 

    counter bit_counter(
        .clk(clk), 
        .reset_n(reset_n), 
        .clear(bit_clear), 
        .increament(bit_increament), 
        .count(bit_count)
    ); 

    shift_register shift(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(shift_en), 
        .data_in(data_in), 
        .data_out(data_out)
    ); 

    comparator clk_cmp(
        .value1(clk_count), 
        .value2(5), 
        .is_equal(clk_count_eq_5)
    ); 

    comparator bit_cmp(
        .value1(bit_count), 
        .value2(5), 
        .is_equal(bit_count_eq_5)
    ); 

    controller controller(
        .clk(clk), 
        .reset_n(reset_n), 
        .rx_start(rx_start), 
        .clk_count_eq_5(clk_count_eq_5), 
        .bit_count_eq_5(bit_count_eq_5), 

        .frame_error_gen(frame_error_gen), 
        .shift_en(shift_en), 
        .clk_clear(clk_clear), 
        .clk_increament(clk_increament), 
        .bit_clear(bit_clear), 
        .bit_increament(bit_increament)
    ); 

    assign frame_error = ~data_out[4] & frame_error_gen; 


endmodule 