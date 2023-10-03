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
//     Abstract  : This modules manages the signals of the write data channel within the up converter.
//                 It includes:
//                 - master command caxi4interconnect_FIFO: it stores the relevant field of the master address channel   
//                 - slave command caxi4interconnect_FIFO: it stores the relevant field of the slave address channel
//                 - data caxi4interconnect_FIFO: it stores the master data, user and strobes
//                 - write data control: it merges data whenever the transfer size is smaller
//                   than the master data width
//                 - Write system control: it handles the write data channel control signals
//                   (i.e. last, valid and ready) at the master and slave side. It also manages
//                   some caxi4interconnect_FIFO signals at the read side (i.e. pass_data and read enable).
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 



module caxi4interconnect_DWC_UpConv_WChannel #

	(
		parameter integer	ID_WIDTH	= 1,
		parameter integer	USER_WIDTH	= 1,
		parameter integer	DATA_FIFO_DEPTH	= 1024,
		parameter integer	ADDR_FIFO_DEPTH	= 3,
		parameter integer	DATA_WIDTH_IN	= 32,
		parameter integer	DATA_WIDTH_OUT	= 32
	)
	(

		input wire sysReset,
		input wire ACLK,

		// Input Write channel
		// Address W channel
		input wire [5:0] awaddr_mst,
		input wire [7:0] awlen_slv,
		input wire [2:0] awsize_mst,

		// W channel
		input wire [ID_WIDTH-1:0]           MASTER_WID,
		input wire[DATA_WIDTH_IN-1:0]       MASTER_WDATA,
		input wire[(DATA_WIDTH_IN/8)-1:0]   MASTER_WSTRB,
		input wire[USER_WIDTH-1:0]          MASTER_WUSER,
		input wire MASTER_WLAST,
		input wire MASTER_WVALID,
		output wire MASTER_WREADY,

		// W channel
		output wire [ID_WIDTH-1:0]      SLAVE_WID,
		output wire[DATA_WIDTH_OUT-1:0] SLAVE_WDATA,
		output wire[(DATA_WIDTH_OUT/8)-1:0] SLAVE_WSTRB,
		output wire[USER_WIDTH-1:0] SLAVE_WUSER,
		output wire SLAVE_WLAST,
		output wire SLAVE_WVALID,
		input wire SLAVE_WREADY,

    output wire                           cmd_fifo_full,
		input wire			      wr_en_cmd,
		input wire[7:0]                            awlen_mst,
		input wire			      wrap_flag,
		input wire			      fixed_flag,
		input wire			      extend_tx,
		input wire [4:0] to_wrap_boundary_master
	);

	genvar i;

  
	localparam FIFO_DATA_WIDTH_IN = DATA_WIDTH_IN + DATA_WIDTH_IN/8;
	localparam FIFO_DATA_WIDTH_OUT = DATA_WIDTH_OUT + DATA_WIDTH_OUT/8;
	localparam CONV_RATIO = FIFO_DATA_WIDTH_OUT/FIFO_DATA_WIDTH_IN;
	localparam DATA_NEARLY_FULL = DATA_FIFO_DEPTH - 1;
	localparam DATA_NEARLY_EMPTY = (3*DATA_FIFO_DEPTH/4) - 1;

	wire wr_cmd_mst_fifo_full;
	wire wr_cmd_slv_fifo_full;
	wire wr_cmd_mst_fifo_empty;

  wire data_fifo_one_from_full;

 	wire [5:0] addr_out_mst;
  
	wire [2:0] awsize_out_mst;
	wire [7:0] curr_awlen_slv;

	wire [(CONV_RATIO)-1:0] zero_strb_data;
	wire [(CONV_RATIO)-1:0] wr_en_data;
  wire incr_pkt_cnt;

	wire [7:0] mst_beat_cnt;

	wire [(FIFO_DATA_WIDTH_OUT + USER_WIDTH + ID_WIDTH)-1:0] fifo_data_out_reg;
  
	wire [USER_WIDTH-1:0]         wuser_out;
	wire [DATA_WIDTH_OUT-1:0]     wdata_out;
	wire [(DATA_WIDTH_OUT/8)-1:0] wstrb_out;
	wire [ID_WIDTH-1:0]           wid_out;

	wire [ID_WIDTH+USER_WIDTH+DATA_WIDTH_IN+DATA_WIDTH_IN/8-1:0] fifo_data_in;

	wire pass_data;
	wire rd_en_data;

	wire rd_en_cmd_slv;
	wire rd_en_cmd_mst;

	wire extend_out_mst;
	wire wrap_flag_out_mst;
	wire fixed_flag_out_mst;
  
  
  


	

	wire [7:0] awlen_mst_out_mst;
  
	wire [4:0] to_wrap_boundary_out_mst;
  
  wire data_fifo_full;
  wire data_fifo_empty;
  wire data_fifo_nearly_full;
  wire data_fifo_nearly_empty;
  

	assign cmd_fifo_full = ( wr_cmd_slv_fifo_full | wr_cmd_mst_fifo_full ); // Both 'fifo_full' statements are really caxi4interconnect_FIFO nearly full

  
  
  // Hold signals for hold reg
  wire        wr_cmd_mst_hold_reg_empty;
  wire [4:0]  to_wrap_boundary_out_mst_hold;
  wire [7:0]  awlen_mst_out_mst_hold;
  wire        extend_out_mst_hold;
  wire        wrap_flag_out_mst_hold;

  wire        fixed_flag_out_mst_hold;
  wire        post_hold_rd_en_cmd_mst;
  
  wire [5:0]  addr_out_mst_hold;
  wire [2:0]  awsize_out_mst_hold;
        

  wire [6:0]    size_one_hot_hold;
  wire [5:0]    mask_addr_msb_hold;
  wire [5:0]    mask_addr_hold;
  wire          aligned_wrap_hold;
  wire          second_wrap_burst_hold;
  wire          extend_wrap_hold;

  
  wire [5:0]  size_shifted_out_mst_hold;
  wire master_beat_cnt_eq_0;
  wire [11:0]  master_beat_cnt_to_boundary_shifted;
  wire [11:0]  master_beat_cnt_shifted;
  
	caxi4interconnect_FIFO_upsizing #
	(
	  .MEM_DEPTH( DATA_FIFO_DEPTH ),
 	  .DATA_WIDTH_IN ( FIFO_DATA_WIDTH_IN ),
	  .DATA_WIDTH_OUT ( FIFO_DATA_WIDTH_OUT ), 
      .EXTRA_DATA_WIDTH( USER_WIDTH + ID_WIDTH ),
	  .NEARLY_FULL_THRESH ( DATA_NEARLY_FULL ),
	  .NEARLY_EMPTY_THRESH ( DATA_NEARLY_EMPTY )
	)
	data_fifo (
	  .rst ( sysReset ),
	  .clk ( ACLK ),
	  .wr_en ( wr_en_data ),
	  .rd_en ( rd_en_data ),
	  .data_in ( fifo_data_in ),
	  .data_out ( fifo_data_out_reg ),
	  .pass_data ( pass_data ),
	  .zero_data ( zero_strb_data ),
	  .fifo_full ( data_fifo_full ),
	  .fifo_empty ( data_fifo_empty ),
	  .fifo_nearly_full ( data_fifo_nearly_full ),
	  .fifo_nearly_empty ( data_fifo_nearly_empty ), //////
	  .fifo_one_from_full ( data_fifo_one_from_full ),
	  .zero_out_data	( 1'b0 )
	);	  


	caxi4interconnect_FIFO #
		(
			.MEM_DEPTH( ADDR_FIFO_DEPTH ),
			.DATA_WIDTH_IN ( 1 + 6 + 3 + 1 + 1 + 8 + 5),
			.DATA_WIDTH_OUT ( 1 + 6 + 3 + 1 + 1 + 8  + 5), 
			.NEARLY_FULL_THRESH ( ADDR_FIFO_DEPTH  -1 ),
			.NEARLY_EMPTY_THRESH ( 0 )
		)
	wr_cmd_mst (
			.rst (sysReset ),
			.clk ( ACLK ),
			.wr_en ( wr_en_cmd ),
			.rd_en ( post_hold_rd_en_cmd_mst ),
			.data_in ( {fixed_flag, awaddr_mst, awsize_mst, extend_tx, wrap_flag, awlen_mst, to_wrap_boundary_master} ),
			.data_out ( {fixed_flag_out_mst, addr_out_mst, awsize_out_mst, extend_out_mst, wrap_flag_out_mst, awlen_mst_out_mst, to_wrap_boundary_out_mst} ),
			.zero_data ( 1'b0 ),
			.fifo_full (  ),
			.fifo_empty ( wr_cmd_mst_fifo_empty ),
			.fifo_nearly_full ( wr_cmd_mst_fifo_full ),
			.fifo_nearly_empty ( ),
			.fifo_one_from_full ( )
	);

	caxi4interconnect_FIFO #
		(
			.MEM_DEPTH( ADDR_FIFO_DEPTH ),
 			.DATA_WIDTH_IN ( 8 ),
			.DATA_WIDTH_OUT ( 8 ), 
			.NEARLY_FULL_THRESH ( ADDR_FIFO_DEPTH -1 ),
			.NEARLY_EMPTY_THRESH ( 1 )
		)
	wr_cmd_slv (
			.rst ( sysReset ),
			.clk ( ACLK ),
			.wr_en ( wr_en_cmd ),
			.rd_en ( rd_en_cmd_slv ),
			.data_in ( awlen_slv ),
			.data_out ( curr_awlen_slv ),
			.zero_data ( 1'b0 ),
			.fifo_full (  ),
			.fifo_empty (  ),
			.fifo_nearly_full ( wr_cmd_slv_fifo_full ),
			.fifo_nearly_empty (  ),
			.fifo_one_from_full (  )
	);

  caxi4interconnect_DWC_UpConv_WChan_Hold_Reg #
    (
      .DATA_WIDTH_IN   ( DATA_WIDTH_IN ),
      .USER_WIDTH      ( USER_WIDTH ),
      .DATA_WIDTH_OUT  ( DATA_WIDTH_OUT )
    )
  caxi4interconnect_DWC_UpConv_WChan_Hold_Reg
  (
    .clk( ACLK ), // INPUT
    .rst( sysReset ), // INPUT

    // Hold Reg Ctrl sinals
    .DWC_UpConv_hold_fifo_empty    ( wr_cmd_mst_fifo_empty ), // INPUT
    .DWC_UpConv_hold_get_next_data ( rd_en_cmd_mst ), // INPUT

    .DWC_UpConv_hold_fifo_rd_en    ( post_hold_rd_en_cmd_mst ), // OUTPUT
    .DWC_UpConv_hold_reg_empty     ( wr_cmd_mst_hold_reg_empty ), // OUTPUT

    // Inputs to be decoded (from Master Cmd caxi4interconnect_FIFO) - going into this holding reg
    .to_boundary     ( to_wrap_boundary_out_mst ),    
    .addr            ( addr_out_mst ),
    .size            ( awsize_out_mst ),
    .wlen_mst        ( awlen_mst_out_mst ),
    .extend_tx       ( extend_out_mst ),
    .wrap_flag       ( wrap_flag_out_mst ),
    .fixed_flag      ( fixed_flag_out_mst ),

    // outputs
    .to_boundary_out     ( to_wrap_boundary_out_mst_hold ),
    .addr_out            ( addr_out_mst_hold ),
    .wlen_mst_out        ( awlen_mst_out_mst_hold ),
    .extend_tx_out       ( extend_out_mst_hold ),
    .wrap_flag_out       ( wrap_flag_out_mst_hold ),
    .fixed_flag_out      ( fixed_flag_out_mst_hold ),
    .size_out            ( awsize_out_mst_hold ),
    .size_shifted_out    ( size_shifted_out_mst_hold ),
    
    // Decoded outputs
    .mask_addr_out         ( mask_addr_hold ),
    .aligned_wrap_out      ( aligned_wrap_hold ),
    .second_wrap_burst_out ( second_wrap_burst_hold ),
    .extend_wrap_out       ( extend_wrap_hold ) 

  );

  caxi4interconnect_DWC_UpConv_Wchan_WriteDataFifoCtrl #
    (
      .DATA_WIDTH_IN   ( DATA_WIDTH_IN ),
      .USER_WIDTH      ( USER_WIDTH ),
      .DATA_WIDTH_OUT  ( DATA_WIDTH_OUT ),	  
	  .ID_WIDTH        ( ID_WIDTH)
    )
  WriteDataCtrl
  (
      .ACLK            ( ACLK ),
      .sysReset        ( sysReset ),
      .data_fifo_nearly_full  ( data_fifo_nearly_full ), // INPUT
      .cmd_fifo_empty  ( wr_cmd_mst_hold_reg_empty ),                // INPUT

      .wready          ( MASTER_WREADY ),
      .wvalid          ( MASTER_WVALID ),
      .beat_cnt        ( mst_beat_cnt ),
      .wlast           ( MASTER_WLAST ),
	  
      .size_shifted    ( size_shifted_out_mst_hold ),
	  .master_beat_cnt_shifted (master_beat_cnt_shifted),
	  .master_beat_cnt_to_boundary_shifted (master_beat_cnt_to_boundary_shifted),
	  .master_beat_cnt_eq_0 (master_beat_cnt_eq_0),
     
      .to_boundary     ( to_wrap_boundary_out_mst_hold ), // from hold
      .addr            ( addr_out_mst_hold ),                // from hold
      .wlen_mst        ( awlen_mst_out_mst_hold ),           // from hold
      .extend_tx       ( extend_out_mst_hold ),              // from hold
      .wrap_flag       ( wrap_flag_out_mst_hold ),           // from hold
      .fixed_flag      ( fixed_flag_out_mst_hold ),          // from hold
      .size            ( awsize_out_mst_hold ),              // from hold
      
      .incr_pkt_cnt    ( incr_pkt_cnt ),
      .wr_en           ( wr_en_data ),         
      .data_in         ( {MASTER_WID,MASTER_WUSER, MASTER_WSTRB, MASTER_WDATA} ),     // INPUT
      .data_out        ( fifo_data_in ),            // OUTPUT
      .zero_strb_data  ( zero_strb_data ),           // OUTPUT
      
      // Decoded Inputs
      .mask_addr         ( mask_addr_hold ),
      .aligned_wrap      ( aligned_wrap_hold ),
      .second_wrap_burst ( second_wrap_burst_hold ),
      .extend_wrap       ( extend_wrap_hold )
    
  );

	generate
		for (i=0; i<(CONV_RATIO); i=i+1) begin
			assign wdata_out [DATA_WIDTH_IN*i+:DATA_WIDTH_IN]          = fifo_data_out_reg[(FIFO_DATA_WIDTH_IN)*i+:DATA_WIDTH_IN];
			assign wstrb_out [(DATA_WIDTH_IN/8)*i+:(DATA_WIDTH_IN/8)]  = fifo_data_out_reg[((FIFO_DATA_WIDTH_IN)*i+DATA_WIDTH_IN)+:(DATA_WIDTH_IN/8)];
		end
	endgenerate
    
	assign wuser_out = fifo_data_out_reg[(FIFO_DATA_WIDTH_OUT) +: USER_WIDTH];
    assign wid_out   = fifo_data_out_reg[(FIFO_DATA_WIDTH_OUT+USER_WIDTH) +: ID_WIDTH];
	
	assign SLAVE_WDATA = wdata_out;
	assign SLAVE_WSTRB = wstrb_out;
	assign SLAVE_WUSER = wuser_out;
    assign SLAVE_WID   = wid_out;
	
  caxi4interconnect_DWC_UpConv_WChan_ReadDataFifoCtrl # 
   (
      .LOG_OPEN_TX( $clog2(ADDR_FIFO_DEPTH) ),
      .SIZE_OUT           ($clog2(DATA_WIDTH_OUT/8))
   )
  wr_sys_ctrl 
   (
      .SLAVE_WREADY       ( SLAVE_WREADY ),
      .SLAVE_WLAST        ( SLAVE_WLAST ),
      .SLAVE_WVALID       ( SLAVE_WVALID ),
      .SLAVE_WLEN         ( curr_awlen_slv ),
      .extend_tx          ( extend_out_mst_hold ),// from hold
      .wrap_flag_mst      ( wrap_flag_out_mst_hold ),// from hold
      .ACLK               ( ACLK ),
      .MASTER_WVALID      ( MASTER_WVALID ),
      .MASTER_WLAST       ( MASTER_WLAST ),
      .MASTER_WREADY      ( MASTER_WREADY ),
      .data_fifo_nearly_full     ( data_fifo_nearly_full ), /////////////////////////////////////////////
      .sysReset           ( sysReset ),
      .fifo_nearly_empty  ( data_fifo_nearly_empty ), // Hold off trandmitting data if level of data in caxi4interconnect_FIFO is below this threshold
      .fifo_empty         ( data_fifo_empty ),
      .size            ( awsize_out_mst_hold ),              // from hold
      .incr_pkt_cnt       ( incr_pkt_cnt ),
      .master_beat_cnt    ( mst_beat_cnt ),
      .pass_data          ( pass_data ),
      .rd_en_data         ( rd_en_data ), 
      .rd_en_cmd_mst      ( rd_en_cmd_mst ), // output
      .rd_en_cmd_slv      ( rd_en_cmd_slv ),
      .cmd_fifo_empty     ( wr_cmd_mst_hold_reg_empty ),
	  .master_beat_cnt_eq_0 (master_beat_cnt_eq_0),
      .to_boundary        ( to_wrap_boundary_out_mst_hold ),
	  .master_beat_cnt_shifted (master_beat_cnt_shifted),
	  .master_beat_cnt_to_boundary_shifted (master_beat_cnt_to_boundary_shifted)
   );

endmodule
