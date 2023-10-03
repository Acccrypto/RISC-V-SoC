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
//    Abstract  : This file provides an Master Protocol Converter for each master. All master side ports
//                can be AHB-Lite, AXI3, AXI4 or AXI4-Lite. Infrastructure components ensure all ports 
//                are converted to AXI4 to be switched by caxi4interconnect_Axi4CrossBar.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_MstrProtocolConverter #

	(
		parameter integer 	NUM_MASTERS			= 4,			// defines number of master ports 
		parameter integer 	MASTER_NUMBER		= 0,			//current master
		parameter integer 	ADDR_WIDTH      	= 20,			// valid values - 16 - 64
		parameter integer 	DATA_WIDTH 			= 32,			// valid widths - 32, 64, 128, 256
		
		parameter [1:0] 	MASTER_TYPE			= 2'b00,		// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11
		
		parameter integer 	USER_WIDTH 			= 1,			// defines the number of bits for USER signals RUSER and WUSER
	
		parameter integer 	ID_WIDTH   			= 1				// number of bits for ID (ie AID, WID, BID) - valid 1-8 
		
	)
	(

	//=====================================  Global Signals   ========================================================================
		input  wire                         ACLK,
		input  wire                       	sysReset,			// active low reset synchronoise to RE AClk - asserted async.
		
	output reg [ID_WIDTH-1:0] 		int_masterARID,
	output reg [ADDR_WIDTH-1:0]		int_masterARADDR,
	output reg [7:0]        		int_masterARLEN,
	output reg [2:0]          		int_masterARSIZE,
	output reg [1:0]          		int_masterARBURST,
	output reg [1:0]          		int_masterARLOCK,
	output reg [3:0]           		int_masterARCACHE,
	output reg [2:0]         		int_masterARPROT,
	output reg [3:0]          		int_masterARREGION,
	output reg [3:0]          		int_masterARQOS,
	output reg [USER_WIDTH-1:0]		int_masterARUSER,
	output reg            			int_masterARVALID,
	input wire             			int_masterARREADY,

	// Master Read Data Ports	
	input wire [ID_WIDTH-1:0]   	int_masterRID,
	input wire [DATA_WIDTH-1:0]		int_masterRDATA,
	input wire [1:0]           		int_masterRRESP,
	input wire                		int_masterRLAST,
	input wire [USER_WIDTH-1:0] 	int_masterRUSER,
	input wire                 		int_masterRVALID,
	output reg               		int_masterRREADY,

	// Master Write Address Ports	
	output reg [ID_WIDTH-1:0]  		int_masterAWID,
	output reg [ADDR_WIDTH-1:0] 	int_masterAWADDR,
	output reg [7:0]           		int_masterAWLEN,
	output reg [2:0]           		int_masterAWSIZE,
	output reg [1:0]           		int_masterAWBURST,
	output reg [1:0]           		int_masterAWLOCK,
	output reg [3:0]          		int_masterAWCACHE,
	output reg [2:0]           		int_masterAWPROT,
	output reg [3:0]            	int_masterAWREGION,
	output reg [3:0]           		int_masterAWQOS,
	output reg [USER_WIDTH-1:0]   	int_masterAWUSER,
	output reg                 		int_masterAWVALID,
	input wire                		int_masterAWREADY,
	
	// Master Write Data Ports	
	output reg [ID_WIDTH-1:0]       int_masterWID,
	output reg [DATA_WIDTH-1:0]  	int_masterWDATA,
	output reg [(DATA_WIDTH/8)-1:0]	int_masterWSTRB,
	output reg                  	int_masterWLAST,
	output reg [USER_WIDTH-1:0] 	int_masterWUSER,
	output reg                  	int_masterWVALID,
	input wire                   	int_masterWREADY,
			
	// Master Write Response Ports	
	input  wire [ID_WIDTH-1:0]		int_masterBID,
	input  wire [1:0]           	int_masterBRESP,
	input  wire [USER_WIDTH-1:0] 	int_masterBUSER,
	input  wire      				int_masterBVALID,
	output reg						int_masterBREADY,

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
	output reg                		MASTER_ARREADY,
	
	// Master Read Data Ports	
	output reg [ID_WIDTH-1:0]  		MASTER_RID,
	output reg [DATA_WIDTH-1:0]  	MASTER_RDATA,
	output reg [1:0]           		MASTER_RRESP,
	output reg                  	MASTER_RLAST,
	output reg [USER_WIDTH-1:0] 	MASTER_RUSER,
	output reg               		MASTER_RVALID,
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
	output reg                		MASTER_AWREADY,
	
	// Master Write Data Ports	
	input  wire [ID_WIDTH-1:0]   	MASTER_WID,
	input wire [DATA_WIDTH-1:0]   	MASTER_WDATA,
	input wire [(DATA_WIDTH/8)-1:0]	MASTER_WSTRB,
	input wire                   	MASTER_WLAST,
	input wire [USER_WIDTH-1:0] 	MASTER_WUSER,
	input wire                  	MASTER_WVALID,
	output reg                  	MASTER_WREADY,
	
	// Master Write Response Ports	
	output reg [ID_WIDTH-1:0]		MASTER_BID,
	output reg [1:0]           		MASTER_BRESP,
	output reg [USER_WIDTH-1:0]  	MASTER_BUSER,
	output reg      				MASTER_BVALID,
	input wire						MASTER_BREADY

	);


