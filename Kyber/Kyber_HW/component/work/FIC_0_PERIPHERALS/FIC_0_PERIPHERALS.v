//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Apr 11 09:22:41 2023
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// FIC_0_PERIPHERALS
module FIC_0_PERIPHERALS(
    // Inputs
    ACLK,
    ARESETN,
    AXI4mmaster0_MASTER0_ARADDR,
    AXI4mmaster0_MASTER0_ARBURST,
    AXI4mmaster0_MASTER0_ARCACHE,
    AXI4mmaster0_MASTER0_ARID,
    AXI4mmaster0_MASTER0_ARLEN,
    AXI4mmaster0_MASTER0_ARLOCK,
    AXI4mmaster0_MASTER0_ARPROT,
    AXI4mmaster0_MASTER0_ARQOS,
    AXI4mmaster0_MASTER0_ARREGION,
    AXI4mmaster0_MASTER0_ARSIZE,
    AXI4mmaster0_MASTER0_ARUSER,
    AXI4mmaster0_MASTER0_ARVALID,
    AXI4mmaster0_MASTER0_AWADDR,
    AXI4mmaster0_MASTER0_AWBURST,
    AXI4mmaster0_MASTER0_AWCACHE,
    AXI4mmaster0_MASTER0_AWID,
    AXI4mmaster0_MASTER0_AWLEN,
    AXI4mmaster0_MASTER0_AWLOCK,
    AXI4mmaster0_MASTER0_AWPROT,
    AXI4mmaster0_MASTER0_AWQOS,
    AXI4mmaster0_MASTER0_AWREGION,
    AXI4mmaster0_MASTER0_AWSIZE,
    AXI4mmaster0_MASTER0_AWUSER,
    AXI4mmaster0_MASTER0_AWVALID,
    AXI4mmaster0_MASTER0_BREADY,
    AXI4mmaster0_MASTER0_RREADY,
    AXI4mmaster0_MASTER0_WDATA,
    AXI4mmaster0_MASTER0_WLAST,
    AXI4mmaster0_MASTER0_WSTRB,
    AXI4mmaster0_MASTER0_WUSER,
    AXI4mmaster0_MASTER0_WVALID,
    // Outputs
    AXI4mmaster0_MASTER0_ARREADY,
    AXI4mmaster0_MASTER0_AWREADY,
    AXI4mmaster0_MASTER0_BID,
    AXI4mmaster0_MASTER0_BRESP,
    AXI4mmaster0_MASTER0_BUSER,
    AXI4mmaster0_MASTER0_BVALID,
    AXI4mmaster0_MASTER0_RDATA,
    AXI4mmaster0_MASTER0_RID,
    AXI4mmaster0_MASTER0_RLAST,
    AXI4mmaster0_MASTER0_RRESP,
    AXI4mmaster0_MASTER0_RUSER,
    AXI4mmaster0_MASTER0_RVALID,
    AXI4mmaster0_MASTER0_WREADY,
    core_poly_irq
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         ACLK;
input         ARESETN;
input  [37:0] AXI4mmaster0_MASTER0_ARADDR;
input  [1:0]  AXI4mmaster0_MASTER0_ARBURST;
input  [3:0]  AXI4mmaster0_MASTER0_ARCACHE;
input  [7:0]  AXI4mmaster0_MASTER0_ARID;
input  [7:0]  AXI4mmaster0_MASTER0_ARLEN;
input  [1:0]  AXI4mmaster0_MASTER0_ARLOCK;
input  [2:0]  AXI4mmaster0_MASTER0_ARPROT;
input  [3:0]  AXI4mmaster0_MASTER0_ARQOS;
input  [3:0]  AXI4mmaster0_MASTER0_ARREGION;
input  [2:0]  AXI4mmaster0_MASTER0_ARSIZE;
input  [0:0]  AXI4mmaster0_MASTER0_ARUSER;
input         AXI4mmaster0_MASTER0_ARVALID;
input  [37:0] AXI4mmaster0_MASTER0_AWADDR;
input  [1:0]  AXI4mmaster0_MASTER0_AWBURST;
input  [3:0]  AXI4mmaster0_MASTER0_AWCACHE;
input  [7:0]  AXI4mmaster0_MASTER0_AWID;
input  [7:0]  AXI4mmaster0_MASTER0_AWLEN;
input  [1:0]  AXI4mmaster0_MASTER0_AWLOCK;
input  [2:0]  AXI4mmaster0_MASTER0_AWPROT;
input  [3:0]  AXI4mmaster0_MASTER0_AWQOS;
input  [3:0]  AXI4mmaster0_MASTER0_AWREGION;
input  [2:0]  AXI4mmaster0_MASTER0_AWSIZE;
input  [0:0]  AXI4mmaster0_MASTER0_AWUSER;
input         AXI4mmaster0_MASTER0_AWVALID;
input         AXI4mmaster0_MASTER0_BREADY;
input         AXI4mmaster0_MASTER0_RREADY;
input  [63:0] AXI4mmaster0_MASTER0_WDATA;
input         AXI4mmaster0_MASTER0_WLAST;
input  [7:0]  AXI4mmaster0_MASTER0_WSTRB;
input  [0:0]  AXI4mmaster0_MASTER0_WUSER;
input         AXI4mmaster0_MASTER0_WVALID;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        AXI4mmaster0_MASTER0_ARREADY;
output        AXI4mmaster0_MASTER0_AWREADY;
output [7:0]  AXI4mmaster0_MASTER0_BID;
output [1:0]  AXI4mmaster0_MASTER0_BRESP;
output [0:0]  AXI4mmaster0_MASTER0_BUSER;
output        AXI4mmaster0_MASTER0_BVALID;
output [63:0] AXI4mmaster0_MASTER0_RDATA;
output [7:0]  AXI4mmaster0_MASTER0_RID;
output        AXI4mmaster0_MASTER0_RLAST;
output [1:0]  AXI4mmaster0_MASTER0_RRESP;
output [0:0]  AXI4mmaster0_MASTER0_RUSER;
output        AXI4mmaster0_MASTER0_RVALID;
output        AXI4mmaster0_MASTER0_WREADY;
output        core_poly_irq;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          ACLK;
wire          ARESETN;
wire   [37:0] AXI4mmaster0_MASTER0_ARADDR;
wire   [1:0]  AXI4mmaster0_MASTER0_ARBURST;
wire   [3:0]  AXI4mmaster0_MASTER0_ARCACHE;
wire   [7:0]  AXI4mmaster0_MASTER0_ARID;
wire   [7:0]  AXI4mmaster0_MASTER0_ARLEN;
wire   [1:0]  AXI4mmaster0_MASTER0_ARLOCK;
wire   [2:0]  AXI4mmaster0_MASTER0_ARPROT;
wire   [3:0]  AXI4mmaster0_MASTER0_ARQOS;
wire          AXI4mmaster0_ARREADY;
wire   [3:0]  AXI4mmaster0_MASTER0_ARREGION;
wire   [2:0]  AXI4mmaster0_MASTER0_ARSIZE;
wire   [0:0]  AXI4mmaster0_MASTER0_ARUSER;
wire          AXI4mmaster0_MASTER0_ARVALID;
wire   [37:0] AXI4mmaster0_MASTER0_AWADDR;
wire   [1:0]  AXI4mmaster0_MASTER0_AWBURST;
wire   [3:0]  AXI4mmaster0_MASTER0_AWCACHE;
wire   [7:0]  AXI4mmaster0_MASTER0_AWID;
wire   [7:0]  AXI4mmaster0_MASTER0_AWLEN;
wire   [1:0]  AXI4mmaster0_MASTER0_AWLOCK;
wire   [2:0]  AXI4mmaster0_MASTER0_AWPROT;
wire   [3:0]  AXI4mmaster0_MASTER0_AWQOS;
wire          AXI4mmaster0_AWREADY;
wire   [3:0]  AXI4mmaster0_MASTER0_AWREGION;
wire   [2:0]  AXI4mmaster0_MASTER0_AWSIZE;
wire   [0:0]  AXI4mmaster0_MASTER0_AWUSER;
wire          AXI4mmaster0_MASTER0_AWVALID;
wire   [7:0]  AXI4mmaster0_BID;
wire          AXI4mmaster0_MASTER0_BREADY;
wire   [1:0]  AXI4mmaster0_BRESP;
wire   [0:0]  AXI4mmaster0_BUSER;
wire          AXI4mmaster0_BVALID;
wire   [63:0] AXI4mmaster0_RDATA;
wire   [7:0]  AXI4mmaster0_RID;
wire          AXI4mmaster0_RLAST;
wire          AXI4mmaster0_MASTER0_RREADY;
wire   [1:0]  AXI4mmaster0_RRESP;
wire   [0:0]  AXI4mmaster0_RUSER;
wire          AXI4mmaster0_RVALID;
wire   [63:0] AXI4mmaster0_MASTER0_WDATA;
wire          AXI4mmaster0_MASTER0_WLAST;
wire          AXI4mmaster0_WREADY;
wire   [7:0]  AXI4mmaster0_MASTER0_WSTRB;
wire   [0:0]  AXI4mmaster0_MASTER0_WUSER;
wire          AXI4mmaster0_MASTER0_WVALID;
wire          core_poly_irq_net_0;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_ARBURST;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_ARCACHE;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave0_ARLEN;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave0_ARPROT;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_ARQOS;
wire          FIC0_INITIATOR_AXI4mslave0_ARREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_ARREGION;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave0_ARSIZE;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_ARUSER;
wire          FIC0_INITIATOR_AXI4mslave0_ARVALID;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_AWBURST;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_AWCACHE;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave0_AWLEN;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave0_AWPROT;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_AWQOS;
wire          FIC0_INITIATOR_AXI4mslave0_AWREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_AWREGION;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave0_AWSIZE;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_AWUSER;
wire          FIC0_INITIATOR_AXI4mslave0_AWVALID;
wire          FIC0_INITIATOR_AXI4mslave0_BREADY;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_BRESP;
wire          FIC0_INITIATOR_AXI4mslave0_BVALID;
wire   [31:0] FIC0_INITIATOR_AXI4mslave0_RDATA;
wire          FIC0_INITIATOR_AXI4mslave0_RLAST;
wire          FIC0_INITIATOR_AXI4mslave0_RREADY;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_RRESP;
wire          FIC0_INITIATOR_AXI4mslave0_RVALID;
wire   [31:0] FIC0_INITIATOR_AXI4mslave0_WDATA;
wire          FIC0_INITIATOR_AXI4mslave0_WLAST;
wire          FIC0_INITIATOR_AXI4mslave0_WREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_WSTRB;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_WUSER;
wire          FIC0_INITIATOR_AXI4mslave0_WVALID;
wire          core_poly_irq_net_1;
wire          AXI4mmaster0_AWREADY_net_0;
wire          AXI4mmaster0_WREADY_net_0;
wire          AXI4mmaster0_BVALID_net_0;
wire          AXI4mmaster0_ARREADY_net_0;
wire          AXI4mmaster0_RLAST_net_0;
wire          AXI4mmaster0_RVALID_net_0;
wire   [7:0]  AXI4mmaster0_BID_net_0;
wire   [1:0]  AXI4mmaster0_BRESP_net_0;
wire   [7:0]  AXI4mmaster0_RID_net_0;
wire   [63:0] AXI4mmaster0_RDATA_net_0;
wire   [1:0]  AXI4mmaster0_RRESP_net_0;
wire   [0:0]  AXI4mmaster0_BUSER_net_0;
wire   [0:0]  AXI4mmaster0_RUSER_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [37:0] FIC0_INITIATOR_AXI4mslave0_ARADDR;
wire   [31:0] FIC0_INITIATOR_AXI4mslave0_ARADDR_0;
wire   [31:0] FIC0_INITIATOR_AXI4mslave0_ARADDR_0_31to0;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave0_ARID;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_ARID_0;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_ARID_0_0to0;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_ARLOCK;
wire          FIC0_INITIATOR_AXI4mslave0_ARLOCK_0;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_ARLOCK_0_0to0;
wire   [37:0] FIC0_INITIATOR_AXI4mslave0_AWADDR;
wire   [31:0] FIC0_INITIATOR_AXI4mslave0_AWADDR_0;
wire   [31:0] FIC0_INITIATOR_AXI4mslave0_AWADDR_0_31to0;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave0_AWID;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_AWID_0;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_AWID_0_0to0;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_AWLOCK;
wire          FIC0_INITIATOR_AXI4mslave0_AWLOCK_0;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_AWLOCK_0_0to0;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_BID;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave0_BID_0;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_BID_0_0to0;
wire   [8:1]  FIC0_INITIATOR_AXI4mslave0_BID_0_8to1;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_RID;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave0_RID_0;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_RID_0_0to0;
wire   [8:1]  FIC0_INITIATOR_AXI4mslave0_RID_0_8to1;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net    = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign core_poly_irq_net_1              = core_poly_irq_net_0;
assign core_poly_irq                    = core_poly_irq_net_1;
assign AXI4mmaster0_AWREADY_net_0       = AXI4mmaster0_AWREADY;
assign AXI4mmaster0_MASTER0_AWREADY     = AXI4mmaster0_AWREADY_net_0;
assign AXI4mmaster0_WREADY_net_0        = AXI4mmaster0_WREADY;
assign AXI4mmaster0_MASTER0_WREADY      = AXI4mmaster0_WREADY_net_0;
assign AXI4mmaster0_BVALID_net_0        = AXI4mmaster0_BVALID;
assign AXI4mmaster0_MASTER0_BVALID      = AXI4mmaster0_BVALID_net_0;
assign AXI4mmaster0_ARREADY_net_0       = AXI4mmaster0_ARREADY;
assign AXI4mmaster0_MASTER0_ARREADY     = AXI4mmaster0_ARREADY_net_0;
assign AXI4mmaster0_RLAST_net_0         = AXI4mmaster0_RLAST;
assign AXI4mmaster0_MASTER0_RLAST       = AXI4mmaster0_RLAST_net_0;
assign AXI4mmaster0_RVALID_net_0        = AXI4mmaster0_RVALID;
assign AXI4mmaster0_MASTER0_RVALID      = AXI4mmaster0_RVALID_net_0;
assign AXI4mmaster0_BID_net_0           = AXI4mmaster0_BID;
assign AXI4mmaster0_MASTER0_BID[7:0]    = AXI4mmaster0_BID_net_0;
assign AXI4mmaster0_BRESP_net_0         = AXI4mmaster0_BRESP;
assign AXI4mmaster0_MASTER0_BRESP[1:0]  = AXI4mmaster0_BRESP_net_0;
assign AXI4mmaster0_RID_net_0           = AXI4mmaster0_RID;
assign AXI4mmaster0_MASTER0_RID[7:0]    = AXI4mmaster0_RID_net_0;
assign AXI4mmaster0_RDATA_net_0         = AXI4mmaster0_RDATA;
assign AXI4mmaster0_MASTER0_RDATA[63:0] = AXI4mmaster0_RDATA_net_0;
assign AXI4mmaster0_RRESP_net_0         = AXI4mmaster0_RRESP;
assign AXI4mmaster0_MASTER0_RRESP[1:0]  = AXI4mmaster0_RRESP_net_0;
assign AXI4mmaster0_BUSER_net_0[0]      = AXI4mmaster0_BUSER[0];
assign AXI4mmaster0_MASTER0_BUSER[0:0]  = AXI4mmaster0_BUSER_net_0[0];
assign AXI4mmaster0_RUSER_net_0[0]      = AXI4mmaster0_RUSER[0];
assign AXI4mmaster0_MASTER0_RUSER[0:0]  = AXI4mmaster0_RUSER_net_0[0];
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign FIC0_INITIATOR_AXI4mslave0_ARADDR_0 = { FIC0_INITIATOR_AXI4mslave0_ARADDR_0_31to0 };
assign FIC0_INITIATOR_AXI4mslave0_ARADDR_0_31to0 = FIC0_INITIATOR_AXI4mslave0_ARADDR[31:0];

assign FIC0_INITIATOR_AXI4mslave0_ARID_0 = { FIC0_INITIATOR_AXI4mslave0_ARID_0_0to0 };
assign FIC0_INITIATOR_AXI4mslave0_ARID_0_0to0 = FIC0_INITIATOR_AXI4mslave0_ARID[0:0];

assign FIC0_INITIATOR_AXI4mslave0_ARLOCK_0 = { FIC0_INITIATOR_AXI4mslave0_ARLOCK_0_0to0 };
assign FIC0_INITIATOR_AXI4mslave0_ARLOCK_0_0to0 = FIC0_INITIATOR_AXI4mslave0_ARLOCK[0:0];

assign FIC0_INITIATOR_AXI4mslave0_AWADDR_0 = { FIC0_INITIATOR_AXI4mslave0_AWADDR_0_31to0 };
assign FIC0_INITIATOR_AXI4mslave0_AWADDR_0_31to0 = FIC0_INITIATOR_AXI4mslave0_AWADDR[31:0];

assign FIC0_INITIATOR_AXI4mslave0_AWID_0 = { FIC0_INITIATOR_AXI4mslave0_AWID_0_0to0 };
assign FIC0_INITIATOR_AXI4mslave0_AWID_0_0to0 = FIC0_INITIATOR_AXI4mslave0_AWID[0:0];

assign FIC0_INITIATOR_AXI4mslave0_AWLOCK_0 = { FIC0_INITIATOR_AXI4mslave0_AWLOCK_0_0to0 };
assign FIC0_INITIATOR_AXI4mslave0_AWLOCK_0_0to0 = FIC0_INITIATOR_AXI4mslave0_AWLOCK[0:0];

assign FIC0_INITIATOR_AXI4mslave0_BID_0 = { FIC0_INITIATOR_AXI4mslave0_BID_0_8to1, FIC0_INITIATOR_AXI4mslave0_BID_0_0to0 };
assign FIC0_INITIATOR_AXI4mslave0_BID_0_0to0 = FIC0_INITIATOR_AXI4mslave0_BID[0:0];
assign FIC0_INITIATOR_AXI4mslave0_BID_0_8to1 = 8'h0;

assign FIC0_INITIATOR_AXI4mslave0_RID_0 = { FIC0_INITIATOR_AXI4mslave0_RID_0_8to1, FIC0_INITIATOR_AXI4mslave0_RID_0_0to0 };
assign FIC0_INITIATOR_AXI4mslave0_RID_0_0to0 = FIC0_INITIATOR_AXI4mslave0_RID[0:0];
assign FIC0_INITIATOR_AXI4mslave0_RID_0_8to1 = 8'h0;

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------Core_Poly
Core_Poly #( 
        .C_S_AXI_ADDR_WIDTH ( 32 ),
        .C_S_AXI_DATA_WIDTH ( 32 ),
        .C_S_AXI_ID_WIDTH   ( 1 ) )
