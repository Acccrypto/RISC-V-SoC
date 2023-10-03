//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec 12 18:37:40 2022
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// IHC_SUBSYSTEM
module IHC_SUBSYSTEM(
    // Inputs
    PADDR,
    PENABLE,
    PSEL,
    PWDATA,
    PWRITE,
    pclk,
    presetn,
    // Outputs
    E51_IRQ,
    PRDATA,
    PREADY,
    PSLVERR,
    U54_1_IRQ,
    U54_2_IRQ,
    U54_3_IRQ,
    U54_4_IRQ
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [31:0] PADDR;
input         PENABLE;
input         PSEL;
input  [31:0] PWDATA;
input         PWRITE;
input         pclk;
input         presetn;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        E51_IRQ;
output [31:0] PRDATA;
output        PREADY;
output        PSLVERR;
output        U54_1_IRQ;
output        U54_2_IRQ;
output        U54_3_IRQ;
output        U54_4_IRQ;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [31:0] PADDR;
wire          PENABLE;
wire   [31:0] APB3mmaster_PRDATA;
wire          APB3mmaster_PREADY;
wire          PSEL;
wire          APB3mmaster_PSLVERR;
wire   [31:0] PWDATA;
wire          PWRITE;
wire   [31:0] APB_ARBITER_0_APB_MASTER_high_PADDR;
wire          APB_ARBITER_0_APB_MASTER_high_PENABLE;
wire   [31:0] APB_ARBITER_0_APB_MASTER_high_PRDATA;
wire          APB_ARBITER_0_APB_MASTER_high_PREADY;
wire          APB_ARBITER_0_APB_MASTER_high_PSELx;
wire          APB_ARBITER_0_APB_MASTER_high_PSLVERR;
wire   [31:0] APB_ARBITER_0_APB_MASTER_high_PWDATA;
wire          APB_ARBITER_0_APB_MASTER_high_PWRITE;
wire   [31:0] APB_ARBITER_0_APB_MASTER_low_PADDR;
wire          APB_ARBITER_0_APB_MASTER_low_PENABLE;
wire   [31:0] APB_ARBITER_0_APB_MASTER_low_PRDATA;
wire          APB_ARBITER_0_APB_MASTER_low_PREADY;
wire          APB_ARBITER_0_APB_MASTER_low_PSELx;
wire          APB_ARBITER_0_APB_MASTER_low_PSLVERR;
wire   [31:0] APB_ARBITER_0_APB_MASTER_low_PWDATA;
wire          APB_ARBITER_0_APB_MASTER_low_PWRITE;
wire          CHANNEL_E51_TO_U54_1_SIDE_A_ACK_FROM_B;
wire          CHANNEL_E51_TO_U54_1_SIDE_A_MSG_PRESENT;
wire          CHANNEL_E51_TO_U54_1_SIDE_B_ACK_FROM_A;
wire          CHANNEL_E51_TO_U54_1_SIDE_B_MSG_PRESENT;
wire          CHANNEL_E51_TO_U54_2_SIDE_A_ACK_FROM_B;
wire          CHANNEL_E51_TO_U54_2_SIDE_A_MSG_PRESENT;
wire          CHANNEL_E51_TO_U54_2_SIDE_B_ACK_FROM_A;
wire          CHANNEL_E51_TO_U54_2_SIDE_B_MSG_PRESENT;
wire          CHANNEL_E51_TO_U54_3_SIDE_A_ACK_FROM_B;
wire          CHANNEL_E51_TO_U54_3_SIDE_A_MSG_PRESENT;
wire          CHANNEL_E51_TO_U54_3_SIDE_B_ACK_FROM_A;
wire          CHANNEL_E51_TO_U54_3_SIDE_B_MSG_PRESENT;
wire          CHANNEL_E51_TO_U54_4_SIDE_A_ACK_FROM_B;
wire          CHANNEL_E51_TO_U54_4_SIDE_A_MSG_PRESENT;
wire          CHANNEL_E51_TO_U54_4_SIDE_B_ACK_FROM_A;
wire          CHANNEL_E51_TO_U54_4_SIDE_B_MSG_PRESENT;
wire          CHANNEL_U54_1_TO_U54_2_SIDE_A_ACK_FROM_B;
wire          CHANNEL_U54_1_TO_U54_2_SIDE_A_MSG_PRESENT;
wire          CHANNEL_U54_1_TO_U54_2_SIDE_B_ACK_FROM_A;
wire          CHANNEL_U54_1_TO_U54_2_SIDE_B_MSG_PRESENT;
wire          CHANNEL_U54_1_TO_U54_3_SIDE_A_ACK_FROM_B;
wire          CHANNEL_U54_1_TO_U54_3_SIDE_A_MSG_PRESENT;
wire          CHANNEL_U54_1_TO_U54_3_SIDE_B_ACK_FROM_A;
wire          CHANNEL_U54_1_TO_U54_3_SIDE_B_MSG_PRESENT;
wire          CHANNEL_U54_1_TO_U54_4_SIDE_A_ACK_FROM_B;
wire          CHANNEL_U54_1_TO_U54_4_SIDE_A_MSG_PRESENT;
wire          CHANNEL_U54_1_TO_U54_4_SIDE_B_ACK_FROM_A;
wire          CHANNEL_U54_1_TO_U54_4_SIDE_B_MSG_PRESENT;
wire          CHANNEL_U54_2_TO_U54_3_SIDE_A_ACK_FROM_B;
wire          CHANNEL_U54_2_TO_U54_3_SIDE_A_MSG_PRESENT;
wire          CHANNEL_U54_2_TO_U54_3_SIDE_B_ACK_FROM_A;
wire          CHANNEL_U54_2_TO_U54_3_SIDE_B_MSG_PRESENT;
wire          CHANNEL_U54_2_TO_U54_4_SIDE_A_ACK_FROM_B;
wire          CHANNEL_U54_2_TO_U54_4_SIDE_A_MSG_PRESENT;
wire          CHANNEL_U54_2_TO_U54_4_SIDE_B_ACK_FROM_A;
wire          CHANNEL_U54_2_TO_U54_4_SIDE_B_MSG_PRESENT;
wire          CHANNEL_U54_3_TO_U54_4_SIDE_A_ACK_FROM_B;
wire          CHANNEL_U54_3_TO_U54_4_SIDE_A_MSG_PRESENT;
wire          CHANNEL_U54_3_TO_U54_4_SIDE_B_ACK_FROM_A;
wire          CHANNEL_U54_3_TO_U54_4_SIDE_B_MSG_PRESENT;
wire          E51_IRQ_net_0;
wire          IHC_APB_0_APBmslave0_PENABLE;
wire   [31:0] IHC_APB_0_APBmslave0_PRDATA;
wire          IHC_APB_0_APBmslave0_PREADY;
wire          IHC_APB_0_APBmslave0_PSELx;
wire          IHC_APB_0_APBmslave0_PSLVERR;
wire          IHC_APB_0_APBmslave0_PWRITE;
wire   [31:0] IHC_APB_0_APBmslave1_PRDATA;
wire          IHC_APB_0_APBmslave1_PREADY;
wire          IHC_APB_0_APBmslave1_PSELx;
wire          IHC_APB_0_APBmslave1_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave2_PRDATA;
wire          IHC_APB_0_APBmslave2_PREADY;
wire          IHC_APB_0_APBmslave2_PSELx;
wire          IHC_APB_0_APBmslave2_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave3_PRDATA;
wire          IHC_APB_0_APBmslave3_PREADY;
wire          IHC_APB_0_APBmslave3_PSELx;
wire          IHC_APB_0_APBmslave3_PSLVERR;
wire          IHC_APB_0_APBmslave4_PREADY;
wire          IHC_APB_0_APBmslave4_PSELx;
wire          IHC_APB_0_APBmslave4_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave5_PRDATA;
wire          IHC_APB_0_APBmslave5_PREADY;
wire          IHC_APB_0_APBmslave5_PSELx;
wire          IHC_APB_0_APBmslave5_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave6_PRDATA;
wire          IHC_APB_0_APBmslave6_PREADY;
wire          IHC_APB_0_APBmslave6_PSELx;
wire          IHC_APB_0_APBmslave6_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave7_PRDATA;
wire          IHC_APB_0_APBmslave7_PREADY;
wire          IHC_APB_0_APBmslave7_PSELx;
wire          IHC_APB_0_APBmslave7_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave8_PRDATA;
wire          IHC_APB_0_APBmslave8_PREADY;
wire          IHC_APB_0_APBmslave8_PSELx;
wire          IHC_APB_0_APBmslave8_PSLVERR;
wire          IHC_APB_0_APBmslave9_PREADY;
wire          IHC_APB_0_APBmslave9_PSELx;
wire          IHC_APB_0_APBmslave9_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave10_PRDATA;
wire          IHC_APB_0_APBmslave10_PREADY;
wire          IHC_APB_0_APBmslave10_PSELx;
wire          IHC_APB_0_APBmslave10_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave11_PRDATA;
wire          IHC_APB_0_APBmslave11_PREADY;
wire          IHC_APB_0_APBmslave11_PSELx;
wire          IHC_APB_0_APBmslave11_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave12_PRDATA;
wire          IHC_APB_0_APBmslave12_PREADY;
wire          IHC_APB_0_APBmslave12_PSELx;
wire          IHC_APB_0_APBmslave12_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave13_PRDATA;
wire          IHC_APB_0_APBmslave13_PREADY;
wire          IHC_APB_0_APBmslave13_PSELx;
wire          IHC_APB_0_APBmslave13_PSLVERR;
wire          IHC_APB_0_APBmslave14_PREADY;
wire          IHC_APB_0_APBmslave14_PSELx;
wire          IHC_APB_0_APBmslave14_PSLVERR;
wire   [31:0] IHC_APB_0_APBmslave15_PRDATA;
wire          IHC_APB_0_APBmslave15_PREADY;
wire          IHC_APB_0_APBmslave15_PSELx;
wire          IHC_APB_0_APBmslave15_PSLVERR;
wire          IHC_APB_1_APBmslave0_PENABLE;
wire   [31:0] IHC_APB_1_APBmslave0_PRDATA;
wire          IHC_APB_1_APBmslave0_PREADY;
wire          IHC_APB_1_APBmslave0_PSELx;
wire          IHC_APB_1_APBmslave0_PSLVERR;
wire          IHC_APB_1_APBmslave0_PWRITE;
wire   [31:0] IHC_APB_1_APBmslave1_PRDATA;
wire          IHC_APB_1_APBmslave1_PREADY;
wire          IHC_APB_1_APBmslave1_PSELx;
wire          IHC_APB_1_APBmslave1_PSLVERR;
wire   [31:0] IHC_APB_1_APBmslave2_PRDATA;
wire          IHC_APB_1_APBmslave2_PREADY;
wire          IHC_APB_1_APBmslave2_PSELx;
wire          IHC_APB_1_APBmslave2_PSLVERR;
wire          IHC_APB_1_APBmslave3_PREADY;
wire          IHC_APB_1_APBmslave3_PSELx;
wire          IHC_APB_1_APBmslave3_PSLVERR;
wire   [31:0] IHC_APB_1_APBmslave4_PRDATA;
wire          IHC_APB_1_APBmslave4_PREADY;
wire          IHC_APB_1_APBmslave4_PSELx;
wire          IHC_APB_1_APBmslave4_PSLVERR;
wire   [31:0] IHC_APB_1_APBmslave5_PRDATA;
wire          IHC_APB_1_APBmslave5_PREADY;
wire          IHC_APB_1_APBmslave5_PSELx;
wire          IHC_APB_1_APBmslave5_PSLVERR;
wire   [31:0] IHC_APB_1_APBmslave6_PRDATA;
wire          IHC_APB_1_APBmslave6_PREADY;
wire          IHC_APB_1_APBmslave6_PSELx;
wire          IHC_APB_1_APBmslave6_PSLVERR;
wire   [31:0] IHC_APB_1_APBmslave7_PRDATA;
wire          IHC_APB_1_APBmslave7_PREADY;
wire          IHC_APB_1_APBmslave7_PSELx;
wire          IHC_APB_1_APBmslave7_PSLVERR;
wire          IHC_APB_1_APBmslave8_PREADY;
wire          IHC_APB_1_APBmslave8_PSELx;
wire          IHC_APB_1_APBmslave8_PSLVERR;
wire          pclk;
wire          presetn;
wire          U54_1_IRQ_net_0;
wire          U54_2_IRQ_net_0;
wire          U54_3_IRQ_net_0;
wire          U54_4_IRQ_net_0;
wire          E51_IRQ_net_1;
wire          APB3mmaster_PREADY_net_0;
wire          APB3mmaster_PSLVERR_net_0;
wire          U54_1_IRQ_net_1;
wire          U54_2_IRQ_net_1;
wire          U54_3_IRQ_net_1;
wire          U54_4_IRQ_net_1;
wire   [31:0] APB3mmaster_PRDATA_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire          VCC_net;
wire   [31:0] PRDATAS9_const_net_0;
wire   [31:0] PRDATAS10_const_net_0;
wire   [31:0] PRDATAS11_const_net_0;
wire   [31:0] PRDATAS12_const_net_0;
wire   [31:0] PRDATAS13_const_net_0;
wire   [31:0] PRDATAS14_const_net_0;
wire   [31:0] PRDATAS15_const_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [31:0] IHC_APB_0_APBmslave0_PADDR;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_0;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_0_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_1;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_10;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_10_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_11;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_11_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_12;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_12_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_13;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_13_5to2;
wire   [3:0]  IHC_APB_0_APBmslave0_PADDR_14;
wire   [3:0]  IHC_APB_0_APBmslave0_PADDR_14_3to0;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_15;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_15_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_1_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_2_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_3;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_3_5to2;
wire   [3:0]  IHC_APB_0_APBmslave0_PADDR_4;
wire   [3:0]  IHC_APB_0_APBmslave0_PADDR_4_3to0;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_5;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_5_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_6;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_6_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_7;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_7_5to2;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_8;
wire   [5:2]  IHC_APB_0_APBmslave0_PADDR_8_5to2;
wire   [3:0]  IHC_APB_0_APBmslave0_PADDR_9;
wire   [3:0]  IHC_APB_0_APBmslave0_PADDR_9_3to0;
wire   [31:0] IHC_APB_0_APBmslave0_PWDATA;
wire   [9:0]  IHC_APB_0_APBmslave0_PWDATA_0;
wire   [9:0]  IHC_APB_0_APBmslave0_PWDATA_0_9to0;
wire   [9:0]  IHC_APB_0_APBmslave0_PWDATA_1;
wire   [9:0]  IHC_APB_0_APBmslave0_PWDATA_1_9to0;
wire   [9:0]  IHC_APB_0_APBmslave0_PWDATA_2;
wire   [9:0]  IHC_APB_0_APBmslave0_PWDATA_2_9to0;
wire   [9:0]  IHC_APB_0_APBmslave4_PRDATA;
wire   [31:0] IHC_APB_0_APBmslave4_PRDATA_0;
wire   [31:10]IHC_APB_0_APBmslave4_PRDATA_0_31to10;
wire   [9:0]  IHC_APB_0_APBmslave4_PRDATA_0_9to0;
wire   [9:0]  IHC_APB_0_APBmslave9_PRDATA;
wire   [31:0] IHC_APB_0_APBmslave9_PRDATA_0;
wire   [31:10]IHC_APB_0_APBmslave9_PRDATA_0_31to10;
wire   [9:0]  IHC_APB_0_APBmslave9_PRDATA_0_9to0;
wire   [9:0]  IHC_APB_0_APBmslave14_PRDATA;
wire   [31:0] IHC_APB_0_APBmslave14_PRDATA_0;
wire   [31:10]IHC_APB_0_APBmslave14_PRDATA_0_31to10;
wire   [9:0]  IHC_APB_0_APBmslave14_PRDATA_0_9to0;
wire   [31:0] IHC_APB_1_APBmslave0_PADDR;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_0;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_0_5to2;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_1;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_1_5to2;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_2;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_2_5to2;
wire   [3:0]  IHC_APB_1_APBmslave0_PADDR_3;
wire   [3:0]  IHC_APB_1_APBmslave0_PADDR_3_3to0;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_4;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_4_5to2;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_5;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_5_5to2;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_6;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_6_5to2;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_7;
wire   [5:2]  IHC_APB_1_APBmslave0_PADDR_7_5to2;
wire   [3:0]  IHC_APB_1_APBmslave0_PADDR_8;
wire   [3:0]  IHC_APB_1_APBmslave0_PADDR_8_3to0;
wire   [31:0] IHC_APB_1_APBmslave0_PWDATA;
wire   [9:0]  IHC_APB_1_APBmslave0_PWDATA_0;
wire   [9:0]  IHC_APB_1_APBmslave0_PWDATA_0_9to0;
wire   [9:0]  IHC_APB_1_APBmslave0_PWDATA_1;
wire   [9:0]  IHC_APB_1_APBmslave0_PWDATA_1_9to0;
wire   [9:0]  IHC_APB_1_APBmslave3_PRDATA;
wire   [31:0] IHC_APB_1_APBmslave3_PRDATA_0;
wire   [31:10]IHC_APB_1_APBmslave3_PRDATA_0_31to10;
wire   [9:0]  IHC_APB_1_APBmslave3_PRDATA_0_9to0;
wire   [9:0]  IHC_APB_1_APBmslave8_PRDATA;
wire   [31:0] IHC_APB_1_APBmslave8_PRDATA_0;
wire   [31:10]IHC_APB_1_APBmslave8_PRDATA_0_31to10;
wire   [9:0]  IHC_APB_1_APBmslave8_PRDATA_0_9to0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net               = 1'b0;
assign VCC_net               = 1'b1;
assign PRDATAS9_const_net_0  = 32'h00000000;
assign PRDATAS10_const_net_0 = 32'h00000000;
assign PRDATAS11_const_net_0 = 32'h00000000;
assign PRDATAS12_const_net_0 = 32'h00000000;
assign PRDATAS13_const_net_0 = 32'h00000000;
assign PRDATAS14_const_net_0 = 32'h00000000;
assign PRDATAS15_const_net_0 = 32'h00000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign E51_IRQ_net_1             = E51_IRQ_net_0;
assign E51_IRQ                   = E51_IRQ_net_1;
assign APB3mmaster_PREADY_net_0  = APB3mmaster_PREADY;
assign PREADY                    = APB3mmaster_PREADY_net_0;
assign APB3mmaster_PSLVERR_net_0 = APB3mmaster_PSLVERR;
assign PSLVERR                   = APB3mmaster_PSLVERR_net_0;
assign U54_1_IRQ_net_1           = U54_1_IRQ_net_0;
assign U54_1_IRQ                 = U54_1_IRQ_net_1;
assign U54_2_IRQ_net_1           = U54_2_IRQ_net_0;
assign U54_2_IRQ                 = U54_2_IRQ_net_1;
assign U54_3_IRQ_net_1           = U54_3_IRQ_net_0;
assign U54_3_IRQ                 = U54_3_IRQ_net_1;
assign U54_4_IRQ_net_1           = U54_4_IRQ_net_0;
assign U54_4_IRQ                 = U54_4_IRQ_net_1;
assign APB3mmaster_PRDATA_net_0  = APB3mmaster_PRDATA;
assign PRDATA[31:0]              = APB3mmaster_PRDATA_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign IHC_APB_0_APBmslave0_PADDR_0 = { IHC_APB_0_APBmslave0_PADDR_0_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_0_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_1 = { IHC_APB_0_APBmslave0_PADDR_1_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_10 = { IHC_APB_0_APBmslave0_PADDR_10_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_10_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_11 = { IHC_APB_0_APBmslave0_PADDR_11_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_11_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_12 = { IHC_APB_0_APBmslave0_PADDR_12_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_12_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_13 = { IHC_APB_0_APBmslave0_PADDR_13_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_13_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_14 = { IHC_APB_0_APBmslave0_PADDR_14_3to0 };
assign IHC_APB_0_APBmslave0_PADDR_14_3to0 = IHC_APB_0_APBmslave0_PADDR[3:0];
assign IHC_APB_0_APBmslave0_PADDR_15 = { IHC_APB_0_APBmslave0_PADDR_15_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_15_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_1_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_2 = { IHC_APB_0_APBmslave0_PADDR_2_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_2_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_3 = { IHC_APB_0_APBmslave0_PADDR_3_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_3_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_4 = { IHC_APB_0_APBmslave0_PADDR_4_3to0 };
assign IHC_APB_0_APBmslave0_PADDR_4_3to0 = IHC_APB_0_APBmslave0_PADDR[3:0];
assign IHC_APB_0_APBmslave0_PADDR_5 = { IHC_APB_0_APBmslave0_PADDR_5_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_5_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_6 = { IHC_APB_0_APBmslave0_PADDR_6_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_6_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_7 = { IHC_APB_0_APBmslave0_PADDR_7_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_7_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_8 = { IHC_APB_0_APBmslave0_PADDR_8_5to2 };
assign IHC_APB_0_APBmslave0_PADDR_8_5to2 = IHC_APB_0_APBmslave0_PADDR[5:2];
assign IHC_APB_0_APBmslave0_PADDR_9 = { IHC_APB_0_APBmslave0_PADDR_9_3to0 };
assign IHC_APB_0_APBmslave0_PADDR_9_3to0 = IHC_APB_0_APBmslave0_PADDR[3:0];

assign IHC_APB_0_APBmslave0_PWDATA_0 = { IHC_APB_0_APBmslave0_PWDATA_0_9to0 };
assign IHC_APB_0_APBmslave0_PWDATA_0_9to0 = IHC_APB_0_APBmslave0_PWDATA[9:0];
assign IHC_APB_0_APBmslave0_PWDATA_1 = { IHC_APB_0_APBmslave0_PWDATA_1_9to0 };
assign IHC_APB_0_APBmslave0_PWDATA_1_9to0 = IHC_APB_0_APBmslave0_PWDATA[9:0];
assign IHC_APB_0_APBmslave0_PWDATA_2 = { IHC_APB_0_APBmslave0_PWDATA_2_9to0 };
assign IHC_APB_0_APBmslave0_PWDATA_2_9to0 = IHC_APB_0_APBmslave0_PWDATA[9:0];

assign IHC_APB_0_APBmslave4_PRDATA_0 = { IHC_APB_0_APBmslave4_PRDATA_0_31to10, IHC_APB_0_APBmslave4_PRDATA_0_9to0 };
assign IHC_APB_0_APBmslave4_PRDATA_0_31to10 = 22'h0;
assign IHC_APB_0_APBmslave4_PRDATA_0_9to0 = IHC_APB_0_APBmslave4_PRDATA[9:0];

assign IHC_APB_0_APBmslave9_PRDATA_0 = { IHC_APB_0_APBmslave9_PRDATA_0_31to10, IHC_APB_0_APBmslave9_PRDATA_0_9to0 };
assign IHC_APB_0_APBmslave9_PRDATA_0_31to10 = 22'h0;
assign IHC_APB_0_APBmslave9_PRDATA_0_9to0 = IHC_APB_0_APBmslave9_PRDATA[9:0];

assign IHC_APB_0_APBmslave14_PRDATA_0 = { IHC_APB_0_APBmslave14_PRDATA_0_31to10, IHC_APB_0_APBmslave14_PRDATA_0_9to0 };
assign IHC_APB_0_APBmslave14_PRDATA_0_31to10 = 22'h0;
assign IHC_APB_0_APBmslave14_PRDATA_0_9to0 = IHC_APB_0_APBmslave14_PRDATA[9:0];

assign IHC_APB_1_APBmslave0_PADDR_0 = { IHC_APB_1_APBmslave0_PADDR_0_5to2 };
assign IHC_APB_1_APBmslave0_PADDR_0_5to2 = IHC_APB_1_APBmslave0_PADDR[5:2];
assign IHC_APB_1_APBmslave0_PADDR_1 = { IHC_APB_1_APBmslave0_PADDR_1_5to2 };
assign IHC_APB_1_APBmslave0_PADDR_1_5to2 = IHC_APB_1_APBmslave0_PADDR[5:2];
assign IHC_APB_1_APBmslave0_PADDR_2 = { IHC_APB_1_APBmslave0_PADDR_2_5to2 };
assign IHC_APB_1_APBmslave0_PADDR_2_5to2 = IHC_APB_1_APBmslave0_PADDR[5:2];
assign IHC_APB_1_APBmslave0_PADDR_3 = { IHC_APB_1_APBmslave0_PADDR_3_3to0 };
assign IHC_APB_1_APBmslave0_PADDR_3_3to0 = IHC_APB_1_APBmslave0_PADDR[3:0];
assign IHC_APB_1_APBmslave0_PADDR_4 = { IHC_APB_1_APBmslave0_PADDR_4_5to2 };
assign IHC_APB_1_APBmslave0_PADDR_4_5to2 = IHC_APB_1_APBmslave0_PADDR[5:2];
assign IHC_APB_1_APBmslave0_PADDR_5 = { IHC_APB_1_APBmslave0_PADDR_5_5to2 };
assign IHC_APB_1_APBmslave0_PADDR_5_5to2 = IHC_APB_1_APBmslave0_PADDR[5:2];
assign IHC_APB_1_APBmslave0_PADDR_6 = { IHC_APB_1_APBmslave0_PADDR_6_5to2 };
assign IHC_APB_1_APBmslave0_PADDR_6_5to2 = IHC_APB_1_APBmslave0_PADDR[5:2];
assign IHC_APB_1_APBmslave0_PADDR_7 = { IHC_APB_1_APBmslave0_PADDR_7_5to2 };
assign IHC_APB_1_APBmslave0_PADDR_7_5to2 = IHC_APB_1_APBmslave0_PADDR[5:2];
assign IHC_APB_1_APBmslave0_PADDR_8 = { IHC_APB_1_APBmslave0_PADDR_8_3to0 };
assign IHC_APB_1_APBmslave0_PADDR_8_3to0 = IHC_APB_1_APBmslave0_PADDR[3:0];

assign IHC_APB_1_APBmslave0_PWDATA_0 = { IHC_APB_1_APBmslave0_PWDATA_0_9to0 };
assign IHC_APB_1_APBmslave0_PWDATA_0_9to0 = IHC_APB_1_APBmslave0_PWDATA[9:0];
assign IHC_APB_1_APBmslave0_PWDATA_1 = { IHC_APB_1_APBmslave0_PWDATA_1_9to0 };
assign IHC_APB_1_APBmslave0_PWDATA_1_9to0 = IHC_APB_1_APBmslave0_PWDATA[9:0];

assign IHC_APB_1_APBmslave3_PRDATA_0 = { IHC_APB_1_APBmslave3_PRDATA_0_31to10, IHC_APB_1_APBmslave3_PRDATA_0_9to0 };
assign IHC_APB_1_APBmslave3_PRDATA_0_31to10 = 22'h0;
assign IHC_APB_1_APBmslave3_PRDATA_0_9to0 = IHC_APB_1_APBmslave3_PRDATA[9:0];

assign IHC_APB_1_APBmslave8_PRDATA_0 = { IHC_APB_1_APBmslave8_PRDATA_0_31to10, IHC_APB_1_APBmslave8_PRDATA_0_9to0 };
assign IHC_APB_1_APBmslave8_PRDATA_0_31to10 = 22'h0;
assign IHC_APB_1_APBmslave8_PRDATA_0_9to0 = IHC_APB_1_APBmslave8_PRDATA[9:0];

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------APB_ARBITER
APB_ARBITER #( 
        .select_bit ( 12 ) )
APB_ARBITER_0(
        // Inputs
        .in_penable       ( PENABLE ),
        .in_psel          ( PSEL ),
        .in_paddr         ( PADDR ),
        .in_pwrite        ( PWRITE ),
        .in_pwdata        ( PWDATA ),
        .out_low_prdata   ( APB_ARBITER_0_APB_MASTER_low_PRDATA ),
        .out_low_pready   ( APB_ARBITER_0_APB_MASTER_low_PREADY ),
        .out_low_pslverr  ( APB_ARBITER_0_APB_MASTER_low_PSLVERR ),
        .out_high_prdata  ( APB_ARBITER_0_APB_MASTER_high_PRDATA ),
        .out_high_pready  ( APB_ARBITER_0_APB_MASTER_high_PREADY ),
        .out_high_pslverr ( APB_ARBITER_0_APB_MASTER_high_PSLVERR ),
        // Outputs
        .in_prdata        ( APB3mmaster_PRDATA ),
        .in_pready        ( APB3mmaster_PREADY ),
        .in_pslverr       ( APB3mmaster_PSLVERR ),
        .out_low_penable  ( APB_ARBITER_0_APB_MASTER_low_PENABLE ),
        .out_low_psel     ( APB_ARBITER_0_APB_MASTER_low_PSELx ),
        .out_low_paddr    ( APB_ARBITER_0_APB_MASTER_low_PADDR ),
        .out_low_pwrite   ( APB_ARBITER_0_APB_MASTER_low_PWRITE ),
        .out_low_pwdata   ( APB_ARBITER_0_APB_MASTER_low_PWDATA ),
        .out_high_penable ( APB_ARBITER_0_APB_MASTER_high_PENABLE ),
        .out_high_psel    ( APB_ARBITER_0_APB_MASTER_high_PSELx ),
        .out_high_paddr   ( APB_ARBITER_0_APB_MASTER_high_PADDR ),
        .out_high_pwrite  ( APB_ARBITER_0_APB_MASTER_high_PWRITE ),
        .out_high_pwdata  ( APB_ARBITER_0_APB_MASTER_high_PWDATA ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 0 ),
        .B_HART_ID     ( 1 ),
        .MESSAGE_DEPTH ( 4 ) )
CHANNEL_E51_TO_U54_1(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_0_APBmslave0_PSELx ),
        .a_paddr            ( IHC_APB_0_APBmslave0_PADDR_0 ),
        .a_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_0_APBmslave5_PSELx ),
        .b_paddr            ( IHC_APB_0_APBmslave0_PADDR_5 ),
        .b_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_0_APBmslave0_PRDATA ),
        .a_pready           ( IHC_APB_0_APBmslave0_PREADY ),
        .a_pslverr          ( IHC_APB_0_APBmslave0_PSLVERR ),
        .b_prdata           ( IHC_APB_0_APBmslave5_PRDATA ),
        .b_pready           ( IHC_APB_0_APBmslave5_PREADY ),
        .b_pslverr          ( IHC_APB_0_APBmslave5_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_E51_TO_U54_1_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_E51_TO_U54_1_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_E51_TO_U54_1_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_E51_TO_U54_1_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 0 ),
        .B_HART_ID     ( 2 ),
        .MESSAGE_DEPTH ( 4 ) )
CHANNEL_E51_TO_U54_2(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_0_APBmslave1_PSELx ),
        .a_paddr            ( IHC_APB_0_APBmslave0_PADDR_1 ),
        .a_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_0_APBmslave10_PSELx ),
        .b_paddr            ( IHC_APB_0_APBmslave0_PADDR_10 ),
        .b_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_0_APBmslave1_PRDATA ),
        .a_pready           ( IHC_APB_0_APBmslave1_PREADY ),
        .a_pslverr          ( IHC_APB_0_APBmslave1_PSLVERR ),
        .b_prdata           ( IHC_APB_0_APBmslave10_PRDATA ),
        .b_pready           ( IHC_APB_0_APBmslave10_PREADY ),
        .b_pslverr          ( IHC_APB_0_APBmslave10_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_E51_TO_U54_2_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_E51_TO_U54_2_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_E51_TO_U54_2_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_E51_TO_U54_2_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 0 ),
        .B_HART_ID     ( 3 ),
        .MESSAGE_DEPTH ( 4 ) )
CHANNEL_E51_TO_U54_3(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_0_APBmslave2_PSELx ),
        .a_paddr            ( IHC_APB_0_APBmslave0_PADDR_2 ),
        .a_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_0_APBmslave15_PSELx ),
        .b_paddr            ( IHC_APB_0_APBmslave0_PADDR_15 ),
        .b_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_0_APBmslave2_PRDATA ),
        .a_pready           ( IHC_APB_0_APBmslave2_PREADY ),
        .a_pslverr          ( IHC_APB_0_APBmslave2_PSLVERR ),
        .b_prdata           ( IHC_APB_0_APBmslave15_PRDATA ),
        .b_pready           ( IHC_APB_0_APBmslave15_PREADY ),
        .b_pslverr          ( IHC_APB_0_APBmslave15_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_E51_TO_U54_3_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_E51_TO_U54_3_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_E51_TO_U54_3_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_E51_TO_U54_3_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 0 ),
        .B_HART_ID     ( 4 ),
        .MESSAGE_DEPTH ( 4 ) )
CHANNEL_E51_TO_U54_4(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_0_APBmslave3_PSELx ),
        .a_paddr            ( IHC_APB_0_APBmslave0_PADDR_3 ),
        .a_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_1_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_1_APBmslave4_PSELx ),
        .b_paddr            ( IHC_APB_1_APBmslave0_PADDR_4 ),
        .b_pwrite           ( IHC_APB_1_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_1_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_0_APBmslave3_PRDATA ),
        .a_pready           ( IHC_APB_0_APBmslave3_PREADY ),
        .a_pslverr          ( IHC_APB_0_APBmslave3_PSLVERR ),
        .b_prdata           ( IHC_APB_1_APBmslave4_PRDATA ),
        .b_pready           ( IHC_APB_1_APBmslave4_PREADY ),
        .b_pslverr          ( IHC_APB_1_APBmslave4_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_E51_TO_U54_4_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_E51_TO_U54_4_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_E51_TO_U54_4_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_E51_TO_U54_4_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 1 ),
        .B_HART_ID     ( 2 ),
        .MESSAGE_DEPTH ( 2 ) )
CHANNEL_U54_1_TO_U54_2(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_0_APBmslave6_PSELx ),
        .a_paddr            ( IHC_APB_0_APBmslave0_PADDR_6 ),
        .a_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_0_APBmslave11_PSELx ),
        .b_paddr            ( IHC_APB_0_APBmslave0_PADDR_11 ),
        .b_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_0_APBmslave6_PRDATA ),
        .a_pready           ( IHC_APB_0_APBmslave6_PREADY ),
        .a_pslverr          ( IHC_APB_0_APBmslave6_PSLVERR ),
        .b_prdata           ( IHC_APB_0_APBmslave11_PRDATA ),
        .b_pready           ( IHC_APB_0_APBmslave11_PREADY ),
        .b_pslverr          ( IHC_APB_0_APBmslave11_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_U54_1_TO_U54_2_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_U54_1_TO_U54_2_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_U54_1_TO_U54_2_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_U54_1_TO_U54_2_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 1 ),
        .B_HART_ID     ( 3 ),
        .MESSAGE_DEPTH ( 2 ) )
