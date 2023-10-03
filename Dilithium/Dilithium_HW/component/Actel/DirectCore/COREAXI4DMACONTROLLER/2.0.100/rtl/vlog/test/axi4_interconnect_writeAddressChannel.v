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
// SVN $Revision: 28871 $
// SVN $Date: 2017-02-13 03:32:54 +0000 (Mon, 13 Feb 2017) $
//
// Resolved SARs
// SAR      Date     Who   Description
//
// Notes:
//
// ****************************************************************************/
module interconnect_writeAddressChannel(
    // General inputs
    clock,
    resetn,

    // Master 0 inputs
    AWVALID_M0,
    AWADDR_M0,
    AWID_M0,
    AWLEN_M0,
    AWSIZE_M0,
    AWBURST_M0,
    
    // Master 1 inputs
    AWVALID_M1,
    AWADDR_M1,
    AWID_M1,
    AWLEN_M1,
    AWSIZE_M1,
    AWBURST_M1,
    
    // Slave 0 inputs
    AWREADY_S0,    
    
    // Slave 1 inputs
    AWREADY_S1,
    
    // Slave 2 inputs
    AWREADY_S2,
    
    // Slave 3 inputs
    AWREADY_S3,
    
    // Write data channel inputs
    wrDataChanGrant,
    
    // Master 0 outputs
    AWREADY_M0,
    
    // Master 1 outputs
    AWREADY_M1,
    
    // Slave 0 outputs
    AWVALID_S0,
    AWADDR_S0,
    AWID_S0,
    AWLEN_S0,
    AWSIZE_S0,
    AWBURST_S0,
    
    // Slave 1 outputs
    AWVALID_S1,
    AWADDR_S1,
    AWID_S1,
    AWLEN_S1,
    AWSIZE_S1,
    AWBURST_S1,
    
    // Slave 2 outputs
    AWVALID_S2,
    AWADDR_S2,
    AWID_S2,
    AWLEN_S2,
    AWSIZE_S2,
    AWBURST_S2,
    
    // Slave 3 outputs
    AWVALID_S3,
    AWADDR_S3,
    AWID_S3,
    AWLEN_S3,
    AWSIZE_S3,
    AWBURST_S3,
    
    // Write data channel outputs
    wrDataChanAddr
);

////////////////////////////////////////////////////////////////////////////////
// Parameters
////////////////////////////////////////////////////////////////////////////////
parameter ID_WIDTH = 0;
parameter AWIDTH   = 0;

////////////////////////////////////////////////////////////////////////////////
// Port directions
////////////////////////////////////////////////////////////////////////////////
// General inputs
input                       clock;
input                       resetn;

// Master 0 inputs
input                       AWVALID_M0;
input   [AWIDTH-1:0]        AWADDR_M0;
input   [ID_WIDTH-1:0]      AWID_M0;
input   [7:0]               AWLEN_M0;
input   [2:0]               AWSIZE_M0;
input   [1:0]               AWBURST_M0;

// Master 1 inputs
input                       AWVALID_M1;
input   [AWIDTH-1:0]        AWADDR_M1;
input   [ID_WIDTH-1:0]      AWID_M1;
input   [7:0]               AWLEN_M1;
input   [2:0]               AWSIZE_M1;
input   [1:0]               AWBURST_M1;

// Slave 0 inputs
input                       AWREADY_S0;    

// Slave 1 inputs
input                       AWREADY_S1;

// Slave 2 inputs
input                       AWREADY_S2;

// Slave 3 inputs
input                       AWREADY_S3;

// Write data channel inputs
input   [1:0]               wrDataChanGrant;

// Master 0 outputs
output reg                  AWREADY_M0;

// Master 1 outputs
output reg                  AWREADY_M1;

// Slave 0 outputs
output reg                  AWVALID_S0;
output      [AWIDTH-1:0]    AWADDR_S0;
output      [ID_WIDTH:0]    AWID_S0;
output      [7:0]           AWLEN_S0;
output      [2:0]           AWSIZE_S0;
output      [1:0]           AWBURST_S0;

// Slave 1 outputs
output reg                  AWVALID_S1;
output      [AWIDTH-1:0]    AWADDR_S1;
output      [ID_WIDTH:0]    AWID_S1;
output      [7:0]           AWLEN_S1;
output      [2:0]           AWSIZE_S1;
output      [1:0]           AWBURST_S1;

// Slave 2 outputs
output reg                  AWVALID_S2;
output      [AWIDTH-1:0]    AWADDR_S2;
output      [ID_WIDTH:0]    AWID_S2;
output      [7:0]           AWLEN_S2;
output      [2:0]           AWSIZE_S2;
output      [1:0]           AWBURST_S2;

