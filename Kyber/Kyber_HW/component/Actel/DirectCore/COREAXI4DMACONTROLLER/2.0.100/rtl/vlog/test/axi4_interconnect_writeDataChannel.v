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
module interconnect_writeDataChannel(
    // General inputs
    clock,
    resetn,
    
    // Master 0 inputs
    WVALID_M0,
    WDATA_M0,
    WSTRB_M0,
    WLAST_M0,
    
    // Master 1 inputs
    WVALID_M1,
    WDATA_M1,
    WSTRB_M1,
    WLAST_M1,
    
    // Slave 0 inputs
    WREADY_S0,
    
    // Slave 1 inputs
    WREADY_S1,
    
    // Slave 2 inputs
    WREADY_S2,
    
    // Slave 3 inputs
    WREADY_S3,
    
    // Write address channel inputs
    wrDataChanAddr,
    
    // Master 0 outputs
    WREADY_M0,
    
    // Master 1 outputs
    WREADY_M1,
    
    // Slave 0 outputs
    WVALID_S0,
    WDATA_S0,
    WSTRB_S0,
    WLAST_S0,
    
    // Slave 1 outputs
    WVALID_S1,
    WDATA_S1,
    WSTRB_S1,
    WLAST_S1,
    
    // Slave 2 outputs
    WVALID_S2,
    WDATA_S2,
    WSTRB_S2,
    WLAST_S2,
    
    // Slave 3 outputs
    WVALID_S3,
    WDATA_S3,
    WSTRB_S3,
    WLAST_S3,
    
    // Write address channel outputs
    wrDataChanGrant
);

////////////////////////////////////////////////////////////////////////////////
// Parameters
////////////////////////////////////////////////////////////////////////////////
parameter DWIDTH = 64; // Data width in bits
parameter AWIDTH = 0;

////////////////////////////////////////////////////////////////////////////////
// Port directions
////////////////////////////////////////////////////////////////////////////////
// General inputs
input                           clock;
input                           resetn;

// Master 0 inputs
input                           WVALID_M0;
input   [DWIDTH-1:0]            WDATA_M0;
input   [(DWIDTH/8)-1:0]        WSTRB_M0;
input                           WLAST_M0;

// Master 1 inputs
input                           WVALID_M1;
input   [DWIDTH-1:0]            WDATA_M1;
input   [(DWIDTH/8)-1:0]        WSTRB_M1;
input                           WLAST_M1;

// Slave 0 inputs
input                           WREADY_S0;

// Slave 1 inputs
input                           WREADY_S1;

// Slave 2 inputs
input                           WREADY_S2;

// Slave 3 inputs
input                           WREADY_S3;

// Write address channel inputs
input   [AWIDTH-1:0]            wrDataChanAddr;

// Master 0 outputs
output reg                      WREADY_M0;

// Master 1 outputs
output reg                      WREADY_M1;

// Slave 0 outputs
output reg                      WVALID_S0;
output      [DWIDTH-1:0]        WDATA_S0;
output      [(DWIDTH/8)-1:0]    WSTRB_S0;
output                          WLAST_S0;

// Slave 1 outputs
output reg                      WVALID_S1;
output      [DWIDTH-1:0]        WDATA_S1;
output      [(DWIDTH/8)-1:0]    WSTRB_S1;
output                          WLAST_S1;

// Slave 2 outputs
output reg                      WVALID_S2;
output      [DWIDTH-1:0]        WDATA_S2;
output      [(DWIDTH/8)-1:0]    WSTRB_S2;
output                          WLAST_S2;

// Slave 3 outputs
output reg                      WVALID_S3;
output      [DWIDTH-1:0]        WDATA_S3;
output      [(DWIDTH/8)-1:0]    WSTRB_S3;
output                          WLAST_S3;

// Write address channel outputs
output      [1:0]               wrDataChanGrant;

////////////////////////////////////////////////////////////////////////////////
// Constants
////////////////////////////////////////////////////////////////////////////////
localparam [3:0] M0_PRI_IDLE   = 4'b0001;
localparam [3:0] M1_PRI_IDLE   = 4'b0010;
localparam [3:0] M0_WAIT_READY = 4'b0100;
localparam [3:0] M1_WAIT_READY = 4'b1000;

