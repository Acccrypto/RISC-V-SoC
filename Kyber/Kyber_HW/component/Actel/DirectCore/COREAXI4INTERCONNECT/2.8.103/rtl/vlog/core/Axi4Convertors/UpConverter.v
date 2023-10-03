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
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_UpConverter #

        (
                parameter integer ID_WIDTH              = 1, 
                parameter integer ADDR_WIDTH            = 32,
                parameter integer WRITE_ADDR_FIFO_DEPTH = 2,                                // max number of outstanding transactions per thread - valid range 1-8
                parameter integer READ_ADDR_FIFO_DEPTH  = 2,                                // max number of outstanding transactions per thread - valid range 1-8
                parameter integer DATA_WIDTH            = 16, 
                parameter integer DATA_WIDTH_IN         = 32,
                parameter integer DATA_WIDTH_OUT        = 64,                
                parameter integer USER_WIDTH            = 1,
                parameter [13:0]  DATA_FIFO_DEPTH       = 14'h10,
                parameter         READ_INTERLEAVE       = 1         
        )
        (

        //=====================================  Global Signals   ========================================================================
        input  wire                                   ACLK,
        input  wire                                  sysReset,
 
        //=====================================  Connections to/from Crossbar   ==========================================================
        // Slave Read Address Ports
        output wire [ID_WIDTH-1:0]          SLAVE_ARID,
        output wire [ADDR_WIDTH-1:0]        SLAVE_ARADDR,
        output wire [7:0]                   SLAVE_ARLEN,
        output wire [2:0]                   SLAVE_ARSIZE,
        output wire [1:0]                   SLAVE_ARBURST,
        output wire [1:0]                   SLAVE_ARLOCK,
        output wire [3:0]                   SLAVE_ARCACHE,
        output wire [2:0]                   SLAVE_ARPROT,
        output wire [3:0]                   SLAVE_ARREGION,
        output wire [3:0]                   SLAVE_ARQOS,
        output wire [USER_WIDTH-1:0]        SLAVE_ARUSER,
        output wire                         SLAVE_ARVALID,
        input wire                          SLAVE_ARREADY,

        // Slave Read Data Ports        
        input wire [ID_WIDTH-1:0]          SLAVE_RID,
        input wire [DATA_WIDTH_OUT-1:0]    SLAVE_RDATA,
        input wire [1:0]                   SLAVE_RRESP,
        input wire                         SLAVE_RLAST,
        input wire [USER_WIDTH-1:0]        SLAVE_RUSER,
        input wire                         SLAVE_RVALID,
        output wire                        SLAVE_RREADY,

        // Slave Write Address Ports        
        output wire [ID_WIDTH-1:0]          SLAVE_AWID,
        output wire [ADDR_WIDTH-1:0]        SLAVE_AWADDR,
        output wire [7:0]                   SLAVE_AWLEN,
        output wire [2:0]                   SLAVE_AWSIZE,
        output wire [1:0]                   SLAVE_AWBURST,
        output wire [1:0]                   SLAVE_AWLOCK,
        output wire [3:0]                   SLAVE_AWCACHE,
        output wire [2:0]                   SLAVE_AWPROT,
        output wire [3:0]                   SLAVE_AWREGION,
        output wire [3:0]                   SLAVE_AWQOS,
        output wire [USER_WIDTH-1:0]        SLAVE_AWUSER,
        output wire                         SLAVE_AWVALID,
        input wire                          SLAVE_AWREADY,
        
        // Slave Write Data Ports        
		output wire [ID_WIDTH-1:0]                SLAVE_WID,
        output wire [DATA_WIDTH_OUT-1:0]          SLAVE_WDATA,
        output wire [(DATA_WIDTH_OUT/8)-1:0]      SLAVE_WSTRB,
        output wire                               SLAVE_WLAST,
        output wire [USER_WIDTH-1:0]              SLAVE_WUSER,
        output wire                               SLAVE_WVALID,
        input wire                                SLAVE_WREADY,
                        
        // Slave Write Response Ports        
        input  wire [ID_WIDTH-1:0]         SLAVE_BID,
        input  wire [1:0]                  SLAVE_BRESP,
        input  wire [USER_WIDTH-1:0]       SLAVE_BUSER,
        input  wire                        SLAVE_BVALID,
        output wire                        SLAVE_BREADY,

        //================================================= External Side Ports  ================================================//

        // Master Read Address Ports        
        input  wire [ID_WIDTH-1:0]          MASTER_ARID,
        input  wire [ADDR_WIDTH-1:0]        MASTER_ARADDR,
        input  wire [7:0]                   MASTER_ARLEN,
        input  wire [2:0]                   MASTER_ARSIZE,
        input  wire [1:0]                   MASTER_ARBURST,
        input  wire [1:0]                   MASTER_ARLOCK,
        input  wire [3:0]                   MASTER_ARCACHE,
        input  wire [2:0]                   MASTER_ARPROT,
        input  wire [3:0]                   MASTER_ARREGION,
        input  wire [3:0]                   MASTER_ARQOS,
        input  wire [USER_WIDTH-1:0]        MASTER_ARUSER,
        input  wire                         MASTER_ARVALID,
        output wire                         MASTER_ARREADY,
        
        // Master Read Data Ports        
        output wire [ID_WIDTH-1:0]       MASTER_RID,
        output wire [DATA_WIDTH_IN-1:0]  MASTER_RDATA,
        output wire [1:0]                MASTER_RRESP,
        output wire                      MASTER_RLAST,
        output wire [USER_WIDTH-1:0]     MASTER_RUSER,
        output wire                      MASTER_RVALID,
        input wire                       MASTER_RREADY,
        
        // Master Write Address Ports        
        input  wire [ID_WIDTH-1:0]       MASTER_AWID,
        input  wire [ADDR_WIDTH-1:0]     MASTER_AWADDR,
        input  wire [7:0]                MASTER_AWLEN,
        input  wire [2:0]                MASTER_AWSIZE,
        input  wire [1:0]                MASTER_AWBURST,
        input  wire [1:0]                MASTER_AWLOCK,
        input  wire [3:0]                MASTER_AWCACHE,
        input  wire [2:0]                MASTER_AWPROT,
        input  wire [3:0]                MASTER_AWREGION,
        input  wire [3:0]                MASTER_AWQOS,
        input  wire [USER_WIDTH-1:0]     MASTER_AWUSER,
        input  wire                      MASTER_AWVALID,
        output wire                      MASTER_AWREADY,
        
        // Master Write Data Ports        
		input wire [ID_WIDTH-1:0]           MASTER_WID,
        input wire [DATA_WIDTH_IN-1:0]      MASTER_WDATA,
        input wire [(DATA_WIDTH_IN/8)-1:0]  MASTER_WSTRB,
        input wire                          MASTER_WLAST,
        input wire [USER_WIDTH-1:0]         MASTER_WUSER,
        input wire                          MASTER_WVALID,
        output wire                         MASTER_WREADY,
        
        // Master Write Response Ports        
        output wire [ID_WIDTH-1:0]          MASTER_BID,
        output wire [1:0]                   MASTER_BRESP,
        output wire [USER_WIDTH-1:0]        MASTER_BUSER,
        output wire                         MASTER_BVALID,
        input wire                          MASTER_BREADY

        ) ;
		
    localparam TOTAL_IDS     = READ_INTERLEAVE ? (2 ** ID_WIDTH) : 1;		
        
