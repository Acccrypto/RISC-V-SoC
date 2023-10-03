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
module AXI4SlaveRAM (
    // General inputs
    clock,
    resetn,
    
    // Write address channel inputs
    AWVALID,
    AWADDR,
    AWID,
    AWLEN,
    AWSIZE,
    AWBURST,
    
    // Write data channel inputs
    WVALID,
    WDATA,
    WSTRB,
    WLAST,
    
    // Write response channel inputs
    BREADY,
    
    // Read address channel inputs
    ARVALID,
    ARADDR,
    ARID,
    ARLEN,
    ARSIZE,
    ARBURST,
    
    // Read data channel inputs
    RREADY,
    
    // Write address channel outputs
    AWREADY,
    
    // Write data channel outputs
    WREADY,
    
    // Write response channel outputs
    BVALID,
    BRESP,
    BID,
    
    // Read address channel outputs
    ARREADY,
    
    // Read data channel outputs
    RVALID,
    RDATA,
    RID,
    RRESP,
    RLAST
);
////////////////////////////////////////////////////////////////////////////////
// Parameters
////////////////////////////////////////////////////////////////////////////////
parameter  ADDR_WIDTH = 8;   // Number of address bits. Determines the amount of RAM inferred
parameter  DATA_WIDTH = 64;  // Data width in bits
parameter  ID_WIDTH   = 1;   // ID field width
parameter  RAM_INIT_FILE  = "./ram_init.mem";

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
localparam [3:0] WR_IDLE         = 4'b0001;
localparam [3:0] WR_ADDR_WAIT    = 4'b0010;
localparam [3:0] WR_DATA_RX      = 4'b0100;
localparam [3:0] WAIT_WR_RESP    = 4'b1000;

// Read control FSM states - One-shot encoding
localparam [3:0] RD_IDLE         = 4'b0001;
localparam [3:0] RD_ADDR_WAIT    = 4'b0010;
localparam [3:0] RD_DATA_STRT    = 4'b0100;
localparam [3:0] RD_DATA_TX      = 4'b1000;

localparam DWIDTH_BYTE_WIDTH     = clog2((DATA_WIDTH/8)-1); // Number of bits required to hold the data width in bytes

////////////////////////////////////////////////////////////////////////////////
// Internal signals
////////////////////////////////////////////////////////////////////////////////
reg [3:0]                   currStateWr;
reg [3:0]                   nextStateWr;
reg [3:0]                   currStateRd;
reg [3:0]                   nextStateRd;

reg                         AWREADYReg;
reg                         AWREADYReg_d;
reg                         WREADYReg;
reg                         WREADYReg_d;
reg                         BVALIDReg;
reg                         BVALIDReg_d;
reg [1:0]                   BRESPReg;
reg [1:0]                   BRESPReg_d;
reg [ID_WIDTH-1:0]          BIDReg;
reg [ID_WIDTH-1:0]          BIDReg_d;

reg [ADDR_WIDTH-1:0]        wrAddrReg;
reg [ADDR_WIDTH-1:0]        wrAddrReg_d;
reg [2:0]                   wrSizeReg;
reg [2:0]                   wrSizeReg_d;
reg [7:0]                   wrLenReg;
reg [7:0]                   wrLenReg_d;
reg [ID_WIDTH-1:0]          wrIDReg;
reg [ID_WIDTH-1:0]          wrIDReg_d;
reg [1:0]                   wrBurstReg;
reg [1:0]                   wrBurstReg_d;

reg                         ARREADYReg;
reg                         ARREADYReg_d;
reg                         RVALIDReg;
reg                         RVALIDReg_d;
reg [DATA_WIDTH-1:0]        RDATAReg;
reg [DATA_WIDTH-1:0]        RDATAReg_d;
reg [ID_WIDTH-1:0]          RIDReg;
reg [ID_WIDTH-1:0]          RIDReg_d;
reg [1:0]                   RRESPReg;
reg [1:0]                   RRESPReg_d;
reg                         RLASTReg;
reg                         RLASTReg_d;

reg [ADDR_WIDTH-1:0]        rdAddrReg;
reg [ADDR_WIDTH-1:0]        rdAddrReg_d;
reg [2:0]                   rdSizeReg;
reg [2:0]                   rdSizeReg_d;
reg [7:0]                   rdLenReg;
reg [7:0]                   rdLenReg_d;
reg [ID_WIDTH-1:0]          rdIDReg;
reg [ID_WIDTH-1:0]          rdIDReg_d;
reg [1:0]                   rdBurstReg;
reg [1:0]                   rdBurstReg_d;
reg [7:0]                   rdBeatCntReg;
reg [7:0]                   rdBeatCntReg_d;
wire [DATA_WIDTH-1:0]       RAMRdData;

