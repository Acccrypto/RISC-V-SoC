// ****************************************************************************/
// Microsemi Corporation Proprietary and Confidential
// Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: 
//
// SVN Revision Information:
// SVN $Revision: 28772 $
// SVN $Date: 2017-02-09 20:06:50 +0000 (Thu, 09 Feb 2017) $
//
// Resolved SARs
// SAR      Date     Who   Description
//
// Notes:
//
// ****************************************************************************/
module interconnect(
    // General inputs
    clock,
    resetn,
    
    // Master 0 write address channel inputs
    AWVALID_M0,
    AWADDR_M0,
    AWID_M0,
    AWLEN_M0,
    AWSIZE_M0,
    AWBURST_M0,

    // Master 0 write data channel inputs
    WVALID_M0,
    WLAST_M0,
    WSTRB_M0,
    WDATA_M0,

    // Master 0 write response channel inputs
    BREADY_M0,

    // Master 0 read address channel inputs
    ARVALID_M0,
    ARADDR_M0,
    ARID_M0,
    ARLEN_M0,
    ARSIZE_M0,
    ARBURST_M0,

    // Master 0 read data channel inputs
    RREADY_M0,

    // Master 1 write address channel inputs
    AWVALID_M1,
    AWADDR_M1,
    AWID_M1,
    AWLEN_M1,
    AWSIZE_M1,
    AWBURST_M1,

    // Master 1 write data channel inputs
    WVALID_M1,
    WLAST_M1,
    WSTRB_M1,
    WDATA_M1,

    // Master 1 write response channel inputs
    BREADY_M1,

    // Master 1 read address channel inputs
    ARVALID_M1,
    ARADDR_M1,
    ARID_M1,
    ARLEN_M1,
    ARSIZE_M1,
    ARBURST_M1,

    // Master 1 read data channel inputs
    RREADY_M1,

    // Slave 0 write address channel inputs
    AWREADY_S0,
    
    // Slave 0 write data channel inputs
    WREADY_S0,
    
    // Slave 0 write response channel inputs
    BVALID_S0,
    BRESP_S0,
    BID_S0,
    
    // Slave 0 read address channel inputs
    ARREADY_S0,
    
    // Slave 0 read data channel inputs
    RVALID_S0,
    RLAST_S0,
    RDATA_S0,
    RID_S0,
    RRESP_S0,

    // Slave 1 write address channel inputs
    AWREADY_S1,
    
    // Slave 1 write data channel inputs
    WREADY_S1,
    
    // Slave 1 write response channel inputs
    BVALID_S1,
    BRESP_S1,
    BID_S1,
    
    // Slave 1 read address channel inputs
    ARREADY_S1,
    
    // Slave 1 read data channel inputs
    RVALID_S1,
    RLAST_S1,
    RDATA_S1,
    RID_S1,
    RRESP_S1,

    // Slave 2 write address channel inputs
    AWREADY_S2,
    
    // Slave 2 write data channel inputs
    WREADY_S2,
    
    // Slave 2 write response channel inputs
    BVALID_S2,
    BRESP_S2,
    BID_S2,
    
    // Slave 2 read address channel inputs
    ARREADY_S2,
    
    // Slave 2 read data channel inputs
    RVALID_S2,
    RLAST_S2,
    RDATA_S2,
    RID_S2,
    RRESP_S2,

    // Slave 3 write address channel inputs
    AWREADY_S3,
    
    // Slave 3 write data channel inputs
    WREADY_S3,
    
    // Slave 3 write response channel inputs
    BVALID_S3,
    BRESP_S3,
    BID_S3,
    
    // Slave 3 read address channel inputs
    ARREADY_S3,
    
    // Slave 3 read data channel inputs
    RVALID_S3,
    RLAST_S3,
    RDATA_S3,
    RID_S3,
    RRESP_S3,

    // Master 0 write address channel outputs
    AWREADY_M0,
 
    // Master 0 write data channel outputs
    WREADY_M0,
    
    // Master 0 write response channel outputs
    BVALID_M0,
    BRESP_M0,
    BID_M0,
    
    // Master 0 read address channel outputs
    ARREADY_M0,
    
    // Master 0 read data channel outputs
    RVALID_M0,
    RLAST_M0,
    RDATA_M0,
    RID_M0,
    RRESP_M0,
    
    // Master 1 write address channel outputs
    AWREADY_M1,
 
    // Master 1 write data channel outputs
    WREADY_M1,
    
    // Master 1 write response channel outputs
    BVALID_M1,
    BRESP_M1,
    BID_M1,
    
    // Master 1 read address channel outputs
    ARREADY_M1,
    
    // Master 1 read data channel outputs
    RVALID_M1,
    RLAST_M1,
    RDATA_M1,
    RID_M1,
    RRESP_M1,

    // Slave 0 write address channel outputs
    AWVALID_S0,
    AWADDR_S0,
    AWID_S0,
    AWLEN_S0,
    AWSIZE_S0,
    AWBURST_S0,
    
    // Slave 0 write data channel outputs
    WVALID_S0,
    WLAST_S0,
    WSTRB_S0,
    WDATA_S0,
    
    // Slave 0 write response channel outputs
    BREADY_S0,
    
    // Slave 0 read address channel outputs
    ARVALID_S0,
    ARADDR_S0,
    ARID_S0,
    ARLEN_S0,
    ARSIZE_S0,
    ARBURST_S0,
    
    // Slave 0 read data channel outputs
    RREADY_S0,
    
    // Slave 1 write address channel outputs
    AWVALID_S1,
    AWADDR_S1,
    AWID_S1,
    AWLEN_S1,
    AWSIZE_S1,
    AWBURST_S1,
    
    // Slave 1 write data channel outputs
    WVALID_S1,
    WLAST_S1,
    WSTRB_S1,
    WDATA_S1,
    
    // Slave 1 write response channel outputs
    BREADY_S1,
    
    // Slave 1 read address channel outputs
    ARVALID_S1,
    ARADDR_S1,
    ARID_S1,
    ARLEN_S1,
    ARSIZE_S1,
    ARBURST_S1,
    
    // Slave 1 read data channel outputs
    RREADY_S1,
    
    // Slave 2 write address channel outputs
    AWVALID_S2,
    AWADDR_S2,
    AWID_S2,
    AWLEN_S2,
    AWSIZE_S2,
    AWBURST_S2,
    
    // Slave 2 write data channel outputs
    WVALID_S2,
    WLAST_S2,
    WSTRB_S2,
    WDATA_S2,
    
    // Slave 2 write response channel outputs
    BREADY_S2,
    
    // Slave 2 read address channel outputs
    ARVALID_S2,
    ARADDR_S2,
    ARID_S2,
    ARLEN_S2,
    ARSIZE_S2,
    ARBURST_S2,
    
    // Slave 2 read data channel outputs
    RREADY_S2,

    // Slave 3 write address channel outputs
    AWVALID_S3,
    AWADDR_S3,
    AWID_S3,
    AWLEN_S3,
    AWSIZE_S3,
    AWBURST_S3,
    
    // Slave 3 write data channel outputs
    WVALID_S3,
    WLAST_S3,
    WSTRB_S3,
    WDATA_S3,
    
    // Slave 3 write response channel outputs
    BREADY_S3,
    
    // Slave 3 read address channel outputs
    ARVALID_S3,
    ARADDR_S3,
    ARID_S3,
    ARLEN_S3,
    ARSIZE_S3,
    ARBURST_S3,
    
    // Slave 3 read data channel outputs
    RREADY_S3
);

