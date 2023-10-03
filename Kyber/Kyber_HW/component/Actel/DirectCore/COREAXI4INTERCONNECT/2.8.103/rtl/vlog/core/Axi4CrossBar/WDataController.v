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
//     Abstract  : This module stores the write transaction details (src & dest ports) from write address transactions,
//                 arbitrates between Masters requesting accesses (on a per Slave based in Crossbar mode or all requestors in
//                 shared access mode) and performs the Data MUXing from Masters to Slaves and the responses back from the slaves for 
//                 the Write Data Channel.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_WDataController # 
	(
		parameter integer NUM_MASTERS			= 2, 				// defines number of masters
		parameter integer NUM_MASTERS_WIDTH		= 1, 				// defines number of bits to encode master number
		
		parameter integer NUM_SLAVES     		= 2, 				// defines number of slaves
		parameter integer NUM_SLAVES_WIDTH 		= 1,				// defines number of bits to encoode slave number

		parameter integer ID_WIDTH   			= 1, 
		parameter integer DATA_WIDTH 			= 32,

		parameter OPEN_WRTRANS_MAX				= 3,				// max number of outstanding write transactions - valid range 1-8

		parameter integer SUPPORT_USER_SIGNALS 	= 0,
		parameter integer USER_WIDTH 			= 1,

		parameter integer CROSSBAR_MODE			= 1,				// defines whether non-blocking (ie set 1) or shared access data path

		parameter [NUM_SLAVES*NUM_MASTERS-1:0] 		MASTER_WRITE_CONNECTIVITY 		= {NUM_SLAVES*NUM_MASTERS{1'b1}},
		
		parameter	HI_FREQ						= 1					// increases freq of operation at cost of added latency
   
	)
	(
		// Global Signals
		input  wire                                                    	sysClk,
		input  wire                                                    	sysReset,			// active low reset synchronoise to RE AClk - asserted async.
   
		//====================== Slave Data Ports  ================================================//
		output  wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]      SLAVE_WID,
		output  wire [NUM_SLAVES*DATA_WIDTH-1:0]    					SLAVE_WDATA,
		output  wire [NUM_SLAVES*(DATA_WIDTH/8)-1:0]               		SLAVE_WSTRB,
		output  wire [NUM_SLAVES-1:0]                           		SLAVE_WLAST,
		output  wire [NUM_SLAVES*USER_WIDTH-1:0]         				SLAVE_WUSER,
		output  wire [NUM_SLAVES-1:0]                           		SLAVE_WVALID,
		
		input wire [NUM_SLAVES-1:0]                           			SLAVE_WREADY,
		
		//====================== Master Data  Ports  ================================================//
		input wire [NUM_MASTERS * ID_WIDTH-1:0]            			    MASTER_WID,
		input wire [NUM_MASTERS*DATA_WIDTH-1:0]     					MASTER_WDATA,
		input wire [NUM_MASTERS*(DATA_WIDTH/8)-1:0]     				MASTER_WSTRB,
		input wire [NUM_MASTERS-1:0]                            		MASTER_WLAST,
		input wire [NUM_MASTERS*USER_WIDTH-1:0]          				MASTER_WUSER,
		input wire [NUM_MASTERS-1:0]                            		MASTER_WVALID,

		output wire [NUM_MASTERS-1:0]                            		MASTER_WREADY,
   
		//======================= Write Address Controller Port======================================//
		input wire														dataFifoWr,
		input wire	[(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 					srcPort,
		input wire	[NUM_SLAVES_WIDTH-1:0]								destPort,
		output wire [NUM_SLAVES-1:0]									wrFifoFull
		
		
	);
   						 
						 
//================================================================================================
// Local Parameters and declarations
//================================================================================================

	localparam MASTERID_WIDTH		= ( NUM_MASTERS_WIDTH + ID_WIDTH );			// defines width masterID - includes infrastructure ID plus ID
	localparam THREAD_VEC_WIDTH		= ( MASTERID_WIDTH + NUM_SLAVES_WIDTH );	// defines width of per thread vector elements width

	localparam STRB_WIDTH			= (DATA_WIDTH/8);							// defines width of write strobes 


	wire [(NUM_SLAVES-1)*CROSSBAR_MODE:0]	wrFifoEmpty, wrFifoRdValid;
	
	//=======================================================================================================================
	// Store write address transactions - per master in crossbar mode or shared in shared-access mode. 
	//=======================================================================================================================     
 	genvar i;
	generate
	if (CROSSBAR_MODE == 1)			// implement full non-blocking data path for read data
		begin	:	iWrConXB

			// Local declarations for crossbar mode
			wire [NUM_SLAVES-1:0]		wrAddrMasterWr;
			wire [NUM_SLAVES-1:0]		dataFifoRd;
			
			wire [NUM_MASTERS_WIDTH-1:0]	wrfifoRdData	[NUM_SLAVES-1:0]; 
	
			wire [NUM_SLAVES-1:0]		fifoOverRunErr;
			wire [NUM_SLAVES-1:0]		fifoUnderRunErr;
			wire [NUM_SLAVES-1:0]		wrMasterValid;
			wire [NUM_SLAVES-1:0]		wrFifoEmptyQ1;
					
			wire [NUM_MASTERS_WIDTH-1:0]	srcMaster			[NUM_SLAVES-1:0];
	
			reg  [NUM_MASTERS-1:0]			MASTER_WREADYVec	[NUM_SLAVES-1:0];
			wire [NUM_MASTERS-1:0]			masterWREADYVec		[NUM_SLAVES-1:0];
			
					
			//======================================================================================
			// In Crossbar mode data paths are non-blocking so need per slave fifos as well
			//======================================================================================
			for (i=0; i < NUM_SLAVES; i=i+1)
				begin	: iWrConFif
				
					// Pick out Infrastructure component of srcPort and use to qualify write per master
					assign wrAddrMasterWr[i] = dataFifoWr & ( destPort == i[NUM_SLAVES_WIDTH-1:0] );	
					
					//====================================================================================================
					// caxi4interconnect_FIFO to hold open write transactions - pushed on Address write cycle and popped on write data
					// cycle.
					//=====================================================================================================
					caxi4interconnect_FifoDualPort #	(	.HI_FREQ( HI_FREQ ),
										.NEAR_FULL ( 'd2 ),
										.FIFO_AWIDTH( OPEN_WRTRANS_MAX ),
										.FIFO_WIDTH( NUM_MASTERS_WIDTH )
									)
						wrFif	(
										.HCLK(	sysClk ),
										.fifo_reset( sysReset ),
					
										// Write Port
										.fifoWrite( wrAddrMasterWr[i] ),
										.fifoWrData( srcPort[MASTERID_WIDTH-1 : ID_WIDTH ] ),	// pick out infrastructure ID

										// Read Port
										.fifoRead( dataFifoRd[i] ),
										.fifoRdData( wrfifoRdData[i] ),
					
										// Status bits
										.fifoEmpty ( wrFifoEmpty[i] ) ,
										.fifoOneAvail(  ),
										.fifoRdValid( wrFifoRdValid[i] ),		// indicates read data is valid - handles clocked rd data
										.fifoFull(  ),
										.fifoNearFull( 	wrFifoFull[i]  ),		// use nearly full to allow cover race between "full" and arb
										.fifoOverRunErr( fifoOverRunErr[i] ),
										.fifoUnderRunErr( fifoUnderRunErr[i] )
				   
								)/* synthesis syn_hier = "remove" */;
 

					// Src Master has request when not empty and wrtite connective to target slave
 					assign wrMasterValid[i] = !wrFifoEmpty[i] & wrFifoRdValid[i];
					assign srcMaster[i] 	= wrfifoRdData[i];

			
					//===================================================================================================
					// caxi4interconnect_WriteDataMux muxes the selected requesting master to the slave port
					//=================================================================================================== 
					caxi4interconnect_WriteDataMux # 
						(
							.NUM_MASTERS				( NUM_MASTERS ),	
							.NUM_MASTERS_WIDTH			( NUM_MASTERS_WIDTH ),
							.NUM_SLAVES 				( NUM_SLAVES ),
							.NUM_SLAVES_WIDTH 			( NUM_SLAVES_WIDTH ),
							.ID_WIDTH  					( ID_WIDTH ),
							.DATA_WIDTH					( DATA_WIDTH ),
							.SUPPORT_USER_SIGNALS		( SUPPORT_USER_SIGNALS ),
							.USER_WIDTH 				( USER_WIDTH ),
							.WRITE_CONNECTIVITY			( MASTER_WRITE_CONNECTIVITY[(i+1)*NUM_MASTERS -1: i*NUM_MASTERS]  ),
							.HI_FREQ					( HI_FREQ ),
							.MASTERID_WIDTH             ( MASTERID_WIDTH)
						)
					wrDMux(
							// Global Signals
							.sysClk			( sysClk ),
							.sysReset		( sysReset ),				
	
							// WrFifo Ports  
							.dataFifoRd		( dataFifoRd[i]    ),
							.wrMasterValid  ( wrMasterValid[i] ),
							.srcMaster		( srcMaster[i]  ),

							//  Master Data  Ports  
							.MASTER_WVALID	( MASTER_WVALID ),
							.MASTER_WID     ( MASTER_WID   ),
							.MASTER_WDATA	( MASTER_WDATA ),
							.MASTER_WSTRB	( MASTER_WSTRB ),
							.MASTER_WLAST	( MASTER_WLAST ),
							.MASTER_WUSER	( MASTER_WUSER ),
							.MASTER_WREADY	( masterWREADYVec[i] ),

							// Slave Data Ports  
							.SLAVE_WVALID	( SLAVE_WVALID[i] ),
							.SLAVE_WID      ( SLAVE_WID[(i+1)*MASTERID_WIDTH-1:i*MASTERID_WIDTH]),
							.SLAVE_WDATA	( SLAVE_WDATA[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] ),
							.SLAVE_WSTRB	( SLAVE_WSTRB[(i+1)*STRB_WIDTH-1:i*STRB_WIDTH] ),
							.SLAVE_WLAST	( SLAVE_WLAST[ i] ),
							.SLAVE_WUSER	( SLAVE_WUSER[(i+1)*USER_WIDTH-1:i*USER_WIDTH] ),
							.SLAVE_WREADY	( SLAVE_WREADY[i] )
  	
						)/* synthesis syn_hier = "remove" */;				
				
			
					//====================================================================================================
					// "OR" all MASTER_WREADYVec - each vector should have only 1 bit set
					//====================================================================================================
					always @(*)
						begin
							if (i == 0)
								begin
									MASTER_WREADYVec[0]	<= masterWREADYVec[0];
								end
							else
								begin
									// OR all vectors to allow each "active" master to pass its ready.
									MASTER_WREADYVec[i] <= masterWREADYVec[i] | MASTER_WREADYVec[i-1];
								end
						end
					
				end				
				
				assign MASTER_WREADY	= MASTER_WREADYVec[NUM_SLAVES-1];
								
		end
	else
		begin	: iWrConSh		// implement shared write datapath - only one write mux path

			//==================================================================
			// Local declarations for shared-access mode
			//==================================================================
			wire 							wrAddrMasterWr;
			wire 							dataFifoRd;
			
			wire [NUM_MASTERS_WIDTH + NUM_SLAVES_WIDTH-1:0]		wrfifoRdData;
	
			wire 							fifoOverRunErr;
			wire 							fifoUnderRunErr;
			wire 							wrMasterValid;		

			wire 					    	slaveWVALID;
			wire [MASTERID_WIDTH-1:0]       slaveWID;
			wire [DATA_WIDTH-1:0]			slaveWDATA;
			wire [(DATA_WIDTH/8)-1:0] 		slaveWSTRB;
			wire 					        slaveWLAST;
			wire [USER_WIDTH-1:0]			slaveWUSER;
		
			wire [NUM_SLAVES_WIDTH-1:0]		destSlave;
			wire [NUM_MASTERS_WIDTH-1:0]	srcMaster;

			wire							wrFifoFulltmp;
			
			reg [NUM_SLAVES-1:0]			aSLAVE_WVALID;
		
			//==================================================================
		
		
			// All write transactions go into same caxi4interconnect_FIFO in shared-access mode
			assign wrAddrMasterWr = dataFifoWr;	
					
			//====================================================================================================
			// caxi4interconnect_FIFO to hold open write transactions - pushed on Address write cycle and popped on write data
			// cycle.
			//=====================================================================================================
			caxi4interconnect_FifoDualPort #	(	.HI_FREQ( 1'b0 ),		// no pipeline on data
								.FIFO_AWIDTH( OPEN_WRTRANS_MAX ),
								.FIFO_WIDTH( NUM_MASTERS_WIDTH + NUM_SLAVES_WIDTH )
							)
				wrFif	(
								.HCLK(	sysClk ),
								.fifo_reset( sysReset ),
					
								// Write Port
								.fifoWrite( wrAddrMasterWr ),
								.fifoWrData( { srcPort[MASTERID_WIDTH-1 : ID_WIDTH ], destPort }  ),	// Pick out infrastructure ID and destPort

								// Read Port
								.fifoRead( dataFifoRd  ),		// pop when any bit set
								.fifoRdData( wrfifoRdData ),
					
								// Status bits
								.fifoEmpty ( wrFifoEmpty ) ,
								.fifoOneAvail(   ),
								.fifoRdValid( wrFifoRdValid ),
								.fifoFull(  ),
								.fifoNearFull( wrFifoFulltmp ),				// use 1 from full to allow cover race between "full" and arb
								.fifoOverRunErr( fifoOverRunErr ),
								.fifoUnderRunErr( fifoUnderRunErr )
				   		) /* synthesis syn_hier = "remove" */;
 

			// Masters have requests stopped when full - stop for any master as common data-path
			assign wrFifoFull = { NUM_SLAVES{ wrFifoFulltmp }  };


			// Src Master has request when not empty and wrtite connective to target slave
			assign wrMasterValid = !wrFifoEmpty & wrFifoRdValid;
			
			assign srcMaster = wrfifoRdData[NUM_MASTERS_WIDTH+NUM_SLAVES_WIDTH-1: NUM_SLAVES_WIDTH];
			assign destSlave = wrfifoRdData[NUM_SLAVES_WIDTH-1: 0];
			
		
			//===================================================================================================
			// caxi4interconnect_WriteDataMux muxes the selected requesting master to the slave port
			//=================================================================================================== 
			caxi4interconnect_WriteDataMux # 
				(
					.NUM_MASTERS				( NUM_MASTERS ),	
					.NUM_MASTERS_WIDTH			( NUM_MASTERS_WIDTH ),
					.NUM_SLAVES 				( NUM_SLAVES ),
					.NUM_SLAVES_WIDTH 			( NUM_SLAVES_WIDTH ),
					.ID_WIDTH  					( ID_WIDTH ),
					.DATA_WIDTH					( DATA_WIDTH ),
					.SUPPORT_USER_SIGNALS		( SUPPORT_USER_SIGNALS ),
					.USER_WIDTH 				( USER_WIDTH ),
					.HI_FREQ					( HI_FREQ )
				)
			wrDMux(
					// Global Signals
					.sysClk			( sysClk ),
					.sysReset		( sysReset ),				

					// WrFifo Ports  
					.dataFifoRd		( dataFifoRd    ),
					.wrMasterValid  ( wrMasterValid ),
					.srcMaster		( srcMaster  ),

					//  Master Data  Ports  
					.MASTER_WVALID	( MASTER_WVALID ),
					.MASTER_WID     ( MASTER_WID    ),
					.MASTER_WDATA	( MASTER_WDATA  ),
					.MASTER_WSTRB	( MASTER_WSTRB  ),
					.MASTER_WLAST	( MASTER_WLAST  ),
					.MASTER_WUSER	( MASTER_WUSER  ),
					.MASTER_WREADY	( MASTER_WREADY ),

					// Slave Data Ports  
					.SLAVE_WVALID	( slaveWVALID ),
					.SLAVE_WID      ( slaveWID   ),
					.SLAVE_WDATA	( slaveWDATA ),
					.SLAVE_WSTRB	( slaveWSTRB ),
					.SLAVE_WLAST	( slaveWLAST ),
					.SLAVE_WUSER	( slaveWUSER ),
					.SLAVE_WREADY	( SLAVE_WREADY[destSlave]  )	
				) /* synthesis syn_hier = "remove" */;				
				
			//====================================================================================
			// Route output of DataMux to individual slave ports
			//====================================================================================	
			for (i=0; i< NUM_SLAVES; i=i+1 )
				begin
					assign SLAVE_WDATA[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] = slaveWDATA;
					assign SLAVE_WSTRB[(i+1)*STRB_WIDTH-1:i*STRB_WIDTH] = slaveWSTRB;
					assign SLAVE_WLAST[(i+1)*1-1:i*1]                 	= slaveWLAST;
					assign SLAVE_WUSER[(i+1)*USER_WIDTH-1:i*USER_WIDTH] = slaveWUSER;
					assign SLAVE_WID  [(i+1)*MASTERID_WIDTH-1:i*MASTERID_WIDTH] = slaveWID;	  
				end

			//================================================================================
			// Mux VALID based on Master target port for read
			//================================================================================
			always @(*)
				begin
					aSLAVE_WVALID 	<= 0;							// initialise to 0 to indicate no transaction - only one can be active
					aSLAVE_WVALID[ destSlave ]	<= slaveWVALID;		// slaveWVALID held deasserted unless valid transaction available
				end				

			assign 	SLAVE_WVALID	= aSLAVE_WVALID;

				
		end
			
	endgenerate

	
endmodule // caxi4interconnect_WDataController.v
