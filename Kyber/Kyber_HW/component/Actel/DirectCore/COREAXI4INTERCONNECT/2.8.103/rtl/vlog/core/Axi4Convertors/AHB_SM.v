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
 
module caxi4interconnect_AHB_SM # 
(
  parameter    USER_WIDTH           = 1,
               DEF_BURST_LEN        = 0,
               ADDR_WIDTH           = 20,
               DATA_WIDTH           = 32,
               ID_WIDTH             = 1,
               BRESP_CHECK_MODE     = 2'b00,
               LOG_BYTE_WIDTH       = 2,
               BRESP_CNT_WIDTH      = 'h8
)
(
  input                           sysReset,
  input                           ACLK,
  output [ID_WIDTH-1:0]           int_masterAWID,
  output [ADDR_WIDTH-1:0]         int_masterAWADDR,
  output [7:0]                    int_masterAWLEN,
  output [2:0]                    int_masterAWSIZE,
  output [1:0]                    int_masterAWBURST,
  output [1:0]                    int_masterAWLOCK,
  output [3:0]                    int_masterAWCACHE,
  output [2:0]                    int_masterAWPROT,
  output [3:0]                    int_masterAWQOS,
  output [3:0]                    int_masterAWREGION,
  output [USER_WIDTH-1:0]         int_masterAWUSER,
  output                          int_masterAWVALID,
  input                           int_masterAWREADY,
  
  output [ID_WIDTH-1:0]           int_masterARID,
  output [ADDR_WIDTH-1:0]         int_masterARADDR,
  output [7:0]                    int_masterARLEN,
  output [2:0]                    int_masterARSIZE,
  output [1:0]                    int_masterARBURST,
  output [1:0]                    int_masterARLOCK,
  output [3:0]                    int_masterARCACHE,
  output [2:0]                    int_masterARPROT,
  output [3:0]                    int_masterARQOS,
  output [3:0]                    int_masterARREGION,
  output [USER_WIDTH-1:0]         int_masterARUSER,
  output                          int_masterARVALID,
  input                           int_masterARREADY,
  
  output [ID_WIDTH-1:0]           int_masterWID,
  output [DATA_WIDTH-1:0]         int_masterWDATA,
  output                          int_masterWLAST,
  output [(DATA_WIDTH / 8) - 1:0] int_masterWSTRB,
  output [USER_WIDTH-1:0]         int_masterWUSER,
  output                          int_masterWVALID,
  input                           int_masterWREADY,
  
  input  [ID_WIDTH-1:0]           int_masterRID,
  input  [DATA_WIDTH-1:0]         int_masterRDATA,
  input                           int_masterRLAST,
  input  [1:0]                    int_masterRRESP,
  input  [USER_WIDTH-1:0]         int_masterRUSER,
  input                           int_masterRVALID,
  output                          int_masterRREADY,
  
  input [ID_WIDTH-1:0]            int_masterBID,
  input [1:0]                     int_masterBRESP,
  input [USER_WIDTH-1:0]          int_masterBUSER,
  input                           int_masterBVALID,
  output                          int_masterBREADY,
  
  input  [31:0]                   MASTER_HADDR,
  input                           MASTER_HSEL,
  input  [2:0]                    MASTER_HBURST,
  input                           MASTER_HMASTLOCK,
  input  [6:0]                    MASTER_HPROT,
  input  [2:0]                    MASTER_HSIZE,
  input                           MASTER_HNONSEC,
  input  [1:0]                    MASTER_HTRANS,
  input  [DATA_WIDTH-1:0]         MASTER_HWDATA,
  input                           MASTER_HWRITE,
  output [DATA_WIDTH-1:0]         MASTER_HRDATA,
  output                          MASTER_HRESP,
  output                          MASTER_HREADY
);
 
  localparam DEF_BURST_LEN_ZERO  = (DEF_BURST_LEN == 0) ? 1'b1 : 1'b0;
    
  wire                            axi_write_busy;
  wire                            ahb_write_req;
  wire                            ahb_read_req;
  wire                            ahb_undefbur_wrstart;
  wire                            ahb_undefbur_wrend;
  wire                            ahb_undefbur_rdstart;
  wire                            ahb_undefbur_rdend;
  wire                            ahb_fixbur_busy_det;
  wire                            valid_ahb_wrdata;
  wire                            first_rdtxndet_aft_busy;
  wire                            axi_undefbur_wrdone;
  wire                            axi_undefbur_rddone;
 