//================================== Internal ==============================

    wire [TOTAL_IDS-1:0]  rchan_cmd_fifo_full;
    wire                  rchan_wr_en_cmd;
    wire                  wchan_cmd_fifo_full;
    wire                  bchan_cmd_fifo_full;
    wire                  wchan_wr_en_cmd;
    wire                  awchan_extend;
    wire [5:0]            awaddr_mst;
    wire [2:0]            awsize_mst;
    wire [7:0]            awlen_mst;
    wire [ID_WIDTH-1:0]   awid_mst;
    wire                  wchan_wrap_flag;
    wire                  wchan_fixed_flag;
    wire                  archan_extend;
    wire [5:0]            araddr_mst;
    wire [2:0]            arsize_mst;
    wire [7:0]            arlen_mst;
    wire [ID_WIDTH-1:0]   arid_mst;
    wire                  rchan_wrap_flag;
    wire                  rchan_fixed_flag;
    wire [4:0]            archan_to_wrap_boundary;
    wire [4:0]            awchan_to_wrap_boundary;
    wire                  archan_unaligned_wrap_burst;
        
        
   
    wire        [4:0]  to_boundary_master_aw;
    wire        [9:0]  mask_wrap_addr_aw;  
    wire        [2:0]  sizeDiff_aw;
    wire               unaligned_wrap_burst_comb_aw;
    wire        [5:0]  len_offset_aw;
    wire               wrap_tx_aw;
    wire               fixed_flag_comb_aw;
   
    wire     [7:0]               int_MASTER_ARLEN;
    wire                         int_MASTER_ARVALID;
    wire     [ID_WIDTH - 1:0]    int_MASTER_ARID;
    wire     [ADDR_WIDTH - 1:0]  int_MASTER_ARADDR;
    wire     [1:0]               int_MASTER_ARBURST;
    wire     [3:0]               int_MASTER_ARCACHE;
    wire     [1:0]               int_MASTER_ARLOCK;
    wire     [2:0]               int_MASTER_ARSIZE;
    wire     [2:0]               int_MASTER_ARPROT;
    wire     [3:0]               int_MASTER_ARQOS;
    wire     [3:0]               int_MASTER_ARREGION;
    wire     [USER_WIDTH - 1:0]  int_MASTER_ARUSER;
    wire                         int_MASTER_ARREADY; // from wrCmdFifoWriteCtrl
        
   
    wire        [4:0]  to_boundary_master_ar;
    wire        [9:0]  mask_wrap_addr_ar;  
    wire       [2:0]   sizeDiff_ar;
    wire               unaligned_wrap_burst_comb_ar;
    wire        [5:0]  len_offset_ar;
    wire               wrap_tx_ar;
    wire               fixed_flag_comb_ar;
	
	wire        [7:0]  alen_sec_wrap_ar;
	wire        [7:0]  alen_sec_wrap_aw;
	wire        [7:0]  alen_wrap_ar;
	wire        [7:0]  alen_wrap_aw;
   
    wire     [7:0]               int_MASTER_AWLEN;
    wire                         int_MASTER_AWVALID;
    wire     [ID_WIDTH - 1:0]    int_MASTER_AWID;
    wire     [ADDR_WIDTH - 1:0]  int_MASTER_AWADDR;
    wire     [1:0]               int_MASTER_AWBURST;
    wire     [3:0]               int_MASTER_AWCACHE;
    wire     [1:0]               int_MASTER_AWLOCK;
    wire     [2:0]               int_MASTER_AWSIZE;
    wire     [2:0]               int_MASTER_AWPROT;
    wire     [3:0]               int_MASTER_AWQOS;
    wire     [3:0]               int_MASTER_AWREGION;
    wire     [USER_WIDTH - 1:0]  int_MASTER_AWUSER;
    wire                         int_MASTER_AWREADY; // from wrCmdFifoWriteCtrl


