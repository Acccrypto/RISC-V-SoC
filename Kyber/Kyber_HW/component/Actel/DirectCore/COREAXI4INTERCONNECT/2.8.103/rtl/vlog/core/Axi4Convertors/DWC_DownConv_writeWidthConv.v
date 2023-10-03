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

module caxi4interconnect_DWC_DownConv_writeWidthConv( MASTER_AWREADY,
                       MASTER_AWADDR,
                       MASTER_AWBURST,
                       MASTER_AWCACHE,
                       MASTER_AWID,
                       MASTER_AWLEN,
                       MASTER_AWLOCK,
                       MASTER_AWPROT,
                       MASTER_AWQOS,
                       MASTER_AWREGION,
                       MASTER_AWSIZE,
                       MASTER_AWUSER,
                       MASTER_AWVALID,
                       SLAVE_BID,
                       SLAVE_BREADY,
                       SLAVE_BRESP,
                       SLAVE_BUSER,
                       SLAVE_BVALID,
                       SLAVE_AWADDR,
                       SLAVE_AWBURST,
                       SLAVE_AWCACHE,
                       SLAVE_AWID,
                       SLAVE_AWLEN,
                       SLAVE_AWLOCK,
                       SLAVE_AWPROT,
                       SLAVE_AWQOS,
                       SLAVE_AWREADY,
                       SLAVE_AWREGION,
                       SLAVE_AWSIZE,
                       SLAVE_AWUSER,
                       SLAVE_AWVALID,
                       MASTER_BID,
                       MASTER_BREADY,
                       MASTER_BRESP,
                       MASTER_BUSER,
                       MASTER_BVALID,
					   MASTER_WID,
                       MASTER_WDATA,
                       MASTER_WLAST,
                       MASTER_WREADY,
                       MASTER_WSTRB,
                       MASTER_WUSER,
                       MASTER_WVALID,
					   SLAVE_WID,
                       SLAVE_WDATA,
                       SLAVE_WLAST,
                       SLAVE_WREADY,
                       SLAVE_WSTRB,
                       SLAVE_WUSER,
                       SLAVE_WVALID,
                       ACLK,
                       sysReset );

parameter CMD_FIFO_DATA_WIDTH = 29; 
parameter DATA_WIDTH_IN = 32; 
parameter DATA_WIDTH_OUT = 32; 
parameter ADDR_FIFO_DEPTH = 5; 
parameter ADDR_WIDTH = 20; 
parameter ID_WIDTH = 1; 
parameter USER_WIDTH = 1; 
parameter STRB_WIDTH_IN = 64; 
parameter STRB_WIDTH_OUT = 4; 
parameter READ_INTERLEAVE = 0; 

localparam     TOTAL_IDS = READ_INTERLEAVE ? (2 ** ID_WIDTH) : 1;

// Port: MASTER_AWChan

output         MASTER_AWREADY;
input [ADDR_WIDTH-1:0] MASTER_AWADDR;
input [1:0]    MASTER_AWBURST;
input [3:0]    MASTER_AWCACHE;
input [ID_WIDTH-1:0] MASTER_AWID;
input [7:0]    MASTER_AWLEN;
input [1:0]    MASTER_AWLOCK;
input [2:0]    MASTER_AWPROT;
input [3:0]    MASTER_AWQOS;
input [3:0]    MASTER_AWREGION;
input [2:0]    MASTER_AWSIZE;
input [USER_WIDTH-1:0] MASTER_AWUSER;
input          MASTER_AWVALID;

// Port: SLAVE_BChan

input [ID_WIDTH-1:0] SLAVE_BID;
output         SLAVE_BREADY;
input [1:0]    SLAVE_BRESP;
input [USER_WIDTH-1:0] SLAVE_BUSER;
input          SLAVE_BVALID;

// Port: SLAVE_AWChan