reg [7:0]                   RAM [0:(2**ADDR_WIDTH)-1];
genvar                      write_offset;
genvar                      read_offset;

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
        nextStateWr     <= currStateWr;
        AWREADYReg_d    <= 1'b0;
        WREADYReg_d     <= 1'b0;
        BVALIDReg_d     <= 1'b0;
        BRESPReg_d      <= 2'b0;
        BIDReg_d        <= {ID_WIDTH{1'b0}};
        wrAddrReg_d     <= wrAddrReg;
        wrSizeReg_d     <= wrSizeReg;
        wrLenReg_d      <= wrLenReg;
        wrIDReg_d       <= wrIDReg;
        wrBurstReg_d    <= wrBurstReg;
        case (currStateWr)
            WR_IDLE:
                begin
                    if (AWVALID)
                        begin
                            AWREADYReg_d <= 1'b1;
                            nextStateWr  <= WR_ADDR_WAIT;
                        end
                end
            WR_ADDR_WAIT:
                begin
                    if (AWVALID & AWREADY)
                        begin
                            // Align the address to the instantiated bus width
                            wrAddrReg_d    <= {AWADDR[ADDR_WIDTH-1:DWIDTH_BYTE_WIDTH], {DWIDTH_BYTE_WIDTH{1'b0}}};
                            wrSizeReg_d    <= AWSIZE;
                            wrLenReg_d     <= AWLEN;
                            wrIDReg_d      <= AWID;
                            wrBurstReg_d   <= AWBURST;
                            WREADYReg_d    <= 1'b1;
                            nextStateWr    <= WR_DATA_RX;
                        end
                    else
                        begin
                            AWREADYReg_d <= 1'b1;
                        end
                end
            WR_DATA_RX:
                begin
                    if (WVALID & WREADY)
                        begin
                            if (WLAST)
                                begin
                                    wrAddrReg_d <= {ADDR_WIDTH{1'b0}};
                                    BVALIDReg_d <= 1'b1;
                                    BRESPReg_d  <= 2'b00; // 'Okay' response
                                    BIDReg_d    <= wrIDReg;
                                    nextStateWr <= WAIT_WR_RESP;
                                end
                            else
                                begin
                                    WREADYReg_d <= 1'b1;
                                    if (wrBurstReg == 2'b01)
                                        begin
                                            wrAddrReg_d <= wrAddrReg + (2**wrSizeReg); // Increment the address by the transfer size
                                        end
                                end
                        end
                    else
                        begin
                            WREADYReg_d <= 1'b1;
                        end
                end
            WAIT_WR_RESP:
                begin
                    if (BVALID & BREADY)
                        begin
                            nextStateWr <= WR_IDLE;
                        end
                    else
                        begin
                            BVALIDReg_d <= 1'b1;
                            BRESPReg_d  <= 2'b00; // 'Okay' response
                            BIDReg_d    <= wrIDReg;
                        end
                end
            default:
                begin
                    nextStateWr <= WR_IDLE;
                end
        endcase
    end
   
////////////////////////////////////////////////////////////////////////////////
// Initialise the RAM for simulation
////////////////////////////////////////////////////////////////////////////////
initial
    begin
        $readmemb(RAM_INIT_FILE, RAM);
    end

////////////////////////////////////////////////////////////////////////////////
// Synchronous write
////////////////////////////////////////////////////////////////////////////////
generate
    for(write_offset=0; write_offset<(DATA_WIDTH/8); write_offset = write_offset + 1)
        begin : mem_write
            always @ (posedge clock)
                begin
                    if(WVALID & WREADY & WSTRB[write_offset])
                        RAM[wrAddrReg+write_offset] <= WDATA[(((write_offset+1)<<3)-1):(write_offset<<3)]; 
                end
        end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// Asynchronous read
////////////////////////////////////////////////////////////////////////////////
generate
    for(read_offset=0; read_offset<(DATA_WIDTH/8); read_offset = read_offset + 1)
        begin : mem_read
            assign RAMRdData[(((read_offset+1)<<3)-1):(read_offset<<3)] = RAM[(rdAddrReg+read_offset)]; 
        end
endgenerate
                    
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
        nextStateRd     <= currStateRd;
        ARREADYReg_d    <= 1'b0;
        RVALIDReg_d     <= 1'b0;
        RDATAReg_d      <= RDATAReg;
        RIDReg_d        <= {ID_WIDTH{1'b0}};
        RRESPReg_d      <= 2'b0;
        RLASTReg_d      <= 1'b0;
        rdAddrReg_d     <= rdAddrReg;
        rdSizeReg_d     <= rdSizeReg;
        rdLenReg_d      <= rdLenReg;
        rdIDReg_d       <= rdIDReg;
        rdBurstReg_d    <= rdBurstReg;
        rdBeatCntReg_d  <= rdBeatCntReg;
        case (currStateRd)
            RD_IDLE:
                begin
                    if (ARVALID)
                        begin
                            ARREADYReg_d <= 1'b1;
                            nextStateRd  <= RD_ADDR_WAIT;
                        end
                end
            RD_ADDR_WAIT:
                begin
                    if (ARVALID & ARREADY)
                        begin
                            rdAddrReg_d    <= {ARADDR[ADDR_WIDTH-1:DWIDTH_BYTE_WIDTH], {DWIDTH_BYTE_WIDTH{1'b0}}};
                            rdSizeReg_d    <= ARSIZE;
                            rdLenReg_d     <= ARLEN;
                            rdIDReg_d      <= ARID;
                            rdBurstReg_d   <= ARBURST;
                            nextStateRd    <= RD_DATA_STRT;
                        end
                    else
                        begin
                            ARREADYReg_d <= 1'b1;
                        end
                end
            RD_DATA_STRT:
                begin
                    // Pipeline the address and the read data.
                    // Address the next location in RAM to have data ready at
                    // RDATA register when the next ack is received
                    RVALIDReg_d <= 1'b1;
                    RIDReg_d    <= rdIDReg;
                    RDATAReg_d  <= RAMRdData;
                    nextStateRd <= RD_DATA_TX;
                    if (rdLenReg == 0)
                        begin
                            // Single transfer transaction
                            RLASTReg_d     <= 1'b1;
                            rdAddrReg_d    <= {ADDR_WIDTH{1'b0}};
                        end
                    else
                        begin
                            if (rdBurstReg == 2'b01)
                                begin
                                    rdAddrReg_d <= rdAddrReg +(2**rdSizeReg);
                                end
                        end
                end
            RD_DATA_TX:
                begin
                    if (RVALID & RREADY)
                        begin
                            if (RLAST)
                                begin
                                    nextStateRd <= RD_IDLE;
                                    RDATAReg_d  <= {DATA_WIDTH{1'b0}};
                                end
                            else
                                begin
                                    RVALIDReg_d <= 1'b1;
                                    RIDReg_d    <= rdIDReg;
                                    RDATAReg_d  <= RAMRdData;
                                    if (rdBeatCntReg == rdLenReg - 1'b1)
                                        begin
                                            rdBeatCntReg_d <= 8'b0;
                                            RLASTReg_d     <= 1'b1;
                                            rdAddrReg_d    <= {ADDR_WIDTH{1'b0}};
                                        end
                                    else
                                        begin
                                            rdBeatCntReg_d <= rdBeatCntReg + 1'b1;
                                            if (rdBurstReg == 2'b01)
                                                begin
                                                    rdAddrReg_d <= rdAddrReg +(2**rdSizeReg);
                                                end
                                        end
                                end
                        end
                    else if (RLAST & RVALID)
                        begin
                            // Keep driving out RLAST if RREADY is not asserted
                            RLASTReg_d  <= 1'b1;
                            RVALIDReg_d <= 1'b1;
                            RIDReg_d    <= rdIDReg;
                        end
                    else
                        begin
                            RVALIDReg_d <= 1'b1;
                            RIDReg_d    <= rdIDReg;
                        end
                end
            default:
                begin
                    nextStateRd <= RD_IDLE;
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// rdBeatCnt register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                rdBeatCntReg <= 8'b0;
            end
        else
            begin
                rdBeatCntReg <= rdBeatCntReg_d;
            end
    end

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
// wrLen register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                wrLenReg <= 8'b0;
            end
        else
            begin
                wrLenReg <= wrLenReg_d;
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

endmodule // AXI4SlaveRAM