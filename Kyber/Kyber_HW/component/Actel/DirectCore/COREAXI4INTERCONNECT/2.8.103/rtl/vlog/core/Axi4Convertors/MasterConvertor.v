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
//     Abstract  : This file is Top level module for Master converter (AXI4, AXI3 and AXI4Lite Masters to 
//                 AXI4), Data Width converter and Slice register.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_MasterConvertor #

	(
		parameter [1:0] 	MASTER_TYPE		= 2'b10,	// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11, AHB - 2'b10
		parameter MASTER_NUMBER	= 0,		// Master number
		parameter  	AWCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter  	ARCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter  	RCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter  	WCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter  	BCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter OPEN_TRANS_MAX				= 2,	// max number of outstanding transactions per thread - valid range 1-8
		parameter integer ID_WIDTH   			= 1, 

		parameter integer ADDR_WIDTH      		= 20,
		parameter integer DATA_WIDTH 			= 16, 
		parameter integer MASTER_DATA_WIDTH		= 32,

        parameter [7:0]		DEF_BURST_LEN		= 8'h1,

		parameter integer SUPPORT_USER_SIGNALS 	= 0,
		parameter integer USER_WIDTH 			= 1,
		parameter [13:0] DWC_DATA_FIFO_DEPTH = 14'h10,
  	    parameter integer DWC_ADDR_FIFO_DEPTH_CEILING = 'h10,
	    parameter CLOCK_DOMAIN_CROSSING = 1'b0,
        parameter [31:0] AHB_BRESP_CNT_WIDTH = 'h8,
	    parameter [1:0] AHB_BRESP_CHECK_MODE = 2'b0,
	    parameter         READ_INTERLEAVE       = 1,
		parameter         NUM_THREADS           = 4
	)
	(

	//=====================================  Global Signals   ========================================================================
	input  wire           			MST_CLK,
	input  wire                             XBAR_CLK,
	input  wire          			ARESETN,
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
	input wire [DATA_WIDTH-1:0]		int_masterRDATA,
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
	output wire [ID_WIDTH-1:0]  		int_masterWID,
	output wire [DATA_WIDTH-1:0]  		int_masterWDATA,
	output wire [(DATA_WIDTH/8)-1:0]	int_masterWSTRB,
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
	input wire [ID_WIDTH-1:0]		MASTER_WID,
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
	input wire						MASTER_BREADY,

        // AHB interface
	input wire[31:0] MASTER_HADDR,
	input wire[2:0] MASTER_HBURST,
	input wire MASTER_HMASTLOCK,
	input wire[6:0] MASTER_HPROT,					
	input wire[2:0] MASTER_HSIZE,
	input wire MASTER_HNONSEC,
	input wire[1:0] MASTER_HTRANS,
	input wire[MASTER_DATA_WIDTH-1:0] MASTER_HWDATA,
	output wire[MASTER_DATA_WIDTH-1:0] MASTER_HRDATA,
	input wire MASTER_HWRITE,
	output wire MASTER_HREADY,
	output wire MASTER_HRESP,
	input wire MASTER_HSEL
//	input wire MASTER_HEXCL

	) ;

	wire MASTER_HEXOKAY;

	wire	sysReset;

	//===================================== Internal wires =======================================//
	//wires between SliceReg block and ClockDomainCrossing

	 wire [ID_WIDTH-1:0] 		prot_cdc_masterARID;
	 wire [ADDR_WIDTH-1:0]		prot_cdc_masterARADDR;
	 wire [7:0]        			prot_cdc_masterARLEN;
	 wire [2:0]          		prot_cdc_masterARSIZE;
	 wire [1:0]          		prot_cdc_masterARBURST;
	 wire [1:0]          		prot_cdc_masterARLOCK;
	 wire [3:0]           		prot_cdc_masterARCACHE;
	 wire [2:0]         		prot_cdc_masterARPROT;
	 wire [3:0]          		prot_cdc_masterARREGION;
	 wire [3:0]          		prot_cdc_masterARQOS;
	 wire [USER_WIDTH-1:0]		prot_cdc_masterARUSER;
	 wire            			prot_cdc_masterARVALID;
	 wire             			prot_cdc_masterARREADY;

	// Master Read Data Ports	
	 wire [ID_WIDTH-1:0]   		prot_cdc_masterRID;
	 wire [MASTER_DATA_WIDTH-1:0]		prot_cdc_masterRDATA;
	 wire [1:0]           		prot_cdc_masterRRESP;
	 wire                		prot_cdc_masterRLAST;
	 wire [USER_WIDTH-1:0] 		prot_cdc_masterRUSER;
	 wire                 		prot_cdc_masterRVALID;
	 wire               		prot_cdc_masterRREADY;

	// Master Write Address Ports	
	 wire [ID_WIDTH-1:0]  		prot_cdc_masterAWID;
	 wire [ADDR_WIDTH-1:0] 		prot_cdc_masterAWADDR;
	 wire [7:0]           		prot_cdc_masterAWLEN;
	 wire [2:0]           		prot_cdc_masterAWSIZE;
	 wire [1:0]           		prot_cdc_masterAWBURST;
	 wire [1:0]           		prot_cdc_masterAWLOCK;
	 wire [3:0]          		prot_cdc_masterAWCACHE;
	 wire [2:0]           		prot_cdc_masterAWPROT;
	 wire [3:0]            		prot_cdc_masterAWREGION;
	 wire [3:0]           		prot_cdc_masterAWQOS;
	 wire [USER_WIDTH-1:0]  	prot_cdc_masterAWUSER;
	 wire                 		prot_cdc_masterAWVALID;
	 wire                		prot_cdc_masterAWREADY;
	
	// Master Write Data Ports	
	 wire [ID_WIDTH-1:0]        prot_cdc_masterWID;
	 wire [MASTER_DATA_WIDTH-1:0]  	prot_cdc_masterWDATA;
	 wire [(MASTER_DATA_WIDTH/8)-1:0]	prot_cdc_masterWSTRB;
	 wire                  		prot_cdc_masterWLAST;
	 wire [USER_WIDTH-1:0] 		prot_cdc_masterWUSER;
	 wire                  		prot_cdc_masterWVALID;
	 wire                   	prot_cdc_masterWREADY;
			
	// Master Write Response Ports	
	 wire [ID_WIDTH-1:0]		prot_cdc_masterBID;
	 wire [1:0]           		prot_cdc_masterBRESP;
	 wire [USER_WIDTH-1:0] 		prot_cdc_masterBUSER;
	 wire      					prot_cdc_masterBVALID;
	 wire						prot_cdc_masterBREADY;

	//===================================== Internal wires =======================================//
	//wires between SliceReg block and caxi4interconnect_MstrProtocolConverter

	 wire [ID_WIDTH-1:0] 		dwc_sr_masterARID;
	 wire [ADDR_WIDTH-1:0]		dwc_sr_masterARADDR;
	 wire [7:0]        			dwc_sr_masterARLEN;
	 wire [2:0]          		dwc_sr_masterARSIZE;
	 wire [1:0]          		dwc_sr_masterARBURST;
	 wire [1:0]          		dwc_sr_masterARLOCK;
	 wire [3:0]           		dwc_sr_masterARCACHE;
	 wire [2:0]         		dwc_sr_masterARPROT;
	 wire [3:0]          		dwc_sr_masterARREGION;
	 wire [3:0]          		dwc_sr_masterARQOS;
	 wire [USER_WIDTH-1:0]		dwc_sr_masterARUSER;
	 wire            			dwc_sr_masterARVALID;
	 wire             			dwc_sr_masterARREADY;

	// Master Read Data Ports	
	 wire [ID_WIDTH-1:0]   		dwc_sr_masterRID;
	 wire [DATA_WIDTH-1:0]		dwc_sr_masterRDATA;
	 wire [1:0]           		dwc_sr_masterRRESP;
	 wire                		dwc_sr_masterRLAST;
	 wire [USER_WIDTH-1:0] 		dwc_sr_masterRUSER;
	 wire                 		dwc_sr_masterRVALID;
	 wire               		dwc_sr_masterRREADY;

	// Master Write Address Ports	
	 wire [ID_WIDTH-1:0]  		dwc_sr_masterAWID;
	 wire [ADDR_WIDTH-1:0] 		dwc_sr_masterAWADDR;
	 wire [7:0]           		dwc_sr_masterAWLEN;
	 wire [2:0]           		dwc_sr_masterAWSIZE;
	 wire [1:0]           		dwc_sr_masterAWBURST;
	 wire [1:0]           		dwc_sr_masterAWLOCK;
	 wire [3:0]          		dwc_sr_masterAWCACHE;
	 wire [2:0]           		dwc_sr_masterAWPROT;
	 wire [3:0]            		dwc_sr_masterAWREGION;
	 wire [3:0]           		dwc_sr_masterAWQOS;
	 wire [USER_WIDTH-1:0]  	dwc_sr_masterAWUSER;
	 wire                 		dwc_sr_masterAWVALID;
	 wire                		dwc_sr_masterAWREADY;
	
	// Master Write Data Ports	
	 wire [ID_WIDTH-1:0]        dwc_sr_masterWID;
	 wire [DATA_WIDTH-1:0]  	dwc_sr_masterWDATA;
	 wire [(DATA_WIDTH/8)-1:0]	dwc_sr_masterWSTRB;
	 wire                  		dwc_sr_masterWLAST;
	 wire [USER_WIDTH-1:0] 		dwc_sr_masterWUSER;
	 wire                  		dwc_sr_masterWVALID;
	 wire                   	dwc_sr_masterWREADY;
			
	// Master Write Response Ports	
	 wire [ID_WIDTH-1:0]		dwc_sr_masterBID;
	 wire [1:0]           		dwc_sr_masterBRESP;
	 wire [USER_WIDTH-1:0] 		dwc_sr_masterBUSER;
	 wire      					dwc_sr_masterBVALID;
	 wire						dwc_sr_masterBREADY;
	 
	 
