///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: poly_bank.v
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

module poly_bank 
    #(parameter addr_width = 5, depth = 32, data_width = 24)(
    input                          clk,
    input                          wen,
    input  [addr_width-1 : 0]      raddr,
    input  [addr_width-1 : 0]      waddr,
    input  [data_width-1 : 0]      din,
    output [data_width-1 : 0]      dout
    );
    
    reg  [addr_width-1 : 0]  raddr_reg;
    reg  [data_width-1 : 0]  bank  [depth-1 : 0];
    
    assign dout  =  bank[raddr_reg];
    
    always @(posedge clk) begin
        if (wen == 1'b1) 
            bank[waddr]    <=    din;
        raddr_reg      <=      raddr;
    end

endmodule

