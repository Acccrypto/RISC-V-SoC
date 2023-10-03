///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: MICROSEMI
//
// IP Core: COREAXI4INTERCONNECT
//
//  Description  : The AMBA AXI4 Interconnect core connects one or more AXI memory-mapped master devices to one or
//                 more memory-mapped slave devices. The AMBA AXI protocol supports high-performance, high-frequency
//                 system designs.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_SlvAxi4ProtConvAXI4ID #
       
	(	
		parameter [0:0] 	ZERO_SLAVE_ID	  	    = 1'b1,	// zero ID field		
		parameter integer 	ID_WIDTH   				= 1,		// number of bits for ID (ie AID, WID, BID) - valid 1-8 
		parameter integer 	SLV_AXI4PRT_ADDRDEPTH	= 8,		// Number transations width - 1 => 2 transations, 2 => 4 transations, etc.
		parameter           READ_INTERLEAVE         = 1
	)
	(

	//=====================================  Global Signals   ========================================================================
	input  wire           			ACLK,
	input  wire          			sysReset,
	
	// External side
	//Slave Read Address Ports
	output wire [ID_WIDTH-1:0]      SLAVE_AID,
	output wire         			SLAVE_AVALID,

	input wire             			SLAVE_AREADY,


	// Slave Read Data Ports
	input wire [ID_WIDTH-1:0]  		SLAVE_ID,	
	
	output wire               		SLAVE_READY,
  	input wire                 		SLAVE_VALID,
	input wire                 		SLAVE_LAST,

	// Slave Read Address Ports	
	input  wire [ID_WIDTH-1:0]  	int_slaveAID,

	input wire                		int_slaveAVALID,
	output wire                		int_slaveAREADY,
	
	// Slave Read Data Ports	
	output wire [ID_WIDTH-1:0]  	int_slaveID,
	output wire                 	int_slaveVALID,
	input wire                 		int_slaveREADY
	
	);


       wire fifoEmpty;
       wire fifoFull;
       wire fifoNearlyFull;
       wire [ID_WIDTH-1:0] IDFifoOut;
       wire fifoWr;
       wire fifoRd;


        generate
          if (READ_INTERLEAVE == 0 && ZERO_SLAVE_ID == 1) begin
  
            caxi4interconnect_FIFO #
	        (
		    .MEM_DEPTH( 2**SLV_AXI4PRT_ADDRDEPTH ),
		    .DATA_WIDTH_IN ( ID_WIDTH ),
		    .DATA_WIDTH_OUT ( ID_WIDTH ), 
		    .NEARLY_FULL_THRESH ( (2**SLV_AXI4PRT_ADDRDEPTH) - 1 ),
		    .NEARLY_EMPTY_THRESH ( 0 )
	        )
            rdata_interleave_fifo (
	        .rst (sysReset ),
	        .clk ( ACLK ),
	        .wr_en ( fifoWr ),
	        .rd_en ( fifoRd ),
	        .data_in ( int_slaveAID ),
	        .data_out ( IDFifoOut ),
	        .zero_data ( 1'b0 ),
	        .fifo_full ( fifoFull ),
	        .fifo_empty ( fifoEmpty ),
	        .fifo_nearly_full ( fifoNearlyFull ),
	        .fifo_nearly_empty ( ),
	        .fifo_one_from_full ( )
            );
			
            assign fifoWr = int_slaveAREADY & int_slaveAVALID;
            assign fifoRd = SLAVE_READY & SLAVE_VALID & SLAVE_LAST;
	        assign SLAVE_READY = ~fifoEmpty & int_slaveREADY;
  	        assign SLAVE_AID = 0;
            assign int_slaveID = IDFifoOut;
            assign int_slaveAREADY = ~fifoNearlyFull & SLAVE_AREADY;
            assign SLAVE_AVALID = int_slaveAVALID & ~fifoNearlyFull;
	        assign int_slaveVALID = SLAVE_VALID & ~fifoEmpty;	
          end else begin
	        assign int_slaveAREADY = SLAVE_AREADY;	
  	        assign SLAVE_AID = int_slaveAID;
	        assign int_slaveID = SLAVE_ID;
	        assign SLAVE_READY = int_slaveREADY;
	        assign SLAVE_AVALID = int_slaveAVALID;
	        assign int_slaveVALID = SLAVE_VALID;	
          end
        endgenerate		
endmodule
