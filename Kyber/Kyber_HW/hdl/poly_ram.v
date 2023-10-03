///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: poly_ram.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::PolarFireSoC> <Die::MPFS250T_ES> <Package::FCVG484>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>

module poly_ram
    #(parameter addr_width = 5, depth = 32, data_width = 24)(
    input                          clk,
    input                          rst,
    input    [2:0]                 sel,  // 000: pwrite, 010/110: PWM/PWA, 001/100: NTT/INTT
    input                          wen,
    input    [1:0]                 bank0_index, bank1_index, bank2_index, bank3_index,
    input    [addr_width-1 : 0]    addr0, addr1, addr2, addr3,
    input    [data_width-1 : 0]    din0, din1, din2, din3,
    output   [data_width-1 : 0]    dout0, dout1, dout2, dout3
    );
    
    reg   [2:0]             sel_reg;
    
    //arbiter port signal
    wire  [1:0]             sel_a_0, sel_a_1, sel_a_2, sel_a_3;
    wire  [addr_width-1:0]  bank0_addr, bank1_addr, bank2_addr, bank3_addr;
    wire  [addr_width-1:0]  bank0_addr_reg1, bank1_addr_reg1, bank2_addr_reg1, bank3_addr_reg1;
    wire  [addr_width-1:0]  bank0_addr_reg2, bank1_addr_reg2, bank2_addr_reg2, bank3_addr_reg2;
    wire  [addr_width-1:0]  bank0_waddr, bank1_waddr, bank2_waddr, bank3_waddr;
    //data from banks
    wire  [data_width-1:0]  q0, q1, q2, q3;
    //data into banks
    wire  [data_width-1:0]  d0, d1, d2, d3;
    
    always @(posedge clk) begin
        if (!rst)
            sel_reg    <=    0;
        else
            sel_reg    <=    sel;
    end
    
    assign  {bank0_waddr, bank1_waddr, bank2_waddr, bank3_waddr} = (sel_reg == 3'b010)? { bank0_addr_reg2, bank1_addr_reg2, bank2_addr_reg2, bank3_addr_reg2 } :
            (sel_reg != 0)? { bank0_addr_reg1, bank1_addr_reg1, bank2_addr_reg1, bank3_addr_reg1 } : { bank0_addr, bank1_addr, bank2_addr, bank3_addr };
    
    arbiter arbiter_0 (
        .a0(bank0_index), .a1(bank1_index),
        .a2(bank2_index), .a3(bank3_index),
        .sel_a_0(sel_a_0), .sel_a_1(sel_a_1),
        .sel_a_2(sel_a_2), .sel_a_3(sel_a_3)
    ); 
    
    network_bank_in #(.addr_width(addr_width)) mux1 (
        .b0(addr0), .b1(addr1),
        .b2(addr2), .b3(addr3),
        .sel_a_0(sel_a_0), .sel_a_1(sel_a_1),
        .sel_a_2(sel_a_2), .sel_a_3(sel_a_3),
        .new_address_0(bank0_addr), .new_address_1(bank1_addr),
        .new_address_2(bank2_addr), .new_address_3(bank3_addr)
    ); 
    
    delay #(.WIDTH({ addr_width, 2'b00 }), .DELAY(7)) delay_0 (
        .clk(clk),
        .din({ bank0_addr, bank1_addr, bank2_addr, bank3_addr }), 
        .dout({ bank0_addr_reg1, bank1_addr_reg1, bank2_addr_reg1, bank3_addr_reg1 })     
    );
    
    delay #(.WIDTH({ addr_width, 2'b00 }), .DELAY(3)) delay_2 (
        .clk(clk),
        .din({ bank0_addr_reg1, bank1_addr_reg1, bank2_addr_reg1, bank3_addr_reg1 }), 
        .dout({ bank0_addr_reg2, bank1_addr_reg2, bank2_addr_reg2, bank3_addr_reg2 })     
    );
    
    poly_bank #(.addr_width(addr_width), .depth(depth), .data_width(data_width)) poly_bank_0 (
        .clk(clk), .wen(wen),
        .raddr(bank0_addr), .waddr(bank0_waddr),
        .din(d0), .dout(q0)
    );
    
    poly_bank #(.addr_width(addr_width), .depth(depth), .data_width(data_width)) poly_bank_1 (
        .clk(clk), .wen(wen),
        .raddr(bank1_addr), .waddr(bank1_waddr),
        .din(d1), .dout(q1)
    );
    
    poly_bank #(.addr_width(addr_width), .depth(depth), .data_width(data_width)) poly_bank_2 (
        .clk(clk), .wen(wen),
        .raddr(bank2_addr), .waddr(bank2_waddr),
        .din(d2), .dout(q2)
    );
    
    poly_bank #(.addr_width(addr_width), .depth(depth), .data_width(data_width)) poly_bank_3 (
        .clk(clk), .wen(wen),
        .raddr(bank3_addr), .waddr(bank3_waddr),
        .din(d3), .dout(q3)
    );
    
    network_bf_in #(.data_width(data_width)) mux2(
        .clk(clk), .rst(rst),
        .sel_a_0(sel_a_0), .sel_a_1(sel_a_1),
        .sel_a_2(sel_a_2), .sel_a_3(sel_a_3),
        .q0(q0), .q1(q1), .q2(q2), .q3(q3),
        .u0(dout0), .v0(dout1), .u1(dout2), .v1(dout3)
    ); 
    
    network_bf_out #(.data_width(data_width)) mux3(
        .clk(clk), .sel(sel_reg),
        .bf_0_upper(din1), .bf_0_lower(din0),
        .bf_1_upper(din3), .bf_1_lower(din2),
        .sel_a_0(sel_a_0), .sel_a_1(sel_a_1),
        .sel_a_2(sel_a_2), .sel_a_3(sel_a_3),
        .d0(d0), .d1(d1), .d2(d2), .d3(d3)
    );  

endmodule

