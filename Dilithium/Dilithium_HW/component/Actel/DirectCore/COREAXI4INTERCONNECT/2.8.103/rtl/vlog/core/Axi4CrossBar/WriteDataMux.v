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
//      Abstract : This module controls the Data MUXing from Masters to Slaves
//                 and the responses back from the slaves for Write Data Channel.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_WriteDataMux # 
	(
		parameter integer NUM_MASTERS			= 4, 				// defines number of masters
		parameter integer NUM_MASTERS_WIDTH		= 2, 				// defines number of bits to encode master number
		
		parameter integer NUM_SLAVES     		= 8, 				// defines number of slaves
		parameter integer NUM_SLAVES_WIDTH 		= 3,				// defines number of bits to encoode slave number

		parameter integer ID_WIDTH   			= 1, 

		parameter integer DATA_WIDTH 			= 32,
		
		parameter integer SUPPORT_USER_SIGNALS 	= 0,
		parameter integer USER_WIDTH 			= 1,
		
		parameter [NUM_MASTERS-1:0] 		WRITE_CONNECTIVITY 		= {NUM_MASTERS{1'b1} },

		parameter HI_FREQ 						= 0,					// increases freq of operation at cost of added latency
		
		parameter MASTERID_WIDTH                = NUM_MASTERS_WIDTH + ID_WIDTH
		
  	)
	(
		// Global Signals
		input  wire                        				sysClk,
		input  wire                        				sysReset,					// active low reset synchronoise to RE AClk - asserted async.

		//====================== WrFifo Ports  ======================================================//
		input  wire										wrMasterValid,

		output wire										dataFifoRd,					// request to pop caxi4interconnect_FIFO entry after write completed.
																				
		input	 [NUM_MASTERS_WIDTH-1:0]				srcMaster,

		//====================== Master Data  Ports  ================================================//
		input wire [NUM_MASTERS-1:0]                    MASTER_WVALID,
		input wire [NUM_MASTERS*ID_WIDTH-1:0]        	MASTER_WID,
		input wire [NUM_MASTERS*DATA_WIDTH-1:0]     	MASTER_WDATA,
		input wire [NUM_MASTERS*(DATA_WIDTH/8)-1:0]     MASTER_WSTRB,
		input wire [NUM_MASTERS-1:0]                    MASTER_WLAST,
		input wire [NUM_MASTERS*USER_WIDTH-1:0]         MASTER_WUSER,

		output reg [NUM_MASTERS-1:0]                    MASTER_WREADY,

		//====================== Slave Data Ports  ==================================================//
		output  reg  				      				SLAVE_WVALID,
		output  reg [MASTERID_WIDTH-1:0]                SLAVE_WID,		
		output  reg [DATA_WIDTH-1:0]    				SLAVE_WDATA,
		output  reg [(DATA_WIDTH/8)-1:0]              	SLAVE_WSTRB,
		output  reg                            			SLAVE_WLAST,
		output  reg [USER_WIDTH-1:0]         			SLAVE_WUSER,
		
		input wire                          			SLAVE_WREADY
 	
	);
   						 
						 
//================================================================================================
// Local Parameters
//================================================================================================


	localparam STRB_WIDTH			= (DATA_WIDTH/8);							// defines width of write strobes 
	
	
//=================================================================================================
// Local Declarationes
//=================================================================================================

	// Master Data Port - output of MUX of selected requestor
	reg [MASTERID_WIDTH-1:0]                    d_slaveWID;
	reg [DATA_WIDTH-1:0]     					d_slaveWDATA;
	reg [STRB_WIDTH-1:0]	       				d_slaveWSTRB;
	reg 				          				d_slaveWLAST;
	reg [USER_WIDTH-1:0]          				d_slaveWUSER;
    
    // jhayes : Change to make internal signals of larger width, based on 2^NUM_MASTERS_WIDTH. Input signals 
    // come in, based on width of NUM_MASTERS. However, logic inferred below will index beyond this width, hence change.
    wire [(2**NUM_MASTERS_WIDTH)*DATA_WIDTH-1:0] i_MASTER_WDATA;
    wire [(2**NUM_MASTERS_WIDTH)*ID_WIDTH-1:0]   i_MASTER_WID;
    wire [(2**NUM_MASTERS_WIDTH)*(DATA_WIDTH/8)-1:0] i_MASTER_WSTRB;
    wire [(2**NUM_MASTERS_WIDTH)-1:0] i_MASTER_WLAST;
    wire [(2**NUM_MASTERS_WIDTH)*USER_WIDTH-1:0] i_MASTER_WUSER;
    
    // jhayes : Padding of input signals.
	assign i_MASTER_WID   = 'b0 | MASTER_WID;
    assign i_MASTER_WDATA = 'b0 | MASTER_WDATA;
    assign i_MASTER_WSTRB = 'b0 | MASTER_WSTRB;
    assign i_MASTER_WLAST = 'b0 | MASTER_WLAST;
    assign i_MASTER_WUSER = 'b0 | MASTER_WUSER;

	

//================================================================================================
// MUX data vector based on srcMaster
//================================================================================================
 
generate
if ( NUM_MASTERS_WIDTH == 1 )
	always @(*)
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_slaveWID      <= 0;
		d_slaveWDATA 	<= 0;
		d_slaveWSTRB 	<= 0;
		d_slaveWLAST 	<= 0;
		d_slaveWUSER	<= 0;
		
		if ( wrMasterValid )		// if an active request, drive selected requestor to all slave ports 
			begin
				case( srcMaster )
					1'b0:	
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[ID_WIDTH-1:0]};
							d_slaveWDATA 	<= i_MASTER_WDATA[DATA_WIDTH-1:0];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[STRB_WIDTH-1:0];
							d_slaveWLAST 	<= i_MASTER_WLAST[0:0];
							d_slaveWUSER	<= i_MASTER_WUSER[USER_WIDTH-1:0];
							
						end
					1'b1:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[2*ID_WIDTH-1:ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[2*STRB_WIDTH-1:STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[1:1];
							d_slaveWUSER	<= i_MASTER_WUSER[2*USER_WIDTH-1:USER_WIDTH];
							
						end
					default:
						begin
			
						end
				endcase
			end
			
	end  // always

else if ( NUM_MASTERS_WIDTH == 2 )

	always @(* )
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_slaveWID      <= 0;
		d_slaveWDATA 	<= 0;
		d_slaveWSTRB 	<= 0;
		d_slaveWLAST 	<= 0;
		d_slaveWUSER	<= 0;

		if ( wrMasterValid )				// if an active request, drive selected requestor to all slave ports 
			begin
				case( srcMaster )
					2'b00:	
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[ID_WIDTH-1:0]};
							d_slaveWDATA 	<= i_MASTER_WDATA[DATA_WIDTH-1:0];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[STRB_WIDTH-1:0];
							d_slaveWLAST 	<= i_MASTER_WLAST[0:0];
							d_slaveWUSER	<= i_MASTER_WUSER[USER_WIDTH-1:0];
							
						end
					2'b01:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[2*ID_WIDTH-1:ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[2*STRB_WIDTH-1:1*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[1:1];
							d_slaveWUSER	<= i_MASTER_WUSER[2*USER_WIDTH-1:USER_WIDTH];	
							
						end
					2'b10:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[3*ID_WIDTH-1:2*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[3*DATA_WIDTH-1:2*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[3*STRB_WIDTH-1:2*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[2:2];
							d_slaveWUSER	<= i_MASTER_WUSER[3*USER_WIDTH-1:2*USER_WIDTH];						
							
						end
					2'b11:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[4*ID_WIDTH-1:3*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[4*DATA_WIDTH-1:3*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[4*STRB_WIDTH-1:3*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[3:3];
							d_slaveWUSER	<= i_MASTER_WUSER[4*USER_WIDTH-1:3*USER_WIDTH];
							
						end
					default:
						begin
			
						end
				endcase
			end
			
	end  // always

