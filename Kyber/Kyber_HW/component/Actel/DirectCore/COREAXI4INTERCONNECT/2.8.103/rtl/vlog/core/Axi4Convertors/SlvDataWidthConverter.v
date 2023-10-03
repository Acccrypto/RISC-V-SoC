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
//     Abstract  : This file provides data bus width conversion on Slave side.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 
`timescale 1ns / 1ns

module caxi4interconnect_SlvDataWidthConverter #

	(
		parameter integer 	NUM_SLAVES			= 4,			// defines number of slave ports
		parameter integer	SLAVE_DATA_WIDTH 	= 32,			// slave valid data widths - 32, 64, 128, 256
		parameter integer 	SLAVE_NUMBER		= 0,			//current slave
		parameter integer 	ADDR_WIDTH      	= 20,			// valid values - 16 - 64
		parameter integer 	DATA_WIDTH 			= 32,			// valid widths - 32, 64, 128, 256
		parameter OPEN_TRANS_MAX				= 2,				// max number of outstanding transactions per thread - valid range 1-8
		
		parameter [1:0] 	SLAVE_TYPE			= 2'b00,		// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b10
		
		parameter integer 	USER_WIDTH 			= 1,			// defines the number of bits for USER signals RUSER and WUSER
	
		parameter integer 	ID_WIDTH   			= 3,			// number of bits for ID (ie AID, WID, BID) - valid 1-8 
		
	    parameter [NUM_SLAVES-1:0]		SLAVE_AWCHAN_RS	= { NUM_SLAVES{1'b1} },		// 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
	    parameter [NUM_SLAVES-1:0]		SLAVE_ARCHAN_RS	= { NUM_SLAVES{1'b1} },		// 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
	    parameter [NUM_SLAVES-1:0]		SLAVE_WCHAN_RS	= { NUM_SLAVES{1'b1} },		// 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
	    parameter [NUM_SLAVES-1:0]		SLAVE_RCHAN_RS	= { NUM_SLAVES{1'b1} },	// 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
	    parameter [NUM_SLAVES-1:0]		SLAVE_BCHAN_RS	= { NUM_SLAVES{1'b1} },		// 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
	    parameter [13:0] DATA_FIFO_DEPTH = 14'h10,
        parameter integer DWC_ADDR_FIFO_DEPTH_CEILING = 'h10,
	    parameter         READ_INTERLEAVE             = 1,
		parameter         NUM_THREADS                 = 4 
	
	)
	(

	//=====================================  Global Signals   ========================================================================
	input  wire           			ACLK,
	input  wire          			sysReset,
  //XBar side signals
	input wire [ID_WIDTH-1:0] 		int_slaveARID,
	input wire [ADDR_WIDTH-1:0]		int_slaveARADDR,
	input wire [7:0]        		int_slaveARLEN,
	input wire [2:0]          		int_slaveARSIZE,
	input wire [1:0]          		int_slaveARBURST,
	input wire [1:0]          		int_slaveARLOCK,
	input wire [3:0]           		int_slaveARCACHE,
	input wire [2:0]         		int_slaveARPROT,
	input wire [3:0]          		int_slaveARREGION,
	input wire [3:0]          		int_slaveARQOS,
	input wire [USER_WIDTH-1:0]		int_slaveARUSER,
	input wire            			int_slaveARVALID,
	output wire             			int_slaveARREADY,

	// Slave Read Data Ports	
	output wire [ID_WIDTH-1:0]   	int_slaveRID,
	output wire [DATA_WIDTH-1:0]	int_slaveRDATA,
	output wire [1:0]           	int_slaveRRESP,
	output wire                		int_slaveRLAST,
	output wire [USER_WIDTH-1:0] 	int_slaveRUSER,
	output wire                 	int_slaveRVALID,
	input wire               		int_slaveRREADY,

	// Slave Write Address Ports	
	input wire [ID_WIDTH-1:0]  		int_slaveAWID,
	input wire [ADDR_WIDTH-1:0] 	int_slaveAWADDR,
	input wire [7:0]           		int_slaveAWLEN,
	input wire [2:0]           		int_slaveAWSIZE,
	input wire [1:0]           		int_slaveAWBURST,
	input wire [1:0]           		int_slaveAWLOCK,
	input wire [3:0]          		int_slaveAWCACHE,
	input wire [2:0]           		int_slaveAWPROT,
	input wire [3:0]            	int_slaveAWREGION,
	input wire [3:0]           		int_slaveAWQOS,
	input wire [USER_WIDTH-1:0]   	int_slaveAWUSER,
	input wire                 		int_slaveAWVALID,
	output wire                		int_slaveAWREADY,
	
	// Slave Write Data Ports	
	input wire [ID_WIDTH-1:0]  	    int_slaveWID,
	input wire [DATA_WIDTH-1:0]  	int_slaveWDATA,
	input wire [(DATA_WIDTH/8)-1:0]	int_slaveWSTRB,
	input wire                  	int_slaveWLAST,
	input wire [USER_WIDTH-1:0] 	int_slaveWUSER,
	input wire                  	int_slaveWVALID,
	output wire                   	int_slaveWREADY,
			
	// Slave Write Response Ports	
	output  wire [ID_WIDTH-1:0]		int_slaveBID,
	output  wire [1:0]           	int_slaveBRESP,
	output  wire [USER_WIDTH-1:0] 	int_slaveBUSER,
	output  wire      				int_slaveBVALID,
	input wire						int_slaveBREADY,

	//================================================= Slave Side Ports  ================================================//

	// Slave Read Address Ports	
	output  wire [ID_WIDTH-1:0]  	SLAVE_ARID,
	output  wire [ADDR_WIDTH-1:0]	SLAVE_ARADDR,
	output  wire [7:0]           	SLAVE_ARLEN,
	output  wire [2:0]        		SLAVE_ARSIZE,
	output  wire [1:0]           	SLAVE_ARBURST,
	output  wire [1:0]         		SLAVE_ARLOCK,
	output  wire [3:0]          	SLAVE_ARCACHE,
	output  wire [2:0]         		SLAVE_ARPROT,
	output  wire [3:0]          	SLAVE_ARREGION,
	output  wire [3:0]          	SLAVE_ARQOS,
	output  wire [USER_WIDTH-1:0]	SLAVE_ARUSER,
	output  wire                	SLAVE_ARVALID,
	input wire                		SLAVE_ARREADY,
	
	// Slave Read Data Ports	
	input wire [ID_WIDTH-1:0]  		SLAVE_RID,
	input wire [SLAVE_DATA_WIDTH-1:0]  	SLAVE_RDATA,
	input wire [1:0]           		SLAVE_RRESP,
	input wire                  	SLAVE_RLAST,
	input wire [USER_WIDTH-1:0] 	SLAVE_RUSER,
	input wire               		SLAVE_RVALID,
	output wire                 	SLAVE_RREADY,
	
	// Slave Write Address Ports	
	output  wire [ID_WIDTH-1:0]   	SLAVE_AWID,
	output  wire [ADDR_WIDTH-1:0] 	SLAVE_AWADDR,
	output  wire [7:0]           	SLAVE_AWLEN,
	output  wire [2:0]           	SLAVE_AWSIZE,
	output  wire [1:0]           	SLAVE_AWBURST,
	output  wire [1:0]            	SLAVE_AWLOCK,
	output  wire [3:0]          	SLAVE_AWCACHE,
	output  wire [2:0]           	SLAVE_AWPROT,
	output  wire [3:0]           	SLAVE_AWREGION,
	output  wire [3:0]           	SLAVE_AWQOS,
	output  wire [USER_WIDTH-1:0] 	SLAVE_AWUSER,
	output  wire                  	SLAVE_AWVALID,
	input wire                		SLAVE_AWREADY,
	
	// Slave Write Data Ports	
	output wire [ID_WIDTH-1:0]      SLAVE_WID,
	output wire [SLAVE_DATA_WIDTH-1:0]   	SLAVE_WDATA,
	output wire [(SLAVE_DATA_WIDTH/8)-1:0] SLAVE_WSTRB,
	output wire                   	SLAVE_WLAST,
	output wire [USER_WIDTH-1:0] 	SLAVE_WUSER,
	output wire                  	SLAVE_WVALID,
	input wire                  	SLAVE_WREADY,
	
	// Slave Write Response Ports	
	input wire [ID_WIDTH-1:0]		SLAVE_BID,
	input wire [1:0]           		SLAVE_BRESP,
	input wire [USER_WIDTH-1:0]  	SLAVE_BUSER,
	input wire      				SLAVE_BVALID,
	output wire						SLAVE_BREADY

	);


generate
	if ( SLAVE_DATA_WIDTH == DATA_WIDTH) 		// Slave data width == AXI4 xBar data width => direct connection
		begin
			//====================================== ASSIGNEMENTS =================================================
					//from crossbar to Slave
			assign SLAVE_AWID =	int_slaveAWID;
			assign SLAVE_AWADDR = int_slaveAWADDR;
			assign SLAVE_AWLEN = int_slaveAWLEN;
			assign SLAVE_AWSIZE = int_slaveAWSIZE;
			assign SLAVE_AWBURST = int_slaveAWBURST;	
			assign SLAVE_AWLOCK = int_slaveAWLOCK;
			assign SLAVE_AWCACHE = int_slaveAWCACHE;	
			assign SLAVE_AWPROT = int_slaveAWPROT;
			assign SLAVE_AWREGION = int_slaveAWREGION;
			assign SLAVE_AWQOS = int_slaveAWQOS;
			assign SLAVE_AWUSER = int_slaveAWUSER;
			assign SLAVE_AWVALID = int_slaveAWVALID;	
			assign SLAVE_WID   = int_slaveWID;
			assign SLAVE_WDATA = int_slaveWDATA;
			assign SLAVE_WSTRB = int_slaveWSTRB;
			assign SLAVE_WLAST = int_slaveWLAST;
			assign SLAVE_WUSER = int_slaveWUSER;
			assign SLAVE_WVALID = int_slaveWVALID;
			assign SLAVE_BREADY = int_slaveBREADY;
			assign SLAVE_ARID = int_slaveARID;
			assign SLAVE_ARADDR = int_slaveARADDR;
			assign SLAVE_ARLEN = int_slaveARLEN;
			assign SLAVE_ARSIZE = int_slaveARSIZE;
			assign SLAVE_ARBURST = int_slaveARBURST;	
			assign SLAVE_ARLOCK = int_slaveARLOCK;
			assign SLAVE_ARCACHE = int_slaveARCACHE;	
			assign SLAVE_ARPROT = int_slaveARPROT;
			assign SLAVE_ARREGION = int_slaveARREGION;
			assign SLAVE_ARQOS = int_slaveARQOS;
			assign SLAVE_ARUSER = int_slaveARUSER;
			assign SLAVE_ARVALID = int_slaveARVALID;	
			assign SLAVE_RREADY = int_slaveRREADY;
			//			
			//from		Slave to crossbar	
			assign int_slaveAWREADY = SLAVE_AWREADY;	
			assign int_slaveWREADY = SLAVE_WREADY;
			assign int_slaveBID = SLAVE_BID;
			assign int_slaveBRESP =	SLAVE_BRESP;
			assign int_slaveBUSER =	SLAVE_BUSER;
			assign int_slaveBVALID = SLAVE_BVALID;	
			assign int_slaveARREADY = SLAVE_ARREADY;	
						
			assign int_slaveRID = SLAVE_RID;
			assign int_slaveRDATA =	SLAVE_RDATA;
			assign int_slaveRRESP =	SLAVE_RRESP;
			assign int_slaveRLAST =	SLAVE_RLAST;
			assign int_slaveRUSER =	SLAVE_RUSER;
			assign int_slaveRVALID = SLAVE_RVALID;	

		end
	else if ( SLAVE_DATA_WIDTH > DATA_WIDTH) 		// upscale
		begin
	                       //localparam WRITE_ADDR_FIFO_EST = (OPEN_TRANS_MAX > 2) ? 2*OPEN_TRANS_MAX : 4; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps

	                       //localparam READ_ADDR_FIFO_EST = (OPEN_TRANS_MAX > 4) ? OPEN_TRANS_MAX : 4; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps

	                       localparam WRITE_ADDR_FIFO_EST = 2*OPEN_TRANS_MAX*NUM_THREADS; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps

	                       localparam READ_ADDR_FIFO_EST  = 2*OPEN_TRANS_MAX*NUM_THREADS; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps
						   
	                       localparam WRITE_ADDR_FIFO_DEPTH = (WRITE_ADDR_FIFO_EST > DWC_ADDR_FIFO_DEPTH_CEILING) ?  DWC_ADDR_FIFO_DEPTH_CEILING: WRITE_ADDR_FIFO_EST;

	                       localparam READ_ADDR_FIFO_DEPTH = (READ_ADDR_FIFO_EST > DWC_ADDR_FIFO_DEPTH_CEILING) ?  DWC_ADDR_FIFO_DEPTH_CEILING: READ_ADDR_FIFO_EST;


			caxi4interconnect_UpConverter #
					(
						.ID_WIDTH ( ID_WIDTH ), 	
						.ADDR_WIDTH( ADDR_WIDTH ),						
						.DATA_WIDTH( DATA_WIDTH ), 
						.WRITE_ADDR_FIFO_DEPTH ( WRITE_ADDR_FIFO_DEPTH ),
						.READ_ADDR_FIFO_DEPTH ( READ_ADDR_FIFO_DEPTH ),
						.DATA_WIDTH_IN 	( DATA_WIDTH ),
						.DATA_WIDTH_OUT ( SLAVE_DATA_WIDTH ),
						.USER_WIDTH( USER_WIDTH ),
						.DATA_FIFO_DEPTH ( DATA_FIFO_DEPTH ),
						.READ_INTERLEAVE (READ_INTERLEAVE)
					)
			SlvUpConv (
						// Global Signals
						.ACLK( ACLK ),
						.sysReset( sysReset ),				
	   
						// Master Read Address Ports
						.MASTER_ARID		( int_slaveARID ),
						.MASTER_ARADDR		( int_slaveARADDR ),
						.MASTER_ARLEN		( int_slaveARLEN ),
						.MASTER_ARSIZE		( int_slaveARSIZE ),
						.MASTER_ARBURST		( int_slaveARBURST ),
						.MASTER_ARLOCK		( int_slaveARLOCK ),
						.MASTER_ARCACHE		( int_slaveARCACHE ),
						.MASTER_ARPROT		( int_slaveARPROT ),
						.MASTER_ARREGION	( int_slaveARREGION ),
						.MASTER_ARQOS		( int_slaveARQOS ),
						.MASTER_ARUSER		( int_slaveARUSER ),
						.MASTER_ARVALID		( int_slaveARVALID ),
						.MASTER_AWQOS		( int_slaveAWQOS ),
						.MASTER_AWREGION	( int_slaveAWREGION ),
						.MASTER_AWID		( int_slaveAWID ),
						.MASTER_AWADDR		( int_slaveAWADDR ),
						.MASTER_AWLEN		( int_slaveAWLEN ),
						.MASTER_AWSIZE		( int_slaveAWSIZE ),
						.MASTER_AWBURST		( int_slaveAWBURST ),
						.MASTER_AWLOCK		( int_slaveAWLOCK ),
						.MASTER_AWCACHE		( int_slaveAWCACHE ),
						.MASTER_AWPROT		( int_slaveAWPROT ),
						.MASTER_AWUSER		( int_slaveAWUSER ),
						.MASTER_AWVALID		( int_slaveAWVALID ),
						.MASTER_WID         ( int_slaveWID   ),
						.MASTER_WDATA		( int_slaveWDATA ),
						.MASTER_WSTRB		( int_slaveWSTRB ),
						.MASTER_WLAST		( int_slaveWLAST ),
						.MASTER_WUSER		( int_slaveWUSER ),
						.MASTER_WVALID		( int_slaveWVALID ),
						.MASTER_BREADY		( int_slaveBREADY ),
						.MASTER_RREADY		( int_slaveRREADY ),
						.MASTER_ARREADY 	( int_slaveARREADY),
						.MASTER_RID 		( int_slaveRID ),
						.MASTER_RDATA 		( int_slaveRDATA ),
						.MASTER_RRESP 		( int_slaveRRESP ),
						.MASTER_RUSER 		( int_slaveRUSER ),
						.MASTER_BID 		( int_slaveBID ),
						.MASTER_BRESP 		( int_slaveBRESP ),
						.MASTER_BUSER 		( int_slaveBUSER ),
						.MASTER_RLAST 		( int_slaveRLAST ),
						.MASTER_RVALID 		( int_slaveRVALID ),
						.MASTER_AWREADY 	( int_slaveAWREADY ),
						.MASTER_WREADY 		( int_slaveWREADY ),
						.MASTER_BVALID 		( int_slaveBVALID ),
						
						.SLAVE_ARID			( SLAVE_ARID ),
						.SLAVE_ARADDR		( SLAVE_ARADDR ),
						.SLAVE_ARLEN		( SLAVE_ARLEN ),
						.SLAVE_ARSIZE		( SLAVE_ARSIZE ),
						.SLAVE_ARBURST		( SLAVE_ARBURST ),
						.SLAVE_ARLOCK		( SLAVE_ARLOCK ),
						.SLAVE_ARCACHE		( SLAVE_ARCACHE ),
						.SLAVE_ARPROT		( SLAVE_ARPROT ),
						.SLAVE_ARREGION		( SLAVE_ARREGION ),
						.SLAVE_ARQOS		( SLAVE_ARQOS ),
						.SLAVE_ARUSER		( SLAVE_ARUSER ),
						.SLAVE_ARVALID		( SLAVE_ARVALID ),
						.SLAVE_AWQOS		( SLAVE_AWQOS ),
						.SLAVE_AWREGION		( SLAVE_AWREGION ),
						.SLAVE_AWID			( SLAVE_AWID ),
						.SLAVE_AWADDR		( SLAVE_AWADDR ),
						.SLAVE_AWLEN		( SLAVE_AWLEN ),
						.SLAVE_AWSIZE		( SLAVE_AWSIZE ),
						.SLAVE_AWBURST		( SLAVE_AWBURST ),
						.SLAVE_AWLOCK		( SLAVE_AWLOCK ),
						.SLAVE_AWCACHE		( SLAVE_AWCACHE ),
						.SLAVE_AWPROT		( SLAVE_AWPROT ),
						.SLAVE_AWUSER		( SLAVE_AWUSER ),
						.SLAVE_AWVALID		( SLAVE_AWVALID ),
						.SLAVE_WID          ( SLAVE_WID   ),
						.SLAVE_WDATA		( SLAVE_WDATA ),
						.SLAVE_WSTRB		( SLAVE_WSTRB ),
						.SLAVE_WLAST		( SLAVE_WLAST ),
						.SLAVE_WUSER		( SLAVE_WUSER ),
						.SLAVE_WVALID		( SLAVE_WVALID ),
						.SLAVE_BREADY		( SLAVE_BREADY ),
						.SLAVE_RREADY		( SLAVE_RREADY ),
						.SLAVE_ARREADY 		( SLAVE_ARREADY ),
						.SLAVE_RID 			( SLAVE_RID ),
						.SLAVE_RDATA 		( SLAVE_RDATA ),
						.SLAVE_RRESP 		( SLAVE_RRESP ),
						.SLAVE_RUSER 		( SLAVE_RUSER ),
						.SLAVE_BID 			( SLAVE_BID ),
						.SLAVE_BRESP 		( SLAVE_BRESP ),
						.SLAVE_BUSER 		( SLAVE_BUSER ),
						.SLAVE_RLAST 		( SLAVE_RLAST ),
						.SLAVE_RVALID 		( SLAVE_RVALID ),
						.SLAVE_AWREADY 		( SLAVE_AWREADY ),
						.SLAVE_WREADY 		( SLAVE_WREADY ),
						.SLAVE_BVALID 		( SLAVE_BVALID )

					); 
		end
	else if (DATA_WIDTH > SLAVE_DATA_WIDTH) 		// down-scale
		begin

                               localparam DOWNCONV_RATIO = DATA_WIDTH/SLAVE_DATA_WIDTH;

	                       localparam ADDR_FIFO_EST = ((OPEN_TRANS_MAX*DOWNCONV_RATIO) > 4) ? 
					( (DOWNCONV_RATIO > 4) ? 4*OPEN_TRANS_MAX : (DOWNCONV_RATIO*OPEN_TRANS_MAX)) 
					: 4; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps
	                       localparam ADDR_FIFO_DEPTH = (ADDR_FIFO_EST > DWC_ADDR_FIFO_DEPTH_CEILING) ?  DWC_ADDR_FIFO_DEPTH_CEILING: ADDR_FIFO_EST;

	caxi4interconnect_DownConverter #
			(
							.ID_WIDTH ( ID_WIDTH ), 	
							.ADDR_WIDTH( ADDR_WIDTH ),	
							.ADDR_FIFO_DEPTH( ADDR_FIFO_DEPTH ),
							.DATA_WIDTH_IN 	( DATA_WIDTH ),
							.DATA_WIDTH_OUT ( SLAVE_DATA_WIDTH ),
							.STRB_WIDTH_IN 	( DATA_WIDTH/8 ),
							.STRB_WIDTH_OUT ( SLAVE_DATA_WIDTH/8 ),
							.USER_WIDTH( USER_WIDTH ),
							.READ_INTERLEAVE (READ_INTERLEAVE)
						)
	DownConverter_inst( .MASTER_ARADDR(int_slaveARADDR),
                             .MASTER_ARBURST(int_slaveARBURST),
                             .MASTER_ARCACHE(int_slaveARCACHE),
                             .MASTER_ARID(int_slaveARID),
                             .MASTER_ARLEN(int_slaveARLEN),
                             .MASTER_ARLOCK(int_slaveARLOCK),
                             .MASTER_ARPROT(int_slaveARPROT),
                             .MASTER_ARQOS(int_slaveARQOS),
                             .MASTER_ARREADY(int_slaveARREADY),
                             .MASTER_ARREGION(int_slaveARREGION),
                             .MASTER_ARSIZE(int_slaveARSIZE),
                             .MASTER_ARUSER(int_slaveARUSER),
                             .MASTER_ARVALID(int_slaveARVALID),
                             .MASTER_RDATA(int_slaveRDATA),
                             .MASTER_RID(int_slaveRID),
                             .MASTER_RLAST(int_slaveRLAST),
                             .MASTER_RREADY(int_slaveRREADY),
                             .MASTER_RRESP(int_slaveRRESP),
                             .MASTER_RUSER(int_slaveRUSER),
                             .MASTER_RVALID(int_slaveRVALID),
                             .MASTER_AWADDR(int_slaveAWADDR),
                             .MASTER_AWBURST(int_slaveAWBURST),
                             .MASTER_AWCACHE(int_slaveAWCACHE),
                             .MASTER_AWID(int_slaveAWID),
                             .MASTER_AWLEN(int_slaveAWLEN),
                             .MASTER_AWLOCK(int_slaveAWLOCK),
                             .MASTER_AWPROT(int_slaveAWPROT),
                             .MASTER_AWQOS(int_slaveAWQOS),
                             .MASTER_AWREADY(int_slaveAWREADY),
                             .MASTER_AWREGION(int_slaveAWREGION),
                             .MASTER_AWSIZE(int_slaveAWSIZE),
                             .MASTER_AWUSER(int_slaveAWUSER),
                             .MASTER_AWVALID(int_slaveAWVALID),
                             .MASTER_WID(int_slaveWID),
                             .MASTER_WDATA(int_slaveWDATA),
                             .MASTER_WLAST(int_slaveWLAST),
                             .MASTER_WREADY(int_slaveWREADY),
                             .MASTER_WSTRB(int_slaveWSTRB),
                             .MASTER_WUSER(int_slaveWUSER),
                             .MASTER_WVALID(int_slaveWVALID),
                             .MASTER_BID(int_slaveBID),
                             .MASTER_BREADY(int_slaveBREADY),
                             .MASTER_BRESP(int_slaveBRESP),
                             .MASTER_BUSER(int_slaveBUSER),
                             .MASTER_BVALID(int_slaveBVALID),
                             .ACLK(ACLK),
                             .sysReset(sysReset),
                             .SLAVE_BID(SLAVE_BID),
                             .SLAVE_BREADY(SLAVE_BREADY),
                             .SLAVE_BRESP(SLAVE_BRESP),
                             .SLAVE_BUSER(SLAVE_BUSER),
                             .SLAVE_BVALID(SLAVE_BVALID),
                             .SLAVE_ARADDR(SLAVE_ARADDR),
                             .SLAVE_ARBURST(SLAVE_ARBURST),
                             .SLAVE_ARCACHE(SLAVE_ARCACHE),
                             .SLAVE_ARID(SLAVE_ARID),
                             .SLAVE_ARLEN(SLAVE_ARLEN),
                             .SLAVE_ARLOCK(SLAVE_ARLOCK),
                             .SLAVE_ARPROT(SLAVE_ARPROT),
                             .SLAVE_ARQOS(SLAVE_ARQOS),
                             .SLAVE_ARREADY(SLAVE_ARREADY),
                             .SLAVE_ARREGION(SLAVE_ARREGION),
                             .SLAVE_ARSIZE(SLAVE_ARSIZE),
                             .SLAVE_ARUSER(SLAVE_ARUSER),
                             .SLAVE_ARVALID(SLAVE_ARVALID),
                             .SLAVE_AWADDR(SLAVE_AWADDR),
                             .SLAVE_AWBURST(SLAVE_AWBURST),
                             .SLAVE_AWCACHE(SLAVE_AWCACHE),
                             .SLAVE_AWID(SLAVE_AWID),
                             .SLAVE_AWLEN(SLAVE_AWLEN),
                             .SLAVE_AWLOCK(SLAVE_AWLOCK),
                             .SLAVE_AWPROT(SLAVE_AWPROT),
                             .SLAVE_AWQOS(SLAVE_AWQOS),
                             .SLAVE_AWREADY(SLAVE_AWREADY),
                             .SLAVE_AWREGION(SLAVE_AWREGION),
                             .SLAVE_AWSIZE(SLAVE_AWSIZE),
                             .SLAVE_AWUSER(SLAVE_AWUSER),
                             .SLAVE_AWVALID(SLAVE_AWVALID),
                             .SLAVE_RDATA(SLAVE_RDATA),
                             .SLAVE_RID(SLAVE_RID),
                             .SLAVE_RLAST(SLAVE_RLAST),
                             .SLAVE_RREADY(SLAVE_RREADY),
                             .SLAVE_RRESP(SLAVE_RRESP),
                             .SLAVE_RUSER(SLAVE_RUSER),
                             .SLAVE_RVALID(SLAVE_RVALID),
                             .SLAVE_WID(SLAVE_WID),
                             .SLAVE_WDATA(SLAVE_WDATA),
                             .SLAVE_WLAST(SLAVE_WLAST),
                             .SLAVE_WREADY(SLAVE_WREADY),
                             .SLAVE_WSTRB(SLAVE_WSTRB),
                             .SLAVE_WUSER(SLAVE_WUSER),
                             .SLAVE_WVALID(SLAVE_WVALID)
		     );			
		end
	else
		begin
			initial 
				begin
					#1 $display("\n\n Module has called for an unsupported data width conversion : %m\n\n" );
					$stop;
				end
		end
		
endgenerate


endmodule 	// caxi4interconnect_SlvDataWidthConverter.v