////////////////////////////////////////////////////////////////////////////////
// Internal signals
////////////////////////////////////////////////////////////////////////////////
reg     [1:0]                   grant;
reg     [1:0]                   grantPrev;
wire                            grantRE;
wire                            WREADYInt;
reg                             WVALIDInt;
reg     [DWIDTH-1:0]            WDATAInt;
reg     [(DWIDTH/8)-1:0]        WSTRBInt;
reg                             WLASTInt;
reg     [DWIDTH-1:0]            WDATAOut;
reg     [(DWIDTH/8)-1:0]        WSTRBOut;
reg                             WLASTOut;
reg     [3:0]                   currState;
reg     [3:0]                   nextState;
reg     [1:0]                   wrDataChanAddrReg;
reg     [1:0]                   grantReg;

////////////////////////////////////////////////////////////////////////////////
// grant rising edge detect
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                grantPrev <= 2'b0;
            end
        else
            begin
                grantPrev <= grant;
            end
    end
assign grantRE = (!grantPrev[0] & grant[0]) || (!grantPrev[1] & grant[1]);

////////////////////////////////////////////////////////////////////////////////
// grant register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                grantReg <= 2'b0;
            end
        else if (grantRE)
            begin
                grantReg <= grant;
            end
        else if ((WVALID_S0 & WREADY_S0) || (WVALID_S1 & WREADY_S1) ||
                 (WVALID_S2 & WREADY_S2) || (WVALID_S3 & WREADY_S3) )
            begin
                grantReg <= 2'b0;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// WREADY output register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                WREADY_M0 = 1'b0;
                WREADY_M1 = 1'b0;
            end
        else
            begin
                if ((WVALID_S0 & WREADY_S0) || (WVALID_S1 & WREADY_S1) ||
                    (WVALID_S2 & WREADY_S2) || (WVALID_S3 & WREADY_S3) )
                    begin
                        case (grantReg)
                            2'b01:
                                begin
                                    WREADY_M0 = 1'b1;
                                    WREADY_M1 = 1'b0;
                                end
                            2'b10:
                                begin
                                    WREADY_M0 = 1'b0;
                                    WREADY_M1 = 1'b1;
                                end
                            default:
                                begin
                                end
                        endcase
                    end
                else
                    begin
                        WREADY_M0 = 1'b0;
                        WREADY_M1 = 1'b0;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// WVALID input mux
