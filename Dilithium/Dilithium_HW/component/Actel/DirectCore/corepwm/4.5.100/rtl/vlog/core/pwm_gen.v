/******************************************************************************

    File Name:  corepwm_pwm_gen.v
      Version:  4.0
         Date:  July 14th, 2009
  Description:  PWM Generation Module
  
  
  SVN Revision Information:
  SVN $Revision: 22653 $
  SVN $Date: 2014-05-19 15:37:07 +0530 (Mon, 19 May 2014) $  
  
  

 COPYRIGHT 2009 BY ACTEL 
 THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
 FROM ACTEL CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
 ACTEL FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
 NO BACK-UP OF THE FILE SHOULD BE MADE. 
 
FUNCTIONAL DESCRIPTION: 
Refer to the CorePWM Handbook.
******************************************************************************/
`timescale 1 ns / 1 ns // timescale for following modules

module corepwm_pwm_gen #(
parameter PWM_NUM = 8,
parameter APB_DWIDTH = 8,
parameter DAC_MODE = 0,
parameter SYNC_RESET = 0
) (
input  PRESETN, 
input  PCLK, 
output [PWM_NUM:1] PWM,
input [APB_DWIDTH-1:0] period_cnt,
input [PWM_NUM:1] pwm_enable_reg,
input [PWM_NUM*APB_DWIDTH:1] pwm_posedge_reg ,
input [PWM_NUM*APB_DWIDTH:1] pwm_negedge_reg ,
input sync_pulse
);

//reg declarations
reg [PWM_NUM:1] PWM_int;
reg [PWM_NUM*(APB_DWIDTH+1):1] acc;
//wire declarations
wire aresetn;
wire sresetn; 
//////main//////
assign PWM[PWM_NUM:1] = PWM_int[PWM_NUM:1];
assign aresetn = (SYNC_RESET==1) ? 1'b1 : PRESETN;
assign sresetn = (SYNC_RESET==1) ? PRESETN : 1'b1;
////separate but identical reg structure for each output
genvar z;
generate for (z=1; z<=PWM_NUM; z=z+1)
begin: PWM_output_generation
// PWM output generatzon
if (DAC_MODE[z-1]==0)
 begin
  always @(negedge aresetn or posedge PCLK)
  begin
   if ((!aresetn) || (!sresetn))
   begin
         PWM_int[z] <= 1'b0;  
   end
   else
   begin
     if (pwm_enable_reg[z] == 1'b0)
     begin
         PWM_int[z] <= 1'b0;
     end 
     else if ((pwm_enable_reg[z] == 1'b1) && (sync_pulse == 1'b1) )
     begin
       if ((pwm_posedge_reg[z*APB_DWIDTH:(z-1)*APB_DWIDTH + 1] == pwm_negedge_reg[z*APB_DWIDTH:(z-1)*APB_DWIDTH + 1]) && 
            ((pwm_posedge_reg[z*APB_DWIDTH:(z-1)*APB_DWIDTH + 1]) == period_cnt)) //toggle mode
       begin
         PWM_int[z] <= ~PWM_int[z];
       end
       else if ((pwm_enable_reg[z] == 1'b1) && (sync_pulse == 1'b1) && 
                (pwm_posedge_reg[z*APB_DWIDTH:(z-1)*APB_DWIDTH + 1]) == period_cnt)  //set PWM out to 1.
       begin
   	     PWM_int[z] <= 1'b1;   
       end
       else if ((pwm_enable_reg[z] == 1'b1) && (sync_pulse == 1'b1) &&
                (pwm_negedge_reg[z*APB_DWIDTH:(z-1)*APB_DWIDTH + 1]) == period_cnt)  //set PWM out to 0.
       begin
   	     PWM_int[z] <= 1'b0;   
	   end
	 end
   end
  end
 end
else
  begin
  always @(negedge aresetn or posedge PCLK)
  begin
   if ((!aresetn) || (!sresetn))
   begin
        acc[z*(APB_DWIDTH+1):(z-1)*(APB_DWIDTH + 1)+1] <= 0;
        PWM_int[z] <= 1'b0;  
   end
   else
   begin
     if (pwm_enable_reg[z] == 1'b0)
     begin
         PWM_int[z] <= 1'b0;
     end 
	 else if (pwm_enable_reg[z] == 1'b1)
	 begin
        acc[z*(APB_DWIDTH+1):(z-1)*(APB_DWIDTH + 1)+1] <= acc[(z*(APB_DWIDTH+1))-1:(z-1)*(APB_DWIDTH + 1)+1] + pwm_negedge_reg[z*APB_DWIDTH:(z-1)*APB_DWIDTH + 1];
        PWM_int[z] <= acc[z*(APB_DWIDTH+1)]; 
     end 
   end
  end
 end
end
endgenerate

endmodule



