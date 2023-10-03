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
//     Abstract  : This module controls provides a default slave for decode errors. It performs the
//                 read/write transactions returning DECODE Error in read/write responses.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_DERR_Slave # 
	(
		parameter integer ID_WIDTH   			= 1, 				// includes infrastrucre ID
		parameter integer DATA_WIDTH			= 32,
		parameter integer USER_WIDTH			= 4,
		parameter [1:0]	  RESP_CODE				= 2'b11
	)
	(
		// Global Signals
		input  wire                                       	sysClk,
		input  wire                                        	sysReset,			// active low reset synchronoise to RE AClk - asserted async.
   
		//====================== Read Address Ports  ================================================//
		input  wire [ID_WIDTH-1:0]        	   				DERR_ARID,
		input  wire [7:0]   	                       		DERR_ARLEN,
		input  wire 	                            		DERR_ARVALID,
		output reg	 		                           		DERR_ARREADY,

		//====================== Read Data Ports  ================================================//
  		output  wire [ID_WIDTH-1:0] 						DERR_RID,
		output  wire [DATA_WIDTH-1:0]    					DERR_RDATA,
		output  wire [1:0]                         			DERR_RRESP,
		output  reg 	                           			DERR_RLAST,
		output  wire [USER_WIDTH-1:0]         				DERR_RUSER,
		output  reg                           				DERR_RVALID,		
		input wire		                           			DERR_RREADY,
		
		//====================== Write  Address Ports  ================================================//
		input  wire [ID_WIDTH-1:0]        	   				DERR_AWID,
		input  wire [7:0]   	                       		DERR_AWLEN,
		input  wire 	                            		DERR_AWVALID,
		output reg	 		                           		DERR_AWREADY,

		//====================== Write  Data Ports  ================================================//
		input  wire [ID_WIDTH-1:0]                          DERR_WID,
		input  wire [DATA_WIDTH-1:0]    					DERR_WDATA,
		input  wire [(DATA_WIDTH/8)-1:0]               		DERR_WSTRB,
		input  wire                            				DERR_WLAST,
		input  wire [USER_WIDTH-1:0]         				DERR_WUSER,
		input  wire                            				DERR_WVALID,
		
		output reg		                          			DERR_WREADY,
		
		//====================== Write Resp Ports  ================================================//
		output  wire [ID_WIDTH-1:0] 						DERR_BID,
		output  wire [1:0]                         			DERR_BRESP,
		output  wire [USER_WIDTH-1:0]         				DERR_BUSER,
		output  reg 	                           			DERR_BVALID,
		input   wire 					               		DERR_BREADY
		  
   
	);
   						 
						 
//================================================================================================
// Local Parameters
//================================================================================================

localparam [2:0]		aIDLE    	 = 3'h0,
        		        aREAD_LAT	 = 3'h1,
						aARREADY_CYC = 3'h2,
						aWRITE_LAT	 = 3'h3,
						aAWREADY_CYC = 3'h4,
						wWRITE_DAT   = 3'h5,
						wRESP_ST	 = 3'h6,
						rREAD_DAT 	 = 3'h7;
									

reg [2:0]		currState, nextState;

reg				readLat, writeLat;
reg				d_DERR_ARREADY, d_DERR_AWREADY;
reg				d_DERR_RLAST, d_DERR_RVALID, d_DERR_WREADY, d_DERR_BVALID;

reg [ID_WIDTH-1:0]	readID, writeID;
reg [7:0]   	    readLen, rxCount, d_rxCount;

wire [31:0]			devRevision;


//========================================================================================================
// caxi4interconnect_revision data - to be read back as Data
//========================================================================================================
caxi4interconnect_revision rev ( devRevision );

