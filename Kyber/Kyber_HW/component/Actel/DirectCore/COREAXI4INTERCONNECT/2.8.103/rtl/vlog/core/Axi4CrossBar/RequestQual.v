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
//     Abstract  : This module only asserted bits in slaveValidQual for ports what are requesting access to master that
//                 matches this caxi4interconnect_ReadDataController instance.      
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_RequestQual # 
	(
		parameter integer NUM_SLAVES 			= 8, 				// defines number of slaves requestors  
		parameter integer NUM_MASTERS_WIDTH		= 1, 				// defines number of bits to encode master number
		parameter integer ID_WIDTH   			= 1,
		parameter integer CROSSBAR_MODE			= 1				// defines whether non-blocking (ie set 1) or shared access data path
	)
	(
		input  wire [NUM_SLAVES-1:0]    								SLAVE_VALID,
		input  wire [3:0]                                   			MASTER_NUM,     // jhayes : change to width to match maximum width possible.
  		input  wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 		SLAVE_ID,
		input  wire [NUM_SLAVES-1:0]									READ_CONNECTIVITY,
		
		output  reg [NUM_SLAVES-1:0]    								slaveValidQual
	);
						 
//================================================================================================
// Local Parameters
//================================================================================================
	localparam MASTERID_WIDTH		= ( NUM_MASTERS_WIDTH + ID_WIDTH );			// defines width masterID - includes infrastructure ID plus ID


//=================================================================================================
// Local Declarationes
//=================================================================================================
	reg	[NUM_MASTERS_WIDTH-1:0]		slaveTargetID	[0:NUM_SLAVES-1];

//=================================================================================================

genvar i;
generate 
	for (i=0; i < NUM_SLAVES; i=i+1)
		begin
			always @(*)
				begin
				// pick out infrastructure component from SLAVE_ID - ie target master
				slaveTargetID[i] 	<= SLAVE_ID[(i+1)*MASTERID_WIDTH-1:(i*MASTERID_WIDTH)+ ID_WIDTH];
			
				// Only assert slaveValidQual to arbitrator when slave valid is asserted and the SLAVE_ID is targetting this
				// master and READ_CONNECTIVITY is set for this slave
				slaveValidQual[i]	<= READ_CONNECTIVITY[i] & SLAVE_VALID[i] &  
												( CROSSBAR_MODE ?  ( slaveTargetID[i] == MASTER_NUM[NUM_MASTERS_WIDTH-1:0] )    // jhayes : change to use relevant bits of MASTER_NUM for comparison.
															    : 1'b1 );	// all slaves arb togather in non-crossbar mode - does not
																			// matter which master they want to connect to - only one path
				end
		end
		
endgenerate


endmodule // caxi4interconnect_RequestQual.v
