/******************************************************************************

    File Name:  tb_user_corepwm.v
      Version:  4.0
         Date:  July 25th, 2009
  Description:  Top level test module

      Company:  Actel



 REVISION HISTORY: 
 COPYRIGHT 2009 BY ACTEL 
 THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
 FROM ACTEL CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
 ACTEL FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
 NO BACK-UP OF THE FILE SHOULD BE MADE. 
 
FUNCTIONAL DESCRIPTION:  
Refer to the CorePWM Handbook.
******************************************************************************/

`timescale 1ns / 1ps

module tb_user_corepwm ();      

`include "../../../../coreparameters.v"

parameter tb_PWM_NUM = 16;
parameter tb_FIXED_PRESCALE_EN = 0;
parameter tb_FIXED_PRESCALE = 8;
parameter tb_FIXED_PERIOD_EN = 0;
parameter tb_FIXED_PERIOD = 8;
parameter tb_DAC_MODE1 = 0;
parameter tb_DAC_MODE2 = 0;
parameter tb_DAC_MODE3 = 0;
parameter tb_DAC_MODE4 = 0;
parameter tb_DAC_MODE5 = 0;
parameter tb_DAC_MODE6 = 0;
parameter tb_DAC_MODE7 = 0;
parameter tb_DAC_MODE8 = 0;
parameter tb_DAC_MODE9 = 0;
parameter tb_DAC_MODE10 = 0;
parameter tb_DAC_MODE11 = 0;
parameter tb_DAC_MODE12 = 0;
parameter tb_DAC_MODE13 = 0;
parameter tb_DAC_MODE14 = 0;
parameter tb_DAC_MODE15 = 0;
parameter tb_DAC_MODE16 = 0;
parameter tb_SHADOW_REG_EN1 = 1;
parameter tb_SHADOW_REG_EN2 = 1;
parameter tb_SHADOW_REG_EN3 = 1;
parameter tb_SHADOW_REG_EN4 = 1;
parameter tb_SHADOW_REG_EN5 = 1;
parameter tb_SHADOW_REG_EN6 = 1;
parameter tb_SHADOW_REG_EN7 = 1;
parameter tb_SHADOW_REG_EN8 = 1;
parameter tb_SHADOW_REG_EN9 = 1;
parameter tb_SHADOW_REG_EN10 = 1;
parameter tb_SHADOW_REG_EN11 = 1;
parameter tb_SHADOW_REG_EN12 = 1;
parameter tb_SHADOW_REG_EN13 = 1;
parameter tb_SHADOW_REG_EN14 = 1;
parameter tb_SHADOW_REG_EN15 = 1;
parameter tb_SHADOW_REG_EN16 = 1;
parameter tb_FIXED_PWM_POS_EN1 =  0;
parameter tb_FIXED_PWM_POS_EN2 =  0;
parameter tb_FIXED_PWM_POS_EN3 =  0;
parameter tb_FIXED_PWM_POS_EN5 =  0;
parameter tb_FIXED_PWM_POS_EN6 =  0;
parameter tb_FIXED_PWM_POS_EN7 =  0;
parameter tb_FIXED_PWM_POS_EN8 =  0;
parameter tb_FIXED_PWM_POS_EN9 =  0;
parameter tb_FIXED_PWM_POS_EN10 = 0;
parameter tb_FIXED_PWM_POS_EN11 = 0;
parameter tb_FIXED_PWM_POS_EN12 = 0;
parameter tb_FIXED_PWM_POS_EN13 = 0;
parameter tb_FIXED_PWM_POS_EN14 = 0;
parameter tb_FIXED_PWM_POS_EN15 = 0;
parameter tb_FIXED_PWM_POS_EN16 = 0;
parameter tb_FIXED_PWM_POSEDGE1 =  0;
parameter tb_FIXED_PWM_POSEDGE2 =  0;
parameter tb_FIXED_PWM_POSEDGE3 =  0;
parameter tb_FIXED_PWM_POSEDGE5 =  0;
parameter tb_FIXED_PWM_POSEDGE6 =  0;
parameter tb_FIXED_PWM_POSEDGE7 =  0;
parameter tb_FIXED_PWM_POSEDGE8 =  0;
parameter tb_FIXED_PWM_POSEDGE9 =  0;
parameter tb_FIXED_PWM_POSEDGE10 = 0;
parameter tb_FIXED_PWM_POSEDGE11 = 0;
parameter tb_FIXED_PWM_POSEDGE12 = 0;
parameter tb_FIXED_PWM_POSEDGE13 = 0;
parameter tb_FIXED_PWM_POSEDGE14 = 0;
parameter tb_FIXED_PWM_POSEDGE15 = 0;
parameter tb_FIXED_PWM_POSEDGE16 = 0;
parameter tb_FIXED_PWM_NEG_EN1 =  0;
parameter tb_FIXED_PWM_NEG_EN2 =  0;
parameter tb_FIXED_PWM_NEG_EN3 =  0;
parameter tb_FIXED_PWM_NEG_EN4 =  0;
parameter tb_FIXED_PWM_NEG_EN5 =  0;
parameter tb_FIXED_PWM_NEG_EN6 =  0;
parameter tb_FIXED_PWM_NEG_EN7 =  0;
parameter tb_FIXED_PWM_NEG_EN8 =  0;
parameter tb_FIXED_PWM_NEG_EN9 =  0;
parameter tb_FIXED_PWM_NEG_EN10 = 0;
parameter tb_FIXED_PWM_NEG_EN11 = 0;
parameter tb_FIXED_PWM_NEG_EN12 = 0;
parameter tb_FIXED_PWM_NEG_EN13 = 0;
parameter tb_FIXED_PWM_NEG_EN14 = 0;
parameter tb_FIXED_PWM_NEG_EN15 = 0;
parameter tb_FIXED_PWM_NEG_EN16 = 0;
parameter tb_FIXED_PWM_NEGEDGE1 = 0;
parameter tb_FIXED_PWM_NEGEDGE2 = 0;
parameter tb_FIXED_PWM_NEGEDGE3 = 0;
parameter tb_FIXED_PWM_NEGEDGE4 = 0;
parameter tb_FIXED_PWM_NEGEDGE5 = 0;
parameter tb_FIXED_PWM_NEGEDGE6 = 0;
parameter tb_FIXED_PWM_NEGEDGE7 = 0;
parameter tb_FIXED_PWM_NEGEDGE8 = 0;
parameter tb_FIXED_PWM_NEGEDGE9 = 0;
parameter tb_FIXED_PWM_NEGEDGE10 = 0;
parameter tb_FIXED_PWM_NEGEDGE11 = 0;
parameter tb_FIXED_PWM_NEGEDGE12 = 0;
parameter tb_FIXED_PWM_NEGEDGE13 = 0;
parameter tb_FIXED_PWM_NEGEDGE14 = 0;
parameter tb_FIXED_PWM_NEGEDGE15 = 0;
parameter tb_FIXED_PWM_NEGEDGE16 = 0;
parameter tb_PWM_STRETCH_VALUE1 = 0;
parameter tb_PWM_STRETCH_VALUE2 = 0;
parameter tb_PWM_STRETCH_VALUE3 = 0;
parameter tb_PWM_STRETCH_VALUE4 = 0;
parameter tb_PWM_STRETCH_VALUE5 = 0;
parameter tb_PWM_STRETCH_VALUE6 = 0;
parameter tb_PWM_STRETCH_VALUE7 = 0;
parameter tb_PWM_STRETCH_VALUE8 = 0;
parameter tb_PWM_STRETCH_VALUE9 = 0;
parameter tb_PWM_STRETCH_VALUE10 = 0;
parameter tb_PWM_STRETCH_VALUE11 = 0;
parameter tb_PWM_STRETCH_VALUE12 = 0;
parameter tb_PWM_STRETCH_VALUE13 = 0;
parameter tb_PWM_STRETCH_VALUE14 = 0;
parameter tb_PWM_STRETCH_VALUE15 = 0;
parameter tb_PWM_STRETCH_VALUE16 = 0;
parameter tb_TACH_EDGE1 = 0;
parameter tb_TACH_EDGE2 = 0;
parameter tb_TACH_EDGE3 = 0;
parameter tb_TACH_EDGE4 = 0;
parameter tb_TACH_EDGE5 = 0;
parameter tb_TACH_EDGE6 = 0;
parameter tb_TACH_EDGE7 = 0;
parameter tb_TACH_EDGE8 = 0;
parameter tb_TACH_EDGE9 = 0;
parameter tb_TACH_EDGE10 = 0;
parameter tb_TACH_EDGE11 = 0;
parameter tb_TACH_EDGE12 = 0;
parameter tb_TACH_EDGE13 = 0;
parameter tb_TACH_EDGE14 = 0;
parameter tb_TACH_EDGE15 = 0;
parameter tb_TACH_EDGE16 = 0;

