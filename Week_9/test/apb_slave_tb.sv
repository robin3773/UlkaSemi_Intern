module spi_apb_slv_intf_tb;
    reg pclk, preset, psel, penable, pwrite;
    reg [31:0] paddr, pwdata, sent_data, received_data;
    reg spi_bsy, spi_rx_fifo_full, spi_rx_fifo_empty,spi_tx_fifo_full, spi_tx_fifo_empty;
    reg [31:0] prdata, address;
    
    

    initial begin
        pclk = 0 ; 
        preset = 1; 
        forever begin 
            pclk = ~pclk; 
            #5; 
        end 
    end 

    initial begin 
        @(posedge pclk )
        preset <= 0; 
        @(posedge pclk); 
        preset <= 1; 
        
        repeat(100) begin
        	generate_and_test(); 
        end
        
        #10; 
        $finish; 

    end 
    
    task generate_and_test(); 
    	sent_data = $random; 
        address = 32'b0; 
        write_data(address, sent_data); 
        @(posedge pclk); 
        read_data(address); 
        check_case(sent_data, received_data, {16'b0, sent_data[15:0]}); 

        sent_data = $random; 
        address = 32'h4; 
        write_data(address, sent_data); 
        @(posedge pclk); 
        read_data(address); 
        check_case(sent_data, received_data, {28'b0, sent_data[3:0]}); 

        sent_data = $random; 
        address = 32'h8; 
        write_data(address, sent_data); 
        @(posedge pclk); 
        read_data(address); 
        check_case(sent_data, received_data, {16'b0, sent_data[15:0]}); 
        
        sent_data = $random; 
        address = 32'hc; 
        write_data(address, sent_data); 
        @(posedge pclk); 
        read_data(address); 
        check_case(sent_data, received_data, 5'b10100);  
        
        sent_data = $random; 
        address = 32'h10; 
        write_data(address, sent_data); 
        @(posedge pclk); 
        read_data(address); 
        check_case(sent_data, received_data, {24'b0, sent_data[7:0]}); 
     endtask 


    task write_data(reg [31:0] addr, reg [31:0] data);
        psel<=1;
        pwrite<=1;
        paddr<=addr;
        pwdata<=data;

        @(posedge pclk);
        penable<=1;

        @(posedge pclk)
        penable <= 0; 
        psel <= 0; 
    endtask

    task read_data(reg [31:0] addr);
        psel<=1;
        pwrite<=0;
        paddr<=addr;
         
        @(posedge pclk);
        penable<=1;

        @(posedge pclk);
        penable <= 0; 
        psel <= 0;
    endtask
    
    
    task check_case(logic [31:0]sent_data, logic [31:0] received_data, logic [31:0] expected_data); 
    	if (expected_data == received_data) 
    		$display("[%7t] Data Sent = %8H Data Received = %4H Expected Data = %4H: Passed!!!", $time, sent_data, received_data, expected_data); 
    	else
    		$display("[%7t] Data Sent = %8H Data Received = %4H Expected Data = %4H: Failed!!!", $time, sent_data, received_data, expected_data); 
    endtask
    
  

    spi_apb_slv_intf DUT(
        .pclk(pclk), 
        .preset(preset), 
        .psel(psel), 
        .penable(penable), 
        .pwrite(pwrite), 
        .paddr(paddr), 
        .pwdata(pwdata), 
        .spi_bsy(1'b1), 
        .spi_rx_fifo_full(1'b0), 
        .spi_rx_fifo_empty(1'b1),
        .spi_tx_fifo_full(1'b0), 
        .spi_tx_fifo_empty(1'b0),  

        .prdata(prdata), 
        .pready(pready));

    assign received_data = prdata; 
endmodule 