////////////////////////////////////////////////////////////////////////////////
// Parameters
////////////////////////////////////////////////////////////////////////////////
parameter ID_WIDTH = 1;  // 1->N
parameter DWIDTH   = 64;
parameter AWIDTH   = 2;

////////////////////////////////////////////////////////////////////////////////
// Port directions
////////////////////////////////////////////////////////////////////////////////
// General inputs
input                           clock;
input                           resetn;

// Master 0 write address channel inputs
input                           AWVALID_M0;
input       [AWIDTH-1:0]        AWADDR_M0;
input       [ID_WIDTH-1:0]      AWID_M0;
input       [7:0]               AWLEN_M0;
input       [2:0]               AWSIZE_M0;
input       [1:0]               AWBURST_M0;

// Master 0 write data channel inputs
input                           WVALID_M0;
input                           WLAST_M0;
input       [(DWIDTH/8)-1:0]    WSTRB_M0;
input       [DWIDTH-1:0]        WDATA_M0;

// Master 0 write response channel inputs
input                           BREADY_M0;

// Master 0 read address channel inputs
input                           ARVALID_M0;
input       [AWIDTH-1:0]        ARADDR_M0;
input       [ID_WIDTH-1:0]      ARID_M0;
input       [7:0]               ARLEN_M0;
input       [2:0]               ARSIZE_M0;
input       [1:0]               ARBURST_M0;

