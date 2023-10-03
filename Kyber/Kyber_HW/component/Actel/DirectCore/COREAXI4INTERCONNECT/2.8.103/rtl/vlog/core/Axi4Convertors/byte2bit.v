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
module caxi4interconnect_byte2bit (
                                 //  input ports
                                 shifted_slv_mask_bit,
                                 shifted_mst_mask_bit,
 
                                 //  output ports
                                 shifted_slv_mask_byte,
                                 shifted_mst_mask_byte
                                 );
 
   parameter        DATA_WIDTH_IN             = 32;
   parameter        DATA_WIDTH_OUT            = 32;
//  output ports
   output     [DATA_WIDTH_IN - 1:0] shifted_slv_mask_bit;
   wire      [DATA_WIDTH_IN - 1:0] shifted_slv_mask_bit;
   output     [DATA_WIDTH_OUT - 1:0] shifted_mst_mask_bit;
   wire      [DATA_WIDTH_OUT - 1:0] shifted_mst_mask_bit;
//  input ports
   input    [(DATA_WIDTH_IN / 8) - 1:0] shifted_slv_mask_byte;
   wire      [(DATA_WIDTH_IN / 8) - 1:0] shifted_slv_mask_byte;
   input    [(DATA_WIDTH_OUT / 8) - 1:0] shifted_mst_mask_byte;
   wire      [(DATA_WIDTH_OUT / 8) - 1:0] shifted_mst_mask_byte;

   genvar i;

   generate
     for (i=0;i<(DATA_WIDTH_IN/8);i=i+1) begin
       assign shifted_slv_mask_bit[(8*i)+:8] = {8{shifted_slv_mask_byte[i]}};
     end
   endgenerate

   generate
     for (i=0;i<(DATA_WIDTH_OUT/8);i=i+1) begin
       assign shifted_mst_mask_bit[(8*i)+:8] = {8{shifted_mst_mask_byte[i]}};
     end
   endgenerate

endmodule