//===================================== Internal wires =======================================//
//wires between caxi4interconnect_MstrProtocolConverter block and next block

	 wire [ID_WIDTH-1:0] 		cdc_dwc_masterARID;
	 wire [ADDR_WIDTH-1:0]		cdc_dwc_masterARADDR;
	 wire [7:0]        			cdc_dwc_masterARLEN;
	 wire [2:0]          		cdc_dwc_masterARSIZE;
	 wire [1:0]          		cdc_dwc_masterARBURST;
	 wire [1:0]          		cdc_dwc_masterARLOCK;
	 wire [3:0]           		cdc_dwc_masterARCACHE;
	 wire [2:0]         		cdc_dwc_masterARPROT;
	 wire [3:0]          		cdc_dwc_masterARREGION;
	 wire [3:0]          		cdc_dwc_masterARQOS;
	 wire [USER_WIDTH-1:0]		cdc_dwc_masterARUSER;
	 wire            			cdc_dwc_masterARVALID;
	 wire             			cdc_dwc_masterARREADY;

	// Master Read Data Ports	
	 wire [ID_WIDTH-1:0]   		cdc_dwc_masterRID;
	 wire [MASTER_DATA_WIDTH-1:0]		cdc_dwc_masterRDATA;
	 wire [1:0]           		cdc_dwc_masterRRESP;
	 wire                		cdc_dwc_masterRLAST;
	 wire [USER_WIDTH-1:0] 		cdc_dwc_masterRUSER;
	 wire                 		cdc_dwc_masterRVALID;
	 wire               		cdc_dwc_masterRREADY;

	// Master Write Address Ports	
	 wire [ID_WIDTH-1:0]  		cdc_dwc_masterAWID;
	 wire [ADDR_WIDTH-1:0] 		cdc_dwc_masterAWADDR;
	 wire [7:0]           		cdc_dwc_masterAWLEN;
	 wire [2:0]           		cdc_dwc_masterAWSIZE;
	 wire [1:0]           		cdc_dwc_masterAWBURST;
	 wire [1:0]           		cdc_dwc_masterAWLOCK;
	 wire [3:0]          		cdc_dwc_masterAWCACHE;
	 wire [2:0]           		cdc_dwc_masterAWPROT;
	 wire [3:0]            		cdc_dwc_masterAWREGION;
	 wire [3:0]           		cdc_dwc_masterAWQOS;
	 wire [USER_WIDTH-1:0]  	cdc_dwc_masterAWUSER;
	 wire                 		cdc_dwc_masterAWVALID;
	 wire                		cdc_dwc_masterAWREADY;
	
	// Master Write Data Ports	
	 wire [ID_WIDTH-1:0]        cdc_dwc_masterWID;
	 wire [MASTER_DATA_WIDTH-1:0]  	cdc_dwc_masterWDATA;
	 wire [(MASTER_DATA_WIDTH/8)-1:0]	cdc_dwc_masterWSTRB;
	 wire                  		cdc_dwc_masterWLAST;
	 wire [USER_WIDTH-1:0] 		cdc_dwc_masterWUSER;
	 wire                  		cdc_dwc_masterWVALID;
	 wire                   	cdc_dwc_masterWREADY;
			 
	// Master Write Response Ports	
	 wire [ID_WIDTH-1:0]		cdc_dwc_masterBID;
	 wire [1:0]           		cdc_dwc_masterBRESP;
	 wire [USER_WIDTH-1:0] 		cdc_dwc_masterBUSER;
	 wire      					cdc_dwc_masterBVALID;
	 wire						cdc_dwc_masterBREADY;




	//=======================================================================================================================
	// Local system reset - asserted asynchronously to MST_CLK and deasserted synchronous
	//=======================================================================================================================
	generate
	if(CLOCK_DOMAIN_CROSSING) 
	  begin
	    caxi4interconnect_ResetSycnc  
	    	rsync(
	    			.sysClk	( MST_CLK ),
	    			.sysReset_L( ARESETN ),			// active low reset synchronoise to RE AClk - asserted async.
	    			.sysReset( sysReset  )			// active low sysReset synchronised to MST_CLK
	    );	
      end
	else
	  begin
	    assign sysReset = ACLK_syncReset;
      end
	endgenerate
	
	
	caxi4interconnect_RegisterSlice #

	(
		.AWCHAN	( AWCHAN_RS ),			// 0 means no slice on channel - 1 means full slice on channel
		.ARCHAN	( ARCHAN_RS ),			// 0 means no slice on channel - 1 means full slice on channel
		.RCHAN	( RCHAN_RS ),			// 0 means no slice on channel - 1 means full slice on channel
		.WCHAN	( WCHAN_RS ),			// 0 means no slice on channel - 1 means full slice on channel
		.BCHAN	( BCHAN_RS ),			// 0 means no slice on channel - 1 means full slice on channel
		.ID_WIDTH   			( ID_WIDTH ), 
		.ADDR_WIDTH      		( ADDR_WIDTH ),
		.DATA_WIDTH 			( DATA_WIDTH ), 
		.SUPPORT_USER_SIGNALS 	( SUPPORT_USER_SIGNALS ),
		.USER_WIDTH 			( USER_WIDTH )
	)
