`timescale 1ns/1ns
// ****************************************************************************/
// Microsemi Corporation Proprietary and Confidential
// Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: CoreAXI4DMAController AXI4 Master Model
//
// SVN Revision Information:
// SVN $Revision: 28873 $
// SVN $Date: 2017-02-13 13:08:48 +0000 (Mon, 13 Feb 2017) $
//
// Resolved SARs
// SAR      Date     Who   Description
//
// Notes:
//
// ****************************************************************************/
module AXI4_Master (
    // General inputs
    ACLK,
    ARESETN,
    
    // Write address channel inputs
    AWREADY,
    
    // Write data channel inputs
    WREADY,
    
    // Write response channel inputs
    BVALID,
    BID,
    BRESP,
    
    // Read address channel inputs
    ARREADY,
    
    // Read data channel inputs
    RID,
    RDATA,
    RRESP,
    RLAST,
    RVALID,

    // Interrupt inputs
    interrupt, 
    
    // Write address channel outputs
    AWID,
    AWADDR,
    AWLEN,
    AWSIZE,
    AWBURST,
    AWVALID,
    
    // Write data channel outputs
    WDATA,
    WSTRB,
    WLAST,
    WVALID,
    
    // Write response channel outputs
    BREADY,
    
    // Read address channel outputs
    ARID,
    ARADDR,
    ARLEN,
    ARSIZE,
    ARBURST,
    ARVALID,
    
    // Read data channel outputs
    RREADY
);
////////////////////////////////////////////////////////////////////////////////
// Parameters
////////////////////////////////////////////////////////////////////////////////
parameter DMA_0_BASE_ADDR = 0;
parameter ID_WIDTH        = 4; // Sets the width of the ID field supported.
parameter DWIDTH          = 64;
parameter MEM_FILE        = "ram_init.mem";
parameter WRITE_RAM_DEPTH = 16;
parameter NUM_OF_INTS     = 1;
parameter AXI4_STREAM_IF  = 0;

////////////////////////////////////////////////////////////////////////////////
// Port directions
////////////////////////////////////////////////////////////////////////////////
input                           AWREADY;
input                           WREADY;
input   [ID_WIDTH-1:0]          BID;
input   [1:0]                   BRESP;
input                           BVALID;
input                           ARREADY;
input   [ID_WIDTH-1:0]          RID;
input   [DWIDTH-1:0]            RDATA;
input   [1:0]                   RRESP;
input                           RLAST;
input                           RVALID;

input      [NUM_OF_INTS-1:0]    interrupt;

// Outputs on AXI Interface
input                           ACLK;
input                           ARESETN;
output  [ID_WIDTH-1:0]          AWID;
output  [31:0]                  AWADDR;
output  [7:0]                   AWLEN;
output  [2:0]                   AWSIZE;
output  [1:0]                   AWBURST;
output                          AWVALID;
output  [DWIDTH-1:0]            WDATA;
output  [(DWIDTH/8)-1:0]        WSTRB;
output                          WLAST;
output                          WVALID;
output                          BREADY;
output  [ID_WIDTH-1:0]          ARID;
output  [31:0]                  ARADDR;
output  [7:0]                   ARLEN;
output  [2:0]                   ARSIZE;
output  [1:0]                   ARBURST;
output                          ARVALID;
output                          RREADY;

reg     [ID_WIDTH-1:0]          AWID;
reg     [31:0]                  AWADDR;
reg     [7:0]                   AWLEN;
reg     [2:0]                   AWSIZE;
reg     [1:0]                   AWBURST;
reg                             AWVALID;
reg     [(DWIDTH/8)-1:0]        WSTRB;
reg                             WLAST;
reg                             WVALID;
reg                             BREADY;
reg     [ID_WIDTH-1:0]          ARID;
reg     [31:0]                  ARADDR;
reg     [7:0]                   ARLEN;
reg     [2:0]                   ARSIZE;
reg     [1:0]                   ARBURST;
reg                             ARVALID;
reg                             RREADY;
reg     [DWIDTH-1:0]            WDATA;

reg     [7:0]                   len_idx;
integer                         lp_cnt;
reg     [7:0]                   data_ram[0:WRITE_RAM_DEPTH-1];
reg     [31:0]                  g_waddr;
reg                             g_inLineWData;
reg     [DWIDTH-1:0]            g_wdata;
reg     [DWIDTH-1:0]            rdWord;

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
localparam WRITE_RAM_ADDR_WIDTH = clog2(WRITE_RAM_DEPTH-1);

////////////////////////////////////////////////////////////////////////////////
// WRDATA RAM Initalization
////////////////////////////////////////////////////////////////////////////////
initial
    begin
        $readmemb( MEM_FILE, data_ram);
    end

////////////////////////////////////////////////////////////////////////////////
// WRDATA assignment based on WSTRB
////////////////////////////////////////////////////////////////////////////////
generate
genvar byte_lane;
    for (byte_lane = 0; byte_lane < 8; byte_lane=byte_lane+1)
        begin
            always @ (WSTRB)
                begin
                    if (WSTRB[byte_lane])
                        begin
                            if (g_inLineWData)
                                begin
                                    WDATA[(((1+byte_lane)*8)-1):(byte_lane*8)] = g_wdata[(((1+byte_lane)*8)-1):(byte_lane*8)];
                                end
                            else
                                begin
                                    WDATA[(((1+byte_lane)*8)-1):(byte_lane*8)] = data_ram[g_waddr + byte_lane];
                                end
                        end
                    else
                        begin
                            WDATA[(((1+byte_lane)*8)-1):(byte_lane*8)] = 8'b0;
                        end
                end
        end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// Initial value declarations                                               
////////////////////////////////////////////////////////////////////////////////
initial begin
    AWID    = {ID_WIDTH{1'b0}};
    AWADDR  = {32{1'b0}};
    AWLEN   = 8'b0;
    AWSIZE  = 3'b0;
    AWBURST = 2'b0;
    AWVALID = 1'b0;
    WDATA   = {DWIDTH{1'b0}};
    WSTRB   = {(DWIDTH/8){1'b0}};
    WLAST   = 1'b0;
    WVALID  = 1'b0;
    BREADY  = 1'b0;
    RREADY  = 1'b0;
    ARID    = {ID_WIDTH{1'b0}};
    ARADDR  = {32{1'b0}};
    ARLEN   = {8{1'b0}};
    ARSIZE  = {3{1'b0}};
    ARBURST = {2{1'b0}};
    ARVALID = 1'b0;
end

////////////////////////////////////////////////////////////////////////////////
// Write Address Channel task
////////////////////////////////////////////////////////////////////////////////
task axi_write_addr_channel;
    input [ID_WIDTH-1:0]     AWID_in;
    input [31:0]             AWADDR_in;
    input [7:0]              AWLEN_in;
    input [2:0]              AWSIZE_in;
    input [1:0]              AWBURST_in;
    begin
        @(posedge ACLK);
        AWID    = AWID_in;
        AWADDR  = AWADDR_in;
        AWLEN   = AWLEN_in;
        AWSIZE  = AWSIZE_in;
        AWBURST = AWBURST_in;
        AWVALID = 1'b1;
        wait (AWREADY);
        @(posedge ACLK);
        AWVALID = 1'b0;
        AWADDR = 32'b0;
        AWLEN = 8'b0;
        AWSIZE = 3'b0;
        AWBURST = 2'b0;
        AWVALID = 1'b0;
    end
endtask // axi_write_addr_channel 


////////////////////////////////////////////////////////////////////////////////
// Write Data Channel task
////////////////////////////////////////////////////////////////////////////////
task axi_write_data_channel;
    input [31:0]             AWADDR_in;
    input [7:0]              AWLEN_in;
    input [2:0]              AWSIZE_in;
    input [1:0]              AWBURST_in;
    input [(DWIDTH/8)-1:0]   WSTRB_in_first; 
    input [(DWIDTH/8)-1:0]   WSTRB_in_last;
    input                    WDATA_inLine_in;
    input [DWIDTH-1:0]       WDATA_in;
    integer                  i;
    begin
        g_waddr = {AWADDR_in[WRITE_RAM_ADDR_WIDTH+2:3], {3{1'b0}}}; // 64-bit align the write address
        if (WDATA_inLine_in)
            begin
                g_inLineWData = 1'b1;
                g_wdata       = WDATA_in;
            end
        else
            begin
                g_inLineWData = 1'b0;
                g_wdata       = {DWIDTH{1'b0}};
            end
        // send number of data transfer in one burst 
        for (i=0; i<=AWLEN_in; i=i+1)
        begin
            if (i==0) // First beat, unaligned transfer
                begin
                    WSTRB = WSTRB_in_first;
                end
            else if (i==AWLEN_in) // Last beat - narrow transfer
                begin
                    WSTRB = WSTRB_in_last;
                end
            else
                begin
                    WSTRB = {(DWIDTH/8){1'b1}};
                end
            WVALID  = 1'b1;
            WLAST   = (i==AWLEN_in) ? 1'b1 : 1'b0; 
            wait (WREADY);
            @(posedge ACLK);
        end
        g_inLineWData = 1'b0;
        g_wdata       = {DWIDTH{1'b0}};
        WLAST         = 1'b0;
        WSTRB         = {(DWIDTH/8){1'b0}};
        WVALID        = 1'b0;
    end
endtask // axi_write_data_channel

////////////////////////////////////////////////////////////////////////////////
// Write Response Channel task
////////////////////////////////////////////////////////////////////////////////
task axi_write_response_channel;
    begin
        @(posedge ACLK);
        BREADY = 1'b1;
        wait (BVALID);
        @(posedge ACLK);
        BREADY = 1'b0;
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// AXI Write task
////////////////////////////////////////////////////////////////////////////////
task axi_write;
    input [31:0]             AWADDR_in;
    input [DWIDTH-1:0]       WDATA_in;
    input [(DWIDTH/8)-1:0]   WSTRB_in_first; 
    begin
        axi_write_addr_channel({ID_WIDTH{1'b0}}, AWADDR_in, 8'b0, 3'd2, 2'b01);
        axi_write_data_channel(AWADDR_in, 8'b0, 3'd2, 2'b01, WSTRB_in_first, {DWIDTH/8{1'b0}}, 1'b1, WDATA_in);
        axi_write_response_channel();
    end
endtask // axi_write

////////////////////////////////////////////////////////////////////////////////
// AXI Write task
////////////////////////////////////////////////////////////////////////////////
task axi_write_multi_beat;
    input [ID_WIDTH-1:0]     AWID_in;
    input [31:0]             AWADDR_in;
    input [7:0]              AWLEN_in;
    input [2:0]              AWSIZE_in;
    input [1:0]              AWBURST_in;
    input [(DWIDTH/8)-1:0]   WSTRB_in_first; 
    input [(DWIDTH/8)-1:0]   WSTRB_in_last; 
    begin
        axi_write_addr_channel(AWID_in,AWADDR_in,AWLEN_in,AWSIZE_in,AWBURST_in);
        axi_write_data_channel(AWADDR_in,AWLEN_in,AWSIZE_in,AWBURST_in,WSTRB_in_first, WSTRB_in_last, 1'b0, {DWIDTH{1'b0}});
        axi_write_response_channel();
    end
endtask // axi_write_multi_beat

////////////////////////////////////////////////////////////////////////////////
// AXI Read Address Channel task
////////////////////////////////////////////////////////////////////////////////
task axi_read_addr_channel;
    input [ID_WIDTH-1:0]     ARID_in;
    input [31:0]             ARADDR_in;
    input [7:0]              ARLEN_in;
    input [2:0]              ARSIZE_in;
    input [1:0]              ARBURST_in;
    begin
        @(posedge ACLK);
        ARID    = ARID_in;
        ARADDR  = ARADDR_in;
        ARLEN   = ARLEN_in;
        ARSIZE  = ARSIZE_in;
        ARBURST = ARBURST_in;
        ARVALID = 1'b1;
        wait (ARREADY);
        @(posedge ACLK);
        ARVALID = 1'b0;
        ARID    = {ID_WIDTH{1'b0}};
        ARADDR  = 32'b0;
        ARLEN   = 8'b0;
        ARSIZE  = 3'b0;
        ARBURST = 2'b0;
    end
endtask // axi_read_addr_channel

////////////////////////////////////////////////////////////////////////////////
// AXI Read Data Channel task
////////////////////////////////////////////////////////////////////////////////
task axi_read_data_channel;
    input [ID_WIDTH-1:0]     ARID_in;
    input [31:0]             ARADDR_in;
    input [7:0]              ARLEN_in;
    input [2:0]              ARSIZE_in;
    input [1:0]              ARBURST_in;
    
    integer                  i;
    begin
        RREADY = 1'b0;    
        for (i=0;i<=ARLEN_in;i=i+1)
        begin
            wait (RVALID); // Wait on slave to assert RVALID
            RREADY = 1'b1;
            @ (posedge ACLK);
            RREADY = 1'b0;
            // Return the read data
            rdWord = RDATA;
            #1;
        end
    end
endtask // axi_read_data_channel 

////////////////////////////////////////////////////////////////////////////////
// AXI Read task
////////////////////////////////////////////////////////////////////////////////
task axi_read;
    input [31:0]             ARADDR_in;
    begin
        axi_read_addr_channel({ID_WIDTH{1'b0}}, ARADDR_in, 8'b0, 3'd2, 2'b01);
        axi_read_data_channel({ID_WIDTH{1'b0}}, ARADDR_in, 8'b0, 3'd2, 2'b01);
    end
endtask // axi_read

////////////////////////////////////////////////////////////////////////////////
// AXI Read task
////////////////////////////////////////////////////////////////////////////////
task axi_read_multi_beat;
    input [ID_WIDTH-1:0]     ARID_in;
    input [31:0]             ARADDR_in;
    input [7:0]              ARLEN_in;
    input [2:0]              ARSIZE_in;
    input [1:0]              ARBURST_in;
    begin
        axi_read_addr_channel(ARID_in,ARADDR_in,ARLEN_in,ARSIZE_in,ARBURST_in);
        axi_read_data_channel(ARID_in,ARADDR_in,ARLEN_in,ARSIZE_in,ARBURST_in);
    end
endtask // axi_read_multi_beat

`include "./coreaxi4dmacontroller_firmware_driver_model.v"
////////////////////////////////////////////////////////////////////////////////
// 
////////////////////////////////////////////////////////////////////////////////
initial
    begin
        @(posedge ARESETN);
        #20;
        `include "./coreaxi4dmacontroller_application.v"
        #10;
        $stop;
    end

endmodule // AXI4_Master