///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: poly_mul.v
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

module poly_mul (
    input                        clk, rst,
    input      [2:0]             sel,      // 000: idle, 001: NTT, 010: MULT/ADD, 100: INTT
    input      [7:0]             tf_address,   
    input      [1:0]             ntt_l,
    input      [45:0]            a0, a1,
    input      [45:0]            b0, b1,
    output reg [45:0]            c0, c1,
    output reg [45:0]            d0, d1
);
    
    reg    [22:0]    mr0_dina, mr1_dina, mr2_dina, mr3_dina;
    reg    [22:0]    mr0_dinb, mr1_dinb, mr2_dinb, mr3_dinb;
    reg    [22:0]    ar0_dina, ar1_dina, ar2_dina, ar3_dina;
    reg    [22:0]    ar0_dinb, ar1_dinb, ar2_dinb, ar3_dinb;
    reg    [22:0]    sr0_dina, sr1_dina, sr2_dina, sr3_dina;
    reg    [22:0]    sr0_dinb, sr1_dinb, sr2_dinb, sr3_dinb;
	reg    [22:0]    mh0_dina, mh1_dina, mh2_dina, mh3_dina, mh4_dina, mh5_dina, mh6_dina, mh7_dina;
    reg    [22:0]    t0, t1, t2, t3, t4, t5, t6, t7, t8, t9;
    reg    [22:0]    t10, t11, t12, t13, t14, t15, t16, t17, t18, t19;
    reg    [22:0]    t20, t21, t22, t23, t24, t25, t26, t27;
	reg    [22:0]    w0, w1, w2, w3;
    reg    [22:0]    bf0_a, bf1_a, bf2_a, bf3_a;
    reg    [22:0]    bf0_b, bf1_b, bf2_b, bf3_b;
    
    wire   [22:0]    mr0_dout, mr1_dout, mr2_dout, mr3_dout;
    wire   [22:0]    ar0_dout, ar1_dout, ar2_dout, ar3_dout;
    wire   [22:0]    sr0_dout, sr1_dout, sr2_dout, sr3_dout;
	wire   [22:0]    mh0_dout, mh1_dout, mh2_dout, mh3_dout, mh4_dout, mh5_dout, mh6_dout, mh7_dout;
	wire   [5:0]     tf0_addr;
	wire   [4:0]     tf1_addr, tf2_addr; 
	wire   [22:0]    tf0_q;
	wire   [45:0]    tf1_q;
	wire   [91:0]    tf2_q;
	wire   [1:0]     ntt_ld0, ntt_ld1, ntt_ld;
	
	assign  tf0_addr = tf_address[5:0];
	assign  tf1_addr = tf_address - 63;
	assign  tf2_addr = tf_address - 127;
	
    delay #(.WIDTH(2), .DELAY(1)) delay_0 (
        .clk(clk),
        .din(ntt_l), 
        .dout(ntt_ld0)     
    );
    
    delay #(.WIDTH(2), .DELAY(3)) delay_1 (
        .clk(clk),
        .din(ntt_ld0), 
        .dout(ntt_ld1)     
    );
    
    assign  ntt_ld = (sel[2] & sel[1])? ntt_ld0 : ntt_ld1;
	
	always @(*) begin
	    if (ntt_l == 0) begin
	        { bf0_a, bf1_a }    =    a0;
	        { bf2_a, bf3_a }    =    a1;
	        { bf0_b, bf1_b }    =    b0;
	        { bf2_b, bf3_b }    =    b1;
	        { w0, w1, w2, w3 }  =    { 4{tf0_q} };
	    end
	    else if (ntt_l == 1) begin
	        { bf0_a, bf1_a }    =    a0;
	        { bf0_b, bf1_b }    =    a1;
	        { bf2_a, bf3_a }    =    b0;
	        { bf2_b, bf3_b }    =    b1;
	        { w0, w2 }          =    tf1_q;
	        { w1, w3 }          =    tf1_q;
	    end
	    else if (ntt_l == 2) begin
	        { bf0_a, bf0_b }    =    a0;
	        { bf1_a, bf1_b }    =    a1;
	        { bf2_a, bf2_b }    =    b0;
	        { bf3_a, bf3_b }    =    b1;
	        { w0, w1, w2, w3 }  =    tf2_q;
	    end
	    else begin
	        { bf0_a, bf1_a }    =    0;
	        { bf2_a, bf3_a }    =    0;
	        { bf0_b, bf1_b }    =    0;
	        { bf2_b, bf3_b }    =    0;
	        { w0, w1, w2, w3 }  =    0;
	    end
	end
	
	always @(*) begin
	    if (ntt_ld == 0) begin
	        c0                  =    { t20, t22 };
	        c1                  =    { t24, t26 };
	        d0                  =    { t21, t23 };
	        d1                  =    { t25, t27 };
	    end
	    else if (ntt_ld == 1) begin
	        c0                  =    { t20, t22 };
	        c1                  =    { t21, t23 };
	        d0                  =    { t24, t26 };
	        d1                  =    { t25, t27 };
	    end
	    else if (ntt_ld == 2) begin
	        if (sel[1]) begin
	            if (sel[2]) begin
                    c0                  =    { t20, t21 };
                    c1                  =    { t22, t23 };
                    d0                  =    { t12, t13 };
                    d1                  =    { t14, t15 };
	            end
	            else begin
                    c0                  =    { t24, t25 };
                    c1                  =    { t26, t27 };
                    d0                  =    { t16, t17 };
                    d1                  =    { t18, t19 };
                end
	        end
	        else begin
                c0                  =    { t20, t21 };
                c1                  =    { t22, t23 };
                d0                  =    { t24, t25 };
                d1                  =    { t26, t27 };
            end
	    end
	    else begin
	        c0                  =    0;
	        c1                  =    0;
	        d0                  =    0;
	        d1                  =    0;
	    end
	end
    
    always @(posedge clk) begin
        if (!rst) begin
            t0      <=      0;
            t1      <=      0;
            t2      <=      0;
            t3      <=      0;
            t4      <=      0;
            t5      <=      0;
            t6      <=      0;
            t7      <=      0;
            t8      <=      0;
            t9      <=      0;
            t10     <=      0;
            t11     <=      0;
            t12     <=      0;
            t13     <=      0;
            t14     <=      0;
            t15     <=      0;
            t16     <=      0;
            t17     <=      0;
            t18     <=      0;
            t19     <=      0;
            t20     <=      0;
            t21     <=      0;
            t22     <=      0;
            t23     <=      0;
            t24     <=      0;
            t25     <=      0;
            t26     <=      0;
            t27     <=      0;
        end
        else begin
            if (sel[0]) begin      // 001: NTT
                t0      <=      bf0_a;
                t1      <=      bf1_a;
                t2      <=      bf2_a;
                t3      <=      bf3_a;
                t4      <=      t0;
                t5      <=      t1;
                t6      <=      t2;
                t7      <=      t3;
                t8      <=      t4;
                t9      <=      t5;
                t10     <=      t6;
                t11     <=      t7;
                t12     <=      mr0_dout;
                t13     <=      mr1_dout;
                t14     <=      mr2_dout;
                t15     <=      mr3_dout;
                t20     <=      ar0_dout;
                t21     <=      sr0_dout;
                t22     <=      ar1_dout;
                t23     <=      sr1_dout;
                t24     <=      ar2_dout;
                t25     <=      sr2_dout;
                t26     <=      ar3_dout;
                t27     <=      sr3_dout;
			end
            else if (sel[1]) begin       // 010/110: MULT/ADD
                t12     <=      ar0_dout;
                t13     <=      ar1_dout;
                t14     <=      ar2_dout;
                t15     <=      ar3_dout;
                t16     <=      mr0_dout;
                t17     <=      mr1_dout;
                t18     <=      mr2_dout;
                t19     <=      mr3_dout;
                t20     <=      t12;
                t21     <=      t13;
                t22     <=      t14;
                t23     <=      t15;
                t24     <=      t16;
                t25     <=      t17;
                t26     <=      t18;
                t27     <=      t19;
            end
			else if (sel[2]) begin     // 100: INTT
			    t0      <=      ar0_dout;
			    t1      <=      sr0_dout;
			    t2      <=      ar1_dout;
			    t3      <=      sr1_dout;
			    t4      <=      ar2_dout;
			    t5      <=      sr2_dout;
			    t6      <=      ar3_dout;
			    t7      <=      sr3_dout;
			    t8      <=      mh0_dout;
			    t9      <=      mh1_dout;
			    t10     <=      mh2_dout;
			    t11     <=      mh3_dout;
			    t12     <=      mh4_dout;
			    t13     <=      mh5_dout;
			    t14     <=      mh6_dout;
			    t15     <=      mh7_dout;
			    t16     <=      t12;
			    t17     <=      t13;
			    t18     <=      t14;
			    t19     <=      t15;
			    t20     <=      t16;
			    t21     <=      mr0_dout;
			    t22     <=      t17;
			    t23     <=      mr1_dout;
			    t24     <=      t18;
			    t25     <=      mr2_dout;
			    t26     <=      t19;
			    t27     <=      mr3_dout;
			end
        end
    end
    
    always @(*) begin
        if (sel[0]) begin      // 001: NTT
            mr0_dina    =    bf0_b;
            mr0_dinb    =    w0;
            mr1_dina    =    bf1_b;
            mr1_dinb    =    w1;
            mr2_dina    =    bf2_b;
            mr2_dinb    =    w2;
            mr3_dina    =    bf3_b;
            mr3_dinb    =    w3;
            ar0_dina    =    t8;
            ar0_dinb    =    t12;
            sr0_dina    =    t8;
            sr0_dinb    =    t12;
            ar1_dina    =    t9;
            ar1_dinb    =    t13;
            sr1_dina    =    t9;
            sr1_dinb    =    t13;
            ar2_dina    =    t10;
            ar2_dinb    =    t14;
            sr2_dina    =    t10;
            sr2_dinb    =    t14;
            ar3_dina    =    t11;
            ar3_dinb    =    t15;
            sr3_dina    =    t11;
            sr3_dinb    =    t15;
            mh0_dina    =    0;
            mh1_dina    =    0;
            mh2_dina    =    0;
            mh3_dina    =    0;
            mh4_dina    =    0;
            mh5_dina    =    0;
            mh6_dina    =    0;
            mh7_dina    =    0;
        end
        else if (sel[1]) begin       // 010/110: MULT/ADD
            mr0_dina    =    bf0_a;
            mr0_dinb    =    bf2_a;
            mr1_dina    =    bf0_b;
            mr1_dinb    =    bf2_b;
            mr2_dina    =    bf1_a;
            mr2_dinb    =    bf3_a;
            mr3_dina    =    bf1_b;
            mr3_dinb    =    bf3_b;
            ar0_dina    =    bf0_a;
            ar0_dinb    =    bf2_a;
            sr0_dina    =    0;
            sr0_dinb    =    0;
            ar1_dina    =    bf0_b;
            ar1_dinb    =    bf2_b;
            sr1_dina    =    0;
            sr1_dinb    =    0;
            ar2_dina    =    bf1_a;
            ar2_dinb    =    bf3_a;
            sr2_dina    =    0;
            sr2_dinb    =    0;
            ar3_dina    =    bf1_b;
            ar3_dinb    =    bf3_b;
            sr3_dina    =    0;
            sr3_dinb    =    0;
            mh0_dina    =    0;
            mh1_dina    =    0;
            mh2_dina    =    0;
            mh3_dina    =    0;
            mh4_dina    =    0;
            mh5_dina    =    0;
            mh6_dina    =    0;
            mh7_dina    =    0;        
        end
        else if (sel[2]) begin     // 100: INTT
            ar0_dina    =    bf0_a;
            ar0_dinb    =    bf0_b;
            sr0_dina    =    bf0_b;
            sr0_dinb    =    bf0_a;
            ar1_dina    =    bf1_a;
            ar1_dinb    =    bf1_b;
            sr1_dina    =    bf1_b;
            sr1_dinb    =    bf1_a;
            ar2_dina    =    bf2_a;
            ar2_dinb    =    bf2_b;
            sr2_dina    =    bf2_b;
            sr2_dinb    =    bf2_a;
            ar3_dina    =    bf3_a;
            ar3_dinb    =    bf3_b;
            sr3_dina    =    bf3_b;
            sr3_dinb    =    bf3_a;
            mh0_dina    =    w3;
            mh1_dina    =    w2;
            mh2_dina    =    w1;
            mh3_dina    =    w0;
            mr0_dina    =    t1;
            mr0_dinb    =    t8;
            mr1_dina    =    t3;
            mr1_dinb    =    t9;
            mr2_dina    =    t5;
            mr2_dinb    =    t10;
            mr3_dina    =    t7;
            mr3_dinb    =    t11;
            mh4_dina    =    t0;
            mh5_dina    =    t2;
            mh6_dina    =    t4;
            mh7_dina    =    t6;
        end
        else begin
            mr0_dina    =    0;
            mr0_dinb    =    0;
            mr1_dina    =    0;
            mr1_dinb    =    0;
            mr2_dina    =    0;
            mr2_dinb    =    0;
            mr3_dina    =    0;
            mr3_dinb    =    0;
            ar0_dina    =    0;
            ar0_dinb    =    0;
            sr0_dina    =    0;
            sr0_dinb    =    0;
            ar1_dina    =    0;
            ar1_dinb    =    0;
            sr1_dina    =    0;
            sr1_dinb    =    0;
            ar2_dina    =    0;
            ar2_dinb    =    0;
            sr2_dina    =    0;
            sr2_dinb    =    0;
            ar3_dina    =    0;
            ar3_dinb    =    0;
            sr3_dina    =    0;
            sr3_dinb    =    0;
            mh0_dina    =    0;
            mh1_dina    =    0;
            mh2_dina    =    0;
            mh3_dina    =    0;
            mh4_dina    =    0;
            mh5_dina    =    0;
            mh6_dina    =    0;
            mh7_dina    =    0;
        end
    end
    
    mult_rd mult_rd_0(
        .clk(clk), .rst(rst),
        .dina(mr0_dina), .dinb(mr0_dinb),
        .dout(mr0_dout)
    );
    
    mult_rd mult_rd_1(
        .clk(clk), .rst(rst),
        .dina(mr1_dina), .dinb(mr1_dinb),
        .dout(mr1_dout)
    );
    
    mult_rd mult_rd_2(
        .clk(clk), .rst(rst),
        .dina(mr2_dina), .dinb(mr2_dinb),
        .dout(mr2_dout)
    );
    
    mult_rd mult_rd_3(
        .clk(clk), .rst(rst),
        .dina(mr3_dina), .dinb(mr3_dinb),
        .dout(mr3_dout)
    );
    
    add_rd add_rd_0(
        .dina(ar0_dina), .dinb(ar0_dinb),		
	    .dout(ar0_dout)
    );
    
    add_rd add_rd_1(
        .dina(ar1_dina), .dinb(ar1_dinb),		
	    .dout(ar1_dout)
    );
    
    add_rd add_rd_2(
        .dina(ar2_dina), .dinb(ar2_dinb),		
	    .dout(ar2_dout)
    );
    
    add_rd add_rd_3(
        .dina(ar3_dina), .dinb(ar3_dinb),		
	    .dout(ar3_dout)
    );
    
    sub_rd sub_rd_0(
        .dina(sr0_dina), .dinb(sr0_dinb),		
	    .dout(sr0_dout)
    );
    
    sub_rd sub_rd_1(
        .dina(sr1_dina), .dinb(sr1_dinb),		
	    .dout(sr1_dout)
    );
    
    sub_rd sub_rd_2(
        .dina(sr2_dina), .dinb(sr2_dinb),		
	    .dout(sr2_dout)
    );
    
    sub_rd sub_rd_3(
        .dina(sr3_dina), .dinb(sr3_dinb),		
	    .dout(sr3_dout)
    );
	
	mult_half mult_half_0(.dina(mh0_dina), .dout(mh0_dout));
	
	mult_half mult_half_1(.dina(mh1_dina), .dout(mh1_dout));
	
	mult_half mult_half_2(.dina(mh2_dina), .dout(mh2_dout));
	
	mult_half mult_half_3(.dina(mh3_dina), .dout(mh3_dout));
	
	mult_half mult_half_4(.dina(mh4_dina), .dout(mh4_dout));
	
	mult_half mult_half_5(.dina(mh5_dina), .dout(mh5_dout));
	
	mult_half mult_half_6(.dina(mh6_dina), .dout(mh6_dout));
	
	mult_half mult_half_7(.dina(mh7_dina), .dout(mh7_dout));
	
	tf0_ROM  tf0_ROM_0 (.clk(clk), .A(tf0_addr), .Q(tf0_q));
	
	tf1_ROM  tf1_ROM_0 (.clk(clk), .A(tf1_addr), .Q(tf1_q));
	
	tf2_ROM  tf2_ROM_0 (.clk(clk), .A(tf2_addr), .Q(tf2_q));

endmodule