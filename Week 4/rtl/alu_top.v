module alu_top(
    input clk, 
    input reset_n, 
    input ss, sclk, mosi, 

    output miso, 
    output busy, 
    output rvalid
); 

	wire [19:0] instruction;  
	wire alu_en; 
	wire [19:0]data_out;
	wire instr_reg_write, res_reg_write, spi_load_en; 
  	wire [19:0] alu_out, spi_load; 

    spi_slave SPI_SLAVE(
        .clk(clk), 
        .reset_n(reset_n), 
        .ss(ss), 
        .sclk(sclk), 
        .mosi(mosi), 
      	.spi_load_en(spi_load_en),
      	.spi_load(spi_load),

        .transaction_done(transaction_done),
        .miso(miso), 
        .data_out(data_out)
    ); 

    shift_reg INSTR_REG(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(instr_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(data_out), 

        .Q(instruction)
    ); 

    shift_reg RESULT_REG(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(1'b0), 
        .load_en(res_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(alu_out), 

        .Q(spi_load)
    );

    alu ALU(
		.exec_en(alu_en),
        .a(instruction[19:12]), 
        .b(instruction[11:4]), 
        .opcode(instruction[3:0]),

        .out(alu_out)
    ); 

    alu_controller ALU_CONTROLLER(
        .clk(clk), 
        .reset_n(reset_n), 
        .transaction_done(transaction_done), 

        .alu_en(alu_en), 
      	.spi_load_en(spi_load_en), 
        .busy(busy), 
        .rvalid(rvalid), 
        .instr_reg_write(instr_reg_write), 
        .res_reg_write(res_reg_write)
    ); 

    endmodule
