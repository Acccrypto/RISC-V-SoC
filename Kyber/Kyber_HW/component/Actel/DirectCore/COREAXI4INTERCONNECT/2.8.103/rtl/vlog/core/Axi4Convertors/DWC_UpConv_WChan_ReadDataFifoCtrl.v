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
 
module caxi4interconnect_DWC_UpConv_WChan_ReadDataFifoCtrl (
                                          //  input ports
                                          SLAVE_WREADY,
                                          SLAVE_WLEN,
                                          ACLK,
                                          MASTER_WVALID,
                                          MASTER_WLAST,
                                          sysReset,
                                          fifo_nearly_empty,
                                          fifo_empty,
                                          incr_pkt_cnt,
                                          data_fifo_nearly_full,
                                          cmd_fifo_empty,
                                          extend_tx,
                                          wrap_flag_mst,
                                          to_boundary,
                                          size,
 
                                          //  output ports
                                          SLAVE_WLAST,
                                          SLAVE_WVALID,
                                          MASTER_WREADY,
                                          master_beat_cnt,
                                          pass_data,
                                          rd_en_data,
                                          rd_en_cmd_slv,
                                          rd_en_cmd_mst,
                                          master_beat_cnt_eq_0,
                                          master_beat_cnt_shifted,
                                          master_beat_cnt_to_boundary_shifted
                                          );
 
   parameter        SIZE_OUT                              = 2;
   parameter        LOG_OPEN_TX                           = 3;
//  input ports
   input            SLAVE_WREADY;
   wire             SLAVE_WREADY;
   input     [7:0]  SLAVE_WLEN;
   wire      [7:0]  SLAVE_WLEN;
   input            ACLK;
   wire             ACLK;
   input            MASTER_WVALID;
   wire             MASTER_WVALID;
   input            MASTER_WLAST;
   wire             MASTER_WLAST;
   input            sysReset;
   wire             sysReset;
   input            fifo_nearly_empty;
   wire             fifo_nearly_empty;
   input            fifo_empty;
   wire             fifo_empty;
   input            incr_pkt_cnt;
   wire             incr_pkt_cnt;
   input            data_fifo_nearly_full;
   wire             data_fifo_nearly_full;
   input            cmd_fifo_empty;
   wire             cmd_fifo_empty;
   input            extend_tx;
   wire             extend_tx;
   input            wrap_flag_mst;
   wire             wrap_flag_mst;
   input     [4:0]  to_boundary;
   wire      [4:0]  to_boundary;
   input     [2:0]  size;
   wire      [2:0]  size;
//  output ports
   output           SLAVE_WLAST;
   reg              SLAVE_WLAST;
   output           SLAVE_WVALID;
   reg              SLAVE_WVALID;
   output           MASTER_WREADY;
   wire             MASTER_WREADY;
   output    [7:0]  master_beat_cnt;
   reg       [7:0]  master_beat_cnt;
   output           pass_data;
   wire             pass_data;
   output           rd_en_data;
   wire             rd_en_data;
   output           rd_en_cmd_slv;
   wire             rd_en_cmd_slv;
   output           rd_en_cmd_mst;
   wire             rd_en_cmd_mst;
   output           master_beat_cnt_eq_0;
   reg              master_beat_cnt_eq_0;
   output    [11:0] master_beat_cnt_shifted;
   reg       [11:0] master_beat_cnt_shifted;
   output    [11:0] master_beat_cnt_to_boundary_shifted;
   reg       [11:0] master_beat_cnt_to_boundary_shifted;