output [ADDR_WIDTH-1:0] SLAVE_AWADDR;
output [1:0]   SLAVE_AWBURST;
output [3:0]   SLAVE_AWCACHE;
output [ID_WIDTH-1:0] SLAVE_AWID;
output [7:0]   SLAVE_AWLEN;
output [1:0]   SLAVE_AWLOCK;
output [2:0]   SLAVE_AWPROT;
output [3:0]   SLAVE_AWQOS;
input          SLAVE_AWREADY;
output [3:0]   SLAVE_AWREGION;
output [2:0]   SLAVE_AWSIZE;
output [USER_WIDTH-1:0] SLAVE_AWUSER;
output         SLAVE_AWVALID;

// Port: MASTER_BChan

output [ID_WIDTH-1:0] MASTER_BID;
input          MASTER_BREADY;
output [1:0]   MASTER_BRESP;
output [USER_WIDTH-1:0] MASTER_BUSER;
output         MASTER_BVALID;

// Port: MASTER_WChan

input [ID_WIDTH-1:0]      MASTER_WID;
input [DATA_WIDTH_IN-1:0] MASTER_WDATA;
input          MASTER_WLAST;
output         MASTER_WREADY;
input [STRB_WIDTH_IN-1:0] MASTER_WSTRB;
input [USER_WIDTH-1:0] MASTER_WUSER;
input          MASTER_WVALID;

// Port: SLAVE_WChan

output [ID_WIDTH-1:0]       SLAVE_WID;
output [DATA_WIDTH_OUT-1:0] SLAVE_WDATA;
output         SLAVE_WLAST;
input          SLAVE_WREADY;
output [STRB_WIDTH_OUT-1:0] SLAVE_WSTRB;
output [USER_WIDTH-1:0] SLAVE_WUSER;
output         SLAVE_WVALID;

// Port: system

input          ACLK;
input          sysReset;


wire                  brespFifoEmpty;
wire [TOTAL_IDS-1:0]  brespFifoEmpty_temp;
wire [ID_WIDTH:0]     brespFifoWrData;
wire [TOTAL_IDS-1:0]  brespFifoNearlyFull;
wire           brespFifore;
wire           brespFifowe;
wire           wrCmdFifoEmpty;
wire           wrCmdFifoNearlyFull;
wire [CMD_FIFO_DATA_WIDTH-1:0] wrCmdFifoRdData;
wire           wrCmdFifore;
wire           wrCmdFifowe;
wire [CMD_FIFO_DATA_WIDTH-1:0] wrCmdFifowrData;


// wire [8:0]	to_boundary_conv_pre;
wire [4:0]	to_boundary_master_pre;
wire [5:0]  mask_addr_pre;
wire [2:0]	ASIZE_pre;
wire [12:0]	tot_len_M_to_boundary_conv_pre;
wire [7:0]	to_boundary_conv_M1_pre;
wire [12:0]	tot_len_pre;
wire [8:0]	max_length_comb_pre;
wire [8:0]	length_comb_pre;
wire 				tot_len_GT_max_length_comb_pre;
wire [12:0]	tot_len_M_max_length_comb_pre;
wire [7:0]	tot_axi_len_pre;
wire [2:0]	wrap_log_len_comb_pre;
wire [5:0]	sizeMax_pre;
wire 				SameMstSlvSize_pre;
wire [5:0]	sizeCnt_comb_pre;
wire            fixed_burst;
wire [6:0]      unaligned_fixed_len_iter;
wire MASTER_AWVALID_reg;
wire from_ctrl_MASTER_READY;
wire to_ctrl_MASTER_AWVALID;

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

wire [7:0] slaveLen_M1;
wire [5:0] master_ADDR_masked;
wire [5:0] second_Beat_Addr;
wire       sizeCnt_comb_EQ_SizeMax;
wire [5:0] sizeCnt_comb_P1;


/// I/O_End <<<---



wire [CMD_FIFO_DATA_WIDTH-1:0] preHold_wrCmdFifoRdData;
wire						   preHold_wrCmdFifoEmpty;
wire 						   postHold_wrCmdFifore;
wire [ADDR_WIDTH - 1:0]        MASTER_AWADDR_mux;
wire                           wrcmd_full;
wire                           bresp_full;


