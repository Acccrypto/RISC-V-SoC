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
module AXI4ToAXI4LiteBridge(
    // General inputs
    clock,
    resetn,
    
    // AXI4 Master Write address channel inputs
    AWVALID,
    AWADDR,
    AWID,
    AWLEN,
    AWSIZE,
    AWBURST,
    
    // AXI4 Master Write data channel inputs
    WVALID,
    WDATA,
    WSTRB,
    WLAST,
    
    // AXI4 Master Write response channel inputs
    BREADY,
    
    // AXI4 Master Read address channel inputs
    ARVALID,
    ARADDR,
    ARID,
    ARLEN,
    ARSIZE,
    ARBURST,
    
    // AXI4 Master Read data channel inputs
    RREADY,
    
    // AXI4-Lite Slave Write address channel inputs
    AWREADY_Lite,
    
    // AXI4-Lite Slave Write data channel inputs
    WREADY_Lite,
    
    // AXI4-Lite Slave Write response channel inputs
    BVALID_Lite,
    BRESP_Lite,
    
    // AXI4-Lite Slave Read address channel inputs
    ARREADY_Lite,
    
    // AXI4-Lite Slave Read data channel inputs
    RVALID_Lite,
    RDATA_Lite,
    RRESP_Lite,
    
    // AXI4 Master Write address channel outputs
    AWREADY,
    
    // AXI4 Master Write data channel outputs
    WREADY,
    
    // AXI4 Master Write response channel outputs
    BVALID,
    BRESP,
    BID,
    
    // AXI4 Master Read address channel outputs
    ARREADY,
    
    // AXI4 Master Read data channel outputs
    RVALID,
    RDATA,
    RID,
    RRESP,
    RLAST,
    
    // AXI4-Lite Slave Write address channel outputs
    AWVALID_Lite,
    AWADDR_Lite,
    
    // AXI4-Lite Slave Write data channel outputs
    WVALID_Lite,
    WDATA_Lite,
    WSTRB_Lite,
    
    // AXI4-Lite Slave Write response channel outputs
    BREADY_Lite,
    
    // AXI4-Lite Slave Read address channel outputs
    ARVALID_Lite,
    ARADDR_Lite,
    
    // AXI4-Lite Slave Read data channel outputs
    RREADY_Lite
);
////////////////////////////////////////////////////////////////////////////////
// Parameters
////////////////////////////////////////////////////////////////////////////////
parameter  ADDR_WIDTH = 8;   // Number of address bits.
parameter  DATA_WIDTH = 64;  // Data width in bits
parameter  ID_WIDTH   = 1;   // ID field width

////////////////////////////////////////////////////////////////////////////////
// Port directions
////////////////////////////////////////////////////////////////////////////////
// General inputs
input                           clock;
input                           resetn;

// Write address channel inputs
input                           AWVALID;
input   [ADDR_WIDTH-1:0]        AWADDR;
input   [ID_WIDTH-1:0]          AWID;
input   [7:0]                   AWLEN;
input   [2:0]                   AWSIZE;
input   [1:0]                   AWBURST;

// Write data channel inputs
input                           WVALID;
input   [DATA_WIDTH-1:0]        WDATA;
input   [(DATA_WIDTH/8)-1:0]    WSTRB;
input                           WLAST;

// Write response channel inputs
input                           BREADY;

// Read address channel inputs
input                           ARVALID;
input   [ADDR_WIDTH-1:0]        ARADDR;
input   [ID_WIDTH-1:0]          ARID;
input   [7:0]                   ARLEN;
input   [2:0]                   ARSIZE;
input   [1:0]                   ARBURST;

// Read data channel inputs
input                           RREADY;

// AXI4-Lite Slave Write address channel inputs
input                           AWREADY_Lite;

// AXI4-Lite Slave Write data channel inputs
input                           WREADY_Lite;

// AXI4-Lite Slave Write response channel inputs
input                           BVALID_Lite;
input   [1:0]                   BRESP_Lite;

// AXI4-Lite Slave Read address channel inputs
input                           ARREADY_Lite;

