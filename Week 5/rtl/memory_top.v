module memory_top #(parameter DATA_LENGTH = 32, parameter ADDRESS_LENGTH = 4)(
    input clk, 
    input reset_n, 
    input ss, sclk, mosi, 

    output miso
); 

    wire [DATA_LENGTH-1:0] spi_reg_out, data_reg_out, addr_reg_out, ram_data_out;


    spi_slave SPI_SLAVE(
        .clk(clk), 
        .reset_n(reset_n), 
        .ss(ss), 
        .sclk(sclk), 
        .mosi(mosi),
 		    .serial_in(spi_reg_out[0]),

        .miso(miso),
		    .shift_en(shift_en), 
        .transaction_done(transaction_done),
		    .serial_out(instr_serial_in)
    ); 

    shift_reg SPI_REG(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(shift_en), 
        .load_en(spi_load_en), 
      	.serial_in(mosi), 
        .parralel_in(ram_data_out), 

        .Q(spi_reg_out)
    ); 

    shift_reg ADDR_REG(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(addr_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(addr_reg_out)
    ); 

    shift_reg DATA_REG(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(data_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(data_reg_out)
    );

    DFFRAM_2048 RAM_MODULE(
        .clk(CLK), 
        .EN(mem_en), 
        .WE(mem_wr_en), 
        .RE(mem_rd_en),
        .Di(data_reg_out),
        .Do(ram_data_out)
    )

    mem_controller MEM_CONTROLLER(
        .clk(clk), 
        .reset_n(reset_n), 
        .transaction_done(transaction_done), 
        .read_write(read_write),

        .mem_en(mem_en), 
        .mem_wr_en(mem_wr_en), 
        .mem_rd_en(mem_rd_en), 
      	.spi_load_en(spi_load_en),
        .addr_reg_write(addr_reg_write), 
        .data_reg_write(data_reg_write)
    ); 

    assign address = addr_reg_out[3:0]; 

    endmodule
