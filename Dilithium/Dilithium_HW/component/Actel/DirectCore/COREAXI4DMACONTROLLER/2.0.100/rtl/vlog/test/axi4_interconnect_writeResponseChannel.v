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
module interconnect_writeResponseChannel(
    // General inputs
    clock,
    resetn,
    
    // Master 0 inputs
    BREADY_M0,
    
    // Master 1 inputs
    BREADY_M1,
    
    // Slave 0 inputs
    BVALID_S0,
    BID_S0,
    BRESP_S0,

    // Slave 1 inputs
    BVALID_S1,
    BID_S1,
    BRESP_S1,
    
    // Slave 2 inputs
    BVALID_S2,
    BID_S2,
    BRESP_S2,
    
    // Slave 3 inputs
    BVALID_S3,
    BID_S3,
    BRESP_S3,
    
    // Master 0 outputs
    BVALID_M0,
    BID_M0,
    BRESP_M0,
    
    // Master 1 outputs
    BVALID_M1,
    BID_M1,
    BRESP_M1,
    
    // Slave 0 outputs
    BREADY_S0,
    
    // Slave 1 outputs
    BREADY_S1,
    
    // Slave 2 outputs
    BREADY_S2,

    // Slave 3 outputs
    BREADY_S3
);

////////////////////////////////////////////////////////////////////////////////
// Parameters
////////////////////////////////////////////////////////////////////////////////
parameter ID_WIDTH = 0;

////////////////////////////////////////////////////////////////////////////////
// Port directions
////////////////////////////////////////////////////////////////////////////////
// General inputs
input                       clock;
input                       resetn;

// Master 0 inputs
input                       BREADY_M0;

// Master 1 inputs
input                       BREADY_M1;

// Slave 0 inputs
input                       BVALID_S0;
input       [ID_WIDTH:0]    BID_S0;
input       [1:0]           BRESP_S0;

// Slave 1 inputs
input                       BVALID_S1;
input       [ID_WIDTH:0]    BID_S1;
input       [1:0]           BRESP_S1;

// Slave 2 inputs
input                       BVALID_S2;
input       [ID_WIDTH:0]    BID_S2;
input       [1:0]           BRESP_S2;

// Slave 3 inputs
input                       BVALID_S3;
input       [ID_WIDTH:0]    BID_S3;
input       [1:0]           BRESP_S3;

// Master 0 outputs
output reg                  BVALID_M0;
output      [ID_WIDTH-1:0]  BID_M0;
output      [1:0]           BRESP_M0;

// Master 1 outputs
output reg                  BVALID_M1;
output      [ID_WIDTH-1:0]  BID_M1;
output      [1:0]           BRESP_M1;

// Slave 0 outputs
output reg                  BREADY_S0;

// Slave 1 outputs
output reg                  BREADY_S1;

// Slave 2 outputs
output reg                  BREADY_S2;

// Slave 3 outputs
output reg                  BREADY_S3;

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
reg                         BREADYInt;
reg                         BVALIDInt;
reg     [ID_WIDTH:0]        BIDInt;
reg     [1:0]               BRESPInt;
reg     [ID_WIDTH:0]        BIDOut;
reg     [1:0]               BRESPOut;
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
        else if ((BVALID_M0 & BREADY_M0) || (BVALID_M1 & BREADY_M1))
            begin
                grantReg <= 4'b0;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// BVALID output mux
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                BVALID_M0 <= 1'b0;
                BVALID_M1 <= 1'b0;
            end
        else
            begin
                if (BVALID_M0 & BREADY_M0)
                    begin
                        BVALID_M0 <= 1'b0;
                    end
                else if (grantRE & !BIDInt[ID_WIDTH])
                    begin
                        BVALID_M0 <= 1'b1;
                    end
                if (BVALID_M1 & BREADY_M1)
                    begin
                        BVALID_M1 <= 1'b0;
                    end
                else if (grantRE & BIDInt[ID_WIDTH])
                    begin
                        BVALID_M1 <= 1'b1;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// BREADY input mux
////////////////////////////////////////////////////////////////////////////////
always @ (*)
    begin
        case (BIDOut[ID_WIDTH])
            1'b0:
                begin
                    BREADYInt = BREADY_M0;
                end
            1'b1:
                begin
                    BREADYInt = BREADY_M1;
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// BREADY output register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                BREADY_S0 = 1'b0;
                BREADY_S1 = 1'b0;
                BREADY_S2 = 1'b0;
                BREADY_S3 = 1'b0;
            end
        else
            begin
                if ((BVALID_M0 & BREADY_M0) || (BVALID_M1 & BREADY_M1))
                    begin
                        case (grantReg)
                            4'b0001:
                                begin
                                    BREADY_S0 = 1'b1;
                                    BREADY_S1 = 1'b0;
                                    BREADY_S2 = 1'b0;
                                    BREADY_S3 = 1'b0;
                                end
                            4'b0010:
                                begin
                                    BREADY_S0 = 1'b0;
                                    BREADY_S1 = 1'b1;
                                    BREADY_S2 = 1'b0;
                                    BREADY_S3 = 1'b0;
                                end
                            4'b0100:
                                begin
                                    BREADY_S0 = 1'b0;
                                    BREADY_S1 = 1'b0;
                                    BREADY_S2 = 1'b1;
                                    BREADY_S3 = 1'b0;
                                end
                            4'b1000:
                                begin
                                    BREADY_S0 = 1'b0;
                                    BREADY_S1 = 1'b0;
                                    BREADY_S2 = 1'b0;
                                    BREADY_S3 = 1'b1;
                                end
                            default:
                                begin
                                end
                        endcase
                    end
                else
                    begin
                        BREADY_S0 = 1'b0;
                        BREADY_S1 = 1'b0;
                        BREADY_S2 = 1'b0;
                        BREADY_S3 = 1'b0;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// BVALID input mux