CHANNEL_U54_1_TO_U54_3(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_0_APBmslave7_PSELx ),
        .a_paddr            ( IHC_APB_0_APBmslave0_PADDR_7 ),
        .a_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_1_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_1_APBmslave0_PSELx ),
        .b_paddr            ( IHC_APB_1_APBmslave0_PADDR_0 ),
        .b_pwrite           ( IHC_APB_1_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_1_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_0_APBmslave7_PRDATA ),
        .a_pready           ( IHC_APB_0_APBmslave7_PREADY ),
        .a_pslverr          ( IHC_APB_0_APBmslave7_PSLVERR ),
        .b_prdata           ( IHC_APB_1_APBmslave0_PRDATA ),
        .b_pready           ( IHC_APB_1_APBmslave0_PREADY ),
        .b_pslverr          ( IHC_APB_1_APBmslave0_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_U54_1_TO_U54_3_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_U54_1_TO_U54_3_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_U54_1_TO_U54_3_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_U54_1_TO_U54_3_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 1 ),
        .B_HART_ID     ( 4 ),
        .MESSAGE_DEPTH ( 2 ) )
CHANNEL_U54_1_TO_U54_4(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_0_APBmslave8_PSELx ),
        .a_paddr            ( IHC_APB_0_APBmslave0_PADDR_8 ),
        .a_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_1_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_1_APBmslave5_PSELx ),
        .b_paddr            ( IHC_APB_1_APBmslave0_PADDR_5 ),
        .b_pwrite           ( IHC_APB_1_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_1_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_0_APBmslave8_PRDATA ),
        .a_pready           ( IHC_APB_0_APBmslave8_PREADY ),
        .a_pslverr          ( IHC_APB_0_APBmslave8_PSLVERR ),
        .b_prdata           ( IHC_APB_1_APBmslave5_PRDATA ),
        .b_pready           ( IHC_APB_1_APBmslave5_PREADY ),
        .b_pslverr          ( IHC_APB_1_APBmslave5_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_U54_1_TO_U54_4_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_U54_1_TO_U54_4_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_U54_1_TO_U54_4_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_U54_1_TO_U54_4_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 2 ),
        .B_HART_ID     ( 3 ),
        .MESSAGE_DEPTH ( 2 ) )
