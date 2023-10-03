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
//     Abstract  : This file provides an caxi4interconnect_Axi4CrossBar between up to 4 masters and 8 slaves. 
//                 All ports are AXI4 compliant and need infrasturtures components between 
//                 them and AXI3 and AXI4Lite compliant nodes.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_Axi4CrossBar #
  (
		parameter integer FAMILY                = 19, 
		
		parameter integer NUM_MASTERS			= 8, 				// defines number of master ports 	- valid 1-4
	
		parameter integer NUM_SLAVES     		= 8, 				// defines number of slaves	valid 1-8

		parameter integer ID_WIDTH   			= 1, 				// number of bits for ID (ie AID and WID) - valid 1 - 8

		parameter integer ADDR_WIDTH      		= 9,				// valid values - 16-64
		parameter integer DATA_WIDTH 			= 8,				// valid widths - 32, 64, 128
		
		parameter NUM_THREADS					= 1,				// defined number of indpendent threads per master supported - valid range 1-8
		parameter OPEN_TRANS_MAX				= 2,				// max number of outstanding transactions per thread - valid range 1-8
		
		parameter OPEN_WRTRANS_MAX				= 3,				// max number of outstanding write transactions per slave - valid range 1-8
		parameter OPEN_RDTRANS_MAX				= 3,				// max number of outstanding read transactions per master - valid range 1-8

		parameter UPPER_COMPARE_BIT 			= 4,				// Defines the upper bit of range to compare
		parameter LOWER_COMPARE_BIT 			= 1,				// Defines lower bound of compare - bits below are dont care


		parameter [ ( NUM_SLAVES* (ADDR_WIDTH-UPPER_COMPARE_BIT) )-1 : 0 ] 			SLOT_BASE_VEC = { 5'h1F, 5'h1E, 5'h1D, 5'h1C, 5'h1B, 5'h1A, 5'h19, 5'h18, 
                                                                            5'h17, 5'h16, 5'h15, 5'h14, 5'h13, 5'h12, 5'h11, 5'h10, 
                                                                            5'hF, 5'hE, 5'hD, 5'hC, 5'hB, 5'hA, 5'h9, 5'h8, 5'h7, 
                                                                            5'h6, 5'h5, 5'h4, 5'h3, 5'h2, 5'h1, 5'h0  },
																												//			0,
	
		parameter [ ( NUM_SLAVES* (UPPER_COMPARE_BIT-LOWER_COMPARE_BIT))-1 : 0 ] 	SLOT_MIN_VEC  = { NUM_SLAVES{ 3'b0 }  },	// SLOT Min per slave 
		parameter [ ( NUM_SLAVES* (UPPER_COMPARE_BIT-LOWER_COMPARE_BIT))-1 : 0 ] 	SLOT_MAX_VEC  = { NUM_SLAVES{ 3'b111 } },	// SLOT Max per slave 

		parameter integer SUPPORT_USER_SIGNALS 	= 0,					// indicates where user signals upport - 0 mean no, 1 means yes
		parameter integer USER_WIDTH 			= 1,					// defines the number of bits for USER signals RUSER and WUSER

		parameter integer CROSSBAR_MODE			= 1,					// defines whether non-blocking (ie set 1) or shared access data path

		parameter [NUM_MASTERS*NUM_SLAVES-1:0] 		MASTER_WRITE_CONNECTIVITY 		= {NUM_MASTERS*NUM_SLAVES{1'b1}},	// bit per port indicating if a master can write to a slave port
		parameter [NUM_MASTERS*NUM_SLAVES-1:0] 		MASTER_READ_CONNECTIVITY 		= {NUM_MASTERS*NUM_SLAVES{1'b1}},	// bit per master port indicating if a master can master can read from a slave port
		
		
		parameter integer NUM_MASTERS_WIDTH		= ( ( NUM_MASTERS == 1 ) | ( NUM_MASTERS == 2 ) ) ? 1			// defines number of bits to encode number of masters number
												: ( ( NUM_MASTERS == 3 ) | ( NUM_MASTERS == 4 ) ) ? 2	 		// valid from 1-8
												: ( ( NUM_MASTERS >= 5 ) | ( NUM_MASTERS <= 8 ) ) ? 3
												: ( ( NUM_MASTERS >= 9 ) | ( NUM_MASTERS <= 16 ) ) ? 4
												: 0,		// defined to be 0 to cause compile error for invalid values
														
		parameter 	HI_FREQ		= 1,			// used to add registers to allow a higher freq of operation at cost of latency
		parameter	RD_ARB_EN 	= 1,			// select arb or ordered rdata
		parameter   READ_INTERLEAVE = 1
		
   )
  (
  
   // Global Signals
   input  wire                                                 ACLK,
   input  wire                                                 ARESETN,
   
   //================================================= Master Ports  ================================================//

   // Master Write Address Ports
   input  wire [NUM_MASTERS*ID_WIDTH-1:0]        	   			MASTER_AWID,
   input  wire [NUM_MASTERS*ADDR_WIDTH-1:0] 		          	MASTER_AWADDR,
   input  wire [NUM_MASTERS*8-1:0]                          	MASTER_AWLEN,
   input  wire [NUM_MASTERS*3-1:0]                          	MASTER_AWSIZE,
   input  wire [NUM_MASTERS*2-1:0]                          	MASTER_AWBURST,
   input  wire [NUM_MASTERS*2-1:0]                          	MASTER_AWLOCK,
   input  wire [NUM_MASTERS*4-1:0]                          	MASTER_AWCACHE,
   input  wire [NUM_MASTERS*3-1:0]                          	MASTER_AWPROT,
   input  wire [NUM_MASTERS*4-1:0]				MASTER_AWREGION,
   input  wire [NUM_MASTERS*4-1:0]                          	MASTER_AWQOS,				// not used
   input  wire [NUM_MASTERS*USER_WIDTH-1:0]         			MASTER_AWUSER,				// not used
   input  wire [NUM_MASTERS-1:0]                            	MASTER_AWVALID,
   output wire [NUM_MASTERS-1:0]                            	MASTER_AWREADY,

   // Master Write Data Ports
   input  wire [NUM_MASTERS*ID_WIDTH-1:0]                       MASTER_WID,
   input  wire [NUM_MASTERS*DATA_WIDTH-1:0]     				MASTER_WDATA,
   input  wire [NUM_MASTERS*DATA_WIDTH/8-1:0]   				MASTER_WSTRB,
   input  wire [NUM_MASTERS-1:0]                           		MASTER_WLAST,
   input  wire [NUM_MASTERS*USER_WIDTH-1:0]          			MASTER_WUSER,
   input  wire [NUM_MASTERS-1:0]                           		MASTER_WVALID,
   output wire [NUM_MASTERS-1:0]	               	            MASTER_WREADY,
 
	// Master Write Response Ports
   output wire [NUM_MASTERS*ID_WIDTH-1:0]           			MASTER_BID,
   output wire [NUM_MASTERS*2-1:0]                          	MASTER_BRESP,
   output wire [NUM_MASTERS*USER_WIDTH-1:0]          			MASTER_BUSER,
   output wire [NUM_MASTERS-1:0]                            	MASTER_BVALID,
   input  wire [NUM_MASTERS-1:0]                            	MASTER_BREADY,

   // Master Read Address Ports
   input  wire [NUM_MASTERS*ID_WIDTH-1:0]           			MASTER_ARID,
   input  wire [NUM_MASTERS*ADDR_WIDTH-1:0]           			MASTER_ARADDR,
   input  wire [NUM_MASTERS*8-1:0]                          	MASTER_ARLEN,
   input  wire [NUM_MASTERS*3-1:0]                          	MASTER_ARSIZE,
   input  wire [NUM_MASTERS*2-1:0]                          	MASTER_ARBURST,
   input  wire [NUM_MASTERS*2-1:0]                          	MASTER_ARLOCK,
   input  wire [NUM_MASTERS*4-1:0]                          	MASTER_ARCACHE,
   input  wire [NUM_MASTERS*3-1:0]                          	MASTER_ARPROT,
   input  wire [NUM_MASTERS*4-1:0]								MASTER_ARREGION,
   input  wire [NUM_MASTERS*4-1:0]                          	MASTER_ARQOS,		// not used
   input  wire [NUM_MASTERS*USER_WIDTH-1:0]         			MASTER_ARUSER,
   input  wire [NUM_MASTERS-1:0]                            	MASTER_ARVALID,
   output wire [NUM_MASTERS-1:0]                            	MASTER_ARREADY,

   // Master Read Data Ports
   output wire [NUM_MASTERS*ID_WIDTH-1:0]          				MASTER_RID,
   output wire [NUM_MASTERS*DATA_WIDTH-1:0]     				MASTER_RDATA,
   output wire [NUM_MASTERS*2-1:0]                          	MASTER_RRESP,
   output wire [NUM_MASTERS-1:0]                            	MASTER_RLAST,
   output wire [NUM_MASTERS*USER_WIDTH-1:0]          			MASTER_RUSER,
   output wire [NUM_MASTERS-1:0]                            	MASTER_RVALID,
   input  wire [NUM_MASTERS-1:0]                            	MASTER_RREADY,
   
   //======================================== Slave Ports  ================================================//
   
   // Slave Write Address Port
   output wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 	SLAVE_AWID,
   output wire [NUM_SLAVES*ADDR_WIDTH-1:0]          			SLAVE_AWADDR,
   output wire [NUM_SLAVES*8-1:0]                         		SLAVE_AWLEN,
   output wire [NUM_SLAVES*3-1:0]                         		SLAVE_AWSIZE,
   output wire [NUM_SLAVES*2-1:0]                         		SLAVE_AWBURST,
   output wire [NUM_SLAVES*2-1:0]                         		SLAVE_AWLOCK,
   output wire [NUM_SLAVES*4-1:0]                         		SLAVE_AWCACHE,
   output wire [NUM_SLAVES*3-1:0]                         		SLAVE_AWPROT,
   output wire [NUM_SLAVES*4-1:0]                         		SLAVE_AWREGION,			// not used
   output wire [NUM_SLAVES*4-1:0]                         		SLAVE_AWQOS,			// not used
   output wire [NUM_SLAVES*USER_WIDTH-1:0]  	      	  		SLAVE_AWUSER,
   output wire [NUM_SLAVES-1:0]                           		SLAVE_AWVALID,
   input  wire [NUM_SLAVES-1:0]                           		SLAVE_AWREADY,
   
   // Slave Write Data Ports
   output wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]    SLAVE_WID,
   output wire [NUM_SLAVES*DATA_WIDTH-1:0]    					SLAVE_WDATA,
   output wire [NUM_SLAVES*DATA_WIDTH/8-1:0]  					SLAVE_WSTRB,
   output wire [NUM_SLAVES-1:0]                           		SLAVE_WLAST,
   output wire [NUM_SLAVES*USER_WIDTH-1:0]	         			SLAVE_WUSER,
   output wire [NUM_SLAVES-1:0]                           		SLAVE_WVALID,
   input  wire [NUM_SLAVES-1:0]                           		SLAVE_WREADY,

   // Slave Write Response Ports
   input  wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]	SLAVE_BID,
   input  wire [NUM_SLAVES*2-1:0]                         		SLAVE_BRESP,
   input  wire [NUM_SLAVES*USER_WIDTH-1:0]         				SLAVE_BUSER,
   input  wire [NUM_SLAVES-1:0]                           		SLAVE_BVALID,
   output wire [NUM_SLAVES-1:0]                           		SLAVE_BREADY,
   
   // Slave Read Address Port
   output wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]	SLAVE_ARID,
   output wire [NUM_SLAVES*ADDR_WIDTH-1:0]          			SLAVE_ARADDR,
   output wire [NUM_SLAVES*8-1:0]                         		SLAVE_ARLEN,
   output wire [NUM_SLAVES*3-1:0]                         		SLAVE_ARSIZE,
   output wire [NUM_SLAVES*2-1:0]                         		SLAVE_ARBURST,
   output wire [NUM_SLAVES*2-1:0]                         		SLAVE_ARLOCK,
   output wire [NUM_SLAVES*4-1:0]                         		SLAVE_ARCACHE,
   output wire [NUM_SLAVES*3-1:0]                         		SLAVE_ARPROT,
   output wire [NUM_SLAVES*4-1:0]                         		SLAVE_ARREGION,			// not used
   output wire [NUM_SLAVES*4-1:0]                         		SLAVE_ARQOS,			// not used
   output wire [NUM_SLAVES*USER_WIDTH-1:0]	        			SLAVE_ARUSER,
   output wire [NUM_SLAVES-1:0]                           		SLAVE_ARVALID,
   input  wire [NUM_SLAVES-1:0]                           		SLAVE_ARREADY,
   
   // Slave Read Data Ports
   input  wire [NUM_SLAVES*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]  	SLAVE_RID,
   input  wire [NUM_SLAVES*DATA_WIDTH-1:0]    					SLAVE_RDATA,
   input  wire [NUM_SLAVES*2-1:0]                         		SLAVE_RRESP,
   input  wire [NUM_SLAVES-1:0]                           		SLAVE_RLAST,
   input  wire [NUM_SLAVES*USER_WIDTH-1:0]	         			SLAVE_RUSER,			// not used
   input  wire [NUM_SLAVES-1:0]                           		SLAVE_RVALID,
   output wire [NUM_SLAVES-1:0]                           		SLAVE_RREADY
   
   
   );

   
   //=======================================================================================================================
   // Local variables
   //=======================================================================================================================

	localparam	integer	NUM_SLAVES_INT	= NUM_SLAVES +1;					// defines number of internal slave ports - includes internal DERR Slave
			
    localparam integer NUM_SLAVES_WIDTH  = (NUM_SLAVES_INT == 1) ? 1 : $clog2(NUM_SLAVES_INT); // defines number of bits to encode number of slaves number

						
	localparam integer ADDR_WIDTH_BITS	= ( ADDR_WIDTH == 16 ) ? 4											// defines number of bits to encode master number
												: ( ( ADDR_WIDTH >= 17 ) & ( ADDR_WIDTH <= 32 ) ) ? 5  		// valid from 16 -32 (really only for test), 32, 64
												: ( ( ADDR_WIDTH >= 33 ) & ( ADDR_WIDTH <= 8 ) )  ? 64  	
														: 0;	// defined to be 0 to cause compile error for invalid values

	localparam NUM_THREADS_WIDTH		= ( ( NUM_THREADS == 1 ) | ( NUM_THREADS == 2 ) ) ? 1				// defined number of bits to encode threads number 
												: ( ( NUM_THREADS == 3 ) | ( NUM_THREADS == 4 ) ) ? 2  		// valid from 1-8
												: ( ( NUM_THREADS >= 5 ) & ( NUM_THREADS <= 8 ) ) ? 3  	
														: 0;	// defined to be 0 to cause compile error for invalid values

	localparam OPEN_TRANS_WIDTH		= ( OPEN_TRANS_MAX == 1 ) ? 1				 	// width of open transaction count 
												: ( ( OPEN_TRANS_MAX == 2 ) | ( OPEN_TRANS_MAX == 3 ) ) ? 2 	// valid from 1-8
												: ( ( OPEN_TRANS_MAX >= 4 ) & ( OPEN_TRANS_MAX <= 7 ) ) ? 3  	
												: (   OPEN_TRANS_MAX == 8 ) ? 4  	
														: 0;	// defined to be 0 to cause compile error for invalid values
		
		
	localparam MASTERID_WIDTH		= ( NUM_MASTERS_WIDTH + ID_WIDTH );			// defines width masterID - includes infrastructure port number plus ID

																																		
	wire	[NUM_MASTERS*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 		currRDataTransID;	// current data transaction ID
	wire	[NUM_MASTERS-1:0]  									openRTransDec;		// indicates thread matching currDataTransID to be decremented

	wire	[NUM_MASTERS*(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 		currWDataTransID;	// current data transaction ID
	wire	[NUM_MASTERS-1:0]  									openWTransDec;		// indicates thread matching currDataTransID to be decremented
	
	wire 	sysReset;
	
	wire														dataFifoWr;
	wire	[(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 					srcPort;
	wire	[NUM_SLAVES_WIDTH-1:0]								destPort;
	wire	[NUM_SLAVES_INT-1:0]								wrFifoFull;

	wire														rdDataFifoWr;
	wire	[(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0] 					rdSrcPort;
	wire	[NUM_SLAVES_WIDTH-1:0]								rdDestPort;
	wire	[1+NUM_MASTERS-1:0]									rdFifoFull;		// includes caxi4interconnect_DERR_Slave
	
	//=========================================================================
	// DERR Slave declarations
	//=========================================================================
	wire [NUM_MASTERS_WIDTH+ID_WIDTH-1:0]          				DERR_ARID;
	wire [7:0]   	                       						DERR_ARLEN;
	wire 	                            						DERR_ARVALID;
	wire 		                           						DERR_ARREADY;
	
	wire [NUM_MASTERS_WIDTH+ID_WIDTH-1:0] 						DERR_RID;
	wire [DATA_WIDTH-1:0]    									DERR_RDATA;
	wire [1:0]                         							DERR_RRESP;
	wire                            							DERR_RLAST;
	wire [USER_WIDTH-1:0]         								DERR_RUSER;
	wire                           								DERR_RVALID;		
	wire		                           						DERR_RREADY;
	
	wire [NUM_MASTERS_WIDTH+ID_WIDTH-1:0]        	   			DERR_AWID;
	wire [7:0]   	                       						DERR_AWLEN;
	wire 	                            						DERR_AWVALID;
	wire 		                           						DERR_AWREADY;

	wire [NUM_MASTERS_WIDTH+ID_WIDTH-1:0]                       DERR_WID;
	wire [DATA_WIDTH-1:0]    									DERR_WDATA;
	wire [(DATA_WIDTH/8)-1:0]               					DERR_WSTRB;
	wire                            							DERR_WLAST;
	wire [USER_WIDTH-1:0]         								DERR_WUSER;
	wire                            							DERR_WVALID;
	wire		                          						DERR_WREADY;
		
	wire [NUM_MASTERS_WIDTH+ID_WIDTH-1:0] 						DERR_BID;
	wire [1:0]                         							DERR_BRESP;
	wire [USER_WIDTH-1:0]         								DERR_BUSER;
	wire 	                           							DERR_BVALID;
	wire 					               						DERR_BREADY;


//=====================================================================================
// function to compute connectiviry map with caxi4interconnect_DERR_Slave inserted.
//=====================================================================================
function [NUM_MASTERS*(NUM_SLAVES+1)-1:0] new_connectivity;

input  [NUM_MASTERS*NUM_SLAVES-1:0] connectivity;

reg  [NUM_MASTERS*(NUM_SLAVES+1)-1:0] new_map;
integer i;

begin

	for (i=0; i< NUM_MASTERS; i=i+1 )
		begin
			new_map[ (i*(NUM_SLAVES+1) ) +: (NUM_SLAVES+1)] = { 1'b1, connectivity[(i*NUM_SLAVES) +: NUM_SLAVES] };
		end
	
	new_connectivity = new_map;
end

endfunction


//=======================================================================================	
// Build new connectivity map adding in caxi4interconnect_DERR_Slave
//=======================================================================================
localparam [NUM_MASTERS*(NUM_SLAVES+1)-1:0]	MASTER_READ_CONNECTIVITY_INT = new_connectivity( MASTER_READ_CONNECTIVITY );
localparam [NUM_MASTERS*(NUM_SLAVES+1)-1:0]	MASTER_WRITE_CONNECTIVITY_INT = new_connectivity( MASTER_WRITE_CONNECTIVITY );


//==================================================================================
// If only 1 Master and 1 Slave generate a pass through
//==================================================================================


genvar i;
generate
   if ( ( NUM_MASTERS == 1) && (NUM_SLAVES == 1 )  && (READ_INTERLEAVE == 0) )
	begin  : psth	
  
		assign MASTER_AWREADY	= SLAVE_AWREADY;
		assign MASTER_WREADY 	= SLAVE_WREADY;
		assign MASTER_BID		= SLAVE_BID[ID_WIDTH-1:0];						// drop off the InfrastructureID from slave_BID
		assign MASTER_BRESP		= SLAVE_BRESP;
		assign MASTER_BUSER		= SLAVE_BUSER;
		assign MASTER_BVALID	= SLAVE_BVALID;

		// Master Read Address Ports
		assign MASTER_ARREADY	= SLAVE_ARREADY;

		// Master Read Data Ports
		assign MASTER_RID		= SLAVE_RID[ID_WIDTH-1:0];						// drop off the InfrastructureID from slave_RID
		assign MASTER_RDATA		= SLAVE_RDATA;
		assign MASTER_RRESP		= SLAVE_RRESP;
		assign MASTER_RLAST		= SLAVE_RLAST;
		assign MASTER_RUSER		= SLAVE_RUSER;
		assign MASTER_RVALID	= SLAVE_RVALID;
   
		//======================================== Slave Ports  ================================================//
   
		// Slave Write Address Port
		assign SLAVE_AWID		= { {NUM_MASTERS_WIDTH{1'b0}}, MASTER_AWID };		// add infrastructure component (andreag: NUM_MASTER_WIDTHS 0s)
		assign SLAVE_AWADDR  	= MASTER_AWADDR;
		assign SLAVE_AWLEN		= MASTER_AWLEN;
		assign SLAVE_AWSIZE		= MASTER_AWSIZE;
		assign SLAVE_AWBURST	= MASTER_AWBURST;
		assign SLAVE_AWLOCK		= MASTER_AWLOCK;
		assign SLAVE_AWCACHE 	= MASTER_AWCACHE;
		assign SLAVE_AWPROT 	= MASTER_AWPROT;
		assign SLAVE_AWREGION	= MASTER_AWREGION;					// not used (andreag: keep region unchanged between master and slave)
		assign SLAVE_AWQOS		= MASTER_AWQOS;					// not used
		assign SLAVE_AWUSER		= MASTER_AWUSER;
		assign SLAVE_AWVALID 	= MASTER_AWVALID;

		// Slave Write Data Ports
		assign SLAVE_WID    = { {NUM_MASTERS_WIDTH{1'b0}}, MASTER_WID };
		assign SLAVE_WDATA	= MASTER_WDATA;
		assign SLAVE_WSTRB	= MASTER_WSTRB;
		assign SLAVE_WLAST	= MASTER_WLAST;
		assign SLAVE_WUSER	= MASTER_WUSER;
		assign SLAVE_WVALID	= MASTER_WVALID;
   
		// Slave Write Response Ports
		assign SLAVE_BREADY = MASTER_BREADY;
   
		// Slave Read Address Port
		assign SLAVE_ARID		= { {NUM_MASTERS_WIDTH{1'b0}}, MASTER_ARID };		// add infrastucture component (andreag: NUM_MASTER_WIDTHS 0s)
		assign SLAVE_ARADDR		= MASTER_ARADDR;
		assign SLAVE_ARLEN		= MASTER_ARLEN;
		assign SLAVE_ARSIZE		= MASTER_ARSIZE;
		assign SLAVE_ARBURST 	= MASTER_ARBURST;
		assign SLAVE_ARLOCK		= MASTER_ARLOCK;
		assign SLAVE_ARCACHE 	= MASTER_ARCACHE;
		assign SLAVE_ARPROT		= MASTER_ARPROT;
		assign SLAVE_ARREGION 	= MASTER_ARREGION;			// not used
		assign SLAVE_ARQOS		= MASTER_ARQOS;				// not used
		assign SLAVE_ARUSER		= MASTER_ARUSER;
		assign SLAVE_ARVALID	= MASTER_ARVALID;

		// Slave Read Data Ports
		assign SLAVE_RREADY		= MASTER_RREADY;
     
	end	// pass-through
   
   else
   begin	: cb
   
	//=======================================================================================================================
	// Local system reset - asserted asynchronously to ACLK and deasserted synchronous
	//=======================================================================================================================
	//caxi4interconnect_ResetSycnc  
	//	rsync(
	//			.sysClk	( ACLK ),
	//			.sysReset_L( ARESETN ),			// active low reset synchronoise to RE AClk - asserted async.
	//			.sysReset( sysReset  )			// active low sysReset synchronised to ACLK
	//);
	assign sysReset = ARESETN; // Temp reomved this block to test silicon issue
	
   		
   
	//=======================================================================================================================
	// caxi4interconnect_AddressController arbitrates between Master requestors (ARVALID),  drivers to selected targeted slave the master read
	// address cycle, push outstanding transaction into openTransVec transaction complete. It pops the transaction defined by
	// currDataTransID when openTransDec is asserted.
	//=======================================================================================================================  
  	caxi4interconnect_AddressController # 
		(
			.NUM_MASTERS			( NUM_MASTERS ), 				// defines number of masters
			.NUM_MASTERS_WIDTH		( NUM_MASTERS_WIDTH ), 			// defines number of bits to encode master number
			.NUM_SLAVES     		( NUM_SLAVES_INT ), 			// defines number of slaves - includes DERR Slave
			.NUM_SLAVES_WIDTH 		( NUM_SLAVES_WIDTH ),			// defines number of bits to encoode slave number
			.ID_WIDTH   			( ID_WIDTH ), 
			.ADDR_WIDTH      		( ADDR_WIDTH ),
			.ADDR_WIDTH_BITS		( ADDR_WIDTH_BITS ),		// defines number of bits for ADDR_WIDTh - 64 -6, 32 = 5
			.NUM_THREADS			( NUM_THREADS ),			// defined number of indpendent threads per master supported 
			.NUM_THREADS_WIDTH		( NUM_THREADS_WIDTH ),		// defined number of bits to encode threads number 
			.OPEN_TRANS_MAX			( OPEN_TRANS_MAX ),			// max number of outstanding transactions 
			.OPEN_TRANS_WIDTH		( OPEN_TRANS_WIDTH ),		// width of open transaction count 
			.UPPER_COMPARE_BIT 		( UPPER_COMPARE_BIT ),		// Defines the upper bit of range to compare
			.LOWER_COMPARE_BIT 		( LOWER_COMPARE_BIT ),		// Defines lower bound of compare - bits below are dont care
			.SLOT_BASE_VEC 			( SLOT_BASE_VEC ),			// SLOT Base per slave 
			.SLOT_MIN_VEC  			( SLOT_MIN_VEC ),			// SLOT Min per slave 
			.SLOT_MAX_VEC  			( SLOT_MAX_VEC ),			// SLOT Max per slave 
			.SUPPORT_USER_SIGNALS 	( SUPPORT_USER_SIGNALS ),
			.AUSER_WIDTH 			( USER_WIDTH   ),
			.MASTER_CONNECTIVITY 	( MASTER_READ_CONNECTIVITY_INT  ),		// DERR Slave is included
			.HI_FREQ( HI_FREQ ),
			.WR_MODULE(1'b0)                                                // jhayes : Parameter to indicate a read caxi4interconnect_AddressController.
		)
	arcon	(
				// Global Signals
				.sysClk( ACLK ),
				.sysReset( sysReset ),			// active low reset synchronoise to RE AClk - asserted async.
   
				// Master Address Ports
				.MASTER_AID( MASTER_ARID ),
				.MASTER_AADDR( MASTER_ARADDR ),
		
				.MASTER_ALEN( MASTER_ARLEN ),
				.MASTER_ASIZE( MASTER_ARSIZE ),
				.MASTER_ABURST( MASTER_ARBURST ),
				.MASTER_ALOCK( MASTER_ARLOCK ),
				.MASTER_ACACHE( MASTER_ARCACHE ),
				.MASTER_APROT( MASTER_ARPROT ),
				.MASTER_AQOS( MASTER_ARQOS ),
				.MASTER_AUSER( MASTER_ARUSER ),
				.MASTER_AVALID( MASTER_ARVALID ),
				.MASTER_AREADY( MASTER_ARREADY ),
   
				// Slave Address Port
				.SLAVE_AID( { DERR_ARID, SLAVE_ARID } ),
				.SLAVE_AADDR( SLAVE_ARADDR ),
				.SLAVE_ALEN( { DERR_ARLEN, SLAVE_ARLEN } ),
				.SLAVE_ASIZE( SLAVE_ARSIZE ),
				.SLAVE_ABURST( SLAVE_ARBURST ),
				.SLAVE_ALOCK( SLAVE_ARLOCK ),
				.SLAVE_ACACHE( SLAVE_ARCACHE ),
				.SLAVE_APROT( SLAVE_ARPROT ),
				.SLAVE_AQOS( SLAVE_ARQOS ),
				.SLAVE_AUSER( SLAVE_ARUSER ),
				.SLAVE_AVALID( { DERR_ARVALID, SLAVE_ARVALID } ),
				.SLAVE_AREADY( { DERR_ARREADY, SLAVE_ARREADY } ),
   
				// DataControl Port 
				.currDataTransID( currRDataTransID ),	// current data transaction ID
				.openTransDec( openRTransDec ),			// indicates thread matching currDataTransID to be decremented
				.dataFifoWr( rdDataFifoWr ),
				.srcPort( rdSrcPort ),
				.destPort( rdDestPort ),

				.stopTrans( 33'd0 & rdFifoFull  ) 	// indicates to address control to "stop" address transactions, 
                                                    // jhayes : Padding to ensure signal is 9 bits wide to avoid port size mismatch.
                                                    // 9 bits wide to include max number of FIFOs and the caxi4interconnect_DERR_Slave.
				
			); 
   
   
   
	//=======================================================================================================================
	// DataController arbitrates between Slaves requestors (RVALID),  drivers to selected targeted Master based SLAVE_RID
	// and "pops" open transaction with currDataTransID when openTransDec at end of transaction.
	//=======================================================================================================================     
 						 
	caxi4interconnect_RDataController # 
			(
				.NUM_MASTERS			( NUM_MASTERS ), 				// defines number of masters
				.NUM_MASTERS_WIDTH		( NUM_MASTERS_WIDTH ), 			// defines number of bits to encode master number
				.NUM_SLAVES     		( NUM_SLAVES_INT ), 			// defines number of slaves - includes DERR Slave
				.NUM_SLAVES_WIDTH 		( NUM_SLAVES_WIDTH ),			// defines number of bits to encoode slave number
				.ID_WIDTH   			( ID_WIDTH ), 
				.DATA_WIDTH 			( DATA_WIDTH ),
				.SUPPORT_USER_SIGNALS 	( SUPPORT_USER_SIGNALS ),
				.USER_WIDTH 			( USER_WIDTH ),
				.CROSSBAR_MODE			( CROSSBAR_MODE ),				// defines whether non-blocking (ie set 1) or shared access data path
				.OPEN_RDTRANS_MAX		( OPEN_RDTRANS_MAX ),
				.MASTER_READ_CONNECTIVITY ( MASTER_READ_CONNECTIVITY_INT ),		// DERR Slave is always "readable"
				.HI_FREQ				( HI_FREQ ),
				.RD_ARB_EN				( RD_ARB_EN )							
			
			)
	rDCon	(
				// Global Signals
				.sysClk ( ACLK ),
				.sysReset( sysReset ),			// active low reset synchronoise to RE AClk - asserted async.

				// Slave Data Ports  
				.SLAVE_VALID	( { DERR_RVALID, SLAVE_RVALID 	} ),
				.SLAVE_ID		( { DERR_RID, SLAVE_RID 		} ),
				.SLAVE_DATA		( { DERR_RDATA, SLAVE_RDATA 	} ),
				.SLAVE_RESP		( { DERR_RRESP, SLAVE_RRESP 	} ),
				.SLAVE_LAST		( { DERR_RLAST, SLAVE_RLAST 	} ),
				.SLAVE_USER		( { DERR_RUSER, SLAVE_RUSER 	} ),
				.SLAVE_READY	( { DERR_RREADY, SLAVE_RREADY 	} ),
		
				// Master Data  Ports  
				.MASTER_ID		( MASTER_RID ),
				.MASTER_DATA	( MASTER_RDATA ),
				.MASTER_RESP	( MASTER_RRESP ),
				.MASTER_LAST	( MASTER_RLAST ),
				.MASTER_USER	( MASTER_RUSER ),
				.MASTER_VALID	( MASTER_RVALID ),
				.MASTER_READY	( MASTER_RREADY ),
      
				// Data Controller  
				.currDataTransID( currRDataTransID ),	// indicates transaction to be decremented 
				.openTransDec( openRTransDec ),			// indicates ID of transaction to be decremented

				// Address Controller
				.rdDataFifoWr( rdDataFifoWr ),
				.rdSrcPort( rdSrcPort ),
				.rdDestPort( rdDestPort ),
				.rdFifoFull( rdFifoFull ) 	// indicates to address control to "stop" address transactions			
			);
   						   
   
 
	//=======================================================================================================================
	// caxi4interconnect_AddressController arbitrates between Master requestors (AWVALID),  drives to selected targeted slave the master read
	// address cycle, push outstanding transaction into openTransVec transaction complete. It pops the transaction defined by
	// currDataTransID when openTransDec is asserted.
	//=======================================================================================================================  
  	caxi4interconnect_AddressController # 
		(
			.NUM_MASTERS			( NUM_MASTERS ), 				// defines number of masters
			.NUM_MASTERS_WIDTH		( NUM_MASTERS_WIDTH ), 			// defines number of bits to encode master number
			.NUM_SLAVES     		( NUM_SLAVES_INT ), 			// defines number of slaves
			.NUM_SLAVES_WIDTH 		( NUM_SLAVES_WIDTH ),			// defines number of bits to encoode slave number
			.ID_WIDTH   			( ID_WIDTH ), 
			.ADDR_WIDTH      		( ADDR_WIDTH ),
			.ADDR_WIDTH_BITS		( ADDR_WIDTH_BITS ),		// defines number of bits for ADDR_WIDTh - 64 -6, 32 = 5
			.NUM_THREADS			( NUM_THREADS ),			// defined number of indpendent threads per master supported 
			.NUM_THREADS_WIDTH		( NUM_THREADS_WIDTH ),		// defined number of bits to encode threads number 
			.OPEN_TRANS_MAX			( OPEN_TRANS_MAX ),			// max number of outstanding transactions 
			.OPEN_TRANS_WIDTH		( OPEN_TRANS_WIDTH ),		// width of open transaction count 
			.UPPER_COMPARE_BIT 		( UPPER_COMPARE_BIT ),		// Defines the upper bit of range to compare
			.LOWER_COMPARE_BIT 		( LOWER_COMPARE_BIT ),		// Defines lower bound of compare - bits below are dont care
			.SLOT_BASE_VEC 			( SLOT_BASE_VEC ),			// SLOT Base per slave 
			.SLOT_MIN_VEC  			( SLOT_MIN_VEC ),			// SLOT Min per slave 
			.SLOT_MAX_VEC  			( SLOT_MAX_VEC ),			// SLOT Max per slave 
			.SUPPORT_USER_SIGNALS 	( SUPPORT_USER_SIGNALS ),
			.AUSER_WIDTH 			( USER_WIDTH   ),
			.MASTER_CONNECTIVITY 	( MASTER_WRITE_CONNECTIVITY_INT ), 		// DERR Slave is included
			.HI_FREQ( HI_FREQ ),
            .WR_MODULE(1'b1)                                                // jhayes : Parameter to indicate a write caxi4interconnect_AddressController.
		)
	awcon	(
				// Global Signals
				.sysClk( ACLK ),
				.sysReset( sysReset ),			// active low reset synchronoise to RE AClk - asserted async.
   
				// Master Address Ports
				.MASTER_AID( MASTER_AWID ),
				.MASTER_AADDR( MASTER_AWADDR ),
		
				.MASTER_ALEN( MASTER_AWLEN ),
				.MASTER_ASIZE( MASTER_AWSIZE ),
				.MASTER_ABURST( MASTER_AWBURST ),
				.MASTER_ALOCK( MASTER_AWLOCK ),
				.MASTER_ACACHE( MASTER_AWCACHE ),
				.MASTER_APROT( MASTER_AWPROT ),
				.MASTER_AQOS( MASTER_AWQOS ),
				.MASTER_AUSER( MASTER_AWUSER ),
				.MASTER_AVALID( MASTER_AWVALID ),
				.MASTER_AREADY( MASTER_AWREADY ),
   
				// Slave Address Port
				.SLAVE_AID(  { DERR_AWID, SLAVE_AWID } ),
				.SLAVE_AADDR( SLAVE_AWADDR ),
				.SLAVE_ALEN( { DERR_AWLEN, SLAVE_AWLEN } ),
				.SLAVE_ASIZE( SLAVE_AWSIZE ),
				.SLAVE_ABURST( SLAVE_AWBURST ),
				.SLAVE_ALOCK( SLAVE_AWLOCK ),
				.SLAVE_ACACHE( SLAVE_AWCACHE ),
				.SLAVE_APROT( SLAVE_AWPROT ),
				.SLAVE_AQOS( SLAVE_AWQOS ),
				.SLAVE_AUSER( SLAVE_AWUSER ),
				.SLAVE_AVALID( { DERR_AWVALID, SLAVE_AWVALID } ),
				.SLAVE_AREADY( { DERR_AWREADY, SLAVE_AWREADY } ),
   
				// DataControl Port 
				.currDataTransID( currWDataTransID ),		// current data transaction ID
				.openTransDec( openWTransDec ),				// indicates thread matching currDataTransID to be decremented
				.dataFifoWr( dataFifoWr ),
				.srcPort( srcPort ),
				.destPort( destPort ),
				
				// WrFifo Port 
				.stopTrans( 33'd0 & wrFifoFull )			// indicates to address control to "stop" allowing Wr Address transactions.
                                                        // jhayes : Padding to ensure signal is 9 bits wide to avoid port size mismatch.
                                                        // 9 bits wide to include max number of FIFOs and the caxi4interconnect_DERR_Slave.
			); 
   
 

//====================================================================================================
 // caxi4interconnect_WDataController stores write address transactions and uses them to select order master write data 
 // transactions will be performed.
 //=================================================================================================== 
caxi4interconnect_WDataController # 
			(
				.NUM_MASTERS				( NUM_MASTERS ),	
				.NUM_MASTERS_WIDTH			( NUM_MASTERS_WIDTH ),
				.NUM_SLAVES 				( NUM_SLAVES_INT ),
				.NUM_SLAVES_WIDTH 			( NUM_SLAVES_WIDTH ),
				.ID_WIDTH  					( ID_WIDTH ),
				.DATA_WIDTH					( DATA_WIDTH ),
				.OPEN_WRTRANS_MAX			( OPEN_WRTRANS_MAX ),	
				.SUPPORT_USER_SIGNALS		( SUPPORT_USER_SIGNALS ),
				.USER_WIDTH 				( USER_WIDTH ),
				.CROSSBAR_MODE				( CROSSBAR_MODE ),					// defines whether non-blocking (ie set 1) or shared access data path
				.MASTER_WRITE_CONNECTIVITY	( MASTER_WRITE_CONNECTIVITY_INT ),	// DERR Slave is always writable
				.HI_FREQ					( HI_FREQ )
			)
	wDCon(
				// Global Signals
				.sysClk			( ACLK ),
				.sysReset		( sysReset ),

				// WrFifo Ports  
				.dataFifoWr( dataFifoWr ),
				.srcPort( srcPort ),
				.destPort( destPort ),
				.wrFifoFull( wrFifoFull ),

				//  Master Data  Ports  
				.MASTER_WVALID	( MASTER_WVALID ),
				.MASTER_WID     ( MASTER_WID),
				.MASTER_WDATA	( MASTER_WDATA ),
				.MASTER_WSTRB	( MASTER_WSTRB ),
				.MASTER_WLAST	( MASTER_WLAST ),
				.MASTER_WUSER	( MASTER_WUSER ),
				.MASTER_WREADY	( MASTER_WREADY ),

				// Slave Data Ports  
				.SLAVE_WID      ( { DERR_WID   , SLAVE_WID      } ),
				.SLAVE_WVALID	( { DERR_WVALID, SLAVE_WVALID 	} ),
				.SLAVE_WDATA	( { DERR_WDATA, SLAVE_WDATA 	} ),
				.SLAVE_WSTRB	( { DERR_WSTRB, SLAVE_WSTRB 	} ),
				.SLAVE_WLAST	( { DERR_WLAST, SLAVE_WLAST 	} ),
				.SLAVE_WUSER	( { DERR_WUSER, SLAVE_WUSER 	} ),
				.SLAVE_WREADY	( { DERR_WREADY, SLAVE_WREADY	} )
 	
			);


   
	
	//=======================================================================================================================
	// DataController arbitrates between Slaves response requestors (BVALID),  drivers to selected targeted Master based 
	// SLAVE_BID and "pops" open transaction with currDataTransID when openTransDec at end of transaction.
	//=======================================================================================================================     
 						 
	caxi4interconnect_RespController # 
			(
				.NUM_MASTERS			( NUM_MASTERS ), 				// defines number of masters
				.NUM_MASTERS_WIDTH		( NUM_MASTERS_WIDTH ), 			// defines number of bits to encode master number
				.NUM_SLAVES     		( NUM_SLAVES_INT ), 				// defines number of slaves - including DERR Slave
				.NUM_SLAVES_WIDTH 		( NUM_SLAVES_WIDTH ),			// defines number of bits to encoode slave number
				.ID_WIDTH   			( ID_WIDTH ), 
				.SUPPORT_USER_SIGNALS 	( SUPPORT_USER_SIGNALS ),
				.USER_WIDTH 			( USER_WIDTH ),
				.MASTER_WRITE_CONNECTIVITY 	( MASTER_WRITE_CONNECTIVITY_INT  ), 		// DERR Slave is always writable
				.MASTER_READ_CONNECTIVITY 	( MASTER_READ_CONNECTIVITY_INT   )			// DERR Slave is always readable

			)
	rcon	(
				// Global Signals
				.sysClk ( ACLK ),
				.sysReset( sysReset ),			// active low reset synchronoise to RE AClk - asserted async.

				//====================== Slave Data Ports  ================================================//
				.SLAVE_VALID	( { DERR_BVALID, SLAVE_BVALID	} ),
				.SLAVE_ID		( { DERR_BID, SLAVE_BID 		} ),
				.SLAVE_RESP		( { DERR_BRESP, SLAVE_BRESP 	} ),
				.SLAVE_USER		( { DERR_BUSER, SLAVE_BUSER 	} ),
				.SLAVE_READY	( { DERR_BREADY, SLAVE_BREADY 	} ),
		
				//====================== Master Data  Ports  ================================================//
				.MASTER_ID		( MASTER_BID ),
				.MASTER_RESP	( MASTER_BRESP ),
				.MASTER_USER	( MASTER_BUSER ),
				.MASTER_VALID	( MASTER_BVALID ),
				.MASTER_READY	( MASTER_BREADY ),
      
				//====================== Data Controller  ================================================//
				.currDataTransID( currWDataTransID ),	// indicates transaction to be decremented 
				.openTransDec( openWTransDec )			// indicates ID of transaction to be decremented

			);
   						   

	//=======================================================================================================================
	// caxi4interconnect_DERR_Slave provides an internal slave for decode errors - provides decerr response to masters
	//=======================================================================================================================     
						   
	caxi4interconnect_DERR_Slave # 
			( 	
				.ID_WIDTH	( MASTERID_WIDTH ), 	// includes infrastrucre ID
				.DATA_WIDTH	( DATA_WIDTH ),
				.USER_WIDTH ( USER_WIDTH ),
				.RESP_CODE  ( 2'b11      )			// DECERR		
			)
		derr
			(
				// Global Signals
				.sysClk		( ACLK ),
				.sysReset	( sysReset ),	
				
				//====================== Read Address Ports  ================================================//
				.DERR_ARID	( 	DERR_ARID 	),
				.DERR_ARLEN	( 	DERR_ARLEN 	),
				.DERR_ARVALID( 	DERR_ARVALID ),
				.DERR_ARREADY( 	DERR_ARREADY ),

				//====================== Read Data Ports  ================================================//
				.DERR_RID( 		DERR_RID	),
				.DERR_RDATA( 	DERR_RDATA 	),
				.DERR_RRESP( 	DERR_RRESP 	),
				.DERR_RLAST( 	DERR_RLAST 	),
				.DERR_RUSER( 	DERR_RUSER 	),
				.DERR_RVALID(	DERR_RVALID ),		
				.DERR_RREADY(	DERR_RREADY ),
		
				//====================== Write  Address Ports  ================================================//
				.DERR_AWID( 	DERR_AWID 	),
				.DERR_AWLEN( 	DERR_AWLEN 	),
				.DERR_AWVALID( 	DERR_AWVALID ),
				.DERR_AWREADY( 	DERR_AWREADY ),

				//====================== Write  Data Ports  ================================================//
				.DERR_WID  ( DERR_WID   ),
				.DERR_WDATA( DERR_WDATA ),
				.DERR_WSTRB( DERR_WSTRB ),
				.DERR_WLAST( DERR_WLAST ),
				.DERR_WUSER( DERR_WUSER ),
				.DERR_WVALID( DERR_WVALID ),
		
				.DERR_WREADY( DERR_WREADY ),
		
				//====================== Write Resp Ports  ================================================//
				.DERR_BID( 		DERR_BID	),
				.DERR_BRESP( 	DERR_BRESP 	),
				.DERR_BUSER( 	DERR_BUSER 	),
				.DERR_BVALID( 	DERR_BVALID ),
				.DERR_BREADY(	DERR_BREADY )
 
	);

	assign SLAVE_ARREGION 	= 0; // not used (andreag: set default value as define in page A10-115 of AXI specs)
	assign SLAVE_AWREGION 	= 0; // not used (andreag: set default value as define in page A10-113 of AXI specs)
	
	
   end
endgenerate


endmodule		// caxi4interconnect_Axi4CrossBar
