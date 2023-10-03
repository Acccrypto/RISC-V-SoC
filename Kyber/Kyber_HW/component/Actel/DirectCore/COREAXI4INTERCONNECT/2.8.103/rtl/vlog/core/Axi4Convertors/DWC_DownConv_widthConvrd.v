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
 
 
module caxi4interconnect_DWC_DownConv_widthConvrd (
                                 //  input ports
                                 sysReset,
                                 ACLK,
                                 MASTER_RREADY,								 
                                 SLAVE_RDATA,
                                 SLAVE_RLAST,
                                 SLAVE_RVALID,
								 SLAVE_RID,
                                 SLAVE_RRESP,
                                 SLAVE_RUSER,
                                 rdCmdFifoReadData,
                                 rdCmdFifoEmpty,
                                 mask_mstSize,
                                 mask_slvSize,
                                 sizeCnt_comb_EQ_SizeMax,
                                 master_ADDR_masked,
                                 second_Beat_Addr,
                                 sizeCnt_comb_P1,
                                 slaveSize_one_hot,
                                 sizeMax_extend,
                                 shifted_slv_mask_bit,
                                 shifted_mst_mask_bit,
 
                                 //  output ports
                                 MASTER_RID,
                                 MASTER_RDATA,
                                 MASTER_RLAST,
                                 MASTER_RVALID,
                                 MASTER_RUSER,
                                 MASTER_RRESP,
                                 SLAVE_RREADY,
                                 rdCmdFifore,
                                 shifted_slv_mask_byte,
                                 shifted_mst_mask_byte,
								 master_hold
                                 );
 
   parameter        CMD_FIFO_DATA_WIDTH       = 30;
   parameter        USER_WIDTH                = 1;
   parameter        ID_WIDTH                  = 1;
   parameter        DATA_WIDTH_IN             = 32;
   parameter        DATA_WIDTH_OUT            = 32;
   parameter        READ_INTERLEAVE           = 1;
   
//  input ports
   input            sysReset;
   wire             sysReset;
   input            ACLK;
   wire             ACLK;
   input            MASTER_RREADY;
   wire             MASTER_RREADY;
   input     [DATA_WIDTH_IN - 1:0] SLAVE_RDATA;
   wire      [DATA_WIDTH_IN - 1:0] SLAVE_RDATA;
   input            SLAVE_RLAST;
   wire             SLAVE_RLAST;
   input            SLAVE_RVALID;
   wire             SLAVE_RVALID;
   input     [ID_WIDTH-1:0] SLAVE_RID;
   input     [1:0]  SLAVE_RRESP;
   wire      [1:0]  SLAVE_RRESP;
   input     [USER_WIDTH - 1:0] SLAVE_RUSER;
   wire      [USER_WIDTH - 1:0] SLAVE_RUSER;
   input     [CMD_FIFO_DATA_WIDTH - 1:0] rdCmdFifoReadData;
   wire      [CMD_FIFO_DATA_WIDTH - 1:0] rdCmdFifoReadData;
   input            rdCmdFifoEmpty;
   wire             rdCmdFifoEmpty;
   input     [5:0]  mask_mstSize;
   wire      [5:0]  mask_mstSize;
   input     [5:0]  mask_slvSize;
   wire      [5:0]  mask_slvSize;
   input            sizeCnt_comb_EQ_SizeMax;
   wire             sizeCnt_comb_EQ_SizeMax;
   input     [5:0]  master_ADDR_masked;
   wire      [5:0]  master_ADDR_masked;
   input     [5:0]  second_Beat_Addr;
   wire      [5:0]  second_Beat_Addr;
   input     [5:0]  sizeCnt_comb_P1;
   wire      [5:0]  sizeCnt_comb_P1;
   input     [6:0]  slaveSize_one_hot;
   wire      [6:0]  slaveSize_one_hot;
   input     [5:0]  sizeMax_extend;
   wire      [5:0]  sizeMax_extend;
   input     [DATA_WIDTH_IN - 1:0] shifted_slv_mask_bit;
   wire      [DATA_WIDTH_IN - 1:0] shifted_slv_mask_bit;
   input     [DATA_WIDTH_OUT - 1:0] shifted_mst_mask_bit;
   wire      [DATA_WIDTH_OUT - 1:0] shifted_mst_mask_bit;
   input                            master_hold;
