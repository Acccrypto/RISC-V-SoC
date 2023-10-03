//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec 12 18:36:34 2022
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// FIC_1_PERIPHERALS
module FIC_1_PERIPHERALS(
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
    AXI4mslave0_SLAVE0_ARREADY,
    AXI4mslave0_SLAVE0_AWREADY,
    AXI4mslave0_SLAVE0_BID,
    AXI4mslave0_SLAVE0_BRESP,
    AXI4mslave0_SLAVE0_BUSER,
    AXI4mslave0_SLAVE0_BVALID,
    AXI4mslave0_SLAVE0_RDATA,
    AXI4mslave0_SLAVE0_RID,
    AXI4mslave0_SLAVE0_RLAST,
    AXI4mslave0_SLAVE0_RRESP,
    AXI4mslave0_SLAVE0_RUSER,
    AXI4mslave0_SLAVE0_RVALID,
    AXI4mslave0_SLAVE0_WREADY,
    CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_BIT_CLK,
    CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_LOCK,
    CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_REF_CLK,
    PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_ARST_N,
    PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CLK,
    PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CTRL,
    PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_WDATA,
    PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_ARST_N,
    PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CLK,
    PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CTRL,
    PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_WDATA,
    PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_ARST_N,
    PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CLK,
    PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CTRL,
    PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_WDATA,
    PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_ARST_N,
    PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CLK,
    PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CTRL,
    PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_WDATA,
    PCIESS_LANE_RXD0_N,
    PCIESS_LANE_RXD0_P,
    PCIESS_LANE_RXD1_N,
    PCIESS_LANE_RXD1_P,
    PCIESS_LANE_RXD2_N,
    PCIESS_LANE_RXD2_P,
    PCIESS_LANE_RXD3_N,
    PCIESS_LANE_RXD3_P,
    PCIE_APB_SLAVE_APB_S_PADDR,
    PCIE_APB_SLAVE_APB_S_PENABLE,
    PCIE_APB_SLAVE_APB_S_PSEL,
    PCIE_APB_SLAVE_APB_S_PWDATA,
    PCIE_APB_SLAVE_APB_S_PWRITE,
    PCIe_CLK_125MHz,
    PCIe_INIT_DONE,
    PCIe_REFERENCE_CLK,
    PCLK,
    PRESETN,
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
    AXI4mslave0_SLAVE0_ARADDR,
    AXI4mslave0_SLAVE0_ARBURST,
    AXI4mslave0_SLAVE0_ARCACHE,
    AXI4mslave0_SLAVE0_ARID,
    AXI4mslave0_SLAVE0_ARLEN,
    AXI4mslave0_SLAVE0_ARLOCK,
    AXI4mslave0_SLAVE0_ARPROT,
    AXI4mslave0_SLAVE0_ARQOS,
    AXI4mslave0_SLAVE0_ARREGION,
    AXI4mslave0_SLAVE0_ARSIZE,
    AXI4mslave0_SLAVE0_ARUSER,
    AXI4mslave0_SLAVE0_ARVALID,
    AXI4mslave0_SLAVE0_AWADDR,
    AXI4mslave0_SLAVE0_AWBURST,
    AXI4mslave0_SLAVE0_AWCACHE,
    AXI4mslave0_SLAVE0_AWID,
    AXI4mslave0_SLAVE0_AWLEN,
    AXI4mslave0_SLAVE0_AWLOCK,
    AXI4mslave0_SLAVE0_AWPROT,
    AXI4mslave0_SLAVE0_AWQOS,
    AXI4mslave0_SLAVE0_AWREGION,
    AXI4mslave0_SLAVE0_AWSIZE,
    AXI4mslave0_SLAVE0_AWUSER,
    AXI4mslave0_SLAVE0_AWVALID,
    AXI4mslave0_SLAVE0_BREADY,
    AXI4mslave0_SLAVE0_RREADY,
    AXI4mslave0_SLAVE0_WDATA,
    AXI4mslave0_SLAVE0_WLAST,
    AXI4mslave0_SLAVE0_WSTRB,
    AXI4mslave0_SLAVE0_WUSER,
    AXI4mslave0_SLAVE0_WVALID,
    PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_INTERRUPT,
    PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_RDATA,
    PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_INTERRUPT,
    PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_RDATA,
    PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_INTERRUPT,
    PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_RDATA,
    PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_INTERRUPT,
    PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_RDATA,
    PCIESS_LANE_TXD0_N,
    PCIESS_LANE_TXD0_P,
    PCIESS_LANE_TXD1_N,
    PCIESS_LANE_TXD1_P,
    PCIESS_LANE_TXD2_N,
    PCIESS_LANE_TXD2_P,
    PCIESS_LANE_TXD3_N,
    PCIESS_LANE_TXD3_P,
    PCIE_1_PERST_N,
    PCIE_APB_SLAVE_APB_S_PRDATA,
    PCIE_APB_SLAVE_APB_S_PREADY,
    PCIE_APB_SLAVE_APB_S_PSLVERR,
    PCIe_IRQ
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
input         AXI4mslave0_SLAVE0_ARREADY;
input         AXI4mslave0_SLAVE0_AWREADY;
input  [4:0]  AXI4mslave0_SLAVE0_BID;
input  [1:0]  AXI4mslave0_SLAVE0_BRESP;
input  [0:0]  AXI4mslave0_SLAVE0_BUSER;
input         AXI4mslave0_SLAVE0_BVALID;
input  [63:0] AXI4mslave0_SLAVE0_RDATA;
input  [4:0]  AXI4mslave0_SLAVE0_RID;
input         AXI4mslave0_SLAVE0_RLAST;
input  [1:0]  AXI4mslave0_SLAVE0_RRESP;
input  [0:0]  AXI4mslave0_SLAVE0_RUSER;
input         AXI4mslave0_SLAVE0_RVALID;
input         AXI4mslave0_SLAVE0_WREADY;
input         CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_BIT_CLK;
input         CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_LOCK;
input         CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_REF_CLK;
input         PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_ARST_N;
input         PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CLK;
input  [10:0] PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CTRL;
input  [32:0] PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_WDATA;
input         PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_ARST_N;
input         PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CLK;
input  [10:0] PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CTRL;
input  [32:0] PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_WDATA;
input         PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_ARST_N;
input         PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CLK;
input  [10:0] PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CTRL;
input  [32:0] PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_WDATA;
input         PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_ARST_N;
input         PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CLK;
input  [10:0] PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CTRL;
input  [32:0] PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_WDATA;
input         PCIESS_LANE_RXD0_N;
input         PCIESS_LANE_RXD0_P;
input         PCIESS_LANE_RXD1_N;
input         PCIESS_LANE_RXD1_P;
input         PCIESS_LANE_RXD2_N;
input         PCIESS_LANE_RXD2_P;
input         PCIESS_LANE_RXD3_N;
input         PCIESS_LANE_RXD3_P;
input  [25:0] PCIE_APB_SLAVE_APB_S_PADDR;
input         PCIE_APB_SLAVE_APB_S_PENABLE;
input         PCIE_APB_SLAVE_APB_S_PSEL;
input  [31:0] PCIE_APB_SLAVE_APB_S_PWDATA;
input         PCIE_APB_SLAVE_APB_S_PWRITE;
input         PCIe_CLK_125MHz;
input         PCIe_INIT_DONE;
input         PCIe_REFERENCE_CLK;
input         PCLK;
input         PRESETN;
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
output [37:0] AXI4mslave0_SLAVE0_ARADDR;
output [1:0]  AXI4mslave0_SLAVE0_ARBURST;
output [3:0]  AXI4mslave0_SLAVE0_ARCACHE;
output [4:0]  AXI4mslave0_SLAVE0_ARID;
output [7:0]  AXI4mslave0_SLAVE0_ARLEN;
output [1:0]  AXI4mslave0_SLAVE0_ARLOCK;
output [2:0]  AXI4mslave0_SLAVE0_ARPROT;
output [3:0]  AXI4mslave0_SLAVE0_ARQOS;
output [3:0]  AXI4mslave0_SLAVE0_ARREGION;
output [2:0]  AXI4mslave0_SLAVE0_ARSIZE;
output [0:0]  AXI4mslave0_SLAVE0_ARUSER;
output        AXI4mslave0_SLAVE0_ARVALID;
output [37:0] AXI4mslave0_SLAVE0_AWADDR;
output [1:0]  AXI4mslave0_SLAVE0_AWBURST;
output [3:0]  AXI4mslave0_SLAVE0_AWCACHE;
output [4:0]  AXI4mslave0_SLAVE0_AWID;
output [7:0]  AXI4mslave0_SLAVE0_AWLEN;
output [1:0]  AXI4mslave0_SLAVE0_AWLOCK;
output [2:0]  AXI4mslave0_SLAVE0_AWPROT;
output [3:0]  AXI4mslave0_SLAVE0_AWQOS;
output [3:0]  AXI4mslave0_SLAVE0_AWREGION;
output [2:0]  AXI4mslave0_SLAVE0_AWSIZE;
output [0:0]  AXI4mslave0_SLAVE0_AWUSER;
output        AXI4mslave0_SLAVE0_AWVALID;
output        AXI4mslave0_SLAVE0_BREADY;
output        AXI4mslave0_SLAVE0_RREADY;
output [63:0] AXI4mslave0_SLAVE0_WDATA;
output        AXI4mslave0_SLAVE0_WLAST;
output [7:0]  AXI4mslave0_SLAVE0_WSTRB;
output [0:0]  AXI4mslave0_SLAVE0_WUSER;
output        AXI4mslave0_SLAVE0_WVALID;
output        PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_INTERRUPT;
output [32:0] PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_RDATA;
output        PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_INTERRUPT;
output [32:0] PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_RDATA;
output        PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_INTERRUPT;
output [32:0] PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_RDATA;
output        PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_INTERRUPT;
output [32:0] PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_RDATA;
output        PCIESS_LANE_TXD0_N;
output        PCIESS_LANE_TXD0_P;
output        PCIESS_LANE_TXD1_N;
output        PCIESS_LANE_TXD1_P;
output        PCIESS_LANE_TXD2_N;
output        PCIESS_LANE_TXD2_P;
output        PCIESS_LANE_TXD3_N;
output        PCIESS_LANE_TXD3_P;
output        PCIE_1_PERST_N;
output [31:0] PCIE_APB_SLAVE_APB_S_PRDATA;
output        PCIE_APB_SLAVE_APB_S_PREADY;
output        PCIE_APB_SLAVE_APB_S_PSLVERR;
output        PCIe_IRQ;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          ACLK;
wire   [25:0] PCIE_APB_SLAVE_APB_S_PADDR;
wire          PCIE_APB_SLAVE_APB_S_PENABLE;
wire   [31:0] APB_SLAVE_PRDATA;
wire          APB_SLAVE_PREADY;
wire          PCIE_APB_SLAVE_APB_S_PSEL;
wire          APB_SLAVE_PSLVERR;
wire   [31:0] PCIE_APB_SLAVE_APB_S_PWDATA;
wire          PCIE_APB_SLAVE_APB_S_PWRITE;
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
wire   [37:0] AXI4mslave0_ARADDR;
wire   [1:0]  AXI4mslave0_ARBURST;
wire   [3:0]  AXI4mslave0_ARCACHE;
wire   [4:0]  AXI4mslave0_ARID;
wire   [7:0]  AXI4mslave0_ARLEN;
wire   [1:0]  AXI4mslave0_ARLOCK;
wire   [2:0]  AXI4mslave0_ARPROT;
wire   [3:0]  AXI4mslave0_ARQOS;
wire          AXI4mslave0_SLAVE0_ARREADY;
wire   [3:0]  AXI4mslave0_ARREGION;
wire   [2:0]  AXI4mslave0_ARSIZE;
wire   [0:0]  AXI4mslave0_ARUSER;
wire          AXI4mslave0_ARVALID;
wire   [37:0] AXI4mslave0_AWADDR;
wire   [1:0]  AXI4mslave0_AWBURST;
wire   [3:0]  AXI4mslave0_AWCACHE;
wire   [4:0]  AXI4mslave0_AWID;
wire   [7:0]  AXI4mslave0_AWLEN;
wire   [1:0]  AXI4mslave0_AWLOCK;
wire   [2:0]  AXI4mslave0_AWPROT;
wire   [3:0]  AXI4mslave0_AWQOS;
wire          AXI4mslave0_SLAVE0_AWREADY;
wire   [3:0]  AXI4mslave0_AWREGION;
wire   [2:0]  AXI4mslave0_AWSIZE;
wire   [0:0]  AXI4mslave0_AWUSER;
wire          AXI4mslave0_AWVALID;
wire   [4:0]  AXI4mslave0_SLAVE0_BID;
wire          AXI4mslave0_BREADY;
wire   [1:0]  AXI4mslave0_SLAVE0_BRESP;
wire   [0:0]  AXI4mslave0_SLAVE0_BUSER;
wire          AXI4mslave0_SLAVE0_BVALID;
wire   [63:0] AXI4mslave0_SLAVE0_RDATA;
wire   [4:0]  AXI4mslave0_SLAVE0_RID;
wire          AXI4mslave0_SLAVE0_RLAST;
wire          AXI4mslave0_RREADY;
wire   [1:0]  AXI4mslave0_SLAVE0_RRESP;
wire   [0:0]  AXI4mslave0_SLAVE0_RUSER;
wire          AXI4mslave0_SLAVE0_RVALID;
wire   [63:0] AXI4mslave0_WDATA;
wire          AXI4mslave0_WLAST;
wire          AXI4mslave0_SLAVE0_WREADY;
wire   [7:0]  AXI4mslave0_WSTRB;
wire   [0:0]  AXI4mslave0_WUSER;
wire          AXI4mslave0_WVALID;
wire   [37:0] AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARADDR;
wire   [1:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARBURST;
wire   [3:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARID;
wire   [7:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARLEN;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARREADY;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARVALID;
wire   [37:0] AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWADDR;
wire   [1:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWBURST;
wire   [3:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWID;
wire   [7:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWLEN;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWREADY;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWVALID;
wire   [3:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BID;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BREADY;
wire   [1:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BRESP;
wire   [0:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BUSER;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BVALID;
wire   [63:0] AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RDATA;
wire   [3:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RID;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RLAST;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RREADY;
wire   [1:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RRESP;
wire   [0:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RUSER;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RVALID;
wire   [63:0] AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WDATA;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WLAST;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WREADY;
wire   [7:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WSTRB;
wire          AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WVALID;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARBURST;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARCACHE;
wire   [7:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARLEN;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARLOCK;
wire   [2:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARPROT;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARQOS;
wire          FIC_1_INITIATOR_0_AXI4mslave0_ARREADY;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARREGION;
wire   [0:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARUSER;
wire          FIC_1_INITIATOR_0_AXI4mslave0_ARVALID;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWBURST;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWCACHE;
wire   [7:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWLEN;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWLOCK;
wire   [2:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWPROT;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWQOS;
wire          FIC_1_INITIATOR_0_AXI4mslave0_AWREADY;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWREGION;
wire   [0:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWUSER;
wire          FIC_1_INITIATOR_0_AXI4mslave0_AWVALID;
wire          FIC_1_INITIATOR_0_AXI4mslave0_BREADY;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_BRESP;
wire          FIC_1_INITIATOR_0_AXI4mslave0_BVALID;
wire   [63:0] FIC_1_INITIATOR_0_AXI4mslave0_RDATA;
wire          FIC_1_INITIATOR_0_AXI4mslave0_RLAST;
wire          FIC_1_INITIATOR_0_AXI4mslave0_RREADY;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_RRESP;
wire          FIC_1_INITIATOR_0_AXI4mslave0_RVALID;
wire   [63:0] FIC_1_INITIATOR_0_AXI4mslave0_WDATA;
wire          FIC_1_INITIATOR_0_AXI4mslave0_WLAST;
wire          FIC_1_INITIATOR_0_AXI4mslave0_WREADY;
wire   [7:0]  FIC_1_INITIATOR_0_AXI4mslave0_WSTRB;
wire   [0:0]  FIC_1_INITIATOR_0_AXI4mslave0_WUSER;
wire          FIC_1_INITIATOR_0_AXI4mslave0_WVALID;
wire          PCIE_1_PERST_N_net_0;
wire   [31:0] PCIE_AXI_1_MASTER_ARADDR;
wire   [1:0]  PCIE_AXI_1_MASTER_ARBURST;
wire   [3:0]  PCIE_AXI_1_MASTER_ARID;
wire   [7:0]  PCIE_AXI_1_MASTER_ARLEN;
wire          PCIE_AXI_1_MASTER_ARREADY;
wire   [1:0]  PCIE_AXI_1_MASTER_ARSIZE;
wire          PCIE_AXI_1_MASTER_ARVALID;
wire   [31:0] PCIE_AXI_1_MASTER_AWADDR;
wire   [1:0]  PCIE_AXI_1_MASTER_AWBURST;
wire   [3:0]  PCIE_AXI_1_MASTER_AWID;
wire   [7:0]  PCIE_AXI_1_MASTER_AWLEN;
wire          PCIE_AXI_1_MASTER_AWREADY;
wire   [1:0]  PCIE_AXI_1_MASTER_AWSIZE;
wire          PCIE_AXI_1_MASTER_AWVALID;
wire   [3:0]  PCIE_AXI_1_MASTER_BID;
wire          PCIE_AXI_1_MASTER_BREADY;
wire   [1:0]  PCIE_AXI_1_MASTER_BRESP;
wire          PCIE_AXI_1_MASTER_BVALID;
wire   [63:0] PCIE_AXI_1_MASTER_RDATA;
wire   [3:0]  PCIE_AXI_1_MASTER_RID;
wire          PCIE_AXI_1_MASTER_RLAST;
wire          PCIE_AXI_1_MASTER_RREADY;
wire   [1:0]  PCIE_AXI_1_MASTER_RRESP;
wire          PCIE_AXI_1_MASTER_RVALID;
wire   [63:0] PCIE_AXI_1_MASTER_WDATA;
wire          PCIE_AXI_1_MASTER_WLAST;
wire          PCIE_AXI_1_MASTER_WREADY;
wire   [7:0]  PCIE_AXI_1_MASTER_WSTRB;
wire          PCIE_AXI_1_MASTER_WVALID;
wire          PCIe_CLK_125MHz;
wire          PCIe_INIT_DONE;
wire          PCIe_IRQ_net_0;
wire          PCIe_REFERENCE_CLK;
wire          PCIESS_LANE_RXD0_N;
wire          PCIESS_LANE_RXD0_P;
wire          PCIESS_LANE_RXD1_N;
wire          PCIESS_LANE_RXD1_P;
wire          PCIESS_LANE_RXD2_N;
wire          PCIESS_LANE_RXD2_P;
wire          PCIESS_LANE_RXD3_N;
wire          PCIESS_LANE_RXD3_P;
wire          PCIESS_LANE_TXD0_N_net_0;
wire          PCIESS_LANE_TXD0_P_net_0;
wire          PCIESS_LANE_TXD1_N_net_0;
wire          PCIESS_LANE_TXD1_P_net_0;
wire          PCIESS_LANE_TXD2_N_net_0;
wire          PCIESS_LANE_TXD2_P_net_0;
wire          PCIESS_LANE_TXD3_N_net_0;
wire          PCIESS_LANE_TXD3_P_net_0;
wire          PCLK;
wire          PRESETN;
wire          PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_ARST_N;
wire          PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CLK;
wire   [10:0] PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CTRL;
wire          Q0_LANE0_DRI_SLAVE_DRI_INTERRUPT;
wire   [32:0] Q0_LANE0_DRI_SLAVE_DRI_RDATA;
wire   [32:0] PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_WDATA;
wire          PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_ARST_N;
wire          PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CLK;
wire   [10:0] PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CTRL;
wire          Q0_LANE1_DRI_SLAVE_DRI_INTERRUPT;
wire   [32:0] Q0_LANE1_DRI_SLAVE_DRI_RDATA;
wire   [32:0] PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_WDATA;
wire          PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_ARST_N;
wire          PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CLK;
wire   [10:0] PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CTRL;
wire          Q0_LANE2_DRI_SLAVE_DRI_INTERRUPT;
wire   [32:0] Q0_LANE2_DRI_SLAVE_DRI_RDATA;
wire   [32:0] PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_WDATA;
wire          PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_ARST_N;
wire          PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CLK;
wire   [10:0] PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CTRL;
wire          Q0_LANE3_DRI_SLAVE_DRI_INTERRUPT;
wire   [32:0] Q0_LANE3_DRI_SLAVE_DRI_RDATA;
wire   [32:0] PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_WDATA;
wire          CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_BIT_CLK;
wire          CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_LOCK;
wire          CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_REF_CLK;
wire          AXI4mmaster0_ARREADY_net_0;
wire          AXI4mmaster0_AWREADY_net_0;
wire          AXI4mmaster0_BVALID_net_0;
wire          AXI4mmaster0_RLAST_net_0;
wire          AXI4mmaster0_RVALID_net_0;
wire          AXI4mmaster0_WREADY_net_0;
wire          AXI4mslave0_ARVALID_net_0;
wire          AXI4mslave0_AWVALID_net_0;
wire          AXI4mslave0_BREADY_net_0;
wire          AXI4mslave0_RREADY_net_0;
wire          AXI4mslave0_WLAST_net_0;
wire          AXI4mslave0_WVALID_net_0;
wire          Q0_LANE0_DRI_SLAVE_DRI_INTERRUPT_net_0;
wire          Q0_LANE1_DRI_SLAVE_DRI_INTERRUPT_net_0;
wire          Q0_LANE2_DRI_SLAVE_DRI_INTERRUPT_net_0;
wire          Q0_LANE3_DRI_SLAVE_DRI_INTERRUPT_net_0;
wire          PCIESS_LANE_TXD0_N_net_1;
wire          PCIESS_LANE_TXD0_P_net_1;
wire          PCIESS_LANE_TXD1_N_net_1;
wire          PCIESS_LANE_TXD1_P_net_1;
wire          PCIESS_LANE_TXD2_N_net_1;
wire          PCIESS_LANE_TXD2_P_net_1;
wire          PCIESS_LANE_TXD3_N_net_1;
wire          PCIESS_LANE_TXD3_P_net_1;
wire          PCIE_1_PERST_N_net_1;
wire          APB_SLAVE_PREADY_net_0;
wire          APB_SLAVE_PSLVERR_net_0;
wire          PCIe_IRQ_net_1;
wire   [7:0]  AXI4mmaster0_BID_net_0;
wire   [1:0]  AXI4mmaster0_BRESP_net_0;
wire   [0:0]  AXI4mmaster0_BUSER_net_0;
wire   [63:0] AXI4mmaster0_RDATA_net_0;
wire   [7:0]  AXI4mmaster0_RID_net_0;
wire   [1:0]  AXI4mmaster0_RRESP_net_0;
wire   [0:0]  AXI4mmaster0_RUSER_net_0;
wire   [37:0] AXI4mslave0_ARADDR_net_0;
wire   [1:0]  AXI4mslave0_ARBURST_net_0;
wire   [3:0]  AXI4mslave0_ARCACHE_net_0;
wire   [4:0]  AXI4mslave0_ARID_net_0;
wire   [7:0]  AXI4mslave0_ARLEN_net_0;
wire   [1:0]  AXI4mslave0_ARLOCK_net_0;
wire   [2:0]  AXI4mslave0_ARPROT_net_0;
wire   [3:0]  AXI4mslave0_ARQOS_net_0;
wire   [3:0]  AXI4mslave0_ARREGION_net_0;
wire   [2:0]  AXI4mslave0_ARSIZE_net_0;
wire   [0:0]  AXI4mslave0_ARUSER_net_0;
wire   [37:0] AXI4mslave0_AWADDR_net_0;
wire   [1:0]  AXI4mslave0_AWBURST_net_0;
wire   [3:0]  AXI4mslave0_AWCACHE_net_0;
wire   [4:0]  AXI4mslave0_AWID_net_0;
wire   [7:0]  AXI4mslave0_AWLEN_net_0;
wire   [1:0]  AXI4mslave0_AWLOCK_net_0;
wire   [2:0]  AXI4mslave0_AWPROT_net_0;
wire   [3:0]  AXI4mslave0_AWQOS_net_0;
wire   [3:0]  AXI4mslave0_AWREGION_net_0;
wire   [2:0]  AXI4mslave0_AWSIZE_net_0;
wire   [0:0]  AXI4mslave0_AWUSER_net_0;
wire   [63:0] AXI4mslave0_WDATA_net_0;
wire   [7:0]  AXI4mslave0_WSTRB_net_0;
wire   [0:0]  AXI4mslave0_WUSER_net_0;
wire   [32:0] Q0_LANE0_DRI_SLAVE_DRI_RDATA_net_0;
wire   [32:0] Q0_LANE1_DRI_SLAVE_DRI_RDATA_net_0;
wire   [32:0] Q0_LANE2_DRI_SLAVE_DRI_RDATA_net_0;
wire   [32:0] Q0_LANE3_DRI_SLAVE_DRI_RDATA_net_0;
wire   [31:0] APB_SLAVE_PRDATA_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   [7:0]  PCIE_1_INTERRUPT_const_net_0;
wire          GND_net;
wire   [1:0]  MASTER0_AWLOCK_const_net_0;
wire   [3:0]  MASTER0_AWCACHE_const_net_0;
wire   [2:0]  MASTER0_AWPROT_const_net_0;
wire   [3:0]  MASTER0_AWQOS_const_net_0;
wire   [3:0]  MASTER0_AWREGION_const_net_0;
wire   [1:0]  MASTER0_ARLOCK_const_net_0;
wire   [3:0]  MASTER0_ARCACHE_const_net_0;
wire   [2:0]  MASTER0_ARPROT_const_net_0;
wire   [3:0]  MASTER0_ARQOS_const_net_0;
wire   [3:0]  MASTER0_ARREGION_const_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [1:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE;
wire   [2:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE_0;
wire   [1:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE_0_1to0;
wire   [2:2]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE_0_2to2;
wire   [1:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE;
wire   [2:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE_0;
wire   [1:0]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE_0_1to0;
wire   [2:2]  AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE_0_2to2;
wire   [37:0] FIC_1_INITIATOR_0_AXI4mslave0_ARADDR;
wire   [31:0] FIC_1_INITIATOR_0_AXI4mslave0_ARADDR_0;
wire   [31:0] FIC_1_INITIATOR_0_AXI4mslave0_ARADDR_0_31to0;
wire   [8:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARID;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARID_0;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARID_0_3to0;
wire   [2:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARSIZE;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARSIZE_0;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_ARSIZE_0_1to0;
wire   [37:0] FIC_1_INITIATOR_0_AXI4mslave0_AWADDR;
wire   [31:0] FIC_1_INITIATOR_0_AXI4mslave0_AWADDR_0;
wire   [31:0] FIC_1_INITIATOR_0_AXI4mslave0_AWADDR_0_31to0;
wire   [8:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWID;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWID_0;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWID_0_3to0;
wire   [2:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWSIZE;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWSIZE_0;
wire   [1:0]  FIC_1_INITIATOR_0_AXI4mslave0_AWSIZE_0_1to0;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_BID;
wire   [8:0]  FIC_1_INITIATOR_0_AXI4mslave0_BID_0;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_BID_0_3to0;
wire   [8:4]  FIC_1_INITIATOR_0_AXI4mslave0_BID_0_8to4;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_RID;
wire   [8:0]  FIC_1_INITIATOR_0_AXI4mslave0_RID_0;
wire   [3:0]  FIC_1_INITIATOR_0_AXI4mslave0_RID_0_3to0;
wire   [8:4]  FIC_1_INITIATOR_0_AXI4mslave0_RID_0_8to4;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign PCIE_1_INTERRUPT_const_net_0 = 8'h00;
assign GND_net                      = 1'b0;
assign MASTER0_AWLOCK_const_net_0   = 2'h0;
assign MASTER0_AWCACHE_const_net_0  = 4'h0;
assign MASTER0_AWPROT_const_net_0   = 3'h0;
assign MASTER0_AWQOS_const_net_0    = 4'h0;
assign MASTER0_AWREGION_const_net_0 = 4'h0;
assign MASTER0_ARLOCK_const_net_0   = 2'h0;
assign MASTER0_ARCACHE_const_net_0  = 4'h0;
assign MASTER0_ARPROT_const_net_0   = 3'h0;
assign MASTER0_ARQOS_const_net_0    = 4'h0;
assign MASTER0_ARREGION_const_net_0 = 4'h0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign AXI4mmaster0_ARREADY_net_0                          = AXI4mmaster0_ARREADY;
assign AXI4mmaster0_MASTER0_ARREADY                        = AXI4mmaster0_ARREADY_net_0;
assign AXI4mmaster0_AWREADY_net_0                          = AXI4mmaster0_AWREADY;
assign AXI4mmaster0_MASTER0_AWREADY                        = AXI4mmaster0_AWREADY_net_0;
assign AXI4mmaster0_BVALID_net_0                           = AXI4mmaster0_BVALID;
assign AXI4mmaster0_MASTER0_BVALID                         = AXI4mmaster0_BVALID_net_0;
assign AXI4mmaster0_RLAST_net_0                            = AXI4mmaster0_RLAST;
assign AXI4mmaster0_MASTER0_RLAST                          = AXI4mmaster0_RLAST_net_0;
assign AXI4mmaster0_RVALID_net_0                           = AXI4mmaster0_RVALID;
assign AXI4mmaster0_MASTER0_RVALID                         = AXI4mmaster0_RVALID_net_0;
assign AXI4mmaster0_WREADY_net_0                           = AXI4mmaster0_WREADY;
assign AXI4mmaster0_MASTER0_WREADY                         = AXI4mmaster0_WREADY_net_0;
assign AXI4mslave0_ARVALID_net_0                           = AXI4mslave0_ARVALID;
assign AXI4mslave0_SLAVE0_ARVALID                          = AXI4mslave0_ARVALID_net_0;
assign AXI4mslave0_AWVALID_net_0                           = AXI4mslave0_AWVALID;
assign AXI4mslave0_SLAVE0_AWVALID                          = AXI4mslave0_AWVALID_net_0;
assign AXI4mslave0_BREADY_net_0                            = AXI4mslave0_BREADY;
assign AXI4mslave0_SLAVE0_BREADY                           = AXI4mslave0_BREADY_net_0;
assign AXI4mslave0_RREADY_net_0                            = AXI4mslave0_RREADY;
assign AXI4mslave0_SLAVE0_RREADY                           = AXI4mslave0_RREADY_net_0;
assign AXI4mslave0_WLAST_net_0                             = AXI4mslave0_WLAST;
assign AXI4mslave0_SLAVE0_WLAST                            = AXI4mslave0_WLAST_net_0;
assign AXI4mslave0_WVALID_net_0                            = AXI4mslave0_WVALID;
assign AXI4mslave0_SLAVE0_WVALID                           = AXI4mslave0_WVALID_net_0;
assign Q0_LANE0_DRI_SLAVE_DRI_INTERRUPT_net_0              = Q0_LANE0_DRI_SLAVE_DRI_INTERRUPT;
assign PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_INTERRUPT   = Q0_LANE0_DRI_SLAVE_DRI_INTERRUPT_net_0;
assign Q0_LANE1_DRI_SLAVE_DRI_INTERRUPT_net_0              = Q0_LANE1_DRI_SLAVE_DRI_INTERRUPT;
assign PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_INTERRUPT   = Q0_LANE1_DRI_SLAVE_DRI_INTERRUPT_net_0;
assign Q0_LANE2_DRI_SLAVE_DRI_INTERRUPT_net_0              = Q0_LANE2_DRI_SLAVE_DRI_INTERRUPT;
assign PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_INTERRUPT   = Q0_LANE2_DRI_SLAVE_DRI_INTERRUPT_net_0;
assign Q0_LANE3_DRI_SLAVE_DRI_INTERRUPT_net_0              = Q0_LANE3_DRI_SLAVE_DRI_INTERRUPT;
assign PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_INTERRUPT   = Q0_LANE3_DRI_SLAVE_DRI_INTERRUPT_net_0;
assign PCIESS_LANE_TXD0_N_net_1                            = PCIESS_LANE_TXD0_N_net_0;
assign PCIESS_LANE_TXD0_N                                  = PCIESS_LANE_TXD0_N_net_1;
assign PCIESS_LANE_TXD0_P_net_1                            = PCIESS_LANE_TXD0_P_net_0;
assign PCIESS_LANE_TXD0_P                                  = PCIESS_LANE_TXD0_P_net_1;
assign PCIESS_LANE_TXD1_N_net_1                            = PCIESS_LANE_TXD1_N_net_0;
assign PCIESS_LANE_TXD1_N                                  = PCIESS_LANE_TXD1_N_net_1;
assign PCIESS_LANE_TXD1_P_net_1                            = PCIESS_LANE_TXD1_P_net_0;
assign PCIESS_LANE_TXD1_P                                  = PCIESS_LANE_TXD1_P_net_1;
assign PCIESS_LANE_TXD2_N_net_1                            = PCIESS_LANE_TXD2_N_net_0;
assign PCIESS_LANE_TXD2_N                                  = PCIESS_LANE_TXD2_N_net_1;
assign PCIESS_LANE_TXD2_P_net_1                            = PCIESS_LANE_TXD2_P_net_0;
assign PCIESS_LANE_TXD2_P                                  = PCIESS_LANE_TXD2_P_net_1;
assign PCIESS_LANE_TXD3_N_net_1                            = PCIESS_LANE_TXD3_N_net_0;
assign PCIESS_LANE_TXD3_N                                  = PCIESS_LANE_TXD3_N_net_1;
assign PCIESS_LANE_TXD3_P_net_1                            = PCIESS_LANE_TXD3_P_net_0;
assign PCIESS_LANE_TXD3_P                                  = PCIESS_LANE_TXD3_P_net_1;
assign PCIE_1_PERST_N_net_1                                = PCIE_1_PERST_N_net_0;
assign PCIE_1_PERST_N                                      = PCIE_1_PERST_N_net_1;
assign APB_SLAVE_PREADY_net_0                              = APB_SLAVE_PREADY;
assign PCIE_APB_SLAVE_APB_S_PREADY                         = APB_SLAVE_PREADY_net_0;
assign APB_SLAVE_PSLVERR_net_0                             = APB_SLAVE_PSLVERR;
assign PCIE_APB_SLAVE_APB_S_PSLVERR                        = APB_SLAVE_PSLVERR_net_0;
assign PCIe_IRQ_net_1                                      = PCIe_IRQ_net_0;
assign PCIe_IRQ                                            = PCIe_IRQ_net_1;
assign AXI4mmaster0_BID_net_0                              = AXI4mmaster0_BID;
assign AXI4mmaster0_MASTER0_BID[7:0]                       = AXI4mmaster0_BID_net_0;
assign AXI4mmaster0_BRESP_net_0                            = AXI4mmaster0_BRESP;
assign AXI4mmaster0_MASTER0_BRESP[1:0]                     = AXI4mmaster0_BRESP_net_0;
assign AXI4mmaster0_BUSER_net_0[0]                         = AXI4mmaster0_BUSER[0];
assign AXI4mmaster0_MASTER0_BUSER[0:0]                     = AXI4mmaster0_BUSER_net_0[0];
assign AXI4mmaster0_RDATA_net_0                            = AXI4mmaster0_RDATA;
assign AXI4mmaster0_MASTER0_RDATA[63:0]                    = AXI4mmaster0_RDATA_net_0;
assign AXI4mmaster0_RID_net_0                              = AXI4mmaster0_RID;
assign AXI4mmaster0_MASTER0_RID[7:0]                       = AXI4mmaster0_RID_net_0;
assign AXI4mmaster0_RRESP_net_0                            = AXI4mmaster0_RRESP;
assign AXI4mmaster0_MASTER0_RRESP[1:0]                     = AXI4mmaster0_RRESP_net_0;
assign AXI4mmaster0_RUSER_net_0[0]                         = AXI4mmaster0_RUSER[0];
assign AXI4mmaster0_MASTER0_RUSER[0:0]                     = AXI4mmaster0_RUSER_net_0[0];
assign AXI4mslave0_ARADDR_net_0                            = AXI4mslave0_ARADDR;
assign AXI4mslave0_SLAVE0_ARADDR[37:0]                     = AXI4mslave0_ARADDR_net_0;
assign AXI4mslave0_ARBURST_net_0                           = AXI4mslave0_ARBURST;
assign AXI4mslave0_SLAVE0_ARBURST[1:0]                     = AXI4mslave0_ARBURST_net_0;
assign AXI4mslave0_ARCACHE_net_0                           = AXI4mslave0_ARCACHE;
assign AXI4mslave0_SLAVE0_ARCACHE[3:0]                     = AXI4mslave0_ARCACHE_net_0;
assign AXI4mslave0_ARID_net_0                              = AXI4mslave0_ARID;
assign AXI4mslave0_SLAVE0_ARID[4:0]                        = AXI4mslave0_ARID_net_0;
assign AXI4mslave0_ARLEN_net_0                             = AXI4mslave0_ARLEN;
assign AXI4mslave0_SLAVE0_ARLEN[7:0]                       = AXI4mslave0_ARLEN_net_0;
assign AXI4mslave0_ARLOCK_net_0                            = AXI4mslave0_ARLOCK;
assign AXI4mslave0_SLAVE0_ARLOCK[1:0]                      = AXI4mslave0_ARLOCK_net_0;
assign AXI4mslave0_ARPROT_net_0                            = AXI4mslave0_ARPROT;
assign AXI4mslave0_SLAVE0_ARPROT[2:0]                      = AXI4mslave0_ARPROT_net_0;
assign AXI4mslave0_ARQOS_net_0                             = AXI4mslave0_ARQOS;
assign AXI4mslave0_SLAVE0_ARQOS[3:0]                       = AXI4mslave0_ARQOS_net_0;
assign AXI4mslave0_ARREGION_net_0                          = AXI4mslave0_ARREGION;
assign AXI4mslave0_SLAVE0_ARREGION[3:0]                    = AXI4mslave0_ARREGION_net_0;
assign AXI4mslave0_ARSIZE_net_0                            = AXI4mslave0_ARSIZE;
assign AXI4mslave0_SLAVE0_ARSIZE[2:0]                      = AXI4mslave0_ARSIZE_net_0;
assign AXI4mslave0_ARUSER_net_0[0]                         = AXI4mslave0_ARUSER[0];
assign AXI4mslave0_SLAVE0_ARUSER[0:0]                      = AXI4mslave0_ARUSER_net_0[0];
assign AXI4mslave0_AWADDR_net_0                            = AXI4mslave0_AWADDR;
assign AXI4mslave0_SLAVE0_AWADDR[37:0]                     = AXI4mslave0_AWADDR_net_0;
assign AXI4mslave0_AWBURST_net_0                           = AXI4mslave0_AWBURST;
assign AXI4mslave0_SLAVE0_AWBURST[1:0]                     = AXI4mslave0_AWBURST_net_0;
assign AXI4mslave0_AWCACHE_net_0                           = AXI4mslave0_AWCACHE;
assign AXI4mslave0_SLAVE0_AWCACHE[3:0]                     = AXI4mslave0_AWCACHE_net_0;
assign AXI4mslave0_AWID_net_0                              = AXI4mslave0_AWID;
assign AXI4mslave0_SLAVE0_AWID[4:0]                        = AXI4mslave0_AWID_net_0;
assign AXI4mslave0_AWLEN_net_0                             = AXI4mslave0_AWLEN;
assign AXI4mslave0_SLAVE0_AWLEN[7:0]                       = AXI4mslave0_AWLEN_net_0;
assign AXI4mslave0_AWLOCK_net_0                            = AXI4mslave0_AWLOCK;
assign AXI4mslave0_SLAVE0_AWLOCK[1:0]                      = AXI4mslave0_AWLOCK_net_0;
assign AXI4mslave0_AWPROT_net_0                            = AXI4mslave0_AWPROT;
assign AXI4mslave0_SLAVE0_AWPROT[2:0]                      = AXI4mslave0_AWPROT_net_0;
assign AXI4mslave0_AWQOS_net_0                             = AXI4mslave0_AWQOS;
assign AXI4mslave0_SLAVE0_AWQOS[3:0]                       = AXI4mslave0_AWQOS_net_0;
assign AXI4mslave0_AWREGION_net_0                          = AXI4mslave0_AWREGION;
assign AXI4mslave0_SLAVE0_AWREGION[3:0]                    = AXI4mslave0_AWREGION_net_0;
assign AXI4mslave0_AWSIZE_net_0                            = AXI4mslave0_AWSIZE;
assign AXI4mslave0_SLAVE0_AWSIZE[2:0]                      = AXI4mslave0_AWSIZE_net_0;
assign AXI4mslave0_AWUSER_net_0[0]                         = AXI4mslave0_AWUSER[0];
assign AXI4mslave0_SLAVE0_AWUSER[0:0]                      = AXI4mslave0_AWUSER_net_0[0];
assign AXI4mslave0_WDATA_net_0                             = AXI4mslave0_WDATA;
assign AXI4mslave0_SLAVE0_WDATA[63:0]                      = AXI4mslave0_WDATA_net_0;
assign AXI4mslave0_WSTRB_net_0                             = AXI4mslave0_WSTRB;
assign AXI4mslave0_SLAVE0_WSTRB[7:0]                       = AXI4mslave0_WSTRB_net_0;
assign AXI4mslave0_WUSER_net_0[0]                          = AXI4mslave0_WUSER[0];
assign AXI4mslave0_SLAVE0_WUSER[0:0]                       = AXI4mslave0_WUSER_net_0[0];
assign Q0_LANE0_DRI_SLAVE_DRI_RDATA_net_0                  = Q0_LANE0_DRI_SLAVE_DRI_RDATA;
assign PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_RDATA[32:0] = Q0_LANE0_DRI_SLAVE_DRI_RDATA_net_0;
assign Q0_LANE1_DRI_SLAVE_DRI_RDATA_net_0                  = Q0_LANE1_DRI_SLAVE_DRI_RDATA;
assign PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_RDATA[32:0] = Q0_LANE1_DRI_SLAVE_DRI_RDATA_net_0;
assign Q0_LANE2_DRI_SLAVE_DRI_RDATA_net_0                  = Q0_LANE2_DRI_SLAVE_DRI_RDATA;
assign PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_RDATA[32:0] = Q0_LANE2_DRI_SLAVE_DRI_RDATA_net_0;
assign Q0_LANE3_DRI_SLAVE_DRI_RDATA_net_0                  = Q0_LANE3_DRI_SLAVE_DRI_RDATA;
assign PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_RDATA[32:0] = Q0_LANE3_DRI_SLAVE_DRI_RDATA_net_0;
assign APB_SLAVE_PRDATA_net_0                              = APB_SLAVE_PRDATA;
assign PCIE_APB_SLAVE_APB_S_PRDATA[31:0]                   = APB_SLAVE_PRDATA_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE_0 = { AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE_0_2to2, AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE_0_1to0 };
assign AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE_0_1to0 = AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE[1:0];
assign AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE_0_2to2 = 1'b0;

assign AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE_0 = { AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE_0_2to2, AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE_0_1to0 };
assign AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE_0_1to0 = AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE[1:0];
assign AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE_0_2to2 = 1'b0;

assign FIC_1_INITIATOR_0_AXI4mslave0_ARADDR_0 = { FIC_1_INITIATOR_0_AXI4mslave0_ARADDR_0_31to0 };
assign FIC_1_INITIATOR_0_AXI4mslave0_ARADDR_0_31to0 = FIC_1_INITIATOR_0_AXI4mslave0_ARADDR[31:0];

assign FIC_1_INITIATOR_0_AXI4mslave0_ARID_0 = { FIC_1_INITIATOR_0_AXI4mslave0_ARID_0_3to0 };
assign FIC_1_INITIATOR_0_AXI4mslave0_ARID_0_3to0 = FIC_1_INITIATOR_0_AXI4mslave0_ARID[3:0];

assign FIC_1_INITIATOR_0_AXI4mslave0_ARSIZE_0 = { FIC_1_INITIATOR_0_AXI4mslave0_ARSIZE_0_1to0 };
assign FIC_1_INITIATOR_0_AXI4mslave0_ARSIZE_0_1to0 = FIC_1_INITIATOR_0_AXI4mslave0_ARSIZE[1:0];

assign FIC_1_INITIATOR_0_AXI4mslave0_AWADDR_0 = { FIC_1_INITIATOR_0_AXI4mslave0_AWADDR_0_31to0 };
assign FIC_1_INITIATOR_0_AXI4mslave0_AWADDR_0_31to0 = FIC_1_INITIATOR_0_AXI4mslave0_AWADDR[31:0];

assign FIC_1_INITIATOR_0_AXI4mslave0_AWID_0 = { FIC_1_INITIATOR_0_AXI4mslave0_AWID_0_3to0 };
assign FIC_1_INITIATOR_0_AXI4mslave0_AWID_0_3to0 = FIC_1_INITIATOR_0_AXI4mslave0_AWID[3:0];

assign FIC_1_INITIATOR_0_AXI4mslave0_AWSIZE_0 = { FIC_1_INITIATOR_0_AXI4mslave0_AWSIZE_0_1to0 };
assign FIC_1_INITIATOR_0_AXI4mslave0_AWSIZE_0_1to0 = FIC_1_INITIATOR_0_AXI4mslave0_AWSIZE[1:0];

assign FIC_1_INITIATOR_0_AXI4mslave0_BID_0 = { FIC_1_INITIATOR_0_AXI4mslave0_BID_0_8to4, FIC_1_INITIATOR_0_AXI4mslave0_BID_0_3to0 };
assign FIC_1_INITIATOR_0_AXI4mslave0_BID_0_3to0 = FIC_1_INITIATOR_0_AXI4mslave0_BID[3:0];
assign FIC_1_INITIATOR_0_AXI4mslave0_BID_0_8to4 = 5'h0;

assign FIC_1_INITIATOR_0_AXI4mslave0_RID_0 = { FIC_1_INITIATOR_0_AXI4mslave0_RID_0_8to4, FIC_1_INITIATOR_0_AXI4mslave0_RID_0_3to0 };
assign FIC_1_INITIATOR_0_AXI4mslave0_RID_0_3to0 = FIC_1_INITIATOR_0_AXI4mslave0_RID[3:0];
assign FIC_1_INITIATOR_0_AXI4mslave0_RID_0_8to4 = 5'h0;

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------AXI_ADDRESS_SHIM
AXI_ADDRESS_SHIM AXI_ADDRESS_SHIM_0(
        // Inputs
        .RESETN                ( ARESETN ),
        .INITIATOR_IN_ARREADY  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARREADY ),
        .INITIATOR_IN_AWREADY  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWREADY ),
        .INITIATOR_IN_BID      ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BID ),
        .INITIATOR_IN_BRESP    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BRESP ),
        .INITIATOR_IN_BVALID   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BVALID ),
        .INITIATOR_IN_RDATA    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RDATA ),
        .INITIATOR_IN_RID      ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RID ),
        .INITIATOR_IN_RLAST    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RLAST ),
        .INITIATOR_IN_RRESP    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RRESP ),
        .INITIATOR_IN_RVALID   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RVALID ),
        .INITIATOR_IN_WREADY   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WREADY ),
        .TARGET_IN_ARADDR      ( PCIE_AXI_1_MASTER_ARADDR ),
        .TARGET_IN_ARBURST     ( PCIE_AXI_1_MASTER_ARBURST ),
        .TARGET_IN_ARID        ( PCIE_AXI_1_MASTER_ARID ),
        .TARGET_IN_ARLEN       ( PCIE_AXI_1_MASTER_ARLEN ),
        .TARGET_IN_ARSIZE      ( PCIE_AXI_1_MASTER_ARSIZE ),
        .TARGET_IN_ARVALID     ( PCIE_AXI_1_MASTER_ARVALID ),
        .TARGET_IN_AWADDR      ( PCIE_AXI_1_MASTER_AWADDR ),
        .TARGET_IN_AWBURST     ( PCIE_AXI_1_MASTER_AWBURST ),
        .TARGET_IN_AWID        ( PCIE_AXI_1_MASTER_AWID ),
        .TARGET_IN_AWLEN       ( PCIE_AXI_1_MASTER_AWLEN ),
        .TARGET_IN_AWSIZE      ( PCIE_AXI_1_MASTER_AWSIZE ),
        .TARGET_IN_AWVALID     ( PCIE_AXI_1_MASTER_AWVALID ),
        .TARGET_IN_BREADY      ( PCIE_AXI_1_MASTER_BREADY ),
        .TARGET_IN_RREADY      ( PCIE_AXI_1_MASTER_RREADY ),
        .TARGET_IN_WDATA       ( PCIE_AXI_1_MASTER_WDATA ),
        .TARGET_IN_WLAST       ( PCIE_AXI_1_MASTER_WLAST ),
        .TARGET_IN_WSTRB       ( PCIE_AXI_1_MASTER_WSTRB ),
        .TARGET_IN_WVALID      ( PCIE_AXI_1_MASTER_WVALID ),
        // Outputs
        .INITIATOR_OUT_ARADDR  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARADDR ),
        .INITIATOR_OUT_ARBURST ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARBURST ),
        .INITIATOR_OUT_ARID    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARID ),
        .INITIATOR_OUT_ARLEN   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARLEN ),
        .INITIATOR_OUT_ARSIZE  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE ),
        .INITIATOR_OUT_ARVALID ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARVALID ),
        .INITIATOR_OUT_AWADDR  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWADDR ),
        .INITIATOR_OUT_AWBURST ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWBURST ),
        .INITIATOR_OUT_AWID    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWID ),
        .INITIATOR_OUT_AWLEN   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWLEN ),
        .INITIATOR_OUT_AWSIZE  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE ),
        .INITIATOR_OUT_AWVALID ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWVALID ),
        .INITIATOR_OUT_BREADY  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BREADY ),
        .INITIATOR_OUT_RREADY  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RREADY ),
        .INITIATOR_OUT_WDATA   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WDATA ),
        .INITIATOR_OUT_WLAST   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WLAST ),
        .INITIATOR_OUT_WSTRB   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WSTRB ),
        .INITIATOR_OUT_WVALID  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WVALID ),
        .TARGET_OUT_ARREADY    ( PCIE_AXI_1_MASTER_ARREADY ),
        .TARGET_OUT_AWREADY    ( PCIE_AXI_1_MASTER_AWREADY ),
        .TARGET_OUT_BID        ( PCIE_AXI_1_MASTER_BID ),
        .TARGET_OUT_BRESP      ( PCIE_AXI_1_MASTER_BRESP ),
        .TARGET_OUT_BVALID     ( PCIE_AXI_1_MASTER_BVALID ),
        .TARGET_OUT_RDATA      ( PCIE_AXI_1_MASTER_RDATA ),
        .TARGET_OUT_RID        ( PCIE_AXI_1_MASTER_RID ),
        .TARGET_OUT_RLAST      ( PCIE_AXI_1_MASTER_RLAST ),
        .TARGET_OUT_RRESP      ( PCIE_AXI_1_MASTER_RRESP ),
        .TARGET_OUT_RVALID     ( PCIE_AXI_1_MASTER_RVALID ),
        .TARGET_OUT_WREADY     ( PCIE_AXI_1_MASTER_WREADY ) 
        );