//=======================AW Channel====================        
caxi4interconnect_DWC_UpConv_AChannel #
      (
      .ID_WIDTH      ( ID_WIDTH ),
      .ADDR_WIDTH    ( ADDR_WIDTH ),
      .USER_WIDTH    ( USER_WIDTH ),
      .DATA_WIDTH_IN ( DATA_WIDTH_IN ),
      .DATA_WIDTH_OUT( DATA_WIDTH_OUT ),
	  .TOTAL_IDS     ( TOTAL_IDS      ),
	  .READ_INTERLEAVE (READ_INTERLEAVE)
      )
    DWC_AWChan
      (
      // Global Signals
      .ACLK                          ( ACLK ),
      .sysReset                      ( sysReset ),            // active low reset synchronoise to RE AClk - asserted async.

      .fifoFull                      ({TOTAL_IDS {(wchan_cmd_fifo_full | bchan_cmd_fifo_full)}} ),
      .last_beat_wrap                ( awchan_to_wrap_boundary ),
      .wr_en_cmd                     ( wchan_wr_en_cmd ),
      .asize_mst                     ( awsize_mst ),
      .aid_mst                       ( awid_mst ),
      .wrap_flag                     ( wchan_wrap_flag ),
      .fixed_flag                    ( wchan_fixed_flag ),
      .alen_mst                      ( awlen_mst ),
      .unaligned_wrap_burst          ( ),

      .extend_tx                     ( awchan_extend ),
      .addr_fifo                     ( awaddr_mst ),

      .alen_wrap_pre                 ( alen_wrap_aw ),
      .alen_sec_wrap_pre             ( alen_sec_wrap_aw ),
      .to_boundary_master_pre        ( to_boundary_master_aw ),
      .mask_wrap_addr_pre            ( mask_wrap_addr_aw ),
      .sizeDiff_pre                  ( sizeDiff_aw ),
      .unaligned_wrap_burst_comb_pre ( unaligned_wrap_burst_comb_aw ),
      .len_offset_pre                ( len_offset_aw ),
      .wrap_tx_pre                   ( wrap_tx_aw ),
      .fixed_flag_comb_pre           ( fixed_flag_comb_aw ),

      .MASTER_AID                    ( int_MASTER_AWID ),
      .MASTER_AADDR                  ( int_MASTER_AWADDR ),
      .MASTER_ALEN                   ( int_MASTER_AWLEN ),
      .MASTER_ASIZE                  ( int_MASTER_AWSIZE ),
      .MASTER_ABURST                 ( int_MASTER_AWBURST ),
      .MASTER_AQOS                   ( int_MASTER_AWQOS ),
      .MASTER_AREGION                ( int_MASTER_AWREGION ),
      .MASTER_ALOCK                  ( int_MASTER_AWLOCK ),
      .MASTER_ACACHE                 ( int_MASTER_AWCACHE ),
      .MASTER_APROT                  ( int_MASTER_AWPROT ),
      .MASTER_AUSER                  ( int_MASTER_AWUSER ),
      .MASTER_AVALID                 ( int_MASTER_AWVALID ),

      .MASTER_AREADY                 ( int_MASTER_AWREADY ),
      .SLAVE_AID                     ( SLAVE_AWID ),
      .SLAVE_AADDR                   ( SLAVE_AWADDR ),
      .SLAVE_ALEN                    ( SLAVE_AWLEN ),
      .SLAVE_ASIZE                   ( SLAVE_AWSIZE ),
      .SLAVE_ABURST                  ( SLAVE_AWBURST ),
      .SLAVE_AQOS                    ( SLAVE_AWQOS ),
      .SLAVE_AREGION                 ( SLAVE_AWREGION ),
      .SLAVE_ALOCK                   ( SLAVE_AWLOCK ),
      .SLAVE_ACACHE                  ( SLAVE_AWCACHE ),
      .SLAVE_APROT                   ( SLAVE_AWPROT ),
      .SLAVE_AUSER                   ( SLAVE_AWUSER ),
      .SLAVE_AVALID                  ( SLAVE_AWVALID ),

      .SLAVE_AREADY                  ( SLAVE_AWREADY )

      );    
