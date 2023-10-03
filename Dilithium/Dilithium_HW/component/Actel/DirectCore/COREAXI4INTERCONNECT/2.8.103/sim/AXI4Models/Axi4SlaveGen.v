// ********************************************************************
//  Microsemi Corporation Proprietary and Confidential
//  Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: This module provides a AXI4 Slave test source.
//
// Revision Information:
// Date     Description:
// Feb17    Revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************
`timescale 1ns / 1ns

module Axi4SlaveGen # 
	(

		parameter [3:0]		SLAVE_NUM				= 0,		// slaive number
		parameter integer 	ID_WIDTH   				= 4, 

		parameter integer 	ADDR_WIDTH      		= 32,				
		parameter integer 	DATA_WIDTH 				= 32, 

		parameter integer 	SUPPORT_USER_SIGNALS 	= 0,
		parameter integer 	USER_WIDTH 				= 1,

		
		parameter integer 	OPENTRANS_MAX			= 2,		// Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.

		parameter integer	LOWER_COMPARE_BIT 		= 'd10,		// Defines lower bound of compare - bits below are dont care
		parameter			HI_FREQ					= 0
		
	)
	(
		// Global Signals
		input  wire                                    		sysClk,
		input  wire                                    		ARESETN,			// active low reset synchronoise to RE AClk - asserted async.
   
		//====================== Slave Read Address Ports  ================================================//
		// Slave Read Address Port
		input wire [ID_WIDTH-1:0]          					SLAVE_ARID,
		input wire [ADDR_WIDTH-1:0]          				SLAVE_ARADDR,
		input wire [7:0]                         			SLAVE_ARLEN,
		input wire [2:0]                         			SLAVE_ARSIZE,
		input wire [1:0]                         			SLAVE_ARBURST,
		input wire [1:0]                         			SLAVE_ARLOCK,
		input wire [3:0]                         			SLAVE_ARCACHE,
		input wire [2:0]                         			SLAVE_ARPROT,
		input wire [3:0]                         			SLAVE_ARREGION,			// not used
		input wire [3:0]                         			SLAVE_ARQOS,			// not used
		input wire [USER_WIDTH-1:0]	        				SLAVE_ARUSER,
		input wire                            				SLAVE_ARVALID,				
		output  wire 	                       				SLAVE_ARREADY,
   
		// Slave Read Data Ports
		output  reg [ID_WIDTH-1:0]          				SLAVE_RID,
		output  reg [DATA_WIDTH-1:0]    					SLAVE_RDATA,
		output  reg [1:0]                     				SLAVE_RRESP,
		output  reg                         				SLAVE_RLAST,
		output  reg [USER_WIDTH-1:0]	        		 	SLAVE_RUSER,			// not used
		output  reg                         				SLAVE_RVALID,
		
		input 	wire	                       				SLAVE_RREADY,
	
		// Slave Write Address Port
		input wire [ID_WIDTH-1:0]          					SLAVE_AWID,
		input wire [ADDR_WIDTH-1:0]          				SLAVE_AWADDR,
		input wire [7:0]                         			SLAVE_AWLEN,
		input wire [2:0]                         			SLAVE_AWSIZE,
		input wire [1:0]                         			SLAVE_AWBURST,
		input wire [1:0]                         			SLAVE_AWLOCK,
		input wire [3:0]                         			SLAVE_AWCACHE,
		input wire [2:0]                         			SLAVE_AWPROT,
		input wire [3:0]                         			SLAVE_AWREGION,			// not used
		input wire [3:0]                         			SLAVE_AWQOS,			// not used
		input wire [USER_WIDTH-1:0]	        				SLAVE_AWUSER,
		input wire                            				SLAVE_AWVALID,				
		output wire	 	                       				SLAVE_AWREADY,
   	
		// Slave Write Data Ports
		input wire [DATA_WIDTH-1:0]    						SLAVE_WDATA,
		input wire [(DATA_WIDTH/8)-1:0]  					SLAVE_WSTRB,
		input wire                           				SLAVE_WLAST,
		input wire [USER_WIDTH-1:0]	         				SLAVE_WUSER,
		input wire                            				SLAVE_WVALID,
		
		output reg                           				SLAVE_WREADY,
		
		// Master Write Response Ports
		output reg [ID_WIDTH-1:0]           				SLAVE_BID,
		output reg [1:0]                          			SLAVE_BRESP,
		output reg [USER_WIDTH-1:0]          				SLAVE_BUSER,
		output reg 	                            			SLAVE_BVALID,

		input  wire  	                           			SLAVE_BREADY,
		
		// ===============  Control Signals  =======================================================//
		input wire											SLAVE_ARREADY_Default,			// defines whether SLAVE asserts ready or waits for ARVALID
		input wire											SLAVE_AWREADY_Default,			// defines whether SLAVE asserts ready or waits for WVALID
	
		input wire											SLAVE_DATA_IDLE_EN,				// Enables idle cycles to be inserted in Data channels
		input wire [1:0]									SLAVE_DATA_IDLE_CYCLES,			// Idle cycles = 00= random, 01 = 1, 10=2, 11=3

		input wire											FORCE_ERROR, 					// Forces error pn read/write RESP
		input wire [7:0]									ERROR_BYTE						// Byte to force error on - for READs
		
	);
   						 
 
	localparam	[0:0]		arstIDLE = 1'h0,	arstDATA = 1'h1;

	localparam integer		NUM_BYTES 				= (DATA_WIDTH/8);			// number of bytes in each read / write 

	localparam [7:0] ALIGNED_BITS = 	$clog2(DATA_WIDTH/8);
								
	reg						d_SLAVE_ARREADY, preSLAVE_ARREADY;
	
	wire					sysReset;
	
	
//=================================================================================================
// Local Declarationes
//=================================================================================================
 
localparam	READFIF_WIDTH = ( ID_WIDTH + ADDR_WIDTH + 8 + 3 + 2 );			// ID, Addr, LEN and SIZE, and Burst 

reg [READFIF_WIDTH-1:0]		readFifWrData;
wire [READFIF_WIDTH-1:0]	readFifRdData;

reg							readFifWr, readFifRd;
wire						readFifoFull, readFifoEmpty;

reg [0:0]					arcurrState, arnextState;
 
reg [7:0]					burstLen, d_burstLen;

wire						rdFifoOverRunErr, rdFifoUnderRunErr;

reg	[LOWER_COMPARE_BIT+ALIGNED_BITS-1:0]	memRdAddr, memWrAddr;
reg	[LOWER_COMPARE_BIT+ALIGNED_BITS-1:0]	d_memRdAddr, d_memWrAddr;

reg [LOWER_COMPARE_BIT+ALIGNED_BITS-1:0] 	memRdAddrAlignedMask, memWrAddrAlignedMask;


wire	[DATA_WIDTH-1:0]	memRdData;
reg	[DATA_WIDTH-1:0]		memWrData;

reg							memWr;
 
reg [15:0]					arCount, d_arCount; 
reg [15:0]					rdCount, d_rdCount; 
 
reg [1:0]					d_idleRdCycles, idleRdCycles;					// holds number of idle cycles per RdData Cycle

reg [1:0]					idleRdCount;
reg 						idleRdCountClr, idleRdCountIncr;

reg [8:0] raddr_rand_sig;
reg [8:0] waddr_rand_sig;
reg [8:0] wdata_rand_sig;
 
 
//=======================================================================================================================
// Local system reset - asserted asynchronously to ACLK and deasserted synchronous
//=======================================================================================================================
//caxi4interconnect_ResetSycnc  
//	rsync(
//			.sysClk	( sysClk ),
//			.sysReset_L( ARESETN ),			// active low reset synchronoise to RE AClk - asserted async.
//			.sysReset( sysReset  )			// active low sysReset synchronised to ACLK
//	);
	assign sysReset = ARESETN; // Temp reomved this block to test silicon issue
 
//=============================================================================================
// Display messages only in Simulation - not synthesis
//=============================================================================================
`ifdef SIM_MODE

	//=============================================================================================
	// Display messages for Read Address Channel
	//=============================================================================================
	always @( posedge sysClk )
	begin
		#1;
	
		if ( SLAVE_ARVALID )
			begin
				#1 $display( "%d, SLAVE  %d - Starting Read Address Transaction %d, ARADDR= %h, ARBURST= %h, ARSIZE= %h, AID= %h, RXLEN= %d", 
								$time, SLAVE_NUM, arCount, SLAVE_ARADDR, SLAVE_ARBURST, SLAVE_ARSIZE, SLAVE_ARID, SLAVE_ARLEN );

				if ( SLAVE_ARREADY )		// single beat
					begin
						#1 $display( "%d, SLAVE  %d - Ending Read Address Transaction %d, AID= %h, RXLEN= %d", 
								$time, SLAVE_NUM, arCount, SLAVE_ARID, SLAVE_ARLEN );
					end
				else
					begin
						@( posedge SLAVE_ARREADY )
							#1 $display( "%d, SLAVE  %d - Ending Read Address Transactions %d, AID= %h, RXLEN= %d", 
								$time, SLAVE_NUM, arCount, SLAVE_ARID, SLAVE_ARLEN );
					end
			end
	end


	//=============================================================================================
	// Display messages for Read Data Channel
	//=============================================================================================
	always @( posedge sysClk )
		begin
			#1;
			if ( SLAVE_RVALID )
				begin
					#1 $display( "%d, SLAVE %d - Starting Read Data Transaction %d, AID= %h, RXLEN= %d", 
							$time, SLAVE_NUM, rdCount, SLAVE_RID, burstLen );

					if ( SLAVE_RLAST & SLAVE_RVALID & SLAVE_RREADY )		// single beat
						begin
							#1 $display( "%d, SLAVE %d - Ending Read Data Transaction %d, AID= %h, RXLEN= %d, RRESP=%h", 
								$time, SLAVE_NUM, rdCount, SLAVE_RID, burstLen, SLAVE_RRESP );
						end
					else
						begin
							@( posedge ( SLAVE_RLAST & SLAVE_RVALID & SLAVE_RREADY ) )
								#1 $display( "%d, SLAVE %d - Ending Read Data Transactions %d, AID= %h, RXLEN= %d, RRESP=%h", 
									$time, SLAVE_NUM, rdCount, SLAVE_RID, burstLen, SLAVE_RID );
						end
				end
		end 
 
 `ifdef VERBOSE
	//=============================================================================================
	// Display RDAT - data begin written from RAM
	//=============================================================================================
	always @( negedge sysClk )
		begin	
			if ( SLAVE_RVALID & SLAVE_RREADY )		
				begin
					$display( "%t, %m, memRdAddr=%h (%d), SLAVE_RDATA= %d", $time, memRdAddr, memRdAddr, SLAVE_RDATA );
				end
		end		
`endif
 
 
 
 
`endif
 
 
 //===========================================================================================
 // FIFO to hold open transactions - pushed on Address Read cycle and popped on read data
 // cycle.
 //===========================================================================================
 caxi4interconnect_FifoDualPort #(	.FIFO_AWIDTH( OPENTRANS_MAX ),
					.FIFO_WIDTH( READFIF_WIDTH ),
					.HI_FREQ( HI_FREQ ),
					.NEAR_FULL( 'd2 )
				)
		rdFif(
					.HCLK(	sysClk ),
					.fifo_reset( sysReset ),
					
					// Write Port
					.fifoWrite( readFifWr ),
					.fifoWrData( readFifWrData ),

					// Read Port
					.fifoRead( readFifRd ),
					.fifoRdData( readFifRdData ),
					
					// Status bits
					.fifoEmpty ( readFifoEmpty ) ,
					.fifoOneAvail(   ),
					.fifoRdValid(  ),
					.fifoFull(  ),
					.fifoNearFull( readFifoFull ),
					.fifoOverRunErr( rdFifoOverRunErr ),
					.fifoUnderRunErr( rdFifoUnderRunErr )
				   
				);

 
		
//=============================================================================
// Declare Dual port RAM - store Slave Data
//=============================================================================
caxi4interconnect_DualPort_RAM_SyncWr_ASyncRd #( 	.FIFO_AWIDTH( LOWER_COMPARE_BIT ),
								.FIFO_WIDTH ( DATA_WIDTH )
							)
		rdRam(
					// global signals
					.HCLK( sysClk ),

					// Write Port
					.fifoWrAddr( memWrAddr ),	
					.fifoWrite ( memWr	   ),
					.fifoWrStrb( SLAVE_WSTRB ),

					.fifoWrData( memWrData ),

					// Read Port
					.fifoRdAddr( d_memRdAddr ),
					.fifoRdData( memRdData )
				   
			);

 
 
//====================================================================================================
// Slave Read Address S/M
//===================================================================================================== 
 always @( * )
 begin
 
	arnextState <= arcurrState;

	readFifWrData <= { SLAVE_ARID, SLAVE_ARADDR, SLAVE_ARLEN, SLAVE_ARSIZE, SLAVE_ARBURST };
	
	d_SLAVE_ARREADY	<= SLAVE_ARREADY_Default;		// only accept a transaction when space in fifo
	readFifWr		<= 0;

	d_arCount		<= arCount;
	
	case( arcurrState )
		arstIDLE: begin
					d_SLAVE_ARREADY <= SLAVE_ARREADY_Default;
		
					if ( SLAVE_ARVALID & SLAVE_ARREADY )		// if always ready
						begin
							d_SLAVE_ARREADY	<= SLAVE_ARREADY_Default;
							
							readFifWr	<= 1;
							d_arCount	<= arCount + 1'b1;

							arnextState <= arstIDLE;
						end
					else if ( SLAVE_ARVALID & !SLAVE_ARREADY )
						begin
							arnextState <= arstDATA;
						end
				end
		arstDATA : begin
					d_SLAVE_ARREADY <= 1'b1;

					if ( SLAVE_ARVALID & SLAVE_ARREADY )		// 	last beat
						begin
							d_SLAVE_ARREADY	<= SLAVE_ARREADY_Default;

							d_arCount		<= arCount + 1'b1;
							
							readFifWr	  	<= 1;
	
							arnextState 		<= arstIDLE;

						end
				end
	endcase
end


 always @( posedge sysClk or negedge sysReset)		
 begin
	if (!sysReset)
		begin
			arcurrState 		<= arstIDLE;
			preSLAVE_ARREADY	<= 0;
			
			arCount				<= 0;

		end
	else
		begin
			arcurrState 		<= arnextState;
			preSLAVE_ARREADY	<= d_SLAVE_ARREADY;
			raddr_rand_sig <= $random() % 100;
      waddr_rand_sig <= (raddr_rand_sig * $random()) % 100;
      wdata_rand_sig <= (waddr_rand_sig * $random()) % 100;
			arCount		<= d_arCount;

		end
end


assign SLAVE_ARREADY = preSLAVE_ARREADY & !readFifoFull & (raddr_rand_sig == 98);


//=================================================================================================
// Local Declarationes for Slave Read Data 
//=================================================================================================
 
reg [ID_WIDTH-1:0] 			d_SLAVE_RID;
reg [DATA_WIDTH-1:0]   		d_SLAVE_RDATA;
reg [1:0]                   d_SLAVE_RRESP;
reg                         d_SLAVE_RLAST;
reg [USER_WIDTH-1:0]        d_SLAVE_RUSER;
reg                         d_SLAVE_RVALID;


reg	[7:0]					rxLen, d_rxLen;
reg [1:0]					rdBurstType, d_rdBurstType; 
reg [2:0]					rdRSize, d_rdRSize; 
 
reg [1:0]					rcurrState, rnextState;

localparam	[1:0]			rstIDLE = 2'h0,	rstDATA = 2'h1, rstIDLE_DATA = 2'h2;


//====================================================================================================
// Counter for Idle on each Read Data
//====================================================================================================
always @(posedge sysClk or negedge sysReset )
begin
	if ( !sysReset )
		begin
			idleRdCount	<= 0;		// initialise to 1
		end
	else if ( idleRdCountClr )
		begin
			idleRdCount	<= 0;		// initiales to 1
		end
	else if ( idleRdCountIncr )
		begin
			idleRdCount	<= idleRdCount + 1'b1;
		end
end

//=================================================================================================
// Create mask to "align" memRdAddr to size of transfer.
//=================================================================================================
always @( * )
	begin
		case( rdRSize )
			3'h0 : memRdAddrAlignedMask <=   { (LOWER_COMPARE_BIT+ALIGNED_BITS  ){1'b1} };
			3'h1 : memRdAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-1){1'b1} }, 1'b0 };
			3'h2 : memRdAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-2){1'b1} }, 2'b0 };
			3'h3 : memRdAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-3){1'b1} }, 3'b0 };
			3'h4 : memRdAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-4){1'b1} }, 4'b0 };
			3'h5 : memRdAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-5){1'b1} }, 5'b0 };
			3'h6 : memRdAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-6){1'b1} }, 6'b0 };
			3'h7 : memRdAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-7){1'b1} }, 7'b0 };
		endcase
	end
	
									
 //====================================================================================================
 // Slave Read Data S/M
//===================================================================================================== 

 always @( * )
 begin
 
	rnextState <= rcurrState;
	
	d_SLAVE_RID		<= SLAVE_RID;
	d_SLAVE_RDATA	<= { SLAVE_NUM, {(DATA_WIDTH-4){1'b0}   } };
	d_SLAVE_RRESP	<= SLAVE_RRESP;
	d_SLAVE_RLAST	<= SLAVE_RLAST;
	d_SLAVE_RUSER	<= 0;
	d_SLAVE_RVALID	<= 0;

	d_rxLen			<= rxLen;
	d_rdBurstType 	<= rdBurstType;
	d_rdRSize		<= rdRSize;
	d_idleRdCycles	<= idleRdCycles;
	
	readFifRd		<= 0;
	
	d_memRdAddr		<= memRdAddr;
	d_burstLen	 	<= burstLen;

	d_rdCount		<= rdCount;

	idleRdCountClr	<= 1'b0;
	idleRdCountIncr	<= 1'b0;
	
	case( rcurrState )
		rstIDLE: begin
					
					d_rxLen 		<= 0;
					d_SLAVE_RLAST	<= 0;
					
					idleRdCountClr	<= 1'b1;

					if ( !readFifoEmpty )				// data to read
						begin
							readFifRd		<= 1;		// pop fifo 

							d_SLAVE_RDATA	<= memRdData;	

							//===========================================================================================
							//FifWrData == { SLAVE_ARID, SLAVE_ARADDR, SLAVE_ARLEN, SLAVE_ARSIZE, SLAVE_ARBURST };
							//===========================================================================================
							d_rdBurstType <= readFifRdData[1:0];
							d_rdRSize	  <= readFifRdData[4:2];
							
							d_memRdAddr	<= readFifRdData[READFIF_WIDTH-ID_WIDTH-1: READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH];
							d_burstLen	<= readFifRdData[READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-8 ]; // pickout ARLEN
							d_SLAVE_RID	<= readFifRdData[READFIF_WIDTH-1: READFIF_WIDTH-ID_WIDTH];

							d_SLAVE_RLAST	<= (readFifRdData[READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-8 ] == 0);

							d_SLAVE_RRESP	<= FORCE_ERROR 	? (ERROR_BYTE == 0 ) ? 2'b10  : 2'b00
															: 2'b00;

							
							//============================================================================
							// see if idle cycles to be inserted
							//============================================================================
							if ( SLAVE_DATA_IDLE_EN )
								begin
									d_SLAVE_RVALID	<= 1'b0;

									case (SLAVE_DATA_IDLE_CYCLES)
										2'b00:		// random cycles
											begin
												`ifdef SIM_MODE		// only use random when in simulation
													d_idleRdCycles <= $random(); 
												`else
													d_idleRdCycles <= 0; 
												`endif
											end
										2'b01:		// 1 idle cycle
											begin
												d_idleRdCycles <= 4'd1; 
											end
										2'b10:		// 2 idle cycle
											begin
												d_idleRdCycles <= 4'd2; 
											end
										2'b11:		// 3 idle cycle
											begin
												d_idleRdCycles <= 4'd3; 
											end
									endcase
							
									rnextState 		<= rstIDLE_DATA;
								end
							else
								begin
									d_idleRdCycles <= 0; 
								
									d_SLAVE_RVALID	<= 1'b1;	// start read cycle
									rnextState 		<= rstDATA;
								end
						end
					else
						begin

						end
						
				end
		rstIDLE_DATA : begin

					d_SLAVE_RDATA	<= memRdData;	
		
					if ( idleRdCount == idleRdCycles )		// if had all idle cycles
						begin
							d_SLAVE_RVALID	<= 1'b1;	// start read cycle

							rnextState 		<= rstDATA;
						end
					else
						begin
							idleRdCountIncr	<= 1'b1;
							
							rnextState 		<= rstIDLE_DATA;
						end
				end

		rstDATA : begin
					d_SLAVE_RVALID	<= 1'b1;
					d_SLAVE_RDATA	<= memRdData;	

					d_SLAVE_RRESP	<= FORCE_ERROR 	? (rxLen == ERROR_BYTE ) ? 2'b10  : 2'b00
													: 2'b00;
					
					if ( SLAVE_RVALID & SLAVE_RREADY & SLAVE_RLAST )		// 	last beat
						begin
							d_rdCount	<= rdCount + 1'b1;					// increment count of read transactions performed

							if ( ~readFifoEmpty )				// if another burst request - start on next clock
								begin
									readFifRd		<= 1;		// pop fifo 
								
									d_SLAVE_RLAST	<= (readFifRdData[READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-8 ] == 0);
									
									// Pick out from Read Fifo
									d_rdBurstType <= readFifRdData[1:0];
									d_rdRSize	  <= readFifRdData[4:2];
									
									d_memRdAddr	<= readFifRdData[READFIF_WIDTH-ID_WIDTH-1: READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH];
									d_burstLen	<= readFifRdData[ READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-8 ]; // pickout ARLEN
									d_SLAVE_RID	<= readFifRdData[READFIF_WIDTH-1: READFIF_WIDTH-ID_WIDTH];

									d_SLAVE_RLAST	<= (readFifRdData[READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-8 ] == 0);
									
									d_rxLen 	<= 0;

									if ( SLAVE_DATA_IDLE_EN )
										begin
								
											if (SLAVE_DATA_IDLE_CYCLES == 0)		// if random delays - update
												begin
													`ifdef SIM_MODE		// only use random when in simulation
														d_idleRdCycles <= $random(); 
													`else
														d_idleRdCycles <= 0; 
													`endif
												end
											d_SLAVE_RVALID	<= 1'b0;	// start next read data transaction
											rnextState  	<= rstIDLE_DATA;
										end
									else
										begin
											d_idleRdCycles <= 0; 

											d_SLAVE_RVALID	<= 1'b1;	// start next read data transaction
											rnextState  	<= rstDATA;
										end
								end
							else
								begin
														
									d_SLAVE_RVALID	<= 1'b0;
									d_SLAVE_RLAST	<= 0;
									d_burstLen		<= 0;
									d_rxLen 		<= 0;
									//d_memRdAddr		<= 0;
							
									rnextState <= rstIDLE;
								end
						end
					else if ( SLAVE_RREADY & SLAVE_RVALID )		// get next data
						begin
						
							case ( rdBurstType )
								2'b00 :			// fixed
									begin
										d_memRdAddr		<= memRdAddr;
									end
								2'b01 :			// increment
									begin
										d_memRdAddr <= ( memRdAddr & memRdAddrAlignedMask) + ( 1 << rdRSize );
																				// increment by number of bytes transferred										
									end
								2'b10 :			// wrap - not handling wrap correctly here
									begin
										d_memRdAddr <= ( memRdAddr & memRdAddrAlignedMask) + ( 1 << rdRSize );
																				// increment by number of bytes transferred										
									end									
								2'b11 :			// reserverd
									begin
										$stop;		// should never get here
									end										
							endcase
							
							d_SLAVE_RLAST	<= ( rxLen +1'b1 == burstLen );		// reached end of burst
							
							d_rxLen 		<= rxLen + 1'b1;

							if ( SLAVE_DATA_IDLE_EN )
								begin
								
									if (SLAVE_DATA_IDLE_CYCLES == 0)		// if random delays - update
										begin
											`ifdef SIM_MODE		// only use random when in simulation
												d_idleRdCycles <= $random(); 
											`else
												d_idleRdCycles <= 0; 
											`endif
										end
									else
										begin
											d_idleRdCycles <= 0; 
										end
										
										d_SLAVE_RVALID	<= 1'b0;	// start next read data transaction
										rnextState  	<= rstIDLE_DATA;
								end
							else
								begin
									d_SLAVE_RVALID	<= 1'b1;	// start next read data transaction
									rnextState  	<= rstDATA;
								end
						
						end
					else			// not ready
						begin
									
						end
				end
	endcase