// Slave 3 outputs
output reg                  AWVALID_S3;
output      [AWIDTH-1:0]    AWADDR_S3;
output      [ID_WIDTH:0]    AWID_S3;
output      [7:0]           AWLEN_S3;
output      [2:0]           AWSIZE_S3;
output      [1:0]           AWBURST_S3;

// Write data channel outputs
output      [AWIDTH-1:0]    wrDataChanAddr;

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
reg     [1:0]               grant;
reg     [1:0]               grantPrev;
wire                        grantRE;
wire                        AWREADYInt;
reg     [AWIDTH-1:0]        wrAddrHoldReg_M0;
reg     [AWIDTH-1:0]        wrAddrHoldReg_M1;
reg                         AWVALIDInt;
reg     [AWIDTH-1:0]        AWADDRInt;
reg     [2:0]               AWSIZEInt;
reg     [ID_WIDTH:0]        AWIDInt;
reg     [7:0]               AWLENInt;
reg     [1:0]               AWBURSTInt;
reg     [AWIDTH-1:0]        AWADDROut;
reg     [2:0]               AWSIZEOut;
reg     [ID_WIDTH:0]        AWIDOut;
reg     [7:0]               AWLENOut;
reg     [1:0]               AWBURSTOut;
reg     [3:0]               currState;
reg     [3:0]               nextState;
reg     [1:0]               grantReg;

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
        else if ((AWVALID_S0 & AWREADY_S0) || (AWVALID_S1 & AWREADY_S1) ||
                 (AWVALID_S2 & AWREADY_S2) || (AWVALID_S3 & AWREADY_S3) )
            begin
                grantReg <= 2'b0;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// AWREADY output register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                AWREADY_M0 = 1'b0;
                AWREADY_M1 = 1'b0;
            end
        else
            begin
                if ((AWVALID_S0 & AWREADY_S0) || (AWVALID_S1 & AWREADY_S1) ||
                    (AWVALID_S2 & AWREADY_S2) || (AWVALID_S3 & AWREADY_S3) )
                    begin
                        case (grantReg)
                            2'b01:
                                begin
                                    AWREADY_M0 = 1'b1;
                                    AWREADY_M1 = 1'b0;
                                end
                            2'b10:
                                begin
                                    AWREADY_M0 = 1'b0;
                                    AWREADY_M1 = 1'b1;
                                end
                            default:
                                begin
                                end
                        endcase
                    end
                else
                    begin
                        AWREADY_M0 = 1'b0;
                        AWREADY_M1 = 1'b0;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// AWVALID input mux