CHANNEL_U54_2_TO_U54_3(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_0_APBmslave12_PSELx ),
        .a_paddr            ( IHC_APB_0_APBmslave0_PADDR_12 ),
        .a_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_1_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_1_APBmslave1_PSELx ),
        .b_paddr            ( IHC_APB_1_APBmslave0_PADDR_1 ),
        .b_pwrite           ( IHC_APB_1_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_1_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_0_APBmslave12_PRDATA ),
        .a_pready           ( IHC_APB_0_APBmslave12_PREADY ),
        .a_pslverr          ( IHC_APB_0_APBmslave12_PSLVERR ),
        .b_prdata           ( IHC_APB_1_APBmslave1_PRDATA ),
        .b_pready           ( IHC_APB_1_APBmslave1_PREADY ),
        .b_pslverr          ( IHC_APB_1_APBmslave1_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_U54_2_TO_U54_3_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_U54_2_TO_U54_3_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_U54_2_TO_U54_3_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_U54_2_TO_U54_3_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 2 ),
        .B_HART_ID     ( 4 ),
        .MESSAGE_DEPTH ( 2 ) )
CHANNEL_U54_2_TO_U54_4(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_0_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_0_APBmslave13_PSELx ),
        .a_paddr            ( IHC_APB_0_APBmslave0_PADDR_13 ),
        .a_pwrite           ( IHC_APB_0_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_0_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_1_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_1_APBmslave6_PSELx ),
        .b_paddr            ( IHC_APB_1_APBmslave0_PADDR_6 ),
        .b_pwrite           ( IHC_APB_1_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_1_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_0_APBmslave13_PRDATA ),
        .a_pready           ( IHC_APB_0_APBmslave13_PREADY ),
        .a_pslverr          ( IHC_APB_0_APBmslave13_PSLVERR ),
        .b_prdata           ( IHC_APB_1_APBmslave6_PRDATA ),
        .b_pready           ( IHC_APB_1_APBmslave6_PREADY ),
        .b_pslverr          ( IHC_APB_1_APBmslave6_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_U54_2_TO_U54_4_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_U54_2_TO_U54_4_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_U54_2_TO_U54_4_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_U54_2_TO_U54_4_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCC
MIV_IHCC #( 
        .A_HART_ID     ( 3 ),
        .B_HART_ID     ( 4 ),
        .MESSAGE_DEPTH ( 2 ) )
