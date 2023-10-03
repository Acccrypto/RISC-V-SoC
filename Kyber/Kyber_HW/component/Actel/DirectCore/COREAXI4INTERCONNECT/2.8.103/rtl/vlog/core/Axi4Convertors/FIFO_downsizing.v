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

module caxi4interconnect_FIFO_downsizing #

  (
    parameter integer  MEM_DEPTH            = 1024,
    parameter integer  DATA_WIDTH_IN        = 36,
    parameter integer  DATA_WIDTH_OUT       = 640,
    parameter integer  EXTRA_DATA_WIDTH     = 8,
    parameter integer  NEARLY_FULL_THRESH   = 512,
    parameter integer  NEARLY_EMPTY_THRESH  = 128
  )
  (
      clk,
      rst,

      rd_src,
      wr_en,
      rd_en,
      data_in,
      data_hold,

      data_out,
      fifo_full,
      fifo_empty,
      fifo_nearly_full,
      fifo_nearly_empty,
      fifo_one_from_full
  );

  localparam FIFO_SIZE = ($clog2(MEM_DEPTH) < 2) ? 4 : MEM_DEPTH;
  localparam FIFO_ADDR_WIDTH = ($clog2(MEM_DEPTH) < 2) ? 2 : $clog2(MEM_DEPTH);
  localparam NEARLY_EMPTY = ($clog2(MEM_DEPTH) < 2) ? 1 : NEARLY_EMPTY_THRESH;
  localparam NEARLY_FULL = ($clog2(MEM_DEPTH) < 2) ? 3 : NEARLY_FULL_THRESH;
  integer i;
  
     input clk;
     input rst;

     input [($clog2(DATA_WIDTH_IN/DATA_WIDTH_OUT)-1):0] rd_src;
     input wr_en;
     input rd_en;
     input [DATA_WIDTH_IN+EXTRA_DATA_WIDTH-1:0] data_in;
     input data_hold;

     output [DATA_WIDTH_OUT+EXTRA_DATA_WIDTH-1:0] data_out;
     output fifo_full;
     output fifo_empty;
     output fifo_nearly_full;
     output fifo_nearly_empty;
     output fifo_one_from_full;
  
     wire clk;
     wire rst;

     wire [($clog2(DATA_WIDTH_IN/DATA_WIDTH_OUT)-1):0] rd_src;
     wire wr_en;
     wire rd_en;
     wire [DATA_WIDTH_IN+EXTRA_DATA_WIDTH-1:0] data_in;
     wire data_hold;

     wire [DATA_WIDTH_OUT+EXTRA_DATA_WIDTH-1:0] data_out;
     wire fifo_full;
     wire fifo_empty;
     wire fifo_nearly_full;
     wire fifo_nearly_empty;
     wire fifo_one_from_full;
  
  wire [FIFO_ADDR_WIDTH-1:0] wr_addr;
  wire [FIFO_ADDR_WIDTH-1:0] rd_addr;

  reg [DATA_WIDTH_OUT-1:0] data_out_sel;

  wire [DATA_WIDTH_IN+EXTRA_DATA_WIDTH-1:0]   data_out_int;
  wire [DATA_WIDTH_OUT+EXTRA_DATA_WIDTH-1:0]  data_out_mux;
  reg [DATA_WIDTH_OUT+EXTRA_DATA_WIDTH-1:0]   data_out_next;
  reg [DATA_WIDTH_OUT+EXTRA_DATA_WIDTH-1:0]   data_out_reg;
  
  caxi4interconnect_RAM_BLOCK #
    (
      .MEM_DEPTH      ( FIFO_SIZE ),
      .ADDR_WIDTH     ( FIFO_ADDR_WIDTH ),
      .DATA_WIDTH     ( DATA_WIDTH_IN + EXTRA_DATA_WIDTH ) 
    )
    ram (
      .clk         ( clk ),
      .wr_en       ( wr_en ),
      .rd_addr     ( rd_addr[FIFO_ADDR_WIDTH-1:0] ),
      .wr_addr     ( wr_addr[FIFO_ADDR_WIDTH-1:0] ),
      .data_in     ( data_in ),
      .data_out    ( data_out_int )
    );


  assign data_out = data_out_reg;
 
  always @(posedge clk or negedge rst) begin
     if (!rst) begin
          data_out_reg <= 'b0;
     end
     else begin
          data_out_reg <= data_out_next;
     end
  end

  always @(*) begin
     if (data_hold) begin
          data_out_next <= data_out_reg;
    end
    else begin
          data_out_next <= data_out_mux;
    end
  end

  generate
    if (DATA_WIDTH_IN == DATA_WIDTH_OUT) begin
      assign data_out_mux = data_out_int;
    end
    else begin
      always @(*) begin
	  data_out_sel <= 0; // default assignment
	  for (i = 0; i < (DATA_WIDTH_IN/DATA_WIDTH_OUT); i = (i + 1)) begin
	     if (rd_src == i) begin
                data_out_sel <= data_out_int[rd_src*DATA_WIDTH_OUT+:DATA_WIDTH_OUT];
             end
          end
      end
      assign data_out_mux = {data_out_int[DATA_WIDTH_IN+:EXTRA_DATA_WIDTH], data_out_sel};
    end
  endgenerate


  caxi4interconnect_FIFO_CTRL #
    (
      .FIFO_SIZE          ( FIFO_SIZE ),
      .NEARLY_FULL        ( NEARLY_FULL ),
      .NEARLY_EMPTY       ( NEARLY_EMPTY ),
      .ADDRESS_WIDTH      ( FIFO_ADDR_WIDTH )
    )
  fifo_ctrl_inst  (
// Inputs
	  .clk 				  ( clk ),
	  .rst 				  ( rst ),
	  .wr_rqst			  ( wr_en ),  // request to write to the caxi4interconnect_FIFO if writing to the top RAM
																			  // successful if not full
	  .rd_rqst			  ( rd_en ), // request to read from the caxi4interconnect_FIFO, successful if not empty 
	  
// Outputs	  
	  .wrptr			  ( wr_addr ),
	  .rdptr			  ( rd_addr ),
      .fifo_full          ( fifo_full ),
      .fifo_empty         ( fifo_empty ),
      .fifo_nearly_full   ( fifo_nearly_full ),
      .fifo_nearly_empty  ( fifo_nearly_empty ),
      .fifo_one_from_full ( fifo_one_from_full )
    );

endmodule

