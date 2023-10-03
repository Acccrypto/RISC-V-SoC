// ********************************************************************
//  Microsemi Corporation Proprietary and Confidential
//  Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: This module provides a AHB Master test source. It
//              initialiates a Master transmission.
//
// Revision Information:
// Date     Description:
// Feb17    Revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************

`timescale 1ns/1ps
module AHBL_Master ( 
    // AHBL interface
    HCLK,
    HRESETn,
    HSEL,
    HADDR,
    HWRITE,
    HREADY,
    HTRANS,
    HSIZE,
    HWDATA,
    HBURST,
    HMASTLOCK,
    HRESP,
    HRDATA,

    HNONSEC, // bbriscoe: added to tidy up
    HPROT, // bbriscoe: added to tidy up

    start_tx,
    hwrite_tx,
    hburst_tx,
    hsize_tx,
    haddr_tx,
    end_tx
    );

//---------------------------------------------------
// Global parameters
//---------------------------------------------------
  parameter  AHB_AWIDTH    = 32; 
  parameter  AHB_DWIDTH    = 32; 
  parameter  [7:0] UNDEF_BURST    = 8'h0f;  // if '0' then single transfer else INCR16. Can be any value between 0-255

  parameter  DATA_INCR_EN  = 1;
  parameter  DATA_STEP_SIZE  = 4'h2;

  `define reset_time = 2ns;


  localparam IDLE        = 2'b00;
  localparam BUSY        = 2'b01;
  localparam NONSEQ      = 2'b10;
  localparam SEQ         = 2'b11;

  localparam SINGLE      = 3'b000;
  localparam INCR        = 3'b001;
  localparam WRAP4       = 3'b010;
  localparam INCR4       = 3'b011;
  localparam WRAP8       = 3'b100;
  localparam INCR8       = 3'b101;
  localparam WRAP16      = 3'b110;
  localparam INCR16      = 3'b111;

  localparam BYTE        = 2'b00;
  localparam HALFWORD    = 2'b01;
  localparam WORD        = 2'b10;
  localparam DOUBLEWORD  = 2'b11;

  localparam OKAY        = 2'b00;
  localparam ERROR       = 2'b01;
  localparam RETRY       = 2'b10;
  localparam SPLIT       = 2'b11;

  localparam WRITE       = 1'b1;
  localparam READ        = 1'b0;
  localparam HIGH        = 1'b1;
  localparam LOW         = 1'b0;

  `define burst;
  `define size;


//---------------------------------------------------
// Input-Output Ports
//---------------------------------------------------
  // Inputs on the AHBL interface
  input                     HCLK;
  input                     HRESETn;  
  input                     HREADY;
  input    [AHB_DWIDTH-1:0] HRDATA;  
  input                     start_tx;
  input    [2:0]            hburst_tx;
  input    [2:0]            hsize_tx;
  input                     hwrite_tx;
  input    [31:0]           haddr_tx;
  input                     HRESP;


  // Outputs on the AHBL Interface
  output                    HSEL;
  output  [AHB_AWIDTH-1:0]  HADDR;
  output                    HWRITE;
  output  [1:0]             HTRANS;
  output  [2:0]             HSIZE;
  output  [AHB_DWIDTH-1:0]  HWDATA;
  output  [2:0]             HBURST;
  output                    HMASTLOCK;
  output                    end_tx;
  output  [6:0]             HPROT;
  output                    HNONSEC;
  
  
  
  

  reg               end_op;
  reg               tx_valid;
  reg               write_tx;
  reg               HSEL;
  reg               HWRITE;
  reg  [1:0]        HTRANS;
  reg  [2:0]        HSIZE;
  reg  [2:0]        HBURST;
  wire              HMASTLOCK;
  
  reg  [AHB_AWIDTH-1:0]    HADDR;
  reg  [AHB_DWIDTH-1:0]    HWDATA;
  reg  [AHB_DWIDTH-1:0]    read_data;
  
  reg  [AHB_AWIDTH-1:0]    haddr, haddr_w,init_addr;
  
  reg  [7:0]            haddr_incr;
  reg  [7:0]            hburst_value;
  reg                   wrap_enable;
  reg  [7:0]            set_wrap_addr;
  reg [AHB_DWIDTH-1:0]  mask;
  reg  [1:0]            write_resp;

  wire [AHB_DWIDTH-1:0] baseValue;


  assign HPROT    = 7'b0;
  assign HNONSEC  = 1'b0;
  assign HMASTLOCK    = 1'b0;

