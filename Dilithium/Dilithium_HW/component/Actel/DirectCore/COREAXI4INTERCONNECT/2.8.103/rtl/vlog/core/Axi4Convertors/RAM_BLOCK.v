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



module caxi4interconnect_RAM_BLOCK #

	(
		parameter integer	MEM_DEPTH	 = 1024,
		parameter integer	ADDR_WIDTH	 = 10,
		parameter integer	DATA_WIDTH	 = 32,
		parameter integer	MASTER_BCHAN = 0
	)
	(
		input wire clk,

		input wire wr_en,
		input wire [ADDR_WIDTH-1:0] rd_addr,
		input wire [ADDR_WIDTH-1:0] wr_addr,
		input wire [DATA_WIDTH-1:0] data_in,

		output wire [DATA_WIDTH-1:0] data_out
	);

	
	
	
	generate 
	  if(MASTER_BCHAN)
	    begin
	      reg [DATA_WIDTH-1:0] mem [MEM_DEPTH-1:0] /* synthesis syn_ramstyle = "uram" */;
		  
		  assign data_out = mem[rd_addr];
		  
	      always @(posedge clk) 
		    begin
		      if (wr_en) 
			    begin
			      mem[wr_addr] <= data_in;
		        end
	        end
        end		
	  else 
	    begin 
	      reg [DATA_WIDTH-1:0] mem [MEM_DEPTH-1:0];
		  
		  assign data_out = mem[rd_addr];
		  
	      always @(posedge clk) 
		    begin
		      if (wr_en) 
			    begin
			      mem[wr_addr] <= data_in;
		        end
	        end
		end 
	endgenerate
endmodule