//=======================AW Channel Pre Calc====================  
caxi4interconnect_DWC_UpConv_preCalcAChannel #
      (
      .DATA_WIDTH_OUT ( DATA_WIDTH_OUT ), // DATA_WIDTH_IN as it is in the read direction
      .ADDR_WIDTH     ( ADDR_WIDTH ),
      .USER_WIDTH     ( USER_WIDTH ),
      .ID_WIDTH       ( ID_WIDTH )

      )
    DWC_UpConv_preCalcAChannel_aw_inst
      (
      .clk                           ( ACLK ),
      .rst                           ( sysReset ),

      .MASTER_ALEN_in                ( MASTER_AWLEN ),
      .MASTER_AADDR_in               ( MASTER_AWADDR ),
      .MASTER_ABURST_in              ( MASTER_AWBURST ),
      .MASTER_ACACHE_in              ( MASTER_AWCACHE ),
      .MASTER_AID_in                 ( MASTER_AWID ),
      .MASTER_ALOCK_in               ( MASTER_AWLOCK ),
      .MASTER_APROT_in               ( MASTER_AWPROT ),
      .MASTER_AQOS_in                ( MASTER_AWQOS ),
      .MASTER_AREGION_in             ( MASTER_AWREGION ),
      .MASTER_ASIZE_in               ( MASTER_AWSIZE ),
      .MASTER_AUSER_in               ( MASTER_AWUSER ),
      .MASTER_AVALID_in              ( MASTER_AWVALID ),

      .MASTER_AREADY_in              (  int_MASTER_AWREADY ), // from ctrl

      .MASTER_ALEN_out               ( int_MASTER_AWLEN  ),
      .MASTER_AADDR_out              ( int_MASTER_AWADDR ),
      .MASTER_ABURST_out             ( int_MASTER_AWBURST ),
      .MASTER_ACACHE_out             ( int_MASTER_AWCACHE ),
      .MASTER_AID_out                ( int_MASTER_AWID ),
      .MASTER_ALOCK_out              ( int_MASTER_AWLOCK ),
      .MASTER_APROT_out              ( int_MASTER_AWPROT ),
      .MASTER_AQOS_out               ( int_MASTER_AWQOS ),
      .MASTER_AREGION_out            ( int_MASTER_AWREGION ),
      .MASTER_ASIZE_out              ( int_MASTER_AWSIZE ),
      .MASTER_AUSER_out              ( int_MASTER_AWUSER ),
      .MASTER_AVALID_out             ( int_MASTER_AWVALID ),

      .MASTER_AREADY_out             ( MASTER_AWREADY ), // to source

      .alen_wrap_pre                 ( alen_wrap_aw ),
      .alen_sec_wrap_pre             ( alen_sec_wrap_aw ),
      .to_boundary_master_pre        ( to_boundary_master_aw ),
      .mask_wrap_addr_pre            ( mask_wrap_addr_aw ),
      .sizeDiff_pre                  ( sizeDiff_aw ),
      .unaligned_wrap_burst_comb_pre ( unaligned_wrap_burst_comb_aw ),
      .len_offset_pre                ( len_offset_aw ),
      .wrap_tx_pre                   ( wrap_tx_aw ),
      .fixed_flag_comb_pre           ( fixed_flag_comb_aw )
      );

