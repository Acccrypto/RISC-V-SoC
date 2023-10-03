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
//     Abstract  : This file decodes which slave device the master is addressing. The match is
//                 combinationally output. It matches if the master address input matches the 
//                 address range for the slave.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_MasterAddressDecoder (
								masterAddr,
								match,					
								slaveMatched
							 );


//===================================================
// Parameter Declarations
//===================================================

	parameter NUM_SLAVES_WIDTH 	= 4;				// defines number bits for encoding slave number
	parameter NUM_SLAVES 		= 4;				// defines number of slaves	- includes derrSlave
	parameter SLAVE_NUM	 		= 0;				// defines slave that this decoder is for
	parameter ADDR_WIDTH 		= 32;				// number of address buts to be decoded
	
	parameter UPPER_COMPARE_BIT = 15;				// Defines the upper bit of range to compare
	parameter LOWER_COMPARE_BIT = 12;				// Defines lower bound of compare - bits below are 
													// dont care
													
	parameter [ADDR_WIDTH-1:UPPER_COMPARE_BIT]			SLOT_BASE_ADDR = 0;		// Base address of Slot
	parameter [UPPER_COMPARE_BIT-1:LOWER_COMPARE_BIT]   SLOT_MIN_ADDR = 0;		// slot min address
	parameter [UPPER_COMPARE_BIT-1:LOWER_COMPARE_BIT]   SLOT_MAX_ADDR = 0;		// slot max address
	parameter [NUM_SLAVES-1:0]							CONNECTIVITY = {NUM_SLAVES{1'b1}};	// onnectivity map - ie which slaves this master can access
	
//==========================================================================
// I/O Declarations
//============================================================================

	input 	[ADDR_WIDTH-1:0]		masterAddr;		// address to be decoded

	output							match;			// Indictaes this slave matched address
	output 	[NUM_SLAVES_WIDTH-1:0] 	slaveMatched;	// encoded number of slave
	
	
//============================================================================
// Local Declarationes
//============================================================================


	reg								match;			// Indictaes this slave matched address
	wire 	[NUM_SLAVES_WIDTH-1:0] 	slaveMatched;	// encoded number of slave
	
 
 
//==============================================================================
// Simple decode matching
//==============================================================================

assign slaveMatched = SLAVE_NUM;		// simply return number of slave instance
/*

//SAR 94407 Change Start

always @( * )
begin
	match <= 		( masterAddr[ADDR_WIDTH-1:UPPER_COMPARE_BIT] == SLOT_BASE_ADDR			 )		// base address matches
				&	( masterAddr[UPPER_COMPARE_BIT-1:LOWER_COMPARE_BIT] >= SLOT_MIN_ADDR	 )
				&	( masterAddr[UPPER_COMPARE_BIT-1:LOWER_COMPARE_BIT] <= SLOT_MAX_ADDR	 )
				&	CONNECTIVITY[SLAVE_NUM];														// only match if master can access this slave

end

*/

always @( * )
begin
	match <=    	( masterAddr[UPPER_COMPARE_BIT-1:LOWER_COMPARE_BIT] >= SLOT_MIN_ADDR	 )
				&	( masterAddr[UPPER_COMPARE_BIT-1:LOWER_COMPARE_BIT] <= SLOT_MAX_ADDR	 )
				&	CONNECTIVITY[SLAVE_NUM];														// only match if master can access this slave

end

//SAR 94407 Change End


endmodule // caxi4interconnect_MasterAddressDecoder.v
