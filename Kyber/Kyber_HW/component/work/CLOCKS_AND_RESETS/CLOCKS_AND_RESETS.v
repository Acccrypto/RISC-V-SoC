//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Sun Nov 26 16:30:28 2023
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// CLOCKS_AND_RESETS
module CLOCKS_AND_RESETS(
    // Inputs
    EXT_RST_N,
    MSS_PLL_LOCKS,
    REF_CLK_50MHz,
    // Outputs
    FIC_0_CLK,
    FIC_1_CLK,
    FIC_2_CLK,
    FIC_3_CLK,
    RESETN_FIC_0_CLK
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  EXT_RST_N;
input  MSS_PLL_LOCKS;
input  REF_CLK_50MHz;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output FIC_0_CLK;
output FIC_1_CLK;
output FIC_2_CLK;
output FIC_3_CLK;
output RESETN_FIC_0_CLK;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   CCC_FIC_x_CLK_PLL_LOCK_0;
wire   CLKINT_REF_CLK_50MHz_Y;
wire   EXT_RST_N;
wire   EXTERNAL_RESETN_0_Y;
wire   FIC_0_CLK_net_0;
wire   FIC_1_CLK_net_0;
wire   FIC_2_CLK_net_0;
wire   FIC_3_CLK_net_0;
wire   INIT_MONITOR_0_DEVICE_INIT_DONE;
wire   INIT_MONITOR_0_FABRIC_POR_N;
wire   MSS_PLL_LOCKS;
wire   REF_CLK_50MHz;
wire   RESET_FIC_0_CLK_PLL_POWERDOWN_B;
wire   RESETN_FIC_0_CLK_net_0;
wire   FIC_0_CLK_net_1;
wire   FIC_1_CLK_net_1;
wire   FIC_2_CLK_net_1;
wire   FIC_3_CLK_net_1;
wire   RESETN_FIC_0_CLK_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   VCC_net;
wire   GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net = 1'b1;
assign GND_net = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign FIC_0_CLK_net_1        = FIC_0_CLK_net_0;
assign FIC_0_CLK              = FIC_0_CLK_net_1;
assign FIC_1_CLK_net_1        = FIC_1_CLK_net_0;
assign FIC_1_CLK              = FIC_1_CLK_net_1;
assign FIC_2_CLK_net_1        = FIC_2_CLK_net_0;
assign FIC_2_CLK              = FIC_2_CLK_net_1;
assign FIC_3_CLK_net_1        = FIC_3_CLK_net_0;
assign FIC_3_CLK              = FIC_3_CLK_net_1;
assign RESETN_FIC_0_CLK_net_1 = RESETN_FIC_0_CLK_net_0;
assign RESETN_FIC_0_CLK       = RESETN_FIC_0_CLK_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------PF_CCC_C0
PF_CCC_C0 CCC_FIC_x_CLK(
        // Inputs
        .REF_CLK_0         ( CLKINT_REF_CLK_50MHz_Y ),
        .PLL_POWERDOWN_N_0 ( RESET_FIC_0_CLK_PLL_POWERDOWN_B ),
        // Outputs
        .OUT0_FABCLK_0     ( FIC_0_CLK_net_0 ),
        .OUT1_FABCLK_0     ( FIC_1_CLK_net_0 ),
        .OUT2_FABCLK_0     ( FIC_2_CLK_net_0 ),
        .OUT3_FABCLK_0     ( FIC_3_CLK_net_0 ),
        .PLL_LOCK_0        ( CCC_FIC_x_CLK_PLL_LOCK_0 ) 
        );

//--------CLKINT
CLKINT CLKINT_REF_CLK_50MHz(
        // Inputs
        .A ( REF_CLK_50MHz ),
        // Outputs
        .Y ( CLKINT_REF_CLK_50MHz_Y ) 
        );

//--------AND2
AND2 EXTERNAL_RESETN(
        // Inputs
        .A ( EXT_RST_N ),
        .B ( MSS_PLL_LOCKS ),
        // Outputs
        .Y ( EXTERNAL_RESETN_0_Y ) 
        );

//--------INIT_MONITOR
INIT_MONITOR INIT_MONITOR_0(
        // Outputs
        .FABRIC_POR_N               ( INIT_MONITOR_0_FABRIC_POR_N ),
        .PCIE_INIT_DONE             (  ),
        .USRAM_INIT_DONE            (  ),
        .SRAM_INIT_DONE             (  ),
        .DEVICE_INIT_DONE           ( INIT_MONITOR_0_DEVICE_INIT_DONE ),
        .XCVR_INIT_DONE             (  ),
        .USRAM_INIT_FROM_SNVM_DONE  (  ),
        .USRAM_INIT_FROM_UPROM_DONE (  ),
        .USRAM_INIT_FROM_SPI_DONE   (  ),
        .SRAM_INIT_FROM_SNVM_DONE   (  ),
        .SRAM_INIT_FROM_UPROM_DONE  (  ),
        .SRAM_INIT_FROM_SPI_DONE    (  ),
        .AUTOCALIB_DONE             (  ) 
        );

//--------CORERESET
CORERESET RESET_FIC_0_CLK(
        // Inputs
        .CLK                ( FIC_0_CLK_net_0 ),
        .EXT_RST_N          ( EXTERNAL_RESETN_0_Y ),
        .BANK_x_VDDI_STATUS ( VCC_net ),
        .BANK_y_VDDI_STATUS ( VCC_net ),
        .PLL_LOCK           ( CCC_FIC_x_CLK_PLL_LOCK_0 ),
        .SS_BUSY            ( GND_net ),
        .INIT_DONE          ( INIT_MONITOR_0_DEVICE_INIT_DONE ),
        .FF_US_RESTORE      ( GND_net ),
        .FPGA_POR_N         ( INIT_MONITOR_0_FABRIC_POR_N ),
        // Outputs
        .PLL_POWERDOWN_B    ( RESET_FIC_0_CLK_PLL_POWERDOWN_B ),
        .FABRIC_RESET_N     ( RESETN_FIC_0_CLK_net_0 ) 
        );


endmodule
