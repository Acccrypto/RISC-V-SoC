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
//     Abstract  : This file provides data bus width conversion on master side.
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

module caxi4interconnect_MstrDataWidthConv #

	(
		parameter [1:0] 	MASTER_TYPE		          = 2'b00,	// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11
		parameter integer	MASTER_NUMBER	          = 0,		// Master number
		parameter OPEN_TRANS_MAX				      = 2,				// max number of outstanding transactions per thread - valid range 1-8
		parameter integer ID_WIDTH   			      = 1, 
                                                      
		parameter integer ADDR_WIDTH      		      = 20,
		parameter integer DATA_WIDTH 			      = 16,
		parameter integer MASTER_DATA_WIDTH		      = 32,

		parameter integer USER_WIDTH 			      = 1,
  	    parameter integer DWC_ADDR_FIFO_DEPTH_CEILING = 'h10,
		parameter [13:0]  DATA_FIFO_DEPTH             = 14'h10,
		parameter         READ_INTERLEAVE             = 1,
		parameter         NUM_THREADS                 = 4
	)
	(

	//=====================================  Global Signals   ========================================================================
	input  wire           			ACLK,
	input  wire          			sysReset,
 
	//=====================================  Connections to/from Crossbar   ==========================================================
 
	output wire [ID_WIDTH-1:0] 		masterARID,
	output wire [ADDR_WIDTH-1:0]	masterARADDR,
	output wire [7:0]        		masterARLEN,
	output wire [2:0]          		masterARSIZE,
	output wire [1:0]          		masterARBURST,
	output wire [1:0]          		masterARLOCK,
	output wire [3:0]           	masterARCACHE,
	output wire [2:0]         		masterARPROT,
	output wire [3:0]          		masterARREGION,
	output wire [3:0]          		masterARQOS,
	output wire [USER_WIDTH-1:0]	masterARUSER,
	output wire            			masterARVALID,
	input wire             			masterARREADY,

	// Master Read Data Ports	
	input wire [ID_WIDTH-1:0]   	masterRID,
	input wire [DATA_WIDTH-1:0]		masterRDATA,
	input wire [1:0]           		masterRRESP,
	input wire                		masterRLAST,
	input wire [USER_WIDTH-1:0] 	masterRUSER,
	input wire                 		masterRVALID,
	output wire               		masterRREADY,

	// Master Write Address Ports	
	output wire [ID_WIDTH-1:0]  	masterAWID,
	output wire [ADDR_WIDTH-1:0] 	masterAWADDR,
	output wire [7:0]           	masterAWLEN,
	output wire [2:0]           	masterAWSIZE,
	output wire [1:0]           	masterAWBURST,
	output wire [1:0]           	masterAWLOCK,
	output wire [3:0]          		masterAWCACHE,
	output wire [2:0]           	masterAWPROT,
	output wire [3:0]            	masterAWREGION,
	output wire [3:0]           	masterAWQOS,
	output wire [USER_WIDTH-1:0]   	masterAWUSER,
	output wire                 	masterAWVALID,
	input wire                		masterAWREADY,
	
	// Master Write Data Ports	
	
	output wire [ID_WIDTH-1:0]          masterWID,
	output wire [DATA_WIDTH-1:0]  		masterWDATA,
	output wire [(DATA_WIDTH/8)-1:0]	masterWSTRB,
	output wire                  		masterWLAST,
	output wire [USER_WIDTH-1:0] 		masterWUSER,
	output wire                  		masterWVALID,
	input wire                   		masterWREADY,
			
	// Master Write Response Ports	
	input  wire [ID_WIDTH-1:0]		masterBID,
	input  wire [1:0]           	masterBRESP,
	input  wire [USER_WIDTH-1:0] 	masterBUSER,
	input  wire      				masterBVALID,
	output wire						masterBREADY,

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

	
generate
		if ( MASTER_DATA_WIDTH == DATA_WIDTH) 		// no data-width conversion so pass-through
			begin
				//====================================== ASSIGNEMENTS =================================================
						//from Master to crossbar & Slave
				assign masterAWID =	MASTER_AWID;
				assign masterAWADDR = MASTER_AWADDR;
				assign masterAWLEN = MASTER_AWLEN;
				assign masterAWSIZE = MASTER_AWSIZE;
				assign masterAWBURST = MASTER_AWBURST;	
				assign masterAWLOCK = MASTER_AWLOCK;
				assign masterAWCACHE = MASTER_AWCACHE;	
				assign masterAWPROT = MASTER_AWPROT;
				assign masterAWREGION = MASTER_AWREGION;
				assign masterAWQOS = MASTER_AWQOS;
				assign masterAWUSER = MASTER_AWUSER;
				assign masterAWVALID = MASTER_AWVALID;	
				assign masterWID   = MASTER_WID;
				assign masterWDATA = MASTER_WDATA;
				assign masterWSTRB = MASTER_WSTRB;
				assign masterWLAST = MASTER_WLAST;
				assign masterWUSER = MASTER_WUSER;
				assign masterWVALID = MASTER_WVALID;
				assign masterBREADY = MASTER_BREADY;
				assign masterARID = MASTER_ARID;
				assign masterARADDR = MASTER_ARADDR;
				assign masterARLEN = MASTER_ARLEN;
				assign masterARSIZE = MASTER_ARSIZE;
				assign masterARBURST = MASTER_ARBURST;	
				assign masterARLOCK = MASTER_ARLOCK;
				assign masterARCACHE = MASTER_ARCACHE;	
				assign masterARPROT = MASTER_ARPROT;
				assign masterARREGION = MASTER_ARREGION;
				assign masterARQOS = MASTER_ARQOS;
				assign masterARUSER = MASTER_ARUSER;
				assign masterARVALID = MASTER_ARVALID;	
				assign masterRREADY = MASTER_RREADY;
				//			
				//from crossbar to MASTER
				assign MASTER_AWREADY = masterAWREADY;	
				assign MASTER_WREADY = masterWREADY;
				assign MASTER_BID = masterBID;
				assign MASTER_BRESP =	masterBRESP;
				assign MASTER_BUSER =	masterBUSER;
				assign MASTER_BVALID = masterBVALID;	
				assign MASTER_ARREADY = masterARREADY;	
							
				assign MASTER_RID = masterRID;
				assign MASTER_RDATA =	masterRDATA;
				assign MASTER_RRESP =	masterRRESP;
				assign MASTER_RLAST =	masterRLAST;
				assign MASTER_RUSER =	masterRUSER;
				assign MASTER_RVALID = masterRVALID;	

			end
		else if ( MASTER_DATA_WIDTH > DATA_WIDTH) 		// down-scale
			begin

	                       //localparam ADDR_FIFO_EST = (OPEN_TRANS_MAX > 4) ? OPEN_TRANS_MAX : 4; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps
	                       localparam ADDR_FIFO_EST = (MASTER_DATA_WIDTH/DATA_WIDTH) * NUM_THREADS * OPEN_TRANS_MAX; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps
	                       localparam ADDR_FIFO_DEPTH = (ADDR_FIFO_EST > DWC_ADDR_FIFO_DEPTH_CEILING) ?  DWC_ADDR_FIFO_DEPTH_CEILING: ADDR_FIFO_EST;


				caxi4interconnect_DownConverter #
						(
							.ID_WIDTH ( ID_WIDTH ), 	
							.ADDR_WIDTH( ADDR_WIDTH ),	
							.ADDR_FIFO_DEPTH( ADDR_FIFO_DEPTH ),
							.DATA_WIDTH_IN 	( MASTER_DATA_WIDTH ),
							.DATA_WIDTH_OUT ( DATA_WIDTH ),
							.STRB_WIDTH_IN 	( MASTER_DATA_WIDTH/8 ),
							.STRB_WIDTH_OUT ( DATA_WIDTH/8 ),
							.USER_WIDTH( USER_WIDTH ),
							.READ_INTERLEAVE( READ_INTERLEAVE )
						)
	DownConverter_inst( .MASTER_ARADDR(MASTER_ARADDR),
                             .MASTER_ARBURST(MASTER_ARBURST),
                             .MASTER_ARCACHE(MASTER_ARCACHE),
                             .MASTER_ARID(MASTER_ARID),
                             .MASTER_ARLEN(MASTER_ARLEN),
                             .MASTER_ARLOCK(MASTER_ARLOCK),
                             .MASTER_ARPROT(MASTER_ARPROT),
                             .MASTER_ARQOS(MASTER_ARQOS),
                             .MASTER_ARREADY(MASTER_ARREADY),
                             .MASTER_ARREGION(MASTER_ARREGION),
                             .MASTER_ARSIZE(MASTER_ARSIZE),
                             .MASTER_ARUSER(MASTER_ARUSER),
                             .MASTER_ARVALID(MASTER_ARVALID),
                             .MASTER_RDATA(MASTER_RDATA),
                             .MASTER_RID(MASTER_RID),
                             .MASTER_RLAST(MASTER_RLAST),
                             .MASTER_RREADY(MASTER_RREADY),
                             .MASTER_RRESP(MASTER_RRESP),
                             .MASTER_RUSER(MASTER_RUSER),
                             .MASTER_RVALID(MASTER_RVALID),
                             .MASTER_AWADDR(MASTER_AWADDR),
                             .MASTER_AWBURST(MASTER_AWBURST),
                             .MASTER_AWCACHE(MASTER_AWCACHE),
                             .MASTER_AWID(MASTER_AWID),
                             .MASTER_AWLEN(MASTER_AWLEN),
                             .MASTER_AWLOCK(MASTER_AWLOCK),
                             .MASTER_AWPROT(MASTER_AWPROT),
                             .MASTER_AWQOS(MASTER_AWQOS),
                             .MASTER_AWREADY(MASTER_AWREADY),
                             .MASTER_AWREGION(MASTER_AWREGION),
                             .MASTER_AWSIZE(MASTER_AWSIZE),
                             .MASTER_AWUSER(MASTER_AWUSER),
                             .MASTER_AWVALID(MASTER_AWVALID),
							 .MASTER_WID  (MASTER_WID),
                             .MASTER_WDATA(MASTER_WDATA),
                             .MASTER_WLAST(MASTER_WLAST),
                             .MASTER_WREADY(MASTER_WREADY),
                             .MASTER_WSTRB(MASTER_WSTRB),
                             .MASTER_WUSER(MASTER_WUSER),
                             .MASTER_WVALID(MASTER_WVALID),
                             .MASTER_BID(MASTER_BID),
                             .MASTER_BREADY(MASTER_BREADY),
                             .MASTER_BRESP(MASTER_BRESP),
                             .MASTER_BUSER(MASTER_BUSER),
                             .MASTER_BVALID(MASTER_BVALID),
                             .ACLK(ACLK),
                             .sysReset(sysReset),
                             .SLAVE_BID(masterBID),
                             .SLAVE_BREADY(masterBREADY),
                             .SLAVE_BRESP(masterBRESP),
                             .SLAVE_BUSER(masterBUSER),
                             .SLAVE_BVALID(masterBVALID),
                             .SLAVE_ARADDR(masterARADDR),
                             .SLAVE_ARBURST(masterARBURST),
                             .SLAVE_ARCACHE(masterARCACHE),
                             .SLAVE_ARID(masterARID),
                             .SLAVE_ARLEN(masterARLEN),
                             .SLAVE_ARLOCK(masterARLOCK),
                             .SLAVE_ARPROT(masterARPROT),
                             .SLAVE_ARQOS(masterARQOS),
                             .SLAVE_ARREADY(masterARREADY),
                             .SLAVE_ARREGION(masterARREGION),
                             .SLAVE_ARSIZE(masterARSIZE),
                             .SLAVE_ARUSER(masterARUSER),
                             .SLAVE_ARVALID(masterARVALID),
                             .SLAVE_AWADDR(masterAWADDR),
                             .SLAVE_AWBURST(masterAWBURST),
                             .SLAVE_AWCACHE(masterAWCACHE),
                             .SLAVE_AWID(masterAWID),
                             .SLAVE_AWLEN(masterAWLEN),
                             .SLAVE_AWLOCK(masterAWLOCK),
                             .SLAVE_AWPROT(masterAWPROT),
                             .SLAVE_AWQOS(masterAWQOS),
                             .SLAVE_AWREADY(masterAWREADY),
                             .SLAVE_AWREGION(masterAWREGION),
                             .SLAVE_AWSIZE(masterAWSIZE),
                             .SLAVE_AWUSER(masterAWUSER),
                             .SLAVE_AWVALID(masterAWVALID),
                             .SLAVE_RDATA(masterRDATA),
                             .SLAVE_RID(masterRID),
                             .SLAVE_RLAST(masterRLAST),
                             .SLAVE_RREADY(masterRREADY),
                             .SLAVE_RRESP(masterRRESP),
                             .SLAVE_RUSER(masterRUSER),
                             .SLAVE_RVALID(masterRVALID),
							 .SLAVE_WID (masterWID),
                             .SLAVE_WDATA(masterWDATA),
                             .SLAVE_WLAST(masterWLAST),
                             .SLAVE_WREADY(masterWREADY),
                             .SLAVE_WSTRB(masterWSTRB),
                             .SLAVE_WUSER(masterWUSER),
                             .SLAVE_WVALID(masterWVALID)
		     );
				
			end
		else if ( MASTER_DATA_WIDTH < DATA_WIDTH) 		// up-scale
			begin

	                       //localparam WRITE_ADDR_FIFO_EST = (OPEN_TRANS_MAX > 2) ? 2*OPEN_TRANS_MAX : 4; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps

	                       //localparam READ_ADDR_FIFO_EST = (OPEN_TRANS_MAX > 4) ? OPEN_TRANS_MAX : 4; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps

	                       localparam WRITE_ADDR_FIFO_EST = (DATA_WIDTH/MASTER_DATA_WIDTH)*OPEN_TRANS_MAX*NUM_THREADS; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps

	                       localparam READ_ADDR_FIFO_EST  = (DATA_WIDTH/MASTER_DATA_WIDTH)*OPEN_TRANS_MAX*NUM_THREADS; // Minimum caxi4interconnect_FIFO depth is 4, else twice OPEN_TRAND_MAX as we need 2 cmd caxi4interconnect_FIFO locations for most wraps
						   
	                       localparam WRITE_ADDR_FIFO_DEPTH = (WRITE_ADDR_FIFO_EST > DWC_ADDR_FIFO_DEPTH_CEILING) ?  DWC_ADDR_FIFO_DEPTH_CEILING: WRITE_ADDR_FIFO_EST;

	                       localparam READ_ADDR_FIFO_DEPTH = (READ_ADDR_FIFO_EST > DWC_ADDR_FIFO_DEPTH_CEILING) ?  DWC_ADDR_FIFO_DEPTH_CEILING: READ_ADDR_FIFO_EST;

				caxi4interconnect_UpConverter #
						(
							.ID_WIDTH ( ID_WIDTH ), 	
							.ADDR_WIDTH( ADDR_WIDTH ),						
							.DATA_WIDTH( DATA_WIDTH ),
							.WRITE_ADDR_FIFO_DEPTH ( WRITE_ADDR_FIFO_DEPTH ),
							.READ_ADDR_FIFO_DEPTH ( READ_ADDR_FIFO_DEPTH ),
							.DATA_WIDTH_IN 	( MASTER_DATA_WIDTH ),
							.DATA_WIDTH_OUT ( DATA_WIDTH ),
							.USER_WIDTH( USER_WIDTH ),
							.DATA_FIFO_DEPTH ( DATA_FIFO_DEPTH ),
							.READ_INTERLEAVE (READ_INTERLEAVE)
						)
				MstUpConv (
							// Global Signals
							.ACLK( ACLK ),
							.sysReset( sysReset ),				// active low reset synchronoise to RE AClk - asserted async.
		   
							// Master Read Address Ports
							.MASTER_ARID		( MASTER_ARID ),
							.MASTER_ARADDR		( MASTER_ARADDR ),
							.MASTER_ARLEN		( MASTER_ARLEN ),
							.MASTER_ARSIZE		( MASTER_ARSIZE ),
							.MASTER_ARBURST		( MASTER_ARBURST ),
							.MASTER_ARLOCK		( MASTER_ARLOCK ),
							.MASTER_ARCACHE		( MASTER_ARCACHE ),
							.MASTER_ARPROT		( MASTER_ARPROT ),
							.MASTER_ARREGION	( MASTER_ARREGION ),
							.MASTER_ARQOS		( MASTER_ARQOS ),
							.MASTER_ARUSER		( MASTER_ARUSER ),
							.MASTER_ARVALID		( MASTER_ARVALID ),
							.MASTER_AWQOS		( MASTER_AWQOS ),
							.MASTER_AWREGION	( MASTER_AWREGION ),
							.MASTER_AWID		( MASTER_AWID ),
							.MASTER_AWADDR		( MASTER_AWADDR ),
							.MASTER_AWLEN		( MASTER_AWLEN ),
							.MASTER_AWSIZE		( MASTER_AWSIZE ),
							.MASTER_AWBURST		( MASTER_AWBURST ),
							.MASTER_AWLOCK		( MASTER_AWLOCK ),
							.MASTER_AWCACHE		( MASTER_AWCACHE ),
							.MASTER_AWPROT		( MASTER_AWPROT ),
							.MASTER_AWUSER		( MASTER_AWUSER ),
							.MASTER_AWVALID		( MASTER_AWVALID ),
							.MASTER_WID         ( MASTER_WID),
							.MASTER_WDATA		( MASTER_WDATA ),
							.MASTER_WSTRB		( MASTER_WSTRB ),
							.MASTER_WLAST		( MASTER_WLAST ),
							.MASTER_WUSER		( MASTER_WUSER ),
							.MASTER_WVALID		( MASTER_WVALID ),
							.MASTER_BREADY		( MASTER_BREADY ),
							.MASTER_RREADY		( MASTER_RREADY ),
							.MASTER_ARREADY 	( MASTER_ARREADY),
							.MASTER_RID 		( MASTER_RID ),
							.MASTER_RDATA 		( MASTER_RDATA ),
							.MASTER_RRESP 		( MASTER_RRESP ),
							.MASTER_RUSER 		( MASTER_RUSER ),
							.MASTER_BID 		( MASTER_BID ),
							.MASTER_BRESP 		( MASTER_BRESP ),
							.MASTER_BUSER 		( MASTER_BUSER ),
							.MASTER_RLAST 		( MASTER_RLAST ),
							.MASTER_RVALID 		( MASTER_RVALID ),
							.MASTER_AWREADY 	( MASTER_AWREADY ),
							.MASTER_WREADY 		( MASTER_WREADY ),
							.MASTER_BVALID 		( MASTER_BVALID ),
							
							.SLAVE_ARID			( masterARID ),
							.SLAVE_ARADDR		( masterARADDR ),
							.SLAVE_ARLEN		( masterARLEN ),
							.SLAVE_ARSIZE		( masterARSIZE ),
							.SLAVE_ARBURST		( masterARBURST ),
							.SLAVE_ARLOCK		( masterARLOCK ),
							.SLAVE_ARCACHE		( masterARCACHE ),
							.SLAVE_ARPROT		( masterARPROT ),
							.SLAVE_ARREGION		( masterARREGION ),
							.SLAVE_ARQOS		( masterARQOS ),
							.SLAVE_ARUSER		( masterARUSER ),
							.SLAVE_ARVALID		( masterARVALID ),
							.SLAVE_AWQOS		( masterAWQOS ),
							.SLAVE_AWREGION		( masterAWREGION ),
							.SLAVE_AWID			( masterAWID ),
							.SLAVE_AWADDR		( masterAWADDR ),
							.SLAVE_AWLEN		( masterAWLEN ),
							.SLAVE_AWSIZE		( masterAWSIZE ),
							.SLAVE_AWBURST		( masterAWBURST ),
							.SLAVE_AWLOCK		( masterAWLOCK ),
							.SLAVE_AWCACHE		( masterAWCACHE ),
							.SLAVE_AWPROT		( masterAWPROT ),
							.SLAVE_AWUSER		( masterAWUSER ),
							.SLAVE_AWVALID		( masterAWVALID ),
							.SLAVE_WID          ( masterWID),
							.SLAVE_WDATA		( masterWDATA ),
							.SLAVE_WSTRB		( masterWSTRB ),
							.SLAVE_WLAST		( masterWLAST ),
							.SLAVE_WUSER		( masterWUSER ),
							.SLAVE_WVALID		( masterWVALID ),
							.SLAVE_BREADY		( masterBREADY ),
							.SLAVE_RREADY		( masterRREADY ),
							.SLAVE_ARREADY 		( masterARREADY ),
							.SLAVE_RID 			( masterRID ),
							.SLAVE_RDATA 		( masterRDATA ),
							.SLAVE_RRESP 		( masterRRESP ),
							.SLAVE_RUSER 		( masterRUSER ),
							.SLAVE_BID 			( masterBID ),
							.SLAVE_BRESP 		( masterBRESP ),
							.SLAVE_BUSER 		( masterBUSER ),
							.SLAVE_RLAST 		( masterRLAST ),
							.SLAVE_RVALID 		( masterRVALID ),
							.SLAVE_AWREADY 		( masterAWREADY ),
							.SLAVE_WREADY 		( masterWREADY ),
							.SLAVE_BVALID 		( masterBVALID )

						); 

			end
		else 				// this is an error condition - only 32-64 or 64-32 supported
			begin
				initial 
					begin
						#1 $display("\n\n Module has called for an unsupported data width conversion : %m\n\n" );
						$stop;
					end
			end
			
endgenerate
	
endmodule		// caxi4interconnect_MstrDataWidthConv.v