rgsl(

	//=====================================  Global Signals   ========================================================================
	.sysClk	( XBAR_CLK ),
	.sysReset	( ACLK_syncReset ),
  
	// Read Address Channel
	.srcARID	( dwc_sr_masterARID ),
	.srcARADDR	( dwc_sr_masterARADDR ),
	.srcARLEN	( dwc_sr_masterARLEN ),
	.srcARSIZE	( dwc_sr_masterARSIZE ),
	.srcARBURST	( dwc_sr_masterARBURST ),
	.srcARLOCK	( dwc_sr_masterARLOCK ),
	.srcARCACHE	( dwc_sr_masterARCACHE ),
	.srcARPROT	( dwc_sr_masterARPROT ),
	.srcARREGION( dwc_sr_masterARREGION ),
	.srcARQOS	( dwc_sr_masterARQOS ),
	.srcARUSER	( dwc_sr_masterARUSER ),
	.srcARVALID	( dwc_sr_masterARVALID ),
	.srcARREADY	( dwc_sr_masterARREADY ),
	
	.dstARID	( int_masterARID ),
	.dstARADDR	( int_masterARADDR ),
	.dstARLEN	( int_masterARLEN ),
	.dstARSIZE	( int_masterARSIZE ),
	.dstARBURST	( int_masterARBURST ),
	.dstARLOCK	( int_masterARLOCK ),
	.dstARCACHE	( int_masterARCACHE ),
	.dstARPROT	( int_masterARPROT ),
	.dstARREGION( int_masterARREGION ),
	.dstARQOS	( int_masterARQOS ),
	.dstARUSER	( int_masterARUSER ),
	.dstARVALID	( int_masterARVALID ),
	.dstARREADY	( int_masterARREADY ),
	
	// Read Data Channel	
	.srcRID		( dwc_sr_masterRID ),
	.srcRDATA	( dwc_sr_masterRDATA ), // Output from this module
	.srcRRESP	( dwc_sr_masterRRESP ),
	.srcRLAST	( dwc_sr_masterRLAST ),
	.srcRUSER	( dwc_sr_masterRUSER ),
	.srcRVALID	( dwc_sr_masterRVALID ),
	.srcRREADY	( dwc_sr_masterRREADY ),
	
	.dstRID		( int_masterRID ),
	.dstRDATA	( int_masterRDATA ), // input to this module // sr_cdc_masterRDATA is input to this file
	.dstRRESP	( int_masterRRESP ),
	.dstRLAST	( int_masterRLAST ),
	.dstRUSER	( int_masterRUSER ),
	.dstRVALID	( int_masterRVALID ),
	.dstRREADY	( int_masterRREADY ),
	
	// Write Address Channel	
	.srcAWID	( dwc_sr_masterAWID ),
	.srcAWADDR	( dwc_sr_masterAWADDR ),
	.srcAWLEN	( dwc_sr_masterAWLEN ),
	.srcAWSIZE	( dwc_sr_masterAWSIZE ),
	.srcAWBURST	( dwc_sr_masterAWBURST ),
	.srcAWLOCK	( dwc_sr_masterAWLOCK ),
	.srcAWCACHE	( dwc_sr_masterAWCACHE ),
	.srcAWPROT	( dwc_sr_masterAWPROT ),
	.srcAWREGION( dwc_sr_masterAWREGION ),
	.srcAWQOS	( dwc_sr_masterAWQOS ),
	.srcAWUSER	( dwc_sr_masterAWUSER ),
	.srcAWVALID	( dwc_sr_masterAWVALID ),
	.srcAWREADY	( dwc_sr_masterAWREADY ),
	
	.dstAWID	( int_masterAWID ),
	.dstAWADDR	( int_masterAWADDR ),
	.dstAWLEN	( int_masterAWLEN ),
	.dstAWSIZE	( int_masterAWSIZE ),
	.dstAWBURST	( int_masterAWBURST ),
	.dstAWLOCK	( int_masterAWLOCK ),
	.dstAWCACHE	( int_masterAWCACHE ),
	.dstAWPROT	( int_masterAWPROT ),
	.dstAWREGION( int_masterAWREGION ),
	.dstAWQOS	( int_masterAWQOS ),
	.dstAWUSER	( int_masterAWUSER ),
	.dstAWVALID	( int_masterAWVALID ),
	.dstAWREADY	( int_masterAWREADY ),

	// Write Data Channel	
	.srcWID     ( dwc_sr_masterWID),
	.srcWDATA	( dwc_sr_masterWDATA ),
	.srcWSTRB	( dwc_sr_masterWSTRB ),
	.srcWLAST	( dwc_sr_masterWLAST ),
	.srcWUSER	( dwc_sr_masterWUSER ),
	.srcWVALID	( dwc_sr_masterWVALID ),
	.srcWREADY	( dwc_sr_masterWREADY ),
	
	.dstWID     ( int_masterWID),
	.dstWDATA	( int_masterWDATA ),
	.dstWSTRB	( int_masterWSTRB ),
	.dstWLAST	( int_masterWLAST ),
	.dstWUSER	( int_masterWUSER ),
	.dstWVALID	( int_masterWVALID ),
	.dstWREADY	( int_masterWREADY ),	

	// Write Response Channel	
	.srcBID	( dwc_sr_masterBID ),
	.srcBRESP	( dwc_sr_masterBRESP ),
	.srcBUSER	( dwc_sr_masterBUSER ),
	.srcBVALID	( dwc_sr_masterBVALID ),
	.srcBREADY	( dwc_sr_masterBREADY ),

	.dstBID	( int_masterBID ),
	.dstBRESP	( int_masterBRESP ),
	.dstBUSER	( int_masterBUSER ),
	.dstBVALID	( int_masterBVALID ),
	.dstBREADY	( int_masterBREADY )

	) /* synthesis syn_hier = "flatten,remove" */;	