//========================W Channel====================
caxi4interconnect_DWC_UpConv_WChannel #
      (
      .ID_WIDTH       ( ID_WIDTH ),
      .DATA_WIDTH_IN  ( DATA_WIDTH_IN ),
      .DATA_WIDTH_OUT ( DATA_WIDTH_OUT ),
      .USER_WIDTH     ( USER_WIDTH ),
      .DATA_FIFO_DEPTH( DATA_FIFO_DEPTH ),
      .ADDR_FIFO_DEPTH( WRITE_ADDR_FIFO_DEPTH )
      )
    DWC_WChan
      (
      // Global Signals
      .ACLK                        ( ACLK ),
      .sysReset                    ( sysReset ),                        // active low reset synchronoise to RE AClk - asserted async.
      .awaddr_mst                  ( awaddr_mst ),
      .awsize_mst                  ( awsize_mst ),
      .awlen_slv                   ( SLAVE_AWLEN ),
      .awlen_mst                   ( awlen_mst ),
      .to_wrap_boundary_master     (awchan_to_wrap_boundary),
	  .MASTER_WID                  (MASTER_WID),
      .MASTER_WDATA                ( MASTER_WDATA ),
      .MASTER_WSTRB                ( MASTER_WSTRB ),
      .MASTER_WLAST                ( MASTER_WLAST ),
      .MASTER_WUSER                ( MASTER_WUSER ),
      .MASTER_WVALID               ( MASTER_WVALID ),

      .MASTER_WREADY               ( MASTER_WREADY ),

	  .SLAVE_WID                   ( SLAVE_WID ),
      .SLAVE_WDATA                 ( SLAVE_WDATA ),
      .SLAVE_WSTRB                 ( SLAVE_WSTRB ),
      .SLAVE_WLAST                 ( SLAVE_WLAST ),
      .SLAVE_WUSER                 ( SLAVE_WUSER ),
      .SLAVE_WVALID                ( SLAVE_WVALID ),

      .SLAVE_WREADY                ( SLAVE_WREADY ),
      .cmd_fifo_full               ( wchan_cmd_fifo_full ),
      .wr_en_cmd                   ( wchan_wr_en_cmd ),
      .extend_tx                   ( awchan_extend ),
      .wrap_flag                   ( wchan_wrap_flag ),
      .fixed_flag                  ( wchan_fixed_flag )
      );
                                                        
