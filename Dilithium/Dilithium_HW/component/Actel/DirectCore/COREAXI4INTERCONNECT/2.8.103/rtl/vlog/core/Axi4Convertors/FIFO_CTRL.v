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
//     Abstract  : This module calculates caxi4interconnect_FIFO flags (full, empty, nearly full, nearly empty, one from full)
//                 given certain parameters and the pointer locations
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 



module caxi4interconnect_FIFO_CTRL #
(
  parameter integer FIFO_SIZE = 24,
  parameter integer NEARLY_FULL = 16,
  parameter integer NEARLY_EMPTY = 8,
  parameter integer ADDRESS_WIDTH = 5
)
(// inputs
  
    clk,
    rst,
    wr_rqst,
    rd_rqst,

  //outputs

    wrptr,
    rdptr,
    fifo_full,
    fifo_empty,
    fifo_nearly_full,
    fifo_nearly_empty,
    fifo_one_from_full
);

// PARAMETERS
localparam fmax = (2**(ADDRESS_WIDTH));
localparam fdiff = fmax - FIFO_SIZE;

// WIRES
input clk;
input rst;
input wr_rqst;
input rd_rqst;

output [ADDRESS_WIDTH-1:0] wrptr;
output [ADDRESS_WIDTH-1:0] rdptr; 
output fifo_full;
output fifo_empty;
output fifo_nearly_full;
output fifo_nearly_empty;
output fifo_one_from_full;


reg [ADDRESS_WIDTH-1:0] wrptr;
reg [ADDRESS_WIDTH-1:0] rdptr; 
reg fifo_full;
reg fifo_empty;
reg fifo_nearly_full;
reg fifo_nearly_empty;
reg fifo_one_from_full;

reg [ADDRESS_WIDTH:0]    entries_in_fifo;

wire [ADDRESS_WIDTH-1:0] wrptr_next;
wire [ADDRESS_WIDTH-1:0] rdptr_next; 

wire we;
wire re;

wire [ADDRESS_WIDTH:0] entries_plus1;
wire [ADDRESS_WIDTH:0] entries_minus1;


assign wrptr_next = (wrptr == (FIFO_SIZE-1)) ? 'b0 : (wrptr + 1);
assign rdptr_next = (rdptr == (FIFO_SIZE-1)) ? 'b0 : (rdptr + 1); 
 
assign we = wr_rqst & !fifo_full;
assign re = rd_rqst & !fifo_empty;

assign entries_plus1 = entries_in_fifo + 1;
assign entries_minus1 = entries_in_fifo - 1;

always @(posedge clk or negedge rst) 
 begin
    if (!rst) 
	  begin	  
	   fifo_full <= 0;
       fifo_empty <= 1;
	   fifo_one_from_full <= 0;
	   fifo_nearly_full <= 0;
	   fifo_nearly_empty <= 1;
	   entries_in_fifo <= 0;
	   wrptr <= 'b0;
       rdptr <= 'b0;
	  end
    else 
	  begin
	   // First take care of the write and read pointers
	   
       if (we) wrptr <= wrptr_next;
       if (re) rdptr <= rdptr_next;
	   
	   // Handle flags if writing and not reading
	   
	   if (we & !re)
		begin
		 fifo_empty <= 0;
		 if (wrptr_next == rdptr)
		  begin
		   fifo_full <= 1;
		   fifo_one_from_full <= 0;
		   fifo_nearly_full <= 1; // including "full";
		   fifo_nearly_empty <= 0;
		   entries_in_fifo <= FIFO_SIZE;
		  end
		 else		 
		  begin
		   fifo_one_from_full <= ((entries_in_fifo + 2) == FIFO_SIZE); 
		   fifo_nearly_full <= (entries_plus1 >= NEARLY_FULL);
		   fifo_nearly_empty <= (entries_plus1 <= NEARLY_EMPTY);
		   entries_in_fifo <= entries_plus1;		   
		  end	 
		end  
			   
			   
	   // Handle flags if reading and not writing
			   
	   if (re & !we)
		begin
		 fifo_full <= 0;
		 if (rdptr_next == wrptr)
		  begin
		   fifo_empty <= 1;
		   fifo_one_from_full <= 0;
		   fifo_nearly_full <= 0;
		   fifo_nearly_empty <= 1;	 // including empty  
		   entries_in_fifo <= 0;
		  end
		 else
		  begin
		   fifo_one_from_full <= fifo_full;
		   fifo_nearly_full <= (entries_minus1 >= NEARLY_FULL);
		   fifo_nearly_empty <= (entries_minus1 <= NEARLY_EMPTY);		   
		   entries_in_fifo <= entries_minus1;		  
		  end	 
		end  
			
		// No changes to flags if both reading and writing
		
		// Note that we might be trying to do both but if the caxi4interconnect_FIFO is full there's no write, 
		// and similarly no reads when empty
			
      end
 end


endmodule