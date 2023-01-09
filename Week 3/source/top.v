`include "./source/comparator.v"
`include "./source/counter.v"
`include "./source/controller.v"

module top(
    input clk, 
    input reset_n, 
    input start, 

    output red_on, yellow_on, green_on
); 

    wire [3:0] count; 

    counter COUNTER(
        .clk(clk), 
        .reset_n(reset_n), 
        .clear(clear), 
        .increament(increament), 
        .count(count)
    ); 

    cmprtr COMPARE3(
        .value1(count), 
        .value2(4'b0010), 
        .is_equal(clk_count_eq_3)
    ); 

    cmprtr COMPARE5(
        .value1(count), 
        .value2(4'b0100), 
        .is_equal(clk_count_eq_5)
    ); 
    
    cmprtr COMPARE10(
        .value1(count), 
        .value2(4'b1001), 
        .is_equal(clk_count_eq_10)
    );

    cmprtr COMPARE11(
        .value1(count), 
        .value2(4'b1010), 
        .is_equal(clk_count_eq_11)
    );

    controller CONTROL(
        .clk(clk), 
        .reset_n(reset_n), 
        .start(start), 
        .clear(clear), 
        .increament(increament),
        .clk_count_eq_3(clk_count_eq_3), 
        .clk_count_eq_5(clk_count_eq_5), 
        .clk_count_eq_10(clk_count_eq_10), 
        .clk_count_eq_11(clk_count_eq_11),
        .red_en(red_en), 
        .green_en(green_en), 
        .yellow_en(yellow_en)
    );

    assign red_on = red_en; 
    assign yellow_on = yellow_en; 
    assign green_on = green_en; 

endmodule 
    