caxi4interconnect_AHBL_Ctrl # 
(
  .DATA_WIDTH             (DATA_WIDTH              ),
  .DEF_BURST_LEN_ZERO     (DEF_BURST_LEN_ZERO      )
)
AHBL_Ctrl_inst 
(
  .ACLK                    (ACLK                   ),                
  .sysReset                (sysReset               ),            
  .MASTER_HSEL             (MASTER_HSEL            ),         
  .MASTER_HTRANS           (MASTER_HTRANS          ),       
  .MASTER_HWRITE           (MASTER_HWRITE          ),       
  .MASTER_HBURST           (MASTER_HBURST          ),       
  .int_masterWLAST         (int_masterWLAST        ),       
  .int_masterBVALID        (int_masterBVALID       ),    
  .int_masterBREADY        (int_masterBREADY       ),    
  .int_masterBRESP         (int_masterBRESP        ),     
  .int_masterRVALID        (int_masterRVALID       ),    
  .int_masterRREADY        (int_masterRREADY       ),    
  .int_masterRLAST         (int_masterRLAST        ),     
  .int_masterRRESP         (int_masterRRESP        ),     
  .int_masterRDATA         (int_masterRDATA        ),     
  .int_masterWREADY        (int_masterWREADY       ),    
  .axi_write_busy          (axi_write_busy         ),      
  .MASTER_HRDATA           (MASTER_HRDATA          ),       
  .MASTER_HRESP            (MASTER_HRESP           ),        
  .MASTER_HREADY           (MASTER_HREADY          ),       
  .ahb_write_req           (ahb_write_req          ),       
  .ahb_read_req            (ahb_read_req           ),        
  .ahb_undefbur_wrstart    (ahb_undefbur_wrstart   ),
  .ahb_undefbur_wrend      (ahb_undefbur_wrend     ),  
  .ahb_undefbur_rdstart    (ahb_undefbur_rdstart   ),
  .ahb_undefbur_rdend      (ahb_undefbur_rdend     ),  
  .ahb_fixbur_busy_det     (ahb_fixbur_busy_det    ),
  .valid_ahb_wrdata        (valid_ahb_wrdata       ),
  .first_rdtxndet_aft_busy (first_rdtxndet_aft_busy),
  .axi_undefbur_wrdone     (axi_undefbur_wrdone    ),
  .axi_undefbur_rddone     (axi_undefbur_rddone    )
);

caxi4interconnect_AXI4_Write_Ctrl # 
(
  .USER_WIDTH          (USER_WIDTH         ),
  .DEF_BURST_LEN       (DEF_BURST_LEN      ),
  .DATA_WIDTH          (DATA_WIDTH         ),
  .ID_WIDTH            (ID_WIDTH           ),
  .LOG_BYTE_WIDTH      (LOG_BYTE_WIDTH     ),
  .DEF_BURST_LEN_ZERO  (DEF_BURST_LEN_ZERO ),
  .ADDR_WIDTH          (ADDR_WIDTH         )
)
AXI4_Write_Ctrl_inst 
(
  .ACLK                   (ACLK                 ),                
  .sysReset               (sysReset             ),            
  .ahb_write_req          (ahb_write_req        ),
  .ahb_undefbur_wrstart   (ahb_undefbur_wrstart ),
  .ahb_undefbur_wrend     (ahb_undefbur_wrend   ),
  .ahb_fixbur_busy_det    (ahb_fixbur_busy_det  ),
  .int_masterAWREADY      (int_masterAWREADY    ),
  .int_masterWREADY       (int_masterWREADY     ),
  .int_masterBVALID       (int_masterBVALID     ),
  .MASTER_HADDR           (MASTER_HADDR         ),
  .MASTER_HBURST          (MASTER_HBURST        ),       
  .MASTER_HMASTLOCK       (MASTER_HMASTLOCK     ),  
  .MASTER_HPROT           (MASTER_HPROT         ),  
  .MASTER_HSIZE           (MASTER_HSIZE         ),       
  .MASTER_HWDATA          (MASTER_HWDATA        ),       
  .MASTER_HNONSEC         (MASTER_HNONSEC       ),
  .valid_ahb_wrdata       (valid_ahb_wrdata     ),

  .axi_write_busy         (axi_write_busy       ),
  .axi_undefbur_wrdone    (axi_undefbur_wrdone  ),
  .int_masterAWID         (int_masterAWID       ),
  .int_masterAWADDR       (int_masterAWADDR     ),  
  .int_masterAWLEN        (int_masterAWLEN      ),  
  .int_masterAWSIZE       (int_masterAWSIZE     ),  
  .int_masterAWBURST      (int_masterAWBURST    ),  
  .int_masterAWLOCK       (int_masterAWLOCK     ),  
  .int_masterAWCACHE      (int_masterAWCACHE    ),  
  .int_masterAWPROT       (int_masterAWPROT     ),  
  .int_masterAWQOS        (int_masterAWQOS      ),  
  .int_masterAWREGION     (int_masterAWREGION   ),  
  .int_masterAWUSER       (int_masterAWUSER     ),  
  .int_masterAWVALID      (int_masterAWVALID    ),  
  .int_masterWID          (int_masterWID        ),  
  .int_masterWDATA        (int_masterWDATA      ),  
  .int_masterWSTRB        (int_masterWSTRB      ),
  .int_masterWLAST        (int_masterWLAST      ),
  .int_masterWUSER        (int_masterWUSER      ),
  .int_masterWVALID       (int_masterWVALID     ),
  .int_masterBREADY       (int_masterBREADY     )  
);