////////////////////////////////////////////////////////////////////////////////
always @ (*)
    begin
        // Default assignments
        AWVALIDInt = 1'b0;
        AWADDRInt  = {AWIDTH{1'b0}};
        AWSIZEInt  = 3'b0;
        AWIDInt    = {(ID_WIDTH+1){1'b0}};
        AWLENInt   = 8'b0;
        AWBURSTInt = 2'b0;
        case (grant)
            2'b01:
                begin
                    AWVALIDInt = AWVALID_M0;
                    AWADDRInt  = AWADDR_M0;
                    AWSIZEInt  = AWSIZE_M0;
                    AWIDInt    = {1'b0, AWID_M0};
                    AWLENInt   = AWLEN_M0;
                    AWBURSTInt = AWBURST_M0;
                end
            2'b10:
                begin
                    AWVALIDInt = AWVALID_M1;
                    AWADDRInt  = AWADDR_M1;
                    AWSIZEInt  = AWSIZE_M1;
                    AWIDInt    = {1'b1, AWID_M1};
                    AWLENInt   = AWLEN_M1;
                    AWBURSTInt = AWBURST_M1;
                end
            default:
                begin
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// Write address register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                AWADDROut  <= {AWIDTH{1'b0}};
                AWSIZEOut  <= 3'b0;
                AWIDOut    <= {(ID_WIDTH+1){1'b0}};
                AWLENOut   <= 8'b0;
                AWBURSTOut <= 2'b0;
            end
        else
            begin
                if (grantRE)
                    begin
                        AWADDROut  <= AWADDRInt;
                        AWSIZEOut  <= AWSIZEInt;
                        AWIDOut    <= AWIDInt;
                        AWLENOut   <= AWLENInt;
                        AWBURSTOut <= AWBURSTInt;
                    end
                else if ((AWVALID_S0 & AWREADY_S0) || (AWVALID_S1 & AWREADY_S1) ||
                         (AWVALID_S2 & AWREADY_S2) || (AWVALID_S3 & AWREADY_S3) )
                    begin
                        AWADDROut  <= {AWIDTH{1'b0}};
                        AWSIZEOut  <= 3'b0;
                        AWIDOut    <= {(ID_WIDTH+1){1'b0}};
                        AWLENOut   <= 8'b0;
                        AWBURSTOut <= 2'b0;
                    end
            end
    end

// Write address channel shared bus
assign AWADDR_S0  = AWADDROut;
assign AWADDR_S1  = AWADDROut;
assign AWADDR_S2  = AWADDROut;
assign AWADDR_S3  = AWADDROut;
assign AWSIZE_S0  = AWSIZEOut;
assign AWSIZE_S1  = AWSIZEOut;
assign AWSIZE_S2  = AWSIZEOut;
assign AWSIZE_S3  = AWSIZEOut;
assign AWID_S0    = AWIDOut;
assign AWID_S1    = AWIDOut;
assign AWID_S2    = AWIDOut;
assign AWID_S3    = AWIDOut;
assign AWLEN_S0   = AWLENOut;
assign AWLEN_S1   = AWLENOut;
assign AWLEN_S2   = AWLENOut;
assign AWLEN_S3   = AWLENOut;
assign AWBURST_S0 = AWBURSTOut;
assign AWBURST_S1 = AWBURSTOut;
assign AWBURST_S2 = AWBURSTOut;
assign AWBURST_S3 = AWBURSTOut;

////////////////////////////////////////////////////////////////////////////////
// Write address hold register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                wrAddrHoldReg_M0 <= {AWIDTH{1'b0}};
                wrAddrHoldReg_M1 <= {AWIDTH{1'b0}};
            end
        else
            begin
                if (grantRE)
                    begin
                        case (grant)
                            2'b01:
                                begin
                                    wrAddrHoldReg_M0 <= AWADDRInt;
                                    wrAddrHoldReg_M1 <= wrAddrHoldReg_M1;
                                end
                            2'b10:
                                begin
                                    wrAddrHoldReg_M0 <= wrAddrHoldReg_M0;
                                    wrAddrHoldReg_M1 <= AWADDRInt;
                                end
                            default:
                                begin
                                end
                        endcase
                    end
            end
    end

assign wrDataChanAddr = (wrDataChanGrant[0]) ? wrAddrHoldReg_M0 :
                        (wrDataChanGrant[1]) ? wrAddrHoldReg_M1 :
                        {AWIDTH{1'b0}};

////////////////////////////////////////////////////////////////////////////////
// AWVALID output register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                AWVALID_S0 <= 1'b0;
                AWVALID_S1 <= 1'b0;
                AWVALID_S2 <= 1'b0;
                AWVALID_S3 <= 1'b0;
            end
        else
            begin
                // Apportion the address space equally between the 4 slaves
                if (AWVALID_S0 & AWREADY_S0)
                    begin
                        AWVALID_S0 <= 1'b0;
                    end
                else if ((grantRE) & (AWADDRInt[AWIDTH-1:AWIDTH-2] == 2'b00))
                    begin
                        AWVALID_S0 <= 1'b1;
                    end
                if (AWVALID_S1 & AWREADY_S1)
                    begin
                        AWVALID_S1 <= 1'b0;
                    end
                else if ((grantRE) & (AWADDRInt[AWIDTH-1:AWIDTH-2] == 2'b01))
                    begin
                        AWVALID_S1 <= 1'b1;
                    end
                if (AWVALID_S2 & AWREADY_S2)
                    begin
                        AWVALID_S2 <= 1'b0;
                    end
                else if ((grantRE) & (AWADDRInt[AWIDTH-1:AWIDTH-2] == 2'b10))
                    begin
                        AWVALID_S2 <= 1'b1;
                    end
                if (AWVALID_S3 & AWREADY_S3)
                    begin
                        AWVALID_S3 <= 1'b0;
                    end
                else if ((grantRE) & (AWADDRInt[AWIDTH-1:AWIDTH-2] == 2'b11))
                    begin
                        AWVALID_S3 <= 1'b1;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// AWREADY input mux
////////////////////////////////////////////////////////////////////////////////
assign AWREADYInt = (AWADDROut[AWIDTH-1:AWIDTH-2] == 2'b01) ? AWREADY_S1 :
                    (AWADDROut[AWIDTH-1:AWIDTH-2] == 2'b10) ? AWREADY_S2 :
                    (AWADDROut[AWIDTH-1:AWIDTH-2] == 2'b11) ? AWREADY_S3 :
                    AWREADY_S0;

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
                    if (AWVALID_M0 & !AWREADY_M0)
                        begin
                            grant     = 2'b01;
                            nextState = M0_WAIT_READY;
                        end
                    else if (AWVALID_M1 & !AWREADY_M1)
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
                    if (AWVALID_M1 & !AWREADY_M1)
                        begin
                            grant     = 2'b10;
                            nextState = M1_WAIT_READY;
                        end
                    else if (AWVALID_M0 & !AWREADY_M0)
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
                    if (AWREADYInt)
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
                    if (AWREADYInt)
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

endmodule // interconnect_writeAddressChannel