// Master 0 read data channel inputs
input                           RREADY_M0;

// Master 1 write address channel inputs
input                           AWVALID_M1;
input       [AWIDTH-1:0]        AWADDR_M1;
input       [ID_WIDTH-1:0]      AWID_M1;
input       [7:0]               AWLEN_M1;
input       [2:0]               AWSIZE_M1;
input       [1:0]               AWBURST_M1;

// Master 1 write data channel inputs
input                           WVALID_M1;
input                           WLAST_M1;
input       [(DWIDTH/8)-1:0]    WSTRB_M1;
input       [DWIDTH-1:0]        WDATA_M1;

// Master 1 write response channel inputs
input                           BREADY_M1;

// Master 1 read address channel inputs
input                           ARVALID_M1;
input       [AWIDTH-1:0]        ARADDR_M1;
input       [ID_WIDTH-1:0]      ARID_M1;
input       [7:0]               ARLEN_M1;
input       [2:0]               ARSIZE_M1;
input       [1:0]               ARBURST_M1;

// Master 1 read data channel inputs
input                           RREADY_M1;

// Slave 0 write address channel inputs
input                           AWREADY_S0;

// Slave 0 write data channel inputs
input                           WREADY_S0;

// Slave 0 write response channel inputs
input                           BVALID_S0;
input       [1:0]               BRESP_S0;
input       [ID_WIDTH:0]        BID_S0;

// Slave 0 read address channel inputs
input                           ARREADY_S0;

// Slave 0 read data channel inputs
input                           RVALID_S0;
input                           RLAST_S0;
input       [DWIDTH-1:0]        RDATA_S0;
input       [ID_WIDTH:0]        RID_S0;
input       [1:0]               RRESP_S0;

// Slave 1 write address channel inputs
input                           AWREADY_S1;

// Slave 1 write data channel inputs
input                           WREADY_S1;

// Slave 1 write response channel inputs
input                           BVALID_S1;
input       [1:0]               BRESP_S1;
input       [ID_WIDTH:0]        BID_S1;

// Slave 1 read address channel inputs
input                           ARREADY_S1;

// Slave 1 read data channel inputs
input                           RVALID_S1;
input                           RLAST_S1;
input       [DWIDTH-1:0]        RDATA_S1;
input       [ID_WIDTH:0]        RID_S1;
input       [1:0]               RRESP_S1;

// Slave 2 write address channel inputs
input                           AWREADY_S2;

// Slave 2 write data channel inputs
input                           WREADY_S2;

// Slave 2 write response channel inputs
input                           BVALID_S2;
input       [1:0]               BRESP_S2;
input       [ID_WIDTH:0]        BID_S2;

// Slave 2 read address channel inputs
input                           ARREADY_S2;

