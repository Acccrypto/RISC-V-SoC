//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec 12 18:35:17 2022
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of OSCILLATOR_160MHz to TCL
# Family: PolarFireSoC
# Part Number: MPFS250T_ES-FCVG484E
# Create and Configure the core component OSCILLATOR_160MHz
create_and_configure_core -core_vlnv {Actel:SgCore:PF_OSC:1.0.102} -component_name {OSCILLATOR_160MHz} -params {\
"RCOSC_2MHZ_CLK_DIV_EN:false"  \
"RCOSC_2MHZ_GL_EN:false"  \
"RCOSC_2MHZ_NGMUX_EN:false"  \
"RCOSC_160MHZ_CLK_DIV_EN:true"  \
"RCOSC_160MHZ_GL_EN:true"  \
"RCOSC_160MHZ_NGMUX_EN:false"   }
# Exporting Component Description of OSCILLATOR_160MHz to TCL done
*/

// OSCILLATOR_160MHz
module OSCILLATOR_160MHz(
    // Outputs
    RCOSC_160MHZ_CLK_DIV,
    RCOSC_160MHZ_GL
);

//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output RCOSC_160MHZ_CLK_DIV;
output RCOSC_160MHZ_GL;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   RCOSC_160MHZ_CLK_DIV_net_0;
wire   RCOSC_160MHZ_GL_net_0;
wire   RCOSC_160MHZ_GL_net_1;
wire   RCOSC_160MHZ_CLK_DIV_net_1;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign RCOSC_160MHZ_GL_net_1      = RCOSC_160MHZ_GL_net_0;
assign RCOSC_160MHZ_GL            = RCOSC_160MHZ_GL_net_1;
assign RCOSC_160MHZ_CLK_DIV_net_1 = RCOSC_160MHZ_CLK_DIV_net_0;
assign RCOSC_160MHZ_CLK_DIV       = RCOSC_160MHZ_CLK_DIV_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------OSCILLATOR_160MHz_OSCILLATOR_160MHz_0_PF_OSC   -   Actel:SgCore:PF_OSC:1.0.102
OSCILLATOR_160MHz_OSCILLATOR_160MHz_0_PF_OSC OSCILLATOR_160MHz_0(
        // Outputs
        .RCOSC_160MHZ_GL      ( RCOSC_160MHZ_GL_net_0 ),
        .RCOSC_160MHZ_CLK_DIV ( RCOSC_160MHZ_CLK_DIV_net_0 ) 
        );


endmodule