// register values (parameterized for TB clarity)
parameter PRESCALE_ADR 		= 8'h00; //6'h00;
parameter PERIOD_ADR 		= 8'h04; //6'h01;
parameter ENABLE1_ADR 		= 8'h08; //6'h02;
parameter ENABLE2_ADR 		= 8'h0C; //6'h03;
parameter PWM1_POSEDGE_ADR	= 8'h10; //6'h04;
parameter PWM1_NEGEDGE_ADR	= 8'h14; //6'h05;
parameter PWM2_POSEDGE_ADR 	= 8'h18; //6'h06;
parameter PWM2_NEGEDGE_ADR 	= 8'h1C; //6'h07;
parameter PWM3_POSEDGE_ADR 	= 8'h20; //6'h08;
parameter PWM3_NEGEDGE_ADR 	= 8'h24; //6'h09;
parameter PWM4_POSEDGE_ADR 	= 8'h28; //6'h0a;
parameter PWM4_NEGEDGE_ADR 	= 8'h2C; //6'h0b;
parameter PWM5_POSEDGE_ADR 	= 8'h30; //6'h0c;
parameter PWM5_NEGEDGE_ADR 	= 8'h34; //6'h0d;
parameter PWM6_POSEDGE_ADR 	= 8'h38; //6'h0e;
parameter PWM6_NEGEDGE_ADR 	= 8'h3C; //6'h0f;
parameter PWM7_POSEDGE_ADR 	= 8'h40; //6'h10;
parameter PWM7_NEGEDGE_ADR 	= 8'h44; //6'h11;
parameter PWM8_POSEDGE_ADR 	= 8'h48; //6'h12;
parameter PWM8_NEGEDGE_ADR 	= 8'h4C; //6'h13;
parameter PWM9_POSEDGE_ADR 	= 8'h50; //6'h14;
parameter PWM9_NEGEDGE_ADR 	= 8'h54; //6'h15;
parameter PWM10_POSEDGE_ADR = 8'h58; //6'h16;
parameter PWM10_NEGEDGE_ADR = 8'h5C; //6'h17;
parameter PWM11_POSEDGE_ADR	= 8'h60; //6'h18;
parameter PWM11_NEGEDGE_ADR	= 8'h64; //6'h19;
parameter PWM12_POSEDGE_ADR = 8'h68; //6'h1a;
parameter PWM12_NEGEDGE_ADR = 8'h6C; //6'h1b;
parameter PWM13_POSEDGE_ADR = 8'h70; //6'h1c;
parameter PWM13_NEGEDGE_ADR = 8'h74; //6'h1d;
parameter PWM14_POSEDGE_ADR = 8'h78; //6'h1e;
parameter PWM14_NEGEDGE_ADR = 8'h7C; //6'h1f;
parameter PWM15_POSEDGE_ADR = 8'h80; //6'h20;
parameter PWM15_NEGEDGE_ADR = 8'h84; //6'h21;
parameter PWM16_POSEDGE_ADR = 8'h88; //6'h22;
parameter PWM16_NEGEDGE_ADR = 8'h8C; //6'h23;
parameter PWM_STRETCH_ADR = 8'h90; //6'h24;
parameter TACHPRESCALE_ADR = 8'h94; //6'h25;
parameter TACHSTATUS_ADR = 8'h98; //6'h26;
parameter TACHIRQMASK_ADR = 8'h9C; //6'h27;
parameter TACHMODE_ADR = 8'hA0; //6'h28;
parameter TACHPULSEDUR_0_ADR = 8'hA4; //6'h29;
parameter TACHPULSEDUR_1_ADR = 8'hA8; //6'h2a;
parameter TACHPULSEDUR_2_ADR = 8'hAC; //6'h2b;
parameter TACHPULSEDUR_3_ADR = 8'hB0; //6'h2c;
parameter TACHPULSEDUR_4_ADR = 8'hB4; //6'h2d;
parameter TACHPULSEDUR_5_ADR = 8'hB8; //6'h2e;
parameter TACHPULSEDUR_6_ADR = 8'hBC; //6'h2f;
parameter TACHPULSEDUR_7_ADR = 8'hC0; //6'h30;
parameter TACHPULSEDUR_8_ADR = 8'hC4; //6'h31;
parameter TACHPULSEDUR_9_ADR = 8'hC8; //6'h32;
parameter TACHPULSEDUR_10_ADR = 8'hCC; //6'h33;
parameter TACHPULSEDUR_11_ADR = 8'hD0; //6'h34;
parameter TACHPULSEDUR_12_ADR = 8'hD4; //6'h35;
parameter TACHPULSEDUR_13_ADR = 8'hD8; //6'h36;
parameter TACHPULSEDUR_14_ADR = 8'hDC; //6'h37;
parameter TACHPULSEDUR_15_ADR = 8'hE0; //6'h38;
parameter SYNC_UPDATE_ADR = 8'hE4; //6'h39;

