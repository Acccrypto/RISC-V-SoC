//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Wed Mar 29 11:18:16 2023
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// FIC_3_PERIPHERALS
module FIC_3_PERIPHERALS(
    // Inputs
    APB_MMASTER_in_paddr,
    APB_MMASTER_in_penable,
    APB_MMASTER_in_psel,
    APB_MMASTER_in_pwdata,
    APB_MMASTER_in_pwrite,
    PCLK,
    PLL0_SW_DRI_INTERRUPT,
    PLL0_SW_DRI_RDATA,
    PRESETN,
    PSTRB,
    Q0_LANE0_DRI_INTERRUPT,
    Q0_LANE0_DRI_RDATA,
    Q0_LANE1_DRI_INTERRUPT,
    Q0_LANE1_DRI_RDATA,
    Q0_LANE2_DRI_INTERRUPT,
    Q0_LANE2_DRI_RDATA,
    Q0_LANE3_DRI_INTERRUPT,
    Q0_LANE3_DRI_RDATA,
    // Outputs
    APB_MMASTER_in_prdata,
    APB_MMASTER_in_pready,
    APB_MMASTER_in_pslverr,
    GPIO_OUT_0,
    GPIO_OUT_1,
    GPIO_OUT_2,
    GPIO_OUT_3,
    IHC_SUBSYSTEM_E51_IRQ,
    IHC_SUBSYSTEM_U54_1_IRQ,
    IHC_SUBSYSTEM_U54_2_IRQ,
    IHC_SUBSYSTEM_U54_3_IRQ,
    IHC_SUBSYSTEM_U54_4_IRQ,
    PLL0_SW_DRI_CTRL,
    Q0_LANE0_DRI_CTRL,
    Q0_LANE0_DRI_DRI_ARST_N,
    Q0_LANE0_DRI_DRI_CLK,
    Q0_LANE0_DRI_DRI_WDATA,
    Q0_LANE1_DRI_CTRL,
    Q0_LANE2_DRI_CTRL,
    Q0_LANE3_DRI_CTRL,
    fabric_sd_emmc_demux_select_out
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [31:0] APB_MMASTER_in_paddr;
input         APB_MMASTER_in_penable;
input         APB_MMASTER_in_psel;
input  [31:0] APB_MMASTER_in_pwdata;
input         APB_MMASTER_in_pwrite;
input         PCLK;
input         PLL0_SW_DRI_INTERRUPT;
input  [32:0] PLL0_SW_DRI_RDATA;
input         PRESETN;
input  [3:0]  PSTRB;
input         Q0_LANE0_DRI_INTERRUPT;
input  [32:0] Q0_LANE0_DRI_RDATA;
input         Q0_LANE1_DRI_INTERRUPT;
input  [32:0] Q0_LANE1_DRI_RDATA;
input         Q0_LANE2_DRI_INTERRUPT;
input  [32:0] Q0_LANE2_DRI_RDATA;
input         Q0_LANE3_DRI_INTERRUPT;
input  [32:0] Q0_LANE3_DRI_RDATA;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [31:0] APB_MMASTER_in_prdata;
output        APB_MMASTER_in_pready;
output        APB_MMASTER_in_pslverr;
output        GPIO_OUT_0;
output        GPIO_OUT_1;
output        GPIO_OUT_2;
output        GPIO_OUT_3;
output        IHC_SUBSYSTEM_E51_IRQ;
output        IHC_SUBSYSTEM_U54_1_IRQ;
output        IHC_SUBSYSTEM_U54_2_IRQ;
output        IHC_SUBSYSTEM_U54_3_IRQ;
output        IHC_SUBSYSTEM_U54_4_IRQ;
output [10:0] PLL0_SW_DRI_CTRL;
output [10:0] Q0_LANE0_DRI_CTRL;
output        Q0_LANE0_DRI_DRI_ARST_N;
output        Q0_LANE0_DRI_DRI_CLK;
output [32:0] Q0_LANE0_DRI_DRI_WDATA;
output [10:0] Q0_LANE1_DRI_CTRL;
output [10:0] Q0_LANE2_DRI_CTRL;
output [10:0] Q0_LANE3_DRI_CTRL;
output        fabric_sd_emmc_demux_select_out;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [31:0] APB_MMASTER_in_paddr;
wire          APB_MMASTER_in_penable;
wire   [31:0] APB_MMASTER_PRDATA;
wire          APB_MMASTER_PREADY;
wire          APB_MMASTER_in_psel;
wire          APB_MMASTER_PSLVERR;
wire   [31:0] APB_MMASTER_in_pwdata;
wire          APB_MMASTER_in_pwrite;
wire          fabric_sd_emmc_demux_select_out_net_0;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PENABLE;
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PRDATA;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PREADY;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PSELx;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PSLVERR;
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PWDATA;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PWRITE;
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PADDR;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PENABLE;
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PRDATA;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PREADY;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PSELx;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PSLVERR;
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PWDATA;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PWRITE;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PENABLE;
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PRDATA;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PREADY;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PSELx;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PSLVERR;
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PWDATA;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PWRITE;
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PRDATA;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PREADY;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PSELx;
wire          FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PSLVERR;
wire   [0:0]  GPIO_OUT_0_net_0;
wire   [1:1]  GPIO_OUT_1_net_0;
wire   [2:2]  GPIO_OUT_2_net_0;
wire   [3:3]  GPIO_OUT_3_net_0;
wire          IHC_SUBSYSTEM_E51_IRQ_net_0;
wire          IHC_SUBSYSTEM_U54_1_IRQ_net_0;
wire          IHC_SUBSYSTEM_U54_2_IRQ_net_0;
wire          IHC_SUBSYSTEM_U54_3_IRQ_net_0;
wire          IHC_SUBSYSTEM_U54_4_IRQ_net_0;
wire          PCLK;
wire          PLL0_SW_DRI_DRI_ARST_N;
wire          PLL0_SW_DRI_DRI_CLK;
wire   [10:0] PLL0_SW_DRI_DRI_CTRL;
wire          PLL0_SW_DRI_INTERRUPT;
wire   [32:0] PLL0_SW_DRI_RDATA;
wire   [32:0] PLL0_SW_DRI_DRI_WDATA;
wire          PRESETN;
wire   [3:0]  PSTRB;
wire   [10:0] Q0_LANE0_DRI_DRI_CTRL;
wire          Q0_LANE0_DRI_INTERRUPT;
wire   [32:0] Q0_LANE0_DRI_RDATA;
wire   [10:0] Q0_LANE1_DRI_DRI_CTRL;
wire          Q0_LANE1_DRI_INTERRUPT;
wire   [32:0] Q0_LANE1_DRI_RDATA;
wire   [10:0] Q0_LANE2_DRI_DRI_CTRL;
wire          Q0_LANE2_DRI_INTERRUPT;
wire   [32:0] Q0_LANE2_DRI_RDATA;
wire   [10:0] Q0_LANE3_DRI_DRI_CTRL;
wire          Q0_LANE3_DRI_INTERRUPT;
wire   [32:0] Q0_LANE3_DRI_RDATA;
wire          GPIO_OUT_0_net_1;
wire          GPIO_OUT_1_net_1;
wire          GPIO_OUT_2_net_1;
wire          GPIO_OUT_3_net_1;
wire          IHC_SUBSYSTEM_E51_IRQ_net_1;
wire          IHC_SUBSYSTEM_U54_1_IRQ_net_1;
wire          IHC_SUBSYSTEM_U54_2_IRQ_net_1;
wire          IHC_SUBSYSTEM_U54_3_IRQ_net_1;
wire          IHC_SUBSYSTEM_U54_4_IRQ_net_1;
wire          PLL0_SW_DRI_DRI_ARST_N_net_0;
wire          PLL0_SW_DRI_DRI_CLK_net_0;
wire          fabric_sd_emmc_demux_select_out_net_1;
wire          APB_MMASTER_PREADY_net_0;
wire          APB_MMASTER_PSLVERR_net_0;
wire   [10:0] PLL0_SW_DRI_DRI_CTRL_net_0;
wire   [10:0] Q0_LANE0_DRI_DRI_CTRL_net_0;
wire   [32:0] PLL0_SW_DRI_DRI_WDATA_net_0;
wire   [10:0] Q0_LANE1_DRI_DRI_CTRL_net_0;
wire   [10:0] Q0_LANE2_DRI_DRI_CTRL_net_0;
wire   [10:0] Q0_LANE3_DRI_DRI_CTRL_net_0;
wire   [31:0] APB_MMASTER_PRDATA_net_0;
wire   [3:0]  GPIO_OUT_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   [3:0]  GPIO_IN_const_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PADDR;
wire   [7:0]  FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PADDR_0;
wire   [7:0]  FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PADDR_0_7to0;
wire   [31:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR;
wire   [7:0]  FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_0;
wire   [7:0]  FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_0_7to0;
wire   [28:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_1;
wire   [28:0] FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_1_28to0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GPIO_IN_const_net_0 = 4'h0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign GPIO_OUT_0_net_1                      = GPIO_OUT_0_net_0[0];
assign GPIO_OUT_0                            = GPIO_OUT_0_net_1;
assign GPIO_OUT_1_net_1                      = GPIO_OUT_1_net_0[1];
assign GPIO_OUT_1                            = GPIO_OUT_1_net_1;
assign GPIO_OUT_2_net_1                      = GPIO_OUT_2_net_0[2];
assign GPIO_OUT_2                            = GPIO_OUT_2_net_1;
assign GPIO_OUT_3_net_1                      = GPIO_OUT_3_net_0[3];
assign GPIO_OUT_3                            = GPIO_OUT_3_net_1;
assign IHC_SUBSYSTEM_E51_IRQ_net_1           = IHC_SUBSYSTEM_E51_IRQ_net_0;
assign IHC_SUBSYSTEM_E51_IRQ                 = IHC_SUBSYSTEM_E51_IRQ_net_1;
assign IHC_SUBSYSTEM_U54_1_IRQ_net_1         = IHC_SUBSYSTEM_U54_1_IRQ_net_0;
assign IHC_SUBSYSTEM_U54_1_IRQ               = IHC_SUBSYSTEM_U54_1_IRQ_net_1;
assign IHC_SUBSYSTEM_U54_2_IRQ_net_1         = IHC_SUBSYSTEM_U54_2_IRQ_net_0;
assign IHC_SUBSYSTEM_U54_2_IRQ               = IHC_SUBSYSTEM_U54_2_IRQ_net_1;
assign IHC_SUBSYSTEM_U54_3_IRQ_net_1         = IHC_SUBSYSTEM_U54_3_IRQ_net_0;
assign IHC_SUBSYSTEM_U54_3_IRQ               = IHC_SUBSYSTEM_U54_3_IRQ_net_1;
assign IHC_SUBSYSTEM_U54_4_IRQ_net_1         = IHC_SUBSYSTEM_U54_4_IRQ_net_0;
assign IHC_SUBSYSTEM_U54_4_IRQ               = IHC_SUBSYSTEM_U54_4_IRQ_net_1;
assign PLL0_SW_DRI_DRI_ARST_N_net_0          = PLL0_SW_DRI_DRI_ARST_N;
assign Q0_LANE0_DRI_DRI_ARST_N               = PLL0_SW_DRI_DRI_ARST_N_net_0;
assign PLL0_SW_DRI_DRI_CLK_net_0             = PLL0_SW_DRI_DRI_CLK;
assign Q0_LANE0_DRI_DRI_CLK                  = PLL0_SW_DRI_DRI_CLK_net_0;
assign fabric_sd_emmc_demux_select_out_net_1 = fabric_sd_emmc_demux_select_out_net_0;
assign fabric_sd_emmc_demux_select_out       = fabric_sd_emmc_demux_select_out_net_1;
assign APB_MMASTER_PREADY_net_0              = APB_MMASTER_PREADY;
assign APB_MMASTER_in_pready                 = APB_MMASTER_PREADY_net_0;
assign APB_MMASTER_PSLVERR_net_0             = APB_MMASTER_PSLVERR;
assign APB_MMASTER_in_pslverr                = APB_MMASTER_PSLVERR_net_0;
assign PLL0_SW_DRI_DRI_CTRL_net_0            = PLL0_SW_DRI_DRI_CTRL;
assign PLL0_SW_DRI_CTRL[10:0]                = PLL0_SW_DRI_DRI_CTRL_net_0;
assign Q0_LANE0_DRI_DRI_CTRL_net_0           = Q0_LANE0_DRI_DRI_CTRL;
assign Q0_LANE0_DRI_CTRL[10:0]               = Q0_LANE0_DRI_DRI_CTRL_net_0;
assign PLL0_SW_DRI_DRI_WDATA_net_0           = PLL0_SW_DRI_DRI_WDATA;
assign Q0_LANE0_DRI_DRI_WDATA[32:0]          = PLL0_SW_DRI_DRI_WDATA_net_0;
assign Q0_LANE1_DRI_DRI_CTRL_net_0           = Q0_LANE1_DRI_DRI_CTRL;
assign Q0_LANE1_DRI_CTRL[10:0]               = Q0_LANE1_DRI_DRI_CTRL_net_0;
assign Q0_LANE2_DRI_DRI_CTRL_net_0           = Q0_LANE2_DRI_DRI_CTRL;
assign Q0_LANE2_DRI_CTRL[10:0]               = Q0_LANE2_DRI_DRI_CTRL_net_0;
assign Q0_LANE3_DRI_DRI_CTRL_net_0           = Q0_LANE3_DRI_DRI_CTRL;
assign Q0_LANE3_DRI_CTRL[10:0]               = Q0_LANE3_DRI_DRI_CTRL_net_0;
assign APB_MMASTER_PRDATA_net_0              = APB_MMASTER_PRDATA;
assign APB_MMASTER_in_prdata[31:0]           = APB_MMASTER_PRDATA_net_0;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign GPIO_OUT_0_net_0[0] = GPIO_OUT_net_0[0:0];
assign GPIO_OUT_1_net_0[1] = GPIO_OUT_net_0[1:1];
assign GPIO_OUT_2_net_0[2] = GPIO_OUT_net_0[2:2];
assign GPIO_OUT_3_net_0[3] = GPIO_OUT_net_0[3:3];
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PADDR_0 = { FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PADDR_0_7to0 };
assign FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PADDR_0_7to0 = FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PADDR[7:0];

assign FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_0 = { FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_0_7to0 };
assign FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_0_7to0 = FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR[7:0];
assign FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_1 = { FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_1_28to0 };
assign FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_1_28to0 = FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR[28:0];

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------GPIO
GPIO COREGPIO_C0(
        // Inputs
        .PRESETN  ( PRESETN ),
        .PCLK     ( PCLK ),
        .PSEL     ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PSELx ),
        .PENABLE  ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PENABLE ),
        .PWRITE   ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PWRITE ),
        .GPIO_IN  ( GPIO_IN_const_net_0 ),
        .PADDR    ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PADDR_0 ),
        .PWDATA   ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PWDATA ),
        // Outputs
        .PREADY   ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PREADY ),
        .PSLVERR  ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PSLVERR ),
        .INT      (  ),
        .GPIO_OUT ( GPIO_OUT_net_0 ),
        .PRDATA   ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PRDATA ) 
        );