//========================================================================================================
// Read/Write address channel 
//========================================================================================================
always @(*)
	begin
	
		d_DERR_ARREADY 	<= 0;
		d_DERR_AWREADY	<= 0;

		d_DERR_WREADY	<= 0;
		d_DERR_BVALID	<= 0;
		d_DERR_RLAST	<= 0;
		d_DERR_RVALID	<= 0;
		
		readLat 	<= 0;
		writeLat	<= 0;
		
		d_rxCount	<= rxCount;
		
		nextState	<= currState;
		
		case( currState )
			aIDLE:
				begin
					
					if ( DERR_ARVALID )
						begin
							nextState <= aREAD_LAT;
						end
					else if ( DERR_AWVALID )
						begin
							nextState <= aWRITE_LAT;
						end
				end
			aREAD_LAT:
				begin
					readLat	<= 1;

					d_DERR_ARREADY	<= 1'b1;
					
					nextState <= aARREADY_CYC;

				end
			aARREADY_CYC:
				begin
					d_rxCount	<= 0;

					nextState <= rREAD_DAT;
				end
			aWRITE_LAT:
				begin
					writeLat	<= 1;

					d_DERR_AWREADY	<= 1'b1;
					
					nextState <= aAWREADY_CYC;

				end
			aAWREADY_CYC:
				begin
					nextState <= wWRITE_DAT;
				end
			wWRITE_DAT:	
				begin
					d_DERR_WREADY	<= 1'b1;
					
					if ( DERR_WVALID & DERR_WREADY & DERR_WLAST )
						begin
							d_DERR_WREADY	<= 1'b0;
							nextState 		<= wRESP_ST;
						end
				end
			wRESP_ST:	
				begin
					d_DERR_BVALID	<= 1'b1;

					if ( DERR_BVALID & DERR_BREADY )
						begin

							d_DERR_BVALID	<= 1'b0;
							nextState 		<= aIDLE;
						end
				end
			rREAD_DAT:
				begin
					d_DERR_RVALID	<= 1'b1;
					d_DERR_RLAST	<= ( readLen == 0 ) ? 1'b1 
														: ( ( rxCount == (readLen -1'b1)  ) & DERR_RVALID & DERR_RREADY );
					
					if ( DERR_RVALID & DERR_RREADY & DERR_RLAST )
						begin	

							d_DERR_RVALID	<= 1'b0;
							d_DERR_RLAST	<= 1'b0;
							nextState 		<= aIDLE;
						end					
					else if ( DERR_RVALID & DERR_RREADY & !DERR_RLAST )
						begin
							d_rxCount	<= rxCount + 1'b1;
							nextState 	<= rREAD_DAT;
						end										
				
				end
			default:
				begin
					readLat		<= 1'bx;
					writeLat	<= 1'bx;

					d_rxCount		<= 8'bxxxx_xxxx;
					d_DERR_RLAST	<= 1'bx;
					d_DERR_ARREADY 	<= 1'bx;
					d_DERR_AWREADY	<= 1'bx;
					d_DERR_RVALID	<= 1'bx;

					d_DERR_WREADY	<= 1'bx;
					d_DERR_BVALID	<= 1'bx;
					
					nextState <= 3'bxxx;	
				end
				
		endcase
		
	end

	
always @(posedge sysClk or negedge sysReset )
	begin
	
		if ( !sysReset )
			begin
				currState <= aIDLE;
				
				DERR_RLAST		<= 1'b0;
				DERR_ARREADY 	<= 1'b0;
				DERR_AWREADY	<= 1'b0;
				DERR_RVALID		<= 1'b0;

				DERR_WREADY		<= 1'b0;
				DERR_BVALID		<= 1'b0;				
				
				rxCount			<= 0;
				
			end
		else
			begin
				currState <= nextState;

				DERR_RLAST		<= d_DERR_RLAST;
				DERR_ARREADY 	<= d_DERR_ARREADY;
				DERR_AWREADY	<= d_DERR_AWREADY;
				DERR_RVALID		<= d_DERR_RVALID;

				DERR_WREADY		<= d_DERR_WREADY;
				DERR_BVALID		<= d_DERR_BVALID;		
				
				rxCount		<= d_rxCount;
				
			end
			
	end



//============================================================================
// Latch Read Length and ID
//============================================================================
always @(posedge sysClk or negedge sysReset )
begin
	if (!sysReset)
		begin
			readLen 	<= 0;
			readID		<= 0;
		end
	else
		if (readLat)
			begin
				readLen <= DERR_ARLEN;
				readID	<= DERR_ARID;
			end
end



//============================================================================
// Latch Write Length and ID
//============================================================================
always @(posedge sysClk or negedge sysReset )
begin
	if (!sysReset)
		begin
			writeID		<= 0;
		end
	else
		if (writeLat)
			begin
				writeID	 <= DERR_AWID;
			end
end


	
//====================== Read Ports  ======================================================//
assign DERR_RID		= readID;
assign DERR_RDATA	= devRevision;			// send back caxi4interconnect_revision as read data.
assign DERR_RRESP	= RESP_CODE;		
assign DERR_RUSER	= 0;

		
//====================== Write Resp Ports  ================================================//
assign DERR_BID			= writeID;
assign DERR_BRESP		= RESP_CODE;			
assign DERR_BUSER		= 0;
		  
	
	
endmodule // caxi4interconnect_DERR_Slave.v