else if ( NUM_MASTERS_WIDTH == 3 )

	always @(* )
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_slaveWID      <= 0;
		d_slaveWDATA 	<= 0;
		d_slaveWSTRB 	<= 0;
		d_slaveWLAST 	<= 0;
		d_slaveWUSER	<= 0;

		if ( wrMasterValid )				// if an active request, drive selected requestor to all slave ports 
			begin
				case( srcMaster )
					3'b000:	
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[ID_WIDTH-1:0]};
							d_slaveWDATA 	<= i_MASTER_WDATA[DATA_WIDTH-1:0];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[STRB_WIDTH-1:0];
							d_slaveWLAST 	<= i_MASTER_WLAST[0:0];
							d_slaveWUSER	<= i_MASTER_WUSER[USER_WIDTH-1:0];
							
						end
					3'b001:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[2*ID_WIDTH-1:ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[2*STRB_WIDTH-1:1*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[1:1];
							d_slaveWUSER	<= i_MASTER_WUSER[2*USER_WIDTH-1:USER_WIDTH];	
							
						end
					3'b010:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[3*ID_WIDTH-1:2*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[3*DATA_WIDTH-1:2*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[3*STRB_WIDTH-1:2*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[2:2];
							d_slaveWUSER	<= i_MASTER_WUSER[3*USER_WIDTH-1:2*USER_WIDTH];						
							
						end
					3'b011:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[4*ID_WIDTH-1:3*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[4*DATA_WIDTH-1:3*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[4*STRB_WIDTH-1:3*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[3:3];
							d_slaveWUSER	<= i_MASTER_WUSER[4*USER_WIDTH-1:3*USER_WIDTH];
							
						end
					3'b100:	
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[5*ID_WIDTH-1:4*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[5*DATA_WIDTH-1:4*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[5*STRB_WIDTH-1:4*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[4:4];
							d_slaveWUSER	<= i_MASTER_WUSER[5*USER_WIDTH-1:4*USER_WIDTH];	
							
						end
					3'b101:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[6*ID_WIDTH-1:5*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[6*DATA_WIDTH-1:5*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[6*STRB_WIDTH-1:5*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[5:5];
							d_slaveWUSER	<= i_MASTER_WUSER[6*USER_WIDTH-1:5*USER_WIDTH];	
							
						end
					3'b110:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[7*ID_WIDTH-1:6*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[7*DATA_WIDTH-1:6*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[7*STRB_WIDTH-1:6*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[6:6];
							d_slaveWUSER	<= i_MASTER_WUSER[7*USER_WIDTH-1:6*USER_WIDTH];						
							
						end
					3'b111:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[8*ID_WIDTH-1:7*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[8*DATA_WIDTH-1:7*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[8*STRB_WIDTH-1:7*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[7:7];
							d_slaveWUSER	<= i_MASTER_WUSER[8*USER_WIDTH-1:7*USER_WIDTH];
							
						end								
					default:
						begin
			
						end
				endcase
			end
	end  // always

else if ( NUM_MASTERS_WIDTH == 4 )

	always @(* )
	begin
	
		// Master Address Port - latch previous requestor unless active requestor
		d_slaveWID      <= 0;
		d_slaveWDATA 	<= 0;
		d_slaveWSTRB 	<= 0;
		d_slaveWLAST 	<= 0;
		d_slaveWUSER	<= 0;

		if ( wrMasterValid )				// if an active request, drive selected requestor to all slave ports 
			begin
				case( srcMaster )
					4'b0000:	
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[ID_WIDTH-1:0]};
							d_slaveWDATA 	<= i_MASTER_WDATA[DATA_WIDTH-1:0];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[STRB_WIDTH-1:0];
							d_slaveWLAST 	<= i_MASTER_WLAST[0:0];
							d_slaveWUSER	<= i_MASTER_WUSER[USER_WIDTH-1:0];
							
						end
					4'b0001:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[2*ID_WIDTH-1:ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[2*DATA_WIDTH-1:DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[2*STRB_WIDTH-1:1*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[1:1];
							d_slaveWUSER	<= i_MASTER_WUSER[2*USER_WIDTH-1:USER_WIDTH];	
							
						end
					4'b0010:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[3*ID_WIDTH-1:2*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[3*DATA_WIDTH-1:2*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[3*STRB_WIDTH-1:2*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[2:2];
							d_slaveWUSER	<= i_MASTER_WUSER[3*USER_WIDTH-1:2*USER_WIDTH];						
							
						end
					4'b0011:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[4*ID_WIDTH-1:3*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[4*DATA_WIDTH-1:3*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[4*STRB_WIDTH-1:3*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[3:3];
							d_slaveWUSER	<= i_MASTER_WUSER[4*USER_WIDTH-1:3*USER_WIDTH];
							
						end
					4'b0100:	
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[5*ID_WIDTH-1:4*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[5*DATA_WIDTH-1:4*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[5*STRB_WIDTH-1:4*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[4:4];
							d_slaveWUSER	<= i_MASTER_WUSER[5*USER_WIDTH-1:4*USER_WIDTH];	
							
						end
					4'b0101:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[6*ID_WIDTH-1:5*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[6*DATA_WIDTH-1:5*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[6*STRB_WIDTH-1:5*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[5:5];
							d_slaveWUSER	<= i_MASTER_WUSER[6*USER_WIDTH-1:5*USER_WIDTH];	
							
						end
					4'b0110:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[7*ID_WIDTH-1:6*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[7*DATA_WIDTH-1:6*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[7*STRB_WIDTH-1:6*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[6:6];
							d_slaveWUSER	<= i_MASTER_WUSER[7*USER_WIDTH-1:6*USER_WIDTH];						
							
						end
					4'b0111:
						begin
						    d_slaveWID      <= {srcMaster,i_MASTER_WID[8*ID_WIDTH-1:7*ID_WIDTH]};
							d_slaveWDATA 	<= i_MASTER_WDATA[8*DATA_WIDTH-1:7*DATA_WIDTH];
							d_slaveWSTRB 	<= i_MASTER_WSTRB[8*STRB_WIDTH-1:7*STRB_WIDTH];
							d_slaveWLAST 	<= i_MASTER_WLAST[7:7];
							d_slaveWUSER	<= i_MASTER_WUSER[8*USER_WIDTH-1:7*USER_WIDTH];							
						end								
                     4'b1000:
                         begin
                             d_slaveWID      <= {srcMaster,i_MASTER_WID[9*ID_WIDTH-1:8*ID_WIDTH]};
                             d_slaveWDATA 	<= i_MASTER_WDATA[9*DATA_WIDTH-1:8*DATA_WIDTH];
                             d_slaveWSTRB 	<= i_MASTER_WSTRB[9*STRB_WIDTH-1:8*STRB_WIDTH];
                             d_slaveWLAST 	<= i_MASTER_WLAST[8:8];
                             d_slaveWUSER	<= i_MASTER_WUSER[9*USER_WIDTH-1:8*USER_WIDTH];
                         end
                     4'b1001:
                         begin
                             d_slaveWID      <= {srcMaster,i_MASTER_WID[10*ID_WIDTH-1:9*ID_WIDTH]};
                             d_slaveWDATA 	<= i_MASTER_WDATA[10*DATA_WIDTH-1:9*DATA_WIDTH];
                             d_slaveWSTRB 	<= i_MASTER_WSTRB[10*STRB_WIDTH-1:9*STRB_WIDTH];
                             d_slaveWLAST 	<= i_MASTER_WLAST[9:9];
                             d_slaveWUSER	<= i_MASTER_WUSER[10*USER_WIDTH-1:9*USER_WIDTH];
                         end
                     4'b1010:
                         begin
                             d_slaveWID      <= {srcMaster,i_MASTER_WID[11*ID_WIDTH-1:10*ID_WIDTH]};
                             d_slaveWDATA 	<= i_MASTER_WDATA[11*DATA_WIDTH-1:10*DATA_WIDTH];
                             d_slaveWSTRB 	<= i_MASTER_WSTRB[11*STRB_WIDTH-1:10*STRB_WIDTH];
                             d_slaveWLAST 	<= i_MASTER_WLAST[10:10];
                             d_slaveWUSER	<= i_MASTER_WUSER[11*USER_WIDTH-1:10*USER_WIDTH];
                         end
                     4'b1011:
                         begin
                             d_slaveWID      <= {srcMaster,i_MASTER_WID[12*ID_WIDTH-1:11*ID_WIDTH]};
                             d_slaveWDATA 	<= i_MASTER_WDATA[12*DATA_WIDTH-1:11*DATA_WIDTH];
                             d_slaveWSTRB 	<= i_MASTER_WSTRB[12*STRB_WIDTH-1:11*STRB_WIDTH];
                             d_slaveWLAST 	<= i_MASTER_WLAST[11:11];
                             d_slaveWUSER	<= i_MASTER_WUSER[12*USER_WIDTH-1:11*USER_WIDTH];
                         end
                     4'b1100:
                         begin
                             d_slaveWID      <= {srcMaster,i_MASTER_WID[13*ID_WIDTH-1:12*ID_WIDTH]};
                             d_slaveWDATA 	<= i_MASTER_WDATA[13*DATA_WIDTH-1:12*DATA_WIDTH];
                             d_slaveWSTRB 	<= i_MASTER_WSTRB[13*STRB_WIDTH-1:12*STRB_WIDTH];
                             d_slaveWLAST 	<= i_MASTER_WLAST[12:12];
                             d_slaveWUSER	<= i_MASTER_WUSER[13*USER_WIDTH-1:12*USER_WIDTH];
                         end
                     4'b1101:
                         begin
                             d_slaveWID      <= {srcMaster,i_MASTER_WID[14*ID_WIDTH-1:13*ID_WIDTH]};
                             d_slaveWDATA 	<= i_MASTER_WDATA[14*DATA_WIDTH-1:13*DATA_WIDTH];
                             d_slaveWSTRB 	<= i_MASTER_WSTRB[14*STRB_WIDTH-1:13*STRB_WIDTH];
                             d_slaveWLAST 	<= i_MASTER_WLAST[13:13];
                             d_slaveWUSER	<= i_MASTER_WUSER[14*USER_WIDTH-1:13*USER_WIDTH];
                         end
                     4'b1110:
                         begin
                             d_slaveWID      <= {srcMaster,i_MASTER_WID[15*ID_WIDTH-1:14*ID_WIDTH]};
                             d_slaveWDATA 	<= i_MASTER_WDATA[15*DATA_WIDTH-1:14*DATA_WIDTH];
                             d_slaveWSTRB 	<= i_MASTER_WSTRB[15*STRB_WIDTH-1:14*STRB_WIDTH];
                             d_slaveWLAST 	<= i_MASTER_WLAST[14:14];
                             d_slaveWUSER	<= i_MASTER_WUSER[15*USER_WIDTH-1:14*USER_WIDTH];
                         end
                     4'b1111:
                         begin
                             d_slaveWID      <= {srcMaster,i_MASTER_WID[16*ID_WIDTH-1:15*ID_WIDTH]};
                             d_slaveWDATA 	<= i_MASTER_WDATA[16*DATA_WIDTH-1:15*DATA_WIDTH];
                             d_slaveWSTRB 	<= i_MASTER_WSTRB[16*STRB_WIDTH-1:15*STRB_WIDTH];
                             d_slaveWLAST 	<= i_MASTER_WLAST[15:15];
                             d_slaveWUSER	<= i_MASTER_WUSER[16*USER_WIDTH-1:15*USER_WIDTH];
                         end						
					default:
						begin
			
						end
				endcase
			end
	end  // always
	
endgenerate

/********
generate
	if ( HI_FREQ == 1 )
		begin
			//====================================================================================
			// Clock out Slave bus - adds a "dead" cycle
			//====================================================================================
			always @(posedge sysClk)
				begin
	
					SLAVE_WDATA 	<= d_slaveWDATA;
					SLAVE_WSTRB 	<= d_slaveWSTRB;
					SLAVE_WLAST 	<= d_slaveWLAST;
					SLAVE_WUSER		<= d_slaveWUSER;

					SLAVE_WVALID 	<= 0;		// initialise to 0 to indicate no transaction
					MASTER_WREADY	<= 0;
	
					if ( wrMasterValid )	// pass through VALID when active request
						begin
							SLAVE_WVALID			 	<= MASTER_WVALID[srcMaster];
							MASTER_WREADY[srcMaster]	<= SLAVE_WREADY;
						end
		
				end	
		end
	else
		begin	
			
			//=====================================================================================
			// Combinational out Slave bus - to avoid "dead" cycles
			//=====================================================================================
			always @(*)
				begin
	
					SLAVE_WDATA 	<= d_slaveWDATA;
					SLAVE_WSTRB 	<= d_slaveWSTRB;
					SLAVE_WLAST 	<= d_slaveWLAST;
					SLAVE_WUSER		<= d_slaveWUSER;

					SLAVE_WVALID 	<= 0;		// initialise to 0 to indicate no transaction
					MASTER_WREADY	<= 0;
	
					if ( wrMasterValid )	// pass through VALID when active request
						begin
							SLAVE_WVALID			 	<= MASTER_WVALID[srcMaster];
							MASTER_WREADY[srcMaster]	<= SLAVE_WREADY;
						end
		
				end	

		end
		
endgenerate

***********************/


//=====================================================================================
// Combinational out Slave bus - to avoid "dead" cycles
//=====================================================================================
always @(*)
	begin
	    
		SLAVE_WID       = d_slaveWID;
		SLAVE_WDATA 	= d_slaveWDATA;
		SLAVE_WSTRB 	= d_slaveWSTRB;
		SLAVE_WLAST 	= d_slaveWLAST;
		SLAVE_WUSER		= d_slaveWUSER;

		SLAVE_WVALID 	= 0;		// initialise to 0 to indicate no transaction
		MASTER_WREADY	= 0;
	
		if ( wrMasterValid )	// pass through VALID when active request
			begin
				SLAVE_WVALID			 	= MASTER_WVALID[srcMaster];
				MASTER_WREADY[srcMaster]	= SLAVE_WREADY;
			end
		
	end	




//=============================================================================
// Pop relevant caxi4interconnect_FIFO when completed write cycle ie last beat
//=============================================================================
assign	dataFifoRd	= SLAVE_WLAST & SLAVE_WREADY & SLAVE_WVALID;

	
endmodule // caxi4interconnect_WriteDataMux.v
