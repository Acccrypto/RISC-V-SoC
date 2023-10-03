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



module caxi4interconnect_DWC_UpConv_WChan_Hold_Reg #
(
  parameter DATA_WIDTH_IN = 32,
  parameter USER_WIDTH = 32,
  parameter DATA_WIDTH_OUT = 32

)
  (
		input wire clk,
		input wire rst,
    

    input wire    DWC_UpConv_hold_fifo_empty,
    input wire    DWC_UpConv_hold_get_next_data,
    
    output wire   DWC_UpConv_hold_fifo_rd_en, // ready for anothr data
    output wire   DWC_UpConv_hold_reg_empty,


    // Inputs to be decoded
      input wire [4:0]  to_boundary,
      input wire [5:0]  addr,
      input wire [2:0]  size,
      input wire [7:0]  wlen_mst,
      input wire        extend_tx,
      input wire        wrap_flag,
      input wire        fixed_flag,

      // Decoded Outputs
      output reg [4:0]  to_boundary_out,
      output reg [5:0]  addr_out,      
      output reg [5:0]  size_shifted_out,      
      output reg [2:0]  size_out,
      output reg [7:0]  wlen_mst_out,
      output reg        extend_tx_out,
      output reg        wrap_flag_out,
      output reg        fixed_flag_out,
      
      output reg [5:0]    mask_addr_out,
      output reg          aligned_wrap_out,
      output reg          second_wrap_burst_out,
      output reg          extend_wrap_out

  );

  localparam WIDTH_OUT_BYTES = DATA_WIDTH_OUT/8;
  
  wire DWC_UpConv_pass_data;
  wire DWC_UpConv_hold_reg_full;

  wire [6:0]    size_one_hot;
  wire [5:0]    mask_addr_msb;
  wire aligned_wrap;
  wire second_wrap_burst;
  wire extend_wrap;
  wire [5:0]    mask_addr;

  
  
  always @ (posedge clk or negedge rst)
  begin
  if (!rst)
    begin
  

      to_boundary_out <= 0;
      addr_out        <= 0;
      size_out        <= 0;
      wlen_mst_out    <= 0;
      extend_tx_out   <= 0;
      wrap_flag_out   <= 0;
      fixed_flag_out  <= 0;
	  
      size_shifted_out        <= 0;
      
      mask_addr_out         <= 0;
      aligned_wrap_out      <= 0;
      second_wrap_burst_out <= 0;
      extend_wrap_out       <= 0;
    end
  else
    begin
    if (DWC_UpConv_pass_data)
      begin

        to_boundary_out <= to_boundary;
        addr_out        <= addr;
        size_shifted_out <= (1 << size);
        size_out        <= size;
        wlen_mst_out    <= wlen_mst;
        extend_tx_out   <= extend_tx;
        wrap_flag_out   <= wrap_flag;
        fixed_flag_out  <= fixed_flag;

        mask_addr_out         <= mask_addr; // align the address to the transfer size and zero unnecessary MSBs
        aligned_wrap_out      <= aligned_wrap;
        second_wrap_burst_out <= second_wrap_burst;
        extend_wrap_out       <= extend_wrap;

      end
    end
  end
  
assign size_one_hot = (1 << size); // not output
assign mask_addr_msb = ~(size_one_hot - 1);  // not output
assign aligned_wrap = (to_boundary == wlen_mst);
assign second_wrap_burst = (wrap_flag & ~extend_tx & ~aligned_wrap);
assign extend_wrap = wrap_flag & extend_tx;
assign mask_addr = (WIDTH_OUT_BYTES - 1) & mask_addr_msb; // align the address to the transfer size and zero unnecessary MSBs

  
  assign DWC_UpConv_hold_reg_empty = !DWC_UpConv_hold_reg_full;

caxi4interconnect_Hold_Reg_Ctrl DWC_UpConv_Hold_Reg_Ctrl (

      .rst(rst), // input
      .clk(clk), // input

      .src_data_valid( !DWC_UpConv_hold_fifo_empty ), // input          // fifo_empty
      .get_next_data_hold( DWC_UpConv_hold_get_next_data ), // input    // hold_reg_get_next_data (fifo_rd_en)
    
      .pass_data( DWC_UpConv_pass_data ), // output // Control the holding register   // pass_data for enabling the clocking of the data
      .get_next_data_src( DWC_UpConv_hold_fifo_rd_en  ), // output       // fifo_rd_en (hold_reg_rd_en)
      .hold_data_valid( DWC_UpConv_hold_reg_full ) // output       // hold_reg_empty_inv
);

endmodule
