module comparator #(parameter WIDTH = 8)(
    input [WIDTH-1: 0] value1, value2, 
    output is_equal
); 


    assign is_equal = value1 == value2; 
endmodule 