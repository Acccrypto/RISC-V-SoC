///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: corereset_pf.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::PolarFire> <Die::MPF300T_ES> <Package::FCG1152>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>

module CORERESET_CORERESET_0_CORERESET_PF(CLK, EXT_RST_N, BANK_x_VDDI_STATUS,BANK_y_VDDI_STATUS,PLL_LOCK,SS_BUSY, INIT_DONE, FF_US_RESTORE,FPGA_POR_N, PLL_POWERDOWN_B, FABRIC_RESET_N);
input  CLK,EXT_RST_N, BANK_x_VDDI_STATUS, PLL_LOCK, SS_BUSY, INIT_DONE, FF_US_RESTORE, BANK_y_VDDI_STATUS, FPGA_POR_N;
output PLL_POWERDOWN_B, FABRIC_RESET_N;

wire A;
wire B;
wire C;
wire D;

wire INTERNAL_RST;

reg dff_0 = 1'b1;
reg dff_1 = 1'b1;
reg dff_2 = 1'b1;
reg dff_3 = 1'b1;
reg dff_4 = 1'b1;
reg dff_5 = 1'b1;
reg dff_6 = 1'b1;
reg dff_7 = 1'b1;
reg dff_8 = 1'b1;
reg dff_9 = 1'b1;
reg dff_10 = 1'b1;
reg dff_11 = 1'b1;
reg dff_12 = 1'b1;
reg dff_13 = 1'b1;
reg dff_14 = 1'b1;
reg dff_15 = 1'b1;


assign A = !(!EXT_RST_N  | !BANK_x_VDDI_STATUS);
assign B = !(!A | !PLL_LOCK);
assign C = !(!B & !SS_BUSY);
assign D = !(!C | !INIT_DONE);
assign INTERNAL_RST = !(!D & !FF_US_RESTORE);
assign PLL_POWERDOWN_B = !(!BANK_y_VDDI_STATUS | !FPGA_POR_N);


always@(posedge CLK or negedge INTERNAL_RST)
begin
   if (!INTERNAL_RST)
      begin
         dff_0 <= 1'b0;
         dff_1 <= 1'b0;
         dff_2 <= 1'b0;
         dff_3 <= 1'b0;
         dff_3 <= 1'b0;
         dff_4 <= 1'b0;
         dff_5 <= 1'b0;
         dff_6 <= 1'b0;
         dff_7 <= 1'b0;
         dff_8 <= 1'b0;
         dff_9 <= 1'b0;
         dff_10 <= 1'b0;
         dff_11 <= 1'b0;
         dff_12 <= 1'b0;
         dff_13 <= 1'b0;
         dff_14 <= 1'b0;
         dff_15 <= 1'b0;
      end
   else
      begin
         dff_0 <= 1'b1;
         dff_1 <= dff_0;
         dff_2 <= dff_1;
         dff_3 <= dff_2;
         dff_4 <= dff_3;
         dff_5 <= dff_4;
         dff_6 <= dff_5;
         dff_7 <= dff_6;
         dff_8 <= dff_7;
         dff_9 <= dff_8;
         dff_10 <= dff_9;
         dff_11 <= dff_10;
         dff_12 <= dff_11;
         dff_13 <= dff_12;
         dff_14 <= dff_13;
         dff_15 <= dff_14;
        end
end

assign FABRIC_RESET_N = !(!dff_15 & !FF_US_RESTORE);

endmodule