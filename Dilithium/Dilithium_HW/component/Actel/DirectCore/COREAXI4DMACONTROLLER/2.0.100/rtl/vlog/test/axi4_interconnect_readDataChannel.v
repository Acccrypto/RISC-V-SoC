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
module interconnect_readDataChannel(
    // General inputs
    clock,
    resetn,
    
    // Master 0 inputs
    RREADY_M0,
    
    // Master 1 inputs
    RREADY_M1,
    
    // Slave 0 inputs
    RVALID_S0,
    RLAST_S0,
    RDATA_S0,
    RID_S0,
    RRESP_S0,

    // Slave 1 inputs
    RVALID_S1,
    RLAST_S1,
    RDATA_S1,
    RID_S1,
    RRESP_S1,
    
    // Slave 2 inputs
    RVALID_S2,
    RLAST_S2,
    RDATA_S2,
    RID_S2,
    RRESP_S2,
    
    // Slave 3 inputs
    RVALID_S3,
    RLAST_S3,
    RDATA_S3,
    RID_S3,
    RRESP_S3,
    
    // Master 0 outputs
    RVALID_M0,
    RLAST_M0,
    RDATA_M0,
    RID_M0,
    RRESP_M0,
    
    // Master 1 outputs
    RVALID_M1,
    RLAST_M1,
    RDATA_M1,
    RID_M1,
    RRESP_M1,
    
    // Slave 0 outputs
    RREADY_S0,
    
    // Slave 1 outputs
    RREADY_S1,
    
    // Slave 2 outputs
    RREADY_S2,

    // Slave 3 outputs
    RREADY_S3
);

////////////////////////////////////////////////////////////////////////////////
// Parameters
////////////////////////////////////////////////////////////////////////////////
parameter ID_WIDTH = 0;
parameter DWIDTH   = 64;

////////////////////////////////////////////////////////////////////////////////
// Port directions
////////////////////////////////////////////////////////////////////////////////
// General inputs
input                       clock;
input                       resetn;

// Master 0 inputs
input                       RREADY_M0;

// Master 1 inputs
input                       RREADY_M1;

// Slave 0 inputs
input                       RVALID_S0;
input                       RLAST_S0;
input       [DWIDTH-1:0]    RDATA_S0;
input       [ID_WIDTH:0]    RID_S0;
input       [1:0]           RRESP_S0;

// Slave 1 inputs
input                       RVALID_S1;
input                       RLAST_S1;
input       [DWIDTH-1:0]    RDATA_S1;
input       [ID_WIDTH:0]    RID_S1;
input       [1:0]           RRESP_S1;

// Slave 2 inputs
input                       RVALID_S2;
input                       RLAST_S2;
input       [DWIDTH-1:0]    RDATA_S2;
input       [ID_WIDTH:0]    RID_S2;
input       [1:0]           RRESP_S2;

// Slave 3 inputs
input                       RVALID_S3;
input                       RLAST_S3;
input       [DWIDTH-1:0]    RDATA_S3;
input       [ID_WIDTH:0]    RID_S3;
input       [1:0]           RRESP_S3;

// Master 0 outputs
output reg                  RVALID_M0;
output                      RLAST_M0;
output      [DWIDTH-1:0]    RDATA_M0;
output      [ID_WIDTH-1:0]  RID_M0;
output      [1:0]           RRESP_M0;

// Master 1 outputs
output reg                  RVALID_M1;
output                      RLAST_M1;
output      [DWIDTH-1:0]    RDATA_M1;
output      [ID_WIDTH-1:0]  RID_M1;
output      [1:0]           RRESP_M1;

// Slave 0 outputs
output reg                  RREADY_S0;

// Slave 1 outputs
output reg                  RREADY_S1;

// Slave 2 outputs
output reg                  RREADY_S2;

// Slave 3 outputs
output reg                  RREADY_S3;

