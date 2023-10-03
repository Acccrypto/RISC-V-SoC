//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec 12 18:35:15 2022
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of GLITCHLESS_MUX to TCL
# Family: PolarFireSoC
# Part Number: MPFS250T_ES-FCVG484E
# Create and Configure the core component GLITCHLESS_MUX
create_and_configure_core -core_vlnv {Actel:SgCore:PF_NGMUX:1.0.101} -component_name {GLITCHLESS_MUX} -params {\
"ENABLE_NON_TOGGLING_CLK_SWITCH_SUPPORT:false"   }
# Exporting Component Description of GLITCHLESS_MUX to TCL done
*/

// GLITCHLESS_MUX
module GLITCHLESS_MUX(
    // Inputs
    CLK0,
    CLK1,
    SEL,
    // Outputs
    CLK_OUT
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  CLK0;
input  CLK1;
input  SEL;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output CLK_OUT;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   CLK0;
wire   CLK1;
wire   CLK_OUT_net_0;
wire   SEL;
wire   CLK_OUT_net_1;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign CLK_OUT_net_1 = CLK_OUT_net_0;
assign CLK_OUT       = CLK_OUT_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------GLITCHLESS_MUX_GLITCHLESS_MUX_0_PF_NGMUX   -   Actel:SgCore:PF_NGMUX:1.0.101
GLITCHLESS_MUX_GLITCHLESS_MUX_0_PF_NGMUX GLITCHLESS_MUX_0(
        // Inputs
        .CLK0    ( CLK0 ),
        .CLK1    ( CLK1 ),
        .SEL     ( SEL ),
        // Outputs
        .CLK_OUT ( CLK_OUT_net_0 ) 
        );


endmodule
