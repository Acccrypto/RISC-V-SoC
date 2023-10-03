// ********************************************************************
//  Microsemi Corporation Proprietary and Confidential
//  Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: This module provides a AXI4 Master test source. It
//              initialiates a Master transmission.
//
// Revision Information:
// Date     Description:
// Feb17    Revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************
`timescale 1ns / 1ns

module AxiMaster # 
	(

		parameter [3:0]		MASTER_NUM				= 0,		// Master number
		parameter [1:0] 	MASTER_TYPE				= 2'b00,	// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11
		parameter integer 	ID_WIDTH   				= 2, 

		parameter integer 	ADDR_WIDTH      		= 20,				
		parameter integer 	DATA_WIDTH 				= 16, 

		parameter integer 	SUPPORT_USER_SIGNALS 	= 0,
		parameter integer 	USER_WIDTH 				= 1,
		
		parameter integer 	OPENTRANS_MAX			= 1,			// Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.

		parameter	HI_FREQ							= 0				// increases freq of operation at cost of added latency
		
	)
	(
		// Global Signals
		input  wire                         sysClk,
		input  wire                       	ARESETN,			// active high reset synchronoise to RE AClk - asserted async.
   
		//====================== Master Read Address Ports  ================================================//
		// Master Read Address Ports
		output  wire [ID_WIDTH-1:0]        	MASTER_ARID,
		output  wire [ADDR_WIDTH-1:0]      	MASTER_ARADDR,
		output  wire [7:0]                 	MASTER_ARLEN,
		output  wire [2:0]                 	MASTER_ARSIZE,
		output  wire [1:0]                 	MASTER_ARBURST,
		output  wire [1:0]                 	MASTER_ARLOCK,
		output  wire [3:0]                 	MASTER_ARCACHE,
		output  wire [2:0]                 	MASTER_ARPROT,
		output  wire [3:0]                 	MASTER_ARREGION,		// not used
		output  wire [3:0]                 	MASTER_ARQOS,			// not used
		output  wire [USER_WIDTH-1:0]      	MASTER_ARUSER,
		output  wire                       	MASTER_ARVALID,
		input 	wire                  		MASTER_ARREADY,
		
		// Master Read Data Ports
		input wire [ID_WIDTH-1:0]      		MASTER_RID,
		input wire [DATA_WIDTH-1:0]     	MASTER_RDATA,
		input wire [1:0]                    MASTER_RRESP,
		input wire                          MASTER_RLAST,
		input wire [USER_WIDTH-1:0]         MASTER_RUSER,
		input wire                          MASTER_RVALID,
		output wire                          MASTER_RREADY,
 
 		// Master Write Address Ports
		output  wire [ID_WIDTH-1:0]        	MASTER_AWID,
		output  wire [ADDR_WIDTH-1:0]      	MASTER_AWADDR,
		output  wire [7:0]                 	MASTER_AWLEN,
		output  wire [2:0]                 	MASTER_AWSIZE,
		output  wire [1:0]                 	MASTER_AWBURST,
		output  wire [1:0]                 	MASTER_AWLOCK,
		output  wire [3:0]                 	MASTER_AWCACHE,
		output  wire [2:0]                 	MASTER_AWPROT,
		output  wire [3:0]                 	MASTER_AWREGION,		// not used
		output  wire [3:0]                 	MASTER_AWQOS,			// not used
		output  wire [USER_WIDTH-1:0]      	MASTER_AWUSER,
		output  wire                       	MASTER_AWVALID,
		input 	wire                  		MASTER_AWREADY,
		
		// Master Write Data Ports
		output wire [ID_WIDTH-1:0]     	MASTER_WID,
		output wire [DATA_WIDTH-1:0]     	MASTER_WDATA,
		output wire [(DATA_WIDTH/8)-1:0]    MASTER_WSTRB,
		output wire                         MASTER_WLAST,
		output wire [USER_WIDTH-1:0]        MASTER_WUSER,
		output wire                         MASTER_WVALID,
		input  wire                         MASTER_WREADY,
  
		// Master Write Response Ports
		input  wire [ID_WIDTH-1:0]			MASTER_BID,
		input  wire [1:0]                   MASTER_BRESP,
		input  wire [USER_WIDTH-1:0]        MASTER_BUSER,
		input  wire      	                MASTER_BVALID,
		output wire	  	                    MASTER_BREADY,
   
		// ===============  Control Signals  =======================================================//
		input wire							MASTER_RREADY_Default,	// defines whether Master asserts ready or waits for RVALID
		input wire							MASTER_WREADY_Default,	// defines whether Master asserts ready or waits for wVALID
		input wire							d_MASTER_BREADY_default,
		input wire							rdStart,				// defines whether Master starts a transaction
		input wire [7:0]					rdBurstLen,				// burst length of read transaction
		input wire [ADDR_WIDTH-1:0]			rdStartAddr,			// start addresss for read transaction
		input wire [ID_WIDTH-1:0]			rdAID,					// AID for read transactions
		input wire [2:0]					rdASize,				// each transfer size
		input wire [1:0]					expRResp,				// indicate Read Respons expected
		
		output wire							masterRdAddrDone,		// Address Read transaction has been completed
		output wire							masterRdDone,			// Asserted when a read transaction has been completed
		output wire							masterRdStatus,			// Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
		output wire							mstRAddrIdle,			// indicates Read Address Bus is idle

		input wire							wrStart,				// defines whether Master starts a transaction
		input wire [1:0]					BurstType,				
		input wire [7:0]					wrBurstLen,				// burst length of write transaction
		input wire [ADDR_WIDTH-1:0]			wrStartAddr,			// start addresss for write transaction
		input wire [ID_WIDTH-1:0]			wrAID,					// AID for write transactions
		input wire [2:0]					wrASize,				// each transfer size
		input wire [1:0]					expWResp,				// indicate Read Respons expected
		
		output wire							masterWrAddrDone,		// Address Write transaction has been completed
		output wire							masterWrDone,			// Asserted when a write transaction has been completed
		output wire							masterRespDone,			// Asserted when a write response transaction has completed
		output wire							masterWrStatus,			// Status of read transaction - Pass =1, Fail=0. Only valid when masterRespDone asserted
		output wire							mstWAddrIdle,			// indicates Read Address Bus is idle
		output wire							mstWrAddrFull,			// Asserted when the internal queue for writes are full
		output wire							mstRdAddrFull			// Asserted when the internal queue for writes are full
		

		
	);
	
	
//==========================================Local reg========================================

	wire [ID_WIDTH-1:0]        	ARID;
	wire [ADDR_WIDTH-1:0]      	ARADDR;
	wire [7:0]                 	ARLEN;
	wire [2:0]                 	ARSIZE;
	wire [1:0]                 	ARBURST;
	wire [1:0]                 	ARLOCK;
	wire [3:0]                 	ARCACHE;
	wire [2:0]                 	ARPROT;
	wire [3:0]                 	ARREGION;		// not used
	wire [3:0]                 	ARQOS;			// not used
	wire [USER_WIDTH-1:0]      	ARUSER;
	wire                       	ARVALID;
	wire                  		ARREADY;
		
	// Master Read Data Ports
	wire [ID_WIDTH-1:0]      	RID;
	wire [DATA_WIDTH-1:0]     	RDATA;
	wire [1:0]                  RRESP;
	wire                        RLAST;
	wire [USER_WIDTH-1:0]       RUSER;
	wire                        RVALID;
	wire                        RREADY;
 
 	// Master Write Address Ports
	wire [ID_WIDTH-1:0]        	AWID;
	wire [ADDR_WIDTH-1:0]      	AWADDR;
	wire [7:0]                 	AWLEN;
	wire [2:0]                 	AWSIZE;
	wire [1:0]                 	AWBURST;
	wire [1:0]                 	AWLOCK;
	wire [3:0]                 	AWCACHE;
	wire [2:0]                 	AWPROT;
	wire [3:0]                 	AWREGION;		// not used
	wire [3:0]                 	AWQOS;			// not used
	wire [USER_WIDTH-1:0]      	AWUSER;
	wire                       	AWVALID;
	wire                  		AWREADY;
		
	// Master Write Data Ports
	reg [ID_WIDTH-1:0]     		WID;
	wire [DATA_WIDTH-1:0]     	WDATA;
	wire [(DATA_WIDTH/8)-1:0]   WSTRB;
	wire                        WLAST;
	wire [USER_WIDTH-1:0]       WUSER;
	wire                        WVALID;
	wire                        WREADY;
  
	// Master Write Response Ports
	wire [ID_WIDTH-1:0]			BID;
	wire [1:0]                  BRESP;
	wire [USER_WIDTH-1:0]       BUSER;
	wire      	                BVALID;
	wire	  	                BREADY;
	/////////////////////////////////////
//modifiable signals depending on protocol
	reg [3:0] 				mstrAWQOS;
	reg [3:0] 				mstrAWREGION;
	reg [USER_WIDTH-1:0] 	mstrAWUSER;
	reg [USER_WIDTH-1:0] 	mstrWUSER;

	reg [3:0] 				mstrARQOS;
	reg [3:0] 				mstrARREGION;
	reg [USER_WIDTH-1:0] 	mstrARUSER;
	
	reg [ID_WIDTH-1:0] 		mstrAWID;
	reg [ID_WIDTH-1:0] 		mstrWID;
	reg [ID_WIDTH-1:0] 		tempWID;
	reg [ID_WIDTH-1:0] 		tempBID;
	reg [ID_WIDTH-1:0]		mstrBID;
	reg [ID_WIDTH-1:0]		mstrRID;
	reg [ID_WIDTH-1:0]		mstrARID;
	reg [ID_WIDTH-1:0]		tempARID;
	reg 			 		mstrWLAST;
	reg [3:0] 				mstrAWCACHE;
	reg [3:0] 				mstrARCACHE;
	reg [7:0] 				mstrAWLEN;
	reg [7:0] 				mstrARLEN;
	reg [1:0] 				mstrAWLOCK;
	reg [1:0] 				mstrARLOCK;
	
	
	
//=======================================================


// Master Read Address Ports
assign MASTER_ARID = mstrARID;
assign MASTER_ARADDR = ARADDR;
assign MASTER_ARLEN = mstrARLEN;
assign MASTER_ARSIZE = ARSIZE;
assign MASTER_ARBURST = ARBURST;
assign MASTER_ARLOCK = mstrARLOCK;
assign MASTER_ARCACHE = mstrARCACHE;
assign MASTER_ARPROT = ARPROT;
assign MASTER_ARREGION = mstrARREGION;
assign MASTER_ARQOS = mstrARQOS;
assign MASTER_ARUSER = mstrARUSER;
assign MASTER_ARVALID = ARVALID;
assign ARREADY = MASTER_ARREADY;

// Master Read Data Ports
assign RID = mstrRID;
assign RDATA = MASTER_RDATA;
assign RRESP = MASTER_RRESP;
assign RLAST = MASTER_RLAST;
assign RUSER = MASTER_RUSER;
assign RVALID = MASTER_RVALID;		
assign MASTER_RREADY = RREADY;

// Master Write Address Ports
assign MASTER_AWID = mstrAWID;
assign MASTER_AWADDR = AWADDR;
assign MASTER_AWLEN = mstrAWLEN;
assign MASTER_AWSIZE = AWSIZE;
assign MASTER_AWBURST = AWBURST;
assign MASTER_AWLOCK  = mstrAWLOCK;
assign MASTER_AWCACHE = mstrAWCACHE;
assign MASTER_AWPROT = AWPROT;
assign MASTER_AWREGION = mstrAWREGION;
assign MASTER_AWQOS = mstrAWQOS;
assign MASTER_AWUSER = mstrAWUSER;
assign MASTER_AWVALID = AWVALID;
assign AWREADY = MASTER_AWREADY;

// Master Write Data Ports
assign MASTER_WID = mstrWID;
assign MASTER_WDATA = WDATA;
assign MASTER_WSTRB = WSTRB;
assign MASTER_WLAST = mstrWLAST;
assign MASTER_WUSER = mstrWUSER;
assign MASTER_WVALID = WVALID;
assign WREADY = MASTER_WREADY;

// Master Write Response Ports
assign BID = mstrBID;
assign BRESP = MASTER_BRESP;
assign BUSER = MASTER_BUSER;
assign BVALID = MASTER_BVALID;
assign MASTER_BREADY = BREADY;



always @( * )
		begin
			  if (MASTER_TYPE == 2'b01)// if AXI4Lite
			  begin
				//signals not supported by AXI4Lite
				mstrAWQOS = 0;
				mstrAWREGION = 0;
				mstrAWUSER = 0;
				mstrWUSER = 0;
				mstrARQOS = 0;
				mstrARREGION = 0;
				mstrARUSER = 0;
				//xID values are not supported by AXI4Lite protocol; all transactions must be sequential
				mstrWID <= 0;
				mstrARID <= 0;
				mstrAWID <= 0;
				//signals defined by AXI4Lite protocol
				mstrAWCACHE <= 0; 
				mstrARCACHE <= 0;
				
				if (AWLEN > 0)
				begin
					$display( "%t  WARNING: AXI4Lite supports only transaction length of 1 ", $time );
				end
				if (ARLEN > 0)
				begin
					$display( "%t  WARNING: AXI4Lite supports only transaction length of 1 ", $time );
				end
				//xID values are not supported by AXI4Lite protocol; 
				if (MASTER_AWVALID)
				begin
					tempBID <= AWID;	
				end
				if (MASTER_BVALID)
				begin
					mstrBID <= tempBID;
				end
				if (MASTER_ARVALID)
				begin
					tempARID <= ARID;	
				end
				if (MASTER_RVALID)
				begin
					mstrRID <= tempARID;
				end

				if (WVALID)
				begin
					mstrWLAST <= WLAST;
				end
				
				mstrAWLEN <= 0;
				mstrARLEN <= 0;
				mstrAWLOCK  <= 0 ;
				mstrARLOCK <= 0;
			  end
			  else if((MASTER_TYPE == 2'b11) | (MASTER_TYPE == 2'b10))//AXI3
			  begin
			  //signals not supported by AXI3
				mstrAWQOS = 0;
				mstrAWREGION = 0;
				mstrAWUSER = 0;
				mstrWUSER = 0;
				mstrARQOS = 0;
				mstrARREGION = 0;
				mstrARUSER = 0;

				
				//required only for AXI3
				if (MASTER_AWVALID)
				begin
					tempWID <= AWID;
				end
				if (MASTER_WVALID)
				begin
					mstrWID <=tempWID;
				end
				
				if (AWLEN > 15)
				begin
					$display( "%t  WARNING: AXI3 support transaction length up to 16 ", $time );
				end
				mstrAWLEN[7:4] <= AWLEN[7:4]; // by protocol should be 0
				mstrAWLEN[3:0] <= AWLEN[3:0];
				
				if (ARLEN > 15)
				begin
					$display( "%t  WARNING: AXI3 support transaction length up to 16 ", $time );
				end
				mstrARLEN[7:4] <= ARLEN[7:4];// by protocol should be 0
				mstrARLEN[3:0] <= ARLEN[3:0];
				
				mstrAWID <= AWID;
				mstrWLAST <= WLAST;
				mstrAWCACHE <= AWCACHE; 
				mstrARCACHE <= ARCACHE;
				mstrAWLOCK  <= AWLOCK;
				mstrARLOCK <= ARLOCK;
				mstrBID <= MASTER_BID;
				mstrARID <= ARID;
				mstrRID <= MASTER_RID;
			  end
			  else //AXI4
			  begin
			    mstrAWID <= AWID;
				mstrAWQOS <= AWQOS;
				mstrAWREGION <= AWREGION;
				mstrAWUSER <= AWUSER;
				mstrWUSER <= WUSER;
				mstrARQOS <= ARQOS;
				mstrARREGION <= ARREGION;
				mstrARUSER <= ARUSER;
				mstrWID <= 0;
				mstrWLAST <= WLAST;
				mstrAWCACHE <= AWCACHE; 
				mstrARCACHE <= ARCACHE;
				mstrAWLEN <= AWLEN;
				mstrARLEN <= ARLEN;
				mstrAWLOCK  <= AWLOCK;
				mstrARLOCK <= ARLOCK;
				mstrBID <= MASTER_BID;
				mstrARID <= ARID;
				mstrRID <= MASTER_RID;
			  end
		end
  

	//====================================================================================================================================
	// AXI4 Master transactor models - one for each mirrored master interface
	//====================================================================================================================================	
	Axi4MasterGen # 
				(
					.MASTER_NUM( MASTER_NUM ),		// slave number
					.ID_WIDTH( ID_WIDTH ),

					.ADDR_WIDTH( ADDR_WIDTH ),				
					.DATA_WIDTH( DATA_WIDTH ), 
					.SUPPORT_USER_SIGNALS( SUPPORT_USER_SIGNALS ),
					.USER_WIDTH( USER_WIDTH ),
					.OPENTRANS_MAX( OPENTRANS_MAX )	// Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.
				)
			mst0	(
					// Global Signals
					.sysClk( sysClk ),
					.ARESETN( ARESETN ),				// active high reset synchronoise to RE AClk - asserted async.
					
					// Master Read Address Ports
					.MASTER_ARID	( ARID ),
					.MASTER_ARADDR	( ARADDR ),
					.MASTER_ARLEN	( ARLEN ),
					.MASTER_ARSIZE	( ARSIZE ),
					.MASTER_ARBURST	( ARBURST ),
					.MASTER_ARLOCK	( ARLOCK ),
					.MASTER_ARCACHE	( ARCACHE ),
					.MASTER_ARPROT	( ARPROT ),
					.MASTER_ARREGION( ARREGION ),		// not used
					.MASTER_ARQOS	( ARQOS ),			// not used
					.MASTER_ARUSER	( ARUSER ),
					.MASTER_ARVALID	( ARVALID ),
					.MASTER_ARREADY	( ARREADY ),

					// Master Read Data Ports
					.MASTER_RID		( RID ),
					.MASTER_RDATA	( RDATA ),
					.MASTER_RRESP	( RRESP ),
					.MASTER_RLAST	( RLAST ),
					.MASTER_RUSER	( RUSER ),
					.MASTER_RVALID	( RVALID ),
					.MASTER_RREADY	( RREADY ),
					

					// Master Write Address Ports
					.MASTER_AWID	( AWID ),
					.MASTER_AWADDR	( AWADDR ),
					.MASTER_AWLEN	( AWLEN ),
					.MASTER_AWSIZE	( AWSIZE ),
					.MASTER_AWBURST	( AWBURST ),
					.MASTER_AWLOCK	( AWLOCK ),
					.MASTER_AWCACHE	( AWCACHE ),
					.MASTER_AWPROT	( AWPROT ),
					.MASTER_AWREGION( AWREGION ),		// not used
		          	.MASTER_AWQOS	( AWQOS ),				// not used
					.MASTER_AWUSER	( AWUSER ),
					.MASTER_AWVALID	( AWVALID ),
					.MASTER_AWREADY	( AWREADY ),
		
					// Master Write Data Ports
					.MASTER_WDATA	( WDATA ),
					.MASTER_WSTRB	( WSTRB ),
					.MASTER_WLAST	( WLAST ),
					.MASTER_WUSER	( WUSER ),
					.MASTER_WVALID	( WVALID ),
					.MASTER_WREADY	( WREADY ),


					// Master Write Response Ports
					.MASTER_BID		( BID ),
					.MASTER_BRESP	( BRESP ),
					.MASTER_BUSER	( BUSER ),
					.MASTER_BVALID	( BVALID ),
					.MASTER_BREADY	( BREADY ),
   
					// ===============  Control Signals  =======================================================//		
					.MASTER_RREADY_Default	( MASTER_RREADY_Default ),		// defines whether Master asserts ready or waits for RVALID
					.MASTER_WREADY_Default	( MASTER_WREADY_Default ),		// defines whether Master asserts ready or waits for RVALID
					.d_MASTER_BREADY_default( d_MASTER_BREADY_default ),		// defines whether Master asserts ready or waits for RVALID
					.rdStart				( rdStart ),					// defines whether Master starts a transaction
					.rdBurstLen				( rdBurstLen ),					// burst length of read transaction
					.rdStartAddr			( rdStartAddr ),				// start addresss for read transaction
					.rdAID					( rdAID ),						// AID for read transactions
					.rdASize				( rdASize  ),		
					.expRResp				( expRResp ),					// indicate Read Respons expected
					
					.masterRdAddrDone		( masterRdAddrDone ),		// Asserted when a read transaction has been completed
					.masterRdDone			( masterRdDone ),			// Asserted when a read transaction has been completed
					.masterRdStatus			( masterRdStatus ),			// Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
					.mstRAddrIdle			( mstRAddrIdle ),
		
					.wrStart				( wrStart ),					// defines whether Master starts a transaction
					.BurstType				( BurstType ),					// Type of burst - FIXED=00, INCR=01, WRAP=10 
					.wrBurstLen 			( wrBurstLen ),					// burst length of write transaction
					.wrStartAddr			( wrStartAddr ),				// start addresss for write transaction
					.wrAID					( wrAID ),						// AID for write transactions
					.wrASize				( wrASize ),
					.expWResp				( expWResp ),					// indicate Write Response expected

					.masterWrAddrDone		( masterWrAddrDone ),		// Address Write transaction has been completed
					.masterWrDone 			( masterWrDone ),			// Asserted when a write transaction has been completed
					.masterWrStatus 		( masterWrStatus ),			// Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
					.mstWAddrIdle 			( mstWAddrIdle ),			// indicates Read Address Bus is idle
					.masterRespDone			( masterRespDone ),			// Asserted when a write response transaction has completed
					.mstWrAddrFull			( mstWrAddrFull	),			// Asserted when the internal queue for writes are full
					.mstRdAddrFull			( mstRdAddrFull	)			// Asserted when the internal queue for reads are full
		);	


		
		
endmodule // AxiMaster.v