//  output ports
   output    [ID_WIDTH - 1:0] MASTER_RID;
   reg       [ID_WIDTH - 1:0] MASTER_RID;
   output    [DATA_WIDTH_OUT - 1:0] MASTER_RDATA;
   reg       [DATA_WIDTH_OUT - 1:0] MASTER_RDATA;
   output           MASTER_RLAST;
   reg              MASTER_RLAST;
   output           MASTER_RVALID;
   reg              MASTER_RVALID;
   output    [USER_WIDTH - 1:0] MASTER_RUSER;
   reg       [USER_WIDTH - 1:0] MASTER_RUSER;
   output    [1:0]  MASTER_RRESP;
   reg       [1:0]  MASTER_RRESP;
   output           SLAVE_RREADY;
   wire             SLAVE_RREADY;
   output           rdCmdFifore;
   wire             rdCmdFifore;
   output    [(DATA_WIDTH_IN / 8) - 1:0] shifted_slv_mask_byte;
   wire      [(DATA_WIDTH_IN / 8) - 1:0] shifted_slv_mask_byte;
   output    [(DATA_WIDTH_OUT / 8) - 1:0] shifted_mst_mask_byte;
   wire      [(DATA_WIDTH_OUT / 8) - 1:0] shifted_mst_mask_byte;