////////////////////////////////////////////////////////////////////////////////
always @ (*)
    begin
        // Default assignments
        BVALIDInt = 1'b0;
        BIDInt    = {(ID_WIDTH+1){1'b0}};
        BRESPInt  = 2'b0;
        case (grant)
            4'b0001:
                begin
                    BVALIDInt = BVALID_S0;
                    BIDInt    = BID_S0;
                    BRESPInt  = BRESP_S0;
                end
            4'b0010:
                begin
                    BVALIDInt = BVALID_S1;
                    BIDInt    = BID_S1;
                    BRESPInt  = BRESP_S1;
                end
            4'b0100:
                begin
                    BVALIDInt = BVALID_S2;
                    BIDInt    = BID_S2;
                    BRESPInt  = BRESP_S2;
                end
            4'b1000:
                begin
                    BVALIDInt = BVALID_S3;
                    BIDInt    = BID_S3;
                    BRESPInt  = BRESP_S3;
                end
            default:
                begin
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// Write response register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                BIDOut   <= {(ID_WIDTH+1){1'b0}};
                BRESPOut <= 2'b0;
            end
        else
            begin
                if (grantRE)
                    begin
                        BIDOut   <= BIDInt[ID_WIDTH:0];
                        BRESPOut <= BRESPInt;
                    end
                else
                    begin
                        BIDOut   <= {(ID_WIDTH+1){1'b0}};
                        BRESPOut <= 2'b0;
                    end
            end
    end

// Write response channel shared bus
assign BID_M0   = BIDOut;
assign BID_M1   = BIDOut;
assign BRESP_M0 = BRESPOut;
assign BRESP_M1 = BRESPOut;

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
                    if (BVALID_S0 & !BREADY_S0)
                        begin
                            grant     = 4'b0001;
                            nextState = S0_WAIT_READY;
                        end
                    else if (BVALID_S1 & !BREADY_S1)
                        begin
                            grant     = 4'b0010;
                            nextState = S1_WAIT_READY;
                        end
                    else if (BVALID_S2 & !BREADY_S2)
                        begin
                            grant     = 4'b0100;
                            nextState = S2_WAIT_READY;
                        end
                    else if (BVALID_S3 & !BREADY_S3)
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
                    if (BVALID_S1 & !BREADY_S1)
                        begin
                            grant     = 4'b0010;
                            nextState = S1_WAIT_READY;
                        end
                    else if (BVALID_S2 & !BREADY_S2)
                        begin
                            grant     = 4'b0100;
                            nextState = S2_WAIT_READY;
                        end
                    else if (BVALID_S3 & !BREADY_S3)
                        begin
                            grant     = 4'b1000;
                            nextState = S3_WAIT_READY;
                        end
                    else if (BVALID_S0 & !BREADY_S0)
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
                    if (BVALID_S2 & !BREADY_S2)
                        begin
                            grant     = 4'b0100;
                            nextState = S2_WAIT_READY;
                        end
                    else if (BVALID_S3 & !BREADY_S3)
                        begin
                            grant     = 4'b1000;
                            nextState = S3_WAIT_READY;
                        end
                    else if (BVALID_S0 & !BREADY_S0)
                        begin
                            grant     = 4'b0001;
                            nextState = S0_WAIT_READY;
                        end
                    else if (BVALID_S1 & !BREADY_S1)
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
                    if (BVALID_S3 & !BREADY_S3)
                        begin
                            grant     = 4'b1000;
                            nextState = S3_WAIT_READY;
                        end
                    else if (BVALID_S0 & !BREADY_S0)
                        begin
                            grant     = 4'b0001;
                            nextState = S0_WAIT_READY;
                        end
                    else if (BVALID_S1 & !BREADY_S1)
                        begin
                            grant     = 4'b0010;
                            nextState = S1_WAIT_READY;
                        end
                    else if (BVALID_S2 & !BREADY_S2)
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
                    grant = 4'b0001;
                    if (BREADYInt)
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
                    grant = 4'b0010;
                    if (BREADYInt)
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
                    grant = 4'b0100;
                    if (BREADYInt)
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
                    grant = 4'b1000;
                    if (BREADYInt)
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

endmodule // interconnect_writeResponseChannel