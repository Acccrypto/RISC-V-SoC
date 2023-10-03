module caxi4interconnect_AHBL_Ctrl # 
(
   parameter        DATA_WIDTH           = 32,
   parameter        DEF_BURST_LEN_ZERO   = 0
)
(
  input                       ACLK,                
  input                       sysReset,            
  input                       MASTER_HSEL,         
  input  [1:0]                MASTER_HTRANS,       
  input                       MASTER_HWRITE,       
  input  [2:0]                MASTER_HBURST,       
  input                       int_masterWLAST,       
  input                       int_masterBVALID,    
  input                       int_masterBREADY,    
  input  [1:0]                int_masterBRESP,     
  input                       int_masterRVALID,    
  input                       int_masterRREADY,    
  input                       int_masterRLAST,     
  input  [1:0]                int_masterRRESP,     
  input  [DATA_WIDTH-1:0]     int_masterRDATA,     
  input                       int_masterWREADY,    
  input                       axi_write_busy,      
  input                       axi_undefbur_wrdone,      
  input                       axi_undefbur_rddone,      
  output reg [DATA_WIDTH-1:0] MASTER_HRDATA,       
  output reg                  MASTER_HRESP,        
  output                      MASTER_HREADY,       
  output                      ahb_write_req,       
  output                      ahb_read_req,        
  output                      ahb_undefbur_wrstart,
  output                      ahb_undefbur_wrend,  
  output                      ahb_undefbur_rdstart,
  output                      ahb_undefbur_rdend,  
  output                      ahb_fixbur_busy_det,
  output                      valid_ahb_wrdata,
  output reg                  first_rdtxndet_aft_busy
);

  wire                        axi_wrresp;
  wire                        axi_rdresp;
  wire                        new_trans;
  wire                        axi_rdwr_comp;
  wire                        ahb_singlebur_hrdy_ctrl_en;
  wire                        ahb_single_undef_bur;
  wire                        new_trans_pl;
  wire                        ahb_burst_cnt_zero;
  wire                        ahb_burst_cnt_one;
  wire                        ahb_fixbur_hrdy_ctrl;
  wire                        ahb_fixbur_hrdy_reg_en; 
  wire                        ahb_undefbur_hrdy_reg_en;
  wire                        ahb_undefbur_hrdy_ctrl;
  wire                        ahb_undefbur_end_hrdy_ctrl;
  wire                        ahb_write_det;
  wire                        ahb_fixed_burst;
  wire                        ahb_read_det;
  wire                        ahb_undefbur_wrdet;
  wire                        ahb_undefbur_rddet;
  wire                        axi_read_comp;
  wire                        incr_undef_burst;
  wire                        ahb_fixbur_busy;
  wire                        ahb_write_req_hold;
  wire                        ahb_read_req_hold;
  wire                        hready_assert;
  reg                         ahb_busy_seq;

  
  
  reg                         axi_wrresp_reg;
  reg                         axi_rdresp_reg;
  reg                         ahb_singlebur_hrdy_ctrl;
  reg  [3:0]                  ahb_burst_cnt;
  reg                         new_trans_reg;
  reg                         ahb_fixbur_hrdy_reg;
  reg                         ahb_write_det_reg;
  reg                         ahb_undefbur_hrdy_reg;
  reg                         new_trans_hold;
  reg                         ahb_undefbur_wrdet_reg;
  reg                         ahb_read_det_reg;
  reg                         ahb_undefbur_rddet_reg;
  reg  [3:0]                  ahb_burst_cnt_load_data;
  reg                         rlast_reg;
  reg                         int_masterRLAST_reg;
  reg                         incr_undef_burst_reg;
  reg                         ahb_undefbur_wrend_hold;
  reg                         ahb_undefbur_rdend_hold;
  reg                         ahb_fixbur_busy_hold;
  reg                         axi_rdresp_hold;
  reg                         MASTER_HREADY_f1;
  reg                         data_not_valid;
  reg                         axi_rdresp_ctrl;
  wire                        invalid_data;
  wire                        ahb_fixbur_busy_rdhrdy_ctrl;
  reg                         ahb_undefbur_last_read_done;
  reg                         int_masterRVALID_f1;
  reg                         ahb_undefbur_last_read_ctrl;
  reg  [9:0]                  read_req_cntr;
  reg  [9:0]                  read_data_cntr;
  reg                         ahb_fixbur_busy_f1;  
  reg                         read_data_cntr_en;  
  reg                         ahb_undefbur_hrdy_deassert_ctrl;  
  reg                         ahb_fixbur_hrdy_deassert_ctrl;  
  
  //To read the last data for undefined burst transaction, below logic is used.Signal is asserted when undefined burst end detected and 
  //read valid is asserted.Signal is de-asserted when transaction is completed.
  

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      ahb_fixbur_busy_f1 <= 0;
	else 
	  ahb_fixbur_busy_f1 <= ahb_fixbur_busy;
  
  //Counters to count number of read request and number of data read. These two counters are used to decide how many read data should be 
  //ignored after detecting termination of undefined burst transaction when DEF_BURST_LEN is not zero.
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      read_req_cntr <= 0;
	else if(axi_undefbur_rddone)
	  read_req_cntr <= 0;
	else if(MASTER_HTRANS[1] & MASTER_HREADY & ~MASTER_HWRITE)
	  read_req_cntr <= read_req_cntr + 1'b1;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      read_data_cntr_en <= 1'b0;
	else if((MASTER_HTRANS == 1) & MASTER_HREADY & ahb_undefbur_rdstart)
	  read_data_cntr_en <= ~int_masterRVALID;
	else if((MASTER_HTRANS != 1) & int_masterRVALID)
	  read_data_cntr_en <= 1'b0;
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      read_data_cntr <= 0;
	else if(axi_undefbur_rddone)
	  read_data_cntr <= 0;
    else if(int_masterRVALID & int_masterRREADY & (MASTER_HTRANS != 1) & ~read_data_cntr_en)
	  read_data_cntr <= read_data_cntr + 1'b1;

	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      int_masterRVALID_f1 <= 1'b0;
	else 
	  int_masterRVALID_f1 <= int_masterRVALID;

	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      ahb_undefbur_last_read_ctrl <= 1'b0;
    else if(ahb_undefbur_rddet)
      ahb_undefbur_last_read_ctrl <= 1'b0;
    else if(ahb_fixbur_busy)
   	  ahb_undefbur_last_read_ctrl <= 1'b1;
	  
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      ahb_undefbur_last_read_done <= 1'b0;
	else if (ahb_undefbur_rdend & (read_req_cntr <= read_data_cntr))
	  ahb_undefbur_last_read_done <= 1'b1;
	else if(MASTER_HREADY)
	  ahb_undefbur_last_read_done <= 1'b0;
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  MASTER_HRDATA <= {DATA_WIDTH{1'b0}};
	else if(int_masterRVALID & ~ahb_undefbur_last_read_done & (~(ahb_undefbur_rdend & (read_req_cntr <= read_data_cntr))))
	  MASTER_HRDATA <= int_masterRDATA;


  assign   axi_wrresp = (int_masterBVALID & int_masterBREADY & int_masterBRESP[1]);
  assign   axi_rdresp = (int_masterRVALID & int_masterRREADY & int_masterRRESP[1]);
  
  always@(posedge ACLK or negedge sysReset)
   if(~sysReset)
    axi_wrresp_reg <= 1'b0;
  else if(int_masterBVALID & int_masterBREADY & int_masterBRESP[1])
    axi_wrresp_reg <= 1'b1;
  else 
    axi_wrresp_reg <= 1'b0;

 always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  axi_rdresp_ctrl <= 1'b0;
	else
	  axi_rdresp_ctrl <= (ahb_undefbur_rddet_reg | ahb_read_det_reg);
 	

 always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  axi_rdresp_reg <= 1'b0;
	else if(axi_rdresp)
	  axi_rdresp_reg <= 1'b1;
	else if(~axi_rdresp_ctrl)
	  axi_rdresp_reg <= 1'b0;
	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  axi_rdresp_hold <= 1'b0;
	else if(int_masterRLAST & int_masterRREADY & int_masterRVALID & (int_masterRRESP[1] | axi_rdresp_reg))
	  axi_rdresp_hold <= 1'b1;
	else 
	  axi_rdresp_hold <= 1'b0;
	  
  always@(*)
    begin 
	  if (axi_rdresp_ctrl)
	    begin 
		  if((int_masterRLAST & int_masterRREADY & int_masterRVALID & int_masterRRESP[1]) | axi_rdresp_hold)
	        MASTER_HRESP = 1'b1;
		  else 
		    MASTER_HRESP = 1'b0;
	    end 
	  else 
	    begin 
		  if((int_masterBVALID & int_masterBREADY & int_masterBRESP[1]) | axi_wrresp_reg)
	        MASTER_HRESP = 1'b1;
		  else 
		    MASTER_HRESP = 1'b0;
		end
    end 	
	
  // Logic for new transaction detection. When DEF_BURST_LEN_ZERO is one, on the detection of single/incr burst trans.
  // this signal is asserted else it is asserted only when single burst trans. is detected. 
  
  assign new_trans = (DEF_BURST_LEN_ZERO & (~MASTER_HBURST[2] & ~MASTER_HBURST[1] & MASTER_HBURST[0])) ? (MASTER_HTRANS[1] & MASTER_HSEL & MASTER_HREADY) :
                                           (MASTER_HTRANS[1] & ~MASTER_HTRANS[0] & MASTER_HSEL & MASTER_HREADY);

  assign axi_rdwr_comp = ((int_masterBVALID & int_masterBREADY) | (int_masterRREADY & int_masterRLAST & int_masterRVALID));  //Indicates AXI read/write complete

  assign ahb_single_undef_bur = DEF_BURST_LEN_ZERO ? ~(| MASTER_HBURST[2:1]) : ~(| MASTER_HBURST[2:0]);  
  
  assign ahb_singlebur_hrdy_ctrl_en = ((axi_rdwr_comp | new_trans ) & ahb_single_undef_bur);
  
  //Logic to control HREADY during single burst or incr burst (if DEF_BURST_LEN is zero). 
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_singlebur_hrdy_ctrl <= 1'b1;
//	else if((MASTER_HTRANS == 2'b01) & ~MASTER_HWRITE)
//	  ahb_singlebur_hrdy_ctrl <= 1'b1;
	else if(ahb_singlebur_hrdy_ctrl_en)
	  begin 
	    if(axi_rdwr_comp)
		  ahb_singlebur_hrdy_ctrl <= 1'b1;
		else 
		  ahb_singlebur_hrdy_ctrl <= ~new_trans;
	  end 

  //Burst count load data logic. For fixed burst, counter is loaded with value 3,7 or 15 based on INCR4/WRAP4, INCR8/WRAP8
  //or INCR16/WRAP16  
	  
  always @(*)
    begin 
	  case(MASTER_HBURST[2:1])
	    2       : ahb_burst_cnt_load_data = 7;
	    3       : ahb_burst_cnt_load_data = 15;
	    default : ahb_burst_cnt_load_data = 3;
	  endcase 
    end 	

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  new_trans_reg <= 1'b0;
	else if(new_trans)  
	  new_trans_reg <= 1'b1;
	else if(axi_rdwr_comp)
	  new_trans_reg <= 1'b0;
  
  assign new_trans_pl = new_trans & ~new_trans_reg; // Rising edge pulse of new trans	  
  
  //Burst Count Logic. Counter is loaded when new transaction is detected or axi write repsonse is received or 
  //axi read last is detected. It is loaded with the vallue 3,7 or 15 depends on the AHB Burst. 
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  rlast_reg <= 1'b0;
	else if(axi_read_comp)  
	  rlast_reg <= 1'b1;
	else 
	  rlast_reg <= 1'b0;
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_burst_cnt <= 4'h3;
	else if(ahb_undefbur_wrstart | ahb_undefbur_rdstart)
	  ahb_burst_cnt <= ahb_burst_cnt_load_data;
	else if(new_trans_pl | ((int_masterBVALID & int_masterBREADY) | rlast_reg))
	  ahb_burst_cnt <= ahb_burst_cnt_load_data;
	else if(MASTER_HTRANS[1] & MASTER_HREADY)
	  ahb_burst_cnt <= ahb_burst_cnt - 1'b1;

  assign ahb_burst_cnt_zero = ~(| ahb_burst_cnt[3:0]);	  //Burst counter value 0
  assign ahb_burst_cnt_one  = ~(| {ahb_burst_cnt[3:1],~ahb_burst_cnt[0]}); //Burst counter value 1
  assign axi_read_not_ready = ~(int_masterRVALID);  //AXI not ready for the read
  assign ahb_fixbur_hrdy_reg_en = (MASTER_HBURST[1] | MASTER_HBURST[2] | axi_rdwr_comp | rlast_reg); // Fixed Burst.
  //assign ahb_fixundef_busy_rdhrdy_ctrl = (ahb_read_req_hold & (MASTER_HTRANS == 2'b01));
  assign ahb_fixbur_busy_rdhrdy_ctrl = (ahb_read_req_hold & (MASTER_HTRANS == 2'b01));  

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_fixbur_hrdy_deassert_ctrl <= 1'b0;
	else if((MASTER_HTRANS == 1) & int_masterRVALID & ~int_masterRVALID_f1)
	  ahb_fixbur_hrdy_deassert_ctrl <= 1'b1;
	else if(MASTER_HTRANS != 1)
	  ahb_fixbur_hrdy_deassert_ctrl <= 1'b0;

	  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_fixbur_hrdy_reg <= 1'b1;
	else if((ahb_single_undef_bur | ahb_undefbur_wrstart | ahb_undefbur_rdstart) & (MASTER_HTRANS != 0))
	  ahb_fixbur_hrdy_reg <= 1'b1;
	else if(ahb_fixbur_hrdy_reg_en)
	  begin 
	    if((ahb_fixbur_busy_f1 & (MASTER_HTRANS != 1) & ahb_read_req_hold & (ahb_fixbur_hrdy_deassert_ctrl | axi_rdwr_comp)) | ahb_read_det) 
		  ahb_fixbur_hrdy_reg <= 1'b0;
	    else if(ahb_burst_cnt_zero | (ahb_read_req_hold & ahb_burst_cnt_one & axi_read_comp) | rlast_reg)
	      ahb_fixbur_hrdy_reg <= 1'b1;
		else 
		  ahb_fixbur_hrdy_reg <= ~(ahb_burst_cnt_zero | (ahb_burst_cnt_one & MASTER_HREADY) | 
		                          (ahb_read_req_hold & axi_read_not_ready));
	  end 
  
  //Logic to control HREADY during fixed burst operation.
  
  assign ahb_fixbur_hrdy_ctrl = ahb_write_det_reg ? (ahb_fixbur_hrdy_reg & int_masterWREADY) :
                                                    (ahb_fixbur_hrdy_reg);
													
  //Logic to enable undefined burst HREADY control. 
													
  assign ahb_undefbur_hrdy_reg_en = DEF_BURST_LEN_ZERO ? 1'b0 : (MASTER_HBURST[0] & ~MASTER_HBURST[1] & ~MASTER_HBURST[2]);													 
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_hrdy_deassert_ctrl <= 1'b0;
	else if((MASTER_HTRANS == 1) & int_masterRVALID & ~int_masterRVALID_f1)
	  ahb_undefbur_hrdy_deassert_ctrl <= 1'b1;
	else if(MASTER_HTRANS != 1)
	  ahb_undefbur_hrdy_deassert_ctrl <= 1'b0;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_hrdy_reg <= 1'b1;
	else if((ahb_undefbur_wrend | ahb_undefbur_rdend) & axi_rdwr_comp)
	  ahb_undefbur_hrdy_reg <= 1'b1;
	else if(ahb_undefbur_hrdy_reg_en)
	  begin 
	    if((ahb_fixbur_busy_f1 & (MASTER_HTRANS != 1) & ahb_undefbur_rdstart & (ahb_undefbur_hrdy_deassert_ctrl | axi_rdwr_comp)) | ahb_undefbur_rddet)
	      ahb_undefbur_hrdy_reg <= 1'b0;
	    else 
	      ahb_undefbur_hrdy_reg <=  (~(ahb_undefbur_rdstart & axi_read_not_ready));
	  end 
	  
  assign ahb_undefbur_hrdy_ctrl = ahb_undefbur_wrdet_reg ? (ahb_undefbur_hrdy_reg & ~axi_write_busy & int_masterWREADY) :
                                                           (ahb_undefbur_hrdy_reg);

  assign incr_undef_burst = (~MASTER_HBURST[2] & ~MASTER_HBURST[1] & MASTER_HBURST[0] & ~DEF_BURST_LEN_ZERO); 		

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  incr_undef_burst_reg <= 1'b0;	
	else if(axi_undefbur_wrdone | axi_undefbur_rddone) 
      incr_undef_burst_reg <= 1'b0;
	else if(new_trans_pl)
      incr_undef_burst_reg <= incr_undef_burst;

  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  new_trans_hold <= 1'b0;
	else if(axi_undefbur_wrdone | axi_undefbur_rddone)	       
      new_trans_hold <= 1'b0;
	else if(new_trans_pl)
      new_trans_hold <= incr_undef_burst;

  //Detects termination of the undefined burst trans.
	  
  assign ahb_undefbur_end_hrdy_ctrl = (~new_trans_hold | MASTER_HTRANS[0]);
  
  assign MASTER_HREADY = ((ahb_singlebur_hrdy_ctrl & ahb_fixbur_hrdy_ctrl & ahb_undefbur_hrdy_ctrl & 
                          ahb_undefbur_end_hrdy_ctrl) | hready_assert);

  //Detects fixed burst transaction. 
  
  assign ahb_fixed_burst = (DEF_BURST_LEN_ZERO | ~MASTER_HBURST[0] | MASTER_HBURST[1] | MASTER_HBURST[2]);
  
  //Detects AHB Write trans. 
  
  assign ahb_write_det   = (new_trans & MASTER_HWRITE & ahb_fixed_burst);
  
  //Hold the AHB Write trans. signal until write operation is finished. 

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_write_det_reg <= 1'b0;
	else if(ahb_write_det)
      ahb_write_det_reg <= 1'b1;
	else if(int_masterWLAST)
      ahb_write_det_reg <= 1'b0;
 	  
  assign ahb_write_req_hold = (ahb_write_det | ahb_write_det_reg);
  assign ahb_write_req = (ahb_write_det);
						   
  //Detects AHB Read trans. 
  
  assign ahb_read_det   = (new_trans & ~MASTER_HWRITE & ahb_fixed_burst);
  
  //Hold the AHB Read trans. signal until read operation is finished. 
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  int_masterRLAST_reg <= 1'b0;
	else 
      int_masterRLAST_reg <= int_masterRLAST;

  assign axi_read_comp = (int_masterRREADY & int_masterRLAST & int_masterRVALID);
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_read_det_reg <= 1'b0;
	else if(ahb_read_det)
      ahb_read_det_reg <= 1'b1;
	else if(axi_read_comp)
      ahb_read_det_reg <= 1'b0;
 	  
  assign ahb_read_req_hold = (ahb_read_det | ahb_read_det_reg);
  assign ahb_read_req      = (ahb_read_det);
  
  //Detects AHB Undefined burst Write trans. 
  
  assign ahb_undefbur_wrdet   = (new_trans & MASTER_HWRITE & ~ahb_fixed_burst);
  
  //Hold the AHB Undefined burst Write trans. signal until write operation is finished. 

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_wrdet_reg <= 1'b0;
	else if(ahb_undefbur_wrdet)
      ahb_undefbur_wrdet_reg <= 1'b1;
	//else if(ahb_undefbur_wrend_hold & int_masterBVALID & int_masterBREADY)
	else if(axi_undefbur_wrdone)
      ahb_undefbur_wrdet_reg <= 1'b0;
 	  
  assign ahb_undefbur_wrstart = (ahb_undefbur_wrdet | ahb_undefbur_wrdet_reg);
  
  //Detects AHB Undefined burst Read trans. 
  
  assign ahb_undefbur_rddet   = (new_trans & ~MASTER_HWRITE & ~ahb_fixed_burst);
  
  //Hold the AHB Undefined burst Write trans. signal until write operation is finished. 

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_rddet_reg <= 1'b0;
	else if(ahb_undefbur_rddet)
      ahb_undefbur_rddet_reg <= 1'b1;
	else if(ahb_undefbur_rdend)
      ahb_undefbur_rddet_reg <= 1'b0;
 	  
  assign ahb_undefbur_rdstart = (ahb_undefbur_rddet | ahb_undefbur_rddet_reg);
  
  assign ahb_undefbur_wrend = (new_trans_hold & (~(MASTER_HTRANS[0])) & MASTER_HWRITE & 
                              (incr_undef_burst | incr_undef_burst_reg));

  assign ahb_undefbur_rdend = (new_trans_hold & (~(MASTER_HTRANS[0])) & ~MASTER_HWRITE & 
                              (incr_undef_burst | incr_undef_burst_reg));
						  
  
  
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_wrend_hold <= 1'b0;
    else if(int_masterBVALID & int_masterBREADY)
      ahb_undefbur_wrend_hold <= 1'b0;
    else if (ahb_undefbur_wrend)
      ahb_undefbur_wrend_hold <= 1'b1;	

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_undefbur_rdend_hold <= 1'b0;
    else if(rlast_reg)
      ahb_undefbur_rdend_hold <= 1'b0;
    else if (ahb_undefbur_rdend)
      ahb_undefbur_rdend_hold <= 1'b1;	
	  
  assign ahb_fixbur_busy = ((ahb_write_det_reg | ahb_read_det_reg | ahb_undefbur_wrdet_reg | ahb_undefbur_rddet_reg) & MASTER_HTRANS[0] & ~MASTER_HTRANS[1] & 
                            ~ahb_single_undef_bur);
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_fixbur_busy_hold <= 1'b0;
	else if(ahb_fixbur_busy & ~ahb_read_det_reg & ~ahb_undefbur_rddet_reg)
	  ahb_fixbur_busy_hold <= 1'b1;
	else if(MASTER_HTRANS[0] & MASTER_HTRANS[1] & MASTER_HREADY)
	  ahb_fixbur_busy_hold <= 1'b0;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  MASTER_HREADY_f1 <= 1'b1;
	else
	  MASTER_HREADY_f1 <= MASTER_HREADY;
	  
  //Logic to delay valid_ahb_wrdata by 1 clock cycle if BUSY transaction is accepted just before the SEQ transaction.
  //If Busy transaction is accepted and on the next clock cycle HREADY is high then data is valid otherwise when HREADY is 
  //asserted again at that time 1 clock cycle delay is given because valid data will be received after one clock cycle after 
  //SEQ transaction is accepted.  

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  data_not_valid <= 1'b0;
	else if((MASTER_HTRANS == 1) & MASTER_HREADY & ~MASTER_HREADY_f1 & MASTER_HWRITE)
	  data_not_valid <= 1'b1;
	else if(MASTER_HREADY)
	  data_not_valid <= 1'b0;

  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
	  ahb_busy_seq <= 1'b0;
	else if((MASTER_HTRANS == 1) & MASTER_HREADY & MASTER_HWRITE)
	  ahb_busy_seq <= 1'b1;
	else if(MASTER_HTRANS != 1)
	  ahb_busy_seq <= 1'b0;


  //If data_not_valid is high and int_masterWREADY is low then, HREADY should be driven high for one clock cycle otherwise int_masterWVALID goes low 
  //as valid_ahb_wrdata is low and never assert again as valid_ahb_wrdata always remains zero since new SEQUENTIAL transaction won't be accepted
  //until int_masterWREADY is high again. So to remove the dependancy of int_masterWREADY into this condition new signal is generated to 
  //drive HREADY high for one clock cycle. 
  
  assign hready_assert = ((data_not_valid | (ahb_busy_seq & MASTER_HTRANS != 1)) & ~int_masterWREADY);
  
  assign invalid_data = (data_not_valid & ~MASTER_HREADY);	    
	  
  assign ahb_fixbur_busy_det = ((ahb_fixbur_busy | ahb_fixbur_busy_hold));
  
  assign valid_ahb_wrdata = (MASTER_HTRANS[1] & MASTER_HREADY & MASTER_HWRITE & ~invalid_data);
  
  always@(posedge ACLK or negedge sysReset)
    if(~sysReset)
      first_rdtxndet_aft_busy <= 1'b0;	
	else if(int_masterRVALID)
	  first_rdtxndet_aft_busy <= 1'b0;
	else if((~(MASTER_HREADY & ~MASTER_HREADY_f1)) & (MASTER_HTRANS == 2'b01) & (ahb_fixbur_hrdy_reg_en | ahb_undefbur_hrdy_reg_en) & 
	        (ahb_read_req_hold | ahb_undefbur_rdstart))	
	  first_rdtxndet_aft_busy <= 1'b1;
														   
endmodule 