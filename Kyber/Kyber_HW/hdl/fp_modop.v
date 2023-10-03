///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: fp_modop.v
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
`define  Q      3329
`define  QINV   769

module mult_rd
    #(parameter data_width = 12) (
    input                       clk,
    input                       rst,
    input   [data_width-1:0]    dina,
    input   [data_width-1:0]    dinb,
    output  [data_width-1:0]    dout
);
    
  reg  [data_width*2-1:0]  m;
  reg  [data_width*2-1:0]  tq;
  reg  [data_width*2-1:0]  m1;
  
  wire [data_width-1:0]         t;
  wire signed [data_width*2:0]  z;
  wire signed [data_width:0]    zh;
  
  wire  [3:0]    th;
  wire  [15:0]   tqh;

  always @(posedge clk) begin
      if (!rst) begin
          m    <=    0;
          tq   <=    0;
          m1   <=    0;
      end
      else begin
          m    <=    dina * dinb;
          // tq  <=  t * `Q;
          // tq   <=    (t << 11) + (t << 10) + (t << 8) + t;
          tq   <=    { tqh, t[7:0] };
          m1   <=    m;
      end
  end
  
  //assign  t  =  m * `QINV;
  //assign  t  =  (m << 9) + (m << 8) + m;
  assign  th  =  { m[2:0], 1'b0 } + m[3:0] + m[11:8];
  assign  t  =  { th, m[7:0] };
  assign  tqh  =  { t[11:0], 3'b0 } + { t[11:0], 2'b0 } + t + t[11:8];
  assign  z  =  m1 - tq;
  assign  zh  =  z[data_width*2:data_width];
  assign  dout  =  (zh[data_width])? zh + `Q : zh;
    
endmodule

module mult_half
    #(parameter data_width = 12) (
    input     [data_width-1:0]    dina,
    output    [data_width-1:0]    dout
);

    wire    [data_width-2:0]    dina_h;
	
	assign  dina_h = dina[data_width-1:1];
	assign  dout = (dina[0])? dina_h + (`Q + 1) / 2 : dina_h;

endmodule

module add_rd
    #(parameter data_width = 12) (
    input   [data_width-1:0]     dina,
	input	[data_width-1:0]	 dinb,		
	output	[data_width-1:0]     dout
);
    
    reg        [data_width:0]      sum0;
    reg signed [data_width:0]      sum1;
    
    always @(*) begin
        sum0    =    dina + dinb;
        sum1    =    sum0 - `Q;
    end
    
    assign  dout  =  (sum1[data_width])? sum0 : sum1;

endmodule

module sub_rd
    #(parameter data_width = 12) (
    input   [data_width-1:0]     dina,
	input	[data_width-1:0]	 dinb,		
	output	[data_width-1:0]     dout
    );
    
    reg signed   [data_width:0]      sub0;
    reg          [data_width:0]      sub1;
    
    always @(*) begin
        sub0    =    dina  - dinb;
        sub1    =    sub0 + `Q;
    end
    
    assign  dout  =  (sub0[data_width])? sub1 : sub0;
    
endmodule

