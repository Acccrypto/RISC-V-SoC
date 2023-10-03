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
 
module caxi4interconnect_DWC_DownConv_CmdFifoWriteCtrl (
                                      //  input ports
                                      ACLK,
                                      sysReset,
                                      MASTER_AVALID,
                                      MASTER_AID,
                                      MASTER_AADDR,
                                      MASTER_ABURST,
                                      MASTER_ACACHE,
                                      MASTER_ALOCK,
                                      MASTER_ASIZE,
                                      MASTER_APROT,
                                      MASTER_AQOS,
                                      MASTER_AREGION,
                                      MASTER_AUSER,
                                      SLAVE_AREADY,
                                      CmdFifoNearlyFull,
                                      brespFifoNearlyFull,
                                      to_boundary_master,
                                      mask_addr,
                                      ASIZE,
                                      tot_len,
                                      max_length_comb,
                                      length_comb,
                                      WrapLogLen_comb,
                                      SizeMax,
                                      SameMstSlvSize,
                                      sizeCnt_comb,
                                      MASTER_AADDR_mux,
		                              fixed_burst,
                                      unaligned_fixed_len_iter,
 
                                      //  output ports
                                      MASTER_AREADY,
                                      SLAVE_ALEN,
                                      SLAVE_AVALID,
                                      SLAVE_AID,
                                      SLAVE_AADDR,
                                      SLAVE_ABURST,
                                      SLAVE_ACACHE,
                                      SLAVE_ALOCK,
                                      SLAVE_ASIZE,
                                      SLAVE_APROT,
                                      SLAVE_AQOS,
                                      SLAVE_AREGION,
                                      SLAVE_AUSER,
                                      FifoWe,
                                      CmdFifoWrData,
                                      brespFifoWrData
                                      );
 
   parameter        ADDR_WIDTH            = 20;
   parameter        ID_WIDTH              = 1;
   parameter        USER_WIDTH            = 1;
   parameter        DATA_WIDTH_IN         = 32;
   parameter        DATA_WIDTH_OUT        = 32;
   parameter        CMD_FIFO_DATA_WIDTH   = 30;   
   parameter        READ_INTERLEAVE       = 1;
   parameter        TOTAL_IDS             = (2 ** ID_WIDTH);
//  input ports
   input            ACLK;
   wire             ACLK;
   input            sysReset;
   wire             sysReset;
   input            MASTER_AVALID;
   wire             MASTER_AVALID;
   input     [ID_WIDTH - 1:0] MASTER_AID;
   wire      [ID_WIDTH - 1:0] MASTER_AID;
   input     [ADDR_WIDTH - 1:0] MASTER_AADDR;
   wire      [ADDR_WIDTH - 1:0] MASTER_AADDR;
   input     [1:0]  MASTER_ABURST;
   wire      [1:0]  MASTER_ABURST;
   input     [3:0]  MASTER_ACACHE;
   wire      [3:0]  MASTER_ACACHE;
   input     [1:0]  MASTER_ALOCK;
   wire      [1:0]  MASTER_ALOCK;
   input     [2:0]  MASTER_ASIZE;
   wire      [2:0]  MASTER_ASIZE;
   input     [2:0]  MASTER_APROT;
   wire      [2:0]  MASTER_APROT;
   input     [3:0]  MASTER_AQOS;
   wire      [3:0]  MASTER_AQOS;
   input     [3:0]  MASTER_AREGION;
   wire      [3:0]  MASTER_AREGION;
   input     [USER_WIDTH - 1:0] MASTER_AUSER;
   wire      [USER_WIDTH - 1:0] MASTER_AUSER;
   input            SLAVE_AREADY;
   wire             SLAVE_AREADY;