end


 always @(posedge sysClk or negedge sysReset )
 begin
 
	if (!sysReset)
		begin
			SLAVE_RID		<= 0;
			SLAVE_RDATA		<= { SLAVE_NUM, {(DATA_WIDTH-4){1'b0} }  };
			SLAVE_RRESP		<= 0;
			SLAVE_RLAST		<= 0;
			SLAVE_RUSER		<= 0;
			SLAVE_RVALID	<= 0;
			
			rdBurstType	<= 0;
			rdRSize		<= 0;
			rxLen 		<= 0;
			memRdAddr	<= 0;
			burstLen	<= 0;

			rdCount		<= 0;
			idleRdCycles	<= 0;
			
			rcurrState	<= rstIDLE;
		end
	else
		begin
			SLAVE_RID		<= d_SLAVE_RID;
			SLAVE_RDATA		<= d_SLAVE_RDATA;
			SLAVE_RRESP		<= d_SLAVE_RRESP;
			SLAVE_RLAST		<= d_SLAVE_RLAST;
			SLAVE_RUSER		<= d_SLAVE_RUSER;
			SLAVE_RVALID	<= d_SLAVE_RVALID;
		
			rdBurstType <= d_rdBurstType;
			rdRSize		<= d_rdRSize;
			rxLen 		<= d_rxLen;
			memRdAddr 	<= d_memRdAddr;
			burstLen	<= d_burstLen;

			rdCount		<= d_rdCount;
			idleRdCycles <= d_idleRdCycles;
			
			rcurrState	<= rnextState;
		end
end

//always@(*)
//  SLAVE_RDATA		<= d_SLAVE_RDATA;


// Different paths for simulation and synthesis
// `ifdef SIM_MODE
	// `include "../component/Actel/DirectCore/CoreAXI4Interconnect_w/2.1.3/sim/AXI4Models/Axi4SlaveGen_Wr.v"
	// `include "../component/Actel/DirectCore/CoreAXI4Interconnect_w/2.1.3/sim/AXI4Models/Axi4SlaveGen_WrResp.v"
// `else
	//`include "./Axi4SlaveGen_Wr.v"
	//`include "./Axi4SlaveGen_WrResp.v"
// `endif

// ********************************************************************
//  Microsemi Corporation Proprietary and Confidential
//  Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: This module provides a AXI4 Slave Write Channel test
//              source. It stores the write cycle into local memory. It
//              assume write is of INCR type.
//
// Revision Information:
// Date     Description:
// Feb17    Revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************
`timescale 1ns / 1ns

//=================================================================================================
// Local Declarationes
//=================================================================================================
 
 
	localparam	RESPFIF_WIDTH = ( ID_WIDTH + 2 );			// ID, Resp

	
	reg							d_SLAVE_AWREADY, preSLAVE_AWREADY;

	wire [READFIF_WIDTH-1:0]	wrFifRdData;	
	reg [READFIF_WIDTH-1:0]		wrFifWrData;	
	
	wire [RESPFIF_WIDTH-1:0]	respFifRdData;	
	wire [RESPFIF_WIDTH-1:0]	respFifWrData;	

	reg							wrFifWr, wrFifRd;
	reg							respFifWr, respFifRd;
	
	wire						wrFifoFull, wrFifoEmpty;	
	wire						respFifoFull, respFifoEmpty;	
	
	wire						wrFifoOverRunErr, wrFifoUnderRunErr;
	wire						respFifoOverRunErr, respFifoUnderRunErr;

	
	reg [0:0]					awcurrState, awnextState;
	
	reg [15:0]					awCount, d_awCount;
	
	localparam	[0:0]			awstIDLE = 1'h0,	awstDATA = 1'h1;


	reg [1:0]					wcurrState, wnextState;
	
	localparam	[1:0]			wstIDLE = 1'h0,	wstDATA = 1'h1, wstIDLE_DATA = 2'h2;

	reg [1:0]					d_idleWrCycles, idleWrCycles;					// holds number of idle cycles per RdData Cycle

	reg [1:0]					idleWrCount;
	reg 						idleWrCountClr, idleWrCountIncr;
	
//======================================================================================================
// Local Declarationes for Slave Write Data 
//======================================================================================================
 
reg						d_SLAVE_WREADY;

reg [1:0]				wrBurstType, d_wrBurstType; 
reg [2:0]				wrWSize, d_wrWSize; 

reg	[8:0]				txLen, d_txLen, wburstLen, d_wburstLen;

reg	[ID_WIDTH-1:0]		respWID, d_respWID;
reg [1:0]				respResp;
 
reg [15:0]				txCount, d_txCount;	

//=============================================================================================
// Display messages only in Simulation - not synthesis
//=============================================================================================
`ifdef SIM_MODE	

	//=============================================================================================
	// Display messages for Write Address Channel
	//=============================================================================================
	always @( posedge sysClk )
		begin
			#1;
	
			if ( SLAVE_AWVALID ) 
				begin
					#1 $display( "%d, SLAVE  %d - Starting Write Address Transaction %d, AWADDR= %h,AWBURST= %h, AWSIZE= %h, WID= %h, AWLEN= %d", 
							$time, SLAVE_NUM, awCount, SLAVE_AWADDR, SLAVE_AWBURST, SLAVE_AWSIZE, SLAVE_AWID, SLAVE_AWLEN );

					if ( SLAVE_AWREADY )		// single beat
						begin
							#1 $display( "%d, SLAVE  %d - Ending Write Address Transaction %d, WID= %h, AWLEN= %d", 
									$time, SLAVE_NUM, awCount, SLAVE_AWID, SLAVE_AWLEN );
						end
					else
						begin
							@( posedge SLAVE_AWREADY )
								#1 $display( "%d, SLAVE  %d - Ending Write Address Transaction %d, WID= %h, AWLEN= %d", 
									$time, SLAVE_NUM, awCount, SLAVE_AWID, SLAVE_AWLEN );
						end
				end
		end	

	//=============================================================================================
	// Display messages for Write Data Channel
	//=============================================================================================
	always @( posedge sysClk )
		begin
			#1;
	
			if ( SLAVE_WVALID & ( wcurrState != wstIDLE ) )
				begin
					#1 $display( "%d, SLAVE  %d - Starting Write Data Transaction %d, WADDR= %h (%d), WID= %h, TXLEN= %d", 
							$time, SLAVE_NUM, txCount, memWrAddr, memWrAddr, respWID, wburstLen );

					if ( SLAVE_WLAST & SLAVE_WVALID & SLAVE_WREADY )		// single beat
						begin
							#1 $display( "%d, SLAVE  %d - Ending Write Data Transaction %d, WID= %h, TXLEN= %d", 
									$time, SLAVE_NUM, txCount, respWID, txLen );
						end
					else
						begin
							@( posedge ( SLAVE_WLAST & SLAVE_WVALID & SLAVE_WREADY ) )
								#1 $display( "%d, SLAVE  %d - Ending Write Data Transaction %d, WID= %h, TXLEN= %d", 
										$time, SLAVE_NUM, txCount, respWID, txLen );
						end
				end
		end

		
	//=============================================================================================
	// Display messages for checking size of burst at end of Write Data Channel
	//=============================================================================================
	always @( negedge sysClk )
		begin
			
			if ( SLAVE_WVALID & SLAVE_WREADY & SLAVE_WLAST )		// wait until end of burst
				begin
					if ( wburstLen != txLen )
						begin
							$display( "%d, AXISLAVEGEN %d WLAST Error, expBurstLen= %d, actBurstLen= %d \n\n", 
											$time, SLAVE_NUM, wburstLen, txLen );
									
							#1 $stop;
						end		
				end
		end