////////////////////////////////////////////////////////////////////////////////
always @ (*)
    begin
        // Default assignments
        WVALIDInt = 1'b0;
        WDATAInt  = {DWIDTH{1'b0}};
        WSTRBInt  = {(DWIDTH/8){1'b0}};
        WLASTInt  = 1'b0;
        case (grant)
            2'b01:
                begin
                    WVALIDInt = WVALID_M0;
                    WDATAInt  = WDATA_M0;
                    WSTRBInt  = WSTRB_M0;
                    WLASTInt  = WLAST_M0;
                end
            2'b10:
                begin
                    WVALIDInt = WVALID_M1;
                    WDATAInt  = WDATA_M1;
                    WSTRBInt  = WSTRB_M1;
                    WLASTInt  = WLAST_M1;
                end
            default:
                begin
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// Write data register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                wrDataChanAddrReg <= 2'b0;
                WDATAOut          <= {DWIDTH{1'b0}};
                WSTRBOut          <= {(DWIDTH/8){1'b0}};
                WLASTOut          <= 1'b0;
            end
        else
            begin
                if (grantRE)
                    begin
                        wrDataChanAddrReg <= wrDataChanAddr[AWIDTH-1:AWIDTH-2];
                        WDATAOut          <= WDATAInt;
                        WSTRBOut          <= WSTRBInt;
                        WLASTOut          <= WLASTInt;
                    end
                else if ((WVALID_S0 & WREADY_S0) || (WVALID_S1 & WREADY_S1) ||
                         (WVALID_S2 & WREADY_S2) || (WVALID_S3 & WREADY_S3) )
                    begin
                        wrDataChanAddrReg <= 2'b0;
                        WDATAOut          <= {DWIDTH{1'b0}};
                        WSTRBOut          <= {(DWIDTH/8){1'b0}};
                        WLASTOut          <= 1'b0;
                    end
            end
    end

// Write data channel shared bus
assign WDATA_S0 = WDATAOut;
assign WDATA_S1 = WDATAOut;
assign WDATA_S2 = WDATAOut;
assign WDATA_S3 = WDATAOut;
assign WSTRB_S0 = WSTRBOut;
assign WSTRB_S1 = WSTRBOut;
assign WSTRB_S2 = WSTRBOut;
assign WSTRB_S3 = WSTRBOut;
assign WLAST_S0 = WLASTOut;
assign WLAST_S1 = WLASTOut;
assign WLAST_S2 = WLASTOut;
assign WLAST_S3 = WLASTOut;

////////////////////////////////////////////////////////////////////////////////
// WVALID output mux
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                WVALID_S0 <= 1'b0;
                WVALID_S1 <= 1'b0;
                WVALID_S2 <= 1'b0;
                WVALID_S3 <= 1'b0;
            end
        else
            begin
                // Apportion the address space equally between the 4 slaves
                if (WVALID_S0 & WREADY_S0)
                    begin
                        WVALID_S0 <= 1'b0;
                    end
                else if ((grantRE) & (wrDataChanAddr[AWIDTH-1:AWIDTH-2] == 2'b00))
                    begin
                        WVALID_S0 <= 1'b1;
                    end
                if (WVALID_S1 & WREADY_S1)
                    begin
                        WVALID_S1 <= 1'b0;
                    end
                else if ((grantRE) & (wrDataChanAddr[AWIDTH-1:AWIDTH-2] == 2'b01))
                    begin
                        WVALID_S1 <= 1'b1;
                    end
                if (WVALID_S2 & WREADY_S2)
                    begin
                        WVALID_S2 <= 1'b0;
                    end
                else if ((grantRE) & (wrDataChanAddr[AWIDTH-1:AWIDTH-2] == 2'b10))
                    begin
                        WVALID_S2 <= 1'b1;
                    end
                if (WVALID_S3 & WREADY_S3)
                    begin
                        WVALID_S3 <= 1'b0;
                    end
                else if ((grantRE) & (wrDataChanAddr[AWIDTH-1:AWIDTH-2] == 2'b11))
                    begin
                        WVALID_S3 <= 1'b1;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// WREADY input mux
////////////////////////////////////////////////////////////////////////////////
assign WREADYInt = (wrDataChanAddrReg == 2'b01) ? WREADY_S1 :
                   (wrDataChanAddrReg == 2'b10) ? WREADY_S2 :
                   (wrDataChanAddrReg == 2'b11) ? WREADY_S3 :
                   WREADY_S0;

////////////////////////////////////////////////////////////////////////////////
// Round robin arbiter
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                currState <= M0_PRI_IDLE;
            end
        else
            begin
                currState <= nextState;
            end
    end

always @ (*)
    begin
        case (currState)
            M0_PRI_IDLE:
                begin
                    if (WVALID_M0 & !WREADY_M0)
                        begin
                            grant     = 2'b01;
                            nextState = M0_WAIT_READY;
                        end
                    else if (WVALID_M1 & !WREADY_M1)
                        begin
                            grant     = 2'b10;
                            nextState = M1_WAIT_READY;
                        end
                    else
                        begin
                            grant     = 2'b00;
                            nextState = M0_PRI_IDLE;
                        end
                end
            M1_PRI_IDLE:
                begin
                    if (WVALID_M1 & !WREADY_M1)
                        begin
                            grant     = 2'b10;
                            nextState = M1_WAIT_READY;
                        end
                    else if (WVALID_M0 & !WREADY_M0)
                        begin
                            grant     = 2'b01;
                            nextState = M0_WAIT_READY;
                        end
                    else
                        begin
                            grant     = 2'b00;
                            nextState = M1_PRI_IDLE;
                        end
                end
            M0_WAIT_READY:
                begin
                    grant = 2'b00;
                    if (WREADYInt)
                        begin
                            nextState = M1_PRI_IDLE;
                        end
                    else
                        begin
                            nextState = M0_WAIT_READY;
                        end
                end
            M1_WAIT_READY:
                begin
                    grant = 2'b00;
                    if (WREADYInt)
                        begin
                            nextState = M0_PRI_IDLE;
                        end
                    else
                        begin
                            nextState = M1_WAIT_READY;
                        end
                end
            default:
                begin
                    grant     = 2'b00;
                    nextState = M0_PRI_IDLE;
                end
        endcase
    end

// Read the write address associated with this master's transaction from the
// write address channel address holding register to determine which slave to
// forward the data to
assign wrDataChanGrant = grant;

endmodule // interconnect_writeDataChannel