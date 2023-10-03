

// **********************************************************************/
// Microsemi Corporation Proprietary and Confidential
// Copyright 2014 Microsemi Corporation. All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: G5 APBLink Slave
//
//
// SVN Revision Information:
// SVN $Revision: 1688 $
// SVN $Date $
//
// Date    Who  Description
// 24Feb13 IPB  Initial version.
//
// *********************************************************************/
`timescale 1ns / 100ps


module G5_APBLINK_MASTER
            ( // Link Side
              output              lnk_m_rst_b,
              output              lnk_m_clock,
              output              lnk_m_enable,
              output [2:0]        lnk_m_addr,
              output [3:0]        lnk_m_wdata,
              input  [3:0]        lnk_m_rdata,
              // APB Side
              input               preset_b,
              input               pclk,
              input               psel,
              input               penable,
              input               pwrite,
              input      [3:0]    pstrb,
              input      [25:0]   paddr,
              input      [31:0]   pwdata,
              output reg [31:0]   prdata,
              output reg          pready,
              output reg          pslverr,
              output reg          pcie_0_perst_out,
              output reg          pcie_1_perst_out,
			  
			  output wire [5:0] lnk_state_copy
            );

//####################################################################################################################
// Local Definitions
//####################################################################################################################

// APBLink Command Encoding
localparam [1:0] NOOP  = 2'b00;
localparam [1:0] WRITE = 2'b10;
localparam [1:0] READ  = 2'b01;
localparam [1:0] POLL  = 2'b11;

//####################################################################################################################
// Declarations

wire  [1:0] start;
wire        match;
wire        rdt_r_shft;
wire        bus_rdy_mrk;
wire        bus_err_mrk;
reg         slv_rd_err;
wire        apb_tfr;

reg  [25:2] last_raddr;
parameter PCIE_0_ROOTPORT_EN = 1'b1;
parameter PCIE_1_ROOTPORT_EN = 1'b1;

localparam [5:0] IDLE = 6'd0;
localparam [5:0] AD_0 = 6'd1;
localparam [5:0] AD_1 = 6'd2;
localparam [5:0] AD_2 = 6'd3;
localparam [5:0] AD_3 = 6'd4;
localparam [5:0] AD_4 = 6'd5;
localparam [5:0] AD_5 = 6'd6;
localparam [5:0] AD_6 = 6'd7;
localparam [5:0] AD_7 = 6'd8;
localparam [5:0] STUP = 6'd9;
localparam [5:0] ACCS = 6'd10;
localparam [5:0] MSTRDY = 6'd11;
localparam [5:0] RD_00 = 6'd12;
localparam [5:0] RD_04 = 6'd13;
localparam [5:0] RD_08 = 6'd14;
localparam [5:0] RD_12 = 6'd15;
localparam [5:0] RD_16 = 6'd16;
localparam [5:0] RD_20 = 6'd17;
localparam [5:0] RD_24 = 6'd18;
localparam [5:0] RD_28 = 6'd19;

reg [5:0] lnk_m_cs = IDLE;

//####################################################################################################################
//  FORCES
//####################################################################################################################

assign lnk_m_enable = 1'b1;

assign lnk_state_copy = lnk_m_cs; //MI

//####################################################################################################################
// Holding Last Transaction Address to be used as READ address for POLL
//####################################################################################################################


always @(posedge pclk or negedge preset_b)
  begin
    if (!preset_b)
        last_raddr[25:2] <= 24'h000000;
    else
        if ( lnk_m_cs == ACCS ) last_raddr[25:2] <= paddr[25:2];
  end

assign match = (paddr[25:2] == last_raddr[25:2]) ? 1'b1: 1'b0;

assign apb_tfr = psel;

assign start = (!apb_tfr) ? NOOP  :
               ( pwrite ) ? WRITE :
               (!match  ) ? READ  :
                POLL;

//####################################################################################################################
// APB to  APBLINK FSM
//####################################################################################################################


always @(posedge pclk or negedge preset_b)
  begin
    if (!preset_b)
      begin
        lnk_m_cs   <= IDLE;
        pready     <= 1'b0;
        pslverr    <= 1'b0;
       end
    else
           case (lnk_m_cs)
                IDLE: if ((start == WRITE) ||  (start == READ))
                        begin
                         lnk_m_cs <= AD_0;
                        end
                      else  if (start == POLL)
                        begin
                         lnk_m_cs <= STUP;
                        end
                AD_0:    lnk_m_cs <= AD_1;
                AD_1:    lnk_m_cs <= AD_2;
                AD_2:    lnk_m_cs <= AD_3;
                AD_3:    lnk_m_cs <= AD_4;
                AD_4:    lnk_m_cs <= AD_5;
                AD_5:    lnk_m_cs <= AD_6;
                AD_6:    lnk_m_cs <= AD_7;
                AD_7:    lnk_m_cs <= STUP;
                STUP: begin
                         lnk_m_cs   <= ACCS;
                         pready     <= 1'b0;
                         pslverr    <= 1'b0;
                         slv_rd_err <= 1'b0;
                      end
                ACCS: if (bus_rdy_mrk && !pwrite)
                          begin
                            lnk_m_cs   <= RD_00;
                            pready     <= 1'b0;
                            pslverr    <= 1'b0;
                            slv_rd_err <= bus_err_mrk;
                          end
                      else if (bus_rdy_mrk && pwrite)
                          begin
                            lnk_m_cs   <= MSTRDY;
                            pready     <= 1'b1;
                            pslverr    <= bus_err_mrk;
                            slv_rd_err <= 1'b0;
                          end
               RD_00:    lnk_m_cs <= RD_04;
               RD_04:    lnk_m_cs <= RD_08;
               RD_08:    lnk_m_cs <= RD_12;
               RD_12:    lnk_m_cs <= RD_16;
               RD_16:    lnk_m_cs <= RD_20;
               RD_20:    lnk_m_cs <= RD_24;
               RD_24:    lnk_m_cs <= RD_28;
               RD_28:    begin
                            lnk_m_cs   <= MSTRDY;
                            pready     <= 1'b1;
                            pslverr    <= slv_rd_err;
                         end
              MSTRDY:    begin
                            lnk_m_cs   <= IDLE;
                            pready     <= 1'b0;
                            pslverr    <= 1'b0;
                         end
             default:    begin
                            lnk_m_cs   <= IDLE;
                            pready     <= 1'b0;
                            pslverr    <= 1'b0;
                         end

           endcase

  end

//####################################################################################################################
// Transmit CMD / ADD / WDT on link
//####################################################################################################################

assign lnk_m_addr = (lnk_m_cs == AD_0) ? {paddr[18], paddr[10], paddr[2]} :
                    (lnk_m_cs == AD_1) ? {paddr[19], paddr[11], paddr[3]} :
                    (lnk_m_cs == AD_2) ? {paddr[20], paddr[12], paddr[4]} :
                    (lnk_m_cs == AD_3) ? {paddr[21], paddr[13], paddr[5]} :
                    (lnk_m_cs == AD_4) ? {paddr[22], paddr[14], paddr[6]} :
                    (lnk_m_cs == AD_5) ? {paddr[23], paddr[15], paddr[7]} :
                    (lnk_m_cs == AD_6) ? {paddr[24], paddr[16], paddr[8]} :
                    (lnk_m_cs == AD_7) ? {paddr[25], paddr[17], paddr[9]} :
                    (lnk_m_cs == IDLE) ? {1'b0, start[1:0]}               :
                     3'b000;

assign lnk_m_wdata = (lnk_m_cs == AD_0) ? {pwdata[24], pwdata[16], pwdata[ 8], pwdata[0]} :
                    (lnk_m_cs == AD_1) ? {pwdata[25], pwdata[17], pwdata[ 9], pwdata[1]} :
                    (lnk_m_cs == AD_2) ? {pwdata[26], pwdata[18], pwdata[10], pwdata[2]} :
                    (lnk_m_cs == AD_3) ? {pwdata[27], pwdata[19], pwdata[11], pwdata[3]} :
                    (lnk_m_cs == AD_4) ? {pwdata[28], pwdata[20], pwdata[12], pwdata[4]} :
                    (lnk_m_cs == AD_5) ? {pwdata[29], pwdata[21], pwdata[13], pwdata[5]} :
                    (lnk_m_cs == AD_6) ? {pwdata[30], pwdata[22], pwdata[14], pwdata[6]} :
                    (lnk_m_cs == AD_7) ? {pwdata[31], pwdata[23], pwdata[15], pwdata[7]} :
                    pstrb;


//####################################################################################################################
// Receive RDT from Link
//####################################################################################################################

assign  rdt_r_shft= (lnk_m_cs == RD_00) ? 1'b1 :
                    (lnk_m_cs == RD_04) ? 1'b1 :
                    (lnk_m_cs == RD_08) ? 1'b1 :
                    (lnk_m_cs == RD_12) ? 1'b1 :
                    (lnk_m_cs == RD_16) ? 1'b1 :
                    (lnk_m_cs == RD_20) ? 1'b1 :
                    (lnk_m_cs == RD_24) ? 1'b1 :
                    (lnk_m_cs == RD_28) ? 1'b1 :
                    1'b0;

always @(posedge pclk)
        begin
           if (rdt_r_shft)
             begin
               prdata[7:0]   <= { lnk_m_rdata[0], prdata[7:1]   };
               prdata[15:8]  <= { lnk_m_rdata[1], prdata[15:9]  };
               prdata[23:16] <= { lnk_m_rdata[2], prdata[23:17] };
               prdata[31:24] <= { lnk_m_rdata[3], prdata[31:25] };
             end
        end

assign bus_rdy_mrk = lnk_m_rdata[2];
assign bus_err_mrk = lnk_m_rdata[3];


assign lnk_m_clock = pclk;
assign lnk_m_rst_b = preset_b;

 //when PCIE_0 is configured as root port "pcie_0_perst_out" signal will be 
 //controlled from register with adress equals to "26'h3006150" and pwrite==1 and bit [0] pwdata
 //below logic will be generated when PCIE_0 is in root port mode

generate 
if (PCIE_0_ROOTPORT_EN) 
 begin
always @(posedge pclk or negedge preset_b)
 begin   
       if (!preset_b)
         begin
          pcie_0_perst_out     <= 1'b1;
         end
       else
	    begin
        if(paddr == 26'h3006150 && pwrite)
	      pcie_0_perst_out <= pwdata[0] ;
         else
		pcie_0_perst_out <=pcie_0_perst_out;
	   end
	end
    end
endgenerate

 //when PCIE_1 is configured as root port "pcie_1_perst_out" signal will be 
 //controlled from register with adress equals to "26'h300A150" and pwrite==1 and bit [0] pwdata
 //below logic will be generated when PCIE_1 is in root port mode
	
generate 
if (PCIE_1_ROOTPORT_EN) 
 begin	
always @(posedge pclk or negedge preset_b)
  begin
      if (!preset_b)
          begin
           pcie_1_perst_out     <= 1'b1;
          end
         else
	     begin
             if(paddr == 26'h300A150 && pwrite )
	      pcie_1_perst_out <= pwdata[0] ;
	     else
		pcie_1_perst_out <=pcie_1_perst_out;
	     end
	end 
 end   
endgenerate 

endmodule