`ifdef VERBOSE
	//=============================================================================================
	// Display WDAT - data begin written into RAM
	//=============================================================================================
	always @( negedge sysClk )
		begin	
			if ( SLAVE_WVALID & SLAVE_WREADY )		
				begin
					$display( "%t, %m, memWrAddr=%h (%d), SLAVE_WDATA= %d, SLAVE_WSTRB= %h", $time, memWrAddr, memWrAddr, SLAVE_WDATA, SLAVE_WSTRB );
				end
		end		
`endif

		
`endif
	
	
//===========================================================================================
 // FIFO to hold open transactions - pushed on Write Address cycle and popped on Write data
 // cycle.
 //===========================================================================================
 caxi4interconnect_FifoDualPort #(	.FIFO_AWIDTH( OPENTRANS_MAX ),
					.FIFO_WIDTH( READFIF_WIDTH ),
					.HI_FREQ( HI_FREQ ),
					.NEAR_FULL( 'd2 )
				)
		wrFif(
					.HCLK(	sysClk ),
					.fifo_reset( sysReset ),
					
					// Write Port
					.fifoWrite( wrFifWr ),
					.fifoWrData( wrFifWrData ),

					// Read Port
					.fifoRead( wrFifRd ),
					.fifoRdData( wrFifRdData ),
					
					// Status bits
					.fifoEmpty ( wrFifoEmpty ) ,
					.fifoOneAvail( ),
					.fifoRdValid(  ),
					.fifoFull(  ),
					.fifoNearFull( wrFifoFull ),
					.fifoOverRunErr( wrFifoOverRunErr ),
					.fifoUnderRunErr( wrFifoUnderRunErr )
				   
				);

				
caxi4interconnect_FifoDualPort #(		.FIFO_AWIDTH( OPENTRANS_MAX ),
					.FIFO_WIDTH( RESPFIF_WIDTH ),
					.HI_FREQ( HI_FREQ ),
					.NEAR_FULL ( 'd2 )
				)
		rspFif(
					.HCLK(	sysClk ),
					.fifo_reset( sysReset ),
					
					// Write Port
					.fifoWrite( respFifWr ),
					.fifoWrData( respFifWrData ),

					// Read Port
					.fifoRead( respFifRd ),
					.fifoRdData( respFifRdData ),
					
					// Status bits
					.fifoEmpty ( respFifoEmpty ) ,
					.fifoOneAvail( ),
					.fifoRdValid ( ),
					.fifoFull( respFifoFull ),
					.fifoNearFull( ),
					.fifoOverRunErr( respFifoOverRunErr ),
					.fifoUnderRunErr( respFifoUnderRunErr )
				   
				);
   
   
//====================================================================================================
// Slave Write Address S/M
//===================================================================================================== 
 always @( * )
 begin
 
	awnextState <= awcurrState;
	
	d_SLAVE_AWREADY	<=  (waddr_rand_sig > 50);
	wrFifWr		<= 0;

	wrFifWrData <= { SLAVE_AWID, SLAVE_AWADDR, SLAVE_AWLEN, SLAVE_AWSIZE, SLAVE_AWBURST };
	
	d_awCount	<= awCount;
	
	case( awcurrState )
		awstIDLE: begin
					d_SLAVE_AWREADY <= (waddr_rand_sig > 50);
		
					if ( SLAVE_AWVALID & SLAVE_AWREADY )		// if both ends ready for transaction
						begin
							wrFifWrData <= { SLAVE_AWID, SLAVE_AWADDR, SLAVE_AWLEN, SLAVE_AWSIZE, SLAVE_AWBURST };
							wrFifWr	<= 1;
							d_awCount	<= awCount + 1'b1;

							awnextState	<= awstIDLE;
						end
					else if ( SLAVE_AWVALID & !SLAVE_AWREADY )
						begin
							awnextState	<= awstDATA;
						end
				end
		awstDATA : begin
					d_SLAVE_AWREADY <= 1'b1;

					if ( SLAVE_AWVALID & SLAVE_AWREADY )		// 	last beat
						begin
							d_SLAVE_AWREADY	<= (waddr_rand_sig > 50);
							
							wrFifWrData <= { SLAVE_AWID, SLAVE_AWADDR, SLAVE_AWLEN, SLAVE_AWSIZE, SLAVE_AWBURST };
							wrFifWr	  	<= 1;
							d_awCount	<= awCount + 1'b1;
	
							awnextState	<= awstIDLE;

						end
				end
	endcase
end


 always @(posedge sysClk or negedge sysReset)		
 begin
	if (!sysReset)
		begin
			awcurrState 		<= awstIDLE;
			preSLAVE_AWREADY	<= 0;
			awCount				<= 0;

		end
	else
		begin
			awcurrState 		<= awnextState;
			preSLAVE_AWREADY	<= d_SLAVE_AWREADY;
			awCount				<= d_awCount;
			
		end
end


assign SLAVE_AWREADY = preSLAVE_AWREADY & !wrFifoFull & (waddr_rand_sig == 98);

assign 	respFifWrData = { respWID, respResp };

//====================================================================================================
// Counter for Idle on each Write Data
//====================================================================================================
always @(posedge sysClk or negedge sysReset )
begin
	if ( !sysReset )
		begin
			idleWrCount	<= 0;		// initialise to 1
		end
	else if ( idleWrCountClr )
		begin
			idleWrCount	<= 0;		// initiales to 1
		end
	else if ( idleWrCountIncr )
		begin
			idleWrCount	<= idleWrCount + 1'b1;
		end
end


//=================================================================================================
// Create mask to "align" memWrAddr
//=================================================================================================
always @( * )
	begin
		case( wrWSize )
			3'h0 : memWrAddrAlignedMask <=   { (LOWER_COMPARE_BIT+ALIGNED_BITS  ){1'b1} };
			3'h1 : memWrAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-1){1'b1} }, 1'b0 };
			3'h2 : memWrAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-2){1'b1} }, 2'b0 };
			3'h3 : memWrAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-3){1'b1} }, 3'b0 };
			3'h4 : memWrAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-4){1'b1} }, 4'b0 };
			3'h5 : memWrAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-5){1'b1} }, 5'b0 };
			3'h6 : memWrAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-6){1'b1} }, 6'b0 };
			3'h7 : memWrAddrAlignedMask <= { { (LOWER_COMPARE_BIT+ALIGNED_BITS-7){1'b1} }, 7'b0 };
		endcase
	end
 //====================================================================================================
 // Slave Write Data S/M
//===================================================================================================== 
 always @( * )
 begin
 
	wnextState 		<= wcurrState;

	memWrData <= SLAVE_WDATA;
	memWr	  <= 0;
	
	d_SLAVE_WREADY	<= 0;

	wrFifRd	  	<= 0;			
	respFifWr	<= 0;

	d_respWID	<= respWID;
	d_wburstLen	<= wburstLen;
	d_memWrAddr	<= memWrAddr;
	d_txLen		<= txLen;
	d_wrBurstType <= wrBurstType;
	d_wrWSize	  <= wrWSize;
	
	d_idleWrCycles <= idleWrCycles;
	
	d_txCount	<= txCount;
	
	respResp	<= FORCE_ERROR 	? 2'b10  : 2'b00;
	
	idleWrCountClr	<= 1'b0;
	idleWrCountIncr	<= 1'b0;

	case( wcurrState )
		wstIDLE: begin
					
					d_txLen <= 0;
					
					d_wburstLen	<= 0;
					d_wrWSize	<= 0;
					d_respWID	<= 0;

					//READFIF_WIDTH = ( ID_WIDTH + ADDR_WIDTH + 8 + 3 + 2 );			// ID, Addr, LEN and SIZE, and Burst 
					d_memWrAddr	<= 0;

					
					if ( ~wrFifoEmpty )
						begin
							d_SLAVE_WREADY	<= 1'b1;
	
							d_wrBurstType <= wrFifRdData[1:0];
							d_wrWSize	  <= wrFifRdData[4:2 ]; 	// pickout AWSIZE

							d_wburstLen	<= wrFifRdData[READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-8 ]; // pickout AWLEN
							d_respWID	<= wrFifRdData[READFIF_WIDTH-1: READFIF_WIDTH- ID_WIDTH];

							//localparam	READFIF_WIDTH = ( ID_WIDTH + ADDR_WIDTH + 8 + 3 + 2 );			// ID, Addr, LEN and SIZE, and Burst 
							d_memWrAddr	<= wrFifRdData[READFIF_WIDTH- ID_WIDTH-1: READFIF_WIDTH-ID_WIDTH - ADDR_WIDTH];  // pick out write start address

							wrFifRd <= 1;		// pop entry
															
							wnextState 	<= wstDATA;
						end
				end
						
		wstDATA : begin
					d_SLAVE_WREADY	<= 1'b1;
					
					idleWrCountClr 	<= 1'b1;
				
					if ( SLAVE_WVALID & SLAVE_WREADY )		// wait until address available for start
						begin
							memWr	  <= 1'b1; //&SLAVE_WSTRB;		// Hack - assumes all bytes have to be written on bus.

							case( wrBurstType )
								2'b00:		// fixed
									begin
										d_memWrAddr	<= memWrAddr;
									end
								2'b01:		// increment
									begin
										d_memWrAddr <= ( memWrAddr & memWrAddrAlignedMask) + ( 1 << wrWSize );
																				// increment by number of bytes transferred
									end
								2'b10:		// wrap - not handling wrap correctly
									begin
										d_memWrAddr <= ( memWrAddr & memWrAddrAlignedMask) + ( 1 << wrWSize );
																				// increment by number of bytes transferred
									end
								2'b11:
									begin
										$stop;		/// should not get here
									end								
							endcase
								
							if ( SLAVE_WLAST )			// 1-beat
								begin													
									d_txCount		<= txCount + 1'b1;
									d_txLen			<= 0;
									
									respFifWr		<= 1'b1;
									
									if ( ~wrFifoEmpty & ~SLAVE_DATA_IDLE_EN)		// another data available - and not IDLE_EN on
										begin
											d_wrBurstType <= wrFifRdData[1:0];
											d_wrWSize	  <= wrFifRdData[4:2 ]; 	// pickout AWSIZE

											d_wburstLen	<= wrFifRdData[READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH-ID_WIDTH-ADDR_WIDTH-8 ]; // pickout ARLEN
											d_respWID	<= wrFifRdData[READFIF_WIDTH-1: READFIF_WIDTH- ID_WIDTH];	
											//localparam	READFIF_WIDTH = ( ID_WIDTH + ADDR_WIDTH + 8 + 3 + 2 );			// ID, Addr, LEN and SIZE, and Burst 
											d_memWrAddr	<= wrFifRdData[READFIF_WIDTH- ID_WIDTH-1: READFIF_WIDTH-ID_WIDTH - ADDR_WIDTH];  // pick out write start address
											wrFifRd <= 1;		// pop entry
											
											d_SLAVE_WREADY	<= 1'b1;									
											wnextState 		<= wstDATA;
										end
									else
										begin
											d_SLAVE_WREADY	<= 1'b0;									
											wnextState 		<= wstIDLE;
										end
								end
							else
								begin
									d_txLen		<= txLen + 1'b1;
									
									//============================================================================
									// see if idle cycles to be inserted
									//============================================================================
									if ( SLAVE_DATA_IDLE_EN )
										begin
											d_SLAVE_WREADY	<= 1'b0;

											case (SLAVE_DATA_IDLE_CYCLES)
												2'b00:		// random cycles
													begin
														`ifdef SIM_MODE		// only use random when in simulation
															d_idleWrCycles <= $random(); 
														`else
															d_idleWrCycles <= 0; 
														`endif
													end
												2'b01:		// 1 idle cycle
													begin
														d_idleWrCycles <= 4'd1; 
													end
												2'b10:		// 2 idle cycle
													begin
														d_idleWrCycles <= 4'd2; 
													end
												2'b11:		// 3 idle cycle
													begin
														d_idleWrCycles <= 4'd3; 
													end
											endcase
							
											wnextState 		<= wstIDLE_DATA;
										end
									else
										begin
											d_idleWrCycles <= 0;
											wnextState 	<= wstDATA;
										end
								end
						end
				end
		wstIDLE_DATA : begin

					d_SLAVE_WREADY	<= 1'b0;
		
					if ( idleWrCount == idleWrCycles )		// if had all idle cycles
						begin
							d_SLAVE_WREADY	<= 1'b1;

							wnextState 		<= wstDATA;
						end
					else
						begin
							idleWrCountIncr	<= 1'b1;
							
							wnextState 		<= wstIDLE_DATA;
						end
				end			
	endcase
