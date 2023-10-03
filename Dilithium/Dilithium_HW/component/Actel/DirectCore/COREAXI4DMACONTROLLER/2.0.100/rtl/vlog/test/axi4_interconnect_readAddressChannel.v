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
module interconnect_readAddressChannel(
    // General inputs
    clock,
    resetn,

    // Master 0 inputs
    ARVALID_M0,
    ARADDR_M0,
    ARID_M0,
    ARLEN_M0,
    ARSIZE_M0,
    ARBURST_M0,
    
    // Master 1 inputs
    ARVALID_M1,
    ARADDR_M1,
    ARID_M1,
    ARLEN_M1,
    ARSIZE_M1,
    ARBURST_M1,
    
    // Slave 0 inputs
    ARREADY_S0,    
    
    // Slave 1 inputs
    ARREADY_S1,
    
    // Slave 2 inputs
    ARREADY_S2,
    
    // Slave 3 inputs
    ARREADY_S3,
    
    // Master 0 outputs
    ARREADY_M0,
    
    // Master 1 outputs
    ARREADY_M1,
    
    // Slave 0 outputs
    ARVALID_S0,
    ARADDR_S0,
    ARID_S0,
    ARLEN_S0,
    ARSIZE_S0,
    ARBURST_S0,
    
    // Slave 1 outputs
    ARVALID_S1,
    ARADDR_S1,
    ARID_S1,
    ARLEN_S1,
    ARSIZE_S1,
    ARBURST_S1,
    
    // Slave 2 outputs
    ARVALID_S2,
    ARADDR_S2,
    ARID_S2,
    ARLEN_S2,
    ARSIZE_S2,
    ARBURST_S2,
    
    // Slave 3 outputs
    ARVALID_S3,
    ARADDR_S3,
    ARID_S3,
    ARLEN_S3,
    ARSIZE_S3,
    ARBURST_S3
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
input                       ARVALID_M0;
input   [AWIDTH-1:0]        ARADDR_M0;
input   [ID_WIDTH-1:0]      ARID_M0;
input   [7:0]               ARLEN_M0;
input   [2:0]               ARSIZE_M0;
input   [1:0]               ARBURST_M0;

// Master 1 inputs
input                       ARVALID_M1;
input   [AWIDTH-1:0]        ARADDR_M1;
input   [ID_WIDTH-1:0]      ARID_M1;
input   [7:0]               ARLEN_M1;
input   [2:0]               ARSIZE_M1;
input   [1:0]               ARBURST_M1;

// Slave 0 inputs
input                       ARREADY_S0;    

// Slave 1 inputs
input                       ARREADY_S1;

// Slave 2 inputs
input                       ARREADY_S2;

// Slave 3 inputs
input                       ARREADY_S3;

// Master 0 outputs
output reg                  ARREADY_M0;

// Master 1 outputs
output reg                  ARREADY_M1;

// Slave 0 outputs
output reg                  ARVALID_S0;
output      [AWIDTH-1:0]    ARADDR_S0;
output      [ID_WIDTH:0]    ARID_S0;
output      [7:0]           ARLEN_S0;
output      [2:0]           ARSIZE_S0;
output      [1:0]           ARBURST_S0;

// Slave 1 outputs
output reg                  ARVALID_S1;
output      [AWIDTH-1:0]    ARADDR_S1;
output      [ID_WIDTH:0]    ARID_S1;
output      [7:0]           ARLEN_S1;
output      [2:0]           ARSIZE_S1;
output      [1:0]           ARBURST_S1;

// Slave 2 outputs
output reg                  ARVALID_S2;
output      [AWIDTH-1:0]    ARADDR_S2;
output      [ID_WIDTH:0]    ARID_S2;
output      [7:0]           ARLEN_S2;
output      [2:0]           ARSIZE_S2;
output      [1:0]           ARBURST_S2;

// Slave 3 outputs
output reg                  ARVALID_S3;
output      [AWIDTH-1:0]    ARADDR_S3;
output      [ID_WIDTH:0]    ARID_S3;
output      [7:0]           ARLEN_S3;
output      [2:0]           ARSIZE_S3;
output      [1:0]           ARBURST_S3;

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
wire                        ARREADYInt;
reg                         ARVALIDInt;
reg     [AWIDTH-1:0]        ARADDRInt;
reg     [2:0]               ARSIZEInt;
reg     [ID_WIDTH:0]        ARIDInt;
reg     [7:0]               ARLENInt;
reg     [1:0]               ARBURSTInt;
reg     [AWIDTH-1:0]        ARADDROut;
reg     [2:0]               ARSIZEOut;
reg     [ID_WIDTH:0]        ARIDOut;
reg     [7:0]               ARLENOut;
reg     [1:0]               ARBURSTOut;
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
        else if ((ARVALID_S0 & ARREADY_S0) || (ARVALID_S1 & ARREADY_S1) ||
                 (ARVALID_S2 & ARREADY_S2) || (ARVALID_S3 & ARREADY_S3) )
            begin
                grantReg <= 2'b0;
            end
    end

////////////////////////////////////////////////////////////////////////////////
// ARREADY output register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                ARREADY_M0 = 1'b0;
                ARREADY_M1 = 1'b0;
            end
        else
            begin
                if ((ARVALID_S0 & ARREADY_S0) || (ARVALID_S1 & ARREADY_S1) ||
                    (ARVALID_S2 & ARREADY_S2) || (ARVALID_S3 & ARREADY_S3) )
                    begin
                        case (grantReg)
                            2'b01:
                                begin
                                    ARREADY_M0 = 1'b1;
                                    ARREADY_M1 = 1'b0;
                                end
                            2'b10:
                                begin
                                    ARREADY_M0 = 1'b0;
                                    ARREADY_M1 = 1'b1;
                                end
                            default:
                                begin
                                end
                        endcase
                    end
                else
                    begin
                        ARREADY_M0 = 1'b0;
                        ARREADY_M1 = 1'b0;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// ARVALID input mux
////////////////////////////////////////////////////////////////////////////////
always @ (*)
    begin
        // Default assignments
        ARVALIDInt = 1'b0;
        ARADDRInt  = {AWIDTH{1'b0}};
        ARSIZEInt  = 3'b0;
        ARIDInt    = {(ID_WIDTH+1){1'b0}};
        ARLENInt   = 8'b0;
        ARBURSTInt = 2'b0;
        case (grant)
            2'b01:
                begin
                    ARVALIDInt = ARVALID_M0;
                    ARADDRInt  = ARADDR_M0;
                    ARSIZEInt  = ARSIZE_M0;
                    ARIDInt    = {1'b0, ARID_M0};
                    ARLENInt   = ARLEN_M0;
                    ARBURSTInt = ARBURST_M0;
                end
            2'b10:
                begin
                    ARVALIDInt = ARVALID_M1;
                    ARADDRInt  = ARADDR_M1;
                    ARSIZEInt  = ARSIZE_M1;
                    ARIDInt    = {1'b1, ARID_M1};
                    ARLENInt   = ARLEN_M1;
                    ARBURSTInt = ARBURST_M1;
                end
            default:
                begin
                end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// Read address register
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                ARADDROut  <= {AWIDTH{1'b0}};
                ARSIZEOut  <= 3'b0;
                ARIDOut    <= {(ID_WIDTH+1){1'b0}};
                ARLENOut   <= 8'b0;
                ARBURSTOut <= 2'b0;
            end
        else
            begin
                if (grantRE)
                    begin
                        ARADDROut  <= ARADDRInt;
                        ARSIZEOut  <= ARSIZEInt;
                        ARIDOut    <= ARIDInt;
                        ARLENOut   <= ARLENInt;
                        ARBURSTOut <= ARBURSTInt;
                    end
                else if ((ARVALID_S0 & ARREADY_S0) || (ARVALID_S1 & ARREADY_S1) ||
                         (ARVALID_S2 & ARREADY_S2) || (ARVALID_S3 & ARREADY_S3) )
                    begin
                        ARADDROut  <= {AWIDTH{1'b0}};
                        ARSIZEOut  <= 3'b0;
                        ARIDOut    <= {(ID_WIDTH+1){1'b0}};
                        ARLENOut   <= 8'b0;
                        ARBURSTOut <= 2'b0;
                    end
            end
    end

// Write address channel shared bus
assign ARADDR_S0  = ARADDROut;
assign ARADDR_S1  = ARADDROut;
assign ARADDR_S2  = ARADDROut;
assign ARADDR_S3  = ARADDROut;
assign ARSIZE_S0  = ARSIZEOut;
assign ARSIZE_S1  = ARSIZEOut;
assign ARSIZE_S2  = ARSIZEOut;
assign ARSIZE_S3  = ARSIZEOut;
assign ARID_S0    = ARIDOut;
assign ARID_S1    = ARIDOut;
assign ARID_S2    = ARIDOut;
assign ARID_S3    = ARIDOut;
assign ARLEN_S0   = ARLENOut;
assign ARLEN_S1   = ARLENOut;
assign ARLEN_S2   = ARLENOut;
assign ARLEN_S3   = ARLENOut;
assign ARBURST_S0 = ARBURSTOut;
assign ARBURST_S1 = ARBURSTOut;
assign ARBURST_S2 = ARBURSTOut;
assign ARBURST_S3 = ARBURSTOut;

////////////////////////////////////////////////////////////////////////////////
// ARVALID output mux
////////////////////////////////////////////////////////////////////////////////
always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
            begin
                ARVALID_S0 <= 1'b0;
                ARVALID_S1 <= 1'b0;
                ARVALID_S2 <= 1'b0;
                ARVALID_S3 <= 1'b0;
            end
        else
            begin
                // Apportion the address space equally between the 4 slaves
                if (ARVALID_S0 & ARREADY_S0)
                    begin
                        ARVALID_S0 <= 1'b0;
                    end
                else if ((grantRE) & (ARADDRInt[AWIDTH-1:AWIDTH-2] == 2'b00))
                    begin
                        ARVALID_S0 <= 1'b1;
                    end
                if (ARVALID_S1 & ARREADY_S1)
                    begin
                        ARVALID_S1 <= 1'b0;
                    end
                else if ((grantRE) & (ARADDRInt[AWIDTH-1:AWIDTH-2] == 2'b01))
                    begin
                        ARVALID_S1 <= 1'b1;
                    end
                if (ARVALID_S2 & ARREADY_S2)
                    begin
                        ARVALID_S2 <= 1'b0;
                    end
                else if ((grantRE) & (ARADDRInt[AWIDTH-1:AWIDTH-2] == 2'b10))
                    begin
                        ARVALID_S2 <= 1'b1;
                    end
                if (ARVALID_S3 & ARREADY_S3)
                    begin
                        ARVALID_S3 <= 1'b0;
                    end
                else if ((grantRE) & (ARADDRInt[AWIDTH-1:AWIDTH-2] == 2'b11))
                    begin
                        ARVALID_S3 <= 1'b1;
                    end
            end
    end

////////////////////////////////////////////////////////////////////////////////
// ARREADY input mux
////////////////////////////////////////////////////////////////////////////////
assign ARREADYInt = (ARADDROut[AWIDTH-1:AWIDTH-2] == 2'b01) ? ARREADY_S1 :
                    (ARADDROut[AWIDTH-1:AWIDTH-2] == 2'b10) ? ARREADY_S2 :
                    (ARADDROut[AWIDTH-1:AWIDTH-2] == 2'b11) ? ARREADY_S3 :
                    ARREADY_S0;

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
                    if (ARVALID_M0 & !ARREADY_M0)
                        begin
                            grant     = 2'b01;
                            nextState = M0_WAIT_READY;
                        end
                    else if (ARVALID_M1 & !ARREADY_M1)
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
                    if (ARVALID_M1 & !ARREADY_M1)
                        begin
                            grant     = 2'b10;
                            nextState = M1_WAIT_READY;
                        end
                    else if (ARVALID_M0 & !ARREADY_M0)
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
                    if (ARREADYInt)
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
                    if (ARREADYInt)
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

endmodule // interconnect_readAddressChannel
