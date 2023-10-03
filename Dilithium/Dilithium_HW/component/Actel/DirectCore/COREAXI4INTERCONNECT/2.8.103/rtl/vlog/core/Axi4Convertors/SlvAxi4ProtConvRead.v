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
//     Abstract  : This file provides an Slave Protocol Converter for AXI3 or AXILite slave read channels.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

`timescale 1ns/1ns

module caxi4interconnect_SlvAxi4ProtConvRead #

	(
		parameter integer 	SLAVE_NUMBER		= 0,			//current slave
		parameter [1:0] 	SLAVE_TYPE			= 2'b11,		// Protocol type = AXI4 - 2'b00, AXI4Lite - 2'b01, AXI3 - 2'b11	
		
		parameter integer 	ADDR_WIDTH      	= 20,			// valid values - 16 - 64
		parameter integer 	DATA_WIDTH 			= 32,			// valid widths - 32, 64, 128, 256

		parameter integer 	USER_WIDTH 			= 1,			// defines the number of bits for USER signals RUSER and WUSER
		parameter integer 	ID_WIDTH   			= 1,				// number of bits for ID (ie AID, WID, BID) - valid 1-8 
		parameter integer 	SLV_AXI4PRT_ADDRDEPTH 		= 8,		// Number transations width - 1 => 2 transations, 2 => 4 transations, etc.
		parameter integer 	SLV_AXI4PRT_DATADEPTH		= 8,		// Number transations width - 1 => 2 transations, 2 => 4 transations, etc.
		parameter           READ_INTERLEAVE             = 1
	)
	(

	//=====================================  Global Signals   ========================================================================
	input  wire           			ACLK,
	input  wire          			sysReset,

	//Slave Read Address Ports
	output wire [ID_WIDTH-1:0]  	SLAVE_ARID,
	output wire [ADDR_WIDTH-1:0]	SLAVE_ARADDR,
	output reg [7:0]    	       	SLAVE_ARLEN,
	output wire [2:0]        		SLAVE_ARSIZE,
	output wire [1:0]           	SLAVE_ARBURST,
	output wire [1:0]         		SLAVE_ARLOCK,
	output wire [2:0]         		SLAVE_ARPROT,
	output wire [3:0]	          	SLAVE_ARCACHE,
	output reg            			SLAVE_ARVALID,
	input wire             			SLAVE_ARREADY,


	// Slave Read Data Ports
	input wire [ID_WIDTH-1:0]  		SLAVE_RID,	
	input wire [DATA_WIDTH-1:0]		SLAVE_RDATA,
	input wire [1:0]           		SLAVE_RRESP,
	input wire                  	SLAVE_RLAST,
	input wire                 		SLAVE_RVALID,
	output reg               		SLAVE_RREADY,


	//============================= Internal AXI4 (XBar) Side Ports  ================================================//

	// MASTER Read Address Ports	
	input  wire [ID_WIDTH-1:0]  	int_slaveARID,
	input  wire [ADDR_WIDTH-1:0]	int_slaveARADDR,
	input  wire [7:0]           	int_slaveARLEN,
	input  wire [2:0]        		int_slaveARSIZE,
	input  wire [1:0]           	int_slaveARBURST,
	input  wire [1:0]         		int_slaveARLOCK,
	input  wire [3:0]          		int_slaveARCACHE,
	input  wire [2:0]         		int_slaveARPROT,
	input  wire [3:0]          		int_slaveARREGION,
	input  wire [3:0]          		int_slaveARQOS,
	input  wire [USER_WIDTH-1:0]	int_slaveARUSER,
	input  wire                		int_slaveARVALID,
	output reg                		int_slaveARREADY,
	
	// MASTER Read Data Ports	
	output wire [ID_WIDTH-1:0]  	int_slaveRID,

	output wire [DATA_WIDTH-1:0]  	int_slaveRDATA,
	output wire [1:0]           	int_slaveRRESP,
	output reg                  	int_slaveRLAST,
	output wire [USER_WIDTH-1:0] 	int_slaveRUSER,
	output reg               		int_slaveRVALID,
	input wire                 		int_slaveRREADY
	
	);
	
	//================================== Local parameters ==============================

	localparam	ARLEN_BITS	= ( SLAVE_TYPE == 2'b11 ) ? 4 : 8;			// AXI3 bursts brokwn into 16 beats or less, AXILite into single beat
	localparam	MAX_BEATS	= ( SLAVE_TYPE == 2'b11 ) ? 'd16 : 'd1;		// AXI3 max bursts beats 16, AXILite is 1	

	//================================== Internal =======================================
	
	//Read number of reads to combine caxi4interconnect_FIFO
	reg 					rdFifoIdRd;
	reg 					rdFifoIdWr;
	wire 					rdFifoIdFull;
	wire 					rdFifoIdEmpty;
	wire [(ID_WIDTH + 8)-1:0] rdFifoIdDIn; 		//hold only number of reads
	wire [(ID_WIDTH + 8)-1:0] rdFifoIdDOut;		//hold only number of reads
	
	//Read Data+last caxi4interconnect_FIFO
	reg 					rdFifoDataRd;
	reg 					rdFifoDataWr;
	wire 					rdFifoDataFull;
	wire 					rdFifoDataEmpty;
	
	wire [(DATA_WIDTH+ID_WIDTH+2)-1:0] 	rdFifoDataIn;		// no need to add RLAST bit 
	wire [(DATA_WIDTH+ID_WIDTH+2)-1:0] 	rdFifoDataOut;		// no need to add RLAST bit


	//==========================================================================
	// Store Read Len information to allow "combination" of read bursts
	//==========================================================================
	
	caxi4interconnect_FifoDualPort #(		.FIFO_AWIDTH( SLV_AXI4PRT_ADDRDEPTH ),
						.FIFO_WIDTH	( ID_WIDTH + 8 ),
						.HI_FREQ	( 1'b0 	)						
					)
		rdIdFif(
					.HCLK(	ACLK ),
					.fifo_reset( sysReset ),
					
					// Write Port
					.fifoWrite( rdFifoIdWr ),
					.fifoWrData( rdFifoIdDIn ),

					// Read Port
					.fifoRead( rdFifoIdRd ),
					.fifoRdData( rdFifoIdDOut ),
					
					// Status bits
					.fifoEmpty ( rdFifoIdEmpty ) ,
					.fifoOneAvail( ),
					.fifoRdValid ( ),
					.fifoFull( rdFifoIdFull ),
					.fifoNearFull( ),
					.fifoOverRunErr(  ),
					.fifoUnderRunErr(  )
				   
				);
				
				
	//==========================================================================
	// Store Read Data to allow "combination" of read bursts
	//==========================================================================		
	caxi4interconnect_FifoDualPort #(	.FIFO_AWIDTH( SLV_AXI4PRT_DATADEPTH ),
					.FIFO_WIDTH	( DATA_WIDTH + ID_WIDTH + 2	),		// store RDATA, RID and RRESP
					.HI_FREQ 	( 1'b0 			)
				)
		rdDataFif(
					.HCLK(	ACLK ),
					.fifo_reset( sysReset ),
					
					// Write Port
					.fifoWrite( rdFifoDataWr ),
					.fifoWrData( rdFifoDataIn ),

					// Read Port
					.fifoRead( rdFifoDataRd ),
					.fifoRdData( rdFifoDataOut ),
					
					// Status bits
					.fifoEmpty ( rdFifoDataEmpty ) ,
					.fifoOneAvail( ),
					.fifoRdValid ( ),
					.fifoFull( rdFifoDataFull ),
					.fifoNearFull( ),
					.fifoOverRunErr(  ),
					.fifoUnderRunErr(  )
				   
				);

	
	//========================== Address Read registers =======================
	
	reg [ID_WIDTH-1:0]      latARID;
	reg [2:0]   			latARSIZE;
	reg [1:0] 				latARBURST;
	reg [1:0] 				latARLOCK;
	reg [3:0] 				latARCACHE;
	reg [2:0]				latARPROT;
	reg [3:0]				lastTransLenRd; 	// only used for AXI3 slaves
	
	reg						latchARAll;
	
	reg [ADDR_WIDTH-1:0]	newAddrRd; 			// Initial or Recalculated address which will be sent to Slave
	reg 					loadAddr;
	reg 					incrAddr;
	
	reg [ARLEN_BITS-1:0]	numTransRd;			// Times address has to be recalculated
	reg 					loadCount;
	reg 					decrCount;
	reg						clearCount;

	reg [1:0] 				IdleAddrRead = 2'b00, ReadAddr = 2'b01, WaitFifoEmpty = 2'b10;
	reg [1:0]				currStateARd, nextStateARd;
	
	//Read Data Channel Get data from slave States
	reg [0:0]				RGetData = 1'b0;
	reg [0:0]				currStateRdGD, nextStateRdGD;

	// andreag: signals for correct WRAP burst address computation
	wire [10:0] wrap_nibble;
	wire [10:0] wrap_mask;


	//==========================================================================================
	// Drive out latched information from Read Address Cycle
	//===========================================================================================
	assign SLAVE_ARID 		= READ_INTERLEAVE ? (SLAVE_TYPE == 2'b01) ? 'h0 : latARID : 'h0;
	assign SLAVE_ARSIZE 	= (SLAVE_TYPE == 2'b01) ? $clog2(DATA_WIDTH/8) : latARSIZE;
	assign SLAVE_ARBURST 	= latARBURST;
	assign SLAVE_ARLOCK 	= latARLOCK;
	assign SLAVE_ARCACHE 	= latARCACHE ;
	assign SLAVE_ARPROT 	= latARPROT;
	assign SLAVE_ARADDR 	= newAddrRd;
	
	assign rdFifoIdDIn 		= {int_slaveARID, int_slaveARLEN[7:0]};			// data to be stored in rdIdFif
    
	//=================================================================================
	// Read Transaction counter for address recalculation
	//=================================================================================
	always @(posedge ACLK or negedge sysReset )
		begin
			if ( !sysReset )
				begin
					numTransRd <= 0;
				end
			else if ( clearCount )
				begin
					numTransRd <= 0;
				end		
			else if (loadCount)
				begin
					numTransRd <= int_slaveARLEN[7:8-ARLEN_BITS];
				end
			else if (decrCount)
				begin
					numTransRd <= numTransRd - 1'b1;
				end

		end

	assign wrap_nibble = 11'h00f << latARSIZE;
	assign wrap_mask = (lastTransLenRd << latARSIZE);
	
	//=================================================================================	
	// Read Address recalculation	
	//=================================================================================
	always @(posedge ACLK or negedge sysReset )
		begin
			if ( !sysReset )
				begin
					newAddrRd <= 0;
				end
			else if (loadAddr)
				begin
					newAddrRd <= int_slaveARADDR;
				end
			else if (incrAddr)
				begin
					//=====================================================================		
					// Compute address based on Burst-type and address alginment
					// Fixed =00, Incr=01, Wrap =10 - Wrap not handled as not needed
					// for AXI3 and makes no sense for AXI4Lite (Caches not used here)
					//======================================================================			
					if ( latARBURST == 2'b00 )			// Fixed type burst
						begin
							newAddrRd	<= newAddrRd;		// all beats use the same address.
						end
					else if (( latARBURST == 2'b10 ) && (SLAVE_TYPE == 2'b01))
					begin
						if ((newAddrRd[10:0] & wrap_mask) == (wrap_mask & wrap_nibble)) begin
						        newAddrRd <= {newAddrRd[ADDR_WIDTH-1:11], (newAddrRd[10:0] & ~wrap_mask)};
					        end else begin
							newAddrRd <= newAddrRd + (1 << latARSIZE); // AXI4-Lite burst length is always 1
						end
					end
					else
						begin
							case (latARSIZE)
								3'd0	: newAddrRd <= newAddrRd + MAX_BEATS;
								3'd1	: newAddrRd <= { newAddrRd[ADDR_WIDTH-1:1] + MAX_BEATS, 1'd0 };
								3'd2	: newAddrRd <= { newAddrRd[ADDR_WIDTH-1:2] + MAX_BEATS, 2'd0 };
								3'd3	: newAddrRd <= { newAddrRd[ADDR_WIDTH-1:3] + MAX_BEATS, 3'd0 };
								3'd4	: newAddrRd <= { newAddrRd[ADDR_WIDTH-1:4] + MAX_BEATS, 4'd0 };
								3'd5	: newAddrRd <= { newAddrRd[ADDR_WIDTH-1:5] + MAX_BEATS, 5'd0 };
								3'd6	: newAddrRd <= { newAddrRd[ADDR_WIDTH-1:6] + MAX_BEATS, 6'd0 };
								3'd7	: newAddrRd <= { newAddrRd[ADDR_WIDTH-1:7] + MAX_BEATS, 7'd0 };
								default :
									newAddrRd <= { ADDR_WIDTH{ 1'bx} };
							endcase
						end				
				
					//newAddrRd <= newAddrRd + ( MAX_BEATS << latARSIZE );	// compute bytes sent in burst
				end
	end
	
	
	//=================================================================================	
	// latch all signals from channel for retransmission 	
	//=================================================================================
	always @(posedge ACLK or negedge sysReset )
		begin
			if ( !sysReset )
				begin
				    latARID     <= 0;
					latARSIZE 	<= 0;
					latARBURST 	<= 0;
					latARLOCK 	<= 0;
					latARCACHE 	<= 0;
					latARPROT 	<= 0;
					lastTransLenRd <= 0;
				end
			else if (latchARAll)
				begin
				    latARID     <= int_slaveARID;
					latARSIZE 	<= int_slaveARSIZE;
					latARBURST 	<= int_slaveARBURST;
					latARLOCK 	<= int_slaveARLOCK;
					latARCACHE 	<= int_slaveARCACHE;
					latARPROT 	<= int_slaveARPROT;
					lastTransLenRd <= int_slaveARLEN[3:0];	
				end
		end
	
	
	//=================================================================================	
	// Read address channel state machine
	//================================================================================= 
	always @(posedge ACLK or negedge sysReset)
		begin
			if ( !sysReset )
				begin
					currStateARd <= IdleAddrRead;
				end
			else
				begin
					currStateARd <= nextStateARd;
				end	
		end
 

	always @(*)
		begin
			clearCount 	<= 1'b0;
			loadCount  	<= 1'b0;
			decrCount 	<= 1'b0;
			loadAddr  	<= 1'b0;
			incrAddr 	<= 1'b0;
			int_slaveARREADY <= 1'b0;
			latchARAll 	<= 1'b0;
			rdFifoIdWr 	<= 1'b0;
			
			SLAVE_ARLEN	<= 0;
			SLAVE_ARVALID		<= 1'b0;
			int_slaveARREADY 	<= 1'b0;
		
			nextStateARd	<= currStateARd;
		
			case( currStateARd )
				IdleAddrRead:
					begin
						if (int_slaveARVALID)
							begin
								if (!rdFifoIdFull)
									begin
										int_slaveARREADY <= 1'b1;
										latchARAll	<= 1'b1; //latch all signals and hold for the duration of address recalculation and re-transfer
										loadCount 	<= 1'b1;								
										loadAddr 	<= 1'b1;
										rdFifoIdWr 	<= 1'b1;
										nextStateARd <= ReadAddr;
									end
							end
					end
				ReadAddr:
					begin
						if ( numTransRd == 0 ) //last burst
							begin
								SLAVE_ARLEN[3:0] <= lastTransLenRd; //last burst,so set LEN to be last transaction LEN - only used by AXI3 slave
								SLAVE_ARVALID <= 1'b1;
							
								if (SLAVE_ARREADY)
									begin
                                        clearCount <= 1'b1;
                                                nextStateARd <= IdleAddrRead;
									end
							end
						else //Not the last burst
							begin
								SLAVE_ARLEN[3:0] <= 4'b1111; // set LEN to be max (16) transfers supported by AXI3 protocol - AXILite slave does not use SLAVE_AWLEN
								SLAVE_ARVALID <= 1'b1;

								if (SLAVE_ARREADY)
									begin
										incrAddr	<= 1'b1;
										decrCount 	<= 1'b1;
									end
							end
					end
                default:
					begin
						clearCount 	<= 1'bx;
						loadCount  	<= 1'bx;
						decrCount 	<= 1'bx;
						loadAddr  	<= 1'bx;
						incrAddr 	<= 1'bx;
						int_slaveARREADY <= 1'bx;
						latchARAll 	<= 1'bx;
						rdFifoIdWr 	<= 1'bx;
				
						SLAVE_ARLEN	<= 8'bxxxx_xxxx;
						SLAVE_ARVALID		<= 1'bx;
						int_slaveARREADY 	<= 1'bx;					
						nextStateARd <= 2'bxx;	
					end
				
			endcase
		
	end
	
	
	//=================================================================================	
	// Data read channel (get data from slave)
	//=================================================================================
	assign rdFifoDataIn = { SLAVE_RDATA, SLAVE_RID, SLAVE_RRESP };

	//=================================================================================
	// Data read channel state machine (get data from slave)
	//=================================================================================
	always @(posedge ACLK or negedge sysReset )
		begin
	
			if ( !sysReset )
				begin
					currStateRdGD <= RGetData;
				end
			else
				begin
					currStateRdGD <= nextStateRdGD;
				end
			
		end

	
	always @(*)
		begin
			rdFifoDataWr <= 1'b0;
			SLAVE_RREADY <= 1'b0;
		
			nextStateRdGD	<= currStateRdGD;
		
			case( currStateRdGD )
				RGetData:
					begin
						if (SLAVE_RVALID)
							begin
								if (!rdFifoDataFull)
									begin
										rdFifoDataWr <= 1'b1;
										SLAVE_RREADY <= 1'b1;
									end
							end
					end
				default:
					begin
						rdFifoDataWr <= 1'bx;
						SLAVE_RREADY <= 1'bx;
					
						nextStateRdGD <= 1'bx;	
					end
				
			endcase
		
		end
	

	//========================== Read Data Channel Send data to master =======================
	// Read Data Channel Send data to master States
	//=========================================================================================
	reg [0:0]				Idle_SendDataRd = 1'b0,	SendDataRd = 1'b1;
	reg [0:0]				currStateRdSD, nextStateRdSD;
	
	//Read Data Channel Send data to master 
	reg [7:0]				numCombRd;				
	reg						resetNumCombRd;
	reg 					loadNumCombRd;
	reg 					decrNumCombRd;
	reg 					BAD_ERROR;
	
	//=========================================================================================

	assign int_slaveRDATA	= rdFifoDataOut[(DATA_WIDTH+ID_WIDTH+2)-1:ID_WIDTH+2];
	assign int_slaveRRESP 	= rdFifoDataOut[1:0];
	assign int_slaveRUSER 	= 0;
  assign int_slaveRID     = rdFifoIdDOut[(ID_WIDTH-1)+8:8];

	//================================================================================= 
	// Counter to calculate when to assert master side LAST signal
	//=================================================================================
	always @(posedge ACLK or negedge sysReset)
		begin
	
			if ( !sysReset )
				begin
					numCombRd <= 0;
				end
			else if ( loadNumCombRd )
				begin
					numCombRd <= rdFifoIdDOut[7:0];
				end
			else if ( decrNumCombRd )
				begin
					numCombRd <= numCombRd - 1'b1;
				end	     
        end

	//=================================================================================
	// Data read channel state machine (Send data to master)
	//=================================================================================
	always @(posedge ACLK or negedge sysReset)
		begin
			if ( !sysReset )
				begin
					currStateRdSD <= Idle_SendDataRd;
				end
			else
				begin
					currStateRdSD <= nextStateRdSD;
				end
			
		end
	
	
	always @(*)
		begin
	
			BAD_ERROR 		<= 1'b0;
			rdFifoIdRd 		<= 1'b0;
			rdFifoDataRd 	<= 1'b0;
			int_slaveRLAST 	<= 1'b0;
			int_slaveRVALID <= 1'b0;
			decrNumCombRd 	<= 0;
			loadNumCombRd 	<= 0;
			resetNumCombRd 	<= 0;
		
			nextStateRdSD	<= currStateRdSD;
		
			case( currStateRdSD )
				Idle_SendDataRd:
					begin
						if ( !rdFifoDataEmpty )
							begin
								if ( rdFifoIdEmpty )
									begin
										BAD_ERROR <= 1'b1;			// internal error condition - only used for debug
									end
								else
									begin
										loadNumCombRd <= 1'b1; 
							
										nextStateRdSD <= SendDataRd;
									end
							end
					end
				SendDataRd:
					begin
					
						//============================================================
						// Check data in caxi4interconnect_FIFO - if not wait for it
						//============================================================
						if ( !rdFifoDataEmpty )
							begin
								if ( numCombRd == 0 ) // last transaction in burst
									begin
										int_slaveRLAST <= 1'b1;
									end
						
								int_slaveRVALID <= 1'b1;

								if (int_slaveRREADY)
									begin
										rdFifoDataRd 	<= 1'b1;		// pop data from caxi4interconnect_FIFO

										if ( numCombRd == 0 ) 	//last transaction in burst
											begin
												resetNumCombRd  <= 1'b1;
												rdFifoIdRd 		<= 1'b1;
							
												nextStateRdSD 	<= Idle_SendDataRd;
											end
										else // not the last transaction in burst
											begin
												decrNumCombRd 	<= 1'b1;
												nextStateRdSD 	<= SendDataRd;
											end
									end
							end
						else		// wait for data to arrive from Slave
							begin
								nextStateRdSD 	<= SendDataRd;
							end
					end
				default:
					begin
						nextStateRdSD <= 1'bx;	
					
						BAD_ERROR 		<= 1'bx;
						rdFifoIdRd 		<= 1'bx;
						rdFifoDataRd 	<= 1'bx;
						int_slaveRLAST 	<= 1'bx;
						int_slaveRVALID <= 1'bx;
						decrNumCombRd 	<= 1'bx;
						loadNumCombRd 	<= 1'bx;
						resetNumCombRd 	<= 1'bx;					
					end
				
			endcase
		
		end
	
endmodule	// caxi4interconnect_SlvAxi4ProtocolConv.v
