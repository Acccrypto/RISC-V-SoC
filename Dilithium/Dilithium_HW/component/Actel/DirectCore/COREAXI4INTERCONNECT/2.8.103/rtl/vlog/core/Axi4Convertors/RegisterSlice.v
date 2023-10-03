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
//     Abstract  : This file provides an RegisterSlic for an AXI Port. Each channel can be configured individually.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_RegisterSlice #

	(
		parameter 	AWCHAN			= 1,			// 0 means no slice on channel - 1 means full slice on channel
		parameter 	ARCHAN			= 1,			// 0 means no slice on channel - 1 means full slice on channel
		parameter 	RCHAN			= 1,			// 0 means no slice on channel - 1 means full slice on channel
		parameter 	WCHAN			= 1,			// 0 means no slice on channel - 1 means full slice on channel
		parameter 	BCHAN			= 1,			// 0 means no slice on channel - 1 means full slice on channel
		
		parameter integer ID_WIDTH   			= 3, 

		parameter integer ADDR_WIDTH      		= 20,
		parameter integer DATA_WIDTH 			= 16, 

		parameter integer SUPPORT_USER_SIGNALS 	= 0,
		parameter integer USER_WIDTH 			= 1
		
	)
	(

	//=====================================  Global Signals   ========================================================================
	input  wire           			sysClk,
	input  wire          			sysReset,
  
	// Read Address Channel
	input wire [ID_WIDTH-1:0] 		srcARID,
	input wire [ADDR_WIDTH-1:0]		srcARADDR,
	input wire [7:0]        		srcARLEN,
	input wire [2:0]          		srcARSIZE,
	input wire [1:0]          		srcARBURST,
	input wire [1:0]          		srcARLOCK,
	input wire [3:0]           		srcARCACHE,
	input wire [2:0]         		srcARPROT,
	input wire [3:0]          		srcARREGION,
	input wire [3:0]          		srcARQOS,
	input wire [USER_WIDTH-1:0]		srcARUSER,
	input wire            			srcARVALID,
	output wire            			srcARREADY,

	output wire [ID_WIDTH-1:0] 		dstARID,
	output wire [ADDR_WIDTH-1:0]	dstARADDR,
	output wire [7:0]        		dstARLEN,
	output wire [2:0]          		dstARSIZE,
	output wire [1:0]          		dstARBURST,
	output wire [1:0]          		dstARLOCK,
	output wire [3:0]           	dstARCACHE,
	output wire [2:0]         		dstARPROT,
	output wire [3:0]          		dstARREGION,
	output wire [3:0]          		dstARQOS,
	output wire [USER_WIDTH-1:0]	dstARUSER,
	output wire            			dstARVALID,
	input wire             			dstARREADY,
	
	// Read Data Channel	
	input wire [ID_WIDTH-1:0]   	dstRID,
	input wire [DATA_WIDTH-1:0]		dstRDATA,
	input wire [1:0]           		dstRRESP,
	input wire                		dstRLAST,
	input wire [USER_WIDTH-1:0] 	dstRUSER,
	input wire                 		dstRVALID,
	output wire               		dstRREADY,

	output wire [ID_WIDTH-1:0]   	srcRID,
	output wire [DATA_WIDTH-1:0]	srcRDATA,
	output wire [1:0]           	srcRRESP,
	output wire                		srcRLAST,
	output wire [USER_WIDTH-1:0] 	srcRUSER,
	output wire                 	srcRVALID,
	input wire               		srcRREADY,

	// Write Address Channel	
	input wire [ID_WIDTH-1:0]  		srcAWID,
	input wire [ADDR_WIDTH-1:0] 	srcAWADDR,
	input wire [7:0]           		srcAWLEN,
	input wire [2:0]           		srcAWSIZE,
	input wire [1:0]           		srcAWBURST,
	input wire [1:0]           		srcAWLOCK,
	input wire [3:0]          		srcAWCACHE,
	input wire [2:0]           		srcAWPROT,
	input wire [3:0]            	srcAWREGION,
	input wire [3:0]           		srcAWQOS,
	input wire [USER_WIDTH-1:0]   	srcAWUSER,
	input wire                 		srcAWVALID,
	output wire                		srcAWREADY,
	
	output wire [ID_WIDTH-1:0]  	dstAWID,
	output wire [ADDR_WIDTH-1:0] 	dstAWADDR,
	output wire [7:0]           	dstAWLEN,
	output wire [2:0]           	dstAWSIZE,
	output wire [1:0]           	dstAWBURST,
	output wire [1:0]           	dstAWLOCK,
	output wire [3:0]          		dstAWCACHE,
	output wire [2:0]           	dstAWPROT,
	output wire [3:0]            	dstAWREGION,
	output wire [3:0]           	dstAWQOS,
	output wire [USER_WIDTH-1:0]   	dstAWUSER,
	output wire                 	dstAWVALID,
	input wire                		dstAWREADY,

	// Write Data Channel	
	input wire [ID_WIDTH-1:0]       srcWID,
	input wire [DATA_WIDTH-1:0]  	srcWDATA,
	input wire [(DATA_WIDTH/8)-1:0]	srcWSTRB,
	input wire                  	srcWLAST,
	input wire [USER_WIDTH-1:0] 	srcWUSER,
	input wire                  	srcWVALID,
	output wire                   	srcWREADY,
	
	output wire [ID_WIDTH-1:0]      dstWID,
	output wire [DATA_WIDTH-1:0]  		dstWDATA,
	output wire [(DATA_WIDTH/8)-1:0]	dstWSTRB,
	output wire                  	dstWLAST,
	output wire [USER_WIDTH-1:0] 	dstWUSER,
	output wire                  	dstWVALID,
	input wire                   	dstWREADY,	
			
	// Write Response Channel	
	input  wire [ID_WIDTH-1:0]		dstBID,
	input  wire [1:0]           	dstBRESP,
	input  wire [USER_WIDTH-1:0] 	dstBUSER,
	input  wire      				dstBVALID,
	output wire						dstBREADY,

	output  wire [ID_WIDTH-1:0]		srcBID,
	output  wire [1:0]           	srcBRESP,
	output  wire [USER_WIDTH-1:0] 	srcBUSER,
	output  wire      				srcBVALID,
	input wire						srcBREADY

	);	

	//===================================================================================================================
	
	generate
		if ( AWCHAN == 0 ) 			// Address Write Channel - direct connection, no Register Slice
			begin			
				assign dstAWID 		= srcAWID;
				assign dstAWADDR 	= srcAWADDR;
				assign dstAWLEN 	= srcAWLEN;
				assign dstAWSIZE 	= srcAWSIZE;
				assign dstAWBURST 	= srcAWBURST;
				assign dstAWLOCK 	= srcAWLOCK;
				assign dstAWCACHE 	= srcAWCACHE;
				assign dstAWPROT 	= srcAWPROT;
				assign dstAWREGION 	= srcAWREGION;
				assign dstAWQOS 	= srcAWQOS;				
				assign dstAWUSER 	= srcAWUSER;								
				assign dstAWVALID 	= srcAWVALID;
				assign srcAWREADY 	= dstAWREADY;
			end
		else if ( AWCHAN == 1 )		// Address Write Channel - Register Slice
			begin
			
				//=====================================================================================
				// Write Address Channel signal bus
				//=====================================================================================
				localparam AWCHAN_WIDTH = ID_WIDTH+ADDR_WIDTH+8+3+2+2+4+3+4+4+USER_WIDTH;
				
				
				wire [AWCHAN_WIDTH-1:0]	srcAWCHAN, dstAWCHAN;

				assign srcAWCHAN = { 	srcAWID, 		srcAWADDR, 
										srcAWLEN, 		srcAWSIZE, 
										srcAWBURST, 	srcAWLOCK, 
										srcAWCACHE, 	srcAWPROT, 
										srcAWREGION,	srcAWQOS, 
										srcAWUSER 					};			
			
				caxi4interconnect_RegSliceFull #
					( .CHAN_WIDTH( AWCHAN_WIDTH )	)	//  the number of channel signals to register (outside of Valid & Ready) 
				awrs (
						.sysClk	( 	sysClk 		),
						.sysReset( 	sysReset 	),						
						.mDat( 		srcAWCHAN 	),		// channel data signals to register from "master" or "source"
						.mValid( 	srcAWVALID 	),		// indicates when mDat is valid
						.mReady( 	srcAWREADY	),		// indicates when taking data from "master" or "source"
						.sDat( 		dstAWCHAN 	),		// channel data signals registered to "slave" or "sink"
						.sValid( 	dstAWVALID 	),		// indicates when sDat is valid
						.sReady( 	dstAWREADY 	)		// indicates when slave/sink taking sDat
					);
			

				assign dstAWUSER	= dstAWCHAN[USER_WIDTH-1:0];
				assign dstAWQOS		= dstAWCHAN[4+USER_WIDTH-1:USER_WIDTH];
				assign dstAWREGION	= dstAWCHAN[4+4+USER_WIDTH-1:4+USER_WIDTH];
				assign dstAWPROT	= dstAWCHAN[3+4+4+USER_WIDTH-1:4+4+USER_WIDTH];
				assign dstAWCACHE	= dstAWCHAN[4+3+4+4+USER_WIDTH-1:3+4+4+USER_WIDTH];
				assign dstAWLOCK	= dstAWCHAN[2+4+3+4+4+USER_WIDTH-1:4+3+4+4+USER_WIDTH];
				assign dstAWBURST	= dstAWCHAN[2+2+4+3+4+4+USER_WIDTH-1:2+4+3+4+4+USER_WIDTH];
				assign dstAWSIZE	= dstAWCHAN[3+2+2+4+3+4+4+USER_WIDTH-1:2+2+4+3+4+4+USER_WIDTH];
				assign dstAWLEN		= dstAWCHAN[8+3+2+2+4+3+4+4+USER_WIDTH-1:3+2+2+4+3+4+4+USER_WIDTH];
				assign dstAWADDR	= dstAWCHAN[ADDR_WIDTH+8+3+2+2+4+3+4+4+USER_WIDTH-1:8+3+2+2+4+3+4+4+USER_WIDTH];
				assign dstAWID		= dstAWCHAN[ID_WIDTH+ADDR_WIDTH+8+3+2+2+4+3+4+4+USER_WIDTH-1:ADDR_WIDTH+8+3+2+2+4+3+4+4+USER_WIDTH];
	
			end	
	endgenerate

	
	generate
		if ( ARCHAN == 0 ) 			// Address Read Channel - direct connection, no Register Slice
			begin			
				assign dstARID 		= srcARID;
				assign dstARADDR 	= srcARADDR;
				assign dstARLEN 	= srcARLEN;
				assign dstARSIZE 	= srcARSIZE;
				assign dstARBURST 	= srcARBURST;
				assign dstARLOCK 	= srcARLOCK;
				assign dstARCACHE 	= srcARCACHE;
				assign dstARPROT 	= srcARPROT;
				assign dstARREGION 	= srcARREGION;
				assign dstARQOS 	= srcARQOS;				
				assign dstARUSER 	= srcARUSER;								
				assign dstARVALID 	= srcARVALID;
				assign srcARREADY 	= dstARREADY;
			end
		else if ( ARCHAN == 1 )		// Address Read Channel -  Register Slice
			begin
			
				//=====================================================================================
				// Read Address Channel signal bus
				//=====================================================================================
				localparam ARCHAN_WIDTH = ID_WIDTH+ADDR_WIDTH+8+3+2+2+4+3+4+4+USER_WIDTH;

				wire [ARCHAN_WIDTH-1:0]	srcARCHAN, dstARCHAN;

				assign srcARCHAN = { 	srcARID, 		srcARADDR, 
										srcARLEN, 		srcARSIZE, 
										srcARBURST, 	srcARLOCK, 
										srcARCACHE, 	srcARPROT, 
										srcARREGION,	srcARQOS, 
										srcARUSER 					};			
			
				caxi4interconnect_RegSliceFull #
					( .CHAN_WIDTH( ARCHAN_WIDTH )	)	//  the number of channel signals to register (outside of Valid & Ready) 
				arrs (
						.sysClk	( 	sysClk 		),	
						.sysReset( 	sysReset 	),						
						.mDat( 		srcARCHAN 	),		// channel data signals to register from "master" or "source"
						.mValid( 	srcARVALID 	),		// indicates when mDat is valid
						.mReady( 	srcARREADY	),		// indicates when taking data from "master" or "source"
						.sDat( 		dstARCHAN 	),		// channel data signals registered to "slave" or "sink"
						.sValid( 	dstARVALID 	),		// indicates when sDat is valid
						.sReady( 	dstARREADY 	)		// indicates when slave/sink taking sDat
					);
			

				assign dstARUSER	= dstARCHAN[USER_WIDTH-1:0];
				assign dstARQOS		= dstARCHAN[4+USER_WIDTH-1:USER_WIDTH];
				assign dstARREGION	= dstARCHAN[4+4+USER_WIDTH-1:4+USER_WIDTH];
				assign dstARPROT	= dstARCHAN[3+4+4+USER_WIDTH-1:4+4+USER_WIDTH];
				assign dstARCACHE	= dstARCHAN[4+3+4+4+USER_WIDTH-1:3+4+4+USER_WIDTH];
				assign dstARLOCK	= dstARCHAN[2+4+3+4+4+USER_WIDTH-1:4+3+4+4+USER_WIDTH];
				assign dstARBURST	= dstARCHAN[2+2+4+3+4+4+USER_WIDTH-1:2+4+3+4+4+USER_WIDTH];
				assign dstARSIZE	= dstARCHAN[3+2+2+4+3+4+4+USER_WIDTH-1:2+2+4+3+4+4+USER_WIDTH];
				assign dstARLEN		= dstARCHAN[8+3+2+2+4+3+4+4+USER_WIDTH-1:3+2+2+4+3+4+4+USER_WIDTH];
				assign dstARADDR	= dstARCHAN[ADDR_WIDTH+8+3+2+2+4+3+4+4+USER_WIDTH-1:8+3+2+2+4+3+4+4+USER_WIDTH];
				assign dstARID		= dstARCHAN[ID_WIDTH+ADDR_WIDTH+8+3+2+2+4+3+4+4+USER_WIDTH-1:ADDR_WIDTH+8+3+2+2+4+3+4+4+USER_WIDTH];
	
			end	
	endgenerate


	generate
		if ( RCHAN == 0 ) 			//  Read Data Channel - direct connection, no Register Slice
			begin			
				assign srcRID	= dstRID;
				assign srcRDATA	= dstRDATA;
				assign srcRRESP	= dstRRESP;
				assign srcRLAST	= dstRLAST;
				assign srcRUSER	= dstRUSER;
				assign srcRVALID = dstRVALID;
				assign dstRREADY = srcRREADY;
			end
		else if ( RCHAN == 1 )		// Read Data Channel -  Register Slice
			begin
			
				//=====================================================================================
				// Read Data Channel signal bus
				//=====================================================================================
				localparam RCHAN_WIDTH = ID_WIDTH+DATA_WIDTH+2+1+USER_WIDTH;

				wire [RCHAN_WIDTH-1:0]	srcRCHAN, dstRCHAN;

				assign dstRCHAN = { 	dstRID, 		dstRDATA, 
										dstRRESP, 		dstRLAST, 
										dstRUSER					};
										
				// For RCHAN - master/src is "dst" and slave/sink is "src"
				caxi4interconnect_RegSliceFull #
					( .CHAN_WIDTH( RCHAN_WIDTH )	)	//  the number of channel signals to register (outside of Valid & Ready) 
				rrs (
						.sysClk	( 	sysClk 		),
						.sysReset( 	sysReset 	),						
						.mDat( 		dstRCHAN 	),		// channel data signals to register from "master" or "source"
						.mValid( 	dstRVALID 	),		// indicates when mDat is valid
						.mReady( 	dstRREADY	),		// indicates when taking data from "master" or "source"
						.sDat( 		srcRCHAN 	),		// channel data signals registered to "slave" or "sink"
						.sValid( 	srcRVALID 	),		// indicates when sDat is valid
						.sReady( 	srcRREADY 	)		// indicates when slave/sink taking sDat
					);
			

				assign srcRUSER		= srcRCHAN[USER_WIDTH-1:0];
				assign srcRLAST		= srcRCHAN[1+USER_WIDTH-1:USER_WIDTH];
				assign srcRRESP		= srcRCHAN[2+1+USER_WIDTH-1:1+USER_WIDTH];
				assign srcRDATA		= srcRCHAN[DATA_WIDTH+2+1+USER_WIDTH-1:2+1+USER_WIDTH];
				assign srcRID		= srcRCHAN[ID_WIDTH+DATA_WIDTH+2+1+USER_WIDTH-1:DATA_WIDTH+2+1+USER_WIDTH];
	
			end	
	endgenerate


	generate
		if ( WCHAN == 0 ) 			//  Write Data Channel - direct connection, no Register Slice
			begin			
			    assign dstWID   = srcWID;
				assign dstWDATA	= srcWDATA;
				assign dstWSTRB	= srcWSTRB;
				assign dstWLAST	= srcWLAST;
				assign dstWUSER	= srcWUSER;
				assign dstWVALID = srcWVALID;
				assign srcWREADY = dstWREADY;
			end
				
		else if ( WCHAN == 1 )		// Write Data Channel -  Register Slice
			begin
			
				//=====================================================================================
				// Write Data Channel signal bus
				//=====================================================================================
				localparam WCHAN_WIDTH = DATA_WIDTH+(DATA_WIDTH/8)+1+USER_WIDTH+ID_WIDTH;

				wire [WCHAN_WIDTH-1:0]	srcWCHAN, dstWCHAN;

				assign srcWCHAN = { 	srcWID, srcWDATA,srcWSTRB,srcWLAST,srcWUSER}; 
										
				caxi4interconnect_RegSliceFull #
					( .CHAN_WIDTH( WCHAN_WIDTH )	)	//  the number of channel signals to register (outside of Valid & Ready) 
				wrs (
						.sysClk	( 	sysClk 		),
						.sysReset( 	sysReset 	),						
						.mDat( 		srcWCHAN 	),		// channel data signals to register from "master" or "source"
						.mValid( 	srcWVALID 	),		// indicates when mDat is valid
						.mReady( 	srcWREADY	),		// indicates when taking data from "master" or "source"
						.sDat( 		dstWCHAN 	),		// channel data signals registered to "slave" or "sink"
						.sValid( 	dstWVALID 	),		// indicates when sDat is valid
						.sReady( 	dstWREADY 	)		// indicates when slave/sink taking sDat
					);
			

				assign dstWUSER		= dstWCHAN[USER_WIDTH-1:0];
				assign dstWLAST		= dstWCHAN[1+USER_WIDTH-1:USER_WIDTH];
				assign dstWSTRB		= dstWCHAN[(DATA_WIDTH/8)+1+USER_WIDTH-1:1+USER_WIDTH];
				assign dstWDATA		= dstWCHAN[DATA_WIDTH+(DATA_WIDTH/8)+1+USER_WIDTH-1:(DATA_WIDTH/8)+1+USER_WIDTH];
				assign dstWID       = dstWCHAN[DATA_WIDTH+(DATA_WIDTH/8)+1+USER_WIDTH+ID_WIDTH-1:DATA_WIDTH+(DATA_WIDTH/8)+1+USER_WIDTH];
	
			end	
	endgenerate

	
	generate
		if ( BCHAN == 0 ) 			//  Write Response Channel - direct connection, no Register Slice
			begin			
				assign srcBID	= dstBID;
				assign srcBRESP	= dstBRESP;
				assign srcBUSER	= dstBUSER;
				assign srcBVALID = dstBVALID;
				assign dstBREADY = srcBREADY;
			end
				
		else if ( BCHAN == 1 )		// Write Response Channel -  Register Slice
			begin
			
				//=====================================================================================
				// Write Response Channel signal bus
				//=====================================================================================
				localparam BCHAN_WIDTH = ID_WIDTH+2+USER_WIDTH;
				
				wire [BCHAN_WIDTH-1:0]	srcBCHAN, dstBCHAN;

				assign dstBCHAN = { 	dstBID, 		dstBRESP, 
										dstBUSER				 	}; 
				// For BCHAN - master/src is "dst" and slave/sink is "src"
				caxi4interconnect_RegSliceFull #
					( .CHAN_WIDTH( BCHAN_WIDTH )	)	//  the number of channel signals to register (outside of Valid & Ready) 
				brs (
						.sysClk	( 	sysClk 		),
						.sysReset( 	sysReset 	),						
						.mDat( 		dstBCHAN 	),		// channel data signals to register from "master" or "source"
						.mValid( 	dstBVALID 	),		// indicates when mDat is valid
						.mReady( 	dstBREADY	),		// indicates when taking data from "master" or "source"
						.sDat( 		srcBCHAN 	),		// channel data signals registered to "slave" or "sink"
						.sValid( 	srcBVALID 	),		// indicates when sDat is valid
						.sReady( 	srcBREADY 	)		// indicates when slave/sink taking sDat
					);
			

				assign srcBUSER		= srcBCHAN[USER_WIDTH-1:0];
				assign srcBRESP		= srcBCHAN[2+USER_WIDTH-1:USER_WIDTH];
				assign srcBID		= srcBCHAN[ID_WIDTH+2+USER_WIDTH-1:2+USER_WIDTH];
	
			end	
	endgenerate



endmodule		// caxi4interconnect_RegisterSlice.v
