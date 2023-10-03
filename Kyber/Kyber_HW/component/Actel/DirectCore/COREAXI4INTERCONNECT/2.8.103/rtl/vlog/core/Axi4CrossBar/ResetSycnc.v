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
//     Abstract  : This module provides active low synchronised version of sysReset_N to sysClk
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_ResetSycnc  
	(
		input  wire             	sysClk,
		input  wire                 sysReset_L,			// active low reset synchronoise to RE AClk - asserted async.

		output reg					sysReset			// active low sysReset synchronised to sysClk
	) /* synthesis syn_preserve = 1 syn_noprune = 1 */ ;
   						 
						 
//================================================================================================
// Local Parameters
//================================================================================================

	
	
//=================================================================================================
// Local Declarationes
//=================================================================================================
 
reg   sysReset_f1;

//=================================================================================================
always @(posedge sysClk or negedge sysReset_L)
begin
	if( ~sysReset_L )
		sysReset_f1 <= 1'b0;			// active low reset on
	else
		sysReset_f1 <= 1'b1;			// active low reset off
end

always @(posedge sysClk or negedge sysReset_L)
begin
	if( ~sysReset_L )
		sysReset <= 1'b0;			// active low reset on
	else
		sysReset <= sysReset_f1;	// active low reset off
end

endmodule // caxi4interconnect_ResetSycnc.v
