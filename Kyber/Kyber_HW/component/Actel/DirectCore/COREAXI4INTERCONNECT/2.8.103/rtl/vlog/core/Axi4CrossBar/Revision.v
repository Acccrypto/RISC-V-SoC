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
//     Abstract  : This module provides a caxi4interconnect_revision for the Core. 
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_revision ( devRevision );

output  [31:0]   devRevision;

wire    [7:0]    relYear;
wire    [7:0]    relMonth;
wire    [7:0]    relDay;
wire    [7:0]    buildNum;
wire    [31:0]   devRevision;

assign relYear            = 8'h15;      // Date: Year
assign relMonth           = 8'h06;      // Date: Month      
assign relDay             = 8'h29;      // Date: Day
assign buildNum           = 8'b0000001; // Build number


assign devRevision = {relYear,relMonth,relDay, buildNum};

endmodule