//--------FIC_1_INITIATOR
FIC_1_INITIATOR FIC_1_INITIATOR_0(
        // Inputs
        .ACLK             ( ACLK ),
        .ARESETN          ( ARESETN ),
        .SLAVE0_AWREADY   ( FIC_1_INITIATOR_0_AXI4mslave0_AWREADY ),
        .SLAVE0_WREADY    ( FIC_1_INITIATOR_0_AXI4mslave0_WREADY ),
        .SLAVE0_BID       ( FIC_1_INITIATOR_0_AXI4mslave0_BID_0 ),
        .SLAVE0_BRESP     ( FIC_1_INITIATOR_0_AXI4mslave0_BRESP ),
        .SLAVE0_BVALID    ( FIC_1_INITIATOR_0_AXI4mslave0_BVALID ),
        .SLAVE0_ARREADY   ( FIC_1_INITIATOR_0_AXI4mslave0_ARREADY ),
        .SLAVE0_RID       ( FIC_1_INITIATOR_0_AXI4mslave0_RID_0 ),
        .SLAVE0_RDATA     ( FIC_1_INITIATOR_0_AXI4mslave0_RDATA ),
        .SLAVE0_RRESP     ( FIC_1_INITIATOR_0_AXI4mslave0_RRESP ),
        .SLAVE0_RLAST     ( FIC_1_INITIATOR_0_AXI4mslave0_RLAST ),
        .SLAVE0_RVALID    ( FIC_1_INITIATOR_0_AXI4mslave0_RVALID ),
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
        .MASTER0_AWVALID  ( AXI4mmaster0_MASTER0_AWVALID ),
        .MASTER0_WDATA    ( AXI4mmaster0_MASTER0_WDATA ),
        .MASTER0_WSTRB    ( AXI4mmaster0_MASTER0_WSTRB ),
        .MASTER0_WLAST    ( AXI4mmaster0_MASTER0_WLAST ),
        .MASTER0_WVALID   ( AXI4mmaster0_MASTER0_WVALID ),
        .MASTER0_BREADY   ( AXI4mmaster0_MASTER0_BREADY ),
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
        .MASTER0_ARVALID  ( AXI4mmaster0_MASTER0_ARVALID ),
        .MASTER0_RREADY   ( AXI4mmaster0_MASTER0_RREADY ),
        .MASTER0_AWUSER   ( AXI4mmaster0_MASTER0_AWUSER ),
        .MASTER0_WUSER    ( AXI4mmaster0_MASTER0_WUSER ),
        .MASTER0_ARUSER   ( AXI4mmaster0_MASTER0_ARUSER ),
        // Outputs
        .SLAVE0_AWID      ( FIC_1_INITIATOR_0_AXI4mslave0_AWID ),
        .SLAVE0_AWADDR    ( FIC_1_INITIATOR_0_AXI4mslave0_AWADDR ),
        .SLAVE0_AWLEN     ( FIC_1_INITIATOR_0_AXI4mslave0_AWLEN ),
        .SLAVE0_AWSIZE    ( FIC_1_INITIATOR_0_AXI4mslave0_AWSIZE ),
        .SLAVE0_AWBURST   ( FIC_1_INITIATOR_0_AXI4mslave0_AWBURST ),
        .SLAVE0_AWLOCK    ( FIC_1_INITIATOR_0_AXI4mslave0_AWLOCK ),
        .SLAVE0_AWCACHE   ( FIC_1_INITIATOR_0_AXI4mslave0_AWCACHE ),
        .SLAVE0_AWPROT    ( FIC_1_INITIATOR_0_AXI4mslave0_AWPROT ),
        .SLAVE0_AWQOS     ( FIC_1_INITIATOR_0_AXI4mslave0_AWQOS ),
        .SLAVE0_AWREGION  ( FIC_1_INITIATOR_0_AXI4mslave0_AWREGION ),
        .SLAVE0_AWVALID   ( FIC_1_INITIATOR_0_AXI4mslave0_AWVALID ),
        .SLAVE0_WDATA     ( FIC_1_INITIATOR_0_AXI4mslave0_WDATA ),
        .SLAVE0_WSTRB     ( FIC_1_INITIATOR_0_AXI4mslave0_WSTRB ),
        .SLAVE0_WLAST     ( FIC_1_INITIATOR_0_AXI4mslave0_WLAST ),
        .SLAVE0_WVALID    ( FIC_1_INITIATOR_0_AXI4mslave0_WVALID ),
        .SLAVE0_BREADY    ( FIC_1_INITIATOR_0_AXI4mslave0_BREADY ),
        .SLAVE0_ARID      ( FIC_1_INITIATOR_0_AXI4mslave0_ARID ),
        .SLAVE0_ARADDR    ( FIC_1_INITIATOR_0_AXI4mslave0_ARADDR ),
        .SLAVE0_ARLEN     ( FIC_1_INITIATOR_0_AXI4mslave0_ARLEN ),
        .SLAVE0_ARSIZE    ( FIC_1_INITIATOR_0_AXI4mslave0_ARSIZE ),
        .SLAVE0_ARBURST   ( FIC_1_INITIATOR_0_AXI4mslave0_ARBURST ),
        .SLAVE0_ARLOCK    ( FIC_1_INITIATOR_0_AXI4mslave0_ARLOCK ),
        .SLAVE0_ARCACHE   ( FIC_1_INITIATOR_0_AXI4mslave0_ARCACHE ),
        .SLAVE0_ARPROT    ( FIC_1_INITIATOR_0_AXI4mslave0_ARPROT ),
        .SLAVE0_ARQOS     ( FIC_1_INITIATOR_0_AXI4mslave0_ARQOS ),
        .SLAVE0_ARREGION  ( FIC_1_INITIATOR_0_AXI4mslave0_ARREGION ),
        .SLAVE0_ARVALID   ( FIC_1_INITIATOR_0_AXI4mslave0_ARVALID ),
        .SLAVE0_RREADY    ( FIC_1_INITIATOR_0_AXI4mslave0_RREADY ),
        .SLAVE0_AWUSER    ( FIC_1_INITIATOR_0_AXI4mslave0_AWUSER ),
        .SLAVE0_WUSER     ( FIC_1_INITIATOR_0_AXI4mslave0_WUSER ),
        .SLAVE0_ARUSER    ( FIC_1_INITIATOR_0_AXI4mslave0_ARUSER ),
        .MASTER0_AWREADY  ( AXI4mmaster0_AWREADY ),
        .MASTER0_WREADY   ( AXI4mmaster0_WREADY ),
        .MASTER0_BID      ( AXI4mmaster0_BID ),
        .MASTER0_BRESP    ( AXI4mmaster0_BRESP ),
        .MASTER0_BVALID   ( AXI4mmaster0_BVALID ),
        .MASTER0_ARREADY  ( AXI4mmaster0_ARREADY ),
        .MASTER0_RID      ( AXI4mmaster0_RID ),
        .MASTER0_RDATA    ( AXI4mmaster0_RDATA ),
        .MASTER0_RRESP    ( AXI4mmaster0_RRESP ),
        .MASTER0_RLAST    ( AXI4mmaster0_RLAST ),
        .MASTER0_RVALID   ( AXI4mmaster0_RVALID ),
        .MASTER0_BUSER    ( AXI4mmaster0_BUSER ),
        .MASTER0_RUSER    ( AXI4mmaster0_RUSER ) 
        );

