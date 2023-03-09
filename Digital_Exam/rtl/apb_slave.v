module apb_slave #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32)(
    input pclk, 
    input presetn, 
    input psel, 
    input penable, 
    input pwrite, 
    input [ADDR_WIDTH -1 : 0] paddr, 
    input [DATA_WIDTH-1: 0] pwdata, 
    input [DATA_WIDTH-1:0] rd_data, 

    output [DATA_WIDTH-1:0] prdata, 
    output wr_en, rd_en,
    output [DATA_WIDTH-1:0] wr_data, 
    output [ADDR_WIDTH-1:0] addr
);


    parameter IDLE = 2'b00; 
    parameter SETUP = 2'b01; 
    parameter ACCESS = 2'b11; 

    reg [1:0] next_state, present_state; 
    reg [2:0] control; 

    always @(*) begin
        begin: NSL
            case(present_state)
                IDLE    : next_state = psel ? SETUP: IDLE; 
                SETUP   : next_state = psel ? penable ? ACCESS : SETUP : IDLE; 
                ACCESS  : next_state = IDLE; 
            endcase
        end 

        begin: OL
            case(present_state)
                IDLE    : control   = 3'b001; 
                SETUP   : control   = {pwrite, ~pwrite, 1'b1};
                ACCESS  : control   = 3'b001; 
            endcase 
        end 
    end 


    always @(posedge pclk or negedge presetn) begin 
        if(!presetn)
            present_state <= IDLE; 
        else 
            present_state <= next_state; 
    end

    assign {wr_en, rd_en, pready} = control; 
    assign prdata = rd_data; 
    assign wr_data = pwdata; 
    assign addr = paddr; 

endmodule 
