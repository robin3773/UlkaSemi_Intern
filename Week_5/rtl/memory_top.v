module memory_top #(parameter DATA_LENGTH = 32, parameter ADDRESS_LENGTH = 4)(
    input clk, 
    input reset_n, 
    input ss, sclk, mosi, 

    output miso
); 
	
    wire [DATA_LENGTH/4-1:0] spi_reg_out, data_reg_out, addr_reg_out; 
    wire [DATA_LENGTH-1:0] ram_data_out;
	wire [3:0]address;
	
	wire transaction_eq_4; 
	wire [2:0] tran_count;
	wire trn_count_clear; 

	
	counter #(3) TRANSACTION_COUNTER(
		.clk(clk), 
		.reset_n(reset_n), 
		.clear(trn_count_clear), 
		.increament(transaction_done), 
		
		.count(tran_count)
	); 
		
	cmprtr #(3) TRANSACTION_CMPR(
		.value1(tran_count), 
		.value2(3'b100), 
		.is_equal(transaction_eq_4)
	); 
		
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

    shift_reg #(8) ADDR_REG3(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(addr_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(addr_reg3_out)
    ); 
    
    shift_reg #(8) ADDR_REG2(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(addr_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(addr_reg2_out)
    ); 
    
    shift_reg #(8) ADDR_REG1(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(addr_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(addr_reg1_out)
    ); 
    
    shift_reg #(8) ADDR_REG0(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(addr_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(addr_reg0_out)
    ); 




    shift_reg #(8) DATA_REG3(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(data_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(data_reg_out)
    );
    
    shift_reg #(8) DATA_REG2(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(data_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(data_reg_out)
    );
    
    
    shift_reg #(8) DATA_REG1(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(data_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(data_reg_out)
    );
    
    
    shift_reg #(8) DATA_REG0(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(data_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(spi_reg_out), 

        .Q(data_reg_out)
    );
    
    
    DFFRAM_2048 RAM_MODULE(
        .CLK(clk), 
        .EN(mem_en), 
        .WE(mem_wr_en), 
        .RE(mem_rd_en),
        .Di(data_reg_out),
        .Do(ram_data_out),
	.A(address)
    );

    mem_controller MEM_CONTROLLER(
        .clk(clk), 
        .reset_n(reset_n), 
        .transaction_eq_4(transaction_eq_4), 
        .read_write(read_write),

        .mem_en(mem_en), 
        .mem_wr_en(mem_wr_en), 
        .mem_rd_en(mem_rd_en), 
      	.spi_load_en(spi_load_en),
        .addr_reg_write(addr_reg_write), 
        .data_reg_write(data_reg_write), 
        .transaction_count_clear(trn_count_clear)
    ); 
	
	assign read_write = addr_reg_out[0]; 
    assign address = addr_reg_out[4:1]; 

    endmodule
