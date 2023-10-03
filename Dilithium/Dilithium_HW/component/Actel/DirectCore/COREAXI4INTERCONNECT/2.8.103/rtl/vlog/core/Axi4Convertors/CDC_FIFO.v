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



module caxi4interconnect_CDC_FIFO #

  (
    parameter integer  MEM_DEPTH         = 4,
    parameter integer  DATA_WIDTH        = 20,
    parameter integer  MASTER_BCHAN      = 0
  )
  (
    input wire rst,
    input wire rdclk_rst,
    input wire clk_wr,
    input wire clk_rd,

    input wire infoInValid,
    input wire readyForOut,

    input wire [DATA_WIDTH-1:0] infoIn,

    output wire [DATA_WIDTH-1:0] infoOut,
    output wire readyForInfo,
    output wire infoOutValid
  );

  genvar i;
  localparam FIFO_ADDR_WIDTH = (MEM_DEPTH < 4) ? 2 : $clog2(MEM_DEPTH);

  reg [FIFO_ADDR_WIDTH-1:0] wrPtr_s1, wrPtr_s2 /* synthesis syn_preserve = 1 */;
  reg [FIFO_ADDR_WIDTH-1:0] rdPtr_s1, rdPtr_s2 /* synthesis syn_preserve = 1 */;
  wire [FIFO_ADDR_WIDTH-1:0] wrPtr /* synthesis syn_keep=1 */;
  wire [FIFO_ADDR_WIDTH-1:0] rdPtr /* synthesis syn_keep=1 */;

  wire [FIFO_ADDR_WIDTH-1:0] wrPtrP1, wrPtrP2;
  wire [FIFO_ADDR_WIDTH-1:0] rdPtrP1;

  wire fifoWe;
  wire fifoRe;
  wire syncRstWrCnt;
  wire syncRstRdCnt;

  caxi4interconnect_RAM_BLOCK #
     (
        .MEM_DEPTH    ( 2**(FIFO_ADDR_WIDTH) ),
        .ADDR_WIDTH   ( FIFO_ADDR_WIDTH ),
        .DATA_WIDTH   ( DATA_WIDTH ),
        .MASTER_BCHAN (MASTER_BCHAN)		
     )
     ram (
        .clk          ( clk_wr ),
        .wr_en        ( fifoWe ),
        .wr_addr      ( wrPtr ),
        .rd_addr      ( rdPtr ),
        .data_in      ( infoIn ),
        .data_out     ( infoOut )
    );

  // Write clock domain
  caxi4interconnect_CDC_grayCodeCounter #
    (
	.bin_rstValue ( 1 ),
        .gray_rstValue ( 0 ),
        .n_bits ( FIFO_ADDR_WIDTH )
    )
    wrGrayCounter
    (    
        .clk (clk_wr),
	.sysRst (rst),
	.syncRst (1'b1),
	.inc(fifoWe),
	.cntGray(wrPtr),
	.syncRstOut(syncRstWrCnt)
    );

    caxi4interconnect_CDC_grayCodeCounter #
    (
	.bin_rstValue ( 2 ),
        .gray_rstValue ( 1 ),
        .n_bits ( FIFO_ADDR_WIDTH )
    )
    wrGrayCounterP1
    (    
        .clk (clk_wr),
	.sysRst (rst),
	.syncRst (syncRstWrCnt),
	.inc(fifoWe),
	.cntGray(wrPtrP1),
	.syncRstOut ()
    );

    caxi4interconnect_CDC_grayCodeCounter #
    (
	.bin_rstValue ( 3 ),
        .gray_rstValue ( 3 ),
        .n_bits ( FIFO_ADDR_WIDTH )
    )
    wrGrayCounterP2
    (    
        .clk (clk_wr),
	.sysRst (rst),
	.syncRst (syncRstWrCnt),
	.inc(fifoWe),
	.cntGray(wrPtrP2),
	.syncRstOut ()
    );

    always @(posedge clk_wr or negedge rst) begin
      if (!rst) begin
	 rdPtr_s1 <= 0;
	 rdPtr_s2 <= 0;
      end
      else begin
	  rdPtr_s1 <= rdPtr;
	  rdPtr_s2 <= rdPtr_s1;
      end
    end

    caxi4interconnect_CDC_wrCtrl # (
        .ADDR_WIDTH ( FIFO_ADDR_WIDTH )
    )	  
    CDC_wrCtrl_inst (
	    .clk (clk_wr),
	    .rst (rst),
	    .wrPtr_gray (wrPtrP1),
	    .rdPtr_gray (rdPtr_s2),
	    .nextwrPtr_gray (wrPtrP2),
	    .readyForInfo (readyForInfo),

	    .infoInValid (infoInValid),
	    .fifoWe (fifoWe)
    );


  // read clock domain
  caxi4interconnect_CDC_grayCodeCounter #
    (
	.bin_rstValue ( 1 ),
        .gray_rstValue ( 0 ),
        .n_bits ( FIFO_ADDR_WIDTH )
    )
    rdGrayCounter
    (    
        .clk (clk_rd),
	.sysRst (rdclk_rst),
	.syncRst (1'b1),
	.inc(fifoRe),
	.cntGray(rdPtr),
	.syncRstOut (syncRstRdCnt)
    );

    caxi4interconnect_CDC_grayCodeCounter #
    (
	.bin_rstValue ( 2 ),
        .gray_rstValue ( 1 ),
        .n_bits ( FIFO_ADDR_WIDTH )
    )
    rdGrayCounterP1
    (    
        .clk (clk_rd),
	.sysRst (rdclk_rst),
	.syncRst (syncRstRdCnt),
	.inc(fifoRe),
	.cntGray(rdPtrP1),
	.syncRstOut ()
    );

    always @(posedge clk_rd or negedge rdclk_rst) begin
      if (!rdclk_rst) begin
	 wrPtr_s1 <= 0;
	 wrPtr_s2 <= 0;
      end
      else begin
	  wrPtr_s1 <= wrPtr;
	  wrPtr_s2 <= wrPtr_s1;
      end
    end

    caxi4interconnect_CDC_rdCtrl # (
        .ADDR_WIDTH ( FIFO_ADDR_WIDTH )
    )	   
    CDC_rdCtrl_inst (
	    .clk (clk_rd),
	    .rst (rdclk_rst),
	    .rdPtr_gray (rdPtr),
	    .wrPtr_gray (wrPtr_s2),
	    .nextrdPtr_gray (rdPtrP1),
	    .readyForOut (readyForOut),

	    .infoOutValid (infoOutValid),
	    .fifoRe (fifoRe)
    );

endmodule

