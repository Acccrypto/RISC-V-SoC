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
//     Abstract  : This file infers a dual-port ram based on FFs with sync write port and
//                 a sync read port.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_DualPort_FF_SyncWr_SyncRd (
					// AHB global signals
					HCLK,

					// Write Port
					fifoWrAddr,	
					fifoWrite,
					fifoWrData,

					// Read Port
					fifoRdAddr,
					fifoRdData
				   
				)
				
		/* synthesis syn_ramstyle = "registers" */;

   

//============================================
// Parameter Declarations
//============================================

	parameter HI_FREQ	= 1;
	
	parameter FIFO_AWIDTH = 9;
	
	parameter FIFO_WIDTH = 8;
	
	localparam FIFO_DEPTH = 1 << FIFO_AWIDTH;


//============================================================================
// I/O ports
//============================================================================

// Inputs - AHB
	input HCLK;								// ahb system clock

	
// Write Port signals
	input [FIFO_WIDTH-1:0]	fifoWrData;		// Data to be written to ram
	input [FIFO_AWIDTH-1:0] fifoWrAddr;		// Addr to be written to in RAM
	input fifoWrite;						// Indicates address defined by fifoWrAddr to be written

 // Read Port signals
	output [FIFO_WIDTH-1:0]	 fifoRdData;	// Data to be written to ram
	input  [FIFO_AWIDTH-1:0] fifoRdAddr;	// Addr to be read from RAM

   
//============================================
// I/O Declarations
//============================================

	wire [FIFO_WIDTH-1:0]		fifoRdData;		// Data to be read from register
	reg  [FIFO_WIDTH-1:0]		fifoRdDataQ1;	// Data to be read from register - sync

	
//============================================
// Local Declarations
//============================================

	reg [FIFO_WIDTH-1:0] mem [0:FIFO_DEPTH-1];	// RAM array declaration

//====================================================================================
// Infer dual port ram - one sync write port - once async or sync read port based on
// HI_FREQ
//==================================================================================


assign fifoRdData = HI_FREQ ?  fifoRdDataQ1 : mem[fifoRdAddr];

always@ (posedge HCLK )
begin

	fifoRdDataQ1 <= mem[fifoRdAddr];
	
	if (fifoWrite)
		mem[fifoWrAddr] <= fifoWrData;

end


endmodule // caxi4interconnect_DualPort_FF_SyncWr_SyncRd.v