CHANNEL_U54_3_TO_U54_4(
        // Inputs
        .pclk               ( pclk ),
        .presetn            ( presetn ),
        .a_penable          ( IHC_APB_1_APBmslave0_PENABLE ),
        .a_psel             ( IHC_APB_1_APBmslave2_PSELx ),
        .a_paddr            ( IHC_APB_1_APBmslave0_PADDR_2 ),
        .a_pwrite           ( IHC_APB_1_APBmslave0_PWRITE ),
        .a_pwdata           ( IHC_APB_1_APBmslave0_PWDATA ),
        .b_penable          ( IHC_APB_1_APBmslave0_PENABLE ),
        .b_psel             ( IHC_APB_1_APBmslave7_PSELx ),
        .b_paddr            ( IHC_APB_1_APBmslave0_PADDR_7 ),
        .b_pwrite           ( IHC_APB_1_APBmslave0_PWRITE ),
        .b_pwdata           ( IHC_APB_1_APBmslave0_PWDATA ),
        // Outputs
        .a_prdata           ( IHC_APB_1_APBmslave2_PRDATA ),
        .a_pready           ( IHC_APB_1_APBmslave2_PREADY ),
        .a_pslverr          ( IHC_APB_1_APBmslave2_PSLVERR ),
        .b_prdata           ( IHC_APB_1_APBmslave7_PRDATA ),
        .b_pready           ( IHC_APB_1_APBmslave7_PREADY ),
        .b_pslverr          ( IHC_APB_1_APBmslave7_PSLVERR ),
        .SIDE_A_MSG_PRESENT ( CHANNEL_U54_3_TO_U54_4_SIDE_A_MSG_PRESENT ),
        .SIDE_A_ACK_FROM_B  ( CHANNEL_U54_3_TO_U54_4_SIDE_A_ACK_FROM_B ),
        .SIDE_B_MSG_PRESENT ( CHANNEL_U54_3_TO_U54_4_SIDE_B_MSG_PRESENT ),
        .SIDE_B_ACK_FROM_A  ( CHANNEL_U54_3_TO_U54_4_SIDE_B_ACK_FROM_A ) 
        );

