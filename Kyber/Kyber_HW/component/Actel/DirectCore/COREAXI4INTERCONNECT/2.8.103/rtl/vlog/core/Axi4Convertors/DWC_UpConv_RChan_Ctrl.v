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
 
 
module caxi4interconnect_DWC_UpConv_RChan_Ctrl (
                              //  input ports
                              MASTER_RREADY,
                              MASTER_RLEN,
                              MASTER_RSIZE,
                              ACLK,
                              sysReset,
                              data_empty,
                              SLAVE_RLAST,
                              SLAVE_RVALID,
                              addr,
                              arid,
                              space_in_data_fifo,
                              //space_in_rresp_fifo,
                              fixed_flag,
                              wrap_flag,
                              to_wrap_boundary,
                              MASTER_RLEN_eq_0,
                              mask_pre,
                              rd_src_shift_pre,
                              rd_src_top,
 
                              //  output ports
                              MASTER_RLAST,
                              MASTER_RVALID,
                              rd_src,
                              rd_en_data,
                              data_hold,
                              SLAVE_RREADY,
                              rd_en_cmd,
                              MASTER_RID
                              );
 
   parameter        DATA_WIDTH_IN         = 512;
   parameter        DATA_WIDTH_OUT        = 32;
   parameter        ID_WIDTH              = 1;
//  input ports
   input            MASTER_RREADY;
   wire             MASTER_RREADY;
   input     [7:0]  MASTER_RLEN;
   wire      [7:0]  MASTER_RLEN;
   input     [2:0]  MASTER_RSIZE;
   wire      [2:0]  MASTER_RSIZE;
   input            ACLK;
   wire             ACLK;
   input            sysReset;
   wire             sysReset;
   input            data_empty;
   wire             data_empty;
   input            SLAVE_RLAST;
   wire             SLAVE_RLAST;
   input            SLAVE_RVALID;
   wire             SLAVE_RVALID;
   input     [9:0]  addr;
   wire      [9:0]  addr;
   input     [ID_WIDTH - 1:0] arid;
   wire      [ID_WIDTH - 1:0] arid;
   input            space_in_data_fifo;
   wire             space_in_data_fifo;
   //input            space_in_rresp_fifo;
   //wire             space_in_rresp_fifo;
   input            fixed_flag;
   wire             fixed_flag;
   input            wrap_flag;
   wire             wrap_flag;
   input     [4:0]  to_wrap_boundary;
   wire      [4:0]  to_wrap_boundary;
   input            MASTER_RLEN_eq_0;
   wire             MASTER_RLEN_eq_0;
   input     [9:0]  mask_pre;
   wire      [9:0]  mask_pre;
   input     [9:0]  rd_src_shift_pre;
   wire      [9:0]  rd_src_shift_pre;
   input     [5:0]  rd_src_top;
   wire      [5:0]  rd_src_top;
//  output ports
   output           MASTER_RLAST;
   reg              MASTER_RLAST;
   output           MASTER_RVALID;
   wire             MASTER_RVALID;
   output    [$clog2 (DATA_WIDTH_IN / DATA_WIDTH_OUT) - 1:0] rd_src;
   wire      [$clog2 (DATA_WIDTH_IN / DATA_WIDTH_OUT) - 1:0] rd_src;
   output           rd_en_data;
   wire             rd_en_data;
   output           data_hold;
   wire             data_hold;
   output           SLAVE_RREADY;
   reg              SLAVE_RREADY;
   output           rd_en_cmd;
   reg              rd_en_cmd;
   output    [ID_WIDTH - 1:0] MASTER_RID;
   reg       [ID_WIDTH - 1:0] MASTER_RID;
