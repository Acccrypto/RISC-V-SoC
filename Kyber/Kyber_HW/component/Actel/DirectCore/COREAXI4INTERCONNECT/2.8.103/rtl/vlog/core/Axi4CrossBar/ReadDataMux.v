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
//     Abstract  : This module controls the Read Data MUXing from slaves to masters
//                 and the responses back from the masters
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_ReadDataMux # 
	(
		parameter integer NUM_MASTERS_WIDTH		= 2, 				// defines number of bits to encode master number
		
		parameter integer NUM_SLAVES     		= 4, 				// defines number of slaves
		parameter integer NUM_SLAVES_WIDTH 		= 2,				// defines number of bits to encoode slave number

		parameter integer ID_WIDTH   			= 1, 

		parameter integer DATA_WIDTH 			= 32,
		
		parameter integer SUPPORT_USER_SIGNALS 	= 0,
		parameter integer USER_WIDTH 			= 1,

		parameter [NUM_SLAVES-1:0]  		MASTER_READ_CONNECTIVITY 		= {NUM_SLAVES{1'b1}}
   
	)
	(
		// Global Signals
		input  wire                                     	sysClk,
		input  wire                                     	sysReset,				// active low reset synchronoise to RE AClk - asserted async.

		// Slot Arbitrator
		input wire											requestorSelValid,		// indicates that slot arb has selected an requestorSelValid so drive to Slave
		input wire [NUM_SLAVES_WIDTH-1:0 ]					requestorSelEnc,		// indicates requestor selected by slot arb when active request is asserted - encoded
		output wire											arbEnable,
				
		//====================== Slave Data Ports  ================================================//
  
		input  wire [NUM_SLAVES-1:0]                           			SLAVE_VALID,
		input  wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 		SLAVE_ID,
		input  wire [NUM_SLAVES*DATA_WIDTH-1:0]    						SLAVE_DATA,
		input  wire [NUM_SLAVES*2-1:0]                         			SLAVE_RESP,
		input  wire [NUM_SLAVES-1:0]                           			SLAVE_LAST,
		input  wire [NUM_SLAVES*USER_WIDTH-1:0]         				SLAVE_USER,
		
		output reg  [NUM_SLAVES-1:0]                           			SLAVE_READY,
		
		//====================== Master Data  Ports  ================================================//

		output reg [(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]          			masterID,
		output reg [DATA_WIDTH-1:0]     								MASTER_DATA,
		output reg [1:0]                   	       						MASTER_RESP,
		output reg                   		          					MASTER_LAST,
		output reg [USER_WIDTH-1:0]          							MASTER_USER,
		output reg		                            					MASTER_VALID,

		input  wire					                            		MASTER_READY,
   
		//====================== AddressControl Port ============================================//
		
		output reg	[(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 					currDataTransID,	// current data transaction ID
		output reg				 										openTransDec,		// indicates thread matching currDataTransID to be decremented
		
		input       [NUM_SLAVES-1:0]                                    slaveValidQual
  
	);
   						 
						 
//================================================================================================
// Local Parameters
//================================================================================================

	localparam MASTERID_WIDTH		= ( NUM_MASTERS_WIDTH + ID_WIDTH );			// defines width masterID - includes infrastructure ID plus ID
	localparam THREAD_VEC_WIDTH		= ( MASTERID_WIDTH + NUM_SLAVES_WIDTH );	// defines width of per thread vector elements width

	
//=================================================================================================
// Local Declarationes
//=================================================================================================
 
	// Master Data Port - output of MUX of selected requestor
	reg [MASTERID_WIDTH-1:0]        d_masterID;
	reg [DATA_WIDTH-1:0]     		d_masterDATA;
	reg [1:0]	                    d_masterRESP;
	reg 				          	d_masterLAST;
	reg [USER_WIDTH-1:0]          	d_masterUSER;

	reg	[(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 		d_currDataTransID;	// current data transaction ID
	
	

	wire 						                masterReady;	
    
    // jhayes : Change to make internal signals of larger width, based on 2^NUM_SLAVES_WIDTH. Input signals 
    // come in, based on width of NUM_SLAVES. However, logic inferred below will index beyond this width, hence change.
    wire [(2**NUM_SLAVES_WIDTH)*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] i_SLAVE_ID;
    wire [(2**NUM_SLAVES_WIDTH)*DATA_WIDTH-1:0] i_SLAVE_DATA;
    wire [(2**NUM_SLAVES_WIDTH)*2-1:0] i_SLAVE_RESP;
    wire [(2**NUM_SLAVES_WIDTH)-1:0] i_SLAVE_LAST;
    wire [(2**NUM_SLAVES_WIDTH)*USER_WIDTH-1:0] i_SLAVE_USER;	
	

    // jhayes : Padding of input signals.
    assign i_SLAVE_ID    = 'b0 | SLAVE_ID;
    assign i_SLAVE_DATA  = 'b0 | SLAVE_DATA;
    assign i_SLAVE_RESP  = 'b0 | SLAVE_RESP;
    assign i_SLAVE_LAST  = 'b0 | SLAVE_LAST;    
    assign i_SLAVE_USER  = 'b0 | SLAVE_USER;

	
generate

if ( NUM_SLAVES_WIDTH == 1 )
	always @(*)
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_masterID		<= 0;
		d_masterDATA 	<= 0;
		d_masterRESP 	<= 0;
		d_masterLAST 	<= 0;
		d_masterUSER	<= 0;
		
		d_currDataTransID <= currDataTransID;
		
		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					1'b0:	
						begin
							d_masterID		<= i_SLAVE_ID[MASTERID_WIDTH-1:0];			// pick out ID
							d_masterDATA 	<= i_SLAVE_DATA[DATA_WIDTH-1:0];
							d_masterRESP 	<= i_SLAVE_RESP[2-1:0];
							d_masterLAST 	<= i_SLAVE_LAST[0:0];
							d_masterUSER	<= i_SLAVE_USER[USER_WIDTH-1:0];
							
							d_currDataTransID	<= i_SLAVE_ID[1*MASTERID_WIDTH-1:0*MASTERID_WIDTH];
						end
					1'b1:
						begin
							d_masterID		<= i_SLAVE_ID[(2*MASTERID_WIDTH)-1:MASTERID_WIDTH];			// pick out ID
							d_masterDATA 	<= i_SLAVE_DATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[2*2-1:2];
							d_masterLAST 	<= i_SLAVE_LAST[1:1];
							d_masterUSER	<= i_SLAVE_USER[2*USER_WIDTH-1:USER_WIDTH];
							
							d_currDataTransID	<= i_SLAVE_ID[2*MASTERID_WIDTH-1:1*MASTERID_WIDTH];

						end
					default:
						begin
			
						end
				endcase
			end
			
	end  // always

else if ( NUM_SLAVES_WIDTH == 2 )

	always @(* )
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_masterID		<= 0;
		d_masterDATA 	<= 0;
		d_masterRESP 	<= 0;
		d_masterLAST 	<= 0;
		d_masterUSER	<= 0;

		d_currDataTransID <= currDataTransID;
		
		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					2'b00:	
						begin
							d_masterID		<= i_SLAVE_ID[MASTERID_WIDTH-1:0];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[DATA_WIDTH-1:0];
							d_masterRESP 	<= i_SLAVE_RESP[2-1:0];
							d_masterLAST 	<= i_SLAVE_LAST[0:0];
							d_masterUSER	<= i_SLAVE_USER[USER_WIDTH-1:0];
							
							d_currDataTransID	<= i_SLAVE_ID[1*MASTERID_WIDTH-1:0*MASTERID_WIDTH];
						end
					2'b01:
						begin
							d_masterID		<= i_SLAVE_ID[2*MASTERID_WIDTH-1:MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[2*2-1:1*2];
							d_masterLAST 	<= i_SLAVE_LAST[1:1];
							d_masterUSER	<= i_SLAVE_USER[2*USER_WIDTH-1:USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[2*MASTERID_WIDTH-1:1*MASTERID_WIDTH];
						end
					2'b10:
						begin
							d_masterID		<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[3*DATA_WIDTH-1:2*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[3*2-1:2*2];
							d_masterLAST 	<= i_SLAVE_LAST[2:2];
							d_masterUSER	<= i_SLAVE_USER[3*USER_WIDTH-1:2*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];
						end
					2'b11:
						begin
							d_masterID		<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[4*DATA_WIDTH-1:3*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[4*2-1:3*2];
							d_masterLAST 	<= i_SLAVE_LAST[3:3];
							d_masterUSER	<= i_SLAVE_USER[4*USER_WIDTH-1:3*USER_WIDTH];
							
							d_currDataTransID	<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];
						end		
					default:
						begin
			
						end
				endcase
			end
	end  // always
else if ( NUM_SLAVES_WIDTH == 3 )

	always @(* )
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_masterID		<= 0;
		d_masterDATA 	<= 0;
		d_masterRESP 	<= 0;
		d_masterLAST 	<= 0;
		d_masterUSER	<= 0;

		d_currDataTransID <= currDataTransID;
		
		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					3'b000:	
						begin
							d_masterID		<= i_SLAVE_ID[MASTERID_WIDTH-1:0];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[DATA_WIDTH-1:0];
							d_masterRESP 	<= i_SLAVE_RESP[2-1:0];
							d_masterLAST 	<= i_SLAVE_LAST[0:0];
							d_masterUSER	<= i_SLAVE_USER[USER_WIDTH-1:0];
							
							d_currDataTransID	<= i_SLAVE_ID[1*MASTERID_WIDTH-1:0*MASTERID_WIDTH];
						end
					3'b001:
						begin
							d_masterID		<= i_SLAVE_ID[2*MASTERID_WIDTH-1:MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[2*2-1:1*2];
							d_masterLAST 	<= i_SLAVE_LAST[1:1];
							d_masterUSER	<= i_SLAVE_USER[2*USER_WIDTH-1:USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[2*MASTERID_WIDTH-1:1*MASTERID_WIDTH];
						end
					3'b010:
						begin
							d_masterID		<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[3*DATA_WIDTH-1:2*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[3*2-1:2*2];
							d_masterLAST 	<= i_SLAVE_LAST[2:2];
							d_masterUSER	<= i_SLAVE_USER[3*USER_WIDTH-1:2*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];
						end
					3'b011:
						begin
							d_masterID		<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[4*DATA_WIDTH-1:3*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[4*2-1:3*2];
							d_masterLAST 	<= i_SLAVE_LAST[3:3];
							d_masterUSER	<= i_SLAVE_USER[4*USER_WIDTH-1:3*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];
						end
					3'b100:	
						begin
							d_masterID		<= i_SLAVE_ID[5*MASTERID_WIDTH-1:4*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[5*DATA_WIDTH-1:4*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[5*2-1:4*2];
							d_masterLAST 	<= i_SLAVE_LAST[4:4];
							d_masterUSER	<= i_SLAVE_USER[5*USER_WIDTH-1:4*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[5*MASTERID_WIDTH-1:4*MASTERID_WIDTH];
						end
					3'b101:
						begin
							d_masterID		<= i_SLAVE_ID[6*MASTERID_WIDTH-1:5*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[6*DATA_WIDTH-1:5*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[6*2-1:5*2];
							d_masterLAST 	<= i_SLAVE_LAST[5:5];
							d_masterUSER	<= i_SLAVE_USER[6*USER_WIDTH-1:5*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[6*MASTERID_WIDTH-1:5*MASTERID_WIDTH];
						end
					3'b110:
						begin
							d_masterID		<= i_SLAVE_ID[7*MASTERID_WIDTH-1:6*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[7*DATA_WIDTH-1:6*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[7*2-1:6*2];
							d_masterLAST 	<= i_SLAVE_LAST[6:6];
							d_masterUSER	<= i_SLAVE_USER[7*USER_WIDTH-1:6*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[7*MASTERID_WIDTH-1:6*MASTERID_WIDTH];
						end
					3'b111:
						begin
							d_masterID		<= i_SLAVE_ID[8*MASTERID_WIDTH-1:7*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[8*DATA_WIDTH-1:7*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[8*2-1:7*2];
							d_masterLAST 	<= i_SLAVE_LAST[7:7];
							d_masterUSER	<= i_SLAVE_USER[8*USER_WIDTH-1:7*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[8*MASTERID_WIDTH-1:7*MASTERID_WIDTH];
						end							
					default:
						begin
			
						end
				endcase
			end
	end  // always		
else if ( NUM_SLAVES_WIDTH == 4 )

	always @(* )
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_masterID		<= 0;
		d_masterDATA 	<= 0;
		d_masterRESP 	<= 0;
		d_masterLAST 	<= 0;
		d_masterUSER	<= 0;

		d_currDataTransID <= currDataTransID;
		
		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					4'b0000:	
						begin
							d_masterID		<= i_SLAVE_ID[MASTERID_WIDTH-1:0];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[DATA_WIDTH-1:0];
							d_masterRESP 	<= i_SLAVE_RESP[2-1:0];
							d_masterLAST 	<= i_SLAVE_LAST[0:0];
							d_masterUSER	<= i_SLAVE_USER[USER_WIDTH-1:0];
							
							d_currDataTransID	<= i_SLAVE_ID[1*MASTERID_WIDTH-1:0*MASTERID_WIDTH];
						end
					4'b0001:
						begin
							d_masterID		<= i_SLAVE_ID[2*MASTERID_WIDTH-1:MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[2*2-1:1*2];
							d_masterLAST 	<= i_SLAVE_LAST[1:1];
							d_masterUSER	<= i_SLAVE_USER[2*USER_WIDTH-1:USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[2*MASTERID_WIDTH-1:1*MASTERID_WIDTH];
						end
					4'b0010:
						begin
							d_masterID		<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[3*DATA_WIDTH-1:2*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[3*2-1:2*2];
							d_masterLAST 	<= i_SLAVE_LAST[2:2];
							d_masterUSER	<= i_SLAVE_USER[3*USER_WIDTH-1:2*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];
						end
					4'b0011:
						begin
							d_masterID		<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[4*DATA_WIDTH-1:3*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[4*2-1:3*2];
							d_masterLAST 	<= i_SLAVE_LAST[3:3];
							d_masterUSER	<= i_SLAVE_USER[4*USER_WIDTH-1:3*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];
						end
					4'b0100:	
						begin
							d_masterID		<= i_SLAVE_ID[5*MASTERID_WIDTH-1:4*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[5*DATA_WIDTH-1:4*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[5*2-1:4*2];
							d_masterLAST 	<= i_SLAVE_LAST[4:4];
							d_masterUSER	<= i_SLAVE_USER[5*USER_WIDTH-1:4*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[5*MASTERID_WIDTH-1:4*MASTERID_WIDTH];
						end
					4'b0101:
						begin
							d_masterID		<= i_SLAVE_ID[6*MASTERID_WIDTH-1:5*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[6*DATA_WIDTH-1:5*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[6*2-1:5*2];
							d_masterLAST 	<= i_SLAVE_LAST[5:5];
							d_masterUSER	<= i_SLAVE_USER[6*USER_WIDTH-1:5*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[6*MASTERID_WIDTH-1:5*MASTERID_WIDTH];
						end
					4'b0110:
						begin
							d_masterID		<= i_SLAVE_ID[7*MASTERID_WIDTH-1:6*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[7*DATA_WIDTH-1:6*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[7*2-1:6*2];
							d_masterLAST 	<= i_SLAVE_LAST[6:6];
							d_masterUSER	<= i_SLAVE_USER[7*USER_WIDTH-1:6*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[7*MASTERID_WIDTH-1:6*MASTERID_WIDTH];
						end
					4'b0111:
						begin
							d_masterID		<= i_SLAVE_ID[8*MASTERID_WIDTH-1:7*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[8*DATA_WIDTH-1:7*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[8*2-1:7*2];
							d_masterLAST 	<= i_SLAVE_LAST[7:7];
							d_masterUSER	<= i_SLAVE_USER[8*USER_WIDTH-1:7*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[8*MASTERID_WIDTH-1:7*MASTERID_WIDTH];
						end
					4'b1000:
						begin
							d_masterID		<= i_SLAVE_ID[9*MASTERID_WIDTH-1:8*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[9*DATA_WIDTH-1:8*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[9*2-1:8*2];
							d_masterLAST 	<= i_SLAVE_LAST[8:8];
							d_masterUSER	<= i_SLAVE_USER[9*USER_WIDTH-1:8*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[9*MASTERID_WIDTH-1:8*MASTERID_WIDTH];
						end
          4'b1001:
						begin
							d_masterID		<= i_SLAVE_ID[10*MASTERID_WIDTH-1:9*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[10*DATA_WIDTH-1:9*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[10*2-1:9*2];
							d_masterLAST 	<= i_SLAVE_LAST[9:9];
							d_masterUSER	<= i_SLAVE_USER[10*USER_WIDTH-1:9*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[10*MASTERID_WIDTH-1:9*MASTERID_WIDTH];
						end
					4'b1010:
						begin
							d_masterID		<= i_SLAVE_ID[11*MASTERID_WIDTH-1:10*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[11*DATA_WIDTH-1:10*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[11*2-1:10*2];
							d_masterLAST 	<= i_SLAVE_LAST[10:10];
							d_masterUSER	<= i_SLAVE_USER[11*USER_WIDTH-1:10*USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[11*MASTERID_WIDTH-1:10*MASTERID_WIDTH];
						end
					4'b1011:
						begin
							d_masterID		<= i_SLAVE_ID[12*MASTERID_WIDTH-1:11*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[12*DATA_WIDTH-1:11*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[12*2-1:11*2];
							d_masterLAST 	<= i_SLAVE_LAST[11:11];
							d_masterUSER	<= i_SLAVE_USER[12*USER_WIDTH-1:11*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[12*MASTERID_WIDTH-1:11*MASTERID_WIDTH];
						end
					4'b1100:
						begin
							d_masterID		<= i_SLAVE_ID[13*MASTERID_WIDTH-1:12*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[13*DATA_WIDTH-1:12*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[13*2-1:12*2];
							d_masterLAST 	<= i_SLAVE_LAST[12:12];
							d_masterUSER	<= i_SLAVE_USER[13*USER_WIDTH-1:12*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[13*MASTERID_WIDTH-1:12*MASTERID_WIDTH];
						end
					4'b1101:	
						begin
							d_masterID		<= i_SLAVE_ID[14*MASTERID_WIDTH-1:13*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[14*DATA_WIDTH-1:13*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[14*2-1:13*2];
							d_masterLAST 	<= i_SLAVE_LAST[13:13];
							d_masterUSER	<= i_SLAVE_USER[14*USER_WIDTH-1:13*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[14*MASTERID_WIDTH-1:13*MASTERID_WIDTH];
						end
					4'b1110:
						begin
							d_masterID		<= i_SLAVE_ID[15*MASTERID_WIDTH-1:14*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[15*DATA_WIDTH-1:14*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[15*2-1:14*2];
							d_masterLAST 	<= i_SLAVE_LAST[14:14];
							d_masterUSER	<= i_SLAVE_USER[15*USER_WIDTH-1:14*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[15*MASTERID_WIDTH-1:14*MASTERID_WIDTH];
						end
					4'b1111:
						begin
							d_masterID		<= i_SLAVE_ID[16*MASTERID_WIDTH-1:15*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[16*DATA_WIDTH-1:15*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[16*2-1:15*2];
							d_masterLAST 	<= i_SLAVE_LAST[15:15];
							d_masterUSER	<= i_SLAVE_USER[16*USER_WIDTH-1:15*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[16*MASTERID_WIDTH-1:15*MASTERID_WIDTH];
						end
					default:
						begin
							d_masterID		<= i_SLAVE_ID[16*MASTERID_WIDTH-1:15*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[16*DATA_WIDTH-1:15*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[16*2-1:15*2];
							d_masterLAST 	<= i_SLAVE_LAST[15:15];
							d_masterUSER	<= i_SLAVE_USER[16*USER_WIDTH-1:15*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[16*MASTERID_WIDTH-1:15*MASTERID_WIDTH];
						end
				endcase
			end
	end  // always		
  else if ( NUM_SLAVES_WIDTH == 5 )

	always @(* )
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_masterID		<= 0;
		d_masterDATA 	<= 0;
		d_masterRESP 	<= 0;
		d_masterLAST 	<= 0;
		d_masterUSER	<= 0;

		d_currDataTransID <= currDataTransID;
		
		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					5'b00000:	
						begin
							d_masterID		<= i_SLAVE_ID[MASTERID_WIDTH-1:0];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[DATA_WIDTH-1:0];
							d_masterRESP 	<= i_SLAVE_RESP[2-1:0];
							d_masterLAST 	<= i_SLAVE_LAST[0:0];
							d_masterUSER	<= i_SLAVE_USER[USER_WIDTH-1:0];
							
							d_currDataTransID	<= i_SLAVE_ID[1*MASTERID_WIDTH-1:0*MASTERID_WIDTH];
						end
					5'b00001:
						begin
							d_masterID		<= i_SLAVE_ID[2*MASTERID_WIDTH-1:MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[2*2-1:1*2];
							d_masterLAST 	<= i_SLAVE_LAST[1:1];
							d_masterUSER	<= i_SLAVE_USER[2*USER_WIDTH-1:USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[2*MASTERID_WIDTH-1:1*MASTERID_WIDTH];
						end
					5'b00010:
						begin
							d_masterID		<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[3*DATA_WIDTH-1:2*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[3*2-1:2*2];
							d_masterLAST 	<= i_SLAVE_LAST[2:2];
							d_masterUSER	<= i_SLAVE_USER[3*USER_WIDTH-1:2*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];
						end
					5'b00011:
						begin
							d_masterID		<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[4*DATA_WIDTH-1:3*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[4*2-1:3*2];
							d_masterLAST 	<= i_SLAVE_LAST[3:3];
							d_masterUSER	<= i_SLAVE_USER[4*USER_WIDTH-1:3*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];
						end
					5'b00100:	
						begin
							d_masterID		<= i_SLAVE_ID[5*MASTERID_WIDTH-1:4*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[5*DATA_WIDTH-1:4*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[5*2-1:4*2];
							d_masterLAST 	<= i_SLAVE_LAST[4:4];
							d_masterUSER	<= i_SLAVE_USER[5*USER_WIDTH-1:4*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[5*MASTERID_WIDTH-1:4*MASTERID_WIDTH];
						end
					5'b00101:
						begin
							d_masterID		<= i_SLAVE_ID[6*MASTERID_WIDTH-1:5*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[6*DATA_WIDTH-1:5*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[6*2-1:5*2];
							d_masterLAST 	<= i_SLAVE_LAST[5:5];
							d_masterUSER	<= i_SLAVE_USER[6*USER_WIDTH-1:5*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[6*MASTERID_WIDTH-1:5*MASTERID_WIDTH];
						end
					5'b00110:
						begin
							d_masterID		<= i_SLAVE_ID[7*MASTERID_WIDTH-1:6*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[7*DATA_WIDTH-1:6*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[7*2-1:6*2];
							d_masterLAST 	<= i_SLAVE_LAST[6:6];
							d_masterUSER	<= i_SLAVE_USER[7*USER_WIDTH-1:6*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[7*MASTERID_WIDTH-1:6*MASTERID_WIDTH];
						end
					5'b00111:
						begin
							d_masterID		<= i_SLAVE_ID[8*MASTERID_WIDTH-1:7*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[8*DATA_WIDTH-1:7*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[8*2-1:7*2];
							d_masterLAST 	<= i_SLAVE_LAST[7:7];
							d_masterUSER	<= i_SLAVE_USER[8*USER_WIDTH-1:7*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[8*MASTERID_WIDTH-1:7*MASTERID_WIDTH];
						end
					5'b01000:
						begin
							d_masterID		<= i_SLAVE_ID[9*MASTERID_WIDTH-1:8*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[9*DATA_WIDTH-1:8*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[9*2-1:8*2];
							d_masterLAST 	<= i_SLAVE_LAST[8:8];
							d_masterUSER	<= i_SLAVE_USER[9*USER_WIDTH-1:8*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[9*MASTERID_WIDTH-1:8*MASTERID_WIDTH];
						end
          5'b01001:
						begin
							d_masterID		<= i_SLAVE_ID[10*MASTERID_WIDTH-1:9*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[10*DATA_WIDTH-1:9*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[10*2-1:9*2];
							d_masterLAST 	<= i_SLAVE_LAST[9:9];
							d_masterUSER	<= i_SLAVE_USER[10*USER_WIDTH-1:9*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[10*MASTERID_WIDTH-1:9*MASTERID_WIDTH];
						end
					5'b01010:
						begin
							d_masterID		<= i_SLAVE_ID[11*MASTERID_WIDTH-1:10*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[11*DATA_WIDTH-1:10*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[11*2-1:10*2];
							d_masterLAST 	<= i_SLAVE_LAST[10:10];
							d_masterUSER	<= i_SLAVE_USER[11*USER_WIDTH-1:10*USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[11*MASTERID_WIDTH-1:10*MASTERID_WIDTH];
						end
					5'b01011:
						begin
							d_masterID		<= i_SLAVE_ID[12*MASTERID_WIDTH-1:11*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[12*DATA_WIDTH-1:11*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[12*2-1:11*2];
							d_masterLAST 	<= i_SLAVE_LAST[11:11];
							d_masterUSER	<= i_SLAVE_USER[12*USER_WIDTH-1:11*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[12*MASTERID_WIDTH-1:11*MASTERID_WIDTH];
						end
					5'b01100:
						begin
							d_masterID		<= i_SLAVE_ID[13*MASTERID_WIDTH-1:12*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[13*DATA_WIDTH-1:12*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[13*2-1:12*2];
							d_masterLAST 	<= i_SLAVE_LAST[12:12];
							d_masterUSER	<= i_SLAVE_USER[13*USER_WIDTH-1:12*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[13*MASTERID_WIDTH-1:12*MASTERID_WIDTH];
						end
					5'b01101:	
						begin
							d_masterID		<= i_SLAVE_ID[14*MASTERID_WIDTH-1:13*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[14*DATA_WIDTH-1:13*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[14*2-1:13*2];
							d_masterLAST 	<= i_SLAVE_LAST[13:13];
							d_masterUSER	<= i_SLAVE_USER[14*USER_WIDTH-1:13*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[14*MASTERID_WIDTH-1:13*MASTERID_WIDTH];
						end
					5'b01110:
						begin
							d_masterID		<= i_SLAVE_ID[15*MASTERID_WIDTH-1:14*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[15*DATA_WIDTH-1:14*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[15*2-1:14*2];
							d_masterLAST 	<= i_SLAVE_LAST[14:14];
							d_masterUSER	<= i_SLAVE_USER[15*USER_WIDTH-1:14*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[15*MASTERID_WIDTH-1:14*MASTERID_WIDTH];
						end
					5'b01111:
						begin
							d_masterID		<= i_SLAVE_ID[16*MASTERID_WIDTH-1:15*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[16*DATA_WIDTH-1:15*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[16*2-1:15*2];
							d_masterLAST 	<= i_SLAVE_LAST[15:15];
							d_masterUSER	<= i_SLAVE_USER[16*USER_WIDTH-1:15*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[16*MASTERID_WIDTH-1:15*MASTERID_WIDTH];
						end
          5'b10000:	
						begin
							d_masterID		<= i_SLAVE_ID[17*MASTERID_WIDTH-1:16*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[17*DATA_WIDTH-1:16*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[17*2-1:16*2];
							d_masterLAST 	<= i_SLAVE_LAST[16:16];
							d_masterUSER	<= i_SLAVE_USER[17*USER_WIDTH-1:16*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[17*MASTERID_WIDTH-1:16*MASTERID_WIDTH];
						end
					5'b10001:
						begin
							d_masterID		<= i_SLAVE_ID[18*MASTERID_WIDTH-1:17*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[18*DATA_WIDTH-1:17*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[18*2-1:17*2];
							d_masterLAST 	<= i_SLAVE_LAST[17:17];
							d_masterUSER	<= i_SLAVE_USER[18*USER_WIDTH-1:17*USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[18*MASTERID_WIDTH-1:17*MASTERID_WIDTH];
						end
					5'b10010:
						begin
							d_masterID		<= i_SLAVE_ID[19*MASTERID_WIDTH-1:18*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[19*DATA_WIDTH-1:18*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[19*2-1:18*2];
							d_masterLAST 	<= i_SLAVE_LAST[18:18];
							d_masterUSER	<= i_SLAVE_USER[19*USER_WIDTH-1:18*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[19*MASTERID_WIDTH-1:18*MASTERID_WIDTH];
						end
					5'b10011:
						begin
							d_masterID		<= i_SLAVE_ID[20*MASTERID_WIDTH-1:19*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[20*DATA_WIDTH-1:19*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[20*2-1:19*2];
							d_masterLAST 	<= i_SLAVE_LAST[19:19];
							d_masterUSER	<= i_SLAVE_USER[20*USER_WIDTH-1:19*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[20*MASTERID_WIDTH-1:19*MASTERID_WIDTH];
						end
					5'b10100:	
						begin
							d_masterID		<= i_SLAVE_ID[21*MASTERID_WIDTH-1:20*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[21*DATA_WIDTH-1:20*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[21*2-1:20*2];
							d_masterLAST 	<= i_SLAVE_LAST[20:20];
							d_masterUSER	<= i_SLAVE_USER[21*USER_WIDTH-1:20*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[21*MASTERID_WIDTH-1:20*MASTERID_WIDTH];
						end
					5'b10101:
						begin
							d_masterID		<= i_SLAVE_ID[22*MASTERID_WIDTH-1:21*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[22*DATA_WIDTH-1:21*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[22*2-1:21*2];
							d_masterLAST 	<= i_SLAVE_LAST[21:21];
							d_masterUSER	<= i_SLAVE_USER[22*USER_WIDTH-1:21*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[22*MASTERID_WIDTH-1:21*MASTERID_WIDTH];
						end
					5'b10110:
						begin
							d_masterID		<= i_SLAVE_ID[23*MASTERID_WIDTH-1:22*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[23*DATA_WIDTH-1:22*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[23*2-1:22*2];
							d_masterLAST 	<= i_SLAVE_LAST[22:22];
							d_masterUSER	<= i_SLAVE_USER[23*USER_WIDTH-1:22*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[23*MASTERID_WIDTH-1:22*MASTERID_WIDTH];
						end
					5'b10111:
						begin
							d_masterID		<= i_SLAVE_ID[24*MASTERID_WIDTH-1:23*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[24*DATA_WIDTH-1:23*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[24*2-1:23*2];
							d_masterLAST 	<= i_SLAVE_LAST[23:23];
							d_masterUSER	<= i_SLAVE_USER[24*USER_WIDTH-1:23*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[24*MASTERID_WIDTH-1:23*MASTERID_WIDTH];
						end
					5'b11000:
						begin
							d_masterID		<= i_SLAVE_ID[25*MASTERID_WIDTH-1:24*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[25*DATA_WIDTH-1:24*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[25*2-1:24*2];
							d_masterLAST 	<= i_SLAVE_LAST[24:24];
							d_masterUSER	<= i_SLAVE_USER[25*USER_WIDTH-1:24*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[25*MASTERID_WIDTH-1:24*MASTERID_WIDTH];
						end
          5'b11001:
						begin
							d_masterID		<= i_SLAVE_ID[26*MASTERID_WIDTH-1:25*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[26*DATA_WIDTH-1:25*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[26*2-1:25*2];
							d_masterLAST 	<= i_SLAVE_LAST[25:25];
							d_masterUSER	<= i_SLAVE_USER[26*USER_WIDTH-1:25*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[26*MASTERID_WIDTH-1:25*MASTERID_WIDTH];
						end
					5'b11010:
						begin
							d_masterID		<= i_SLAVE_ID[27*MASTERID_WIDTH-1:26*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[27*DATA_WIDTH-1:26*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[27*2-1:26*2];
							d_masterLAST 	<= i_SLAVE_LAST[26:26];
							d_masterUSER	<= i_SLAVE_USER[27*USER_WIDTH-1:26*USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[27*MASTERID_WIDTH-1:26*MASTERID_WIDTH];
						end
					5'b11011:
						begin
							d_masterID		<= i_SLAVE_ID[28*MASTERID_WIDTH-1:27*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[28*DATA_WIDTH-1:27*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[28*2-1:27*2];
							d_masterLAST 	<= i_SLAVE_LAST[27:27];
							d_masterUSER	<= i_SLAVE_USER[28*USER_WIDTH-1:27*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[28*MASTERID_WIDTH-1:27*MASTERID_WIDTH];
						end
					5'b11100:
						begin
							d_masterID		<= i_SLAVE_ID[29*MASTERID_WIDTH-1:28*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[29*DATA_WIDTH-1:28*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[29*2-1:28*2];
							d_masterLAST 	<= i_SLAVE_LAST[28:28];
							d_masterUSER	<= i_SLAVE_USER[29*USER_WIDTH-1:28*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[29*MASTERID_WIDTH-1:28*MASTERID_WIDTH];
						end
					5'b11101:	
						begin
							d_masterID		<= i_SLAVE_ID[30*MASTERID_WIDTH-1:29*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[30*DATA_WIDTH-1:29*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[30*2-1:29*2];
							d_masterLAST 	<= i_SLAVE_LAST[29:29];
							d_masterUSER	<= i_SLAVE_USER[30*USER_WIDTH-1:29*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[30*MASTERID_WIDTH-1:29*MASTERID_WIDTH];
						end
					5'b11110:
						begin
							d_masterID		<= i_SLAVE_ID[31*MASTERID_WIDTH-1:30*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[31*DATA_WIDTH-1:30*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[31*2-1:30*2];
							d_masterLAST 	<= i_SLAVE_LAST[30:30];
							d_masterUSER	<= i_SLAVE_USER[31*USER_WIDTH-1:30*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[31*MASTERID_WIDTH-1:30*MASTERID_WIDTH];
						end
					5'b11111:
						begin
							d_masterID		<= i_SLAVE_ID[32*MASTERID_WIDTH-1:31*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[32*DATA_WIDTH-1:31*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[32*2-1:31*2];
							d_masterLAST 	<= i_SLAVE_LAST[31:31];
							d_masterUSER	<= i_SLAVE_USER[32*USER_WIDTH-1:31*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[32*MASTERID_WIDTH-1:31*MASTERID_WIDTH];
						end

					default:
						begin
							d_masterID		<= i_SLAVE_ID[32*MASTERID_WIDTH-1:31*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[32*DATA_WIDTH-1:31*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[32*2-1:31*2];
							d_masterLAST 	<= i_SLAVE_LAST[31:31];
							d_masterUSER	<= i_SLAVE_USER[32*USER_WIDTH-1:31*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[32*MASTERID_WIDTH-1:31*MASTERID_WIDTH];
						end
				endcase
			end
	end  // always		
  
  else if ( NUM_SLAVES_WIDTH == 6 )

	always @(* )
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_masterID		<= 0;
		d_masterDATA 	<= 0;
		d_masterRESP 	<= 0;
		d_masterLAST 	<= 0;
		d_masterUSER	<= 0;

		d_currDataTransID <= currDataTransID;
		
		if (requestorSelValid)				// if an active request, drive selected requestor to all slave ports 
			begin
				case( requestorSelEnc )
					6'b000000:	
						begin
							d_masterID		<= i_SLAVE_ID[MASTERID_WIDTH-1:0];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[DATA_WIDTH-1:0];
							d_masterRESP 	<= i_SLAVE_RESP[2-1:0];
							d_masterLAST 	<= i_SLAVE_LAST[0:0];
							d_masterUSER	<= i_SLAVE_USER[USER_WIDTH-1:0];
							
							d_currDataTransID	<= i_SLAVE_ID[1*MASTERID_WIDTH-1:0*MASTERID_WIDTH];
						end
					6'b000001:
						begin
							d_masterID		<= i_SLAVE_ID[2*MASTERID_WIDTH-1:MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[2*2-1:1*2];
							d_masterLAST 	<= i_SLAVE_LAST[1:1];
							d_masterUSER	<= i_SLAVE_USER[2*USER_WIDTH-1:USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[2*MASTERID_WIDTH-1:1*MASTERID_WIDTH];
						end
					6'b000010:
						begin
							d_masterID		<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[3*DATA_WIDTH-1:2*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[3*2-1:2*2];
							d_masterLAST 	<= i_SLAVE_LAST[2:2];
							d_masterUSER	<= i_SLAVE_USER[3*USER_WIDTH-1:2*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[3*MASTERID_WIDTH-1:2*MASTERID_WIDTH];
						end
					6'b000011:
						begin
							d_masterID		<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[4*DATA_WIDTH-1:3*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[4*2-1:3*2];
							d_masterLAST 	<= i_SLAVE_LAST[3:3];
							d_masterUSER	<= i_SLAVE_USER[4*USER_WIDTH-1:3*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[4*MASTERID_WIDTH-1:3*MASTERID_WIDTH];
						end
					6'b000100:	
						begin
							d_masterID		<= i_SLAVE_ID[5*MASTERID_WIDTH-1:4*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[5*DATA_WIDTH-1:4*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[5*2-1:4*2];
							d_masterLAST 	<= i_SLAVE_LAST[4:4];
							d_masterUSER	<= i_SLAVE_USER[5*USER_WIDTH-1:4*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[5*MASTERID_WIDTH-1:4*MASTERID_WIDTH];
						end
					6'b000101:
						begin
							d_masterID		<= i_SLAVE_ID[6*MASTERID_WIDTH-1:5*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[6*DATA_WIDTH-1:5*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[6*2-1:5*2];
							d_masterLAST 	<= i_SLAVE_LAST[5:5];
							d_masterUSER	<= i_SLAVE_USER[6*USER_WIDTH-1:5*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[6*MASTERID_WIDTH-1:5*MASTERID_WIDTH];
						end
					6'b000110:
						begin
							d_masterID		<= i_SLAVE_ID[7*MASTERID_WIDTH-1:6*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[7*DATA_WIDTH-1:6*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[7*2-1:6*2];
							d_masterLAST 	<= i_SLAVE_LAST[6:6];
							d_masterUSER	<= i_SLAVE_USER[7*USER_WIDTH-1:6*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[7*MASTERID_WIDTH-1:6*MASTERID_WIDTH];
						end
					6'b000111:
						begin
							d_masterID		<= i_SLAVE_ID[8*MASTERID_WIDTH-1:7*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[8*DATA_WIDTH-1:7*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[8*2-1:7*2];
							d_masterLAST 	<= i_SLAVE_LAST[7:7];
							d_masterUSER	<= i_SLAVE_USER[8*USER_WIDTH-1:7*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[8*MASTERID_WIDTH-1:7*MASTERID_WIDTH];
						end
					6'b001000:
						begin
							d_masterID		<= i_SLAVE_ID[9*MASTERID_WIDTH-1:8*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[9*DATA_WIDTH-1:8*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[9*2-1:8*2];
							d_masterLAST 	<= i_SLAVE_LAST[8:8];
							d_masterUSER	<= i_SLAVE_USER[9*USER_WIDTH-1:8*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[9*MASTERID_WIDTH-1:8*MASTERID_WIDTH];
						end
          6'b001001:
						begin
							d_masterID		<= i_SLAVE_ID[10*MASTERID_WIDTH-1:9*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[10*DATA_WIDTH-1:9*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[10*2-1:9*2];
							d_masterLAST 	<= i_SLAVE_LAST[9:9];
							d_masterUSER	<= i_SLAVE_USER[10*USER_WIDTH-1:9*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[10*MASTERID_WIDTH-1:9*MASTERID_WIDTH];
						end
					6'b001010:
						begin
							d_masterID		<= i_SLAVE_ID[11*MASTERID_WIDTH-1:10*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[11*DATA_WIDTH-1:10*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[11*2-1:10*2];
							d_masterLAST 	<= i_SLAVE_LAST[10:10];
							d_masterUSER	<= i_SLAVE_USER[11*USER_WIDTH-1:10*USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[11*MASTERID_WIDTH-1:10*MASTERID_WIDTH];
						end
					6'b001011:
						begin
							d_masterID		<= i_SLAVE_ID[12*MASTERID_WIDTH-1:11*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[12*DATA_WIDTH-1:11*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[12*2-1:11*2];
							d_masterLAST 	<= i_SLAVE_LAST[11:11];
							d_masterUSER	<= i_SLAVE_USER[12*USER_WIDTH-1:11*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[12*MASTERID_WIDTH-1:11*MASTERID_WIDTH];
						end
					6'b001100:
						begin
							d_masterID		<= i_SLAVE_ID[13*MASTERID_WIDTH-1:12*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[13*DATA_WIDTH-1:12*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[13*2-1:12*2];
							d_masterLAST 	<= i_SLAVE_LAST[12:12];
							d_masterUSER	<= i_SLAVE_USER[13*USER_WIDTH-1:12*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[13*MASTERID_WIDTH-1:12*MASTERID_WIDTH];
						end
					6'b001101:	
						begin
							d_masterID		<= i_SLAVE_ID[14*MASTERID_WIDTH-1:13*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[14*DATA_WIDTH-1:13*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[14*2-1:13*2];
							d_masterLAST 	<= i_SLAVE_LAST[13:13];
							d_masterUSER	<= i_SLAVE_USER[14*USER_WIDTH-1:13*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[14*MASTERID_WIDTH-1:13*MASTERID_WIDTH];
						end
					6'b001110:
						begin
							d_masterID		<= i_SLAVE_ID[15*MASTERID_WIDTH-1:14*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[15*DATA_WIDTH-1:14*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[15*2-1:14*2];
							d_masterLAST 	<= i_SLAVE_LAST[14:14];
							d_masterUSER	<= i_SLAVE_USER[15*USER_WIDTH-1:14*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[15*MASTERID_WIDTH-1:14*MASTERID_WIDTH];
						end
					6'b001111:
						begin
							d_masterID		<= i_SLAVE_ID[16*MASTERID_WIDTH-1:15*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[16*DATA_WIDTH-1:15*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[16*2-1:15*2];
							d_masterLAST 	<= i_SLAVE_LAST[15:15];
							d_masterUSER	<= i_SLAVE_USER[16*USER_WIDTH-1:15*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[16*MASTERID_WIDTH-1:15*MASTERID_WIDTH];
						end
          6'b010000:	
						begin
							d_masterID		<= i_SLAVE_ID[17*MASTERID_WIDTH-1:16*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[17*DATA_WIDTH-1:16*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[17*2-1:16*2];
							d_masterLAST 	<= i_SLAVE_LAST[16:16];
							d_masterUSER	<= i_SLAVE_USER[17*USER_WIDTH-1:16*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[17*MASTERID_WIDTH-1:16*MASTERID_WIDTH];
						end
					6'b010001:
						begin
							d_masterID		<= i_SLAVE_ID[18*MASTERID_WIDTH-1:17*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[18*DATA_WIDTH-1:17*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[18*2-1:17*2];
							d_masterLAST 	<= i_SLAVE_LAST[17:17];
							d_masterUSER	<= i_SLAVE_USER[18*USER_WIDTH-1:17*USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[18*MASTERID_WIDTH-1:17*MASTERID_WIDTH];
						end
					6'b010010:
						begin
							d_masterID		<= i_SLAVE_ID[19*MASTERID_WIDTH-1:18*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[19*DATA_WIDTH-1:18*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[19*2-1:18*2];
							d_masterLAST 	<= i_SLAVE_LAST[18:18];
							d_masterUSER	<= i_SLAVE_USER[19*USER_WIDTH-1:18*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[19*MASTERID_WIDTH-1:18*MASTERID_WIDTH];
						end
					6'b010011:
						begin
							d_masterID		<= i_SLAVE_ID[20*MASTERID_WIDTH-1:19*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[20*DATA_WIDTH-1:19*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[20*2-1:19*2];
							d_masterLAST 	<= i_SLAVE_LAST[19:19];
							d_masterUSER	<= i_SLAVE_USER[20*USER_WIDTH-1:19*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[20*MASTERID_WIDTH-1:19*MASTERID_WIDTH];
						end
					6'b010100:	
						begin
							d_masterID		<= i_SLAVE_ID[21*MASTERID_WIDTH-1:20*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[21*DATA_WIDTH-1:20*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[21*2-1:20*2];
							d_masterLAST 	<= i_SLAVE_LAST[20:20];
							d_masterUSER	<= i_SLAVE_USER[21*USER_WIDTH-1:20*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[21*MASTERID_WIDTH-1:20*MASTERID_WIDTH];
						end
					6'b010101:
						begin
							d_masterID		<= i_SLAVE_ID[22*MASTERID_WIDTH-1:21*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[22*DATA_WIDTH-1:21*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[22*2-1:21*2];
							d_masterLAST 	<= i_SLAVE_LAST[21:21];
							d_masterUSER	<= i_SLAVE_USER[22*USER_WIDTH-1:21*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[22*MASTERID_WIDTH-1:21*MASTERID_WIDTH];
						end
					6'b010110:
						begin
							d_masterID		<= i_SLAVE_ID[23*MASTERID_WIDTH-1:22*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[23*DATA_WIDTH-1:22*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[23*2-1:22*2];
							d_masterLAST 	<= i_SLAVE_LAST[22:22];
							d_masterUSER	<= i_SLAVE_USER[23*USER_WIDTH-1:22*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[23*MASTERID_WIDTH-1:22*MASTERID_WIDTH];
						end
					6'b010111:
						begin
							d_masterID		<= i_SLAVE_ID[24*MASTERID_WIDTH-1:23*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[24*DATA_WIDTH-1:23*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[24*2-1:23*2];
							d_masterLAST 	<= i_SLAVE_LAST[23:23];
							d_masterUSER	<= i_SLAVE_USER[24*USER_WIDTH-1:23*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[24*MASTERID_WIDTH-1:23*MASTERID_WIDTH];
						end
					6'b011000:
						begin
							d_masterID		<= i_SLAVE_ID[25*MASTERID_WIDTH-1:24*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[25*DATA_WIDTH-1:24*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[25*2-1:24*2];
							d_masterLAST 	<= i_SLAVE_LAST[24:24];
							d_masterUSER	<= i_SLAVE_USER[25*USER_WIDTH-1:24*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[25*MASTERID_WIDTH-1:24*MASTERID_WIDTH];
						end
          6'b011001:
						begin
							d_masterID		<= i_SLAVE_ID[26*MASTERID_WIDTH-1:25*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[26*DATA_WIDTH-1:25*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[26*2-1:25*2];
							d_masterLAST 	<= i_SLAVE_LAST[25:25];
							d_masterUSER	<= i_SLAVE_USER[26*USER_WIDTH-1:25*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[26*MASTERID_WIDTH-1:25*MASTERID_WIDTH];
						end
					6'b011010:
						begin
							d_masterID		<= i_SLAVE_ID[27*MASTERID_WIDTH-1:26*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[27*DATA_WIDTH-1:26*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[27*2-1:26*2];
							d_masterLAST 	<= i_SLAVE_LAST[26:26];
							d_masterUSER	<= i_SLAVE_USER[27*USER_WIDTH-1:26*USER_WIDTH];	
							
							d_currDataTransID	<= i_SLAVE_ID[27*MASTERID_WIDTH-1:26*MASTERID_WIDTH];
						end
					6'b011011:
						begin
							d_masterID		<= i_SLAVE_ID[28*MASTERID_WIDTH-1:27*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[28*DATA_WIDTH-1:27*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[28*2-1:27*2];
							d_masterLAST 	<= i_SLAVE_LAST[27:27];
							d_masterUSER	<= i_SLAVE_USER[28*USER_WIDTH-1:27*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[28*MASTERID_WIDTH-1:27*MASTERID_WIDTH];
						end
					6'b011100:
						begin
							d_masterID		<= i_SLAVE_ID[29*MASTERID_WIDTH-1:28*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[29*DATA_WIDTH-1:28*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[29*2-1:28*2];
							d_masterLAST 	<= i_SLAVE_LAST[28:28];
							d_masterUSER	<= i_SLAVE_USER[29*USER_WIDTH-1:28*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[29*MASTERID_WIDTH-1:28*MASTERID_WIDTH];
						end
					6'b011101:	
						begin
							d_masterID		<= i_SLAVE_ID[30*MASTERID_WIDTH-1:29*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[30*DATA_WIDTH-1:29*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[30*2-1:29*2];
							d_masterLAST 	<= i_SLAVE_LAST[29:29];
							d_masterUSER	<= i_SLAVE_USER[30*USER_WIDTH-1:29*USER_WIDTH];		
							
							d_currDataTransID	<= i_SLAVE_ID[30*MASTERID_WIDTH-1:29*MASTERID_WIDTH];
						end
					6'b011110:
						begin
							d_masterID		<= i_SLAVE_ID[31*MASTERID_WIDTH-1:30*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[31*DATA_WIDTH-1:30*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[31*2-1:30*2];
							d_masterLAST 	<= i_SLAVE_LAST[30:30];
							d_masterUSER	<= i_SLAVE_USER[31*USER_WIDTH-1:30*USER_WIDTH];					
							
							d_currDataTransID	<= i_SLAVE_ID[31*MASTERID_WIDTH-1:30*MASTERID_WIDTH];
						end
					6'b011111:
						begin
							d_masterID		<= i_SLAVE_ID[32*MASTERID_WIDTH-1:31*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[32*DATA_WIDTH-1:31*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[32*2-1:31*2];
							d_masterLAST 	<= i_SLAVE_LAST[31:31];
							d_masterUSER	<= i_SLAVE_USER[32*USER_WIDTH-1:31*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[32*MASTERID_WIDTH-1:31*MASTERID_WIDTH];
						end

					default:
						begin
							d_masterID		<= i_SLAVE_ID[32*MASTERID_WIDTH-1:31*MASTERID_WIDTH];			// pick out ID 
							d_masterDATA 	<= i_SLAVE_DATA[32*DATA_WIDTH-1:31*DATA_WIDTH];
							d_masterRESP 	<= i_SLAVE_RESP[32*2-1:31*2];
							d_masterLAST 	<= i_SLAVE_LAST[31:31];
							d_masterUSER	<= i_SLAVE_USER[32*USER_WIDTH-1:31*USER_WIDTH];						
							
							d_currDataTransID	<= i_SLAVE_ID[32*MASTERID_WIDTH-1:31*MASTERID_WIDTH];
						end
				endcase
			end
	end  // always		
	
endgenerate


always @(posedge sysClk or negedge sysReset )
begin
	if (!sysReset)
		begin
			currDataTransID <= 0;
			openTransDec	<= 0;
		end
	else
		begin
			openTransDec	<= 0;
	
			//if ( requestorSelValid & d_masterLAST )  // -- Commented For SAR90208 -Incorrect generation of "openTransDec" when "d_masterLAST" gets extended .
                                                       // -- Thread Count should be decremented with the completion of the read data cycle for the same thread.
			if ( requestorSelValid & arbEnable )       // -- Added For SAR90208 
				begin
					currDataTransID		<= d_currDataTransID;
					openTransDec		<= MASTER_READY;
				end

		end
end

//=====================================================================================
// Master bus
//=====================================================================================

always @(*)

begin
	
	masterID		<= d_masterID;
	MASTER_DATA  	<= d_masterDATA;
	MASTER_RESP  	<= d_masterRESP;
	MASTER_LAST  	<= d_masterLAST;
	MASTER_USER		<= d_masterUSER;

	MASTER_VALID 	<= 0;		// initialise to 0 to indicate no transaction
	SLAVE_READY	 	<= 0;
	
	if ( requestorSelValid && (slaveValidQual[requestorSelEnc]))	// pass through VALID when requestorValid
		begin
		    MASTER_VALID					<= (SLAVE_VALID[requestorSelEnc]);
			SLAVE_READY[ requestorSelEnc ] 	<= MASTER_READY;  
		end

end	

assign	masterReady		= (MASTER_READY & MASTER_VALID );				// masterReady when ready is asserted on master targeted

// Completed this transaction when see LAST & VALID & READY
assign arbEnable 		= MASTER_LAST &  masterReady;					// free to arb for Next

	
	
endmodule // caxi4interconnect_ReadDataMux.v