// System Clock cycle (in ns)
parameter SYS_CLK_CYCLE	= 30;

// required data values for testing:
parameter [APB_DWIDTH-1:0] 	PERIOD_DATA = (2**APB_DWIDTH)-3;
parameter [16:1] 			ENABLE_DATA = (2**tb_PWM_NUM)-1;

// timeout 
parameter            TIMEOUT	    = 4*(2**16);
//3 *2**16) * (2**16)); 
//parameter [19:0] TIMEOUT	= 393216; 

// DUT signal declarations
reg						PWM_CLK;
reg						PCLK;
reg						PRESETN;
reg						PSEL;
reg						PENABLE;
reg						PWRITE;
reg	 [7:0]				PADDR;
reg	 [APB_DWIDTH-1:0]	PWDATA;
wire [APB_DWIDTH-1:0]	PRDATA;
wire [tb_PWM_NUM:1]		PWM;
reg [TACH_NUM-1:0] TACHIN;
wire [TACH_NUM-1:0] tb_TACH_EDGE;
// other signal declarations
integer			cyc;
integer			simerrors;
integer			count_high, count_low;
integer 		real_error;

// string related signals
reg [8*79:1]	init_str_mem [0:11];
reg [8*79:1]	dash_str,uline_str,copyright_str,tb_name_str,
				tb_ver_str,pound_str,lsb_str,msb_str;
reg [7:0]		sum;
reg [7:0]		sum_count;

// initialize strings
initial
begin: init_strings

dash_str		=
"-----------------------------------------------------------------------------";
uline_str		=
"_____________________________________________________________________________";
pound_str		=
"#############################################################################";
copyright_str	=
"(c) Copyright 2008 Actel Corporation. All rights reserved.";
tb_name_str		=
"Testbench for: CorePWM";
tb_ver_str		=
"Version: 4.0 July 25th, 2009";

// initialization of testbench string
init_str_mem[00]	= "";
init_str_mem[01]	= "";
init_str_mem[02]	= uline_str;
init_str_mem[03]	= "";
init_str_mem[04]	= copyright_str;
init_str_mem[05]	= "";
init_str_mem[06]	= tb_name_str;
init_str_mem[07]	= tb_ver_str;
init_str_mem[08]	= uline_str;
init_str_mem[09]	= "";
init_str_mem[10]	= "";
init_str_mem[11]	= "";

lsb_str				= "LSB";
msb_str				= "MSB";
end

//-------------------------------------------------------------------

// generate the system clock
initial cyc	= SYS_CLK_CYCLE;
initial PCLK = 0;
initial PWM_CLK = 0;
always #(cyc/2) PCLK = ~PCLK;
always #(cyc/2) PWM_CLK = ~PWM_CLK; 