//========================B Channel====================        
caxi4interconnect_DWC_UpConv_BChannel #
      (
      .ID_WIDTH       ( ID_WIDTH ),
      .USER_WIDTH     ( USER_WIDTH ),
      .ADDR_FIFO_DEPTH( WRITE_ADDR_FIFO_DEPTH ),
      .READ_INTERLEAVE( READ_INTERLEAVE )
      )
    DWC_BChan
      (
      // Global Signals
      .ACLK                ( ACLK ),
      .sysReset            ( sysReset ),  // active low reset synchronoise to RE AClk - asserted async.
      .BRespFifoWrData     ( {awid_mst, ~awchan_extend} ),
      .MASTER_BID          ( MASTER_BID ),
      .MASTER_BRESP        ( MASTER_BRESP ),
      .MASTER_BUSER        ( MASTER_BUSER ),
      .MASTER_BVALID       ( MASTER_BVALID ),
      .MASTER_BREADY       ( MASTER_BREADY ),

      .SLAVE_BID           ( SLAVE_BID ),
      .SLAVE_BRESP         ( SLAVE_BRESP ),
      .SLAVE_BUSER         ( SLAVE_BUSER ),
      .SLAVE_BVALID        ( SLAVE_BVALID ),
      .SLAVE_BREADY        ( SLAVE_BREADY ),

      .bchan_cmd_fifo_full ( bchan_cmd_fifo_full ),
      .wr_en_cmd           ( wchan_wr_en_cmd )
      );