////////////////////////////////////////////////////////////////////////////////
// Constants
////////////////////////////////////////////////////////////////////////////////
localparam [7:0] S0_PRI_IDLE   = 8'b00000001;
localparam [7:0] S1_PRI_IDLE   = 8'b00000010;
localparam [7:0] S2_PRI_IDLE   = 8'b00000100;
localparam [7:0] S3_PRI_IDLE   = 8'b00001000;
localparam [7:0] S0_WAIT_READY = 8'b00010000;
localparam [7:0] S1_WAIT_READY = 8'b00100000;
localparam [7:0] S2_WAIT_READY = 8'b01000000;
localparam [7:0] S3_WAIT_READY = 8'b10000000;

////////////////////////////////////////////////////////////////////////////////
// Internal signals
////////////////////////////////////////////////////////////////////////////////
reg     [3:0]               grant;
reg     [3:0]               grantPrev;
wire                        grantRE;
reg                         RREADYInt;
reg                         RVALIDInt;
reg     [DWIDTH-1:0]        RDATAInt;
reg                         RLASTInt;
reg     [ID_WIDTH:0]        RIDInt;
reg     [1:0]               RRESPInt;
reg     [DWIDTH-1:0]        RDATAOut;
reg                         RLASTOut;
reg     [ID_WIDTH:0]        RIDOut;
reg     [1:0]               RRESPOut;
reg     [7:0]               currState;
reg     [7:0]               nextState;
reg     [3:0]               grantReg;

////////////////////////////////////////////////////////////////////////////////
// grant rising edge detect
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                grantPrev <= 4'b0;
            end
        else
            begin
                grantPrev <= grant;
            end
    end
assign grantRE = (!grantPrev[0] & grant[0]) || (!grantPrev[1] & grant[1])
                 || (!grantPrev[2] & grant[2]) || (!grantPrev[3] & grant[3]);

////////////////////////////////////////////////////////////////////////////////
// Grant register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                grantReg <= 4'b0;
            end
        else if (grantRE)
            begin
                grantReg <= grant;
            end
        else if ((RVALID_M0 & RREADY_M0) || (RVALID_M1 & RREADY_M1))
            begin
                grantReg <= 4'b0;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// RVALID output register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                RVALID_M0 <= 1'b0;
                RVALID_M1 <= 1'b0;
            end
        else
            begin
                if (RVALID_M0 & RREADY_M0)
                    begin
                        RVALID_M0 <= 1'b0;
                    end
                else if (grantRE & !RIDInt[ID_WIDTH])
                    begin
                        RVALID_M0 <= 1'b1;
                    end
                if (RVALID_M1 & RREADY_M1)
                    begin
                        RVALID_M1 <= 1'b0;
                    end
                else if (grantRE & RIDInt[ID_WIDTH])
                    begin
                        RVALID_M1 <= 1'b1;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// RREADY input mux
////////////////////////////////////////////////////////////////////////////////
always @ (*)
    begin
        case (RIDOut[ID_WIDTH])
            1'b0:
                begin
                    RREADYInt = RREADY_M0;
                end
            1'b1:
                begin
                    RREADYInt = RREADY_M1;
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// RREADY output register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                RREADY_S0 = 1'b0;
                RREADY_S1 = 1'b0;
                RREADY_S2 = 1'b0;
                RREADY_S3 = 1'b0;
            end
        else
            begin
                if ((RVALID_M0 & RREADY_M0) || (RVALID_M1 & RREADY_M1))
                    begin
                        case (grantReg)
                            4'b0001:
                                begin
                                    RREADY_S0 = 1'b1;
                                    RREADY_S1 = 1'b0;
                                    RREADY_S2 = 1'b0;
                                    RREADY_S3 = 1'b0;
                                end
                            4'b0010:
                                begin
                                    RREADY_S0 = 1'b0;
                                    RREADY_S1 = 1'b1;
                                    RREADY_S2 = 1'b0;
                                    RREADY_S3 = 1'b0;
                                end
                            4'b0100:
                                begin
                                    RREADY_S0 = 1'b0;
                                    RREADY_S1 = 1'b0;
                                    RREADY_S2 = 1'b1;
                                    RREADY_S3 = 1'b0;
                                end
                            4'b1000:
                                begin
                                    RREADY_S0 = 1'b0;
                                    RREADY_S1 = 1'b0;
                                    RREADY_S2 = 1'b0;
                                    RREADY_S3 = 1'b1;
                                end
                            default:
                                begin
                                end
                        endcase
                    end
                else
                    begin
                        RREADY_S0 = 1'b0;
                        RREADY_S1 = 1'b0;
                        RREADY_S2 = 1'b0;
                        RREADY_S3 = 1'b0;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// RVALID input mux