// AXI4-Lite Slave Read data channel inputs
input                           RVALID_Lite;
input   [DATA_WIDTH-1:0]        RDATA_Lite;
input   [1:0]                   RRESP_Lite;
    
// Write address channel outputs
output                          AWREADY;

// Write data channel outputs
output                          WREADY;

// Write response channel outputs
output                          BVALID;
output  [1:0]                   BRESP;
output  [ID_WIDTH-1:0]          BID;

// Read address channel outputs
output                          ARREADY;

// Read data channel outputs
output                          RVALID;
output  [DATA_WIDTH-1:0]        RDATA;
output  [ID_WIDTH-1:0]          RID;
output  [1:0]                   RRESP;
output                          RLAST;
    
// AXI4-Lite Slave Write address channel outputs
output                          AWVALID_Lite;
output  [ADDR_WIDTH-1:0]        AWADDR_Lite;

// AXI4-Lite Slave Write data channel outputs
output                          WVALID_Lite;
output  [DATA_WIDTH-1:0]        WDATA_Lite;
output  [(DATA_WIDTH/8)-1:0]    WSTRB_Lite;

// AXI4-Lite Slave Write response channel outputs
output                          BREADY_Lite;

// AXI4-Lite Slave Read address channel outputs
output                          ARVALID_Lite;
output  [ADDR_WIDTH-1:0]        ARADDR_Lite;

// AXI4-Lite Slave Read data channel outputs
output                          RREADY_Lite;

////////////////////////////////////////////////////////////////////////////////
// Utility functions
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// clog2 function implementation. Returns the number of bits required to
// hold the value passed as argument.
////////////////////////////////////////////////////////////////////////////////
function integer clog2;
    input integer x;
    integer x1, tmp, res;
    begin
        tmp = 1;
        res = 0;
        x1 = x + 1;
        while (tmp < x1)
            begin 
                tmp = tmp * 2;
                res = res + 1;
            end
        clog2 = res;
    end
endfunction

////////////////////////////////////////////////////////////////////////////////
// Constants
////////////////////////////////////////////////////////////////////////////////
// Write control FSM states - One-shot encoding
localparam [7:0] WR_IDLE                = 8'b00000001;
localparam [7:0] WR_LITE_WR_ADDR        = 8'b00000010;
localparam [7:0] WR_FULL_WR_ADDR_ACK    = 8'b00000100;
localparam [7:0] WAIT_FULL_WAIT_WR_DATA = 8'b00001000;
localparam [7:0] WR_LITE_WR_DATA_ACK    = 8'b00010000;
localparam [7:0] WR_LITE_WAIT_RESP      = 8'b00100000;
localparam [7:0] WR_FULL_WAIT_ACK       = 8'b01000000;
localparam [7:0] WR_FULL_WAIT_RESP_ACK  = 8'b10000000;

// Read control FSM states - One-shot encoding
localparam [4:0] RD_IDLE                = 5'b00001;
localparam [4:0] RD_LITE_RD_ADDR        = 5'b00010;
localparam [4:0] RD_FULL_RD_ADDR_ACK    = 5'b00100;
localparam [4:0] RD_LITE_WAIT_RD_DATA   = 5'b01000;
localparam [4:0] RD_FULL_RD_DATA_ACK    = 5'b10000;

localparam DWIDTH_BYTE_WIDTH = clog2((DATA_WIDTH/8)-1);
////////////////////////////////////////////////////////////////////////////////
// Internal signals
////////////////////////////////////////////////////////////////////////////////
reg [7:0]                   currStateWr;
reg [7:0]                   nextStateWr;
reg [4:0]                   currStateRd;
reg [4:0]                   nextStateRd;
       
