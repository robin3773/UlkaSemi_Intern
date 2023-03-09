module telephone_top_tb;
    reg pclk, presetn, psel, penable, pwrite;
    reg [31:0] paddr, pwdata;

    reg pickup_call; 
    reg [31:0] sent_data, received_data;
    reg [31:0] prdata, address;
    reg pready; 
    
    
    initial begin
        pclk = 0 ; 
        presetn = 0; 
        pickup_call = 0; 
        forever begin 
            pclk = ~pclk; 
            #5; 
        end 
    end 

    initial begin 
        @(posedge pclk );
        presetn <= 1;
        
        $display("[%0t] --------------------Checking Invalid Contact Number Case---------------------", $time); 
        write_data(32'h8, 32'b0); 
        write_data(32'h0, {$random, 3'b001}); 
        generate_delay(80);
        reset_phone(); 
       	
       	generate_delay(20);
        $display("[%0t] --------------------Checking Dial Timeout Case-----------------------------", $time); 
        write_data(32'h8, $random); 
        write_data(32'h0, {$random, 3'b001}); 
        generate_delay(80);
        pickup_call <= 1; 
        generate_delay(30); 
       	write_data(32'h0, {$random, 3'b011});
       	pickup_call = 0; 
        reset_phone(); 
       	
       	generate_delay(20);
       	$display("[%0t] --------------------Checking Endcall Case-----------------------------", $time); 
        write_data(32'h8, $random); 
        write_data(32'h0, {$random, 3'b001}); 
        generate_delay(30);
        pickup_call <= 1; 
        generate_delay(30); 
       	write_data(32'h0, {$random, 3'b101});
       	generate_delay(20); 
       	pickup_call = 0; 
        reset_phone(); 

       	generate_delay(20);
       	$display("[%0t] --------------------Checking Call Timeout Case-----------------------------", $time); 
        write_data(32'h8, $random); 
        write_data(32'h0, {$random, 3'b001}); 
        generate_delay(30);
        pickup_call <= 1; 
        generate_delay(40); 
       	write_data(32'h0, {$random, 3'b011});
       	pickup_call = 0; 
       	
       	
        
        #3300; 
        $finish; 

    end 
    

    task generate_delay(int i);
        repeat(i/10)
            @(posedge pclk);
    endtask 
    
    task reset_phone(); 
    	presetn <= 0; 
    	@(posedge pclk); 
    	presetn <= 1; 
    	@(posedge pclk); 
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
        @(posedge pclk); 
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
        @(posedge pclk); 
    endtask
    
    
    task check_case(logic [31:0]sent_data, logic [31:0] received_data, logic [31:0] expected_data); 
    	if (expected_data == received_data) 
    		$display("[%7t] Data Sent = %8H Data Received = %4H Expected Data = %4H: Passed!!!", $time, sent_data, received_data, expected_data); 
    	else
    		$display("[%7t] Data Sent = %8H Data Received = %4H Expected Data = %4H: Failed!!!", $time, sent_data, received_data, expected_data); 
    endtask
    
  

    telephone_top DUT(
        .pclk(pclk), 
        .presetn(presetn), 
        .psel(psel), 
        .penable(penable), 
        .pwrite(pwrite), 
        .paddr(paddr), 
        .pwdata(pwdata), 
        .pickup_call(pickup_call), 

        .prdata(prdata), 
        .pready(pready),
        .dial_tone(dial_tone), 
        .dial_timeout(dial_timeout), 
        .in_call(in_call), 
        .call_ended(call_ended), 
        .call_timeout(call_timeout)
        );

    assign received_data = prdata; 
endmodule 
