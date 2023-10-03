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
//     Abstract  : This file provides master AHB-Lite to AXI4 conversion
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 


module caxi4interconnect_MstrAHBtoAXI4Converter #

	(
		parameter integer 	ADDR_WIDTH      	= 20,			// valid values - 16 - 64
		parameter integer 	DATA_WIDTH 			= 32,			// valid widths - 32, 64, 128, 256
		
		parameter integer 	USER_WIDTH 			= 1,			// defines the number of bits for USER signals RUSER and WUSER

                parameter [7:0]		DEF_BURST_LEN		= 8'h1,
	
		parameter integer 	ID_WIDTH   			= 1,				// number of bits for ID (ie AID, WID, BID) - valid 1-8
                parameter [31:0] BRESP_CNT_WIDTH = 'h8,
                parameter [1:0] BRESP_CHECK_MODE = 1'b0 
		
	)
	(

	//=====================================  Global Signals   ========================================================================
		input  wire                         ACLK,
		input  wire                       	sysReset,			// active low reset synchronoise to RE AClk - asserted async.
		
	output wire [ID_WIDTH-1:0] 		int_masterARID,
	output wire [ADDR_WIDTH-1:0]		int_masterARADDR,
	output wire [7:0]        		int_masterARLEN,
	output wire [2:0]          		int_masterARSIZE,
	output wire [1:0]          		int_masterARBURST,
	output wire [1:0]          		int_masterARLOCK,
	output wire [3:0]           		int_masterARCACHE,
	output wire [2:0]         		int_masterARPROT,
	output wire [3:0]          		int_masterARREGION,
	output wire [3:0]          		int_masterARQOS,
	output wire [USER_WIDTH-1:0]		int_masterARUSER,
	output wire            			int_masterARVALID,
	input wire             			int_masterARREADY,

	// Master Read Data Ports	
	input wire [ID_WIDTH-1:0]   	int_masterRID,
	input wire [DATA_WIDTH-1:0]		int_masterRDATA,
	input wire [1:0]           		int_masterRRESP,
	input wire                		int_masterRLAST,
	input wire [USER_WIDTH-1:0] 	int_masterRUSER,
	input wire                 		int_masterRVALID,
	output wire               		int_masterRREADY,

	// Master Write Address Ports	
	output wire [ID_WIDTH-1:0]  		int_masterAWID,
	output wire [ADDR_WIDTH-1:0] 	int_masterAWADDR,
	output wire [7:0]           		int_masterAWLEN,
	output wire [2:0]           		int_masterAWSIZE,
	output wire [1:0]           		int_masterAWBURST,
	output wire [1:0]           		int_masterAWLOCK,
	output wire [3:0]          		int_masterAWCACHE,
	output wire [2:0]           		int_masterAWPROT,
	output wire [3:0]            	int_masterAWREGION,
	output wire [3:0]           		int_masterAWQOS,
	output wire [USER_WIDTH-1:0]   	int_masterAWUSER,
	output wire                 		int_masterAWVALID,
	input wire                		int_masterAWREADY,
	
	// Master Write Data Ports	
	output wire [ID_WIDTH-1:0]      int_masterWID,
	output wire [DATA_WIDTH-1:0]  	int_masterWDATA,
	output wire [(DATA_WIDTH/8)-1:0]	int_masterWSTRB,
	output wire                  	int_masterWLAST,
	output wire [USER_WIDTH-1:0] 	int_masterWUSER,
	output wire                  	int_masterWVALID,
	input wire                   	int_masterWREADY,
			
	// Master Write Response Ports	
	input  wire [ID_WIDTH-1:0]		int_masterBID,
	input  wire [1:0]           	int_masterBRESP,
	input  wire [USER_WIDTH-1:0] 	int_masterBUSER,
	input  wire      				int_masterBVALID,
	output wire						int_masterBREADY,

	//================================================= External Side Ports  ================================================//
        // AHB interface
	input wire[31:0] MASTER_HADDR,
	input wire[2:0] MASTER_HBURST,
	input wire MASTER_HMASTLOCK,
	input wire[6:0] MASTER_HPROT,					
	input wire[2:0] MASTER_HSIZE,
	input wire MASTER_HNONSEC,
	input wire[1:0] MASTER_HTRANS,
	input wire[DATA_WIDTH-1:0] MASTER_HWDATA,
	output wire[DATA_WIDTH-1:0] MASTER_HRDATA,
	input wire MASTER_HWRITE,
//	input wire MASTER_HEXCL,
	input wire MASTER_HSEL,
	output wire MASTER_HREADY,
	output wire MASTER_HRESP
//	output wire MASTER_HEXOKAY

	);

	caxi4interconnect_AHB_SM #
			(
				.ID_WIDTH( ID_WIDTH ),
				.ADDR_WIDTH( ADDR_WIDTH ),				
				.DATA_WIDTH( DATA_WIDTH ),
                                .LOG_BYTE_WIDTH( $clog2(DATA_WIDTH/8) ),
				.DEF_BURST_LEN( DEF_BURST_LEN ),
				.USER_WIDTH( USER_WIDTH ),
                                .BRESP_CNT_WIDTH ( BRESP_CNT_WIDTH ),
				.BRESP_CHECK_MODE( BRESP_CHECK_MODE )
			)
	AHB_SM_i (
				// Global Signals
				.ACLK( ACLK ),
				.sysReset( sysReset ),	

				// AHB interface							
				.MASTER_HADDR			( MASTER_HADDR ),
				.MASTER_HBURST			( MASTER_HBURST ),
				.MASTER_HMASTLOCK			( MASTER_HMASTLOCK ),
				.MASTER_HPROT			( MASTER_HPROT ),					
				.MASTER_HSIZE			( MASTER_HSIZE ),
				.MASTER_HNONSEC			( MASTER_HNONSEC ),
				.MASTER_HTRANS			( MASTER_HTRANS ),
				.MASTER_HWDATA			( MASTER_HWDATA ),
				.MASTER_HRDATA			( MASTER_HRDATA ),
				.MASTER_HWRITE			( MASTER_HWRITE ),
				.MASTER_HREADY			( MASTER_HREADY),
				.MASTER_HSEL			( MASTER_HSEL ),
				.MASTER_HRESP			( MASTER_HRESP ),
//				.MASTER_HEXOKAY			( MASTER_HEXOKAY ),
//				.MASTER_HEXCL			( MASTER_HEXCL ),


				// AXI4 interface
				.int_masterARID			( int_masterARID ),
				.int_masterARADDR		( int_masterARADDR ),
				.int_masterARLEN		( int_masterARLEN ),
				.int_masterARSIZE		( int_masterARSIZE ),
				.int_masterARBURST		( int_masterARBURST ),
				.int_masterARLOCK		( int_masterARLOCK ),
				.int_masterARCACHE		( int_masterARCACHE ),
				.int_masterARPROT		( int_masterARPROT ),
				.int_masterARREGION		( int_masterARREGION ),
				.int_masterARQOS		( int_masterARQOS ),
				.int_masterARUSER		( int_masterARUSER ),
				.int_masterARVALID		( int_masterARVALID ),
				.int_masterAWQOS		( int_masterAWQOS ),
				.int_masterAWREGION		( int_masterAWREGION ),
				.int_masterAWID			( int_masterAWID ),
				.int_masterAWADDR		( int_masterAWADDR ),
				.int_masterAWLEN		( int_masterAWLEN ),
				.int_masterAWSIZE		( int_masterAWSIZE ),
				.int_masterAWBURST		( int_masterAWBURST ),
				.int_masterAWLOCK		( int_masterAWLOCK ),
				.int_masterAWCACHE		( int_masterAWCACHE ),
				.int_masterAWPROT		( int_masterAWPROT ),
				.int_masterAWUSER		( int_masterAWUSER ),
				.int_masterAWVALID		( int_masterAWVALID ),
				.int_masterWID		    ( int_masterWID ),
				.int_masterWDATA		( int_masterWDATA ),
				.int_masterWSTRB		( int_masterWSTRB ),
				.int_masterWLAST		( int_masterWLAST ),
				.int_masterWUSER		( int_masterWUSER ),
				.int_masterWVALID		( int_masterWVALID ),
				.int_masterBREADY		( int_masterBREADY ),
				.int_masterRREADY		( int_masterRREADY ),
				.int_masterARREADY 		( int_masterARREADY ),
				.int_masterRID 			( int_masterRID ),
				.int_masterRDATA 		( int_masterRDATA ),
				.int_masterRRESP 		( int_masterRRESP ),
				.int_masterRUSER 		( int_masterRUSER ),
				.int_masterBID 			( int_masterBID ),
				.int_masterBRESP 		( int_masterBRESP ),
				.int_masterBUSER 		( int_masterBUSER ),
				.int_masterRLAST 		( int_masterRLAST ),
				.int_masterRVALID 		( int_masterRVALID ),
				.int_masterAWREADY 		( int_masterAWREADY ),
				.int_masterWREADY 		( int_masterWREADY ),
				.int_masterBVALID 		( int_masterBVALID )

			)/* synthesis syn_hier = "remove" */; 

endmodule