//--------MIV_IHCIA
MIV_IHCIA E51_IRQ_AGGREGATOR_0(
        // Inputs
        .pclk                ( pclk ),
        .presetn             ( presetn ),
        .penable             ( IHC_APB_0_APBmslave0_PENABLE ),
        .psel                ( IHC_APB_0_APBmslave4_PSELx ),
        .paddr               ( IHC_APB_0_APBmslave0_PADDR_4 ),
        .pwrite              ( IHC_APB_0_APBmslave0_PWRITE ),
        .pwdata              ( IHC_APB_0_APBmslave0_PWDATA_0 ),
        .CH0_MSG_PRESENT_IRQ ( GND_net ),
        .CH0_ACK_IRQ         ( GND_net ),
        .CH1_MSG_PRESENT_IRQ ( CHANNEL_E51_TO_U54_1_SIDE_A_MSG_PRESENT ),
        .CH1_ACK_IRQ         ( CHANNEL_E51_TO_U54_1_SIDE_A_ACK_FROM_B ),
        .CH2_MSG_PRESENT_IRQ ( CHANNEL_E51_TO_U54_2_SIDE_A_MSG_PRESENT ),
        .CH2_ACK_IRQ         ( CHANNEL_E51_TO_U54_2_SIDE_A_ACK_FROM_B ),
        .CH3_MSG_PRESENT_IRQ ( CHANNEL_E51_TO_U54_3_SIDE_A_MSG_PRESENT ),
        .CH3_ACK_IRQ         ( CHANNEL_E51_TO_U54_3_SIDE_A_ACK_FROM_B ),
        .CH4_MSG_PRESENT_IRQ ( CHANNEL_E51_TO_U54_4_SIDE_A_MSG_PRESENT ),
        .CH4_ACK_IRQ         ( CHANNEL_E51_TO_U54_4_SIDE_A_ACK_FROM_B ),
        // Outputs
        .prdata              ( IHC_APB_0_APBmslave4_PRDATA ),
        .pready              ( IHC_APB_0_APBmslave4_PREADY ),
        .pslverr             ( IHC_APB_0_APBmslave4_PSLVERR ),
        .IRQ                 ( E51_IRQ_net_0 ) 
        );

