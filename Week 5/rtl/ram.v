module DFFRAM_2048 #(parameter ADDRESS_LENGTH = 4, parameter DATA_LENGTH = 32)(
    input CLK,
    input EN, WE, RE, 
    input [DATA_LENGTH-1:0] Di,
    input [ADDRESS_LENGTH-1:0] A,

    output reg [DATA_LENGTH-1:0] Do
);

    reg [(DATA_LENGTH) -1:0] RAM[2047 : 0]; 

    always @(posedge CLK) begin
        if(EN) begin
            if (RE) 
                Do <= RAM[A];
            if(WE) 
                RAM[A] <= Di;
        end

        else
            Do <= 32'b0;
    end 
endmodule