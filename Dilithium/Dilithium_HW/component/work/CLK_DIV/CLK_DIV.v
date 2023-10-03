//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec 12 18:35:13 2022
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of CLK_DIV to TCL
# Family: PolarFireSoC
# Part Number: MPFS250T_ES-FCVG484E
# Create and Configure the core component CLK_DIV
create_and_configure_core -core_vlnv {Actel:SgCore:PF_CLK_DIV:1.0.103} -component_name {CLK_DIV} -params {\
"DIVIDER:2"  \
"ENABLE_BIT_SLIP:false"  \
"ENABLE_SRESET:false"   }
# Exporting Component Description of CLK_DIV to TCL done
*/

// CLK_DIV
module CLK_DIV(
    // Inputs
    CLK_IN,
    // Outputs
    CLK_OUT
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  CLK_IN;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output CLK_OUT;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   CLK_IN;
wire   CLK_OUT_net_0;
wire   CLK_OUT_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign CLK_OUT_net_1 = CLK_OUT_net_0;
assign CLK_OUT       = CLK_OUT_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CLK_DIV_CLK_DIV_0_PF_CLK_DIV   -   Actel:SgCore:PF_CLK_DIV:1.0.103
CLK_DIV_CLK_DIV_0_PF_CLK_DIV CLK_DIV_0(
        // Inputs
        .CLK_IN  ( CLK_IN ),
        // Outputs
        .CLK_OUT ( CLK_OUT_net_0 ) 
        );


endmodule
