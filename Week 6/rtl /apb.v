module apb #(parameter DATA_WIDTH = 32, parameter ADDRESS_WIDTH = 32)(
    input pclk, presetn, 
    input paddr, 
    input psel, 
    input penable, 
    input pwrite, 
    input [DATA_WIDTH-1:0] rd_data, pwdata,

    output [ADDRESS_WIDTH-1:0] addr, 
    output reg wr_en, rd_en,
    output  prdata, 
    output reg pready,
    output  [DATA_WIDTH-1:0] wr_data
); 

    parameter IDLE       = 2'b00;
    parameter SETUP      = 2'b01; 
    parameter ACCESS     = 2'b10; 

    reg [1:0] next_state, present_state;

    always @(*) begin
        begin: NSL
            case(present_state)
                IDLE    : next_state = psel? SETUP: IDLE; 
                SETUP   : next_state = psel? (penable? ACCESS: SETUP) : IDLE; 
                ACCESS  : next_state = psel? (penable? SETUP: IDLE) : IDLE; 
            endcase
        end 

        begin: OL
            case(present_state)
                IDLE: begin
                    pready  =  1; 
                    wr_en   =  0; 
                    rd_en   =  0; 
                end

                SETUP: begin
                    pready  = 1; 
                    wr_en   = pwrite; 
                    rd_en   = ~pwrite; 
                end

                ACCESS: begin
                    pready  = 1;
                    wr_en   = 0; 
                    rd_en   = 0; 
                end  
            endcase
        end
    end 

    always @(posedge pclk, negedge presetn) begin 
        if(!presetn)
            present_state <= IDLE; 
        else 
            present_state <= next_state; 
    end 

    assign prdata   = rd_data; 
    assign wr_data  = pwdata; 
    assign addr     = paddr; 

endmodule 