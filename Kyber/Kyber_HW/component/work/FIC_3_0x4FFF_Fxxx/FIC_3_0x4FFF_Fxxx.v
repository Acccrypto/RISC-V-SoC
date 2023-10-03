//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec 12 18:36:51 2022
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of FIC_3_0x4FFF_Fxxx to TCL
# Family: PolarFireSoC
# Part Number: MPFS250T_ES-FCVG484E
# Create and Configure the core component FIC_3_0x4FFF_Fxxx
create_and_configure_core -core_vlnv {Actel:DirectCore:CoreAPB3:4.2.100} -component_name {FIC_3_0x4FFF_Fxxx} -params {\
"APB_DWIDTH:32"  \
"APBSLOT0ENABLE:false"  \
"APBSLOT1ENABLE:false"  \
"APBSLOT2ENABLE:false"  \
"APBSLOT3ENABLE:false"  \
"APBSLOT4ENABLE:false"  \
"APBSLOT5ENABLE:false"  \
"APBSLOT6ENABLE:false"  \
"APBSLOT7ENABLE:false"  \
"APBSLOT8ENABLE:false"  \
"APBSLOT9ENABLE:false"  \
"APBSLOT10ENABLE:false"  \
"APBSLOT11ENABLE:false"  \
"APBSLOT12ENABLE:false"  \
"APBSLOT13ENABLE:false"  \
"APBSLOT14ENABLE:false"  \
"APBSLOT15ENABLE:true"  \
"IADDR_OPTION:0"  \
"MADDR_BITS:12"  \
"SC_0:false"  \
"SC_1:false"  \
"SC_2:false"  \
"SC_3:false"  \
"SC_4:false"  \
"SC_5:false"  \
"SC_6:false"  \
"SC_7:false"  \
"SC_8:false"  \
"SC_9:false"  \
"SC_10:false"  \
"SC_11:false"  \
"SC_12:false"  \
"SC_13:false"  \
"SC_14:false"  \
"SC_15:false"  \
"UPR_NIBBLE_POSN:6"   }
# Exporting Component Description of FIC_3_0x4FFF_Fxxx to TCL done
*/

// FIC_3_0x4FFF_Fxxx
module FIC_3_0x4FFF_Fxxx(
    // Inputs
    PADDR,
    PENABLE,
    PRDATAS15,
    PREADYS15,
    PSEL,
    PSLVERRS15,
    PWDATA,
    PWRITE,
    // Outputs
    PADDRS,
    PENABLES,
    PRDATA,
    PREADY,
    PSELS15,
    PSLVERR,
    PWDATAS,
    PWRITES
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [31:0] PADDR;
input         PENABLE;
input  [31:0] PRDATAS15;
input         PREADYS15;
input         PSEL;
input         PSLVERRS15;
input  [31:0] PWDATA;
input         PWRITE;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [31:0] PADDRS;
output        PENABLES;
output [31:0] PRDATA;
output        PREADY;
output        PSELS15;
output        PSLVERR;
output [31:0] PWDATAS;
output        PWRITES;
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
wire   [31:0] APBmslave15_PADDR;
wire          APBmslave15_PENABLE;
wire   [31:0] PRDATAS15;
wire          PREADYS15;
wire          APBmslave15_PSELx;
wire          PSLVERRS15;
wire   [31:0] APBmslave15_PWDATA;
wire          APBmslave15_PWRITE;
wire   [31:0] APB3mmaster_PRDATA_net_0;
wire          APB3mmaster_PREADY_net_0;
wire          APB3mmaster_PSLVERR_net_0;
wire   [31:0] APBmslave15_PADDR_net_0;
wire          APBmslave15_PSELx_net_0;
wire          APBmslave15_PENABLE_net_0;
wire          APBmslave15_PWRITE_net_0;
wire   [31:0] APBmslave15_PWDATA_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire          VCC_net;
wire   [31:0] IADDR_const_net_0;
wire   [31:0] PRDATAS0_const_net_0;
wire   [31:0] PRDATAS1_const_net_0;
wire   [31:0] PRDATAS2_const_net_0;
wire   [31:0] PRDATAS3_const_net_0;
wire   [31:0] PRDATAS4_const_net_0;
wire   [31:0] PRDATAS5_const_net_0;
wire   [31:0] PRDATAS6_const_net_0;
wire   [31:0] PRDATAS7_const_net_0;
wire   [31:0] PRDATAS8_const_net_0;
wire   [31:0] PRDATAS9_const_net_0;
wire   [31:0] PRDATAS10_const_net_0;
wire   [31:0] PRDATAS11_const_net_0;
wire   [31:0] PRDATAS12_const_net_0;
wire   [31:0] PRDATAS13_const_net_0;
wire   [31:0] PRDATAS14_const_net_0;
wire   [31:0] PRDATAS16_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net               = 1'b0;
assign VCC_net               = 1'b1;
assign IADDR_const_net_0     = 32'h00000000;
assign PRDATAS0_const_net_0  = 32'h00000000;
assign PRDATAS1_const_net_0  = 32'h00000000;
assign PRDATAS2_const_net_0  = 32'h00000000;
assign PRDATAS3_const_net_0  = 32'h00000000;
assign PRDATAS4_const_net_0  = 32'h00000000;
assign PRDATAS5_const_net_0  = 32'h00000000;
assign PRDATAS6_const_net_0  = 32'h00000000;
assign PRDATAS7_const_net_0  = 32'h00000000;
assign PRDATAS8_const_net_0  = 32'h00000000;
assign PRDATAS9_const_net_0  = 32'h00000000;
assign PRDATAS10_const_net_0 = 32'h00000000;
assign PRDATAS11_const_net_0 = 32'h00000000;
assign PRDATAS12_const_net_0 = 32'h00000000;
assign PRDATAS13_const_net_0 = 32'h00000000;
assign PRDATAS14_const_net_0 = 32'h00000000;
assign PRDATAS16_const_net_0 = 32'h00000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign APB3mmaster_PRDATA_net_0  = APB3mmaster_PRDATA;
assign PRDATA[31:0]              = APB3mmaster_PRDATA_net_0;
assign APB3mmaster_PREADY_net_0  = APB3mmaster_PREADY;
assign PREADY                    = APB3mmaster_PREADY_net_0;
assign APB3mmaster_PSLVERR_net_0 = APB3mmaster_PSLVERR;
assign PSLVERR                   = APB3mmaster_PSLVERR_net_0;
assign APBmslave15_PADDR_net_0   = APBmslave15_PADDR;
assign PADDRS[31:0]              = APBmslave15_PADDR_net_0;
assign APBmslave15_PSELx_net_0   = APBmslave15_PSELx;
assign PSELS15                   = APBmslave15_PSELx_net_0;
assign APBmslave15_PENABLE_net_0 = APBmslave15_PENABLE;
assign PENABLES                  = APBmslave15_PENABLE_net_0;
assign APBmslave15_PWRITE_net_0  = APBmslave15_PWRITE;
assign PWRITES                   = APBmslave15_PWRITE_net_0;
assign APBmslave15_PWDATA_net_0  = APBmslave15_PWDATA;
assign PWDATAS[31:0]             = APBmslave15_PWDATA_net_0;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CoreAPB3   -   Actel:DirectCore:CoreAPB3:4.2.100
CoreAPB3 #( 
        .APB_DWIDTH      ( 32 ),
        .APBSLOT0ENABLE  ( 0 ),
        .APBSLOT1ENABLE  ( 0 ),
        .APBSLOT2ENABLE  ( 0 ),
        .APBSLOT3ENABLE  ( 0 ),
        .APBSLOT4ENABLE  ( 0 ),
        .APBSLOT5ENABLE  ( 0 ),
        .APBSLOT6ENABLE  ( 0 ),
        .APBSLOT7ENABLE  ( 0 ),
        .APBSLOT8ENABLE  ( 0 ),
        .APBSLOT9ENABLE  ( 0 ),
        .APBSLOT10ENABLE ( 0 ),
        .APBSLOT11ENABLE ( 0 ),
        .APBSLOT12ENABLE ( 0 ),
        .APBSLOT13ENABLE ( 0 ),
        .APBSLOT14ENABLE ( 0 ),
        .APBSLOT15ENABLE ( 1 ),
        .FAMILY          ( 19 ),
        .IADDR_OPTION    ( 0 ),
        .MADDR_BITS      ( 12 ),
        .SC_0            ( 0 ),
        .SC_1            ( 0 ),
        .SC_2            ( 0 ),
        .SC_3            ( 0 ),
        .SC_4            ( 0 ),
        .SC_5            ( 0 ),
        .SC_6            ( 0 ),
        .SC_7            ( 0 ),
        .SC_8            ( 0 ),
        .SC_9            ( 0 ),
        .SC_10           ( 0 ),
        .SC_11           ( 0 ),
        .SC_12           ( 0 ),
        .SC_13           ( 0 ),
        .SC_14           ( 0 ),
        .SC_15           ( 0 ),
        .UPR_NIBBLE_POSN ( 6 ) )
