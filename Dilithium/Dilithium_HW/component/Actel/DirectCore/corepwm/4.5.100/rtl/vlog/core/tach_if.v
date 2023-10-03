/******************************************************************************

    File Name:  corepwm_tach_if.v
      Version:  4.0
         Date:  Jul 24th, 2009
  Description:  Tachometer Interface
  
  
  SVN Revision Information:
  SVN $Revision: 9212 $
  SVN $Date: 2009-07-24 15:32:50 -0700 (Fri, 24 Jul 2009) $  
  
  

 COPYRIGHT 2009 BY ACTEL 
 THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
 FROM ACTEL CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
 ACTEL FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
 NO BACK-UP OF THE FILE SHOULD BE MADE. 
 
FUNCTIONAL DESCRIPTION: 
Refer to the CorePWM Handbook.
******************************************************************************/
`timescale 1 ns / 1 ns // timescale for following modules

module corepwm_tach_if #(
parameter TACH_NUM = 1,
parameter SYNC_RESET = 0
)(
//microcontroller IF
input  PCLK,
input  PRESETN,
// TACH IF
input  TACHIN,
input  TACHMODE,
input TACH_EDGE,
input TACHSTATUS,
input  status_clear,
input  tach_cnt_clk,
output [15:0] TACHPULSEDUR,
output update_status
);

parameter cnt0 = 0;
parameter cnt1 = 1;

//wire declarations
wire aresetn;
wire sresetn; 

//reg declarations
reg [15:0] tach_cnt;
reg [15:0] tach_cnt_next;
reg tach_cnt_overflow;	 
reg tach_cnt_overflow_en;	 
reg [15:0] tach_cnt_store;	 
reg [15:0] tach_cnt_store_next;	 
reg update_status_next;	
reg present_state;	
reg next_state;	
reg tachin_edge_det;	
reg tachin_sync0;	
reg tachin_sync1;	
reg tachin_sync2;	
reg [15:0] TACHPULSEDUR_int;
reg update_status_int;

//////main//////
assign aresetn = (SYNC_RESET==1) ? 1'b1 : PRESETN;
assign sresetn = (SYNC_RESET==1) ? PRESETN : 1'b1;

// store tach pulse duration
always @(negedge aresetn or posedge PCLK)
 begin
   if ((!aresetn) || (!sresetn))
    begin
      TACHPULSEDUR_int <= 0; 
    end
   else
    begin
      TACHPULSEDUR_int <= tach_cnt_store;
    end
end

assign TACHPULSEDUR = TACHPULSEDUR_int;
assign update_status = update_status_int;

// generate tachin edge detect signal
always @(negedge aresetn or posedge PCLK)
 begin
   if ((!aresetn) || (!sresetn))
   begin
     tach_cnt <= 0;
     tach_cnt_store <= 0;
     tachin_sync0 <= 0;
     tachin_sync1 <= 0;
     tachin_sync2 <= 0;
     tachin_edge_det <= 0;
     tach_cnt_overflow <= 0;	 
     update_status_int <= 1'b0;
     present_state <= 1'b0;
   end
  else
   begin
     if (tach_cnt_clk == 1'b1)
      begin
        present_state <= next_state;
        tachin_sync0 <= TACHIN;
        tachin_sync1 <= tachin_sync0;
        tachin_sync2 <= tachin_sync1;
        tach_cnt_store <= tach_cnt_store_next;
        update_status_int <= update_status_next;
        tach_cnt <= tach_cnt_next;
	    if (tach_cnt_overflow_en == 1'b1)
          begin
            tach_cnt_overflow <= 1'b1;
          end
        else if (tachin_edge_det == 1'b1)
          begin
            tach_cnt_overflow <= 1'b0;
          end
         	   
        if(TACHMODE==0) 
		  begin
            if(TACH_EDGE==1 )
			  begin
                tachin_edge_det <= tachin_sync1 && !tachin_sync2 ;
              end
			else 
			  begin
                tachin_edge_det <= !tachin_sync1 && tachin_sync2 ;
              end
          end 
		else // TACHMODE=1
		  begin  
            if(TACHSTATUS==0) 
			  begin
                if(TACH_EDGE==1 )
				  begin
                    tachin_edge_det <= tachin_sync1 && !tachin_sync2 ;
                  end 
				else 
				  begin
                    tachin_edge_det <= !tachin_sync1 && tachin_sync2 ;
                  end
              end
          end
      end
   end
end

// State machine to generate tach counter
   always @(*)
     begin
       tach_cnt_store_next = tach_cnt_store;	 
       tach_cnt_next = 0;
       update_status_next = 1'b0;
       next_state = present_state;	
       tach_cnt_overflow_en = 0;	 
       case(present_state)
        cnt0:
          begin
            next_state = cnt0;	
            tach_cnt_overflow_en = 0;	 
            if (tachin_edge_det == 1'b1)   
             begin
   	       tach_cnt_next = 0;
               next_state = cnt1;	
             end
          end

        cnt1:     
          begin
            tach_cnt_store_next = tach_cnt_store;	 
	    update_status_next = 1'b0;
	    tach_cnt_overflow_en = 0;	 
            if (tachin_edge_det == 1'b1)   
             begin
   	       tach_cnt_next = 0;
	       tach_cnt_overflow_en = 0;	 
               if ((tach_cnt_overflow == 1) && (status_clear == 1'b1))
	        begin
	          tach_cnt_store_next = 0;	 
                end
	       else
	        begin
	          if ((TACHMODE == 1'b1) && (status_clear == 1'b1))
	           begin 
	             tach_cnt_store_next = tach_cnt + 1;
	           end
	          else if (TACHMODE == 1'b0)
	           begin 
                     if (tach_cnt_overflow == 1) 
	              begin 
	                tach_cnt_store_next = 0;
	              end
	             else
	              begin
	                tach_cnt_store_next = tach_cnt + 1;
	              end
	           end

                  if (status_clear == 1'b1 )
	           begin
	             update_status_next = 1'b1;
	           end	    
                end
             end
            else
             begin
               if (tach_cnt_overflow == 0)
	        begin
   	          tach_cnt_next = tach_cnt + 1;
                  if (tach_cnt == 65535)
	           begin
	             tach_cnt_overflow_en = 1;	 
                   end
                end
             end
           end
       endcase
     end


endmodule


