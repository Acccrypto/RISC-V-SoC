//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec 12 18:37:10 2022
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of IHC_APB to TCL
# Family: PolarFireSoC
# Part Number: MPFS250T_ES-FCVG484E
# Create and Configure the core component IHC_APB
create_and_configure_core -core_vlnv {Actel:DirectCore:CoreAPB3:4.2.100} -component_name {IHC_APB} -params {\
"APB_DWIDTH:32"  \
"APBSLOT0ENABLE:true"  \
"APBSLOT1ENABLE:true"  \
"APBSLOT2ENABLE:true"  \
"APBSLOT3ENABLE:true"  \
"APBSLOT4ENABLE:true"  \
"APBSLOT5ENABLE:true"  \
"APBSLOT6ENABLE:true"  \
"APBSLOT7ENABLE:true"  \
"APBSLOT8ENABLE:true"  \
"APBSLOT9ENABLE:true"  \
"APBSLOT10ENABLE:true"  \
"APBSLOT11ENABLE:true"  \
"APBSLOT12ENABLE:true"  \
"APBSLOT13ENABLE:true"  \
"APBSLOT14ENABLE:true"  \
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
# Exporting Component Description of IHC_APB to TCL done
*/

// IHC_APB
module IHC_APB(
    // Inputs
    PADDR,
    PENABLE,
    PRDATAS0,
    PRDATAS1,
    PRDATAS10,
    PRDATAS11,
    PRDATAS12,
    PRDATAS13,
    PRDATAS14,
    PRDATAS15,
    PRDATAS2,
    PRDATAS3,
    PRDATAS4,
    PRDATAS5,
    PRDATAS6,
    PRDATAS7,
    PRDATAS8,
    PRDATAS9,
    PREADYS0,
    PREADYS1,
    PREADYS10,
    PREADYS11,
    PREADYS12,
    PREADYS13,
    PREADYS14,
    PREADYS15,
    PREADYS2,
    PREADYS3,
    PREADYS4,
    PREADYS5,
    PREADYS6,
    PREADYS7,
    PREADYS8,
    PREADYS9,
    PSEL,
    PSLVERRS0,
    PSLVERRS1,
    PSLVERRS10,
    PSLVERRS11,
    PSLVERRS12,
    PSLVERRS13,
    PSLVERRS14,
    PSLVERRS15,
    PSLVERRS2,
    PSLVERRS3,
    PSLVERRS4,
    PSLVERRS5,
    PSLVERRS6,
    PSLVERRS7,
    PSLVERRS8,
    PSLVERRS9,
    PWDATA,
    PWRITE,
    // Outputs
    PADDRS,
    PENABLES,
    PRDATA,
    PREADY,
    PSELS0,
    PSELS1,
    PSELS10,
    PSELS11,
    PSELS12,
    PSELS13,
    PSELS14,
    PSELS15,
    PSELS2,
    PSELS3,
    PSELS4,
    PSELS5,
    PSELS6,
    PSELS7,
    PSELS8,
    PSELS9,
    PSLVERR,
    PWDATAS,
    PWRITES
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [31:0] PADDR;
input         PENABLE;
input  [31:0] PRDATAS0;
input  [31:0] PRDATAS1;
input  [31:0] PRDATAS10;
input  [31:0] PRDATAS11;
input  [31:0] PRDATAS12;
input  [31:0] PRDATAS13;
input  [31:0] PRDATAS14;
input  [31:0] PRDATAS15;
input  [31:0] PRDATAS2;
input  [31:0] PRDATAS3;
input  [31:0] PRDATAS4;
input  [31:0] PRDATAS5;
input  [31:0] PRDATAS6;
input  [31:0] PRDATAS7;
input  [31:0] PRDATAS8;
input  [31:0] PRDATAS9;
input         PREADYS0;
input         PREADYS1;
input         PREADYS10;
input         PREADYS11;
input         PREADYS12;
input         PREADYS13;
input         PREADYS14;
input         PREADYS15;
input         PREADYS2;
input         PREADYS3;
input         PREADYS4;
input         PREADYS5;
input         PREADYS6;
input         PREADYS7;
input         PREADYS8;
input         PREADYS9;
input         PSEL;
input         PSLVERRS0;
input         PSLVERRS1;
input         PSLVERRS10;
input         PSLVERRS11;
input         PSLVERRS12;
input         PSLVERRS13;
input         PSLVERRS14;
input         PSLVERRS15;
input         PSLVERRS2;
input         PSLVERRS3;
input         PSLVERRS4;
input         PSLVERRS5;
input         PSLVERRS6;
input         PSLVERRS7;
input         PSLVERRS8;
input         PSLVERRS9;
input  [31:0] PWDATA;
input         PWRITE;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [31:0] PADDRS;
output        PENABLES;
output [31:0] PRDATA;
output        PREADY;
output        PSELS0;
output        PSELS1;
output        PSELS10;
output        PSELS11;
output        PSELS12;
output        PSELS13;
output        PSELS14;
output        PSELS15;
output        PSELS2;
output        PSELS3;
output        PSELS4;
output        PSELS5;
output        PSELS6;
output        PSELS7;
output        PSELS8;
output        PSELS9;
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
wire   [31:0] APBmslave0_PADDR;
wire          APBmslave0_PENABLE;
wire   [31:0] PRDATAS0;
wire          PREADYS0;
wire          APBmslave0_PSELx;
wire          PSLVERRS0;
wire   [31:0] APBmslave0_PWDATA;
wire          APBmslave0_PWRITE;
wire   [31:0] PRDATAS1;
wire          PREADYS1;
wire          APBmslave1_PSELx;
wire          PSLVERRS1;
wire   [31:0] PRDATAS2;
wire          PREADYS2;
wire          APBmslave2_PSELx;
wire          PSLVERRS2;
wire   [31:0] PRDATAS3;
wire          PREADYS3;
wire          APBmslave3_PSELx;
wire          PSLVERRS3;
wire   [31:0] PRDATAS4;
wire          PREADYS4;
wire          APBmslave4_PSELx;
wire          PSLVERRS4;
wire   [31:0] PRDATAS5;
wire          PREADYS5;
wire          APBmslave5_PSELx;
wire          PSLVERRS5;
wire   [31:0] PRDATAS6;
wire          PREADYS6;
wire          APBmslave6_PSELx;
wire          PSLVERRS6;
wire   [31:0] PRDATAS7;
wire          PREADYS7;
wire          APBmslave7_PSELx;
wire          PSLVERRS7;
wire   [31:0] PRDATAS8;
wire          PREADYS8;
wire          APBmslave8_PSELx;
wire          PSLVERRS8;
wire   [31:0] PRDATAS9;
wire          PREADYS9;
wire          APBmslave9_PSELx;
wire          PSLVERRS9;
wire   [31:0] PRDATAS10;
wire          PREADYS10;
wire          APBmslave10_PSELx;
wire          PSLVERRS10;
wire   [31:0] PRDATAS11;
wire          PREADYS11;
wire          APBmslave11_PSELx;
wire          PSLVERRS11;
wire   [31:0] PRDATAS12;
wire          PREADYS12;
wire          APBmslave12_PSELx;
wire          PSLVERRS12;
wire   [31:0] PRDATAS13;
wire          PREADYS13;
wire          APBmslave13_PSELx;
wire          PSLVERRS13;
wire   [31:0] PRDATAS14;
wire          PREADYS14;
wire          APBmslave14_PSELx;
wire          PSLVERRS14;
wire   [31:0] PRDATAS15;
wire          PREADYS15;
wire          APBmslave15_PSELx;
wire          PSLVERRS15;
wire   [31:0] APB3mmaster_PRDATA_net_0;
wire          APB3mmaster_PREADY_net_0;
wire          APB3mmaster_PSLVERR_net_0;
wire   [31:0] APBmslave0_PADDR_net_0;
wire          APBmslave0_PSELx_net_0;
wire          APBmslave0_PENABLE_net_0;
wire          APBmslave0_PWRITE_net_0;
wire   [31:0] APBmslave0_PWDATA_net_0;
wire          APBmslave1_PSELx_net_0;
wire          APBmslave2_PSELx_net_0;
wire          APBmslave3_PSELx_net_0;
wire          APBmslave4_PSELx_net_0;
wire          APBmslave5_PSELx_net_0;
wire          APBmslave6_PSELx_net_0;
wire          APBmslave7_PSELx_net_0;
wire          APBmslave8_PSELx_net_0;
wire          APBmslave9_PSELx_net_0;
wire          APBmslave10_PSELx_net_0;
wire          APBmslave11_PSELx_net_0;
wire          APBmslave12_PSELx_net_0;
wire          APBmslave13_PSELx_net_0;
wire          APBmslave14_PSELx_net_0;
wire          APBmslave15_PSELx_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire          VCC_net;
wire   [31:0] IADDR_const_net_0;
wire   [31:0] PRDATAS16_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net               = 1'b0;
assign VCC_net               = 1'b1;
assign IADDR_const_net_0     = 32'h00000000;
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
assign APBmslave0_PADDR_net_0    = APBmslave0_PADDR;
assign PADDRS[31:0]              = APBmslave0_PADDR_net_0;
assign APBmslave0_PSELx_net_0    = APBmslave0_PSELx;
assign PSELS0                    = APBmslave0_PSELx_net_0;
assign APBmslave0_PENABLE_net_0  = APBmslave0_PENABLE;
assign PENABLES                  = APBmslave0_PENABLE_net_0;
assign APBmslave0_PWRITE_net_0   = APBmslave0_PWRITE;
assign PWRITES                   = APBmslave0_PWRITE_net_0;
assign APBmslave0_PWDATA_net_0   = APBmslave0_PWDATA;
assign PWDATAS[31:0]             = APBmslave0_PWDATA_net_0;
assign APBmslave1_PSELx_net_0    = APBmslave1_PSELx;
assign PSELS1                    = APBmslave1_PSELx_net_0;
assign APBmslave2_PSELx_net_0    = APBmslave2_PSELx;
assign PSELS2                    = APBmslave2_PSELx_net_0;
assign APBmslave3_PSELx_net_0    = APBmslave3_PSELx;
assign PSELS3                    = APBmslave3_PSELx_net_0;
assign APBmslave4_PSELx_net_0    = APBmslave4_PSELx;
assign PSELS4                    = APBmslave4_PSELx_net_0;
assign APBmslave5_PSELx_net_0    = APBmslave5_PSELx;
assign PSELS5                    = APBmslave5_PSELx_net_0;
assign APBmslave6_PSELx_net_0    = APBmslave6_PSELx;
assign PSELS6                    = APBmslave6_PSELx_net_0;
assign APBmslave7_PSELx_net_0    = APBmslave7_PSELx;
assign PSELS7                    = APBmslave7_PSELx_net_0;
assign APBmslave8_PSELx_net_0    = APBmslave8_PSELx;
assign PSELS8                    = APBmslave8_PSELx_net_0;
assign APBmslave9_PSELx_net_0    = APBmslave9_PSELx;
assign PSELS9                    = APBmslave9_PSELx_net_0;
assign APBmslave10_PSELx_net_0   = APBmslave10_PSELx;
assign PSELS10                   = APBmslave10_PSELx_net_0;
assign APBmslave11_PSELx_net_0   = APBmslave11_PSELx;
assign PSELS11                   = APBmslave11_PSELx_net_0;
assign APBmslave12_PSELx_net_0   = APBmslave12_PSELx;
assign PSELS12                   = APBmslave12_PSELx_net_0;
assign APBmslave13_PSELx_net_0   = APBmslave13_PSELx;
assign PSELS13                   = APBmslave13_PSELx_net_0;
assign APBmslave14_PSELx_net_0   = APBmslave14_PSELx;
assign PSELS14                   = APBmslave14_PSELx_net_0;
assign APBmslave15_PSELx_net_0   = APBmslave15_PSELx;
assign PSELS15                   = APBmslave15_PSELx_net_0;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CoreAPB3   -   Actel:DirectCore:CoreAPB3:4.2.100
CoreAPB3 #( 
        .APB_DWIDTH      ( 32 ),
        .APBSLOT0ENABLE  ( 1 ),
        .APBSLOT1ENABLE  ( 1 ),
        .APBSLOT2ENABLE  ( 1 ),
        .APBSLOT3ENABLE  ( 1 ),
        .APBSLOT4ENABLE  ( 1 ),
        .APBSLOT5ENABLE  ( 1 ),
        .APBSLOT6ENABLE  ( 1 ),
        .APBSLOT7ENABLE  ( 1 ),
        .APBSLOT8ENABLE  ( 1 ),
        .APBSLOT9ENABLE  ( 1 ),
        .APBSLOT10ENABLE ( 1 ),
        .APBSLOT11ENABLE ( 1 ),
        .APBSLOT12ENABLE ( 1 ),
        .APBSLOT13ENABLE ( 1 ),
        .APBSLOT14ENABLE ( 1 ),
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
IHC_APB_0(
        // Inputs
        .PRESETN    ( GND_net ), // tied to 1'b0 from definition
        .PCLK       ( GND_net ), // tied to 1'b0 from definition
        .PADDR      ( PADDR ),
        .PWRITE     ( PWRITE ),
        .PENABLE    ( PENABLE ),
        .PWDATA     ( PWDATA ),
        .PSEL       ( PSEL ),
        .PRDATAS0   ( PRDATAS0 ),
        .PREADYS0   ( PREADYS0 ),
        .PSLVERRS0  ( PSLVERRS0 ),
        .PRDATAS1   ( PRDATAS1 ),
        .PREADYS1   ( PREADYS1 ),
        .PSLVERRS1  ( PSLVERRS1 ),
        .PRDATAS2   ( PRDATAS2 ),
        .PREADYS2   ( PREADYS2 ),
        .PSLVERRS2  ( PSLVERRS2 ),
        .PRDATAS3   ( PRDATAS3 ),
        .PREADYS3   ( PREADYS3 ),
        .PSLVERRS3  ( PSLVERRS3 ),
        .PRDATAS4   ( PRDATAS4 ),
        .PREADYS4   ( PREADYS4 ),
        .PSLVERRS4  ( PSLVERRS4 ),
        .PRDATAS5   ( PRDATAS5 ),
        .PREADYS5   ( PREADYS5 ),
        .PSLVERRS5  ( PSLVERRS5 ),
        .PRDATAS6   ( PRDATAS6 ),
        .PREADYS6   ( PREADYS6 ),
        .PSLVERRS6  ( PSLVERRS6 ),
        .PRDATAS7   ( PRDATAS7 ),
        .PREADYS7   ( PREADYS7 ),
        .PSLVERRS7  ( PSLVERRS7 ),
        .PRDATAS8   ( PRDATAS8 ),
        .PREADYS8   ( PREADYS8 ),
        .PSLVERRS8  ( PSLVERRS8 ),
        .PRDATAS9   ( PRDATAS9 ),
        .PREADYS9   ( PREADYS9 ),
        .PSLVERRS9  ( PSLVERRS9 ),
        .PRDATAS10  ( PRDATAS10 ),
        .PREADYS10  ( PREADYS10 ),
        .PSLVERRS10 ( PSLVERRS10 ),
        .PRDATAS11  ( PRDATAS11 ),
        .PREADYS11  ( PREADYS11 ),
        .PSLVERRS11 ( PSLVERRS11 ),
        .PRDATAS12  ( PRDATAS12 ),
        .PREADYS12  ( PREADYS12 ),
        .PSLVERRS12 ( PSLVERRS12 ),
        .PRDATAS13  ( PRDATAS13 ),
        .PREADYS13  ( PREADYS13 ),
        .PSLVERRS13 ( PSLVERRS13 ),
        .PRDATAS14  ( PRDATAS14 ),
        .PREADYS14  ( PREADYS14 ),
        .PSLVERRS14 ( PSLVERRS14 ),
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
        .PADDRS     ( APBmslave0_PADDR ),
        .PWRITES    ( APBmslave0_PWRITE ),
        .PENABLES   ( APBmslave0_PENABLE ),
        .PWDATAS    ( APBmslave0_PWDATA ),
        .PSELS0     ( APBmslave0_PSELx ),
        .PSELS1     ( APBmslave1_PSELx ),
        .PSELS2     ( APBmslave2_PSELx ),
        .PSELS3     ( APBmslave3_PSELx ),
        .PSELS4     ( APBmslave4_PSELx ),
        .PSELS5     ( APBmslave5_PSELx ),
        .PSELS6     ( APBmslave6_PSELx ),
        .PSELS7     ( APBmslave7_PSELx ),
        .PSELS8     ( APBmslave8_PSELx ),
        .PSELS9     ( APBmslave9_PSELx ),
        .PSELS10    ( APBmslave10_PSELx ),
        .PSELS11    ( APBmslave11_PSELx ),
        .PSELS12    ( APBmslave12_PSELx ),
        .PSELS13    ( APBmslave13_PSELx ),
        .PSELS14    ( APBmslave14_PSELx ),
        .PSELS15    ( APBmslave15_PSELx ),
        .PSELS16    (  ) 
        );


endmodule
