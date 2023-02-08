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
	wire shift_en; 
  	wire [19:0] alu_out, result_reg_out; 
	wire instr_serial_in; 

    spi_slave SPI_SLAVE(
        .clk(clk), 
        .reset_n(reset_n), 
        .ss(ss), 
        .sclk(sclk), 
        .mosi(mosi),
 		.serial_in(result_reg_out[0]),

        .miso(miso),
		.shift_en(shift_en), 
        .transaction_done(transaction_done),
		.serial_out(instr_serial_in)
    ); 

    shift_reg INSTR_REG(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(shift_en), 
        .load_en(1'b0), 
      	.serial_in(instr_serial_in), 
        .parralel_in(20'b0), 

        .Q(instruction)
    ); 

    shift_reg RESULT_REG(
        .clk(clk), 
        .reset_n(reset_n), 
        .shift_en(shift_en), 
        .load_en(res_reg_write), 
      	.serial_in(1'b0), 
        .parralel_in(alu_out), 

        .Q(result_reg_out)
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