// Slave 2 read data channel inputs
input                           RVALID_S2;
input                           RLAST_S2;
input       [DWIDTH-1:0]        RDATA_S2;
input       [ID_WIDTH:0]        RID_S2;
input       [1:0]               RRESP_S2;

// Slave 3 write address channel inputs
input                           AWREADY_S3;

// Slave 3 write data channel inputs
input                           WREADY_S3;

// Slave 3 write response channel inputs
input                           BVALID_S3;
input       [1:0]               BRESP_S3;
input       [ID_WIDTH:0]        BID_S3;

// Slave 3 read address channel inputs
input                           ARREADY_S3;

// Slave 3 read data channel inputs
input                           RVALID_S3;
input                           RLAST_S3;
input       [DWIDTH-1:0]        RDATA_S3;
input       [ID_WIDTH:0]        RID_S3;
input       [1:0]               RRESP_S3;

// Master 0 write address channel outputs
output                          AWREADY_M0;

// Master 0 write data channel outputs
output                          WREADY_M0;

// Master 0 write response channel outputs
output                          BVALID_M0;
output      [1:0]               BRESP_M0;
output      [ID_WIDTH-1:0]      BID_M0;

// Master 0 read address channel outputs
output                          ARREADY_M0;

// Master 0 read data channel outputs
output                          RVALID_M0;
output                          RLAST_M0;
output      [DWIDTH-1:0]        RDATA_M0;
output      [ID_WIDTH-1:0]      RID_M0;
output      [1:0]               RRESP_M0;

// Master 1 write address channel outputs
output                          AWREADY_M1;

// Master 1 write data channel outputs
output                          WREADY_M1;

// Master 1 write response channel outputs
output                          BVALID_M1;
output      [1:0]               BRESP_M1;
output      [ID_WIDTH-1:0]      BID_M1;

// Master 1 read address channel outputs
output                          ARREADY_M1;

// Master 1 read data channel outputs
output                          RVALID_M1;
output                          RLAST_M1;
output      [DWIDTH-1:0]        RDATA_M1;
output      [ID_WIDTH-1:0]      RID_M1;
output      [1:0]               RRESP_M1;

// Slave 0 write address channel outputs
output                          AWVALID_S0;
output      [AWIDTH-1:0]        AWADDR_S0;
output      [ID_WIDTH:0]        AWID_S0;
output      [7:0]               AWLEN_S0;
output      [2:0]               AWSIZE_S0;
output      [1:0]               AWBURST_S0;

// Slave 0 write data channel outputs
output                          WVALID_S0;
output                          WLAST_S0;
output      [(DWIDTH/8)-1:0]    WSTRB_S0;
output      [DWIDTH-1:0]        WDATA_S0;

// Slave 0 write response channel outputs
output                          BREADY_S0;

// Slave 0 read address channel outputs
output                          ARVALID_S0;
output      [AWIDTH-1:0]        ARADDR_S0;
output      [ID_WIDTH:0]        ARID_S0;
output      [7:0]               ARLEN_S0;
output      [2:0]               ARSIZE_S0;
output      [1:0]               ARBURST_S0;

// Slave 0 read data channel outputs
output                          RREADY_S0;

// Slave 1 write address channel outputs
output                          AWVALID_S1;
output      [AWIDTH-1:0]        AWADDR_S1;
output      [ID_WIDTH:0]        AWID_S1;
output      [7:0]               AWLEN_S1;
output      [2:0]               AWSIZE_S1;
output      [1:0]               AWBURST_S1;

// Slave 1 write data channel outputs
output                          WVALID_S1;
output                          WLAST_S1;
output      [(DWIDTH/8)-1:0]    WSTRB_S1;
output      [DWIDTH-1:0]        WDATA_S1;

// Slave 1 write response channel outputs
output                          BREADY_S1;

// Slave 1 read address channel outputs
output                          ARVALID_S1;
output      [AWIDTH-1:0]        ARADDR_S1;
output      [ID_WIDTH:0]        ARID_S1;
output      [7:0]               ARLEN_S1;
output      [2:0]               ARSIZE_S1;
output      [1:0]               ARBURST_S1;