//=======================AR Channel====================
caxi4interconnect_DWC_UpConv_AChannel #
      (
      .ID_WIDTH      ( ID_WIDTH ),
      .ADDR_WIDTH    ( ADDR_WIDTH ),
      .USER_WIDTH    ( USER_WIDTH ),
      .DATA_WIDTH_IN ( DATA_WIDTH_IN ),
      .DATA_WIDTH_OUT( DATA_WIDTH_OUT ),
	  .TOTAL_IDS     (TOTAL_IDS),
	  .READ_INTERLEAVE (READ_INTERLEAVE)
      )
    DWC_ARChan 
      (
      // Global Signals
      .ACLK                          ( ACLK ),
      .sysReset                      ( sysReset ),        // active low reset synchronoise to RE AClk - asserted async.

      .fifoFull                      ( rchan_cmd_fifo_full ),
      .last_beat_wrap                ( archan_to_wrap_boundary ),
      .wr_en_cmd                     ( rchan_wr_en_cmd ),
      .asize_mst                     ( arsize_mst ),
      .wrap_flag                     ( rchan_wrap_flag ),
      .aid_mst                       ( arid_mst ),
      .fixed_flag                    ( rchan_fixed_flag ),
      .alen_mst                      ( arlen_mst ),

      .extend_tx                     ( archan_extend ),
      .addr_fifo                     ( araddr_mst ),
      .unaligned_wrap_burst          ( archan_unaligned_wrap_burst ),

      .alen_wrap_pre                 ( alen_wrap_ar ),
      .alen_sec_wrap_pre             ( alen_sec_wrap_ar ),
      .to_boundary_master_pre        ( to_boundary_master_ar ),
      .mask_wrap_addr_pre            ( mask_wrap_addr_ar ),
      .sizeDiff_pre                  ( sizeDiff_ar ),
      .unaligned_wrap_burst_comb_pre ( unaligned_wrap_burst_comb_ar ),
      .len_offset_pre                ( len_offset_ar ),
      .wrap_tx_pre                   ( wrap_tx_ar ),
      .fixed_flag_comb_pre           ( fixed_flag_comb_ar ),

      .MASTER_AID                    ( int_MASTER_ARID ),
      .MASTER_AADDR                  ( int_MASTER_ARADDR ),
      .MASTER_ALEN                   ( int_MASTER_ARLEN ),
      .MASTER_ASIZE                  ( int_MASTER_ARSIZE ),
      .MASTER_ABURST                 ( int_MASTER_ARBURST ),
      .MASTER_AQOS                   ( int_MASTER_ARQOS ),
      .MASTER_AREGION                ( int_MASTER_ARREGION ),
      .MASTER_ALOCK                  ( int_MASTER_ARLOCK ),
      .MASTER_ACACHE                 ( int_MASTER_ARCACHE ),
      .MASTER_APROT                  ( int_MASTER_ARPROT ),
      .MASTER_AUSER                  ( int_MASTER_ARUSER ),
      .MASTER_AVALID                 ( int_MASTER_ARVALID ),

      .MASTER_AREADY                 ( int_MASTER_ARREADY ),
      .SLAVE_AID                     ( SLAVE_ARID ),
      .SLAVE_AADDR                   ( SLAVE_ARADDR ),
      .SLAVE_ALEN                    ( SLAVE_ARLEN ),
      .SLAVE_ASIZE                   ( SLAVE_ARSIZE ),
      .SLAVE_ABURST                  ( SLAVE_ARBURST ),
      .SLAVE_AQOS                    ( SLAVE_ARQOS ),
      .SLAVE_AREGION                 ( SLAVE_ARREGION ),
      .SLAVE_ALOCK                   ( SLAVE_ARLOCK ),
      .SLAVE_ACACHE                  ( SLAVE_ARCACHE ),
      .SLAVE_APROT                   ( SLAVE_ARPROT ),
      .SLAVE_AUSER                   ( SLAVE_ARUSER ),
      .SLAVE_AVALID                  ( SLAVE_ARVALID ),

      .SLAVE_AREADY                  ( SLAVE_ARREADY )

      ); 
//=======================AR Channel Pre Calc====================  

caxi4interconnect_DWC_UpConv_preCalcAChannel #
      (
      .DATA_WIDTH_OUT ( DATA_WIDTH_OUT ), // DATA_WIDTH_IN as it is in the read direction
      .ADDR_WIDTH     ( ADDR_WIDTH ),
      .USER_WIDTH     ( USER_WIDTH ),
      .ID_WIDTH       ( ID_WIDTH )

      )
    DWC_UpConv_preCalcAChannel_ar_inst
      (
      .clk                                ( ACLK ),
      .rst                                ( sysReset ),

      .MASTER_ALEN_in                     (  MASTER_ARLEN ),
      .MASTER_AADDR_in                    ( MASTER_ARADDR ),
      .MASTER_ABURST_in                   ( MASTER_ARBURST ),
      .MASTER_ACACHE_in                   ( MASTER_ARCACHE ),
      .MASTER_AID_in                      ( MASTER_ARID ),
      .MASTER_ALOCK_in                    ( MASTER_ARLOCK ),
      .MASTER_APROT_in                    ( MASTER_ARPROT ),
      .MASTER_AQOS_in                     ( MASTER_ARQOS ),
      .MASTER_AREGION_in                  ( MASTER_ARREGION ),
      .MASTER_ASIZE_in                    ( MASTER_ARSIZE ),
      .MASTER_AUSER_in                    ( MASTER_ARUSER ),
      .MASTER_AVALID_in                   ( MASTER_ARVALID ),

      .MASTER_AREADY_in                   (  int_MASTER_ARREADY ), // from ctrl

      .MASTER_ALEN_out                    ( int_MASTER_ARLEN  ),
      .MASTER_AADDR_out                   ( int_MASTER_ARADDR ),
      .MASTER_ABURST_out                  ( int_MASTER_ARBURST ),
      .MASTER_ACACHE_out                  ( int_MASTER_ARCACHE ),
      .MASTER_AID_out                     ( int_MASTER_ARID ),
      .MASTER_ALOCK_out                   ( int_MASTER_ARLOCK ),
      .MASTER_APROT_out                   ( int_MASTER_ARPROT ),
      .MASTER_AQOS_out                    ( int_MASTER_ARQOS ),
      .MASTER_AREGION_out                 ( int_MASTER_ARREGION ),
      .MASTER_ASIZE_out                   ( int_MASTER_ARSIZE ),
      .MASTER_AUSER_out                   ( int_MASTER_ARUSER ),
      .MASTER_AVALID_out                  ( int_MASTER_ARVALID ),

      .MASTER_AREADY_out                  ( MASTER_ARREADY ), // to source

      .alen_wrap_pre                      ( alen_wrap_ar ),
      .alen_sec_wrap_pre                  ( alen_sec_wrap_ar ),
      .to_boundary_master_pre             ( to_boundary_master_ar ),
      .mask_wrap_addr_pre                 ( mask_wrap_addr_ar ),
      .sizeDiff_pre                       ( sizeDiff_ar ),
      .unaligned_wrap_burst_comb_pre      ( unaligned_wrap_burst_comb_ar ),
      .len_offset_pre                     ( len_offset_ar ),
      .wrap_tx_pre                        ( wrap_tx_ar ),
      .fixed_flag_comb_pre                ( fixed_flag_comb_ar )                                       
      );
