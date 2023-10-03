/******************************************************************************

    File Name:  corepwm_reg_if.v
      Version:  4.0
         Date:  Jul 19th, 2009
  Description:  Register Interface
  
  
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

module corepwm_reg_if #(
parameter PWM_NUM = 8,
parameter APB_DWIDTH = 8,
parameter FIXED_PRESCALE_EN = 0,
parameter FIXED_PRESCALE = 8,
parameter FIXED_PERIOD_EN = 0,
parameter FIXED_PERIOD = 8,
parameter DAC_MODE = 0,
parameter SHADOW_REG_EN = 0,
parameter FIXED_PWM_POS_EN = 0,
parameter FIXED_PWM_POSEDGE = 0,
parameter FIXED_PWM_NEG_EN = 0,
parameter FIXED_PWM_NEGEDGE = 0,
parameter SYNC_RESET = 0
)(
input  PCLK,
input  PRESETN,
input  PSEL,
input  PENABLE,
input  PWRITE,
input  [5:0] PADDR,
input  [APB_DWIDTH-1:0] PWDATA,
output [APB_DWIDTH-1:0] PRDATA_regif,
input  [APB_DWIDTH-1:0] period_cnt,
input  sync_pulse,
input [PWM_NUM-1:0] PWM_STRETCH,
output [APB_DWIDTH-1:0] period_out_wire,
output [APB_DWIDTH-1:0] prescale_out_wire,
output [PWM_NUM:1] pwm_enable_out_wire,
output [PWM_NUM*APB_DWIDTH:1] pwm_posedge_out_wire,
output [PWM_NUM*APB_DWIDTH:1] pwm_negedge_out_wire
);


//wire declarations
wire aresetn;
wire sresetn; 
wire [APB_DWIDTH-1:0]   prescale_wire;
wire [APB_DWIDTH-1:0]   period_wire;
wire [16:1]             pwm_enable_pre_out_wire;
wire [APB_DWIDTH-1:0]   all_zeros = 0;


//reg declarations
//note: psh = Pre SHadow
reg [APB_DWIDTH-1:0] PRDATA_typ;
reg [APB_DWIDTH-1:0] PRDATA_generated;
reg [PWM_NUM*APB_DWIDTH:1] pwm_posedge_wire;
reg [PWM_NUM*APB_DWIDTH:1] pwm_negedge_wire;
reg [APB_DWIDTH-1:0] psh_prescale_reg;
reg [APB_DWIDTH-1:0] psh_period_reg;
reg [APB_DWIDTH-1:0] period_reg;
reg [APB_DWIDTH-1:0] prescale_reg;
reg [8:1]  psh_enable_reg1; 
reg [16:9] psh_enable_reg2; 
reg [16:1] pwm_enable_reg;
reg [PWM_NUM*APB_DWIDTH:1] psh_posedge_reg;
reg [PWM_NUM*APB_DWIDTH:1] psh_negedge_reg;
reg [PWM_NUM*APB_DWIDTH:1] pwm_posedge_reg;
reg [PWM_NUM*APB_DWIDTH:1] pwm_negedge_reg;
reg sync_update;

//////main//////
assign aresetn = (SYNC_RESET==1) ? 1'b1 : PRESETN;
assign sresetn = (SYNC_RESET==1) ? PRESETN : 1'b1;


always @(negedge aresetn or posedge PCLK)
 begin
   if ((!aresetn) || (!sresetn))
   begin
         psh_prescale_reg <= 8; 
         psh_period_reg   <= 8; 
         psh_enable_reg1  <= 0; 
         psh_enable_reg2  <= 0; 
   end
   else
   begin
     if ((PSEL == 1'b1) && (PWRITE ==1'b1) && (PENABLE ==1'b1))
     begin
	 case (PADDR)
	 5'h00:  psh_prescale_reg  <= PWDATA;
	 5'h01:  psh_period_reg    <= PWDATA;
	 5'h02:  psh_enable_reg1   <= PWDATA[7:0];
	 5'h03:  psh_enable_reg2   <= PWDATA[7:0];
	 endcase
     end
   end
end

genvar h;
// Write process parameter-based addresses
generate for (h=1; h<=(PWM_NUM); h=h+1)
begin: gen_pos_neg_shregs
always @(negedge aresetn or posedge PCLK) // this will synthesize out if the fixed enable is asserted.
 begin
   if ((!aresetn) || (!sresetn))
   begin
         psh_posedge_reg[h*APB_DWIDTH:(h-1)*APB_DWIDTH + 1] <= 0; 
         psh_negedge_reg[h*APB_DWIDTH:(h-1)*APB_DWIDTH + 1] <= 0; 
   end
   else
   begin
     if ((PSEL == 1'b1) && (PWRITE ==1'b1) && (PENABLE ==1'b1))
     begin
	 case (PADDR)
	 (2 + h*2):  begin
		       psh_posedge_reg[h*APB_DWIDTH:(h-1)*APB_DWIDTH + 1] <= PWDATA;
	             end
	 (3 + h*2):  psh_negedge_reg[h*APB_DWIDTH:(h-1)*APB_DWIDTH + 1] <= PWDATA;
	 endcase
     end
   end
end
end
endgenerate

// Generate sync update for deadbanding
always @(negedge aresetn or posedge PCLK)
 begin
   if ((!aresetn) || (!sresetn))
    begin
      sync_update <= 1'b0;
    end
   else
    begin
     if ((PSEL == 1'b1) && (PWRITE ==1'b1) && (PENABLE ==1'b1))
      begin
	case (PADDR)
	  57:  begin
		 sync_update <= PWDATA[0];
	       end
	endcase
      end
    end
 end


genvar i;
// Write process parameter-based addresses
generate for (i=1; i<=(PWM_NUM); i=i+1)
begin: gen_pos_neg_regs
always @(negedge aresetn or posedge PCLK) // this will synthesize out if the fixed enable is asserted.
 begin
   if ((!aresetn) || (!sresetn))
   begin
	 	 pwm_posedge_reg[i*APB_DWIDTH:(i-1)*APB_DWIDTH + 1]  <= 0;
	 	 pwm_negedge_reg[i*APB_DWIDTH:(i-1)*APB_DWIDTH + 1]  <= 0;
   end
   else
   begin
      if ((period_cnt >= period_out_wire) && (sync_pulse) && (sync_update == 1'b1))
     // if ((period_cnt >= period_out_wire) && (sync_pulse))
     begin	 
	 pwm_posedge_reg[i*APB_DWIDTH:(i-1)*APB_DWIDTH + 1]  <= psh_posedge_reg[i*APB_DWIDTH:(i-1)*APB_DWIDTH + 1];
	 pwm_negedge_reg[i*APB_DWIDTH:(i-1)*APB_DWIDTH + 1]  <= psh_negedge_reg[i*APB_DWIDTH:(i-1)*APB_DWIDTH + 1];
     end
   end
end
end
endgenerate
   
genvar j;
// Write process parameter-based addresses
generate for (j=1; j<=(PWM_NUM); j=j+1)
begin: pos_neg_shadow_mux
always @*
begin
if (SHADOW_REG_EN[j-1]==1)
 begin
  	pwm_posedge_wire[j*APB_DWIDTH:(j-1)*APB_DWIDTH + 1] <= pwm_posedge_reg[j*APB_DWIDTH:(j-1)*APB_DWIDTH + 1];
  	pwm_negedge_wire[j*APB_DWIDTH:(j-1)*APB_DWIDTH + 1] <= pwm_negedge_reg[j*APB_DWIDTH:(j-1)*APB_DWIDTH + 1];
 end
else
 begin
  	pwm_posedge_wire[j*APB_DWIDTH:(j-1)*APB_DWIDTH + 1] <= psh_posedge_reg[j*APB_DWIDTH:(j-1)*APB_DWIDTH + 1];
  	pwm_negedge_wire[j*APB_DWIDTH:(j-1)*APB_DWIDTH + 1] <= psh_negedge_reg[j*APB_DWIDTH:(j-1)*APB_DWIDTH + 1];
 end
end
end
endgenerate

genvar l;
// Write process parameter-based addresses
generate for (l=1; l<=(PWM_NUM); l=l+1)
begin: posedge_fixed_mux
if (FIXED_PWM_POS_EN[l-1]==1)
 begin
  assign	 pwm_posedge_out_wire[l*APB_DWIDTH:(l-1)*APB_DWIDTH + 1] = FIXED_PWM_POSEDGE[l*APB_DWIDTH-1:(l-1)*APB_DWIDTH];
 end
else
 begin
  assign	 pwm_posedge_out_wire[l*APB_DWIDTH:(l-1)*APB_DWIDTH + 1] = pwm_posedge_wire[l*APB_DWIDTH:(l-1)*APB_DWIDTH + 1];
 end
end
endgenerate

genvar m;
// Write process parameter-based addresses
generate for (m=1; m<=(PWM_NUM); m=m+1)
begin: negedge_fixed_mux
if (FIXED_PWM_NEG_EN[m-1]==1)
 begin
  assign	 pwm_negedge_out_wire[m*APB_DWIDTH:(m-1)*APB_DWIDTH + 1] = FIXED_PWM_NEGEDGE[m*APB_DWIDTH-1:(m-1)*APB_DWIDTH];
 end
else
 begin
  assign	 pwm_negedge_out_wire[m*APB_DWIDTH:(m-1)*APB_DWIDTH + 1] = pwm_negedge_wire[m*APB_DWIDTH:(m-1)*APB_DWIDTH + 1];
 end
end
endgenerate

// Shadow Regs for synchronized reg update to corepwm_pwm_gen block 
//  posedge and negedge disabled if SHADOW_REG_EN[x] = 0
always @(negedge aresetn or posedge PCLK)
 begin
   if ((!aresetn) || (!sresetn))
   begin
         prescale_reg     <= 8; 
         period_reg       <= 8; 
         pwm_enable_reg   <= 0; 
   end
   else
   begin
     if ((period_cnt >= period_out_wire) && (sync_pulse))
     begin	 
	 prescale_reg     <= psh_prescale_reg;
	 period_reg       <= psh_period_reg  ;
	 pwm_enable_reg   <= {psh_enable_reg2,psh_enable_reg1}   ;
     end
   end
end

assign pwm_enable_pre_out_wire = {psh_enable_reg2,psh_enable_reg1};

//Shadow regs ALWAYS enabled for small corepwm_timebase regs
genvar n;
// Write process parameter-based addresses
generate for (n=1; n<=(PWM_NUM); n=n+1)
begin: pwm_enable_out_mux
if (SHADOW_REG_EN[n-1]==1)
 begin
  assign	 pwm_enable_out_wire[n] = pwm_enable_reg[n];
 end
else
 begin
  assign	 pwm_enable_out_wire[n] = pwm_enable_pre_out_wire[n];
 end
end
endgenerate

// assign	 pwm_enable_out_wire = (SHADOW_REG_EN==1)? pwm_enable_reg : {psh_enable_reg2,psh_enable_reg1};
// assign	 prescale_wire = (SHADOW_REG_EN==1)? prescale_reg : psh_prescale_reg;
// assign	 period_wire =   (SHADOW_REG_EN==1)? period_reg   : psh_period_reg;
// assign	 pwm_enable_out_wire[PWM_NUM:1] = 	pwm_enable_reg[PWM_NUM:1];

// keep the prescale/period registers shadowed as these apply to all channels.
 assign	 prescale_wire = 		prescale_reg;
 assign	 period_wire =   		period_reg;

 assign	 prescale_out_wire = (FIXED_PRESCALE_EN==1)? FIXED_PRESCALE : prescale_wire;
 assign	 period_out_wire   = (FIXED_PERIOD_EN==1)?   FIXED_PERIOD   : period_wire;



always @*
begin
	 case (PADDR)
	 0:  PRDATA_typ = prescale_out_wire;
	 1:  PRDATA_typ = period_out_wire;
	 default:PRDATA_typ = 0;
	 endcase 
end

//genvar n;
// Asynchronous Read hard-valued addresses
generate if (PWM_NUM==1)
begin: prdata_rd_mux1
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[1]; 
	 6'h03:  PRDATA_generated = 0;  
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==2)
begin: prdata_rd_mux2
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[2:1]; 
	 6'h03:  PRDATA_generated = 0;  
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==3)
begin: prdata_rd_mux3
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[3:1]; 
	 6'h03:  PRDATA_generated = 0;  
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==4)
begin: prdata_rd_mux4
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[4:1]; 
	 6'h03:  PRDATA_generated = 0;  
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==5)
begin: prdata_rd_mux5
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[5:1]; 
	 6'h03:  PRDATA_generated = 0;  
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==6)
begin: prdata_rd_mux6
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[6:1]; 
	 6'h03:  PRDATA_generated = 0;  
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==7)
begin: prdata_rd_mux7
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[7:1]; 
	 6'h03:  PRDATA_generated = 0;  
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==8)
begin: prdata_rd_mux8
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[8:1]; 
	 6'h03:  PRDATA_generated = 0;  
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h12:  PRDATA_generated = pwm_posedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h13:  PRDATA_generated = pwm_negedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==9)
begin: prdata_rd_mux9
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[8:1]; 
	 6'h03:  PRDATA_generated = pwm_enable_out_wire[9]; 
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h12:  PRDATA_generated = pwm_posedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h13:  PRDATA_generated = pwm_negedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h14:  PRDATA_generated = pwm_posedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h15:  PRDATA_generated = pwm_negedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==10)
begin: prdata_rd_mux10
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[8:1]; 
	 6'h03:  PRDATA_generated = pwm_enable_out_wire[10:9]; 
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h12:  PRDATA_generated = pwm_posedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h13:  PRDATA_generated = pwm_negedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h14:  PRDATA_generated = pwm_posedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h15:  PRDATA_generated = pwm_negedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h16:  PRDATA_generated = pwm_posedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h17:  PRDATA_generated = pwm_negedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==11)
begin: prdata_rd_mux11
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[8:1]; 
	 6'h03:  PRDATA_generated = pwm_enable_out_wire[11:9]; 
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h12:  PRDATA_generated = pwm_posedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h13:  PRDATA_generated = pwm_negedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h14:  PRDATA_generated = pwm_posedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h15:  PRDATA_generated = pwm_negedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h16:  PRDATA_generated = pwm_posedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h17:  PRDATA_generated = pwm_negedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h18:  PRDATA_generated = pwm_posedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h19:  PRDATA_generated = pwm_negedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==12)
begin: prdata_rd_mux12
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[8:1]; 
	 6'h03:  PRDATA_generated = pwm_enable_out_wire[12:9]; 
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h12:  PRDATA_generated = pwm_posedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h13:  PRDATA_generated = pwm_negedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h14:  PRDATA_generated = pwm_posedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h15:  PRDATA_generated = pwm_negedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h16:  PRDATA_generated = pwm_posedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h17:  PRDATA_generated = pwm_negedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h18:  PRDATA_generated = pwm_posedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h19:  PRDATA_generated = pwm_negedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h1a:  PRDATA_generated = pwm_posedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h1b:  PRDATA_generated = pwm_negedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==13)
begin: prdata_rd_mux13
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[8:1]; 
	 6'h03:  PRDATA_generated = pwm_enable_out_wire[13:9]; 
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h12:  PRDATA_generated = pwm_posedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h13:  PRDATA_generated = pwm_negedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h14:  PRDATA_generated = pwm_posedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h15:  PRDATA_generated = pwm_negedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h16:  PRDATA_generated = pwm_posedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h17:  PRDATA_generated = pwm_negedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h18:  PRDATA_generated = pwm_posedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h19:  PRDATA_generated = pwm_negedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h1a:  PRDATA_generated = pwm_posedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h1b:  PRDATA_generated = pwm_negedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h1c:  PRDATA_generated = pwm_posedge_out_wire[13*APB_DWIDTH:12*APB_DWIDTH + 1];
	 6'h1d:  PRDATA_generated = pwm_negedge_out_wire[13*APB_DWIDTH:12*APB_DWIDTH + 1];
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==14)
begin: prdata_rd_mux14
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[8:1]; 
	 6'h03:  PRDATA_generated = pwm_enable_out_wire[14:9]; 
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h12:  PRDATA_generated = pwm_posedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h13:  PRDATA_generated = pwm_negedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h14:  PRDATA_generated = pwm_posedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h15:  PRDATA_generated = pwm_negedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h16:  PRDATA_generated = pwm_posedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h17:  PRDATA_generated = pwm_negedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h18:  PRDATA_generated = pwm_posedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h19:  PRDATA_generated = pwm_negedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h1a:  PRDATA_generated = pwm_posedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h1b:  PRDATA_generated = pwm_negedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h1c:  PRDATA_generated = pwm_posedge_out_wire[13*APB_DWIDTH:12*APB_DWIDTH + 1];
	 6'h1d:  PRDATA_generated = pwm_negedge_out_wire[13*APB_DWIDTH:12*APB_DWIDTH + 1];
	 6'h1e:  PRDATA_generated = pwm_posedge_out_wire[14*APB_DWIDTH:13*APB_DWIDTH + 1];
	 6'h1f:  PRDATA_generated = pwm_negedge_out_wire[14*APB_DWIDTH:13*APB_DWIDTH + 1];
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==15)
begin: prdata_rd_mux15
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[8:1]; 
	 6'h03:  PRDATA_generated = pwm_enable_out_wire[15:9]; 
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h12:  PRDATA_generated = pwm_posedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h13:  PRDATA_generated = pwm_negedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h14:  PRDATA_generated = pwm_posedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h15:  PRDATA_generated = pwm_negedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h16:  PRDATA_generated = pwm_posedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h17:  PRDATA_generated = pwm_negedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h18:  PRDATA_generated = pwm_posedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h19:  PRDATA_generated = pwm_negedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h1a:  PRDATA_generated = pwm_posedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h1b:  PRDATA_generated = pwm_negedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h1c:  PRDATA_generated = pwm_posedge_out_wire[13*APB_DWIDTH:12*APB_DWIDTH + 1];
	 6'h1d:  PRDATA_generated = pwm_negedge_out_wire[13*APB_DWIDTH:12*APB_DWIDTH + 1];
	 6'h1e:  PRDATA_generated = pwm_posedge_out_wire[14*APB_DWIDTH:13*APB_DWIDTH + 1];
	 6'h1f:  PRDATA_generated = pwm_negedge_out_wire[14*APB_DWIDTH:13*APB_DWIDTH + 1];
	 6'h20:  PRDATA_generated = pwm_posedge_out_wire[15*APB_DWIDTH:14*APB_DWIDTH + 1];
	 6'h21:  PRDATA_generated = pwm_negedge_out_wire[15*APB_DWIDTH:14*APB_DWIDTH + 1];
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate
generate if (PWM_NUM==16)
begin: prdata_rd_mux16
  always @*
  begin
	 case (PADDR)
	 6'h02:  PRDATA_generated = pwm_enable_out_wire[8:1]; 
	 6'h03:  PRDATA_generated = pwm_enable_out_wire[16:9]; 
	 6'h04:  PRDATA_generated = pwm_posedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h05:  PRDATA_generated = pwm_negedge_out_wire[1*APB_DWIDTH:0*APB_DWIDTH + 1];  
	 6'h06:  PRDATA_generated = pwm_posedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h07:  PRDATA_generated = pwm_negedge_out_wire[2*APB_DWIDTH:1*APB_DWIDTH + 1];  
	 6'h08:  PRDATA_generated = pwm_posedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h09:  PRDATA_generated = pwm_negedge_out_wire[3*APB_DWIDTH:2*APB_DWIDTH + 1];  
	 6'h0a:  PRDATA_generated = pwm_posedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0b:  PRDATA_generated = pwm_negedge_out_wire[4*APB_DWIDTH:3*APB_DWIDTH + 1];  
	 6'h0c:  PRDATA_generated = pwm_posedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0d:  PRDATA_generated = pwm_negedge_out_wire[5*APB_DWIDTH:4*APB_DWIDTH + 1];  
	 6'h0e:  PRDATA_generated = pwm_posedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h0f:  PRDATA_generated = pwm_negedge_out_wire[6*APB_DWIDTH:5*APB_DWIDTH + 1];  
	 6'h10:  PRDATA_generated = pwm_posedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h11:  PRDATA_generated = pwm_negedge_out_wire[7*APB_DWIDTH:6*APB_DWIDTH + 1];  
	 6'h12:  PRDATA_generated = pwm_posedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h13:  PRDATA_generated = pwm_negedge_out_wire[8*APB_DWIDTH:7*APB_DWIDTH + 1];  
	 6'h14:  PRDATA_generated = pwm_posedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h15:  PRDATA_generated = pwm_negedge_out_wire[9*APB_DWIDTH:8*APB_DWIDTH + 1];  
	 6'h16:  PRDATA_generated = pwm_posedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h17:  PRDATA_generated = pwm_negedge_out_wire[10*APB_DWIDTH:9*APB_DWIDTH + 1];
	 6'h18:  PRDATA_generated = pwm_posedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h19:  PRDATA_generated = pwm_negedge_out_wire[11*APB_DWIDTH:10*APB_DWIDTH + 1];
	 6'h1a:  PRDATA_generated = pwm_posedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h1b:  PRDATA_generated = pwm_negedge_out_wire[12*APB_DWIDTH:11*APB_DWIDTH + 1];
	 6'h1c:  PRDATA_generated = pwm_posedge_out_wire[13*APB_DWIDTH:12*APB_DWIDTH + 1];
	 6'h1d:  PRDATA_generated = pwm_negedge_out_wire[13*APB_DWIDTH:12*APB_DWIDTH + 1];
	 6'h1e:  PRDATA_generated = pwm_posedge_out_wire[14*APB_DWIDTH:13*APB_DWIDTH + 1];
	 6'h1f:  PRDATA_generated = pwm_negedge_out_wire[14*APB_DWIDTH:13*APB_DWIDTH + 1];
	 6'h20:  PRDATA_generated = pwm_posedge_out_wire[15*APB_DWIDTH:14*APB_DWIDTH + 1];
	 6'h21:  PRDATA_generated = pwm_negedge_out_wire[15*APB_DWIDTH:14*APB_DWIDTH + 1];
	 6'h22:  PRDATA_generated = pwm_posedge_out_wire[16*APB_DWIDTH:15*APB_DWIDTH + 1];
	 6'h23:  PRDATA_generated = pwm_negedge_out_wire[16*APB_DWIDTH:15*APB_DWIDTH + 1];	 
	 6'h24:  PRDATA_generated = PWM_STRETCH[PWM_NUM-1:0];
	 default:PRDATA_generated = 0;
	 endcase 
  end
end
endgenerate


// APB Read data for sync update register
generate
 if (APB_DWIDTH == 32) 
  begin
    assign PRDATA_regif = (PADDR <= 1)? PRDATA_typ: ((PADDR == 57) ? {31'b0,sync_update} : PRDATA_generated);
  end
 else if (APB_DWIDTH == 16)
  begin
    assign PRDATA_regif = (PADDR <= 1)? PRDATA_typ: ((PADDR == 57) ? {15'b0,sync_update} : PRDATA_generated);
  end
 else 
  begin
    assign PRDATA_regif = (PADDR <= 1)? PRDATA_typ: ((PADDR == 57) ? {7'b0,sync_update} : PRDATA_generated);
  end
endgenerate

endmodule