reg                         AWVALID_LiteReg;
reg                         AWVALID_LiteReg_d;
reg [2:0]                   wrSizeReg;
reg [2:0]                   wrSizeReg_d;
reg [ADDR_WIDTH-1:0]        AWADDR_LiteReg;
reg [ADDR_WIDTH-1:0]        AWADDR_LiteReg_d;
reg [ADDR_WIDTH-1:0]        wrAddrReg;
reg [ADDR_WIDTH-1:0]        wrAddrReg_d;
reg [1:0]                   wrBurstReg;
reg [1:0]                   wrBurstReg_d;
reg [ID_WIDTH-1:0]          wrIDReg;
reg [ID_WIDTH-1:0]          wrIDReg_d;
reg                         AWREADYReg;
reg                         AWREADYReg_d;
reg                         WVALID_LiteReg;
reg                         WVALID_LiteReg_d;
reg [DATA_WIDTH-1:0]        WDATA_LiteReg;
reg [DATA_WIDTH-1:0]        WDATA_LiteReg_d;
reg [(DATA_WIDTH/8)-1:0]    WSTRB_LiteReg;
reg [(DATA_WIDTH/8)-1:0]    WSTRB_LiteReg_d;
reg                         BREADY_LiteReg;
reg                         BREADY_LiteReg_d;
reg                         WREADYReg;
reg                         WREADYReg_d;
reg                         BVALIDReg;
reg                         BVALIDReg_d;
reg [1:0]                   BRESPReg;
reg [1:0]                   BRESPReg_d;
reg [ID_WIDTH-1:0]          BIDReg;
reg [ID_WIDTH-1:0]          BIDReg_d;
reg                         errorHoldReg;
reg                         errorHoldReg_d;

reg                         ARVALID_LiteReg;
reg                         ARVALID_LiteReg_d;
reg [2:0]                   rdSizeReg;
reg [2:0]                   rdSizeReg_d;
reg [31:0]                  ARADDR_LiteReg;
reg [31:0]                  ARADDR_LiteReg_d;
reg [31:0]                  rdAddrReg;
reg [31:0]                  rdAddrReg_d;
reg [1:0]                   rdBurstReg;
reg [1:0]                   rdBurstReg_d;
reg [ID_WIDTH-1:0]          rdIDReg;
reg [ID_WIDTH-1:0]          rdIDReg_d;
reg [7:0]                   rdLenReg;
reg [7:0]                   rdLenReg_d;
reg                         ARREADYReg;
reg                         ARREADYReg_d;
reg                         RREADY_LiteReg;
reg                         RREADY_LiteReg_d;
reg                         RLASTReg;
reg                         RLASTReg_d;
reg                         RVALIDReg;
reg                         RVALIDReg_d;
reg [DATA_WIDTH-1:0]        RDATAReg;
reg [DATA_WIDTH-1:0]        RDATAReg_d;
reg [1:0]                   RRESPReg;
reg [1:0]                   RRESPReg_d;
reg [ID_WIDTH-1:0]          RIDReg;
reg [ID_WIDTH-1:0]          RIDReg_d;
reg [7:0]                   rdBeatCnt;
reg [7:0]                   rdBeatCnt_d;

////////////////////////////////////////////////////////////////////////////////
// Write Ctrl FSM - Current state register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                currStateWr <= WR_IDLE;
            end
        else
            begin
                currStateWr <= nextStateWr;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// Write Ctrl FSM - Combinatorial next state & output logic
