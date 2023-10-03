`timescale 1ns / 1ns
///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: MICROSEMI
//
// IP Core: COREAXI4INTERCONNECT
//
//  Description  : The AMBA AXI4 Interconnect core connects one or more AXI memory-mapped master devices to one or
//                 more memory-mapped slave devices. The AMBA AXI protocol supports high-performance, high-frequency
//                 system designs.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_DownConverter( MASTER_ARADDR,
                      MASTER_ARBURST,
                      MASTER_ARCACHE,
                      MASTER_ARID,
                      MASTER_ARLEN,
                      MASTER_ARLOCK,
                      MASTER_ARPROT,
                      MASTER_ARQOS,
                      MASTER_ARREADY,
                      MASTER_ARREGION,
                      MASTER_ARSIZE,
                      MASTER_ARUSER,
                      MASTER_ARVALID,
                      MASTER_RDATA,
                      MASTER_RID,
                      MASTER_RLAST,
                      MASTER_RREADY,
                      MASTER_RRESP,
                      MASTER_RUSER,
                      MASTER_RVALID,
                      MASTER_AWADDR,
                      MASTER_AWBURST,
                      MASTER_AWCACHE,
                      MASTER_AWID,
                      MASTER_AWLEN,
                      MASTER_AWLOCK,
                      MASTER_AWPROT,
                      MASTER_AWQOS,
                      MASTER_AWREADY,
                      MASTER_AWREGION,
                      MASTER_AWSIZE,
                      MASTER_AWUSER,
                      MASTER_AWVALID,
					  MASTER_WID,
                      MASTER_WDATA,
                      MASTER_WLAST,
                      MASTER_WREADY,
                      MASTER_WSTRB,
                      MASTER_WUSER,
                      MASTER_WVALID,
                      ACLK,
                      sysReset,
                      SLAVE_BID,
                      SLAVE_BREADY,
                      SLAVE_BRESP,
                      SLAVE_BUSER,
                      SLAVE_BVALID,
                      SLAVE_ARADDR,
                      SLAVE_ARBURST,
                      SLAVE_ARCACHE,
                      SLAVE_ARID,
                      SLAVE_ARLEN,
                      SLAVE_ARLOCK,
                      SLAVE_ARPROT,
                      SLAVE_ARQOS,
                      SLAVE_ARREADY,
                      SLAVE_ARREGION,
                      SLAVE_ARSIZE,
                      SLAVE_ARUSER,
                      SLAVE_ARVALID,
                      SLAVE_AWADDR,
                      SLAVE_AWBURST,
                      SLAVE_AWCACHE,
                      SLAVE_AWID,
                      SLAVE_AWLEN,
                      SLAVE_AWLOCK,
                      SLAVE_AWPROT,
                      SLAVE_AWQOS,
                      SLAVE_AWREADY,
                      SLAVE_AWREGION,
                      SLAVE_AWSIZE,
                      SLAVE_AWUSER,
                      SLAVE_AWVALID,
                      SLAVE_RDATA,
                      SLAVE_RID,
                      SLAVE_RLAST,
                      SLAVE_RREADY,
                      SLAVE_RRESP,
                      SLAVE_RUSER,
                      SLAVE_RVALID,
					  SLAVE_WID,
                      SLAVE_WDATA,
                      SLAVE_WLAST,
                      SLAVE_WREADY,
                      SLAVE_WSTRB,
                      SLAVE_WUSER,
                      SLAVE_WVALID,
                      MASTER_BID,
                      MASTER_BREADY,
                      MASTER_BRESP,
                      MASTER_BUSER,
                      MASTER_BVALID );

parameter ADDR_FIFO_DEPTH = 5; 
parameter DATA_WIDTH_IN = 32; 
parameter DATA_WIDTH_OUT = 32; 
parameter ADDR_WIDTH = 20; 
parameter ID_WIDTH = 1; 
parameter USER_WIDTH = 1; 
parameter STRB_WIDTH_IN = 64; 
parameter STRB_WIDTH_OUT = 4; 
parameter READ_INTERLEAVE = 0; 

// Port: MASTER_ARChan

input [ADDR_WIDTH-1:0] MASTER_ARADDR;
input [1:0]    MASTER_ARBURST;
input [3:0]    MASTER_ARCACHE;
input [ID_WIDTH-1:0] MASTER_ARID;
input [7:0]    MASTER_ARLEN;
input [1:0]    MASTER_ARLOCK;
input [2:0]    MASTER_ARPROT;
input [3:0]    MASTER_ARQOS;
output         MASTER_ARREADY;
input [3:0]    MASTER_ARREGION;
input [2:0]    MASTER_ARSIZE;
input [USER_WIDTH-1:0] MASTER_ARUSER;
input          MASTER_ARVALID;

// Port: MASTER_RChan

output [DATA_WIDTH_IN-1:0] MASTER_RDATA;
output [ID_WIDTH-1:0] MASTER_RID;
output         MASTER_RLAST;
input          MASTER_RREADY;
output [1:0]   MASTER_RRESP;
output [USER_WIDTH-1:0] MASTER_RUSER;
output         MASTER_RVALID;

// Port: MASTER_AWChan

input [ADDR_WIDTH-1:0] MASTER_AWADDR;
input [1:0]    MASTER_AWBURST;
input [3:0]    MASTER_AWCACHE;
input [ID_WIDTH-1:0] MASTER_AWID;
input [7:0]    MASTER_AWLEN;
input [1:0]    MASTER_AWLOCK;
input [2:0]    MASTER_AWPROT;
input [3:0]    MASTER_AWQOS;
output         MASTER_AWREADY;
input [3:0]    MASTER_AWREGION;
input [2:0]    MASTER_AWSIZE;
input [USER_WIDTH-1:0] MASTER_AWUSER;
input          MASTER_AWVALID;

// Port: MASTER_WChan

input [ID_WIDTH-1:0]      MASTER_WID;
input [DATA_WIDTH_IN-1:0] MASTER_WDATA;
input          MASTER_WLAST;
output         MASTER_WREADY;
input [STRB_WIDTH_IN-1:0] MASTER_WSTRB;
input [USER_WIDTH-1:0] MASTER_WUSER;
input          MASTER_WVALID;

// Port: system

input          ACLK;
input          sysReset;

// Port: SLAVE_BChan

input [ID_WIDTH-1:0] SLAVE_BID;
output         SLAVE_BREADY;
input [1:0]    SLAVE_BRESP;
input [USER_WIDTH-1:0] SLAVE_BUSER;
input          SLAVE_BVALID;

// Port: SLAVE_ARChan

output [ADDR_WIDTH-1:0] SLAVE_ARADDR;
output [1:0]   SLAVE_ARBURST;
output [3:0]   SLAVE_ARCACHE;
output [ID_WIDTH-1:0] SLAVE_ARID;
output [7:0]   SLAVE_ARLEN;
output [1:0]   SLAVE_ARLOCK;
output [2:0]   SLAVE_ARPROT;
output [3:0]   SLAVE_ARQOS;
input          SLAVE_ARREADY;
output [3:0]   SLAVE_ARREGION;
output [2:0]   SLAVE_ARSIZE;
output [USER_WIDTH-1:0] SLAVE_ARUSER;
output         SLAVE_ARVALID;

// Port: SLAVE_AWChan

output [ADDR_WIDTH-1:0] SLAVE_AWADDR;
output [1:0]   SLAVE_AWBURST;
output [3:0]   SLAVE_AWCACHE;
output [ID_WIDTH-1:0] SLAVE_AWID;
output [7:0]   SLAVE_AWLEN;
output [1:0]   SLAVE_AWLOCK;
output [2:0]   SLAVE_AWPROT;
output [3:0]   SLAVE_AWQOS;
input          SLAVE_AWREADY;
output [3:0]   SLAVE_AWREGION;
output [2:0]   SLAVE_AWSIZE;
output [USER_WIDTH-1:0] SLAVE_AWUSER;
output         SLAVE_AWVALID;

// Port: SLAVE_RChan

input [DATA_WIDTH_OUT-1:0] SLAVE_RDATA;
input [ID_WIDTH-1:0] SLAVE_RID;
input          SLAVE_RLAST;
output         SLAVE_RREADY;
input [1:0]    SLAVE_RRESP;
input [USER_WIDTH-1:0] SLAVE_RUSER;
input          SLAVE_RVALID;

// Port: SLAVE_WChan

output [ID_WIDTH-1:0]       SLAVE_WID;
output [DATA_WIDTH_OUT-1:0] SLAVE_WDATA;
output         SLAVE_WLAST;
input          SLAVE_WREADY;
output [STRB_WIDTH_OUT-1:0] SLAVE_WSTRB;
output [USER_WIDTH-1:0] SLAVE_WUSER;
output         SLAVE_WVALID;

// Port: MASTER_BChan

output [ID_WIDTH-1:0] MASTER_BID;
input          MASTER_BREADY;
output [1:0]   MASTER_BRESP;
output [USER_WIDTH-1:0] MASTER_BUSER;
output         MASTER_BVALID;



/// I/O_End <<<---






/// Components_Start --->>>

// write data width conversion
// File: writeWidthConv.v

defparam writeWidthConv.CMD_FIFO_DATA_WIDTH = 37+ID_WIDTH;
defparam writeWidthConv.DATA_WIDTH_IN = DATA_WIDTH_IN;
defparam writeWidthConv.DATA_WIDTH_OUT = DATA_WIDTH_OUT;
defparam writeWidthConv.ADDR_FIFO_DEPTH = ADDR_FIFO_DEPTH;
defparam writeWidthConv.ADDR_WIDTH = ADDR_WIDTH;
defparam writeWidthConv.ID_WIDTH = ID_WIDTH;
defparam writeWidthConv.USER_WIDTH = USER_WIDTH;
defparam writeWidthConv.STRB_WIDTH_IN = STRB_WIDTH_IN;
defparam writeWidthConv.STRB_WIDTH_OUT = STRB_WIDTH_OUT;
defparam writeWidthConv.READ_INTERLEAVE = READ_INTERLEAVE;


caxi4interconnect_DWC_DownConv_writeWidthConv writeWidthConv( .MASTER_AWREADY(MASTER_AWREADY),
                               .MASTER_AWADDR(MASTER_AWADDR),
                               .MASTER_AWBURST(MASTER_AWBURST),
                               .MASTER_AWCACHE(MASTER_AWCACHE),
                               .MASTER_AWID(MASTER_AWID),
                               .MASTER_AWLEN(MASTER_AWLEN),
                               .MASTER_AWLOCK(MASTER_AWLOCK),
                               .MASTER_AWPROT(MASTER_AWPROT),
                               .MASTER_AWQOS(MASTER_AWQOS),
                               .MASTER_AWREGION(MASTER_AWREGION),
                               .MASTER_AWSIZE(MASTER_AWSIZE),
                               .MASTER_AWUSER(MASTER_AWUSER),
                               .MASTER_AWVALID(MASTER_AWVALID),
                               .SLAVE_BID(SLAVE_BID),
                               .SLAVE_BREADY(SLAVE_BREADY),
                               .SLAVE_BRESP(SLAVE_BRESP),
                               .SLAVE_BUSER(SLAVE_BUSER),
                               .SLAVE_BVALID(SLAVE_BVALID),
                               .SLAVE_AWADDR(SLAVE_AWADDR),
                               .SLAVE_AWBURST(SLAVE_AWBURST),
                               .SLAVE_AWCACHE(SLAVE_AWCACHE),
                               .SLAVE_AWID(SLAVE_AWID),
                               .SLAVE_AWLEN(SLAVE_AWLEN),
                               .SLAVE_AWLOCK(SLAVE_AWLOCK),
                               .SLAVE_AWPROT(SLAVE_AWPROT),
                               .SLAVE_AWQOS(SLAVE_AWQOS),
                               .SLAVE_AWREADY(SLAVE_AWREADY),
                               .SLAVE_AWREGION(SLAVE_AWREGION),
                               .SLAVE_AWSIZE(SLAVE_AWSIZE),
                               .SLAVE_AWUSER(SLAVE_AWUSER),
                               .SLAVE_AWVALID(SLAVE_AWVALID),
                               .MASTER_BID(MASTER_BID),
                               .MASTER_BREADY(MASTER_BREADY),
                               .MASTER_BRESP(MASTER_BRESP),
                               .MASTER_BUSER(MASTER_BUSER),
                               .MASTER_BVALID(MASTER_BVALID),
							   .MASTER_WID (MASTER_WID),
                               .MASTER_WDATA(MASTER_WDATA),
                               .MASTER_WLAST(MASTER_WLAST),
                               .MASTER_WREADY(MASTER_WREADY),
                               .MASTER_WSTRB(MASTER_WSTRB),
                               .MASTER_WUSER(MASTER_WUSER),
                               .MASTER_WVALID(MASTER_WVALID),
							   .SLAVE_WID  (SLAVE_WID),
                               .SLAVE_WDATA(SLAVE_WDATA),
                               .SLAVE_WLAST(SLAVE_WLAST),
                               .SLAVE_WREADY(SLAVE_WREADY),
                               .SLAVE_WSTRB(SLAVE_WSTRB),
                               .SLAVE_WUSER(SLAVE_WUSER),
                               .SLAVE_WVALID(SLAVE_WVALID),
                               .ACLK(ACLK),
                               .sysReset(sysReset) );

// read width converter
// File: readWidthConv.v

defparam readWidthConv.DATA_WIDTH_IN = DATA_WIDTH_OUT;
defparam readWidthConv.ADDR_FIFO_DEPTH = ADDR_FIFO_DEPTH;
defparam readWidthConv.CMD_FIFO_DATA_WIDTH = 37+ID_WIDTH;
defparam readWidthConv.DATA_WIDTH_OUT = DATA_WIDTH_IN;
defparam readWidthConv.ADDR_WIDTH = ADDR_WIDTH;
defparam readWidthConv.ID_WIDTH = ID_WIDTH;
defparam readWidthConv.USER_WIDTH = USER_WIDTH;
defparam readWidthConv.READ_INTERLEAVE = READ_INTERLEAVE;

caxi4interconnect_DWC_DownConv_readWidthConv readWidthConv( .MASTER_ARADDR(MASTER_ARADDR),
                             .MASTER_ARBURST(MASTER_ARBURST),
                             .MASTER_ARCACHE(MASTER_ARCACHE),
                             .MASTER_ARID(MASTER_ARID),
                             .MASTER_ARLEN(MASTER_ARLEN),
                             .MASTER_ARLOCK(MASTER_ARLOCK),
                             .MASTER_ARPROT(MASTER_ARPROT),
                             .MASTER_ARQOS(MASTER_ARQOS),
                             .MASTER_ARREADY(MASTER_ARREADY),
                             .MASTER_ARREGION(MASTER_ARREGION),
                             .MASTER_ARSIZE(MASTER_ARSIZE),
                             .MASTER_ARUSER(MASTER_ARUSER),
                             .MASTER_ARVALID(MASTER_ARVALID),
                             .MASTER_RDATA(MASTER_RDATA),
                             .MASTER_RID(MASTER_RID),
                             .MASTER_RLAST(MASTER_RLAST),
                             .MASTER_RREADY(MASTER_RREADY),
                             .MASTER_RRESP(MASTER_RRESP),
                             .MASTER_RUSER(MASTER_RUSER),
                             .MASTER_RVALID(MASTER_RVALID),
                             .SLAVE_RDATA(SLAVE_RDATA),
                             .SLAVE_RID(SLAVE_RID),
                             .SLAVE_RLAST(SLAVE_RLAST),
                             .SLAVE_RREADY(SLAVE_RREADY),
                             .SLAVE_RRESP(SLAVE_RRESP),
                             .SLAVE_RUSER(SLAVE_RUSER),
                             .SLAVE_RVALID(SLAVE_RVALID),
                             .SLAVE_ARADDR(SLAVE_ARADDR),
                             .SLAVE_ARBURST(SLAVE_ARBURST),
                             .SLAVE_ARCACHE(SLAVE_ARCACHE),
                             .SLAVE_ARID(SLAVE_ARID),
                             .SLAVE_ARLEN(SLAVE_ARLEN),
                             .SLAVE_ARLOCK(SLAVE_ARLOCK),
                             .SLAVE_ARPROT(SLAVE_ARPROT),
                             .SLAVE_ARQOS(SLAVE_ARQOS),
                             .SLAVE_ARREADY(SLAVE_ARREADY),
                             .SLAVE_ARREGION(SLAVE_ARREGION),
                             .SLAVE_ARVALID(SLAVE_ARVALID),
                             .SLAVE_ASIZE(SLAVE_ARSIZE),
                             .SLAVE_AUSER(SLAVE_ARUSER),
                             .ACLK(ACLK),
                             .sysReset(sysReset) );




/// Components_End <<<---


endmodule