//   input     [TOTAL_IDS-1:0] CmdFifoNearlyFull;
//   wire      [TOTAL_IDS-1:0] CmdFifoNearlyFull;
   input            CmdFifoNearlyFull;
   wire             CmdFifoNearlyFull;
   input            brespFifoNearlyFull;
   wire             brespFifoNearlyFull;
   input     [4:0]  to_boundary_master;
   wire      [4:0]  to_boundary_master;
   input     [5:0]  mask_addr;
   wire      [5:0]  mask_addr;
   input     [2:0]  ASIZE;
   wire      [2:0]  ASIZE;
   input     [12:0] tot_len;
   wire      [12:0] tot_len;
   input     [8:0]  max_length_comb;
   wire      [8:0]  max_length_comb;
   input     [8:0]  length_comb;
   wire      [8:0]  length_comb;
   input     [2:0]  WrapLogLen_comb;
   wire      [2:0]  WrapLogLen_comb;
   input     [5:0]  SizeMax;
   wire      [5:0]  SizeMax;
   input            SameMstSlvSize;
   wire             SameMstSlvSize;
   input     [5:0]  sizeCnt_comb;
   wire      [5:0]  sizeCnt_comb;
   input     [ADDR_WIDTH - 1:0] MASTER_AADDR_mux;
   wire      [ADDR_WIDTH - 1:0] MASTER_AADDR_mux;
   input            fixed_burst;
   input     [6:0]  unaligned_fixed_len_iter;
//  output ports
   output           MASTER_AREADY;
   reg              MASTER_AREADY;
   output    [7:0]  SLAVE_ALEN;
   reg       [7:0]  SLAVE_ALEN;
   output           SLAVE_AVALID;
   reg              SLAVE_AVALID;
   output    [ID_WIDTH - 1:0] SLAVE_AID;
   reg       [ID_WIDTH - 1:0] SLAVE_AID;
   output    [ADDR_WIDTH - 1:0] SLAVE_AADDR;
   reg       [ADDR_WIDTH - 1:0] SLAVE_AADDR;
   output    [1:0]  SLAVE_ABURST;
   reg       [1:0]  SLAVE_ABURST;
   output    [3:0]  SLAVE_ACACHE;
   reg       [3:0]  SLAVE_ACACHE;
   output    [1:0]  SLAVE_ALOCK;
   reg       [1:0]  SLAVE_ALOCK;
   output    [2:0]  SLAVE_ASIZE;
   reg       [2:0]  SLAVE_ASIZE;
   output    [2:0]  SLAVE_APROT;
   reg       [2:0]  SLAVE_APROT;
   output    [3:0]  SLAVE_AQOS;
   reg       [3:0]  SLAVE_AQOS;
   output    [3:0]  SLAVE_AREGION;
   reg       [3:0]  SLAVE_AREGION;
   output    [USER_WIDTH - 1:0] SLAVE_AUSER;
   reg       [USER_WIDTH - 1:0] SLAVE_AUSER;
   output           FifoWe;
   wire             FifoWe;
   output    [CMD_FIFO_DATA_WIDTH - 1:0] CmdFifoWrData;
   reg       [CMD_FIFO_DATA_WIDTH - 1:0] CmdFifoWrData;
   output    [ID_WIDTH:0] brespFifoWrData;
   wire      [ID_WIDTH:0] brespFifoWrData;
//  local signals
   reg       [14:0] incr_addr;
   wire      [ADDR_WIDTH - 1:0] next_addr;
   reg       [12:0] len_latched;
   reg       [8:0]  max_length;
   wire      [1:0]  FIXED;
   wire      [1:0]  INCR;
   wire      [1:0]  WRAP;
   wire      [ADDR_WIDTH - 1:0] aligned_addr;
   reg       [2:0]  ASIZE_reg;
   reg       [2:0]  MASTER_ASIZE_reg;
   reg              SameMstSlvSize_reg;
   reg       [5:0]  SizeMax_reg;
   wire             addr_phase_accept;
   reg              fixed_flag;
   wire      [ADDR_WIDTH - 1:0] wrap_addr;
   wire      [9:0]  mask_wrap_addr;
   reg       [2:0]  WrapLogLen_reg;
   reg       [1:0]  MASTER_ABURST_reg;
   wire      [3:0]  wrap_mask_shift;
   reg       [ID_WIDTH - 1:0] MASTER_AID_reg;
   reg       [5:0]  sizeCnt_reg;
