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
//     Abstract  : This file provides master clock domain crossing
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 
module caxi4interconnect_MstrClockDomainCrossing #

	(
		parameter integer ADDR_WIDTH      		= 20,
		parameter integer ID_WIDTH 			    = 16, 
		parameter integer MASTER_DATA_WIDTH		= 32,
		parameter integer USER_WIDTH 			= 1,
		parameter CLOCK_DOMAIN_CROSSING         = 1'b0,
		parameter MASTER_TYPE                   = 0,
		parameter READ_INTERLEAVE               = 0
	)
	(

	//=====================================  Global Signals   ========================================================================
	input  wire           			MST_CLK,
	input  wire                     XBAR_CLK,
	input  wire          			sysReset,
	input  wire          			ACLK_syncReset,
 
	//=====================================  Connections to/from Crossbar   ==========================================================
 
	output wire [ID_WIDTH-1:0] 		int_masterARID,
	output wire [ADDR_WIDTH-1:0]	int_masterARADDR,
	output wire [7:0]        		int_masterARLEN,
	output wire [2:0]          		int_masterARSIZE,
	output wire [1:0]          		int_masterARBURST,
	output wire [1:0]          		int_masterARLOCK,
	output wire [3:0]           	int_masterARCACHE,
	output wire [2:0]         		int_masterARPROT,
	output wire [3:0]          		int_masterARREGION,
	output wire [3:0]          		int_masterARQOS,
	output wire [USER_WIDTH-1:0]	int_masterARUSER,
	output wire            			int_masterARVALID,
	input wire             			int_masterARREADY,

	// Master Read Data Ports	
	input wire [ID_WIDTH-1:0]   	int_masterRID,
	input wire [MASTER_DATA_WIDTH-1:0]		int_masterRDATA,
	input wire [1:0]           		int_masterRRESP,
	input wire                		int_masterRLAST,
	input wire [USER_WIDTH-1:0] 	int_masterRUSER,
	input wire                 		int_masterRVALID,
	output wire               		int_masterRREADY,

	// Master Write Address Ports	
	output wire [ID_WIDTH-1:0]  	int_masterAWID,
	output wire [ADDR_WIDTH-1:0] 	int_masterAWADDR,
	output wire [7:0]           	int_masterAWLEN,
	output wire [2:0]           	int_masterAWSIZE,
	output wire [1:0]           	int_masterAWBURST,
	output wire [1:0]           	int_masterAWLOCK,
	output wire [3:0]          		int_masterAWCACHE,
	output wire [2:0]           	int_masterAWPROT,
	output wire [3:0]            	int_masterAWREGION,
	output wire [3:0]           	int_masterAWQOS,
	output wire [USER_WIDTH-1:0]   	int_masterAWUSER,
	output wire                 	int_masterAWVALID,
	input wire                		int_masterAWREADY,
	
	// Master Write Data Ports	

	output wire [ID_WIDTH-1:0]      int_masterWID,
	output wire [MASTER_DATA_WIDTH-1:0]  		int_masterWDATA,
	output wire [(MASTER_DATA_WIDTH/8)-1:0]	int_masterWSTRB,
	output wire                  		int_masterWLAST,
	output wire [USER_WIDTH-1:0] 		int_masterWUSER,
	output wire                  		int_masterWVALID,
	input wire                   		int_masterWREADY,
			
	// Master Write Response Ports	
	input  wire [ID_WIDTH-1:0]		int_masterBID,
	input  wire [1:0]           	int_masterBRESP,
	input  wire [USER_WIDTH-1:0] 	int_masterBUSER,
	input  wire      				int_masterBVALID,
	output wire						int_masterBREADY,

	//================================================= External Side Ports  ================================================//

	// Master Read Address Ports	
	input  wire [ID_WIDTH-1:0]  	MASTER_ARID,
	input  wire [ADDR_WIDTH-1:0]	MASTER_ARADDR,
	input  wire [7:0]           	MASTER_ARLEN,
	input  wire [2:0]        		MASTER_ARSIZE,
	input  wire [1:0]           	MASTER_ARBURST,
	input  wire [1:0]         		MASTER_ARLOCK,
	input  wire [3:0]          		MASTER_ARCACHE,
	input  wire [2:0]         		MASTER_ARPROT,
	input  wire [3:0]          		MASTER_ARREGION,
	input  wire [3:0]          		MASTER_ARQOS,
	input  wire [USER_WIDTH-1:0]	MASTER_ARUSER,
	input  wire                		MASTER_ARVALID,
	output wire                		MASTER_ARREADY,
	
	// Master Read Data Ports	
	output wire [ID_WIDTH-1:0]  	MASTER_RID,
	output wire [MASTER_DATA_WIDTH-1:0]  	MASTER_RDATA,
	output wire [1:0]           	MASTER_RRESP,
	output wire                  	MASTER_RLAST,
	output wire [USER_WIDTH-1:0] 	MASTER_RUSER,
	output wire               		MASTER_RVALID,
	input wire                 		MASTER_RREADY,
	
	// Master Write Address Ports	
	input  wire [ID_WIDTH-1:0]   	MASTER_AWID,
	input  wire [ADDR_WIDTH-1:0] 	MASTER_AWADDR,
	input  wire [7:0]           	MASTER_AWLEN,
	input  wire [2:0]           	MASTER_AWSIZE,
	input  wire [1:0]           	MASTER_AWBURST,
	input  wire [1:0]            	MASTER_AWLOCK,
	input  wire [3:0]          		MASTER_AWCACHE,
	input  wire [2:0]           	MASTER_AWPROT,
	input  wire [3:0]           	MASTER_AWREGION,
	input  wire [3:0]           	MASTER_AWQOS,
	input  wire [USER_WIDTH-1:0] 	MASTER_AWUSER,
	input  wire                  	MASTER_AWVALID,
	output wire                		MASTER_AWREADY,
	
	// Master Write Data Ports	
	input wire [ID_WIDTH-1:0]       MASTER_WID,
	input wire [MASTER_DATA_WIDTH-1:0]   	MASTER_WDATA,
	input wire [(MASTER_DATA_WIDTH/8)-1:0]	MASTER_WSTRB,
	input wire                   	MASTER_WLAST,
	input wire [USER_WIDTH-1:0] 	MASTER_WUSER,
	input wire                  	MASTER_WVALID,
	output wire                  	MASTER_WREADY,
	
	// Master Write Response Ports	
	output wire [ID_WIDTH-1:0]		MASTER_BID,
	output wire [1:0]           	MASTER_BRESP,
	output wire [USER_WIDTH-1:0]  	MASTER_BUSER,
	output wire      				MASTER_BVALID,
	input wire						MASTER_BREADY
	) ;

    localparam integer ADDR_CHAN_WIDTH = ID_WIDTH + ADDR_WIDTH + 8 + 3 + 2 + 2 + 4 + 3 + 4 + 4 + USER_WIDTH;
	//For AXI3 Master stored WID in the fifo. 
	localparam integer WCHAN_WIDTH = (MASTER_TYPE == 2'b11) ? MASTER_DATA_WIDTH + MASTER_DATA_WIDTH/8 + 1 + USER_WIDTH + ID_WIDTH: 
	                                                          MASTER_DATA_WIDTH + MASTER_DATA_WIDTH/8 + 1 + USER_WIDTH;
	localparam integer BCHAN_WIDTH = ID_WIDTH + 2 + USER_WIDTH;
	localparam integer RCHAN_WIDTH = ID_WIDTH + MASTER_DATA_WIDTH + 2 + 1 + USER_WIDTH;

	localparam integer MEM_DEPTH = 8; //SAR 91000

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
    	         .rst (sysReset),
    	         .rdclk_rst (ACLK_syncReset),
                 .clk_wr (MST_CLK),
                 .clk_rd (XBAR_CLK),

                 .infoInValid (MASTER_AWVALID),
                 .readyForOut (int_masterAWREADY),

                 .infoIn ({MASTER_AWID, MASTER_AWADDR, MASTER_AWLEN, MASTER_AWSIZE, MASTER_AWBURST, MASTER_AWLOCK, MASTER_AWCACHE,  MASTER_AWPROT, MASTER_ARQOS, MASTER_AWREGION, MASTER_AWUSER}),

                 .infoOut ({int_masterAWID, int_masterAWADDR, int_masterAWLEN, int_masterAWSIZE, int_masterAWBURST, int_masterAWLOCK, int_masterAWCACHE,  int_masterAWPROT, int_masterAWQOS, int_masterAWREGION, int_masterAWUSER}),
                 .readyForInfo (MASTER_AWREADY),
                 .infoOutValid (int_masterAWVALID)
		);
           if(MASTER_TYPE == 2'b11)         //AXI3
		     begin 
	           caxi4interconnect_CDC_FIFO #
	           (
                 .MEM_DEPTH (MEM_DEPTH),
                 .DATA_WIDTH  ( WCHAN_WIDTH ),
				 .MASTER_BCHAN (0)
               )
	           cdc_WChan
               (
    	         .rst (sysReset),
    	         .rdclk_rst (ACLK_syncReset),
                 .clk_wr (MST_CLK),
                 .clk_rd (XBAR_CLK),

                 .infoInValid (MASTER_WVALID),
                 .readyForOut (int_masterWREADY),

                 .infoIn ({MASTER_WID,MASTER_WDATA, MASTER_WSTRB, MASTER_WLAST, MASTER_WUSER}),

                 .infoOut ({int_masterWID,int_masterWDATA, int_masterWSTRB, int_masterWLAST, int_masterWUSER}),
                 .readyForInfo (MASTER_WREADY),
                 .infoOutValid (int_masterWVALID)
		       );
			 end 
		   else 
		     begin 
			 
			   assign int_masterWID   = 0;
			   
	           caxi4interconnect_CDC_FIFO #
	           (
                 .MEM_DEPTH (MEM_DEPTH),
                 .DATA_WIDTH  ( WCHAN_WIDTH ),
				 .MASTER_BCHAN (0)
               )
	           cdc_WChan
               (
    	         .rst (sysReset),
    	         .rdclk_rst (ACLK_syncReset),
                 .clk_wr (MST_CLK),
                 .clk_rd (XBAR_CLK),

                 .infoInValid (MASTER_WVALID),
                 .readyForOut (int_masterWREADY),

                 .infoIn ({MASTER_WDATA, MASTER_WSTRB, MASTER_WLAST, MASTER_WUSER}),

                 .infoOut ({int_masterWDATA, int_masterWSTRB, int_masterWLAST, int_masterWUSER}),
                 .readyForInfo (MASTER_WREADY),
                 .infoOutValid (int_masterWVALID)
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
    	         .rst (sysReset),
    	         .rdclk_rst (ACLK_syncReset),
                 .clk_wr (MST_CLK),
                 .clk_rd (XBAR_CLK),

                 .infoInValid (MASTER_ARVALID),
                 .readyForOut (int_masterARREADY),

                 .infoIn ({MASTER_ARID, MASTER_ARADDR, MASTER_ARLEN, MASTER_ARSIZE, MASTER_ARBURST, MASTER_ARLOCK, MASTER_ARCACHE,  MASTER_ARPROT, MASTER_ARQOS, MASTER_ARREGION, MASTER_ARUSER}),

                 .infoOut ({int_masterARID, int_masterARADDR, int_masterARLEN, int_masterARSIZE, int_masterARBURST, int_masterARLOCK, int_masterARCACHE,  int_masterARPROT, int_masterARQOS, int_masterARREGION, int_masterARUSER}),
                 .readyForInfo (MASTER_ARREADY),
                 .infoOutValid (int_masterARVALID)
		);

	       caxi4interconnect_CDC_FIFO #
	       (
                 .MEM_DEPTH (MEM_DEPTH),
                 .DATA_WIDTH  ( RCHAN_WIDTH ),
				 .MASTER_BCHAN (0)
               )
	       cdc_RChan
               (
    	         .rst (ACLK_syncReset),
    	         .rdclk_rst (sysReset),
                 .clk_rd (MST_CLK),
                 .clk_wr (XBAR_CLK),

                 .infoInValid (int_masterRVALID),
                 .readyForOut (MASTER_RREADY),

                 .infoOut ({MASTER_RID, MASTER_RDATA, MASTER_RRESP, MASTER_RLAST, MASTER_RUSER}),

                 .infoIn ({int_masterRID, int_masterRDATA, int_masterRRESP, int_masterRLAST, int_masterRUSER}),
                 .readyForInfo (int_masterRREADY),
                 .infoOutValid (MASTER_RVALID)
		);

	       caxi4interconnect_CDC_FIFO #
	       (
                 .MEM_DEPTH (MEM_DEPTH),
                 .DATA_WIDTH  ( BCHAN_WIDTH ),
				 .MASTER_BCHAN (1)
               )
	       cdc_BChan
               (
    	         .rst (ACLK_syncReset),
    	         .rdclk_rst (sysReset),
                 .clk_rd (MST_CLK),
                 .clk_wr (XBAR_CLK),

                 .infoInValid (int_masterBVALID),
                 .readyForOut (MASTER_BREADY),

                 .infoOut ({MASTER_BID, MASTER_BRESP, MASTER_BUSER}),

                 .infoIn ({int_masterBID, int_masterBRESP, int_masterBUSER}),
                 .readyForInfo (int_masterBREADY),
                 .infoOutValid (MASTER_BVALID)
		);
	end
	else begin
		//====================================== ASSIGNEMENTS =================================================
		//from Master to crossbar & Slave
		  assign int_masterAWID =	MASTER_AWID;
		  assign int_masterAWADDR = MASTER_AWADDR;
		  assign int_masterAWLEN = MASTER_AWLEN;
		  assign int_masterAWSIZE = MASTER_AWSIZE;
		  assign int_masterAWBURST = MASTER_AWBURST;	
		  assign int_masterAWLOCK = MASTER_AWLOCK;
		  assign int_masterAWCACHE = MASTER_AWCACHE;	
		  assign int_masterAWPROT = MASTER_AWPROT;
		  assign int_masterAWREGION = MASTER_AWREGION;
		  assign int_masterAWQOS = MASTER_AWQOS;
		  assign int_masterAWUSER = MASTER_AWUSER;
		  assign int_masterAWVALID = MASTER_AWVALID;	
		  assign int_masterWID   = MASTER_WID;
		  assign int_masterWDATA = MASTER_WDATA;
		  assign int_masterWSTRB = MASTER_WSTRB;
		  assign int_masterWLAST = MASTER_WLAST;
		  assign int_masterWUSER = MASTER_WUSER;
		  assign int_masterWVALID = MASTER_WVALID;
		  assign int_masterBREADY = MASTER_BREADY;
		  assign int_masterARID = MASTER_ARID;
		  assign int_masterARADDR = MASTER_ARADDR;
		  assign int_masterARLEN = MASTER_ARLEN;
		  assign int_masterARSIZE = MASTER_ARSIZE;
		  assign int_masterARBURST = MASTER_ARBURST;	
		  assign int_masterARLOCK = MASTER_ARLOCK;
		  assign int_masterARCACHE = MASTER_ARCACHE;	
		  assign int_masterARPROT = MASTER_ARPROT;
		  assign int_masterARREGION = MASTER_ARREGION;
		  assign int_masterARQOS = MASTER_ARQOS;
		  assign int_masterARUSER = MASTER_ARUSER;
		  assign int_masterARVALID = MASTER_ARVALID;	
		  assign int_masterRREADY = MASTER_RREADY;
		  //			
		  //from crossbar to MASTER
		  assign MASTER_AWREADY = int_masterAWREADY;	
		  assign MASTER_WREADY = int_masterWREADY;
		  assign MASTER_BID = int_masterBID;
		  assign MASTER_BRESP =	int_masterBRESP;
		  assign MASTER_BUSER =	int_masterBUSER;
		  assign MASTER_BVALID = int_masterBVALID;	
		  assign MASTER_ARREADY = int_masterARREADY;	
		  			
		  assign MASTER_RID = int_masterRID;
		  assign MASTER_RDATA =	int_masterRDATA;
		  assign MASTER_RRESP =	int_masterRRESP;
		  assign MASTER_RLAST =	int_masterRLAST;
		  assign MASTER_RUSER =	int_masterRUSER;
		  assign MASTER_RVALID = int_masterRVALID;
	  end
	endgenerate
endmodule	