// Slave 1 read data channel outputs
output                          RREADY_S1;

// Slave 2 write address channel outputs
output                          AWVALID_S2;
output      [AWIDTH-1:0]        AWADDR_S2;
output      [ID_WIDTH:0]        AWID_S2;
output      [7:0]               AWLEN_S2;
output      [2:0]               AWSIZE_S2;
output      [1:0]               AWBURST_S2;

// Slave 2 write data channel outputs
output                          WVALID_S2;
output                          WLAST_S2;
output      [(DWIDTH/8)-1:0]    WSTRB_S2;
output      [DWIDTH-1:0]        WDATA_S2;

// Slave 2 write response channel outputs
output                          BREADY_S2;

// Slave 2 read address channel outputs
output                          ARVALID_S2;
output      [AWIDTH-1:0]        ARADDR_S2;
output      [ID_WIDTH:0]        ARID_S2;
output      [7:0]               ARLEN_S2;
output      [2:0]               ARSIZE_S2;
output      [1:0]               ARBURST_S2;

// Slave 2 read data channel outputs
output                          RREADY_S2;

// Slave 3 write address channel outputs
output                          AWVALID_S3;
output      [AWIDTH-1:0]        AWADDR_S3;
output      [ID_WIDTH:0]        AWID_S3;
output      [7:0]               AWLEN_S3;
output      [2:0]               AWSIZE_S3;
output      [1:0]               AWBURST_S3;

// Slave 3 write data channel outputs
output                          WVALID_S3;
output                          WLAST_S3;
output      [(DWIDTH/8)-1:0]    WSTRB_S3;
output      [DWIDTH-1:0]        WDATA_S3;

// Slave 3 write response channel outputs
output                          BREADY_S3;

// Slave 3 read address channel outputs
output                          ARVALID_S3;
output      [AWIDTH-1:0]        ARADDR_S3;
output      [ID_WIDTH:0]        ARID_S3;
output      [7:0]               ARLEN_S3;
output      [2:0]               ARSIZE_S3;
output      [1:0]               ARBURST_S3;

// Slave 3 read data channel outputs
output                          RREADY_S3;

////////////////////////////////////////////////////////////////////////////////
// Internal signals
////////////////////////////////////////////////////////////////////////////////
wire        [1:0]               wrDataChanGrant;
wire        [AWIDTH-1:0]        wrDataChanAddr;