//========================R Channel====================        
caxi4interconnect_DWC_UpConv_RChannel #
      (
      .ID_WIDTH           ( ID_WIDTH ),
      .DATA_WIDTH_IN      ( DATA_WIDTH_OUT ),
      .DATA_WIDTH_OUT     ( DATA_WIDTH_IN ),
      .USER_WIDTH         ( USER_WIDTH ),
      .DATA_FIFO_DEPTH    ( DATA_FIFO_DEPTH ),
      .ADDR_FIFO_DEPTH    ( READ_ADDR_FIFO_DEPTH ),
	  .READ_INTERLEAVE    (READ_INTERLEAVE),
	  .TOTAL_IDS          (TOTAL_IDS)
      )
    DWC_RChan
      (
      // Global Signals
      .ACLK               ( ACLK ),
      .sysReset           ( sysReset ),        // active low reset synchronoise to RE AClk - asserted async.
      .araddr_mstr        ( araddr_mst ),
      .arid_mstr          ( arid_mst ),
      .arlen_mstr         ( arlen_mst ),
      .MASTER_RSIZE       ( arsize_mst ),
      .fixed_flag         ( rchan_fixed_flag ),
      .MASTER_RDATA       ( MASTER_RDATA ),
      .MASTER_RLAST       ( MASTER_RLAST ),
      .MASTER_RUSER       ( MASTER_RUSER ),
      .MASTER_RVALID      ( MASTER_RVALID ),
      .MASTER_RID         ( MASTER_RID ),
      .MASTER_RRESP       ( MASTER_RRESP ),
      .MASTER_RREADY      ( MASTER_RREADY ),
      .SLAVE_RID          ( SLAVE_RID ),
      .SLAVE_RDATA        ( SLAVE_RDATA ),
      .SLAVE_RLAST        ( SLAVE_RLAST ),
      .SLAVE_RUSER        ( SLAVE_RUSER ),
      .SLAVE_RVALID       ( SLAVE_RVALID ),
      .SLAVE_RREADY       ( SLAVE_RREADY ),
      .SLAVE_RRESP        ( SLAVE_RRESP ),

      .cmd_fifo_full      ( rchan_cmd_fifo_full ),
      .wr_en_cmd          ( rchan_wr_en_cmd & (~rchan_wrap_flag | (rchan_wrap_flag & ~(archan_extend ^ archan_unaligned_wrap_burst ))) ),
      .to_boundary_master ( archan_to_wrap_boundary ),
      .wrap_flag          ( rchan_wrap_flag ),
      .extend_wrap        ( archan_extend )
);


endmodule // caxi4interconnect_UpConverter.v
