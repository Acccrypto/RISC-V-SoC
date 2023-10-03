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



module caxi4interconnect_FIFO_upsizing #

  (
    parameter integer  MEM_DEPTH           = 1024,
    parameter integer  DATA_WIDTH_IN       = 36,
    parameter integer  DATA_WIDTH_OUT      = 640,
    parameter integer  EXTRA_DATA_WIDTH    = 8,
    parameter integer  NEARLY_FULL_THRESH  = 512,
    parameter integer  NEARLY_EMPTY_THRESH = 128
  )
  (
      clk,
      rst,

      zero_data,
      wr_en,
      rd_en,
      pass_data, 
      data_in,
      zero_out_data,

      data_out,
      fifo_full,
      fifo_empty,
      fifo_nearly_full,
      fifo_nearly_empty,
      fifo_one_from_full
  );

  genvar i;
  localparam FIFO_SIZE = ($clog2(MEM_DEPTH) < 2) ? 4 : MEM_DEPTH;
  localparam FIFO_ADDR_WIDTH = ($clog2(MEM_DEPTH) < 2) ? 2 : $clog2(MEM_DEPTH);
  localparam NEARLY_EMPTY = ($clog2(MEM_DEPTH) < 2) ? 1 : NEARLY_EMPTY_THRESH;
  localparam NEARLY_FULL = ($clog2(MEM_DEPTH) < 2) ? 3 : NEARLY_FULL_THRESH;
   
     input clk;
     input rst;

     input [((DATA_WIDTH_OUT/DATA_WIDTH_IN)-1):0] zero_data;
     input [((DATA_WIDTH_OUT/DATA_WIDTH_IN)-1):0] wr_en;
     input rd_en;
     input pass_data; 
     input [(DATA_WIDTH_IN + EXTRA_DATA_WIDTH)-1:0] data_in;
     input zero_out_data;

     output [(DATA_WIDTH_OUT + EXTRA_DATA_WIDTH)-1:0] data_out;
     output fifo_full;
     output fifo_empty;
     output fifo_nearly_full;
     output fifo_nearly_empty;
     output fifo_one_from_full;
  
  
     wire clk;
     wire rst;

     wire [((DATA_WIDTH_OUT/DATA_WIDTH_IN)-1):0] zero_data;
     wire [((DATA_WIDTH_OUT/DATA_WIDTH_IN)-1):0] wr_en;
     wire rd_en;
     wire pass_data; 
     wire [(DATA_WIDTH_IN + EXTRA_DATA_WIDTH)-1:0] data_in;
     wire zero_out_data;

     wire [(DATA_WIDTH_OUT + EXTRA_DATA_WIDTH)-1:0] data_out;
     wire fifo_full;
     wire fifo_empty;
     wire fifo_nearly_full;
     wire fifo_nearly_empty;
     wire fifo_one_from_full;
  
  
  
  wire [FIFO_ADDR_WIDTH-1:0] wr_addr;
  wire [FIFO_ADDR_WIDTH-1:0] rd_addr;


  wire [(DATA_WIDTH_OUT + EXTRA_DATA_WIDTH)-1:0]  data_out_int;
  wire [(DATA_WIDTH_OUT + EXTRA_DATA_WIDTH)-1:0]  data_out_mux;
  reg [(DATA_WIDTH_OUT + EXTRA_DATA_WIDTH)-1:0]   data_out_next;
  reg [(DATA_WIDTH_OUT + EXTRA_DATA_WIDTH)-1:0]   data_out_reg;

  wire [(DATA_WIDTH_IN)-1:0] data_in_fifo [(DATA_WIDTH_OUT/DATA_WIDTH_IN)-1:0];
  wire [(DATA_WIDTH_OUT/DATA_WIDTH_IN)-1:0] wr_en_fifo;

  generate
    for (i=0; i<(DATA_WIDTH_OUT/DATA_WIDTH_IN); i=i+1) begin
      caxi4interconnect_RAM_BLOCK #
        (
          .MEM_DEPTH    ( FIFO_SIZE ),
          .ADDR_WIDTH   ( FIFO_ADDR_WIDTH ),
          .DATA_WIDTH   ( DATA_WIDTH_IN) 
        )
      ram (
          .clk          ( clk ),
          .wr_en        ( wr_en_fifo[i] ),
          .rd_addr      ( rd_addr[FIFO_ADDR_WIDTH-1:0] ),
          .wr_addr      ( wr_addr[FIFO_ADDR_WIDTH-1:0] ),
          .data_in      ( data_in_fifo[i] ),
          .data_out     ( data_out_int[DATA_WIDTH_IN*(i+1)-1:DATA_WIDTH_IN*i] )
      );
    end
  endgenerate  
  
  generate
  
    if (EXTRA_DATA_WIDTH > 0)
    begin

      caxi4interconnect_RAM_BLOCK #
        (
          .MEM_DEPTH  ( FIFO_SIZE ),
          .ADDR_WIDTH ( FIFO_ADDR_WIDTH ),
          .DATA_WIDTH ( EXTRA_DATA_WIDTH ) 
        )
      user_block (
          .clk         ( clk ),
          .wr_en       ( wr_en_fifo[(DATA_WIDTH_OUT/DATA_WIDTH_IN)-1] ),
          .rd_addr     ( rd_addr[FIFO_ADDR_WIDTH-1:0] ),
          .wr_addr     ( wr_addr[FIFO_ADDR_WIDTH-1:0] ),
          .data_in     ( data_in[DATA_WIDTH_IN +:EXTRA_DATA_WIDTH] ),
          .data_out    ( data_out_int[DATA_WIDTH_OUT +: EXTRA_DATA_WIDTH] )
      );
    end
  endgenerate

  assign data_out_mux = (zero_out_data) ? { data_out_reg[DATA_WIDTH_OUT +: EXTRA_DATA_WIDTH], {DATA_WIDTH_OUT{1'b0}}} : data_out_int;

  generate
    for (i=0; i<(DATA_WIDTH_OUT/DATA_WIDTH_IN); i=i+1) begin
      assign data_in_fifo[i] = (zero_data[i]) ? 'b0 :  data_in[DATA_WIDTH_IN-1:0]; // concatenate user_data_in and data_in
      assign wr_en_fifo[i] = zero_data[i] | wr_en[i];
    end
  endgenerate

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
          data_out_reg <= 'b0;
    end
    else begin
          data_out_reg <= data_out_next;
    end
  end

  always @(*) begin
    if (pass_data) begin
          data_out_next <= data_out_mux;
    end
    else begin
          data_out_next <= data_out_reg;
    end
  end


  assign data_out = data_out_reg;


  caxi4interconnect_FIFO_CTRL #
    (
      .FIFO_SIZE          (FIFO_SIZE),
      .NEARLY_FULL        (NEARLY_FULL),
      .NEARLY_EMPTY       (NEARLY_EMPTY),
      .ADDRESS_WIDTH      (FIFO_ADDR_WIDTH)
    )
  fifo_ctrl_inst (
// Inputs
	  .clk 				  ( clk ),
	  .rst 				  ( rst ),
	  .wr_rqst			  ( wr_en_fifo[(DATA_WIDTH_OUT/DATA_WIDTH_IN)-1] ),  // request to write to the caxi4interconnect_FIFO if writing to the top RAM
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