//--------IHC_APB
IHC_APB IHC_APB_0(
        // Inputs
        .PADDR      ( APB_ARBITER_0_APB_MASTER_low_PADDR ),
        .PSEL       ( APB_ARBITER_0_APB_MASTER_low_PSELx ),
        .PENABLE    ( APB_ARBITER_0_APB_MASTER_low_PENABLE ),
        .PWRITE     ( APB_ARBITER_0_APB_MASTER_low_PWRITE ),
        .PWDATA     ( APB_ARBITER_0_APB_MASTER_low_PWDATA ),
        .PRDATAS0   ( IHC_APB_0_APBmslave0_PRDATA ),
        .PREADYS0   ( IHC_APB_0_APBmslave0_PREADY ),
        .PSLVERRS0  ( IHC_APB_0_APBmslave0_PSLVERR ),
        .PRDATAS1   ( IHC_APB_0_APBmslave1_PRDATA ),
        .PREADYS1   ( IHC_APB_0_APBmslave1_PREADY ),
        .PSLVERRS1  ( IHC_APB_0_APBmslave1_PSLVERR ),
        .PRDATAS2   ( IHC_APB_0_APBmslave2_PRDATA ),
        .PREADYS2   ( IHC_APB_0_APBmslave2_PREADY ),
        .PSLVERRS2  ( IHC_APB_0_APBmslave2_PSLVERR ),
        .PRDATAS3   ( IHC_APB_0_APBmslave3_PRDATA ),
        .PREADYS3   ( IHC_APB_0_APBmslave3_PREADY ),
        .PSLVERRS3  ( IHC_APB_0_APBmslave3_PSLVERR ),
        .PRDATAS4   ( IHC_APB_0_APBmslave4_PRDATA_0 ),
        .PREADYS4   ( IHC_APB_0_APBmslave4_PREADY ),
        .PSLVERRS4  ( IHC_APB_0_APBmslave4_PSLVERR ),
        .PRDATAS5   ( IHC_APB_0_APBmslave5_PRDATA ),
        .PREADYS5   ( IHC_APB_0_APBmslave5_PREADY ),
        .PSLVERRS5  ( IHC_APB_0_APBmslave5_PSLVERR ),
        .PRDATAS6   ( IHC_APB_0_APBmslave6_PRDATA ),
        .PREADYS6   ( IHC_APB_0_APBmslave6_PREADY ),
        .PSLVERRS6  ( IHC_APB_0_APBmslave6_PSLVERR ),
        .PRDATAS7   ( IHC_APB_0_APBmslave7_PRDATA ),
        .PREADYS7   ( IHC_APB_0_APBmslave7_PREADY ),
        .PSLVERRS7  ( IHC_APB_0_APBmslave7_PSLVERR ),
        .PRDATAS8   ( IHC_APB_0_APBmslave8_PRDATA ),
        .PREADYS8   ( IHC_APB_0_APBmslave8_PREADY ),
        .PSLVERRS8  ( IHC_APB_0_APBmslave8_PSLVERR ),
        .PRDATAS9   ( IHC_APB_0_APBmslave9_PRDATA_0 ),
        .PREADYS9   ( IHC_APB_0_APBmslave9_PREADY ),
        .PSLVERRS9  ( IHC_APB_0_APBmslave9_PSLVERR ),
        .PRDATAS10  ( IHC_APB_0_APBmslave10_PRDATA ),
        .PREADYS10  ( IHC_APB_0_APBmslave10_PREADY ),
        .PSLVERRS10 ( IHC_APB_0_APBmslave10_PSLVERR ),
        .PRDATAS11  ( IHC_APB_0_APBmslave11_PRDATA ),
        .PREADYS11  ( IHC_APB_0_APBmslave11_PREADY ),
        .PSLVERRS11 ( IHC_APB_0_APBmslave11_PSLVERR ),
        .PRDATAS12  ( IHC_APB_0_APBmslave12_PRDATA ),
        .PREADYS12  ( IHC_APB_0_APBmslave12_PREADY ),
        .PSLVERRS12 ( IHC_APB_0_APBmslave12_PSLVERR ),
        .PRDATAS13  ( IHC_APB_0_APBmslave13_PRDATA ),
        .PREADYS13  ( IHC_APB_0_APBmslave13_PREADY ),
        .PSLVERRS13 ( IHC_APB_0_APBmslave13_PSLVERR ),
        .PRDATAS14  ( IHC_APB_0_APBmslave14_PRDATA_0 ),
        .PREADYS14  ( IHC_APB_0_APBmslave14_PREADY ),
        .PSLVERRS14 ( IHC_APB_0_APBmslave14_PSLVERR ),
        .PRDATAS15  ( IHC_APB_0_APBmslave15_PRDATA ),
        .PREADYS15  ( IHC_APB_0_APBmslave15_PREADY ),
        .PSLVERRS15 ( IHC_APB_0_APBmslave15_PSLVERR ),
        // Outputs
        .PRDATA     ( APB_ARBITER_0_APB_MASTER_low_PRDATA ),
        .PREADY     ( APB_ARBITER_0_APB_MASTER_low_PREADY ),
        .PSLVERR    ( APB_ARBITER_0_APB_MASTER_low_PSLVERR ),
        .PADDRS     ( IHC_APB_0_APBmslave0_PADDR ),
        .PSELS0     ( IHC_APB_0_APBmslave0_PSELx ),
        .PENABLES   ( IHC_APB_0_APBmslave0_PENABLE ),
        .PWRITES    ( IHC_APB_0_APBmslave0_PWRITE ),
        .PWDATAS    ( IHC_APB_0_APBmslave0_PWDATA ),
        .PSELS1     ( IHC_APB_0_APBmslave1_PSELx ),
        .PSELS2     ( IHC_APB_0_APBmslave2_PSELx ),
        .PSELS3     ( IHC_APB_0_APBmslave3_PSELx ),
        .PSELS4     ( IHC_APB_0_APBmslave4_PSELx ),
        .PSELS5     ( IHC_APB_0_APBmslave5_PSELx ),
        .PSELS6     ( IHC_APB_0_APBmslave6_PSELx ),
        .PSELS7     ( IHC_APB_0_APBmslave7_PSELx ),
        .PSELS8     ( IHC_APB_0_APBmslave8_PSELx ),
        .PSELS9     ( IHC_APB_0_APBmslave9_PSELx ),
        .PSELS10    ( IHC_APB_0_APBmslave10_PSELx ),
        .PSELS11    ( IHC_APB_0_APBmslave11_PSELx ),
        .PSELS12    ( IHC_APB_0_APBmslave12_PSELx ),
        .PSELS13    ( IHC_APB_0_APBmslave13_PSELx ),
        .PSELS14    ( IHC_APB_0_APBmslave14_PSELx ),
        .PSELS15    ( IHC_APB_0_APBmslave15_PSELx ) 
        );

