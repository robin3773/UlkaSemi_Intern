module alu_controller(
    input clk, 
    input reset_n, 
    input transaction_done, 

    output reg alu_en, 
    output reg spi_load_en, 
    output reg busy, 
    output reg rvalid, 
    output reg instr_reg_write, 
    output reg res_reg_write
); 

    reg [1:0] present_state, next_state; 
    parameter TRANSACTION = 2'b00; 
    parameter LOAD = 2'b01; 
  	parameter EXEC = 2'b10; 
    parameter REG_WRITE = 2'b11; 

    always @(*) begin
        begin: NSL
            case(present_state)
                TRANSACTION     : next_state = transaction_done ? LOAD: TRANSACTION; 
                LOAD            : next_state = EXEC; 
                EXEC            : next_state = REG_WRITE; 
                REG_WRITE       : next_state = TRANSACTION; 
            endcase 
        end 

        begin: OL
            case(present_state)
              TRANSACTION     : {alu_en, spi_load_en, busy, rvalid, instr_reg_write, res_reg_write} = 6'b000000; 
                LOAD            : begin
                                    alu_en = 0; 
                                    spi_load_en = 0; 
                                    busy = 0; 
                                    rvalid = 0; 
                                    instr_reg_write = 1; 
                                    res_reg_write = 0;  
                                end 

                EXEC            : begin 
                                    alu_en = 1; 
                                    spi_load_en = 0; 
                                    busy = 1; 
                                    rvalid = 0; 
                                    instr_reg_write = 0; 
                                    res_reg_write = 1;  
                                end 

                REG_WRITE       : begin
                                    alu_en = 1; 
                                    spi_load_en = 1; 
                                    busy = 0; 
                                    rvalid = 1; 
                                    instr_reg_write = 0; 
                                    res_reg_write = 0;  
                                end 
            endcase
        end 
    end 

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)
            present_state <= TRANSACTION; 
        else
            present_state <= next_state; 
    end 

endmodule  