//  local signals
   wire             last_next;
   reg       [8:0]  master_beat_cnt;
   wire             data_out_valid;
   wire             pass_data;
   reg              hold_data_valid;
   wire             incr_rd_src;
   wire             master_accept;
   reg       [9:0]  rd_src_cnt;
   wire             zero_src;
   wire      [5:0]  rd_src_full;
   wire      [5:0]  rd_src_data;
   wire      [9:0]  inc_value;
   reg              fixed_flag_comb;
   reg              fixed_flag_reg;
   wire             wrap_reach_boundary;
   wire             rd_msb;
   wire             end_cycle;
   wire             wrap_point;
   wire      [9:0]  mask_wrap_addr;
   wire             set_master_rlast;
   wire             data_fifo_rd_ok;
   reg              extend_wrap_tx;
   wire             set_extend;
   wire             mux_top;
   reg       [9:0]  mask_wrap_addr_reg;
   wire      [9:0]  log_wrap_len;
   wire      [9:0]  shift_wrap_mask;
   reg       [8:0]  next_master_beat_cnt;
   wire             clear_extend;
   reg       [8:0]  master_beat_cnt_plus_1;
 
 
   always @( posedge ACLK or negedge sysReset )
   begin   :clk_rst_ctrl
 
      if (!sysReset)
      begin
         SLAVE_RREADY <= 0;
      end
      else
      begin
         SLAVE_RREADY <= (space_in_data_fifo);
                           //& space_in_rresp_fifo); Removed response fifo so no use of this signal. 
      end
   end
 
 
 
   always @( posedge ACLK or negedge sysReset )
   begin   :clk_reg_RD_SYS
 
      if (!sysReset)
      begin
         hold_data_valid <= 0;
         MASTER_RID <= 0;
      end
      else
      begin
         if (pass_data)
         begin
            hold_data_valid <= data_out_valid;
            MASTER_RID <= arid;
         end
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :mst_beat_cnt_ctrl
 
      if (!sysReset)
      begin
         master_beat_cnt <= 0;
         master_beat_cnt_plus_1 <= 1;
      end
      else
      begin
         master_beat_cnt <= next_master_beat_cnt;
         master_beat_cnt_plus_1 <= next_master_beat_cnt + 1;
      end
   end
 
 
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :src_ctrl
 
      if (!sysReset)
      begin
         rd_src_cnt <= 0;
      end
      else
      begin
         if (zero_src)
         begin
            rd_src_cnt <= 0;
         end
         else
         begin
            if (incr_rd_src)
            begin
               rd_src_cnt <=
               rd_src_cnt + inc_value;
            end
         end
      end
   end
 
 
 
   always  @(MASTER_RLAST or master_accept or last_next or data_out_valid)
   begin   :rlast_next_gen
 
      if (MASTER_RLAST)
      begin
         if (master_accept)
         begin
            if (last_next)
            begin
               if (data_out_valid)
               begin
                  rd_en_cmd <= 1'b1;
               end
               else
               begin
                  rd_en_cmd <= 1'b0;
               end
            end
            else
            begin
               rd_en_cmd <= 1'b0;
            end
         end
         else
         begin
            rd_en_cmd <= 1'b0;
         end
      end
      else
      begin
         if (last_next)
         begin
            if (data_out_valid)
            begin
               rd_en_cmd <= 1'b1;
            end
            else
            begin
               rd_en_cmd <= 1'b0;
            end
         end
         else
         begin
            rd_en_cmd <= 1'b0;
         end
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :Start12
 
      if (!sysReset)
      begin
         MASTER_RLAST <= 1'b0;
      end
      else
      begin
         if (set_master_rlast)
         begin
            MASTER_RLAST <= 1'b1;
         end
         else
         begin
            if (end_cycle)
            begin
               MASTER_RLAST <= 1'b0;
            end
         end
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :extend_flag_tx
 
      if (!sysReset)
      begin
         extend_wrap_tx <= 1'b0;
      end
      else
      begin
         if (set_extend)
         begin
            extend_wrap_tx <= 1'b1;
         end
         else
         begin
            if (clear_extend)
            begin
               extend_wrap_tx <= 1'b0;
            end
         end
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :mask_wrap_reg
 
      if (!sysReset)
      begin
         mask_wrap_addr_reg <= 'b0;
      end
      else
      begin
         mask_wrap_addr_reg <= mask_wrap_addr >> MASTER_RSIZE;
      end
   end
 
 
 
   always  @(master_accept or MASTER_RLAST or master_beat_cnt_plus_1 or master_beat_cnt)
   begin   :master_beat_cnt_comb
 
      if (master_accept)  //MASTER_RVALID & MASTER_RREADY
      begin
         if (MASTER_RLAST)
         begin
            next_master_beat_cnt <= 0;
         end
         else
         begin
            next_master_beat_cnt <=
            master_beat_cnt_plus_1;
         end
      end
      else
      begin
         next_master_beat_cnt <= master_beat_cnt;
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :Start8
 
      if (!sysReset)
      begin
         fixed_flag_reg <= 1'b0;
      end
      else
      begin
         fixed_flag_reg <= fixed_flag_comb;
      end
   end
 
 
 
   always  @(MASTER_RLAST or fixed_flag_reg or fixed_flag)
   begin   :Start9
 
      if (MASTER_RLAST)
      begin
         fixed_flag_comb <= fixed_flag_reg;
      end
      else
      begin
         fixed_flag_comb <= fixed_flag;
      end
   end
 
   assign last_next = (~end_cycle & ((master_accept ? master_beat_cnt_plus_1 : master_beat_cnt) == MASTER_RLEN)) | (MASTER_RLEN_eq_0);
 
 
   assign master_accept = MASTER_RVALID & MASTER_RREADY;
   assign pass_data = master_accept | (~hold_data_valid);
   assign incr_rd_src = data_out_valid & pass_data & ~fixed_flag;
   assign data_out_valid = ~data_empty;
   assign data_hold = ~pass_data;
   assign MASTER_RVALID = hold_data_valid;
   assign zero_src = rd_en_cmd | set_extend;
 
   // Calculations for rd_en and rd_src
   //assign mask = ((1 << size_in) - 1) >> MASTER_RSIZE; // mask for read source
   //assign size_in = $clog2(DATA_WIDTH_IN/8);   // Data width as quotient
   //assign size_out = MASTER_RSIZE; 	       // just master size
 
   //assign size_diff = (size_in - size_out);   // difference in sizes
   //assign rd_src_top = (1 << size_diff) - 1;    // top of rd_src (max value)
 
   //assign addr_extend = {4'b0000, addr};
   //assign addr_extend = {4'b0000, addr}  >> MASTER_RSIZE ;
 
 
   assign rd_src_full = mask_pre & (((extend_wrap_tx && !end_cycle) ? (addr & mask_wrap_addr_reg) : addr) + rd_src_cnt); // full rd_src value before shift
 
   // rd_src to enter mux at register stage
   assign rd_src = rd_src_full >> rd_src_shift_pre;
 
   assign rd_src_data = rd_src_full;
 
   assign rd_en_data = data_fifo_rd_ok & ( fixed_flag | last_next | mux_top | wrap_point);
   assign data_fifo_rd_ok = data_out_valid & pass_data;
 
   assign wrap_point = wrap_flag & wrap_reach_boundary;
   assign wrap_reach_boundary = (master_accept | (~hold_data_valid)) & (next_master_beat_cnt == to_wrap_boundary);
 
 
   assign log_wrap_len = (MASTER_RLEN == 8'h0f) ? (10'b100) : ((MASTER_RLEN == 8'h07) ? (10'b011) : ((MASTER_RLEN == 8'h03) ? (10'b010) : 10'b01));
 
   assign mask_wrap_addr = (10'h3ff << shift_wrap_mask);
   assign shift_wrap_mask = (log_wrap_len + MASTER_RSIZE);
 
   assign set_master_rlast = last_next & data_out_valid & pass_data;
 
   assign inc_value = 1; // increment value for rd_src_cnt to ensure it inceases by the correct amount
 
   assign mux_top = rd_msb;
   assign rd_msb = (rd_src_data == rd_src_top);
   assign end_cycle = MASTER_RLAST & master_accept;
 
   assign set_extend = wrap_point & data_fifo_rd_ok;
   assign clear_extend = data_out_valid & last_next;
 
 
endmodule

