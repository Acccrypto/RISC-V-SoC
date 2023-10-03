/******************************************************************************

    File Name:  COREPWM.v
      Version:  4.0
         Date:  July 20th, 2009
  Description:  Top level module
  
  
  SVN Revision Information:
  SVN $Revision: 10267 $
  SVN $Date: 2009-10-15 16:42:37 -0700 (Thu, 15 Oct 2009) $  
  
  

 COPYRIGHT 2009 BY ACTEL 
 THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
 FROM ACTEL CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
 ACTEL FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
 NO BACK-UP OF THE FILE SHOULD BE MADE. 
 
FUNCTIONAL DESCRIPTION:  
Refer to the CorePWM Handbook.
******************************************************************************/
`timescale 1 ns / 1 ns // timescale for following modules

module corepwm #(
parameter FAMILY      = 0,		 // INTEGER range 0 to 25;	
parameter CONFIG_MODE = 0,           // 0=PWM only, 1=PWM and Tach; 2=Tach only;
parameter PWM_NUM = 1,
parameter APB_DWIDTH = 8,
parameter FIXED_PRESCALE_EN = 1,
parameter FIXED_PRESCALE = 8,
parameter FIXED_PERIOD_EN = 0,
parameter FIXED_PERIOD = 8,
parameter DAC_MODE1 = 0,
parameter DAC_MODE2 = 0,
parameter DAC_MODE3 = 0,
parameter DAC_MODE4 = 0,
parameter DAC_MODE5 = 0,
parameter DAC_MODE6 = 0,
parameter DAC_MODE7 = 0,
parameter DAC_MODE8 = 0,
parameter DAC_MODE9 = 0,
parameter DAC_MODE10 = 0,
parameter DAC_MODE11 = 0,
parameter DAC_MODE12 = 0,
parameter DAC_MODE13 = 0,
parameter DAC_MODE14 = 0,
parameter DAC_MODE15 = 0,
parameter DAC_MODE16 = 0,
parameter SHADOW_REG_EN1 = 0,
parameter SHADOW_REG_EN2 = 0,
parameter SHADOW_REG_EN3 = 0,
parameter SHADOW_REG_EN4 = 0,
parameter SHADOW_REG_EN5 = 0,
parameter SHADOW_REG_EN6 = 0,
parameter SHADOW_REG_EN7 = 0,
parameter SHADOW_REG_EN8 = 0,
parameter SHADOW_REG_EN9 = 0,
parameter SHADOW_REG_EN10 = 0,
parameter SHADOW_REG_EN11 = 0,
parameter SHADOW_REG_EN12 = 0,
parameter SHADOW_REG_EN13 = 0,
parameter SHADOW_REG_EN14 = 0,
parameter SHADOW_REG_EN15 = 0,
parameter SHADOW_REG_EN16 = 0,
parameter FIXED_PWM_POS_EN1 =  1,
parameter FIXED_PWM_POS_EN2 =  1,
parameter FIXED_PWM_POS_EN3 =  1,
parameter FIXED_PWM_POS_EN4 =  1,
parameter FIXED_PWM_POS_EN5 =  1,
parameter FIXED_PWM_POS_EN6 =  1,
parameter FIXED_PWM_POS_EN7 =  1,
parameter FIXED_PWM_POS_EN8 =  1,
parameter FIXED_PWM_POS_EN9 =  1,
parameter FIXED_PWM_POS_EN10 = 1,
parameter FIXED_PWM_POS_EN11 = 1,
parameter FIXED_PWM_POS_EN12 = 1,
parameter FIXED_PWM_POS_EN13 = 1,
parameter FIXED_PWM_POS_EN14 = 1,
parameter FIXED_PWM_POS_EN15 = 1,
parameter FIXED_PWM_POS_EN16 = 1,
parameter FIXED_PWM_POSEDGE1 =  0,
parameter FIXED_PWM_POSEDGE2 =  0,
parameter FIXED_PWM_POSEDGE3 =  0,
parameter FIXED_PWM_POSEDGE4 =  0,
parameter FIXED_PWM_POSEDGE5 =  0,
parameter FIXED_PWM_POSEDGE6 =  0,
parameter FIXED_PWM_POSEDGE7 =  0,
parameter FIXED_PWM_POSEDGE8 =  0,
parameter FIXED_PWM_POSEDGE9 =  0,
parameter FIXED_PWM_POSEDGE10 = 0,
parameter FIXED_PWM_POSEDGE11 = 0,
parameter FIXED_PWM_POSEDGE12 = 0,
parameter FIXED_PWM_POSEDGE13 = 0,
parameter FIXED_PWM_POSEDGE14 = 0,
parameter FIXED_PWM_POSEDGE15 = 0,
parameter FIXED_PWM_POSEDGE16 = 0,
parameter FIXED_PWM_NEG_EN1 =  0,
parameter FIXED_PWM_NEG_EN2 =  0,
parameter FIXED_PWM_NEG_EN3 =  0,
parameter FIXED_PWM_NEG_EN4 =  0,
parameter FIXED_PWM_NEG_EN5 =  0,
parameter FIXED_PWM_NEG_EN6 =  0,
parameter FIXED_PWM_NEG_EN7 =  0,
parameter FIXED_PWM_NEG_EN8 =  0,
parameter FIXED_PWM_NEG_EN9 =  0,
parameter FIXED_PWM_NEG_EN10 = 0,
parameter FIXED_PWM_NEG_EN11 = 0,
parameter FIXED_PWM_NEG_EN12 = 0,
parameter FIXED_PWM_NEG_EN13 = 0,
parameter FIXED_PWM_NEG_EN14 = 0,
parameter FIXED_PWM_NEG_EN15 = 0,
parameter FIXED_PWM_NEG_EN16 = 0,
parameter FIXED_PWM_NEGEDGE1 = 0,
parameter FIXED_PWM_NEGEDGE2 = 0,
parameter FIXED_PWM_NEGEDGE3 = 0,
parameter FIXED_PWM_NEGEDGE4 = 0,
parameter FIXED_PWM_NEGEDGE5 = 0,
parameter FIXED_PWM_NEGEDGE6 = 0,
parameter FIXED_PWM_NEGEDGE7 = 0,
parameter FIXED_PWM_NEGEDGE8 = 0,
parameter FIXED_PWM_NEGEDGE9 = 0,
parameter FIXED_PWM_NEGEDGE10 = 0,
parameter FIXED_PWM_NEGEDGE11 = 0,
parameter FIXED_PWM_NEGEDGE12 = 0,
parameter FIXED_PWM_NEGEDGE13 = 0,
parameter FIXED_PWM_NEGEDGE14 = 0,
parameter FIXED_PWM_NEGEDGE15 = 0,
parameter FIXED_PWM_NEGEDGE16 = 0,
parameter PWM_STRETCH_VALUE1 = 0,
parameter PWM_STRETCH_VALUE2 = 0,
parameter PWM_STRETCH_VALUE3 = 0,
parameter PWM_STRETCH_VALUE4 = 0,
parameter PWM_STRETCH_VALUE5 = 0,
parameter PWM_STRETCH_VALUE6 = 0,
parameter PWM_STRETCH_VALUE7 = 0,
parameter PWM_STRETCH_VALUE8 = 0,
parameter PWM_STRETCH_VALUE9 = 0,
parameter PWM_STRETCH_VALUE10 = 0,
parameter PWM_STRETCH_VALUE11 = 0,
parameter PWM_STRETCH_VALUE12 = 0,
parameter PWM_STRETCH_VALUE13 = 0,
parameter PWM_STRETCH_VALUE14 = 0,
parameter PWM_STRETCH_VALUE15 = 0,
parameter PWM_STRETCH_VALUE16 = 0,
parameter TACH_NUM = 1,
parameter TACH_EDGE1 = 0,
parameter TACH_EDGE2 = 0,
parameter TACH_EDGE3 = 0,
parameter TACH_EDGE4 = 0,
parameter TACH_EDGE5 = 0,
parameter TACH_EDGE6 = 0,
parameter TACH_EDGE7 = 0,
parameter TACH_EDGE8 = 0,
parameter TACH_EDGE9 = 0,
parameter TACH_EDGE10 = 0,
parameter TACH_EDGE11 = 0,
parameter TACH_EDGE12 = 0,
parameter TACH_EDGE13 = 0,
parameter TACH_EDGE14 = 0,
parameter TACH_EDGE15 = 0,
parameter TACH_EDGE16 = 0,
parameter TACHINT_ACT_LEVEL = 0,
parameter SEPARATE_PWM_CLK = 0
)
(
//system globals
input  PRESETN, 
input  PCLK, 
//microcontroller IF
input  PSEL,
input  PENABLE,
input  PWRITE,
input  [7:0] PADDR,
input  [APB_DWIDTH-1:0] PWDATA,
output [APB_DWIDTH-1:0] PRDATA,
output PREADY,
output PSLVERR,
// TACH IF
input [TACH_NUM-1:0] TACHIN,
output TACHINT,
//PWM IF
input PWM_CLK,
output [PWM_NUM:1] PWM
);


//wire declarations
wire [APB_DWIDTH-1:0] prescale_reg, period_reg, period_cnt; 
wire [PWM_NUM:1] pwm_enable_reg;
wire [PWM_NUM*APB_DWIDTH:1] pwm_posedge_reg, pwm_negedge_reg;
wire sync_pulse;
wire [PWM_NUM:1] PWM_int;
reg [15:0] PRDATA_TACH;
wire [PWM_NUM-1:0] PWM_STRETCH_VALUE_int; 
wire [TACH_NUM-1:0] TACH_EDGE; 
wire tachint_mask;
reg [3:0] TACHPRESCALE;
reg  [PWM_NUM-1:0] PWM_STRETCH;
reg [TACH_NUM-1:0] TACHIRQMASK;
reg [TACH_NUM-1:0] TACHMODE;
reg [TACH_NUM-1:0] TACHSTATUS;
reg [10:0] tach_prescale_cnt;   
reg [10:0] tach_prescale_value; 
reg [10:0] prescale_decode_value;   
reg       tach_cnt_clk;
wire [15:0] TACHPULSEDUR[TACH_NUM-1:0];
wire [TACH_NUM-1:0] update_status;
reg [TACH_NUM-1:0] status_clear;
wire [APB_DWIDTH-1:0] PRDATA_regif;
wire pwm_clk_int;
wire aresetn;
wire sresetn; 

//parameter declarations
parameter SYNC_RESET = (FAMILY == 25) ? 1 : 0;
parameter [15:0] all_ones = 16'hffff;

parameter [15:0] DAC_MODE =
(DAC_MODE16 << 15)|
(DAC_MODE15 << 14)|
(DAC_MODE14 << 13)|
(DAC_MODE13 << 12)|
(DAC_MODE12 << 11)|
(DAC_MODE11 << 10)|
(DAC_MODE10 <<  9)|
(DAC_MODE9  <<  8)|
(DAC_MODE8  <<  7)|
(DAC_MODE7  <<  6)|
(DAC_MODE6  <<  5)|
(DAC_MODE5  <<  4)|
(DAC_MODE4  <<  3)|
(DAC_MODE3  <<  2)|
(DAC_MODE2  <<  1)|
(DAC_MODE1  <<  0)
;
parameter [15:0] SHADOW_REG_EN =
(SHADOW_REG_EN16 << 15)|
(SHADOW_REG_EN15 << 14)|
(SHADOW_REG_EN14 << 13)|
(SHADOW_REG_EN13 << 12)|
(SHADOW_REG_EN12 << 11)|
(SHADOW_REG_EN11 << 10)|
(SHADOW_REG_EN10 <<  9)|
(SHADOW_REG_EN9  <<  8)|
(SHADOW_REG_EN8  <<  7)|
(SHADOW_REG_EN7  <<  6)|
(SHADOW_REG_EN6  <<  5)|
(SHADOW_REG_EN5  <<  4)|
(SHADOW_REG_EN4  <<  3)|
(SHADOW_REG_EN3  <<  2)|
(SHADOW_REG_EN2  <<  1)|
(SHADOW_REG_EN1  <<  0)
;
parameter [15:0] FIXED_PWM_POS_EN =
(FIXED_PWM_POS_EN16 << 15)|
(FIXED_PWM_POS_EN15 << 14)|
(FIXED_PWM_POS_EN14 << 13)|
(FIXED_PWM_POS_EN13 << 12)|
(FIXED_PWM_POS_EN12 << 11)|
(FIXED_PWM_POS_EN11 << 10)|
(FIXED_PWM_POS_EN10 <<  9)|
(FIXED_PWM_POS_EN9  <<  8)|
(FIXED_PWM_POS_EN8  <<  7)|
(FIXED_PWM_POS_EN7  <<  6)|
(FIXED_PWM_POS_EN6  <<  5)|
(FIXED_PWM_POS_EN5  <<  4)|
(FIXED_PWM_POS_EN4  <<  3)|
(FIXED_PWM_POS_EN3  <<  2)|
(FIXED_PWM_POS_EN2  <<  1)|
(FIXED_PWM_POS_EN1  <<  0)
;
parameter [15:0] FIXED_PWM_NEG_EN =
(FIXED_PWM_NEG_EN16 << 15)|
(FIXED_PWM_NEG_EN15 << 14)|
(FIXED_PWM_NEG_EN14 << 13)|
(FIXED_PWM_NEG_EN13 << 12)|
(FIXED_PWM_NEG_EN12 << 11)|
(FIXED_PWM_NEG_EN11 << 10)|
(FIXED_PWM_NEG_EN10 <<  9)|
(FIXED_PWM_NEG_EN9  <<  8)|
(FIXED_PWM_NEG_EN8  <<  7)|
(FIXED_PWM_NEG_EN7  <<  6)|
(FIXED_PWM_NEG_EN6  <<  5)|
(FIXED_PWM_NEG_EN5  <<  4)|
(FIXED_PWM_NEG_EN4  <<  3)|
(FIXED_PWM_NEG_EN3  <<  2)|
(FIXED_PWM_NEG_EN2  <<  1)|
(FIXED_PWM_NEG_EN1  <<  0)
;

parameter [16*APB_DWIDTH-1:0] FIXED_PWM_POSEDGE =
{FIXED_PWM_POSEDGE16[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE15[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE14[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE13[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE12[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE11[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE10[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE9[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE8[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE7[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE6[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE5[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE4[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE3[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE2[APB_DWIDTH-1:0] ,
 FIXED_PWM_POSEDGE1[APB_DWIDTH-1:0] }
;
parameter [16*APB_DWIDTH-1:0] FIXED_PWM_NEGEDGE =
{FIXED_PWM_NEGEDGE16[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE15[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE14[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE13[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE12[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE11[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE10[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE9[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE8[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE7[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE6[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE5[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE4[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE3[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE2[APB_DWIDTH-1:0] ,
 FIXED_PWM_NEGEDGE1[APB_DWIDTH-1:0] }
;
// 
assign aresetn = (SYNC_RESET==1) ? 1'b1 : PRESETN;
assign sresetn = (SYNC_RESET==1) ? PRESETN : 1'b1;
 
generate 
if(SEPARATE_PWM_CLK == 1)
  begin
    assign pwm_clk_int = PWM_CLK;
  end
else
  begin
    assign pwm_clk_int = PCLK;
  end
endgenerate

generate if (CONFIG_MODE > 0) 
begin: tach_misc
// APB write to tach prescale
always @(negedge aresetn or posedge PCLK)
 begin
   if ((!aresetn) || (!sresetn))
   begin
         TACHPRESCALE   <= 0; 
   end
   else
   begin
     if ((PSEL == 1'b1) && (PWRITE ==1'b1) && (PENABLE ==1'b1))
     begin
	 case (PADDR[7:2])
	 37:  TACHPRESCALE    <= PWDATA[3:0];
	 endcase
     end
   end
 end

// APB write to PWM_STRETCH, TACHIRQMASK and TACHMODE
always @(negedge aresetn or posedge PCLK)
 begin
   if ((!aresetn) || (!sresetn))
   begin
         TACHIRQMASK  <= 0; 
         PWM_STRETCH <= 0; 
         TACHMODE <= 0; 
   end
   else
   begin
     if ((PSEL == 1'b1) && (PWRITE ==1'b1) && (PENABLE ==1'b1))
     begin
	 case (PADDR[7:2])
	 36:  PWM_STRETCH  <= PWDATA[PWM_NUM-1:0];
	 39:  TACHIRQMASK   <= PWDATA[TACH_NUM-1:0];
	 40:  TACHMODE   <= PWDATA[TACH_NUM-1:0];
	 endcase
     end
   end
end

// Preload value
// decode tach_prescale value
always @ (*) 
  begin
    case (TACHPRESCALE)
      4'b0000:  prescale_decode_value = 0;
      4'b0001:  prescale_decode_value = 1;
      4'b0010:  prescale_decode_value = 3;
      4'b0011:  prescale_decode_value = 7;
      4'b0100:  prescale_decode_value = 15;
      4'b0101:  prescale_decode_value = 31;
      4'b0110:  prescale_decode_value = 63;
      4'b0111:  prescale_decode_value = 127;
      4'b1000:  prescale_decode_value = 255;
      4'b1001:  prescale_decode_value = 511;
      4'b1010:  prescale_decode_value = 1023;
      4'b1011:  prescale_decode_value = 2047;
      default:prescale_decode_value = 2047;
    endcase 
  end

// generate tach_prescale_cnt and tach_cnt_clk
always @(negedge aresetn or posedge PCLK)
 begin
   if ((!aresetn) || (!sresetn))
   begin
     tach_prescale_cnt <= 0;
     tach_prescale_value <= 0;
     tach_cnt_clk <= 0;
   end
   else
   begin
     if (tach_prescale_cnt >= tach_prescale_value)  //reset tach_prescale_cnt
      begin
   	tach_prescale_cnt <= 0;   
   	tach_prescale_value <= prescale_decode_value;   
        tach_cnt_clk <= 1;
      end
     else 
      begin
   	tach_prescale_cnt <= tach_prescale_cnt + 1;   
        tach_cnt_clk <= 0;
      end
   end
end
end // tach_misc
endgenerate

// Update STATUS register
genvar x;
// Write process parameter-based addresses
generate for (x=0; x<=(TACH_NUM-1); x=x+1)
begin: gen_tachstatus
always @(negedge aresetn or posedge PCLK)
 begin
   if ((!aresetn) || (!sresetn))
    begin
      TACHSTATUS[x] <= 0; 
      status_clear[x] <= 1'b1;
    end
   else
    begin
     if ((PSEL == 1'b1) && (PWRITE ==1'b1) && (PENABLE ==1'b1) && (PADDR[7:2] == 6'h26))
      begin
        if (PWDATA[x] == 1'b1)
         begin
           TACHSTATUS[x]   <= 1'b0;
	   status_clear[x] <= 1'b1;
	 end
      end
     else
      begin
	if (update_status[x] == 1'b1)
         begin
           TACHSTATUS[x]   <= 1'b1;
	   status_clear[x] <= 1'b0;
	 end
      end
    end
end
end
endgenerate



generate if (CONFIG_MODE > 0) 
begin: tach_int
assign TACHINT = TACHINT_ACT_LEVEL ? (tachint_mask) : !(tachint_mask);
end
endgenerate

// Flatten PWM_STRETCH to create PWM_STRETCH arrary 

generate if ((PWM_NUM>0) && (CONFIG_MODE > 0) )
begin: tach_out_0
  assign PWM_STRETCH_VALUE_int[0] = PWM_STRETCH_VALUE1;  
end
endgenerate
generate if ((PWM_NUM>1) && (CONFIG_MODE > 0) )
begin: tach_out_1
  assign PWM_STRETCH_VALUE_int[1] = PWM_STRETCH_VALUE2;  
end
endgenerate
generate if ((PWM_NUM>2) && (CONFIG_MODE > 0) )
begin: tach_out_2
  assign PWM_STRETCH_VALUE_int[2] = PWM_STRETCH_VALUE3;  
end
endgenerate
generate if ((PWM_NUM>3) && (CONFIG_MODE > 0) )
begin: tach_out_3
  assign PWM_STRETCH_VALUE_int[3] = PWM_STRETCH_VALUE4;  
end
endgenerate
generate if ((PWM_NUM>4) && (CONFIG_MODE > 0) )
begin: tach_out_4
  assign PWM_STRETCH_VALUE_int[4] = PWM_STRETCH_VALUE5;  
end
endgenerate
generate if ((PWM_NUM>5) && (CONFIG_MODE > 0) )
begin: tach_out_5
  assign PWM_STRETCH_VALUE_int[5] = PWM_STRETCH_VALUE6;  
end
endgenerate
generate if ((PWM_NUM>6) && (CONFIG_MODE > 0) )
begin: tach_out_6
  assign PWM_STRETCH_VALUE_int[6] = PWM_STRETCH_VALUE7;  
end
endgenerate
generate if ((PWM_NUM>7) && (CONFIG_MODE > 0) )
begin: tach_out_7
  assign PWM_STRETCH_VALUE_int[7] = PWM_STRETCH_VALUE8;  
end
endgenerate
generate if ((PWM_NUM>8) && (CONFIG_MODE > 0) )
begin: tach_out_8
  assign PWM_STRETCH_VALUE_int[8] = PWM_STRETCH_VALUE9;  
end
endgenerate
generate if ((PWM_NUM>9) && (CONFIG_MODE > 0) )
begin: tach_out_9
  assign PWM_STRETCH_VALUE_int[9] = PWM_STRETCH_VALUE10;  
end
endgenerate
generate if ((PWM_NUM>10) && (CONFIG_MODE > 0) )
begin: tach_out_10
  assign PWM_STRETCH_VALUE_int[10] = PWM_STRETCH_VALUE11;  
end
endgenerate
generate if ((PWM_NUM>11) && (CONFIG_MODE > 0) )
begin: tach_out_11
  assign PWM_STRETCH_VALUE_int[11] = PWM_STRETCH_VALUE12;  
end
endgenerate
generate if ((PWM_NUM>12) && (CONFIG_MODE > 0) )
begin: tach_out_12
  assign PWM_STRETCH_VALUE_int[12] = PWM_STRETCH_VALUE13;  
end
endgenerate
generate if ((PWM_NUM>13) && (CONFIG_MODE > 0) )
begin: tach_out_13
  assign PWM_STRETCH_VALUE_int[13] = PWM_STRETCH_VALUE14;  
end
endgenerate
generate if ((PWM_NUM>14) && (CONFIG_MODE > 0) )
begin: tach_out_14
  assign PWM_STRETCH_VALUE_int[14] = PWM_STRETCH_VALUE15;  
end
endgenerate
generate if ((PWM_NUM>15) && (CONFIG_MODE > 0) )
begin: tach_out_15
  assign PWM_STRETCH_VALUE_int[15] = PWM_STRETCH_VALUE16;  
end
endgenerate

// concatenate PWM_STRETCH_VALUE and tach mask interrupt
generate if ((TACH_NUM==1) && (CONFIG_MODE > 0) )
begin: tach_int_0
  assign TACH_EDGE = {TACH_EDGE1[0]}; 
// Mask interrupt
  assign tachint_mask =  ( TACHSTATUS[0] & TACHIRQMASK[0]) ;  
end
endgenerate
generate if ((TACH_NUM==2) && (CONFIG_MODE > 0) )
begin: tach_int_1
  assign TACH_EDGE = {TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;  
end
endgenerate
generate if ((TACH_NUM==3) && (CONFIG_MODE > 0) )
begin: tach_int_2
  assign TACH_EDGE = {TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;   
end
endgenerate
generate if ((TACH_NUM==4) && (CONFIG_MODE > 0) )
begin: tach_int_3
  assign TACH_EDGE = {TACH_EDGE4[0], TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  (  (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;  
end
endgenerate
generate if ((TACH_NUM==5) && (CONFIG_MODE > 0) )
begin: tach_int_4
  assign TACH_EDGE = {TACH_EDGE5[0], TACH_EDGE4[0], TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;  
end
endgenerate
generate if ((TACH_NUM==6) && (CONFIG_MODE > 0) )
begin: tach_int_5
  assign TACH_EDGE = {TACH_EDGE6[0], TACH_EDGE5[0], TACH_EDGE4[0], 
                      TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;  
end
endgenerate
generate if ((TACH_NUM==7) && (CONFIG_MODE > 0) )
begin: tach_int_6
  assign TACH_EDGE = {TACH_EDGE7[0], TACH_EDGE6[0], TACH_EDGE5[0], TACH_EDGE4[0], 
                      TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  
  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;   
end
endgenerate
generate if ((TACH_NUM==8) && (CONFIG_MODE > 0) )
begin: tach_int_7
  assign TACH_EDGE = {TACH_EDGE8[0], TACH_EDGE7[0], TACH_EDGE6[0], TACH_EDGE5[0], 
                      TACH_EDGE4[0], TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  
  // Mask interrupt
  assign tachint_mask =  (  (TACHSTATUS[7] & TACHIRQMASK[7]) | (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;     
end
endgenerate
generate if ((TACH_NUM==9) && (CONFIG_MODE > 0) )
begin: tach_int_8
  assign TACH_EDGE = {TACH_EDGE9[0], TACH_EDGE8[0], TACH_EDGE7[0], TACH_EDGE6[0], TACH_EDGE5[0], 
                      TACH_EDGE4[0], TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[8] & TACHIRQMASK[8]) | 
			 (TACHSTATUS[7] & TACHIRQMASK[7]) | (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;   
end
endgenerate
generate if ((TACH_NUM==10) && (CONFIG_MODE > 0) )
begin: tach_int_9
  assign TACH_EDGE = {TACH_EDGE10[0], TACH_EDGE9[0], TACH_EDGE8[0], TACH_EDGE7[0], TACH_EDGE6[0], 
                       TACH_EDGE5[0], TACH_EDGE4[0], TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[9] & TACHIRQMASK[9]) | (TACHSTATUS[8] & TACHIRQMASK[8]) | 
			 (TACHSTATUS[7] & TACHIRQMASK[7]) | (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;  
end
endgenerate
generate if ((TACH_NUM==11) && (CONFIG_MODE > 0) )
begin: tach_int_10
  assign TACH_EDGE = {TACH_EDGE11[0], TACH_EDGE10[0], TACH_EDGE9[0], TACH_EDGE8[0], TACH_EDGE7[0], TACH_EDGE6[0], 
                       TACH_EDGE5[0],  TACH_EDGE4[0], TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  (   (TACHSTATUS[10] & TACHIRQMASK[10]) | 
			 (TACHSTATUS[9] & TACHIRQMASK[9]) | (TACHSTATUS[8] & TACHIRQMASK[8]) | 
			 (TACHSTATUS[7] & TACHIRQMASK[7]) | (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;      
end
endgenerate
generate if ((TACH_NUM==12) && (CONFIG_MODE > 0) )
begin: tach_int_11
  assign TACH_EDGE = {TACH_EDGE12[0], TACH_EDGE11[0], TACH_EDGE10[0], TACH_EDGE9[0], TACH_EDGE8[0], TACH_EDGE7[0], 
                       TACH_EDGE6[0],  TACH_EDGE5[0],  TACH_EDGE4[0], TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  (  (TACHSTATUS[11] & TACHIRQMASK[11]) | (TACHSTATUS[10] & TACHIRQMASK[10]) | 
			 (TACHSTATUS[9] & TACHIRQMASK[9]) | (TACHSTATUS[8] & TACHIRQMASK[8]) | 
			 (TACHSTATUS[7] & TACHIRQMASK[7]) | (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;    
end
endgenerate
generate if ((TACH_NUM==13) && (CONFIG_MODE > 0) )
begin: tach_int_12
  assign TACH_EDGE = {TACH_EDGE13[0], TACH_EDGE12[0], TACH_EDGE11[0], TACH_EDGE10[0], TACH_EDGE9[0], TACH_EDGE8[0], TACH_EDGE7[0], 
                       TACH_EDGE6[0],  TACH_EDGE5[0],  TACH_EDGE4[0],  TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[12] & TACHIRQMASK[12]) | 
			 (TACHSTATUS[11] & TACHIRQMASK[11]) | (TACHSTATUS[10] & TACHIRQMASK[10]) | 
			 (TACHSTATUS[9] & TACHIRQMASK[9]) | (TACHSTATUS[8] & TACHIRQMASK[8]) | 
			 (TACHSTATUS[7] & TACHIRQMASK[7]) | (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;     
end
endgenerate
generate if ((TACH_NUM==14) && (CONFIG_MODE > 0) )
begin: tach_int_13
  assign TACH_EDGE = {TACH_EDGE14[0], TACH_EDGE13[0], TACH_EDGE12[0], TACH_EDGE11[0], TACH_EDGE10[0], TACH_EDGE9[0], TACH_EDGE8[0], 
                       TACH_EDGE7[0],  TACH_EDGE6[0],  TACH_EDGE5[0],  TACH_EDGE4[0],  TACH_EDGE3[0], TACH_EDGE2[0], TACH_EDGE1[0]}; 
  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[13] & TACHIRQMASK[13]) | (TACHSTATUS[12] & TACHIRQMASK[12]) | 
			 (TACHSTATUS[11] & TACHIRQMASK[11]) | (TACHSTATUS[10] & TACHIRQMASK[10]) | 
			 (TACHSTATUS[9] & TACHIRQMASK[9]) | (TACHSTATUS[8] & TACHIRQMASK[8]) | 
			 (TACHSTATUS[7] & TACHIRQMASK[7]) | (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;    
end
endgenerate
generate if ((TACH_NUM==15) && (CONFIG_MODE > 0) )
begin: tach_int_14
  assign TACH_EDGE = {TACH_EDGE15[0], TACH_EDGE14[0], TACH_EDGE13[0], TACH_EDGE12[0], TACH_EDGE11[0], TACH_EDGE10[0], TACH_EDGE9[0], TACH_EDGE8[0],  
                       TACH_EDGE7[0],  TACH_EDGE6[0],  TACH_EDGE5[0],  TACH_EDGE4[0],  TACH_EDGE3[0],  TACH_EDGE2[0], TACH_EDGE1[0]};

  // Mask interrupt
  assign tachint_mask =  ( (TACHSTATUS[14] & TACHIRQMASK[14]) | 
	                 (TACHSTATUS[13] & TACHIRQMASK[13]) | (TACHSTATUS[12] & TACHIRQMASK[12]) | 
			 (TACHSTATUS[11] & TACHIRQMASK[11]) | (TACHSTATUS[10] & TACHIRQMASK[10]) | 
			 (TACHSTATUS[9] & TACHIRQMASK[9]) | (TACHSTATUS[8] & TACHIRQMASK[8]) | 
			 (TACHSTATUS[7] & TACHIRQMASK[7]) | (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;  
end
endgenerate
generate if ((TACH_NUM==16) && (CONFIG_MODE > 0) )
begin: tach_int_15
  assign TACH_EDGE = {TACH_EDGE16[0], TACH_EDGE15[0], TACH_EDGE14[0], TACH_EDGE13[0], TACH_EDGE12[0], TACH_EDGE11[0], TACH_EDGE10[0], TACH_EDGE9[0], 
                       TACH_EDGE8[0],  TACH_EDGE7[0],  TACH_EDGE6[0],  TACH_EDGE5[0],  TACH_EDGE4[0],  TACH_EDGE3[0],  TACH_EDGE2[0], TACH_EDGE1[0]};
  // Mask interrupt
  assign tachint_mask =  ((TACHSTATUS[15] & TACHIRQMASK[15]) | (TACHSTATUS[14] & TACHIRQMASK[14]) | 
	                 (TACHSTATUS[13] & TACHIRQMASK[13]) | (TACHSTATUS[12] & TACHIRQMASK[12]) | 
			 (TACHSTATUS[11] & TACHIRQMASK[11]) | (TACHSTATUS[10] & TACHIRQMASK[10]) | 
			 (TACHSTATUS[9] & TACHIRQMASK[9]) | (TACHSTATUS[8] & TACHIRQMASK[8]) | 
			 (TACHSTATUS[7] & TACHIRQMASK[7]) | (TACHSTATUS[6] & TACHIRQMASK[6]) | 
			 (TACHSTATUS[5] & TACHIRQMASK[5]) | (TACHSTATUS[4] & TACHIRQMASK[4]) | 
			 (TACHSTATUS[3] & TACHIRQMASK[3]) | (TACHSTATUS[2] & TACHIRQMASK[2]) | 
			 (TACHSTATUS[1] & TACHIRQMASK[1] | TACHSTATUS[0] & TACHIRQMASK[0])) ;  
end
endgenerate




// APB Data read mux
generate if ((TACH_NUM==1) && (CONFIG_MODE > 0))
begin: prdata_rd_mux1
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==2) && (CONFIG_MODE > 0))
begin: prdata_rd_mux2
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==3) && (CONFIG_MODE > 0))
begin: prdata_rd_mux3
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==4) && (CONFIG_MODE > 0))
begin: prdata_rd_mux4
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==5) && (CONFIG_MODE > 0))
begin: prdata_rd_mux5
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==6) && (CONFIG_MODE > 0))
begin: prdata_rd_mux6
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==7) && (CONFIG_MODE > 0))
begin: prdata_rd_mux7
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate


generate if ((TACH_NUM==8) && (CONFIG_MODE > 0))
begin: prdata_rd_mux8
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 6'h30:  PRDATA_TACH = TACHPULSEDUR[7];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==9) && (CONFIG_MODE > 0))
begin: prdata_rd_mux9
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 6'h30:  PRDATA_TACH = TACHPULSEDUR[7];  
	 6'h31:  PRDATA_TACH = TACHPULSEDUR[8];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==10) && (CONFIG_MODE > 0))
begin: prdata_rd_mux10
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 6'h30:  PRDATA_TACH = TACHPULSEDUR[7];  
	 6'h31:  PRDATA_TACH = TACHPULSEDUR[8];  
	 6'h32:  PRDATA_TACH = TACHPULSEDUR[9];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==11) && (CONFIG_MODE > 0))
begin: prdata_rd_mux11
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 6'h30:  PRDATA_TACH = TACHPULSEDUR[7];  
	 6'h31:  PRDATA_TACH = TACHPULSEDUR[8];  
	 6'h32:  PRDATA_TACH = TACHPULSEDUR[9];  
	 6'h33:  PRDATA_TACH = TACHPULSEDUR[10];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==12) && (CONFIG_MODE > 0))
begin: prdata_rd_mux12
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 6'h30:  PRDATA_TACH = TACHPULSEDUR[7];  
	 6'h31:  PRDATA_TACH = TACHPULSEDUR[8];  
	 6'h32:  PRDATA_TACH = TACHPULSEDUR[9];  
	 6'h33:  PRDATA_TACH = TACHPULSEDUR[10];  
	 6'h34:  PRDATA_TACH = TACHPULSEDUR[11];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==13) && (CONFIG_MODE > 0))
begin: prdata_rd_mux13
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 6'h30:  PRDATA_TACH = TACHPULSEDUR[7];  
	 6'h31:  PRDATA_TACH = TACHPULSEDUR[8];  
	 6'h32:  PRDATA_TACH = TACHPULSEDUR[9];  
	 6'h33:  PRDATA_TACH = TACHPULSEDUR[10];  
	 6'h34:  PRDATA_TACH = TACHPULSEDUR[11];  
	 6'h35:  PRDATA_TACH = TACHPULSEDUR[12];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==14) && (CONFIG_MODE > 0))
begin: prdata_rd_mux14
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 6'h30:  PRDATA_TACH = TACHPULSEDUR[7];  
	 6'h31:  PRDATA_TACH = TACHPULSEDUR[8];  
	 6'h32:  PRDATA_TACH = TACHPULSEDUR[9];  
	 6'h33:  PRDATA_TACH = TACHPULSEDUR[10];  
	 6'h34:  PRDATA_TACH = TACHPULSEDUR[11];  
	 6'h35:  PRDATA_TACH = TACHPULSEDUR[12];  
	 6'h36:  PRDATA_TACH = TACHPULSEDUR[13];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate


generate if ((TACH_NUM==15) && (CONFIG_MODE > 0))
begin: prdata_rd_mux15
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 6'h30:  PRDATA_TACH = TACHPULSEDUR[7];  
	 6'h31:  PRDATA_TACH = TACHPULSEDUR[8];  
	 6'h32:  PRDATA_TACH = TACHPULSEDUR[9];  
	 6'h33:  PRDATA_TACH = TACHPULSEDUR[10];  
	 6'h34:  PRDATA_TACH = TACHPULSEDUR[11];  
	 6'h35:  PRDATA_TACH = TACHPULSEDUR[12];  
	 6'h36:  PRDATA_TACH = TACHPULSEDUR[13];  
	 6'h37:  PRDATA_TACH = TACHPULSEDUR[14];  
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate

generate if ((TACH_NUM==16) && (CONFIG_MODE > 0))
begin: prdata_rd_mux16
  always @*
  begin
	 case (PADDR[7:2])
	 6'h25:  PRDATA_TACH = TACHPRESCALE[3:0]; 
	 6'h26:  PRDATA_TACH = TACHSTATUS[TACH_NUM-1:0];  
	 6'h27:  PRDATA_TACH = TACHIRQMASK[TACH_NUM-1:0];  
	 6'h28:  PRDATA_TACH = TACHMODE[TACH_NUM-1:0];  
	 6'h29:  PRDATA_TACH = TACHPULSEDUR[0];  
	 6'h2a:  PRDATA_TACH = TACHPULSEDUR[1]; 
	 6'h2b:  PRDATA_TACH = TACHPULSEDUR[2];  
	 6'h2c:  PRDATA_TACH = TACHPULSEDUR[3];  
	 6'h2d:  PRDATA_TACH = TACHPULSEDUR[4];  
	 6'h2e:  PRDATA_TACH = TACHPULSEDUR[5];  
	 6'h2f:  PRDATA_TACH = TACHPULSEDUR[6];  
	 6'h30:  PRDATA_TACH = TACHPULSEDUR[7];  
	 6'h31:  PRDATA_TACH = TACHPULSEDUR[8];  
	 6'h32:  PRDATA_TACH = TACHPULSEDUR[9];  
	 6'h33:  PRDATA_TACH = TACHPULSEDUR[10];  
	 6'h34:  PRDATA_TACH = TACHPULSEDUR[11];  
	 6'h35:  PRDATA_TACH = TACHPULSEDUR[12];  
	 6'h36:  PRDATA_TACH = TACHPULSEDUR[13];  
	 6'h37:  PRDATA_TACH = TACHPULSEDUR[14];  
	 6'h38:  PRDATA_TACH = TACHPULSEDUR[15];
	 default:PRDATA_TACH = 0;
	 endcase 
  end
end
endgenerate


// APB Read data
generate
 if (APB_DWIDTH == 32) 
  begin
    assign PRDATA = ((PADDR[7:2] <= 6'h24) || (PADDR[7:2] == 6'h39)) ? PRDATA_regif:{16'b0,PRDATA_TACH[15:0]};
  end
 else if (APB_DWIDTH == 16)
  begin
    assign PRDATA = ((PADDR[7:2] <= 6'h24) || (PADDR[7:2] == 6'h39)) ? PRDATA_regif:PRDATA_TACH[15:0];
  end
 else 
  begin
    assign PRDATA = PRDATA_regif;
  end
endgenerate

// force PWM output based on PWM_STRETCH
genvar l;
// Write process parameter-based addresses
generate for (l=1; l<=(PWM_NUM); l=l+1)
begin: pwm_out_mux
if (CONFIG_MODE==0)
 begin
  assign	 PWM[l] = PWM_int[l];
 end
else if (CONFIG_MODE==1)
 begin
  assign	 PWM[l] = PWM_STRETCH[l-1] ? PWM_STRETCH_VALUE_int[l-1] : PWM_int[l];
 end
end
endgenerate

//sub-module instantiations
generate
if (CONFIG_MODE < 2) 
begin
corepwm_reg_if #( .PWM_NUM(PWM_NUM),
                  .APB_DWIDTH(APB_DWIDTH),
                  .FIXED_PRESCALE_EN(FIXED_PRESCALE_EN),
                  .FIXED_PRESCALE(FIXED_PRESCALE),
                  .FIXED_PERIOD_EN(FIXED_PERIOD_EN),
                  .FIXED_PERIOD(FIXED_PERIOD),
                  .DAC_MODE(DAC_MODE),
                  .SHADOW_REG_EN(SHADOW_REG_EN),
                  .FIXED_PWM_POS_EN(FIXED_PWM_POS_EN),
                  .FIXED_PWM_POSEDGE(FIXED_PWM_POSEDGE),
                  .FIXED_PWM_NEG_EN(FIXED_PWM_NEG_EN),
                  .FIXED_PWM_NEGEDGE(FIXED_PWM_NEGEDGE),
                  .SYNC_RESET(SYNC_RESET)
                 ) corepwm_reg_if ( .PCLK (PCLK),
                                    .PRESETN (PRESETN),
                                    .PSEL (PSEL),
                                    .PENABLE (PENABLE),
                                    .PWRITE (PWRITE),
                                    .PADDR (PADDR[7:2]),
                                    .PWDATA (PWDATA),
                                    .PWM_STRETCH (PWM_STRETCH),
                                    .PRDATA_regif (PRDATA_regif), 
                                    .pwm_posedge_out_wire (pwm_posedge_reg ),
                                    .pwm_negedge_out_wire (pwm_negedge_reg ),
                                    .prescale_out_wire (prescale_reg),
                                    .period_out_wire (period_reg),
                                    .period_cnt (period_cnt),
                                    .pwm_enable_out_wire (pwm_enable_reg),
                                    .sync_pulse (sync_pulse)
); 
end
endgenerate

genvar t;
generate
if ((CONFIG_MODE > 0) && ( APB_DWIDTH > 15))
for (t=0; t<=(TACH_NUM-1); t=t+1)
begin: tach_interface
corepwm_tach_if #( .TACH_NUM(TACH_NUM),
                   .SYNC_RESET(SYNC_RESET)
                  ) corepwm_tach_if (//microcontroller IF
                                      .PCLK(PCLK),
                                      .PRESETN(PRESETN),
                                     // TACH IF
                                      .TACHSTATUS(TACHSTATUS[t]),
                                      .TACH_EDGE(TACH_EDGE[t]), 
                                      .TACHIN(TACHIN[t]),
                                      .TACHMODE(TACHMODE[t]),
                                      .status_clear(status_clear[t]),
                                      .tach_cnt_clk(tach_cnt_clk),  
                                      .TACHPULSEDUR(TACHPULSEDUR[t]),  
                                      .update_status(update_status[t])
);
end
endgenerate

// APB Ready and Slave Error signals
assign PREADY = 1'b1;
assign PSLVERR = 1'b0;

generate
if ((SHADOW_REG_EN[PWM_NUM - 1:0]==0) && (DAC_MODE[PWM_NUM - 1:0] == all_ones[PWM_NUM - 1:0]) 
//	&& ((FAMILY != 12) && (FAMILY != 13)) 
)
begin 
assign period_cnt = 0;
assign sync_pulse = 0;
end
else
begin
if (CONFIG_MODE < 2)
begin
corepwm_timebase #( .APB_DWIDTH(APB_DWIDTH), 
                    .SYNC_RESET(SYNC_RESET)
                   ) corepwm_timebase ( .PCLK (pwm_clk_int),
                                        .PRESETN (PRESETN),
                                        .prescale_reg (prescale_reg),
                                        .period_reg (period_reg),
                                        .period_cnt (period_cnt),
                                        .sync_pulse (sync_pulse)
);
end
end
endgenerate

generate
if (CONFIG_MODE < 2) 
begin
corepwm_pwm_gen #( .PWM_NUM(PWM_NUM),
                   .APB_DWIDTH(APB_DWIDTH),
                   .DAC_MODE(DAC_MODE),
                   .SYNC_RESET(SYNC_RESET)
                  ) corepwm_pwm_gen ( .PCLK (pwm_clk_int),
                                      .PRESETN (PRESETN),
                                      .PWM (PWM_int),
                                      .period_cnt (period_cnt),
                                      .pwm_enable_reg (pwm_enable_reg),
                                      .pwm_posedge_reg (pwm_posedge_reg ),
                                      .pwm_negedge_reg (pwm_negedge_reg ),
                                      .sync_pulse (sync_pulse)
);
end
endgenerate

endmodule



