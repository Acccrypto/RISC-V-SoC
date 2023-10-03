//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec 12 18:35:31 2022
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// CLOCKS_AND_RESETS
module CLOCKS_AND_RESETS(
    // Inputs
    EXT_RST_N,
    MSS_PLL_LOCKS,
    REF_CLK_50MHz,
    REF_CLK_PAD_N,
    REF_CLK_PAD_P,
    // Outputs
    BIT_CLK,
    FIC_0_CLK,
    FIC_1_CLK,
    FIC_2_CLK,
    FIC_3_CLK,
    LOCK,
    PCIE_INIT_DONE,
    PCIe_CLK_125MHz,
    PCIe_REFERENCE_CLK,
    REF_CLK_TO_LANE,
    RESETN_FIC2_CLK,
    RESETN_FIC_0_CLK,
    RESETN_FIC_1_CLK,
    RESETN_FIC_3_CLK
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  EXT_RST_N;
input  MSS_PLL_LOCKS;
input  REF_CLK_50MHz;
input  REF_CLK_PAD_N;
input  REF_CLK_PAD_P;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output BIT_CLK;
output FIC_0_CLK;
output FIC_1_CLK;
output FIC_2_CLK;
output FIC_3_CLK;
output LOCK;
output PCIE_INIT_DONE;
output PCIe_CLK_125MHz;
output PCIe_REFERENCE_CLK;
output REF_CLK_TO_LANE;
output RESETN_FIC2_CLK;
output RESETN_FIC_0_CLK;
output RESETN_FIC_1_CLK;
output RESETN_FIC_3_CLK;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   AND4_0_Y;
wire   CCC_FIC_x_CLK_PLL_LOCK_0;
wire   CLK_160MHz_to_CLK_80MHz_CLK_OUT;
wire   CLKINT_REF_CLK_50MHz_Y;
wire   CLKS_TO_XCVR_BIT_CLK;
wire   CLKS_TO_XCVR_LOCK;
wire   CLKS_TO_XCVR_REF_CLK_TO_LANE;
wire   EXT_RST_N;
wire   EXTERNAL_RESETN_Y;
wire   FIC_0_CLK_net_0;
wire   FIC_1_CLK_net_0;
wire   FIC_2_CLK_net_0;
wire   FIC_3_CLK_net_0;
wire   INIT_MONITOR_0_DEVICE_INIT_DONE;
wire   INIT_MONITOR_0_FABRIC_POR_N;
wire   MSS_PLL_LOCKS;
wire   OSCILLATOR_160MHz_RCOSC_160MHZ_CLK_DIV;
wire   PCIe_CLK_125MHz_net_0;
wire   PCIe_CLK_LOCK_Y;
wire   PCIE_INIT_DONE_net_0;
wire   PCIe_REFERENCE_CLK_net_0;
wire   REF_CLK_50MHz;
wire   REF_CLK_PAD_N;
wire   REF_CLK_PAD_P;
wire   RESET_FIC_0_CLK_PLL_POWERDOWN_B;
wire   RESET_FIC_1_CLK_PLL_POWERDOWN_B;
wire   RESET_FIC_2_CLK_PLL_POWERDOWN_B;
wire   RESET_FIC_3_CLK_PLL_POWERDOWN_B;
wire   RESETN_FIC2_CLK_net_0;
wire   RESETN_FIC_0_CLK_net_0;
wire   RESETN_FIC_1_CLK_net_0;
wire   RESETN_FIC_3_CLK_net_0;
wire   TRANSMIT_PLL_0_CLK_125;
wire   TRANSMIT_PLL_0_PLL_LOCK;
wire   CLKS_TO_XCVR_BIT_CLK_net_0;
wire   FIC_0_CLK_net_1;
wire   FIC_1_CLK_net_1;
wire   FIC_2_CLK_net_1;
wire   FIC_3_CLK_net_1;
wire   CLKS_TO_XCVR_LOCK_net_0;
wire   PCIE_INIT_DONE_net_1;
wire   PCIe_CLK_125MHz_net_1;
wire   PCIe_REFERENCE_CLK_net_1;
wire   CLKS_TO_XCVR_REF_CLK_TO_LANE_net_0;
wire   RESETN_FIC2_CLK_net_1;
wire   RESETN_FIC_0_CLK_net_1;
wire   RESETN_FIC_1_CLK_net_1;
wire   RESETN_FIC_3_CLK_net_1;
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
assign CLKS_TO_XCVR_BIT_CLK_net_0         = CLKS_TO_XCVR_BIT_CLK;
assign BIT_CLK                            = CLKS_TO_XCVR_BIT_CLK_net_0;
assign FIC_0_CLK_net_1                    = FIC_0_CLK_net_0;
assign FIC_0_CLK                          = FIC_0_CLK_net_1;
assign FIC_1_CLK_net_1                    = FIC_1_CLK_net_0;
assign FIC_1_CLK                          = FIC_1_CLK_net_1;
assign FIC_2_CLK_net_1                    = FIC_2_CLK_net_0;
assign FIC_2_CLK                          = FIC_2_CLK_net_1;
assign FIC_3_CLK_net_1                    = FIC_3_CLK_net_0;
assign FIC_3_CLK                          = FIC_3_CLK_net_1;
assign CLKS_TO_XCVR_LOCK_net_0            = CLKS_TO_XCVR_LOCK;
assign LOCK                               = CLKS_TO_XCVR_LOCK_net_0;
assign PCIE_INIT_DONE_net_1               = PCIE_INIT_DONE_net_0;
assign PCIE_INIT_DONE                     = PCIE_INIT_DONE_net_1;
assign PCIe_CLK_125MHz_net_1              = PCIe_CLK_125MHz_net_0;
assign PCIe_CLK_125MHz                    = PCIe_CLK_125MHz_net_1;
assign PCIe_REFERENCE_CLK_net_1           = PCIe_REFERENCE_CLK_net_0;
assign PCIe_REFERENCE_CLK                 = PCIe_REFERENCE_CLK_net_1;
assign CLKS_TO_XCVR_REF_CLK_TO_LANE_net_0 = CLKS_TO_XCVR_REF_CLK_TO_LANE;
assign REF_CLK_TO_LANE                    = CLKS_TO_XCVR_REF_CLK_TO_LANE_net_0;
assign RESETN_FIC2_CLK_net_1              = RESETN_FIC2_CLK_net_0;
assign RESETN_FIC2_CLK                    = RESETN_FIC2_CLK_net_1;
assign RESETN_FIC_0_CLK_net_1             = RESETN_FIC_0_CLK_net_0;
assign RESETN_FIC_0_CLK                   = RESETN_FIC_0_CLK_net_1;
assign RESETN_FIC_1_CLK_net_1             = RESETN_FIC_1_CLK_net_0;
assign RESETN_FIC_1_CLK                   = RESETN_FIC_1_CLK_net_1;
assign RESETN_FIC_3_CLK_net_1             = RESETN_FIC_3_CLK_net_0;
assign RESETN_FIC_3_CLK                   = RESETN_FIC_3_CLK_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------AND4
AND4 AND4_0(
        // Inputs
        .A ( RESET_FIC_0_CLK_PLL_POWERDOWN_B ),
        .B ( RESET_FIC_1_CLK_PLL_POWERDOWN_B ),
        .C ( RESET_FIC_2_CLK_PLL_POWERDOWN_B ),
        .D ( RESET_FIC_3_CLK_PLL_POWERDOWN_B ),
        // Outputs
        .Y ( AND4_0_Y ) 
        );

//--------PF_CCC_C0
PF_CCC_C0 CCC_FIC_x_CLK(
        // Inputs
        .REF_CLK_0         ( CLKINT_REF_CLK_50MHz_Y ),
        .PLL_POWERDOWN_N_0 ( AND4_0_Y ),
        // Outputs
        .OUT0_FABCLK_0     ( FIC_0_CLK_net_0 ),
        .OUT1_FABCLK_0     ( FIC_1_CLK_net_0 ),
        .OUT2_FABCLK_0     ( FIC_2_CLK_net_0 ),
        .OUT3_FABCLK_0     ( FIC_3_CLK_net_0 ),
        .PLL_LOCK_0        ( CCC_FIC_x_CLK_PLL_LOCK_0 ) 
        );

//--------CLK_DIV
CLK_DIV CLK_160MHz_to_CLK_80MHz(
        // Inputs
        .CLK_IN  ( OSCILLATOR_160MHz_RCOSC_160MHZ_CLK_DIV ),
        // Outputs
        .CLK_OUT ( CLK_160MHz_to_CLK_80MHz_CLK_OUT ) 
        );

//--------CLKINT
CLKINT CLKINT_REF_CLK_50MHz(
        // Inputs
        .A ( REF_CLK_50MHz ),
        // Outputs
        .Y ( CLKINT_REF_CLK_50MHz_Y ) 
        );

//--------AND3
AND3 EXTERNAL_RESETN(
        // Inputs
        .A ( EXT_RST_N ),
        .B ( MSS_PLL_LOCKS ),
        .C ( TRANSMIT_PLL_0_PLL_LOCK ),
        // Outputs
        .Y ( EXTERNAL_RESETN_Y ) 
        );

//--------GLITCHLESS_MUX
GLITCHLESS_MUX GLITCHLESS_MUX_inst_0(
        // Inputs
        .CLK0    ( CLK_160MHz_to_CLK_80MHz_CLK_OUT ),
        .CLK1    ( TRANSMIT_PLL_0_CLK_125 ),
        .SEL     ( PCIe_CLK_LOCK_Y ),
        // Outputs
        .CLK_OUT ( PCIe_CLK_125MHz_net_0 ) 
        );

//--------INIT_MONITOR
INIT_MONITOR INIT_MONITOR_0(
        // Outputs
        .FABRIC_POR_N               ( INIT_MONITOR_0_FABRIC_POR_N ),
        .PCIE_INIT_DONE             ( PCIE_INIT_DONE_net_0 ),
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

//--------OSCILLATOR_160MHz
OSCILLATOR_160MHz OSCILLATOR_160MHz_inst_0(
        // Outputs
        .RCOSC_160MHZ_GL      (  ),
        .RCOSC_160MHZ_CLK_DIV ( OSCILLATOR_160MHz_RCOSC_160MHZ_CLK_DIV ) 
        );

//--------AND2
AND2 PCIe_CLK_LOCK(
        // Inputs
        .A ( TRANSMIT_PLL_0_PLL_LOCK ),
        .B ( PCIE_INIT_DONE_net_0 ),
        // Outputs
        .Y ( PCIe_CLK_LOCK_Y ) 
        );

//--------PCIE_REF_CLK
PCIE_REF_CLK PCIE_REF_CLK_0(
        // Inputs
        .REF_CLK_PAD_P ( REF_CLK_PAD_P ),
        .REF_CLK_PAD_N ( REF_CLK_PAD_N ),
        // Outputs
        .REF_CLK       ( PCIe_REFERENCE_CLK_net_0 ) 
        );

//--------CORERESET
CORERESET RESET_FIC_0_CLK(
        // Inputs
        .CLK                ( FIC_0_CLK_net_0 ),
        .EXT_RST_N          ( EXTERNAL_RESETN_Y ),
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

//--------CORERESET
CORERESET RESET_FIC_1_CLK(
        // Inputs
        .CLK                ( FIC_1_CLK_net_0 ),
        .EXT_RST_N          ( EXTERNAL_RESETN_Y ),
        .BANK_x_VDDI_STATUS ( VCC_net ),
        .BANK_y_VDDI_STATUS ( VCC_net ),
        .PLL_LOCK           ( CCC_FIC_x_CLK_PLL_LOCK_0 ),
        .SS_BUSY            ( GND_net ),
        .INIT_DONE          ( INIT_MONITOR_0_DEVICE_INIT_DONE ),
        .FF_US_RESTORE      ( GND_net ),
        .FPGA_POR_N         ( INIT_MONITOR_0_FABRIC_POR_N ),
        // Outputs
        .PLL_POWERDOWN_B    ( RESET_FIC_1_CLK_PLL_POWERDOWN_B ),
        .FABRIC_RESET_N     ( RESETN_FIC_1_CLK_net_0 ) 
        );

//--------CORERESET
CORERESET RESET_FIC_2_CLK(
        // Inputs
        .CLK                ( FIC_2_CLK_net_0 ),
        .EXT_RST_N          ( EXTERNAL_RESETN_Y ),
        .BANK_x_VDDI_STATUS ( VCC_net ),
        .BANK_y_VDDI_STATUS ( VCC_net ),
        .PLL_LOCK           ( CCC_FIC_x_CLK_PLL_LOCK_0 ),
        .SS_BUSY            ( GND_net ),
        .INIT_DONE          ( INIT_MONITOR_0_DEVICE_INIT_DONE ),
        .FF_US_RESTORE      ( GND_net ),
        .FPGA_POR_N         ( INIT_MONITOR_0_FABRIC_POR_N ),
        // Outputs
        .PLL_POWERDOWN_B    ( RESET_FIC_2_CLK_PLL_POWERDOWN_B ),
        .FABRIC_RESET_N     ( RESETN_FIC2_CLK_net_0 ) 
        );

//--------CORERESET
CORERESET RESET_FIC_3_CLK(
        // Inputs
        .CLK                ( FIC_3_CLK_net_0 ),
        .EXT_RST_N          ( EXTERNAL_RESETN_Y ),
        .BANK_x_VDDI_STATUS ( VCC_net ),
        .BANK_y_VDDI_STATUS ( VCC_net ),
        .PLL_LOCK           ( CCC_FIC_x_CLK_PLL_LOCK_0 ),
        .SS_BUSY            ( GND_net ),
        .INIT_DONE          ( INIT_MONITOR_0_DEVICE_INIT_DONE ),
        .FF_US_RESTORE      ( GND_net ),
        .FPGA_POR_N         ( INIT_MONITOR_0_FABRIC_POR_N ),
        // Outputs
        .PLL_POWERDOWN_B    ( RESET_FIC_3_CLK_PLL_POWERDOWN_B ),
        .FABRIC_RESET_N     ( RESETN_FIC_3_CLK_net_0 ) 
        );

//--------TRANSMIT_PLL
TRANSMIT_PLL TRANSMIT_PLL_0(
        // Inputs
        .REF_CLK         ( PCIe_REFERENCE_CLK_net_0 ),
        // Outputs
        .PLL_LOCK        ( TRANSMIT_PLL_0_PLL_LOCK ),
        .LOCK            ( CLKS_TO_XCVR_LOCK ),
        .BIT_CLK         ( CLKS_TO_XCVR_BIT_CLK ),
        .REF_CLK_TO_LANE ( CLKS_TO_XCVR_REF_CLK_TO_LANE ),
        .CLK_125         ( TRANSMIT_PLL_0_CLK_125 ) 
        );


endmodule
