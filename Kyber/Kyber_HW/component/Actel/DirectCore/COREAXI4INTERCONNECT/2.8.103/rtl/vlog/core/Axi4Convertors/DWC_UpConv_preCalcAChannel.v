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
//     Abstract  : Register slice to compute values before sending to WrCmdFifoWriteCtrl
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 



module caxi4interconnect_DWC_UpConv_preCalcAChannel #
(
  parameter DATA_WIDTH_OUT = 32,
  parameter ADDR_WIDTH = 32,
  parameter USER_WIDTH = 32,
  parameter ID_WIDTH = 32
)
  (
   input wire clk,
   input wire rst,


   input wire     [7:0]               MASTER_ALEN_in,
   input wire                         MASTER_AVALID_in,
   input wire     [ID_WIDTH - 1:0]    MASTER_AID_in,
   input wire     [ADDR_WIDTH - 1:0]  MASTER_AADDR_in,
   input wire     [1:0]               MASTER_ABURST_in,
   input wire     [3:0]               MASTER_ACACHE_in,
   input wire     [1:0]               MASTER_ALOCK_in,
   input wire     [2:0]               MASTER_ASIZE_in,
   input wire     [2:0]               MASTER_APROT_in,
   input wire     [3:0]               MASTER_AQOS_in,
   input wire     [3:0]               MASTER_AREGION_in,
   input wire     [USER_WIDTH - 1:0]  MASTER_AUSER_in,
   
   
   input wire      MASTER_AREADY_in, // from wrCmdFifoWriteCtrl
    
    output reg     [7:0]               MASTER_ALEN_out,
    output wire                        MASTER_AVALID_out, // Direct output from caxi4interconnect_Hold_Reg_Ctrl
    output reg     [ID_WIDTH - 1:0]    MASTER_AID_out,
    output reg     [ADDR_WIDTH - 1:0]  MASTER_AADDR_out,
    output reg     [1:0]               MASTER_ABURST_out,
    output reg     [3:0]               MASTER_ACACHE_out,
    output reg     [1:0]               MASTER_ALOCK_out,
    output reg     [2:0]               MASTER_ASIZE_out,
    output reg     [2:0]               MASTER_APROT_out,
    output reg     [3:0]               MASTER_AQOS_out,
    output reg     [3:0]               MASTER_AREGION_out,
    output reg     [USER_WIDTH - 1:0]  MASTER_AUSER_out,
    
    output wire                        MASTER_AREADY_out, // to the source, direct output from caxi4interconnect_Hold_Reg_Ctrl
	  
    output reg        [7:0]  alen_wrap_pre,  
    output reg        [7:0]  alen_sec_wrap_pre,   
    output reg        [4:0]  to_boundary_master_pre,
    output reg        [9:0]  mask_wrap_addr_pre,  
    output reg       [2:0]   sizeDiff_pre,
    output reg               unaligned_wrap_burst_comb_pre,
    output reg        [5:0]  len_offset_pre,
    output reg               wrap_tx_pre,
    output reg               fixed_flag_comb_pre
   

  );

  
   wire [1:0]   INCR, FIXED, WRAP;
  
   wire         pass_data;
  
   wire        [4:0]  to_boundary_master;
   wire        [9:0]  mask_wrap_addr;  
   wire       [2:0]   sizeDiff;
   wire               unaligned_wrap_burst_comb;
   wire        [5:0]  len_offset;
   wire               wrap_tx;
   wire               fixed_flag_comb;   
   
   wire      [5:0]  mask;
   wire      [4:0]  addr_beat;
  
  
   assign to_boundary_master =  MASTER_ALEN_in + 1 - addr_beat;
   assign mask_wrap_addr = ((MASTER_ALEN_in+1) << MASTER_ASIZE_in)-1;
   assign sizeDiff = ($clog2(DATA_WIDTH_OUT/8) - MASTER_ASIZE_in);
   assign unaligned_wrap_burst_comb = ~((MASTER_AADDR_in[9:0] & mask_wrap_addr) == 0);
   assign len_offset = (MASTER_AADDR_in[5:0] & mask) >> MASTER_ASIZE_in;
   assign wrap_tx = unaligned_wrap_burst_comb & (MASTER_ABURST_in == WRAP);
   assign fixed_flag_comb = (MASTER_ABURST_in == FIXED);
		 
  
   // use master address when MASTER_AVALID is asserted otherwise use the latched version
   assign addr_beat = MASTER_AADDR_in[MASTER_ASIZE_in+:4] & MASTER_ALEN_in; 
   assign mask = (DATA_WIDTH_OUT/8) - 1; 
		 
   assign INCR  = 2'b01;
   assign FIXED = 2'b00;
   assign WRAP = 2'b10;
  
  
  always @ (posedge clk or negedge rst)
  begin
  if (!rst)
    begin

    
        MASTER_ALEN_out               <= 0;
        MASTER_AID_out                <= 0;
        MASTER_AADDR_out              <= 0;
        MASTER_ABURST_out             <= 0;
        MASTER_ACACHE_out             <= 0;
        MASTER_ALOCK_out              <= 0;
        MASTER_ASIZE_out              <= 0;
        MASTER_APROT_out              <= 0;
        MASTER_AQOS_out               <= 0;
        MASTER_AREGION_out            <= 0;
        MASTER_AUSER_out              <= 0;
        
        to_boundary_master_pre        <= 0;
        mask_wrap_addr_pre            <= 0;
        sizeDiff_pre                  <= 0;
        unaligned_wrap_burst_comb_pre <= 0;
        len_offset_pre                <= 0;
        wrap_tx_pre                   <= 0;
        fixed_flag_comb_pre           <= 0;
        alen_sec_wrap_pre             <= 0;
        alen_wrap_pre             <= 0;
   
    end
  else
    begin
    if (pass_data)
      begin
	  
        MASTER_ALEN_out                  <= MASTER_ALEN_in;
        MASTER_AID_out                   <= MASTER_AID_in;
        MASTER_AADDR_out                 <= MASTER_AADDR_in;
        MASTER_ABURST_out                <= MASTER_ABURST_in ;
        MASTER_ACACHE_out                <= MASTER_ACACHE_in;
        MASTER_ALOCK_out                 <= MASTER_ALOCK_in;
        MASTER_ASIZE_out                 <= MASTER_ASIZE_in;
        MASTER_APROT_out                 <= MASTER_APROT_in;
        MASTER_AQOS_out                  <= MASTER_AQOS_in;
        MASTER_AREGION_out               <= MASTER_AREGION_in;
        MASTER_AUSER_out                 <= MASTER_AUSER_in;
        
        to_boundary_master_pre        <= to_boundary_master;
        mask_wrap_addr_pre            <= mask_wrap_addr;
        sizeDiff_pre                  <= sizeDiff;
        unaligned_wrap_burst_comb_pre <= unaligned_wrap_burst_comb;
        len_offset_pre                <= len_offset;
        wrap_tx_pre                   <= wrap_tx;
        fixed_flag_comb_pre           <= fixed_flag_comb;
		alen_sec_wrap_pre             <= (MASTER_ALEN_in - to_boundary_master) >> sizeDiff;
		alen_wrap_pre                 <= ((to_boundary_master - 1) >>  sizeDiff);
	  
      end
    end
  end
  
  



caxi4interconnect_Hold_Reg_Ctrl DWC_DownConv_Calc_Hold_Reg_Ctrl (

                .rst(rst), // input
                .clk(clk), // input

                .src_data_valid( MASTER_AVALID_in ), // input
                .get_next_data_hold( MASTER_AREADY_in ), // input

                .pass_data( pass_data ), // output // Control the holding register
                .get_next_data_src( MASTER_AREADY_out ), // output
                .hold_data_valid( MASTER_AVALID_out ) // output
);

endmodule