/// Components_Start --->>>


// File: caxi4interconnect_FIFO.v

defparam wrCmdFifo.DATA_WIDTH_IN = CMD_FIFO_DATA_WIDTH;
defparam wrCmdFifo.DATA_WIDTH_OUT = CMD_FIFO_DATA_WIDTH;
defparam wrCmdFifo.MEM_DEPTH = ADDR_FIFO_DEPTH;
defparam wrCmdFifo.NEARLY_FULL_THRESH = ADDR_FIFO_DEPTH-1;

caxi4interconnect_FIFO wrCmdFifo( 
            .data_in(wrCmdFifowrData[CMD_FIFO_DATA_WIDTH-1:0]),
            .fifo_full(),
            .fifo_nearly_full(wrCmdFifoNearlyFull),
            .fifo_one_from_full(),
            .wr_en(wrCmdFifowe),
            .zero_data(1'b0),
            .data_out(preHold_wrCmdFifoRdData[CMD_FIFO_DATA_WIDTH-1:0]),
            .fifo_empty(preHold_wrCmdFifoEmpty),
            .fifo_nearly_empty(),
            .rd_en(postHold_wrCmdFifore),
            .clk(ACLK),
            .rst(sysReset) );



// File: caxi4interconnect_DWC_DownConv_Hold_Reg_Wr.v

defparam caxi4interconnect_DWC_DownConv_Hold_Reg_Wr.CMD_FIFO_DATA_WIDTH = CMD_FIFO_DATA_WIDTH;
defparam caxi4interconnect_DWC_DownConv_Hold_Reg_Wr.ID_WIDTH = ID_WIDTH;

caxi4interconnect_DWC_DownConv_Hold_Reg_Wr caxi4interconnect_DWC_DownConv_Hold_Reg_Wr(
                .ACLK(ACLK), // INPUT
                .sysReset(sysReset), // INPUT
                
                .DWC_DownConv_hold_data_in(preHold_wrCmdFifoRdData[CMD_FIFO_DATA_WIDTH-1:0]), // INPUT
                .DWC_DownConv_hold_fifo_empty(preHold_wrCmdFifoEmpty), // INPUT

                .DWC_DownConv_hold_get_next_data(wrCmdFifore), // INPUT

                .DWC_DownConv_hold_fifo_rd_en(postHold_wrCmdFifore), // OUTPUT
                .DWC_DownConv_hold_data_out(wrCmdFifoRdData[CMD_FIFO_DATA_WIDTH-1:0]), // OUTPUT
                .DWC_DownConv_hold_reg_empty(wrCmdFifoEmpty), // OUTPUT

                .slaveLen_M1               ( slaveLen_M1), // OUTPUT
                .master_ADDR_masked        ( master_ADDR_masked ), // OUTPUT
                .second_Beat_Addr          ( second_Beat_Addr ), // OUTPUT
                .sizeCnt_comb_EQ_SizeMax   ( sizeCnt_comb_EQ_SizeMax ), // OUTPUT
                .sizeCnt_comb_P1           ( sizeCnt_comb_P1) // OUTPUT
                );

// File: widthConvwr.v

defparam widthConvwr.ID_WIDTH = ID_WIDTH;
defparam widthConvwr.DATA_WIDTH_IN = DATA_WIDTH_IN;
defparam widthConvwr.DATA_WIDTH_OUT = DATA_WIDTH_OUT;
defparam widthConvwr.CMD_FIFO_DATA_WIDTH = CMD_FIFO_DATA_WIDTH;
defparam widthConvwr.STRB_WIDTH_IN = STRB_WIDTH_IN;
defparam widthConvwr.USER_WIDTH = USER_WIDTH;
defparam widthConvwr.STRB_WIDTH_OUT = STRB_WIDTH_OUT;

caxi4interconnect_DWC_DownConv_widthConvwr widthConvwr(
                         .ACLK(ACLK),
                         .sysReset(sysReset),
                         .wrCmdFifoEmpty(wrCmdFifoEmpty),
                         .wrCmdFifoRdData(wrCmdFifoRdData),
                         .wrCmdFifore(wrCmdFifore),
						 .MASTER_WID (MASTER_WID),
                         .MASTER_WDATA(MASTER_WDATA),
                         .MASTER_WREADY(MASTER_WREADY),
                         .MASTER_WSTRB(MASTER_WSTRB),
                         .MASTER_WUSER(MASTER_WUSER),
                         .MASTER_WVALID(MASTER_WVALID),
						 .SLAVE_WID  (SLAVE_WID),
                         .SLAVE_WDATA(SLAVE_WDATA),
                         .SLAVE_WLAST(SLAVE_WLAST),
                         .SLAVE_WREADY(SLAVE_WREADY),
                         .SLAVE_WSTRB(SLAVE_WSTRB),
                         .SLAVE_WUSER(SLAVE_WUSER),
                         .SLAVE_WVALID(SLAVE_WVALID),
                         
                         .slaveLEN_M1               ( slaveLen_M1),
                         .master_ADDR_masked        ( master_ADDR_masked ),
                         .second_Beat_Addr          ( second_Beat_Addr ),
                         .sizeCnt_comb_EQ_SizeMax   ( sizeCnt_comb_EQ_SizeMax ),
                         .sizeCnt_comb_P1           ( sizeCnt_comb_P1)
          );

genvar id_range; 
	
generate  

  if(READ_INTERLEAVE)
    begin 
  
      wire [TOTAL_IDS-1:0]  BRespFifoRdData;
	  
      defparam brespCtrl.ID_WIDTH = ID_WIDTH;
      defparam brespCtrl.USER_WIDTH = USER_WIDTH;

      caxi4interconnect_DWC_brespCtrl brespCtrl(
                           .SLAVE_BREADY(SLAVE_BREADY),
                           .SLAVE_BRESP(SLAVE_BRESP),
                           .SLAVE_BUSER(SLAVE_BUSER),
                           .SLAVE_BVALID(SLAVE_BVALID),
                           .SLAVE_BID(SLAVE_BID),
                           .BRespFifoRdData(BRespFifoRdData[SLAVE_BID]),
                           .bresp_fifo_empty(brespFifoEmpty),
                           .brespFifore(brespFifore),
                           .ACLK(ACLK),
                           .sysReset(sysReset),
      
                           .MASTER_BID(MASTER_BID),
                           .MASTER_BREADY(MASTER_BREADY),
                           .MASTER_BRESP(MASTER_BRESP),
                           .MASTER_BUSER(MASTER_BUSER),
                           .MASTER_BVALID(MASTER_BVALID) );

      for(id_range = 0; id_range < TOTAL_IDS; id_range = id_range+1)
        begin 
	    
          caxi4interconnect_FIFO BrespCmdFifo( 
                       .data_in(brespFifoWrData[0]),
                       .fifo_full(),
                       .fifo_nearly_full(brespFifoNearlyFull[id_range]),
                       .fifo_one_from_full(),
                       .wr_en(wrCmdFifowe & (brespFifoWrData[ID_WIDTH:1] == id_range)),
                       .zero_data(1'b0),
                       .data_out(BRespFifoRdData[id_range]),
                       .fifo_empty(brespFifoEmpty_temp[id_range]),
                       .fifo_nearly_empty(),
                       .rd_en(brespFifore & (SLAVE_BID == id_range)),
                       .clk(ACLK),
                       .rst(sysReset) );
	    			   
          defparam BrespCmdFifo.DATA_WIDTH_IN = 1;
          defparam BrespCmdFifo.DATA_WIDTH_OUT = 1;
          defparam BrespCmdFifo.MEM_DEPTH = ADDR_FIFO_DEPTH;
          defparam BrespCmdFifo.NEARLY_FULL_THRESH = ADDR_FIFO_DEPTH-1;				   
        end 	 
		
        assign brespFifoEmpty = MASTER_BVALID ? brespFifoEmpty_temp[MASTER_BID] : brespFifoEmpty_temp[SLAVE_BID];		
		assign wrcmd_full     = wrCmdFifoNearlyFull;
		assign bresp_full     = (|brespFifoNearlyFull);
		
	end 
  else 
    begin 
	
	  wire [ID_WIDTH:0]   BRespFifoRdData;
	  
	  defparam brespCtrl.ID_WIDTH = ID_WIDTH;
      defparam brespCtrl.USER_WIDTH = USER_WIDTH;
  
	  caxi4interconnect_DWC_brespCtrl brespCtrl(
                     .SLAVE_BREADY(SLAVE_BREADY),
                     .SLAVE_BRESP(SLAVE_BRESP),
                     .SLAVE_BUSER(SLAVE_BUSER),
                     .SLAVE_BVALID(SLAVE_BVALID),
                     .SLAVE_BID(BRespFifoRdData[ID_WIDTH:1]),										   
                     .BRespFifoRdData(BRespFifoRdData[0]),
                     .bresp_fifo_empty(brespFifoEmpty),
                     .brespFifore(brespFifore),
                     .ACLK(ACLK),
                     .sysReset(sysReset),

                     .MASTER_BID(MASTER_BID),
                     .MASTER_BREADY(MASTER_BREADY),
                     .MASTER_BRESP(MASTER_BRESP),
                     .MASTER_BUSER(MASTER_BUSER),
                     .MASTER_BVALID(MASTER_BVALID) );

// File: caxi4interconnect_FIFO.v

      defparam BrespCmdFifo.DATA_WIDTH_IN = 1+ID_WIDTH;
      defparam BrespCmdFifo.DATA_WIDTH_OUT = 1+ID_WIDTH;
      defparam BrespCmdFifo.MEM_DEPTH = ADDR_FIFO_DEPTH;
      defparam BrespCmdFifo.NEARLY_FULL_THRESH = ADDR_FIFO_DEPTH-1;
	  
      caxi4interconnect_FIFO BrespCmdFifo( 
                         .data_in(brespFifoWrData),
                         .fifo_full(),
                         .fifo_nearly_full(brespFifoNearlyFull),
                         .fifo_one_from_full(),
                         .wr_en(wrCmdFifowe),
                         .zero_data(1'b0),
                         .data_out(BRespFifoRdData),
                         .fifo_empty(brespFifoEmpty),
                         .fifo_nearly_empty(),
                         .rd_en(brespFifore),
                         .clk(ACLK),
                         .rst(sysReset) );
						 
      assign wrcmd_full     = wrCmdFifoNearlyFull;
	  assign bresp_full     = brespFifoNearlyFull;
	  

	end 
	
endgenerate 	

// File: CmdFifoWriteCtrl.v

defparam wrCmdFifoWriteCtrl.ADDR_WIDTH = ADDR_WIDTH;
defparam wrCmdFifoWriteCtrl.CMD_FIFO_DATA_WIDTH = CMD_FIFO_DATA_WIDTH;
defparam wrCmdFifoWriteCtrl.ID_WIDTH = ID_WIDTH;
defparam wrCmdFifoWriteCtrl.USER_WIDTH = USER_WIDTH;
defparam wrCmdFifoWriteCtrl.DATA_WIDTH_IN = DATA_WIDTH_IN;
defparam wrCmdFifoWriteCtrl.DATA_WIDTH_OUT = DATA_WIDTH_OUT;
defparam wrCmdFifoWriteCtrl.READ_INTERLEAVE = READ_INTERLEAVE;

caxi4interconnect_DWC_DownConv_CmdFifoWriteCtrl wrCmdFifoWriteCtrl( 
                                     .MASTER_AADDR(int_MASTER_AWADDR),
                                     .MASTER_ABURST(int_MASTER_AWBURST),
                                     .MASTER_ACACHE(int_MASTER_AWCACHE),
                                     .MASTER_AID(int_MASTER_AWID),
                                     .MASTER_ALOCK(int_MASTER_AWLOCK),
                                     .MASTER_APROT(int_MASTER_AWPROT),
                                     .MASTER_AQOS(int_MASTER_AWQOS),
                                     
                                     .MASTER_AREADY(int_MASTER_AWREADY), // output from module
                                     
                                     .MASTER_AREGION(int_MASTER_AWREGION),
                                     .MASTER_ASIZE(int_MASTER_AWSIZE),
                                     .MASTER_AUSER(int_MASTER_AWUSER),
                                     .MASTER_AVALID(int_MASTER_AWVALID),
                                     .CmdFifoNearlyFull(wrcmd_full),
                                     .FifoWe(wrCmdFifowe),
                                     .CmdFifoWrData(wrCmdFifowrData[CMD_FIFO_DATA_WIDTH-1:0]),
                                     .brespFifoWrData(brespFifoWrData),
                                     .brespFifoNearlyFull(bresp_full),
                                     .ACLK(ACLK),
                                     .sysReset(sysReset),

                                     // .to_boundary_conv            ( to_boundary_conv_pre ),
                                     .to_boundary_master            ( to_boundary_master_pre ),
                                     .mask_addr                   ( mask_addr_pre ),
                                     .ASIZE                       ( ASIZE_pre ),
                                     // .tot_len_M_to_boundary_conv  ( tot_len_M_to_boundary_conv_pre ),
                                     // .to_boundary_conv_M1         ( to_boundary_conv_M1_pre ),
                                     .tot_len                     ( tot_len_pre ),
                                     .max_length_comb             ( max_length_comb_pre ),
                                     .length_comb                 ( length_comb_pre ),
                                     // .tot_len_GT_max_length_comb  ( tot_len_GT_max_length_comb_pre ),
                                     // .tot_len_M_max_length_comb   ( tot_len_M_max_length_comb_pre ),
                                     // .tot_axi_len                 ( tot_axi_len_pre ),
                                     .WrapLogLen_comb             ( wrap_log_len_comb_pre ),
                                     .SizeMax                     ( sizeMax_pre ),
                                     .SameMstSlvSize              ( SameMstSlvSize_pre ),
                                     .sizeCnt_comb                ( sizeCnt_comb_pre ),
                                     .MASTER_AADDR_mux (MASTER_AWADDR_mux),
				                     .fixed_burst                 ( fixed_burst),
                                     .unaligned_fixed_len_iter    (unaligned_fixed_len_iter),

                                     .SLAVE_AADDR(SLAVE_AWADDR),
                                     .SLAVE_ABURST(SLAVE_AWBURST),
                                     .SLAVE_ACACHE(SLAVE_AWCACHE),
                                     .SLAVE_AID(SLAVE_AWID),
                                     .SLAVE_ALEN(SLAVE_AWLEN),
                                     .SLAVE_ALOCK(SLAVE_AWLOCK),
                                     .SLAVE_APROT(SLAVE_AWPROT),
                                     .SLAVE_AQOS(SLAVE_AWQOS),
                                     .SLAVE_AREADY(SLAVE_AWREADY),
                                     .SLAVE_AREGION(SLAVE_AWREGION),
                                     .SLAVE_ASIZE(SLAVE_AWSIZE), // Longest path is here
                                     .SLAVE_AUSER(SLAVE_AWUSER),
                                     .SLAVE_AVALID(SLAVE_AWVALID) 
                                     );

// File: caxi4interconnect_DWC_DownConv_preCalcCmdFifoWrCtrl.v

caxi4interconnect_DWC_DownConv_preCalcCmdFifoWrCtrl #
                                 (
                                .DATA_WIDTH_OUT ( DATA_WIDTH_OUT ),
                                .DATA_WIDTH_IN ( DATA_WIDTH_IN ),
                                .ADDR_WIDTH( ADDR_WIDTH ),
                                .USER_WIDTH( USER_WIDTH ),
                                .ID_WIDTH( ID_WIDTH ),
								.WRITE_ENABLE (1'b1)   // 1 - Write 0 - Read 

                                )
    DWC_DownConv_preCalcCmdFifoWrCtrl_inst  (
                                .clk( ACLK ),
                                .rst( sysReset ),
                                
                                
                                 .MASTER_ALEN_in    ( MASTER_AWLEN ),
                                 .MASTER_AADDR_in   (MASTER_AWADDR),
                                 .MASTER_ABURST_in  (MASTER_AWBURST),
                                 .MASTER_ACACHE_in  (MASTER_AWCACHE),
                                 .MASTER_AID_in     (MASTER_AWID),
                                 .MASTER_ALOCK_in   (MASTER_AWLOCK),
                                 .MASTER_APROT_in   (MASTER_AWPROT),
                                 .MASTER_AQOS_in    (MASTER_AWQOS),
                                 .MASTER_AREGION_in (MASTER_AWREGION),
                                 .MASTER_ASIZE_in   (MASTER_AWSIZE),
                                 .MASTER_AUSER_in   (MASTER_AWUSER),
                                 .MASTER_AVALID_in  (MASTER_AWVALID),
                                 
                                 .MASTER_AREADY_in(int_MASTER_AWREADY), // from ctrl

                                 .MASTER_ALEN_out(int_MASTER_AWLEN ),
                                 .MASTER_AADDR_out(int_MASTER_AWADDR),
                                 .MASTER_ABURST_out(int_MASTER_AWBURST),
                                 .MASTER_ACACHE_out(int_MASTER_AWCACHE),
                                 .MASTER_AID_out(int_MASTER_AWID),
                                 .MASTER_ALOCK_out(int_MASTER_AWLOCK),
                                 .MASTER_APROT_out(int_MASTER_AWPROT),
                                 .MASTER_AQOS_out(int_MASTER_AWQOS),
                                 .MASTER_AREGION_out(int_MASTER_AWREGION),
                                 .MASTER_ASIZE_out(int_MASTER_AWSIZE),
                                 .MASTER_AUSER_out(int_MASTER_AWUSER),
                                 .MASTER_AVALID_out(int_MASTER_AWVALID),

                                 .MASTER_AREADY_out(MASTER_AWREADY), // to source

                                .MASTER_AADDR_mux_pre (MASTER_AWADDR_mux),                                
                                // .to_boundary_conv_pre           ( to_boundary_conv_pre ),
                                .to_boundary_master_pre           ( to_boundary_master_pre ),
                                .mask_addr_pre                  ( mask_addr_pre ),
                                .ASIZE_pre                      ( ASIZE_pre ),
                                // .tot_len_M_to_boundary_conv_pre ( tot_len_M_to_boundary_conv_pre ),
                                // .to_boundary_conv_M1_pre        ( to_boundary_conv_M1_pre ),
                                .tot_len_pre                    ( tot_len_pre ),
                                .max_length_comb_pre            ( max_length_comb_pre ),
																.length_comb_pre								( length_comb_pre ),
                                // .tot_len_GT_max_length_comb_pre ( tot_len_GT_max_length_comb_pre ),
                                // .tot_len_M_max_length_comb_pre  ( tot_len_M_max_length_comb_pre ),
                                // .tot_axi_len_pre                ( tot_axi_len_pre ),
                                .WrapLogLen_comb_pre            ( wrap_log_len_comb_pre ),
                                .sizeMax_pre                    ( sizeMax_pre ),
                                .SameMstSlvSize_pre             ( SameMstSlvSize_pre ),
                                .sizeCnt_comb_pre               ( sizeCnt_comb_pre ),
                                .fixed_burst_pre                ( fixed_burst),
                                .unaligned_fixed_len_iter_pre   ( unaligned_fixed_len_iter)
                                );




/// Components_End <<<---


endmodule
