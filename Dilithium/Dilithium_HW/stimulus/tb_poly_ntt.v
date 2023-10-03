//////////////////////////////////////////////////////////////////////
// Created by Microsemi SmartDesign Sat Mar  4 14:25:05 2023
// Testbench Template
// This is a basic testbench that instantiates your design with basic 
// clock and reset pins connected.  If your design has special
// clock/reset or testbench driver requirements then you should 
// copy this file and modify it. 
//////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: tb_poly_ntt.v
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

`timescale 1ns/100ps

module tb_poly_ntt;

parameter SYSCLK_PERIOD = 10;// 100MHZ

reg SYSCLK;
reg NSYSRESET;

reg           penable;
reg           psel;
reg  [15:0]   paddr;
reg           pwrite;
reg  [31:0]   pwdata;

wire [31:0]   prdata;
wire          pready;
wire          pslverr;
wire          poly_ntt_irq;    

initial
begin
    SYSCLK = 1'b0;
    NSYSRESET = 1'b0;
end

//////////////////////////////////////////////////////////////////////
// Reset Pulse
//////////////////////////////////////////////////////////////////////
initial
begin
    #(SYSCLK_PERIOD * 10 )
        NSYSRESET = 1'b1;
end


//////////////////////////////////////////////////////////////////////
// Clock Driver
//////////////////////////////////////////////////////////////////////
always @(SYSCLK)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;


//////////////////////////////////////////////////////////////////////
// Testbench
//////////////////////////////////////////////////////////////////////
initial begin 
    $readmemb("F:/RISC-V/Reference Code/icicle-kit-reference-design-master/MPFS_ICICLE/stimulus/model/bank0.txt",tb_poly_ntt.poly_ntt_0.poly_ram_0.poly_bank_0.bank);
    $readmemb("F:/RISC-V/Reference Code/icicle-kit-reference-design-master/MPFS_ICICLE/stimulus/model/bank1.txt",tb_poly_ntt.poly_ntt_0.poly_ram_0.poly_bank_1.bank);
    $readmemb("F:/RISC-V/Reference Code/icicle-kit-reference-design-master/MPFS_ICICLE/stimulus/model/bank2.txt",tb_poly_ntt.poly_ntt_0.poly_ram_0.poly_bank_2.bank);
    $readmemb("F:/RISC-V/Reference Code/icicle-kit-reference-design-master/MPFS_ICICLE/stimulus/model/bank3.txt",tb_poly_ntt.poly_ntt_0.poly_ram_0.poly_bank_3.bank);
end

initial begin
    penable    =    1'b0;
    psel       =    1'b0;
    paddr      =    0;
    pwrite     =    1'b0;
    pwdata     =    0;
    #200;
    penable    =    1'b1;
    psel       =    1'b1;
    pwrite     =    1'b1;
    paddr      =    16'hfffc;
    pwdata     =    32'h00000002;
    #10;
    pwrite     =    1'b0;
    #10;
    while (!poly_ntt_irq) #10;
    $finish;
end
    

//////////////////////////////////////////////////////////////////////
// Instantiate Unit Under Test:  poly_ntt
//////////////////////////////////////////////////////////////////////
poly_ntt poly_ntt_0 (
    // Inputs
    .pclk(SYSCLK),
    .presetn(NSYSRESET),
    .penable(penable),
    .psel(psel),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),

    // Outputs
    .prdata(prdata),
    .pready(pready),
    .pslverr(pslverr),
    .poly_ntt_irq(poly_ntt_irq)

    // Inouts

);

endmodule