end


 always @(posedge sysClk or negedge sysReset)
 begin
 
	if (!sysReset)
		begin
			txLen 			<= 0;
			memWrAddr		<= 0;
			
			respWID			<= 0;
			wburstLen		<= 0;
			SLAVE_WREADY	<= 0;
			txCount			<= 0;
			wrBurstType 	<= 0;
			wrWSize			<= 0;
			
			idleWrCycles	<= 0;

			wcurrState	<= wstIDLE;
		end
	else
		begin
			txLen 			<= d_txLen;
			memWrAddr		<= d_memWrAddr;
		
			respWID			<= d_respWID;
			wburstLen		<= d_wburstLen;
			SLAVE_WREADY	<= d_SLAVE_WREADY & !respFifoFull;
			
			txCount		<= d_txCount;
			wrBurstType <= d_wrBurstType;
			wrWSize		<= d_wrWSize;

			idleWrCycles <= d_idleWrCycles;
		
			wcurrState	<= wnextState;
		end
end

// ********************************************************************
//  Microsemi Corporation Proprietary and Confidential
//  Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: This module provides a AXI4 Slave test source.
//
// Revision Information:
// Date     Description:
// Feb17    Revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************
`timescale 1ns / 1ns

reg [15:0]	respCount, d_respCount;


//=============================================================================================
// Display messages only in Simulation - not synthesis
//=============================================================================================
`ifdef SIM_MODE

	//=============================================================================================
	// Display messages for Write Response Channel
	//=============================================================================================
	always @( posedge sysClk )
		begin
			#1;
	
			if ( SLAVE_BVALID )
				begin
					#1 $display( "%d, SLAVE  %d - Starting Write Response Transaction %d, BID= %h, BRESP= %h", 
							$time, SLAVE_NUM, respCount, SLAVE_BID, SLAVE_BRESP );

					if ( SLAVE_BREADY & SLAVE_BVALID )		// single beat
						begin
							#1 $display( "%d, SLAVE  %d - Ending Write Response Transaction %d, BID= %h", 
									$time, SLAVE_NUM, respCount, SLAVE_BID );
						end
					else
						begin
							@( posedge ( SLAVE_BREADY & SLAVE_BVALID)  )
								#1 $display( "%d, SLAVE  %d - Ending Write Response Transaction %d, BID= %h", 
									$time, SLAVE_NUM, respCount, SLAVE_BID );
						end
				end
		end

