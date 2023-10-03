// ********************************************************************
//  Microsemi Corporation Proprietary and Confidential
//  Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: This file infers a dual-port ram with sync write port
//              and a sync read port.
//
// Revision Information:
// Date     Description:
// Feb17    Revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************
`timescale 1ns / 1ns

`ifdef SIM_MODE

module caxi4interconnect_DualPort_RAM_SyncWr_ASyncRd (
					// AHB global signals
					HCLK,

					// Write Port
					fifoWrAddr,	
					fifoWrite,
					fifoWrStrb,					
					fifoWrData,

					// Read Port
					fifoRdAddr,
					fifoRdData
				   
				);

   

//============================================
// Parameter Declarations
//============================================

	parameter FIFO_AWIDTH = 9;
	
	parameter FIFO_WIDTH = 8;
	
	localparam [32:0] FIFO_DEPTH = 1 << FIFO_AWIDTH;

	localparam NUM_BYTES = (FIFO_WIDTH/8);
	
	localparam ADDR_NC_BITS = 	$clog2(FIFO_WIDTH/8);

//============================================================================
// I/O ports
//============================================================================

	input HCLK;								// ahb system clock

	
// Write Port signals
	input [FIFO_WIDTH-1:0]					fifoWrData;		// Data to be written to ram
	input [FIFO_AWIDTH+ADDR_NC_BITS-1:0] 	fifoWrAddr;		// Addr to be written to in RAM
	input [NUM_BYTES - 1:0]					fifoWrStrb ;		// One strobe per byte

	input fifoWrite;						// Indicates address defined by fifoWrAddr to be written

 // Read Port signals
	output [FIFO_WIDTH-1:0]					fifoRdData;	// Data to be written to ram
	input  [FIFO_AWIDTH+ADDR_NC_BITS-1:0] 	fifoRdAddr;	// Addr to be read from RAM

   
//============================================
// I/O Declarations
//============================================

	wire [FIFO_WIDTH-1:0]		fifoRdData;		// Data to be read from register

	
