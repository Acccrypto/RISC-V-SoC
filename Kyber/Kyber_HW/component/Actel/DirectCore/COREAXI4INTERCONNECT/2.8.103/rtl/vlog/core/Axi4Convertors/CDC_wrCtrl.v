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
 
 
module caxi4interconnect_CDC_wrCtrl (
                   //  input ports
                   clk,
                   rst,
                   rdPtr_gray,
                   wrPtr_gray,
                   nextwrPtr_gray,
                   infoInValid,
 
                   //  output ports
                   fifoWe,
                   readyForInfo
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
   input     [ADDR_WIDTH - 1:0] nextwrPtr_gray;
   wire      [ADDR_WIDTH - 1:0] nextwrPtr_gray;
   input            infoInValid;
   wire             infoInValid;
//  output ports
   output           fifoWe;
   wire             fifoWe;
   output           readyForInfo;
   wire             readyForInfo;
//  local signals
   wire             ptrsEq_wrZone;
   wire             rdEqWrP1;
   reg              full;
 
 
   always
      @( posedge clk or negedge rst )
   begin   :WrCtrl
 
      if (!rst)
      begin
         full <= 1'b0;
      end
      else
      begin
         if (ptrsEq_wrZone)
         begin
         end
         else
         begin
            if (rdEqWrP1)
            begin
               if (fifoWe)
               begin
                  full <= 1'b1;
               end
               else
               begin
                  full <= 1'b0;
               end
            end
            else
            begin
               full <= 1'b0;
            end
         end
      end
   end
 
   assign ptrsEq_wrZone = (rdPtr_gray == wrPtr_gray);
   assign rdEqWrP1 = (rdPtr_gray == nextwrPtr_gray);
 
   assign fifoWe = infoInValid & readyForInfo;
   assign readyForInfo = !full;
 
 
endmodule

