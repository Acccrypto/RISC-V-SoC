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
//     Abstract  : This file infers a dual-port caxi4interconnect_FIFO with both read and write port sync
//                 to HCLK. It takes in slaveValidQual and generates a valid signal
//                 when Rd Data is valid.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 
module caxi4interconnect_RdFifoDualPort (
					// Bus global signals
					HCLK,
					fifo_reset,
					
					// Write Port
					fifoWrite,
					fifoWrData,

					// Read Port
					fifoRead,
					fifoRdData,
					slaveValidQual,
					
					// Status bits
					fifoEmpty,
					fifoOneAvail,
					fifoRdValid,
					requestorSelValid,
					fifoFull,
					fifoNearFull,
					fifoOverRunErr,
					fifoUnderRunErr
				   
				);

   

//============================================
// Parameter Declarations
//============================================

	parameter HI_FREQ	= 1;			// used to add registers to allow a higher freq of operation at cost of latency
	parameter NEAR_FULL	= 2;			// used to define how close to full full the nearFull signal is asserted.

	parameter FIFO_AWIDTH = 1;			// Defines depth of caxi4interconnect_FIFO creates - 2^FIFO_AWIDTH of depth.
	
	parameter FIFO_WIDTH  = 3;
	parameter NUM_SLAVES = 8;


//============================================================================
// I/O Declarations
//============================================================================

// Inputs - AHB
	input HCLK;								// ahb system clock
	input fifo_reset;						// reset - active high

	
// Write Port signals
	input [FIFO_WIDTH-1:0]	fifoWrData;		// Data to be written to ram
	input fifoWrite;						// Push data into caxi4interconnect_FIFO (ie write)

 // Read Port signals
	input  fifoRead;							// Pop (ie read) caxi4interconnect_FIFO
	output [FIFO_WIDTH-1:0]	 fifoRdData;		// Data to be read from ram
	input  [NUM_SLAVES-1:0]  slaveValidQual;	
	
	output					 requestorSelValid;

 // Status bits
 	output fifoEmpty;
	output fifoOneAvail;					// indicates one entry in caxi4interconnect_FIFO
	output fifoRdValid;						// indicates data on fifRdData is valid - used to validate data in cases when pipeline
											// stages added to fifoRdData path.
	output fifoFull;		
	output fifoNearFull;					// indicates reached NEAR_FULL level from full and held asserted until caxi4interconnect_FIFO falls below thresholld 
											// ie held asserted when above level.
	output fifoOverRunErr;
	output fifoUnderRunErr;			
   
   

//============================================
// I/O Declarations
//============================================

	reg	fifoOverRunErr, fifoUnderRunErr;								// Error status bits
	reg fifoEmpty, fifoOneAvail, fifoRdValid, fifoFull, fifoNearFull;	// Empty and Full status bits

	wire  [NUM_SLAVES-1:0]	slaveValidQual;	
	reg						requestorSelValid;
	
//============================================
// Local Declarations
//============================================

	reg [FIFO_AWIDTH-1:0] fifoWrAddr;			// Addr to be written to in RAM
	reg [FIFO_AWIDTH-1:0] fifoRdAddr;			// Addr to be read from RAM

	reg [FIFO_AWIDTH:0] fifoSpace;				// Amount of space left in caxi4interconnect_FIFO

	reg					fifoReadQ1;
	
localparam	nearFullSpace = HI_FREQ ? NEAR_FULL : 'd1;		// handle pipelining cases

//====================================================================================
// Create read and write pointers (ie addresses for RAM) and space counter for caxi4interconnect_FIFO.
//====================================================================================

