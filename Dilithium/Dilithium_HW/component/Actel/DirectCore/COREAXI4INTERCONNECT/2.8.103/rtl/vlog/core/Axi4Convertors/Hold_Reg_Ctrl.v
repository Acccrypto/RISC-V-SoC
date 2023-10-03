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


module caxi4interconnect_Hold_Reg_Ctrl

  (
    input wire rst,
    input wire clk,

		input wire src_data_valid, //!fifo_empty,
		input wire get_next_data_hold,
		
    
		output wire pass_data,
		output wire get_next_data_src, //fifo_rd_en,
		output reg  hold_data_valid //!hold_reg_empty

  );

	// Allow data into holding register when data is being taken from the holding register OR the holding register is empty.
	assign pass_data = (get_next_data_hold | !hold_data_valid);
	
	// Read more data from the source as there is data available at the source and we're passing the previous data to the holding register.
	assign get_next_data_src = (src_data_valid & pass_data); 
	
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
       hold_data_valid <= 'b0;
			end
    else begin
    // When passing data, indicate that data in the holding register is valid if source data was valid.
			if (pass_data)	hold_data_valid <= src_data_valid;

    end
  end

endmodule

