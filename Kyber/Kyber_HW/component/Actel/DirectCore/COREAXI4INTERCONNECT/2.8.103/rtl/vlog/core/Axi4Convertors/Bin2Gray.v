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
//     Abstract  : binary to graycode converter
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 


module caxi4interconnect_Bin2Gray #
  (
  parameter integer n_bits = 4
  )
  (
   input wire [n_bits-1:0]  cntBinary,

   output wire [n_bits-1:0] nextGray
  );

  genvar i;
  generate
  for (i = 0; i < (n_bits-1) ; i = i + 1) 
    begin
      assign nextGray[i] = cntBinary[i] ^ cntBinary[i+1];
    end
  endgenerate

  assign nextGray[n_bits-1] = cntBinary[n_bits-1];

endmodule