//--------fabric_sd_emmc_demux_select
fabric_sd_emmc_demux_select fabric_sd_emmc_demux_select_0(
        // Inputs
        .pclk                            ( PCLK ),
        .presetn                         ( PRESETN ),
        .penable                         ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PENABLE ),
        .psel                            ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PSELx ),
        .pwrite                          ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PWRITE ),
        .paddr                           ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_0 ),
        .pwdata                          ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PWDATA ),
        // Outputs
        .pready                          ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PREADY ),
        .pslverr                         ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PSLVERR ),
        .fabric_sd_emmc_demux_select_out ( fabric_sd_emmc_demux_select_out_net_0 ),
        .prdata                          ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PRDATA ) 
        );

//--------FIC_3_ADDRESS_GENERATION
FIC_3_ADDRESS_GENERATION FIC_3_ADDRESS_GENERATION_1(
        // Inputs
        .APB_MASTER_high_out_high_pready  ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PREADY ),
        .APB_MASTER_high_out_high_pslverr ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PSLVERR ),
        .APB_MMASTER_in_penable           ( APB_MMASTER_in_penable ),
        .APB_MMASTER_in_psel              ( APB_MMASTER_in_psel ),
        .APB_MMASTER_in_pwrite            ( APB_MMASTER_in_pwrite ),
        .APBmslave15_PREADYS15            ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PREADY ),
        .APBmslave15_PSLVERRS15           ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PSLVERR ),
        .APBmslave1_PREADYS1              ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PREADY ),
        .APBmslave1_PSLVERRS1             ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PSLVERR ),
        .APBmslave3_PREADYS3              ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PREADY ),
        .APBmslave3_PSLVERRS3             ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PSLVERR ),
        .APB_MASTER_high_out_high_prdata  ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PRDATA ),
        .APB_MMASTER_in_paddr             ( APB_MMASTER_in_paddr ),
        .APB_MMASTER_in_pwdata            ( APB_MMASTER_in_pwdata ),
        .APBmslave15_PRDATAS15            ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PRDATA ),
        .APBmslave1_PRDATAS1              ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PRDATA ),
        .APBmslave3_PRDATAS3              ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PRDATA ),
        // Outputs
        .APB_MASTER_high_out_high_penable ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PENABLE ),
        .APB_MASTER_high_out_high_psel    ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PSELx ),
        .APB_MASTER_high_out_high_pwrite  ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PWRITE ),
        .APB_MMASTER_in_pready            ( APB_MMASTER_PREADY ),
        .APB_MMASTER_in_pslverr           ( APB_MMASTER_PSLVERR ),
        .APBmslave15_PENABLES             ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PENABLE ),
        .APBmslave15_PSELS15              ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PSELx ),
        .APBmslave15_PWRITES              ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PWRITE ),
        .APBmslave1_PSELS1                ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PSELx ),
        .APBmslave0_PENABLES              ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PENABLE ),
        .APBmslave0_PWRITES               ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PWRITE ),
        .APBmslave3_PSELS3                ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PSELx ),
        .APB_MASTER_high_out_high_paddr   ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PADDR ),
        .APB_MASTER_high_out_high_pwdata  ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PWDATA ),
        .APB_MMASTER_in_prdata            ( APB_MMASTER_PRDATA ),
        .APBmslave15_PADDRS               ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PADDR ),
        .APBmslave15_PWDATAS              ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4FFF_FFxx_PWDATA ),
        .APBmslave0_PADDRS                ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR ),
        .APBmslave0_PWDATAS               ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PWDATA ) 
        );

