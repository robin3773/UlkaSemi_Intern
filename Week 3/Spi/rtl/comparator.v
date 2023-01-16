module cmprtr(
    input value1, 
    input value2, 
    output is_equal
); 

    assign is_equal = (value1 == value2);
endmodule