// instantiate DUT (corepwm)
corepwm #(
.FAMILY             (FAMILY                ),
.CONFIG_MODE        (CONFIG_MODE           ),
.APB_DWIDTH         (APB_DWIDTH            ),
.PWM_NUM            (tb_PWM_NUM            ),
.FIXED_PRESCALE_EN  (tb_FIXED_PRESCALE_EN  ),
.FIXED_PRESCALE     (tb_FIXED_PRESCALE     ),
.FIXED_PERIOD_EN    (tb_FIXED_PERIOD_EN    ),
.FIXED_PERIOD       (tb_FIXED_PERIOD       ),
.DAC_MODE1          (tb_DAC_MODE1          ),
.DAC_MODE2          (tb_DAC_MODE2          ),
.DAC_MODE3          (tb_DAC_MODE3          ),
.DAC_MODE4          (tb_DAC_MODE4          ),
.DAC_MODE5          (tb_DAC_MODE5          ),
.DAC_MODE6          (tb_DAC_MODE6          ),
.DAC_MODE7          (tb_DAC_MODE7          ),
.DAC_MODE8          (tb_DAC_MODE8          ),
.DAC_MODE9          (tb_DAC_MODE9          ),
.DAC_MODE10         (tb_DAC_MODE10         ),
.DAC_MODE11         (tb_DAC_MODE11         ),
.DAC_MODE12         (tb_DAC_MODE12         ),
.DAC_MODE13         (tb_DAC_MODE13         ),
.DAC_MODE14         (tb_DAC_MODE14         ),
.DAC_MODE15         (tb_DAC_MODE15         ),
.DAC_MODE16         (tb_DAC_MODE16         ),
.SHADOW_REG_EN1     (tb_SHADOW_REG_EN1     ),
.SHADOW_REG_EN2     (tb_SHADOW_REG_EN2     ),
.SHADOW_REG_EN3     (tb_SHADOW_REG_EN3     ),
.SHADOW_REG_EN4     (tb_SHADOW_REG_EN4     ),
.SHADOW_REG_EN5     (tb_SHADOW_REG_EN5     ),
.SHADOW_REG_EN6     (tb_SHADOW_REG_EN6     ),
.SHADOW_REG_EN7     (tb_SHADOW_REG_EN7     ),
.SHADOW_REG_EN8     (tb_SHADOW_REG_EN8     ),
.SHADOW_REG_EN9     (tb_SHADOW_REG_EN9     ),
.SHADOW_REG_EN10    (tb_SHADOW_REG_EN10    ),
.SHADOW_REG_EN11    (tb_SHADOW_REG_EN11    ),
.SHADOW_REG_EN12    (tb_SHADOW_REG_EN12    ),
.SHADOW_REG_EN13    (tb_SHADOW_REG_EN13    ),
.SHADOW_REG_EN14    (tb_SHADOW_REG_EN14    ),
.SHADOW_REG_EN15    (tb_SHADOW_REG_EN15    ),
.SHADOW_REG_EN16    (tb_SHADOW_REG_EN16    ),
.FIXED_PWM_POS_EN1  (tb_FIXED_PWM_POS_EN1  ),
.FIXED_PWM_POS_EN2  (tb_FIXED_PWM_POS_EN2  ),
.FIXED_PWM_POS_EN3  (tb_FIXED_PWM_POS_EN3  ),
.FIXED_PWM_POS_EN4  (FIXED_PWM_POS_EN4  ),
.FIXED_PWM_POS_EN5  (tb_FIXED_PWM_POS_EN5  ),
.FIXED_PWM_POS_EN6  (tb_FIXED_PWM_POS_EN6  ),
.FIXED_PWM_POS_EN7  (tb_FIXED_PWM_POS_EN7  ),
.FIXED_PWM_POS_EN8  (tb_FIXED_PWM_POS_EN8  ),
.FIXED_PWM_POS_EN9  (tb_FIXED_PWM_POS_EN9  ),
.FIXED_PWM_POS_EN10 (tb_FIXED_PWM_POS_EN10 ),
.FIXED_PWM_POS_EN11 (tb_FIXED_PWM_POS_EN11 ),
.FIXED_PWM_POS_EN12 (tb_FIXED_PWM_POS_EN12 ),
.FIXED_PWM_POS_EN13 (tb_FIXED_PWM_POS_EN13 ),
.FIXED_PWM_POS_EN14 (tb_FIXED_PWM_POS_EN14 ),
.FIXED_PWM_POS_EN15 (tb_FIXED_PWM_POS_EN15 ),
.FIXED_PWM_POS_EN16 (tb_FIXED_PWM_POS_EN16 ),
.FIXED_PWM_POSEDGE1 (tb_FIXED_PWM_POSEDGE1 ),
.FIXED_PWM_POSEDGE2 (tb_FIXED_PWM_POSEDGE2 ),
.FIXED_PWM_POSEDGE3 (tb_FIXED_PWM_POSEDGE3 ),
.FIXED_PWM_POSEDGE4 (FIXED_PWM_POSEDGE4 ),
.FIXED_PWM_POSEDGE5 (tb_FIXED_PWM_POSEDGE5 ),
.FIXED_PWM_POSEDGE6 (tb_FIXED_PWM_POSEDGE6 ),
.FIXED_PWM_POSEDGE7 (tb_FIXED_PWM_POSEDGE7 ),
.FIXED_PWM_POSEDGE8 (tb_FIXED_PWM_POSEDGE8 ),
.FIXED_PWM_POSEDGE9 (tb_FIXED_PWM_POSEDGE9 ),
.FIXED_PWM_POSEDGE10(tb_FIXED_PWM_POSEDGE10),
.FIXED_PWM_POSEDGE11(tb_FIXED_PWM_POSEDGE11),
.FIXED_PWM_POSEDGE12(tb_FIXED_PWM_POSEDGE12),
.FIXED_PWM_POSEDGE13(tb_FIXED_PWM_POSEDGE13),
.FIXED_PWM_POSEDGE14(tb_FIXED_PWM_POSEDGE14),
.FIXED_PWM_POSEDGE15(tb_FIXED_PWM_POSEDGE15),
.FIXED_PWM_POSEDGE16(tb_FIXED_PWM_POSEDGE16),
.FIXED_PWM_NEG_EN1  (tb_FIXED_PWM_NEG_EN1  ),
.FIXED_PWM_NEG_EN2  (tb_FIXED_PWM_NEG_EN2  ),
.FIXED_PWM_NEG_EN3  (tb_FIXED_PWM_NEG_EN3  ),
.FIXED_PWM_NEG_EN4  (tb_FIXED_PWM_NEG_EN4  ),
.FIXED_PWM_NEG_EN5  (tb_FIXED_PWM_NEG_EN5  ),
.FIXED_PWM_NEG_EN6  (tb_FIXED_PWM_NEG_EN6  ),
.FIXED_PWM_NEG_EN7  (tb_FIXED_PWM_NEG_EN7  ),
.FIXED_PWM_NEG_EN8  (tb_FIXED_PWM_NEG_EN8  ),
.FIXED_PWM_NEG_EN9  (tb_FIXED_PWM_NEG_EN9  ),
.FIXED_PWM_NEG_EN10 (tb_FIXED_PWM_NEG_EN10 ),
.FIXED_PWM_NEG_EN11 (tb_FIXED_PWM_NEG_EN11 ),
.FIXED_PWM_NEG_EN12 (tb_FIXED_PWM_NEG_EN12 ),
.FIXED_PWM_NEG_EN13 (tb_FIXED_PWM_NEG_EN13 ),
.FIXED_PWM_NEG_EN14 (tb_FIXED_PWM_NEG_EN14 ),
.FIXED_PWM_NEG_EN15 (tb_FIXED_PWM_NEG_EN15 ),
.FIXED_PWM_NEG_EN16 (tb_FIXED_PWM_NEG_EN16 ),
.FIXED_PWM_NEGEDGE1 (tb_FIXED_PWM_NEGEDGE1 ),
.FIXED_PWM_NEGEDGE2 (tb_FIXED_PWM_NEGEDGE2 ),
.FIXED_PWM_NEGEDGE3 (tb_FIXED_PWM_NEGEDGE3 ),
.FIXED_PWM_NEGEDGE4 (tb_FIXED_PWM_NEGEDGE4 ),
.FIXED_PWM_NEGEDGE5 (tb_FIXED_PWM_NEGEDGE5 ),
.FIXED_PWM_NEGEDGE6 (tb_FIXED_PWM_NEGEDGE6 ),
.FIXED_PWM_NEGEDGE7 (tb_FIXED_PWM_NEGEDGE7 ),
.FIXED_PWM_NEGEDGE8 (tb_FIXED_PWM_NEGEDGE8 ),
.FIXED_PWM_NEGEDGE9 (tb_FIXED_PWM_NEGEDGE9 ),
.FIXED_PWM_NEGEDGE10(tb_FIXED_PWM_NEGEDGE10),
.FIXED_PWM_NEGEDGE11(tb_FIXED_PWM_NEGEDGE11),
.FIXED_PWM_NEGEDGE12(tb_FIXED_PWM_NEGEDGE12),
.FIXED_PWM_NEGEDGE13(tb_FIXED_PWM_NEGEDGE13),
.FIXED_PWM_NEGEDGE14(tb_FIXED_PWM_NEGEDGE14),
.FIXED_PWM_NEGEDGE15(tb_FIXED_PWM_NEGEDGE15),
.FIXED_PWM_NEGEDGE16(tb_FIXED_PWM_NEGEDGE16),
.PWM_STRETCH_VALUE1 (tb_PWM_STRETCH_VALUE1 ),
.PWM_STRETCH_VALUE2 (tb_PWM_STRETCH_VALUE2 ),
.PWM_STRETCH_VALUE3 (tb_PWM_STRETCH_VALUE3 ),
.PWM_STRETCH_VALUE4 (tb_PWM_STRETCH_VALUE4 ),
.PWM_STRETCH_VALUE5 (tb_PWM_STRETCH_VALUE5 ),
.PWM_STRETCH_VALUE6 (tb_PWM_STRETCH_VALUE6 ),
.PWM_STRETCH_VALUE7 (tb_PWM_STRETCH_VALUE7 ),
.PWM_STRETCH_VALUE8 (tb_PWM_STRETCH_VALUE8 ),
.PWM_STRETCH_VALUE9 (tb_PWM_STRETCH_VALUE9 ),
.PWM_STRETCH_VALUE10(tb_PWM_STRETCH_VALUE10),
.PWM_STRETCH_VALUE11(tb_PWM_STRETCH_VALUE11),
.PWM_STRETCH_VALUE12(tb_PWM_STRETCH_VALUE12),
.PWM_STRETCH_VALUE13(tb_PWM_STRETCH_VALUE13),
.PWM_STRETCH_VALUE14(tb_PWM_STRETCH_VALUE14),
.PWM_STRETCH_VALUE15(tb_PWM_STRETCH_VALUE15),
.PWM_STRETCH_VALUE16(tb_PWM_STRETCH_VALUE16),
.TACH_EDGE1         (tb_TACH_EDGE1         ),
.TACH_EDGE2         (tb_TACH_EDGE2         ),
.TACH_EDGE3         (tb_TACH_EDGE3         ),
.TACH_EDGE4         (tb_TACH_EDGE4         ),
.TACH_EDGE5         (tb_TACH_EDGE5         ),
.TACH_EDGE6         (tb_TACH_EDGE6         ),
.TACH_EDGE7         (tb_TACH_EDGE7         ),
.TACH_EDGE8         (tb_TACH_EDGE8         ),
.TACH_EDGE9         (tb_TACH_EDGE9         ),
.TACH_EDGE10        (tb_TACH_EDGE10        ),
.TACH_EDGE11        (tb_TACH_EDGE11        ),
.TACH_EDGE12        (tb_TACH_EDGE12        ),
.TACH_EDGE13        (tb_TACH_EDGE13        ),
.TACH_EDGE14        (tb_TACH_EDGE14        ),
.TACH_EDGE15        (tb_TACH_EDGE15        ),
.TACH_EDGE16        (tb_TACH_EDGE16        ),
.TACH_NUM           (TACH_NUM              ),
.TACHINT_ACT_LEVEL  (TACHINT_ACT_LEVEL     ),
.SEPARATE_PWM_CLK   (SEPARATE_PWM_CLK      )
) 
corepwm (
.PCLK(PCLK),
.PRESETN(PRESETN),
.PSEL(PSEL),
.PENABLE(PENABLE),
.PWRITE(PWRITE),
.PADDR(PADDR),
.PWDATA(PWDATA),
.PRDATA(PRDATA),
.PREADY(PREADY),
.PSLVERR(PSLVERR),
.TACHIN(TACHIN),
.TACHINT(TACHINT),
.PWM(PWM),
.PWM_CLK(PWM_CLK)
);

