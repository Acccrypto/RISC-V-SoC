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
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 
 
module caxi4interconnect_CDC_rdCtrl (
                   //  input ports
                   clk,
                   rst,
                   rdPtr_gray,
                   wrPtr_gray,
                   nextrdPtr_gray,
                   readyForOut,
 
                   //  output ports
                   infoOutValid,
                   fifoRe
                   );
 
   parameter        ADDR_WIDTH       = 3;
//  input ports
   input            clk;
   wire             clk;
   input            rst;
   wire             rst;
   input     [ADDR_WIDTH - 1:0] rdPtr_gray;
   wire      [ADDR_WIDTH - 1:0] rdPtr_gray;
   input     [ADDR_WIDTH - 1:0] wrPtr_gray;
   wire      [ADDR_WIDTH - 1:0] wrPtr_gray;
   input     [ADDR_WIDTH - 1:0] nextrdPtr_gray;
   wire      [ADDR_WIDTH - 1:0] nextrdPtr_gray;
   input            readyForOut;
   wire             readyForOut;
//  output ports
   output           infoOutValid;
   wire             infoOutValid;
   output           fifoRe;
   wire             fifoRe;
//  local signals
   wire             ptrsEq_rdZone;
   wire             wrEqRdP1;
   reg              empty;
 
 
   always
      @( posedge clk or negedge rst )
   begin   :RdCtrl
 
      if (!rst)
      begin
         empty <= 1'b1;
      end
      else
      begin
         if (ptrsEq_rdZone)
         begin
         end
         else
         begin
            if (wrEqRdP1)
            begin
               if (fifoRe)
               begin
                  empty <= 1'b1;
               end
               else
               begin
                  empty <= 1'b0;
               end
            end
            else
            begin
               empty <= 1'b0;
            end
         end
      end
   end
 
   assign ptrsEq_rdZone = (rdPtr_gray == wrPtr_gray);
   assign wrEqRdP1 = (wrPtr_gray == nextrdPtr_gray);
 
   assign fifoRe = infoOutValid & readyForOut;
   assign infoOutValid = !empty;
 
 
endmodule