////////////////////////////////////////////////////////////////////////////////
always @ (*)
    begin
        // Default assignments
        RVALIDInt = 1'b0;
        RLASTInt  = 1'b0;
        RDATAInt  = {DWIDTH{1'b0}};
        RIDInt    = {(ID_WIDTH+1){1'b0}};
        RRESPInt  = 2'b0;
        case (grant)
            4'b0001:
                begin
                    RVALIDInt = RVALID_S0;
                    RLASTInt  = RLAST_S0;
                    RDATAInt  = RDATA_S0;
                    RIDInt    = RID_S0;
                    RRESPInt  = RRESP_S0;
                end
            4'b0010:
                begin
                    RVALIDInt = RVALID_S1;
                    RLASTInt  = RLAST_S1;
                    RDATAInt  = RDATA_S1;
                    RIDInt    = RID_S1;
                    RRESPInt  = RRESP_S1;
                end
            4'b0100:
                begin
                    RVALIDInt = RVALID_S2;
                    RLASTInt  = RLAST_S2;
                    RDATAInt  = RDATA_S2;
                    RIDInt    = RID_S2;
                    RRESPInt  = RRESP_S2;
                end
            4'b1000:
                begin
                    RVALIDInt = RVALID_S3;
                    RLASTInt  = RLAST_S3;
                    RDATAInt  = RDATA_S3;
                    RIDInt    = RID_S3;
                    RRESPInt  = RRESP_S3;
                end
            default:
                begin
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// Read data register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                RLASTOut <= 1'b0;
                RDATAOut <= {DWIDTH{1'b0}};
                RIDOut   <= {(ID_WIDTH+1){1'b0}};
                RRESPOut <= 2'b0;
            end
        else
            begin
                if (grantRE)
                    begin
                        RLASTOut <= RLASTInt;
                        RDATAOut <= RDATAInt;
                        RIDOut   <= RIDInt[ID_WIDTH:0];
                        RRESPOut <= RRESPInt;
                    end
                else if ((RVALID_M0 & RREADY_M0) || (RVALID_M1 & RREADY_M1))
                    begin
                        RLASTOut <= 1'b0;
                        RDATAOut <= {DWIDTH{1'b0}};
                        RIDOut   <= {(ID_WIDTH+1){1'b0}};
                        RRESPOut <= 2'b0;
                    end
            end
    end

// Read data channel shared bus
assign RLAST_M0 = RLASTOut;
assign RLAST_M1 = RLASTOut;
assign RDATA_M0 = RDATAOut;
assign RDATA_M1 = RDATAOut;
assign RID_M0   = RIDOut[ID_WIDTH-1:0];
assign RID_M1   = RIDOut[ID_WIDTH-1:0];
assign RRESP_M0 = RRESPOut;
assign RRESP_M1 = RRESPOut;

////////////////////////////////////////////////////////////////////////////////
// Round robin arbiter
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                currState <= S0_PRI_IDLE;
            end
        else
            begin
                currState <= nextState;
            end
    end

always @ (*)
    begin
        case (currState)
            S0_PRI_IDLE:
                begin
                    if (RVALID_S0 & !RREADY_S0)
                        begin
                            grant     = 4'b0001;
                            nextState = S0_WAIT_READY;
                        end
                    else if (RVALID_S1 & !RREADY_S1)
                        begin
                            grant     = 4'b0010;
                            nextState = S1_WAIT_READY;
                        end
                    else if (RVALID_S2 & !RREADY_S2)
                        begin
                            grant     = 4'b0100;
                            nextState = S2_WAIT_READY;
                        end
                    else if (RVALID_S3 & !RREADY_S3)
                        begin
                            grant     = 4'b1000;
                            nextState = S3_WAIT_READY;
                        end
                    else
                        begin
                            grant     = 4'b0000;
                            nextState = S0_PRI_IDLE;
                        end
                end
            S1_PRI_IDLE:
                begin
                    if (RVALID_S1 & !RREADY_S1)
                        begin
                            grant     = 4'b0010;
                            nextState = S1_WAIT_READY;
                        end
                    else if (RVALID_S2 & !RREADY_S2)
                        begin
                            grant     = 4'b0100;
                            nextState = S2_WAIT_READY;
                        end
                    else if (RVALID_S3 & !RREADY_S3)
                        begin
                            grant     = 4'b1000;
                            nextState = S3_WAIT_READY;
                        end
                    else if (RVALID_S0 & !RREADY_S0)
                        begin
                            grant     = 4'b0001;
                            nextState = S0_WAIT_READY;
                        end
                    else
                        begin
                            grant     = 4'b0000;
                            nextState = S1_PRI_IDLE;
                        end
                end
            S2_PRI_IDLE:
                begin
                    if (RVALID_S2 & !RREADY_S2)
                        begin
                            grant     = 4'b0100;
                            nextState = S2_WAIT_READY;
                        end
                    else if (RVALID_S3 & !RREADY_S3)
                        begin
                            grant     = 4'b1000;
                            nextState = S3_WAIT_READY;
                        end
                    else if (RVALID_S0 & !RREADY_S0)
                        begin
                            grant     = 4'b0001;
                            nextState = S0_WAIT_READY;
                        end
                    else if (RVALID_S1 & !RREADY_S1)
                        begin
                            grant     = 4'b0010;
                            nextState = S1_WAIT_READY;
                        end
                    else
                        begin
                            grant     = 4'b0000;
                            nextState = S2_PRI_IDLE;
                        end
                end
            S3_PRI_IDLE:
                begin
                    if (RVALID_S3 & !RREADY_S3)
                        begin
                            grant     = 4'b1000;
                            nextState = S3_WAIT_READY;
                        end
                    else if (RVALID_S0 & !RREADY_S0)
                        begin
                            grant     = 4'b0001;
                            nextState = S0_WAIT_READY;
                        end
                    else if (RVALID_S1 & !RREADY_S1)
                        begin
                            grant     = 4'b0010;
                            nextState = S1_WAIT_READY;
                        end
                    else if (RVALID_S2 & !RREADY_S2)
                        begin
                            grant     = 4'b0100;
                            nextState = S2_WAIT_READY;
                        end
                    else
                        begin
                            grant     = 4'b0000;
                            nextState = S3_PRI_IDLE;
                        end
                end
            S0_WAIT_READY:
                begin
                    grant = 4'b0000;
                    if (RREADYInt)
                        begin
                            nextState = S1_PRI_IDLE;
                        end
                    else
                        begin
                            nextState = S0_WAIT_READY;
                        end
                end
            S1_WAIT_READY:
                begin
                    grant = 4'b0000;
                    if (RREADYInt)
                        begin
                            nextState = S2_PRI_IDLE;
                        end
                    else
                        begin
                            nextState = S1_WAIT_READY;
                        end
                end
            S2_WAIT_READY:
                begin
                    grant = 4'b0000;
                    if (RREADYInt)
                        begin
                            nextState = S3_PRI_IDLE;
                        end
                    else
                        begin
                            nextState = S2_WAIT_READY;
                        end
                end
            S3_WAIT_READY:
                begin
                    grant = 4'b0000;
                    if (RREADYInt)
                        begin
                            nextState = S0_PRI_IDLE;
                        end
                    else
                        begin
                            nextState = S3_WAIT_READY;
                        end
                end
            default:
                begin
                    grant     = 4'b0000;
                    nextState = S0_PRI_IDLE;
                end
        endcase
    end

endmodule // interconnect_readDataChannel