// Flatten PWM_STRETCH to create PWM_STRETCH arrary 

generate if ((TACH_NUM>0) && (CONFIG_MODE > 0) )
begin: tach_out_0
  assign tb_TACH_EDGE = {tb_TACH_EDGE1};
end
endgenerate
generate if ((TACH_NUM>1) && (CONFIG_MODE > 0) )
begin: tach_out_1
  assign tb_TACH_EDGE = {tb_TACH_EDGE1}; 
end
endgenerate
generate if ((TACH_NUM>2) && (CONFIG_MODE > 0) )
begin: tach_out_2
  assign tb_TACH_EDGE = {tb_TACH_EDGE2, tb_TACH_EDGE1};
end
endgenerate
generate if ((TACH_NUM>3) && (CONFIG_MODE > 0) )
begin: tach_out_3
  assign tb_TACH_EDGE = {tb_TACH_EDGE3, tb_TACH_EDGE2, tb_TACH_EDGE1}; 
end
endgenerate
generate if ((TACH_NUM>4) && (CONFIG_MODE > 0) )
begin: tach_out_4
  assign tb_TACH_EDGE = {tb_TACH_EDGE4, tb_TACH_EDGE3, tb_TACH_EDGE2, tb_TACH_EDGE1}; 
end
endgenerate
generate if ((TACH_NUM>5) && (CONFIG_MODE > 0) )
begin: tach_out_5
  assign tb_TACH_EDGE = {tb_TACH_EDGE5, tb_TACH_EDGE4, tb_TACH_EDGE3, tb_TACH_EDGE2, tb_TACH_EDGE1}; 
