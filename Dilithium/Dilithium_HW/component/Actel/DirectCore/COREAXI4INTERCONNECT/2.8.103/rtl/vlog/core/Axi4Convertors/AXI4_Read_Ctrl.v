module caxi4interconnect_AXI4_Read_Ctrl #
(
   parameter        USER_WIDTH           = 1,
   parameter        DEF_BURST_LEN        = 0,
   parameter        DATA_WIDTH           = 32,
   parameter        ID_WIDTH             = 1,
   parameter        LOG_BYTE_WIDTH       = 2,
   parameter        DEF_BURST_LEN_ZERO   = 0,
   parameter        ADDR_WIDTH           = 32
)
(
  input                           ACLK,                
  input                           sysReset,            
  input                           ahb_read_req,
  input                           ahb_undefbur_rdstart,
  input                           ahb_undefbur_rdend,
  input                           ahb_fixbur_busy_det,
  input                           int_masterARREADY,
  input  [31:0]                   MASTER_HADDR,
  input  [2:0]                    MASTER_HBURST,       
  input                           MASTER_HMASTLOCK,  
  input  [6:0]                    MASTER_HPROT,  
  input  [2:0]                    MASTER_HSIZE,       
  input                           MASTER_HNONSEC,
  input                           int_masterRLAST,
  input                           int_masterRVALID,
  input                           first_rdtxndet_aft_busy,
  
  output [ID_WIDTH-1:0]           int_masterARID,
  output reg [ADDR_WIDTH-1:0]     int_masterARADDR,
  output reg [7:0]                int_masterARLEN,
  output reg [2:0]                int_masterARSIZE,
  output reg [1:0]                int_masterARBURST,
  output [1:0]                    int_masterARLOCK,
  output [3:0]                    int_masterARCACHE,
  output [2:0]                    int_masterARPROT,
  output [3:0]                    int_masterARQOS,
  output [3:0]                    int_masterARREGION,
  output [USER_WIDTH-1:0]         int_masterARUSER,
  output reg                      int_masterARVALID,
  output                          int_masterRREADY,
  output reg                      axi_undefbur_rddone
);

  localparam                      MASK_UPPER_ADDR_BITS = ADDR_WIDTH > 32 ? ADDR_WIDTH - 32 : 32; //If ADDR_WIDTH > 32

  wire                            axi_bur_rdend;  
  wire                            ahb_red_req_pl;
  wire                            ahb_undefbur_rdstart_pl;
  wire                            axi_read_en;
  wire  [7:0]                     ahb_haddr_modulo_256;
  wire                            sel_def_bur_len;
  wire  [7:0]                     ahb_undef_axi_burst_len;
  wire                            ahb_fixed_burst;
  wire  [7:0]                     axi_burst_len;
  wire                            rlast_pl;
  wire  [31:0]                    axi_read_addr;
  wire                            axi_read_comp;
  
  reg                             ahb_read_req_reg;
  reg                             ahb_undefbur_rdstart_reg;
  reg                             axi_defbur_rddone;
  reg   [7:0]                     ahb_fixbur_axi_burst_len;
  reg   [7:0]                     axi_len_limit;
  reg                             rready_ctrl;
  reg                             rlast_reg;
  reg                             ahb_undefbur_rdend_hold;
  reg                             axi_read_busy_ctrl;
  reg                             axi_read_busy_reg;
  reg   [31:0]                    addr_latch;
  reg                             axi_last_beat_xfer;
  reg                             ahb_undefbur_rdend_f1;
  reg                             rlast_reg_ctrl;
  reg                             rlast_reg_ctrl_f1;
  reg                             ahb_fixbur_busy_det_f1;
  reg                             rlast_reg_f1;
  
  assign int_masterARID = {ID_WIDTH{1'b0}};
  
  assign axi_bur_rdend = (ahb_undefbur_rdstart & ~ahb_undefbur_rdend & ~ahb_undefbur_rdend_hold);
  
  assign axi_read_comp = (int_masterRVALID & int_masterRREADY & int_masterRLAST);
  
  always@(posedge ACLK or negedge sysReset)
   if(~sysReset)
     ahb_undefbur_rdend_hold <= 1'b0;
   else if(axi_undefbur_rddone)
     ahb_undefbur_rdend_hold <= 1'b0;
   else if (ahb_undefbur_rdend & int_masterRVALID)
     ahb_undefbur_rdend_hold <= 1'b1;	
/* 
  always@(*)
    if(int_masterARVALID & int_masterARREADY & axi_read_comp)
	  axi_read_busy_ctrl <= 1'b0;
	else 
	  axi_read_busy_ctrl <= 1'b1;
*/
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  axi_read_busy_reg <= 1'b0;
	else if((int_masterARLEN == 0) & int_masterARVALID & int_masterARREADY)
	  axi_read_busy_reg <= 1'b0;
	else if(axi_read_comp)
	  axi_read_busy_reg <= axi_bur_rdend;	    
    else if(int_masterARVALID)
	  axi_read_busy_reg <= (axi_read_busy_reg & ~int_masterARREADY);		
	 
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_read_req_reg <= 1'b0;
	else 
	  ahb_read_req_reg <= ahb_read_req;
  
  assign ahb_red_req_pl = ahb_read_req & ~ahb_read_req_reg;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_rdstart_reg <= 1'b0;
	else 
	  ahb_undefbur_rdstart_reg <= ahb_undefbur_rdstart;
  
  assign ahb_undefbur_rdstart_pl = ahb_undefbur_rdstart & ~ahb_undefbur_rdstart_reg; 
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_fixbur_busy_det_f1 <= 1'b0;
    else 
      ahb_fixbur_busy_det_f1 <= ahb_fixbur_busy_det;
  

  always@(*)
    if(axi_read_comp & ~ahb_fixbur_busy_det & ahb_fixbur_busy_det_f1)
	  rlast_reg_ctrl <= 1'b1;
	else
	  rlast_reg_ctrl <= 1'b0;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  rlast_reg_ctrl_f1 <= 1'b0;
    else 
      rlast_reg_ctrl_f1 <= rlast_reg_ctrl;  

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  rlast_reg_f1 <= 1'b0;
    else 
      rlast_reg_f1 <= rlast_reg;  
	  
  always@(*)
    axi_defbur_rddone = (axi_read_busy_reg & rlast_reg_f1 & ~DEF_BURST_LEN_ZERO);
	
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  addr_latch = 0;
    else if((rlast_reg & ~rlast_reg_ctrl_f1) | rlast_reg_ctrl)
	  addr_latch = MASTER_HADDR;
	  
  assign axi_read_addr = axi_defbur_rddone ? addr_latch : MASTER_HADDR;
						   
  assign axi_read_en = (ahb_undefbur_rdstart_pl | ahb_red_req_pl | axi_defbur_rddone);

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterARADDR <= {ADDR_WIDTH{1'b0}};
	else if(ADDR_WIDTH > 32)
	  begin 
	    if(axi_read_en)
		  int_masterARADDR <= {{MASK_UPPER_ADDR_BITS{1'b0}},axi_read_addr};
	  end 	
	else if(axi_read_en)
	  int_masterARADDR <= axi_read_addr[ADDR_WIDTH-1:0];
  
  assign ahb_haddr_modulo_256 = 255 - axi_read_addr[7:0];	  

  always@(*)
    case (MASTER_HSIZE)
	  1       : axi_len_limit = {1'b0,ahb_haddr_modulo_256[7:1]};  
	  2       : axi_len_limit = {2'b00,ahb_haddr_modulo_256[7:2]};  
	  3       : axi_len_limit = {3'b000,ahb_haddr_modulo_256[7:3]};  
	  4       : axi_len_limit = {4'b0000,ahb_haddr_modulo_256[7:4]};  
	  5       : axi_len_limit = {5'b00000,ahb_haddr_modulo_256[7:5]};  
	  6       : axi_len_limit = {6'b000000,ahb_haddr_modulo_256[7:6]};  
	  7       : axi_len_limit = {7'b0000000,ahb_haddr_modulo_256[7]};  
	  default : axi_len_limit = ahb_haddr_modulo_256[7:0];  
	endcase

  assign sel_def_bur_len = 	(axi_len_limit > DEF_BURST_LEN);
  
  assign ahb_undef_axi_burst_len = sel_def_bur_len ? DEF_BURST_LEN : axi_len_limit;
  
  always@(*)
    case (MASTER_HBURST[2:1])
	  1       : ahb_fixbur_axi_burst_len = 3;
	  2       : ahb_fixbur_axi_burst_len = 7;
	  3       : ahb_fixbur_axi_burst_len = 15;
	  default : ahb_fixbur_axi_burst_len = 0;
	endcase 
	
  assign ahb_fixed_burst = (DEF_BURST_LEN_ZERO | ~MASTER_HBURST[0] | MASTER_HBURST[1] | MASTER_HBURST[2]);	
  
  assign axi_burst_len = ahb_fixed_burst ? ahb_fixbur_axi_burst_len : ahb_undef_axi_burst_len;	
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterARLEN <= 0;
	else if(axi_read_en)
	  int_masterARLEN <= axi_burst_len;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterARSIZE <= 0;
	else if(axi_read_en)
	  int_masterARSIZE <= MASTER_HSIZE;	   
  
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterARBURST <= 0;
	else if(axi_read_en)
	  begin 
	    int_masterARBURST[1] <=  ((MASTER_HBURST[1] | MASTER_HBURST[2] ) & ~MASTER_HBURST[0]); 
		int_masterARBURST[0] <= ~((MASTER_HBURST[1] | MASTER_HBURST[2] ) & ~MASTER_HBURST[0]); 
	  end 
	  

  assign int_masterARLOCK = { 1'b0, MASTER_HMASTLOCK};  
  assign int_masterARCACHE = {MASTER_HPROT[5], MASTER_HPROT[5], MASTER_HPROT[3], MASTER_HPROT[2]};
  assign int_masterARPROT = {~MASTER_HPROT[0], MASTER_HNONSEC, MASTER_HPROT[1]};  
  assign int_masterARQOS = 0;
  assign int_masterARREGION = 0;
  assign int_masterARUSER = 0;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterARVALID <= 1'b0;
	else if(axi_read_en)
	  int_masterARVALID <= 1'b1;
	else if(int_masterARREADY)
	  int_masterARVALID <= 1'b0;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  rlast_reg <= 1'b0;
	else 
	  rlast_reg <= axi_read_comp;
	  

  assign rlast_pl = axi_read_comp  & ~rlast_reg;
  	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  rready_ctrl <= 1'b0;
	else if(int_masterARVALID & int_masterARREADY)
	  rready_ctrl <= 1'b1;
	else if(rlast_pl)
	  rready_ctrl <= 1'b0;
	  
  assign int_masterRREADY = (~ahb_fixbur_busy_det & rready_ctrl & ~first_rdtxndet_aft_busy);

  
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_rdend_f1 <= 1'b0;
    else 
      ahb_undefbur_rdend_f1 <= ahb_undefbur_rdend;
  
  //Signal is generated to detect corner condition in which axi last transaction occurs and on the next clock cycle undefined burst termination
  //is detected. In this scenerio, one more transaction needs to be generated to axi.
 
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  axi_last_beat_xfer <= 1'b0;
    else if(axi_read_busy_reg & ahb_undefbur_rdend & ~ahb_undefbur_rdend_f1)
      axi_last_beat_xfer <= 1'b1;
	else if(axi_read_comp)
	  axi_last_beat_xfer <= 1'b0;
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      axi_undefbur_rddone <= 1'b0;
    //else if(~axi_last_beat_xfer & int_masterRVALID & int_masterRREADY & int_masterRLAST & ahb_undefbur_rdend)
    else if(rlast_reg_f1 & ~axi_defbur_rddone & ahb_undefbur_rdend)
	  axi_undefbur_rddone <= 1'b1;
	else 
	  axi_undefbur_rddone <= 1'b0;
  

endmodule 