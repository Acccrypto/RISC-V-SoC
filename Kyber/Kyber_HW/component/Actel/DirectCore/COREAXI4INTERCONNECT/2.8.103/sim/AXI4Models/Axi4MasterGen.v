// ********************************************************************
//  Microsemi Corporation Proprietary and Confidential
//  Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: This module provides a AXI4 Master test source. It initialiates a Master transmission.
//
// Revision Information:
// Date     Description:
// Feb17    Revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************
`timescale 1ns / 1ns

module Axi4MasterGen # 
	(

		parameter [3:0]		MASTER_NUM				= 0,		// slaive number
		parameter integer 	ID_WIDTH   				= 2, 

		parameter integer 	ADDR_WIDTH      		= 20,				
		parameter integer 	DATA_WIDTH 				= 16, 

		parameter integer 	SUPPORT_USER_SIGNALS 	= 0,
		parameter integer 	USER_WIDTH 				= 1,
		
		parameter integer 	OPENTRANS_MAX			= 1,			// Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.

		parameter	HI_FREQ							= 0				// increases freq of operation at cost of added latency
		
	)
	(
		// Global Signals
		input  wire                         sysClk,
		input  wire                       	ARESETN,			// active high reset synchronoise to RE AClk - asserted async.
   
		//====================== Master Read Address Ports  ================================================//
		// Master Read Address Ports
		output  reg [ID_WIDTH-1:0]        	MASTER_ARID,
		output  reg [ADDR_WIDTH-1:0]      	MASTER_ARADDR,
		output  reg [7:0]                 	MASTER_ARLEN,
		output  reg [2:0]                 	MASTER_ARSIZE,
		output  reg [1:0]                 	MASTER_ARBURST,
		output  reg [1:0]                 	MASTER_ARLOCK,
		output  reg [3:0]                 	MASTER_ARCACHE,
		output  reg [2:0]                 	MASTER_ARPROT,
		output  reg  [3:0]                	MASTER_ARREGION,		// not used
		output  reg  [3:0]                	MASTER_ARQOS,			// not used
		output  reg [USER_WIDTH-1:0]      	MASTER_ARUSER,
		output  reg                       	MASTER_ARVALID,
		input 	wire                    		MASTER_ARREADY,
		
		// Master Read Data Ports
		input wire [ID_WIDTH-1:0]      	  	MASTER_RID,
		input wire [DATA_WIDTH-1:0]        	MASTER_RDATA,
		input wire [1:0]                    MASTER_RRESP,
		input wire                          MASTER_RLAST,
		input wire [USER_WIDTH-1:0]         MASTER_RUSER,
		input wire                          MASTER_RVALID,
		output reg                          MASTER_RREADY,
 
 		// Master Write Address Ports
		output  reg [ID_WIDTH-1:0]        	MASTER_AWID,
		output  reg [ADDR_WIDTH-1:0]      	MASTER_AWADDR,
		output  reg [7:0]                 	MASTER_AWLEN,
		output  reg [2:0]                 	MASTER_AWSIZE,
		output  reg [1:0]                 	MASTER_AWBURST,
		output  reg [1:0]                 	MASTER_AWLOCK,
		output  reg [3:0]                 	MASTER_AWCACHE,
		output  reg [2:0]                 	MASTER_AWPROT,
		output  reg [3:0]                 	MASTER_AWREGION,		// not used
		output  reg [3:0]                 	MASTER_AWQOS,			// not used
		output  reg [USER_WIDTH-1:0]      	MASTER_AWUSER,
		output  reg                       	MASTER_AWVALID,
		input 	wire                  		  MASTER_AWREADY,
		
		// Master Write Data Ports
		output reg [DATA_WIDTH-1:0]     	  MASTER_WDATA,
		output reg [(DATA_WIDTH/8)-1:0]     MASTER_WSTRB,
		output reg                          MASTER_WLAST,
		output reg [USER_WIDTH-1:0]         MASTER_WUSER,
		output reg                          MASTER_WVALID,
		output reg [USER_WIDTH-1:0]         MASTER_WID,
		input  wire                         MASTER_WREADY,
  
		// Master Write Response Ports
		input  wire [ID_WIDTH-1:0]		    	MASTER_BID,
		input  wire [1:0]                   MASTER_BRESP,
		input  wire [USER_WIDTH-1:0]        MASTER_BUSER,
		input  wire      	                  MASTER_BVALID,
		output reg	  	                    MASTER_BREADY,
   
		// ===============  Control Signals  =======================================================//
		input wire				   	  		MASTER_RREADY_Default,  	// defines whether Master asserts ready or waits for RVALID
		input wire				     			MASTER_WREADY_Default,  	// defines whether Master asserts ready or waits for wVALID
		input wire					     		d_MASTER_BREADY_default,
		input wire							    rdStart,									// defines whether Master starts a transaction
		input wire [7:0]				   	rdBurstLen,								// burst length of read transaction
		input wire [ADDR_WIDTH-1:0]	rdStartAddr,							// start addresss for read transaction
		input wire [ID_WIDTH-1:0]		rdAID,					  				// AID for read transactions
		input wire [2:0]				  	rdASize,									// each transfer size
		input wire [1:0]				  	expRResp,									// indicate Read Respons expected
		
		output reg					    		masterRdAddrDone,		// Address Read transaction has been completed
		output reg				    			masterRdDone,		  	// Asserted when a read transaction has been completed
		output reg					    		masterRdStatus,			// Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
		output reg					    		mstRAddrIdle,		  	// indicates Read Address Bus is idle
  
		input wire					    		wrStart,			 			// defines whether Master starts a transaction
		input wire [1:0]			  		BurstType,					// Type of burst - FIXED=00, INCR=01, WRAP=10 
		input wire [7:0]			  		wrBurstLen,					// burst length of write transaction
		input wire [ADDR_WIDTH-1:0]	wrStartAddr,				// start addresss for write transaction
		input wire [ID_WIDTH-1:0]		wrAID,						  // AID for write transactions
		input wire [2:0]					  wrASize,				  	// each transfer size
		input wire [1:0]					  expWResp,				  	// indicate Read Respons expected
		
		output reg									masterWrAddrDone,		// Address Write transaction has been completed
		output reg									masterWrDone,		  	// Asserted when a write transaction has been completed
		output reg									masterRespDone,			// Asserted when a write response transaction has completed
		output reg									masterWrStatus,			// Status of read transaction - Pass =1, Fail=0. Only valid when masterRespDone asserted
		output reg									mstWAddrIdle,		  	// indicates Read Address Bus is idle
		output wire									mstWrAddrFull,			// Asserted when the internal queue for writes are full
		output wire									mstRdAddrFull		  	// Asserted when the internal queue for writes are full

		
	);

//================================================================================================
// Local Parameters
//================================================================================================
 
localparam	READFIF_WIDTH = ( ID_WIDTH + ADDR_WIDTH + 8 + 3 + 2 );			// ID, Addr, LEN and SIZE, and Burst 

localparam	[2:0]		MASTER_ASIZE_DEFAULT	= 	(DATA_WIDTH == 'd16) ? 3'h1 :
													(DATA_WIDTH == 'd32) ? 3'h2 :
													(DATA_WIDTH == 'd64) ? 3'h3 :
													(DATA_WIDTH == 'd128) ? 3'h4 :
													(DATA_WIDTH == 'd256) ? 3'h5 :
													(DATA_WIDTH == 'd512) ? 3'h6 :
													(DATA_WIDTH == 'd1024) ? 3'h7 :
														3'b000;		// not supported

wire						fifoOverRunErr, fifoUnderRunErr;
	
reg [READFIF_WIDTH-1:0]		readFifWrData;
wire [READFIF_WIDTH-1:0]	readFifRdData;

reg							readFifWr, readFifRd;
wire						readFifoFull, readFifoEmpty;
 
reg [15:0]					arCount, d_arCount; 
reg [15:0]					rdCount, d_rdCount; 

reg [5:0]					wAddrMask;

  wire [4:0]   rd_addr_beat;
  wire [4:0]   rd_to_boundary_master;
   wire      [9:0]  ReadAddrMaskWrap;


//====================================================================================================
// Local Declarationes for Master Read Address 
//====================================================================================================

localparam	[2:0]		rstIDLE = 3'h0,	rstDATA = 3'h1;

reg						d_MASTER_RREADY;

reg [2:0]				rcurrState, rnextState;

reg [ID_WIDTH-1:0]		transID;
reg [1:0]			burstType;

reg	[DATA_WIDTH-1:0]	d_rxLen, rxLen;

reg [7:0]				burstLen;
reg [2:0] burstSize;
wire [5:0] ReadAddrMask;
wire [ADDR_WIDTH-1:0]	startRdAddr;
reg [ADDR_WIDTH-1:0]	curRdAddr, d_curRdAddr;

reg [DATA_WIDTH-1:0]	rDataMask;
wire [DATA_WIDTH-1:0] shift_dataMask;
wire [DATA_WIDTH-1:0] mask_rDataMask;
wire [DATA_WIDTH-1:0] mask_rDataMask_exp;
wire [10:0] shift_fixed;
wire [DATA_WIDTH-1:0] addr_shift;
wire [DATA_WIDTH-1:0] exp_mask_shift;

wire					sysReset;

wire [DATA_WIDTH-1:0] baseValue;

reg [8:0] rdata_rand_sig;
reg [8:0] bready_rand_sig;

wire[5:0] align_addr_32;
wire[5:0] align_addr;
wire[31:0] mask_unalign;

genvar i;

generate
for (i=0; i<(DATA_WIDTH/8);i=i+1) begin
	assign baseValue[(8*i)+:8] = i;
end
endgenerate

assign shift_fixed = ((burstType == 2'b00) && (MASTER_ARSIZE > 2) && (((2**MASTER_ARSIZE) -  ((curRdAddr[5:0]) & ((2**MASTER_ARSIZE) - 1))) > 4)) ? ((8*((2**MASTER_ARSIZE)-(align_addr & 6'h3c))) - 32) : 0;

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

//=====================================================================================================
// Compute Mask for mis-aligned data
//=====================================================================================================
always @( * )
	begin
		rDataMask <= { DATA_WIDTH{1'b0}  };		// initialise mask to all invalid

  // The below case statement(DATA_WIDTH) allows the mask to be applied properly.
  // The size of the bus determines the max transfer size
  case (DATA_WIDTH)
    // The case statement (MASTER_ARSIZE) applies the 1's to the appropriate part of the mask
    // by shifting in a defined number of 1's to the appropriate location.
    // Indexing is multiplied (by 8, 16, 32, 64, 128, 256) as the mask is set on a 'per-bit' basis.
    'd32 :  case(MASTER_ARSIZE)
             3'b000 : rDataMask[(8*curRdAddr[1:0]) +: 8] <= {1{8'hff}};
             3'b001 : rDataMask[(16*curRdAddr[1]) +: 16] <= {2{8'hff}};
             3'b010 : rDataMask[31 : 0] <= {4{8'hff}};
            endcase
    'd64 :  case (MASTER_ARSIZE)
             3'b000 : rDataMask[(8*curRdAddr[2:0]) +: 8]   <= {1{8'hff}};
             3'b001 : rDataMask[(16*curRdAddr[2:1]) +: 16] <= {2{8'hff}};
             3'b010 : rDataMask[(32*curRdAddr[2]) +: 32]   <= {4{8'hff}};
             3'b011 : rDataMask[63 : 0] <= {8{8'hff}};
            endcase
    'd128 : case (MASTER_ARSIZE)
             3'b000 : rDataMask[(8*curRdAddr[3:0]) +: 8]   <= {1{8'hff}};
             3'b001 : rDataMask[(16*curRdAddr[3:1]) +: 16] <= {2{8'hff}};
             3'b010 : rDataMask[(32*curRdAddr[3:2]) +: 32] <= {4{8'hff}};
             3'b011 : rDataMask[(64*curRdAddr[3]) +: 64]   <= {8{8'hff}};
             3'b100 : rDataMask[127 : 0] <=  {16{8'hff}};
            endcase
    'd256 : case (MASTER_ARSIZE)
             3'b000 : rDataMask[(8*curRdAddr[4:0]) +: 8]     <= {1{8'hff}};
             3'b001 : rDataMask[(16*curRdAddr[4:1]) +: 16]   <= {2{8'hff}};
             3'b010 : rDataMask[(32*curRdAddr[4:2]) +: 32]   <= {4{8'hff}};
             3'b011 : rDataMask[(64*curRdAddr[4:3]) +: 64]   <= {8{8'hff}};
             3'b100 : rDataMask[(128*curRdAddr[4]) +: 128]   <= {16{8'hff}};
             3'b101 : rDataMask[255 : 0] <= {32{8'hff}};
            endcase
    'd512 : case (MASTER_ARSIZE)
             3'b000 : rDataMask[(8*curRdAddr[5:0]) +: 8]     <= {1{8'hff}};
             3'b001 : rDataMask[(16*curRdAddr[5:1]) +: 16]   <= {2{8'hff}};
             3'b010 : rDataMask[(32*curRdAddr[5:2]) +: 32]   <= {4{8'hff}};
             3'b011 : rDataMask[(64*curRdAddr[5:3]) +: 64]   <= {8{8'hff}};
             3'b100 : rDataMask[(128*curRdAddr[5:4]) +: 128] <= {16{8'hff}};
             3'b101 : rDataMask[(256*curRdAddr[5]) +: 256]   <= {32{8'hff}};
             3'b110 : rDataMask[511 : 0] <= {64{8'hff}};
            endcase
  endcase
end

//=============================================================================================
// Display messages only in Simulation - not synthesis
//=============================================================================================
`ifdef SIM_MODE
	
	//============================================================================================
	// Display messages for Read Address Channel	
	//=============================================================================================
	always @( posedge sysClk )
		begin
			#1;

			if ( MASTER_ARVALID )
				begin
					#1 $display( "%d, MASTER  %d - Starting Read Address Transaction %d, ARADDR= %h, ARBURST= %h, ARSIZE= %h, AID= %h, RXLEN= %d", 
											$time, MASTER_NUM, arCount, MASTER_ARADDR, MASTER_ARBURST, MASTER_ARSIZE, MASTER_ARID, MASTER_ARLEN );

					if ( MASTER_ARREADY )		// single beat
						begin
							#1 $display( "%d, MASTER  %d - Ending Read Address Transaction %d, AID= %h, RXLEN= %d", 
											$time, MASTER_NUM, arCount, MASTER_ARID, MASTER_ARLEN );
						end
					else
						begin
							@( posedge MASTER_ARREADY )
								#1 $display( "%d, MASTER  %d - Ending Read Address Transactions %d, AID= %h, RXLEN= %d", 
											$time, MASTER_NUM, arCount, MASTER_ARID, MASTER_ARLEN );
						end
				end
		end


		//=============================================================================================
		// Display messages for Read Data Channel
		//=============================================================================================
		always @( posedge sysClk )
			begin
				#1;

				if ( MASTER_RVALID )
					begin
						#1 $display( "%d, MASTER %d - Starting Read Data Transaction %d, RADDR= %h (%d), AID= %h, RXLEN= %d", 
										$time, MASTER_NUM, rdCount, curRdAddr, curRdAddr, MASTER_RID, burstLen );

						if ( MASTER_RLAST & MASTER_RVALID & MASTER_RREADY )		// single beat
							begin
								#1 $display( "%d, MASTER %d - Ending Read Data Transaction %d, AID= %h, RXLEN= %d", 
										$time, MASTER_NUM, rdCount, MASTER_RID, burstLen );
							end
						else
							begin
								@( posedge ( MASTER_RLAST & MASTER_RVALID & MASTER_RREADY ) )
									#1 $display( "%d, MASTER %d - Ending Read Data Transactions %d, AID= %h, RXLEN= %d, RRESP= %h", 
										$time, MASTER_NUM, rdCount, MASTER_RID, burstLen, MASTER_RRESP );
							end
					end
			end


		//=============================================================================================
		// Display messages for Read Data 
		//=============================================================================================
		always @( negedge sysClk )
			begin
				#1;

				if ( MASTER_RVALID & MASTER_RREADY )
					begin
						#1
						`ifdef VERBOSE
							$display( "%d, MASTER %d DATA: - RADDR= %h (%d), exp RDATA= %h, mask= %h, act RDATA= %h", $time, MASTER_NUM, 
												curRdAddr, curRdAddr, (rxLen+ MASTER_NUM + baseValue ), rDataMask & mask_rDataMask, MASTER_RDATA  );					
						`endif

						//===========================================================
						// For first beat in burst Mask out unused bytes
						//===========================================================
						
						if ( ( ( MASTER_RDATA & rDataMask & mask_rDataMask )!== ( (rxLen + MASTER_NUM + baseValue) & rDataMask & mask_rDataMask_exp ) ) & (expRResp == 0 ) & (burstType != 2'b00)  )
							begin
								$display( "%d, MASTER %d DATA ERROR - RADDR= %h (%d) exp RDATA= %h, mask= %h, act RDATA= %h", 
												$time, MASTER_NUM, curRdAddr, curRdAddr, ( rxLen+ MASTER_NUM + baseValue  ), rDataMask & mask_rDataMask, MASTER_RDATA  );
                $display( "360\t\t\trxLen: %h, d_rxLen: %h, MASTER_NUM: %h, MASTER_ARLEN: %h", rxLen, d_rxLen, MASTER_NUM, MASTER_ARLEN );

								masterRdStatus 	<= 0;
									
								if ( expRResp == 0 )		// if expect no error
									begin
										#1 $stop;
									end
							end
						else if ( ( ((( MASTER_RDATA  >> shift_fixed) & rDataMask ) & mask_rDataMask & (mask_unalign << 8*align_addr_32)  )!== ( ( (burstLen + MASTER_NUM + baseValue) & rDataMask  & mask_rDataMask_exp ) >> shift_fixed) ) & (expRResp == 0 ) & (burstType == 2'b00)  )
							begin
								$display( "%d, MASTER %d ERROR - exp RDATA= %h, act RDATA= %h", $time, MASTER_NUM, 
												( ( (burstLen + MASTER_NUM + baseValue) & rDataMask  & mask_rDataMask_exp ) >> shift_fixed), ((( MASTER_RDATA  >> shift_fixed) & rDataMask ) & mask_rDataMask & (mask_unalign << 8*align_addr_32)  )  );
								masterRdStatus 	<= 0;
								if ( expRResp == 0 )		// if expect no error
									begin
										#1 $stop;
									end		
							end
					end
			end
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
		slFif(
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
					.fifoFull( readFifoFull ),
					.fifoNearFull( ),
					.fifoOverRunErr( fifoOverRunErr ),
					.fifoUnderRunErr( fifoUnderRunErr )
				   
				);

assign mstRdAddrFull = readFifoFull;
assign startRdAddr	= readFifRdData[READFIF_WIDTH- ID_WIDTH-1: READFIF_WIDTH- ID_WIDTH- ADDR_WIDTH];

// align address to 32 bit boundary if TxSize > 32, align to TxSize otherwise
assign align_addr_32 = (((DATA_WIDTH/8)-1) & ( (MASTER_ARSIZE > 2) ? (curRdAddr[5:0] & 6'h3c) : (curRdAddr[5:0] & ~((1<<MASTER_ARSIZE)-1)) ));

// unalignement offset
assign align_addr = (curRdAddr[5:0] & ((1<<MASTER_ARSIZE)-1));

// valid bit within a 32 bit word for fixed
assign mask_unalign = 32'hffffffff << (curRdAddr[1:0] << 3);

// 
assign shift_dataMask = (((2**MASTER_ARSIZE) -  ((curRdAddr[5:0]) & ((2**MASTER_ARSIZE) - 1))) > 4) ? (8*(align_addr-4 + (DATA_WIDTH/8-addr_shift/8))) : 0;

// received data mask (mask out all bits but last 32 received bits
assign mask_rDataMask = ((burstType == 2'b00) && ( MASTER_ARSIZE > 2)) ? ((~((1 << addr_shift)-1))) : ~((1 << (8*(curRdAddr[5:0] & (DATA_WIDTH/8-1))))-1);

// expected data mask (mask out all bits but upper 32 valid bits)
assign mask_rDataMask_exp = ((burstType == 2'b00) && (MASTER_ARSIZE > 2)) ? (~((1 << addr_shift)-1)  << exp_mask_shift) : ~((1 << (8*(curRdAddr[5:0] & (DATA_WIDTH/8-1))))-1);

// address byte to bits within a word
assign addr_shift = (8*((curRdAddr[5:0]) & (DATA_WIDTH/8-1)));

// amount to shift the exp data mask by if TxSize > 32 bit
assign exp_mask_shift = (((2**MASTER_ARSIZE) -  ((curRdAddr[5:0]) & ((2**MASTER_ARSIZE) - 1))) > 4) ? ((8*((2**MASTER_ARSIZE)-(align_addr & 6'h3c))) - 32) : 0;

assign ReadAddrMaskWrap = (10'h3ff << $clog2((rdBurstLen+1) * (1 << rdASize)));

  assign rd_addr_beat = rdStartAddr[rdASize+:4] & rdBurstLen;
  assign rd_to_boundary_master = (rdBurstLen + 1) - rd_addr_beat;

//====================================================================================================
// Master Read Data S/M
//===================================================================================================== 
 always @( * )
 begin
 
 	#1;	// wait for inputs to "settle" - issue as "display" stmts 
	rnextState <= rcurrState;

	d_MASTER_RREADY	<= MASTER_RREADY_Default;
	readFifRd		<= 0;

	masterRdStatus	<= 1;

	d_rxLen 	<= rxLen;

	transID		= readFifRdData[READFIF_WIDTH-1: READFIF_WIDTH-ID_WIDTH];
	burstLen	= readFifRdData[READFIF_WIDTH- ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH- ID_WIDTH- ADDR_WIDTH -8];
  burstSize = readFifRdData[4:2];
	burstType	= readFifRdData[1:0];

	d_curRdAddr	<= curRdAddr;

	masterRdDone	<= 0;

	d_rdCount	<= rdCount;


  

	case( rcurrState )
		rstIDLE: begin
					d_MASTER_RREADY <= MASTER_RREADY_Default;

					masterRdStatus 	<= 1;
					d_rxLen 		<= 0;

					d_curRdAddr <= startRdAddr;
					
					if ( MASTER_RVALID & MASTER_RREADY & MASTER_RLAST )		// only 1 beat
						begin
							d_MASTER_RREADY	<= MASTER_RREADY_Default;

							transID		= readFifRdData[READFIF_WIDTH-1: READFIF_WIDTH-ID_WIDTH];
							burstLen	= readFifRdData[READFIF_WIDTH- ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH- ID_WIDTH- ADDR_WIDTH -8];

							if ( readFifoEmpty )
								begin

									$display( "%d, MASTER %d ERROR - Read Data cycle with no Read Address Pending", $time, MASTER_NUM );
									masterRdStatus 	<= 0;
									#1 $stop;
								end	
								
							if ( transID != MASTER_RID )
								begin
								
									$display( "%d, MASTER %d ERROR - exp RID= %h, act RID= %h", $time, MASTER_NUM, transID, MASTER_RID );
									
									masterRdStatus 	<= 0;
									#1 $stop;
								end
				
							if ( burstLen != rxLen )
								begin
									$display( "%d, MASTER %d ERROR - exp rxLen= %h, act rxLen= %h", $time, MASTER_NUM, burstLen, rxLen );

									masterRdStatus 	<= 0;

									#1 $stop;
								end		
							
							if ( MASTER_RRESP != expRResp )
								begin
									$display( "%d, MASTER %d ERROR - expRResp= %h, act RRESP= %h", $time, MASTER_NUM, 
													expRResp, MASTER_RRESP );
									masterRdStatus 	<= 0;

									#1 $stop;
							end		

							if ( ( ( MASTER_RDATA & rDataMask & mask_rDataMask )!== ( (rxLen + MASTER_NUM + baseValue) & rDataMask & mask_rDataMask_exp ) ) & (expRResp == 0 ) & (burstType != 2'b00)  )
								begin
									$display( "%d, MASTER %d ERROR - exp RDATA= %h, act RDATA= %h, mask= %h, curRdAddr= %h", $time, MASTER_NUM, 
												(rxLen+ MASTER_NUM + baseValue ), MASTER_RDATA, rDataMask & mask_rDataMask, curRdAddr );
									masterRdStatus 	<= 0;
									#1 $stop;
								end	

							else if ( ( ( ( (MASTER_RDATA >> shift_fixed) & rDataMask  ) & mask_rDataMask & (mask_unalign << 8*align_addr_32) )!== ( ((rxLen + MASTER_NUM + baseValue) & rDataMask & mask_rDataMask_exp ) >> shift_fixed) ) & (expRResp == 0 ) & (burstType == 2'b00)  )
								begin
									$display( "%d, MASTER %d ERROR - exp RDATA= %h, act RDATA= %h, mask= %h, exp_mask= %h, curRdAddr= %h", $time, MASTER_NUM, 
												(((rxLen+ MASTER_NUM + baseValue ) & rDataMask & mask_rDataMask_exp ) >> shift_fixed), (MASTER_RDATA  >> shift_fixed) & rDataMask & mask_rDataMask & (mask_unalign << 8*align_addr_32), rDataMask & mask_rDataMask & (mask_unalign << 8*align_addr_32), rDataMask & mask_rDataMask_exp, curRdAddr );
									masterRdStatus 	<= 0;
									#1 $stop;
								end	
								
							masterRdDone	<= 1;
							readFifRd		<= 1;				// pop open transaction
							
							d_rdCount	<= rdCount + 1'b1;
	
							rnextState	<= rstIDLE;
						end
					else if ( MASTER_RVALID & MASTER_RREADY & !MASTER_RLAST  )
						begin
							d_MASTER_RREADY	<= MASTER_RREADY_Default;
	
							d_rxLen <= rxLen + 1'b1;

		if (burstType == 2'b00) begin
			d_curRdAddr <= curRdAddr;
		end
                  else if (burstType == 2'b10) begin
                if (rxLen == (rd_to_boundary_master-1)) begin
                d_curRdAddr <= { curRdAddr[ADDR_WIDTH-1:10], (curRdAddr[9:0] & ReadAddrMaskWrap)};
                end else begin
                d_curRdAddr <= curRdAddr + (1 << burstSize);
                end
              end
		else begin
							d_curRdAddr	<= { curRdAddr[ADDR_WIDTH-1:6], (curRdAddr[5:0] & ReadAddrMask) }  + (1 << burstSize);		// aligned address 						
						end
							
							if ( readFifoEmpty )
								begin
								
									$display( "%d, MASTER %d ERROR - Read Data cycle with no Read Address Pending", $time, MASTER_NUM );
									masterRdStatus 	<= 0;
									#1 $stop;

								end	
								
							if ( transID != MASTER_RID )
								begin

									$display( "%d, MASTER %d ERROR - exp RID= %h, act RID= %h", $time, MASTER_NUM, transID, MASTER_RID );
									masterRdStatus 	<= 0;
									#1 $stop;
								end
								
							if ( MASTER_RRESP != expRResp )
								begin
									$display( "%d, MASTER %d ERROR - expRResp= %h, act RRESP= %h", $time, MASTER_NUM, 
													expRResp, MASTER_RRESP );
									masterRdStatus 	<= 0;

									#1 $stop;
							end		

							if ( ( ( MASTER_RDATA & rDataMask & mask_rDataMask )!== ( ( rxLen + MASTER_NUM + baseValue) & rDataMask & mask_rDataMask_exp ) ) & (expRResp == 0 ) & (burstType != 2'b00)  )

								begin
									$display( "%d, MASTER %d ERROR - exp RDATA= %h, act RDATA= %h, mask= %h", $time, MASTER_NUM, 
												( rxLen + MASTER_NUM + baseValue ), MASTER_RDATA, rDataMask & mask_rDataMask );
                  $display( "\t\t\trxLen: %h, d_rxLen: %h, MASTER_NUM: %h, MASTER_ARLEN: %h, burstLen: %h, rdBurstLen: %h", 
                        rxLen, d_rxLen, MASTER_NUM, MASTER_ARLEN, burstLen, rdBurstLen );
									masterRdStatus 	<= 0;
									#1 $stop;		
								end
							else if ( ( ( ( (MASTER_RDATA >> shift_fixed) & rDataMask )  & mask_rDataMask & (mask_unalign << 8*align_addr_32) )!== (( (burstLen + MASTER_NUM + baseValue) & rDataMask & mask_rDataMask_exp )  >> shift_fixed)) & (expRResp == 0 ) & (burstType == 2'b00)  )
								begin
									$display( "%d, MASTER %d ERROR - exp RDATA= %h, act RDATA= %h", $time, MASTER_NUM, 
												( (burstLen+ MASTER_NUM + baseValue ) & rDataMask & mask_rDataMask_exp) >> shift_fixed, ( ((MASTER_RDATA >> shift_fixed) & rDataMask) ) & mask_rDataMask & (mask_unalign << 8*align_addr_32) );
									masterRdStatus 	<= 0;
									#1 $stop;		
								end
								
							rnextState 		<= rstDATA;
							
						end
					else if ( MASTER_RVALID & !MASTER_RREADY  )
						begin
							d_MASTER_RREADY	<= MASTER_RREADY_Default;

							if ( readFifoEmpty )
								begin
								
									$display( "%d, MASTER %d ERROR - Read Data cycle with no Read Address Pending", $time, MASTER_NUM );
									masterRdStatus 	<= 0;
									#1 $stop;
								end	
								
							if ( transID != MASTER_RID )
								begin
									$display( "%d, MASTER %d ERROR - exp RID= %h, act RID= %h", $time, MASTER_NUM, transID, MASTER_RID );
									masterRdStatus 	<= 0;
									#1 $stop;
								
								end

							rnextState 		<= rstDATA;
							
						end
				end
		rstDATA : begin
					d_MASTER_RREADY <= 1'b1;

					#1;
					
					if ( MASTER_RVALID & MASTER_RREADY & MASTER_RLAST )		// only 1 beat
						begin
							d_MASTER_RREADY	<= MASTER_RREADY_Default;
							
							transID		= readFifRdData[READFIF_WIDTH-1: READFIF_WIDTH-ID_WIDTH];
							burstLen	= readFifRdData[READFIF_WIDTH- ID_WIDTH-ADDR_WIDTH-1: READFIF_WIDTH- ID_WIDTH- ADDR_WIDTH -8];
							
							if ( transID != MASTER_RID )
								begin
									$display( "%d, MASTER %d ERROR - exp RID= %h, act RID= %h", $time, MASTER_NUM, transID, MASTER_RID );
									masterRdStatus 	<= 0;
									#1 $stop;
									
								end
				
							if ( burstLen != rxLen )
								begin
									$display( "%d, MASTER %d ERROR - exp rxLen= %h, act rxLen= %h", $time, MASTER_NUM, burstLen, rxLen );
									masterRdStatus 	<= 0;
									#1 $stop;
									
								end	
								
							if ( MASTER_RRESP != expRResp )
								begin
									$display( "%d, MASTER %d ERROR - expRResp= %h, act RRESP= %h", $time, MASTER_NUM, 
													expRResp, MASTER_RRESP );
									masterRdStatus 	<= 0;

									#1 $stop;
							end		
							
							if ( ( ( MASTER_RDATA & rDataMask & mask_rDataMask )!== ( (rxLen + MASTER_NUM + baseValue) & rDataMask & mask_rDataMask_exp ) ) & (expRResp == 0 ) & (burstType != 2'b00) )
								begin
									$display( "%d, MASTER %d ERROR - exp RDATA= %h, act RDATA= %h, rDataMask & mask_rDataMask: %h", $time, MASTER_NUM, 
												(rxLen+ MASTER_NUM + baseValue ), MASTER_RDATA, rDataMask & mask_rDataMask );
                  $display( "\t\t\trxLen: %h, MASTER_NUM: %h, MASTER_ARLEN: %h, DATA+MASK: %h, curRdAddr:%h", 
                        rxLen, MASTER_NUM, MASTER_ARLEN,(MASTER_RDATA & rDataMask & mask_rDataMask), curRdAddr );
									masterRdStatus 	<= 0;
											#1 $stop;
								end	
							else if ( ( ( ( (MASTER_RDATA >> shift_fixed) & rDataMask )  & mask_rDataMask & (mask_unalign << 8*align_addr_32) )!== (( (rxLen + MASTER_NUM + baseValue) & rDataMask & mask_rDataMask_exp ) >> shift_fixed )) & (expRResp == 0 ) &  (burstType == 2'b00))
								begin
									$display( "%d, MASTER %d ERROR - exp RDATA= %h, act RDATA= %h, rDataMask & mask_rDataMask: %h", $time, MASTER_NUM, 
												((rxLen+ MASTER_NUM + baseValue ) >> shift_fixed), (MASTER_RDATA  >> shift_fixed), rDataMask & mask_rDataMask & (mask_unalign << 8*align_addr_32) );
                  $display( "\t\t\trxLen: %h, MASTER_NUM: %h, MASTER_ARLEN: %h, DATA+MASK: %h, curRdAddr:%h", 
                        rxLen, MASTER_NUM, MASTER_ARLEN,(MASTER_RDATA & rDataMask & mask_rDataMask & (mask_unalign << 8*align_addr_32)), curRdAddr );
									masterRdStatus 	<= 0;
											#1 $stop;
								end	

							d_rxLen 		<= 0;				// initialise for next burst

							d_curRdAddr	<= startRdAddr;
							
							readFifRd		<= 1;				// pop open transaction
							masterRdDone	<= 1;
							d_rdCount		<= rdCount + 1'b1;

							rnextState	<= rstIDLE;
						end
					else if ( MASTER_RVALID & MASTER_RREADY & !MASTER_RLAST  )
						begin
							d_MASTER_RREADY	<= MASTER_RREADY_Default;
							d_rxLen <= rxLen + 1'b1;
		if (burstType == 2'b00) begin
			d_curRdAddr <= curRdAddr;
		end
                      else if (burstType == 2'b10) begin
                if (rxLen == (rd_to_boundary_master-1)) begin
                d_curRdAddr <= { curRdAddr[ADDR_WIDTH-1:10], (curRdAddr[9:0] & ReadAddrMaskWrap)};
                end else begin
                d_curRdAddr <= curRdAddr + (1 << burstSize);
                end
              end
		else begin
              d_curRdAddr	<= { curRdAddr[ADDR_WIDTH-1:6], (curRdAddr[5:0] & ReadAddrMask) }  + (1 << burstSize);		// aligned address
      end

							if ( transID != MASTER_RID )
								begin
									$display( "%d, MASTER %d ERROR - exp RID= %h, act RID= %h", $time, MASTER_NUM, transID, MASTER_RID );
									masterRdStatus 	<= 0;
									#1 $stop;
									
								end
								
							if ( MASTER_RRESP != expRResp )
								begin
									$display( "%d, MASTER %d ERROR - expRResp= %h, act RRESP= %h", $time, MASTER_NUM, 
													expRResp, MASTER_RRESP );
									masterRdStatus 	<= 0;

									#1 $stop;
							end

							if ( ( ( MASTER_RDATA & rDataMask & mask_rDataMask )!== ( (rxLen /*MASTER_ARLEN*/ + MASTER_NUM + baseValue) & rDataMask & mask_rDataMask_exp ) ) & (expRResp == 0 ) & (burstType != 2'b00)  )
								begin
									$display( "%d, MASTER %d ERROR - exp RDATA= %h, act RDATA= %h", $time, MASTER_NUM, 
												(rxLen+ MASTER_NUM + baseValue ) & rDataMask & mask_rDataMask_exp, MASTER_RDATA & rDataMask & mask_rDataMask );
									masterRdStatus 	<= 0;
									#1 $stop;		
								end
							else if ( ( ( ( (MASTER_RDATA  >> shift_fixed) & rDataMask ) & mask_rDataMask & (mask_unalign << 8*align_addr_32) )!== ( ( (burstLen + MASTER_NUM + baseValue) & rDataMask & mask_rDataMask_exp ) >> shift_fixed ) ) & (expRResp == 0 ) & (burstType == 2'b00)  )
								begin
									$display( "%d, MASTER %d ERROR - exp RDATA= %h, act RDATA= %h", $time, MASTER_NUM, 
												((burstLen+ MASTER_NUM + baseValue ) & rDataMask & mask_rDataMask_exp ) >> shift_fixed, (MASTER_RDATA  >> shift_fixed) & rDataMask & mask_rDataMask & (mask_unalign << 8*align_addr_32) );
									masterRdStatus 	<= 0;
									#1 $stop;		
								end

							rnextState 		<= rstDATA;
							
						end
				end
	endcase
end

assign ReadAddrMask = 6'h3f << (readFifRdData[4:2]);

 always @(posedge sysClk or negedge sysReset )
 begin
	if (!sysReset)
		begin
			rcurrState 		<= rstIDLE;
			MASTER_RREADY	<= 0;
			rxLen 			<= 0;
			rdCount			<= 0;
			curRdAddr		<= 0;
		end
	else
		begin
			rcurrState 		<= rnextState;
			MASTER_RREADY	<= d_MASTER_RREADY;
			rxLen			<= d_rxLen;
			rdCount			<= d_rdCount;
			curRdAddr		<= d_curRdAddr;
		end
end


//====================================================================================================
// Local Declarationes for Master Read Address 
//====================================================================================================
reg [ID_WIDTH-1:0]        	d_MASTER_ARID;
reg [ADDR_WIDTH-1:0]      	d_MASTER_ARADDR;
reg [7:0]                 	d_MASTER_ARLEN;
reg [2:0]                 	d_MASTER_ARSIZE;
reg [2:0]                 	max_ARSIZE;
reg [1:0]                 	d_MASTER_ARBURST;
reg [1:0]                 	d_MASTER_ARLOCK;
reg [3:0]                 	d_MASTER_ARCACHE;
reg [2:0]                 	d_MASTER_ARPROT;
reg [3:0]					d_MASTER_ARREGION;
reg [3:0]                 	d_MASTER_ARQOS;		// not used
reg [USER_WIDTH-1:0]      	d_MASTER_ARUSER;
reg                       	d_MASTER_ARVALID;

reg [2:0]	arcurrState, arnextState;

localparam	[2:0]		arstIDLE = 3'h0,	arstDATA = 3'h1;

//====================================================================================================
// Master Read Address S/M
//===================================================================================================== 
 always @( * )
 begin
 
	arnextState <= arcurrState;

	d_MASTER_ARID		<= MASTER_ARID;
	d_MASTER_ARADDR		<= MASTER_ARADDR;
	d_MASTER_ARLEN		<= MASTER_ARLEN;
	d_MASTER_ARSIZE 	<= MASTER_ARSIZE;
	d_MASTER_ARBURST	<= MASTER_ARBURST;
	d_MASTER_ARLOCK		<= MASTER_ARLOCK;
	d_MASTER_ARCACHE	<= MASTER_ARCACHE;
	d_MASTER_ARPROT		<= MASTER_ARPROT;
	d_MASTER_ARREGION	<= MASTER_ARREGION;
	d_MASTER_ARQOS		<= MASTER_ARQOS;		// not used
	d_MASTER_ARUSER		<= MASTER_ARUSER;

	d_MASTER_ARVALID	<= MASTER_ARVALID;	
	
	mstRAddrIdle			<= 0;
	readFifWrData <= { MASTER_ARID, MASTER_ARADDR, MASTER_ARLEN, MASTER_ARSIZE, MASTER_ARBURST };

	readFifWr	<= 0;	

	d_arCount			<= arCount;
	masterRdAddrDone	<= 0;
	
	case( arcurrState )
		arstIDLE: begin
					mstRAddrIdle	<= 1;
			
					if ( rdStart & !readFifoFull )		// start master read address transaction
						begin
							d_MASTER_ARVALID	<= 1'b1;

							d_MASTER_ARID		<= rdAID;
							d_MASTER_ARADDR		<= rdStartAddr;				// make up data to be easy read in simulation
							d_MASTER_ARLEN 		<= rdBurstLen;

							
							max_ARSIZE 	<= 	(DATA_WIDTH == 'd16)  ? 3'h1 :
											(DATA_WIDTH == 'd32 ) ? 3'h2 :
											(DATA_WIDTH == 'd64 ) ? 3'h3 :
											(DATA_WIDTH == 'd128) ? 3'h4 :
											(DATA_WIDTH == 'd256) ? 3'h5 :
											(DATA_WIDTH == 'd512) ? 3'h6 :
														 3'bxxx;		// not supported;
														 
							if (rdASize > max_ARSIZE)
								begin
									d_MASTER_ARSIZE 	<= max_ARSIZE;
									$display( "%d, MASTER %d ERROR - requested transfer size = %h exceed data width limitation and is reset to %h", 
														$time, MASTER_NUM, rdASize, max_ARSIZE );
									#1 $stop;
								end
							else
								begin
									d_MASTER_ARSIZE 	<= rdASize;
								end
														
							d_MASTER_ARBURST	<= BurstType;	
							d_MASTER_ARLOCK		<= 0;
							d_MASTER_ARCACHE	<= 0;
							d_MASTER_ARPROT		<= 0;
							d_MASTER_ARREGION	<= 0;
							d_MASTER_ARQOS		<= 0;		// not used
							d_MASTER_ARUSER		<= 1;

							arnextState 	<= arstDATA;
						end
				end
		arstDATA : begin
					d_MASTER_ARVALID	<= 1'b1;
					readFifWrData <= { MASTER_ARID, MASTER_ARADDR, MASTER_ARLEN, MASTER_ARSIZE, MASTER_ARBURST };

					if ( MASTER_ARVALID & MASTER_ARREADY )		
						begin
						
							readFifWr			<= 1;		// push fifo 
							d_arCount			<= arCount + 1'b1;
							masterRdAddrDone	<= 1;
							
							if ( rdStart & !readFifoFull)				// if another burst request and space
								begin
									d_MASTER_ARVALID	<= 1'b1;
									
									d_MASTER_ARID		<= rdAID;
									d_MASTER_ARADDR		<= rdStartAddr;				// make up data to be easy read in simulation
									d_MASTER_ARLEN 		<= rdBurstLen;

									arnextState <= arstDATA;
								end
							else
								begin
									d_MASTER_ARVALID	<= 1'b0;
							
									arnextState <= arstIDLE;
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
			MASTER_ARVALID	<= 1'b0;

			MASTER_ARID		<= 0;
			MASTER_ARADDR	<= 0;				// make up data to be easy read in simulation
			MASTER_ARLEN 	<= 0;

			MASTER_ARSIZE 	<= 0;
			MASTER_ARBURST	<= 0;
			MASTER_ARLOCK	<= 0;
			MASTER_ARCACHE	<= 0;
			MASTER_ARPROT	<= 0;
			MASTER_ARREGION	<= 0;
			MASTER_ARQOS	<= 0;		// not used
			MASTER_ARUSER	<= 1;

			arCount			<= 0;

			arcurrState	<= arstIDLE;
		end
	else
		begin
			MASTER_ARVALID	<= d_MASTER_ARVALID;

			MASTER_ARID		<= d_MASTER_ARID;
			MASTER_ARADDR	<= d_MASTER_ARADDR;				// make up data to be easy read in simulation
			MASTER_ARLEN 	<= d_MASTER_ARLEN;

			MASTER_ARSIZE 	<= d_MASTER_ARSIZE;
			MASTER_ARBURST	<= d_MASTER_ARBURST;
			MASTER_ARLOCK	<= d_MASTER_ARLOCK;
			MASTER_ARCACHE	<= d_MASTER_ARCACHE;
			MASTER_ARPROT	<= d_MASTER_ARPROT;
			MASTER_ARREGION	<= d_MASTER_ARREGION;
			MASTER_ARQOS	<= d_MASTER_ARQOS;		// not used
			MASTER_ARUSER	<= d_MASTER_ARUSER;

			arCount			<= d_arCount;

			arcurrState	<= arnextState;
		end
end

// Different paths for simulation and synthesis
// `ifdef SIM_MODE
	// `include "../component/Actel/DirectCore/CoreAXI4Interconnect_w/2.1.3/sim/AXI4Models/Axi4MasterGen_Wr.v"
	// `include "../component/Actel/DirectCore/CoreAXI4Interconnect_w/2.1.3/sim/AXI4Models/Axi4MasterGen_WrResp.v"
// `else
	//`include "../../sim/AXI4Models/Axi4MasterGen_Wr.v"
	//`include "../../sim/AXI4Models/Axi4MasterGen_WrResp.v"
// `endif
// ********************************************************************
//  Microsemi Corporation Proprietary and Confidential
//  Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: This module provides a AXI4 Master Write test source.
//              It initialiates a Master write on Write Address channel.
//
// Revision Information:
// Date     Description:
// Feb17    Revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************
`timescale 1ns / 1ns

//================================================================================================
// Local Parameters
//================================================================================================
 
localparam	WRFIF_WIDTH = ( ID_WIDTH + ADDR_WIDTH + 8 + 3 + 2 );			// ID, Addr, LEN and SIZE, and Burst 
localparam	RESPFIF_WIDTH = ( ID_WIDTH + 2 );			// ID, Resp

  wire [4:0]   wr_addr_beat;
  wire [4:0]   wr_to_boundary_master;
   wire      [9:0]  WriteAddrMaskWrap;

wire [(DATA_WIDTH/8)-1:0] mask_strb;

wire [5:0] 			WriteAddrMask;
wire						wrfifoOverRunErr, wrfifoUnderRunErr;

reg		[WRFIF_WIDTH-1:0]			wrFifWrData;
wire	[WRFIF_WIDTH-1:0]		wrFifRdData;
reg		[WRFIF_WIDTH-1:0]			wrFifRdDataHold;

reg							wrFifWr, wrFifRd;
wire						wrFifoFull, wrFifoEmpty, wrFifoOneAvail;

reg							respFifWr, respFifRd;
wire						respFifoFull, respFifoEmpty;

wire	[RESPFIF_WIDTH-1:0]	respFifRdData;
wire	[RESPFIF_WIDTH-1:0]	respFifWrData;	

reg		[ID_WIDTH-1:0]		respWID, d_respWID;
reg		[ADDR_WIDTH-1:0]	d_masterWrAddr, masterWrAddr;			// used to track address being sent out.

 //===========================================================================================
 // FIFO to hold open transactions - pushed on Address Read cycle and popped on write data
 // cycle.
 //===========================================================================================
 caxi4interconnect_FifoDualPort #(	.FIFO_AWIDTH( OPENTRANS_MAX ),
					.FIFO_WIDTH( WRFIF_WIDTH ),
					.HI_FREQ( HI_FREQ ),
					.NEAR_FULL ( 'd2 )
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
					.fifoOneAvail( wrFifoOneAvail ),
					.fifoRdValid(	),
					.fifoFull( wrFifoFull ),
					.fifoNearFull(	),
					.fifoOverRunErr( wrfifoOverRunErr ),
					.fifoUnderRunErr( wrfifoUnderRunErr )
					 
				);

assign mstWrAddrFull = wrFifoFull;


//===========================================================================================
// Storage latch for data cycle to be processed
//===========================================================================================
always @(posedge sysClk or	negedge sysReset )
begin
	
	if ( !sysReset )
		begin
			wrFifRdDataHold	<= 0;
		end
	else if ( wrFifRd )
		begin
			wrFifRdDataHold	<= wrFifRdData;
		end
end


//===========================================================================================
 // FIFO to hold open transactions - pushed on Write Data cycle and popped on write response
 // cycle.
 //===========================================================================================				
	caxi4interconnect_FifoDualPort #(	.FIFO_AWIDTH( OPENTRANS_MAX ),
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
					.fifoOneAvail(		 ),
					.fifoRdValid(	),
					.fifoFull( respFifoFull ),
					.fifoNearFull(	),
					.fifoOverRunErr( respFifoOverRunErr ),
					.fifoUnderRunErr( respFifoUnderRunErr )
					 
				);

				
assign 	respFifWrData = { respWID, expWResp };


//====================================================================================================
// Local Declarationes for Master Write Address 
//====================================================================================================

localparam	[2:0]		wstIDLE = 3'h0,	wstDATA = 3'h1;

reg [(DATA_WIDTH/8)-1:0]	 	d_MASTER_WSTRB;
reg 												d_MASTER_WLAST, d_MASTER_WVALID;
reg [USER_WIDTH-1:0]				d_MASTER_WUSER;

reg [2:0]				wcurrState, wnextState;

reg	[DATA_WIDTH-1:0]	d_txLen, txLen;

reg [15:0]				txCount, d_txCount;
reg [15:0]				awCount, d_awCount;

wire [7:0]				curTxLen, curTxLenHold;
wire [ID_WIDTH-1:0]		curWID, curWIDHold;


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
	
			if ( MASTER_AWVALID )
				begin
					#1 $display( "%d, MASTER %d - Starting Write Address Transaction %d, AWADDR= %h, AWBURST= %h, AWSIZE= %h, WID= %h, AWLEN= %d", 
											$time, MASTER_NUM, awCount, MASTER_AWADDR, MASTER_AWBURST, MASTER_AWSIZE, MASTER_AWID, MASTER_AWLEN );

					if ( MASTER_AWREADY )		// single beat
						begin
							#1 $display( "%d, MASTER %d - Ending Write Address Transaction %d, WID= %h, AWLEN= %d", 
											$time, MASTER_NUM, awCount, MASTER_AWID, MASTER_AWLEN );
						end
					else
						begin
							@( posedge MASTER_AWREADY )
								#1 $display( "%d, MASTER %d - Ending Write Address Transaction %d, WID= %h, AWLEN= %d", 
											$time, MASTER_NUM, awCount, MASTER_AWID, MASTER_AWLEN );
						end
				end
		end	


	//=============================================================================================
	// Display messages for Write Data Channel
	//=============================================================================================
	always @( negedge sysClk )
		begin
			#1;
	
			if ( MASTER_WVALID )
				begin
					#1 $display( "%d, MASTER %d - Starting Write Data Transaction %d, WADDR= %h (%d), WID= %h, TXLEN= %d, WSTRB= %h", 
										$time, MASTER_NUM, txCount, masterWrAddr, masterWrAddr, curWIDHold, curTxLenHold, MASTER_WSTRB );

					if ( MASTER_WLAST &	MASTER_WVALID & MASTER_WREADY )		// single beat
						begin
							#1 $display( "%d, MASTER %d - Ending Write Data Transaction %d, WID= %h, TXLEN= %d", 
										$time, MASTER_NUM, txCount, curWIDHold, txLen );
						end
					else
						begin
							@( posedge ( MASTER_WLAST &	MASTER_WVALID & MASTER_WREADY )	)
								#1 $display( "%d, MASTER %d - Ending Write Data Transaction %d, WID= %h, TXLEN= %d", 
										$time, MASTER_NUM, txCount, curWIDHold, txLen );
						end
				end
		end

`ifdef VERBOSE
	//=============================================================================================
	// Display Write Data
	//=============================================================================================
	always @( negedge sysClk )
		begin
			#1;

			if ( MASTER_WVALID & MASTER_WREADY )
				begin
					#1 $display( "%t, MASTER %d - ADDR= %h (%d), WDATA= %d, WSTRB= %h", 
										$time, MASTER_NUM, masterWrAddr, masterWrAddr, MASTER_WDATA, MASTER_WSTRB );
				end
		end		
`endif

`endif


assign	curTxLen 			= wrFifRdData[12:5];										// pick out txLen from FIFO data
assign	curTxLenHold	= wrFifRdDataHold[12:5];								// pick out txLen from Hold data

assign	curWID				= wrFifRdData[WRFIF_WIDTH-1:WRFIF_WIDTH-ID_WIDTH];				// pick out WID from FIFO data
assign	curWIDHold		= wrFifRdDataHold[WRFIF_WIDTH-1:WRFIF_WIDTH-ID_WIDTH];		// pick out WID from Hold data

wire	[ADDR_WIDTH-1:0]	wDStartAddr;
wire	[2:0]							wD_AWSIZE, repMultip;
reg		[2:0]							wD_AWSIZE_next, wD_AWSIZE_reg;
wire	[1:0]							wD_AWBURST;
 
assign repMultip		= (1 << wD_AWSIZE);
assign wDStartAddr	= wrFifRdData[WRFIF_WIDTH-ID_WIDTH-1:WRFIF_WIDTH-ID_WIDTH-ADDR_WIDTH]; 
assign wD_AWSIZE		= wrFifRdData[4:2];
assign wD_AWBURST	 	= wrFifRdData[1:0];

assign WriteAddrMask = (6'h3f << wD_AWSIZE_reg);
assign WriteAddrMaskWrap = (10'h3ff << $clog2((wrBurstLen+1) * ( 1 << wrASize )));

  assign wr_addr_beat = wrStartAddr[wrASize+:4] & wrBurstLen;
  assign wr_to_boundary_master = (wrBurstLen + 1) - wr_addr_beat;

//====================================================================================================
// Master Data S/M
//===================================================================================================== 
 always @( * )
 begin
 
	wnextState 		<= wcurrState;
	masterWrDone	<= 0;
	wrFifRd			<= 0;
	respFifWr		<= 0;

	d_MASTER_WUSER	<= MASTER_WUSER;

	d_MASTER_WLAST	<= 0;
	d_MASTER_WVALID	<= 0;

	d_txCount	<= txCount;

	d_respWID	<= respWID;

	d_txLen 	<= txLen;
	d_masterWrAddr <= masterWrAddr;
	wD_AWSIZE_next <= wD_AWSIZE_reg;

	case( wcurrState )
		wstIDLE: begin
					d_respWID	<= 0;
					d_respWID	<= wrFifRdData[WRFIF_WIDTH-1: WRFIF_WIDTH- ID_WIDTH];

					if ( wrFifoEmpty )
						begin
							d_txLen 		<= 0;
							d_MASTER_WUSER 	<= 0;
						end
					else if ( ~wrFifoEmpty )
						begin
							d_MASTER_WVALID	<= 1;
							d_MASTER_WLAST	<= ( curTxLen == 0 );		// only 1-beat

							d_masterWrAddr <= wDStartAddr;
							wD_AWSIZE_next <= wD_AWSIZE;

							wAddrMask <= (wDStartAddr[5:0] & ((DATA_WIDTH/8)-1)) >> wD_AWSIZE;
							d_MASTER_WUSER	<= 0;

							wrFifRd			<= 1;						// pop fifo - use hold for current cycle.
							
							wnextState	<= wstDATA;
						end
				end
		wstDATA : begin
					
					d_respWID	<= wrFifRdDataHold[WRFIF_WIDTH-1: WRFIF_WIDTH- ID_WIDTH];
				
					d_MASTER_WVALID	<= 1;
					d_MASTER_WLAST	<= MASTER_WLAST;		// only if set until VALID/READY Seen
					wAddrMask <= ((masterWrAddr+wD_AWSIZE*(txLen+1)) & ((DATA_WIDTH/8)-1)) >> wD_AWSIZE;

					if ( MASTER_WREADY & MASTER_WVALID & MASTER_WLAST)
						begin

							masterWrDone	<= 1;
							respFifWr		<= 1;

							d_MASTER_WUSER	<= 0;

							d_txLen		<= 0;
							d_txCount 	<= txLen + 1;

							if (~wrFifoEmpty)		// another data transaction available
								begin
									d_MASTER_WLAST	<= ( curTxLen == 0 );		
									d_MASTER_WVALID	<= 1;

									d_masterWrAddr <= wDStartAddr;

									d_respWID			<= wrFifRdData[WRFIF_WIDTH-1: WRFIF_WIDTH- ID_WIDTH];
									wrFifRd				<= 1;			// pop entry - next entry is in hold
									wnextState		<= wstDATA;
								end
							else					// no other entries to handle
								begin
									d_MASTER_WLAST	<= 0;		
									d_MASTER_WVALID	<= 0;
									d_respWID		<= wrFifRdDataHold[WRFIF_WIDTH-1: WRFIF_WIDTH- ID_WIDTH];
									wrFifRd			<= 0;

									wnextState	<= wstIDLE;
								end
						end
					else if ( MASTER_WREADY & MASTER_WVALID & ~MASTER_WLAST)
						begin
							d_txCount 	<= txLen + 1;
							d_txLen			<= txLen + 1;
							if (MASTER_AWBURST == 2'b00) begin
							 	d_masterWrAddr <= masterWrAddr;
							end
              else if (MASTER_AWBURST == 2'b10) begin
                if (txLen == (wr_to_boundary_master-1)) begin
                d_masterWrAddr <= { masterWrAddr[ADDR_WIDTH-1:10], (masterWrAddr[9:0] & WriteAddrMaskWrap)};
                end else begin
                d_masterWrAddr <= masterWrAddr + (1 << wD_AWSIZE_reg);
                end
              end
							else begin
								d_masterWrAddr <= { masterWrAddr[ADDR_WIDTH-1:6], (masterWrAddr[5:0] & WriteAddrMask) } + (1 << wD_AWSIZE_reg);
							end

							if ( (curTxLenHold -1'b1) == txLen[7:0] ) 		// last beat
								begin
									d_MASTER_WLAST	<= 1;
									wnextState	<= wstDATA;
								end
							else
								begin
									d_MASTER_WUSER	<= MASTER_WUSER -1'b1;		// rotate
									wnextState	<= wstDATA;
								end
						end
					end
	endcase
end

always @(*)
begin	
		//==============================================================
		// Set WSTRB bits based on alignment - just for startAddress
		//==============================================================
		// The below case statement(DATA_WIDTH) allows the strobes to be applied properly. The size of the bus determines the
		// max transfer size
			case (DATA_WIDTH)
			// The case statement (MASTER_AWSIZE) applies a strobe on a 'per-byte' basis. The strobe is set the the correct size, 
			// depending on the transfer size, and is then shifted by the apptoptiate number of bytes.
			'd32 :	case(wD_AWSIZE_next)
							 3'b000 : d_MASTER_WSTRB	<= 4'h1 << (d_masterWrAddr[1:0]);
							 3'b001 : d_MASTER_WSTRB	<= 4'h3 << 2*(d_masterWrAddr[1]);
							 3'b010 : d_MASTER_WSTRB	<= 4'hF;														 // No shift as size = data width
							endcase
			'd64 :	case(wD_AWSIZE_next)
							 3'b000 : d_MASTER_WSTRB	<= 8'h1 << (d_masterWrAddr[2:0]);
							 3'b001 : d_MASTER_WSTRB	<= 8'h3 << 2*(d_masterWrAddr[2:1]);
							 3'b010 : d_MASTER_WSTRB	<= 8'hF << 4*(d_masterWrAddr[2]);
							 3'b011 : d_MASTER_WSTRB	<= 8'hFF;														// No shift as size = data width
							endcase
			'd128 : case(wD_AWSIZE_next)
							 3'b000 : d_MASTER_WSTRB	<= 16'h1 << (d_masterWrAddr[3:0]);
							 3'b001 : d_MASTER_WSTRB	<= 16'h3 << 2*(d_masterWrAddr[3:1]);
							 3'b010 : d_MASTER_WSTRB	<= 16'hF << 4*(d_masterWrAddr[3:2]);
							 3'b011 : d_MASTER_WSTRB	<= 16'hFF << 8*(d_masterWrAddr[3]);
							 3'b100 : d_MASTER_WSTRB	<= 16'hFFFF;													// No shift as size = data width
							endcase
			'd256 : case(wD_AWSIZE_next)
							 3'b000 : d_MASTER_WSTRB	<= 32'h1 << (d_masterWrAddr[4:0]);
							 3'b001 : d_MASTER_WSTRB	<= 32'h3 << 2*(d_masterWrAddr[4:1]);
							 3'b010 : d_MASTER_WSTRB	<= 32'hF << 4*(d_masterWrAddr[4:2]);
							 3'b011 : d_MASTER_WSTRB	<= 32'hFF << 8*(d_masterWrAddr[4:3]);
							 3'b100 : d_MASTER_WSTRB	<= 32'hFFFF << 16*(d_masterWrAddr[4]);
							 3'b101 : d_MASTER_WSTRB	<= 32'hFFFF_FFFF;										 // No shift as size = data width
							endcase
			'd512 : case(wD_AWSIZE_next)
							 3'b000 : d_MASTER_WSTRB	<= 64'h1 << (d_masterWrAddr[5:0]);
							 3'b001 : d_MASTER_WSTRB	<= 64'h3 << 2*(d_masterWrAddr[5:1]);
							 3'b010 : d_MASTER_WSTRB	<= 64'hF << 4*(d_masterWrAddr[5:2]);
							 3'b011 : d_MASTER_WSTRB	<= 64'hFF << 8*(d_masterWrAddr[5:3]);
							 3'b100 : d_MASTER_WSTRB	<= 64'hFFFF << 16*(d_masterWrAddr[5:4]);
							 3'b101 : d_MASTER_WSTRB	<= 64'hFFFF_FFFF << 32*(d_masterWrAddr[5]);
							 3'b110 : d_MASTER_WSTRB	<= 64'hFFFF_FFFF_FFFF_FFFF;					 // No shift as size = data width
							endcase
			endcase

end


always @(posedge sysClk or negedge sysReset )
 begin
 
	if (!sysReset)
		begin
			wcurrState 	<= wstIDLE;

			txLen 		<= 0;
			txCount		<= 0;

			MASTER_WVALID	<= 0;
			MASTER_WID   	<= 0;
			MASTER_WDATA	<= 0;
			MASTER_WSTRB	<= 0;
			MASTER_WUSER	<= 0;
			MASTER_WLAST	<= 0;

			respWID	<= 0;
			masterWrAddr	<= 0;

			wD_AWSIZE_reg <= 3'h0;

		end
	else
		begin
			wcurrState	<= wnextState;

			txLen			<= d_txLen;
			txCount 	<= d_txCount;

			wD_AWSIZE_reg <= wD_AWSIZE_next;

			MASTER_WVALID	<= d_MASTER_WVALID;
			MASTER_WDATA	<= d_txLen + MASTER_NUM + baseValue;				// have all Master use a unique sequence
			MASTER_WLAST	<= d_MASTER_WLAST;
			MASTER_WSTRB	<= d_MASTER_WSTRB & mask_strb;
			MASTER_WUSER	<= d_MASTER_WUSER;

			respWID				<= d_respWID;
			masterWrAddr	<= d_masterWrAddr;
		end
end

assign mask_strb = ~((1 << (d_masterWrAddr[5:0] & ((DATA_WIDTH/8)-1)))-1);

//====================================================================================================
// Local Declarationes for Master Write Address 
//====================================================================================================
reg [ID_WIDTH-1:0]					d_MASTER_AWID;
reg [ADDR_WIDTH-1:0]				d_MASTER_AWADDR;
reg [7:0]								 		d_MASTER_AWLEN;
reg [2:0]								 		d_MASTER_AWSIZE;
reg [2:0]								 		max_AWSIZE;
reg [1:0]								 		d_MASTER_AWBURST;
reg [1:0]								 		d_MASTER_AWLOCK;
reg [3:0]								 		d_MASTER_AWCACHE;
reg [2:0]									 	d_MASTER_AWPROT;
reg [3:0]										d_MASTER_AWREGION;
reg [3:0]								 		d_MASTER_AWQOS;		// not used
reg [USER_WIDTH-1:0]				d_MASTER_AWUSER;
reg												 	d_MASTER_AWVALID;

reg [2:0]										awcurrState, awnextState;

localparam	[2:0]	 awstIDLE = 3'h0,	awstDATA = 3'h1;

//=====================================================================================================
// Master Write Address S/M
//=====================================================================================================
always @( * )
 begin

	awnextState <= awcurrState;

	d_MASTER_AWID			<= MASTER_AWID;
	d_MASTER_AWADDR		<= MASTER_AWADDR;
	d_MASTER_AWLEN		<= MASTER_AWLEN;
	d_MASTER_AWSIZE 	<= MASTER_AWSIZE;
	d_MASTER_AWBURST	<= MASTER_AWBURST;
	d_MASTER_AWLOCK		<= MASTER_AWLOCK;
	d_MASTER_AWCACHE	<= MASTER_AWCACHE;
	d_MASTER_AWPROT		<= MASTER_AWPROT;
	d_MASTER_AWREGION	<= MASTER_AWREGION;
	d_MASTER_AWQOS		<= MASTER_AWQOS;		// not used
	d_MASTER_AWUSER		<= MASTER_AWUSER;
	d_MASTER_AWVALID	<= MASTER_AWVALID;	

	mstWAddrIdle	<= 0;
	wrFifWr				<= 0;

	masterWrAddrDone	<= 0;
	if (wrASize > MASTER_ASIZE_DEFAULT)
		begin
			max_AWSIZE <= MASTER_ASIZE_DEFAULT;
			$display( "%d, MASTER %d ERROR - requested transfer size exceed data width limitation and is reset to %b", $time, MASTER_NUM, MASTER_ASIZE_DEFAULT );
		end
	else
		begin
			max_AWSIZE <= wrASize;
		end

	wrFifWrData <= { wrAID, wrStartAddr, wrBurstLen, max_AWSIZE, BurstType };

	d_awCount	<= awCount;

	case( awcurrState )
		awstIDLE: begin
					mstWAddrIdle			<= 1;

					if ( wrStart & !wrFifoFull )						// start write address transaction
						begin
							d_MASTER_AWVALID	<= 1'b1;

							d_MASTER_AWID			<= wrAID;
							d_MASTER_AWADDR		<= wrStartAddr;			// make up data to be easy read in simulation
							d_MASTER_AWLEN 		<= wrBurstLen;
							d_MASTER_AWSIZE 	<= max_AWSIZE;
							d_MASTER_AWBURST	<= BurstType;
							d_MASTER_AWLOCK		<= 0;
							d_MASTER_AWCACHE	<= 0;
							d_MASTER_AWPROT		<= 0;
							d_MASTER_AWREGION	<= 0;
							d_MASTER_AWQOS		<= 0;		// not used
							d_MASTER_AWUSER		<= 1;

							awnextState <= awstDATA;
							
							//========================================================================================
							// Initiate Write Channel early if MASTER_WREADY_Default asserted - ie do not wait
							// till Write Address transactioon completed.
							//=========================================================================================
							if ( MASTER_WREADY_Default )
								begin
									wrFifWr		<= 1;		// push fifo 
								end
						end
				end
		awstDATA : begin
					d_MASTER_AWVALID	<= 1'b1;

					if ( MASTER_AWVALID & MASTER_AWREADY )
						begin
						
							masterWrAddrDone <= 1'b1;
							d_awCount	<= awCount + 1'b1;

							//========================================================================================
							// Initiate Write Channel if MASTER_WREADY_Default not asserted - ie start write data
							// after Write Address transactioon completed.
							//=========================================================================================
							if ( ~MASTER_WREADY_Default )
								begin
									wrFifWr		<= 1;		// push fifo 
								end

							if ( wrStart & !wrFifoFull)				// if another burst request and space
								begin
									d_MASTER_AWVALID	<= 1'b1;
									d_MASTER_AWID			<= wrAID;
									d_MASTER_AWADDR		<= wrStartAddr;				// make up data to be easy read in simulation
									d_MASTER_AWLEN 		<= wrBurstLen;
									d_MASTER_AWSIZE 	<= max_AWSIZE;

									awnextState <= awstDATA;

									//========================================================================================
									// Initiate Write Channel early if MASTER_WREADY_Default asserted - ie do not wait
									// till Write Address transactioon completed.
									//=========================================================================================
									if ( MASTER_WREADY_Default )
										begin
											wrFifWrData <= { wrAID, wrStartAddr, wrBurstLen, max_AWSIZE, BurstType };
											wrFifWr			<= 1;		// push fifo 
										end
								end
							else
								begin
									d_MASTER_AWVALID	<= 1'b0;
									awnextState				<= awstIDLE;
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
			MASTER_AWVALID	<= 1'b0;

			MASTER_AWID	  	<= 0;
			MASTER_AWADDR 	<= 0;				// make up data to be easy read in simulation
			MASTER_AWLEN  	<= 0;
			MASTER_AWSIZE 	<= 0;
			MASTER_AWBURST	<= 0;
			MASTER_AWLOCK 	<= 0;
			MASTER_AWCACHE	<= 0;
			MASTER_AWPROT 	<= 0;
			MASTER_AWREGION	<= 0;
			MASTER_AWQOS	  <= 0;		// not used
			MASTER_AWUSER 	<= 0;

			awCount			<= 0;

			awcurrState	<= awstIDLE;
		end
	else
		begin
			MASTER_AWVALID	<= d_MASTER_AWVALID;

			MASTER_AWID	<= d_MASTER_AWID;
			MASTER_AWADDR	<= d_MASTER_AWADDR;				// make up data to be easy read in simulation
			MASTER_AWLEN 	<= d_MASTER_AWLEN;
			MASTER_AWSIZE 	<= d_MASTER_AWSIZE;
			MASTER_AWBURST	<= d_MASTER_AWBURST;
			MASTER_AWLOCK	<= d_MASTER_AWLOCK;
			MASTER_AWCACHE	<= d_MASTER_AWCACHE;
			MASTER_AWPROT 	<= d_MASTER_AWPROT;
			MASTER_AWREGION	<= d_MASTER_AWREGION;
			MASTER_AWQOS	<= d_MASTER_AWQOS;		// not used
			MASTER_AWUSER   <= d_MASTER_AWUSER;

			awCount		<= d_awCount;
			
			awcurrState	<= awnextState;
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
// Description: This module provides a AXI4 Master write response channel.
//
// Revision Information:
// Date     Description:
// Feb17    Revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************
`timescale 1ns / 1ns

//====================================================================================================
// Local Declarationes for Master Write Response Channel 
//====================================================================================================

localparam	[2:0]		bstIDLE = 3'h0,	bstDATA = 3'h1;

reg						d_MASTER_BREADY, bIdle;

reg [2:0]				bcurrState, bnextState;

reg	[15:0]				respCount, d_respCount;


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
	
			if ( MASTER_BVALID )
				begin
					#1 $display( "%d, MASTER %d - Starting Write Response Transaction %d, BID= %h, BRESP= %h", 
										$time, MASTER_NUM, respCount, MASTER_BID, MASTER_BRESP );

					if ( MASTER_BREADY & MASTER_BVALID)		// single beat
						begin
							#1 $display( "%d, MASTER %d - Ending Write Response Transaction %d, BID= %h, wrStatus= %b", 
										$time, MASTER_NUM, respCount, MASTER_BID, masterWrStatus );
						end
					else
						begin
							@( posedge ( MASTER_BREADY & MASTER_BVALID) )
								#1 $display( "%d, MASTER %d - Ending Write Response Transaction %d, BID= %h, wrStatus= %b", 
										$time, MASTER_NUM, respCount, MASTER_BID, masterWrStatus );
						end
				end
		end

	// Check BResp is as expected
	always @( posedge sysClk )
		begin
			#1;		
			
			if ( MASTER_BREADY & MASTER_BVALID)		// single beat
				if ( MASTER_BRESP != respFifRdData[RESPFIF_WIDTH-ID_WIDTH-1: 0] )
					begin
						$display( "%d, MASTER %d ERROR - expWResp= %h, act BRESP= %h", $time, MASTER_NUM, 
											respFifRdData[RESPFIF_WIDTH-ID_WIDTH-1: 0], MASTER_BRESP );

						#1 $stop;
					end		
		end
		
`endif



//====================================================================================================
// Master Write Response S/M
//===================================================================================================== 
 always @( * )
 begin
 
	bnextState <= bcurrState;

	//d_MASTER_BREADY	<= MASTER_BREADY;	
	d_MASTER_BREADY	<= d_MASTER_BREADY_default;	
	
	bIdle	 	<= 0;
	respFifRd	<= 0;
	masterRespDone  <= 0;
	masterWrStatus	<= 0;

	d_respCount <= respCount;		// running counter of number of responses completed
	
	case( bcurrState )
		bstIDLE: begin
					bIdle	<= 1;
			
					d_MASTER_BREADY		<= d_MASTER_BREADY_default;
			
					if ( MASTER_BVALID & MASTER_BREADY )	
						begin
							bIdle		<= 0;

							masterWrStatus <= 	( 	( MASTER_BID ==  respFifRdData[RESPFIF_WIDTH-1: RESPFIF_WIDTH-ID_WIDTH]   	)
												  & ( MASTER_BRESP == respFifRdData[RESPFIF_WIDTH-ID_WIDTH-1: 0]   				)
												);
							masterRespDone  <= 1;
							respFifRd		<= 1'b1;

							d_respCount <= respCount + 1'b1;
							
						end
					else if ( MASTER_BVALID & !MASTER_BREADY )		// move to assert ready
						begin
							d_MASTER_BREADY	<= 1'b1;
							bnextState 	<= bstDATA;
						end
				end
		bstDATA : begin
					bIdle				<= 0;
					d_MASTER_BREADY		<= 1'b1;
			
					if ( MASTER_BVALID & MASTER_BREADY )	
						begin
							
							masterWrStatus <= 	( 	( MASTER_BID ==  respFifRdData[RESPFIF_WIDTH-1: RESPFIF_WIDTH-ID_WIDTH]   	)
												  & ( MASTER_BRESP == respFifRdData[RESPFIF_WIDTH-ID_WIDTH-1: 0]   				)
												);
												
							masterRespDone  <= 1;
							respFifRd		<= 1'b1;

							d_respCount <= respCount + 1'b1;
					
							d_MASTER_BREADY	<= d_MASTER_BREADY_default;
							
							bnextState 	<= bstIDLE;
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
			MASTER_BREADY	<= 1'b0;
			bcurrState		<= bstIDLE;
			respCount		<= 0;

		end
	else
		begin
			MASTER_BREADY	<= d_MASTER_BREADY;

			bcurrState		<= bnextState;
			
			respCount		<= d_respCount;

		end
end

		
		
 // Axi4MasterGen_WrResp.v
		
endmodule // Axi4MasterGen.v