end
endgenerate
generate if ((TACH_NUM>6) && (CONFIG_MODE > 0) )
begin: tach_out_6
  assign tb_TACH_EDGE = {tb_TACH_EDGE6, tb_TACH_EDGE5, tb_TACH_EDGE4, tb_TACH_EDGE3, tb_TACH_EDGE2, tb_TACH_EDGE1}; 
end
endgenerate
generate if ((TACH_NUM>7) && (CONFIG_MODE > 0) )
begin: tach_out_7
  assign tb_TACH_EDGE = {tb_TACH_EDGE7, tb_TACH_EDGE6, tb_TACH_EDGE5, tb_TACH_EDGE4, tb_TACH_EDGE3, tb_TACH_EDGE2, 
	              tb_TACH_EDGE1};
end
endgenerate
generate if ((TACH_NUM>8) && (CONFIG_MODE > 0) )
begin: tach_out_8
  assign tb_TACH_EDGE = {tb_TACH_EDGE8, tb_TACH_EDGE7, tb_TACH_EDGE6, tb_TACH_EDGE5, tb_TACH_EDGE4, tb_TACH_EDGE3, 
	              tb_TACH_EDGE2, tb_TACH_EDGE1}; 
end
endgenerate
generate if ((TACH_NUM>9) && (CONFIG_MODE > 0) )
begin: tach_out_9
  assign tb_TACH_EDGE = {tb_TACH_EDGE9, tb_TACH_EDGE8, tb_TACH_EDGE7, tb_TACH_EDGE6, tb_TACH_EDGE5, tb_TACH_EDGE4, 
	              tb_TACH_EDGE3, tb_TACH_EDGE2, tb_TACH_EDGE1}; 
end
endgenerate
generate if ((TACH_NUM>10) && (CONFIG_MODE > 0) )
begin: tach_out_10
  assign tb_TACH_EDGE = {tb_TACH_EDGE10, tb_TACH_EDGE9, tb_TACH_EDGE8, tb_TACH_EDGE7, tb_TACH_EDGE6, tb_TACH_EDGE5, 
	              tb_TACH_EDGE4, tb_TACH_EDGE3, tb_TACH_EDGE2, tb_TACH_EDGE1};
end
endgenerate
generate if ((TACH_NUM>11) && (CONFIG_MODE > 0) )
begin: tach_out_11
  assign tb_TACH_EDGE = {tb_TACH_EDGE11, tb_TACH_EDGE10, tb_TACH_EDGE9, tb_TACH_EDGE8, tb_TACH_EDGE7, tb_TACH_EDGE6, 
	              tb_TACH_EDGE5, tb_TACH_EDGE4, tb_TACH_EDGE3, tb_TACH_EDGE2, tb_TACH_EDGE1};
end
endgenerate
generate if ((TACH_NUM>12) && (CONFIG_MODE > 0) )
begin: tach_out_12
  assign tb_TACH_EDGE = {tb_TACH_EDGE12, tb_TACH_EDGE11, tb_TACH_EDGE10, tb_TACH_EDGE9, tb_TACH_EDGE8, tb_TACH_EDGE7, 
	              tb_TACH_EDGE6, tb_TACH_EDGE5, tb_TACH_EDGE4, tb_TACH_EDGE3, tb_TACH_EDGE2, tb_TACH_EDGE1};
end
endgenerate
generate if ((TACH_NUM>13) && (CONFIG_MODE > 0) )
begin: tach_out_13
  assign tb_TACH_EDGE = {tb_TACH_EDGE13, tb_TACH_EDGE12, tb_TACH_EDGE11, tb_TACH_EDGE10, tb_TACH_EDGE9, tb_TACH_EDGE8, 
	              tb_TACH_EDGE7, tb_TACH_EDGE6, tb_TACH_EDGE5, tb_TACH_EDGE4, tb_TACH_EDGE3, tb_TACH_EDGE2, 
		      tb_TACH_EDGE1};
end
endgenerate
generate if ((TACH_NUM>14) && (CONFIG_MODE > 0) )
begin: tach_out_14
  assign tb_TACH_EDGE = {tb_TACH_EDGE14, tb_TACH_EDGE13, tb_TACH_EDGE12, tb_TACH_EDGE11, tb_TACH_EDGE10, tb_TACH_EDGE9, 
	              tb_TACH_EDGE8, tb_TACH_EDGE7, tb_TACH_EDGE6, tb_TACH_EDGE5, tb_TACH_EDGE4, tb_TACH_EDGE3, 
		      tb_TACH_EDGE2, tb_TACH_EDGE1};  
end
endgenerate
generate if ((TACH_NUM>15) && (CONFIG_MODE > 0) )
begin: tach_out_15
  assign tb_TACH_EDGE = {tb_TACH_EDGE15, tb_TACH_EDGE14, tb_TACH_EDGE13, tb_TACH_EDGE12, tb_TACH_EDGE11, tb_TACH_EDGE10, 
	              tb_TACH_EDGE9, tb_TACH_EDGE8, tb_TACH_EDGE7, tb_TACH_EDGE6, tb_TACH_EDGE5, tb_TACH_EDGE4, 
		      tb_TACH_EDGE3, tb_TACH_EDGE2, tb_TACH_EDGE1};
end
endgenerate

// Primary stimuli
initial
begin: testing
integer i,j,k,l,t;

reg	[8*79:1]	lmsb_str;

reg [TACH_NUM-1:0] SET_PWM_STRETCH;	 
reg [3:0]  SET_TACHPRESCALE;
reg [TACH_NUM-1:0] SET_TACHSTATUS;
reg [TACH_NUM-1:0] SET_TACHSTATUS_INV;
reg [TACH_NUM-1:0] SET_TACHIRQMASK;
reg [TACH_NUM-1:0] SET_TACHMODE;
reg [7:0] SET_TACHPULSEDUR_ADR;

$timeformat(-9, 2, " ns", 3);

