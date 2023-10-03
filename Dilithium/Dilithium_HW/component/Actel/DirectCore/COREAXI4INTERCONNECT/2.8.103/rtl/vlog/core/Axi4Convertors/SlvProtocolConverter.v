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
//    Abstract   : This file provides an Slave Protocol Converter for each slave. All slave side ports
//                 can be AXI3, AXI4 or AXI4-Lite. Infrastructure components ensure all ports are
//                 converted to AXI4 to be switched by caxi4interconnect_Axi4CrossBar.
//                                                               
//                 Note: AXI3 Interleaving not supported in AXI3 interface module.               
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_SlvProtocolConverter #

	(
		parameter integer 	NUM_SLAVES			= 4,			// defines number of slave ports
		
		parameter integer 	SLAVE_NUMBER		= 0,			//current slave
		parameter integer 	ADDR_WIDTH      	= 20,			// valid values - 16 - 64
		parameter integer 	DATA_WIDTH 			= 32,			// valid widths - 32, 64, 128, 256
		
		parameter [1:0] 	SLAVE_TYPE			= 2'b11,		// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11
		parameter [0:0] 	READ_ZERO_SLAVE_ID		= 1'b1,	// zero ID field		
		parameter [0:0] 	WRITE_ZERO_SLAVE_ID		= 1'b1,	// zero ID field		

		parameter integer 	USER_WIDTH 			= 1,			// defines the number of bits for USER signals RUSER and WUSER
	
		parameter integer 	ID_WIDTH   			= 3,			// number of bits for ID (ie AID, WID, BID) - valid 1-8 
		
		parameter integer   SLV_AXI4PRT_ADDRDEPTH = 8,		// Number transations width - 1 => 2 transations, 2 => 4 transations, etc.
		parameter integer   SLV_AXI4PRT_DATADEPTH = 8,		// Number transations width - 1 => 2 transations, 2 => 4 transations, etc.		
		parameter integer   MAX_TRANS             = 8,		// Number of maximum transaction
		
		parameter           READ_INTERLEAVE       = 0       // 1 - Enable out of order transaction 0 - Diable out of order transaction
	
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
	output wire             		int_slaveARREADY,

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
	input wire [DATA_WIDTH-1:0]  	SLAVE_RDATA,
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
	output  wire [ID_WIDTH-1:0]   	SLAVE_WID,
	output wire [DATA_WIDTH-1:0]   	SLAVE_WDATA,
	output wire [(DATA_WIDTH/8)-1:0] SLAVE_WSTRB,
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
		if ( SLAVE_TYPE == 2'b00) 		// AXI4 Slave type - direct connection
			begin
				//====================================== ASSIGNEMENTS =================================================
						//from crossbar to Slave
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
				assign SLAVE_WID   = 0;
				assign SLAVE_WDATA = int_slaveWDATA;
				assign SLAVE_WSTRB = int_slaveWSTRB;
				assign SLAVE_WLAST = int_slaveWLAST;
				assign SLAVE_WUSER = int_slaveWUSER;
				assign SLAVE_WVALID = int_slaveWVALID;
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
				//			
				//from		Slave to crossbar	
				assign int_slaveWREADY = SLAVE_WREADY;
				assign int_slaveBRESP =	SLAVE_BRESP;
				assign int_slaveBUSER =	SLAVE_BUSER;
						
				assign int_slaveRDATA =	SLAVE_RDATA;
				assign int_slaveRRESP =	SLAVE_RRESP;
				assign int_slaveRLAST =	SLAVE_RLAST;
				assign int_slaveRUSER =	SLAVE_RUSER;


                                caxi4interconnect_SlvAxi4ProtConvAXI4ID #
							(
								.ID_WIDTH( ID_WIDTH ),		// includes infrastructure ID
								.ZERO_SLAVE_ID( READ_ZERO_SLAVE_ID ),				
								.SLV_AXI4PRT_ADDRDEPTH 		( SLV_AXI4PRT_ADDRDEPTH ),
								.READ_INTERLEAVE            (READ_INTERLEAVE)
							)
						u_SlvAxi4ReadID (
									.ACLK( ACLK ),
									.sysReset( sysReset ),				// active low reset synchronoise to RE AClk - asserted async.
									
									//===================== Master to SLAVE direction==================================
									//READ Request Chan	
									.int_slaveAID			( int_slaveARID ),	

									//READ REASPONSE Chan response
									.int_slaveREADY		( int_slaveRREADY ),
									.int_slaveVALID		( int_slaveRVALID ),
									//================= SLAVE to Master direction ================================== 
									//READ DATA Chan				
									.int_slaveID		( int_slaveRID ),

									//READ Address Request Chan Response
									.int_slaveAREADY	( int_slaveARREADY ),
									.int_slaveAVALID		( int_slaveARVALID ),	
									
									//READ Address Request Chan
									.SLAVE_AID			( SLAVE_ARID ),	
									.SLAVE_AREADY		( SLAVE_ARREADY ),	
									.SLAVE_AVALID		( SLAVE_ARVALID ),

									//READ DATA Chan	
									.SLAVE_VALID		( SLAVE_RVALID ),
									.SLAVE_LAST		( SLAVE_RLAST ),
									.SLAVE_READY		( SLAVE_RREADY ),
									.SLAVE_ID			( SLAVE_RID )
								); 


                                
                                caxi4interconnect_SlvAxi4ProtConvAXI4ID #
							(
								.ID_WIDTH( ID_WIDTH ),		// includes infrastructure ID
								.ZERO_SLAVE_ID( WRITE_ZERO_SLAVE_ID ),				
								.SLV_AXI4PRT_ADDRDEPTH 		( SLV_AXI4PRT_ADDRDEPTH ),
								.READ_INTERLEAVE            (READ_INTERLEAVE)
							)
						u_SlvAxi4WriteID (
									.ACLK( ACLK ),
									.sysReset( sysReset ),				// active low reset synchronoise to RE AClk - asserted async.
									
									//===================== Master to SLAVE direction==================================
									//WRITE Request Chan	
									.int_slaveAID			( int_slaveAWID ),	

									//WRITE REASPONSE Chan response
									.int_slaveREADY		( int_slaveBREADY ),
									.int_slaveVALID		( int_slaveBVALID ),
								
									//================= SLAVE to Master direction ================================== 
									//WRITE RESPONSE Chan				
									.int_slaveID		( int_slaveBID ),

									//WRITE Address Request Chan Response
									.int_slaveAREADY	( int_slaveAWREADY ),
									.int_slaveAVALID		( int_slaveAWVALID ),	
	
									//WRITE Address Request Chan
									.SLAVE_AID			( SLAVE_AWID ),	
									.SLAVE_AREADY		( SLAVE_AWREADY ),	
									.SLAVE_AVALID		( SLAVE_AWVALID ),
				
									//WRITE RESPONSE Chan	
									.SLAVE_VALID		( SLAVE_BVALID ),
									.SLAVE_READY		( SLAVE_BREADY ),
									.SLAVE_LAST		( 1'b1 ),
									.SLAVE_ID			( SLAVE_BID )				
								); 


			end
		else if ( SLAVE_TYPE == 2'b01) 		// AXI4-Lite Slave type	
			begin

				//==========================================================================
				// Assign signals not used by AXI4Lite 
				//==========================================================================
				assign  SLAVE_ARLEN		= 0;
				assign  SLAVE_ARSIZE	= $clog2(DATA_WIDTH/8);  // andreag: set the transfer size to the full bus width (spec B1-123). Previously was tied to 0;
				assign  SLAVE_ARBURST	= 2'b01;
				assign  SLAVE_ARLOCK	= 0;
				assign  SLAVE_ARCACHE	= 0;
				assign 	SLAVE_ARQOS		= 0;
				assign 	SLAVE_ARUSER    = 0;

				assign  SLAVE_AWLEN		= 0;
				assign  SLAVE_AWSIZE	= $clog2(DATA_WIDTH/8);  // andreag: set the transfer size to the full bus width (spec B1-123). Previously was tied to 0;
				assign  SLAVE_AWBURST	= 2'b01;
				assign  SLAVE_AWLOCK	= 0;
				assign  SLAVE_AWCACHE	= 0;
				assign 	SLAVE_AWQOS		= 0;
				assign  SLAVE_AWUSER    = 0;

				assign SLAVE_WID   = 0;
				assign SLAVE_WUSER = 0;			
				assign 	SLAVE_WLAST 	= 1'b1;			// always burst of 1	- set to 1 to allow models to work without change
				
				assign SLAVE_AWREGION 	= 0;		// TC: These signals exist, so need to be driven, though unused externally
				assign SLAVE_AWQOS 		= 0;
				assign SLAVE_ARREGION 	= 0;		
				assign SLAVE_ARQOS 		= 0;
				
 				caxi4interconnect_SlvAxi4ProtocolConv #
							(
								.SLAVE_NUMBER( SLAVE_NUMBER ),		// slave number
								.SLAVE_TYPE( 2'b01	),				// AXI4Lite Slave

								.ID_WIDTH( ID_WIDTH ),		// includes infrastructure ID
								.ADDR_WIDTH( ADDR_WIDTH ),				
								.DATA_WIDTH( DATA_WIDTH ), 
								.USER_WIDTH( USER_WIDTH ),
								.SLV_AXI4PRT_ADDRDEPTH 		( SLV_AXI4PRT_ADDRDEPTH ),
								.SLV_AXI4PRT_DATADEPTH 		( SLV_AXI4PRT_DATADEPTH )
							)
						u_AXILtePC (
									.ACLK( ACLK ),
									.sysReset( sysReset ),				// active low reset synchronoise to RE AClk - asserted async.
									
									//===================== Master to SLAVE direction==================================
									//WRITE ADDRESS Chan
									.int_slaveAWID			( int_slaveAWID),	
									.int_slaveAWADDR		( int_slaveAWADDR ),	
									.int_slaveAWLEN			( int_slaveAWLEN ),	
									.int_slaveAWSIZE		( int_slaveAWSIZE ),	
									.int_slaveAWBURST		( int_slaveAWBURST ),	
									.int_slaveAWLOCK		( int_slaveAWLOCK ),	
									.int_slaveAWCACHE		( int_slaveAWCACHE  ),	
									.int_slaveAWPROT		( int_slaveAWPROT  ),	
									.int_slaveAWREGION		( int_slaveAWREGION  ), 	
									.int_slaveAWQOS			( int_slaveAWQOS ),	
									.int_slaveAWUSER		( int_slaveAWUSER ),	
									.int_slaveAWVALID		( int_slaveAWVALID ),	
									//WRITE DATA Chan
									.int_slaveWDATA			( int_slaveWDATA ),	
									.int_slaveWSTRB			( int_slaveWSTRB ),	
									.int_slaveWLAST			( int_slaveWLAST ),	
									.int_slaveWUSER			( int_slaveWUSER ),	
									.int_slaveWVALID		( int_slaveWVALID ),	
									//WRITE RESPONSE Chan response
									.int_slaveBREADY		( int_slaveBREADY ),
									//READ Request Chan	
									.int_slaveARID			( int_slaveARID ),	
									.int_slaveARADDR		( int_slaveARADDR ),	
									.int_slaveARLEN			( int_slaveARLEN ),	
									.int_slaveARSIZE		( int_slaveARSIZE ),	
									.int_slaveARBURST		( int_slaveARBURST ),	
									.int_slaveARLOCK		( int_slaveARLOCK ),	
									.int_slaveARCACHE		( int_slaveARCACHE ),	
									.int_slaveARPROT		( int_slaveARPROT ),	
									.int_slaveARREGION		( int_slaveARREGION ), 	
									.int_slaveARQOS			( int_slaveARQOS ),	
									.int_slaveARUSER		( int_slaveARUSER ),	
									.int_slaveARVALID		( int_slaveARVALID ),	
									
									//READ REASPONSE Chan response
									.int_slaveRREADY		( int_slaveRREADY ),

									//================= SLAVE to Master direction ================================== 
									//WRITE ADDRESS Chan response
									.int_slaveAWREADY	( int_slaveAWREADY ),	
									//WRITE DATA Chan response
									.int_slaveWREADY	( int_slaveWREADY ),	
									//WRITE RESPONSE Chan				
									.int_slaveBID		( int_slaveBID ),	
									.int_slaveBRESP		( int_slaveBRESP ),	
									.int_slaveBUSER		( int_slaveBUSER ),	
									.int_slaveBVALID	( int_slaveBVALID ),	
									//READ DATA Chan				
									.int_slaveRID		( int_slaveRID ),	
									.int_slaveRDATA		( int_slaveRDATA ),	
									.int_slaveRRESP		( int_slaveRRESP ),	
									.int_slaveRLAST		( int_slaveRLAST ),	
									.int_slaveRUSER		( int_slaveRUSER ),	
									.int_slaveRVALID	( int_slaveRVALID ),
									//READ Address Request Chan Response
									.int_slaveARREADY	( int_slaveARREADY ),
									
									//WRITE ADDRESS Chan
									.SLAVE_AWID			( SLAVE_AWID ),			
									.SLAVE_AWADDR		( SLAVE_AWADDR ),	
									.SLAVE_AWLEN		(  ),	
									.SLAVE_AWSIZE		(  ),	
									.SLAVE_AWBURST		(  ),	
									.SLAVE_AWLOCK		(  ),	
									.SLAVE_AWCACHE		(  ),	
									.SLAVE_AWPROT		( SLAVE_AWPROT ),		
									.SLAVE_AWVALID		( SLAVE_AWVALID ),	
									.SLAVE_AWREADY		( SLAVE_AWREADY ),	  			
									
									//WRITE DATA Chan
									//.SLAVE_WID			( SLAVE_WID ),
									.SLAVE_WDATA		( SLAVE_WDATA ),	
									.SLAVE_WSTRB		( SLAVE_WSTRB ),	
									.SLAVE_WLAST		(  ),		
									.SLAVE_WVALID		( SLAVE_WVALID ),
									.SLAVE_WREADY		( SLAVE_WREADY ),
									//WRITE RESPONSE Chan									
									.SLAVE_BID			( SLAVE_BID ),	
									.SLAVE_BRESP		( SLAVE_BRESP ),		
									.SLAVE_BVALID		( SLAVE_BVALID ),	
									.SLAVE_BREADY		( SLAVE_BREADY ),
									//READ Address Request Chan
									.SLAVE_ARID			( SLAVE_ARID ),	
									.SLAVE_ARADDR		( SLAVE_ARADDR ),	
									.SLAVE_ARLEN		(  ),	
									.SLAVE_ARSIZE		(  ),	
									.SLAVE_ARBURST		(  ),	
									.SLAVE_ARLOCK		(  ),	
									.SLAVE_ARCACHE		(  ),	
									.SLAVE_ARPROT		( SLAVE_ARPROT ),		
									.SLAVE_ARVALID		( SLAVE_ARVALID ),			
									.SLAVE_ARREADY		( SLAVE_ARREADY ),													
				
									//READ DATA Chan	
									.SLAVE_RREADY		( SLAVE_RREADY ),
									.SLAVE_RID			( SLAVE_RID ),				
									.SLAVE_RDATA		( SLAVE_RDATA ),	
									.SLAVE_RRESP		( SLAVE_RRESP ),	
									.SLAVE_RLAST		( 1'b1 ),				// always burst of 1	
									.SLAVE_RVALID		( SLAVE_RVALID )
								); 
 								
					end
					
		else //if ( SLAVE_TYPE == 2'b11) 		// AXI4-AXI3 Slave type	
			begin
			
				assign SLAVE_AWLEN[7:4] = 0;	// tie upper bit to 0 as not used in AXI3
				assign SLAVE_WUSER = 0;			// not used in AXI3

				assign SLAVE_AWREGION = 0;		// just to pass protocol checker
				assign SLAVE_AWQOS = 0;
				assign SLAVE_AWUSER = 0;
			
				assign SLAVE_ARREGION = 0;		// just to pass protocol checker
				assign SLAVE_ARQOS = 0;
				assign SLAVE_ARUSER = 0;
				
 				caxi4interconnect_SlvAxi4ProtocolConv #
							(
								.SLAVE_NUMBER( SLAVE_NUMBER ),		// slave number
								.SLAVE_TYPE( 2'b11	),				// AXI3 Slave

								.ID_WIDTH( ID_WIDTH ),		// includes infrastructure ID
								.ADDR_WIDTH( ADDR_WIDTH ),				
								.DATA_WIDTH( DATA_WIDTH ), 
								.USER_WIDTH( USER_WIDTH ),
								.SLV_AXI4PRT_ADDRDEPTH 		( SLV_AXI4PRT_ADDRDEPTH ),
								.SLV_AXI4PRT_DATADEPTH 		( SLV_AXI4PRT_DATADEPTH ),
								.MAX_TRANS 		            ( MAX_TRANS ),
								.READ_INTERLEAVE            ( READ_INTERLEAVE )
							)
						u_AXI3ProtConv (
									.ACLK( ACLK ),
									.sysReset( sysReset ),				// active low reset synchronoise to RE AClk - asserted async.
									
									//===================== Master to SLAVE direction==================================
									//WRITE ADDRESS Chan
									.int_slaveAWID			( int_slaveAWID),	
									.int_slaveAWADDR		( int_slaveAWADDR ),	
									.int_slaveAWLEN			( int_slaveAWLEN ),	
									.int_slaveAWSIZE		( int_slaveAWSIZE ),	
									.int_slaveAWBURST		( int_slaveAWBURST ),	
									.int_slaveAWLOCK		( int_slaveAWLOCK ),	
									.int_slaveAWCACHE		( int_slaveAWCACHE  ),	
									.int_slaveAWPROT		( int_slaveAWPROT  ),	
									.int_slaveAWREGION		( int_slaveAWREGION  ), 	
									.int_slaveAWQOS			( int_slaveAWQOS ),	
									.int_slaveAWUSER		( int_slaveAWUSER ),	
									.int_slaveAWVALID		( int_slaveAWVALID ),	
									//WRITE DATA Chan
									.int_slaveWID 			( int_slaveWID   ),	
									.int_slaveWDATA			( int_slaveWDATA ),	
									.int_slaveWSTRB			( int_slaveWSTRB ),	
									.int_slaveWLAST			( int_slaveWLAST ),	
									.int_slaveWUSER			( int_slaveWUSER ),	
									.int_slaveWVALID		( int_slaveWVALID ),	
									//WRITE RESPONSE Chan response
									.int_slaveBREADY		( int_slaveBREADY ),
									//READ Request Chan	
									.int_slaveARID			( int_slaveARID ),	
									.int_slaveARADDR		( int_slaveARADDR ),	
									.int_slaveARLEN			( int_slaveARLEN ),	
									.int_slaveARSIZE		( int_slaveARSIZE ),	
									.int_slaveARBURST		( int_slaveARBURST ),	
									.int_slaveARLOCK		( int_slaveARLOCK ),	
									.int_slaveARCACHE		( int_slaveARCACHE ),	
									.int_slaveARPROT		( int_slaveARPROT ),	
									.int_slaveARREGION		( int_slaveARREGION ), 	
									.int_slaveARQOS			( int_slaveARQOS ),	
									.int_slaveARUSER		( int_slaveARUSER ),	
									.int_slaveARVALID		( int_slaveARVALID ),	
									
									//READ REASPONSE Chan response
									.int_slaveRREADY		( int_slaveRREADY ),
//=====================================SLAVE to Master direction================================== 
									//WRITE ADDRESS Chan response
									.int_slaveAWREADY		( int_slaveAWREADY ),	
									//WRITE DATA Chan response
									.int_slaveWREADY		( int_slaveWREADY ),	
									//WRITE RESPONSE Chan				
									.int_slaveBID			( int_slaveBID ),	
									.int_slaveBRESP		( int_slaveBRESP ),	
									.int_slaveBUSER		( int_slaveBUSER ),	
									.int_slaveBVALID		( int_slaveBVALID ),	
									//READ DATA Chan				
									.int_slaveRID			( int_slaveRID ),	
									.int_slaveRDATA		( int_slaveRDATA ),	
									.int_slaveRRESP		( int_slaveRRESP ),	
									.int_slaveRLAST		( int_slaveRLAST ),	
									.int_slaveRUSER		( int_slaveRUSER ),	
									.int_slaveRVALID		( int_slaveRVALID ),
									//READ Address Request Chan Response
									.int_slaveARREADY		( int_slaveARREADY ),
									
									//WRITE ADDRESS Chan
									.SLAVE_AWID			( SLAVE_AWID ),	
									.SLAVE_AWADDR		( SLAVE_AWADDR ),	
									.SLAVE_AWLEN		( SLAVE_AWLEN[3:0] ),	
									.SLAVE_AWSIZE		( SLAVE_AWSIZE ),	
									.SLAVE_AWBURST		( SLAVE_AWBURST ),	
									.SLAVE_AWLOCK		( SLAVE_AWLOCK ),	
									.SLAVE_AWCACHE		( SLAVE_AWCACHE ),	
									.SLAVE_AWPROT		( SLAVE_AWPROT ),		
									.SLAVE_AWVALID		( SLAVE_AWVALID ),	
									.SLAVE_AWREADY		( SLAVE_AWREADY ),	  			
									
									//WRITE DATA Chan
									.SLAVE_WID			( SLAVE_WID ),
									.SLAVE_WDATA		( SLAVE_WDATA ),	
									.SLAVE_WSTRB		( SLAVE_WSTRB ),	
									.SLAVE_WLAST		( SLAVE_WLAST ),		
									.SLAVE_WVALID		( SLAVE_WVALID ),
									.SLAVE_WREADY		( SLAVE_WREADY ),
									//WRITE RESPONSE Chan									
									.SLAVE_BID			( SLAVE_BID ),	
									.SLAVE_BRESP		( SLAVE_BRESP ),		
									.SLAVE_BVALID		( SLAVE_BVALID ),	
									.SLAVE_BREADY		( SLAVE_BREADY ),
									//READ Address Request Chan
									.SLAVE_ARID			( SLAVE_ARID ),	
									.SLAVE_ARADDR		( SLAVE_ARADDR ),	
									.SLAVE_ARLEN		( SLAVE_ARLEN ),	
									.SLAVE_ARSIZE		( SLAVE_ARSIZE ),	
									.SLAVE_ARBURST		( SLAVE_ARBURST ),	
									.SLAVE_ARLOCK		( SLAVE_ARLOCK ),	
									.SLAVE_ARCACHE		( SLAVE_ARCACHE ),	
									.SLAVE_ARPROT		( SLAVE_ARPROT ),		
									.SLAVE_ARVALID		( SLAVE_ARVALID ),			
									.SLAVE_ARREADY		( SLAVE_ARREADY ),													
				
									//READ DATA Chan	
									.SLAVE_RREADY		( SLAVE_RREADY ),
									.SLAVE_RID			( SLAVE_RID ),	
									.SLAVE_RDATA		( SLAVE_RDATA ),	
									.SLAVE_RRESP		( SLAVE_RRESP ),	
									.SLAVE_RLAST		( SLAVE_RLAST ),	
									.SLAVE_RVALID		( SLAVE_RVALID )
								); 
 								
					end

endgenerate
	
endmodule 