caxi4interconnect_AXI4_Read_Ctrl # 
(
  .USER_WIDTH          (USER_WIDTH         ),
  .DEF_BURST_LEN       (DEF_BURST_LEN      ),
  .DATA_WIDTH          (DATA_WIDTH         ),
  .ID_WIDTH            (ID_WIDTH           ),
  .LOG_BYTE_WIDTH      (LOG_BYTE_WIDTH     ),
  .DEF_BURST_LEN_ZERO  (DEF_BURST_LEN_ZERO ),
  .ADDR_WIDTH          (ADDR_WIDTH         )
)
AXI4_Read_Ctrl_inst 
(
  .ACLK                    (ACLK                   ),                                
  .sysReset                (sysReset               ),                        
  .ahb_read_req            (ahb_read_req           ),
  .ahb_undefbur_rdstart    (ahb_undefbur_rdstart   ),
  .ahb_undefbur_rdend      (ahb_undefbur_rdend     ),
  .ahb_fixbur_busy_det     (ahb_fixbur_busy_det    ),
  .int_masterARREADY       (int_masterARREADY      ),
  .MASTER_HADDR            (MASTER_HADDR           ),
  .MASTER_HBURST           (MASTER_HBURST          ),       
  .MASTER_HMASTLOCK        (MASTER_HMASTLOCK       ),  
  .MASTER_HPROT            (MASTER_HPROT           ),         
  .MASTER_HSIZE            (MASTER_HSIZE           ),         
  .MASTER_HNONSEC          (MASTER_HNONSEC         ),  
  .int_masterRLAST         (int_masterRLAST        ),       
  .int_masterRVALID        (int_masterRVALID       ),       
                                                   
                                                   
  .int_masterARID          (int_masterARID         ),
  .int_masterARADDR        (int_masterARADDR       ),
  .int_masterARLEN         (int_masterARLEN        ),  
  .int_masterARSIZE        (int_masterARSIZE       ),  
  .int_masterARBURST       (int_masterARBURST      ),  
  .int_masterARLOCK        (int_masterARLOCK       ),  
  .int_masterARCACHE       (int_masterARCACHE      ),  
  .int_masterARPROT        (int_masterARPROT       ),  
  .int_masterARQOS         (int_masterARQOS        ),  
  .int_masterARREGION      (int_masterARREGION     ),  
  .int_masterARUSER        (int_masterARUSER       ),  
  .int_masterARVALID       (int_masterARVALID      ),  
  .int_masterRREADY        (int_masterRREADY       ),
  .first_rdtxndet_aft_busy (first_rdtxndet_aft_busy),
  .axi_undefbur_rddone     (axi_undefbur_rddone    )
); 

endmodule