generate
	if (MASTER_TYPE == 2'b10) begin

                                localparam BRESP_CNT_WIDTH = (AHB_BRESP_CNT_WIDTH < 2) ? 2: AHB_BRESP_CNT_WIDTH;

				caxi4interconnect_MstrAHBtoAXI4Converter #
						(
							.ID_WIDTH( ID_WIDTH ),
							.BRESP_CHECK_MODE( AHB_BRESP_CHECK_MODE ),
                                                        .BRESP_CNT_WIDTH ( BRESP_CNT_WIDTH ),
							.ADDR_WIDTH( ADDR_WIDTH ),				
							.DATA_WIDTH( MASTER_DATA_WIDTH ), 
							.DEF_BURST_LEN( DEF_BURST_LEN ),
							.USER_WIDTH( USER_WIDTH )
						)
				mstAHBtoAXI4Conv (
							// Global Signals
							.ACLK( MST_CLK ),
							.sysReset( sysReset ),	

                                                        // AHB interface							
							.MASTER_HADDR			( MASTER_HADDR ),
							.MASTER_HSEL		( MASTER_HSEL ),
							.MASTER_HBURST			( MASTER_HBURST ),
							.MASTER_HMASTLOCK			( MASTER_HMASTLOCK ),
							.MASTER_HPROT			( MASTER_HPROT ),					
							.MASTER_HSIZE			( MASTER_HSIZE ),
							.MASTER_HNONSEC			( MASTER_HNONSEC ),
							.MASTER_HTRANS			( MASTER_HTRANS ),
							.MASTER_HWDATA			( MASTER_HWDATA ),
							.MASTER_HRDATA			( MASTER_HRDATA ),
							.MASTER_HWRITE			( MASTER_HWRITE ),
							.MASTER_HREADY			( MASTER_HREADY ),
							.MASTER_HRESP			( MASTER_HRESP ),
//							.MASTER_HEXOKAY			( MASTER_HEXOKAY ),
//							.MASTER_HEXCL			( MASTER_HEXCL ),

                                                        // AXI4 interface
							.int_masterARID			( prot_cdc_masterARID ),
							.int_masterARADDR		( prot_cdc_masterARADDR ),
							.int_masterARLEN		( prot_cdc_masterARLEN ),
							.int_masterARSIZE		( prot_cdc_masterARSIZE ),
							.int_masterARBURST		( prot_cdc_masterARBURST ),
							.int_masterARLOCK		( prot_cdc_masterARLOCK ),
							.int_masterARCACHE		( prot_cdc_masterARCACHE ),
							.int_masterARPROT		( prot_cdc_masterARPROT ),
							.int_masterARREGION		( prot_cdc_masterARREGION ),
							.int_masterARQOS		( prot_cdc_masterARQOS ),
							.int_masterARUSER		( prot_cdc_masterARUSER ),
							.int_masterARVALID		( prot_cdc_masterARVALID ),
							.int_masterARREADY 		( prot_cdc_masterARREADY ),

							.int_masterAWQOS		( prot_cdc_masterAWQOS ),
							.int_masterAWREGION		( prot_cdc_masterAWREGION ),
							.int_masterAWID			( prot_cdc_masterAWID ),
							.int_masterAWADDR		( prot_cdc_masterAWADDR ),
							.int_masterAWLEN		( prot_cdc_masterAWLEN ),
							.int_masterAWSIZE		( prot_cdc_masterAWSIZE ),
							.int_masterAWBURST		( prot_cdc_masterAWBURST ),
							.int_masterAWLOCK		( prot_cdc_masterAWLOCK ),
							.int_masterAWCACHE		( prot_cdc_masterAWCACHE ),
							.int_masterAWPROT		( prot_cdc_masterAWPROT ),
							.int_masterAWUSER		( prot_cdc_masterAWUSER ),
							.int_masterAWVALID		( prot_cdc_masterAWVALID ),

							.int_masterAWREADY 		( prot_cdc_masterAWREADY ),
							.int_masterWID   		( prot_cdc_masterWID   ),
							.int_masterWDATA		( prot_cdc_masterWDATA ),
							.int_masterWSTRB		( prot_cdc_masterWSTRB ),
							.int_masterWLAST		( prot_cdc_masterWLAST ),
							.int_masterWUSER		( prot_cdc_masterWUSER ),
							.int_masterWVALID		( prot_cdc_masterWVALID ),
							.int_masterWREADY 		( prot_cdc_masterWREADY ),

							.int_masterBVALID 		( prot_cdc_masterBVALID ),
							.int_masterBID 			( prot_cdc_masterBID ),
							.int_masterBUSER 		( prot_cdc_masterBUSER ),
							.int_masterBRESP 		( prot_cdc_masterBRESP ),
							.int_masterBREADY		( prot_cdc_masterBREADY ),

							.int_masterRREADY		( prot_cdc_masterRREADY ),
							.int_masterRID 			( prot_cdc_masterRID ),
							.int_masterRDATA 		( prot_cdc_masterRDATA ),
							.int_masterRRESP 		( prot_cdc_masterRRESP ),
							.int_masterRUSER 		( prot_cdc_masterRUSER ),
							.int_masterRLAST 		( prot_cdc_masterRLAST ),
							.int_masterRVALID 		( prot_cdc_masterRVALID )
						)/* synthesis syn_hier = "remove" */;

            assign MASTER_ARREADY = 'b0;
	
						// Master Read Data Ports	
						assign MASTER_RID     = 'b0;
						assign MASTER_RDATA   = 'b0;
				   	assign MASTER_RRESP   = 'b0;
						assign MASTER_RLAST   = 'b0;
						assign MASTER_RUSER   = 'b0;
						assign MASTER_RVALID  = 'b0;

						assign MASTER_AWREADY = 'b0;
	
							// Master Write Data Ports	
						assign MASTER_WREADY = 'b0;
	
							// Master Write Response Ports	
						assign MASTER_BID     = 'b0;
						assign MASTER_BRESP   = 'b0;
						assign MASTER_BUSER   = 'b0;
						assign MASTER_BVALID  = 'b0;
	end
	else begin	
				caxi4interconnect_MstrProtocolConverter #
						(
							.MASTER_TYPE( MASTER_TYPE ) , 		// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11
							.MASTER_NUMBER( MASTER_NUMBER ),	// master number
							.ID_WIDTH( ID_WIDTH ),
							.ADDR_WIDTH( ADDR_WIDTH ),				
							.DATA_WIDTH( MASTER_DATA_WIDTH ), 
							.USER_WIDTH( USER_WIDTH )
						)
				mstrProtConv (
							// Global Signals
							.ACLK( MST_CLK ),
							.sysReset( sysReset ),	
							
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
							.MASTER_RDATA 		( MASTER_RDATA ), // output from this module
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
							
							.int_masterARID			( prot_cdc_masterARID ),
							.int_masterARADDR		( prot_cdc_masterARADDR ),
							.int_masterARLEN		( prot_cdc_masterARLEN ),
							.int_masterARSIZE		( prot_cdc_masterARSIZE ),
							.int_masterARBURST		( prot_cdc_masterARBURST ),
							.int_masterARLOCK		( prot_cdc_masterARLOCK ),
							.int_masterARCACHE		( prot_cdc_masterARCACHE ),
							.int_masterARPROT		( prot_cdc_masterARPROT ),
							.int_masterARREGION		( prot_cdc_masterARREGION ),
							.int_masterARQOS		( prot_cdc_masterARQOS ),
							.int_masterARUSER		( prot_cdc_masterARUSER ),
							.int_masterARVALID		( prot_cdc_masterARVALID ),
							.int_masterAWQOS		( prot_cdc_masterAWQOS ),
							.int_masterAWREGION		( prot_cdc_masterAWREGION ),
							.int_masterAWID			( prot_cdc_masterAWID ),
							.int_masterAWADDR		( prot_cdc_masterAWADDR ),
							.int_masterAWLEN		( prot_cdc_masterAWLEN ),
							.int_masterAWSIZE		( prot_cdc_masterAWSIZE ),
							.int_masterAWBURST		( prot_cdc_masterAWBURST ),
							.int_masterAWLOCK		( prot_cdc_masterAWLOCK ),
							.int_masterAWCACHE		( prot_cdc_masterAWCACHE ),
							.int_masterAWPROT		( prot_cdc_masterAWPROT ),
							.int_masterAWUSER		( prot_cdc_masterAWUSER ),
							.int_masterAWVALID		( prot_cdc_masterAWVALID ),
							.int_masterWID          ( prot_cdc_masterWID),
							.int_masterWDATA		( prot_cdc_masterWDATA ),
							.int_masterWSTRB		( prot_cdc_masterWSTRB ),
							.int_masterWLAST		( prot_cdc_masterWLAST ),
							.int_masterWUSER		( prot_cdc_masterWUSER ),
							.int_masterWVALID		( prot_cdc_masterWVALID ),
							.int_masterBREADY		( prot_cdc_masterBREADY ),
							.int_masterRREADY		( prot_cdc_masterRREADY ),
							.int_masterARREADY 		( prot_cdc_masterARREADY ),
							.int_masterRID 			( prot_cdc_masterRID ),
							.int_masterRDATA 		( prot_cdc_masterRDATA ), // input to this module
							.int_masterRRESP 		( prot_cdc_masterRRESP ),
							.int_masterRUSER 		( prot_cdc_masterRUSER ),
							.int_masterBID 			( prot_cdc_masterBID ),
							.int_masterBRESP 		( prot_cdc_masterBRESP ),
							.int_masterBUSER 		( prot_cdc_masterBUSER ),
							.int_masterRLAST 		( prot_cdc_masterRLAST ),
							.int_masterRVALID 		( prot_cdc_masterRVALID ),
							.int_masterAWREADY 		( prot_cdc_masterAWREADY ),
							.int_masterWREADY 		( prot_cdc_masterWREADY ),
							.int_masterBVALID 		( prot_cdc_masterBVALID )

						)/* synthesis syn_hier = "remove" */;

						assign MASTER_HRDATA = 1'b0;
						assign MASTER_HREADY = 1'b0;
						assign MASTER_HRESP = 1'b0;
						assign MASTER_HEXOKAY = 1'b0;
	end
endgenerate						
						
caxi4interconnect_MstrDataWidthConv #
						(
							.MASTER_TYPE( MASTER_TYPE ) , 		// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11
							.MASTER_NUMBER( MASTER_NUMBER ),	// master number
							.OPEN_TRANS_MAX			( OPEN_TRANS_MAX ),
							.ID_WIDTH( ID_WIDTH ),
							.ADDR_WIDTH( ADDR_WIDTH ),				
							.DATA_WIDTH( DATA_WIDTH ), 
							.MASTER_DATA_WIDTH ( MASTER_DATA_WIDTH ),
							.USER_WIDTH( USER_WIDTH ),
							.DWC_ADDR_FIFO_DEPTH_CEILING (DWC_ADDR_FIFO_DEPTH_CEILING),
							.DATA_FIFO_DEPTH ( DWC_DATA_FIFO_DEPTH ),
							.READ_INTERLEAVE (READ_INTERLEAVE),
							.NUM_THREADS (NUM_THREADS)
							
						)
				mstrDWC (
							// Global Signals
							.ACLK( XBAR_CLK ),
							.sysReset( ACLK_syncReset ),	
		   
							// Master Read Address Ports
							.MASTER_ARID		( cdc_dwc_masterARID ),
							.MASTER_ARADDR		( cdc_dwc_masterARADDR ),
							.MASTER_ARLEN		( cdc_dwc_masterARLEN ),
							.MASTER_ARSIZE		( cdc_dwc_masterARSIZE ),
							.MASTER_ARBURST		( cdc_dwc_masterARBURST ),
							.MASTER_ARLOCK		( cdc_dwc_masterARLOCK ),
							.MASTER_ARCACHE		( cdc_dwc_masterARCACHE ),
							.MASTER_ARPROT		( cdc_dwc_masterARPROT ),
							.MASTER_ARREGION	( cdc_dwc_masterARREGION ),
							.MASTER_ARQOS		( cdc_dwc_masterARQOS ),
							.MASTER_ARUSER		( cdc_dwc_masterARUSER ),
							.MASTER_ARVALID		( cdc_dwc_masterARVALID ),
							.MASTER_AWQOS		( cdc_dwc_masterAWQOS ),
							.MASTER_AWREGION	( cdc_dwc_masterAWREGION ),
							.MASTER_AWID		( cdc_dwc_masterAWID ),
							.MASTER_AWADDR		( cdc_dwc_masterAWADDR ),
							.MASTER_AWLEN		( cdc_dwc_masterAWLEN ),
							.MASTER_AWSIZE		( cdc_dwc_masterAWSIZE ),
							.MASTER_AWBURST		( cdc_dwc_masterAWBURST ),
							.MASTER_AWLOCK		( cdc_dwc_masterAWLOCK ),
							.MASTER_AWCACHE		( cdc_dwc_masterAWCACHE ),
							.MASTER_AWPROT		( cdc_dwc_masterAWPROT ),
							.MASTER_AWUSER		( cdc_dwc_masterAWUSER ),
							.MASTER_AWVALID		( cdc_dwc_masterAWVALID ),
							.MASTER_WID         ( cdc_dwc_masterWID),
							.MASTER_WDATA		( cdc_dwc_masterWDATA ),
							.MASTER_WSTRB		( cdc_dwc_masterWSTRB ),
							.MASTER_WLAST		( cdc_dwc_masterWLAST ),
							.MASTER_WUSER		( cdc_dwc_masterWUSER ),
							.MASTER_WVALID		( cdc_dwc_masterWVALID ),
							.MASTER_BREADY		( cdc_dwc_masterBREADY ),
							.MASTER_RREADY		( cdc_dwc_masterRREADY ),
							.MASTER_ARREADY 	( cdc_dwc_masterARREADY),
							.MASTER_RID 		( cdc_dwc_masterRID ),
							.MASTER_RDATA 		( cdc_dwc_masterRDATA ), // output from this module
							.MASTER_RRESP 		( cdc_dwc_masterRRESP ),
							.MASTER_RUSER 		( cdc_dwc_masterRUSER ),
							.MASTER_BID 		( cdc_dwc_masterBID ),
							.MASTER_BRESP 		( cdc_dwc_masterBRESP ),
							.MASTER_BUSER 		( cdc_dwc_masterBUSER ),
							.MASTER_RLAST 		( cdc_dwc_masterRLAST ),
							.MASTER_RVALID 		( cdc_dwc_masterRVALID ),
							.MASTER_AWREADY 	( cdc_dwc_masterAWREADY ),
							.MASTER_WREADY 		( cdc_dwc_masterWREADY ),
							.MASTER_BVALID 		( cdc_dwc_masterBVALID ),
							
							.masterARID			( dwc_sr_masterARID ),
							.masterARADDR		( dwc_sr_masterARADDR ),
							.masterARLEN		( dwc_sr_masterARLEN ),
							.masterARSIZE		( dwc_sr_masterARSIZE ),
							.masterARBURST		( dwc_sr_masterARBURST ),
							.masterARLOCK		( dwc_sr_masterARLOCK ),
							.masterARCACHE		( dwc_sr_masterARCACHE ),
							.masterARPROT		( dwc_sr_masterARPROT ),
							.masterARREGION		( dwc_sr_masterARREGION ),
							.masterARQOS		( dwc_sr_masterARQOS ),
							.masterARUSER		( dwc_sr_masterARUSER ),
							.masterARVALID		( dwc_sr_masterARVALID ),
							.masterAWQOS		( dwc_sr_masterAWQOS ),
							.masterAWREGION		( dwc_sr_masterAWREGION ),
							.masterAWID			( dwc_sr_masterAWID ),
							.masterAWADDR		( dwc_sr_masterAWADDR ),
							.masterAWLEN		( dwc_sr_masterAWLEN ),
							.masterAWSIZE		( dwc_sr_masterAWSIZE ),
							.masterAWBURST		( dwc_sr_masterAWBURST ),
							.masterAWLOCK		( dwc_sr_masterAWLOCK ),
							.masterAWCACHE		( dwc_sr_masterAWCACHE ),
							.masterAWPROT		( dwc_sr_masterAWPROT ),
							.masterAWUSER		( dwc_sr_masterAWUSER ),
							.masterAWVALID		( dwc_sr_masterAWVALID ),
							.masterWID          ( dwc_sr_masterWID),
							.masterWDATA		( dwc_sr_masterWDATA ),
							.masterWSTRB		( dwc_sr_masterWSTRB ),
							.masterWLAST		( dwc_sr_masterWLAST ),
							.masterWUSER		( dwc_sr_masterWUSER ),
							.masterWVALID		( dwc_sr_masterWVALID ),
							.masterBREADY		( dwc_sr_masterBREADY ),
							.masterRREADY		( dwc_sr_masterRREADY ),
							.masterARREADY 		( dwc_sr_masterARREADY ),
							.masterRID 			( dwc_sr_masterRID ),
							.masterRDATA 		( dwc_sr_masterRDATA ), // Input to this module
							.masterRRESP 		( dwc_sr_masterRRESP ),
							.masterRUSER 		( dwc_sr_masterRUSER ),
							.masterBID 			( dwc_sr_masterBID ),
							.masterBRESP 		( dwc_sr_masterBRESP ),
							.masterBUSER 		( dwc_sr_masterBUSER ),
							.masterRLAST 		( dwc_sr_masterRLAST ),
							.masterRVALID 		( dwc_sr_masterRVALID ),
							.masterAWREADY 		( dwc_sr_masterAWREADY ),
							.masterWREADY 		( dwc_sr_masterWREADY ),
							.masterBVALID 		( dwc_sr_masterBVALID )

						)  /* synthesis syn_hier = "remove" */;

												
				caxi4interconnect_MstrClockDomainCrossing #
						(
							.ID_WIDTH( ID_WIDTH ),
							.ADDR_WIDTH( ADDR_WIDTH ),				
							.MASTER_DATA_WIDTH ( MASTER_DATA_WIDTH ),
							.USER_WIDTH( USER_WIDTH ),
							.CLOCK_DOMAIN_CROSSING (CLOCK_DOMAIN_CROSSING),
							.MASTER_TYPE( MASTER_TYPE ),  		// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11
							.READ_INTERLEAVE       (READ_INTERLEAVE)
						)
				mstrCDC (
							// Global Signals
							.MST_CLK( MST_CLK ),
							.XBAR_CLK( XBAR_CLK ),
							.sysReset( sysReset ),	
							.ACLK_syncReset( ACLK_syncReset ),	
		   
							// Master Read Address Ports
							.MASTER_ARID		( prot_cdc_masterARID ),
							.MASTER_ARADDR		( prot_cdc_masterARADDR ),
							.MASTER_ARLEN		( prot_cdc_masterARLEN ),
							.MASTER_ARSIZE		( prot_cdc_masterARSIZE ),
							.MASTER_ARBURST		( prot_cdc_masterARBURST ),
							.MASTER_ARLOCK		( prot_cdc_masterARLOCK ),
							.MASTER_ARCACHE		( prot_cdc_masterARCACHE ),
							.MASTER_ARPROT		( prot_cdc_masterARPROT ),
							.MASTER_ARREGION	( prot_cdc_masterARREGION ),
							.MASTER_ARQOS		( prot_cdc_masterARQOS ),
							.MASTER_ARUSER		( prot_cdc_masterARUSER ),
							.MASTER_ARVALID		( prot_cdc_masterARVALID ),
							.MASTER_AWQOS		( prot_cdc_masterAWQOS ),
							.MASTER_AWREGION	( prot_cdc_masterAWREGION ),
							.MASTER_AWID		( prot_cdc_masterAWID ),
							.MASTER_AWADDR		( prot_cdc_masterAWADDR ),
							.MASTER_AWLEN		( prot_cdc_masterAWLEN ),
							.MASTER_AWSIZE		( prot_cdc_masterAWSIZE ),
							.MASTER_AWBURST		( prot_cdc_masterAWBURST ),
							.MASTER_AWLOCK		( prot_cdc_masterAWLOCK ),
							.MASTER_AWCACHE		( prot_cdc_masterAWCACHE ),
							.MASTER_AWPROT		( prot_cdc_masterAWPROT ),
							.MASTER_AWUSER		( prot_cdc_masterAWUSER ),
							.MASTER_AWVALID		( prot_cdc_masterAWVALID ),
							.MASTER_WID         ( prot_cdc_masterWID),
							.MASTER_WDATA		( prot_cdc_masterWDATA ),
							.MASTER_WSTRB		( prot_cdc_masterWSTRB ),
							.MASTER_WLAST		( prot_cdc_masterWLAST ),
							.MASTER_WUSER		( prot_cdc_masterWUSER ),
							.MASTER_WVALID		( prot_cdc_masterWVALID ),
							.MASTER_BREADY		( prot_cdc_masterBREADY ),
							.MASTER_RREADY		( prot_cdc_masterRREADY ),
							.MASTER_ARREADY 	( prot_cdc_masterARREADY),
							.MASTER_RID 		( prot_cdc_masterRID ),
							.MASTER_RDATA 		( prot_cdc_masterRDATA ), // output from this module
							.MASTER_RRESP 		( prot_cdc_masterRRESP ),
							.MASTER_RUSER 		( prot_cdc_masterRUSER ),
							.MASTER_BID 		( prot_cdc_masterBID ),
							.MASTER_BRESP 		( prot_cdc_masterBRESP ),
							.MASTER_BUSER 		( prot_cdc_masterBUSER ),
							.MASTER_RLAST 		( prot_cdc_masterRLAST ),
							.MASTER_RVALID 		( prot_cdc_masterRVALID ),
							.MASTER_AWREADY 	( prot_cdc_masterAWREADY ),
							.MASTER_WREADY 		( prot_cdc_masterWREADY ),
							.MASTER_BVALID 		( prot_cdc_masterBVALID ),
							
							.int_masterARID			( cdc_dwc_masterARID ),
							.int_masterARADDR		( cdc_dwc_masterARADDR ),
							.int_masterARLEN		( cdc_dwc_masterARLEN ),
							.int_masterARSIZE		( cdc_dwc_masterARSIZE ),
							.int_masterARBURST		( cdc_dwc_masterARBURST ),
							.int_masterARLOCK		( cdc_dwc_masterARLOCK ),
							.int_masterARCACHE		( cdc_dwc_masterARCACHE ),
							.int_masterARPROT		( cdc_dwc_masterARPROT ),
							.int_masterARREGION		( cdc_dwc_masterARREGION ),
							.int_masterARQOS		( cdc_dwc_masterARQOS ),
							.int_masterARUSER		( cdc_dwc_masterARUSER ),
							.int_masterARVALID		( cdc_dwc_masterARVALID ),
							.int_masterAWQOS		( cdc_dwc_masterAWQOS ),
							.int_masterAWREGION		( cdc_dwc_masterAWREGION ),
							.int_masterAWID			( cdc_dwc_masterAWID ),
							.int_masterAWADDR		( cdc_dwc_masterAWADDR ),
							.int_masterAWLEN		( cdc_dwc_masterAWLEN ),
							.int_masterAWSIZE		( cdc_dwc_masterAWSIZE ),
							.int_masterAWBURST		( cdc_dwc_masterAWBURST ),
							.int_masterAWLOCK		( cdc_dwc_masterAWLOCK ),
							.int_masterAWCACHE		( cdc_dwc_masterAWCACHE ),
							.int_masterAWPROT		( cdc_dwc_masterAWPROT ),
							.int_masterAWUSER		( cdc_dwc_masterAWUSER ),
							.int_masterAWVALID		( cdc_dwc_masterAWVALID ),
							.int_masterWID          ( cdc_dwc_masterWID),
							.int_masterWDATA		( cdc_dwc_masterWDATA ),
							.int_masterWSTRB		( cdc_dwc_masterWSTRB ),
							.int_masterWLAST		( cdc_dwc_masterWLAST ),
							.int_masterWUSER		( cdc_dwc_masterWUSER ),
							.int_masterWVALID		( cdc_dwc_masterWVALID ),
							.int_masterBREADY		( cdc_dwc_masterBREADY ),
							.int_masterRREADY		( cdc_dwc_masterRREADY ),
							.int_masterARREADY 		( cdc_dwc_masterARREADY ),
							.int_masterRID 			( cdc_dwc_masterRID ),
							.int_masterRDATA 		( cdc_dwc_masterRDATA ), // Input to this module
							.int_masterRRESP 		( cdc_dwc_masterRRESP ),
							.int_masterRUSER 		( cdc_dwc_masterRUSER ),
							.int_masterBID 			( cdc_dwc_masterBID ),
							.int_masterBRESP 		( cdc_dwc_masterBRESP ),
							.int_masterBUSER 		( cdc_dwc_masterBUSER ),
							.int_masterRLAST 		( cdc_dwc_masterRLAST ),
							.int_masterRVALID 		( cdc_dwc_masterRVALID ),
							.int_masterAWREADY 		( cdc_dwc_masterAWREADY ),
							.int_masterWREADY 		( cdc_dwc_masterWREADY ),
							.int_masterBVALID 		( cdc_dwc_masterBVALID )

						)  /* synthesis syn_hier = "remove" */;

						
endmodule		// caxi4interconnect_MasterConvertor.v
