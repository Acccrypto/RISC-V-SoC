module caxi4interconnect_AXI4_Write_Ctrl #
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
  input                           ahb_write_req,
  input                           ahb_undefbur_wrstart,
  input                           ahb_undefbur_wrend,
  input                           ahb_fixbur_busy_det,
  input                           int_masterAWREADY,
  input                           int_masterWREADY,
  input                           int_masterBVALID,
  input  [31:0]                   MASTER_HADDR,
  input  [2:0]                    MASTER_HBURST,       
  input                           MASTER_HMASTLOCK,  
  input  [6:0]                    MASTER_HPROT,  
  input  [2:0]                    MASTER_HSIZE,       
  input  [DATA_WIDTH-1:0]         MASTER_HWDATA,       
  input                           MASTER_HNONSEC,
  input                           valid_ahb_wrdata,
  
  output                          axi_write_busy,
  output [ID_WIDTH-1:0]           int_masterAWID,
  output reg [ADDR_WIDTH-1:0]     int_masterAWADDR,
  output reg [7:0]                int_masterAWLEN,
  output reg [2:0]                int_masterAWSIZE,
  output reg [1:0]                int_masterAWBURST,
  output [1:0]                    int_masterAWLOCK,
  output [3:0]                    int_masterAWCACHE,
  output [2:0]                    int_masterAWPROT,
  output [3:0]                    int_masterAWQOS,
  output [3:0]                    int_masterAWREGION,
  output [USER_WIDTH-1:0]         int_masterAWUSER,
  output reg                      int_masterAWVALID,
  output [ID_WIDTH-1:0]           int_masterWID,
  output [DATA_WIDTH-1:0]         int_masterWDATA,
  output reg [(DATA_WIDTH/8)-1:0] int_masterWSTRB,
  output reg                      int_masterWLAST,
  output [USER_WIDTH-1:0]         int_masterWUSER,
  output reg                      int_masterWVALID,
  output reg                      int_masterBREADY,
  output reg                      axi_undefbur_wrdone
);

  localparam                      MASK_UPPER_ADDR_BITS = ADDR_WIDTH > 32 ? ADDR_WIDTH - 32 : 32; //If ADDR_WIDTH > 32
  
  wire                            axi_bur_wrend;
  wire                            ahb_write_req_pl;
  wire                            ahb_undefbur_wrstart_pl;
  wire                            axi_defbur_wrdone;
  wire  [31:0]                    axi_write_addr;
  wire                            axi_write_en;
  wire  [7:0]                     ahb_haddr_modulo_256;
  wire                            sel_def_bur_len;
  wire  [7:0]                     ahb_undef_axi_burst_len;  
  wire  [7:0]                     axi_burst_len;
  wire                            ahb_fixed_burst;  
  wire                            axi_beat_xfer;
  wire                            ahb_single_burst_trans;
  wire                            write_burst_cnt_msb_zero;
  wire                            fixed_burst_wlast_ctrl;
  wire                            wlast_assert_en;
  wire                            wlast_en;
  wire                            ahb_write_start_pl;
  wire                            axi_last_beat_wrdone;
  wire                            wvalid_assert_en;
  wire                            wvalid_en;
  wire                            bready_assert_en;
  wire                            bready_en;
  
  reg                             ahb_write_req_reg;
  reg                             ahb_undefbur_wrstart_reg;
  reg   [31:0]                    addr_latch;
  reg   [7:0]                     axi_len_limit;
  reg   [(DATA_WIDTH/8)-1:0]      pre_shifted_strobes;
  reg   [7:0]                     write_burst_cnt;
  reg                             axi_wvalid_ctrl;
  reg   [7:0]                     ahb_fixbur_axi_burst_len;
  reg                             ahb_undefbur_wrend_hold;
  reg                             one_data_xfer_aft_busy;
  reg                             wready_reg;
  reg                             wstrb_addr_ctrl;
  reg                             int_masterWLAST_f1;
  reg                             ahb_fixbur_busy_det_f1;
  reg                             wvalid_deassert;
  reg                             one_data_xfer_aft_busy_f1;
  reg                             axi_write_busy_ctrl;
  reg                             axi_write_busy_reg;
  reg                             axi_wvalid_ctrl_f1;
  reg                             axi_last_beat_wrdone_reg;
  reg                             ahb_undefbur_wrend_f1;
  reg                             axi_last_beat_xfer;
  
  wire [LOG_BYTE_WIDTH-1:0]       wstrb_addr;

  assign int_masterWID = 0;
  
  assign axi_bur_wrend = (ahb_undefbur_wrstart & ~ahb_undefbur_wrend & ~ahb_undefbur_wrend_hold);
  
  //always@(posedge ACLK or negedge sysReset)
  always@(*)
    if(int_masterAWVALID & int_masterAWREADY & int_masterWLAST & int_masterWVALID & int_masterWREADY)
	  axi_write_busy_ctrl <= 1'b0;
	else 
	  axi_write_busy_ctrl <= 1'b1;

  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  axi_write_busy_reg <= 1'b0;
	else if(~axi_write_busy_ctrl & ~DEF_BURST_LEN_ZERO & (MASTER_HBURST == 1))
	  axi_write_busy_reg <= 1'b1;
	else if((int_masterAWLEN == 0) & int_masterAWVALID & int_masterAWREADY)
	  axi_write_busy_reg <= 1'b0;
	else 
	  begin 
	    //if((int_masterWLAST & int_masterWVALID & int_masterWREADY) | ahb_undefbur_wrend)
	    if((int_masterWLAST & int_masterWVALID & int_masterWREADY))
	      axi_write_busy_reg <= axi_bur_wrend;	    
	    else if(int_masterAWVALID)
	      axi_write_busy_reg <= (axi_write_busy_reg & ~int_masterAWREADY);		
	  end 

  assign axi_write_busy = axi_write_busy_reg & axi_write_busy_ctrl;
  
  assign int_masterAWID = {ID_WIDTH{1'b0}};
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_write_req_reg <= 1'b0;
	else 
	  ahb_write_req_reg <= ahb_write_req;
  
  assign ahb_write_req_pl = ahb_write_req & ~ahb_write_req_reg;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_wrstart_reg <= 1'b0;
	else 
	  ahb_undefbur_wrstart_reg <= ahb_undefbur_wrstart;
  
  assign ahb_undefbur_wrstart_pl = ahb_undefbur_wrstart & ~ahb_undefbur_wrstart_reg;
  
  //assign axi_defbur_wrdone = axi_write_busy_reg & int_masterBVALID & ~ahb_undefbur_wrend & ~DEF_BURST_LEN_ZERO;
  assign axi_defbur_wrdone = axi_write_busy_reg & int_masterBVALID & ~DEF_BURST_LEN_ZERO;
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterWLAST_f1 <= 1'b0;
	else 
	  int_masterWLAST_f1 <= int_masterWLAST;  
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  addr_latch <= 0;
	else if(int_masterWREADY & int_masterWLAST & int_masterWVALID)
	//else if (int_masterWLAST & ~int_masterWLAST_f1)
	  addr_latch <= MASTER_HADDR;
  
  assign axi_write_addr = axi_defbur_wrdone ? addr_latch : MASTER_HADDR;
  
  assign axi_write_en   = (ahb_undefbur_wrstart_pl | ahb_write_req_pl | axi_defbur_wrdone);

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterAWADDR <= {ADDR_WIDTH{1'b0}};
	else if(ADDR_WIDTH > 32)
	  begin 
	    if(axi_write_en)
		  int_masterAWADDR <= {{MASK_UPPER_ADDR_BITS{1'b0}},axi_write_addr};
	  end 
	else if(axi_write_en)
	  int_masterAWADDR <= axi_write_addr[ADDR_WIDTH-1:0];
	  
  assign ahb_haddr_modulo_256 = 255 - axi_write_addr[7:0];	  
  
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
	  int_masterAWLEN <= 0;
	else if(axi_write_en)
	  int_masterAWLEN <= axi_burst_len;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterAWSIZE <= 0;
	else if(axi_write_en)
	  int_masterAWSIZE <= MASTER_HSIZE;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterAWBURST <= 0;
	else if(axi_write_en)
	  begin 
	    int_masterAWBURST[1] <= ((MASTER_HBURST[1] | MASTER_HBURST[2] ) & ~MASTER_HBURST[0]); 
	    int_masterAWBURST[0] <= ~((MASTER_HBURST[1] | MASTER_HBURST[2] ) & ~MASTER_HBURST[0]); 
	  end 
	  
  assign int_masterAWLOCK   = { 1'b0, MASTER_HMASTLOCK};  
  assign int_masterAWCACHE  = {MASTER_HPROT[5], MASTER_HPROT[5], MASTER_HPROT[3], MASTER_HPROT[2]};  
  assign int_masterAWPROT   = {~MASTER_HPROT[0], MASTER_HNONSEC, MASTER_HPROT[1]};
  assign int_masterAWQOS    = 0;
  assign int_masterAWQOS    = 0;
  assign int_masterAWREGION = 0;  
  assign int_masterAWUSER   = 0;  
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterAWVALID <= 0;
	else if(axi_write_en)
	  int_masterAWVALID <= 1'b1;
	else if(int_masterAWREADY)
      int_masterAWVALID <= 1'b0;

	  
  assign int_masterWDATA = MASTER_HWDATA;

  always@(*)
    case (MASTER_HSIZE)
	  1       : pre_shifted_strobes = 'h3;
	  2       : pre_shifted_strobes = 'hf;
	  3       : pre_shifted_strobes = 'hff;
	  4       : pre_shifted_strobes = 'hffff;
	  5       : pre_shifted_strobes = 'hffff_ffff;
	  6       : pre_shifted_strobes = 'hffff_ffff_ffff_ffff;	  
	  default : pre_shifted_strobes = 'h1;
	endcase
	  

  assign axi_beat_xfer = int_masterWVALID & int_masterWREADY;
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_wrend_hold <= 1'b0;
    //else if(int_masterBVALID)
    else if(axi_undefbur_wrdone)
      ahb_undefbur_wrend_hold <= 1'b0;
    else if (ahb_undefbur_wrend & int_masterWREADY)
      ahb_undefbur_wrend_hold <= 1'b1;	

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_wrend_f1 <= 1'b0;
    else 
      ahb_undefbur_wrend_f1 <= ahb_undefbur_wrend;
 
  //Signal is generated to detect corner condition in which axi last transaction occurs and on the next clock cycle undefined burst termination
  //is detected. In this scenerio, one more transaction needs to be generated to axi.
 
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  axi_last_beat_xfer <= 1'b0;
    else if(axi_write_busy_reg & ahb_undefbur_wrend & ~ahb_undefbur_wrend_f1)
      axi_last_beat_xfer <= 1'b1;
	else if(int_masterWVALID & int_masterWREADY)
	  axi_last_beat_xfer <= 1'b0;
	  
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_fixbur_busy_det_f1 <= 1'b0;
    else 
      ahb_fixbur_busy_det_f1 <= ahb_fixbur_busy_det;
	  
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  wstrb_addr_ctrl <= 1'b0;
	else if(axi_write_busy_reg & ~ahb_fixbur_busy_det_f1 & (~ahb_undefbur_wrend | axi_last_beat_xfer))
	  wstrb_addr_ctrl <= 1'b1;
	//else if(int_masterWVALID & int_masterWREADY)
	else if((wvalid_assert_en | int_masterWVALID) & int_masterWREADY & ~ahb_fixbur_busy_det)
	  wstrb_addr_ctrl <= 1'b0;
      
	  
  assign wstrb_addr = (wstrb_addr_ctrl & (~(int_masterWVALID & int_masterWREADY))) ? addr_latch[LOG_BYTE_WIDTH-1:0] : MASTER_HADDR[LOG_BYTE_WIDTH-1:0];	  

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterWSTRB <= 0;
	else if(int_masterWLAST & int_masterWREADY & int_masterWVALID) //Without this, protocol violation occurs.
	  int_masterWSTRB <= 0;
	else if(axi_write_en | axi_beat_xfer)
      begin 
	    if(((ahb_undefbur_wrend & int_masterWREADY) | ahb_undefbur_wrend_hold) & (~axi_last_beat_xfer | axi_beat_xfer))
		  int_masterWSTRB <= 0;
		else 
		  int_masterWSTRB <= pre_shifted_strobes << wstrb_addr;
	  end 
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      write_burst_cnt <= 0;
    else if(axi_write_en)
      write_burst_cnt <= axi_burst_len;
    else if(axi_beat_xfer)
      write_burst_cnt <= write_burst_cnt - 1'b1;	

  assign ahb_single_burst_trans = ((~(MASTER_HBURST[2] | MASTER_HBURST[1])) & axi_write_en & 
                                     (DEF_BURST_LEN_ZERO | ~MASTER_HBURST[0]));

  assign write_burst_cnt_msb_zero = (~(| write_burst_cnt[7:1]));
  
  assign fixed_burst_wlast_ctrl = write_burst_cnt[0] ? (int_masterWVALID & int_masterWREADY & ~ahb_fixbur_busy_det) : 
                                                       ~ahb_fixbur_busy_det;
													   
  assign wlast_assert_en = ((write_burst_cnt_msb_zero & write_burst_cnt[0] & int_masterWREADY & int_masterWVALID) |
                             ahb_single_burst_trans);													   
  
  assign wlast_en = (wlast_assert_en | (int_masterWREADY & int_masterWVALID));
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      int_masterWLAST <= 1'b0;
	else if (axi_write_en && (axi_burst_len == 0))
	  int_masterWLAST <= 1'b1;
    else if(wlast_en)
  	  begin 	    
	    if(int_masterWREADY & int_masterWLAST & int_masterWVALID)
		  int_masterWLAST <= 1'b0;
		else 
		  int_masterWLAST <= wlast_assert_en;
	  end 

  assign int_masterWUSER = {USER_WIDTH{1'b0}};

  assign ahb_write_start_pl = (ahb_undefbur_wrstart_pl | ahb_write_req_pl);
  
  assign axi_last_beat_wrdone = (int_masterWLAST & int_masterWREADY & int_masterWVALID);

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      axi_last_beat_wrdone_reg <= 0;
	else 
      axi_last_beat_wrdone_reg <= axi_last_beat_wrdone;
  
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      axi_wvalid_ctrl <= 0;
	else if (axi_last_beat_wrdone)
      axi_wvalid_ctrl <= 1'b0;	  
    else if(wvalid_assert_en & ~ahb_single_burst_trans & ~wvalid_deassert)// & (axi_burst_len != 0))
	  axi_wvalid_ctrl <= 1'b1;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      axi_wvalid_ctrl_f1 <= 0;
	else if (axi_last_beat_wrdone)
      axi_wvalid_ctrl_f1 <= 1'b0;	  
    else if(axi_wvalid_ctrl & (int_masterAWLEN != 0))// & (axi_burst_len != 0))
	  axi_wvalid_ctrl_f1 <= 1'b1;
	  
  //assign wvalid_assert_en = (ahb_write_start_pl | (valid_ahb_wrdata & ~axi_last_beat_wrdone_reg) | (int_masterAWVALID & int_masterAWREADY & axi_write_busy_reg & ~ahb_undefbur_wrend & ~one_data_xfer_aft_busy));
  assign wvalid_assert_en = (ahb_write_start_pl | (valid_ahb_wrdata & ~axi_last_beat_wrdone_reg) | (int_masterAWVALID & int_masterAWREADY & axi_write_busy_reg & ~one_data_xfer_aft_busy));
  
  assign wvalid_en =  ((wvalid_assert_en | ahb_fixbur_busy_det | (axi_wvalid_ctrl & (axi_burst_len != 0)) | axi_wvalid_ctrl_f1 | axi_last_beat_wrdone) & ~wvalid_deassert); 
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      wready_reg <= 1'b0;
    else if(int_masterWREADY & ahb_fixbur_busy_det)
	  wready_reg <= 1'b1;
	else if(valid_ahb_wrdata)
	  wready_reg <= 1'b0;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      one_data_xfer_aft_busy <= 1'b0;
    else if(ahb_fixbur_busy_det & int_masterWREADY & ~wready_reg)
      one_data_xfer_aft_busy <= 1'b1; 
	else if(valid_ahb_wrdata)
	  one_data_xfer_aft_busy <= 1'b0; 

//Below two signals are required to control wvalid incase if the second last transction is busy transfer for undefined burst length. 
//Generally, wvalid is asserted on the next clock cycle after axi_write_en is asserted in case when axi has transferred the AXI_BURST_LENGTH 
//and undefined burst is still not terminated. But in the case when second last transaction is busy transfer then wvalid should be delayed 
//by one more clock cycle. 
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      one_data_xfer_aft_busy_f1 <= 1'b0;
    else 
      one_data_xfer_aft_busy_f1 <= one_data_xfer_aft_busy; 
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      wvalid_deassert <= 1'b0;
	//else if((int_masterAWLEN == 0) | axi_write_en | ahb_undefbur_wrstart_pl | ahb_write_req_pl)
	else if((axi_burst_len == 0) | axi_write_en | ahb_undefbur_wrend)
	//else if((axi_burst_len == 0) | (int_masterAWVALID & int_masterAWREADY) | ahb_undefbur_wrend)
	  wvalid_deassert <= 1'b0;
    else if(one_data_xfer_aft_busy_f1 & int_masterWLAST & int_masterWREADY & int_masterWVALID)
      wvalid_deassert <= 1'b1;
	  
//	  
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      int_masterWVALID <= 0;
	else if(int_masterWREADY & int_masterWLAST & int_masterWVALID)
	  int_masterWVALID <= 1'b0;	  
	else if(wstrb_addr_ctrl & one_data_xfer_aft_busy & axi_write_en)
	  begin 
	    if(int_masterWVALID & int_masterWREADY)
		  int_masterWVALID <= 1'b0;
		else 
		  int_masterWVALID <= 1'b1;
	  end 
    else if(wvalid_en)
	  begin 
	    if(ahb_fixbur_busy_det & int_masterWREADY & ~wready_reg & ~axi_last_beat_wrdone)
		  int_masterWVALID <= 1'b0;
		else
          int_masterWVALID <= ((axi_wvalid_ctrl & ~one_data_xfer_aft_busy & ~axi_last_beat_wrdone) |
		                        wvalid_assert_en);
	  end 
    else if(~((MASTER_HBURST == 0) | ((MASTER_HBURST == 1) & DEF_BURST_LEN_ZERO)))
	  int_masterWVALID <= 1'b0;
	  
  assign bready_assert_en = (int_masterAWVALID & int_masterAWREADY);	  
  assign bready_en        = (bready_assert_en | int_masterBVALID);	  
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      int_masterBREADY <= 0;
    else if(bready_en)
	  begin 
	    if(bready_assert_en)
		  int_masterBREADY <= 1'b1;
	    else 
          int_masterBREADY <= 1'b0;
	  end 

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      axi_undefbur_wrdone <= 1'b0;
    else if(~axi_last_beat_xfer & int_masterBVALID & int_masterBREADY & ahb_undefbur_wrend)
	  axi_undefbur_wrdone <= 1'b1;
	else 
	  axi_undefbur_wrdone <= 1'b0;
	  
  
endmodule 