////////////////////////////////////////////////////////////////////////////////
// Write address channel instantiation
////////////////////////////////////////////////////////////////////////////////
interconnect_writeAddressChannel #(
    .ID_WIDTH               (ID_WIDTH),
    .AWIDTH                 (AWIDTH)
) U_wrAddrChan (
    // General inputs
    .clock                  (clock),
    .resetn                 (resetn),

    // Master 0 inputs
    .AWVALID_M0             (AWVALID_M0),
    .AWADDR_M0              (AWADDR_M0),
    .AWID_M0                (AWID_M0),
    .AWLEN_M0               (AWLEN_M0),
    .AWSIZE_M0              (AWSIZE_M0),
    .AWBURST_M0             (AWBURST_M0),
    
    // Master 1 inputs
    .AWVALID_M1             (AWVALID_M1),
    .AWADDR_M1              (AWADDR_M1),
    .AWID_M1                (AWID_M1),
    .AWLEN_M1               (AWLEN_M1),
    .AWSIZE_M1              (AWSIZE_M1),
    .AWBURST_M1             (AWBURST_M1),
    
    // Slave 0 inputs
    .AWREADY_S0             (AWREADY_S0),    
    
    // Slave 1 inputs
    .AWREADY_S1             (AWREADY_S1),
    
    // Slave 2 inputs
    .AWREADY_S2             (AWREADY_S2),
    
    // Slave 3 inputs
    .AWREADY_S3             (AWREADY_S3),
    
    // Write data channel inputs
    .wrDataChanGrant        (wrDataChanGrant),
    
    // Master 0 outputs
    .AWREADY_M0             (AWREADY_M0),
    
    // Master 1 outputs
    .AWREADY_M1             (AWREADY_M1),
    
    // Slave 0 outputs
    .AWVALID_S0             (AWVALID_S0),
    .AWADDR_S0              (AWADDR_S0),
    .AWID_S0                (AWID_S0),
    .AWLEN_S0               (AWLEN_S0),
    .AWSIZE_S0              (AWSIZE_S0),
    .AWBURST_S0             (AWBURST_S0),
    
    // Slave 1 outputs
    .AWVALID_S1             (AWVALID_S1),
    .AWADDR_S1              (AWADDR_S1),
    .AWID_S1                (AWID_S1),
    .AWLEN_S1               (AWLEN_S1),
    .AWSIZE_S1              (AWSIZE_S1),
    .AWBURST_S1             (AWBURST_S1),
    
    // Slave 2 outputs
    .AWVALID_S2             (AWVALID_S2),
    .AWADDR_S2              (AWADDR_S2),
    .AWID_S2                (AWID_S2),
    .AWLEN_S2               (AWLEN_S2),
    .AWSIZE_S2              (AWSIZE_S2),
    .AWBURST_S2             (AWBURST_S2),
    
    // Slave 3 outputs
    .AWVALID_S3             (AWVALID_S3),
    .AWADDR_S3              (AWADDR_S3),
    .AWID_S3                (AWID_S3),
    .AWLEN_S3               (AWLEN_S3),
    .AWSIZE_S3              (AWSIZE_S3),
    .AWBURST_S3             (AWBURST_S3),
    
    // Write data channel outputs
    .wrDataChanAddr         (wrDataChanAddr)
);

////////////////////////////////////////////////////////////////////////////////
// Write data channel instantiation
////////////////////////////////////////////////////////////////////////////////
interconnect_writeDataChannel #(
    .DWIDTH                 (DWIDTH),
    .AWIDTH                 (AWIDTH)
) U_wrDataChan (
    // General inputs
    .clock                  (clock),
    .resetn                 (resetn),
    
    // Master 0 inputs
    .WVALID_M0              (WVALID_M0),
    .WDATA_M0               (WDATA_M0),
    .WSTRB_M0               (WSTRB_M0),
    .WLAST_M0               (WLAST_M0),
    
    // Master 1 inputs
    .WVALID_M1              (WVALID_M1),
    .WDATA_M1               (WDATA_M1),
    .WSTRB_M1               (WSTRB_M1),
    .WLAST_M1               (WLAST_M1),
    
    // Slave 0 inputs
    .WREADY_S0              (WREADY_S0),
    
    // Slave 1 inputs
    .WREADY_S1              (WREADY_S1),
    
    // Slave 2 inputs
    .WREADY_S2              (WREADY_S2),
    
    // Slave 3 inputs
    .WREADY_S3              (WREADY_S3),
    
    // Write address channel inputs
    .wrDataChanAddr         (wrDataChanAddr),
    
    // Master 0 outputs
    .WREADY_M0              (WREADY_M0),
    
    // Master 1 outputs
    .WREADY_M1              (WREADY_M1),
    
    // Slave 0 outputs
    .WVALID_S0              (WVALID_S0),
    .WDATA_S0               (WDATA_S0),
    .WSTRB_S0               (WSTRB_S0),
    .WLAST_S0               (WLAST_S0),
    
    // Slave 1 outputs
    .WVALID_S1              (WVALID_S1),
    .WDATA_S1               (WDATA_S1),
    .WSTRB_S1               (WSTRB_S1),
    .WLAST_S1               (WLAST_S1),
    
    // Slave 2 outputs
    .WVALID_S2              (WVALID_S2),
    .WDATA_S2               (WDATA_S2),
    .WSTRB_S2               (WSTRB_S2),
    .WLAST_S2               (WLAST_S2),
    
    // Slave 3 outputs
    .WVALID_S3              (WVALID_S3),
    .WDATA_S3               (WDATA_S3),
    .WSTRB_S3               (WSTRB_S3),
    .WLAST_S3               (WLAST_S3),
    
    // Write address channel outputs
    .wrDataChanGrant        (wrDataChanGrant)
);