`ifdef VERBOSE
initial
begin
		if (HI_FREQ)
			begin
				$display( "Module has HI_FREQ assert: %m ");
			end
end
`endif 
	
	
always @( posedge HCLK or negedge fifo_reset )
begin
	if (!fifo_reset)
		begin
		
			fifoWrAddr <= 0;					// Addr to be written to in RAM
			fifoRdAddr <= 0;					// Addr to be read from RAM

			fifoSpace 		<= { 1'b1, { FIFO_AWIDTH{1'b0} } };	// Initialise space "empty"
			fifoEmpty 		<= 1;
			
			fifoFull  		<= 0;
			fifoNearFull 	<= 1'b0;			// One from full
		
			fifoOverRunErr  <= 0;
			fifoUnderRunErr <= 0;
			
		end
	else
		begin
		
			fifoOverRunErr  <= 0;			// errors bit only asserted for 1 clock tick
			fifoUnderRunErr <= 0;
		
			case( { fifoRead, fifoWrite }  )			// handle writing/reading combinations
			2'b00:  
					begin				// do nothing if no
					end					// read or write
			2'b01:		// write only on caxi4interconnect_FIFO
					begin
					
						fifoEmpty  <= 1'b0;								// doing write so will not be empty 
						
						if ( fifoSpace == (nearFullSpace + 1) )			// reaching NEAR_FULL level
							begin
								fifoWrAddr 	 <= fifoWrAddr + 1'b1;
								fifoSpace  	 <= fifoSpace - 1'b1;	
								fifoNearFull <= 1'b1;				// Reached NEAR_FULL level
							end
						else if ( fifoSpace == 1 )						// one last entry can be written
							begin
								fifoWrAddr 	<= fifoWrAddr + 1'b1;
								fifoSpace  	<= fifoSpace - 1'b1;	
								fifoFull 	<= 1'b1;					// set full
							end
						else if ( fifoSpace != 0 )						// space for entry
							begin
								fifoWrAddr <= fifoWrAddr + 1'b1;	
								fifoSpace  <= fifoSpace - 1'b1;	
							end
						else
							begin
								fifoOverRunErr <= 1'b1;					// trying to write a full caxi4interconnect_FIFO
								$display( "%t Module has fifoOverRunErr assert: %m ", $time );
								$stop;
							end
					end
								
			2'b10:		// read only on caxi4interconnect_FIFO
					begin
					
						fifoFull  <= 1'b0;								// doing read so will not be full 

						if ( fifoSpace == nearFullSpace )				// doing read at NEAR_FULL level of space
							begin
								fifoNearFull <= 1'b0;				
								fifoRdAddr <= fifoRdAddr + 1'b1;
								fifoSpace  <= fifoSpace + 1'b1;	
								
								if ( fifoSpace == { 1'b0, { FIFO_AWIDTH{1'b1} } }  )	// if only of depth of 2 for caxi4interconnect_FIFO
									begin
										fifoEmpty  <= 1'b1;								// set empty 
									end
							end
						else if ( fifoSpace == { 1'b0, { FIFO_AWIDTH{1'b1} } }  )		// one last entry can be read
							begin
								fifoRdAddr <= fifoRdAddr + 1'b1;
								fifoSpace  <= fifoSpace + 1'b1;	
								fifoEmpty  <= 1'b1;										// set empty 
							end
						else if ( fifoSpace != {1'b1, { FIFO_AWIDTH{1'b0} } }  )		// entry to be read
							begin
								fifoRdAddr <= fifoRdAddr + 1'b1;	
								fifoSpace  <= fifoSpace + 1'b1;	
							end
						else
							begin
								fifoUnderRunErr <= 1'b1;					// trying to read from an empty caxi4interconnect_FIFO
								$display( "%t Module has fifoUnderRunErr assert: %m ", $time );
								$stop;
							end
					end					
			2'b11:		// simultaneous read and write 
					begin

						fifoRdAddr <= fifoRdAddr + 1'b1;					// only need to incremenet rd/write addresses
						fifoWrAddr <= fifoWrAddr + 1'b1;					// space does not change nor do caxi4interconnect_FIFO status bits.

					end								
			endcase
		end
		

end

always @( posedge HCLK or negedge fifo_reset )
begin
	if (!fifo_reset)
		begin
			fifoRdValid		<= 0;
			fifoReadQ1		<= 0;
			requestorSelValid <= 0;
		end
	else
		begin
			fifoReadQ1	<= fifoRead;				
			
			case( { fifoRead, fifoWrite }  )			// handle writing/reading combinations
				2'b00:  
						begin				// do nothing if no
							fifoRdValid 	  <= !fifoEmpty;		// set if data already in firo
							requestorSelValid <= !fifoEmpty & slaveValidQual[fifoRdData];
						end					// read or write
				2'b01:		// write only on caxi4interconnect_FIFO
						begin
							if ( HI_FREQ )
								begin
									fifoRdValid <= !fifoEmpty;		// set if data alread in firo
									requestorSelValid <= !fifoEmpty & slaveValidQual[fifoRdData];
								end
							else
								begin
									fifoRdValid <= 1;
									requestorSelValid <= slaveValidQual[fifoRdData];
								end
						end
				2'b10:		// read only on caxi4interconnect_FIFO
						begin
							if ( HI_FREQ )
								begin
									fifoRdValid <= fifoReadQ1 & !fifoEmpty;			// bubble on a read - but only on first read and data in caxi4interconnect_FIFO
									requestorSelValid <= fifoReadQ1 & !fifoEmpty & slaveValidQual[fifoRdData];								
								end
							else
								begin
									if ( fifoSpace == { 1'b0, { FIFO_AWIDTH{1'b1} } }  )	// only 1 entry and reading
										begin
											fifoRdValid 		<= 0;
											requestorSelValid 	<= 0;								
										end
								end
						end					
				2'b11:		// simultaneous read and write 
						begin
							if ( HI_FREQ )
								begin
									fifoRdValid <= fifoReadQ1 & !fifoEmpty;			// bubble on a read - but only on first read
									requestorSelValid <= fifoReadQ1 & !fifoEmpty & slaveValidQual[fifoRdData];								
								end
							else
								begin
									fifoRdValid <= 1;
									requestorSelValid <= slaveValidQual[fifoRdData];
								end

						end								
				endcase
		end