//   reg       [TOTAL_IDS-1:0] FifoNearlyFull_reg;
//   wire      [TOTAL_IDS-1:0] FifoNearlyFull;
   reg              FifoNearlyFull_reg;
   wire             FifoNearlyFull;
   reg       [8:0]  length;
   wire      [14:0] SLAVE_ALEN_P1;
   reg              full_flag;
   reg              tx_in_progress;
   wire      [8:0]  to_boundary_conv;
   wire      [7:0]  tot_axi_len;
   reg       [5:0]  mask_addr_reg;
   reg       [6:0]  unaligned_fixed_burst_count;
   reg              fixed_burst_reg;
 
   parameter SEND_TRANS  = 1'b0,
             WAIT_AVALID = 1'b1;
 
 
   reg [0:0] visual_CmdFifoWriteCtrl_current, visual_CmdFifoWriteCtrl_next;
 
   reg       [7:0]  visual_SLAVE_ALEN_next;
   reg              visual_SLAVE_AVALID_next;
   reg       [ID_WIDTH-1:0] visual_SLAVE_AID_next;
   reg       [ADDR_WIDTH - 1:0] visual_SLAVE_AADDR_next;
   reg       [1:0]  visual_SLAVE_ABURST_next;
   reg       [2:0]  visual_SLAVE_ASIZE_next;
   reg       [CMD_FIFO_DATA_WIDTH - 1:0] visual_CmdFifoWrData_next;
   reg       [12:0] visual_len_latched_next;
   reg       [8:0]  visual_max_length_next;
   reg       [2:0]  visual_ASIZE_reg_next;
   reg       [2:0]  visual_MASTER_ASIZE_reg_next;
   reg              visual_SameMstSlvSize_reg_next;
   reg       [5:0]  visual_SizeMax_reg_next;
   reg              visual_fixed_flag_next;
   reg       [2:0]  visual_WrapLogLen_reg_next;
   reg       [1:0]  visual_MASTER_ABURST_reg_next;
   reg       [ID_WIDTH - 1:0] visual_MASTER_AID_reg_next;
   reg       [5:0]  visual_sizeCnt_reg_next;
   reg       [8:0]  visual_length_next;
   reg              visual_full_flag_next;
   reg              visual_tx_in_progress_next;
   reg       [5:0]  visual_mask_addr_reg_next;
   reg       [6:0]  visual_unaligned_fixed_burst_count_next;
   reg              visual_fixed_burst;
 
 
   // Combinational process
   always@ (*)
   begin : CmdFifoWriteCtrl_comb
      MASTER_AREADY <= 1'b0;
      visual_SLAVE_ALEN_next <= SLAVE_ALEN;
      visual_SLAVE_AVALID_next <= SLAVE_AVALID;
      visual_SLAVE_AID_next <= SLAVE_AID;
      visual_SLAVE_AADDR_next <= SLAVE_AADDR;
      visual_SLAVE_ABURST_next <= SLAVE_ABURST;
      visual_SLAVE_ASIZE_next <= SLAVE_ASIZE;
      visual_CmdFifoWrData_next <= CmdFifoWrData;
      visual_len_latched_next <= len_latched;
      visual_max_length_next <= max_length;
      visual_ASIZE_reg_next <= ASIZE_reg;
      visual_MASTER_ASIZE_reg_next <= MASTER_ASIZE_reg;
      visual_SameMstSlvSize_reg_next <= SameMstSlvSize_reg;
      visual_SizeMax_reg_next <= SizeMax_reg;
      visual_fixed_flag_next <= fixed_flag;
      visual_WrapLogLen_reg_next <= WrapLogLen_reg;
      visual_MASTER_ABURST_reg_next <= MASTER_ABURST_reg;
      visual_MASTER_AID_reg_next <= MASTER_AID_reg;
      visual_sizeCnt_reg_next <= sizeCnt_reg;
      visual_length_next <= length;
      visual_full_flag_next <= full_flag;
      visual_tx_in_progress_next <= tx_in_progress;
      visual_mask_addr_reg_next <= mask_addr_reg;
	  visual_unaligned_fixed_burst_count_next <= unaligned_fixed_burst_count; 
	  visual_fixed_burst <= fixed_burst_reg; 
 
      case (visual_CmdFifoWriteCtrl_current)
         SEND_TRANS:
            begin
               MASTER_AREADY <= 1'b0;
               incr_addr <= ((SLAVE_ALEN_P1) << ASIZE_reg);
               if (FifoNearlyFull)
               begin
                  if (FifoWe)
                  begin
                     visual_full_flag_next <= 1'b1;
                     visual_SLAVE_AVALID_next <= 1'b0;
                     visual_tx_in_progress_next <= 1'b0;
                     if (len_latched == 0)
                     begin
                        visual_CmdFifoWriteCtrl_next <= WAIT_AVALID;
                     end
                     else
                     begin
                        visual_SLAVE_AADDR_next <= next_addr;
                        if (len_latched > max_length)
                        begin
                           visual_SLAVE_ALEN_next <= length - 1;
                           visual_len_latched_next <= len_latched - max_length;
                           visual_CmdFifoWrData_next <= {fixed_burst_reg,sizeCnt_reg, MASTER_AID_reg, fixed_flag, next_addr[5:0], length, ASIZE_reg, MASTER_ASIZE_reg, SameMstSlvSize_reg, SizeMax_reg, 1'b0};
                           visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                        end
                        else if((unaligned_fixed_burst_count > 1) & fixed_burst_reg)
						begin 
                           visual_SLAVE_ALEN_next <= length - 1;
                           visual_CmdFifoWrData_next <= {fixed_burst_reg,sizeCnt_reg, MASTER_AID_reg, fixed_flag, next_addr[5:0], length, ASIZE_reg, MASTER_ASIZE_reg, SameMstSlvSize_reg, SizeMax_reg, 1'b0};
						   visual_unaligned_fixed_burst_count_next <= unaligned_fixed_burst_count - 1'b1;
                           visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
						end 
						else 
                        begin
                           visual_SLAVE_ALEN_next <= fixed_burst_reg ? length - 1'b1 : ((max_length == length) ? len_latched : length) - 1;
                           visual_len_latched_next <= 0;
                           visual_CmdFifoWrData_next <= {fixed_burst_reg,sizeCnt_reg, MASTER_AID_reg, fixed_flag, next_addr[5:0], fixed_burst_reg ? length : ((max_length == length) ? len_latched[8:0] : length), ASIZE_reg, MASTER_ASIZE_reg,
                                                  SameMstSlvSize_reg, SizeMax_reg, 1'b1};
                           visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                        end
                     end
                  end
                  else
                  begin
                     visual_SLAVE_AVALID_next <= ~(full_flag);
                     visual_tx_in_progress_next <= ~(full_flag);
                     visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                  end
               end
               else
               begin
                  visual_full_flag_next <= 1'b0;
                  visual_SLAVE_AVALID_next <= 1'b1;
                  visual_tx_in_progress_next <= 1'b1;
                  if (tx_in_progress)
                  begin
                     if (SLAVE_AREADY)
                     begin
                        if (len_latched == 0)
                        begin
                           visual_SLAVE_AVALID_next <= 0;
                           visual_CmdFifoWriteCtrl_next <= WAIT_AVALID;
                        end
                        else
                        begin
                           visual_SLAVE_AADDR_next <= next_addr;
                           if (len_latched > max_length)
                           begin
                              visual_SLAVE_ALEN_next <= length - 1;
                              visual_len_latched_next <= len_latched - max_length;
                              visual_CmdFifoWrData_next <= {fixed_burst_reg,sizeCnt_reg, MASTER_AID_reg, fixed_flag, next_addr[5:0], length, ASIZE_reg, MASTER_ASIZE_reg, SameMstSlvSize_reg, SizeMax_reg, 1'b0};
                              visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                           end
                           else if((unaligned_fixed_burst_count > 1) & fixed_burst_reg)
						   begin 
                              visual_SLAVE_ALEN_next <= length - 1;
                              visual_CmdFifoWrData_next <= {fixed_burst_reg,sizeCnt_reg, MASTER_AID_reg, fixed_flag, next_addr[5:0], length, ASIZE_reg, MASTER_ASIZE_reg, SameMstSlvSize_reg, SizeMax_reg, 1'b0};
                              visual_unaligned_fixed_burst_count_next <= unaligned_fixed_burst_count - 1'b1;
                              visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
						   end						   
                           else
                           begin
                              visual_SLAVE_ALEN_next <= fixed_burst_reg ? length - 1'b1 : ((max_length == length) ? len_latched : length) - 1;
                              visual_len_latched_next <= 0;
                              visual_CmdFifoWrData_next <= {fixed_burst_reg,sizeCnt_reg, MASTER_AID_reg, fixed_flag, next_addr[5:0], fixed_burst_reg ? length : ((max_length == length) ? len_latched[8:0] : length), ASIZE_reg, MASTER_ASIZE_reg,
                                                  SameMstSlvSize_reg, SizeMax_reg, 1'b1};
                              visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                           end
                        end
                     end
                     else
                     begin
                        visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                     end
                  end
                  else if (FifoNearlyFull_reg)
                  begin
                     visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                  end
                  else if (SLAVE_AREADY)
                  begin
                     if (len_latched == 0)
                     begin
                        visual_SLAVE_AVALID_next <= 0;
                        visual_CmdFifoWriteCtrl_next <= WAIT_AVALID;
                     end
                     else
                     begin
                        visual_SLAVE_AADDR_next <= next_addr;
                        if (len_latched > max_length)
                        begin
                           visual_SLAVE_ALEN_next <= length - 1;
                           visual_len_latched_next <= len_latched - max_length;
                           visual_CmdFifoWrData_next <= {fixed_burst_reg,sizeCnt_reg, MASTER_AID_reg, fixed_flag, next_addr[5:0], length, ASIZE_reg, MASTER_ASIZE_reg, SameMstSlvSize_reg, SizeMax_reg, 1'b0};
                           visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                        end
                        else if((unaligned_fixed_burst_count > 1) & fixed_burst_reg)
						begin 
                           visual_SLAVE_ALEN_next <= length - 1;
                           visual_CmdFifoWrData_next <= {fixed_burst_reg,sizeCnt_reg, MASTER_AID_reg, fixed_flag, next_addr[5:0], length, ASIZE_reg, MASTER_ASIZE_reg, SameMstSlvSize_reg, SizeMax_reg, 1'b0};
						   visual_unaligned_fixed_burst_count_next <= unaligned_fixed_burst_count - 1'b1;
                           visual_CmdFifoWriteCtrl_next <= SEND_TRANS;						
						end 
                        else
                        begin
                           visual_SLAVE_ALEN_next <= fixed_burst_reg ? length - 1'b1 : ((max_length == length) ? len_latched : length) - 1;
                           visual_len_latched_next <= 0;
                           visual_CmdFifoWrData_next <= {fixed_burst_reg,sizeCnt_reg, MASTER_AID_reg, fixed_flag, next_addr[5:0], fixed_burst_reg ? length : ((max_length == length) ? len_latched[8:0] : length), ASIZE_reg, MASTER_ASIZE_reg,
                                                  SameMstSlvSize_reg, SizeMax_reg, 1'b1};
                           visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                        end
                     end
                  end
                  else
                  begin
                     visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                  end
               end
            end
 
         WAIT_AVALID:
            begin
               if (MASTER_AVALID)
               begin
                  if (FifoNearlyFull)
                  begin
                     visual_CmdFifoWrData_next <= 0;
                     visual_SLAVE_AVALID_next <= 0;
                     visual_full_flag_next <= FifoNearlyFull;
                     visual_tx_in_progress_next <= 1'b0;
                     MASTER_AREADY <= 1'b0;
                     incr_addr <= 0;
                     visual_CmdFifoWriteCtrl_next <= WAIT_AVALID;
                  end
                  else
                  begin
                     visual_full_flag_next <= 1'b0;
                     visual_tx_in_progress_next <= 1'b1;
                     visual_SLAVE_ASIZE_next <= ASIZE;
					 visual_SLAVE_AID_next <= MASTER_AID;
                     visual_SLAVE_AADDR_next <= MASTER_AADDR_mux;
                     visual_SLAVE_AVALID_next <= 1;
                     MASTER_AREADY <= 1'b1;
                     visual_ASIZE_reg_next <= ASIZE;
                     visual_MASTER_ASIZE_reg_next <= MASTER_ASIZE;
                     visual_MASTER_ABURST_reg_next <= MASTER_ABURST;
                     visual_SizeMax_reg_next <= SizeMax;
                     visual_SameMstSlvSize_reg_next <= SameMstSlvSize;
                     visual_WrapLogLen_reg_next <= WrapLogLen_comb;
                     visual_MASTER_AID_reg_next <= MASTER_AID;
                     visual_sizeCnt_reg_next <= sizeCnt_comb;
                     incr_addr <= ((SLAVE_ALEN_P1) << ASIZE);
                     visual_mask_addr_reg_next <= mask_addr;
                     visual_fixed_burst <= fixed_burst;
                     if (MASTER_ABURST == WRAP)
                     begin
                        visual_SLAVE_ALEN_next <= to_boundary_conv - 1;
                        visual_len_latched_next <= tot_len - to_boundary_conv;
                        visual_fixed_flag_next <= 1'b0;
                        visual_SLAVE_ABURST_next <= INCR;
                        visual_CmdFifoWrData_next <= {1'b0,sizeCnt_comb, MASTER_AID, 1'b0, MASTER_AADDR[5:0], to_boundary_conv, ASIZE, MASTER_ASIZE, SameMstSlvSize, SizeMax, (tot_len == to_boundary_conv)};
                        visual_max_length_next <= max_length_comb;
                        visual_length_next <= length_comb;
                        visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                     end
                     else if (SameMstSlvSize)
                     begin
                        visual_fixed_flag_next <= (MASTER_ABURST == FIXED);
                        visual_len_latched_next <= 0;
                        visual_SLAVE_ALEN_next <= tot_axi_len;
                        visual_SLAVE_ABURST_next <= MASTER_ABURST;
                        visual_CmdFifoWrData_next <= {fixed_burst,sizeCnt_comb, MASTER_AID, (MASTER_ABURST == FIXED), MASTER_AADDR[5:0], tot_len[8:0], ASIZE, MASTER_ASIZE, SameMstSlvSize, SizeMax, 1'b1};
                        visual_max_length_next <= 9'h0;
                        visual_length_next <= 9'h0;
                        visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                     end
                     else
                     begin
                        visual_fixed_flag_next <= 1'b0;
                        if (MASTER_ABURST == FIXED)
                        begin
                           visual_SLAVE_ALEN_next <= length_comb - 1;
                           visual_len_latched_next <= (unaligned_fixed_len_iter == 1) ? 0 : max_length_comb;
                           visual_SLAVE_ABURST_next <= MASTER_ABURST;
                           visual_CmdFifoWrData_next <= {fixed_burst,sizeCnt_comb, MASTER_AID, 1'b0, MASTER_AADDR_mux[5:0], length_comb, ASIZE, MASTER_ASIZE, SameMstSlvSize, SizeMax, (unaligned_fixed_len_iter == 1)}
                                                  ;
                           visual_max_length_next <= max_length_comb;
                           visual_length_next <= length_comb;
						   visual_unaligned_fixed_burst_count_next <= unaligned_fixed_len_iter - 1'b1;
                           visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                        end
                        else if (tot_len > max_length_comb)
                        begin
                           visual_SLAVE_ALEN_next <= length_comb - 1;
                           visual_len_latched_next <= tot_len - max_length_comb;
                           visual_SLAVE_ABURST_next <= MASTER_ABURST;
                           visual_CmdFifoWrData_next <= {fixed_burst,sizeCnt_comb, MASTER_AID, 1'b0, MASTER_AADDR_mux[5:0], length_comb, ASIZE, MASTER_ASIZE, SameMstSlvSize, SizeMax, (tot_len == max_length_comb)}
                                                  ;
                           visual_max_length_next <= max_length_comb;
                           visual_length_next <= length_comb;
                           visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                        end
                        else
                        begin
                           visual_len_latched_next <= 0;
                           visual_SLAVE_ALEN_next <= tot_axi_len;
                           visual_SLAVE_ABURST_next <= MASTER_ABURST;
                           visual_CmdFifoWrData_next <= {fixed_burst,sizeCnt_comb, MASTER_AID, (MASTER_ABURST == FIXED), MASTER_AADDR[5:0], tot_len[8:0], ASIZE, MASTER_ASIZE, SameMstSlvSize, SizeMax, 1'b1};
                           visual_max_length_next <= 9'h0;
                           visual_length_next <= 9'h0;
                           visual_CmdFifoWriteCtrl_next <= SEND_TRANS;
                        end
                     end
                  end
               end
               else
               begin
                  visual_CmdFifoWrData_next <= 0;
                  visual_SLAVE_AVALID_next <= 0;
                  visual_full_flag_next <= FifoNearlyFull;
                  visual_tx_in_progress_next <= 1'b0;
                  MASTER_AREADY <= 1'b0;
                  incr_addr <= 0;
                  visual_CmdFifoWriteCtrl_next <= WAIT_AVALID;
               end
            end
 
         default:
            begin
               visual_CmdFifoWriteCtrl_next <= WAIT_AVALID;
            end
      endcase
   end
 
   always@(posedge ACLK or negedge sysReset)
   begin : CmdFifoWriteCtrl
 
      if (!sysReset)
      begin
         SLAVE_ASIZE <= 0;
         SLAVE_AADDR <= 0;
         SLAVE_AVALID <= 0;
         ASIZE_reg <= 0;
         MASTER_ASIZE_reg <= 0;
         MASTER_ABURST_reg <= 0;
         SizeMax_reg <= 0;
         SameMstSlvSize_reg <= 0;
         WrapLogLen_reg <= 0;
         len_latched <= 0;
         SLAVE_ALEN <= 0;
         SLAVE_ABURST <= 0;
         CmdFifoWrData <= 0;
         max_length <= 0;
         fixed_flag <= 0;
         MASTER_AID_reg <= 0;
         sizeCnt_reg <= 0;
		 length <= 9'd0;
         full_flag <= 1'b0;
         tx_in_progress <= 1'b0;
         mask_addr_reg <= 0;
         visual_CmdFifoWriteCtrl_current <= WAIT_AVALID;
         unaligned_fixed_burst_count <= 0;
         fixed_burst_reg <= 0;
      end
      else
      begin
         SLAVE_ALEN <= visual_SLAVE_ALEN_next;
         SLAVE_AVALID <= visual_SLAVE_AVALID_next;
         SLAVE_AADDR <= visual_SLAVE_AADDR_next;
         SLAVE_ABURST <= visual_SLAVE_ABURST_next;
         SLAVE_ASIZE <= visual_SLAVE_ASIZE_next;
         CmdFifoWrData <= visual_CmdFifoWrData_next;
         len_latched <= visual_len_latched_next;
         max_length <= visual_max_length_next;
         ASIZE_reg <= visual_ASIZE_reg_next;
         MASTER_ASIZE_reg <= visual_MASTER_ASIZE_reg_next;
         SameMstSlvSize_reg <= visual_SameMstSlvSize_reg_next;
         SizeMax_reg <= visual_SizeMax_reg_next;
         fixed_flag <= visual_fixed_flag_next;
         WrapLogLen_reg <= visual_WrapLogLen_reg_next;
         MASTER_ABURST_reg <= visual_MASTER_ABURST_reg_next;
         MASTER_AID_reg <= visual_MASTER_AID_reg_next;
         sizeCnt_reg <= visual_sizeCnt_reg_next;
         length <= visual_length_next;
         full_flag <= visual_full_flag_next;
         tx_in_progress <= visual_tx_in_progress_next;
         mask_addr_reg <= visual_mask_addr_reg_next;
         visual_CmdFifoWriteCtrl_current <= visual_CmdFifoWriteCtrl_next;
		 unaligned_fixed_burst_count <= visual_unaligned_fixed_burst_count_next;
		 fixed_burst_reg  <= visual_fixed_burst;
      end
   end
 
 
 
   always@( posedge ACLK or negedge sysReset )
   begin   :AChan_unchanged_sigs
 
      if (!sysReset)
      begin
         SLAVE_ALOCK <= 0;
         SLAVE_APROT <= 0;
         SLAVE_AUSER <= 0;
         SLAVE_AREGION <= 0;
         SLAVE_AQOS <= 0;
         SLAVE_ACACHE <= 0;
      end
      else
      begin
         if (addr_phase_accept)
         begin
            SLAVE_ALOCK <= MASTER_ALOCK;
            SLAVE_APROT <= MASTER_APROT;
            SLAVE_AUSER <= MASTER_AUSER;
            SLAVE_AREGION <= MASTER_AREGION;
            SLAVE_AQOS <= MASTER_AQOS;
            SLAVE_ACACHE <= MASTER_ACACHE;
         end
      end
   end
 
 
 
   always @( posedge ACLK or negedge sysReset )
   begin   :CmdFifoFull_register
 
      if (!sysReset)
      begin
         FifoNearlyFull_reg <= 0;
      end
      else
      begin
         FifoNearlyFull_reg <= FifoNearlyFull;
      end
   end
 
   // force the slave to process transaction in order. It reduces the memory resources required in the converters
   //assign SLAVE_AID = READ_INTERLEAVE ? MASTER_AID : {ID_WIDTH{1'b0}} ;
   
   always@(posedge ACLK or negedge sysReset)
     begin
       if (!sysReset)
	     SLAVE_AID <= {ID_WIDTH{1'b0}};
	   else if(READ_INTERLEAVE)
         SLAVE_AID   <= visual_SLAVE_AID_next;
	   else  
	     SLAVE_AID   <= {ID_WIDTH{1'b0}};
     end
 
   assign SLAVE_ALEN_P1 = SLAVE_ALEN + 1;
   assign wrap_mask_shift = (MASTER_ASIZE_reg+WrapLogLen_reg);
   assign mask_wrap_addr = (10'h3ff << wrap_mask_shift);
   assign wrap_addr = {SLAVE_AADDR[ADDR_WIDTH-1:10], (SLAVE_AADDR[9:0] & mask_wrap_addr)};
 
   // next address computation.
   // FIXED burst: address unchanged
   // INCR burst: address incremented by the number of byte written during the burst
   // WRAP burst: align the address to the lower wrap boundary
   assign next_addr = (MASTER_ABURST_reg == FIXED) ? SLAVE_AADDR:
       ((MASTER_ABURST_reg == INCR) ? (aligned_addr + incr_addr) : wrap_addr);
 
   assign aligned_addr = {SLAVE_AADDR[ADDR_WIDTH-1:6], (SLAVE_AADDR[5:0] & mask_addr_reg)};
 
   assign FIXED = 2'b00;
   assign INCR = 2'b01;
   assign WRAP = 2'b10;
 
   assign addr_phase_accept = MASTER_AREADY & MASTER_AVALID;
 
   assign FifoWe = SLAVE_AVALID & SLAVE_AREADY;
   assign brespFifoWrData = {MASTER_AID_reg, CmdFifoWrData[0]};
 
   assign FifoNearlyFull = (brespFifoNearlyFull | CmdFifoNearlyFull);
 
   assign tot_axi_len = tot_len - 1;
   assign to_boundary_conv = to_boundary_master << (MASTER_ASIZE-ASIZE);
 
 
endmodule