i			= 0;
j			= 0;
k			= 0;
l			= 0;
t			= 0;
simerrors	= 0;
sum         = 8'b0;
sum_count   = 8'b0;
count_high	= 0;
count_low	= 0;
real_error  = 0;

// print out copyright info, testbench version, name of testbench, etc.
for (i=0;i<12;i=i+1)
begin
	$display("%0s",init_str_mem[i]);
end

	// initialize signals
	PRESETN			= 0;
	PSEL			= 0;
	PWDATA			= 0;
	PADDR			= 0;
	PWRITE			= 0;
	PENABLE			= 0;


// synch to falling edge of clock
//		@ (negedge sysclk);
// synch to rising edge of clock
@ (posedge PCLK);

#(cyc * 2);
PRESETN			= 1;
#(cyc * 2);


if (CONFIG_MODE < 2)
begin
 $display("PWM tests beginning:\n\n");
 $display("PWM outputs set to %0d", tb_PWM_NUM);

	$display("Writing PWM Registers\n");
	for (i=0;i<PWM16_NEGEDGE_ADR;i=i+4) 
	begin
		cpu_wr(i,i);
		#(cyc * 1);
	end


	// Do write to SYNC_UPDATE_ADR for deadbanding synchronization 
		cpu_wr(SYNC_UPDATE_ADR,1);
		#(cyc * 1);
