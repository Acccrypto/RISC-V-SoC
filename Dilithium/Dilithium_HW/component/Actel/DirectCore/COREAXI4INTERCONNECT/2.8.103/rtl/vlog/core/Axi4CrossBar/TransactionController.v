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
//     Abstract  : This module "pushes" open transactions - counts open transactions and records SlaveID per
//                 thread which are open. It "pops" a transaction when it has completed as indicated by
//                 DataController.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_TransactionController (
								sysClk,
								sysReset,
								
								// DependancyCheck Port
								currTransSlaveID,
								currTransID,								// ID for current transaction								
								
								threadAvail,
								threadValid,
								threadCount,
								threadSlaveID,
	
								// caxi4interconnect_TargetMuxController
								openTransInc,
			
								// Components of transaction to pop from stack
								currDataTransID,
								openTransDec

						 );


//=================================================================================================
// Parameter Declarations
//=================================================================================================

	parameter NUM_SLAVES_WIDTH 		= 2;		// defines number of bits to encoode slave number

	parameter MASTERID_WIDTH		= 4;		// defines number of bits to in masterID - includes Infrastructure ID + requestor ID
	
	parameter NUM_THREADS			= 1;		// defined number of indpendent threads per master supported 
	parameter NUM_THREADS_WIDTH		= 1;		// defined number of bits to encode threads number
	
	parameter OPEN_TRANS_MAX		= 3;		// max number of outstanding transactions 
	parameter OPEN_TRANS_WIDTH		= 2;		// width of open transaction count 

	parameter  WR_MODULE            = 1;
	
	localparam THREAD_VEC_WIDTH		= ( MASTERID_WIDTH + NUM_SLAVES_WIDTH + OPEN_TRANS_WIDTH );	// defines width of per thread vector elements width
	
	localparam	[OPEN_TRANS_WIDTH-1:0]	COUNT_1 = 1;											

							
//================================================================================================
// I/O Declarations
//================================================================================================

	input								sysClk;
	input								sysReset;
	
	//========= Dependancy Checker  Port ======================//
	
	input	[NUM_SLAVES_WIDTH-1:0] 		currTransSlaveID;					// matched slaveID
	input	[MASTERID_WIDTH-1:0]		currTransID;						// ID for current transaction

	output								threadAvail;						// indicates a thread slot available for new threadID
	output								threadValid;						// indicates matched currTransID and threadCount and threadSlaveID valid
	output 	[OPEN_TRANS_WIDTH-1:0]		threadCount;
	output	[NUM_SLAVES_WIDTH-1:0]		threadSlaveID;
	

	//========= caxi4interconnect_TargetMuxController Port ======================//
	input								openTransInc;						// Increment openTransVec for thread matching currTransID

	//========= DataControl Port =============================//
	input	[MASTERID_WIDTH-1:0]		currDataTransID;					// current data transaction ID
	input								openTransDec;						// indicates thread matching currDataTransID to be decremented
	
	
//====================================================================================
// I/O Declarationes
//====================================================================================

	wire								sysClk;
	wire								sysReset;
	
	wire	[NUM_SLAVES_WIDTH-1:0] 		currTransSlaveID;					// matched slaveID
	wire	[MASTERID_WIDTH-1:0]		currTransID;						// ID for current transaction

	wire								threadAvail;						// indicates a thread slot available for new threadID
	reg									threadValid;						// indicates matched currTransID and threadCount and threadSlaveID valid
	reg 	[OPEN_TRANS_WIDTH-1:0]		threadCount;
	reg		[NUM_SLAVES_WIDTH-1:0]		threadSlaveID;
	
	wire								openTransInc;						// Increment openTransVec for thread matching currTransID

	wire	[MASTERID_WIDTH-1:0]		currDataTransID;					// current data transaction ID
	wire								openTransDec;						// indicates thread matching currDataTransID to be decremented
	
