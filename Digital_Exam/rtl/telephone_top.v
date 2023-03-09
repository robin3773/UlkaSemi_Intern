module telephone_top #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32)(
    input pclk, presetn, 
    input psel, penable, pwrite, 
    input [ADDR_WIDTH-1:0] paddr, 
    input [DATA_WIDTH-1:0] pwdata, 
    input pickup_call, 

    output pready, 
    output [DATA_WIDTH-1:0] prdata
); 


    wire [2:0]dial_count; 
    wire dial_counter_clear, dial_counter_increament; 
    wire [7:0] call_duration_count; 
    wire call_counter_clear, call_counter_increament; 

    wire dial_count_5; 
    wire call_duration_count_250; 
    wire wr_en, rd_en; 
    wire [DATA_WIDTH-1:0] wr_data;
    reg [DATA_WIDTH-1:0] rd_data; 
    wire [ADDR_WIDTH-1:0] addr; 
    wire [DATA_WIDTH-1:0] cr_d, cr_q, stat_d, stat_q, cntct_d, cntct_q, cdr_d, cdr_q; 
    wire cr_wr_en, cntct_wr_en; 
    wire dial_timeout, in_call, call_timeout; 

    assign cr_wr_en = wr_en & (addr == 32'h0) ; 
    assign cr_d = cr_wr_en ? {29'b0, wr_data[2:0]} : cr_q; 

    assign cntct_wr_en = wr_en & (addr == 32'h08) ; 
    assign cntct_d = cntct_wr_en ? {21'b0, wr_data[10:0]} : cntct_q; 
    assign cdr_d = call_duration_count; 
    assign stat_d = {stat_q[31:3], dial_timeout, in_call, call_timeout};
    

    always @(*) begin
        case(addr)
            32'h0   : rd_data = rd_en ? cr_q : 32'b0; 
            32'h4   : rd_data = rd_en ? stat_q: 32'b0;
            32'h8   : rd_data = rd_en ? cntct_q : 32'b0; 
            32'hC   : rd_data = rd_en ? cdr_q: 32'b0;
        endcase 
    end 



    apb_slave u_apb_slave(
        .pclk(pclk), 
        .presetn(presetn), 
        .psel(psel), 
        .penable(penable), 
        .pwrite(pwrite), 
        .paddr(paddr),
        .pwdata(pwdata), 
        .rd_data(rd_data), 
        .prdata(prdata), 
        .wr_en(wr_en), 
        .rd_en(rd_en), 
        .wr_data(wr_data), 
        .addr(addr)
    ); 


    tele_fsm u_tele_fsm(
        .clk(pclk), 
        .reset_n(presetn), 
        .pickup_call(pickup_call), 
        .dial(cr_q[0]),
        .cancel(cr_q[1]),
        .end_call(cr_q[2]),
        .valid_cntct(~valid_cntct),
        .dial_count_5(dial_count_5), 
        .call_duration_count_250(call_duration_count_250), 

        .dial_counter_clear(dial_counter_clear), 
        .dial_counter_increament(dial_counter_increament), 
        .call_counter_clear(call_counter_clear), 
        .call_counter_increament(call_counter_increament),
        .call_timeout(call_timeout),
        .in_call(in_call),
        .dial_timeout(dial_timeout)
    ); 


    counter #(3) u_dial_counter(
        .clk(pclk), 
        .reset_n(presetn), 
        .clear(dial_counter_clear), 
        .increament(dial_counter_increament), 
        .count(dial_count)

    ); 

    counter #(8) u_call_duration_counter(
        .clk(pclk), 
        .reset_n(presetn), 
        .clear(call_counter_clear), 
        .increament(call_counter_increament), 
        .count(call_duration_count)
    ); 

    comparator #(3) u_dial_comp_5(
        .value1(dial_count),
        .value2(3'b101),
        .is_equal(dial_count_5)
    );

    comparator #(8) u_dial_comp_250(
        .value1(call_duration_count),
        .value2(8'b11111010),
        .is_equal(call_duration_count_250)
    );

    comparator #(11) u_valid_check_comp(
        .value1(cntct_q[10:0]), 
        .value2(11'b0), 
        .is_equal(valid_cntct)
    );

    dff #(32) cr(
        .clk(pclk), 
        .reset_n(presetn), 
        .D(cr_d), 
        .Q(cr_q)
    ); 

    dff #(32) stat(
        .clk(pclk), 
        .reset_n(presetn), 
        .D(stat_d), 
        .Q(stat_q)
    ); 

    dff #(32) cntct(
        .clk(pclk), 
        .reset_n(presetn), 
        .D(cntct_d), 
        .Q(cntct_q)
    ); 

    dff #(32) cdr(
        .clk(pclk), 
        .reset_n(presetn), 
        .D(cdr_d), 
        .Q(cdr_q)
    ); 


endmodule 