//============================================
// Local Declarations
//============================================

	localparam [FIFO_WIDTH-1:0]	element = { FIFO_WIDTH{1'b1} };
	
	reg [FIFO_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

	integer j;
	
	initial // Read the memory contents in the file
            // ram_init.txt. 
		begin
			for (j=0; j<FIFO_DEPTH; j=j+1)
				begin
					mem[j] = { FIFO_WIDTH{ 1'b1 } };		// set to all 1s
				end
		end

	wire [FIFO_AWIDTH -1 :0]	fifoRdAddr_nc; 
	wire [FIFO_AWIDTH -1 :0]	fifoWrAddr_nc; 
	
	wire [FIFO_WIDTH - 1:0]		fifoRdModWrData;
	wire [FIFO_WIDTH - 1:0]		fifoWrDataIn;
	
	
//========================================================================================
// Generate Byte Write Lanes
//========================================================================================
	
	assign fifoRdModWrData = mem[fifoWrAddr_nc];	// Read the Data in the Location to be Written
	
	genvar i;										// Select Stored Read Data if it is not	
	generate										// Select the Input Byte if Strobe is Active, 
		for (i = 0; i < NUM_BYTES; i = i + 1)
			begin
				assign fifoWrDataIn[((i+1)*8) -1:(i*8) ] = fifoWrStrb[i] ? fifoWrData[((i+1)*8) -1:(i*8)] : fifoRdModWrData[((i+1)*8) -1:(i*8)];
			end								
	endgenerate
	

//====================================================================================
// Infer dual port ram - one sync write port - once async read port
//==================================================================================

	assign fifoRdAddr_nc = fifoRdAddr[ADDR_NC_BITS+: FIFO_AWIDTH];	// Address Bus Connection
	assign fifoWrAddr_nc = fifoWrAddr[ADDR_NC_BITS+: FIFO_AWIDTH];	// Based on Data Bus Width	- drop bits for bytes stored in each RAM location

	assign fifoRdData = mem[fifoRdAddr_nc];	

//====================================================================================
// Infer RAM - Read Data Before Writing - Read Modify Write
//====================================================================================
	
	always@ ( posedge HCLK )
	begin

		if (fifoWrite)
			mem[fifoWrAddr_nc] <= fifoWrDataIn;

	end

	
`ifdef VERBOSE
	//=============================================================================================
	// Display data begin written into RAM
	//=============================================================================================
	always @( negedge HCLK )
		begin	
			if ( fifoWrite )		
				begin
					$display( "%t, %m, fifoWrAddr=%h (%d), fifoWrAddr_nc=%h (%d) , fifoWrDataIn= %d (%h), fifoRdMOrgData = %d (%h), fifoWrStrb= %h", 
									$time, fifoWrAddr, fifoWrAddr, fifoWrAddr_nc, fifoWrAddr_nc, fifoWrDataIn, fifoWrDataIn, fifoRdModWrData, fifoRdModWrData, fifoWrStrb );
				end
		end

	reg [FIFO_AWIDTH -1 :0]	fifoRdAddr_ncQ1; 
	
	//=============================================================================================
	// Display data read from RAM
	//=============================================================================================
	always @( negedge HCLK )
		begin	
			
			if ( fifoRdAddr_ncQ1 !== fifoRdAddr_nc )		// if address changed		
				begin
					$display( "%t, %m, memRdAddr=%h (%d), fifoRdAddr_nc=%h (%d), fifoRdData= %d (%h)", 
									$time, fifoRdAddr, fifoRdAddr, fifoRdAddr_nc, fifoRdAddr_nc, fifoRdData, fifoRdData );
				end

			fifoRdAddr_ncQ1 <= fifoRdAddr_nc;
			
		end				

`endif
	
endmodule // caxi4interconnect_DualPort_RAM_SyncWr_ASyncRd.v

`else

module caxi4interconnect_DualPort_RAM_SyncWr_ASyncRd (
					// AHB global signals
					HCLK,

					// Write Port
					fifoWrAddr,	
					fifoWrite,
					fifoWrStrb,
					fifoWrData,

					// Read Port
					fifoRdAddr,
					fifoRdData
				   
				);

   

//============================================
// Parameter Declarations
//============================================

	parameter FIFO_AWIDTH = 9;
	
	parameter FIFO_WIDTH = 8;
	
	localparam FIFO_DEPTH = 1 << FIFO_AWIDTH;

	localparam NUM_BYTES = (FIFO_WIDTH/8);
	
	localparam ADDR_NC_BITS = 	(FIFO_WIDTH == 'd8) 	? 	'd0	:	// Determine which address bits
								(FIFO_WIDTH == 'd16) 	?  	'd1	:	// to connect to FIFO address input
								(FIFO_WIDTH == 'd32) 	? 	'd2	:	// based on Data Bus Width
								(FIFO_WIDTH == 'd64) 	? 	'd3	:	
								(FIFO_WIDTH == 'd128) 	? 	'd4	:	
								(FIFO_WIDTH == 'd256) 	? 	'd5	:	
								(FIFO_WIDTH == 'd512) 	? 	'd6	:	
								(FIFO_WIDTH == 'd1024) 	? 	'd7	:	
								'd0;		// not supported;	
//============================================================================
// I/O ports
//============================================================================

// Inputs - AHB
	input HCLK;								// ahb system clock

	
// Write Port signals
	input [FIFO_WIDTH-1:0]	fifoWrData;		// Data to be written to ram
	input [FIFO_AWIDTH+ADDR_NC_BITS-1:0] 	fifoWrAddr;		// Addr to be written to in RAM
	input fifoWrite;						// Indicates address defined by fifoWrAddr to be written
	input [NUM_BYTES - 1:0]	fifoWrStrb ;		// One strobe per byte

 // Read Port signals
	output [FIFO_WIDTH-1:0]	fifoRdData;	// Data to be written to ram
	input  [FIFO_AWIDTH+ADDR_NC_BITS-1:0] 	fifoRdAddr;	// Addr to be read from RAM

   
//============================================
// I/O Declarations
//============================================

	wire [FIFO_WIDTH-1:0]		fifoRdData;		// Data to be read from register

	
//============================================
// Local Declarations
//============================================

	reg [FIFO_WIDTH-1:0] mem [0:FIFO_DEPTH-1];	// RAM array declaration
	
	reg [FIFO_AWIDTH-1:0] 	fifoRdAddrQ1;		// Addr to be read from RAM

	wire [FIFO_AWIDTH-1:0] fifoRdAddr_nc, fifoWrAddr_nc;

	integer j;
	

//====================================================================================
// Infer dual port ram - one sync write port - once async read port
//==================================================================================
assign fifoRdAddr_nc = fifoRdAddr[FIFO_AWIDTH- 1: 0];	// Address Bus Connection
assign fifoWrAddr_nc = fifoWrAddr[FIFO_AWIDTH- 1: 0];	// Based on Data Bus Width	- drop bits for bytes stored in each RAM location

assign fifoRdData = mem[fifoRdAddrQ1] ;

always@ (posedge HCLK )
begin

	fifoRdAddrQ1 <= fifoRdAddr_nc;			// just a way to break timing for synthesis - not really a working solution
	
	if (fifoWrite)
		mem[fifoWrAddr_nc] <= fifoWrData;

end

`ifdef VERBOSE
	//=============================================================================================
	// Display data begin written into RAM
	//=============================================================================================
	always @( negedge HCLK )
		begin	
			if ( fifoWrite )		
				begin
					$display( "%t, %m, fifoWrAddr=%h (%d), fifoWrAddr_nc=%h (%d) , fifoWrData= %d (%h), fifoWrStrb= %h", 
									$time, fifoWrAddr, fifoWrAddr, fifoWrAddr_nc, fifoWrAddr_nc, fifoWrData, fifoWrData, fifoWrStrb );
				end
		end

	reg [FIFO_AWIDTH -1 :0]	fifoRdAddr_ncQ1; 
	
	//=============================================================================================
	// Display data read from RAM
	//=============================================================================================
	always @( negedge HCLK )
		begin	
			
			if ( fifoRdAddr_ncQ1 !== fifoRdAddr_nc )		// if address changed		
				begin
					$display( "%t, %m, memRdAddr=%h (%d), fifoRdAddr_nc=%h (%d), fifoRdAddrQ1,=%h (%d), fifoRdData= %d (%h)", 
									$time, fifoRdAddr, fifoRdAddr, fifoRdAddr_nc, fifoRdAddr_nc, fifoRdAddrQ1, fifoRdAddrQ1, fifoRdData, fifoRdData );
				end

			fifoRdAddr_ncQ1 <= fifoRdAddr_nc;
			
		end				
`endif

endmodule // caxi4interconnect_DualPort_RAM_SyncWr_ASyncRd.v

`endif