//--------IHC_APB
IHC_APB IHC_APB_1(
        // Inputs
        .PADDR      ( APB_ARBITER_0_APB_MASTER_high_PADDR ),
        .PSEL       ( APB_ARBITER_0_APB_MASTER_high_PSELx ),
        .PENABLE    ( APB_ARBITER_0_APB_MASTER_high_PENABLE ),
        .PWRITE     ( APB_ARBITER_0_APB_MASTER_high_PWRITE ),
        .PWDATA     ( APB_ARBITER_0_APB_MASTER_high_PWDATA ),
        .PRDATAS0   ( IHC_APB_1_APBmslave0_PRDATA ),
        .PREADYS0   ( IHC_APB_1_APBmslave0_PREADY ),
        .PSLVERRS0  ( IHC_APB_1_APBmslave0_PSLVERR ),
        .PRDATAS1   ( IHC_APB_1_APBmslave1_PRDATA ),
        .PREADYS1   ( IHC_APB_1_APBmslave1_PREADY ),
        .PSLVERRS1  ( IHC_APB_1_APBmslave1_PSLVERR ),
        .PRDATAS2   ( IHC_APB_1_APBmslave2_PRDATA ),
        .PREADYS2   ( IHC_APB_1_APBmslave2_PREADY ),
        .PSLVERRS2  ( IHC_APB_1_APBmslave2_PSLVERR ),
        .PRDATAS3   ( IHC_APB_1_APBmslave3_PRDATA_0 ),
        .PREADYS3   ( IHC_APB_1_APBmslave3_PREADY ),
        .PSLVERRS3  ( IHC_APB_1_APBmslave3_PSLVERR ),
        .PRDATAS4   ( IHC_APB_1_APBmslave4_PRDATA ),
        .PREADYS4   ( IHC_APB_1_APBmslave4_PREADY ),
        .PSLVERRS4  ( IHC_APB_1_APBmslave4_PSLVERR ),
        .PRDATAS5   ( IHC_APB_1_APBmslave5_PRDATA ),
        .PREADYS5   ( IHC_APB_1_APBmslave5_PREADY ),
        .PSLVERRS5  ( IHC_APB_1_APBmslave5_PSLVERR ),
        .PRDATAS6   ( IHC_APB_1_APBmslave6_PRDATA ),
        .PREADYS6   ( IHC_APB_1_APBmslave6_PREADY ),
        .PSLVERRS6  ( IHC_APB_1_APBmslave6_PSLVERR ),
        .PRDATAS7   ( IHC_APB_1_APBmslave7_PRDATA ),
        .PREADYS7   ( IHC_APB_1_APBmslave7_PREADY ),
        .PSLVERRS7  ( IHC_APB_1_APBmslave7_PSLVERR ),
        .PRDATAS8   ( IHC_APB_1_APBmslave8_PRDATA_0 ),
        .PREADYS8   ( IHC_APB_1_APBmslave8_PREADY ),
        .PSLVERRS8  ( IHC_APB_1_APBmslave8_PSLVERR ),
        .PRDATAS9   ( PRDATAS9_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS9   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS9  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS10  ( PRDATAS10_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS10  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS10 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS11  ( PRDATAS11_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS11  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS11 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS12  ( PRDATAS12_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS12  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS12 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS13  ( PRDATAS13_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS13  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS13 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS14  ( PRDATAS14_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS14  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS14 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS15  ( PRDATAS15_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS15  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS15 ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .PRDATA     ( APB_ARBITER_0_APB_MASTER_high_PRDATA ),
        .PREADY     ( APB_ARBITER_0_APB_MASTER_high_PREADY ),
        .PSLVERR    ( APB_ARBITER_0_APB_MASTER_high_PSLVERR ),
        .PADDRS     ( IHC_APB_1_APBmslave0_PADDR ),
        .PSELS0     ( IHC_APB_1_APBmslave0_PSELx ),
        .PENABLES   ( IHC_APB_1_APBmslave0_PENABLE ),
        .PWRITES    ( IHC_APB_1_APBmslave0_PWRITE ),
        .PWDATAS    ( IHC_APB_1_APBmslave0_PWDATA ),
        .PSELS1     ( IHC_APB_1_APBmslave1_PSELx ),
        .PSELS2     ( IHC_APB_1_APBmslave2_PSELx ),
        .PSELS3     ( IHC_APB_1_APBmslave3_PSELx ),
        .PSELS4     ( IHC_APB_1_APBmslave4_PSELx ),
        .PSELS5     ( IHC_APB_1_APBmslave5_PSELx ),
        .PSELS6     ( IHC_APB_1_APBmslave6_PSELx ),
        .PSELS7     ( IHC_APB_1_APBmslave7_PSELx ),
        .PSELS8     ( IHC_APB_1_APBmslave8_PSELx ),
        .PSELS9     (  ),
        .PSELS10    (  ),
        .PSELS11    (  ),
        .PSELS12    (  ),
        .PSELS13    (  ),
        .PSELS14    (  ),
        .PSELS15    (  ) 
        );

//--------MIV_IHCIA
MIV_IHCIA U54_1_IRQ_AGGREGATOR(
        // Inputs
        .pclk                ( pclk ),
        .presetn             ( presetn ),
        .penable             ( IHC_APB_0_APBmslave0_PENABLE ),
        .psel                ( IHC_APB_0_APBmslave9_PSELx ),
        .paddr               ( IHC_APB_0_APBmslave0_PADDR_9 ),
        .pwrite              ( IHC_APB_0_APBmslave0_PWRITE ),
        .pwdata              ( IHC_APB_0_APBmslave0_PWDATA_1 ),
        .CH0_MSG_PRESENT_IRQ ( CHANNEL_E51_TO_U54_1_SIDE_B_MSG_PRESENT ),
        .CH0_ACK_IRQ         ( CHANNEL_E51_TO_U54_1_SIDE_B_ACK_FROM_A ),
        .CH1_MSG_PRESENT_IRQ ( GND_net ),
        .CH1_ACK_IRQ         ( GND_net ),
        .CH2_MSG_PRESENT_IRQ ( CHANNEL_U54_1_TO_U54_2_SIDE_A_MSG_PRESENT ),
        .CH2_ACK_IRQ         ( CHANNEL_U54_1_TO_U54_2_SIDE_A_ACK_FROM_B ),
        .CH3_MSG_PRESENT_IRQ ( CHANNEL_U54_1_TO_U54_3_SIDE_A_MSG_PRESENT ),
        .CH3_ACK_IRQ         ( CHANNEL_U54_1_TO_U54_3_SIDE_A_ACK_FROM_B ),
        .CH4_MSG_PRESENT_IRQ ( CHANNEL_U54_1_TO_U54_4_SIDE_A_MSG_PRESENT ),
        .CH4_ACK_IRQ         ( CHANNEL_U54_1_TO_U54_4_SIDE_A_ACK_FROM_B ),
        // Outputs
        .prdata              ( IHC_APB_0_APBmslave9_PRDATA ),
        .pready              ( IHC_APB_0_APBmslave9_PREADY ),
        .pslverr             ( IHC_APB_0_APBmslave9_PSLVERR ),
        .IRQ                 ( U54_1_IRQ_net_0 ) 
        );

//--------MIV_IHCIA
MIV_IHCIA U54_2_IRQ_AGGREGATOR(
        // Inputs
        .pclk                ( pclk ),
        .presetn             ( presetn ),
        .penable             ( IHC_APB_0_APBmslave0_PENABLE ),
        .psel                ( IHC_APB_0_APBmslave14_PSELx ),
        .paddr               ( IHC_APB_0_APBmslave0_PADDR_14 ),
        .pwrite              ( IHC_APB_0_APBmslave0_PWRITE ),
        .pwdata              ( IHC_APB_0_APBmslave0_PWDATA_2 ),
        .CH0_MSG_PRESENT_IRQ ( CHANNEL_E51_TO_U54_2_SIDE_B_MSG_PRESENT ),
        .CH0_ACK_IRQ         ( CHANNEL_E51_TO_U54_2_SIDE_B_ACK_FROM_A ),
        .CH1_MSG_PRESENT_IRQ ( CHANNEL_U54_1_TO_U54_2_SIDE_B_MSG_PRESENT ),
        .CH1_ACK_IRQ         ( CHANNEL_U54_1_TO_U54_2_SIDE_B_ACK_FROM_A ),
        .CH2_MSG_PRESENT_IRQ ( GND_net ),
        .CH2_ACK_IRQ         ( GND_net ),
        .CH3_MSG_PRESENT_IRQ ( CHANNEL_U54_2_TO_U54_3_SIDE_A_MSG_PRESENT ),
        .CH3_ACK_IRQ         ( CHANNEL_U54_2_TO_U54_3_SIDE_A_ACK_FROM_B ),
        .CH4_MSG_PRESENT_IRQ ( CHANNEL_U54_2_TO_U54_4_SIDE_A_MSG_PRESENT ),
        .CH4_ACK_IRQ         ( CHANNEL_U54_2_TO_U54_4_SIDE_A_ACK_FROM_B ),
        // Outputs
        .prdata              ( IHC_APB_0_APBmslave14_PRDATA ),
        .pready              ( IHC_APB_0_APBmslave14_PREADY ),
        .pslverr             ( IHC_APB_0_APBmslave14_PSLVERR ),
        .IRQ                 ( U54_2_IRQ_net_0 ) 
        );

//--------MIV_IHCIA
MIV_IHCIA U54_3_IRQ_AGGREGATOR(
        // Inputs
        .pclk                ( pclk ),
        .presetn             ( presetn ),
        .penable             ( IHC_APB_1_APBmslave0_PENABLE ),
        .psel                ( IHC_APB_1_APBmslave3_PSELx ),
        .paddr               ( IHC_APB_1_APBmslave0_PADDR_3 ),
        .pwrite              ( IHC_APB_1_APBmslave0_PWRITE ),
        .pwdata              ( IHC_APB_1_APBmslave0_PWDATA_0 ),
        .CH0_MSG_PRESENT_IRQ ( CHANNEL_E51_TO_U54_3_SIDE_B_MSG_PRESENT ),
        .CH0_ACK_IRQ         ( CHANNEL_E51_TO_U54_3_SIDE_B_ACK_FROM_A ),
        .CH1_MSG_PRESENT_IRQ ( CHANNEL_U54_1_TO_U54_3_SIDE_B_MSG_PRESENT ),
        .CH1_ACK_IRQ         ( CHANNEL_U54_1_TO_U54_3_SIDE_B_ACK_FROM_A ),
        .CH2_MSG_PRESENT_IRQ ( CHANNEL_U54_2_TO_U54_3_SIDE_B_MSG_PRESENT ),
        .CH2_ACK_IRQ         ( CHANNEL_U54_2_TO_U54_3_SIDE_B_ACK_FROM_A ),
        .CH3_MSG_PRESENT_IRQ ( GND_net ),
        .CH3_ACK_IRQ         ( GND_net ),
        .CH4_MSG_PRESENT_IRQ ( CHANNEL_U54_3_TO_U54_4_SIDE_A_MSG_PRESENT ),
        .CH4_ACK_IRQ         ( CHANNEL_U54_3_TO_U54_4_SIDE_A_ACK_FROM_B ),
        // Outputs
        .prdata              ( IHC_APB_1_APBmslave3_PRDATA ),
        .pready              ( IHC_APB_1_APBmslave3_PREADY ),
        .pslverr             ( IHC_APB_1_APBmslave3_PSLVERR ),
        .IRQ                 ( U54_3_IRQ_net_0 ) 
        );

//--------MIV_IHCIA
MIV_IHCIA U54_4_IRQ_AGGREGATOR(
        // Inputs
        .pclk                ( pclk ),
        .presetn             ( presetn ),
        .penable             ( IHC_APB_1_APBmslave0_PENABLE ),
        .psel                ( IHC_APB_1_APBmslave8_PSELx ),
        .paddr               ( IHC_APB_1_APBmslave0_PADDR_8 ),
        .pwrite              ( IHC_APB_1_APBmslave0_PWRITE ),
        .pwdata              ( IHC_APB_1_APBmslave0_PWDATA_1 ),
        .CH0_MSG_PRESENT_IRQ ( CHANNEL_E51_TO_U54_4_SIDE_B_MSG_PRESENT ),
        .CH0_ACK_IRQ         ( CHANNEL_E51_TO_U54_4_SIDE_B_ACK_FROM_A ),
        .CH1_MSG_PRESENT_IRQ ( CHANNEL_U54_1_TO_U54_4_SIDE_B_MSG_PRESENT ),
        .CH1_ACK_IRQ         ( CHANNEL_U54_1_TO_U54_4_SIDE_B_ACK_FROM_A ),
        .CH2_MSG_PRESENT_IRQ ( CHANNEL_U54_2_TO_U54_4_SIDE_B_MSG_PRESENT ),
        .CH2_ACK_IRQ         ( CHANNEL_U54_2_TO_U54_4_SIDE_B_ACK_FROM_A ),
        .CH3_MSG_PRESENT_IRQ ( CHANNEL_U54_3_TO_U54_4_SIDE_B_MSG_PRESENT ),
        .CH3_ACK_IRQ         ( CHANNEL_U54_3_TO_U54_4_SIDE_B_ACK_FROM_A ),
        .CH4_MSG_PRESENT_IRQ ( GND_net ),
        .CH4_ACK_IRQ         ( GND_net ),
        // Outputs
        .prdata              ( IHC_APB_1_APBmslave8_PRDATA ),
        .pready              ( IHC_APB_1_APBmslave8_PREADY ),
        .pslverr             ( IHC_APB_1_APBmslave8_PSLVERR ),
        .IRQ                 ( U54_4_IRQ_net_0 ) 
        );


endmodule