//--------IHC_SUBSYSTEM
IHC_SUBSYSTEM IHC_SUBSYSTEM_0(
        // Inputs
        .PENABLE   ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PENABLE ),
        .PSEL      ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PSELx ),
        .PWRITE    ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PWRITE ),
        .pclk      ( PCLK ),
        .presetn   ( PRESETN ),
        .PADDR     ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PADDR ),
        .PWDATA    ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PWDATA ),
        // Outputs
        .E51_IRQ   ( IHC_SUBSYSTEM_E51_IRQ_net_0 ),
        .PREADY    ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PREADY ),
        .PSLVERR   ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PSLVERR ),
        .U54_1_IRQ ( IHC_SUBSYSTEM_U54_1_IRQ_net_0 ),
        .U54_2_IRQ ( IHC_SUBSYSTEM_U54_2_IRQ_net_0 ),
        .U54_3_IRQ ( IHC_SUBSYSTEM_U54_3_IRQ_net_0 ),
        .U54_4_IRQ ( IHC_SUBSYSTEM_U54_4_IRQ_net_0 ),
        .PRDATA    ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x5xxx_xxxx_PRDATA ) 
        );

//--------RECONFIGURATION_INTERFACE
RECONFIGURATION_INTERFACE RECONFIGURATION_INTERFACE_0(
        // Inputs
        .PCLK                   ( PCLK ),
        .PRESETN                ( PRESETN ),
        .Q0_LANE0_DRI_INTERRUPT ( Q0_LANE0_DRI_INTERRUPT ),
        .Q0_LANE1_DRI_INTERRUPT ( Q0_LANE1_DRI_INTERRUPT ),
        .Q0_LANE2_DRI_INTERRUPT ( Q0_LANE2_DRI_INTERRUPT ),
        .Q0_LANE3_DRI_INTERRUPT ( Q0_LANE3_DRI_INTERRUPT ),
        .PLL0_SW_DRI_INTERRUPT  ( PLL0_SW_DRI_INTERRUPT ),
        .PSEL                   ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PSELx ),
        .PENABLE                ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PENABLE ),
        .PWRITE                 ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PWRITE ),
        .PSTRB                  ( PSTRB ),
        .Q0_LANE0_DRI_RDATA     ( Q0_LANE0_DRI_RDATA ),
        .Q0_LANE1_DRI_RDATA     ( Q0_LANE1_DRI_RDATA ),
        .Q0_LANE2_DRI_RDATA     ( Q0_LANE2_DRI_RDATA ),
        .Q0_LANE3_DRI_RDATA     ( Q0_LANE3_DRI_RDATA ),
        .PLL0_SW_DRI_RDATA      ( PLL0_SW_DRI_RDATA ),
        .PADDR                  ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PADDR_1 ),
        .PWDATA                 ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_01xx_PWDATA ),
        // Outputs
        .PINTERRUPT             (  ),
        .PTIMEOUT               (  ),
        .BUSERROR               (  ),
        .DRI_CLK                ( PLL0_SW_DRI_DRI_CLK ),
        .DRI_ARST_N             ( PLL0_SW_DRI_DRI_ARST_N ),
        .PREADY                 ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PREADY ),
        .PSLVERR                ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PSLVERR ),
        .DRI_WDATA              ( PLL0_SW_DRI_DRI_WDATA ),
        .Q0_LANE0_DRI_CTRL      ( Q0_LANE0_DRI_DRI_CTRL ),
        .Q0_LANE1_DRI_CTRL      ( Q0_LANE1_DRI_DRI_CTRL ),
        .Q0_LANE2_DRI_CTRL      ( Q0_LANE2_DRI_DRI_CTRL ),
        .Q0_LANE3_DRI_CTRL      ( Q0_LANE3_DRI_DRI_CTRL ),
        .PLL0_SW_DRI_CTRL       ( PLL0_SW_DRI_DRI_CTRL ),
        .PRDATA                 ( FIC_3_ADDRESS_GENERATION_1_FIC_3_0x4000_03xx_PRDATA ) 
        );


endmodule