//====================================================================================
// Local Declarationes
//====================================================================================
	reg		[NUM_THREADS-1:0]		matchThread, matchDataThread;	
	reg		[NUM_THREADS-1:0]		outstndgTrans;	

	reg		[NUM_THREADS-1:0]		d_activeThreadMask, activeThreadMask;		// bit mask per thread - indicates thread is active
	wire 	[NUM_THREADS-1:0]		nextOpenThreadMask;							// bit mask per thread - bit set to one indicates next open thread

	reg		[MASTERID_WIDTH-1:0]		threadVecTransID [0:NUM_THREADS-1];				//  transID for individual openTransVec element

	reg 	[THREAD_VEC_WIDTH-1:0] 		d_openTransVec [0:NUM_THREADS-1];				// used to process a thread from the openTransVec array	
	reg		[THREAD_VEC_WIDTH-1:0] 		openTransVec [0:NUM_THREADS-1];					// open transaction vector - stores open transactions. Organised per thread
																						// as { tramsID, slaveID, openCount }	
												
	reg		[THREAD_VEC_WIDTH-1:0]		matchThreadTrans;
	wire	[NUM_THREADS_WIDTH-1:0]		matchThreadEnc;		

    reg 	[MASTERID_WIDTH-1:0]        currTransIDReg;
										
	//=====================================================================================
	// Generates a binary coded from onehotone encoded
	//====================================================================================
	function [3:0] fnc_hot2enc
		(
		input [15:0]  one_hot
		);
		begin
			fnc_hot2enc[0] = |(one_hot & 16'b1010_1010_1010_1010);
			fnc_hot2enc[1] = |(one_hot & 16'b1100_1100_1100_1100);
			fnc_hot2enc[2] = |(one_hot & 16'b1111_0000_1111_0000);
			fnc_hot2enc[3] = |(one_hot & 16'b1111_1111_0000_0000);
		end
	endfunction


	
	//============================================================================================
	// Find thread that matches currTransID and currDataTransID if any - results
	// in a bitmask where one bit should be set if find match (only expecting
	// one thread to match). Need to check thread is active as well.
	//=============================================================================================
	genvar i;
	generate
		for (i=0; i< NUM_THREADS; i=i+1 )
			begin
				always @( * )
				begin
				
					threadVecTransID[i]	<= openTransVec[i][ THREAD_VEC_WIDTH -1 : NUM_SLAVES_WIDTH+OPEN_TRANS_WIDTH ];

					if ( ( currTransID == threadVecTransID[i] ) &	activeThreadMask[i] )		// if current transaction ID matches this thread stored ID
						begin																	// and is active thread
							matchThread[i] = 1'b1;
						end
					else
						begin
							matchThread[i] = 1'b0;
						end
                    // if current data transaction ID matches this thread stored ID and outstnading transaction count is not zero.
					if ( (currDataTransID == threadVecTransID[i]) & ( | openTransVec[i][THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH-1 :0]))		
						begin
							matchDataThread[i] = 1'b1;
						end
					else
						begin
							matchDataThread[i] = 1'b0; 
						end
						
					outstndgTrans[i] = ( | openTransVec[i][THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH-1 :0]);
				end
			end
	endgenerate

	
assign matchThreadEnc = fnc_hot2enc(matchThread);		
 	
assign threadAvail = ( activeThreadMask != { NUM_THREADS{ 1'b1 } } );			// threadAvail if all activeThreadMask not all 1s


always@(posedge sysClk or negedge sysReset)
  if(~sysReset)
    currTransIDReg <= 0;
  else if(d_activeThreadMask == {NUM_THREADS{1'b1}} & threadAvail)
    currTransIDReg <= currTransID;
    
//====================================================================================
// Pick out count and slaveID from matched openTransVec
//====================================================================================
always @( * )
begin
	matchThreadTrans <= openTransVec[matchThreadEnc];
	//SAR 107729 - Less throughput and data corruption with different ID's 
	//When Master issues outstanding transaction to different slave, transactions to different slaves were passed and due to that
	//MASTER WVALID was passed to different slaves at the same time. 
	//To fix the issue, outstanding transactions to one slave needs to be passed and after finishing all the outstanding transactions
	//to that slave, outstanding transaction to other slave should be passed. threadValid signal is ANDed with currTransSlaveID which 
	//indicates slave selected for current transactions. threadValid logic change. Now it is asserted when out of NUM_THREADS any 
	//thread has outstanding transactions or if last THREAD is detected (using threadAvail) and SLAVE ID doesn't change. 
	

	threadValid 	<= ((outstndgTrans != 0) & ((currTransIDReg == currTransID) | threadAvail));
	 

	threadCount 	<= matchThreadTrans[THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH-1 :0];
	threadSlaveID	<= matchThreadTrans[THREAD_VEC_WIDTH-MASTERID_WIDTH-1 : OPEN_TRANS_WIDTH ];

end


//==========================================================================
// find next open thread - one with a 0 in its active bit mask
//==========================================================================
caxi4interconnect_BitScan0 # ( .WIDTH( NUM_THREADS ) )
		bs0 (
				.inMask(activeThreadMask),
				.outMask(nextOpenThreadMask)
			);
					

//==========================================================================
// Latch, increment and decrement trans threads
//==========================================================================
genvar j;
generate
for (j=0; j<NUM_THREADS;j=j+1)

always @(*)
begin
			
	d_activeThreadMask[j] 	<= activeThreadMask[j];	
	d_openTransVec[j]		<= openTransVec[j];	
	
	//=======================================================================================================================
	// Handle latching initial thread
	//=======================================================================================================================
	if (( matchThread == 0 ) & openTransInc)	// no matching thread and told to increment - store in next open thread
		begin										

			if ( nextOpenThreadMask[j] )
				begin
					d_openTransVec[j]		<= { currTransID, currTransSlaveID, COUNT_1 };
					d_activeThreadMask[j]	<= 1'b1;					// set bit to indicate thread now active
				end
				
			// If decrement - handle for mnatched data thread
			
			if ( openTransDec )
				begin
					if ( matchDataThread[j] )
						begin
							d_openTransVec[j]	<= 	{ 	openTransVec[j][THREAD_VEC_WIDTH-1: THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH ],
															{ openTransVec[j][THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH-1 :0] - 1'b1 }	
													};

							// If last active transaction - clear activeThreadMask bit as free
							if ( { openTransVec[j][THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH-1 :0] - 1'b1 }	== 0 )	
								begin
									d_activeThreadMask[j]	<= 1'b0;					// clear bit to indicate thread now inactive
								end
						end
				end
		end
	else 		// increment/decrement threads - pick out active thread
		begin

			// Matched a thread and told to increment with no associated decrement
			if ( ( matchThread[j] & openTransInc) & !(matchDataThread[j] & openTransDec ))	// update when told to increment only
				begin
					// Increment count - leave the rest the same
					d_openTransVec[j]	<= 	{ openTransVec[j][THREAD_VEC_WIDTH-1: THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH ],
												 { openTransVec[j][THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH-1 :0] + 1'b1 }
											};
				end
							
			// Matched a thread and told to decrement with no associated increment
			else if ( !(matchThread[j]  & openTransInc) & ( matchDataThread[j] & openTransDec )  )		
				begin
					// Decrement count - leave the reset the same	
					d_openTransVec[j]	<= 	{ openTransVec[j][THREAD_VEC_WIDTH-1: THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH ],
												{ openTransVec[j][THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH-1 :0] - 1'b1 }	
											};

					// If last active transaction - clear activeThreadMask bit as free
					if ( { openTransVec[j][THREAD_VEC_WIDTH-MASTERID_WIDTH-NUM_SLAVES_WIDTH-1 :0] - 1'b1 }	== 0 )	
						begin
							d_activeThreadMask[j]	<= 1'b0;					// clear bit to indicate thread now inactive
						end
				end
			else 	// for when no increments or decrements or when both asserted on same thread - do nothing
				begin
							
				end
		end
	
end   // end of always block
endgenerate




//==========================================================================================================
// Storage for openTransVec and activeThreadMask
//==========================================================================================================
genvar l;
generate
for (l=0; l<NUM_THREADS; l=l+1)
	always @(posedge sysClk or negedge sysReset)
		begin
			if (!sysReset)
				begin
					activeThreadMask[l]	<= 0;		// all threads inactive
					openTransVec[l]	<= 0;
				end
			else
				begin
					activeThreadMask[l] <= d_activeThreadMask[l];	
					openTransVec[l]	<= d_openTransVec[l];	
				end

	
		end   // end of always block
endgenerate

endmodule // caxi4interconnect_TransactionController.v
