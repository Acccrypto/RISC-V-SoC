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



module caxi4interconnect_DWC_DownConv_preCalcCmdFifoWrCtrl #
(
  parameter DATA_WIDTH_OUT = 32,
  parameter DATA_WIDTH_IN = 32,
  parameter ADDR_WIDTH = 32,
  parameter USER_WIDTH = 32,
  parameter ID_WIDTH = 32,
  parameter WRITE_ENABLE = 1
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
    
    
    output reg [ADDR_WIDTH - 1:0]  MASTER_AADDR_mux_pre,
    
    output reg [4:0]               to_boundary_master_pre,
    output reg [5:0]               mask_addr_pre,
    output reg [2:0]               ASIZE_pre,
    output reg [12:0]              tot_len_pre,
    output reg [8:0]               max_length_comb_pre,
    output reg [8:0]               length_comb_pre,
    output reg [2:0]               WrapLogLen_comb_pre,
    output reg [5:0]               sizeMax_pre,
    output reg                     SameMstSlvSize_pre,
    output reg [5:0]               sizeCnt_comb_pre,
    output reg                     fixed_burst_pre,
    output reg [6:0]               unaligned_fixed_len_iter_pre
  );

  localparam   MASTER_MAX_SIZE      = $clog2(DATA_WIDTH_IN/8);
  localparam   MASTER_SIZE_MAX_MASK = (1<<MASTER_MAX_SIZE)-1;
  localparam   MAX_SIZE             = (DATA_WIDTH_IN/DATA_WIDTH_OUT) - 1;
  
  wire [4:0]   addr_beat;

  wire [4:0]   to_boundary_master;
  wire [5:0]   mask_addr;
  
  wire         reduce_tx_size;
  
  wire [12:0]  tot_len_aligned;
  wire [5:0]   len_offset;
  wire [5:0]   fixed_burst_length_offset;
  wire [12:0]  tot_incr_len;
  wire [12:0]  tot_len;
  wire [5:0]   mask_len;
  
  wire [2:0]   WrapLogLen_comb;
  wire [8:0]   max_length_comb;
  wire [8:0]   max_length_fixed_burst;
  wire [8:0]   length_comb;
  
  wire [2:0]   ASIZE;
  wire [2:0]   sizeDiff;
  wire [5:0]   SizeMax;
  wire [5:0]   fixed_burst_sizemax;
  wire         SameMstSlvSize;
  
  wire [5:0]   sizeCnt_comb;
  wire [5:0]   mask_sizeCnt;

  wire [1:0]   INCR, FIXED;
  
  wire         pass_data;
  wire [ADDR_WIDTH - 1:0]  MASTER_AADDR_mux;
  
  wire                     fixed_burst;
  wire [6:0]               unaligned_fixed_len_iter;  
  
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
        
        
        
      MASTER_AADDR_mux_pre            <= 0; 
      to_boundary_master_pre          <= 0;
      mask_addr_pre                   <= 0;
      ASIZE_pre                       <= 0;
      tot_len_pre                     <= 0;
      max_length_comb_pre             <= 0;
      length_comb_pre                 <= 0;
      WrapLogLen_comb_pre             <= 0;
      sizeMax_pre                     <= 0;
      SameMstSlvSize_pre              <= 0;
      sizeCnt_comb_pre                <= 0;
      
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
        
        
        to_boundary_master_pre           <= to_boundary_master;
        mask_addr_pre                    <= mask_addr;
        ASIZE_pre                        <= ASIZE;
        tot_len_pre                      <= tot_len;
        max_length_comb_pre              <= max_length_comb;
        length_comb_pre                  <= length_comb;
        WrapLogLen_comb_pre              <= WrapLogLen_comb;
        sizeMax_pre                      <= SizeMax;
        SameMstSlvSize_pre               <= SameMstSlvSize;
        sizeCnt_comb_pre                 <= sizeCnt_comb;
        MASTER_AADDR_mux_pre             <= MASTER_AADDR_mux;
        fixed_burst_pre                  <= fixed_burst;
        unaligned_fixed_len_iter_pre     <= unaligned_fixed_len_iter;
      end
    end
  end
  

  assign addr_beat = MASTER_AADDR_in[MASTER_ASIZE_in+:4] & MASTER_ALEN_in;

  assign to_boundary_master = (MASTER_ALEN_in + 1) - addr_beat;
  assign mask_addr = (6'h3f << ASIZE);


  assign reduce_tx_size = (MASTER_ASIZE_in > $clog2(DATA_WIDTH_OUT/8));

  // compute the total length as function of the master transfer size, data widths and burst length
  // if the master and slave transfer sizes differ, the total length of a fixed burst is the master length shifted by sizeDiff

  assign tot_len_aligned = ((MASTER_ALEN_in + 1) << (MASTER_ASIZE_in-$clog2(DATA_WIDTH_OUT/8)));

  assign len_offset = ((MASTER_AADDR_in[5:0] & mask_len) >> $clog2(DATA_WIDTH_OUT/8));

  assign tot_incr_len = tot_len_aligned - len_offset;
  
  assign unaligned_fixed_len_iter = reduce_tx_size & fixed_burst ? ((1<<sizeDiff)-len_offset) : 1'b1;

  assign tot_len = reduce_tx_size ? (MASTER_ABURST_in == FIXED) ? MASTER_ALEN_in + 1 : tot_incr_len : MASTER_ALEN_in + 1;
  assign mask_len = ((1<<MASTER_ASIZE_in)-1);

  assign WrapLogLen_comb = (MASTER_ALEN_in == 8'h0f) ? 3'h4 :
        ((MASTER_ALEN_in == 8'h07) ? 3'h3 :
        ((MASTER_ALEN_in == 8'h03) ? 3'h2 : 3'h1));

  assign max_length_fixed_burst = tot_len;
  
  assign max_length_comb = (MASTER_ABURST_in == INCR) ? 9'h100 : ((MASTER_ABURST_in == FIXED) ? tot_len[8:0] : (9'h010 << sizeDiff));
 
  assign length_comb =  max_length_comb;
  // combinatorial calculation of the slave transfer size.
  // if a master beat has to be split, utilize the full width of the slave data bus otherwise pass the master transfer size through
  assign ASIZE = (reduce_tx_size) ? $clog2(DATA_WIDTH_OUT/8) : MASTER_ASIZE_in;

  assign sizeDiff = MASTER_ASIZE_in - ASIZE;
  assign fixed_burst_sizemax = fixed_burst_length_offset + (1<<sizeDiff) - len_offset - 1;
  assign SizeMax = fixed_burst & WRITE_ENABLE ? fixed_burst_sizemax : (1<<sizeDiff)-1;
  assign SameMstSlvSize = fixed_burst ? (((1<<sizeDiff)-1 == len_offset) | (MASTER_ASIZE_in == ASIZE)) : (MASTER_ASIZE_in == ASIZE);

  assign fixed_burst_length_offset = ((MASTER_AADDR_in[5:0] & ((1<<MASTER_MAX_SIZE)-1)) >> $clog2(DATA_WIDTH_OUT/8));
  
  assign sizeCnt_comb = fixed_burst & WRITE_ENABLE  ? fixed_burst_length_offset : ((MASTER_AADDR_in & mask_sizeCnt) >> ASIZE);  								                        


  assign mask_sizeCnt = ((1<<MASTER_ASIZE_in)-1);

  assign MASTER_AADDR_mux = ((MASTER_ABURST_in == FIXED) && (~SameMstSlvSize)) ? {MASTER_AADDR_in[ADDR_WIDTH-1:6], (MASTER_AADDR_in[5:0] & mask_addr)} : MASTER_AADDR_in;

  assign INCR  = 2'b01;
  assign FIXED = 2'b00;
  
  assign fixed_burst = ((MASTER_ABURST_in == FIXED)) ;


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