Core_Poly_0(
        // Inputs
        .S_AXI_ACLK     ( ACLK ),
        .S_AXI_ARESETN  ( ARESETN ),
        .S_AXI_AWLOCK   ( FIC0_INITIATOR_AXI4mslave0_AWLOCK_0 ),
        .S_AXI_AWVALID  ( FIC0_INITIATOR_AXI4mslave0_AWVALID ),
        .S_AXI_WLAST    ( FIC0_INITIATOR_AXI4mslave0_WLAST ),
        .S_AXI_WVALID   ( FIC0_INITIATOR_AXI4mslave0_WVALID ),
        .S_AXI_BREADY   ( FIC0_INITIATOR_AXI4mslave0_BREADY ),
        .S_AXI_ARLOCK   ( FIC0_INITIATOR_AXI4mslave0_ARLOCK_0 ),
        .S_AXI_ARVALID  ( FIC0_INITIATOR_AXI4mslave0_ARVALID ),
        .S_AXI_RREADY   ( FIC0_INITIATOR_AXI4mslave0_RREADY ),
        .S_AXI_AWID     ( FIC0_INITIATOR_AXI4mslave0_AWID_0 ),
        .S_AXI_AWADDR   ( FIC0_INITIATOR_AXI4mslave0_AWADDR_0 ),
        .S_AXI_AWLEN    ( FIC0_INITIATOR_AXI4mslave0_AWLEN ),
        .S_AXI_AWSIZE   ( FIC0_INITIATOR_AXI4mslave0_AWSIZE ),
        .S_AXI_AWBURST  ( FIC0_INITIATOR_AXI4mslave0_AWBURST ),
        .S_AXI_AWCACHE  ( FIC0_INITIATOR_AXI4mslave0_AWCACHE ),
        .S_AXI_AWPROT   ( FIC0_INITIATOR_AXI4mslave0_AWPROT ),
        .S_AXI_AWQOS    ( FIC0_INITIATOR_AXI4mslave0_AWQOS ),
        .S_AXI_AWREGION ( FIC0_INITIATOR_AXI4mslave0_AWREGION ),
        .S_AXI_WDATA    ( FIC0_INITIATOR_AXI4mslave0_WDATA ),
        .S_AXI_WSTRB    ( FIC0_INITIATOR_AXI4mslave0_WSTRB ),
        .S_AXI_ARID     ( FIC0_INITIATOR_AXI4mslave0_ARID_0 ),
        .S_AXI_ARADDR   ( FIC0_INITIATOR_AXI4mslave0_ARADDR_0 ),
        .S_AXI_ARLEN    ( FIC0_INITIATOR_AXI4mslave0_ARLEN ),
        .S_AXI_ARSIZE   ( FIC0_INITIATOR_AXI4mslave0_ARSIZE ),
        .S_AXI_ARBURST  ( FIC0_INITIATOR_AXI4mslave0_ARBURST ),
        .S_AXI_ARCACHE  ( FIC0_INITIATOR_AXI4mslave0_ARCACHE ),
        .S_AXI_ARPROT   ( FIC0_INITIATOR_AXI4mslave0_ARPROT ),
        .S_AXI_ARQOS    ( FIC0_INITIATOR_AXI4mslave0_ARQOS ),
        .S_AXI_ARREGION ( FIC0_INITIATOR_AXI4mslave0_ARREGION ),
        // Outputs
        .core_poly_irq  ( core_poly_irq_net_0 ),
        .S_AXI_AWREADY  ( FIC0_INITIATOR_AXI4mslave0_AWREADY ),
        .S_AXI_WREADY   ( FIC0_INITIATOR_AXI4mslave0_WREADY ),
        .S_AXI_BVALID   ( FIC0_INITIATOR_AXI4mslave0_BVALID ),
        .S_AXI_ARREADY  ( FIC0_INITIATOR_AXI4mslave0_ARREADY ),
        .S_AXI_RLAST    ( FIC0_INITIATOR_AXI4mslave0_RLAST ),
        .S_AXI_RVALID   ( FIC0_INITIATOR_AXI4mslave0_RVALID ),
        .S_AXI_BID      ( FIC0_INITIATOR_AXI4mslave0_BID ),
        .S_AXI_BRESP    ( FIC0_INITIATOR_AXI4mslave0_BRESP ),
        .S_AXI_RID      ( FIC0_INITIATOR_AXI4mslave0_RID ),
        .S_AXI_RDATA    ( FIC0_INITIATOR_AXI4mslave0_RDATA ),
        .S_AXI_RRESP    ( FIC0_INITIATOR_AXI4mslave0_RRESP ) 
        );