//================================================= External Side Ports  ================================================//
	
	
	generate
		if ( MASTER_TYPE == 2'b00) 		// AXI4 Master type - direct connection
			begin
			
				//====================================== ASSIGNEMENTS =================================================
				always @(*)
					begin
			
						//from master to crossbar
						int_masterAWID 		<= MASTER_AWID;
						int_masterAWADDR 	<= MASTER_AWADDR;
						int_masterAWLEN 	<= MASTER_AWLEN;
						int_masterAWSIZE 	<= MASTER_AWSIZE;
						int_masterAWBURST 	<= MASTER_AWBURST;
						int_masterAWLOCK 	<= MASTER_AWLOCK;
						int_masterAWCACHE 	<= MASTER_AWCACHE;
						int_masterAWPROT 	<= MASTER_AWPROT;
						int_masterAWREGION 	<= MASTER_AWREGION;
						int_masterAWQOS 	<= MASTER_AWQOS;				// not used
						int_masterAWUSER 	<= MASTER_AWUSER;				// not used
						int_masterAWVALID 	<= MASTER_AWVALID;
						int_masterWID       <= {ID_WIDTH{1'b0}};
						int_masterWDATA 	<= MASTER_WDATA;
						int_masterWSTRB 	<= MASTER_WSTRB;
						int_masterWLAST 	<= MASTER_WLAST;
						int_masterWUSER 	<= MASTER_WUSER;
						int_masterWVALID	<= MASTER_WVALID;
						int_masterBREADY 	<= MASTER_BREADY;
						int_masterARID 		<= MASTER_ARID;
						int_masterARADDR 	<= MASTER_ARADDR;
						int_masterARLEN 	<= MASTER_ARLEN;
						int_masterARSIZE 	<= MASTER_ARSIZE;
						int_masterARBURST 	<= MASTER_ARBURST;
						int_masterARLOCK 	<= MASTER_ARLOCK;
						int_masterARCACHE 	<= MASTER_ARCACHE;
						int_masterARPROT 	<= MASTER_ARPROT;
						int_masterARREGION 	<= MASTER_ARREGION;
						int_masterARQOS 	<= MASTER_ARQOS;		// not used
						int_masterARUSER 	<= MASTER_ARUSER;
						int_masterARVALID 	<= MASTER_ARVALID;
						int_masterRREADY 	<= MASTER_RREADY;

						//================================================= External Side Ports  ===============================
						//from crossbar to master
						MASTER_AWREADY 		<= int_masterAWREADY;
						MASTER_WREADY 		<= int_masterWREADY;
						MASTER_BID 			<= int_masterBID;
						MASTER_BRESP 		<= int_masterBRESP;
						MASTER_BUSER 		<= int_masterBUSER;
						MASTER_BVALID 		<= int_masterBVALID;
						MASTER_ARREADY 		<= int_masterARREADY;

						MASTER_RID 			<= int_masterRID;
						MASTER_RDATA 		<= int_masterRDATA;
						MASTER_RRESP 		<= int_masterRRESP;
						MASTER_RLAST 		<= int_masterRLAST;
						MASTER_RUSER 		<= int_masterRUSER;
						MASTER_RVALID 		<= int_masterRVALID;

					end
			end
			
		else if ( MASTER_TYPE == 2'b01) 		// AXI4-Lite Master type	
			begin
			
				always @(*)
					begin
					
						int_masterAWLEN  	<= 0; 			// always single cycle
						int_masterAWBURST  	<= 2'b01;		// burst length is defined as 1.

						int_masterAWLOCK <= 0;

						int_masterAWCACHE 	<= 4'b0000;		// <= 0b0000; signal discarded. All transactions are treated as Non-modifiable and Non-bufferable.
						int_masterWLAST 	<= 1'b1;		// 
						int_masterARLEN 	<= 0; 			// always 1 beat in burst
						int_masterARBURST  	<= 2'b01;		// burst length is defined as 1.
						
						int_masterARLOCK <= 0;
						
						int_masterARCACHE  	<= 4'b0000;		// <= 0b0000; signal discarded. All transactions are treated as Non-modifiable and Non-bufferable.

						int_masterAWID <= 0;				//MASTER_AWID not provided. Use fixed ID value. All transactions must be in order
						// andreag: propagate the master transfer size for any data_width
						int_masterAWSIZE <= MASTER_AWSIZE;	//3'b010
						int_masterARSIZE <= MASTER_ARSIZE;	//3'b010
						// from master to crossbar
				    
						int_masterAWADDR 	<= MASTER_AWADDR;
				    
						int_masterAWPROT 	<= MASTER_AWPROT;
						int_masterAWREGION 	<= MASTER_AWREGION;
						int_masterAWQOS 	<= MASTER_AWQOS;				// not used
						int_masterAWUSER 	<= MASTER_AWUSER;				// not used
						int_masterAWVALID 	<= MASTER_AWVALID;
						int_masterWID       <= {ID_WIDTH{1'b0}};
						int_masterWDATA 	<= MASTER_WDATA;
						int_masterWSTRB 	<= MASTER_WSTRB;
						int_masterWUSER 	<= MASTER_WUSER;
						int_masterWVALID 	<= MASTER_WVALID;
						int_masterBREADY 	<= MASTER_BREADY;
						int_masterARID 		<= MASTER_ARID;
						int_masterARADDR 	<= MASTER_ARADDR;

						int_masterARPROT 	<= MASTER_ARPROT;
						int_masterARREGION 	<= MASTER_ARREGION;
						int_masterARQOS 	<= MASTER_ARQOS;		// not used
						int_masterARUSER 	<= MASTER_ARUSER;
						int_masterARVALID 	<= MASTER_ARVALID;
						int_masterRREADY 	<= MASTER_RREADY;
				   
						//================================= External Side Ports  ==============================================

						//from crossbar to master
						MASTER_AWREADY 	<= int_masterAWREADY;
						MASTER_WREADY 	<= int_masterWREADY;
						MASTER_BID 		<= int_masterBID;

						if (int_masterBRESP == 2'b01)	//EXOKAY Not supported by AXI4Lite protocol
							begin
								MASTER_BRESP <= 2'b00; //OKAY
							end
						else
							begin
								MASTER_BRESP <= int_masterBRESP;
							end
							
						MASTER_BUSER 	<= int_masterBUSER;
						MASTER_BVALID 	<= int_masterBVALID;
						MASTER_ARREADY 	<= int_masterARREADY;

						MASTER_RID 		<= int_masterRID;
						MASTER_RDATA 	<= int_masterRDATA;
						
						if (int_masterRRESP == 2'b01)	//EXOKAY Not supported by AXI4Lite protocol
							begin
								MASTER_RRESP <= 2'b00; //OKAY
							end
						else
							begin
								MASTER_RRESP <= int_masterRRESP;
							end
							
						MASTER_RLAST 	<= int_masterRLAST;
						MASTER_RUSER 	<= int_masterRUSER;
						MASTER_RVALID 	<= int_masterRVALID;
					end
			end

		else 			// Axi3 to AXI4
			begin
				always @(*)
					begin
						//from master to crossbar
						int_masterAWID 		<= MASTER_AWID;
						int_masterAWADDR 	<= MASTER_AWADDR;
						int_masterAWLEN 	<= MASTER_AWLEN;
						int_masterAWSIZE 	<= MASTER_AWSIZE;
						int_masterAWBURST 	<= MASTER_AWBURST;
						
						int_masterAWLOCK <= ( MASTER_AWLOCK == 2'b10 ) ? 2'b00 : MASTER_AWLOCK;	//map between AXI3 and AXI4 locking mechanisms
						
						int_masterAWCACHE 	<= MASTER_AWCACHE;
						int_masterAWPROT 	<= MASTER_AWPROT;
						int_masterAWREGION 	<= MASTER_AWREGION;
						int_masterAWQOS 	<= MASTER_AWQOS;				// not used
						int_masterAWUSER 	<= MASTER_AWUSER;				// not used
						int_masterAWVALID 	<= MASTER_AWVALID;
						int_masterWID       <= MASTER_WID;
						int_masterWDATA 	<= MASTER_WDATA;
						int_masterWSTRB 	<= MASTER_WSTRB;
						int_masterWLAST 	<= MASTER_WLAST;
						int_masterWUSER 	<= MASTER_WUSER;
						int_masterWVALID	<= MASTER_WVALID;
						int_masterBREADY 	<= MASTER_BREADY;
						int_masterARID 		<= MASTER_ARID;
						int_masterARADDR 	<= MASTER_ARADDR;
						int_masterARLEN 	<= MASTER_ARLEN;
						int_masterARSIZE 	<= MASTER_ARSIZE;
						int_masterARBURST 	<= MASTER_ARBURST;
						
						int_masterARLOCK <= ( MASTER_ARLOCK == 2'b10 ) ? 2'b00 : MASTER_AWLOCK;	//map between AXI3 and AXI4 locking mechanisms
						
						int_masterARCACHE 	<= MASTER_ARCACHE;
						int_masterARPROT 	<= MASTER_ARPROT;
						int_masterARREGION 	<= MASTER_ARREGION;
						int_masterARQOS 	<= MASTER_ARQOS;		// not used
						int_masterARUSER 	<= MASTER_ARUSER;
						int_masterARVALID 	<= MASTER_ARVALID;
						int_masterRREADY 	<= MASTER_RREADY;

						//================================================= External Side Ports  ===============================
						//from crossbar to master
						MASTER_AWREADY 		<= int_masterAWREADY;
						MASTER_WREADY 		<= int_masterWREADY;
						MASTER_BID 			<= int_masterBID;
						MASTER_BRESP 		<= int_masterBRESP;
						MASTER_BUSER 		<= int_masterBUSER;
						MASTER_BVALID 		<= int_masterBVALID;
						MASTER_ARREADY 		<= int_masterARREADY;

						MASTER_RID 			<= int_masterRID;
						MASTER_RDATA 		<= int_masterRDATA;
						MASTER_RRESP 		<= int_masterRRESP;
						MASTER_RLAST 		<= int_masterRLAST;
						MASTER_RUSER 		<= int_masterRUSER;
						MASTER_RVALID 		<= int_masterRVALID;
						
					end
			end
			
	endgenerate
	
endmodule 