//--------PF_PCIE_C0
PF_PCIE_C0 PCIE(
        // Inputs
        .INIT_DONE                  ( PCIe_INIT_DONE ),
        .APB_S_PRESET_N             ( PRESETN ),
        .APB_S_PCLK                 ( PCLK ),
        .PCIESS_AXI_1_S_ARBURST     ( FIC_1_INITIATOR_0_AXI4mslave0_ARBURST ),
        .PCIESS_AXI_1_S_ARID        ( FIC_1_INITIATOR_0_AXI4mslave0_ARID_0 ),
        .PCIESS_AXI_1_S_ARLEN       ( FIC_1_INITIATOR_0_AXI4mslave0_ARLEN ),
        .PCIESS_AXI_1_S_ARSIZE      ( FIC_1_INITIATOR_0_AXI4mslave0_ARSIZE_0 ),
        .PCIESS_AXI_1_S_ARVALID     ( FIC_1_INITIATOR_0_AXI4mslave0_ARVALID ),
        .PCIESS_AXI_1_S_AWBURST     ( FIC_1_INITIATOR_0_AXI4mslave0_AWBURST ),
        .PCIESS_AXI_1_S_AWID        ( FIC_1_INITIATOR_0_AXI4mslave0_AWID_0 ),
        .PCIESS_AXI_1_S_AWLEN       ( FIC_1_INITIATOR_0_AXI4mslave0_AWLEN ),
        .PCIESS_AXI_1_S_AWSIZE      ( FIC_1_INITIATOR_0_AXI4mslave0_AWSIZE_0 ),
        .PCIESS_AXI_1_S_AWVALID     ( FIC_1_INITIATOR_0_AXI4mslave0_AWVALID ),
        .PCIESS_AXI_1_S_BREADY      ( FIC_1_INITIATOR_0_AXI4mslave0_BREADY ),
        .PCIESS_AXI_1_S_RREADY      ( FIC_1_INITIATOR_0_AXI4mslave0_RREADY ),
        .PCIESS_AXI_1_S_WSTRB       ( FIC_1_INITIATOR_0_AXI4mslave0_WSTRB ),
        .PCIESS_AXI_1_S_WLAST       ( FIC_1_INITIATOR_0_AXI4mslave0_WLAST ),
        .PCIESS_AXI_1_S_WVALID      ( FIC_1_INITIATOR_0_AXI4mslave0_WVALID ),
        .PCIESS_AXI_1_S_AWADDR      ( FIC_1_INITIATOR_0_AXI4mslave0_AWADDR_0 ),
        .PCIESS_AXI_1_S_WDATA       ( FIC_1_INITIATOR_0_AXI4mslave0_WDATA ),
        .PCIESS_AXI_1_S_ARADDR      ( FIC_1_INITIATOR_0_AXI4mslave0_ARADDR_0 ),
        .PCIESS_AXI_1_M_ARREADY     ( PCIE_AXI_1_MASTER_ARREADY ),
        .PCIESS_AXI_1_M_AWREADY     ( PCIE_AXI_1_MASTER_AWREADY ),
        .PCIESS_AXI_1_M_BID         ( PCIE_AXI_1_MASTER_BID ),
        .PCIESS_AXI_1_M_BRESP       ( PCIE_AXI_1_MASTER_BRESP ),
        .PCIESS_AXI_1_M_BVALID      ( PCIE_AXI_1_MASTER_BVALID ),
        .PCIESS_AXI_1_M_RID         ( PCIE_AXI_1_MASTER_RID ),
        .PCIESS_AXI_1_M_RRESP       ( PCIE_AXI_1_MASTER_RRESP ),
        .PCIESS_AXI_1_M_RLAST       ( PCIE_AXI_1_MASTER_RLAST ),
        .PCIESS_AXI_1_M_RVALID      ( PCIE_AXI_1_MASTER_RVALID ),
        .PCIESS_AXI_1_M_WREADY      ( PCIE_AXI_1_MASTER_WREADY ),
        .PCIESS_AXI_1_M_RDATA       ( PCIE_AXI_1_MASTER_RDATA ),
        .PCIESS_LANE0_DRI_CLK       ( PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CLK ),
        .PCIESS_LANE0_DRI_CTRL      ( PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CTRL ),
        .PCIESS_LANE0_DRI_WDATA     ( PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_WDATA ),
        .PCIESS_LANE0_DRI_ARST_N    ( PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_ARST_N ),
        .PCIESS_LANE1_DRI_CLK       ( PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CLK ),
        .PCIESS_LANE1_DRI_CTRL      ( PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CTRL ),
        .PCIESS_LANE1_DRI_WDATA     ( PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_WDATA ),
        .PCIESS_LANE1_DRI_ARST_N    ( PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_ARST_N ),
        .PCIESS_LANE2_DRI_CLK       ( PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CLK ),
        .PCIESS_LANE2_DRI_CTRL      ( PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CTRL ),
        .PCIESS_LANE2_DRI_WDATA     ( PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_WDATA ),
        .PCIESS_LANE2_DRI_ARST_N    ( PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_ARST_N ),
        .PCIESS_LANE3_DRI_CLK       ( PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CLK ),
        .PCIESS_LANE3_DRI_CTRL      ( PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CTRL ),
        .PCIESS_LANE3_DRI_WDATA     ( PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_WDATA ),
        .PCIESS_LANE3_DRI_ARST_N    ( PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_ARST_N ),
        .APB_S_PSEL                 ( PCIE_APB_SLAVE_APB_S_PSEL ),
        .APB_S_PENABLE              ( PCIE_APB_SLAVE_APB_S_PENABLE ),
        .APB_S_PWRITE               ( PCIE_APB_SLAVE_APB_S_PWRITE ),
        .APB_S_PADDR                ( PCIE_APB_SLAVE_APB_S_PADDR ),
        .APB_S_PWDATA               ( PCIE_APB_SLAVE_APB_S_PWDATA ),
        .PCIE_1_TX_PLL_LOCK         ( CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_LOCK ),
        .PCIE_1_TX_BIT_CLK          ( CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_BIT_CLK ),
        .PCIE_1_TX_PLL_REF_CLK      ( CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_REF_CLK ),
        .PCIESS_LANE_RXD0_P         ( PCIESS_LANE_RXD0_P ),
        .PCIESS_LANE_RXD0_N         ( PCIESS_LANE_RXD0_N ),
        .PCIESS_LANE_RXD1_P         ( PCIESS_LANE_RXD1_P ),
        .PCIESS_LANE_RXD1_N         ( PCIESS_LANE_RXD1_N ),
        .PCIESS_LANE_RXD2_P         ( PCIESS_LANE_RXD2_P ),
        .PCIESS_LANE_RXD2_N         ( PCIESS_LANE_RXD2_N ),
        .PCIESS_LANE_RXD3_P         ( PCIESS_LANE_RXD3_P ),
        .PCIESS_LANE_RXD3_N         ( PCIESS_LANE_RXD3_N ),
        .PCIESS_LANE0_CDR_REF_CLK_0 ( PCIe_REFERENCE_CLK ),
        .AXI_CLK                    ( ACLK ),
        .AXI_CLK_STABLE             ( ARESETN ),
        .PCIESS_LANE1_CDR_REF_CLK_0 ( PCIe_REFERENCE_CLK ),
        .PCIESS_LANE2_CDR_REF_CLK_0 ( PCIe_REFERENCE_CLK ),
        .PCIESS_LANE3_CDR_REF_CLK_0 ( PCIe_REFERENCE_CLK ),
        .PCIE_1_TL_CLK_125MHz       ( PCIe_CLK_125MHz ),
        .PCIE_1_INTERRUPT           ( PCIE_1_INTERRUPT_const_net_0 ),
        .PCIE_1_M_RDERR             ( GND_net ),
        .PCIE_1_S_WDERR             ( GND_net ),
        // Outputs
        .PCIESS_AXI_1_S_ARREADY     ( FIC_1_INITIATOR_0_AXI4mslave0_ARREADY ),
        .PCIESS_AXI_1_S_AWREADY     ( FIC_1_INITIATOR_0_AXI4mslave0_AWREADY ),
        .PCIESS_AXI_1_S_BID         ( FIC_1_INITIATOR_0_AXI4mslave0_BID ),
        .PCIESS_AXI_1_S_BRESP       ( FIC_1_INITIATOR_0_AXI4mslave0_BRESP ),
        .PCIESS_AXI_1_S_BVALID      ( FIC_1_INITIATOR_0_AXI4mslave0_BVALID ),
        .PCIESS_AXI_1_S_RID         ( FIC_1_INITIATOR_0_AXI4mslave0_RID ),
        .PCIESS_AXI_1_S_RRESP       ( FIC_1_INITIATOR_0_AXI4mslave0_RRESP ),
        .PCIESS_AXI_1_S_RLAST       ( FIC_1_INITIATOR_0_AXI4mslave0_RLAST ),
        .PCIESS_AXI_1_S_RVALID      ( FIC_1_INITIATOR_0_AXI4mslave0_RVALID ),
        .PCIESS_AXI_1_S_WREADY      ( FIC_1_INITIATOR_0_AXI4mslave0_WREADY ),
        .PCIESS_AXI_1_S_RDATA       ( FIC_1_INITIATOR_0_AXI4mslave0_RDATA ),
        .PCIESS_AXI_1_M_ARBURST     ( PCIE_AXI_1_MASTER_ARBURST ),
        .PCIESS_AXI_1_M_ARLEN       ( PCIE_AXI_1_MASTER_ARLEN ),
        .PCIESS_AXI_1_M_ARSIZE      ( PCIE_AXI_1_MASTER_ARSIZE ),
        .PCIESS_AXI_1_M_ARVALID     ( PCIE_AXI_1_MASTER_ARVALID ),
        .PCIESS_AXI_1_M_AWBURST     ( PCIE_AXI_1_MASTER_AWBURST ),
        .PCIESS_AXI_1_M_AWLEN       ( PCIE_AXI_1_MASTER_AWLEN ),
        .PCIESS_AXI_1_M_AWSIZE      ( PCIE_AXI_1_MASTER_AWSIZE ),
        .PCIESS_AXI_1_M_AWVALID     ( PCIE_AXI_1_MASTER_AWVALID ),
        .PCIESS_AXI_1_M_BREADY      ( PCIE_AXI_1_MASTER_BREADY ),
        .PCIESS_AXI_1_M_RREADY      ( PCIE_AXI_1_MASTER_RREADY ),
        .PCIESS_AXI_1_M_WSTRB       ( PCIE_AXI_1_MASTER_WSTRB ),
        .PCIESS_AXI_1_M_WLAST       ( PCIE_AXI_1_MASTER_WLAST ),
        .PCIESS_AXI_1_M_WVALID      ( PCIE_AXI_1_MASTER_WVALID ),
        .PCIESS_AXI_1_M_ARID        ( PCIE_AXI_1_MASTER_ARID ),
        .PCIESS_AXI_1_M_AWADDR      ( PCIE_AXI_1_MASTER_AWADDR ),
        .PCIESS_AXI_1_M_WDATA       ( PCIE_AXI_1_MASTER_WDATA ),
        .PCIESS_AXI_1_M_AWID        ( PCIE_AXI_1_MASTER_AWID ),
        .PCIESS_AXI_1_M_ARADDR      ( PCIE_AXI_1_MASTER_ARADDR ),
        .PCIESS_LANE0_DRI_RDATA     ( Q0_LANE0_DRI_SLAVE_DRI_RDATA ),
        .PCIESS_LANE0_DRI_INTERRUPT ( Q0_LANE0_DRI_SLAVE_DRI_INTERRUPT ),
        .PCIESS_LANE1_DRI_RDATA     ( Q0_LANE1_DRI_SLAVE_DRI_RDATA ),
        .PCIESS_LANE1_DRI_INTERRUPT ( Q0_LANE1_DRI_SLAVE_DRI_INTERRUPT ),
        .PCIESS_LANE2_DRI_RDATA     ( Q0_LANE2_DRI_SLAVE_DRI_RDATA ),
        .PCIESS_LANE2_DRI_INTERRUPT ( Q0_LANE2_DRI_SLAVE_DRI_INTERRUPT ),
        .PCIESS_LANE3_DRI_RDATA     ( Q0_LANE3_DRI_SLAVE_DRI_RDATA ),
        .PCIESS_LANE3_DRI_INTERRUPT ( Q0_LANE3_DRI_SLAVE_DRI_INTERRUPT ),
        .APB_S_PREADY               ( APB_SLAVE_PREADY ),
        .APB_S_PRDATA               ( APB_SLAVE_PRDATA ),
        .APB_S_PSLVERR              ( APB_SLAVE_PSLVERR ),
        .PCIESS_LANE_TXD0_P         ( PCIESS_LANE_TXD0_P_net_0 ),
        .PCIESS_LANE_TXD0_N         ( PCIESS_LANE_TXD0_N_net_0 ),
        .PCIESS_LANE_TXD1_P         ( PCIESS_LANE_TXD1_P_net_0 ),
        .PCIESS_LANE_TXD1_N         ( PCIESS_LANE_TXD1_N_net_0 ),
        .PCIESS_LANE_TXD2_P         ( PCIESS_LANE_TXD2_P_net_0 ),
        .PCIESS_LANE_TXD2_N         ( PCIESS_LANE_TXD2_N_net_0 ),
        .PCIESS_LANE_TXD3_P         ( PCIESS_LANE_TXD3_P_net_0 ),
        .PCIESS_LANE_TXD3_N         ( PCIESS_LANE_TXD3_N_net_0 ),
        .PCIE_1_LTSSM               (  ),
        .PCIE_1_INTERRUPT_OUT       ( PCIe_IRQ_net_0 ),
        .PCIE_1_PERST_OUT_N         ( PCIE_1_PERST_N_net_0 ),
        .PCIE_1_M_WDERR             (  ),
        .PCIE_1_S_RDERR             (  ),
        .PCIE_1_HOT_RST_EXIT        (  ),
        .PCIE_1_DLUP_EXIT           (  ) 
        );