////////////////////////////////////////////////////////////////////////////////
// Write response channel instantiation
////////////////////////////////////////////////////////////////////////////////
interconnect_writeResponseChannel #(
    .ID_WIDTH               (ID_WIDTH)
) U_wrRespChan (
    // General inputs
    .clock                  (clock),
    .resetn                 (resetn),
    
    // Master 0 inputs
    .BREADY_M0              (BREADY_M0),
    
    // Master 1 inputs
    .BREADY_M1              (BREADY_M1),
    
    // Slave 0 inputs
    .BVALID_S0              (BVALID_S0),
    .BID_S0                 (BID_S0),
    .BRESP_S0               (BRESP_S0),

    // Slave 1 inputs
    .BVALID_S1              (BVALID_S1),
    .BID_S1                 (BID_S1),
    .BRESP_S1               (BRESP_S1),
    
    // Slave 2 inputs
    .BVALID_S2              (BVALID_S2),
    .BID_S2                 (BID_S2),
    .BRESP_S2               (BRESP_S2),
    
    // Slave 3 inputs
    .BVALID_S3              (BVALID_S3),
    .BID_S3                 (BID_S3),
    .BRESP_S3               (BRESP_S3),
    
    // Master 0 outputs
    .BVALID_M0              (BVALID_M0),
    .BID_M0                 (BID_M0),
    .BRESP_M0               (BRESP_M0),
    
    // Master 1 outputs
    .BVALID_M1              (BVALID_M1),
    .BID_M1                 (BID_M1),
    .BRESP_M1               (BRESP_M1),
    
    // Slave 0 outputs
    .BREADY_S0              (BREADY_S0),
    
    // Slave 1 outputs
    .BREADY_S1              (BREADY_S1),
    
    // Slave 2 outputs
    .BREADY_S2              (BREADY_S2),

    // Slave 3 outputs
    .BREADY_S3              (BREADY_S3)
);

////////////////////////////////////////////////////////////////////////////////
// Read address channel instantiation
////////////////////////////////////////////////////////////////////////////////
interconnect_readAddressChannel #(
    .ID_WIDTH               (ID_WIDTH),
    .AWIDTH                 (AWIDTH)
) U_rdAddrChan (
    // General inputs
    .clock                  (clock),
    .resetn                 (resetn),

    // Master 0 inputs
    .ARVALID_M0             (ARVALID_M0),
    .ARADDR_M0              (ARADDR_M0),
    .ARID_M0                (ARID_M0),
    .ARLEN_M0               (ARLEN_M0),
    .ARSIZE_M0              (ARSIZE_M0),
    .ARBURST_M0             (ARBURST_M0),
    
    // Master 1 inputs
    .ARVALID_M1             (ARVALID_M1),
    .ARADDR_M1              (ARADDR_M1),
    .ARID_M1                (ARID_M1),
    .ARLEN_M1               (ARLEN_M1),
    .ARSIZE_M1              (ARSIZE_M1),
    .ARBURST_M1             (ARBURST_M1),
    
    // Slave 0 inputs
    .ARREADY_S0             (ARREADY_S0),    
    
    // Slave 1 inputs
    .ARREADY_S1             (ARREADY_S1),
    
    // Slave 2 inputs
    .ARREADY_S2             (ARREADY_S2),
    
    // Slave 3 inputs
    .ARREADY_S3             (ARREADY_S3),
    
    // Master 0 outputs
    .ARREADY_M0             (ARREADY_M0),
    
    // Master 1 outputs
    .ARREADY_M1             (ARREADY_M1),
    
    // Slave 0 outputs
    .ARVALID_S0             (ARVALID_S0),
    .ARADDR_S0              (ARADDR_S0),
    .ARID_S0                (ARID_S0),
    .ARLEN_S0               (ARLEN_S0),
    .ARSIZE_S0              (ARSIZE_S0),
    .ARBURST_S0             (ARBURST_S0),
    
    // Slave 1 outputs
    .ARVALID_S1             (ARVALID_S1),
    .ARADDR_S1              (ARADDR_S1),
    .ARID_S1                (ARID_S1),
    .ARLEN_S1               (ARLEN_S1),
    .ARSIZE_S1              (ARSIZE_S1),
    .ARBURST_S1             (ARBURST_S1),
    
    // Slave 2 outputs
    .ARVALID_S2             (ARVALID_S2),
    .ARADDR_S2              (ARADDR_S2),
    .ARID_S2                (ARID_S2),
    .ARLEN_S2               (ARLEN_S2),
    .ARSIZE_S2              (ARSIZE_S2),
    .ARBURST_S2             (ARBURST_S2),
    
    // Slave 3 outputs
    .ARVALID_S3             (ARVALID_S3),
    .ARADDR_S3              (ARADDR_S3),
    .ARID_S3                (ARID_S3),
    .ARLEN_S3               (ARLEN_S3),
    .ARSIZE_S3              (ARSIZE_S3),
    .ARBURST_S3             (ARBURST_S3)
);

