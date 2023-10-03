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
//     Abstract  : This module controls the Address MUXing from requestors to targets
//                 and the responses back from the targets.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_TargetMuxController # 
	(
		parameter integer NUM_MASTERS			= 4, 				// defines number of masters
		parameter integer NUM_MASTERS_WIDTH		= 2, 		// defines number of bits to encode master number
		
		parameter integer NUM_SLAVES     		= 4, 				// defines number of slaves
		parameter integer NUM_SLAVES_WIDTH 		= 2,				// defines number of bits to encoode slave number

		parameter integer ID_WIDTH   			= 1, 

		parameter integer ADDR_WIDTH      		= 32,
		parameter integer ADDR_WIDTH_BITS		=  5,				// defines number of bits for ADDR_WIDTh - 64 -6, 32 = 5
		
		parameter integer SUPPORT_USER_SIGNALS 	= 0,
		parameter integer AUSER_WIDTH 			= 1,

		parameter [NUM_MASTERS*NUM_SLAVES-1:0] 		MASTER_CONNECTIVITY = {NUM_MASTERS*NUM_SLAVES{1'b1}},
		
		parameter	HI_FREQ	= 1										// increases freq of operation at cost of added latency
   
	)
	(
		// Global Signals
		input  wire                                     	sysClk,
		input  wire                                     	sysReset,				// active low reset synchronoise to RE AClk - asserted async.

		// Slot Arbitrator
		input wire											requestorSelValid,		// indicates that slot arb has selected an requestorSelValid so drive to Slave
		input wire [NUM_MASTERS_WIDTH-1:0 ]					requestorSelEnc,		// indicates requestor selected by slot arb when active request is asserted - encoded
		input wire [NUM_MASTERS*NUM_SLAVES_WIDTH-1:0]		targetSlave,			// slave that requestors wants to perform transaction with
		output wire											arbEnable,
				
		//====================== Master Ports  ================================================//

		input  wire [NUM_MASTERS*ID_WIDTH-1:0]        	   	MASTER_AID,
		input  wire [NUM_MASTERS*ADDR_WIDTH-1:0] 		    MASTER_AADDR,
		
		input  wire [NUM_MASTERS*8-1:0]                     MASTER_ALEN,
		input  wire [NUM_MASTERS*3-1:0]                     MASTER_ASIZE,
		input  wire [NUM_MASTERS*2-1:0]                     MASTER_ABURST,
		input  wire [NUM_MASTERS*2-1:0]                     MASTER_ALOCK,
		input  wire [NUM_MASTERS*4-1:0]                     MASTER_ACACHE,
		input  wire [NUM_MASTERS*3-1:0]                     MASTER_APROT,
		input  wire [NUM_MASTERS*4-1:0]                     MASTER_AQOS,
		input  wire [NUM_MASTERS*AUSER_WIDTH-1:0]         	MASTER_AUSER,
		output reg  [NUM_MASTERS-1:0]                       MASTER_AREADY,
   
		//====================== Slave Ports  ================================================//
   
   		output wire [NUM_SLAVES-1:0]                        		SLAVE_AVALID,
		input  wire [NUM_SLAVES-1:0]                    	    	SLAVE_AREADY,
		output wire [NUM_SLAVES*8-1:0] 			   		        	SLAVE_ALEN,
		output wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]	SLAVE_AID,

		output wire [(NUM_SLAVES-1)*ADDR_WIDTH-1:0]          	SLAVE_AADDR,		// not routed to DECERR Slaves
		output wire [(NUM_SLAVES-1)*3-1:0]                      SLAVE_ASIZE,		// not routed to DECERR Slaves
		output wire [(NUM_SLAVES-1)*2-1:0]                      SLAVE_ABURST,		// not routed to DECERR Slaves
		output wire [(NUM_SLAVES-1)*2-1:0]                      SLAVE_ALOCK,		// not routed to DECERR Slaves
		output wire [(NUM_SLAVES-1)*4-1:0]                      SLAVE_ACACHE,		// not routed to DECERR Slaves
		output wire [(NUM_SLAVES-1)*3-1:0]                      SLAVE_APROT,		// not routed to DECERR Slaves
		output wire [(NUM_SLAVES-1)*4-1:0]                      SLAVE_AQOS,			// not routed to DECERR Slaves
		output wire [(NUM_SLAVES-1)*AUSER_WIDTH-1:0]        	SLAVE_AUSER,		// not routed to DECERR Slaves

		
		//====================  Data Controller Ports	======================================//
		output reg											dataFifoWr,
		output reg	[(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 		srcPort,
		output reg	[NUM_SLAVES_WIDTH-1:0]					destPort  
	);
   						 
						 
//================================================================================================
// Local Parameters
//================================================================================================

	localparam MASTERID_WIDTH		= ( NUM_MASTERS_WIDTH + ID_WIDTH );			// defines width masterID - includes infrastructure ID plus ID

	
//=================================================================================================
// Local Declarationes
//=================================================================================================
 
	// Slave Address Port - output of MUX of selected requestor
	reg [MASTERID_WIDTH-1:0]       				d_slaveAID, slaveAID;			// append infrastructure ID to AID from master
	reg [ADDR_WIDTH-1:0]          				d_slaveAADDR, slaveAADDR;
	reg [8-1:0]                         		d_slaveALEN, slaveALEN;
	reg [3-1:0]                         		d_slaveASIZE, slaveASIZE;
	reg [2-1:0]                         		d_slaveABURST, slaveABURST;
	reg [2-1:0]                         		d_slaveALOCK, slaveALOCK;
	reg [4-1:0]                         		d_slaveACACHE, slaveACACHE;
	reg [3-1:0]                         		d_slaveAPROT, slaveAPROT;
	reg [4-1:0]                         		d_slaveAQOS, slaveAQOS;
	reg [AUSER_WIDTH-1:0] 	       	  			d_slaveAUSER, slaveAUSER;

	reg [NUM_SLAVES-1:0]               			slaveAVALID;
	wire 						                slaveReady;
   
   	reg [NUM_SLAVES_WIDTH-1:0]					slaveTarget;
    
    // jhayes : Change to make internal signals of larger width, based on 2^NUM_MASTERS_WIDTH. Input signals 
    // come in, based on width of NUM_MASTERS. However, logic inferred below will index beyond this width, hence change.
    wire [(2**NUM_MASTERS_WIDTH)*ID_WIDTH-1:0] i_MASTER_AID;
    wire [(2**NUM_MASTERS_WIDTH)*ADDR_WIDTH-1:0] i_MASTER_AADDR;
    wire [(2**NUM_MASTERS_WIDTH)*8-1:0] i_MASTER_ALEN;
	wire [(2**NUM_MASTERS_WIDTH)*3-1:0] i_MASTER_ASIZE;
    wire [(2**NUM_MASTERS_WIDTH)*2-1:0] i_MASTER_ABURST;
    wire [(2**NUM_MASTERS_WIDTH)*2-1:0] i_MASTER_ALOCK;
    wire [(2**NUM_MASTERS_WIDTH)*4-1:0] i_MASTER_ACACHE;
    wire [(2**NUM_MASTERS_WIDTH)*3-1:0] i_MASTER_APROT;
	wire [(2**NUM_MASTERS_WIDTH)*4-1:0] i_MASTER_AQOS;
	wire [(2**NUM_MASTERS_WIDTH)*AUSER_WIDTH-1:0] i_MASTER_AUSER;
    
    wire [(2**NUM_MASTERS_WIDTH)*NUM_SLAVES_WIDTH-1:0] i_targetSlave;
    
    // jhayes : Padding of input signals.
	assign i_MASTER_AID = 'b0 | MASTER_AID;
	assign i_MASTER_AADDR = 'b0 | MASTER_AADDR;
	assign i_MASTER_ALEN = 'b0 | MASTER_ALEN;
	assign i_MASTER_ASIZE = 'b0 | MASTER_ASIZE;
	assign i_MASTER_ABURST = 'b0 | MASTER_ABURST;
	assign i_MASTER_ALOCK = 'b0 | MASTER_ALOCK;
	assign i_MASTER_ACACHE = 'b0 | MASTER_ACACHE;
	assign i_MASTER_APROT = 'b0 | MASTER_APROT;
	assign i_MASTER_AQOS = 'b0 | MASTER_AQOS;
	assign i_MASTER_AUSER = 'b0 | MASTER_AUSER;
    
	assign i_targetSlave = 'b0 | targetSlave;

//================================================================================================
// MUX address vector based on requestorSel
//================================================================================================

generate

if ( NUM_MASTERS_WIDTH == 1 )
	always @(* )
	begin
	
		// Slave Address Port - latch previous requestor unless active requestor
		d_slaveAID		<= slaveAID;
		d_slaveAADDR 	<= slaveAADDR;
		d_slaveALEN  	<= slaveALEN;
		d_slaveASIZE 	<= slaveASIZE;
		d_slaveABURST	<= slaveABURST;
		d_slaveALOCK	<= slaveALOCK;
		d_slaveACACHE	<= slaveACACHE;
		d_slaveAPROT	<= slaveAPROT;
		d_slaveAQOS		<= slaveAQOS;
		d_slaveAUSER	<= slaveAUSER;

		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					1'b0:	
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[ID_WIDTH-1:0] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ADDR_WIDTH-1:0];
							d_slaveALEN  	<= i_MASTER_ALEN[7:0];
							d_slaveASIZE 	<= i_MASTER_ASIZE[2:0];
							d_slaveABURST	<= i_MASTER_ABURST[1:0];
							d_slaveALOCK	<= i_MASTER_ALOCK[1:0];
							d_slaveACACHE	<= i_MASTER_ACACHE[3:0];
							d_slaveAPROT	<= i_MASTER_APROT[2:0];
							d_slaveAQOS		<= i_MASTER_AQOS[3:0];
							d_slaveAUSER	<= i_MASTER_AUSER[AUSER_WIDTH-1:0];
						end
					1'b1:
						begin
							d_slaveAID  	<= { requestorSelEnc,  i_MASTER_AID[2*ID_WIDTH-1:ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[2*ADDR_WIDTH-1:ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[8+7:8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[3+2:3];
							d_slaveABURST	<= i_MASTER_ABURST[2+1:2];
							d_slaveALOCK	<= i_MASTER_ALOCK[2+1:2];
							d_slaveACACHE	<= i_MASTER_ACACHE[4+3:4];
							d_slaveAPROT	<= i_MASTER_APROT[3+2:3];
							d_slaveAQOS		<= i_MASTER_AQOS[4+3:4];
							d_slaveAUSER	<= i_MASTER_AUSER[2*AUSER_WIDTH-1:AUSER_WIDTH];
						end
					default:
						begin
			
						end
				endcase
			end
			
	end  // always

else if ( NUM_MASTERS_WIDTH == 2 )

	always @(* )
	begin
	
		// Slave Address Port - latch previous requestor unless active requestor
		d_slaveAID		<= slaveAID;
		d_slaveAADDR 	<= slaveAADDR;
		d_slaveALEN  	<= slaveALEN;
		d_slaveASIZE 	<= slaveASIZE;
		d_slaveABURST	<= slaveABURST;
		d_slaveALOCK	<= slaveALOCK;
		d_slaveACACHE	<= slaveACACHE;
		d_slaveAPROT	<= slaveAPROT;
		d_slaveAQOS		<= slaveAQOS;
		d_slaveAUSER	<= slaveAUSER;

		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					2'b00:	
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[ID_WIDTH-1:0] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ADDR_WIDTH-1:0];
							d_slaveALEN  	<= i_MASTER_ALEN[7:0];
							d_slaveASIZE 	<= i_MASTER_ASIZE[2:0];
							d_slaveABURST	<= i_MASTER_ABURST[1:0];
							d_slaveALOCK	<= i_MASTER_ALOCK[1:0];
							d_slaveACACHE	<= i_MASTER_ACACHE[3:0];
							d_slaveAPROT	<= i_MASTER_APROT[2:0];
							d_slaveAQOS		<= i_MASTER_AQOS[3:0];
							d_slaveAUSER	<= i_MASTER_AUSER[AUSER_WIDTH-1:0];
						end
					2'b01:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[2*ID_WIDTH-1:ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[2*ADDR_WIDTH-1:ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[8+7:8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[3+2:3];
							d_slaveABURST	<= i_MASTER_ABURST[2+1:2];
							d_slaveALOCK	<= i_MASTER_ALOCK[2+1:2];
							d_slaveACACHE	<= i_MASTER_ACACHE[4+3:4];
							d_slaveAPROT	<= i_MASTER_APROT[3+2:3];
							d_slaveAQOS		<= i_MASTER_AQOS[4+3:4];
							d_slaveAUSER	<= i_MASTER_AUSER[2*AUSER_WIDTH-1:AUSER_WIDTH];
						end								
					2'b10:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[(3*ID_WIDTH)-1:2*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[3*ADDR_WIDTH-1:2*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[16+7:16];
							d_slaveASIZE 	<= i_MASTER_ASIZE[6+2:6];
							d_slaveABURST	<= i_MASTER_ABURST[4+1:4];
							d_slaveALOCK	<= i_MASTER_ALOCK[4+1:4];
							d_slaveACACHE	<= i_MASTER_ACACHE[8+3:8];
							d_slaveAPROT	<= i_MASTER_APROT[6+2:6];
							d_slaveAQOS		<= i_MASTER_AQOS[8+3:8];
							d_slaveAUSER	<= i_MASTER_AUSER[3*AUSER_WIDTH-1:2*AUSER_WIDTH];
						end								
					2'b11:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[4*ID_WIDTH-1:3*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[4*ADDR_WIDTH-1:3*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[24+7:24];
							d_slaveASIZE 	<= i_MASTER_ASIZE[9+2:9];
							d_slaveABURST	<= i_MASTER_ABURST[6+1:6];
							d_slaveALOCK	<= i_MASTER_ALOCK[6+1:6];
							d_slaveACACHE	<= i_MASTER_ACACHE[12+3:12];
							d_slaveAPROT	<= i_MASTER_APROT[9+2:9];
							d_slaveAQOS		<= i_MASTER_AQOS[12+3:12];
							d_slaveAUSER	<= i_MASTER_AUSER[4*AUSER_WIDTH-1:3*AUSER_WIDTH];
						end
					default:
						begin
			
						end
				endcase
			end
			
	end  // always
	
else if ( NUM_MASTERS_WIDTH == 3 )

	always @(* )
	begin
	
		// Slave Address Port - latch previous requestor unless active requestor
		d_slaveAID		<= slaveAID;
		d_slaveAADDR 	<= slaveAADDR;
		d_slaveALEN  	<= slaveALEN;
		d_slaveASIZE 	<= slaveASIZE;
		d_slaveABURST	<= slaveABURST;
		d_slaveALOCK	<= slaveALOCK;
		d_slaveACACHE	<= slaveACACHE;
		d_slaveAPROT	<= slaveAPROT;
		d_slaveAQOS		<= slaveAQOS;
		d_slaveAUSER	<= slaveAUSER;

		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					3'b000:	
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[ID_WIDTH-1:0] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ADDR_WIDTH-1:0];
							d_slaveALEN  	<= i_MASTER_ALEN[7:0];
							d_slaveASIZE 	<= i_MASTER_ASIZE[2:0];
							d_slaveABURST	<= i_MASTER_ABURST[1:0];
							d_slaveALOCK	<= i_MASTER_ALOCK[1:0];
							d_slaveACACHE	<= i_MASTER_ACACHE[3:0];
							d_slaveAPROT	<= i_MASTER_APROT[2:0];
							d_slaveAQOS		<= i_MASTER_AQOS[3:0];
							d_slaveAUSER	<= i_MASTER_AUSER[AUSER_WIDTH-1:0];
						end
					3'b001:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[2*ID_WIDTH-1:ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[2*ADDR_WIDTH-1:ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[8+7:8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[3+2:3];
							d_slaveABURST	<= i_MASTER_ABURST[2+1:2];
							d_slaveALOCK	<= i_MASTER_ALOCK[2+1:2];
							d_slaveACACHE	<= i_MASTER_ACACHE[4+3:4];
							d_slaveAPROT	<= i_MASTER_APROT[3+2:3];
							d_slaveAQOS		<= i_MASTER_AQOS[4+3:4];
							d_slaveAUSER	<= i_MASTER_AUSER[2*AUSER_WIDTH-1:AUSER_WIDTH];
						end								
					3'b010:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[(3*ID_WIDTH)-1:2*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[3*ADDR_WIDTH-1:2*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[16+7:16];
							d_slaveASIZE 	<= i_MASTER_ASIZE[6+2:6];
							d_slaveABURST	<= i_MASTER_ABURST[4+1:4];
							d_slaveALOCK	<= i_MASTER_ALOCK[4+1:4];
							d_slaveACACHE	<= i_MASTER_ACACHE[8+3:8];
							d_slaveAPROT	<= i_MASTER_APROT[6+2:6];
							d_slaveAQOS		<= i_MASTER_AQOS[8+3:8];
							d_slaveAUSER	<= i_MASTER_AUSER[3*AUSER_WIDTH-1:2*AUSER_WIDTH];
						end								
					3'b011:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[4*ID_WIDTH-1:3*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[4*ADDR_WIDTH-1:3*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[24+7:24];
							d_slaveASIZE 	<= i_MASTER_ASIZE[9+2:9];
							d_slaveABURST	<= i_MASTER_ABURST[6+1:6];
							d_slaveALOCK	<= i_MASTER_ALOCK[6+1:6];
							d_slaveACACHE	<= i_MASTER_ACACHE[12+3:12];
							d_slaveAPROT	<= i_MASTER_APROT[9+2:9];
							d_slaveAQOS		<= i_MASTER_AQOS[12+3:12];
							d_slaveAUSER	<= i_MASTER_AUSER[4*AUSER_WIDTH-1:3*AUSER_WIDTH];
						end
					3'b100:	
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[5*ID_WIDTH-1:4*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ 5*ADDR_WIDTH-1	:4*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[  5*8-1         	:4*8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[ 5*3-1		 	:4*3];
							d_slaveABURST	<= i_MASTER_ABURST[5*2-1			:4*2];
							d_slaveALOCK	<= i_MASTER_ALOCK[ 5*2-1			:4*2];
							d_slaveACACHE	<= i_MASTER_ACACHE[5*4-1			:4*4];
							d_slaveAPROT	<= i_MASTER_APROT[ 5*3-1			:4*3];
							d_slaveAQOS		<= i_MASTER_AQOS[  5*4-1			:4*4];
							d_slaveAUSER	<= i_MASTER_AUSER[ 5*AUSER_WIDTH-1:4*AUSER_WIDTH];
						end
					3'b101:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[6*ID_WIDTH-1:5*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ 6*ADDR_WIDTH-1	:5*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[  6*8-1         	:5*8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[ 6*3-1		 	:5*3];
							d_slaveABURST	<= i_MASTER_ABURST[6*2-1			:5*2];
							d_slaveALOCK	<= i_MASTER_ALOCK[ 6*2-1			:5*2];
							d_slaveACACHE	<= i_MASTER_ACACHE[6*4-1			:5*4];
							d_slaveAPROT	<= i_MASTER_APROT[ 6*3-1			:5*3];
							d_slaveAQOS		<= i_MASTER_AQOS[  6*4-1			:5*4];
							d_slaveAUSER	<= i_MASTER_AUSER[ 6*AUSER_WIDTH-1:5*AUSER_WIDTH];
						end								
					3'b110:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[7*ID_WIDTH-1:6*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ 7*ADDR_WIDTH-1	:6*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[  7*8-1         	:6*8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[ 7*3-1		 	:6*3];
							d_slaveABURST	<= i_MASTER_ABURST[7*2-1			:6*2];
							d_slaveALOCK	<= i_MASTER_ALOCK[ 7*2-1			:6*2];
							d_slaveACACHE	<= i_MASTER_ACACHE[7*4-1			:6*4];
							d_slaveAPROT	<= i_MASTER_APROT[ 7*3-1			:6*3];
							d_slaveAQOS		<= i_MASTER_AQOS[  7*4-1			:6*4];
							d_slaveAUSER	<= i_MASTER_AUSER[ 7*AUSER_WIDTH-1:6*AUSER_WIDTH];						
						end								
					3'b111:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[8*ID_WIDTH-1:7*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ 8*ADDR_WIDTH-1	:7*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[  8*8-1         	:7*8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[ 8*3-1		 	:7*3];
							d_slaveABURST	<= i_MASTER_ABURST[8*2-1			:7*2];
							d_slaveALOCK	<= i_MASTER_ALOCK[ 8*2-1			:7*2];
							d_slaveACACHE	<= i_MASTER_ACACHE[8*4-1			:7*4];
							d_slaveAPROT	<= i_MASTER_APROT[ 8*3-1			:7*3];
							d_slaveAQOS		<= i_MASTER_AQOS[  8*4-1			:7*4];
							d_slaveAUSER	<= i_MASTER_AUSER[ 8*AUSER_WIDTH-1:7*AUSER_WIDTH];
						end								
					default:
						begin
			
						end
				endcase
			end
	end  // always						

else if ( NUM_MASTERS_WIDTH == 4 )

	always @(* )
	begin
	
		// Slave Address Port - latch previous requestor unless active requestor
		d_slaveAID		<= slaveAID;
		d_slaveAADDR 	<= slaveAADDR;
		d_slaveALEN  	<= slaveALEN;
		d_slaveASIZE 	<= slaveASIZE;
		d_slaveABURST	<= slaveABURST;
		d_slaveALOCK	<= slaveALOCK;
		d_slaveACACHE	<= slaveACACHE;
		d_slaveAPROT	<= slaveAPROT;
		d_slaveAQOS		<= slaveAQOS;
		d_slaveAUSER	<= slaveAUSER;

		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					4'b0000:	
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[ID_WIDTH-1:0] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ADDR_WIDTH-1:0];
							d_slaveALEN  	<= i_MASTER_ALEN[7:0];
							d_slaveASIZE 	<= i_MASTER_ASIZE[2:0];
							d_slaveABURST	<= i_MASTER_ABURST[1:0];
							d_slaveALOCK	<= i_MASTER_ALOCK[1:0];
							d_slaveACACHE	<= i_MASTER_ACACHE[3:0];
							d_slaveAPROT	<= i_MASTER_APROT[2:0];
							d_slaveAQOS		<= i_MASTER_AQOS[3:0];
							d_slaveAUSER	<= i_MASTER_AUSER[AUSER_WIDTH-1:0];
						end
					4'b0001:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[2*ID_WIDTH-1:ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[2*ADDR_WIDTH-1:ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[8+7:8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[3+2:3];
							d_slaveABURST	<= i_MASTER_ABURST[2+1:2];
							d_slaveALOCK	<= i_MASTER_ALOCK[2+1:2];
							d_slaveACACHE	<= i_MASTER_ACACHE[4+3:4];
							d_slaveAPROT	<= i_MASTER_APROT[3+2:3];
							d_slaveAQOS		<= i_MASTER_AQOS[4+3:4];
							d_slaveAUSER	<= i_MASTER_AUSER[2*AUSER_WIDTH-1:AUSER_WIDTH];
						end								
					4'b0010:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[(3*ID_WIDTH)-1:2*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[3*ADDR_WIDTH-1:2*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[16+7:16];
							d_slaveASIZE 	<= i_MASTER_ASIZE[6+2:6];
							d_slaveABURST	<= i_MASTER_ABURST[4+1:4];
							d_slaveALOCK	<= i_MASTER_ALOCK[4+1:4];
							d_slaveACACHE	<= i_MASTER_ACACHE[8+3:8];
							d_slaveAPROT	<= i_MASTER_APROT[6+2:6];
							d_slaveAQOS		<= i_MASTER_AQOS[8+3:8];
							d_slaveAUSER	<= i_MASTER_AUSER[3*AUSER_WIDTH-1:2*AUSER_WIDTH];
						end								
					4'b0011:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[4*ID_WIDTH-1:3*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[4*ADDR_WIDTH-1:3*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[24+7:24];
							d_slaveASIZE 	<= i_MASTER_ASIZE[9+2:9];
							d_slaveABURST	<= i_MASTER_ABURST[6+1:6];
							d_slaveALOCK	<= i_MASTER_ALOCK[6+1:6];
							d_slaveACACHE	<= i_MASTER_ACACHE[12+3:12];
							d_slaveAPROT	<= i_MASTER_APROT[9+2:9];
							d_slaveAQOS		<= i_MASTER_AQOS[12+3:12];
							d_slaveAUSER	<= i_MASTER_AUSER[4*AUSER_WIDTH-1:3*AUSER_WIDTH];
						end
					4'b0100:	
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[5*ID_WIDTH-1:4*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ 5*ADDR_WIDTH-1	:4*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[  5*8-1         	:4*8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[ 5*3-1		 	:4*3];
							d_slaveABURST	<= i_MASTER_ABURST[5*2-1			:4*2];
							d_slaveALOCK	<= i_MASTER_ALOCK[ 5*2-1			:4*2];
							d_slaveACACHE	<= i_MASTER_ACACHE[5*4-1			:4*4];
							d_slaveAPROT	<= i_MASTER_APROT[ 5*3-1			:4*3];
							d_slaveAQOS		<= i_MASTER_AQOS[  5*4-1			:4*4];
							d_slaveAUSER	<= i_MASTER_AUSER[ 5*AUSER_WIDTH-1:4*AUSER_WIDTH];
						end
					4'b0101:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[6*ID_WIDTH-1:5*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ 6*ADDR_WIDTH-1	:5*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[  6*8-1         	:5*8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[ 6*3-1		 	:5*3];
							d_slaveABURST	<= i_MASTER_ABURST[6*2-1			:5*2];
							d_slaveALOCK	<= i_MASTER_ALOCK[ 6*2-1			:5*2];
							d_slaveACACHE	<= i_MASTER_ACACHE[6*4-1			:5*4];
							d_slaveAPROT	<= i_MASTER_APROT[ 6*3-1			:5*3];
							d_slaveAQOS		<= i_MASTER_AQOS[  6*4-1			:5*4];
							d_slaveAUSER	<= i_MASTER_AUSER[ 6*AUSER_WIDTH-1:5*AUSER_WIDTH];
						end								
					4'b0110:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[7*ID_WIDTH-1:6*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ 7*ADDR_WIDTH-1	:6*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[  7*8-1         	:6*8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[ 7*3-1		 	:6*3];
							d_slaveABURST	<= i_MASTER_ABURST[7*2-1			:6*2];
							d_slaveALOCK	<= i_MASTER_ALOCK[ 7*2-1			:6*2];
							d_slaveACACHE	<= i_MASTER_ACACHE[7*4-1			:6*4];
							d_slaveAPROT	<= i_MASTER_APROT[ 7*3-1			:6*3];
							d_slaveAQOS		<= i_MASTER_AQOS[  7*4-1			:6*4];
							d_slaveAUSER	<= i_MASTER_AUSER[ 7*AUSER_WIDTH-1:6*AUSER_WIDTH];						
						end								
					4'b0111:
						begin
							d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[8*ID_WIDTH-1:7*ID_WIDTH] };
							d_slaveAADDR 	<= i_MASTER_AADDR[ 8*ADDR_WIDTH-1	:7*ADDR_WIDTH];
							d_slaveALEN  	<= i_MASTER_ALEN[  8*8-1         	:7*8];
							d_slaveASIZE 	<= i_MASTER_ASIZE[ 8*3-1		 	:7*3];
							d_slaveABURST	<= i_MASTER_ABURST[8*2-1			:7*2];
							d_slaveALOCK	<= i_MASTER_ALOCK[ 8*2-1			:7*2];
							d_slaveACACHE	<= i_MASTER_ACACHE[8*4-1			:7*4];
							d_slaveAPROT	<= i_MASTER_APROT[ 8*3-1			:7*3];
							d_slaveAQOS		<= i_MASTER_AQOS[  8*4-1			:7*4];
							d_slaveAUSER	<= i_MASTER_AUSER[ 8*AUSER_WIDTH-1:7*AUSER_WIDTH];
						end		
                     4'b1000:
                         begin
                             d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[9*ID_WIDTH-1:8*ID_WIDTH] };
                             d_slaveAADDR 	<= i_MASTER_AADDR [9*ADDR_WIDTH-1	:8*ADDR_WIDTH];
                             d_slaveALEN  	<= i_MASTER_ALEN  [9*8-1         	:8*8];
                             d_slaveASIZE 	<= i_MASTER_ASIZE [9*3-1		 	:8*3];
                             d_slaveABURST	<= i_MASTER_ABURST[9*2-1			:8*2];
                             d_slaveALOCK	<= i_MASTER_ALOCK [9*2-1		  	:8*2];
                             d_slaveACACHE	<= i_MASTER_ACACHE[9*4-1		    :8*4];
                             d_slaveAPROT	<= i_MASTER_APROT [9*3-1			:8*3];
                             d_slaveAQOS	<= i_MASTER_AQOS  [9*4-1			:8*4];
                             d_slaveAUSER	<= i_MASTER_AUSER [9*AUSER_WIDTH-1  :8*AUSER_WIDTH];
                         end
                     4'b1001:
                         begin
                             d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[10*ID_WIDTH-1:9*ID_WIDTH] };
                             d_slaveAADDR 	<= i_MASTER_AADDR [10*ADDR_WIDTH-1	:9*ADDR_WIDTH];
                             d_slaveALEN  	<= i_MASTER_ALEN  [10*8-1         	:9*8];
                             d_slaveASIZE 	<= i_MASTER_ASIZE [10*3-1		 	:9*3];
                             d_slaveABURST	<= i_MASTER_ABURST[10*2-1			:9*2];
                             d_slaveALOCK	<= i_MASTER_ALOCK [10*2-1		  	:9*2];
                             d_slaveACACHE	<= i_MASTER_ACACHE[10*4-1		    :9*4];
                             d_slaveAPROT	<= i_MASTER_APROT [10*3-1			:9*3];
                             d_slaveAQOS	<= i_MASTER_AQOS  [10*4-1			:9*4];
                             d_slaveAUSER	<= i_MASTER_AUSER [10*AUSER_WIDTH-1  :9*AUSER_WIDTH];
                         end
                     4'b1010:
                         begin
                             d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[11*ID_WIDTH-1:10*ID_WIDTH] };
                             d_slaveAADDR 	<= i_MASTER_AADDR [11*ADDR_WIDTH-1	:10*ADDR_WIDTH];
                             d_slaveALEN  	<= i_MASTER_ALEN  [11*8-1         	:10*8];
                             d_slaveASIZE 	<= i_MASTER_ASIZE [11*3-1		 	:10*3];
                             d_slaveABURST	<= i_MASTER_ABURST[11*2-1			:10*2];
                             d_slaveALOCK	<= i_MASTER_ALOCK [11*2-1		  	:10*2];
                             d_slaveACACHE	<= i_MASTER_ACACHE[11*4-1		    :10*4];
                             d_slaveAPROT	<= i_MASTER_APROT [11*3-1			:10*3];
                             d_slaveAQOS	<= i_MASTER_AQOS  [11*4-1			:10*4];
                             d_slaveAUSER	<= i_MASTER_AUSER [11*AUSER_WIDTH-1  :10*AUSER_WIDTH];
                         end
                     4'b1011:
                         begin
                             d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[12*ID_WIDTH-1:11*ID_WIDTH] };
                             d_slaveAADDR 	<= i_MASTER_AADDR [12*ADDR_WIDTH-1	:11*ADDR_WIDTH];
                             d_slaveALEN  	<= i_MASTER_ALEN  [12*8-1         	:11*8];
                             d_slaveASIZE 	<= i_MASTER_ASIZE [12*3-1		 	:11*3];
                             d_slaveABURST	<= i_MASTER_ABURST[12*2-1			:11*2];
                             d_slaveALOCK	<= i_MASTER_ALOCK [12*2-1		  	:11*2];
                             d_slaveACACHE	<= i_MASTER_ACACHE[12*4-1		    :11*4];
                             d_slaveAPROT	<= i_MASTER_APROT [12*3-1			:11*3];
                             d_slaveAQOS	<= i_MASTER_AQOS  [12*4-1			:11*4];
                             d_slaveAUSER	<= i_MASTER_AUSER [12*AUSER_WIDTH-1  :11*AUSER_WIDTH];
                         end
                     4'b1100:
                         begin
                             d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[13*ID_WIDTH-1:12*ID_WIDTH] };
                             d_slaveAADDR 	<= i_MASTER_AADDR [13*ADDR_WIDTH-1	:12*ADDR_WIDTH];
                             d_slaveALEN  	<= i_MASTER_ALEN  [13*8-1         	:12*8];
                             d_slaveASIZE 	<= i_MASTER_ASIZE [13*3-1		 	:12*3];
                             d_slaveABURST	<= i_MASTER_ABURST[13*2-1			:12*2];
                             d_slaveALOCK	<= i_MASTER_ALOCK [13*2-1		  	:12*2];
                             d_slaveACACHE	<= i_MASTER_ACACHE[13*4-1		    :12*4];
                             d_slaveAPROT	<= i_MASTER_APROT [13*3-1			:12*3];
                             d_slaveAQOS	<= i_MASTER_AQOS  [13*4-1			:12*4];
                             d_slaveAUSER	<= i_MASTER_AUSER [13*AUSER_WIDTH-1  :12*AUSER_WIDTH];
                         end
                     4'b1101:
                         begin
                             d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[14*ID_WIDTH-1:13*ID_WIDTH] };
                             d_slaveAADDR 	<= i_MASTER_AADDR [14*ADDR_WIDTH-1	:13*ADDR_WIDTH];
                             d_slaveALEN  	<= i_MASTER_ALEN  [14*8-1         	:13*8];
                             d_slaveASIZE 	<= i_MASTER_ASIZE [14*3-1		 	:13*3];
                             d_slaveABURST	<= i_MASTER_ABURST[14*2-1			:13*2];
                             d_slaveALOCK	<= i_MASTER_ALOCK [14*2-1		  	:13*2];
                             d_slaveACACHE	<= i_MASTER_ACACHE[14*4-1		    :13*4];
                             d_slaveAPROT	<= i_MASTER_APROT [14*3-1			:13*3];
                             d_slaveAQOS	<= i_MASTER_AQOS  [14*4-1			:13*4];
                             d_slaveAUSER	<= i_MASTER_AUSER [14*AUSER_WIDTH-1  :13*AUSER_WIDTH];
                         end
                     4'b1110:
                         begin
                             d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[15*ID_WIDTH-1:14*ID_WIDTH] };
                             d_slaveAADDR 	<= i_MASTER_AADDR [15*ADDR_WIDTH-1	:14*ADDR_WIDTH];
                             d_slaveALEN  	<= i_MASTER_ALEN  [15*8-1         	:14*8];
                             d_slaveASIZE 	<= i_MASTER_ASIZE [15*3-1		 	:14*3];
                             d_slaveABURST	<= i_MASTER_ABURST[15*2-1			:14*2];
                             d_slaveALOCK	<= i_MASTER_ALOCK [15*2-1		  	:14*2];
                             d_slaveACACHE	<= i_MASTER_ACACHE[15*4-1		    :14*4];
                             d_slaveAPROT	<= i_MASTER_APROT [15*3-1			:14*3];
                             d_slaveAQOS	<= i_MASTER_AQOS  [15*4-1			:14*4];
                             d_slaveAUSER	<= i_MASTER_AUSER [15*AUSER_WIDTH-1  :14*AUSER_WIDTH];
                         end
                     4'b1111:
                         begin
                             d_slaveAID  	<= { requestorSelEnc, i_MASTER_AID[16*ID_WIDTH-1:15*ID_WIDTH] };
                             d_slaveAADDR 	<= i_MASTER_AADDR [16*ADDR_WIDTH-1	:15*ADDR_WIDTH];
                             d_slaveALEN  	<= i_MASTER_ALEN  [16*8-1         	:15*8];
                             d_slaveASIZE 	<= i_MASTER_ASIZE [16*3-1		 	:15*3];
                             d_slaveABURST	<= i_MASTER_ABURST[16*2-1			:15*2];
                             d_slaveALOCK	<= i_MASTER_ALOCK [16*2-1		  	:15*2];
                             d_slaveACACHE	<= i_MASTER_ACACHE[16*4-1		    :15*4];
                             d_slaveAPROT	<= i_MASTER_APROT [16*3-1			:15*3];
                             d_slaveAQOS	<= i_MASTER_AQOS  [16*4-1			:15*4];
                             d_slaveAUSER	<= i_MASTER_AUSER [16*AUSER_WIDTH-1  :15*AUSER_WIDTH];
                         end						
					default:
						begin
			
						end
				endcase
			end
	end  // always						
	
