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
//     Abstract  : This module controls which slave gets its data selected to be sent to
//                 target master. It arbitrates between slave requestors and muxes
//                 slave data signals to target master based on SLAVE_ID.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_RDataController # 
	(
		parameter integer NUM_MASTERS			= 2, 				// defines number of masters
		parameter integer NUM_MASTERS_WIDTH		= 1, 				// defines number of bits to encode master number
		
		parameter integer NUM_SLAVES     		= 2, 				// defines number of slaves
		parameter integer NUM_SLAVES_WIDTH 		= 1,				// defines number of bits to encoode slave number

		parameter integer ID_WIDTH   			= 1, 
		parameter integer DATA_WIDTH 			= 32,

		parameter integer SUPPORT_USER_SIGNALS 	= 0,
		parameter integer USER_WIDTH 			= 1,

		parameter integer CROSSBAR_MODE			= 1,				// defines whether non-blocking (ie set 1) or shared access data path
		parameter integer OPEN_RDTRANS_MAX		= 2,

		parameter [NUM_MASTERS*NUM_SLAVES-1:0] 		MASTER_READ_CONNECTIVITY 		= {NUM_MASTERS*NUM_SLAVES{1'b1}},

		parameter	HI_FREQ						= 0, 				// used to add registers to allow a higher freq of operation at cost of latency
		parameter	RD_ARB_EN 					= 1					// select arb or ordered rdata
	
   
	)
	(
		// Global Signals
		input  wire                                                    	sysClk,
		input  wire                                                    	sysReset,			// active high reset synchronoise to RE sysClk - asserted async.
   
		//====================== Slave Data Ports  ================================================//
  		input  wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 		SLAVE_ID,
		input  wire [NUM_SLAVES*DATA_WIDTH-1:0]    						SLAVE_DATA,
		input  wire [NUM_SLAVES*2-1:0]                         			SLAVE_RESP,
		input  wire [NUM_SLAVES-1:0]                           			SLAVE_LAST,
		input  wire [NUM_SLAVES*USER_WIDTH-1:0]         				SLAVE_USER,
		input  wire [NUM_SLAVES-1:0]                           			SLAVE_VALID,
		
		output wire [NUM_SLAVES-1:0]                           			SLAVE_READY,
		
		//====================== Master Data  Ports  ================================================//
		output wire [NUM_MASTERS*ID_WIDTH-1:0]          				MASTER_ID,
		output wire [NUM_MASTERS*DATA_WIDTH-1:0]     					MASTER_DATA,
		output wire [NUM_MASTERS*2-1:0]                          		MASTER_RESP,
		output wire [NUM_MASTERS-1:0]                            		MASTER_LAST,
		output wire [NUM_MASTERS*USER_WIDTH-1:0]          				MASTER_USER,
		output wire [NUM_MASTERS-1:0]                            		MASTER_VALID,

		input  wire [NUM_MASTERS-1:0]                            		MASTER_READY,
   
		//====================== DataControl Port ============================================//
		
		output wire	[NUM_MASTERS*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 		currDataTransID,	// current data transaction ID
		output wire	[NUM_MASTERS-1:0]  									openTransDec,		// indicates thread matching currDataTransID to be decremented

		//======================= Read Address Controller Port======================================//
		input wire														rdDataFifoWr,
		input wire	[(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 					rdSrcPort,
		input wire	[NUM_SLAVES_WIDTH-1:0]								rdDestPort,
		output wire [1+NUM_MASTERS-1:0]									rdFifoFull	
		
	);
   						 
						 
//================================================================================================
// Local Parameters
//================================================================================================

	localparam MASTERID_WIDTH		= ( NUM_MASTERS_WIDTH + ID_WIDTH );			// defines width masterID - includes infrastructure ID plus ID
	localparam THREAD_VEC_WIDTH		= ( MASTERID_WIDTH + NUM_SLAVES_WIDTH );	// defines width of per thread vector elements width

	wire	 [NUM_MASTERS-1:0]		rdFifoActFull;								// internal probe signal
	wire	 [NUM_MASTERS-1:0]		rdFifoEmpty;								// internal probe signal
	
	//=======================================================================================================================
	// caxi4interconnect_ReadDataController arbitrates between Slaves requestors (RVALID),  drivers to selected targeted Master based SLAVE_RID
	// and "pops" open transaction with currDataTransID when openTransDec at end of transaction.
	//=======================================================================================================================     
 	genvar i;
	generate
	if (CROSSBAR_MODE == 1)			// implement full non-blocking data path for read data
		begin : MD
		
			// Local parameters
			wire [MASTERID_WIDTH-1:0]	masterID		[NUM_MASTERS -1:0];					
			wire [NUM_SLAVES-1:0]		slaveReady		[NUM_MASTERS -1:0];			// temp store of vectors from each master read controller
			reg [NUM_SLAVES-1:0]		SLAVE_READYVec	[NUM_MASTERS -1:0];			// temp store of vectors from each master read controller

			//==========================================================================
			// Declare a caxi4interconnect_ReadDataController for each Master port
			//==========================================================================
			for (i=0; i< NUM_MASTERS; i=i+1 )
				begin
				
					caxi4interconnect_ReadDataController # 
						(
							.MASTER_NUM					( i	),					// Port number
							.NUM_MASTERS				( NUM_MASTERS ), 				// defines number of masters
							.NUM_MASTERS_WIDTH			( NUM_MASTERS_WIDTH ), 			// defines number of bits to encode master number
							.NUM_SLAVES     			( NUM_SLAVES ), 				// defines number of slaves
							.NUM_SLAVES_WIDTH 			( NUM_SLAVES_WIDTH ),			// defines number of bits to encoode slave number
							.ID_WIDTH   				( ID_WIDTH ), 
							.DATA_WIDTH 				( DATA_WIDTH ),
							.SUPPORT_USER_SIGNALS 		( SUPPORT_USER_SIGNALS ),
							.USER_WIDTH 				( USER_WIDTH ),
							.CROSSBAR_MODE				( CROSSBAR_MODE ),
							.OPEN_RDTRANS_MAX			( OPEN_RDTRANS_MAX ),							
							.MASTER_READ_CONNECTIVITY 	( MASTER_READ_CONNECTIVITY[((i+1)*NUM_SLAVES)-1:i*NUM_SLAVES] ),   // which slaves can be read from this master
							.HI_FREQ					( HI_FREQ ),
							.RD_ARB_EN					( RD_ARB_EN )							
							)
					rdcon	(
								// Global Signals
								.sysClk ( sysClk ),
								.sysReset( sysReset ),			// active low reset synchronoise to RE sysClk - asserted async.

								// Slave Data Ports  
								.SLAVE_VALID	( SLAVE_VALID ),
								.SLAVE_ID		( SLAVE_ID ),
								.SLAVE_DATA		( SLAVE_DATA ),
								.SLAVE_RESP		( SLAVE_RESP ),
								.SLAVE_LAST		( SLAVE_LAST ),
								.SLAVE_USER		( SLAVE_USER ),
								.SLAVE_READY	( slaveReady[i] ),

								// Master Data  Port  
								.masterID		( masterID[i] ),
								.MASTER_DATA	( MASTER_DATA[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] ),
								.MASTER_RESP	( MASTER_RESP[(i+1)*2-1:i*2] ),
								.MASTER_LAST	( MASTER_LAST[i] ),
								.MASTER_USER	( MASTER_USER[(i+1)*USER_WIDTH-1:i*USER_WIDTH] ),
								.MASTER_VALID	( MASTER_VALID[i] ),
								.MASTER_READY	( MASTER_READY[i] ),
      
								// Data Controller  
								.currDataTransID( currDataTransID[(i+1)*MASTERID_WIDTH-1:i*MASTERID_WIDTH] ),	// indicates transaction to be decremented 
								.openTransDec( openTransDec[i] ),			// indicates ID of transaction to be decremented

								// Address Controller
								.rdDataFifoWr( rdDataFifoWr ),
								.rdSrcPort( rdSrcPort ),
								.rdDestPort( rdDestPort ),
								.rdFifoEmpty( rdFifoEmpty[i] ),
								.rdFifoActFull( rdFifoActFull[i] ),
								.rdFifoFull( rdFifoFull[i] ) 			// indicates to address control to "stop" address transactions
																		// caxi4interconnect_DERR_Slave never full!
							)/* synthesis syn_hier = "flatten,remove" */;
							
					// Drop Infrastructure component from ID 
					assign MASTER_ID[(i+1)*ID_WIDTH-1:i*ID_WIDTH] = masterID[i][MASTERID_WIDTH-NUM_MASTERS_WIDTH-1:0];


					
					
					//====================================================================================================
					// "OR" all slaveReadys - each vector should have only 1 bit set
					//====================================================================================================
					always @(*)
						begin
							if (i == 0)
								SLAVE_READYVec[0] <= slaveReady[0];
							else
								// OR all slaveReady vectors to allow each "active" master to pass its ready.
								SLAVE_READYVec[i] <= slaveReady[i] | SLAVE_READYVec[i-1];
						end
					
				end
       
        // always assign rdFifoFull for caxi4interconnect_DERR_Slave    bbriscoe: moved this to outside the 'for' loop.
        assign rdFifoFull[NUM_MASTERS] = 0;
        
				assign SLAVE_READY = SLAVE_READYVec[NUM_MASTERS-1];
				
		end
	else
		begin : SD			// implement shared read datapath - only one read mux path

			// Declare local paramaters for shared-mode
			wire [NUM_SLAVES-1:0]			slaveReady;
			
			wire [MASTERID_WIDTH-1:0]		masterID;
			wire [DATA_WIDTH-1:0]     		masterDATA;
			wire [1:0]	                    masterRESP;
			wire 				          	masterLAST;
			wire [USER_WIDTH-1:0]           masterUSER;

			reg	[NUM_MASTERS-1:0]  			currTransDec;
			
			wire [(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 		dataTransID;	// current data transaction ID
			wire											transDec;
			wire											rdFifoFulltmp, rdFifoActFulltmp, rdFifoEmptytmp;
			
			wire 				              	masterVALID;
			reg									masterREADY;

			reg [NUM_MASTERS_WIDTH-1:0]			targetMaster, targetMasterQ1;
			reg	[NUM_MASTERS-1:0] 				aMASTER_VALID;
			

	
			caxi4interconnect_ReadDataController # 
				(
					.MASTER_NUM					( {NUM_MASTERS_WIDTH{1'b0} }  ),// Port number - not used in Shared Data mode
					.NUM_MASTERS				( NUM_MASTERS ), 				// defines number of masters
					.NUM_MASTERS_WIDTH			( NUM_MASTERS_WIDTH ), 			// defines number of bits to encode master number
					.NUM_SLAVES     			( NUM_SLAVES ), 				// defines number of slaves
					.NUM_SLAVES_WIDTH 			( NUM_SLAVES_WIDTH ),			// defines number of bits to encoode slave number
					.ID_WIDTH   				( ID_WIDTH ), 
					.DATA_WIDTH 				( DATA_WIDTH ),
					.SUPPORT_USER_SIGNALS 		( SUPPORT_USER_SIGNALS ),
					.USER_WIDTH 				( USER_WIDTH ),
					.CROSSBAR_MODE				( CROSSBAR_MODE ),
					.OPEN_RDTRANS_MAX			( OPEN_RDTRANS_MAX ),							
					.MASTER_READ_CONNECTIVITY 	( {NUM_MASTERS*NUM_SLAVES{1'b1} } ),   // no pruning as one common path
					.HI_FREQ					( HI_FREQ ),
					.RD_ARB_EN					( RD_ARB_EN )							
				)
			rdcon	(
					// Global Signals
					.sysClk ( sysClk ),
					.sysReset( sysReset ),			// active low reset synchronoise to RE sysClk - asserted async.
								
					// Slave Data Ports  
					.SLAVE_VALID	( SLAVE_VALID ),
					.SLAVE_ID		( SLAVE_ID ),
					.SLAVE_DATA		( SLAVE_DATA ),
					.SLAVE_RESP		( SLAVE_RESP ),
					.SLAVE_LAST		( SLAVE_LAST ),
					.SLAVE_USER		( SLAVE_USER ),
					.SLAVE_READY	( slaveReady ),

					// Master Data  Port  
					.masterID		( masterID ),
					.MASTER_DATA	( masterDATA ),
					.MASTER_RESP	( masterRESP ),
					.MASTER_LAST	( masterLAST ),
					.MASTER_USER	( masterUSER ),
					.MASTER_VALID	( masterVALID ),
					.MASTER_READY	( masterREADY ),
      
					// Data Controller  
					.currDataTransID( dataTransID ),	// indicates transaction to be decremented 
					.openTransDec( transDec ),			// indicates ID of transaction to be decremented

					// Address Controller
					.rdDataFifoWr( rdDataFifoWr ),
					.rdSrcPort( rdSrcPort ),
					.rdDestPort( rdDestPort ),
					.rdFifoEmpty( rdFifoEmptytmp ),
					.rdFifoActFull( rdFifoActFulltmp ),
					.rdFifoFull( rdFifoFulltmp ) 			// indicates to address control to "stop" address transactions
														// caxi4interconnect_DERR_Slave never full!
					)  /* synthesis syn_hier = "flatten,remove" */;


			// Masters have requests stopped when full - stop for any master as common data-path
			assign rdFifoFull = { 1'b0, { NUM_MASTERS{ rdFifoFulltmp } }   };		// MSD is for caxi4interconnect_DERR_Slave - never stopped

			assign rdFifoActFull = { NUM_MASTERS{ rdFifoActFulltmp } };
			assign rdFifoEmpty = { NUM_MASTERS{ rdFifoEmptytmp } };
			
			//=============================================================================
			// Route all "common" signals to all master interfaces
			//=============================================================================
			for (i=0; i< NUM_MASTERS; i=i+1 )
				begin
					assign MASTER_ID[  (i+1)*ID_WIDTH-1  :i*ID_WIDTH]		= masterID[MASTERID_WIDTH-NUM_MASTERS_WIDTH-1:0];	// Strip off infrastructure ID
					assign MASTER_DATA[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] 	= masterDATA;
					assign MASTER_RESP[(i+1)*2-1   		 :i*2]				= masterRESP;
					assign MASTER_LAST[(i+1)*1-1		 :i*1]				= masterLAST;
					assign MASTER_USER[(i+1)*USER_WIDTH-1:i*USER_WIDTH] 	= masterUSER;
				end

			//================================================================================
			// Mux VALID and Reads based on Master target port for read
			//================================================================================
			always @(*)
				begin
	
					aMASTER_VALID 	<= 0;		// initialise to 0 to indicate no transaction
					
					targetMaster <= masterID[MASTERID_WIDTH-1:ID_WIDTH];	// pick out target master from RID
					
					aMASTER_VALID[ targetMaster ]	<= masterVALID;
					masterREADY 					<= MASTER_READY[targetMaster];  

					currTransDec					<= 0;
					currTransDec[ targetMasterQ1 ] 	<= transDec;

				end

			//======================================================================
			// Pass transDec back to approbriate master - needs to be clocked
			// as targetMaster changes before transDec asserted.
			//======================================================================
			always @(posedge sysClk)
				begin
					targetMasterQ1	<= targetMaster;
				end
				
			// Data Controller  signals routed to all ports
			assign currDataTransID	=  { NUM_MASTERS{ dataTransID } };
			assign openTransDec		= currTransDec;
			
			assign MASTER_VALID = aMASTER_VALID;		
			assign SLAVE_READY  = slaveReady;	
				
		end
			
	endgenerate

	
endmodule // caxi4interconnect_RDataController.v
