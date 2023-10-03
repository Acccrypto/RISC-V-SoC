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
 
 
module caxi4interconnect_DWC_brespCtrl (
                      //  input ports
                      ACLK,
                      sysReset,
                      MASTER_BREADY,
                      SLAVE_BUSER,
                      SLAVE_BRESP,
                      SLAVE_BVALID,
                      SLAVE_BID,
                      BRespFifoRdData,
                      bresp_fifo_empty,
 
                      //  output ports
                      brespFifore,
                      MASTER_BVALID,
                      MASTER_BID,
                      MASTER_BUSER,
                      MASTER_BRESP,
                      SLAVE_BREADY
                      );
 
   parameter        USER_WIDTH         = 1;
   parameter        ID_WIDTH           = 1;
//  input ports
   input            ACLK;
   wire             ACLK;
   input            sysReset;
   wire             sysReset;
   input            MASTER_BREADY;
   wire             MASTER_BREADY;
   input     [USER_WIDTH - 1:0] SLAVE_BUSER;
   wire      [USER_WIDTH - 1:0] SLAVE_BUSER;
   input     [1:0]  SLAVE_BRESP;
   wire      [1:0]  SLAVE_BRESP;
   input            SLAVE_BVALID;
   wire             SLAVE_BVALID;
   input     [ID_WIDTH-1:0] SLAVE_BID;
   input            BRespFifoRdData;
   wire             BRespFifoRdData;
   input            bresp_fifo_empty;
   wire             bresp_fifo_empty;
//  output ports
   output           brespFifore;
   wire             brespFifore;
   output           MASTER_BVALID;
   reg              MASTER_BVALID;
   output    [ID_WIDTH - 1:0] MASTER_BID;
   reg       [ID_WIDTH - 1:0] MASTER_BID;
   output    [USER_WIDTH - 1:0] MASTER_BUSER;
   reg       [USER_WIDTH - 1:0] MASTER_BUSER;
   output    [1:0]  MASTER_BRESP;
   reg       [1:0]  MASTER_BRESP;
   output           SLAVE_BREADY;
   reg              SLAVE_BREADY;
//  local signals
   reg              tx_in_progress;
   reg              MASTER_BVALID_next;
   reg              tx_in_progress_next;
   reg       [ID_WIDTH - 1:0] MASTER_BID_next;
   reg       [USER_WIDTH - 1:0] MASTER_BUSER_next;
   reg       [1:0]  MASTER_BRESP_next;
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :bchan_data_ctrl
 
      if (!sysReset)
      begin
         MASTER_BID <= 0;
         MASTER_BUSER <= 0;
         MASTER_BRESP <= 0;
         MASTER_BVALID <= 1'b0;
         tx_in_progress <= 1'b0;
      end
      else
      begin
         MASTER_BID <= MASTER_BID_next;
         MASTER_BUSER <= MASTER_BUSER_next;
         MASTER_BRESP <= MASTER_BRESP_next;
         MASTER_BVALID <= MASTER_BVALID_next;
         tx_in_progress <= tx_in_progress_next;
      end
   end
 
 
 
   always  @(MASTER_BID or MASTER_BUSER or MASTER_BRESP or MASTER_BVALID or tx_in_progress or MASTER_BREADY or bresp_fifo_empty or SLAVE_BVALID or BRespFifoRdData or SLAVE_BUSER or SLAVE_BRESP or SLAVE_BID)
   begin   :bchan_data_ctrl_next
 
      // default values
 
      MASTER_BID_next <= MASTER_BID;
      MASTER_BUSER_next <= MASTER_BUSER;
      MASTER_BRESP_next <= MASTER_BRESP;
      MASTER_BVALID_next <= MASTER_BVALID;
      tx_in_progress_next <= tx_in_progress;
      if (tx_in_progress)
      //  T
      begin
         if (MASTER_BVALID)
         begin
            if (MASTER_BREADY)
            begin
               if (bresp_fifo_empty)
               begin
                  // master accept write response and caxi4interconnect_FIFO is empty.
                  // MASTER_BRESP is zeroed. If we wouldn't do so,
                  //      we are not able to clear an error reponse
                  //      the next time around
                  // tx_in_progress is taken away because no write
                  //      response is awaiting processing
 
                  tx_in_progress_next <= 0;
                  MASTER_BRESP_next <= 2'b00;
                  SLAVE_BREADY <= 0;
                  MASTER_BVALID_next <= 0;
               end
               else
               begin
                  if (SLAVE_BVALID)
                  begin
                     // valid slave write response. Pass values across
 
                     SLAVE_BREADY <= 1;
                     MASTER_BVALID_next <= BRespFifoRdData;
                     tx_in_progress_next <= 1;
                     //MASTER_BID_next <= BRespFifoRdData[ID_WIDTH:1];
                     MASTER_BID_next <= SLAVE_BID;
                     MASTER_BUSER_next <= SLAVE_BUSER;
                     // master accepts write response and
                     //      slave puts down another one.
                     // We default MASTER_BRESP to SLAVE_BRESP
 
                     MASTER_BRESP_next <= SLAVE_BRESP;
                  end
                  else
                  begin
                     // master accept write response and slave
                     //      doesn't put down one.
                     // MASTER_BRESP is zeroed. If we wouldn't
                     //      do so, we are not able to clear
                     //      an error reponse the next time around
                     // tx_in_progress is taken away because
                     //      no write response is awaiting processing
 
                     SLAVE_BREADY <= 0;
                     MASTER_BVALID_next <= 0;
                     tx_in_progress_next <= 1'b0;
                     MASTER_BRESP_next <= 2'b00;
                  end
               end
            end
            else
            begin
               // waiting for MASTER_BREADY
 
               SLAVE_BREADY <= 0;
               MASTER_BVALID_next <= 1;
            end
         end
         else
         begin
            if (bresp_fifo_empty)
            begin
               SLAVE_BREADY <= 0;
               MASTER_BVALID_next <= 0;
            end
            else
            begin
               if (SLAVE_BVALID)
               begin
                  // valid slave write response. Pass values across
 
                  SLAVE_BREADY <= 1;
                  MASTER_BVALID_next <= BRespFifoRdData;
                  tx_in_progress_next <= 1;
                  //MASTER_BID_next <= BRespFifoRdData[ID_WIDTH:1];
                  MASTER_BID_next <= SLAVE_BID;
                  MASTER_BUSER_next <= SLAVE_BUSER;
                  if (MASTER_BRESP < SLAVE_BRESP)
                  begin
                     MASTER_BRESP_next <= SLAVE_BRESP;
                  end
               end
               else
               begin
                  SLAVE_BREADY <= 0;
                  MASTER_BVALID_next <= 0;
               end
            end
         end
      end
      else
      begin
         if (SLAVE_BVALID)
         begin
            // valid slave write response. Pass values across
 
            SLAVE_BREADY <= 1;
            MASTER_BVALID_next <= BRespFifoRdData;
            tx_in_progress_next <= 1;
            //MASTER_BID_next <= BRespFifoRdData[ID_WIDTH:1];
            MASTER_BID_next <= SLAVE_BID;
            MASTER_BUSER_next <= SLAVE_BUSER;
            if (MASTER_BRESP < SLAVE_BRESP)
            begin
               MASTER_BRESP_next <= SLAVE_BRESP;
            end
         end
         else
         begin
            SLAVE_BREADY <= 0;
            MASTER_BVALID_next <= 0;
         end
      end
   end
 
   assign brespFifore = SLAVE_BREADY & SLAVE_BVALID;
 
 
endmodule

