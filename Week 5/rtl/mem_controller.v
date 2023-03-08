module mem_controller(
    input clk, 
    input reset_n, 
    input transaction_eq_4,
    input read_write,

    output reg mem_en,
    output reg mem_wr_en, 
    output reg mem_rd_en,  
    output reg spi_load_en, 
    output reg addr_reg_write, 
    output reg data_reg_write, 
    output reg transaction_count_clear
); 

    reg [2:0] present_state, next_state; 
    parameter IDLE          = 3'b000; 
    parameter ADDR_LOAD     = 3'b001; 
    parameter MEM_READ      = 3'b010;
    parameter WAIT_FOR_DATA = 3'b011;
    parameter DATA_LOAD     = 3'B100; 
    parameter MEM_WRITE     = 3'b101; 

    always @(*) begin
        begin: NSL
            case(present_state)
                IDLE            : next_state = transaction_eq_4 ? ADDR_LOAD: IDLE; 
                ADDR_LOAD       : next_state = read_write? WAIT_FOR_DATA: MEM_READ; 
                WAIT_FOR_DATA   : next_state = transaction_eq_4? DATA_LOAD: WAIT_FOR_DATA; 
                DATA_LOAD       : next_state = MEM_WRITE; 
                MEM_WRITE       : next_state = IDLE; 
                MEM_READ        : next_state = IDLE; 
            endcase 
        end 

        begin: OL
            case(present_state)
                IDLE            : begin
                                    mem_en          = 0;
                                    mem_rd_en       = 0; 
                                    mem_wr_en       = 0;  
                                    spi_load_en     = 0; 
                                    addr_reg_write  = transaction_eq_4; 
                                    data_reg_write  = 0;  
                                    transaction_count_clear = 0; 
                                end
                ADDR_LOAD            : begin
                                    mem_en          = 0;
                                    mem_rd_en       = 0; 
                                    mem_wr_en       = 0;  
                                    spi_load_en     = 0; 
                                    addr_reg_write  = transaction_eq_4; 
                                    data_reg_write  = 0;  
                                    transaction_count_clear = 1; 
                                end 

                WAIT_FOR_DATA   : begin
                                    mem_en          = 0;
                                    mem_rd_en       = 0; 
                                    mem_wr_en       = 0;  
                                    spi_load_en     = 0; 
                                    addr_reg_write  = 0; 
                                    data_reg_write  = 0; 
                                    transaction_count_clear = 0;         
                                end

                DATA_LOAD   : begin
                                    mem_en          = 0;
                                    mem_rd_en       = 0; 
                                    mem_wr_en       = 0;  
                                    spi_load_en     = 0; 
                                    addr_reg_write  = 0; 
                                    data_reg_write  = read_write;  
                                    transaction_count_clear = 1;           
                                end

                MEM_WRITE       : begin 
                                    mem_en          = 1;
                                    mem_rd_en       = 0; 
                                    mem_wr_en       = 1;  
                                    spi_load_en     = 0; 
                                    addr_reg_write  = 0; 
                                    data_reg_write  = 0;  
                                    transaction_count_clear = 1; 
                                end 

                MEM_READ       : begin
                                    mem_en          = 1;
                                    mem_rd_en       = 1; 
                                    mem_wr_en       = 0;  
                                    spi_load_en     = ~read_write; 
                                    addr_reg_write  = 0; 
                                    data_reg_write  = ~read_write;  
                                    transaction_count_clear = 1;  
                                end 
            endcase
        end 
    end 

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)
            present_state <= IDLE; 
        else
            present_state <= next_state; 
    end 

endmodule  
