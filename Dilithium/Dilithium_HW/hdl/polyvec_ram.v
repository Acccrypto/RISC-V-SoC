///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: polyvec_ram.v
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

module polyvec_ram
    #(parameter addr_width = 8, depth = 256, data_width = 23)(
    input                          clk,
    input                          wen,
    input  [addr_width-1 : 0]      raddr,
    input  [addr_width-1 : 0]      waddr,
    input  [data_width-1 : 0]      din0, din1, din2, din3,
    output [data_width-1 : 0]      dout0, dout1, dout2, dout3
);

    reg  [data_width-1 : 0]  bank0  [depth-1 : 0];
    reg  [data_width-1 : 0]  bank1  [depth-1 : 0];
    reg  [data_width-1 : 0]  bank2  [depth-1 : 0];
    reg  [data_width-1 : 0]  bank3  [depth-1 : 0];
    
    integer j;
    initial begin
        for (j = 0; j < depth; j = j + 1) begin
            bank0[j]   =   0;
            bank1[j]   =   0;
            bank2[j]   =   0;
            bank3[j]   =   0;
        end
    end

    always @(posedge clk) begin
        if (wen) begin
            bank0[waddr]    <=    din0;
            bank1[waddr]    <=    din1;
            bank2[waddr]    <=    din2;
            bank3[waddr]    <=    din3;
        end
    end
    
    assign  dout0 = bank0[raddr];
    assign  dout1 = bank1[raddr];
    assign  dout2 = bank2[raddr];
    assign  dout3 = bank3[raddr];

endmodule

