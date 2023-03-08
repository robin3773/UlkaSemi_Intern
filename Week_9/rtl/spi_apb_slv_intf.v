module spi_apb_slv_intf #(parameter ADDR_LENGTH = 32, DATA_LENGTH =32)(
    input pclk, preset, psel, penable, pwrite,
    input [ADDR_LENGTH-1:0] paddr,
    input [DATA_LENGTH-1:0] pwdata, 
    input spi_bsy, spi_rx_fifo_full, spi_rx_fifo_empty, 
    input spi_tx_fifo_full, spi_tx_fifo_empty, 

    output [DATA_LENGTH-1:0] prdata, 
    output pready, 

    output [3:0] spi_apb_slv_intf_dss, 
    output [1:0] spi_apb_slv_intf_frf,
    output spi_apb_slv_intf_spo,    
    output   spi_apb_slv_intf_sph, 
    output  [7:0] spi_apb_slv_intf_scr, 
    output   spi_apb_slv_intf_lbm, 
    output   spi_apb_slv_intf_sse, 
    output   spi_apb_slv_intf_ms, 
    output   spi_apb_slv_intf_sod, 
    output [15:0] spi_apb_slv_intf_data, 
    output   spi_apb_slv_intf_tfe, 
    output   spi_apb_slv_intf_tnf, 
    output   spi_apb_slv_intf_rne, 
    output   spi_apb_slv_intf_rff, 
    output  spi_apb_slv_intf_bsy, 
    output [7:0] spi_apb_slv_intf_cpsdvsr); 

    wire cr0_wr_en, cr1_wr_en, dr_wr_en, sr_wr_en, cpsr_wr_en; 
    wire wr_en, rd_en; 
    wire [ADDR_LENGTH-1:0] addr; 
    reg  [DATA_LENGTH-1:0] rd_data; 
    wire [DATA_LENGTH-1:0] wr_data; 

    wire [DATA_LENGTH-1:0] cr0_d, cr0_q; 
    wire [DATA_LENGTH-1:0] cr1_d, cr1_q; 
    wire [DATA_LENGTH-1:0] dr_d, dr_q; 
    wire [DATA_LENGTH-1:0] sr_d, sr_q; 
    wire [DATA_LENGTH-1:0] cpsr_d, cpsr_q; 


    dff #(32, 32'b0) u_cr0(
        .d(cr0_d),
        .q(cr0_q),
        .clk(pclk),
        .reset_n(preset)
    );

    dff #(32, 32'b0) u_cr1(
        .d(cr1_d),
        .q(cr1_q),
        .clk(pclk),
        .reset_n(preset)
    );

    dff #(32, 32'h0000xxxx) u_dr(
        .d(dr_d),
        .q(dr_q),
        .clk(pclk),
        .reset_n(preset)
    );

    dff #(32, 32'h3) u_sr(
        .d(sr_d),
        .q(sr_q),
        .clk(pclk),
        .reset_n(preset)
    );

    dff #(32, 32'b0) u_cpsr(
        .d(cpsr_d),
        .q(cpsr_q),
        .clk(pclk),
        .reset_n(preset)
    );

    apb u_apb(
	.pclk(pclk),
	.preset(preset),
	.paddr(paddr),
	.psel(psel),
	.penable(penable),
	.pwrite(pwrite),
	.rd_data(rd_data), 
	.pwdata(pwdata),

	.addr(addr),
	.wr_en(wr_en),
	.rd_en(rd_en),	
	.prdata(prdata),
	.pready(pready),
	.wr_data(wr_data)
); 


    assign cr0_wr_en = wr_en & (addr == 32'h0) ; 
    assign cr0_d = cr0_wr_en ? {16'b0, wr_data[15:0]} : cr0_q; 

    assign cr1_wr_en = wr_en & (addr == 32'h4) ; 
    assign cr1_d = cr1_wr_en ? {28'b0, wr_data[3:0]} : cr1_q; 

    assign dr_wr_en = wr_en & (addr == 32'h8) ; 
    assign dr_d = dr_wr_en ? {16'b0, wr_data[15:0]} : dr_q; 

    assign sr_d = {27'b0, spi_bsy, spi_rx_fifo_full, spi_rx_fifo_empty, spi_tx_fifo_full, spi_tx_fifo_empty}; 

    assign cpsr_wr_en = wr_en & (addr == 32'h10) ; 
    assign cpsr_d = cpsr_wr_en ? {24'b0, wr_data[7:0]} : cpsr_q; 

    always @(*) begin
        case(addr) 
            32'h0 : rd_data = rd_en ? cr0_q: 32'b0;
            32'h4 : rd_data = rd_en ? cr1_q: 32'b0;  
            32'h8 : rd_data = rd_en ? dr_q : 32'b0; 
            32'hc : rd_data = rd_en ? sr_q : 32'b0; 
            32'h10: rd_data = rd_en ? cpsr_q: 32'b0;
        endcase 
    end

    assign {spi_apb_slv_intf_scr, spi_apb_slv_intf_sph, spi_apb_slv_intf_spo, spi_apb_slv_intf_frf, spi_apb_slv_intf_dss} = cr0_q[15:0]; 
    assign {spi_apb_slv_intf_sod, spi_apb_slv_intf_ms, spi_apb_slv_intf_sse, spi_apb_slv_intf_lbm} = cr1_q[3:0]; 
    assign spi_apb_slv_intf_data = dr_q[15:0]; 
    assign {spi_apb_slv_intf_bsy, spi_apb_slv_intf_rff, spi_apb_slv_intf_rne, spi_apb_slv_intf_tnf, spi_apb_slv_intf_tfe} = sr_q[3:0]; 
    assign spi_apb_slv_intf_cpsdvsr = cpsr_q[7:0]; 
endmodule 

