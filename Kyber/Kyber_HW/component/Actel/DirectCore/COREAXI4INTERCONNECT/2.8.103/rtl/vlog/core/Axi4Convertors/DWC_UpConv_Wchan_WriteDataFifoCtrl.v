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
//      Abstract : As incoming data may have a transfer size smaller the the
//                 input data width, we must first clock incoming data " data_in" into
//                 a holding register "data_out" using write strobes "wr_data". The holding
//                 register is the same width as the incoming data bus, so "data_in" and
//                 "data_out" are both the same, e.g. 32-bit.
//               
//                 It clocks data from there to a command caxi4interconnect_FIFO external to this block using
//                 "wr_en" when the holding register is full of valid data or the transaction
//                 terminates as long as the caxi4interconnect_FIFO has space. Because the caxi4interconnect_FIFO is the width of
//                 th efinal slave output data bus, "DATA_WIDTH_OUT", the output of this block
//                 "data_out" is replicated several times, e.g. 16 times for a 32 to 512 bit
//                 caxi4interconnect_UpConverter. Only one of the "wr_en" signals is pulsed during burst for
//                 normal writes.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 



module caxi4interconnect_DWC_UpConv_Wchan_WriteDataFifoCtrl #

	(
		parameter integer	DATA_WIDTH_IN	  = 32,
		parameter integer	USER_WIDTH      = 1,
		parameter integer	DATA_WIDTH_OUT	= 32,
		parameter           ID_WIDTH        = 2
	)
	(
		input wire ACLK,
		input wire sysReset,

		input wire        data_fifo_nearly_full,
		input wire        cmd_fifo_empty,
		input wire        wready,
		input wire        wvalid,
		input wire [7:0] beat_cnt,
		input wire        wlast,
		input wire [5:0]  addr,
		input wire [2:0]  size,
		input wire [(ID_WIDTH+USER_WIDTH+(DATA_WIDTH_IN/8)+DATA_WIDTH_IN)-1:0]   data_in,
		input wire [5:0]  size_shifted,
        input wire [11:0]  master_beat_cnt_shifted,
        input wire [11:0]  master_beat_cnt_to_boundary_shifted,

		output wire [(ID_WIDTH+USER_WIDTH+(DATA_WIDTH_IN/8)+DATA_WIDTH_IN)-1:0]  data_out,		
		output wire [(DATA_WIDTH_OUT/DATA_WIDTH_IN)-1:0]            zero_strb_data,
		output reg  [(DATA_WIDTH_OUT/DATA_WIDTH_IN)-1:0]            wr_en,
		output reg        incr_pkt_cnt,
		input wire        wrap_flag,
		input wire        extend_tx,
		input wire [7:0]  wlen_mst,
		input wire        fixed_flag,
		input wire [4:0]  to_boundary,
		input wire        master_beat_cnt_eq_0,
    
    
    input wire [5:0]    mask_addr,
    input wire          aligned_wrap,
    input wire          second_wrap_burst,
    input wire          extend_wrap
	);

	localparam WIDTH_IN_BYTES    = DATA_WIDTH_IN/8;
	localparam WIDTH_IN_ENCODED  = $clog2(WIDTH_IN_BYTES);
	localparam WIDTH_OUT_BYTES   = DATA_WIDTH_OUT/8;
	localparam WIDTH_OUT_ENCODED = $clog2(WIDTH_OUT_BYTES);

  
  reg [USER_WIDTH-1:0]                      user_data_out;
  reg [DATA_WIDTH_IN+DATA_WIDTH_IN/8-1:0]   ds_data_out;
  reg [ID_WIDTH-1:0]                        wid_data_out;
  
	genvar i,j;
	wire [5:0]    beat_offset;
	wire [5:0]    addr_offset;
	reg  [WIDTH_OUT_ENCODED-WIDTH_IN_ENCODED-1:0] addr_offset_reg;
	wire [WIDTH_OUT_ENCODED-WIDTH_IN_ENCODED-1:0] addr_offset_comb;
	wire [5:0]    offset;
	reg  [5:0]    offset_latched;
	// wire [5:0]    mask_addr;
  // wire [5:0]    mask_addr_msb;
  // wire [6:0]    size_one_hot;
	wire          end_cycle;
	wire          end_cycle_comb;
	reg           end_cycle_reg;
	wire          accept_data;
	wire          incr_pkt_cnt_next;
	wire [(DATA_WIDTH_OUT/DATA_WIDTH_IN)-1:0] wr_en_words;  
	wire          write_top_hold_reg;
	wire          en_write;
	wire          hold_data_valid;
	// wire          extend_wrap;
	reg           hold_data_valid_reg;
	reg           space_in_data_fifo_reg;
	wire          pass_data;
	reg  [7:0]    beat_cnt_reg;
	reg  [11:0]    beat_cnt_reg_shifted;
	reg           fixed_flag_reg;
	wire          fixed_flag_comb;
	wire          valid_fixed_flag;
	// wire          aligned_wrap;
	wire          reached_wrap_boundary_accepted;
	wire          reached_wrap_boundary;
	reg           reached_wrap_boundary_accepted_reg;
	wire          reached_wrap_boundary_accepted_comb;
	wire          end_ext_wrap_burst;
	reg           end_ext_wrap_burst_reg;
	reg           beat_cnt_reg_eq_0;
	wire          end_ext_wrap_burst_comb;
	wire [WIDTH_OUT_ENCODED-WIDTH_IN_ENCODED-1:0]   addr_comb;
	reg  [WIDTH_OUT_ENCODED-WIDTH_IN_ENCODED-1:0]   addr_reg;

	reg  [(DATA_WIDTH_OUT/DATA_WIDTH_IN)-1:0]  zero_strb_data_reg;
	reg  [WIDTH_IN_BYTES-1:0]                  zero_hold_reg_data;
	wire [WIDTH_IN_BYTES-1:0]                  wr_data;
  
	// wire        second_wrap_burst;
	wire        boundary_reached;

	assign end_cycle      = wlast & accept_data;
	assign zero_strb_data = zero_strb_data_reg;
	assign accept_data    = wready & wvalid;
	assign en_write       = ~data_fifo_nearly_full & (accept_data | hold_data_valid_reg);

	assign valid_fixed_flag = ~cmd_fifo_empty & fixed_flag;

  // assign size_one_hot  = (1 << size);
  // assign mask_addr_msb = ~(size_one_hot - 1);
	// assign mask_addr     = (WIDTH_OUT_BYTES - 1) & mask_addr_msb; // align the address to the transfer size and zero unnecessary MSBs
	assign offset        = valid_fixed_flag ? 0 : (second_wrap_burst ? master_beat_cnt_to_boundary_shifted : ((pass_data) ? master_beat_cnt_shifted : (beat_cnt_reg_shifted)));
	assign addr_offset   = (mask_addr & (addr + offset));
	assign beat_offset   = ((beat_cnt == 0) ?  addr_offset >> (size) : offset_latched);

	// assign second_wrap_burst = (wrap_flag & ~extend_tx & ~aligned_wrap);
	// if WRAP burst needs to be split into two transactions, increments the pkt counter when the caxi4interconnect_UpConverter receives enough data to provide a full transacton to the slave otherwise wait for WLAST.
	assign boundary_reached  = (beat_cnt == to_boundary);
	// assign aligned_wrap      = (to_boundary == wlen_mst);
	assign incr_pkt_cnt_next = accept_data & ((extend_wrap) ? boundary_reached: wlast); 
	// assign extend_wrap       = wrap_flag & extend_tx;

	always @(posedge ACLK or negedge sysReset) begin
		if (!sysReset) begin
			incr_pkt_cnt                       <= 1'b0;
			offset_latched                     <= 11'b0;
			hold_data_valid_reg                <= 1'b0;
			end_cycle_reg                      <= 1'b0;
			space_in_data_fifo_reg             <= 1'b1;
			fixed_flag_reg                     <= 1'b0;
			addr_offset_reg                    <= 0;
			reached_wrap_boundary_accepted_reg <= 1'b0;
			end_ext_wrap_burst_reg             <= 1'b0;
			addr_reg                           <= 0;
		end
		else begin
			incr_pkt_cnt                       <= incr_pkt_cnt_next; // force to 0 when no transactions are stored in the command caxi4interconnect_FIFO
			offset_latched                     <= beat_offset;
			hold_data_valid_reg                <= hold_data_valid;
			end_cycle_reg                      <= end_cycle_comb;
			space_in_data_fifo_reg             <= ~data_fifo_nearly_full;
			fixed_flag_reg                     <= fixed_flag_comb;
			addr_offset_reg                    <= addr_offset_comb;
			reached_wrap_boundary_accepted_reg <= reached_wrap_boundary_accepted_comb;
			end_ext_wrap_burst_reg             <= end_ext_wrap_burst_comb;
			addr_reg                           <= addr_comb;
		end
	end

	always @(posedge ACLK or negedge sysReset) begin
		if (!sysReset) begin
			beat_cnt_reg <= 0;
			beat_cnt_reg_eq_0 <= 1'b0;
			beat_cnt_reg_shifted <= 0;
		end
		else begin
			if (pass_data) begin
				beat_cnt_reg <= beat_cnt;
				beat_cnt_reg_eq_0 <= (beat_cnt == 'b0);
				beat_cnt_reg_shifted <= beat_cnt << size;
			end
		end
	end

	assign write_top_hold_reg = (valid_fixed_flag) | (wr_data[WIDTH_IN_BYTES-1] | zero_hold_reg_data[WIDTH_IN_BYTES-1]);

	generate
		for (i=0;i<(DATA_WIDTH_OUT/DATA_WIDTH_IN);i=i+1) begin
			assign wr_en_words[i] = ((pass_data) ? (i == addr_offset[WIDTH_OUT_ENCODED-1:WIDTH_IN_ENCODED]) : (i == addr_offset_reg));
			always @(posedge ACLK or negedge sysReset) begin
				if (!sysReset) begin
					wr_en[i] <= 1'b0;
				end
				else begin
					if (data_fifo_nearly_full) begin
						wr_en[i] <= 1'b0;
					end
					else begin
						wr_en[i] <= en_write & wr_en_words[i] & (hold_data_valid_reg | write_top_hold_reg | reached_wrap_boundary); // write data to the data caxi4interconnect_FIFO when the memory is not full, the AXI data can be accepted and the holding register is full
					end
				end
			end
		end
	endgenerate

	generate
		for (j=0;j<(DATA_WIDTH_OUT/DATA_WIDTH_IN);j=j+1) begin
			always @(posedge ACLK or negedge sysReset) begin
				if (!sysReset) begin
					zero_strb_data_reg[j] <= 1'b0;
				end
				else begin
					if (data_fifo_nearly_full) begin
						zero_strb_data_reg[j] <= 1'b0;
					end
					else if (pass_data) begin
						if (((valid_fixed_flag & en_write) | end_cycle | reached_wrap_boundary_accepted) & (j > addr_offset[WIDTH_OUT_ENCODED-1:WIDTH_IN_ENCODED])) begin // zero data and strobes if the transaction is terminated before the output data bus is full
							zero_strb_data_reg[j] <= 1'b1;
						end
						else if ((valid_fixed_flag | (master_beat_cnt_eq_0)) & (j < addr_offset[WIDTH_OUT_ENCODED-1:WIDTH_IN_ENCODED]) & en_write) begin // zero data and strobes if the incoming address is not aligned to the output datawidth
							zero_strb_data_reg[j] <= 1'b1;
						end
						else if (end_ext_wrap_burst & (j < addr[WIDTH_OUT_ENCODED-1:WIDTH_IN_ENCODED]) & en_write) begin
							zero_strb_data_reg[j] <= 1'b1;
						end
						else begin
							zero_strb_data_reg[j] <= 1'b0;
						end
					end
					else begin
						if (((fixed_flag_reg & en_write) | end_cycle_reg |  reached_wrap_boundary_accepted_reg) & (j > addr_offset_reg)) begin // zero data and strobes if the transaction is terminated before the output data bus is full
							zero_strb_data_reg[j] <= 1'b1;
						end
						else if ((fixed_flag_reg | (beat_cnt_reg_eq_0)) & (j < addr_offset_reg) & en_write) begin // zero data and strobes if the incoming address is not aligned to the output datawidth
							zero_strb_data_reg[j] <= 1'b1;
						end
						else if (end_ext_wrap_burst_reg & (j < addr_reg) & en_write) begin
							zero_strb_data_reg[j] <= 1'b1;
						end
						else begin
							zero_strb_data_reg[j] <= 1'b0;
						end
					end
				end
			end
		end
	endgenerate
  
  // For user info and wid only
	always @(posedge ACLK or negedge sysReset) begin
		if (!sysReset) begin
			user_data_out[USER_WIDTH-1:0] <= 0;
			wid_data_out                  <= 0;
		end
		else begin
			if ((wr_data[WIDTH_IN_BYTES-1]) | (zero_hold_reg_data[WIDTH_IN_BYTES-1])) begin
				user_data_out[USER_WIDTH-1:0] <= data_in[((USER_WIDTH+DATA_WIDTH_IN+DATA_WIDTH_IN/8)-1):(DATA_WIDTH_IN+DATA_WIDTH_IN/8)];
				wid_data_out                  <= data_in[(ID_WIDTH+USER_WIDTH+DATA_WIDTH_IN+(DATA_WIDTH_IN/8)-1):(USER_WIDTH+DATA_WIDTH_IN+DATA_WIDTH_IN/8)];
			end
		end
	end

  // For Data + Strobes info only
	generate
		for (i=0;i<WIDTH_IN_BYTES;i=i+1) begin // WIDTH_IN_BYTES = DATA_WIDTH_IN+DATA_WIDTH_IN/8
			always @(posedge ACLK or negedge sysReset) begin
				if (!sysReset) begin
					ds_data_out[i*8+:8] <= 8'h00;
					ds_data_out[DATA_WIDTH_IN+i] <= 1'b0;
				end
				else begin
					if (pass_data) begin
						if (wr_data[i]) begin
							ds_data_out[i*8+:8] <= data_in[i*8+:8];
							ds_data_out[DATA_WIDTH_IN+i] <= data_in[DATA_WIDTH_IN+i];
						end
						else if (zero_hold_reg_data[i]) begin
							ds_data_out[i*8+:8] <= 8'h00;
							ds_data_out[DATA_WIDTH_IN+i] <= 1'b0;
						end
					end
				end
			end
		end
	endgenerate	

  //Separated these out to avoid using same output variable names from 2 threads
  assign data_out = { wid_data_out,user_data_out, ds_data_out};
  
	generate
		for (i=0;i<WIDTH_IN_BYTES;i=i+1) begin
			// generate local strobes to write data on a byte basis.
			// set bit when the i-th byte has to be written. It occurs when i is between the current value of offset and (offset + size).
			assign wr_data[i] = ((i >= addr_offset[WIDTH_IN_ENCODED-1:0]) && (i < (addr_offset[WIDTH_IN_ENCODED-1:0]+(size_shifted)))) & accept_data; //((~cmd_fifo_empty) | en_write) ;
		end
	endgenerate

	generate
		for (j=0;j<WIDTH_IN_BYTES;j=j+1) begin
			always @(*) begin
				if (data_fifo_nearly_full) begin
					zero_hold_reg_data[j] <= 1'b0;
				end
				else if ((valid_fixed_flag | end_cycle | reached_wrap_boundary_accepted) & (j >= (addr_offset[WIDTH_IN_ENCODED-1:0]+(size_shifted)))) begin  // zero data at the end of a transaction if the holding register is not full
					zero_hold_reg_data[j] <= 1'b1;
				end
				else if ((valid_fixed_flag | (master_beat_cnt_eq_0)) & (j < addr_offset[WIDTH_IN_ENCODED-1:0]) & accept_data) begin // zero data in case of unaligned address at the beginning of a transaction
					zero_hold_reg_data[j] <= 1'b1;
				end
				else if (end_ext_wrap_burst & (j < addr[WIDTH_IN_ENCODED-1:0]) & en_write) begin
					zero_hold_reg_data[j] <= 1'b1;
				end
				else begin
					zero_hold_reg_data[j] <= 1'b0;
				end
			end
		end
	endgenerate

	assign end_ext_wrap_burst = wrap_flag & ~extend_tx & end_cycle & ~aligned_wrap;
	assign end_ext_wrap_burst_comb = (pass_data) ? end_ext_wrap_burst : end_ext_wrap_burst_reg;

	assign reached_wrap_boundary = boundary_reached & wrap_flag & extend_tx;
	assign reached_wrap_boundary_accepted = reached_wrap_boundary & accept_data;
	assign reached_wrap_boundary_accepted_comb = (pass_data) ? reached_wrap_boundary_accepted : reached_wrap_boundary_accepted_reg;

	assign hold_data_valid = (hold_data_valid_reg) ? data_fifo_nearly_full : (data_fifo_nearly_full & accept_data);
	assign end_cycle_comb = (pass_data) ? end_cycle : end_cycle_reg;
	assign fixed_flag_comb = (pass_data) ? valid_fixed_flag : fixed_flag_reg;
	assign addr_comb = (pass_data) ? addr[WIDTH_OUT_ENCODED-1:WIDTH_IN_ENCODED] : addr_reg;	
	assign addr_offset_comb = (pass_data) ? addr_offset[WIDTH_OUT_ENCODED-1:WIDTH_IN_ENCODED] : addr_offset_reg;
	assign pass_data = (data_fifo_nearly_full) ? space_in_data_fifo_reg : 1'b1;

endmodule
