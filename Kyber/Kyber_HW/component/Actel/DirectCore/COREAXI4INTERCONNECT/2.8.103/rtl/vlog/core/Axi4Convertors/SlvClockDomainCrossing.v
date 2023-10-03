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
//     Abstract  : This file provides salve clock domain crossing
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 
module caxi4interconnect_SlvClockDomainCrossing #

	(
		parameter integer ADDR_WIDTH      		= 20,
		parameter integer ID_WIDTH 			    = 1, 
		parameter integer SLAVE_DATA_WIDTH		= 32,
		parameter integer USER_WIDTH 			= 1,
	    parameter CLOCK_DOMAIN_CROSSING         = 1'b0,
		parameter SLAVE_TYPE                    = 0,
		parameter READ_INTERLEAVE               = 0
	)
	(

	//=====================================  Global Signals   ========================================================================
	input  wire           			SLV_CLK,
	input  wire                     XBAR_CLK,
	input  wire          			sysReset,
	input  wire          			ACLK_syncReset,
 
	//=====================================  Connections to/from Crossbar   ==========================================================
 
	output wire [ID_WIDTH-1:0] 		slaveARID,
	output wire [ADDR_WIDTH-1:0]	slaveARADDR,
	output wire [7:0]        		slaveARLEN,
	output wire [2:0]          		slaveARSIZE,
	output wire [1:0]          		slaveARBURST,
	output wire [1:0]          		slaveARLOCK,
	output wire [3:0]           	slaveARCACHE,
	output wire [2:0]         		slaveARPROT,
	output wire [3:0]          		slaveARREGION,
	output wire [3:0]          		slaveARQOS,
	output wire [USER_WIDTH-1:0]	slaveARUSER,
	output wire            			slaveARVALID,
	input wire             			slaveARREADY,

	// Master Read Data Ports	
	input wire [ID_WIDTH-1:0]   	slaveRID,
	input wire [SLAVE_DATA_WIDTH-1:0]		slaveRDATA,
	input wire [1:0]           		slaveRRESP,
	input wire                		slaveRLAST,
	input wire [USER_WIDTH-1:0] 	slaveRUSER,
	input wire                 		slaveRVALID,
	output wire               		slaveRREADY,

	// Master Write Address Ports	
	output wire [ID_WIDTH-1:0]  	slaveAWID,
	output wire [ADDR_WIDTH-1:0] 	slaveAWADDR,
	output wire [7:0]           	slaveAWLEN,
	output wire [2:0]           	slaveAWSIZE,
	output wire [1:0]           	slaveAWBURST,
	output wire [1:0]           	slaveAWLOCK,
	output wire [3:0]          		slaveAWCACHE,
	output wire [2:0]           	slaveAWPROT,
	output wire [3:0]            	slaveAWREGION,
	output wire [3:0]           	slaveAWQOS,
	output wire [USER_WIDTH-1:0]   	slaveAWUSER,
	output wire                 	slaveAWVALID,
	input wire                		slaveAWREADY,
	
	// Master Write Data Ports	
	output wire [ID_WIDTH-1:0]  		    slaveWID,
	output wire [SLAVE_DATA_WIDTH-1:0]      slaveWDATA,
	output wire [(SLAVE_DATA_WIDTH/8)-1:0]	slaveWSTRB,
	output wire                  		slaveWLAST,
	output wire [USER_WIDTH-1:0] 		slaveWUSER,
	output wire                  		slaveWVALID,
	input wire                   		slaveWREADY,
			
	// Master Write Response Ports	
	input  wire [ID_WIDTH-1:0]		slaveBID,
	input  wire [1:0]           	slaveBRESP,
	input  wire [USER_WIDTH-1:0] 	slaveBUSER,
	input  wire      				slaveBVALID,
	output wire						slaveBREADY,

	//================================================= External Side Ports  ================================================//

	// Master Read Address Ports	
	input  wire [ID_WIDTH-1:0]  	SLAVE_ARID,
	input  wire [ADDR_WIDTH-1:0]	SLAVE_ARADDR,
	input  wire [7:0]           	SLAVE_ARLEN,
	input  wire [2:0]        		SLAVE_ARSIZE,
	input  wire [1:0]           	SLAVE_ARBURST,
	input  wire [1:0]         		SLAVE_ARLOCK,
	input  wire [3:0]          		SLAVE_ARCACHE,
	input  wire [2:0]         		SLAVE_ARPROT,
	input  wire [3:0]          		SLAVE_ARREGION,
	input  wire [3:0]          		SLAVE_ARQOS,
	input  wire [USER_WIDTH-1:0]	SLAVE_ARUSER,
	input  wire                		SLAVE_ARVALID,
	output wire                		SLAVE_ARREADY,
	
	// Master Read Data Ports	
	output wire [ID_WIDTH-1:0]  	SLAVE_RID,
	output wire [SLAVE_DATA_WIDTH-1:0]  	SLAVE_RDATA,
	output wire [1:0]           	SLAVE_RRESP,
	output wire                  	SLAVE_RLAST,
	output wire [USER_WIDTH-1:0] 	SLAVE_RUSER,
	output wire               		SLAVE_RVALID,
	input wire                 		SLAVE_RREADY,
	
	// Master Write Address Ports	
	input  wire [ID_WIDTH-1:0]   	SLAVE_AWID,
	input  wire [ADDR_WIDTH-1:0] 	SLAVE_AWADDR,
	input  wire [7:0]           	SLAVE_AWLEN,
	input  wire [2:0]           	SLAVE_AWSIZE,
	input  wire [1:0]           	SLAVE_AWBURST,
	input  wire [1:0]            	SLAVE_AWLOCK,
	input  wire [3:0]          		SLAVE_AWCACHE,
	input  wire [2:0]           	SLAVE_AWPROT,
	input  wire [3:0]           	SLAVE_AWREGION,
	input  wire [3:0]           	SLAVE_AWQOS,
	input  wire [USER_WIDTH-1:0] 	SLAVE_AWUSER,
	input  wire                  	SLAVE_AWVALID,
	output wire                		SLAVE_AWREADY,
	
	// Master Write Data Ports	
	input wire [ID_WIDTH-1:0]   	      SLAVE_WID,
	input wire [SLAVE_DATA_WIDTH-1:0]     SLAVE_WDATA,
	input wire [(SLAVE_DATA_WIDTH/8)-1:0] SLAVE_WSTRB,
	input wire                   	SLAVE_WLAST,
	input wire [USER_WIDTH-1:0] 	SLAVE_WUSER,
	input wire                  	SLAVE_WVALID,
	output wire                  	SLAVE_WREADY,
	
	// Master Write Response Ports	
	output wire [ID_WIDTH-1:0]		SLAVE_BID,
	output wire [1:0]           	SLAVE_BRESP,
	output wire [USER_WIDTH-1:0]  	SLAVE_BUSER,
	output wire      				SLAVE_BVALID,
	input wire						SLAVE_BREADY
	) ;

    localparam ADDR_CHAN_WIDTH = ID_WIDTH + ADDR_WIDTH + 8 + 3 + 2 + 2 + 4 + 3 + 4 + 4 + USER_WIDTH;
	localparam WCHAN_WIDTH = (SLAVE_TYPE == 2'b11) ? SLAVE_DATA_WIDTH + SLAVE_DATA_WIDTH/8 + 1 + USER_WIDTH + ID_WIDTH: 
	                                                 SLAVE_DATA_WIDTH + SLAVE_DATA_WIDTH/8 + 1 + USER_WIDTH;
	localparam BCHAN_WIDTH = ID_WIDTH + 2 + USER_WIDTH;
	localparam RCHAN_WIDTH = ID_WIDTH + SLAVE_DATA_WIDTH + 2 + 1 + USER_WIDTH;
	
	localparam MEM_DEPTH  = 8;  //SAR 91000

         generate
         if (CLOCK_DOMAIN_CROSSING) begin
             caxi4interconnect_CDC_FIFO #
	       (
                 .MEM_DEPTH (MEM_DEPTH),
                 .DATA_WIDTH  ( ADDR_CHAN_WIDTH ),
				 .MASTER_BCHAN (0)
               )
	       cdc_AWChan
               (
    	         .rst (ACLK_syncReset),
    	         .rdclk_rst (sysReset),
                 .clk_rd (SLV_CLK),
                 .clk_wr (XBAR_CLK),

                 .infoInValid (SLAVE_AWVALID),
                 .readyForOut (slaveAWREADY),

                 .infoIn ({SLAVE_AWID, SLAVE_AWADDR, SLAVE_AWLEN, SLAVE_AWSIZE, SLAVE_AWBURST, SLAVE_AWLOCK, SLAVE_AWCACHE,  SLAVE_AWPROT, SLAVE_AWQOS, SLAVE_AWREGION, SLAVE_AWUSER}),

                 .infoOut ({slaveAWID, slaveAWADDR, slaveAWLEN, slaveAWSIZE, slaveAWBURST, slaveAWLOCK, slaveAWCACHE,  slaveAWPROT, slaveAWQOS, slaveAWREGION, slaveAWUSER}),
                 .readyForInfo (SLAVE_AWREADY),
                 .infoOutValid (slaveAWVALID)
		);

		if(SLAVE_TYPE == 2'b11)         //AXI3
		  begin 
	       caxi4interconnect_CDC_FIFO #
	       (
             .MEM_DEPTH (MEM_DEPTH),
             .DATA_WIDTH  ( WCHAN_WIDTH ),
			 .MASTER_BCHAN (0)
           )
	       cdc_WChan
           (
    	     .rst (ACLK_syncReset),
    	     .rdclk_rst (sysReset),
             .clk_rd (SLV_CLK),
             .clk_wr (XBAR_CLK),

             .infoInValid (SLAVE_WVALID),
             .readyForOut (slaveWREADY),

             .infoIn ({SLAVE_WID,SLAVE_WDATA, SLAVE_WSTRB, SLAVE_WLAST, SLAVE_WUSER}),

             .infoOut ({slaveWID,slaveWDATA, slaveWSTRB, slaveWLAST, slaveWUSER}),
             .readyForInfo (SLAVE_WREADY),
             .infoOutValid (slaveWVALID)
		    );
		  end 
		else 
		  begin 
		   assign slaveWID = 0;
	       caxi4interconnect_CDC_FIFO #
	       (
             .MEM_DEPTH (MEM_DEPTH),
             .DATA_WIDTH  ( WCHAN_WIDTH ),
			 .MASTER_BCHAN (0)
           )
	       cdc_WChan
           (
    	     .rst (ACLK_syncReset),
    	     .rdclk_rst (sysReset),
             .clk_rd (SLV_CLK),
             .clk_wr (XBAR_CLK),

             .infoInValid (SLAVE_WVALID),
             .readyForOut (slaveWREADY),

             .infoIn ({SLAVE_WDATA, SLAVE_WSTRB, SLAVE_WLAST, SLAVE_WUSER}),

             .infoOut ({slaveWDATA, slaveWSTRB, slaveWLAST, slaveWUSER}),
             .readyForInfo (SLAVE_WREADY),
             .infoOutValid (slaveWVALID)
		    );
		  end 
		  

            caxi4interconnect_CDC_FIFO #
	       (
                 .MEM_DEPTH (MEM_DEPTH),
                 .DATA_WIDTH  ( ADDR_CHAN_WIDTH ),
				 .MASTER_BCHAN (0)
               )
	       cdc_ARChan
               (
    	         .rst (ACLK_syncReset),
    	         .rdclk_rst (sysReset),
                 .clk_rd (SLV_CLK),
                 .clk_wr (XBAR_CLK),

                 .infoInValid (SLAVE_ARVALID),
                 .readyForOut (slaveARREADY),

                 .infoIn ({SLAVE_ARID, SLAVE_ARADDR, SLAVE_ARLEN, SLAVE_ARSIZE, SLAVE_ARBURST, SLAVE_ARLOCK, SLAVE_ARCACHE,  SLAVE_ARPROT, SLAVE_ARQOS, SLAVE_ARREGION, SLAVE_ARUSER}),

                 .infoOut ({slaveARID, slaveARADDR, slaveARLEN, slaveARSIZE, slaveARBURST, slaveARLOCK, slaveARCACHE,  slaveARPROT, slaveARQOS, slaveARREGION, slaveARUSER}),
                 .readyForInfo (SLAVE_ARREADY),
                 .infoOutValid (slaveARVALID)
		);

	       caxi4interconnect_CDC_FIFO #
	       (
                 .MEM_DEPTH (MEM_DEPTH),
                 .DATA_WIDTH  ( RCHAN_WIDTH ),
				 .MASTER_BCHAN (0)
               )
	       cdc_RChan
               (
    	         .rst (sysReset),
    	         .rdclk_rst (ACLK_syncReset),
                 .clk_wr (SLV_CLK),
                 .clk_rd (XBAR_CLK),

                 .infoInValid (slaveRVALID),
                 .readyForOut (SLAVE_RREADY),

                 .infoOut ({SLAVE_RID, SLAVE_RDATA, SLAVE_RRESP, SLAVE_RLAST, SLAVE_RUSER}),

                 .infoIn ({slaveRID, slaveRDATA, slaveRRESP, slaveRLAST, slaveRUSER}),
                 .readyForInfo (slaveRREADY),
                 .infoOutValid (SLAVE_RVALID)
		);

	       caxi4interconnect_CDC_FIFO #
	       (
                 .MEM_DEPTH (MEM_DEPTH),
                 .DATA_WIDTH  ( BCHAN_WIDTH ),
				 .MASTER_BCHAN (0)
               )
	       cdc_BChan
               (
    	         .rst (sysReset),
    	         .rdclk_rst (ACLK_syncReset),
                 .clk_wr (SLV_CLK),
                 .clk_rd (XBAR_CLK),

                 .infoInValid (slaveBVALID),
                 .readyForOut (SLAVE_BREADY),

                 .infoOut ({SLAVE_BID, SLAVE_BRESP, SLAVE_BUSER}),

                 .infoIn ({slaveBID, slaveBRESP, slaveBUSER}),
                 .readyForInfo (slaveBREADY),
                 .infoOutValid (SLAVE_BVALID)
		);
	end
	else begin
		//====================================== ASSIGNEMENTS =================================================
		//from Master to crossbar & Slave
		
		assign slaveAWID =	SLAVE_AWID;
		assign slaveAWADDR = SLAVE_AWADDR;
		assign slaveAWLEN = SLAVE_AWLEN;
		assign slaveAWSIZE = SLAVE_AWSIZE;
		assign slaveAWBURST = SLAVE_AWBURST;	
		assign slaveAWLOCK = SLAVE_AWLOCK;
		assign slaveAWCACHE = SLAVE_AWCACHE;	
		assign slaveAWPROT = SLAVE_AWPROT;
		assign slaveAWREGION = SLAVE_AWREGION;
		assign slaveAWQOS = SLAVE_AWQOS;
		assign slaveAWUSER = SLAVE_AWUSER;
		assign slaveAWVALID = SLAVE_AWVALID;	
		assign slaveWID = SLAVE_WID;
		assign slaveWDATA = SLAVE_WDATA;
		assign slaveWSTRB = SLAVE_WSTRB;
		assign slaveWLAST = SLAVE_WLAST;
		assign slaveWUSER = SLAVE_WUSER;
		assign slaveWVALID = SLAVE_WVALID;
		assign slaveBREADY = SLAVE_BREADY;
		assign slaveARID = SLAVE_ARID;
		assign slaveARADDR = SLAVE_ARADDR;
		assign slaveARLEN = SLAVE_ARLEN;
		assign slaveARSIZE = SLAVE_ARSIZE;
		assign slaveARBURST = SLAVE_ARBURST;	
		assign slaveARLOCK = SLAVE_ARLOCK;
		assign slaveARCACHE = SLAVE_ARCACHE;	
		assign slaveARPROT = SLAVE_ARPROT;
		assign slaveARREGION = SLAVE_ARREGION;
		assign slaveARQOS = SLAVE_ARQOS;
		assign slaveARUSER = SLAVE_ARUSER;
		assign slaveARVALID = SLAVE_ARVALID;	
		assign slaveRREADY = SLAVE_RREADY;
		//			
		//from crossbar to SLAVE
		assign SLAVE_AWREADY = slaveAWREADY;	
		assign SLAVE_WREADY = slaveWREADY;
		assign SLAVE_BID = slaveBID;
		assign SLAVE_BRESP =	slaveBRESP;
		assign SLAVE_BUSER =	slaveBUSER;
		assign SLAVE_BVALID = slaveBVALID;	
		assign SLAVE_ARREADY = slaveARREADY;	
					
		assign SLAVE_RID = slaveRID;
		assign SLAVE_RDATA =	slaveRDATA;
		assign SLAVE_RRESP =	slaveRRESP;
		assign SLAVE_RLAST =	slaveRLAST;
		assign SLAVE_RUSER =	slaveRUSER;
		assign SLAVE_RVALID = slaveRVALID;
	  end		
	endgenerate
endmodule	