FIC_3_0x4FFF_Fxxx_0(
        // Inputs
        .PRESETN    ( GND_net ), // tied to 1'b0 from definition
        .PCLK       ( GND_net ), // tied to 1'b0 from definition
        .PADDR      ( PADDR ),
        .PWRITE     ( PWRITE ),
        .PENABLE    ( PENABLE ),
        .PWDATA     ( PWDATA ),
        .PSEL       ( PSEL ),
        .PRDATAS0   ( PRDATAS0_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS0   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS0  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS1   ( PRDATAS1_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS1   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS1  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS2   ( PRDATAS2_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS2   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS2  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS3   ( PRDATAS3_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS3   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS3  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS4   ( PRDATAS4_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS4   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS4  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS5   ( PRDATAS5_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS5   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS5  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS6   ( PRDATAS6_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS6   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS6  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS7   ( PRDATAS7_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS7   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS7  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS8   ( PRDATAS8_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS8   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS8  ( GND_net ), // tied to 1'b0 from definition
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
        .PRDATAS15  ( PRDATAS15 ),
        .PREADYS15  ( PREADYS15 ),
        .PSLVERRS15 ( PSLVERRS15 ),
        .PRDATAS16  ( PRDATAS16_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS16  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS16 ( GND_net ), // tied to 1'b0 from definition
        .IADDR      ( IADDR_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .PRDATA     ( APB3mmaster_PRDATA ),
        .PREADY     ( APB3mmaster_PREADY ),
        .PSLVERR    ( APB3mmaster_PSLVERR ),
        .PADDRS     ( APBmslave15_PADDR ),
        .PWRITES    ( APBmslave15_PWRITE ),
        .PENABLES   ( APBmslave15_PENABLE ),
        .PWDATAS    ( APBmslave15_PWDATA ),
        .PSELS0     (  ),
        .PSELS1     (  ),
        .PSELS2     (  ),
        .PSELS3     (  ),
        .PSELS4     (  ),
        .PSELS5     (  ),
        .PSELS6     (  ),
        .PSELS7     (  ),
        .PSELS8     (  ),
        .PSELS9     (  ),
        .PSELS10    (  ),
        .PSELS11    (  ),
        .PSELS12    (  ),
        .PSELS13    (  ),
        .PSELS14    (  ),
        .PSELS15    ( APBmslave15_PSELx ),
        .PSELS16    (  ) 
        );


endmodule