genvar i;

generate
for (i=0; i<(AHB_DWIDTH/8);i=i+1) begin
  assign baseValue[(8*i)+:8] = i;
end
endgenerate


//---------------------------------------------------------------------------
// Initial value declarations
//---------------------------------------------------------------------------
initial begin
  HSEL        = 1'b0; 
  HWRITE      = 1'b0;
  HTRANS      = 2'b00;
  HADDR       = 32'h0000_0000;
  HBURST      = 3'b000;
  HSIZE       = 3'b000;
  end_op      = 1'b1;
  tx_valid    = 1'b0;
  @ (posedge HRESETn);
end

  assign end_tx = end_op;

always @(*) begin
  if (start_tx & end_op) begin
    ahb_op(haddr_tx, hburst_tx, hsize_tx, hwrite_tx);
  end
  else begin
        if (tx_valid & HREADY) begin
    tx_valid = 0;
    if (~write_tx & ((HRDATA & mask) != ((baseValue+hburst_value) & mask))) begin
      $display( "%d, MASTER ERROR - exp RDATA= %h, act RDATA= %h, mask= %h, full data= %h", $time, ((baseValue + hburst_value) & mask), (HRDATA & mask), mask, HRDATA  );
      #1 $stop;
    end
  end
  end
end

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

  task set_wraddr_incr_value;
  input  [2:0]   hsize;
  begin
    case (hsize) 
      3'b000 : haddr_incr = 8'h1; // Byte
      3'b001 : haddr_incr = 8'h2; // Half word
      3'b010 : haddr_incr = 8'h4; // Word
      3'b011 : haddr_incr = 8'h8; // Double word
      3'b100 : haddr_incr = 8'h10; 
      3'b101 : haddr_incr = 8'h20;
      3'b110 : haddr_incr = 8'h40;
      3'b111 : haddr_incr = 8'h80;
    endcase
  end
  endtask

  task set_hburst_value;
  input  [2:0]   hburst;
  begin
    case (hburst) 
      3'b000 : hburst_value = 8'h00;
      3'b001 : hburst_value = UNDEF_BURST;
      3'b010 : hburst_value = 8'h03;
      3'b011 : hburst_value = 8'h03;
      3'b100 : hburst_value = 8'h07;
      3'b101 : hburst_value = 8'h07;
      3'b110 : hburst_value = 8'hf;
      3'b111 : hburst_value = 8'hf;
    endcase
    case (hburst) 
      3'b000 : wrap_enable = 1'b0;
      3'b001 : wrap_enable = 1'b0;
      3'b010 : wrap_enable = 1'b1;
      3'b011 : wrap_enable = 1'b0;
      3'b100 : wrap_enable = 1'b1;
      3'b101 : wrap_enable = 1'b0;
      3'b110 : wrap_enable = 1'b1;
      3'b111 : wrap_enable = 1'b0;
    endcase
  end
  endtask

  task set_wrap_value;
  begin
    case (HBURST[2:0]) 
      3'b010 : if (HSIZE == 2'b10) begin
            set_wrap_addr = 8'h0C;
           end else if (HSIZE == 2'b01) begin
            set_wrap_addr = 8'h06;
           end else if (HSIZE == 2'b00) begin
            set_wrap_addr = 8'h03;
           end
      3'b100 : if (HSIZE == 2'b10) begin
            set_wrap_addr = 8'h1C;
           end else if (HSIZE == 2'b01) begin
            set_wrap_addr = 8'h0E;
           end else if (HSIZE == 2'b00) begin
            set_wrap_addr = 8'h07;
           end
      3'b110 : if (HSIZE == 2'b10) begin
            set_wrap_addr = 8'h3C;
           end else if (HSIZE == 2'b01) begin
            set_wrap_addr = 8'h1E;
           end else if (HSIZE == 2'b00) begin
            set_wrap_addr = 8'h0F;
           end
      default : set_wrap_addr = 8'h00;
  endcase
  end
  endtask

  task set_mask;
  begin
    mask <= 0;
  case (AHB_DWIDTH)
    'd32 :  case(HSIZE)
             3'b000 : mask[(8*HADDR[1:0]) +: 8] <= {1{8'hff}};
             3'b001 : mask[(16*HADDR[1]) +: 16] <= {2{8'hff}};
             3'b010 : mask[31 : 0] <= {4{8'hff}};
            endcase
    'd64 :  case (HSIZE)
             3'b000 : mask[(8*HADDR[2:0]) +: 8]   <= {1{8'hff}};
             3'b001 : mask[(16*HADDR[2:1]) +: 16] <= {2{8'hff}};
             3'b010 : mask[(32*HADDR[2]) +: 32]   <= {4{8'hff}};
             3'b011 : mask[63 : 0] <= {8{8'hff}};
            endcase
    'd128 : case (HSIZE)
             3'b000 : mask[(8*HADDR[3:0]) +: 8]   <= {1{8'hff}};
             3'b001 : mask[(16*HADDR[3:1]) +: 16] <= {2{8'hff}};
             3'b010 : mask[(32*HADDR[3:2]) +: 32] <= {4{8'hff}};
             3'b011 : mask[(64*HADDR[3]) +: 64]   <= {8{8'hff}};
             3'b100 : mask[127 : 0] <=  {16{8'hff}};
            endcase
    'd256 : case (HSIZE)
             3'b000 : mask[(8*HADDR[4:0]) +: 8]     <= {1{8'hff}};
             3'b001 : mask[(16*HADDR[4:1]) +: 16]   <= {2{8'hff}};
             3'b010 : mask[(32*HADDR[4:2]) +: 32]   <= {4{8'hff}};
             3'b011 : mask[(64*HADDR[4:3]) +: 64]   <= {8{8'hff}};
             3'b100 : mask[(128*HADDR[4]) +: 128]   <= {16{8'hff}};
             3'b101 : mask[255 : 0] <= {32{8'hff}};
            endcase
    'd512 : case (HSIZE)
             3'b000 : mask[(8*HADDR[5:0]) +: 8]     <= {1{8'hff}};
             3'b001 : mask[(16*HADDR[5:1]) +: 16]   <= {2{8'hff}};
             3'b010 : mask[(32*HADDR[5:2]) +: 32]   <= {4{8'hff}};
             3'b011 : mask[(64*HADDR[5:3]) +: 64]   <= {8{8'hff}};
             3'b100 : mask[(128*HADDR[5:4]) +: 128] <= {16{8'hff}};
             3'b101 : mask[(256*HADDR[5]) +: 256]   <= {32{8'hff}};
             3'b110 : mask[511 : 0] <= {64{8'hff}};
            endcase
      endcase
  end
  endtask

  task set_haddr;
  input  [31:0]  initaddr;
  input  [31:0]  haddr;
  input  [2:0]   hsize;  // 00-byte, 01-halfword, 10-word, 11-doubleword
  output [31:0]  haddr_out;
  reg    [31:0]  haddr_reg;
  reg    [10:0]  LAST_NIBBLE;
  begin
    case (hsize) 
      3'b000: LAST_NIBBLE = 11'h00F;  // Byte
      3'b001: LAST_NIBBLE = 11'h1E;   // Halfword
      3'b010: LAST_NIBBLE = 11'h3C;   // Word
      3'b011: LAST_NIBBLE = 11'h78;   // Double Word
      3'b100: LAST_NIBBLE = 11'hF0;   // 4-word Line
      3'b101: LAST_NIBBLE = 11'h1E0;  // 8-word Line
      3'b110: LAST_NIBBLE = 11'h3C0;  // 512 bits
      3'b111: LAST_NIBBLE = 11'h780;  // 1024 bits
    endcase 
    set_wrap_value;
    haddr_reg = haddr;
    if (wrap_enable) begin
      if ((haddr_reg[10:0] & (hburst_value << hsize)) == ((hburst_value << hsize) & LAST_NIBBLE)) begin
        haddr_reg = {haddr_reg[31:11], (haddr_reg[10:0] & ~(hburst_value << hsize))};
      end
      else begin
        haddr_reg  = haddr_reg + haddr_incr;
      end
    end
    else begin
      haddr_reg  = haddr_reg + haddr_incr;
    end
    haddr_out = haddr_reg;
  end   
  endtask // set_haddr

  task ahb_op;
  input  [31:0] haddr;
  input  [2:0]  hburst;
  input  [2:0]  hsize;
  input         hwrite;
  integer       i, busy_threshold, counter;
  reg  [3:0]    data_step_size;
  begin


    // ===========================
    // Perform one single write
    busy_threshold = 50;
    init_addr = haddr; 

    // First non-seq cycle 
    HSEL   = HIGH; 
    HTRANS = NONSEQ;
    HADDR  = haddr;
    HBURST = hburst;
    HWRITE = hwrite;
    HSIZE  = hsize;

    @(posedge HCLK);

    end_op <= 1'b0;
    while (HREADY==1'b0) begin
      @ (posedge HCLK);
    end

    write_tx = hwrite;

    if (~hwrite & tx_valid) begin
      tx_valid = 1;
        if ((HRDATA & mask) != ((baseValue + hburst_value) & mask)) begin
          $display( "%d, MASTER ERROR - exp RDATA= %h, act RDATA= %h, mask= %h, full data= %h", $time, ((baseValue + hburst_value) & mask), (HRDATA & mask), mask, HRDATA  );
          #1 $stop;
        end
      end
      set_mask;
      set_wraddr_incr_value(hsize);
      set_hburst_value(hburst);

      if (hwrite) begin
         HWDATA = baseValue;
         tx_valid = 1;
      end 
      
      counter = 1;
      while (counter <= hburst_value) begin

        HSEL   = HIGH; 
        HTRANS = SEQ;
        set_haddr(haddr, HADDR, hsize, HADDR);
        HBURST = hburst;
        HWRITE = hwrite;
        HSIZE  = hsize;

        @(posedge HCLK);
        while (HREADY==1'b0) begin
          @ (posedge HCLK);
        end
     
        if (~hwrite & tx_valid) begin
          tx_valid = 1;
          if ((HRDATA & mask) != ((baseValue + counter-1) & mask)) begin
            $display( "%d, MASTER ERROR - exp RDATA= %h, act RDATA= %h, mask= %h, full data= %h", $time, ((baseValue + counter - 1) & mask), (HRDATA & mask), mask, HRDATA  );
            #1 $stop;
          end
          end
        counter = counter + 1;
        set_mask;

        if (hwrite) begin
          HWDATA = HWDATA + 1;
          tx_valid = 1;
        end
      end

      HSEL = LOW;
      HTRANS = IDLE;
      HTRANS = IDLE;
      HADDR  = 32'h0000_0000;
      HBURST = 3'b000;
      HWRITE = 1'b0;
      HSIZE  = 2'b00;
      @ (posedge HCLK);
      if (tx_valid & HREADY & ~write_tx) begin
        tx_valid = 0;
          if ((HRDATA & mask) != ((baseValue + hburst_value) & mask)) begin
            $display( "%d, MASTER ERROR - exp RDATA= %h, act RDATA= %h, mask= %h, full data= %h", $time, ((baseValue + hburst_value) & mask), (HRDATA & mask), mask, HRDATA  );
            #1 $stop;
          end
      end
      end_op <= 1'b1;

  end
  endtask // ahb_op

endmodule