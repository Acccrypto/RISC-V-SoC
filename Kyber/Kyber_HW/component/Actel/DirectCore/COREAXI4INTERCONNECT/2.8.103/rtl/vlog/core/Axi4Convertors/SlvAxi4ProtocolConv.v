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
//     Abstract  : This file provides a Slave Protocol Converter. The slave side port can be
//                 AXI3 or AXI4-Lite. AXI4 bursts are broken into smaller bursts as needed by 
//                 module for AXI3 or AXI4Lite as required. Infrastructure components ensure all 
//                 ports are converted to AXI4 to be switched by caxi4interconnect_Axi4CrossBar.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_SlvAxi4ProtocolConv #
       
	(
		parameter integer 	SLAVE_NUMBER			= 0,		//current slave
		parameter [1:0] 	SLAVE_TYPE				= 2'b11,	// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11	
		
		parameter integer 	ADDR_WIDTH      		= 20,		// valid values - 16 - 64
		parameter integer 	DATA_WIDTH 				= 32,		// valid widths - 32, 64, 128, 256
		
		parameter integer 	USER_WIDTH 				= 1,		// defines the number of bits for USER signals RUSER and WUSER
	
		parameter integer 	ID_WIDTH   				= 1,		// number of bits for ID (ie AID, WID, BID) - valid 1-8 
		parameter integer 	SLV_AXI4PRT_ADDRDEPTH	= 8,		// Number transations width - 1 => 2 transations, 2 => 4 transations, etc.
		parameter integer 	SLV_AXI4PRT_DATADEPTH	= 8,			// Number transations width - 1 => 2 transations, 2 => 4 transations, etc.
		parameter integer 	MAX_TRANS           	= 8,			// Maximum transactions 
		parameter           READ_INTERLEAVE         = 1
	)
	(

	//=====================================  Global Signals   ========================================================================
	input  wire           			ACLK,
	input  wire          			sysReset,
	
	// External side
	//Slave Read Address Ports
	output wire [ID_WIDTH-1:0]  	SLAVE_ARID,
	output wire [ADDR_WIDTH-1:0]	SLAVE_ARADDR,
	output wire [7:0]           	SLAVE_ARLEN,
	output wire [2:0]        		SLAVE_ARSIZE,
	output wire [1:0]           	SLAVE_ARBURST,
	output wire [1:0]         		SLAVE_ARLOCK,
	output wire [2:0]         		SLAVE_ARPROT,
	output wire [3:0]  	        	SLAVE_ARCACHE,
	output wire            			SLAVE_ARVALID,
	
	input wire             			SLAVE_ARREADY,


	// Slave Read Data Ports
	input wire [ID_WIDTH-1:0]  		SLAVE_RID,	
	input wire [DATA_WIDTH-1:0]		SLAVE_RDATA,
	input wire [1:0]           		SLAVE_RRESP,
	input wire                  	SLAVE_RLAST,
	input wire                 		SLAVE_RVALID,
	
	output wire               		SLAVE_RREADY,
  

	// Slave Write Address Ports
	output wire [ID_WIDTH-1:0]   	SLAVE_AWID,	
	output wire [ADDR_WIDTH-1:0] 	SLAVE_AWADDR,
	output wire [3:0]           	SLAVE_AWLEN,
	output wire [2:0]           	SLAVE_AWSIZE,
	output wire [1:0]           	SLAVE_AWBURST,
	output wire [1:0]            	SLAVE_AWLOCK,
	output wire [3:0]          		SLAVE_AWCACHE,
	output wire [2:0]           	SLAVE_AWPROT,
	output wire	                 	SLAVE_AWVALID,
	
	input wire                		SLAVE_AWREADY,

	
	// Slave Write Data Ports	
	output wire [ID_WIDTH-1:0]   	SLAVE_WID,	
	output wire [DATA_WIDTH-1:0]  	SLAVE_WDATA,
	output wire [(DATA_WIDTH/8)-1:0] SLAVE_WSTRB,
	output wire                   	SLAVE_WLAST,
	output wire                  	SLAVE_WVALID,
	
	input wire                   	SLAVE_WREADY,

			
	// Slave Write Response Ports	
	input wire [ID_WIDTH-1:0]		SLAVE_BID,
	input  wire [1:0]           	SLAVE_BRESP,
	input  wire      				SLAVE_BVALID,
	
	output wire						SLAVE_BREADY,


	//================================================= Internal (XBar) Side Ports  ================================================//

	// Slave Read Address Ports	
	input  wire [ID_WIDTH-1:0]  	int_slaveARID,
	input  wire [ADDR_WIDTH-1:0]	int_slaveARADDR,
	input  wire [7:0]           	int_slaveARLEN,
	input  wire [2:0]        		int_slaveARSIZE,
	input  wire [1:0]           	int_slaveARBURST,
	input  wire [1:0]         		int_slaveARLOCK,
	input  wire [3:0]          		int_slaveARCACHE,
	input  wire [2:0]         		int_slaveARPROT,
	input  wire [3:0]          		int_slaveARREGION,
	input  wire [3:0]          		int_slaveARQOS,
	input  wire [USER_WIDTH-1:0]	int_slaveARUSER,
	input  wire                		int_slaveARVALID,
	
	output wire                		int_slaveARREADY,
	
	// Slave Read Data Ports	
	output wire [ID_WIDTH-1:0]  	int_slaveRID,
	output wire [DATA_WIDTH-1:0]  	int_slaveRDATA,
	output wire [1:0]           	int_slaveRRESP,
	output wire                  	int_slaveRLAST,
	output wire [USER_WIDTH-1:0] 	int_slaveRUSER,
	output wire               		int_slaveRVALID,
	
	input wire                 		int_slaveRREADY,
	
	// Slave Write Address Ports	
	input  wire [ID_WIDTH-1:0]   	int_slaveAWID,
	input  wire [ADDR_WIDTH-1:0] 	int_slaveAWADDR,
	input  wire [7:0]           	int_slaveAWLEN,
	input  wire [2:0]           	int_slaveAWSIZE,
	input  wire [1:0]           	int_slaveAWBURST,
	input  wire [1:0]            	int_slaveAWLOCK,
	input  wire [3:0]          		int_slaveAWCACHE,
	input  wire [2:0]           	int_slaveAWPROT,
	input  wire [3:0]           	int_slaveAWREGION,
	input  wire [3:0]           	int_slaveAWQOS,
	input  wire [USER_WIDTH-1:0] 	int_slaveAWUSER,
	input  wire                  	int_slaveAWVALID,
	output wire                		int_slaveAWREADY,
	
	// Slave Write Data Ports	
	input wire [ID_WIDTH-1:0]   	int_slaveWID,
	input wire [DATA_WIDTH-1:0]   	int_slaveWDATA,
	input wire [(DATA_WIDTH/8)-1:0]	int_slaveWSTRB,
	input wire                   	int_slaveWLAST,
	input wire [USER_WIDTH-1:0] 	int_slaveWUSER,
	input wire                  	int_slaveWVALID,
	output wire                  	int_slaveWREADY,
	
	// Slave Write Response Ports	
	output wire [ID_WIDTH-1:0]		int_slaveBID,
	output wire [1:0]           	int_slaveBRESP,
	output wire [USER_WIDTH-1:0]  	int_slaveBUSER,
	output wire      				int_slaveBVALID,
	input wire						int_slaveBREADY
	
	
	);

	//===================================================================================

	caxi4interconnect_SlvAxi4ProtConvWrite #

		(
			.SLAVE_NUMBER 		( SLAVE_NUMBER ),	
			.SLAVE_TYPE			( SLAVE_TYPE ),
			.ADDR_WIDTH 		( ADDR_WIDTH ),		
			.DATA_WIDTH 		( DATA_WIDTH ),
			.USER_WIDTH 		( USER_WIDTH ),
			.ID_WIDTH 			( ID_WIDTH ),
			.SLV_AXI4PRT_ADDRDEPTH 		( SLV_AXI4PRT_ADDRDEPTH ),
			.SLV_AXI4PRT_DATADEPTH 		( SLV_AXI4PRT_DATADEPTH ),
			.MAX_TRANS 		            ( MAX_TRANS ),
			.READ_INTERLEAVE 		    ( READ_INTERLEAVE )
		)
	SlvPCWr(
			.ACLK 				( ACLK ),
			.sysReset 			( sysReset ),
			
			.SLAVE_AWID 		( SLAVE_AWID ),	
			.SLAVE_AWADDR 		( SLAVE_AWADDR ),
			.SLAVE_AWLEN 		( SLAVE_AWLEN ),
			.SLAVE_AWSIZE 		( SLAVE_AWSIZE ),
			.SLAVE_AWBURST 		( SLAVE_AWBURST ),
			.SLAVE_AWLOCK 		( SLAVE_AWLOCK ),
			.SLAVE_AWCACHE 		( SLAVE_AWCACHE ),
			.SLAVE_AWPROT 		( SLAVE_AWPROT ),
			.SLAVE_AWVALID 		( SLAVE_AWVALID ),
			.SLAVE_AWREADY 		( SLAVE_AWREADY ),	
			.SLAVE_WID 			( SLAVE_WID ),	
			.SLAVE_WDATA 		( SLAVE_WDATA ),
			.SLAVE_WSTRB 		( SLAVE_WSTRB ),
			.SLAVE_WLAST 		( SLAVE_WLAST ),
			.SLAVE_WVALID 		( SLAVE_WVALID ),
			.SLAVE_WREADY 		( SLAVE_WREADY ),	
			.SLAVE_BID 			( SLAVE_BID ),
			.SLAVE_BRESP 		( SLAVE_BRESP ),
			.SLAVE_BVALID 		( SLAVE_BVALID ),
			.SLAVE_BREADY 		( SLAVE_BREADY ),
			.int_slaveAWID 		( int_slaveAWID ),
			.int_slaveAWADDR	( int_slaveAWADDR ),
			.int_slaveAWLEN 	( int_slaveAWLEN ),
			.int_slaveAWSIZE	( int_slaveAWSIZE ),
			.int_slaveAWBURST	( int_slaveAWBURST ),
			.int_slaveAWLOCK 	( int_slaveAWLOCK ),
			.int_slaveAWCACHE 	( int_slaveAWCACHE ),
			.int_slaveAWPROT 	( int_slaveAWPROT ),
			.int_slaveAWREGION 	( int_slaveAWREGION ),
			.int_slaveAWQOS 	( int_slaveAWQOS ),
			.int_slaveAWUSER 	( int_slaveAWUSER ),
			.int_slaveAWVALID 	( int_slaveAWVALID ),
			.int_slaveAWREADY 	( int_slaveAWREADY ),
			.int_slaveWID    	( int_slaveWID ),
			.int_slaveWDATA 	( int_slaveWDATA ),
			.int_slaveWSTRB 	( int_slaveWSTRB ),
			.int_slaveWLAST 	( int_slaveWLAST ),
			.int_slaveWUSER 	( int_slaveWUSER ),
			.int_slaveWVALID 	( int_slaveWVALID ),
			.int_slaveWREADY 	( int_slaveWREADY ),	
			.int_slaveBID 		( int_slaveBID ),
			.int_slaveBRESP		( int_slaveBRESP ),
			.int_slaveBUSER 	( int_slaveBUSER ),
			.int_slaveBVALID 	( int_slaveBVALID ),
			.int_slaveBREADY 	( int_slaveBREADY )
	);  
	
	
	//==========================================================================

	caxi4interconnect_SlvAxi4ProtConvRead #
		(
			.SLAVE_NUMBER 		( SLAVE_NUMBER ),
			.SLAVE_TYPE			( SLAVE_TYPE ),			
			.ADDR_WIDTH 		( ADDR_WIDTH ),		
			.DATA_WIDTH 		( DATA_WIDTH ),
			.USER_WIDTH 		( USER_WIDTH ),
			.ID_WIDTH 			( ID_WIDTH ),
			.SLV_AXI4PRT_ADDRDEPTH 		( SLV_AXI4PRT_ADDRDEPTH ),
			.SLV_AXI4PRT_DATADEPTH 		( SLV_AXI4PRT_DATADEPTH ),
			.READ_INTERLEAVE    		( READ_INTERLEAVE )
		)
	SlvPCRd(
	
			.ACLK 				( ACLK ),
			.sysReset 			( sysReset ),
	
			.SLAVE_ARID 		( SLAVE_ARID ),
			.SLAVE_ARADDR 		( SLAVE_ARADDR ),
			.SLAVE_ARLEN 		( SLAVE_ARLEN ),
			.SLAVE_ARSIZE 		( SLAVE_ARSIZE ),
			.SLAVE_ARBURST 		( SLAVE_ARBURST ),
			.SLAVE_ARLOCK 		( SLAVE_ARLOCK ),
			.SLAVE_ARPROT 		( SLAVE_ARPROT ),
			.SLAVE_ARCACHE 		( SLAVE_ARCACHE ),
			.SLAVE_ARVALID 		( SLAVE_ARVALID ),
			.SLAVE_ARREADY 		( SLAVE_ARREADY ),
			.SLAVE_RID 			( SLAVE_RID ),	
			.SLAVE_RDATA 		( SLAVE_RDATA ),
			.SLAVE_RRESP 		( SLAVE_RRESP ),
			.SLAVE_RLAST 		( SLAVE_RLAST ),
			.SLAVE_RVALID 		( SLAVE_RVALID ),
			.SLAVE_RREADY 		( SLAVE_RREADY ),
			.int_slaveARID 		( int_slaveARID ),
			.int_slaveARADDR 	( int_slaveARADDR ),
			.int_slaveARLEN 	( int_slaveARLEN ),
			.int_slaveARSIZE 	( int_slaveARSIZE ),
			.int_slaveARBURST 	( int_slaveARBURST ),
			.int_slaveARLOCK 	( int_slaveARLOCK ),
			.int_slaveARCACHE 	( int_slaveARCACHE ),
			.int_slaveARPROT 	( int_slaveARPROT ),
			.int_slaveARREGION 	( int_slaveARREGION ),
			.int_slaveARQOS 	( int_slaveARQOS ),
			.int_slaveARUSER 	( int_slaveARUSER ),
			.int_slaveARVALID 	( int_slaveARVALID ),
			.int_slaveARREADY 	( int_slaveARREADY ),
			.int_slaveRID 		( int_slaveRID ),
			.int_slaveRDATA 	( int_slaveRDATA ),
			.int_slaveRRESP 	( int_slaveRRESP ),
			.int_slaveRLAST 	( int_slaveRLAST ),
			.int_slaveRUSER 	( int_slaveRUSER ),
			.int_slaveRVALID 	( int_slaveRVALID ),
			.int_slaveRREADY 	( int_slaveRREADY )
	);

//==========================================================================

	
	
endmodule	// caxi4interconnect_SlvAxi4ProtocolConv
