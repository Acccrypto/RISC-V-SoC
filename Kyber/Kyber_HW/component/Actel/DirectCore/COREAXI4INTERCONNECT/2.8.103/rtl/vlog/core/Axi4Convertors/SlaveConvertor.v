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
//     Abstract  : This file provides a caxi4interconnect_SlaveConvertor for AXI3, AXI4 or AXI4-Lite. Infrastructure 
//                 components ensure all ports from Crossbar are AXI4. Slave Converter converts this to 
//                 AXI4 (pass-through), AXI4Lite or AXI3 based on SLAVE_TYPE.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_SlaveConvertor #

	(
  		parameter integer 	ID_WIDTH   		= 3, 				// ID width includes infrastructure ID

		parameter integer 	SLAVE_NUMBER	= 0,				// Slave number
		
		parameter 	AWCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter 	ARCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter 	RCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter 	WCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter 	BCHAN_RS		= 0,		// 0 means no slice on channel - 1 means full slice on channel
		parameter OPEN_TRANS_MAX			= 2,	// max number of outstanding transactions per thread - valid range 1-8
		
		parameter integer 	ADDR_WIDTH      = 20,		
		parameter integer 	DATA_WIDTH 		= 16, 
		parameter integer SLAVE_DATA_WIDTH	= 32,
		
		parameter integer 	SUPPORT_USER_SIGNALS 	= 0,
		parameter integer 	USER_WIDTH 				= 1,

		parameter [1:0] SLAVE_TYPE			= 2'b00,				// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11	
		parameter [0:0] 	READ_ZERO_SLAVE_ID		= 1'b1,	// disable interleave		
		parameter [0:0] 	WRITE_ZERO_SLAVE_ID		= 1'b1,	// disable interleave		
		parameter integer 	SLV_AXI4PRT_ADDRDEPTH 		= 8,		// Number transations width - 1 => 2 transations, 2 => 4 transations, etc.
		parameter integer 	SLV_AXI4PRT_DATADEPTH		= 8,			// Number transations width - 1 => 2 transations, 2 => 4 transations, etc.
		parameter [13:0] DWC_DATA_FIFO_DEPTH = 14'h10,
  	    parameter integer DWC_ADDR_FIFO_DEPTH_CEILING = 'h10,
        parameter CLOCK_DOMAIN_CROSSING = 1'b0,
		parameter         READ_INTERLEAVE = 1,
		parameter           NUM_THREADS     = 4,
		parameter           MAX_TRANS       = 4
		
	)
	(
	
	//================================= Global Signals  ==============================================================================
	input  wire           								SLV_CLK,
	input  wire           								XBAR_CLK,
	input  wire          								ARESETN,
	input  wire          								ACLK_syncReset,
  
	//================================================= to/from CrossBar Ports  =================================================
	input wire [ID_WIDTH-1:0]							slaveARID,
	input wire [ADDR_WIDTH-1:0]          				slaveARADDR,
	input wire [7:0]                         			slaveARLEN,
	input wire [2:0]                         			slaveARSIZE,
	input wire [1:0]                         			slaveARBURST,
	input wire [1:0]                         			slaveARLOCK,
	input wire [3:0]                         			slaveARCACHE,
	input wire [2:0]                         			slaveARPROT,
	input wire [3:0]                         			slaveARREGION,			// not used
	input wire [3:0]                         			slaveARQOS,				// not used
	input wire [USER_WIDTH-1:0]	        				slaveARUSER,
	input wire                            				slaveARVALID,				
	output  wire 	                       				slaveARREADY,
   
	//=========================================  Slave Read Data Ports  =========================================================
	output  wire [ID_WIDTH-1:0]							slaveRID,
	output  wire [DATA_WIDTH-1:0]    					slaveRDATA,
	output  wire [1:0]                     				slaveRRESP,
	output  wire                         				slaveRLAST,
	output  wire [USER_WIDTH-1:0]	        		 	slaveRUSER,				// not used
	output  wire                         				slaveRVALID,
		
	input 	wire	                       				slaveRREADY,
	
	//=========================================  Slave Write Address Port  ======================================================
	input wire [ID_WIDTH-1:0]							slaveAWID,
	input wire [ADDR_WIDTH-1:0]          				slaveAWADDR,
	input wire [7:0]                         			slaveAWLEN,
	input wire [2:0]                         			slaveAWSIZE,
	input wire [1:0]                         			slaveAWBURST,
	input wire [1:0]                         			slaveAWLOCK,
	input wire [3:0]                         			slaveAWCACHE,
	input wire [2:0]                         			slaveAWPROT,
	input wire [3:0]                         			slaveAWREGION,			// not used
	input wire [3:0]                         			slaveAWQOS,				// not used
	input wire [USER_WIDTH-1:0]	        				slaveAWUSER,
	input wire                            				slaveAWVALID,				
	output wire	 	                       				slaveAWREADY,
   	
	//========================================  Slave Write Data Ports  =========================================================
	input wire [ID_WIDTH-1:0]                           slaveWID,
	input wire [DATA_WIDTH-1:0]    						slaveWDATA,
	input wire [(DATA_WIDTH/8)-1:0]  					slaveWSTRB,
	input wire                           				slaveWLAST,
	input wire [USER_WIDTH-1:0]	         				slaveWUSER,
	input wire                            				slaveWVALID,
		
	output wire                           				slaveWREADY,
		
	//========================================  Master Write Response Ports  ====================================================
	output wire [ID_WIDTH-1:0]							slaveBID,
	output wire [1:0]                          			slaveBRESP,
	output wire [USER_WIDTH-1:0]          				slaveBUSER,
	output wire 	                            		slaveBVALID,

	input  wire  	                           			slaveBREADY,
		 
	//================================================= External Side Ports  ====================================================
	// Slave Write Address Port - Slave ID is composed of Master Port ID concatenated with transaction ID
	output wire [ID_WIDTH-1:0] 							SLAVE_AWID,
	output wire [ADDR_WIDTH-1:0]          				SLAVE_AWADDR,
	output wire [7:0]                         			SLAVE_AWLEN,	
	output wire [2:0]                         			SLAVE_AWSIZE,	
	output wire [1:0]                         			SLAVE_AWBURST,	
	output wire [1:0]                         			SLAVE_AWLOCK,
	output wire [3:0]                         			SLAVE_AWCACHE,
	output wire [2:0]                         			SLAVE_AWPROT,	
	output wire [3:0]                         			SLAVE_AWREGION, 
	output wire [3:0]                         			SLAVE_AWQOS,			
	output wire [USER_WIDTH-1:0]  	      	  			SLAVE_AWUSER,	
	output wire      	                     			SLAVE_AWVALID,	
	input  wire		                          			SLAVE_AWREADY,
   
	//========================================  Slave Write Data Ports  ==========================================================
	output wire [ID_WIDTH-1:0] 							SLAVE_WID,
	output wire [SLAVE_DATA_WIDTH-1:0]    				SLAVE_WDATA,	
	output wire [(SLAVE_DATA_WIDTH/8)-1:0]  			SLAVE_WSTRB,	
	output wire                           				SLAVE_WLAST,	
	output wire [USER_WIDTH-1:0]	         			SLAVE_WUSER,	
	output wire                            				SLAVE_WVALID,	
	input  wire                           				SLAVE_WREADY,	

	//=======================================  Slave Write Response Ports  =======================================================
	input  wire [ID_WIDTH-1:0]							SLAVE_BID,		
	input  wire [1:0]                         			SLAVE_BRESP,	
	input  wire [USER_WIDTH-1:0]        				SLAVE_BUSER,	
	input  wire      	                     			SLAVE_BVALID,	
	output wire	  	                         			SLAVE_BREADY,	
   
	//=======================================  Slave Read Address Port  =========================================================
	output wire [ID_WIDTH-1:0]							SLAVE_ARID,	
	output wire [ADDR_WIDTH-1:0]          				SLAVE_ARADDR,	
	output wire [7:0]                         			SLAVE_ARLEN,	
	output wire [2:0]                         			SLAVE_ARSIZE,	
	output wire [1:0]                         			SLAVE_ARBURST,	
	output wire [1:0]                         			SLAVE_ARLOCK,	
	output wire [3:0]                         			SLAVE_ARCACHE,	
	output wire [2:0]                         			SLAVE_ARPROT,	
	output wire [3:0]                         			SLAVE_ARREGION, 
	output wire [3:0]                         			SLAVE_ARQOS,	
	output wire [USER_WIDTH-1:0]	        			SLAVE_ARUSER,	
	output wire      	                     			SLAVE_ARVALID,	
	input  wire 		                          		SLAVE_ARREADY,	
   
	//====================================  Slave Read Data Ports  ==============================================================
	input  wire [ID_WIDTH-1:0]  						SLAVE_RID,		
	input  wire [SLAVE_DATA_WIDTH-1:0]    				SLAVE_RDATA,	
	input  wire [1:0]                         			SLAVE_RRESP,	
	input  wire          	                 			SLAVE_RLAST,	
	input  wire [USER_WIDTH-1:0]	         			SLAVE_RUSER,			
	input  wire      	                    			SLAVE_RVALID,	
	output wire 		                           		SLAVE_RREADY
    
	);

	//===================================== Internal wires =======================================//	
	wire	sysReset;

	//================================== Wires between RegSlice and caxi4interconnect_SlvProtocolConverter ==================
	// Slave Write Address Port - Slave ID is composed of Master Port ID concatenated with transaction ID
	wire [ID_WIDTH-1:0] 						dwc_cdc_slaveAWID;
	wire [ADDR_WIDTH-1:0]          				dwc_cdc_slaveAWADDR;
	wire [7:0]                         			dwc_cdc_slaveAWLEN;	
	wire [2:0]                         			dwc_cdc_slaveAWSIZE;	
	wire [1:0]                         			dwc_cdc_slaveAWBURST;	
	wire [1:0]                         			dwc_cdc_slaveAWLOCK;
	wire [3:0]                         			dwc_cdc_slaveAWCACHE;
	wire [2:0]                         			dwc_cdc_slaveAWPROT;	
	wire [3:0]                         			dwc_cdc_slaveAWREGION; 
	wire [3:0]                         			dwc_cdc_slaveAWQOS;			
	wire [USER_WIDTH-1:0]  	      	  			dwc_cdc_slaveAWUSER;	
	wire      	                     			dwc_cdc_slaveAWVALID;	
	wire		                          		dwc_cdc_slaveAWREADY;
   
	// Write Data Ports  
	wire [ID_WIDTH-1:0]      					dwc_cdc_slaveWID;	
	wire [SLAVE_DATA_WIDTH-1:0] 				dwc_cdc_slaveWDATA;	
	wire [(SLAVE_DATA_WIDTH/8)-1:0] 			dwc_cdc_slaveWSTRB;	
	wire                           				dwc_cdc_slaveWLAST;	
	wire [USER_WIDTH-1:0]	         			dwc_cdc_slaveWUSER;	
	wire                            			dwc_cdc_slaveWVALID;	
	wire                           				dwc_cdc_slaveWREADY;	

	// Write Response Ports 
	wire [ID_WIDTH-1:0]							dwc_cdc_slaveBID;		
	wire [1:0]                         			dwc_cdc_slaveBRESP;	
	wire [USER_WIDTH-1:0]        				dwc_cdc_slaveBUSER;	
	wire      	                     			dwc_cdc_slaveBVALID;	
	wire	  	                         		dwc_cdc_slaveBREADY;	
   
	// Read Address Port  
	wire [ID_WIDTH-1:0]							dwc_cdc_slaveARID;	
	wire [ADDR_WIDTH-1:0]          				dwc_cdc_slaveARADDR;	
	wire [7:0]                         			dwc_cdc_slaveARLEN;	
	wire [2:0]                         			dwc_cdc_slaveARSIZE;	
	wire [1:0]                         			dwc_cdc_slaveARBURST;	
	wire [1:0]                         			dwc_cdc_slaveARLOCK;	
	wire [3:0]                         			dwc_cdc_slaveARCACHE;	
	wire [2:0]                         			dwc_cdc_slaveARPROT;	
	wire [3:0]                         			dwc_cdc_slaveARREGION; 
	wire [3:0]                         			dwc_cdc_slaveARQOS;	
	wire [USER_WIDTH-1:0]	        			dwc_cdc_slaveARUSER;	
	wire      	                     			dwc_cdc_slaveARVALID;	
	wire 		                          		dwc_cdc_slaveARREADY;	
   
	// Read Data Ports  
	wire [ID_WIDTH-1:0]  						dwc_cdc_slaveRID;		
	wire [SLAVE_DATA_WIDTH-1:0]    					dwc_cdc_slaveRDATA;	
	wire [1:0]                         			dwc_cdc_slaveRRESP;	
	wire          	                 			dwc_cdc_slaveRLAST;	
	wire [USER_WIDTH-1:0]	         			dwc_cdc_slaveRUSER;			
	wire      	                    			dwc_cdc_slaveRVALID;	
	wire 										dwc_cdc_slaveRREADY;


	//================================== Wires between RegSlice and caxi4interconnect_SlvProtocolConverter ==================
	// Slave Write Address Port - Slave ID is composed of Master Port ID concatenated with transaction ID
	wire [ID_WIDTH-1:0] 						sr_dwc_slaveAWID;
	wire [ADDR_WIDTH-1:0]          				sr_dwc_slaveAWADDR;
	wire [7:0]                         			sr_dwc_slaveAWLEN;	
	wire [2:0]                         			sr_dwc_slaveAWSIZE;	
	wire [1:0]                         			sr_dwc_slaveAWBURST;	
	wire [1:0]                         			sr_dwc_slaveAWLOCK;
	wire [3:0]                         			sr_dwc_slaveAWCACHE;
	wire [2:0]                         			sr_dwc_slaveAWPROT;	
	wire [3:0]                         			sr_dwc_slaveAWREGION; 
	wire [3:0]                         			sr_dwc_slaveAWQOS;			
	wire [USER_WIDTH-1:0]  	      	  			sr_dwc_slaveAWUSER;	
	wire      	                     			sr_dwc_slaveAWVALID;	
	wire		                          		sr_dwc_slaveAWREADY;
   
	// Write Data Ports  
	wire [ID_WIDTH-1:0]    		    			sr_dwc_slaveWID;	
	wire [DATA_WIDTH-1:0]    					sr_dwc_slaveWDATA;	
	wire [(DATA_WIDTH/8)-1:0]  					sr_dwc_slaveWSTRB;	
	wire                           				sr_dwc_slaveWLAST;	
	wire [USER_WIDTH-1:0]	         			sr_dwc_slaveWUSER;	
	wire                            			sr_dwc_slaveWVALID;	
	wire                           				sr_dwc_slaveWREADY;	

	// Write Response Ports 
	wire [ID_WIDTH-1:0]							sr_dwc_slaveBID;		
	wire [1:0]                         			sr_dwc_slaveBRESP;	
	wire [USER_WIDTH-1:0]        				sr_dwc_slaveBUSER;	
	wire      	                     			sr_dwc_slaveBVALID;	
	wire	  	                         		sr_dwc_slaveBREADY;	
   
	// Read Address Port  
	wire [ID_WIDTH-1:0]							sr_dwc_slaveARID;	
	wire [ADDR_WIDTH-1:0]          				sr_dwc_slaveARADDR;	
	wire [7:0]                         			sr_dwc_slaveARLEN;	
	wire [2:0]                         			sr_dwc_slaveARSIZE;	
	wire [1:0]                         			sr_dwc_slaveARBURST;	
	wire [1:0]                         			sr_dwc_slaveARLOCK;	
	wire [3:0]                         			sr_dwc_slaveARCACHE;	
	wire [2:0]                         			sr_dwc_slaveARPROT;	
	wire [3:0]                         			sr_dwc_slaveARREGION; 
	wire [3:0]                         			sr_dwc_slaveARQOS;	
	wire [USER_WIDTH-1:0]	        			sr_dwc_slaveARUSER;	
	wire      	                     			sr_dwc_slaveARVALID;	
	wire 		                          		sr_dwc_slaveARREADY;	
   
	// Read Data Ports  
	wire [ID_WIDTH-1:0]  						sr_dwc_slaveRID;		
	wire [DATA_WIDTH-1:0]    					sr_dwc_slaveRDATA;	
	wire [1:0]                         			sr_dwc_slaveRRESP;	
	wire          	                 			sr_dwc_slaveRLAST;	
	wire [USER_WIDTH-1:0]	         			sr_dwc_slaveRUSER;			
	wire      	                    			sr_dwc_slaveRVALID;	
	wire 										sr_dwc_slaveRREADY;
	
	//================================== Wires between caxi4interconnect_SlvProtocolConverter and NextBlock ==================
	// Slave Write Address Port - Slave ID is composed of Master Port ID concatenated with transaction ID
	wire [ID_WIDTH-1:0] 						cdc_prot_slaveAWID;
	wire [ADDR_WIDTH-1:0]          				cdc_prot_slaveAWADDR;
	wire [7:0]                         			cdc_prot_slaveAWLEN;	
	wire [2:0]                         			cdc_prot_slaveAWSIZE;	
	wire [1:0]                         			cdc_prot_slaveAWBURST;	
	wire [1:0]                         			cdc_prot_slaveAWLOCK;
	wire [3:0]                         			cdc_prot_slaveAWCACHE;
	wire [2:0]                         			cdc_prot_slaveAWPROT;	
	wire [3:0]                         			cdc_prot_slaveAWREGION; 
	wire [3:0]                         			cdc_prot_slaveAWQOS;			
	wire [USER_WIDTH-1:0]  	      	  			cdc_prot_slaveAWUSER;	
	wire      	                     			cdc_prot_slaveAWVALID;	
	wire		                          		cdc_prot_slaveAWREADY;
   
	// Write Data Ports  
	wire [ID_WIDTH-1:0]    			        	cdc_prot_slaveWID;	
	wire [SLAVE_DATA_WIDTH-1:0]    				cdc_prot_slaveWDATA;	
	wire [(SLAVE_DATA_WIDTH/8)-1:0]  			cdc_prot_slaveWSTRB;	
	wire                           				cdc_prot_slaveWLAST;	
	wire [USER_WIDTH-1:0]	         			cdc_prot_slaveWUSER;	
	wire                            			cdc_prot_slaveWVALID;	
	wire                           				cdc_prot_slaveWREADY;	

	// Write Response Ports 
	wire [ID_WIDTH-1:0]							cdc_prot_slaveBID;		
	wire [1:0]                         			cdc_prot_slaveBRESP;	
	wire [USER_WIDTH-1:0]        				cdc_prot_slaveBUSER;	
	wire      	                     			cdc_prot_slaveBVALID;	
	wire	  	                         		cdc_prot_slaveBREADY;	
   
	// Read Address Port  
	wire [ID_WIDTH-1:0]							cdc_prot_slaveARID;	
	wire [ADDR_WIDTH-1:0]          				cdc_prot_slaveARADDR;	
	wire [7:0]                         			cdc_prot_slaveARLEN;	
	wire [2:0]                         			cdc_prot_slaveARSIZE;	
	wire [1:0]                         			cdc_prot_slaveARBURST;	
	wire [1:0]                         			cdc_prot_slaveARLOCK;	
	wire [3:0]                         			cdc_prot_slaveARCACHE;	
	wire [2:0]                         			cdc_prot_slaveARPROT;	 
	wire [3:0]                         			cdc_prot_slaveARREGION; 
	wire [3:0]                         			cdc_prot_slaveARQOS;	
	wire [USER_WIDTH-1:0]	        			cdc_prot_slaveARUSER;	
	wire      	                     			cdc_prot_slaveARVALID;	
	wire 		                          		cdc_prot_slaveARREADY;	
   
	// Read Data Ports  
	wire [ID_WIDTH-1:0]  						cdc_prot_slaveRID;		
	wire [SLAVE_DATA_WIDTH-1:0]    				cdc_prot_slaveRDATA;	
	wire [1:0]                         			cdc_prot_slaveRRESP;	
	wire          	                 			cdc_prot_slaveRLAST;	
	wire [USER_WIDTH-1:0]	         			cdc_prot_slaveRUSER;			
	wire      	                    			cdc_prot_slaveRVALID;	
	wire 										cdc_prot_slaveRREADY;

	//=======================================================================================================================
	// Local system reset - asserted asynchronously to SLV_CLK and deasserted synchronous
	//=======================================================================================================================
	generate
	if(CLOCK_DOMAIN_CROSSING) 
	  begin
	    caxi4interconnect_ResetSycnc  
	    	rsync(
	    			.sysClk	( SLV_CLK ),
	    			.sysReset_L( ARESETN ),			// active low reset synchronoise to RE AClk - asserted async.
	    			.sysReset( sysReset  )			// active low sysReset synchronised to MST_CLK
	    );	
      end
	else
	  begin
	    assign sysReset = ACLK_syncReset; 
      end
	endgenerate

	//=======================================================================================================================
	// Insert a bank of registers on each channel as reqiored
	//=======================================================================================================================	
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

				//=====================================  Global Signals   =====================================================
				.sysClk	( XBAR_CLK ),
				.sysReset	( ACLK_syncReset ),
  
				// Read Address Channel
				.srcARID	( slaveARID ),
				.srcARADDR	( slaveARADDR ),
				.srcARLEN	( slaveARLEN ),
				.srcARSIZE	( slaveARSIZE ),
				.srcARBURST	( slaveARBURST ),
				.srcARLOCK	( slaveARLOCK ),
				.srcARCACHE	( slaveARCACHE ),
				.srcARPROT	( slaveARPROT ),
				.srcARREGION( slaveARREGION ),
				.srcARQOS	( slaveARQOS ),
				.srcARUSER	( slaveARUSER ),
				.srcARVALID	( slaveARVALID ),
				.srcARREADY	( slaveARREADY ),
	
				.dstARID	( sr_dwc_slaveARID ),
				.dstARADDR	( sr_dwc_slaveARADDR ),
				.dstARLEN	( sr_dwc_slaveARLEN ),
				.dstARSIZE	( sr_dwc_slaveARSIZE ),
				.dstARBURST	( sr_dwc_slaveARBURST ),
				.dstARLOCK	( sr_dwc_slaveARLOCK ),
				.dstARCACHE	( sr_dwc_slaveARCACHE ),
				.dstARPROT	( sr_dwc_slaveARPROT ),
				.dstARREGION( sr_dwc_slaveARREGION ),
				.dstARQOS	( sr_dwc_slaveARQOS ),
				.dstARUSER	( sr_dwc_slaveARUSER ),
				.dstARVALID	( sr_dwc_slaveARVALID ),
				.dstARREADY	( sr_dwc_slaveARREADY ),
	
				// Read Data Channel	
				.srcRID		( slaveRID ),
				.srcRDATA	( slaveRDATA ), // output from this module, input to this file
				.srcRRESP	( slaveRRESP ),
				.srcRLAST	( slaveRLAST ),
				.srcRUSER	( slaveRUSER ),
				.srcRVALID	( slaveRVALID ),
				.srcRREADY	( slaveRREADY ),
	
				.dstRID		( sr_dwc_slaveRID ),
				.dstRDATA	( sr_dwc_slaveRDATA ), // input to this module, 
				.dstRRESP	( sr_dwc_slaveRRESP ),
				.dstRLAST	( sr_dwc_slaveRLAST ),
				.dstRUSER	( sr_dwc_slaveRUSER ),
				.dstRVALID	( sr_dwc_slaveRVALID ),
				.dstRREADY	( sr_dwc_slaveRREADY ),
	
				// Write Address Channel	
				.srcAWID	( slaveAWID ),
				.srcAWADDR	( slaveAWADDR ),
				.srcAWLEN	( slaveAWLEN ),
				.srcAWSIZE	( slaveAWSIZE ),
				.srcAWBURST	( slaveAWBURST ),
				.srcAWLOCK	( slaveAWLOCK ),
				.srcAWCACHE	( slaveAWCACHE ),
				.srcAWPROT	( slaveAWPROT ),
				.srcAWREGION( slaveAWREGION ),
				.srcAWQOS	( slaveAWQOS ),
				.srcAWUSER	( slaveAWUSER ),
				.srcAWVALID	( slaveAWVALID ),
				.srcAWREADY	( slaveAWREADY ),
	
				.dstAWID	( sr_dwc_slaveAWID ),
				.dstAWADDR	( sr_dwc_slaveAWADDR ),
				.dstAWLEN	( sr_dwc_slaveAWLEN ),
				.dstAWSIZE	( sr_dwc_slaveAWSIZE ),
				.dstAWBURST	( sr_dwc_slaveAWBURST ),
				.dstAWLOCK	( sr_dwc_slaveAWLOCK ),
				.dstAWCACHE	( sr_dwc_slaveAWCACHE ),
				.dstAWPROT	( sr_dwc_slaveAWPROT ),
				.dstAWREGION( sr_dwc_slaveAWREGION ),
				.dstAWQOS	( sr_dwc_slaveAWQOS ),
				.dstAWUSER	( sr_dwc_slaveAWUSER ),
				.dstAWVALID	( sr_dwc_slaveAWVALID ),
				.dstAWREADY	( sr_dwc_slaveAWREADY ),

				// Write Data Channel	
				.srcWID	    ( slaveWID   ),
				.srcWDATA	( slaveWDATA ),
				.srcWSTRB	( slaveWSTRB ),
				.srcWLAST	( slaveWLAST ),
				.srcWUSER	( slaveWUSER ),
				.srcWVALID	( slaveWVALID ),
				.srcWREADY	( slaveWREADY ),
	
	            .dstWID     ( sr_dwc_slaveWID   ),
				.dstWDATA	( sr_dwc_slaveWDATA ),
				.dstWSTRB	( sr_dwc_slaveWSTRB ),
				.dstWLAST	( sr_dwc_slaveWLAST ),
				.dstWUSER	( sr_dwc_slaveWUSER ),
				.dstWVALID	( sr_dwc_slaveWVALID ),
				.dstWREADY	( sr_dwc_slaveWREADY ),	

				// Write Response Channel	
				.srcBID		( slaveBID ),
				.srcBRESP	( slaveBRESP ),
				.srcBUSER	( slaveBUSER ),
				.srcBVALID	( slaveBVALID ),
				.srcBREADY	( slaveBREADY ),

				.dstBID		( sr_dwc_slaveBID ),
				.dstBRESP	( sr_dwc_slaveBRESP ),
				.dstBUSER	( sr_dwc_slaveBUSER ),
				.dstBVALID	( sr_dwc_slaveBVALID ),
				.dstBREADY	( sr_dwc_slaveBREADY )

			)	/* synthesis syn_hier = "flatten,remove" */;
	
	//=========================================================================================
	// Currently caxi4interconnect_SlvDataWidthConverter is a "pass-through" module - no data width conversion
	// implemented. Here as stub to minimise changes needed to hierarchy when added in.
	//=========================================================================================
	caxi4interconnect_SlvDataWidthConverter #
						(
							.SLAVE_TYPE( SLAVE_TYPE ) , 		// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b10
							.SLAVE_NUMBER( SLAVE_NUMBER ),		// slave number
							.OPEN_TRANS_MAX			( OPEN_TRANS_MAX ),
							.ID_WIDTH( ID_WIDTH ),
							.ADDR_WIDTH( ADDR_WIDTH ),
							.DATA_WIDTH (DATA_WIDTH ),
							.SLAVE_DATA_WIDTH (SLAVE_DATA_WIDTH ),
							.USER_WIDTH( USER_WIDTH ),
							.DWC_ADDR_FIFO_DEPTH_CEILING (DWC_ADDR_FIFO_DEPTH_CEILING),
							.DATA_FIFO_DEPTH ( DWC_DATA_FIFO_DEPTH ),
                            .READ_INTERLEAVE (READ_INTERLEAVE),
                            .NUM_THREADS (NUM_THREADS)							
						)
				slvdwc (
							// Global Signals
							.ACLK( XBAR_CLK ),
							.sysReset( ACLK_syncReset ),				// active low reset synchronoise to RE AClk - asserted async.
		   
							// Master Read Address Ports
							.SLAVE_ARID			( dwc_cdc_slaveARID ),
							.SLAVE_ARADDR		( dwc_cdc_slaveARADDR ),
							.SLAVE_ARLEN		( dwc_cdc_slaveARLEN ),
							.SLAVE_ARSIZE		( dwc_cdc_slaveARSIZE ),
							.SLAVE_ARBURST		( dwc_cdc_slaveARBURST ),
							.SLAVE_ARLOCK		( dwc_cdc_slaveARLOCK ),
							.SLAVE_ARCACHE		( dwc_cdc_slaveARCACHE ),
							.SLAVE_ARPROT		( dwc_cdc_slaveARPROT ),
							.SLAVE_ARREGION		( dwc_cdc_slaveARREGION ),
							.SLAVE_ARQOS		( dwc_cdc_slaveARQOS ),
							.SLAVE_ARUSER		( dwc_cdc_slaveARUSER ),
							.SLAVE_ARVALID		( dwc_cdc_slaveARVALID ),
							.SLAVE_AWQOS		( dwc_cdc_slaveAWQOS ),
							.SLAVE_AWREGION		( dwc_cdc_slaveAWREGION ),
							.SLAVE_AWID			( dwc_cdc_slaveAWID ),
							.SLAVE_AWADDR		( dwc_cdc_slaveAWADDR ),
							.SLAVE_AWLEN		( dwc_cdc_slaveAWLEN ),
							.SLAVE_AWSIZE		( dwc_cdc_slaveAWSIZE ),
							.SLAVE_AWBURST		( dwc_cdc_slaveAWBURST ),
							.SLAVE_AWLOCK		( dwc_cdc_slaveAWLOCK ),
							.SLAVE_AWCACHE		( dwc_cdc_slaveAWCACHE ),
							.SLAVE_AWPROT		( dwc_cdc_slaveAWPROT ),
							.SLAVE_AWUSER		( dwc_cdc_slaveAWUSER ),
							.SLAVE_AWVALID		( dwc_cdc_slaveAWVALID ),
							.SLAVE_WID          ( dwc_cdc_slaveWID   ),
							.SLAVE_WDATA		( dwc_cdc_slaveWDATA ),
							.SLAVE_WSTRB		( dwc_cdc_slaveWSTRB ),
							.SLAVE_WLAST		( dwc_cdc_slaveWLAST ),
							.SLAVE_WUSER		( dwc_cdc_slaveWUSER ),
							.SLAVE_WVALID		( dwc_cdc_slaveWVALID ),
							.SLAVE_BREADY		( dwc_cdc_slaveBREADY ),
							.SLAVE_RREADY		( dwc_cdc_slaveRREADY ),
							.SLAVE_ARREADY 		( dwc_cdc_slaveARREADY),
							.SLAVE_RID 			( dwc_cdc_slaveRID ),
							.SLAVE_RDATA 		( dwc_cdc_slaveRDATA ), // Input from this module
							.SLAVE_RRESP 		( dwc_cdc_slaveRRESP ),
							.SLAVE_RUSER 		( dwc_cdc_slaveRUSER ),
							.SLAVE_BID 			( dwc_cdc_slaveBID ),
							.SLAVE_BRESP 		( dwc_cdc_slaveBRESP ),
							.SLAVE_BUSER 		( dwc_cdc_slaveBUSER ),
							.SLAVE_RLAST 		( dwc_cdc_slaveRLAST ),
							.SLAVE_RVALID 		( dwc_cdc_slaveRVALID ),
							.SLAVE_AWREADY 		( dwc_cdc_slaveAWREADY ),
							.SLAVE_WREADY 		( dwc_cdc_slaveWREADY ),
							.SLAVE_BVALID 		( dwc_cdc_slaveBVALID ),
							
							.int_slaveARID			( sr_dwc_slaveARID ),
							.int_slaveARADDR		( sr_dwc_slaveARADDR ),
							.int_slaveARLEN			( sr_dwc_slaveARLEN ),
							.int_slaveARSIZE		( sr_dwc_slaveARSIZE ),
							.int_slaveARBURST		( sr_dwc_slaveARBURST ),
							.int_slaveARLOCK		( sr_dwc_slaveARLOCK ),
							.int_slaveARCACHE		( sr_dwc_slaveARCACHE ),
							.int_slaveARPROT		( sr_dwc_slaveARPROT ),
							.int_slaveARREGION		( sr_dwc_slaveARREGION ),
							.int_slaveARQOS			( sr_dwc_slaveARQOS ),
							.int_slaveARUSER		( sr_dwc_slaveARUSER ),
							.int_slaveARVALID		( sr_dwc_slaveARVALID ),
							.int_slaveAWQOS			( sr_dwc_slaveAWQOS ),
							.int_slaveAWREGION		( sr_dwc_slaveAWREGION ),
							.int_slaveAWID			( sr_dwc_slaveAWID ),
							.int_slaveAWADDR		( sr_dwc_slaveAWADDR ),
							.int_slaveAWLEN			( sr_dwc_slaveAWLEN ),
							.int_slaveAWSIZE		( sr_dwc_slaveAWSIZE ),
							.int_slaveAWBURST		( sr_dwc_slaveAWBURST ),
							.int_slaveAWLOCK		( sr_dwc_slaveAWLOCK ),
							.int_slaveAWCACHE		( sr_dwc_slaveAWCACHE ),
							.int_slaveAWPROT		( sr_dwc_slaveAWPROT ),
							.int_slaveAWUSER		( sr_dwc_slaveAWUSER ),
							.int_slaveAWVALID		( sr_dwc_slaveAWVALID ),
							.int_slaveWID			( sr_dwc_slaveWID ),
							.int_slaveWDATA			( sr_dwc_slaveWDATA ),
							.int_slaveWSTRB			( sr_dwc_slaveWSTRB ),
							.int_slaveWLAST			( sr_dwc_slaveWLAST ),
							.int_slaveWUSER			( sr_dwc_slaveWUSER ),
							.int_slaveWVALID		( sr_dwc_slaveWVALID ),
							.int_slaveBREADY		( sr_dwc_slaveBREADY ),
							.int_slaveRREADY		( sr_dwc_slaveRREADY ),
							.int_slaveARREADY 		( sr_dwc_slaveARREADY ),
							.int_slaveRID 			( sr_dwc_slaveRID ),
							.int_slaveRDATA 		( sr_dwc_slaveRDATA ), // Output from this module, goes to RS
							.int_slaveRRESP 		( sr_dwc_slaveRRESP ),
							.int_slaveRUSER 		( sr_dwc_slaveRUSER ),
							.int_slaveBID 			( sr_dwc_slaveBID ),
							.int_slaveBRESP 		( sr_dwc_slaveBRESP ),
							.int_slaveBUSER 		( sr_dwc_slaveBUSER ),
							.int_slaveRLAST 		( sr_dwc_slaveRLAST ),
							.int_slaveRVALID 		( sr_dwc_slaveRVALID ),
							.int_slaveAWREADY 		( sr_dwc_slaveAWREADY ),
							.int_slaveWREADY 		( sr_dwc_slaveWREADY ),
							.int_slaveBVALID 		( sr_dwc_slaveBVALID )

						)	/* synthesis syn_hier = "remove" */; 	



	//=======================================================================================================================
	// Slave Protocol Converter converts an AXI4 port to AXI4 (pass-through), AXI4Lite or AXI3 slave port based on
	// SLAVE_TYPE.
	//=======================================================================================================================
	caxi4interconnect_SlvProtocolConverter #
						(
							.SLAVE_TYPE( SLAVE_TYPE ) , 	// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11
							.SLAVE_NUMBER( SLAVE_NUMBER ),	// slave number
							.ID_WIDTH( ID_WIDTH ),
							.ADDR_WIDTH( ADDR_WIDTH ),				
							.DATA_WIDTH( SLAVE_DATA_WIDTH ), 
							.USER_WIDTH( USER_WIDTH ),
							.WRITE_ZERO_SLAVE_ID( WRITE_ZERO_SLAVE_ID ),
							.READ_ZERO_SLAVE_ID( READ_ZERO_SLAVE_ID ),				
							.SLV_AXI4PRT_ADDRDEPTH 		( SLV_AXI4PRT_ADDRDEPTH ),
							.SLV_AXI4PRT_DATADEPTH 		( SLV_AXI4PRT_DATADEPTH ),
							.MAX_TRANS                  (MAX_TRANS ),
							.READ_INTERLEAVE            (READ_INTERLEAVE)
						)
				slvProtConv (
							// Global Signals
							.ACLK( SLV_CLK ),
							.sysReset( sysReset ),				// active low reset synchronoise to RE AClk - asserted async.
		   
							// Master Read Address Ports
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
							.SLAVE_WID			( SLAVE_WID ),
							.SLAVE_WDATA		( SLAVE_WDATA ),
							.SLAVE_WSTRB		( SLAVE_WSTRB ),
							.SLAVE_WLAST		( SLAVE_WLAST ),
							.SLAVE_WUSER		( SLAVE_WUSER ),
							.SLAVE_WVALID		( SLAVE_WVALID ),
							.SLAVE_BREADY		( SLAVE_BREADY ),
							.SLAVE_RREADY		( SLAVE_RREADY ),
							.SLAVE_ARREADY 		( SLAVE_ARREADY),
							.SLAVE_RID 			( SLAVE_RID ),
							.SLAVE_RDATA 		( SLAVE_RDATA ), // input to this module, input to this file
							.SLAVE_RRESP 		( SLAVE_RRESP ),
							.SLAVE_RUSER 		( SLAVE_RUSER ),
							.SLAVE_BID 			( SLAVE_BID ),
							.SLAVE_BRESP 		( SLAVE_BRESP ),
							.SLAVE_BUSER 		( SLAVE_BUSER ),
							.SLAVE_RLAST 		( SLAVE_RLAST ),
							.SLAVE_RVALID 		( SLAVE_RVALID ),
							.SLAVE_AWREADY 		( SLAVE_AWREADY ),
							.SLAVE_WREADY 		( SLAVE_WREADY ),
							.SLAVE_BVALID 		( SLAVE_BVALID ),
							
							.int_slaveARID			( cdc_prot_slaveARID ),
							.int_slaveARADDR		( cdc_prot_slaveARADDR ),
							.int_slaveARLEN			( cdc_prot_slaveARLEN ),
							.int_slaveARSIZE		( cdc_prot_slaveARSIZE ),
							.int_slaveARBURST		( cdc_prot_slaveARBURST ),
							.int_slaveARLOCK		( cdc_prot_slaveARLOCK ),
							.int_slaveARCACHE		( cdc_prot_slaveARCACHE ),
							.int_slaveARPROT		( cdc_prot_slaveARPROT ),
							.int_slaveARREGION		( cdc_prot_slaveARREGION ),
							.int_slaveARQOS			( cdc_prot_slaveARQOS ),
							.int_slaveARUSER		( cdc_prot_slaveARUSER ),
							.int_slaveARVALID		( cdc_prot_slaveARVALID ),
							.int_slaveAWQOS			( cdc_prot_slaveAWQOS ),
							.int_slaveAWREGION		( cdc_prot_slaveAWREGION ),
							.int_slaveAWID			( cdc_prot_slaveAWID ),
							.int_slaveAWADDR		( cdc_prot_slaveAWADDR ),
							.int_slaveAWLEN			( cdc_prot_slaveAWLEN ),
							.int_slaveAWSIZE		( cdc_prot_slaveAWSIZE ),
							.int_slaveAWBURST		( cdc_prot_slaveAWBURST ),
							.int_slaveAWLOCK		( cdc_prot_slaveAWLOCK ),
							.int_slaveAWCACHE		( cdc_prot_slaveAWCACHE ),
							.int_slaveAWPROT		( cdc_prot_slaveAWPROT ),
							.int_slaveAWUSER		( cdc_prot_slaveAWUSER ),
							.int_slaveAWVALID		( cdc_prot_slaveAWVALID ),
							.int_slaveWID			( cdc_prot_slaveWID ),
							.int_slaveWDATA			( cdc_prot_slaveWDATA ),
							.int_slaveWSTRB			( cdc_prot_slaveWSTRB ),
							.int_slaveWLAST			( cdc_prot_slaveWLAST ),
							.int_slaveWUSER			( cdc_prot_slaveWUSER ),
							.int_slaveWVALID		( cdc_prot_slaveWVALID ),
							.int_slaveBREADY		( cdc_prot_slaveBREADY ),
							.int_slaveRREADY		( cdc_prot_slaveRREADY ),
							.int_slaveARREADY 		( cdc_prot_slaveARREADY ),
							.int_slaveRID 			( cdc_prot_slaveRID ),
							.int_slaveRDATA 		( cdc_prot_slaveRDATA ), // outout from this module
							.int_slaveRRESP 		( cdc_prot_slaveRRESP ),
							.int_slaveRUSER 		( cdc_prot_slaveRUSER ),
							.int_slaveBID 			( cdc_prot_slaveBID ),
							.int_slaveBRESP 		( cdc_prot_slaveBRESP ),
							.int_slaveBUSER 		( cdc_prot_slaveBUSER ),
							.int_slaveRLAST 		( cdc_prot_slaveRLAST ),
							.int_slaveRVALID 		( cdc_prot_slaveRVALID ),
							.int_slaveAWREADY 		( cdc_prot_slaveAWREADY ),
							.int_slaveWREADY 		( cdc_prot_slaveWREADY ),
							.int_slaveBVALID 		( cdc_prot_slaveBVALID )

						)	/* synthesis syn_hier = "remove" */; 


				caxi4interconnect_SlvClockDomainCrossing #
						(
							.ID_WIDTH( ID_WIDTH ),
							.ADDR_WIDTH( ADDR_WIDTH ),				
							.SLAVE_DATA_WIDTH ( SLAVE_DATA_WIDTH ),
							.USER_WIDTH( USER_WIDTH ),
							.CLOCK_DOMAIN_CROSSING (CLOCK_DOMAIN_CROSSING),
							.SLAVE_TYPE (SLAVE_TYPE),
							.READ_INTERLEAVE  (READ_INTERLEAVE)
						)
				slvCDC (
							// Global Signals
							.XBAR_CLK( XBAR_CLK ),
							.SLV_CLK( SLV_CLK),
							.sysReset( sysReset ),	
							.ACLK_syncReset( ACLK_syncReset ),	
		   
							// Master Read Address Ports
							.SLAVE_ARID		( dwc_cdc_slaveARID ),
							.SLAVE_ARADDR		( dwc_cdc_slaveARADDR ),
							.SLAVE_ARLEN		( dwc_cdc_slaveARLEN ),
							.SLAVE_ARSIZE		( dwc_cdc_slaveARSIZE ),
							.SLAVE_ARBURST		( dwc_cdc_slaveARBURST ),
							.SLAVE_ARLOCK		( dwc_cdc_slaveARLOCK ),
							.SLAVE_ARCACHE		( dwc_cdc_slaveARCACHE ),
							.SLAVE_ARPROT		( dwc_cdc_slaveARPROT ),
							.SLAVE_ARREGION	( dwc_cdc_slaveARREGION ),
							.SLAVE_ARQOS		( dwc_cdc_slaveARQOS ),
							.SLAVE_ARUSER		( dwc_cdc_slaveARUSER ),
							.SLAVE_ARVALID		( dwc_cdc_slaveARVALID ),
							.SLAVE_AWQOS		( dwc_cdc_slaveAWQOS ),
							.SLAVE_AWREGION	( dwc_cdc_slaveAWREGION ),
							.SLAVE_AWID		( dwc_cdc_slaveAWID ),
							.SLAVE_AWADDR		( dwc_cdc_slaveAWADDR ),
							.SLAVE_AWLEN		( dwc_cdc_slaveAWLEN ),
							.SLAVE_AWSIZE		( dwc_cdc_slaveAWSIZE ),
							.SLAVE_AWBURST		( dwc_cdc_slaveAWBURST ),
							.SLAVE_AWLOCK		( dwc_cdc_slaveAWLOCK ),
							.SLAVE_AWCACHE		( dwc_cdc_slaveAWCACHE ),
							.SLAVE_AWPROT		( dwc_cdc_slaveAWPROT ),
							.SLAVE_AWUSER		( dwc_cdc_slaveAWUSER ),
							.SLAVE_AWVALID		( dwc_cdc_slaveAWVALID ),
							.SLAVE_WID   		( dwc_cdc_slaveWID ),
							.SLAVE_WDATA		( dwc_cdc_slaveWDATA ),
							.SLAVE_WSTRB		( dwc_cdc_slaveWSTRB ),
							.SLAVE_WLAST		( dwc_cdc_slaveWLAST ),
							.SLAVE_WUSER		( dwc_cdc_slaveWUSER ),
							.SLAVE_WVALID		( dwc_cdc_slaveWVALID ),
							.SLAVE_BREADY		( dwc_cdc_slaveBREADY ),
							.SLAVE_RREADY		( dwc_cdc_slaveRREADY ),
							.SLAVE_ARREADY 	( dwc_cdc_slaveARREADY),
							.SLAVE_RID 		( dwc_cdc_slaveRID ),
							.SLAVE_RDATA 		( dwc_cdc_slaveRDATA ), // output from this module
							.SLAVE_RRESP 		( dwc_cdc_slaveRRESP ),
							.SLAVE_RUSER 		( dwc_cdc_slaveRUSER ),
							.SLAVE_BID 		( dwc_cdc_slaveBID ),
							.SLAVE_BRESP 		( dwc_cdc_slaveBRESP ),
							.SLAVE_BUSER 		( dwc_cdc_slaveBUSER ),
							.SLAVE_RLAST 		( dwc_cdc_slaveRLAST ),
							.SLAVE_RVALID 		( dwc_cdc_slaveRVALID ),
							.SLAVE_AWREADY 	( dwc_cdc_slaveAWREADY ),
							.SLAVE_WREADY 		( dwc_cdc_slaveWREADY ),
							.SLAVE_BVALID 		( dwc_cdc_slaveBVALID ),
							
							.slaveARID			( cdc_prot_slaveARID ),
							.slaveARADDR		( cdc_prot_slaveARADDR ),
							.slaveARLEN		( cdc_prot_slaveARLEN ),
							.slaveARSIZE		( cdc_prot_slaveARSIZE ),
							.slaveARBURST		( cdc_prot_slaveARBURST ),
							.slaveARLOCK		( cdc_prot_slaveARLOCK ),
							.slaveARCACHE		( cdc_prot_slaveARCACHE ),
							.slaveARPROT		( cdc_prot_slaveARPROT ),
							.slaveARREGION		( cdc_prot_slaveARREGION ),
							.slaveARQOS		( cdc_prot_slaveARQOS ),
							.slaveARUSER		( cdc_prot_slaveARUSER ),
							.slaveARVALID		( cdc_prot_slaveARVALID ),
							.slaveAWQOS		( cdc_prot_slaveAWQOS ),
							.slaveAWREGION		( cdc_prot_slaveAWREGION ),
							.slaveAWID			( cdc_prot_slaveAWID ),
							.slaveAWADDR		( cdc_prot_slaveAWADDR ),
							.slaveAWLEN		( cdc_prot_slaveAWLEN ),
							.slaveAWSIZE		( cdc_prot_slaveAWSIZE ),
							.slaveAWBURST		( cdc_prot_slaveAWBURST ),
							.slaveAWLOCK		( cdc_prot_slaveAWLOCK ),
							.slaveAWCACHE		( cdc_prot_slaveAWCACHE ),
							.slaveAWPROT		( cdc_prot_slaveAWPROT ),
							.slaveAWUSER		( cdc_prot_slaveAWUSER ),
							.slaveAWVALID		( cdc_prot_slaveAWVALID ),
							.slaveWID		( cdc_prot_slaveWID ),
							.slaveWDATA		( cdc_prot_slaveWDATA ),
							.slaveWSTRB		( cdc_prot_slaveWSTRB ),
							.slaveWLAST		( cdc_prot_slaveWLAST ),
							.slaveWUSER		( cdc_prot_slaveWUSER ),
							.slaveWVALID		( cdc_prot_slaveWVALID ),
							.slaveBREADY		( cdc_prot_slaveBREADY ),
							.slaveRREADY		( cdc_prot_slaveRREADY ),
							.slaveARREADY 		( cdc_prot_slaveARREADY ),
							.slaveRID 			( cdc_prot_slaveRID ),
							.slaveRDATA 		( cdc_prot_slaveRDATA ), // Input to this module
							.slaveRRESP 		( cdc_prot_slaveRRESP ),
							.slaveRUSER 		( cdc_prot_slaveRUSER ),
							.slaveBID 			( cdc_prot_slaveBID ),
							.slaveBRESP 		( cdc_prot_slaveBRESP ),
							.slaveBUSER 		( cdc_prot_slaveBUSER ),
							.slaveRLAST 		( cdc_prot_slaveRLAST ),
							.slaveRVALID 		( cdc_prot_slaveRVALID ),
							.slaveAWREADY 		( cdc_prot_slaveAWREADY ),
							.slaveWREADY 		( cdc_prot_slaveWREADY ),
							.slaveBVALID 		( cdc_prot_slaveBVALID )

						)  /* synthesis syn_hier = "remove" */;
	
						
endmodule		// caxi4interconnect_SlaveConvertor.v
				
