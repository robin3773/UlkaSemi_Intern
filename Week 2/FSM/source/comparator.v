module comparator #(parameter VALUE_WIDTH = 3)(
    input [VALUE_WIDTH - 1: 0] value1, 
    input [VALUE_WIDTH - 1: 0] value2, 
    output reg is_equal
); 

    always @(*) begin
        if (value1 == value2) is_equal = 1; 
        else is_equal = 0;
    end 
endmodule