//  local signals
   wire      [5:0]  int_masterADDR;
   wire             SameMstSlvSize;
   wire             lastTx;
   wire             master_accept;
   reg       [8:0]  cnt;
   reg       [5:0]  current_addr;
   reg       [5:0]  current_addr_reg;
   wire             slave_valid_data;
   wire      [5:0]  dataLoc;
   wire      [5:0]  dataLocMst;
   wire      [5:0]  dataLocSlv;
   reg       [DATA_WIDTH_OUT - 1:0] MASTER_RDATA_next;
   reg       [DATA_WIDTH_OUT - 1:0] FIXED_MASTER_RDATA_next;
   wire      [DATA_WIDTH_OUT - 1:0] MASTER_RDATA_masked;
   wire      [DATA_WIDTH_IN - 1:0] SLAVE_RDATA_masked;
   wire      [5:0]  addr_mux;
   wire      [ID_WIDTH - 1:0] int_masterRID;
   wire             fixed_flag;
   reg       [5:0]  sizeCnt;
   reg       [5:0]  fixed_burst_sizecnt;
   reg       [5:0]  sizeCnt_reg;
   reg              cnt_EQ_zero;
   wire      [5:0]  SizeMax;
   wire      [(DATA_WIDTH_IN / 8) - 1:0] unshifted_mask;     //  TC: this mask is based on a one-hot size (not encoded size)
   wire      [$clog2 (DATA_WIDTH_OUT / 8) - $clog2 (DATA_WIDTH_IN / 8) - 1:0] target_mst_data_part;
   wire      [(2**($clog2 (DATA_WIDTH_OUT / 8) - $clog2 (DATA_WIDTH_IN / 8)))-1:0] target_mst_data_onehot;
   wire      [$clog2 (DATA_WIDTH_IN) + $clog2 (DATA_WIDTH_OUT / 8) - $clog2 (DATA_WIDTH_IN / 8) - 1:0] slv_masked_rdata_shift;
   wire             master_hold_keep;
   wire      [1:0]  MASTER_RRESP_next;
   reg       [1:0]  SLAVE_RRESP_MAX;
   wire             higher_slave_rresp;
   wire             last_slave_beat;
   wire             fixed_burst;
   reg              slave_rddone;
   reg              fixed_burst_ctrl;
   reg              fixed_burst_ctrl_reg;
   reg              rdCmdFifoEmpty_reg;
   wire      [DATA_WIDTH_OUT - 1:0] mst_mask_bit;
   reg              fixed_burst_reg;
   reg [5:0]        sizeMax_extend_reg;
   reg              sizeMax_extend_chng;
   reg              fixed_lastTx_ctrl;
   
   genvar          i;

 
 
   always @( posedge ACLK or negedge sysReset )
   begin   :widthConvRead_ctrl
 
      if (!sysReset)
      begin
         MASTER_RVALID <= 0;
         MASTER_RLAST <= 0;
         MASTER_RDATA <= 0;
         MASTER_RUSER <= 0;
         MASTER_RID <= 0;
         MASTER_RRESP <= 0;
      end
      else
      begin
         if (master_hold_keep | master_hold)
         begin
         end
         else
         begin
            MASTER_RDATA <= MASTER_RDATA_next;
            MASTER_RUSER <= SLAVE_RUSER;
			if(~READ_INTERLEAVE)
			  begin 
                MASTER_RID <= int_masterRID;            
			  end 
            MASTER_RRESP <= MASTER_RRESP_next;
 
            // Setting defaults
            // VALID and LAST defaulted to 0, and asserted as required.
            MASTER_RVALID <= 0;
            MASTER_RLAST <= 0;
            if (rdCmdFifoEmpty)
            begin
            end
            else
            begin
               if (SLAVE_RVALID)
               begin
                  if (last_slave_beat)
                  begin
                     MASTER_RVALID <= 1;
					 if(READ_INTERLEAVE)
					   begin 
					     MASTER_RID    <= int_masterRID; 
					   end 
                     MASTER_RLAST  <= 1;
                  end
                  else
                  begin
                     if (SameMstSlvSize)
                     begin
                        MASTER_RVALID <= 1;
						if(READ_INTERLEAVE)
					      begin
						    MASTER_RID    <= int_masterRID; 
						  end 
                     end
                     else
                     begin
                        if (dataLoc == sizeMax_extend)
                        begin
                           MASTER_RVALID <= 1;
						   if(READ_INTERLEAVE)
					         begin
						       MASTER_RID    <= int_masterRID; 
							 end 
                        end
                     end
                  end
               end
            end
         end
      end
   end
 
 
 
   always  @(*)
   begin   :addr_ctrl
 
      if (slave_valid_data)
      begin
         if (cnt_EQ_zero & ~(fixed_burst_ctrl & fixed_burst))
         begin
            if (fixed_flag)
            begin
               if (SameMstSlvSize)
               begin
                  current_addr <= int_masterADDR;
               end
               else
               begin
                  if (sizeCnt_comb_EQ_SizeMax)
                  begin
                     current_addr <= master_ADDR_masked;
                  end
                  else
                  begin
                     current_addr <= second_Beat_Addr;
                  end
               end
            end
            else
            begin
               current_addr <= second_Beat_Addr;
            end
         end
         else
         begin
            if (fixed_flag | fixed_burst)
            begin
               if (SameMstSlvSize)
                 current_addr <= int_masterADDR;
               else if ((sizeCnt_reg == SizeMax) & ~fixed_burst)
                 current_addr <= master_ADDR_masked;
			   else if((fixed_burst_sizecnt == (SizeMax - sizeCnt_comb_P1)))
                 current_addr <= int_masterADDR;					   
               else
                 current_addr <= current_addr_reg + (slaveSize_one_hot);
            end
            else
              current_addr <= current_addr_reg + (slaveSize_one_hot);
         end
      end
      else
      begin
         current_addr <= current_addr_reg;
      end
   end
 
 
 
   always  @(*)
   begin   :sieCntCtrl
 
      if (slave_valid_data)
      begin
         if (fixed_flag)
         begin
            if (SameMstSlvSize)
            begin
               sizeCnt <= 'b0;
            end
            else
            begin
               if (cnt_EQ_zero & ~(fixed_burst_ctrl & fixed_burst))
               begin
                  if (SameMstSlvSize)
                  begin
                     sizeCnt <= 'b0;
                  end
                  else
                  begin
                     if (sizeCnt_comb_EQ_SizeMax)
                     begin
                        sizeCnt <= 'b0;
                     end
                     else
                     begin
                        sizeCnt <= sizeCnt_comb_P1;
                     end
                  end
               end
               else
               begin
                  if (SameMstSlvSize)
                  begin
                     sizeCnt <= 'b0;
                  end
                  else
                  begin
                     if (SizeMax == sizeCnt_reg)
                     begin
                        sizeCnt <= 'b0;
                     end
                     else
                     begin
                        sizeCnt <= sizeCnt_reg + 1;
                     end
                  end
               end
            end
         end
         else
         begin
            if (cnt_EQ_zero & ~(fixed_burst_ctrl & fixed_burst))
            begin
               if (SameMstSlvSize)
               begin
                  sizeCnt <= 'b0;
               end
               else
               begin
                  if (sizeCnt_comb_EQ_SizeMax)
                  begin
                     sizeCnt <= 'b0;
                  end
                  else
                  begin
                     sizeCnt <= sizeCnt_comb_P1;
                  end
               end
            end
            else
            begin
               if (SameMstSlvSize)
               begin
                  sizeCnt <= 'b0;
               end
               else
               begin
                  if (SizeMax == sizeCnt_reg)
                  begin
                     sizeCnt <= 'b0;
                  end
                  else
                  begin
                     sizeCnt <= sizeCnt_reg + 1;
                  end
               end
            end
         end
      end
      else
      begin
         sizeCnt <= sizeCnt_reg;
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :addrCtrl_reg
 
      if (!sysReset)
      begin
         current_addr_reg <= 0;
         sizeCnt_reg <= 0;
      end
      else
      begin
         current_addr_reg <= current_addr;
         sizeCnt_reg <= sizeCnt;
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :cnt_ctrl
 
      if (!sysReset)
      begin
         cnt <= 0;
         cnt_EQ_zero <= 1;
      end
      else
      begin
         if (slave_valid_data)
         begin
            if (SLAVE_RLAST)
            begin
               cnt <= 0;
               cnt_EQ_zero <= 1;
            end
            else
            begin
               cnt <= cnt + 1;
               cnt_EQ_zero <= 0;
            end
         end
      end
   end
 
 
 
   always
      @( posedge ACLK or negedge sysReset )
   begin   :rresp_ctrl
 
      if (!sysReset)
      begin
         SLAVE_RRESP_MAX <= 2'b00;
      end
      else
      begin
         if (rdCmdFifoEmpty)
         begin
            SLAVE_RRESP_MAX <= 2'b00;
         end
         else
         begin
            if (master_accept)
            begin
               if (SLAVE_RVALID)
               begin
                  SLAVE_RRESP_MAX <= SLAVE_RRESP;
               end
               else
               begin
                  SLAVE_RRESP_MAX <= 2'b00;
               end
            end
            else
            begin
               if (SLAVE_RVALID)
               begin
                  if (SLAVE_RRESP > SLAVE_RRESP_MAX)
                  begin
                     SLAVE_RRESP_MAX <= SLAVE_RRESP;
                  end
               end
            end
         end
      end
   end
 
 
   always @( posedge ACLK or negedge sysReset )
     if (!sysReset)
       slave_rddone <= 0;
	 else 
	   slave_rddone <= rdCmdFifore;
	   
   always @( posedge ACLK or negedge sysReset )
     if (!sysReset)
       fixed_burst_reg <= 1'b0;
	 else if(SLAVE_RVALID & last_slave_beat)
	   fixed_burst_reg <= 1'b0;
	 else if(fixed_burst)
	   fixed_burst_reg <= 1'b1;
	   
   always @( posedge ACLK or negedge sysReset )
     if (!sysReset)
       sizeMax_extend_reg <= 0;
	 else 
	   sizeMax_extend_reg <= sizeMax_extend;

   always @( posedge ACLK or negedge sysReset )
     if (!sysReset)
       sizeMax_extend_chng <= 1'b0;
	 else if((sizeMax_extend != sizeMax_extend_reg) | fixed_lastTx_ctrl)
	   sizeMax_extend_chng <= 1'b1;
	 else 
	   sizeMax_extend_chng <= 1'b0;
	 
   always@(posedge ACLK or negedge sysReset)
     if(~sysReset)
	   fixed_lastTx_ctrl <= 1'b0;
	 else if(lastTx)
	   fixed_lastTx_ctrl <= 1'b1;
	 else if(MASTER_RVALID & MASTER_RREADY & MASTER_RLAST)
	   fixed_lastTx_ctrl <= 1'b0;
	   
   always @(*)
     if(MASTER_RVALID & MASTER_RREADY & MASTER_RLAST & (~SLAVE_RVALID | SameMstSlvSize | sizeMax_extend_chng ))     
	   fixed_burst_ctrl = 1'b0;
	 else if(slave_rddone & fixed_burst_reg)
	   fixed_burst_ctrl = 1'b1;
	 else 
	   fixed_burst_ctrl = fixed_burst_ctrl_reg;

   always @( posedge ACLK or negedge sysReset )
     if (!sysReset)
       fixed_burst_ctrl_reg <= 1'b0;
	 else 
	   fixed_burst_ctrl_reg <= fixed_burst_ctrl;
 
   always @( posedge ACLK or negedge sysReset )
     if (!sysReset)
       rdCmdFifoEmpty_reg <= 1'b0;
	 else 
	   rdCmdFifoEmpty_reg <= rdCmdFifoEmpty;
 
   // Split up wrCmdFifoRdData
   //assign int_masterRID = READ_INTERLEAVE ? slave_valid_data ? SLAVE_RID : {ID_WIDTH{1'b0}}: rdCmdFifoReadData[30+ID_WIDTH-1:30];
   assign int_masterRID = READ_INTERLEAVE ? (slave_valid_data ? SLAVE_RID : {ID_WIDTH{1'b0}}) : SLAVE_RID ;
   assign fixed_flag = rdCmdFifoReadData[29];
   assign int_masterADDR = rdCmdFifoReadData[28:23];
   assign SameMstSlvSize = rdCmdFifoReadData[7];
   assign SizeMax = rdCmdFifoReadData[6:1]; // not used used for compering to dataLoc
   assign lastTx = rdCmdFifoReadData[0];
   assign fixed_burst = rdCmdFifoReadData[37+ID_WIDTH-1];
   
   assign rdCmdFifore = SLAVE_RREADY & SLAVE_RLAST & SLAVE_RVALID & ~master_hold;
 
   assign addr_mux = cnt_EQ_zero & ~(fixed_burst_ctrl & fixed_burst)  ? int_masterADDR : current_addr_reg;
 
   // Location of data on Master bus

   assign dataLocMst = ((DATA_WIDTH_OUT/8) - 1) & addr_mux & mask_slvSize;
 
   assign dataLoc = ( mask_mstSize & addr_mux );
 
   // Location of data on Slave bus
   assign dataLocSlv = ((DATA_WIDTH_IN/8) - 1) & addr_mux & mask_slvSize;
 
   assign master_accept = MASTER_RVALID & MASTER_RREADY;
   assign slave_valid_data = SLAVE_RREADY & SLAVE_RVALID & ~master_hold;
 
   assign unshifted_mask = (1 << slaveSize_one_hot) - 1;
 
   assign shifted_mst_mask_byte = unshifted_mask << dataLocMst;
   assign shifted_slv_mask_byte = unshifted_mask << dataLocSlv;
 
   assign SLAVE_RDATA_masked = SLAVE_RDATA & shifted_slv_mask_bit;
   assign MASTER_RDATA_masked = MASTER_RDATA & ~shifted_mst_mask_bit;
 
   assign target_mst_data_part = dataLocMst >> $clog2(DATA_WIDTH_IN/8);
   assign slv_masked_rdata_shift = target_mst_data_part << $clog2(DATA_WIDTH_IN); 
 
   always@(posedge ACLK or negedge sysReset)
     if(~sysReset)
	   FIXED_MASTER_RDATA_next <= 0;
	 else if((SameMstSlvSize & SLAVE_RVALID) | ((fixed_burst_sizecnt == (SizeMax - sizeCnt_comb_P1)) & slave_valid_data))
	   FIXED_MASTER_RDATA_next <= 0;
	 else if(fixed_burst & slave_valid_data)
	   FIXED_MASTER_RDATA_next <= (FIXED_MASTER_RDATA_next | ((SLAVE_RDATA_masked << slv_masked_rdata_shift) & mst_mask_bit));
 
   always@(*)
     begin 
       if(slave_valid_data)
	     begin 
	       if(fixed_burst)
	  	     MASTER_RDATA_next = (FIXED_MASTER_RDATA_next | ((SLAVE_RDATA_masked << slv_masked_rdata_shift) & mst_mask_bit));
	  	   else 
	  	     MASTER_RDATA_next = (MASTER_RDATA_masked | (SLAVE_RDATA_masked << slv_masked_rdata_shift));
	     end 
	   else 
	     MASTER_RDATA_next = MASTER_RDATA;
	 end 
 
   assign higher_slave_rresp = SLAVE_RVALID & (SLAVE_RRESP > SLAVE_RRESP_MAX);
   assign MASTER_RRESP_next = higher_slave_rresp ? SLAVE_RRESP : SLAVE_RRESP_MAX;
   // TC: highest response could just arrive so use combinatorial logic
 
   assign last_slave_beat = lastTx & SLAVE_RLAST;
   assign master_hold_keep = MASTER_RVALID & !MASTER_RREADY; // Hold and keep master values until this is cleared
   assign SLAVE_RREADY = !(rdCmdFifoEmpty | master_hold_keep );
 
   
   always@(posedge ACLK or negedge sysReset)
     begin :fixburst_sizecnt
	   if(~sysReset)
	     fixed_burst_sizecnt <= 0;
       else if((MASTER_RVALID & MASTER_RREADY & MASTER_RLAST & ~SLAVE_RVALID) | ((fixed_burst_sizecnt == (SizeMax - sizeCnt_comb_P1)) & slave_valid_data))	     
	     fixed_burst_sizecnt <= 0;
       else if (slave_valid_data & fixed_burst)
	     fixed_burst_sizecnt <= fixed_burst_sizecnt + 1'b1;
     end 

   assign target_mst_data_onehot = (1 << target_mst_data_part);
   generate
     for (i=0;i<(DATA_WIDTH_OUT/DATA_WIDTH_IN);i=i+1) begin
       assign mst_mask_bit[(DATA_WIDTH_IN*i)+:DATA_WIDTH_IN] = {DATA_WIDTH_IN{target_mst_data_onehot[i]}};
     end
   endgenerate

  
endmodule