endgenerate



//==============================================================================================================
// Select slave target from Master selected  - prune unwanted bits of muxing
//==============================================================================================================

generate

if ( NUM_MASTERS_WIDTH == 1 )

	always @(*)
	begin
		case( requestorSelEnc )
			1'b0:	
				begin
					slaveTarget  	<= i_targetSlave[NUM_SLAVES_WIDTH-1:0];
				end
			1'b1:	
				begin
					slaveTarget  	<= i_targetSlave[2*NUM_SLAVES_WIDTH-1:NUM_SLAVES_WIDTH];
				end		
			default:
				begin
					slaveTarget		<= { NUM_SLAVES_WIDTH{ 1'bx } };
				end
		endcase
	end

else if ( NUM_MASTERS_WIDTH == 2 )
	always @(*)
	begin
		case( requestorSelEnc )
			2'b00:	
				begin
					slaveTarget  	<= i_targetSlave[NUM_SLAVES_WIDTH-1:0];
				end
			2'b01:	
				begin
					slaveTarget  	<= i_targetSlave[2*NUM_SLAVES_WIDTH-1:NUM_SLAVES_WIDTH];
				end
			2'b10:	
				begin
					slaveTarget  	<= i_targetSlave[3*NUM_SLAVES_WIDTH-1:2*NUM_SLAVES_WIDTH];
				end
			2'b11:	
				begin
					slaveTarget  	<= i_targetSlave[4*NUM_SLAVES_WIDTH-1:3*NUM_SLAVES_WIDTH];
				end		
			default:
				begin
					slaveTarget		<= { NUM_SLAVES_WIDTH{ 1'bx } };
				end
		endcase
	end
else if ( NUM_MASTERS_WIDTH == 3 )
	always @(*)
	begin
		case( requestorSelEnc )
			3'b000:	
				begin
					slaveTarget  	<= i_targetSlave[1*NUM_SLAVES_WIDTH-1:0*NUM_SLAVES_WIDTH];
				end
			3'b001:	
				begin
					slaveTarget  	<= i_targetSlave[2*NUM_SLAVES_WIDTH-1:1*NUM_SLAVES_WIDTH];
				end
			3'b010:	
				begin
					slaveTarget  	<= i_targetSlave[3*NUM_SLAVES_WIDTH-1:2*NUM_SLAVES_WIDTH];
				end
			3'b011:	
				begin
					slaveTarget  	<= i_targetSlave[4*NUM_SLAVES_WIDTH-1:3*NUM_SLAVES_WIDTH];
				end		
			3'b100:	
				begin
					slaveTarget  	<= i_targetSlave[5*NUM_SLAVES_WIDTH-1:4*NUM_SLAVES_WIDTH];
				end
			3'b101:	
				begin
					slaveTarget  	<= i_targetSlave[6*NUM_SLAVES_WIDTH-1:5*NUM_SLAVES_WIDTH];
				end
			3'b110:	
				begin
					slaveTarget  	<= i_targetSlave[7*NUM_SLAVES_WIDTH-1:6*NUM_SLAVES_WIDTH];
				end
			3'b111:	
				begin
					slaveTarget  	<= i_targetSlave[8*NUM_SLAVES_WIDTH-1:7*NUM_SLAVES_WIDTH];
				end						
			default:
				begin
					slaveTarget		<= { NUM_SLAVES_WIDTH{ 1'bx } };
				end
		endcase
	end
else if ( NUM_MASTERS_WIDTH == 4 )
	always @(*)
	begin
		case( requestorSelEnc )
			4'b0000:	
				begin
					slaveTarget  	<= i_targetSlave[1*NUM_SLAVES_WIDTH-1:0*NUM_SLAVES_WIDTH];
				end
			4'b0001:	
				begin
					slaveTarget  	<= i_targetSlave[2*NUM_SLAVES_WIDTH-1:1*NUM_SLAVES_WIDTH];
				end
			4'b0010:	
				begin
					slaveTarget  	<= i_targetSlave[3*NUM_SLAVES_WIDTH-1:2*NUM_SLAVES_WIDTH];
				end
			4'b0011:	
				begin
					slaveTarget  	<= i_targetSlave[4*NUM_SLAVES_WIDTH-1:3*NUM_SLAVES_WIDTH];
				end		
			4'b0100:	
				begin
					slaveTarget  	<= i_targetSlave[5*NUM_SLAVES_WIDTH-1:4*NUM_SLAVES_WIDTH];
				end
			4'b0101:	
				begin
					slaveTarget  	<= i_targetSlave[6*NUM_SLAVES_WIDTH-1:5*NUM_SLAVES_WIDTH];
				end
			4'b0110:	
				begin
					slaveTarget  	<= i_targetSlave[7*NUM_SLAVES_WIDTH-1:6*NUM_SLAVES_WIDTH];
				end
			4'b0111:	
				begin
					slaveTarget  	<= i_targetSlave[8*NUM_SLAVES_WIDTH-1:7*NUM_SLAVES_WIDTH];
				end						
			4'b1000:	
				begin
					slaveTarget  	<= i_targetSlave[9*NUM_SLAVES_WIDTH-1:8*NUM_SLAVES_WIDTH];
				end
			4'b1001:	
				begin
					slaveTarget  	<= i_targetSlave[10*NUM_SLAVES_WIDTH-1:9*NUM_SLAVES_WIDTH];
				end
			4'b1010:	
				begin
					slaveTarget  	<= i_targetSlave[11*NUM_SLAVES_WIDTH-1:10*NUM_SLAVES_WIDTH];
				end
			4'b1011:	
				begin
					slaveTarget  	<= i_targetSlave[12*NUM_SLAVES_WIDTH-1:11*NUM_SLAVES_WIDTH];
				end		
			4'b1100:	
				begin
					slaveTarget  	<= i_targetSlave[13*NUM_SLAVES_WIDTH-1:12*NUM_SLAVES_WIDTH];
				end
			4'b1101:	
				begin
					slaveTarget  	<= i_targetSlave[14*NUM_SLAVES_WIDTH-1:13*NUM_SLAVES_WIDTH];
				end
			4'b1110:	
				begin
					slaveTarget  	<= i_targetSlave[15*NUM_SLAVES_WIDTH-1:14*NUM_SLAVES_WIDTH];
				end
			4'b1111:	
				begin
					slaveTarget  	<= i_targetSlave[16*NUM_SLAVES_WIDTH-1:15*NUM_SLAVES_WIDTH];
				end						
			default:
				begin
					slaveTarget		<= { NUM_SLAVES_WIDTH{ 1'bx } };
				end
		endcase
	end
	
endgenerate

//=====================================================================================
// Clock out Slave bus
//=====================================================================================
always @(posedge sysClk or negedge sysReset)
begin
	if (!sysReset)
		begin
			slaveAID	<= 0;
			slaveAADDR 	<= 0;
			slaveALEN  	<= 0;
			slaveASIZE 	<= 0;
			slaveABURST	<= 0;
			slaveALOCK	<= 0;
			slaveACACHE	<= 0;
			slaveAPROT	<= 0;
			slaveAQOS	<= 0;
			slaveAUSER	<= 0;
	
			slaveAVALID	<= 0;
		end
	else
		begin

			slaveAID	<= d_slaveAID;
			slaveAADDR 	<= d_slaveAADDR;
			slaveALEN  	<= d_slaveALEN;
			slaveASIZE 	<= d_slaveASIZE;
			slaveABURST	<= d_slaveABURST;
			slaveALOCK	<= d_slaveALOCK;
			slaveACACHE	<= d_slaveACACHE;
			slaveAPROT	<= d_slaveAPROT;
			slaveAQOS	<= d_slaveAQOS;
			slaveAUSER	<= d_slaveAUSER;

			slaveAVALID	<= 0;		// initialise to 0 to indicate no transaction
	
			if ( requestorSelValid & (~slaveReady ) )		// terminate slaveAVALID when slave asserts aready
				begin
					slaveAVALID[ slaveTarget ] <= 1'b1;  // set target slave valid bit  
				end
		end
end	

//====================================================================================
// Connect output of clocked address vector from MUX to individual slaves ports
//====================================================================================	

genvar i;
generate

	// Route signals that go to external ports
	for (i=0; i< NUM_SLAVES-1; i=i+1 )
		begin
			assign SLAVE_AID[(i+1)*MASTERID_WIDTH-1:i*MASTERID_WIDTH]	= slaveAID;
			assign SLAVE_AADDR[ (i+1)*ADDR_WIDTH-1:i*ADDR_WIDTH] 		= slaveAADDR;
			assign SLAVE_ALEN[(i+1)*8-1:i*8]               				= slaveALEN;
			assign SLAVE_ASIZE[(i+1)*3-1:i*3]                      		= slaveASIZE;
			assign SLAVE_ABURST[(i+1)*2-1:i*2]                  		= slaveABURST;
			assign SLAVE_ALOCK[(i+1)*2-1:i*2]                       	= slaveALOCK;
			assign SLAVE_ACACHE[(i+1)*4-1:i*4]                      	= slaveACACHE;
			assign SLAVE_APROT[(i+1)*3-1:i*3]                       	= slaveAPROT;
			assign SLAVE_AQOS[(i+1)*4-1:i*4]                        	= slaveAQOS;
			assign SLAVE_AUSER[(i+1)*AUSER_WIDTH-1:i*AUSER_WIDTH]   	= slaveAUSER;
		end
		
		// Route signals for DECERR Slave
		assign SLAVE_AID[(NUM_SLAVES)*MASTERID_WIDTH-1:(NUM_SLAVES-1)*MASTERID_WIDTH]	= slaveAID;
		assign SLAVE_ALEN[(NUM_SLAVES)*8-1:(NUM_SLAVES-1)*8]             				= slaveALEN;
		
endgenerate

assign 	SLAVE_AVALID	= slaveAVALID;

assign	slaveReady		= |(SLAVE_AREADY & SLAVE_AVALID );			// slaveReady when ready is asserted on slave targeted

assign arbEnable 		= slaveReady;								// free to arb for Next


always @(*)
begin
		MASTER_AREADY	<= 0;		// initialise to 0 to indicate no transaction
	
		if ( requestorSelValid & slaveReady)
			begin
				MASTER_AREADY[ requestorSelEnc ] <= 1'b1;  // set target slave valid bit  
			end

end	



//======================================================================================
// For Writes - pass on src & dest port and push into dataFifo.
//======================================================================================
generate
	if ( HI_FREQ == 1 )
		begin
			always @( posedge sysClk or negedge sysReset)	
				begin
				  if(~sysReset)
				    begin 
					  dataFifoWr	<= 0;
					  srcPort		<= 0;
					  destPort	    <= 0;
					end 
				  else 
				    begin 
					  dataFifoWr	<= arbEnable;		
					  srcPort		<= slaveAID;
					  destPort   	<= slaveTarget;
					end 
				end
		end
	else
		begin
			always @( * )	
				begin
					dataFifoWr	<= arbEnable;
		
					srcPort		<= slaveAID;
					destPort	<= slaveTarget;
				end
		end	
	
endgenerate

	
	
	
endmodule // caxi4interconnect_TargetMuxController.v