////////////////////////////////////////////////////////////////////////////////
always @ (*)
    begin
        // Default assignments
        AWVALID_LiteReg_d = 1'b0;
        wrSizeReg_d       = wrSizeReg;
        AWADDR_LiteReg_d  = {ADDR_WIDTH{1'b0}};
        wrAddrReg_d       = wrAddrReg;
        wrBurstReg_d      = wrBurstReg;
        wrIDReg_d         = wrIDReg;
        AWREADYReg_d      = 1'b0;
        WVALID_LiteReg_d  = 1'b0;
        WDATA_LiteReg_d   = {DATA_WIDTH{1'b0}};
        WSTRB_LiteReg_d   = {(DATA_WIDTH/8){1'b0}};
        BREADY_LiteReg_d  = 1'b0;
        WREADYReg_d       = 1'b0;
        BVALIDReg_d       = 1'b0;
        BRESPReg_d        = 2'b0;
        BIDReg_d          = {ID_WIDTH{1'b0}};
        errorHoldReg_d    = errorHoldReg;
        case (currStateWr)
            WR_IDLE:
                begin
                    if (AWVALID)
                        begin
                            // Start the AXI4-Lite write transaction
                            AWVALID_LiteReg_d = 1'b1;
                            wrSizeReg_d       = AWSIZE;
                            AWADDR_LiteReg_d  = {AWADDR[ADDR_WIDTH-1:DWIDTH_BYTE_WIDTH], {DWIDTH_BYTE_WIDTH{1'b0}}};
                            wrAddrReg_d       = {AWADDR[ADDR_WIDTH-1:DWIDTH_BYTE_WIDTH], {DWIDTH_BYTE_WIDTH{1'b0}}};
                            wrBurstReg_d      = AWBURST;
                            wrIDReg_d         = AWID;
                            nextStateWr       = WR_LITE_WR_ADDR;
                        end
                    else
                        begin
                            nextStateWr = WR_IDLE;
                        end
                end
            WR_LITE_WR_ADDR:
                begin
                    if (AWVALID_Lite & AWREADY_Lite)
                        begin
                            // AXI4-Lite slave has ack'ed the write address. Now lets ack' the address data
                            // from the AXI4 master
                            wrAddrReg_d  = wrAddrReg + (2**wrSizeReg);
                            AWREADYReg_d = 1'b1;
                            nextStateWr  = WR_FULL_WR_ADDR_ACK;
                        end
                    else
                        begin
                            // Continue to drive out the address data to the AXI4-Lite slave
                            AWVALID_LiteReg_d = 1'b1;
                            AWADDR_LiteReg_d  = wrAddrReg;
                            nextStateWr       = WR_LITE_WR_ADDR;
                        end
                end
            WR_FULL_WR_ADDR_ACK:
                begin
                    if (AWVALID & AWREADY)
                        begin
                            // AXI4 master has seen the address acknowledgement. Now check if the AXI4 master
                            // is driving out write data
                            if (WVALID)
                                begin
                                    // Drive out the data to the AXI4-Lite slave
                                    WVALID_LiteReg_d = 1'b1;
                                    WDATA_LiteReg_d  = WDATA;
                                    WSTRB_LiteReg_d  = WSTRB;        
                                    nextStateWr      = WR_LITE_WR_DATA_ACK;
                                end
                            else
                                begin
                                    // Wait for the AXI4 master to drive out data
                                    nextStateWr = WAIT_FULL_WAIT_WR_DATA;
                                end
                        end
                    else
                        begin
                            // AXI4 master hasn't seen the ack' yet as it must have
                            // driven AWVALID low (Shouldn't happen).
                            AWREADYReg_d = 1'b1;
                            nextStateWr  = WR_FULL_WR_ADDR_ACK;
                        end
                end
            WAIT_FULL_WAIT_WR_DATA:
                begin
                    if (WVALID)
                        begin
                            // Drive out the data to the AXI4-Lite slave
                            WVALID_LiteReg_d = 1'b1;
                            WDATA_LiteReg_d  = WDATA;
                            WSTRB_LiteReg_d  = WSTRB;        
                            nextStateWr      = WR_LITE_WR_DATA_ACK;
                        end
                    else
                        begin
                            // Wait for the AXI4 master to drive out data
                            nextStateWr = WAIT_FULL_WAIT_WR_DATA;
                        end
                end
            WR_LITE_WR_DATA_ACK:
                begin
                    if (WVALID_Lite & WREADY_Lite)
                        begin
                            // The AXI4-Lite slave has ack'ed the write data
                            BREADY_LiteReg_d = 1'b1;
                            nextStateWr      = WR_LITE_WAIT_RESP;
                        end
                    else
                        begin
                            // Continue to drive out the write data to AXI4-Lite
                            // slave
                            WVALID_LiteReg_d = 1'b1;
                            WDATA_LiteReg_d  = WDATA;
                            WSTRB_LiteReg_d  = WSTRB;        
                            nextStateWr      = WR_LITE_WR_DATA_ACK;
                        end
                end
            WR_LITE_WAIT_RESP:
                begin
                    if (BVALID_Lite & BREADY_Lite)
                        begin
                            // Response data received and ack'ed
                            if (BRESP_Lite != 2'b00)
                                begin
                                    // Catch AXI4-Lite transaction errors to
                                    // return to AXI4 master at the end of the
                                    // burst transaction
                                    errorHoldReg_d = 1'b1;
                                end
                            // Acknowledge the current write beat with the AXI4
                            // master
                            WREADYReg_d = 1'b1;
                            nextStateWr = WR_FULL_WAIT_ACK;
                        end
                    else
                        begin
                            // Continue to wait for the write response from the
                            // AXI4-Lite slave.
                            BREADY_LiteReg_d = 1'b1;
                            nextStateWr      = WR_LITE_WAIT_RESP;
                        end
                end
            WR_FULL_WAIT_ACK:
                begin
                    if (WVALID & WREADY)
                        begin
                            // AXI4 master has seen the write data ack' for the
                            // current write data beat
                            if (WLAST)
                                begin
                                    // Start driving out the write response to
                                    // the AXI4 Master as the entire write data
                                    // burst has been forwarded to the AXI4-Lite
                                    // slave
                                    BVALIDReg_d = 1'b1;
                                    BRESPReg_d  = errorHoldReg;
                                    BIDReg_d    = wrIDReg;
                                    nextStateWr = WR_FULL_WAIT_RESP_ACK;
                                end
                            else
                                begin
                                    // Perform the process over again for the
                                    // next beat of write data from the AXI4 master
                                    AWVALID_LiteReg_d = 1'b1;
                                    AWADDR_LiteReg_d  = wrAddrReg;
                                    nextStateWr       = WR_LITE_WR_ADDR;
                                end
                        end
                    else
                        begin
                            // AXI4 master hasn't seen the ack' yet as it must have
                            // driven WVALID low (Shouldn't happen).
                            WREADYReg_d = 1'b1;
                            nextStateWr = WR_FULL_WAIT_ACK;
                        end
                end
            WR_FULL_WAIT_RESP_ACK:
                begin
                    if (BREADY & BVALID)
                        begin
                            // The AXI4 Master has ack'ed the write response
                            // signifying the end of the write burst transaction
                            // processing
                            // Clear the error holding register if it's set
                            errorHoldReg_d = 1'b0;
                            nextStateWr    = WR_IDLE;
                        end
                    else
                        begin
                            // Waiting on the AXI4 master to ack' the write
                            // response. Continue driving out the write response
                            BVALIDReg_d = 1'b1;
                            BRESPReg_d  = errorHoldReg;
                            BIDReg_d    = wrIDReg;
                            nextStateWr = WR_FULL_WAIT_RESP_ACK;
                        end
                end
            default:
                begin
                    nextStateWr = WR_IDLE;
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// Read Ctrl FSM - Current state register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                currStateRd <= RD_IDLE;
            end
        else
            begin
                currStateRd <= nextStateRd;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// Read Ctrl FSM - Combinatorial next state & output logic
////////////////////////////////////////////////////////////////////////////////
always @ (*)
    begin
        // Default assignments
        ARVALID_LiteReg_d = 1'b0;
        rdSizeReg_d       = rdSizeReg;
        ARADDR_LiteReg_d  = {ADDR_WIDTH{1'b0}};
        rdAddrReg_d       = rdAddrReg;
        rdBurstReg_d      = rdBurstReg;
        rdIDReg_d         = rdIDReg;
        rdLenReg_d        = rdLenReg;
        ARREADYReg_d      = 1'b0;
        RREADY_LiteReg_d  = 1'b0;
        RLASTReg_d        = 1'b0;
        RVALIDReg_d       = 1'b0;
        RDATAReg_d        = {DATA_WIDTH{1'b0}};
        RRESPReg_d        = 2'b0;
        RIDReg_d          = {ID_WIDTH{1'b0}};
        rdBeatCnt_d       = rdBeatCnt;
        case (currStateRd)
            RD_IDLE:
                begin
                    if (ARVALID)
                        begin
                            // Start the AXI4-Lite read transaction
                            ARVALID_LiteReg_d = 1'b1;
                            rdSizeReg_d       = ARSIZE;
                            ARADDR_LiteReg_d  = {ARADDR[ADDR_WIDTH-1:DWIDTH_BYTE_WIDTH], {DWIDTH_BYTE_WIDTH{1'b0}}};
                            rdAddrReg_d       = {ARADDR[ADDR_WIDTH-1:DWIDTH_BYTE_WIDTH], {DWIDTH_BYTE_WIDTH{1'b0}}};
                            rdBurstReg_d      = ARBURST;
                            rdIDReg_d         = ARID;
                            rdLenReg_d        = ARLEN;
                            nextStateRd       = RD_LITE_RD_ADDR;
                        end
                    else
                        begin
                            nextStateRd = RD_IDLE;
                        end
                end
            RD_LITE_RD_ADDR:
                begin
                    if (ARVALID_Lite & ARREADY_Lite)
                        begin
                            // AXI4-Lite slave has ack'ed the read address. Now lets ack' the address data
                            // from the AXI4 master
                            rdAddrReg_d  = rdAddrReg + (2**rdSizeReg);
                            ARREADYReg_d = 1'b1;
                            nextStateRd  = RD_FULL_RD_ADDR_ACK;
                        end
                    else
                        begin
                            // Continue to drive out the address data to the AXI4-Lite slave
                            ARVALID_LiteReg_d = 1'b1;
                            ARADDR_LiteReg_d  = rdAddrReg;
                            nextStateRd       = RD_LITE_RD_ADDR;
                        end
                end
            RD_FULL_RD_ADDR_ACK:
                begin
                    if (ARVALID & ARREADY)
                        begin
                            // AXI4 master has seen the address acknowledgement. 
                            // Get ready to receive the read data from the AXI4-Lite
                            // slave
                            RREADY_LiteReg_d = 1'b1;
                            nextStateRd      = RD_LITE_WAIT_RD_DATA;
                        end
                    else
                        begin
                            // AXI4 master hasn't seen the ack' yet as it must have
                            // driven ARVALID low (Shouldn't happen).
                            ARREADYReg_d = 1'b1;
                            nextStateRd  = RD_FULL_RD_ADDR_ACK;
                        end
                end
            RD_LITE_WAIT_RD_DATA:
                begin
                    if (RVALID_Lite & RREADY_Lite)
                        begin
                            // AXI-Lite slave returned read data & response info
                            // Forward the read data to the AXI4 master. 
                            if (rdBeatCnt == rdLenReg)
                                begin
                                    // This is the last transfer in the AXI4
                                    // read transaction
                                    RLASTReg_d = 1'b1;
                                end
                            else
                                begin
                                    rdBeatCnt_d = rdBeatCnt + 1'b1;
                                end
                            RVALIDReg_d = 1'b1;
                            RDATAReg_d  = RDATA_Lite;
                            RRESPReg_d  = RRESP_Lite;
                            RIDReg_d    = rdIDReg;
                            nextStateRd = RD_FULL_RD_DATA_ACK;
                        end
                    else
                        begin
                            // AXI4-Lite slave not yet driving out valid read
                            // data
                            RREADY_LiteReg_d = 1'b1;
                            nextStateRd      = RD_LITE_WAIT_RD_DATA;
                        end
                end
            RD_FULL_RD_DATA_ACK:
                begin
                    if (RVALID & RREADY)
                        begin
                            if (rdBeatCnt == rdLenReg)
                                begin
                                    rdBeatCnt_d = 8'b0;
                                    nextStateRd = RD_IDLE;
                                end
                            else
                                begin
                                    // More AXI4-Lite reads required to fulfill
                                    // the AXI4 master's request.
                                    ARVALID_LiteReg_d = 1'b1;
                                    ARADDR_LiteReg_d  = rdAddrReg;
                                    nextStateRd       = RD_LITE_RD_ADDR;
                                end
                        end
                    else
                        begin
                            // Waiting on the AXI4 master to ACK the read data
                            // transfer. Continue to drive out the read data 
                            if (rdBeatCnt == rdLenReg)
                                begin
                                    // This is the last transfer in the AXI4
                                    // read transaction
                                    RLASTReg_d = 1'b1;
                                end
                            RVALIDReg_d = 1'b1;
                            RDATAReg_d  = RDATA_Lite;
                            RRESPReg_d  = RRESP_Lite;
                            RIDReg_d    = rdIDReg;
                            nextStateRd = RD_FULL_RD_DATA_ACK;
                        end
                end
            default:
                begin
                    nextStateRd = RD_IDLE;
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// AWVALID_Lite register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                AWVALID_LiteReg <= 1'b0;
            end
        else
            begin
                AWVALID_LiteReg <= AWVALID_LiteReg_d;
            end
    end
assign AWVALID_Lite = AWVALID_LiteReg;

////////////////////////////////////////////////////////////////////////////////
// wrSize register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                wrSizeReg <= 3'b0;
            end
        else
            begin
                wrSizeReg <= wrSizeReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// AWADDR_Lite register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                AWADDR_LiteReg <= {ADDR_WIDTH{1'b0}};
            end
        else
            begin
                AWADDR_LiteReg <= AWADDR_LiteReg_d;
            end
    end
assign AWADDR_Lite = AWADDR_LiteReg;

////////////////////////////////////////////////////////////////////////////////
// wrAddr register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                wrAddrReg <= {ADDR_WIDTH{1'b0}};
            end
        else
            begin
                wrAddrReg <= wrAddrReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// wrBurst register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                wrBurstReg <= 2'b0;
            end
        else
            begin
                wrBurstReg <= wrBurstReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// wrID register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                wrIDReg <= {ID_WIDTH{1'b0}};
            end
        else
            begin
                wrIDReg <= wrIDReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// AWREADY register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                AWREADYReg <= 1'b0;
            end
        else
            begin
                AWREADYReg <= AWREADYReg_d;
            end
    end
assign AWREADY = AWREADYReg;

////////////////////////////////////////////////////////////////////////////////
// WVALID_Lite register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                WVALID_LiteReg <= 1'b0;
            end
        else
            begin
                WVALID_LiteReg <= WVALID_LiteReg_d;
            end
    end
assign WVALID_Lite = WVALID_LiteReg;

////////////////////////////////////////////////////////////////////////////////
// WDATA_Lite register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                WDATA_LiteReg <= {DATA_WIDTH{1'b0}};
            end
        else
            begin
                WDATA_LiteReg <= WDATA_LiteReg_d;
            end
    end
assign WDATA_Lite = WDATA_LiteReg;

////////////////////////////////////////////////////////////////////////////////
// WSTRB_Lite register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                WSTRB_LiteReg <= {(DATA_WIDTH/8){1'b0}};
            end
        else
            begin
                WSTRB_LiteReg <= WSTRB_LiteReg_d;
            end
    end
assign WSTRB_Lite = WSTRB_LiteReg;

////////////////////////////////////////////////////////////////////////////////
// BREADY_Lite register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                BREADY_LiteReg <= 1'b0;
            end
        else
            begin
                BREADY_LiteReg <= BREADY_LiteReg_d;
            end
    end
assign BREADY_Lite = BREADY_LiteReg;

////////////////////////////////////////////////////////////////////////////////
// WREADY register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                WREADYReg <= 1'b0;
            end
        else
            begin
                WREADYReg <= WREADYReg_d;
            end
    end
assign WREADY = WREADYReg;

////////////////////////////////////////////////////////////////////////////////
// BVALID register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                BVALIDReg <= 1'b0;
            end
        else
            begin
                BVALIDReg <= BVALIDReg_d;
            end
    end
assign BVALID = BVALIDReg;

////////////////////////////////////////////////////////////////////////////////
// BRESP register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                BRESPReg <= 2'b0;
            end
        else
            begin
                BRESPReg <= BRESPReg_d;
            end
    end
assign BRESP = BRESPReg;

////////////////////////////////////////////////////////////////////////////////
// BID register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                BIDReg <= {ID_WIDTH{1'b0}};
            end
        else
            begin
                BIDReg <= BIDReg_d;
            end
    end
assign BID = BIDReg;

////////////////////////////////////////////////////////////////////////////////
// errorHold register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                errorHoldReg <= 1'b0;
            end
        else
            begin
                errorHoldReg <= errorHoldReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// ARVALID_Lite register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                ARVALID_LiteReg <= 1'b0;
            end
        else
            begin
                ARVALID_LiteReg <= ARVALID_LiteReg_d;
            end
    end
assign ARVALID_Lite = ARVALID_LiteReg;

////////////////////////////////////////////////////////////////////////////////
// rdSize register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                rdSizeReg <= 3'b0;
            end
        else
            begin
                rdSizeReg <= rdSizeReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// ARADDR_Lite register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                ARADDR_LiteReg <= {ADDR_WIDTH{1'b0}};
            end
        else
            begin
                ARADDR_LiteReg <= ARADDR_LiteReg_d;
            end
    end
assign ARADDR_Lite = ARADDR_LiteReg;

////////////////////////////////////////////////////////////////////////////////
// rdAddr register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                rdAddrReg <= {ADDR_WIDTH{1'b0}};
            end
        else
            begin
                rdAddrReg <= rdAddrReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// rdBurst register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                rdBurstReg <= 2'b0;
            end
        else
            begin
                rdBurstReg <= rdBurstReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// rdID register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                rdIDReg <= {ID_WIDTH{1'b0}};
            end
        else
            begin
                rdIDReg <= rdIDReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// rdLen register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                rdLenReg <= 8'b0;
            end
        else
            begin
                rdLenReg <= rdLenReg_d;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// ARREADY register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                ARREADYReg <= 1'b0;
            end
        else
            begin
                ARREADYReg <= ARREADYReg_d;
            end
    end
assign ARREADY = ARREADYReg;

////////////////////////////////////////////////////////////////////////////////
// RREADY_Lite register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                RREADY_LiteReg <= 1'b0;
            end
        else
            begin
                RREADY_LiteReg <= RREADY_LiteReg_d;
            end
    end
assign RREADY_Lite = RREADY_LiteReg;

////////////////////////////////////////////////////////////////////////////////
// RLAST register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                RLASTReg <= 1'b0;
            end
        else
            begin
                RLASTReg <= RLASTReg_d;
            end
    end
assign RLAST = RLASTReg;

////////////////////////////////////////////////////////////////////////////////
// RVALID register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                RVALIDReg <= 1'b0;
            end
        else
            begin
                RVALIDReg <= RVALIDReg_d;
            end
    end
assign RVALID = RVALIDReg;

////////////////////////////////////////////////////////////////////////////////
// RDATA register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                RDATAReg <= {DATA_WIDTH{1'b0}};
            end
        else
            begin
                RDATAReg <= RDATAReg_d;
            end
    end
assign RDATA = RDATAReg;

////////////////////////////////////////////////////////////////////////////////
// RRESP register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                RRESPReg <= 2'b0;
            end
        else
            begin
                RRESPReg <= RRESPReg_d;
            end
    end
assign RRESP = RRESPReg;

////////////////////////////////////////////////////////////////////////////////
// RID register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                RIDReg <= {ID_WIDTH{1'b0}};
            end
        else
            begin
                RIDReg <= RIDReg_d;
            end
    end
assign RID = RIDReg;

////////////////////////////////////////////////////////////////////////////////
// rdBeatCnt register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                rdBeatCnt <= 8'b0;
            end
        else
            begin
                rdBeatCnt <= rdBeatCnt_d;
            end
    end

endmodule // AXI4ToAXI4LiteBridge