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
//     Abstract  : This file provides full 2-stage register slice which adds 1 cycle latency but
//                 no bubble cycles between transactions.   
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_RegSliceFull #

	(
  		parameter integer 	CHAN_WIDTH 			= 5			//  the number of channel signals to register (outside of Valid & Ready) 
	)
	
	(

		input  wire			sysClk,
		input  wire         sysReset,						// active high reset - async assert and sync to sysClk deassert
  
		//========================= to/from Master and Slave Ports ================================================//
   
		input wire [CHAN_WIDTH-1:0]		mDat,				// channel data signals to register from "master" or "source"
		input wire        				mValid,				// indicates when mDat is valid
		output reg						mReady,				// indicates when taking data from "master" or "source"
		
		output reg [CHAN_WIDTH-1:0]		sDat,				// channel data signals registered to "slave" or "sink"
		output reg						sValid,				// indicates when sDat is valid
		input wire						sReady				// indicates when slave/sink taking sDat
    
	);
	
	//===============================================================================================================
	// Local Declarations
	//===============================================================================================================
	
	reg [CHAN_WIDTH-1:0]	holdDat;						// holding register for mDat - for when slave/sink not ready
	reg						sDatEn;							// latch next data into sDat
	reg						holdDatSel;
	
	
	//============================================================================================
	// Declare state machine variables
	//============================================================================================
	localparam [1:0]	IDLE = 2'b00, NO_DAT = 2'b01,	ONE_DAT = 2'b11, 	TWO_DAT = 2'b10;
	
	reg [1:0]	currState, nextState;
	reg			d_mReady, d_sValid;
	
	
	//============================================================================================
	// holdDat holds mDat when sink is not ready to take sDat - allows master/source to move on
	// while not losing data.
	//============================================================================================
	always @(posedge sysClk or negedge sysReset )
		begin
			if (!sysReset)
				holdDat <= 0;
			else if ( mValid & mReady )
				holdDat <= mDat;
		end

	
	//=============================================================================================
	// sDat has mDat clocked in or holdDat if slave/sink was not ready.
	//=============================================================================================
	always @(posedge sysClk or negedge sysReset )
		begin
			if (!sysReset)
				sDat <= 0;
			else if ( sDatEn )			// if s/m says load next data
				begin
					sDat <= holdDatSel 	? holdDat : mDat;		// normally clock in mDat but if had been held off due to slave 
																// not ready, take from holding register
				end
		end
		
		
	//===============================================================================================
	// Control State machine
	//===============================================================================================
	always @( * )
		begin
		
			d_mReady <= 1;
			d_sValid <= 0;
			
			holdDatSel	<= 0;
			sDatEn		<= 0;
			
			nextState <= currState;
		
			case ( currState )
				IDLE:	
						begin					// this state ensures that we mReady is always desserted as we exit reset
							nextState <= NO_DAT;
						end
				NO_DAT:
						begin
							
							if ( mValid )			// if master/source has data for us
								begin
									sDatEn		<= 1'b1;	// latch for slave/sink
									d_sValid 	<= 1'b1;	// indicate to slave that data available
									
									nextState 	<= ONE_DAT;
								end
						end
				ONE_DAT:
						begin
						
							if ( sReady )			// if slave/sink is taking available data
								begin
								
									if ( mValid )	// if source has another data available
										begin
											sDatEn 		<= 1'b1;
											d_sValid 	<= 1'b1;
										end
									else
										begin
											nextState	<= NO_DAT;
										end
								end
							else
								begin
									d_sValid	<= 1'b1;
									
									if ( mValid )
										begin
											d_mReady	<= 1'b0;		// stop mReady as pipe full
											nextState	<= TWO_DAT;
										end
									else
										begin
											d_mReady	<= 1'b1;
										end

								end
						end
				TWO_DAT:
						begin
							holdDatSel 	<= 1;
							d_sValid	<= 1'b1;
							d_mReady	<= 1'b0;
							
							if ( sReady )
								begin
									sDatEn 		<= 1'b1;
									d_mReady	<= 1'b1;
									
									nextState	<= ONE_DAT;
								end
						end
				default:
					begin
						nextState	<= 2'bxx;
						sDatEn		<= 1'bx;
						holdDatSel	<= 1'bx;
						
						d_mReady	<= 1'bx;
						d_sValid	<= 1'bx;
						
					end
			endcase
	
		end
							
	//===================================================================================================
	// Sequential part of s/m
	//===================================================================================================
	always @(posedge sysClk or negedge sysReset )
		begin
			if (!sysReset)
				begin
					currState	<= IDLE;
				
					mReady	<= 1'b0;
					sValid	<= 1'b0;
				end
			else
				begin
					currState	<= nextState;
				
					mReady	<= d_mReady;
					sValid	<= d_sValid;
				end
				
		end
					
				
		
		
		
endmodule		// caxi4interconnect_RegSliceFull.v