//debug:	$stop;


	$display("Reading PWM Registers\n"); 	
	for (i=0;i<PWM16_NEGEDGE_ADR;i=i+4)
	begin
	  if (i == PWM4_POSEDGE_ADR && FIXED_PWM_POS_EN4 == 1'b0) //ADD THIS SERIES OF IFs FOR EVERY FIXABLE REGISTER.
	  begin
		cpu_rd(i,i);
		#(cyc * 1);
	  end
	  else if (i == PWM4_POSEDGE_ADR && FIXED_PWM_POS_EN4 == 1'b1) 
	  begin
		cpu_rd(i,FIXED_PWM_POSEDGE4);
		#(cyc * 1);
	  end
	  else
	  begin
		cpu_rd(i,i);
		#(cyc * 1);
	  end
	end

	// Read and verify SYNC_UPDATE_ADR 
		cpu_rd(SYNC_UPDATE_ADR,1);

	$display("Configuring Channels\n");
		cpu_wr(PRESCALE_ADR,1);
		#(cyc * 1);
		cpu_wr(PERIOD_ADR,PERIOD_DATA);
		#(cyc * 1);
		cpu_wr(ENABLE1_ADR,ENABLE_DATA[8:1]);
		#(cyc * 1);
		cpu_wr(ENABLE2_ADR,ENABLE_DATA[16:9]);
		#(cyc * 1);
	for (i=1;i<=(tb_PWM_NUM);i=i+1) 
//	@ (negedge PCLK)
	begin
	$display("Waiting for PWM%0d Output to Change....", i);
				begin: tloop1
				for (t=0;t<TIMEOUT+1;t=t+1) 
				begin
					#(cyc * 1);
						//$display("Timeout count = %d at %t\n", t, $time);
					if (PWM[i]==1'b1) 
					begin
						$display("....................Change Detected...\n");
						disable tloop1;
					end
					if (t == TIMEOUT) 
					begin
						$display("*** Error: Timed Out Waiting For Change at %t.\n", $time);
						simerrors = simerrors + 1;
					end
				end
				end
//				#(cyc * 1);
	end
   $display("PWM tests finished:\n\n");
 end // CONFIG_MODE < 2

 if (CONFIG_MODE > 0)
begin
  $display("Start TACH testing :\n\n");
  $display("No. of TACH inputs set to %0d", TACH_NUM);

           SET_PWM_STRETCH = 0;	 
           SET_TACHSTATUS = 0;	 
           SET_TACHIRQMASK = 0;	 
           SET_TACHMODE = 0;	 
           TACHIN = 0;

	for (l=0;l<TACH_NUM;l=l+1)
	 begin
           SET_PWM_STRETCH[l] = 1'b1;	 
           SET_TACHSTATUS[l] = 1'b1;	 
           SET_TACHSTATUS_INV[l] = 1'b0;	 
           SET_TACHIRQMASK[l] = 1'b1;	 
           SET_TACHMODE[l] = 1'b1;	 
         end


	$display("Writing TACH Registers\n");
        cpu_wr(PWM_STRETCH_ADR,SET_PWM_STRETCH);
        cpu_wr(TACHPRESCALE_ADR,4);
        cpu_wr(TACHSTATUS_ADR,SET_TACHSTATUS);
        cpu_wr(TACHIRQMASK_ADR,SET_TACHIRQMASK);
        cpu_wr(TACHMODE_ADR,SET_TACHMODE);
	for (i=164;i<TACHPULSEDUR_15_ADR+4;i=i+4) 
	 begin
           cpu_wr(i,i);
	   #(cyc * 1);
	 end

	$display("Reading TACH Registers\n"); 	
        cpu_rd(PWM_STRETCH_ADR,SET_PWM_STRETCH);
        cpu_rd(TACHPRESCALE_ADR,4);
        cpu_rd(TACHSTATUS_ADR,SET_TACHSTATUS_INV);
        cpu_rd(TACHIRQMASK_ADR,SET_TACHIRQMASK);
        cpu_rd(TACHMODE_ADR,SET_TACHMODE);
	for (i=164;i<TACHPULSEDUR_15_ADR+4;i=i+4)
	 begin
	   cpu_rd(i,0);
	   #(cyc * 1);
	 end

	for (k=0;k<TACH_NUM;k=k+1)
	 begin
           SET_TACHSTATUS[k] = 1'b1;	 
           SET_TACHIRQMASK[k] = 1'b1;	 
           SET_TACHMODE[k] = 1'b0;	 
         end
        SET_TACHPRESCALE = 4'b0010;	 
        cpu_wr(TACHPRESCALE_ADR,SET_TACHPRESCALE);
        cpu_wr(TACHSTATUS_ADR,SET_TACHSTATUS);
        cpu_wr(TACHIRQMASK_ADR,SET_TACHIRQMASK);
        cpu_wr(TACHMODE_ADR,SET_TACHMODE);
	   #(cyc * 25);

        $display("TACH interrupt test beginning:\n\n");
	for (j=0;j<TACH_NUM;j=j+1)
	 begin
	   if (tb_TACH_EDGE[j] == 1'b1)
	    begin
              TACHIN[j] = 1'b0;
	      #(cyc * 120);
              TACHIN[j] = 1'b1;
	      #(cyc * 120);
              TACHIN[j] = 1'b0;
	      #(cyc * 120);
              TACHIN[j] = 1'b1;
	      #(cyc * 125);
              TACHIN[j] = 1'b0;
	      #(cyc * 125);
              TACHIN[j] = 1'b1;
	      #(cyc * 130);
              TACHIN[j] = 1'b0;
	      #(cyc * 130);
              TACHIN[j] = 1'b1;
	      #(cyc * 135);
              TACHIN[j] = 1'b0;
	      #(cyc * 135);
              if (TACHINT_ACT_LEVEL == 1'b1)
	       begin
	         if (TACHINT == 1'b1)
	          begin
	            SET_TACHPULSEDUR_ADR = 164 + j*4;
                    cpu_rd(SET_TACHPULSEDUR_ADR,65);
                    cpu_wr(152,SET_TACHSTATUS);
                  end
               end
	      else
	       begin
	         if (TACHINT == 1'b0)
	          begin
	            SET_TACHPULSEDUR_ADR = 164 + j*4;
                    cpu_rd(SET_TACHPULSEDUR_ADR,65);
                    cpu_wr(152,SET_TACHSTATUS);
                  end
               end
	    end
	   else
	    begin
              TACHIN[j] = 1'b1;
	      #(cyc * 120);
              TACHIN[j] = 1'b0;
	      #(cyc * 120);
              TACHIN[j] = 1'b1;
	      #(cyc * 120);
              TACHIN[j] = 1'b0;
	      #(cyc * 125);
              TACHIN[j] = 1'b1;
	      #(cyc * 125);
              TACHIN[j] = 1'b0;
	      #(cyc * 130);
              TACHIN[j] = 1'b1;
	      #(cyc * 130);
              TACHIN[j] = 1'b0;
	      #(cyc * 135);
              if (TACHINT_ACT_LEVEL == 1'b1)
	       begin
	         if (TACHINT == 1'b1)
	          begin
	            SET_TACHPULSEDUR_ADR = 164 + j*4;
                    cpu_rd(SET_TACHPULSEDUR_ADR,65);
                    cpu_wr(152,SET_TACHSTATUS);
                  end
               end
	      else
	       begin
	         if (TACHINT == 1'b0)
	          begin
	            SET_TACHPULSEDUR_ADR = 164 + j*4;
                    cpu_rd(SET_TACHPULSEDUR_ADR,65);
                    cpu_wr(152,SET_TACHSTATUS);
                  end
               end
	    end
         end

  $display("TACH tests finished:\n\n");

end // CONFIG_MODE > 0
  
// print out number of simulation errors (if any) at end of sim
$display(" ");
$display("%0s",pound_str);
$display("All tests for PWM = %0d complete with %d Errors at time %t", tb_PWM_NUM, simerrors, $time);
$display("%0s",pound_str);
$display(" ");
#(cyc * 1);
//	$finish; //this will prompt for closing MODELSIM window
  $stop;   
end


//----------------------------------------------------------------------
// tasks
//----------------------------------------------------------------------

// ----------- check the value of a signal or bus (up to 128 bits) ---------

task checksig;
input [127:0] d;
input [8*17:1] sig_name;
input [127:0] v;
begin
	$timeformat(-9, 2, " ns", 3);
	if (d != v)
	begin
		$display("");
		$display("%0s",pound_str);
		$display("ERROR!!! Mismatch on signal %0s",sig_name);
		$display("At time: %0t",$time);
		$display("Expected value was: 0x%0x, observed value is: 0x%0x",v,d);
		$display("%0s",pound_str);
		$display("");
		simerrors = simerrors + 1;
 	    #(cyc * 1);
	//	$stop;
	end
end
endtask

//-------------------------------------------------------------------
// Emulate task of cpu writing data to peripheral (IP macro)
//-------------------------------------------------------------------
task cpu_wr;
input	[7:0]	addr;	// only 5 LSB bits used
input	[APB_DWIDTH-1:0]	d;
begin
	PSEL  	= 1;
	PADDR	= addr;
	PWRITE	= 1;
	PENABLE	= 0;
	PWDATA	= d;
	#(cyc * 1);
	PENABLE	= 1;
	#(cyc * 1);
//	@ (posedge PCLK);
	@ (negedge PCLK);
	PADDR	= 0;
	PWRITE	= 0;
	PSEL	= 0;
	PENABLE	= 0;
	PADDR	= 0;
	PWDATA	= 0;
end
endtask

//-------------------------------------------------------------------
// Emulate task of cpu reading data from peripheral (IP macro)
//-------------------------------------------------------------------
task cpu_rd;
input	[7:0]	addr;	// only 5 LSB bits used
input	[APB_DWIDTH-1:0]	d;
begin
	PSEL  	= 1;
	PADDR	= addr;
	PWRITE	= 0;
	PENABLE	= 0;
	#(cyc * 1);
	PENABLE	= 1;
	#(cyc * 1);
//	@ (posedge PCLK);
	@ (negedge PCLK);
	$display("Read Address = 0x%0x, Expected PRDATA = 0x%0x",addr, d);
	checksig(PRDATA,"CPU Data Bus",d);
	PADDR	= 0;
	PWRITE	= 0;
	PSEL	= 0;
	PENABLE	= 0;
	PADDR	= 0;
end
endtask

task read;
input	[7:0]	addr;	// only 5 LSB bits used
begin
	PSEL  	= 1;
	PADDR	= addr;
	PWRITE	= 0;
	PENABLE	= 0;
	#(cyc * 1);
	PENABLE	= 1;
	#(cyc * 1);
	@ (negedge PCLK);
	PADDR	= 0;
	PWRITE	= 0;
	PSEL	= 0;
	PENABLE	= 0;
	PADDR	= 0;
end
endtask

endmodule 
