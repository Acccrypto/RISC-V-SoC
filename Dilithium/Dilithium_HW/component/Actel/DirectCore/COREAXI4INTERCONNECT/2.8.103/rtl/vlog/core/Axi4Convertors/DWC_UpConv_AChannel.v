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
 
 
module caxi4interconnect_DWC_UpConv_AChannel (
                            //  input ports
                            ACLK,
                            sysReset,
                            MASTER_ALEN,
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
                            fifoFull,
                            to_boundary_master_pre,
                            mask_wrap_addr_pre,
                            sizeDiff_pre,
                            unaligned_wrap_burst_comb_pre,
                            len_offset_pre,
                            wrap_tx_pre,
                            fixed_flag_comb_pre,
                            alen_sec_wrap_pre,
                            alen_wrap_pre,
 
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
                            extend_tx,
                            wr_en_cmd,
                            addr_fifo,
                            asize_mst,
                            alen_mst,
                            wrap_flag,
                            fixed_flag,
                            last_beat_wrap,
                            unaligned_wrap_burst,
                            aid_mst
                            );
 
   parameter        ADDR_WIDTH                      = 20;
   parameter        ID_WIDTH                        = 1;
   parameter        USER_WIDTH                      = 1;
   parameter        DATA_WIDTH_IN                   = 32;
   parameter        DATA_WIDTH_OUT                  = 32;
   parameter        CMD_FIFO_DATA_WIDTH             = 30;
   parameter        TOTAL_IDS                       = (2 ** ID_WIDTH);
   parameter        READ_INTERLEAVE                 = 0;
//  input ports
   input            ACLK;
   wire             ACLK;
   input            sysReset;
   wire             sysReset;
   input     [7:0]  MASTER_ALEN;
   wire      [7:0]  MASTER_ALEN;
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
   input     [TOTAL_IDS-1:0] fifoFull;
   wire      [TOTAL_IDS-1:0] fifoFull;
   input     [4:0]  to_boundary_master_pre;
   wire      [4:0]  to_boundary_master_pre;
   input     [9:0]  mask_wrap_addr_pre;
   wire      [9:0]  mask_wrap_addr_pre;
   input     [2:0]  sizeDiff_pre;
   wire      [2:0]  sizeDiff_pre;
   input            unaligned_wrap_burst_comb_pre;
   wire             unaligned_wrap_burst_comb_pre;
   input     [5:0]  len_offset_pre;
   wire      [5:0]  len_offset_pre;
   input            wrap_tx_pre;
   wire             wrap_tx_pre;
   input            fixed_flag_comb_pre;
   wire             fixed_flag_comb_pre;
   input     [7:0]  alen_sec_wrap_pre;
   wire      [7:0]  alen_sec_wrap_pre;
   input     [7:0]  alen_wrap_pre;
   wire      [7:0]  alen_wrap_pre;
//  output ports
   output           MASTER_AREADY;
   reg              MASTER_AREADY;
   output    [7:0]  SLAVE_ALEN;
   reg       [7:0]  SLAVE_ALEN;
   output           SLAVE_AVALID;
   reg              SLAVE_AVALID;
   output    [ID_WIDTH - 1:0] SLAVE_AID;
   wire      [ID_WIDTH - 1:0] SLAVE_AID;
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
   output           extend_tx;
   reg              extend_tx;
   output           wr_en_cmd;
   wire             wr_en_cmd;
   output    [5:0]  addr_fifo;
   reg       [5:0]  addr_fifo;
   output    [2:0]  asize_mst;
   reg       [2:0]  asize_mst;
   output    [7:0]  alen_mst;
   reg       [7:0]  alen_mst;
   output           wrap_flag;
   reg              wrap_flag;
   output           fixed_flag;
   reg              fixed_flag;
   output    [4:0]  last_beat_wrap;
   reg       [4:0]  last_beat_wrap;
   output           unaligned_wrap_burst;
   reg              unaligned_wrap_burst;
   output    [ID_WIDTH - 1:0] aid_mst;
   reg       [ID_WIDTH - 1:0] aid_mst;