////////////////////////////////////////////////////////////////////////////////
// Read data channel instantiation
////////////////////////////////////////////////////////////////////////////////
interconnect_readDataChannel #(
    .ID_WIDTH               (ID_WIDTH),
    .DWIDTH                 (DWIDTH)
) U_rdDataChan (
    // General inputs
    .clock                  (clock),
    .resetn                 (resetn),
    
    // Master 0 inputs
    .RREADY_M0              (RREADY_M0),
    
    // Master 1 inputs
    .RREADY_M1              (RREADY_M1),
    
    // Slave 0 inputs
    .RVALID_S0              (RVALID_S0),
    .RLAST_S0               (RLAST_S0),
    .RDATA_S0               (RDATA_S0),
    .RID_S0                 (RID_S0),
    .RRESP_S0               (RRESP_S0),

    // Slave 1 inputs
    .RVALID_S1              (RVALID_S1),
    .RLAST_S1               (RLAST_S1),
    .RDATA_S1               (RDATA_S1),
    .RID_S1                 (RID_S1),
    .RRESP_S1               (RRESP_S1),
    
    // Slave 2 inputs
    .RVALID_S2              (RVALID_S2),
    .RLAST_S2               (RLAST_S2),
    .RDATA_S2               (RDATA_S2),
    .RID_S2                 (RID_S2),
    .RRESP_S2               (RRESP_S2),
    
    // Slave 3 inputs
    .RVALID_S3              (RVALID_S3),
    .RLAST_S3               (RLAST_S3),
    .RDATA_S3               (RDATA_S3),
    .RID_S3                 (RID_S3),
    .RRESP_S3               (RRESP_S3),
    
    // Master 0 outputs
    .RVALID_M0              (RVALID_M0),
    .RLAST_M0               (RLAST_M0),
    .RDATA_M0               (RDATA_M0),
    .RID_M0                 (RID_M0),
    .RRESP_M0               (RRESP_M0),
    
    // Master 1 outputs
    .RVALID_M1              (RVALID_M1),
    .RLAST_M1               (RLAST_M1),
    .RDATA_M1               (RDATA_M1),
    .RID_M1                 (RID_M1),
    .RRESP_M1               (RRESP_M1),
    
    // Slave 0 outputs
    .RREADY_S0              (RREADY_S0),
    
    // Slave 1 outputs
    .RREADY_S1              (RREADY_S1),
    
    // Slave 2 outputs
    .RREADY_S2              (RREADY_S2),

    // Slave 3 outputs
    .RREADY_S3              (RREADY_S3)
);

endmodule // interconnect