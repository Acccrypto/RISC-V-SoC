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
`define    Q                8380417

module mult_rd(
    input                   clk,
    input                   rst,
    input         [22:0]    dina,
    input         [22:0]    dinb,
    output        [22:0]    dout
);
    
    wire        [10:0]    ah, bh;
    wire        [11:0]    al, bl;
    wire        [21:0]    ahbh_mult;
    wire        [23:0]    albl_mult;
    wire        [22:0]    ahbl_mult;
    wire        [22:0]    albh_mult;
    wire signed [4:0]     sum1;
    wire signed [23:0]    sum0;
    
    reg           [45:0]    c;
    reg           [23:0]    d;
    reg           [11:0]    x1;
    reg           [24:0]    y1;
    reg           [22:0]    z1;
    reg           [10:0]    x2;
    reg           [13:0]    y2;
    reg           [10:0]    z2;
    reg  signed   [26:0]    rd1;
    reg  signed   [25:0]    rd2;
    reg  signed   [27:0]    sum;
    reg  signed   [24:0]    rd;
    reg  signed   [23:0]    q;
    reg  signed   [23:0]    addq;
    
    assign  { ah, al }  =  dina;
    assign  { bh, bl }  =  dinb;
    assign  ahbh_mult  =  ah * bh;
    assign  albl_mult  =  al * bl; 
    assign  ahbl_mult  =  ah * bl;
    assign  albh_mult  =  al * bh; 
    assign  sum1  =  sum[27:23];
    assign  sum0  =  { 1'b0, sum[22:0] };
    
    always @(posedge clk) begin
        if (!rst) begin 
            c         <=        0;
            d         <=        0;
            sum       <=        0;
        end
        else begin
            c         <=        { ahbh_mult, albl_mult }; 
            d         <=        ahbl_mult + albh_mult;
            sum       <=        rd1 + rd2;    
        end
    end
    
    always @(*) begin
        x1       =        c[45:43] + c[42:33] + c[32:23];
        y1       =        c[45:43] + c[45:33] + c[45:23];
        z1       =        c[22:0];
        rd1      =        (x1 << 13) - y1 + z1;
        x2       =        d[23:21] + d[20:11];
        y2       =        d[23:21] + d[23:11];
        z2       =        d[10:0];
        rd2      =        (x2 << 13) - y2 + (z2 << 12);
        rd       =        (sum1 << 13) - sum1 + sum0;
    end
    
    always @(*) begin
        q           =        (rd[24])? `Q : -`Q;
        addq        =        rd + q;
    end
    
    assign  dout  =  (addq[23])? rd: addq;
    
    /*reg        [45:0]    m, m1, m2;
    reg        [69:0]    t;
    reg        [45:0]    tq;
 
    wire       [10:0]    ah, bh;
    wire       [11:0]    al, bl;
    wire       [21:0]    ahbh_mult;
    wire       [23:0]    albl_mult; 
    wire       [25:0]    add_mult;
    wire       [24:0]    mult_add;
    wire       [23:0]    d;
    wire       [23:0]    th;
    wire       [23:0]    z;
 
    always @(posedge clk) begin
        if (!rst) begin 
            m         <=        0;
            m1        <=        0;
            m2        <=        0;
            t         <=        0;
        end
        else begin
            m         <=        { ahbh_mult, albl_mult } + (d << 12);
            m1        <=        m;
            m2        <=        m1;
            t         <=        (m << 23) + (m << 13) + (m << 3) - m;
        end
    end
    
    assign  { ah, al }  =  dina;
    assign  { bh, bl }  =  dinb;
    assign  ahbh_mult  =  ah * bh;
    assign  albl_mult  =  al * bl; 
    assign  add_mult   =  (ah + al) * (bh + bl);
    assign  mult_add   =  ahbh_mult + albl_mult;
    assign  d  =  add_mult - mult_add;
    assign  th  =  t >> 46;
    assign  tq  =  (th << 23) - (th << 13) + th;
    assign  z   =  m2 - tq;
    assign  dout  =  (z >= `Q)? z - `Q : z;*/
 
endmodule

module mult_half(
    input         [22:0]    dina,
    output        [22:0]    dout
);

    wire    [21:0]    dina_h;
	
	assign  dina_h = dina[22:1];
	assign  dout = (dina[0])? dina_h + (`Q + 1) / 2 : dina_h;

endmodule

module add_rd(
    input   [22:0]     dina,
	input	[22:0]	   dinb,		
	output	[22:0]     dout
    );
    
    reg        [23:0]      sum0;
    reg signed [23:0]      sum1;
    
    always @(*) begin
        sum0    =    dina + dinb;
        sum1    =    sum0 - `Q;
    end
    
    assign  dout  =  (sum1[23])? sum0 : sum1;

endmodule

module sub_rd(
    input   [22:0]     dina,
	input	[22:0]	   dinb,		
	output	[22:0]     dout
    );
    
    reg signed   [23:0]      sub0;
    reg          [23:0]      sub1;
    
    always @(*) begin
        sub0    =    dina  - dinb;
        sub1    =    sub0 + `Q;
    end
    
    assign  dout  =  (sub0[23])? sub1 : sub0;
    
endmodule