//--------FIC0_INITIATOR
FIC0_INITIATOR FIC0_INITIATOR_inst_0(
        // Inputs
        .ACLK             ( ACLK ),
        .ARESETN          ( ARESETN ),
        .SLAVE0_AWREADY   ( FIC0_INITIATOR_AXI4mslave0_AWREADY ),
        .SLAVE0_WREADY    ( FIC0_INITIATOR_AXI4mslave0_WREADY ),
        .SLAVE0_BVALID    ( FIC0_INITIATOR_AXI4mslave0_BVALID ),
        .SLAVE0_ARREADY   ( FIC0_INITIATOR_AXI4mslave0_ARREADY ),
        .SLAVE0_RLAST     ( FIC0_INITIATOR_AXI4mslave0_RLAST ),
        .SLAVE0_RVALID    ( FIC0_INITIATOR_AXI4mslave0_RVALID ),
        .MASTER0_AWVALID  ( AXI4mmaster0_MASTER0_AWVALID ),
        .MASTER0_WLAST    ( AXI4mmaster0_MASTER0_WLAST ),
        .MASTER0_WVALID   ( AXI4mmaster0_MASTER0_WVALID ),
        .MASTER0_BREADY   ( AXI4mmaster0_MASTER0_BREADY ),
        .MASTER0_ARVALID  ( AXI4mmaster0_MASTER0_ARVALID ),
        .MASTER0_RREADY   ( AXI4mmaster0_MASTER0_RREADY ),
        .SLAVE0_BID       ( FIC0_INITIATOR_AXI4mslave0_BID_0 ),
        .SLAVE0_BRESP     ( FIC0_INITIATOR_AXI4mslave0_BRESP ),
        .SLAVE0_RID       ( FIC0_INITIATOR_AXI4mslave0_RID_0 ),
        .SLAVE0_RDATA     ( FIC0_INITIATOR_AXI4mslave0_RDATA ),
        .SLAVE0_RRESP     ( FIC0_INITIATOR_AXI4mslave0_RRESP ),
        .SLAVE0_BUSER     ( GND_net ), // tied to 1'b0 from definition
        .SLAVE0_RUSER     ( GND_net ), // tied to 1'b0 from definition
        .MASTER0_AWID     ( AXI4mmaster0_MASTER0_AWID ),
        .MASTER0_AWADDR   ( AXI4mmaster0_MASTER0_AWADDR ),
        .MASTER0_AWLEN    ( AXI4mmaster0_MASTER0_AWLEN ),
        .MASTER0_AWSIZE   ( AXI4mmaster0_MASTER0_AWSIZE ),
        .MASTER0_AWBURST  ( AXI4mmaster0_MASTER0_AWBURST ),
        .MASTER0_AWLOCK   ( AXI4mmaster0_MASTER0_AWLOCK ),
        .MASTER0_AWCACHE  ( AXI4mmaster0_MASTER0_AWCACHE ),
        .MASTER0_AWPROT   ( AXI4mmaster0_MASTER0_AWPROT ),
        .MASTER0_AWQOS    ( AXI4mmaster0_MASTER0_AWQOS ),
        .MASTER0_AWREGION ( AXI4mmaster0_MASTER0_AWREGION ),
        .MASTER0_WDATA    ( AXI4mmaster0_MASTER0_WDATA ),
        .MASTER0_WSTRB    ( AXI4mmaster0_MASTER0_WSTRB ),
        .MASTER0_ARID     ( AXI4mmaster0_MASTER0_ARID ),
        .MASTER0_ARADDR   ( AXI4mmaster0_MASTER0_ARADDR ),
        .MASTER0_ARLEN    ( AXI4mmaster0_MASTER0_ARLEN ),
        .MASTER0_ARSIZE   ( AXI4mmaster0_MASTER0_ARSIZE ),
        .MASTER0_ARBURST  ( AXI4mmaster0_MASTER0_ARBURST ),
        .MASTER0_ARLOCK   ( AXI4mmaster0_MASTER0_ARLOCK ),
        .MASTER0_ARCACHE  ( AXI4mmaster0_MASTER0_ARCACHE ),
        .MASTER0_ARPROT   ( AXI4mmaster0_MASTER0_ARPROT ),
        .MASTER0_ARQOS    ( AXI4mmaster0_MASTER0_ARQOS ),
        .MASTER0_ARREGION ( AXI4mmaster0_MASTER0_ARREGION ),
        .MASTER0_AWUSER   ( AXI4mmaster0_MASTER0_AWUSER ),
        .MASTER0_WUSER    ( AXI4mmaster0_MASTER0_WUSER ),
        .MASTER0_ARUSER   ( AXI4mmaster0_MASTER0_ARUSER ),
        // Outputs
        .SLAVE0_AWVALID   ( FIC0_INITIATOR_AXI4mslave0_AWVALID ),
        .SLAVE0_WLAST     ( FIC0_INITIATOR_AXI4mslave0_WLAST ),
        .SLAVE0_WVALID    ( FIC0_INITIATOR_AXI4mslave0_WVALID ),
        .SLAVE0_BREADY    ( FIC0_INITIATOR_AXI4mslave0_BREADY ),
        .SLAVE0_ARVALID   ( FIC0_INITIATOR_AXI4mslave0_ARVALID ),
        .SLAVE0_RREADY    ( FIC0_INITIATOR_AXI4mslave0_RREADY ),
        .MASTER0_AWREADY  ( AXI4mmaster0_AWREADY ),
        .MASTER0_WREADY   ( AXI4mmaster0_WREADY ),
        .MASTER0_BVALID   ( AXI4mmaster0_BVALID ),
        .MASTER0_ARREADY  ( AXI4mmaster0_ARREADY ),
        .MASTER0_RLAST    ( AXI4mmaster0_RLAST ),
        .MASTER0_RVALID   ( AXI4mmaster0_RVALID ),
        .SLAVE0_AWID      ( FIC0_INITIATOR_AXI4mslave0_AWID ),
        .SLAVE0_AWADDR    ( FIC0_INITIATOR_AXI4mslave0_AWADDR ),
        .SLAVE0_AWLEN     ( FIC0_INITIATOR_AXI4mslave0_AWLEN ),
        .SLAVE0_AWSIZE    ( FIC0_INITIATOR_AXI4mslave0_AWSIZE ),
        .SLAVE0_AWBURST   ( FIC0_INITIATOR_AXI4mslave0_AWBURST ),
        .SLAVE0_AWLOCK    ( FIC0_INITIATOR_AXI4mslave0_AWLOCK ),
        .SLAVE0_AWCACHE   ( FIC0_INITIATOR_AXI4mslave0_AWCACHE ),
        .SLAVE0_AWPROT    ( FIC0_INITIATOR_AXI4mslave0_AWPROT ),
        .SLAVE0_AWQOS     ( FIC0_INITIATOR_AXI4mslave0_AWQOS ),
        .SLAVE0_AWREGION  ( FIC0_INITIATOR_AXI4mslave0_AWREGION ),
        .SLAVE0_WDATA     ( FIC0_INITIATOR_AXI4mslave0_WDATA ),
        .SLAVE0_WSTRB     ( FIC0_INITIATOR_AXI4mslave0_WSTRB ),
        .SLAVE0_ARID      ( FIC0_INITIATOR_AXI4mslave0_ARID ),
        .SLAVE0_ARADDR    ( FIC0_INITIATOR_AXI4mslave0_ARADDR ),
        .SLAVE0_ARLEN     ( FIC0_INITIATOR_AXI4mslave0_ARLEN ),
        .SLAVE0_ARSIZE    ( FIC0_INITIATOR_AXI4mslave0_ARSIZE ),
        .SLAVE0_ARBURST   ( FIC0_INITIATOR_AXI4mslave0_ARBURST ),
        .SLAVE0_ARLOCK    ( FIC0_INITIATOR_AXI4mslave0_ARLOCK ),
        .SLAVE0_ARCACHE   ( FIC0_INITIATOR_AXI4mslave0_ARCACHE ),
        .SLAVE0_ARPROT    ( FIC0_INITIATOR_AXI4mslave0_ARPROT ),
        .SLAVE0_ARQOS     ( FIC0_INITIATOR_AXI4mslave0_ARQOS ),
        .SLAVE0_ARREGION  ( FIC0_INITIATOR_AXI4mslave0_ARREGION ),
        .SLAVE0_AWUSER    ( FIC0_INITIATOR_AXI4mslave0_AWUSER ),
        .SLAVE0_WUSER     ( FIC0_INITIATOR_AXI4mslave0_WUSER ),
        .SLAVE0_ARUSER    ( FIC0_INITIATOR_AXI4mslave0_ARUSER ),
        .MASTER0_BID      ( AXI4mmaster0_BID ),
        .MASTER0_BRESP    ( AXI4mmaster0_BRESP ),
        .MASTER0_RID      ( AXI4mmaster0_RID ),
        .MASTER0_RDATA    ( AXI4mmaster0_RDATA ),
        .MASTER0_RRESP    ( AXI4mmaster0_RRESP ),
        .MASTER0_BUSER    ( AXI4mmaster0_BUSER ),
        .MASTER0_RUSER    ( AXI4mmaster0_RUSER ) 
        );


endmodule