end



//=====================================================================
// Decode when only one entry in caxi4interconnect_FIFO
//=====================================================================
always @( posedge HCLK or negedge fifo_reset  )
	begin
		if ( !fifo_reset )
			begin
				fifoOneAvail	<= 0;
			end
		else
			begin
				if ( ( fifoSpace == {1'b1, { FIFO_AWIDTH{1'b0} } }  ) & fifoWrite & !fifoRead )			// caxi4interconnect_FIFO empty and writing one in
					begin
						fifoOneAvail <= 1'b1;
					end
				else if ( ( fifoSpace == {1'b0, { FIFO_AWIDTH{1'b1} } }  ) & fifoWrite & !fifoRead )	// caxi4interconnect_FIFO 1-entry and writing one in
					begin
						fifoOneAvail <= 1'b0;
					end				
				else if ( ( fifoSpace == ( {1'b0, { FIFO_AWIDTH{1'b1} } } -1'b1) ) & !fifoWrite & fifoRead )	// two entries in caxi4interconnect_FIFO
					begin
						fifoOneAvail <= 1'b0;
					end					
				else if ( ( fifoSpace == {1'b0, { FIFO_AWIDTH{1'b1} } }  ) & !fifoWrite & fifoRead )	// moving to empty
					begin
						fifoOneAvail <= 1'b0;
					end
			end
	end

	
//==================================================================
// Declare Dual port RAM - generate from FFs if less than 64 memory
// elements.
//==================================================================
generate

	if (  (( 1<< FIFO_AWIDTH ) * FIFO_WIDTH ) <= 'd64 )		

		caxi4interconnect_DualPort_FF_SyncWr_SyncRd #( 	.HI_FREQ(  HI_FREQ ),
										.FIFO_AWIDTH( FIFO_AWIDTH ),
										.FIFO_WIDTH ( FIFO_WIDTH )
									)
				DPFF(
										// AHB global signals
										.HCLK( HCLK ),

										// Write Port
										.fifoWrAddr( fifoWrAddr ),	
										.fifoWrite ( fifoWrite  ),
										.fifoWrData( fifoWrData ),

										// Read Port
										.fifoRdAddr( fifoRdAddr ),
										.fifoRdData( fifoRdData )
				   
									) ;

	else
		begin
	
			reg [FIFO_AWIDTH-1:0] d_fifoRdAddr;			// Addr to be read from RAM

			//=======================================================================
			// Create "pipeline" address for Block RAM to allow dual-port
			// sync read and sync write to be inferred.
			//=======================================================================
			always @(*)
				begin

					d_fifoRdAddr <= fifoRdAddr;
	
					if ( fifoRead )
						begin
							if ( fifoWrite )									// can always increment as writing and reading 
								d_fifoRdAddr <= fifoRdAddr + 1'b1;							
							else if ( fifoSpace != {1'b1, { FIFO_AWIDTH{1'b0} } }  )		// as long as entry to be read
								d_fifoRdAddr <= fifoRdAddr + 1'b1;	
						end

				end
			
			caxi4interconnect_DualPort_RAM_SyncWr_SyncRd #( 	.FIFO_AWIDTH( FIFO_AWIDTH ),
											.FIFO_WIDTH ( FIFO_WIDTH )
										)
						DPRam(
											// AHB global signals
											.HCLK( HCLK ),

											// Write Port
											.fifoWrAddr( fifoWrAddr ),	
											.fifoWrite ( fifoWrite  ),
											.fifoWrData( fifoWrData ),

											// Read Port
											.fifoRdAddr( d_fifoRdAddr ),
											.fifoRdData( fifoRdData )
				   
										);

		end
	
endgenerate


endmodule // caxi4interconnect_RdFifoDualPort.v
