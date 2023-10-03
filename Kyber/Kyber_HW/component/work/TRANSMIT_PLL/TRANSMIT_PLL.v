//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec 12 18:35:22 2022
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of TRANSMIT_PLL to TCL
# Family: PolarFireSoC
# Part Number: MPFS250T_ES-FCVG484E
# Create and Configure the core component TRANSMIT_PLL
create_and_configure_core -core_vlnv {Actel:SgCore:PF_TX_PLL:2.0.300} -component_name {TRANSMIT_PLL} -params {\
"CORE:PF_TX_PLL"  \
"INIT:0x0"  \
"TxPLL_AUX_LOW_SEL:true"  \
"TxPLL_AUX_OUT:125"  \
"TxPLL_BANDWIDTH:Low"  \
"TxPLL_CLK_125_EN:true"  \
"TxPLL_DYNAMIC_RECONFIG_INTERFACE_EN:false"  \
"TxPLL_EXT_WAVE_SEL:0"  \
"TxPLL_FAB_LOCK_EN:false"  \
"TxPLL_FAB_REF:200"  \
"TxPLL_INTEGER_MODE:false"  \
"TxPLL_JITTER_MODE_AT_POWERUP:true"  \
"TxPLL_JITTER_MODE_CUT_OFF_FREQ:5000"  \
"TxPLL_JITTER_MODE_OPTIMIZE_FOR:0"  \
"TxPLL_JITTER_MODE_REFCLK_FREQ:125"  \
"TxPLL_JITTER_MODE_REFCLK_SEL:DEDICATED"  \
"TxPLL_JITTER_MODE_SEL:10G"  \
"TxPLL_JITTER_MODE_WANDER:15"  \
"TxPLL_MODE:NORMAL"  \
"TxPLL_OUT:2500.000"  \
"TxPLL_REF:100"  \
"TxPLL_RN_FILTER:false"  \
"TxPLL_SOURCE:DEDICATED"  \
"TxPLL_SSM_DEPTH:0"  \
"TxPLL_SSM_DIVVAL:1"  \
"TxPLL_SSM_DOWN_SPREAD:false"  \
"TxPLL_SSM_FREQ:64"  \
"TxPLL_SSM_RAND_PATTERN:0"  \
"VCOFREQUENCY:1600"   }
# Exporting Component Description of TRANSMIT_PLL to TCL done
*/

// TRANSMIT_PLL
module TRANSMIT_PLL(
    // Inputs
    REF_CLK,
    // Outputs
    BIT_CLK,
    CLK_125,
    LOCK,
    PLL_LOCK,
    REF_CLK_TO_LANE
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  REF_CLK;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output BIT_CLK;
output CLK_125;
output LOCK;
output PLL_LOCK;
output REF_CLK_TO_LANE;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   CLK_125_net_0;
wire   CLKS_TO_XCVR_BIT_CLK;
wire   CLKS_TO_XCVR_LOCK;
wire   CLKS_TO_XCVR_REF_CLK_TO_LANE;
wire   PLL_LOCK_net_0;
wire   REF_CLK;
wire   PLL_LOCK_net_1;
wire   CLKS_TO_XCVR_LOCK_net_0;
wire   CLKS_TO_XCVR_BIT_CLK_net_0;
wire   CLKS_TO_XCVR_REF_CLK_TO_LANE_net_0;
wire   CLK_125_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   GND_net;
wire   [10:0]DRI_CTRL_const_net_0;
wire   [32:0]DRI_WDATA_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net               = 1'b0;
assign DRI_CTRL_const_net_0  = 11'h000;
assign DRI_WDATA_const_net_0 = 33'h000000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign PLL_LOCK_net_1                     = PLL_LOCK_net_0;
assign PLL_LOCK                           = PLL_LOCK_net_1;
assign CLKS_TO_XCVR_LOCK_net_0            = CLKS_TO_XCVR_LOCK;
assign LOCK                               = CLKS_TO_XCVR_LOCK_net_0;
assign CLKS_TO_XCVR_BIT_CLK_net_0         = CLKS_TO_XCVR_BIT_CLK;
assign BIT_CLK                            = CLKS_TO_XCVR_BIT_CLK_net_0;
assign CLKS_TO_XCVR_REF_CLK_TO_LANE_net_0 = CLKS_TO_XCVR_REF_CLK_TO_LANE;
assign REF_CLK_TO_LANE                    = CLKS_TO_XCVR_REF_CLK_TO_LANE_net_0;
assign CLK_125_net_1                      = CLK_125_net_0;
assign CLK_125                            = CLK_125_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------TRANSMIT_PLL_TRANSMIT_PLL_0_PF_TX_PLL   -   Actel:SgCore:PF_TX_PLL:2.0.300
TRANSMIT_PLL_TRANSMIT_PLL_0_PF_TX_PLL TRANSMIT_PLL_0(
        // Inputs
        .REF_CLK         ( REF_CLK ),
        // Outputs
        .LOCK            ( CLKS_TO_XCVR_LOCK ),
        .BIT_CLK         ( CLKS_TO_XCVR_BIT_CLK ),
        .CLK_125         ( CLK_125_net_0 ),
        .REF_CLK_TO_LANE ( CLKS_TO_XCVR_REF_CLK_TO_LANE ),
        .PLL_LOCK        ( PLL_LOCK_net_0 ) 
        );


endmodule
