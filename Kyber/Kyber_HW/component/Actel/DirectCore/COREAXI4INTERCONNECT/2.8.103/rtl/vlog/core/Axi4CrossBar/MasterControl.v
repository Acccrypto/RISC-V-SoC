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
//     Abstract  : This module performs a dependency check on request and if qualified
//                 requests a slot from SlotArbitrator. Open threads are stored and incremented
//                 decremented.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 
module caxi4interconnect_MasterControl # 
	(
		parameter NUM_SLAVES 			= 4,		// defines number of slaves - includes internal DERR Slave
		parameter NUM_SLAVES_WIDTH 		= 2,		// defines number of bits to encoode slave number

		parameter MASTERID_WIDTH		= 4,		// defines number of bits to in masterID - includes Infrastructure ID + requestor ID
	
		parameter ADDR_WIDTH 			= 32,		// number of address bits to be decoded
		parameter ADDR_WIDTH_BITS		=  5,		// defines number of bits for ADDR_WIDTh - 64 -6, 32 = 5

		parameter NUM_THREADS			= 1,		// defined number of indpendent threads per master supported 
		parameter NUM_THREADS_WIDTH		= 1,		// defined number of bits to encode threads number 
		parameter OPEN_TRANS_MAX		= 3,		// max number of outstanding transactions 
		parameter OPEN_TRANS_WIDTH		= 2,		// width of open transaction count 

		parameter UPPER_COMPARE_BIT 	= 15,		// Defines the upper bit of range to compare
		parameter LOWER_COMPARE_BIT 	= 12,		// Defines lower bound of compare - bits below are dont care

		// Define memory map for slaves - none for DERR slave
		parameter [ ( ( NUM_SLAVES-1)* (ADDR_WIDTH-UPPER_COMPARE_BIT) )-1 : 0 ] 		SLOT_BASE_VEC = 0,		// SLOT Base per slave 
		parameter [ ( ( NUM_SLAVES-1)* (UPPER_COMPARE_BIT-LOWER_COMPARE_BIT))-1 : 0 ] 	SLOT_MIN_VEC  = 0,		// SLOT Min per slave 
		parameter [ ( ( NUM_SLAVES-1)* (UPPER_COMPARE_BIT-LOWER_COMPARE_BIT))-1 : 0 ] 	SLOT_MAX_VEC  = 1,		// SLOT Max per slave 
		parameter [NUM_SLAVES-1:0]		CONNECTIVITY		= { NUM_SLAVES{1'b1} }, 							// onnectivity map
		parameter  WR_MODULE            = 1
   
	)
	(
		// Global Signals
		input  wire							sysClk,
		input  wire							sysReset,					// active low reset synchronoise to RE AClk - asserted async.
   
		//========================== Master Port ==========================================
		input wire 	[ADDR_WIDTH-1:0]		masterAddr,					// address to be decoded
		input wire							masterValid,				// indicates Master has a valid address available
	
		input wire	[MASTERID_WIDTH-1:0]	masterID,					// unique ID per infrastructure Master port - includes infrastructure + ID


		//========================== SlotArbitrator Port  ===================================
		output wire							validQual,					// Indictaes this slave matched address

		//========= caxi4interconnect_TargetMuxController Port ======================//
		input wire							openTransInc,				// Increment openTransVec for thread matching currTransID
		output wire	[NUM_SLAVES_WIDTH-1:0]	currTransSlaveID,			// slaveID for current transaction			


		//========= DataControl Port =============================//
		input wire	[MASTERID_WIDTH-1:0] 	currDataTransID,			// current data transaction ID
		input wire							openTransDec,				// indicates thread matching currDataTransID to be decremented
		
		//====================== WrFifo Port ===============================================
		input wire 	[NUM_SLAVES-1:0]		stopTrans									// indicates to address control to "stop" allowing 
																						// Address transactions.	


	);
   						 
//==================================================================================================
// Local Declarations
//==================================================================================================						 
	wire								threadAvail;					// indicates a thread slot available for new threadID

	wire								threadValid;
	wire 	[OPEN_TRANS_WIDTH-1:0]		threadCount;
	wire	[NUM_SLAVES_WIDTH-1:0]		threadSlaveID;

 	wire								currTransSlaveValid;			// asserted when currTransSlaveID is valid
	wire	[MASTERID_WIDTH-1:0]		currTransID;					// ID for current transaction

	
//====================================================================================================

						 
	caxi4interconnect_DependenceChecker #(
							.NUM_SLAVES 		( NUM_SLAVES ),				// defines number of slaves
							.NUM_SLAVES_WIDTH 	( NUM_SLAVES_WIDTH ),		// defines number of bits to encoode slave number
							.MASTERID_WIDTH		( MASTERID_WIDTH ),			// defines number of bits to in masterID - includes Infrastructure ID + requestor ID

							.ADDR_WIDTH 		( ADDR_WIDTH ),				// number of address bits to be decoded
							.ADDR_WIDTH_BITS	( ADDR_WIDTH_BITS  ), 		// defines number of bits for ADDR_WIDTh - 64 -6, 32 = 5

							.NUM_THREADS		( NUM_THREADS ),			// defined number of indpendent threads per master supported 
							.NUM_THREADS_WIDTH	( NUM_THREADS_WIDTH ),		// defined number of bits to encode threads number 

							.OPEN_TRANS_MAX		( OPEN_TRANS_MAX ),			// max number of outstanding transactions 
							.OPEN_TRANS_WIDTH	( OPEN_TRANS_WIDTH ),		// width of open transaction count 	
						
							.UPPER_COMPARE_BIT 	( UPPER_COMPARE_BIT ),		// Defines the upper bit of range to compare
							.LOWER_COMPARE_BIT 	( LOWER_COMPARE_BIT ),		// Defines lower bound of compare - bits below are dont care
													
							.SLOT_BASE_VEC ( SLOT_BASE_VEC ),				// Base address of Slot
							.SLOT_MIN_VEC  ( SLOT_MIN_VEC  ), 				// slot min address in decoded space
							.SLOT_MAX_VEC  ( SLOT_MAX_VEC ),				// slot max address in decoded space
							.CONNECTIVITY	( CONNECTIVITY )				// Connectivity map for this master
						
						)
					depck 	(
					            .sysClk         ( sysClk        ),
					            .sysReset       ( sysReset      ),
								.masterAddr		( masterAddr 	),
								.masterValid	( masterValid 	),
								.masterID		( masterID 		),
								.threadAvail	( threadAvail 	),
								.threadValid	( threadValid 	),
								.threadCount	( threadCount 	),
								.threadSlaveID	( threadSlaveID ),
								.currTransSlaveValid( currTransSlaveValid ),	// asserted when currTransSlaveID is valid
								.currTransSlaveID( currTransSlaveID ),			// slaveID for current transaction
								.currTransID	( currTransID 	),				// ID for current transaction
								.stopTrans		( stopTrans		),
								.validQual		( validQual 	),
								.openTransInc   ( openTransInc  ),
								.openTransDec   ( openTransDec  )
		
							)	/* synthesis syn_hier = "remove" */;		
								
		
		
	caxi4interconnect_TransactionController #(
							.NUM_SLAVES_WIDTH 	( NUM_SLAVES_WIDTH ),		
							.MASTERID_WIDTH		( MASTERID_WIDTH ),			// defines number of bits to in masterID - includes Infrastructure ID + requestor ID
							.NUM_THREADS		( NUM_THREADS ),			// defined number of indpendent threads per master supported 
							.NUM_THREADS_WIDTH	( NUM_THREADS_WIDTH ),		// defined number of bits to encode threads number 
							.OPEN_TRANS_MAX		( OPEN_TRANS_MAX ),			// max number of outstanding transactions 
							.OPEN_TRANS_WIDTH	( OPEN_TRANS_WIDTH ),		// width of open transaction count 							
							.WR_MODULE      	( WR_MODULE )		        // Read Chaneel Address or Write Address Channel
							)
					trnscon (	
								.sysClk				( sysClk ),
								.sysReset			( sysReset ),
								.currTransSlaveID	( currTransSlaveID ),				// slaveID for current transaction
								.currTransID		( currTransID ),					// ID for current transaction						
								.threadAvail		( threadAvail ),
								.threadValid		( threadValid ),
								.threadCount		( threadCount ),
								.threadSlaveID		( threadSlaveID ),
								.openTransInc		( openTransInc ),
								.currDataTransID	( currDataTransID ),
								.openTransDec		( openTransDec )

							)	/* synthesis syn_hier = "remove" */;


	
endmodule // caxi4interconnect_MasterControl.v