//--------PCIE_INITIATOR
PCIE_INITIATOR PCIE_INITIATOR_inst_0(
        // Inputs
        .ACLK             ( ACLK ),
        .ARESETN          ( ARESETN ),
        .SLAVE0_AWREADY   ( AXI4mslave0_SLAVE0_AWREADY ),
        .SLAVE0_WREADY    ( AXI4mslave0_SLAVE0_WREADY ),
        .SLAVE0_BID       ( AXI4mslave0_SLAVE0_BID ),
        .SLAVE0_BRESP     ( AXI4mslave0_SLAVE0_BRESP ),
        .SLAVE0_BVALID    ( AXI4mslave0_SLAVE0_BVALID ),
        .SLAVE0_ARREADY   ( AXI4mslave0_SLAVE0_ARREADY ),
        .SLAVE0_RID       ( AXI4mslave0_SLAVE0_RID ),
        .SLAVE0_RDATA     ( AXI4mslave0_SLAVE0_RDATA ),
        .SLAVE0_RRESP     ( AXI4mslave0_SLAVE0_RRESP ),
        .SLAVE0_RLAST     ( AXI4mslave0_SLAVE0_RLAST ),
        .SLAVE0_RVALID    ( AXI4mslave0_SLAVE0_RVALID ),
        .SLAVE0_BUSER     ( AXI4mslave0_SLAVE0_BUSER ),
        .SLAVE0_RUSER     ( AXI4mslave0_SLAVE0_RUSER ),
        .MASTER0_AWID     ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWID ),
        .MASTER0_AWADDR   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWADDR ),
        .MASTER0_AWLEN    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWLEN ),
        .MASTER0_AWSIZE   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWSIZE_0 ),
        .MASTER0_AWBURST  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWBURST ),
        .MASTER0_AWLOCK   ( MASTER0_AWLOCK_const_net_0 ), // tied to 2'h0 from definition
        .MASTER0_AWCACHE  ( MASTER0_AWCACHE_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_AWPROT   ( MASTER0_AWPROT_const_net_0 ), // tied to 3'h0 from definition
        .MASTER0_AWQOS    ( MASTER0_AWQOS_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_AWREGION ( MASTER0_AWREGION_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_AWVALID  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWVALID ),
        .MASTER0_WDATA    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WDATA ),
        .MASTER0_WSTRB    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WSTRB ),
        .MASTER0_WLAST    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WLAST ),
        .MASTER0_WVALID   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WVALID ),
        .MASTER0_BREADY   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BREADY ),
        .MASTER0_ARID     ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARID ),
        .MASTER0_ARADDR   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARADDR ),
        .MASTER0_ARLEN    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARLEN ),
        .MASTER0_ARSIZE   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARSIZE_0 ),
        .MASTER0_ARBURST  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARBURST ),
        .MASTER0_ARLOCK   ( MASTER0_ARLOCK_const_net_0 ), // tied to 2'h0 from definition
        .MASTER0_ARCACHE  ( MASTER0_ARCACHE_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_ARPROT   ( MASTER0_ARPROT_const_net_0 ), // tied to 3'h0 from definition
        .MASTER0_ARQOS    ( MASTER0_ARQOS_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_ARREGION ( MASTER0_ARREGION_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_ARVALID  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARVALID ),
        .MASTER0_RREADY   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RREADY ),
        .MASTER0_AWUSER   ( GND_net ), // tied to 1'b0 from definition
        .MASTER0_WUSER    ( GND_net ), // tied to 1'b0 from definition
        .MASTER0_ARUSER   ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .SLAVE0_AWID      ( AXI4mslave0_AWID ),
        .SLAVE0_AWADDR    ( AXI4mslave0_AWADDR ),
        .SLAVE0_AWLEN     ( AXI4mslave0_AWLEN ),
        .SLAVE0_AWSIZE    ( AXI4mslave0_AWSIZE ),
        .SLAVE0_AWBURST   ( AXI4mslave0_AWBURST ),
        .SLAVE0_AWLOCK    ( AXI4mslave0_AWLOCK ),
        .SLAVE0_AWCACHE   ( AXI4mslave0_AWCACHE ),
        .SLAVE0_AWPROT    ( AXI4mslave0_AWPROT ),
        .SLAVE0_AWQOS     ( AXI4mslave0_AWQOS ),
        .SLAVE0_AWREGION  ( AXI4mslave0_AWREGION ),
        .SLAVE0_AWVALID   ( AXI4mslave0_AWVALID ),
        .SLAVE0_WDATA     ( AXI4mslave0_WDATA ),
        .SLAVE0_WSTRB     ( AXI4mslave0_WSTRB ),
        .SLAVE0_WLAST     ( AXI4mslave0_WLAST ),
        .SLAVE0_WVALID    ( AXI4mslave0_WVALID ),
        .SLAVE0_BREADY    ( AXI4mslave0_BREADY ),
        .SLAVE0_ARID      ( AXI4mslave0_ARID ),
        .SLAVE0_ARADDR    ( AXI4mslave0_ARADDR ),
        .SLAVE0_ARLEN     ( AXI4mslave0_ARLEN ),
        .SLAVE0_ARSIZE    ( AXI4mslave0_ARSIZE ),
        .SLAVE0_ARBURST   ( AXI4mslave0_ARBURST ),
        .SLAVE0_ARLOCK    ( AXI4mslave0_ARLOCK ),
        .SLAVE0_ARCACHE   ( AXI4mslave0_ARCACHE ),
        .SLAVE0_ARPROT    ( AXI4mslave0_ARPROT ),
        .SLAVE0_ARQOS     ( AXI4mslave0_ARQOS ),
        .SLAVE0_ARREGION  ( AXI4mslave0_ARREGION ),
        .SLAVE0_ARVALID   ( AXI4mslave0_ARVALID ),
        .SLAVE0_RREADY    ( AXI4mslave0_RREADY ),
        .SLAVE0_AWUSER    ( AXI4mslave0_AWUSER ),
        .SLAVE0_WUSER     ( AXI4mslave0_WUSER ),
        .SLAVE0_ARUSER    ( AXI4mslave0_ARUSER ),
        .MASTER0_AWREADY  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_AWREADY ),
        .MASTER0_WREADY   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_WREADY ),
        .MASTER0_BID      ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BID ),
        .MASTER0_BRESP    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BRESP ),
        .MASTER0_BVALID   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BVALID ),
        .MASTER0_ARREADY  ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_ARREADY ),
        .MASTER0_RID      ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RID ),
        .MASTER0_RDATA    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RDATA ),
        .MASTER0_RRESP    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RRESP ),
        .MASTER0_RLAST    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RLAST ),
        .MASTER0_RVALID   ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RVALID ),
        .MASTER0_BUSER    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_BUSER ),
        .MASTER0_RUSER    ( AXI_ADDRESS_SHIM_0_AXI4_INITIATOR_RUSER ) 
        );


endmodule