`endif



//=================================================================================================
// Local Declarationes for Slave Write Response Channel 
//=================================================================================================
 
reg [ID_WIDTH-1:0] 			d_SLAVE_BID;
reg [1:0]                   d_SLAVE_BRESP;
reg [USER_WIDTH-1:0]        d_SLAVE_BUSER;
reg                         d_SLAVE_BVALID;

reg [0:0]					bcurrState, bnextState;

localparam	[0:0]			bstIDLE = 1'h0,	bstDATA = 1'h1;


 //====================================================================================================
 // Slave Read Data S/M
//===================================================================================================== 
 always @( * )
 begin
 
	bnextState <= bcurrState;
	
	d_SLAVE_BID		<= SLAVE_BID;
	d_SLAVE_BRESP	<= SLAVE_BRESP;
	d_SLAVE_BUSER	<= 0;
	d_SLAVE_BVALID	<= 0;

	respFifRd	  	<= 0;

	d_respCount		<= respCount;

	case( bcurrState )
		bstIDLE: begin
					
					if ( ~respFifoEmpty )		// data to read
						begin
							//RESPFIF_WIDTH = ( ID_WIDTH + 2 );			// ID, Resp

							d_SLAVE_BID		<= respFifRdData[RESPFIF_WIDTH-1: RESPFIF_WIDTH-ID_WIDTH];
							d_SLAVE_BRESP	<= respFifRdData[RESPFIF_WIDTH-ID_WIDTH-1: 0];

							respFifRd		<= 1;		// pop fifo 

							bnextState 		<= bstDATA;
						end
				end
		rstDATA : begin
					d_SLAVE_BVALID	<= 1'b1;

					if ( SLAVE_BREADY & SLAVE_BVALID )
						begin
						
							d_respCount		<= respCount + 1'b1;

							if ( ~respFifoEmpty )				// if another burst request - start on next clock
								begin
									d_SLAVE_BVALID	<= 1'b1;
									d_SLAVE_BID		<= respFifRdData[RESPFIF_WIDTH-1: RESPFIF_WIDTH-ID_WIDTH];
									d_SLAVE_BRESP	<= respFifRdData[RESPFIF_WIDTH-ID_WIDTH-1: 0];
								
									respFifRd	<= 1;		// pop fifo 
									bnextState 	<= bstDATA;
								end
							else
								begin
									d_SLAVE_BVALID	<= 1'b0;
									d_SLAVE_BID		<= 0;
									d_SLAVE_BRESP	<= 0;
									
									bnextState <= bstIDLE;
								end
						end
					else			// not ready
						begin
									
						end
				end
	endcase
end


 always @(posedge sysClk or negedge sysReset)
 begin
 
	if (!sysReset)
		begin
			SLAVE_BID		<= 0;
			SLAVE_BRESP		<= 0;
			SLAVE_BUSER		<= 0;
			SLAVE_BVALID	<= 0;
			respCount		<= 0;
			
			bcurrState	<= bstIDLE;
		end
	else
		begin
			SLAVE_BID		<= d_SLAVE_BID;
			SLAVE_BRESP		<= d_SLAVE_BRESP;
			SLAVE_BUSER		<= d_SLAVE_BUSER;
			SLAVE_BVALID	<= d_SLAVE_BVALID;	
			respCount		<= d_respCount;
			
			bcurrState	<= bnextState;
		end
end


 // Axi4SlaveGen_RespWr.v

		
endmodule // Axi4SlaveGen.v