//  local signals
   reg              decr_pkt_cnt;
   wire      [8:0]  actual_wlen;
   wire             last_next;
   reg       [LOG_OPEN_TX:0] pkt_cnt;
   reg       [7:0]  slave_beat_cnt;
   reg              hold_data_valid;
   wire             data_out_valid;
   wire             slave_accept;
   wire             extend_wrap;
   wire             end_first_wrap_pkt;
 
   parameter IDLE      = 1'b0,
             SEND_DATA = 1'b1;
 
 
   reg [0:0] visual_SEND_DATA_SM_current, visual_SEND_DATA_SM_next;
 
   reg              visual_SLAVE_WLAST_next;
   reg              visual_SLAVE_WVALID_next;
   reg       [7:0]  visual_slave_beat_cnt_next;
 
 
   // Combinational process
   always  @(slave_beat_cnt or SLAVE_WLAST or SLAVE_WVALID or pkt_cnt or fifo_empty or last_next or fifo_nearly_empty or SLAVE_WREADY or visual_SEND_DATA_SM_current)
   begin : SEND_DATA_SM_comb
      decr_pkt_cnt <= 0;
      visual_slave_beat_cnt_next <= slave_beat_cnt;
      visual_SLAVE_WLAST_next <= SLAVE_WLAST;
      visual_SLAVE_WVALID_next <= SLAVE_WVALID;
 
 
 
      case (visual_SEND_DATA_SM_current)
         IDLE:
            begin
               if (pkt_cnt > 0)
               begin
                  if (fifo_empty)
                  begin
                     visual_SLAVE_WLAST_next <= 0;
                     visual_SLAVE_WVALID_next <= 0;
                     visual_SEND_DATA_SM_next <= IDLE;
                  end
                  else
                  begin
                     visual_SLAVE_WVALID_next <= 1;
                     if (last_next)
                     begin
                        visual_SLAVE_WLAST_next <= 1;
                        decr_pkt_cnt <= 1;
                        visual_slave_beat_cnt_next <= 0;
                        visual_SEND_DATA_SM_next <= SEND_DATA;
                     end
                     else
                     begin
                        visual_slave_beat_cnt_next <= slave_beat_cnt + 1;
                        visual_SLAVE_WLAST_next <= 0;
                        visual_SEND_DATA_SM_next <= SEND_DATA;
                     end
                  end
               end
               //  No point in proceesing yet,
               //  as the amount of data in the
               //  caxi4interconnect_FIFO is too low
               else if (fifo_nearly_empty)
               begin
                  visual_SLAVE_WLAST_next <= 0;
                  visual_SLAVE_WVALID_next <= 0;
                  visual_SEND_DATA_SM_next <= IDLE;
               end
               else
               begin
                  visual_SLAVE_WVALID_next <= 1;
                  if (last_next)
                  begin
                     visual_SLAVE_WLAST_next <= 1;
                     decr_pkt_cnt <= 1;
                     visual_slave_beat_cnt_next <= 0;
                     visual_SEND_DATA_SM_next <= SEND_DATA;
                  end
                  else
                  begin
                     visual_slave_beat_cnt_next <= slave_beat_cnt + 1;
                     visual_SLAVE_WLAST_next <= 0;
                     visual_SEND_DATA_SM_next <= SEND_DATA;
                  end
               end
            end
 
         SEND_DATA:
            begin
               if (SLAVE_WREADY)
               begin
                  if (fifo_empty)
                  begin
                     if (pkt_cnt > 0)
                     begin
                        if (fifo_empty)
                        begin
                           visual_SLAVE_WLAST_next <= 0;
                           visual_SLAVE_WVALID_next <= 0;
                           visual_SEND_DATA_SM_next <= IDLE;
                        end
                        else
                        begin
                           visual_SLAVE_WVALID_next <= 1;
                           if (last_next)
                           begin
                              visual_SLAVE_WLAST_next <= 1;
                              decr_pkt_cnt <= 1;
                              visual_slave_beat_cnt_next <= 0;
                              visual_SEND_DATA_SM_next <= SEND_DATA;
                           end
                           else
                           begin
                              visual_slave_beat_cnt_next <= slave_beat_cnt + 1;
                              visual_SLAVE_WLAST_next <= 0;
                              visual_SEND_DATA_SM_next <= SEND_DATA;
                           end
                        end
                     end
                     else if (fifo_nearly_empty)
                     begin
                        visual_SLAVE_WLAST_next <= 0;
                        visual_SLAVE_WVALID_next <= 0;
                        visual_SEND_DATA_SM_next <= IDLE;
                     end
                     else
                     begin
                        visual_SLAVE_WVALID_next <= 1;
                        if (last_next)
                        begin
                           visual_SLAVE_WLAST_next <= 1;
                           decr_pkt_cnt <= 1;
                           visual_slave_beat_cnt_next <= 0;
                           visual_SEND_DATA_SM_next <= SEND_DATA;
                        end
                        else
                        begin
                           visual_slave_beat_cnt_next <= slave_beat_cnt + 1;
                           visual_SLAVE_WLAST_next <= 0;
                           visual_SEND_DATA_SM_next <= SEND_DATA;
                        end
                     end
                  end
                  else if (SLAVE_WLAST)
                  begin
                     if (pkt_cnt > 0)
                     begin
                        if (fifo_empty)
                        begin
                           visual_SLAVE_WLAST_next <= 0;
                           visual_SLAVE_WVALID_next <= 0;
                           visual_SEND_DATA_SM_next <= IDLE;
                        end
                        else
                        begin
                           visual_SLAVE_WVALID_next <= 1;
                           if (last_next)
                           begin
                              visual_SLAVE_WLAST_next <= 1;
                              decr_pkt_cnt <= 1;
                              visual_slave_beat_cnt_next <= 0;
                              visual_SEND_DATA_SM_next <= SEND_DATA;
                           end
                           else
                           begin
                              visual_slave_beat_cnt_next <= slave_beat_cnt + 1;
                              visual_SLAVE_WLAST_next <= 0;
                              visual_SEND_DATA_SM_next <= SEND_DATA;
                           end
                        end
                     end
                     else if (fifo_nearly_empty)
                     begin
                        visual_SLAVE_WLAST_next <= 0;
                        visual_SLAVE_WVALID_next <= 0;
                        visual_SEND_DATA_SM_next <= IDLE;
                     end
                     else
                     begin
                        visual_SLAVE_WVALID_next <= 1;
                        if (last_next)
                        begin
                           visual_SLAVE_WLAST_next <= 1;
                           decr_pkt_cnt <= 1;
                           visual_slave_beat_cnt_next <= 0;
                           visual_SEND_DATA_SM_next <= SEND_DATA;
                        end
                        else
                        begin
                           visual_slave_beat_cnt_next <= slave_beat_cnt + 1;
                           visual_SLAVE_WLAST_next <= 0;
                           visual_SEND_DATA_SM_next <= SEND_DATA;
                        end
                     end
                  end
                  else if (last_next)
                  begin
                     visual_SLAVE_WLAST_next <= 1;
                     decr_pkt_cnt <= 1;
                     visual_slave_beat_cnt_next <= 0;
                     visual_SEND_DATA_SM_next <= SEND_DATA;
                  end
                  else
                  begin
                     visual_slave_beat_cnt_next <= slave_beat_cnt + 1;
                     visual_SLAVE_WLAST_next <= 0;
                     visual_SEND_DATA_SM_next <= SEND_DATA;
                  end
               end
               else
               begin
                  visual_SEND_DATA_SM_next <= SEND_DATA;
               end
            end
 
         default:
            begin
               visual_SEND_DATA_SM_next <= IDLE;
            end
      endcase
   end
 
   always  @(posedge ACLK or negedge sysReset)
   begin : SEND_DATA_SM
 
      if (!sysReset)
      begin
         SLAVE_WVALID <= 0;
         SLAVE_WLAST <= 0;
         slave_beat_cnt <= 0;
         visual_SEND_DATA_SM_current <= IDLE;
      end
      else
      begin
         SLAVE_WLAST <= visual_SLAVE_WLAST_next;
         SLAVE_WVALID <= visual_SLAVE_WVALID_next;
         slave_beat_cnt <= visual_slave_beat_cnt_next;
         visual_SEND_DATA_SM_current <= visual_SEND_DATA_SM_next;
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :mstr_beat_cnt_ctrl
 
      if (!sysReset)
      begin
         master_beat_cnt <= 0;
         master_beat_cnt_eq_0 <= 1;
         master_beat_cnt_shifted <= 0;
         master_beat_cnt_to_boundary_shifted <= 0;
      end
      else
      begin
         if (MASTER_WREADY)
         begin
            if (MASTER_WVALID)
            begin
               if (MASTER_WLAST)
               begin
                  master_beat_cnt <= 0;
                  master_beat_cnt_eq_0 <= 1;
                  master_beat_cnt_shifted <= 0;
                  master_beat_cnt_to_boundary_shifted <= 0;
               end
               else
               begin
                  master_beat_cnt <= master_beat_cnt + 1;
                  master_beat_cnt_eq_0 <= ((master_beat_cnt + 1) == 0);
                  master_beat_cnt_to_boundary_shifted <= (((master_beat_cnt + 1) - (to_boundary + 1)) << size);
                  master_beat_cnt_shifted <= (((master_beat_cnt + 1)) << size);
               end
            end
         end
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :pkts_in_wfifo_cnt
 
      if (!sysReset)
      begin
         pkt_cnt <= 0;
      end
      else
      begin
         if (incr_pkt_cnt)
         begin
            if (decr_pkt_cnt)
            begin
            end
            else
            begin
               pkt_cnt <= pkt_cnt + 1;
            end
         end
         else
         begin
            if (decr_pkt_cnt == 1)
            begin
               pkt_cnt <= pkt_cnt - 1;
            end
         end
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :hold_data_valid_ctrl
 
      if (!sysReset)
      begin
         hold_data_valid <= 0;
      end
      else
      begin
         if (pass_data)
         begin
            hold_data_valid <=
            data_out_valid;
         end
      end
   end
 
   assign last_next = (slave_beat_cnt == SLAVE_WLEN);
 
   //assign last_next = ((slave_beat_cnt + 1) == actual_wlen);
   //assign actual_wlen = SLAVE_WLEN + 1;
 
   assign slave_accept =  SLAVE_WREADY & SLAVE_WVALID;
 
   assign pass_data = (slave_accept | ~hold_data_valid);
 
   assign rd_en_data = data_out_valid & pass_data;
   assign rd_en_cmd_slv = decr_pkt_cnt;
   assign data_out_valid = ~fifo_empty;
   assign extend_wrap = (wrap_flag_mst & extend_tx);
   assign end_first_wrap_pkt = (master_beat_cnt == {3'b000, to_boundary});
   assign rd_en_cmd_mst = MASTER_WVALID & MASTER_WREADY & (extend_wrap ? end_first_wrap_pkt : MASTER_WLAST);
 
   assign MASTER_WREADY = !data_fifo_nearly_full & (~cmd_fifo_empty); // Space for 2 or more in data caxi4interconnect_FIFO & cmd available
 
 
endmodule