//  local signals
   wire      [1:0]  WRAP;
   reg       [4:0]  to_boundary_master;
   reg       [4:0]  to_boundary_master_reg;
   wire      [7:0]  alen_int;
   wire      [8:0]  alen_tot;
   wire      [7:0]  alen_wrap;
   wire      [7:0]  alen_sec_wrap;
   wire      [7:0]  wrap_alen_out;
   wire      [7:0]  alen_out;
   reg       [5:0]  len_offset;
   reg       [5:0]  len_offset_reg;
   reg       [9:0]  mask_wrap_addr;
   reg              unaligned_wrap_burst_comb;
   reg       [2:0]  sizeDiff_reg;
   reg       [2:0]  sizeDiff;
   wire             addr_phase_accept;
   reg              wrap_tx;
   reg       [9:0]  mask_wrap_addr_reg;
   reg       [7:0]  MASTER_ALEN_int;
   reg              fixed_flag_comb;
   reg              wait_avalid_state;
   reg       [7:0]  alen_sec_wrap_reg;
   reg       [7:0]  alen_wrap_reg;
 
   parameter SEND_TRANS  = 1'b0,
             WAIT_AVALID = 1'b1;
 
 
   reg [0:0] visual_AChan_FSM_current, visual_AChan_FSM_next;
 
   reg       [7:0]  visual_SLAVE_ALEN_next;
   reg              visual_SLAVE_AVALID_next;
   reg       [ID_WIDTH-1:0] visual_SLAVE_AID_next;
   reg       [ADDR_WIDTH - 1:0] visual_SLAVE_AADDR_next;
   reg       [1:0]  visual_SLAVE_ABURST_next;
   reg       [2:0]  visual_SLAVE_ASIZE_next;
   reg              visual_extend_tx_next;
   reg       [5:0]  visual_addr_fifo_next;
   reg       [2:0]  visual_asize_mst_next;
   reg       [7:0]  visual_alen_mst_next;
   reg              visual_wrap_flag_next;
   reg       [ID_WIDTH - 1:0] visual_aid_mst_next;
   
   wire      [TOTAL_IDS-1:0] fifoFull_Ctrl = READ_INTERLEAVE ? fifoFull[MASTER_AID] : fifoFull;
   
   reg       [ID_WIDTH - 1:0] SLAVE_AID_REG;
 
 
   // Combinational process
   always@(*)
   //always  @(SLAVE_ALEN or SLAVE_AVALID or SLAVE_AADDR or SLAVE_ABURST or SLAVE_ASIZE or extend_tx or addr_fifo or asize_mst or alen_mst or wrap_flag or aid_mst or SLAVE_AREADY or mask_wrap_addr or
   //          alen_out or MASTER_AVALID or fifoFull or MASTER_AADDR or unaligned_wrap_burst_comb or MASTER_ABURST or WRAP or MASTER_ASIZE or MASTER_ALEN or MASTER_AID or fixed_flag_comb or
   //          visual_AChan_FSM_current)
   begin : AChan_FSM_comb
      MASTER_AREADY <= 1'b0;
      visual_SLAVE_ALEN_next <= SLAVE_ALEN;
      visual_SLAVE_AVALID_next <= SLAVE_AVALID;
      visual_SLAVE_AADDR_next <= SLAVE_AADDR;
      visual_SLAVE_ABURST_next <= SLAVE_ABURST;
      visual_SLAVE_ASIZE_next <= SLAVE_ASIZE;
      visual_SLAVE_AID_next <= SLAVE_AID;
      visual_extend_tx_next <= extend_tx;
      visual_addr_fifo_next <= addr_fifo;
      visual_asize_mst_next <= asize_mst;
      visual_alen_mst_next <= alen_mst;
      visual_wrap_flag_next <= wrap_flag;
      visual_aid_mst_next <= aid_mst;
      wait_avalid_state <= 0;
 
 
 
      case (visual_AChan_FSM_current)
         SEND_TRANS:
            begin
               MASTER_AREADY <= 1'b0;
               if (SLAVE_AREADY)
               begin
                  if (extend_tx)
                  begin
                     visual_SLAVE_AVALID_next <= 1;
                     visual_SLAVE_AADDR_next <= {SLAVE_AADDR[ADDR_WIDTH - 1:10], (SLAVE_AADDR[9:0] & ~(mask_wrap_addr))};
                     visual_SLAVE_ALEN_next <= alen_out;
                     visual_SLAVE_ABURST_next <= 2'b01;
                     visual_addr_fifo_next <= SLAVE_AADDR[5:0] & ~(mask_wrap_addr[5:0]);
                     visual_extend_tx_next <= 1'b0;
                     visual_SLAVE_ASIZE_next <= $clog2 (DATA_WIDTH_OUT / 8);
                     visual_AChan_FSM_next <= SEND_TRANS;
                  end
                  else
                  begin
                     visual_SLAVE_AVALID_next <= 0;
                     visual_AChan_FSM_next <= WAIT_AVALID;
                  end
               end
               else
               begin
                  visual_SLAVE_AVALID_next <= 1'b1;
                  visual_AChan_FSM_next <= SEND_TRANS;
               end
            end
 
         WAIT_AVALID:
            begin
               wait_avalid_state <= 1;
               if (MASTER_AVALID)
               begin
                  if (fifoFull_Ctrl)
                  begin
                     visual_SLAVE_AVALID_next <= 0;
                     visual_AChan_FSM_next <= WAIT_AVALID;
                  end
                  else
                  begin
                     visual_SLAVE_AADDR_next <= MASTER_AADDR;
                     visual_SLAVE_ALEN_next <= alen_out;
                     visual_SLAVE_AVALID_next <= 1'b1;
					 visual_SLAVE_AID_next    <= MASTER_AID;
                     MASTER_AREADY <= 1'b1;
                     visual_addr_fifo_next <= MASTER_AADDR[5:0];
                     visual_extend_tx_next <= unaligned_wrap_burst_comb & (MASTER_ABURST == WRAP);
                     visual_asize_mst_next <= MASTER_ASIZE;
                     visual_alen_mst_next <= MASTER_ALEN;
                     visual_aid_mst_next <= MASTER_AID;
                     visual_SLAVE_ASIZE_next <= (fixed_flag_comb) ? MASTER_ASIZE : $clog2 (DATA_WIDTH_OUT / 8);
                     if (MASTER_ABURST == WRAP)
                     begin
                        visual_SLAVE_ABURST_next <= 2'b01;
                        visual_wrap_flag_next <= 1'b1;
                        visual_AChan_FSM_next <= SEND_TRANS;
                     end
                     else
                     begin
                        visual_SLAVE_ABURST_next <= MASTER_ABURST;
                        visual_wrap_flag_next <= 1'b0;
                        visual_AChan_FSM_next <= SEND_TRANS;
                     end
                  end
               end
               else
               begin
                  visual_SLAVE_AVALID_next <= 0;
                  visual_AChan_FSM_next <= WAIT_AVALID;
               end
            end
 
         default:
            begin
               visual_AChan_FSM_next <= WAIT_AVALID;
            end
      endcase
   end
 
   always  @(posedge ACLK or negedge sysReset)
   begin : AChan_FSM
 
      if (!sysReset)
      begin
         SLAVE_ABURST <= 2'b00;
         SLAVE_AADDR <= 0;
         SLAVE_AVALID <= 0;
         SLAVE_ALEN <= 0;
         addr_fifo <= 0;
         extend_tx <= 0;
         asize_mst <= 0;
         alen_mst <= 0;
         visual_AChan_FSM_current <= WAIT_AVALID;
      end
      else
      begin
         SLAVE_ALEN <= visual_SLAVE_ALEN_next;
         SLAVE_AVALID <= visual_SLAVE_AVALID_next;
         SLAVE_AADDR <= visual_SLAVE_AADDR_next;
         SLAVE_ABURST <= visual_SLAVE_ABURST_next;
         SLAVE_ASIZE <= visual_SLAVE_ASIZE_next;
         extend_tx <= visual_extend_tx_next;
         addr_fifo <= visual_addr_fifo_next;
         asize_mst <= visual_asize_mst_next;
         alen_mst <= visual_alen_mst_next;
         wrap_flag <= visual_wrap_flag_next;
         aid_mst <= visual_aid_mst_next;
         visual_AChan_FSM_current <= visual_AChan_FSM_next;
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
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
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :ctrl_sigs_reg
 
      if (!sysReset)
      begin
         to_boundary_master_reg <= 0;
         sizeDiff_reg <= 0;
         unaligned_wrap_burst <= 0;
         len_offset_reg <= 0;
         last_beat_wrap <= 0;
         mask_wrap_addr_reg <= 0;
         fixed_flag  <= 1'b0;
         alen_sec_wrap_reg <= 0;
         alen_wrap_reg <= 0;
      end
      else
      begin
         to_boundary_master_reg <= to_boundary_master;
         sizeDiff_reg <= sizeDiff;
         unaligned_wrap_burst <= unaligned_wrap_burst_comb;
         len_offset_reg <= len_offset;
         last_beat_wrap <= to_boundary_master - 1;
         mask_wrap_addr_reg <= mask_wrap_addr;
         fixed_flag <= fixed_flag_comb;
         alen_sec_wrap_reg <= (visual_alen_mst_next - to_boundary_master) >> sizeDiff;
         alen_wrap_reg <= ((to_boundary_master - 1) >>  sizeDiff);
      end
   end
 
 
 
   always  @(wait_avalid_state or to_boundary_master_pre or mask_wrap_addr_pre or sizeDiff_pre or unaligned_wrap_burst_comb_pre or MASTER_ALEN or len_offset_pre or wrap_tx_pre or fixed_flag_comb_pre or
             to_boundary_master_reg or mask_wrap_addr_reg or sizeDiff_reg or unaligned_wrap_burst or alen_mst or len_offset_reg or extend_tx or fixed_flag)
   begin   :comb
 
      if (wait_avalid_state)
      begin
         to_boundary_master <=  to_boundary_master_pre;
         mask_wrap_addr <= mask_wrap_addr_pre;
         sizeDiff <= sizeDiff_pre;
         unaligned_wrap_burst_comb <= unaligned_wrap_burst_comb_pre;
         MASTER_ALEN_int <= MASTER_ALEN;
         len_offset <= len_offset_pre;
         wrap_tx <= wrap_tx_pre;
         fixed_flag_comb <= fixed_flag_comb_pre;
      end
      else
      begin
         to_boundary_master <= to_boundary_master_reg;
         mask_wrap_addr <= mask_wrap_addr_reg;
         sizeDiff <=  sizeDiff_reg;
         unaligned_wrap_burst_comb <= unaligned_wrap_burst;
         MASTER_ALEN_int <= alen_mst;
         len_offset <= len_offset_reg;
         wrap_tx <= extend_tx;
         fixed_flag_comb <= fixed_flag;
      end
   end
 
   // use master address when MASTER_AVALID is asserted otherwise use the latched version
   assign addr_beat = MASTER_AADDR[MASTER_ASIZE+:4] & MASTER_ALEN;
 
   assign wr_en_cmd = SLAVE_AVALID & SLAVE_AREADY;
 
   assign mask = (DATA_WIDTH_OUT/8) - 1;
 
   assign alen_tot = (MASTER_ALEN_int + len_offset);
   //assign alen_wrap = ((to_boundary_master - 1) >>  sizeDiff);
   assign alen_wrap = wait_avalid_state ? alen_wrap_pre : alen_wrap_reg;
   //assign alen_sec_wrap = (MASTER_ALEN_int - to_boundary_master)  >>  sizeDiff;
   assign alen_sec_wrap = wait_avalid_state ? alen_sec_wrap_pre : alen_sec_wrap_reg;
   assign wrap_alen_out = (extend_tx ? alen_sec_wrap : alen_wrap );
   assign alen_int = (fixed_flag_comb) ? MASTER_ALEN_int : (alen_tot  >>  sizeDiff);
   // assign the number of beats left to reach the wrap boundary to alen_out for the first address phase of a wrap burst
   // assign 0 to alen_out for the second address phase of a wrap burst
   // assign the converted length (alen_int) to alen_out in case of INCR or FIXED
   assign alen_out = ((wrap_tx) ? wrap_alen_out : alen_int);
 
   assign addr_phase_accept = MASTER_AVALID & MASTER_AREADY;
 
   // force the slave to process transaction in order. It reduces the memory resources required in the converters  
   
   //assign SLAVE_AID = 0;
 
   generate 
     if(READ_INTERLEAVE)
	   begin 
	     always @(posedge ACLK or negedge sysReset)
           if (~sysReset)		 
		     SLAVE_AID_REG <= {ID_WIDTH{1'b0}};
		   else 
		     SLAVE_AID_REG <= visual_SLAVE_AID_next;
	    
		  assign SLAVE_AID = SLAVE_AID_REG;
	   end 
	 else 
	   begin 
         assign SLAVE_AID = 0;
	   end 
   endgenerate
   assign WRAP = 2'b10;
   assign FIXED = 2'b00;
 
 
endmodule

