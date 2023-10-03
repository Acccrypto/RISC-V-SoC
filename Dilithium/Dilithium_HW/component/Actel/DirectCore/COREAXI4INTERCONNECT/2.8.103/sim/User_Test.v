// ********************************************************************
//  Microsemi Corporation Proprietary and Confidential
//  Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: COREAXI4INTERCONNECT testbench
//
// caxi4interconnect_revision Information:
// Date     Description     User Testbench to exercise COREAXI4INTERCONNECT. It exercises writes and reads from all
//                          masters to all slaves. The parameters can be changed in the parameter_incl.v file to change
//                          the core's operation. Models for AXI Masters and Slaves are used to exercise core.
// Feb17    caxi4interconnect_revision 1.0
//
// Notes:
// best viewed with tabstops set to "4"
// ********************************************************************
`timescale 1ns / 1ns



module testbench ();

`include "./parameter_incl.v"            // performs detailed verification of AXI4CROSS

  localparam integer SUPPORT_USER_SIGNALS   = 0;        // indicates where user signals upport - 0 mean no, 1 means yes
  localparam [(ADDR_WIDTH-UPPER_COMPARE_BIT) -1:0]   NXM_DEC =  `DECWIDTH;  // Memory space ADDR[31:28] == 4'd8 is undecoded space.

  //====================================================================
  // Register Slice parameters
  //====================================================================  
  localparam [0:0]  MASTER0_AWCHAN_RS = MASTER0_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  MASTER1_AWCHAN_RS = MASTER1_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  MASTER2_AWCHAN_RS = MASTER2_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  MASTER3_AWCHAN_RS = MASTER3_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  MASTER4_AWCHAN_RS = MASTER4_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  MASTER5_AWCHAN_RS = MASTER5_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  MASTER6_AWCHAN_RS = MASTER6_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  MASTER7_AWCHAN_RS = MASTER7_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
              
  localparam [0:0]  MASTER0_ARCHAN_RS = MASTER0_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  MASTER1_ARCHAN_RS = MASTER1_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  MASTER2_ARCHAN_RS = MASTER2_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  MASTER3_ARCHAN_RS = MASTER3_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  MASTER4_ARCHAN_RS = MASTER4_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  MASTER5_ARCHAN_RS = MASTER5_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  MASTER6_ARCHAN_RS = MASTER6_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  MASTER7_ARCHAN_RS = MASTER7_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
             
  localparam [0:0]  MASTER0_WCHAN_RS = MASTER0_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  MASTER1_WCHAN_RS = MASTER1_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  MASTER2_WCHAN_RS = MASTER2_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  MASTER3_WCHAN_RS = MASTER3_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  MASTER4_WCHAN_RS = MASTER4_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  MASTER5_WCHAN_RS = MASTER5_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  MASTER6_WCHAN_RS = MASTER6_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  MASTER7_WCHAN_RS = MASTER7_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
             
  localparam [0:0]  MASTER0_RCHAN_RS = MASTER0_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  MASTER1_RCHAN_RS = MASTER1_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  MASTER2_RCHAN_RS = MASTER2_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  MASTER3_RCHAN_RS = MASTER3_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  MASTER4_RCHAN_RS = MASTER4_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  MASTER5_RCHAN_RS = MASTER5_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  MASTER6_RCHAN_RS = MASTER6_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  MASTER7_RCHAN_RS = MASTER7_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
              
  localparam [0:0]  MASTER0_BCHAN_RS = MASTER0_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  MASTER1_BCHAN_RS = MASTER1_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  MASTER2_BCHAN_RS = MASTER2_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  MASTER3_BCHAN_RS = MASTER3_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  MASTER4_BCHAN_RS = MASTER4_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  MASTER5_BCHAN_RS = MASTER5_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  MASTER6_BCHAN_RS = MASTER6_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  MASTER7_BCHAN_RS = MASTER7_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
              
  localparam [0:0]  SLAVE0_AWCHAN_RS  = SLAVE0_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE1_AWCHAN_RS  = SLAVE1_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE2_AWCHAN_RS  = SLAVE2_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE3_AWCHAN_RS  = SLAVE3_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE4_AWCHAN_RS  = SLAVE4_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE5_AWCHAN_RS  = SLAVE5_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE6_AWCHAN_RS  = SLAVE6_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE7_AWCHAN_RS  = SLAVE7_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE8_AWCHAN_RS  = SLAVE8_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE9_AWCHAN_RS  = SLAVE9_CHAN_RS;   // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE10_AWCHAN_RS = SLAVE10_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE11_AWCHAN_RS = SLAVE11_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE12_AWCHAN_RS = SLAVE12_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE13_AWCHAN_RS = SLAVE13_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE14_AWCHAN_RS = SLAVE14_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE15_AWCHAN_RS = SLAVE15_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE16_AWCHAN_RS = SLAVE16_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE17_AWCHAN_RS = SLAVE17_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE18_AWCHAN_RS = SLAVE18_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE19_AWCHAN_RS = SLAVE19_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE20_AWCHAN_RS = SLAVE20_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE21_AWCHAN_RS = SLAVE21_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE22_AWCHAN_RS = SLAVE22_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE23_AWCHAN_RS = SLAVE23_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE24_AWCHAN_RS = SLAVE24_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE25_AWCHAN_RS = SLAVE25_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE26_AWCHAN_RS = SLAVE26_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE27_AWCHAN_RS = SLAVE27_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE28_AWCHAN_RS = SLAVE28_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE29_AWCHAN_RS = SLAVE29_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE30_AWCHAN_RS = SLAVE30_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
  localparam [0:0]  SLAVE31_AWCHAN_RS = SLAVE31_CHAN_RS;  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
              
  localparam [0:0]  SLAVE0_ARCHAN_RS  = SLAVE0_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE1_ARCHAN_RS  = SLAVE1_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE2_ARCHAN_RS  = SLAVE2_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE3_ARCHAN_RS  = SLAVE3_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE4_ARCHAN_RS  = SLAVE4_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE5_ARCHAN_RS  = SLAVE5_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE6_ARCHAN_RS  = SLAVE6_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE7_ARCHAN_RS  = SLAVE7_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE8_ARCHAN_RS  = SLAVE8_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE9_ARCHAN_RS  = SLAVE9_CHAN_RS;   // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE10_ARCHAN_RS = SLAVE10_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE11_ARCHAN_RS = SLAVE11_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE12_ARCHAN_RS = SLAVE12_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE13_ARCHAN_RS = SLAVE13_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE14_ARCHAN_RS = SLAVE14_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE15_ARCHAN_RS = SLAVE15_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE16_ARCHAN_RS = SLAVE16_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE17_ARCHAN_RS = SLAVE17_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE18_ARCHAN_RS = SLAVE18_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE19_ARCHAN_RS = SLAVE19_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE20_ARCHAN_RS = SLAVE20_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE21_ARCHAN_RS = SLAVE21_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE22_ARCHAN_RS = SLAVE22_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE23_ARCHAN_RS = SLAVE23_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE24_ARCHAN_RS = SLAVE24_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE25_ARCHAN_RS = SLAVE25_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE26_ARCHAN_RS = SLAVE26_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE27_ARCHAN_RS = SLAVE27_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE28_ARCHAN_RS = SLAVE28_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE29_ARCHAN_RS = SLAVE29_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE30_ARCHAN_RS = SLAVE30_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  localparam [0:0]  SLAVE31_ARCHAN_RS = SLAVE31_CHAN_RS;  // 0 - no ARCHAN register slice, 1 - ARCHAN register slice inserted
  
  localparam [0:0]  SLAVE0_WCHAN_RS  = SLAVE0_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE1_WCHAN_RS  = SLAVE1_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE2_WCHAN_RS  = SLAVE2_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE3_WCHAN_RS  = SLAVE3_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE4_WCHAN_RS  = SLAVE4_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE5_WCHAN_RS  = SLAVE5_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE6_WCHAN_RS  = SLAVE6_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE7_WCHAN_RS  = SLAVE7_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE8_WCHAN_RS  = SLAVE8_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE9_WCHAN_RS  = SLAVE9_CHAN_RS;   // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE10_WCHAN_RS = SLAVE10_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE11_WCHAN_RS = SLAVE11_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE12_WCHAN_RS = SLAVE12_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE13_WCHAN_RS = SLAVE13_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE14_WCHAN_RS = SLAVE14_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE15_WCHAN_RS = SLAVE15_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE16_WCHAN_RS = SLAVE16_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE17_WCHAN_RS = SLAVE17_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE18_WCHAN_RS = SLAVE18_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE19_WCHAN_RS = SLAVE19_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE20_WCHAN_RS = SLAVE20_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE21_WCHAN_RS = SLAVE21_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE22_WCHAN_RS = SLAVE22_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE23_WCHAN_RS = SLAVE23_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE24_WCHAN_RS = SLAVE24_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE25_WCHAN_RS = SLAVE25_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE26_WCHAN_RS = SLAVE26_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE27_WCHAN_RS = SLAVE27_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE28_WCHAN_RS = SLAVE28_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE29_WCHAN_RS = SLAVE29_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE30_WCHAN_RS = SLAVE30_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  localparam [0:0]  SLAVE31_WCHAN_RS = SLAVE31_CHAN_RS;  // 0 - no WCHAN register slice, 1 - WCHAN register slice inserted
  
  localparam [0:0]  SLAVE0_RCHAN_RS  = SLAVE0_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE1_RCHAN_RS  = SLAVE1_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE2_RCHAN_RS  = SLAVE2_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE3_RCHAN_RS  = SLAVE3_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE4_RCHAN_RS  = SLAVE4_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE5_RCHAN_RS  = SLAVE5_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE6_RCHAN_RS  = SLAVE6_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE7_RCHAN_RS  = SLAVE7_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE8_RCHAN_RS  = SLAVE8_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE9_RCHAN_RS  = SLAVE9_CHAN_RS;   // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE10_RCHAN_RS = SLAVE10_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE11_RCHAN_RS = SLAVE11_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE12_RCHAN_RS = SLAVE12_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE13_RCHAN_RS = SLAVE13_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE14_RCHAN_RS = SLAVE14_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE15_RCHAN_RS = SLAVE15_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE16_RCHAN_RS = SLAVE16_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE17_RCHAN_RS = SLAVE17_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE18_RCHAN_RS = SLAVE18_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE19_RCHAN_RS = SLAVE19_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE20_RCHAN_RS = SLAVE20_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE21_RCHAN_RS = SLAVE21_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE22_RCHAN_RS = SLAVE22_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE23_RCHAN_RS = SLAVE23_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE24_RCHAN_RS = SLAVE24_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE25_RCHAN_RS = SLAVE25_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE26_RCHAN_RS = SLAVE26_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE27_RCHAN_RS = SLAVE27_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE28_RCHAN_RS = SLAVE28_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE29_RCHAN_RS = SLAVE29_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE30_RCHAN_RS = SLAVE30_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  localparam [0:0]  SLAVE31_RCHAN_RS = SLAVE31_CHAN_RS;  // 0 - no RCHAN register slice, 1 - RCHAN register slice inserted
  
  localparam [0:0]  SLAVE0_BCHAN_RS  = SLAVE0_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE1_BCHAN_RS  = SLAVE1_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE2_BCHAN_RS  = SLAVE2_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE3_BCHAN_RS  = SLAVE3_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE4_BCHAN_RS  = SLAVE4_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE5_BCHAN_RS  = SLAVE5_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE6_BCHAN_RS  = SLAVE6_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE7_BCHAN_RS  = SLAVE7_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE8_BCHAN_RS  = SLAVE8_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE9_BCHAN_RS  = SLAVE9_CHAN_RS;   // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE10_BCHAN_RS = SLAVE10_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE11_BCHAN_RS = SLAVE11_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE12_BCHAN_RS = SLAVE12_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE13_BCHAN_RS = SLAVE13_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE14_BCHAN_RS = SLAVE14_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE15_BCHAN_RS = SLAVE15_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE16_BCHAN_RS = SLAVE16_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE17_BCHAN_RS = SLAVE17_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE18_BCHAN_RS = SLAVE18_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE19_BCHAN_RS = SLAVE19_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE20_BCHAN_RS = SLAVE20_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE21_BCHAN_RS = SLAVE21_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE22_BCHAN_RS = SLAVE22_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE23_BCHAN_RS = SLAVE23_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE24_BCHAN_RS = SLAVE24_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE25_BCHAN_RS = SLAVE25_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE26_BCHAN_RS = SLAVE26_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE27_BCHAN_RS = SLAVE27_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE28_BCHAN_RS = SLAVE28_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE29_BCHAN_RS = SLAVE29_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE30_BCHAN_RS = SLAVE30_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  localparam [0:0]  SLAVE31_BCHAN_RS = SLAVE31_CHAN_RS;  // 0 - no BCHAN register slice, 1 - BCHAN register slice inserted
  
  //===================================================================================================================================

  localparam [64-1:0] UNDEF_AHB_BURST = { UNDEF_BURST_MASTER0,
                                          UNDEF_BURST_MASTER1,
                                          UNDEF_BURST_MASTER2,
                                          UNDEF_BURST_MASTER3,
                                          UNDEF_BURST_MASTER4,
                                          UNDEF_BURST_MASTER5,
                                          UNDEF_BURST_MASTER6,
                                          UNDEF_BURST_MASTER7
                                          };
  
  
  
  localparam integer NUM_MASTERS_WIDTH  = (NUM_MASTERS == 1) ? 1 : $clog2(NUM_MASTERS);// defines number of bits to encode number of masters number
  
  localparam integer NUM_SLAVES_WIDTH  = (NUM_SLAVES == 1) ? 1 : $clog2(NUM_SLAVES);// defines number of bits to encode number of slaves number

  localparam integer ADDR_WIDTH_BITS  = ( ADDR_WIDTH <= 16 ) ? 4 : $clog2(ADDR_WIDTH);// defines number of bits to encode master number

  localparam NUM_THREADS_WIDTH    =  (NUM_THREADS == 1) ? 1 : $clog2(NUM_THREADS);// defined number of bits to encode threads number 

  localparam OPEN_TRANS_WIDTH    = ( OPEN_TRANS_MAX == 1 ) ? 1 : $clog2(OPEN_TRANS_MAX);// width of open transaction count 

  localparam MASTERID_WIDTH    = ( NUM_MASTERS_WIDTH + ID_WIDTH );      // defines width masterID - includes infrastructure port number plus ID

  localparam  BASE_WIDTH = ADDR_WIDTH-UPPER_COMPARE_BIT;

  localparam CMPR_WIDTH = UPPER_COMPARE_BIT-LOWER_COMPARE_BIT;

  localparam [(NUM_MASTERS*2)-1:0] MASTER_TYPE  = { MASTER7_TYPE, MASTER6_TYPE, MASTER5_TYPE, MASTER4_TYPE,
                                                    MASTER3_TYPE, MASTER2_TYPE, MASTER1_TYPE, MASTER0_TYPE };    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3

  localparam [(NUM_SLAVES*2)-1:0] SLAVE_TYPE    = { SLAVE15_TYPE, SLAVE14_TYPE, SLAVE13_TYPE, SLAVE12_TYPE, SLAVE11_TYPE, SLAVE10_TYPE, SLAVE9_TYPE,
													SLAVE8_TYPE, SLAVE7_TYPE, SLAVE6_TYPE, SLAVE5_TYPE, SLAVE4_TYPE,
                                                    SLAVE3_TYPE, SLAVE2_TYPE, SLAVE1_TYPE, SLAVE0_TYPE };    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3

  localparam [NUM_MASTERS-1:0]  MASTER_AWCHAN_RS = {  MASTER7_AWCHAN_RS, MASTER6_AWCHAN_RS, MASTER5_AWCHAN_RS, MASTER4_AWCHAN_RS,  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                      MASTER3_AWCHAN_RS, MASTER2_AWCHAN_RS, MASTER1_AWCHAN_RS, MASTER0_AWCHAN_RS };

  localparam [NUM_MASTERS-1:0]  MASTER_ARCHAN_RS = {  MASTER7_ARCHAN_RS, MASTER6_ARCHAN_RS, MASTER5_ARCHAN_RS, MASTER4_ARCHAN_RS,  // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                      MASTER3_ARCHAN_RS, MASTER2_ARCHAN_RS, MASTER1_ARCHAN_RS, MASTER0_ARCHAN_RS };

  localparam [NUM_MASTERS-1:0]  MASTER_WCHAN_RS = { MASTER7_WCHAN_RS, MASTER6_WCHAN_RS, MASTER5_WCHAN_RS, MASTER4_WCHAN_RS,    // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                    MASTER3_WCHAN_RS, MASTER2_WCHAN_RS, MASTER1_WCHAN_RS, MASTER0_WCHAN_RS };

  localparam [NUM_MASTERS-1:0]  MASTER_RCHAN_RS = { MASTER7_RCHAN_RS, MASTER6_RCHAN_RS, MASTER5_RCHAN_RS, MASTER4_RCHAN_RS,    // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                    MASTER3_RCHAN_RS, MASTER2_RCHAN_RS, MASTER1_RCHAN_RS, MASTER0_RCHAN_RS };

  localparam [NUM_MASTERS-1:0]  MASTER_BCHAN_RS = { MASTER7_BCHAN_RS, MASTER6_BCHAN_RS, MASTER5_BCHAN_RS, MASTER4_BCHAN_RS,    // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                    MASTER3_BCHAN_RS, MASTER2_BCHAN_RS, MASTER1_BCHAN_RS, MASTER0_BCHAN_RS };

  localparam [NUM_SLAVES-1:0]    SLAVE_AWCHAN_RS = { SLAVE15_AWCHAN_RS, SLAVE14_AWCHAN_RS, SLAVE13_AWCHAN_RS, SLAVE12_AWCHAN_RS, SLAVE11_AWCHAN_RS, SLAVE10_AWCHAN_RS, SLAVE9_AWCHAN_RS,  
													 SLAVE8_AWCHAN_RS, SLAVE7_AWCHAN_RS, SLAVE6_AWCHAN_RS, SLAVE5_AWCHAN_RS, SLAVE4_AWCHAN_RS,    // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                      SLAVE3_AWCHAN_RS, SLAVE2_AWCHAN_RS, SLAVE1_AWCHAN_RS, SLAVE0_AWCHAN_RS };

  localparam [NUM_SLAVES-1:0]    SLAVE_ARCHAN_RS = { SLAVE15_ARCHAN_RS, SLAVE14_ARCHAN_RS, SLAVE13_ARCHAN_RS, SLAVE12_ARCHAN_RS, SLAVE11_ARCHAN_RS, SLAVE10_ARCHAN_RS, SLAVE9_ARCHAN_RS,
													 SLAVE8_ARCHAN_RS, SLAVE7_ARCHAN_RS, SLAVE6_ARCHAN_RS, SLAVE5_ARCHAN_RS, SLAVE4_ARCHAN_RS,    // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                      SLAVE3_ARCHAN_RS, SLAVE2_ARCHAN_RS, SLAVE1_ARCHAN_RS, SLAVE0_ARCHAN_RS };

  localparam [NUM_SLAVES-1:0]    SLAVE_WCHAN_RS = { SLAVE15_WCHAN_RS, SLAVE14_WCHAN_RS, SLAVE13_WCHAN_RS, SLAVE12_WCHAN_RS, SLAVE11_WCHAN_RS, SLAVE10_WCHAN_RS, SLAVE9_WCHAN_RS,
													SLAVE8_WCHAN_RS, SLAVE7_WCHAN_RS, SLAVE6_WCHAN_RS, SLAVE5_WCHAN_RS, SLAVE4_WCHAN_RS,      // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                    SLAVE3_WCHAN_RS, SLAVE2_WCHAN_RS, SLAVE1_WCHAN_RS, SLAVE0_WCHAN_RS };

  localparam [NUM_SLAVES-1:0]    SLAVE_RCHAN_RS = { SLAVE15_RCHAN_RS, SLAVE14_RCHAN_RS, SLAVE13_RCHAN_RS, SLAVE12_RCHAN_RS, SLAVE11_RCHAN_RS, SLAVE10_RCHAN_RS, SLAVE9_RCHAN_RS,
													SLAVE8_RCHAN_RS, SLAVE7_RCHAN_RS, SLAVE6_RCHAN_RS, SLAVE5_RCHAN_RS, SLAVE4_RCHAN_RS,      // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                    SLAVE3_RCHAN_RS, SLAVE2_RCHAN_RS, SLAVE1_RCHAN_RS, SLAVE0_RCHAN_RS };

  localparam [NUM_SLAVES-1:0]    SLAVE_BCHAN_RS = { SLAVE15_BCHAN_RS, SLAVE14_BCHAN_RS, SLAVE13_BCHAN_RS, SLAVE12_BCHAN_RS, SLAVE11_BCHAN_RS, SLAVE10_BCHAN_RS, SLAVE9_BCHAN_RS,
													SLAVE8_BCHAN_RS, SLAVE7_BCHAN_RS, SLAVE6_BCHAN_RS, SLAVE5_BCHAN_RS, SLAVE4_BCHAN_RS,      // 0 - no AWCHAN register slice, 1 - AWCHAN register slice inserted
                                                    SLAVE3_BCHAN_RS, SLAVE2_BCHAN_RS, SLAVE1_BCHAN_RS, SLAVE0_BCHAN_RS };

  localparam [7:0]   MASTER0_WRITE_CONNECTIVITY   = { MASTER0_WRITE_SLAVE15, MASTER0_WRITE_SLAVE14, MASTER0_WRITE_SLAVE13, MASTER0_WRITE_SLAVE12, MASTER0_WRITE_SLAVE11, MASTER0_WRITE_SLAVE10, 
													  MASTER0_WRITE_SLAVE9, MASTER0_WRITE_SLAVE8, MASTER0_WRITE_SLAVE7, MASTER0_WRITE_SLAVE6, MASTER0_WRITE_SLAVE5, MASTER0_WRITE_SLAVE4,
                                                      MASTER0_WRITE_SLAVE3, MASTER0_WRITE_SLAVE2, MASTER0_WRITE_SLAVE1, MASTER0_WRITE_SLAVE0  };

  localparam [7:0]   MASTER1_WRITE_CONNECTIVITY   = { MASTER1_WRITE_SLAVE15, MASTER1_WRITE_SLAVE14, MASTER1_WRITE_SLAVE13, MASTER1_WRITE_SLAVE12, MASTER1_WRITE_SLAVE11, MASTER1_WRITE_SLAVE10, 
													  MASTER1_WRITE_SLAVE9, MASTER1_WRITE_SLAVE8, MASTER1_WRITE_SLAVE7, MASTER1_WRITE_SLAVE6, MASTER1_WRITE_SLAVE5, MASTER1_WRITE_SLAVE4,
                                                      MASTER1_WRITE_SLAVE3, MASTER1_WRITE_SLAVE2, MASTER1_WRITE_SLAVE1, MASTER1_WRITE_SLAVE0  };

  localparam [7:0]   MASTER2_WRITE_CONNECTIVITY   = { MASTER2_WRITE_SLAVE7, MASTER2_WRITE_SLAVE6, MASTER2_WRITE_SLAVE5, MASTER2_WRITE_SLAVE4,
                                                      MASTER2_WRITE_SLAVE3, MASTER2_WRITE_SLAVE2, MASTER2_WRITE_SLAVE1, MASTER2_WRITE_SLAVE0  };

  localparam [7:0]   MASTER3_WRITE_CONNECTIVITY   = { MASTER3_WRITE_SLAVE7, MASTER3_WRITE_SLAVE6, MASTER3_WRITE_SLAVE5, MASTER3_WRITE_SLAVE4,
                                                      MASTER3_WRITE_SLAVE3, MASTER3_WRITE_SLAVE2, MASTER3_WRITE_SLAVE1, MASTER3_WRITE_SLAVE0  };

  localparam [7:0]   MASTER4_WRITE_CONNECTIVITY   = { MASTER4_WRITE_SLAVE7, MASTER4_WRITE_SLAVE6, MASTER4_WRITE_SLAVE5, MASTER4_WRITE_SLAVE4,
                                                      MASTER4_WRITE_SLAVE3, MASTER4_WRITE_SLAVE2, MASTER4_WRITE_SLAVE1, MASTER4_WRITE_SLAVE0  };

  localparam [7:0]   MASTER5_WRITE_CONNECTIVITY   = { MASTER5_WRITE_SLAVE7, MASTER5_WRITE_SLAVE6, MASTER5_WRITE_SLAVE5, MASTER5_WRITE_SLAVE4,
                                                      MASTER5_WRITE_SLAVE3, MASTER5_WRITE_SLAVE2, MASTER5_WRITE_SLAVE1, MASTER5_WRITE_SLAVE0  };

  localparam [7:0]   MASTER6_WRITE_CONNECTIVITY   = { MASTER6_WRITE_SLAVE7, MASTER6_WRITE_SLAVE6, MASTER6_WRITE_SLAVE5, MASTER6_WRITE_SLAVE4,
                                                      MASTER6_WRITE_SLAVE3, MASTER6_WRITE_SLAVE2, MASTER6_WRITE_SLAVE1, MASTER6_WRITE_SLAVE0  };

  localparam [7:0]   MASTER7_WRITE_CONNECTIVITY   = { MASTER7_WRITE_SLAVE7, MASTER7_WRITE_SLAVE6, MASTER7_WRITE_SLAVE5, MASTER7_WRITE_SLAVE4,
                                                      MASTER7_WRITE_SLAVE3, MASTER7_WRITE_SLAVE2, MASTER7_WRITE_SLAVE1, MASTER7_WRITE_SLAVE0  };

  localparam [7:0]   MASTER0_READ_CONNECTIVITY   = {  MASTER0_READ_SLAVE15, MASTER0_READ_SLAVE14, MASTER0_READ_SLAVE13, MASTER0_READ_SLAVE12, MASTER0_READ_SLAVE11, MASTER0_READ_SLAVE10, 
													  MASTER0_READ_SLAVE9, MASTER0_READ_SLAVE8, MASTER0_READ_SLAVE7, MASTER0_READ_SLAVE6, MASTER0_READ_SLAVE5, MASTER0_READ_SLAVE4,
                                                      MASTER0_READ_SLAVE3, MASTER0_READ_SLAVE2, MASTER0_READ_SLAVE1, MASTER0_READ_SLAVE0  };

  localparam [7:0]   MASTER1_READ_CONNECTIVITY   = {  MASTER1_READ_SLAVE15, MASTER1_READ_SLAVE14, MASTER1_READ_SLAVE13, MASTER1_READ_SLAVE12, MASTER1_READ_SLAVE11, MASTER1_READ_SLAVE10, 
													  MASTER1_READ_SLAVE9, MASTER1_READ_SLAVE8, MASTER1_READ_SLAVE7, MASTER1_READ_SLAVE6, MASTER1_READ_SLAVE5, MASTER1_READ_SLAVE4,
                                                      MASTER1_READ_SLAVE3, MASTER1_READ_SLAVE2, MASTER1_READ_SLAVE1, MASTER1_READ_SLAVE0  };
  
  localparam [7:0]   MASTER2_READ_CONNECTIVITY   = {  MASTER2_READ_SLAVE7, MASTER2_READ_SLAVE6, MASTER2_READ_SLAVE5, MASTER2_READ_SLAVE4,
                                                      MASTER2_READ_SLAVE3, MASTER2_READ_SLAVE2, MASTER2_READ_SLAVE1, MASTER2_READ_SLAVE0  };

  localparam [7:0]   MASTER3_READ_CONNECTIVITY   = {  MASTER3_READ_SLAVE7, MASTER3_READ_SLAVE6, MASTER3_READ_SLAVE5, MASTER3_READ_SLAVE4,
                                                      MASTER3_READ_SLAVE3, MASTER3_READ_SLAVE2, MASTER3_READ_SLAVE1, MASTER3_READ_SLAVE0  };

  localparam [7:0]   MASTER4_READ_CONNECTIVITY   = {  MASTER4_READ_SLAVE7, MASTER4_READ_SLAVE6, MASTER4_READ_SLAVE5, MASTER4_READ_SLAVE4,
                                                      MASTER4_READ_SLAVE3, MASTER4_READ_SLAVE2, MASTER4_READ_SLAVE1, MASTER4_READ_SLAVE0  };

  localparam [7:0]   MASTER5_READ_CONNECTIVITY   = {  MASTER5_READ_SLAVE7, MASTER5_READ_SLAVE6, MASTER5_READ_SLAVE5, MASTER5_READ_SLAVE4,
                                                      MASTER5_READ_SLAVE3, MASTER5_READ_SLAVE2, MASTER5_READ_SLAVE1, MASTER5_READ_SLAVE0  };

  localparam [7:0]   MASTER6_READ_CONNECTIVITY   = {  MASTER6_READ_SLAVE7, MASTER6_READ_SLAVE6, MASTER6_READ_SLAVE5, MASTER6_READ_SLAVE4,
                                                      MASTER6_READ_SLAVE3, MASTER6_READ_SLAVE2, MASTER6_READ_SLAVE1, MASTER6_READ_SLAVE0  };

  localparam [7:0]   MASTER7_READ_CONNECTIVITY   = {  MASTER7_READ_SLAVE7, MASTER7_READ_SLAVE6, MASTER7_READ_SLAVE5, MASTER7_READ_SLAVE4,
                                                      MASTER7_READ_SLAVE3, MASTER7_READ_SLAVE2, MASTER7_READ_SLAVE1, MASTER7_READ_SLAVE0  };

  localparam [NUM_MASTERS*NUM_SLAVES-1:0] MASTER_WRITE_CONNECTIVITY = {  MASTER7_WRITE_CONNECTIVITY, MASTER6_WRITE_CONNECTIVITY, MASTER5_WRITE_CONNECTIVITY, MASTER4_WRITE_CONNECTIVITY, 
                                                                MASTER3_WRITE_CONNECTIVITY, MASTER2_WRITE_CONNECTIVITY, MASTER1_WRITE_CONNECTIVITY, MASTER0_WRITE_CONNECTIVITY };  // bit per port indicating if a master can write to a slave port

  localparam [NUM_MASTERS*NUM_SLAVES-1:0] MASTER_READ_CONNECTIVITY  = {  MASTER7_READ_CONNECTIVITY, MASTER6_READ_CONNECTIVITY, MASTER5_READ_CONNECTIVITY, MASTER4_READ_CONNECTIVITY, 
                                                                MASTER3_READ_CONNECTIVITY, MASTER2_READ_CONNECTIVITY, MASTER1_READ_CONNECTIVITY, MASTER0_READ_CONNECTIVITY };  // bit per port indicating if a master can write to a slave port

  localparam [(NUM_MASTERS*32)-1:0]  MASTER_PORTS_DATA_WIDTH    = { MASTER7_DATA_WIDTH,
                                                                    MASTER6_DATA_WIDTH,
                                                                    MASTER5_DATA_WIDTH,
                                                                    MASTER4_DATA_WIDTH,
                                                                    MASTER3_DATA_WIDTH,
                                                                    MASTER2_DATA_WIDTH,
                                                                    MASTER1_DATA_WIDTH,
                                                                    MASTER0_DATA_WIDTH
                                                                  };

  localparam [(NUM_SLAVES*32)-1:0]  SLAVE_PORTS_DATA_WIDTH  = { SLAVE15_DATA_WIDTH, 
																SLAVE14_DATA_WIDTH,
                                                                SLAVE13_DATA_WIDTH,
                                                                SLAVE12_DATA_WIDTH,
                                                                SLAVE11_DATA_WIDTH,
                                                                SLAVE10_DATA_WIDTH,
                                                                SLAVE9_DATA_WIDTH,
																SLAVE8_DATA_WIDTH, 
																SLAVE7_DATA_WIDTH,
                                                                SLAVE6_DATA_WIDTH,
                                                                SLAVE5_DATA_WIDTH,
                                                                SLAVE4_DATA_WIDTH,
                                                                SLAVE3_DATA_WIDTH,
                                                                SLAVE2_DATA_WIDTH,
                                                                SLAVE1_DATA_WIDTH,
                                                                SLAVE0_DATA_WIDTH
                                                                };
  localparam [(NUM_SLAVES*32)-1:0]  SLAVE_ADDR   = {
                                                       SLAVE15_START_ADDR,
                                                       SLAVE14_START_ADDR,
                                                       SLAVE13_START_ADDR,
                                                       SLAVE12_START_ADDR,
                                                       SLAVE11_START_ADDR,
                                                       SLAVE10_START_ADDR,
                                                       SLAVE9_START_ADDR,
                                                       SLAVE8_START_ADDR,
                                                       SLAVE7_START_ADDR,
                                                       SLAVE6_START_ADDR,
                                                       SLAVE5_START_ADDR,
                                                       SLAVE4_START_ADDR,
                                                       SLAVE3_START_ADDR,
                                                       SLAVE2_START_ADDR,
                                                       SLAVE1_START_ADDR,
                                                       SLAVE0_START_ADDR
                                                    };
  localparam integer MASTER_DATA_WIDTH_PORT = ( MASTER7_DATA_WIDTH + MASTER6_DATA_WIDTH + MASTER5_DATA_WIDTH + MASTER4_DATA_WIDTH + 
                                                MASTER3_DATA_WIDTH + MASTER2_DATA_WIDTH + MASTER1_DATA_WIDTH + MASTER0_DATA_WIDTH);

  localparam  integer ADDR_DEC_WIDTH  =   (ADDR_WIDTH-UPPER_COMPARE_BIT);

  localparam [NUM_MASTERS*8-1:0] MASTER_DEF_BURST_LEN = { MASTER7_DEF_BURST_LEN,
                                                          MASTER6_DEF_BURST_LEN,
                                                          MASTER5_DEF_BURST_LEN,
                                                          MASTER4_DEF_BURST_LEN,
                                                          MASTER3_DEF_BURST_LEN,
                                                          MASTER2_DEF_BURST_LEN,
                                                          MASTER1_DEF_BURST_LEN,
                                                          MASTER0_DEF_BURST_LEN
                                                          };

  localparam [NUM_SLAVES*14-1:0] SLAVE_DWC_DATA_FIFO_DEPTH = {  SLAVE15_DWC_DATA_FIFO_DEPTH, 
																SLAVE14_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE13_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE12_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE11_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE10_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE9_DWC_DATA_FIFO_DEPTH,
																SLAVE8_DWC_DATA_FIFO_DEPTH, 
																SLAVE7_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE6_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE5_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE4_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE3_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE2_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE1_DWC_DATA_FIFO_DEPTH,
                                                                SLAVE0_DWC_DATA_FIFO_DEPTH
                                                                };

  localparam [NUM_MASTERS*14-1:0] MASTER_DWC_DATA_FIFO_DEPTH = {  MASTER7_DWC_DATA_FIFO_DEPTH,
                                                                  MASTER6_DWC_DATA_FIFO_DEPTH,
                                                                  MASTER5_DWC_DATA_FIFO_DEPTH,
                                                                  MASTER4_DWC_DATA_FIFO_DEPTH,
                                                                  MASTER3_DWC_DATA_FIFO_DEPTH,
                                                                  MASTER2_DWC_DATA_FIFO_DEPTH,
                                                                  MASTER1_DWC_DATA_FIFO_DEPTH,
                                                                  MASTER0_DWC_DATA_FIFO_DEPTH
                                                                  };

  localparam MASTER0_CLOCK_DOMAIN_CROSSING = (MASTER0_CLK_PERIOD != XBAR_CLK_PERIOD) | (MASTER0_PHASE != XBAR_PHASE);
  localparam MASTER1_CLOCK_DOMAIN_CROSSING = (MASTER1_CLK_PERIOD != XBAR_CLK_PERIOD) | (MASTER1_PHASE != XBAR_PHASE);
  localparam MASTER2_CLOCK_DOMAIN_CROSSING = (MASTER2_CLK_PERIOD != XBAR_CLK_PERIOD) | (MASTER2_PHASE != XBAR_PHASE);
  localparam MASTER3_CLOCK_DOMAIN_CROSSING = (MASTER3_CLK_PERIOD != XBAR_CLK_PERIOD) | (MASTER3_PHASE != XBAR_PHASE);
  localparam MASTER4_CLOCK_DOMAIN_CROSSING = (MASTER4_CLK_PERIOD != XBAR_CLK_PERIOD) | (MASTER4_PHASE != XBAR_PHASE);
  localparam MASTER5_CLOCK_DOMAIN_CROSSING = (MASTER5_CLK_PERIOD != XBAR_CLK_PERIOD) | (MASTER5_PHASE != XBAR_PHASE);
  localparam MASTER6_CLOCK_DOMAIN_CROSSING = (MASTER6_CLK_PERIOD != XBAR_CLK_PERIOD) | (MASTER6_PHASE != XBAR_PHASE);
  localparam MASTER7_CLOCK_DOMAIN_CROSSING = (MASTER7_CLK_PERIOD != XBAR_CLK_PERIOD) | (MASTER7_PHASE != XBAR_PHASE);

  localparam SLAVE0_CLOCK_DOMAIN_CROSSING  = (SLAVE0_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE0_PHASE != XBAR_PHASE);
  localparam SLAVE1_CLOCK_DOMAIN_CROSSING  = (SLAVE1_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE1_PHASE != XBAR_PHASE);
  localparam SLAVE2_CLOCK_DOMAIN_CROSSING  = (SLAVE2_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE2_PHASE != XBAR_PHASE);
  localparam SLAVE3_CLOCK_DOMAIN_CROSSING  = (SLAVE3_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE3_PHASE != XBAR_PHASE);
  localparam SLAVE4_CLOCK_DOMAIN_CROSSING  = (SLAVE4_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE4_PHASE != XBAR_PHASE);
  localparam SLAVE5_CLOCK_DOMAIN_CROSSING  = (SLAVE5_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE5_PHASE != XBAR_PHASE);
  localparam SLAVE6_CLOCK_DOMAIN_CROSSING  = (SLAVE6_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE6_PHASE != XBAR_PHASE);
  localparam SLAVE7_CLOCK_DOMAIN_CROSSING  = (SLAVE7_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE7_PHASE != XBAR_PHASE);
  localparam SLAVE8_CLOCK_DOMAIN_CROSSING  = (SLAVE8_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE8_PHASE != XBAR_PHASE);
  localparam SLAVE9_CLOCK_DOMAIN_CROSSING  = (SLAVE9_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE9_PHASE != XBAR_PHASE);
  localparam SLAVE10_CLOCK_DOMAIN_CROSSING = (SLAVE10_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE10_PHASE != XBAR_PHASE);
  localparam SLAVE11_CLOCK_DOMAIN_CROSSING = (SLAVE11_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE11_PHASE != XBAR_PHASE);
  localparam SLAVE12_CLOCK_DOMAIN_CROSSING = (SLAVE12_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE12_PHASE != XBAR_PHASE);
  localparam SLAVE13_CLOCK_DOMAIN_CROSSING = (SLAVE13_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE13_PHASE != XBAR_PHASE);
  localparam SLAVE14_CLOCK_DOMAIN_CROSSING = (SLAVE14_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE14_PHASE != XBAR_PHASE);
  localparam SLAVE15_CLOCK_DOMAIN_CROSSING = (SLAVE15_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE15_PHASE != XBAR_PHASE);
  localparam SLAVE16_CLOCK_DOMAIN_CROSSING = (SLAVE16_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE16_PHASE != XBAR_PHASE);
  localparam SLAVE17_CLOCK_DOMAIN_CROSSING = (SLAVE17_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE17_PHASE != XBAR_PHASE);
  localparam SLAVE18_CLOCK_DOMAIN_CROSSING = (SLAVE18_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE18_PHASE != XBAR_PHASE);
  localparam SLAVE19_CLOCK_DOMAIN_CROSSING = (SLAVE19_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE19_PHASE != XBAR_PHASE);
  localparam SLAVE20_CLOCK_DOMAIN_CROSSING = (SLAVE20_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE20_PHASE != XBAR_PHASE);
  localparam SLAVE21_CLOCK_DOMAIN_CROSSING = (SLAVE21_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE21_PHASE != XBAR_PHASE);
  localparam SLAVE22_CLOCK_DOMAIN_CROSSING = (SLAVE22_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE22_PHASE != XBAR_PHASE);
  localparam SLAVE23_CLOCK_DOMAIN_CROSSING = (SLAVE23_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE23_PHASE != XBAR_PHASE);
  localparam SLAVE24_CLOCK_DOMAIN_CROSSING = (SLAVE24_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE24_PHASE != XBAR_PHASE);
  localparam SLAVE25_CLOCK_DOMAIN_CROSSING = (SLAVE25_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE25_PHASE != XBAR_PHASE);
  localparam SLAVE26_CLOCK_DOMAIN_CROSSING = (SLAVE26_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE26_PHASE != XBAR_PHASE);
  localparam SLAVE27_CLOCK_DOMAIN_CROSSING = (SLAVE27_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE27_PHASE != XBAR_PHASE);
  localparam SLAVE28_CLOCK_DOMAIN_CROSSING = (SLAVE28_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE28_PHASE != XBAR_PHASE);
  localparam SLAVE29_CLOCK_DOMAIN_CROSSING = (SLAVE29_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE29_PHASE != XBAR_PHASE);
  localparam SLAVE30_CLOCK_DOMAIN_CROSSING = (SLAVE30_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE30_PHASE != XBAR_PHASE);
  localparam SLAVE31_CLOCK_DOMAIN_CROSSING = (SLAVE31_CLK_PERIOD != XBAR_CLK_PERIOD) | (SLAVE31_PHASE != XBAR_PHASE);
  

  //=======================================================================================================================
  // Variable Declarations
  //=======================================================================================================================


  //================================================= Global Signals  =============================================//
  reg           ACLK;
  reg           M_CLK0, M_CLK1, M_CLK2, M_CLK3, M_CLK4, M_CLK5, M_CLK6, M_CLK7;
  reg           S_CLK0,  S_CLK1,  S_CLK2,  S_CLK3,  S_CLK4,  S_CLK5,  S_CLK6,  S_CLK7, 
                S_CLK8,  S_CLK9,  S_CLK10, S_CLK11, S_CLK12, S_CLK13, S_CLK14, S_CLK15, 
                S_CLK16, S_CLK17, S_CLK18, S_CLK19, S_CLK20, S_CLK21, S_CLK22, S_CLK23, 
                S_CLK24, S_CLK25, S_CLK26, S_CLK27, S_CLK28, S_CLK29, S_CLK30, S_CLK31;
                
  reg           ARESETN;      // active high reset synchronoise to RE AClk - asserted async.

  //================================================================================================================
  reg            MASTER_RREADY_Default, MASTER_WREADY_Default;    // defines whether Master asserts ready or waits for RVALID
  reg            d_MASTER_BREADY_default;

  reg [NUM_MASTERS-1:0]  rdStart;                  // defines whether Master starts a transaction
  reg [NUM_MASTERS-1:0]  wrStart;                  // defines whether Master starts a transaction

  reg [7:0]        rdBurstLen;      // burst length of read transaction
  reg [ADDR_WIDTH-1:0]  rdStartAddr;    // start addresss for read transaction
  reg [ID_WIDTH-1:0]    rdAID;        // AID for read transactions
  reg [2:0]         rdASize  [7:0];

  reg [1:0]        expWResp [7:0];    // expected Write Response - for AxiMaster
  reg [1:0]        expRResp [7:0];    // expected Read Response - for AxiMaster

  reg [1:0]        BurstType;
  reg [7:0]        wrBurstLen;
  reg [ADDR_WIDTH-1:0]  wrStartAddr;
  reg [ID_WIDTH-1:0]    wrAID;
  reg [2:0]  wrASize  [7:0];

  wire [NUM_MASTERS-1:0]  masterWrAddrDone;    // Address Write transaction has been completed
  wire [NUM_MASTERS-1:0]  masterWrDone;      // Asserted when a write transaction has been completed
  wire [NUM_MASTERS-1:0]  masterWrStatus;      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
  wire [NUM_MASTERS-1:0]  mstWAddrIdle;      // indicates Read Address Bus is idle
  wire [NUM_MASTERS-1:0]  masterRespDone;      // indicates Write Response done 
  wire [NUM_MASTERS-1:0]  masterRdAddrDone;
  wire [NUM_MASTERS-1:0]  masterRdDone;      // Asserted when a write transaction has been completed
  wire [NUM_MASTERS-1:0]  masterRdStatus;      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
  wire [NUM_MASTERS-1:0]  mstRAddrIdle;

  wire [NUM_MASTERS-1:0]  mstWrAddrFull;
  wire [NUM_MASTERS-1:0]  mstRdAddrFull;

  reg SLAVE_ARREADY_Default;
  reg SLAVE_AWREADY_Default;

  reg        SLAVE_DATA_IDLE_EN;        // Enables idle cycles to be inserted in Data channels
  reg [1:0]  SLAVE_DATA_IDLE_CYCLES;      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3

  reg [31:0]  FORCE_ERROR;             // Forces error pn read/write RESP
  reg [7:0]   ERROR_BYTE;              // Byte to force error on - for READs

  //=================================================  AHB  ================================================//
  reg  [7:0]   start_tx;
  wire [7:0]   end_tx;
  reg  [2:0]   hburst;
  reg  [2:0]   hsize;
  reg          hwrite;
  reg  [31:0]  haddr;

  //================================================= Master Ports  ================================================//

  // AHB interface
  wire [31:0]    MASTER0_HADDR,     MASTER1_HADDR,     MASTER2_HADDR,     MASTER3_HADDR,     MASTER4_HADDR,     MASTER5_HADDR,     MASTER6_HADDR,     MASTER7_HADDR;
  wire [2:0]     MASTER0_HBURST,    MASTER1_HBURST,    MASTER2_HBURST,    MASTER3_HBURST,    MASTER4_HBURST,    MASTER5_HBURST,    MASTER6_HBURST,    MASTER7_HBURST;
  wire           MASTER0_HMASTLOCK, MASTER1_HMASTLOCK, MASTER2_HMASTLOCK, MASTER3_HMASTLOCK, MASTER4_HMASTLOCK, MASTER5_HMASTLOCK, MASTER6_HMASTLOCK, MASTER7_HMASTLOCK;
  wire [6:0]     MASTER0_HPROT,     MASTER1_HPROT,     MASTER2_HPROT,     MASTER3_HPROT,     MASTER4_HPROT,     MASTER5_HPROT,     MASTER6_HPROT,     MASTER7_HPROT;
  wire [2:0]     MASTER0_HSIZE,     MASTER1_HSIZE,     MASTER2_HSIZE,     MASTER3_HSIZE,     MASTER4_HSIZE,     MASTER5_HSIZE,     MASTER6_HSIZE,     MASTER7_HSIZE;
  wire           MASTER0_HNONSEC,   MASTER1_HNONSEC,   MASTER2_HNONSEC,   MASTER3_HNONSEC,   MASTER4_HNONSEC,   MASTER5_HNONSEC,   MASTER6_HNONSEC,   MASTER7_HNONSEC;
  wire [1:0]     MASTER0_HTRANS,    MASTER1_HTRANS,    MASTER2_HTRANS,    MASTER3_HTRANS,    MASTER4_HTRANS,    MASTER5_HTRANS,    MASTER6_HTRANS,    MASTER7_HTRANS;
  wire           MASTER0_HWRITE,    MASTER1_HWRITE,    MASTER2_HWRITE,    MASTER3_HWRITE,    MASTER4_HWRITE,    MASTER5_HWRITE,    MASTER6_HWRITE,    MASTER7_HWRITE;
  wire           MASTER0_HSEL,      MASTER1_HSEL,      MASTER2_HSEL,      MASTER3_HSEL,      MASTER4_HSEL,      MASTER5_HSEL,      MASTER6_HSEL,      MASTER7_HSEL;
  wire           MASTER0_HREADY,    MASTER1_HREADY,    MASTER2_HREADY,    MASTER3_HREADY,    MASTER4_HREADY,    MASTER5_HREADY,    MASTER6_HREADY,    MASTER7_HREADY;
  wire           MASTER0_HRESP,     MASTER1_HRESP,     MASTER2_HRESP,     MASTER3_HRESP,     MASTER4_HRESP,     MASTER5_HRESP,     MASTER6_HRESP,     MASTER7_HRESP;

  //================================================  AHB data ports  ======================================================================//
  wire [MASTER0_DATA_WIDTH-1:0]    MASTER0_HWDATA;
  wire [MASTER1_DATA_WIDTH-1:0]    MASTER1_HWDATA;
  wire [MASTER2_DATA_WIDTH-1:0]    MASTER2_HWDATA;
  wire [MASTER3_DATA_WIDTH-1:0]    MASTER3_HWDATA;
  wire [MASTER4_DATA_WIDTH-1:0]    MASTER4_HWDATA;
  wire [MASTER5_DATA_WIDTH-1:0]    MASTER5_HWDATA;
  wire [MASTER6_DATA_WIDTH-1:0]    MASTER6_HWDATA;
  wire [MASTER7_DATA_WIDTH-1:0]    MASTER7_HWDATA;

  wire [MASTER0_DATA_WIDTH-1:0]    MASTER0_HRDATA;
  wire [MASTER1_DATA_WIDTH-1:0]    MASTER1_HRDATA;
  wire [MASTER2_DATA_WIDTH-1:0]    MASTER2_HRDATA;
  wire [MASTER3_DATA_WIDTH-1:0]    MASTER3_HRDATA;
  wire [MASTER4_DATA_WIDTH-1:0]    MASTER4_HRDATA;
  wire [MASTER5_DATA_WIDTH-1:0]    MASTER5_HRDATA;
  wire [MASTER6_DATA_WIDTH-1:0]    MASTER6_HRDATA;
  wire [MASTER7_DATA_WIDTH-1:0]    MASTER7_HRDATA;

  //================================================  Master Write Address Ports  ======================================================================//
  wire [ID_WIDTH-1:0]      MASTER0_AWID,     MASTER1_AWID,     MASTER2_AWID,     MASTER3_AWID,     MASTER4_AWID,     MASTER5_AWID,     MASTER6_AWID,     MASTER7_AWID;
  wire [ADDR_WIDTH-1:0]    MASTER0_AWADDR,   MASTER1_AWADDR,   MASTER2_AWADDR,   MASTER3_AWADDR,   MASTER4_AWADDR,   MASTER5_AWADDR,   MASTER6_AWADDR,   MASTER7_AWADDR;
  wire [7:0]               MASTER0_AWLEN,    MASTER1_AWLEN,    MASTER2_AWLEN,    MASTER3_AWLEN,    MASTER4_AWLEN,    MASTER5_AWLEN,    MASTER6_AWLEN,    MASTER7_AWLEN;
  wire [2:0]               MASTER0_AWSIZE,   MASTER1_AWSIZE,   MASTER2_AWSIZE,   MASTER3_AWSIZE,   MASTER4_AWSIZE,   MASTER5_AWSIZE,   MASTER6_AWSIZE,   MASTER7_AWSIZE;
  wire [1:0]               MASTER0_AWBURST,  MASTER1_AWBURST,  MASTER2_AWBURST,  MASTER3_AWBURST,  MASTER4_AWBURST,  MASTER5_AWBURST,  MASTER6_AWBURST,  MASTER7_AWBURST;
  wire [1:0]               MASTER0_AWLOCK,   MASTER1_AWLOCK,   MASTER2_AWLOCK,   MASTER3_AWLOCK,   MASTER4_AWLOCK,   MASTER5_AWLOCK,   MASTER6_AWLOCK,   MASTER7_AWLOCK;
  wire [3:0]               MASTER0_AWCACHE,  MASTER1_AWCACHE,  MASTER2_AWCACHE,  MASTER3_AWCACHE,  MASTER4_AWCACHE,  MASTER5_AWCACHE,  MASTER6_AWCACHE,  MASTER7_AWCACHE;
  wire [2:0]               MASTER0_AWPROT,   MASTER1_AWPROT,   MASTER2_AWPROT,   MASTER3_AWPROT,   MASTER4_AWPROT,   MASTER5_AWPROT,   MASTER6_AWPROT,   MASTER7_AWPROT;
  wire [3:0]               MASTER0_AWREGION, MASTER1_AWREGION, MASTER2_AWREGION, MASTER3_AWREGION, MASTER4_AWREGION, MASTER5_AWREGION, MASTER6_AWREGION, MASTER7_AWREGION;
  wire [3:0]               MASTER0_AWQOS,    MASTER1_AWQOS,    MASTER2_AWQOS,    MASTER3_AWQOS,    MASTER4_AWQOS,    MASTER5_AWQOS,    MASTER6_AWQOS,    MASTER7_AWQOS;
  wire [USER_WIDTH-1:0]    MASTER0_AWUSER,   MASTER1_AWUSER,   MASTER2_AWUSER,   MASTER3_AWUSER,   MASTER4_AWUSER,   MASTER5_AWUSER,   MASTER6_AWUSER,   MASTER7_AWUSER;
  wire                     MASTER0_AWVALID,  MASTER1_AWVALID,  MASTER2_AWVALID,  MASTER3_AWVALID,  MASTER4_AWVALID,  MASTER5_AWVALID,  MASTER6_AWVALID,  MASTER7_AWVALID;
  wire                     MASTER0_AWREADY,  MASTER1_AWREADY,  MASTER2_AWREADY,  MASTER3_AWREADY,  MASTER4_AWREADY,  MASTER5_AWREADY,  MASTER6_AWREADY,  MASTER7_AWREADY;

  //================================================   Master Write Data Ports  ======================================================================//
  wire [ID_WIDTH-1:0]       MASTER0_WID,    MASTER1_WID,    MASTER2_WID,    MASTER3_WID,    MASTER4_WID,    MASTER5_WID,    MASTER6_WID,    MASTER7_WID;
  wire                      MASTER0_WLAST,  MASTER1_WLAST,  MASTER2_WLAST,  MASTER3_WLAST,  MASTER4_WLAST,  MASTER5_WLAST,  MASTER6_WLAST,  MASTER7_WLAST;
  wire [USER_WIDTH-1:0]     MASTER0_WUSER,  MASTER1_WUSER,  MASTER2_WUSER,  MASTER3_WUSER,  MASTER4_WUSER,  MASTER5_WUSER,  MASTER6_WUSER,  MASTER7_WUSER;
  wire                      MASTER0_WVALID, MASTER1_WVALID, MASTER2_WVALID, MASTER3_WVALID, MASTER4_WVALID, MASTER5_WVALID, MASTER6_WVALID, MASTER7_WVALID;
  wire                      MASTER0_WREADY, MASTER1_WREADY, MASTER2_WREADY, MASTER3_WREADY, MASTER4_WREADY, MASTER5_WREADY, MASTER6_WREADY, MASTER7_WREADY;

  wire [MASTER0_DATA_WIDTH-1:0]    MASTER0_WDATA;
  wire [MASTER1_DATA_WIDTH-1:0]    MASTER1_WDATA;
  wire [MASTER2_DATA_WIDTH-1:0]    MASTER2_WDATA;
  wire [MASTER3_DATA_WIDTH-1:0]    MASTER3_WDATA;
  wire [MASTER4_DATA_WIDTH-1:0]    MASTER4_WDATA;
  wire [MASTER5_DATA_WIDTH-1:0]    MASTER5_WDATA;
  wire [MASTER6_DATA_WIDTH-1:0]    MASTER6_WDATA;
  wire [MASTER7_DATA_WIDTH-1:0]    MASTER7_WDATA;
  wire [(MASTER0_DATA_WIDTH/8)-1:0]  MASTER0_WSTRB;
  wire [(MASTER1_DATA_WIDTH/8)-1:0]  MASTER1_WSTRB;
  wire [(MASTER2_DATA_WIDTH/8)-1:0]  MASTER2_WSTRB;
  wire [(MASTER3_DATA_WIDTH/8)-1:0]  MASTER3_WSTRB;
  wire [(MASTER4_DATA_WIDTH/8)-1:0]  MASTER4_WSTRB;
  wire [(MASTER5_DATA_WIDTH/8)-1:0]  MASTER5_WSTRB;
  wire [(MASTER6_DATA_WIDTH/8)-1:0]  MASTER6_WSTRB;
  wire [(MASTER7_DATA_WIDTH/8)-1:0]  MASTER7_WSTRB;

  //================================================  Master Write Response Ports  ======================================================================//
  wire [ID_WIDTH-1:0]    MASTER0_BID,     MASTER1_BID,    MASTER2_BID,    MASTER3_BID,    MASTER4_BID,    MASTER5_BID,    MASTER6_BID,    MASTER7_BID;
  wire [1:0]             MASTER0_BRESP,   MASTER1_BRESP,  MASTER2_BRESP,  MASTER3_BRESP,  MASTER4_BRESP,  MASTER5_BRESP,  MASTER6_BRESP,  MASTER7_BRESP;
  wire [USER_WIDTH-1:0]  MASTER0_BUSER,   MASTER1_BUSER,  MASTER2_BUSER,  MASTER3_BUSER,  MASTER4_BUSER,  MASTER5_BUSER,  MASTER6_BUSER,  MASTER7_BUSER;
  wire                   MASTER0_BVALID,  MASTER1_BVALID, MASTER2_BVALID, MASTER3_BVALID, MASTER4_BVALID, MASTER5_BVALID, MASTER6_BVALID, MASTER7_BVALID;
  wire                   MASTER0_BREADY,  MASTER1_BREADY, MASTER2_BREADY, MASTER3_BREADY, MASTER4_BREADY, MASTER5_BREADY, MASTER6_BREADY, MASTER7_BREADY;
  
  //================================================  Master Read Address Ports  ======================================================================//
  wire [ID_WIDTH-1:0]     MASTER0_ARID,     MASTER1_ARID,     MASTER2_ARID,     MASTER3_ARID,     MASTER4_ARID,     MASTER5_ARID,     MASTER6_ARID,     MASTER7_ARID;
  wire [ADDR_WIDTH-1:0]   MASTER0_ARADDR,   MASTER1_ARADDR,   MASTER2_ARADDR,   MASTER3_ARADDR,   MASTER4_ARADDR,   MASTER5_ARADDR,   MASTER6_ARADDR,   MASTER7_ARADDR;
  wire [7:0]              MASTER0_ARLEN,    MASTER1_ARLEN,    MASTER2_ARLEN,    MASTER3_ARLEN,    MASTER4_ARLEN,    MASTER5_ARLEN,    MASTER6_ARLEN,    MASTER7_ARLEN;
  wire [2:0]              MASTER0_ARSIZE,   MASTER1_ARSIZE,   MASTER2_ARSIZE,   MASTER3_ARSIZE,   MASTER4_ARSIZE,   MASTER5_ARSIZE,   MASTER6_ARSIZE,   MASTER7_ARSIZE;
  wire [1:0]              MASTER0_ARBURST,  MASTER1_ARBURST,  MASTER2_ARBURST,  MASTER3_ARBURST,  MASTER4_ARBURST,  MASTER5_ARBURST,  MASTER6_ARBURST,  MASTER7_ARBURST;
  wire [1:0]              MASTER0_ARLOCK,   MASTER1_ARLOCK,   MASTER2_ARLOCK,   MASTER3_ARLOCK,   MASTER4_ARLOCK,   MASTER5_ARLOCK,   MASTER6_ARLOCK,   MASTER7_ARLOCK;
  wire [3:0]              MASTER0_ARCACHE,  MASTER1_ARCACHE,  MASTER2_ARCACHE,  MASTER3_ARCACHE,  MASTER4_ARCACHE,  MASTER5_ARCACHE,  MASTER6_ARCACHE,  MASTER7_ARCACHE;
  wire [2:0]              MASTER0_ARPROT,   MASTER1_ARPROT,   MASTER2_ARPROT,   MASTER3_ARPROT,   MASTER4_ARPROT,   MASTER5_ARPROT,   MASTER6_ARPROT,   MASTER7_ARPROT;
  wire [3:0]              MASTER0_ARREGION, MASTER1_ARREGION, MASTER2_ARREGION, MASTER3_ARREGION, MASTER4_ARREGION, MASTER5_ARREGION, MASTER6_ARREGION, MASTER7_ARREGION;
  wire [3:0]              MASTER0_ARQOS,    MASTER1_ARQOS,    MASTER2_ARQOS,    MASTER3_ARQOS,    MASTER4_ARQOS,    MASTER5_ARQOS,    MASTER6_ARQOS,    MASTER7_ARQOS;
  wire [USER_WIDTH-1:0]   MASTER0_ARUSER,   MASTER1_ARUSER,   MASTER2_ARUSER,   MASTER3_ARUSER,   MASTER4_ARUSER,   MASTER5_ARUSER,   MASTER6_ARUSER,   MASTER7_ARUSER;
  wire                    MASTER0_ARVALID,  MASTER1_ARVALID,  MASTER2_ARVALID,  MASTER3_ARVALID,  MASTER4_ARVALID,  MASTER5_ARVALID,  MASTER6_ARVALID,  MASTER7_ARVALID;
  wire                    MASTER0_ARREADY,  MASTER1_ARREADY,  MASTER2_ARREADY,  MASTER3_ARREADY,  MASTER4_ARREADY,  MASTER5_ARREADY,  MASTER6_ARREADY,  MASTER7_ARREADY;

  //================================================  Master Read Data Ports  ======================================================================//
  wire [ID_WIDTH-1:0]       MASTER0_RID,    MASTER1_RID,    MASTER2_RID,    MASTER3_RID,    MASTER4_RID,    MASTER5_RID,    MASTER6_RID,    MASTER7_RID;
  wire [1:0]                MASTER0_RRESP,  MASTER1_RRESP,  MASTER2_RRESP,  MASTER3_RRESP,  MASTER4_RRESP,  MASTER5_RRESP,  MASTER6_RRESP,  MASTER7_RRESP;
  wire                      MASTER0_RLAST,  MASTER1_RLAST,  MASTER2_RLAST,  MASTER3_RLAST,  MASTER4_RLAST,  MASTER5_RLAST,  MASTER6_RLAST,  MASTER7_RLAST;
  wire [USER_WIDTH-1:0]     MASTER0_RUSER,  MASTER1_RUSER,  MASTER2_RUSER,  MASTER3_RUSER,  MASTER4_RUSER,  MASTER5_RUSER,  MASTER6_RUSER,  MASTER7_RUSER;
  wire                      MASTER0_RVALID, MASTER1_RVALID, MASTER2_RVALID, MASTER3_RVALID, MASTER4_RVALID, MASTER5_RVALID, MASTER6_RVALID, MASTER7_RVALID;
  wire                      MASTER0_RREADY, MASTER1_RREADY, MASTER2_RREADY, MASTER3_RREADY, MASTER4_RREADY, MASTER5_RREADY, MASTER6_RREADY, MASTER7_RREADY;

  wire [MASTER0_DATA_WIDTH-1:0]    MASTER0_RDATA;
  wire [MASTER1_DATA_WIDTH-1:0]    MASTER1_RDATA;
  wire [MASTER2_DATA_WIDTH-1:0]    MASTER2_RDATA;
  wire [MASTER3_DATA_WIDTH-1:0]    MASTER3_RDATA;
  wire [MASTER4_DATA_WIDTH-1:0]    MASTER4_RDATA;
  wire [MASTER5_DATA_WIDTH-1:0]    MASTER5_RDATA;
  wire [MASTER6_DATA_WIDTH-1:0]    MASTER6_RDATA;
  wire [MASTER7_DATA_WIDTH-1:0]    MASTER7_RDATA;

  //================================================ Slave Ports  ======================================================================//
 
  // Slave Write Address Port - Slave ID is composed of Master Port ID concatenated with transaction ID
 wire [(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]  SLAVE0_AWID,     SLAVE1_AWID,     SLAVE2_AWID,      SLAVE3_AWID,     SLAVE4_AWID,     SLAVE5_AWID,     SLAVE6_AWID,     SLAVE7_AWID,
                                          SLAVE8_AWID,     SLAVE9_AWID,     SLAVE10_AWID,     SLAVE11_AWID,    SLAVE12_AWID,    SLAVE13_AWID,    SLAVE14_AWID,    SLAVE15_AWID,
                                          SLAVE16_AWID,    SLAVE17_AWID,    SLAVE18_AWID,     SLAVE19_AWID,    SLAVE20_AWID,    SLAVE21_AWID,    SLAVE22_AWID,    SLAVE23_AWID,
                                          SLAVE24_AWID,    SLAVE25_AWID,    SLAVE26_AWID,     SLAVE27_AWID,    SLAVE28_AWID,    SLAVE29_AWID,    SLAVE30_AWID,    SLAVE31_AWID;
                                          
 wire [ADDR_WIDTH-1:0]    SLAVE0_AWADDR,   SLAVE1_AWADDR,   SLAVE2_AWADDR,   SLAVE3_AWADDR,    SLAVE4_AWADDR,   SLAVE5_AWADDR,   SLAVE6_AWADDR,   SLAVE7_AWADDR,
                          SLAVE8_AWADDR,   SLAVE9_AWADDR,   SLAVE10_AWADDR,  SLAVE11_AWADDR,   SLAVE12_AWADDR,  SLAVE13_AWADDR,  SLAVE14_AWADDR,  SLAVE15_AWADDR,
                          SLAVE16_AWADDR,  SLAVE17_AWADDR,  SLAVE18_AWADDR,  SLAVE19_AWADDR,   SLAVE20_AWADDR,  SLAVE21_AWADDR,  SLAVE22_AWADDR,  SLAVE23_AWADDR,
                          SLAVE24_AWADDR,  SLAVE25_AWADDR,  SLAVE26_AWADDR,  SLAVE27_AWADDR,   SLAVE28_AWADDR,  SLAVE29_AWADDR,  SLAVE30_AWADDR,  SLAVE31_AWADDR;
                                          
 wire [7:0]               SLAVE0_AWLEN,    SLAVE1_AWLEN,    SLAVE2_AWLEN,    SLAVE3_AWLEN,    SLAVE4_AWLEN,    SLAVE5_AWLEN,    SLAVE6_AWLEN,    SLAVE7_AWLEN,
                          SLAVE8_AWLEN,    SLAVE9_AWLEN,    SLAVE10_AWLEN,   SLAVE11_AWLEN,   SLAVE12_AWLEN,   SLAVE13_AWLEN,   SLAVE14_AWLEN,   SLAVE15_AWLEN,
                          SLAVE16_AWLEN,   SLAVE17_AWLEN,   SLAVE18_AWLEN,   SLAVE19_AWLEN,   SLAVE20_AWLEN,   SLAVE21_AWLEN,   SLAVE22_AWLEN,   SLAVE23_AWLEN,
                          SLAVE24_AWLEN,   SLAVE25_AWLEN,   SLAVE26_AWLEN,   SLAVE27_AWLEN,   SLAVE28_AWLEN,   SLAVE29_AWLEN,   SLAVE30_AWLEN,   SLAVE31_AWLEN;
                                          

 wire [2:0]               SLAVE0_AWSIZE,   SLAVE1_AWSIZE,   SLAVE2_AWSIZE,   SLAVE3_AWSIZE,   SLAVE4_AWSIZE,   SLAVE5_AWSIZE,   SLAVE6_AWSIZE,   SLAVE7_AWSIZE,
                          SLAVE8_AWSIZE,   SLAVE9_AWSIZE,   SLAVE10_AWSIZE,  SLAVE11_AWSIZE,  SLAVE12_AWSIZE,  SLAVE13_AWSIZE,  SLAVE14_AWSIZE,  SLAVE15_AWSIZE,
                          SLAVE16_AWSIZE,  SLAVE17_AWSIZE,  SLAVE18_AWSIZE,  SLAVE19_AWSIZE,  SLAVE20_AWSIZE,  SLAVE21_AWSIZE,  SLAVE22_AWSIZE,  SLAVE23_AWSIZE,
                          SLAVE24_AWSIZE,  SLAVE25_AWSIZE,  SLAVE26_AWSIZE,  SLAVE27_AWSIZE,  SLAVE28_AWSIZE,  SLAVE29_AWSIZE,  SLAVE30_AWSIZE,  SLAVE31_AWSIZE;


 wire [1:0]               SLAVE0_AWBURST,  SLAVE1_AWBURST,  SLAVE2_AWBURST,   SLAVE3_AWBURST,  SLAVE4_AWBURST,  SLAVE5_AWBURST,  SLAVE6_AWBURST,   SLAVE7_AWBURST,
                          SLAVE8_AWBURST,  SLAVE9_AWBURST,  SLAVE10_AWBURST,  SLAVE11_AWBURST, SLAVE12_AWBURST, SLAVE13_AWBURST, SLAVE14_AWBURST,  SLAVE15_AWBURST,
                          SLAVE16_AWBURST, SLAVE17_AWBURST, SLAVE18_AWBURST,  SLAVE19_AWBURST, SLAVE20_AWBURST, SLAVE21_AWBURST, SLAVE22_AWBURST,  SLAVE23_AWBURST,
                          SLAVE24_AWBURST, SLAVE25_AWBURST, SLAVE26_AWBURST,  SLAVE27_AWBURST, SLAVE28_AWBURST, SLAVE29_AWBURST, SLAVE30_AWBURST,  SLAVE31_AWBURST;


 wire [1:0]               SLAVE0_AWLOCK,   SLAVE1_AWLOCK,   SLAVE2_AWLOCK,   SLAVE3_AWLOCK,   SLAVE4_AWLOCK,   SLAVE5_AWLOCK,   SLAVE6_AWLOCK,   SLAVE7_AWLOCK,
                          SLAVE8_AWLOCK,   SLAVE9_AWLOCK,   SLAVE10_AWLOCK,  SLAVE11_AWLOCK,  SLAVE12_AWLOCK,  SLAVE13_AWLOCK,  SLAVE14_AWLOCK,  SLAVE15_AWLOCK,
                          SLAVE16_AWLOCK,  SLAVE17_AWLOCK,  SLAVE18_AWLOCK,  SLAVE19_AWLOCK,  SLAVE20_AWLOCK,  SLAVE21_AWLOCK,  SLAVE22_AWLOCK,  SLAVE23_AWLOCK,
                          SLAVE24_AWLOCK,  SLAVE25_AWLOCK,  SLAVE26_AWLOCK,  SLAVE27_AWLOCK,  SLAVE28_AWLOCK,  SLAVE29_AWLOCK,  SLAVE30_AWLOCK,  SLAVE31_AWLOCK;


 wire [3:0]               SLAVE0_AWCACHE,   SLAVE1_AWCACHE,   SLAVE2_AWCACHE,   SLAVE3_AWCACHE,   SLAVE4_AWCACHE,   SLAVE5_AWCACHE,   SLAVE6_AWCACHE,   SLAVE7_AWCACHE,
                          SLAVE8_AWCACHE,   SLAVE9_AWCACHE,   SLAVE10_AWCACHE,  SLAVE11_AWCACHE,  SLAVE12_AWCACHE,  SLAVE13_AWCACHE,  SLAVE14_AWCACHE,  SLAVE15_AWCACHE,
                          SLAVE16_AWCACHE,  SLAVE17_AWCACHE,  SLAVE18_AWCACHE,  SLAVE19_AWCACHE,  SLAVE20_AWCACHE,  SLAVE21_AWCACHE,  SLAVE22_AWCACHE,  SLAVE23_AWCACHE,
                          SLAVE24_AWCACHE,  SLAVE25_AWCACHE,  SLAVE26_AWCACHE,  SLAVE27_AWCACHE,  SLAVE28_AWCACHE,  SLAVE29_AWCACHE,  SLAVE30_AWCACHE,  SLAVE31_AWCACHE;

 wire [2:0]               SLAVE0_AWPROT,   SLAVE1_AWPROT,   SLAVE2_AWPROT,   SLAVE3_AWPROT,   SLAVE4_AWPROT,   SLAVE5_AWPROT,   SLAVE6_AWPROT,   SLAVE7_AWPROT,
                          SLAVE8_AWPROT,   SLAVE9_AWPROT,   SLAVE10_AWPROT,  SLAVE11_AWPROT,  SLAVE12_AWPROT,  SLAVE13_AWPROT,  SLAVE14_AWPROT,  SLAVE15_AWPROT,
                          SLAVE16_AWPROT,  SLAVE17_AWPROT,  SLAVE18_AWPROT,  SLAVE19_AWPROT,  SLAVE20_AWPROT,  SLAVE21_AWPROT,  SLAVE22_AWPROT,  SLAVE23_AWPROT,
                          SLAVE24_AWPROT,  SLAVE25_AWPROT,  SLAVE26_AWPROT,  SLAVE27_AWPROT,  SLAVE28_AWPROT,  SLAVE29_AWPROT,  SLAVE30_AWPROT,  SLAVE31_AWPROT;


 wire [3:0]               SLAVE0_AWREGION,   SLAVE1_AWREGION,   SLAVE2_AWREGION,   SLAVE3_AWREGION,   SLAVE4_AWREGION,   SLAVE5_AWREGION,   SLAVE6_AWREGION,   SLAVE7_AWREGION,
                          SLAVE8_AWREGION,   SLAVE9_AWREGION,   SLAVE10_AWREGION,  SLAVE11_AWREGION,  SLAVE12_AWREGION,  SLAVE13_AWREGION,  SLAVE14_AWREGION,  SLAVE15_AWREGION,
                          SLAVE16_AWREGION,  SLAVE17_AWREGION,  SLAVE18_AWREGION,  SLAVE19_AWREGION,  SLAVE20_AWREGION,  SLAVE21_AWREGION,  SLAVE22_AWREGION,  SLAVE23_AWREGION,
                          SLAVE24_AWREGION,  SLAVE25_AWREGION,  SLAVE26_AWREGION,  SLAVE27_AWREGION,  SLAVE28_AWREGION,  SLAVE29_AWREGION,  SLAVE30_AWREGION,  SLAVE31_AWREGION;

 wire [3:0]               SLAVE0_AWQOS,   SLAVE1_AWQOS,  SLAVE2_AWQOS,   SLAVE3_AWQOS,  SLAVE4_AWQOS,   SLAVE5_AWQOS,   SLAVE6_AWQOS,   SLAVE7_AWQOS,
                          SLAVE8_AWQOS,   SLAVE9_AWQOS,  SLAVE10_AWQOS,  SLAVE11_AWQOS, SLAVE12_AWQOS,  SLAVE13_AWQOS,  SLAVE14_AWQOS,  SLAVE15_AWQOS,
                          SLAVE16_AWQOS,  SLAVE17_AWQOS, SLAVE18_AWQOS,  SLAVE19_AWQOS, SLAVE20_AWQOS,  SLAVE21_AWQOS,  SLAVE22_AWQOS,  SLAVE23_AWQOS,  
                          SLAVE24_AWQOS,  SLAVE25_AWQOS, SLAVE26_AWQOS,  SLAVE27_AWQOS, SLAVE28_AWQOS,  SLAVE29_AWQOS,  SLAVE30_AWQOS,   SLAVE31_AWQOS;
                          
                          
 wire [USER_WIDTH-1:0]    SLAVE0_AWUSER,   SLAVE1_AWUSER,   SLAVE2_AWUSER,   SLAVE3_AWUSER,   SLAVE4_AWUSER,   SLAVE5_AWUSER,   SLAVE6_AWUSER,   SLAVE7_AWUSER,
                          SLAVE8_AWUSER,   SLAVE9_AWUSER,   SLAVE10_AWUSER,  SLAVE11_AWUSER,  SLAVE12_AWUSER,  SLAVE13_AWUSER,  SLAVE14_AWUSER,  SLAVE15_AWUSER,
                          SLAVE16_AWUSER,  SLAVE17_AWUSER,  SLAVE18_AWUSER,  SLAVE19_AWUSER,  SLAVE20_AWUSER,  SLAVE21_AWUSER,  SLAVE22_AWUSER,  SLAVE23_AWUSER,
                          SLAVE24_AWUSER,  SLAVE25_AWUSER,  SLAVE26_AWUSER,  SLAVE27_AWUSER,  SLAVE28_AWUSER,  SLAVE29_AWUSER,  SLAVE30_AWUSER,  SLAVE31_AWUSER;

 wire                     SLAVE0_AWVALID,   SLAVE1_AWVALID,   SLAVE2_AWVALID,   SLAVE3_AWVALID,   SLAVE4_AWVALID,  SLAVE5_AWVALID,   SLAVE6_AWVALID,   SLAVE7_AWVALID,
                          SLAVE8_AWVALID,   SLAVE9_AWVALID,   SLAVE10_AWVALID,  SLAVE11_AWVALID,  SLAVE12_AWVALID, SLAVE13_AWVALID,  SLAVE14_AWVALID,  SLAVE15_AWVALID,  
                          SLAVE16_AWVALID,  SLAVE17_AWVALID,  SLAVE18_AWVALID,  SLAVE19_AWVALID,  SLAVE20_AWVALID, SLAVE21_AWVALID,  SLAVE22_AWVALID,   SLAVE23_AWVALID,  
                          SLAVE24_AWVALID,  SLAVE25_AWVALID,  SLAVE26_AWVALID,  SLAVE27_AWVALID,  SLAVE28_AWVALID,  SLAVE29_AWVALID, SLAVE30_AWVALID,  SLAVE31_AWVALID;

 wire                     SLAVE0_AWREADY,   SLAVE1_AWREADY,   SLAVE2_AWREADY,   SLAVE3_AWREADY,   SLAVE4_AWREADY,    SLAVE5_AWREADY,   SLAVE6_AWREADY,   SLAVE7_AWREADY,
                          SLAVE8_AWREADY,   SLAVE9_AWREADY,   SLAVE10_AWREADY,  SLAVE11_AWREADY,  SLAVE12_AWREADY,   SLAVE13_AWREADY,  SLAVE14_AWREADY,  SLAVE15_AWREADY,  
                          SLAVE16_AWREADY,  SLAVE17_AWREADY,  SLAVE18_AWREADY,  SLAVE19_AWREADY,  SLAVE20_AWREADY,  SLAVE21_AWREADY,   SLAVE22_AWREADY,  SLAVE23_AWREADY,
                          SLAVE24_AWREADY,  SLAVE25_AWREADY,  SLAVE26_AWREADY,  SLAVE27_AWREADY,  SLAVE28_AWREADY,  SLAVE29_AWREADY,   SLAVE30_AWREADY,  SLAVE31_AWREADY;
   
  // Slave Write Data Ports
 wire [(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]  SLAVE0_WID,  SLAVE1_WID,  SLAVE2_WID,  SLAVE3_WID,  SLAVE4_WID,  SLAVE5_WID,  SLAVE6_WID,  SLAVE7_WID, 
                                          SLAVE8_WID,  SLAVE9_WID,  SLAVE10_WID, SLAVE11_WID, SLAVE12_WID, SLAVE13_WID, SLAVE14_WID, SLAVE15_WID,
                                          SLAVE16_WID, SLAVE17_WID, SLAVE18_WID, SLAVE19_WID, SLAVE20_WID, SLAVE21_WID, SLAVE22_WID, SLAVE23_WID, 
                                          SLAVE24_WID, SLAVE25_WID, SLAVE26_WID, SLAVE27_WID, SLAVE28_WID, SLAVE29_WID, SLAVE30_WID, SLAVE31_WID;

 wire [SLAVE0_DATA_WIDTH-1:0]      SLAVE0_WDATA;  
 wire [SLAVE1_DATA_WIDTH-1:0]      SLAVE1_WDATA;  
 wire [SLAVE2_DATA_WIDTH-1:0]      SLAVE2_WDATA;  
 wire [SLAVE3_DATA_WIDTH-1:0]      SLAVE3_WDATA;  
 wire [SLAVE4_DATA_WIDTH-1:0]      SLAVE4_WDATA;  
 wire [SLAVE5_DATA_WIDTH-1:0]      SLAVE5_WDATA;  
 wire [SLAVE6_DATA_WIDTH-1:0]      SLAVE6_WDATA;   
 wire [SLAVE7_DATA_WIDTH-1:0]      SLAVE7_WDATA;  
 wire [SLAVE8_DATA_WIDTH-1:0]      SLAVE8_WDATA;  
 wire [SLAVE9_DATA_WIDTH-1:0]      SLAVE9_WDATA;  
 wire [SLAVE10_DATA_WIDTH-1:0]     SLAVE10_WDATA;  
 wire [SLAVE11_DATA_WIDTH-1:0]     SLAVE11_WDATA;  
 wire [SLAVE12_DATA_WIDTH-1:0]     SLAVE12_WDATA;  
 wire [SLAVE13_DATA_WIDTH-1:0]     SLAVE13_WDATA;  
 wire [SLAVE14_DATA_WIDTH-1:0]     SLAVE14_WDATA;   
 wire [SLAVE15_DATA_WIDTH-1:0]     SLAVE15_WDATA;  
 wire [SLAVE16_DATA_WIDTH-1:0]     SLAVE16_WDATA;  
 wire [SLAVE17_DATA_WIDTH-1:0]     SLAVE17_WDATA;  
 wire [SLAVE18_DATA_WIDTH-1:0]     SLAVE18_WDATA;  
 wire [SLAVE19_DATA_WIDTH-1:0]     SLAVE19_WDATA;  
 wire [SLAVE20_DATA_WIDTH-1:0]     SLAVE20_WDATA;  
 wire [SLAVE21_DATA_WIDTH-1:0]     SLAVE21_WDATA;  
 wire [SLAVE22_DATA_WIDTH-1:0]     SLAVE22_WDATA;   
 wire [SLAVE23_DATA_WIDTH-1:0]     SLAVE23_WDATA;  
 wire [SLAVE24_DATA_WIDTH-1:0]     SLAVE24_WDATA;  
 wire [SLAVE25_DATA_WIDTH-1:0]     SLAVE25_WDATA;  
 wire [SLAVE26_DATA_WIDTH-1:0]     SLAVE26_WDATA;  
 wire [SLAVE27_DATA_WIDTH-1:0]     SLAVE27_WDATA;  
 wire [SLAVE28_DATA_WIDTH-1:0]     SLAVE28_WDATA;  
 wire [SLAVE29_DATA_WIDTH-1:0]     SLAVE29_WDATA;  
 wire [SLAVE30_DATA_WIDTH-1:0]     SLAVE30_WDATA;   
 wire [SLAVE31_DATA_WIDTH-1:0]     SLAVE31_WDATA;


 wire [(SLAVE0_DATA_WIDTH/8)-1:0]     SLAVE0_WSTRB;
 wire [(SLAVE1_DATA_WIDTH/8)-1:0]     SLAVE1_WSTRB;  
 wire [(SLAVE2_DATA_WIDTH/8)-1:0]     SLAVE2_WSTRB;  
 wire [(SLAVE3_DATA_WIDTH/8)-1:0]     SLAVE3_WSTRB;  
 wire [(SLAVE4_DATA_WIDTH/8)-1:0]     SLAVE4_WSTRB;  
 wire [(SLAVE5_DATA_WIDTH/8)-1:0]     SLAVE5_WSTRB;  
 wire [(SLAVE6_DATA_WIDTH/8)-1:0]     SLAVE6_WSTRB;  
 wire [(SLAVE7_DATA_WIDTH/8)-1:0]     SLAVE7_WSTRB;
 wire [(SLAVE8_DATA_WIDTH/8)-1:0]     SLAVE8_WSTRB;
 wire [(SLAVE9_DATA_WIDTH/8)-1:0]     SLAVE9_WSTRB;  
 wire [(SLAVE10_DATA_WIDTH/8)-1:0]    SLAVE10_WSTRB;  
 wire [(SLAVE11_DATA_WIDTH/8)-1:0]    SLAVE11_WSTRB;  
 wire [(SLAVE12_DATA_WIDTH/8)-1:0]    SLAVE12_WSTRB;  
 wire [(SLAVE13_DATA_WIDTH/8)-1:0]    SLAVE13_WSTRB;  
 wire [(SLAVE14_DATA_WIDTH/8)-1:0]    SLAVE14_WSTRB;  
 wire [(SLAVE15_DATA_WIDTH/8)-1:0]    SLAVE15_WSTRB;
 wire [(SLAVE16_DATA_WIDTH/8)-1:0]    SLAVE16_WSTRB;
 wire [(SLAVE17_DATA_WIDTH/8)-1:0]    SLAVE17_WSTRB;  
 wire [(SLAVE18_DATA_WIDTH/8)-1:0]    SLAVE18_WSTRB;  
 wire [(SLAVE19_DATA_WIDTH/8)-1:0]    SLAVE19_WSTRB;  
 wire [(SLAVE20_DATA_WIDTH/8)-1:0]    SLAVE20_WSTRB;  
 wire [(SLAVE21_DATA_WIDTH/8)-1:0]    SLAVE21_WSTRB;  
 wire [(SLAVE22_DATA_WIDTH/8)-1:0]    SLAVE22_WSTRB;  
 wire [(SLAVE23_DATA_WIDTH/8)-1:0]    SLAVE23_WSTRB;
 wire [(SLAVE24_DATA_WIDTH/8)-1:0]    SLAVE24_WSTRB;
 wire [(SLAVE25_DATA_WIDTH/8)-1:0]    SLAVE25_WSTRB;  
 wire [(SLAVE26_DATA_WIDTH/8)-1:0]    SLAVE26_WSTRB;  
 wire [(SLAVE27_DATA_WIDTH/8)-1:0]    SLAVE27_WSTRB;  
 wire [(SLAVE28_DATA_WIDTH/8)-1:0]    SLAVE28_WSTRB;  
 wire [(SLAVE29_DATA_WIDTH/8)-1:0]    SLAVE29_WSTRB;  
 wire [(SLAVE30_DATA_WIDTH/8)-1:0]    SLAVE30_WSTRB;  
 wire [(SLAVE31_DATA_WIDTH/8)-1:0]    SLAVE31_WSTRB;


 wire                         SLAVE0_WLAST,  SLAVE1_WLAST,  SLAVE2_WLAST,  SLAVE3_WLAST,  SLAVE4_WLAST,  SLAVE5_WLAST,  SLAVE6_WLAST,  SLAVE7_WLAST, 
                              SLAVE8_WLAST,  SLAVE9_WLAST,  SLAVE10_WLAST, SLAVE11_WLAST, SLAVE12_WLAST, SLAVE13_WLAST, SLAVE14_WLAST, SLAVE15_WLAST, 
                              SLAVE16_WLAST, SLAVE17_WLAST, SLAVE18_WLAST, SLAVE19_WLAST, SLAVE20_WLAST, SLAVE21_WLAST, SLAVE22_WLAST, SLAVE23_WLAST, 
                              SLAVE24_WLAST, SLAVE25_WLAST, SLAVE26_WLAST, SLAVE27_WLAST, SLAVE28_WLAST, SLAVE29_WLAST, SLAVE30_WLAST, SLAVE31_WLAST;
                              
 wire [USER_WIDTH-1:0]        SLAVE0_WUSER,  SLAVE1_WUSER,  SLAVE2_WUSER,  SLAVE3_WUSER,  SLAVE4_WUSER,  SLAVE5_WUSER,  SLAVE6_WUSER,  SLAVE7_WUSER, 
                              SLAVE8_WUSER,  SLAVE9_WUSER,  SLAVE10_WUSER, SLAVE11_WUSER, SLAVE12_WUSER, SLAVE13_WUSER, SLAVE14_WUSER, SLAVE15_WUSER, 
                              SLAVE16_WUSER, SLAVE17_WUSER, SLAVE18_WUSER, SLAVE19_WUSER, SLAVE20_WUSER, SLAVE21_WUSER, SLAVE22_WUSER, SLAVE23_WUSER, 
                              SLAVE24_WUSER, SLAVE25_WUSER, SLAVE26_WUSER, SLAVE27_WUSER, SLAVE28_WUSER, SLAVE29_WUSER, SLAVE30_WUSER, SLAVE31_WUSER;
                              
 wire                         SLAVE0_WVALID,  SLAVE1_WVALID,  SLAVE2_WVALID,  SLAVE3_WVALID,  SLAVE4_WVALID,  SLAVE5_WVALID,  SLAVE6_WVALID,  SLAVE7_WVALID, 
                              SLAVE8_WVALID,  SLAVE9_WVALID,  SLAVE10_WVALID, SLAVE11_WVALID, SLAVE12_WVALID, SLAVE13_WVALID, SLAVE14_WVALID, SLAVE15_WVALID, 
                              SLAVE16_WVALID, SLAVE17_WVALID, SLAVE18_WVALID, SLAVE19_WVALID, SLAVE20_WVALID, SLAVE21_WVALID, SLAVE22_WVALID, SLAVE23_WVALID, 
                              SLAVE24_WVALID, SLAVE25_WVALID, SLAVE26_WVALID, SLAVE27_WVALID, SLAVE28_WVALID, SLAVE29_WVALID, SLAVE30_WVALID, SLAVE31_WVALID;
                              
 wire                         SLAVE0_WREADY,  SLAVE1_WREADY,  SLAVE2_WREADY,  SLAVE3_WREADY,  SLAVE4_WREADY,  SLAVE5_WREADY,  SLAVE6_WREADY,  SLAVE7_WREADY, 
                              SLAVE8_WREADY,  SLAVE9_WREADY,  SLAVE10_WREADY, SLAVE11_WREADY, SLAVE12_WREADY, SLAVE13_WREADY, SLAVE14_WREADY, SLAVE15_WREADY, 
                              SLAVE16_WREADY, SLAVE17_WREADY, SLAVE18_WREADY, SLAVE19_WREADY, SLAVE20_WREADY, SLAVE21_WREADY, SLAVE22_WREADY, SLAVE23_WREADY, 
                              SLAVE24_WREADY, SLAVE25_WREADY, SLAVE26_WREADY, SLAVE27_WREADY, SLAVE28_WREADY, SLAVE29_WREADY, SLAVE30_WREADY, SLAVE31_WREADY;

  // Slave Write Response Ports
wire [(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]    SLAVE0_BID,  SLAVE1_BID,  SLAVE2_BID,  SLAVE3_BID,  SLAVE4_BID,  SLAVE5_BID,  SLAVE6_BID,  SLAVE7_BID, 
                                           SLAVE8_BID,  SLAVE9_BID,  SLAVE10_BID, SLAVE11_BID, SLAVE12_BID, SLAVE13_BID, SLAVE14_BID, SLAVE15_BID, 
                                           SLAVE16_BID, SLAVE17_BID, SLAVE18_BID, SLAVE19_BID, SLAVE20_BID, SLAVE21_BID, SLAVE22_BID, SLAVE23_BID, 
                                           SLAVE24_BID, SLAVE25_BID, SLAVE26_BID, SLAVE27_BID, SLAVE28_BID, SLAVE29_BID, SLAVE30_BID, SLAVE31_BID;
                                           
wire [1:0]                                 SLAVE0_BRESP,  SLAVE1_BRESP,  SLAVE2_BRESP,  SLAVE3_BRESP,  SLAVE4_BRESP,  SLAVE5_BRESP,  SLAVE6_BRESP,  SLAVE7_BRESP, 
                                           SLAVE8_BRESP,  SLAVE9_BRESP,  SLAVE10_BRESP, SLAVE11_BRESP, SLAVE12_BRESP, SLAVE13_BRESP, SLAVE14_BRESP, SLAVE15_BRESP, 
                                           SLAVE16_BRESP, SLAVE17_BRESP, SLAVE18_BRESP, SLAVE19_BRESP, SLAVE20_BRESP, SLAVE21_BRESP, SLAVE22_BRESP, SLAVE23_BRESP, 
                                           SLAVE24_BRESP, SLAVE25_BRESP, SLAVE26_BRESP, SLAVE27_BRESP, SLAVE28_BRESP, SLAVE29_BRESP, SLAVE30_BRESP, SLAVE31_BRESP;
                   
wire [USER_WIDTH-1:0]                      SLAVE0_BUSER,  SLAVE1_BUSER,  SLAVE2_BUSER,  SLAVE3_BUSER,  SLAVE4_BUSER,  SLAVE5_BUSER,  SLAVE6_BUSER,  SLAVE7_BUSER, 
                                           SLAVE8_BUSER,  SLAVE9_BUSER,  SLAVE10_BUSER, SLAVE11_BUSER, SLAVE12_BUSER, SLAVE13_BUSER, SLAVE14_BUSER, SLAVE15_BUSER, 
                                           SLAVE16_BUSER, SLAVE17_BUSER, SLAVE18_BUSER, SLAVE19_BUSER, SLAVE20_BUSER, SLAVE21_BUSER, SLAVE22_BUSER, SLAVE23_BUSER, 
                                           SLAVE24_BUSER, SLAVE25_BUSER, SLAVE26_BUSER, SLAVE27_BUSER, SLAVE28_BUSER, SLAVE29_BUSER, SLAVE30_BUSER, SLAVE31_BUSER;
                                           
wire                                       SLAVE0_BVALID,  SLAVE1_BVALID,  SLAVE2_BVALID,  SLAVE3_BVALID,  SLAVE4_BVALID,  SLAVE5_BVALID,  SLAVE6_BVALID,  SLAVE7_BVALID, 
                                           SLAVE8_BVALID,  SLAVE9_BVALID,  SLAVE10_BVALID, SLAVE11_BVALID, SLAVE12_BVALID, SLAVE13_BVALID, SLAVE14_BVALID, SLAVE15_BVALID, 
                                           SLAVE16_BVALID, SLAVE17_BVALID, SLAVE18_BVALID, SLAVE19_BVALID, SLAVE20_BVALID, SLAVE21_BVALID, SLAVE22_BVALID, SLAVE23_BVALID, 
                                           SLAVE24_BVALID, SLAVE25_BVALID, SLAVE26_BVALID, SLAVE27_BVALID, SLAVE28_BVALID, SLAVE29_BVALID, SLAVE30_BVALID, SLAVE31_BVALID;

wire                                       SLAVE0_BREADY,  SLAVE1_BREADY,  SLAVE2_BREADY,  SLAVE3_BREADY,  SLAVE4_BREADY,  SLAVE5_BREADY,  SLAVE6_BREADY,  SLAVE7_BREADY, 
                                           SLAVE8_BREADY,  SLAVE9_BREADY,  SLAVE10_BREADY, SLAVE11_BREADY, SLAVE12_BREADY, SLAVE13_BREADY, SLAVE14_BREADY, SLAVE15_BREADY, 
                                           SLAVE16_BREADY, SLAVE17_BREADY, SLAVE18_BREADY, SLAVE19_BREADY, SLAVE20_BREADY, SLAVE21_BREADY, SLAVE22_BREADY, SLAVE23_BREADY, 
                                           SLAVE24_BREADY, SLAVE25_BREADY, SLAVE26_BREADY, SLAVE27_BREADY, SLAVE28_BREADY, SLAVE29_BREADY, SLAVE30_BREADY, SLAVE31_BREADY;
   
  // Slave Read Address Port
  wire [(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]    SLAVE0_ARID,  SLAVE1_ARID,  SLAVE2_ARID,  SLAVE3_ARID,  SLAVE4_ARID,  SLAVE5_ARID,  SLAVE6_ARID,  SLAVE7_ARID, 
                                             SLAVE8_ARID,  SLAVE9_ARID,  SLAVE10_ARID, SLAVE11_ARID, SLAVE12_ARID, SLAVE13_ARID, SLAVE14_ARID, SLAVE15_ARID, 
                                             SLAVE16_ARID, SLAVE17_ARID, SLAVE18_ARID, SLAVE19_ARID, SLAVE20_ARID, SLAVE21_ARID, SLAVE22_ARID, SLAVE23_ARID, 
                                             SLAVE24_ARID, SLAVE25_ARID, SLAVE26_ARID, SLAVE27_ARID, SLAVE28_ARID, SLAVE29_ARID, SLAVE30_ARID, SLAVE31_ARID;
 
 
 
  wire [ADDR_WIDTH-1:0]      SLAVE0_ARADDR,  SLAVE1_ARADDR,  SLAVE2_ARADDR,  SLAVE3_ARADDR,  SLAVE4_ARADDR,  SLAVE5_ARADDR,  SLAVE6_ARADDR,  SLAVE7_ARADDR, 
                             SLAVE8_ARADDR,  SLAVE9_ARADDR,  SLAVE10_ARADDR, SLAVE11_ARADDR, SLAVE12_ARADDR, SLAVE13_ARADDR, SLAVE14_ARADDR, SLAVE15_ARADDR, 
                             SLAVE16_ARADDR, SLAVE17_ARADDR, SLAVE18_ARADDR, SLAVE19_ARADDR, SLAVE20_ARADDR, SLAVE21_ARADDR, SLAVE22_ARADDR, SLAVE23_ARADDR, 
                             SLAVE24_ARADDR, SLAVE25_ARADDR, SLAVE26_ARADDR, SLAVE27_ARADDR, SLAVE28_ARADDR, SLAVE29_ARADDR, SLAVE30_ARADDR, SLAVE31_ARADDR;


  wire [7:0]                 SLAVE0_ARLEN,  SLAVE1_ARLEN,  SLAVE2_ARLEN,  SLAVE3_ARLEN,  SLAVE4_ARLEN,  SLAVE5_ARLEN,  SLAVE6_ARLEN,  SLAVE7_ARLEN, 
                             SLAVE8_ARLEN,  SLAVE9_ARLEN,  SLAVE10_ARLEN, SLAVE11_ARLEN, SLAVE12_ARLEN, SLAVE13_ARLEN, SLAVE14_ARLEN, SLAVE15_ARLEN, 
                             SLAVE16_ARLEN, SLAVE17_ARLEN, SLAVE18_ARLEN, SLAVE19_ARLEN, SLAVE20_ARLEN, SLAVE21_ARLEN, SLAVE22_ARLEN, SLAVE23_ARLEN, 
                             SLAVE24_ARLEN, SLAVE25_ARLEN, SLAVE26_ARLEN, SLAVE27_ARLEN, SLAVE28_ARLEN, SLAVE29_ARLEN, SLAVE30_ARLEN, SLAVE31_ARLEN;


  wire [2:0]                 SLAVE0_ARSIZE,  SLAVE1_ARSIZE,  SLAVE2_ARSIZE,  SLAVE3_ARSIZE,  SLAVE4_ARSIZE,  SLAVE5_ARSIZE,  SLAVE6_ARSIZE,  SLAVE7_ARSIZE, 
                             SLAVE8_ARSIZE,  SLAVE9_ARSIZE,  SLAVE10_ARSIZE, SLAVE11_ARSIZE, SLAVE12_ARSIZE, SLAVE13_ARSIZE, SLAVE14_ARSIZE, SLAVE15_ARSIZE, 
                             SLAVE16_ARSIZE, SLAVE17_ARSIZE, SLAVE18_ARSIZE, SLAVE19_ARSIZE, SLAVE20_ARSIZE, SLAVE21_ARSIZE, SLAVE22_ARSIZE, SLAVE23_ARSIZE, 
                             SLAVE24_ARSIZE, SLAVE25_ARSIZE, SLAVE26_ARSIZE, SLAVE27_ARSIZE, SLAVE28_ARSIZE, SLAVE29_ARSIZE, SLAVE30_ARSIZE, SLAVE31_ARSIZE;


  wire [1:0]                 SLAVE0_ARBURST,  SLAVE1_ARBURST,  SLAVE2_ARBURST,  SLAVE3_ARBURST,  SLAVE4_ARBURST,  SLAVE5_ARBURST,  SLAVE6_ARBURST,  SLAVE7_ARBURST, 
                             SLAVE8_ARBURST,  SLAVE9_ARBURST,  SLAVE10_ARBURST, SLAVE11_ARBURST, SLAVE12_ARBURST, SLAVE13_ARBURST, SLAVE14_ARBURST, SLAVE15_ARBURST, 
                             SLAVE16_ARBURST, SLAVE17_ARBURST, SLAVE18_ARBURST, SLAVE19_ARBURST, SLAVE20_ARBURST, SLAVE21_ARBURST, SLAVE22_ARBURST, SLAVE23_ARBURST, 
                             SLAVE24_ARBURST, SLAVE25_ARBURST, SLAVE26_ARBURST, SLAVE27_ARBURST, SLAVE28_ARBURST, SLAVE29_ARBURST, SLAVE30_ARBURST, SLAVE31_ARBURST;


  wire [1:0]                 SLAVE0_ARLOCK,  SLAVE1_ARLOCK,  SLAVE2_ARLOCK,  SLAVE3_ARLOCK,  SLAVE4_ARLOCK,  SLAVE5_ARLOCK,  SLAVE6_ARLOCK,  SLAVE7_ARLOCK, 
                             SLAVE8_ARLOCK,  SLAVE9_ARLOCK,  SLAVE10_ARLOCK, SLAVE11_ARLOCK, SLAVE12_ARLOCK, SLAVE13_ARLOCK, SLAVE14_ARLOCK, SLAVE15_ARLOCK, 
                             SLAVE16_ARLOCK, SLAVE17_ARLOCK, SLAVE18_ARLOCK, SLAVE19_ARLOCK, SLAVE20_ARLOCK, SLAVE21_ARLOCK, SLAVE22_ARLOCK, SLAVE23_ARLOCK, 
                             SLAVE24_ARLOCK, SLAVE25_ARLOCK, SLAVE26_ARLOCK, SLAVE27_ARLOCK, SLAVE28_ARLOCK, SLAVE29_ARLOCK, SLAVE30_ARLOCK, SLAVE31_ARLOCK;


  wire [3:0]                 SLAVE0_ARCACHE,  SLAVE1_ARCACHE,  SLAVE2_ARCACHE,  SLAVE3_ARCACHE,  SLAVE4_ARCACHE,  SLAVE5_ARCACHE,  SLAVE6_ARCACHE,  SLAVE7_ARCACHE, 
                             SLAVE8_ARCACHE,  SLAVE9_ARCACHE,  SLAVE10_ARCACHE, SLAVE11_ARCACHE, SLAVE12_ARCACHE, SLAVE13_ARCACHE, SLAVE14_ARCACHE, SLAVE15_ARCACHE, 
                             SLAVE16_ARCACHE, SLAVE17_ARCACHE, SLAVE18_ARCACHE, SLAVE19_ARCACHE, SLAVE20_ARCACHE, SLAVE21_ARCACHE, SLAVE22_ARCACHE, SLAVE23_ARCACHE, 
                             SLAVE24_ARCACHE, SLAVE25_ARCACHE, SLAVE26_ARCACHE, SLAVE27_ARCACHE, SLAVE28_ARCACHE, SLAVE29_ARCACHE, SLAVE30_ARCACHE, SLAVE31_ARCACHE;


  wire [2:0]                 SLAVE0_ARPROT,  SLAVE1_ARPROT,  SLAVE2_ARPROT,  SLAVE3_ARPROT,  SLAVE4_ARPROT,  SLAVE5_ARPROT,  SLAVE6_ARPROT,  SLAVE7_ARPROT, 
                             SLAVE8_ARPROT,  SLAVE9_ARPROT,  SLAVE10_ARPROT, SLAVE11_ARPROT, SLAVE12_ARPROT, SLAVE13_ARPROT, SLAVE14_ARPROT, SLAVE15_ARPROT, 
                             SLAVE16_ARPROT, SLAVE17_ARPROT, SLAVE18_ARPROT, SLAVE19_ARPROT, SLAVE20_ARPROT, SLAVE21_ARPROT, SLAVE22_ARPROT, SLAVE23_ARPROT, 
                             SLAVE24_ARPROT, SLAVE25_ARPROT, SLAVE26_ARPROT, SLAVE27_ARPROT, SLAVE28_ARPROT, SLAVE29_ARPROT, SLAVE30_ARPROT, SLAVE31_ARPROT;


  wire [3:0]                 SLAVE0_ARREGION,  SLAVE1_ARREGION,  SLAVE2_ARREGION,  SLAVE3_ARREGION,  SLAVE4_ARREGION,  SLAVE5_ARREGION,  SLAVE6_ARREGION,  SLAVE7_ARREGION, 
                             SLAVE8_ARREGION,  SLAVE9_ARREGION,  SLAVE10_ARREGION, SLAVE11_ARREGION, SLAVE12_ARREGION, SLAVE13_ARREGION, SLAVE14_ARREGION, SLAVE15_ARREGION, 
                             SLAVE16_ARREGION, SLAVE17_ARREGION, SLAVE18_ARREGION, SLAVE19_ARREGION, SLAVE20_ARREGION, SLAVE21_ARREGION, SLAVE22_ARREGION, SLAVE23_ARREGION, 
                             SLAVE24_ARREGION, SLAVE25_ARREGION, SLAVE26_ARREGION, SLAVE27_ARREGION, SLAVE28_ARREGION, SLAVE29_ARREGION, SLAVE30_ARREGION, SLAVE31_ARREGION;


  wire [3:0]                 SLAVE0_ARQOS,  SLAVE1_ARQOS,  SLAVE2_ARQOS,  SLAVE3_ARQOS,  SLAVE4_ARQOS,  SLAVE5_ARQOS,  SLAVE6_ARQOS,  SLAVE7_ARQOS, 
                             SLAVE8_ARQOS,  SLAVE9_ARQOS,  SLAVE10_ARQOS, SLAVE11_ARQOS, SLAVE12_ARQOS, SLAVE13_ARQOS, SLAVE14_ARQOS, SLAVE15_ARQOS, 
                             SLAVE16_ARQOS, SLAVE17_ARQOS, SLAVE18_ARQOS, SLAVE19_ARQOS, SLAVE20_ARQOS, SLAVE21_ARQOS, SLAVE22_ARQOS, SLAVE23_ARQOS, 
                             SLAVE24_ARQOS, SLAVE25_ARQOS, SLAVE26_ARQOS, SLAVE27_ARQOS, SLAVE28_ARQOS, SLAVE29_ARQOS, SLAVE30_ARQOS, SLAVE31_ARQOS;

  wire [USER_WIDTH-1:0]      SLAVE0_ARUSER,  SLAVE1_ARUSER,  SLAVE2_ARUSER,  SLAVE3_ARUSER,  SLAVE4_ARUSER,  SLAVE5_ARUSER,  SLAVE6_ARUSER,  SLAVE7_ARUSER, 
                             SLAVE8_ARUSER,  SLAVE9_ARUSER,  SLAVE10_ARUSER, SLAVE11_ARUSER, SLAVE12_ARUSER, SLAVE13_ARUSER, SLAVE14_ARUSER, SLAVE15_ARUSER, 
                             SLAVE16_ARUSER, SLAVE17_ARUSER, SLAVE18_ARUSER, SLAVE19_ARUSER, SLAVE20_ARUSER, SLAVE21_ARUSER, SLAVE22_ARUSER, SLAVE23_ARUSER, 
                             SLAVE24_ARUSER, SLAVE25_ARUSER, SLAVE26_ARUSER, SLAVE27_ARUSER, SLAVE28_ARUSER, SLAVE29_ARUSER, SLAVE30_ARUSER, SLAVE31_ARUSER;


  wire                       SLAVE0_ARVALID,  SLAVE1_ARVALID,  SLAVE2_ARVALID,  SLAVE3_ARVALID,  SLAVE4_ARVALID,  SLAVE5_ARVALID,  SLAVE6_ARVALID,  SLAVE7_ARVALID, 
                             SLAVE8_ARVALID,  SLAVE9_ARVALID,  SLAVE10_ARVALID, SLAVE11_ARVALID, SLAVE12_ARVALID, SLAVE13_ARVALID, SLAVE14_ARVALID, SLAVE15_ARVALID, 
                             SLAVE16_ARVALID, SLAVE17_ARVALID, SLAVE18_ARVALID, SLAVE19_ARVALID, SLAVE20_ARVALID, SLAVE21_ARVALID, SLAVE22_ARVALID, SLAVE23_ARVALID, 
                             SLAVE24_ARVALID, SLAVE25_ARVALID, SLAVE26_ARVALID, SLAVE27_ARVALID, SLAVE28_ARVALID, SLAVE29_ARVALID, SLAVE30_ARVALID, SLAVE31_ARVALID;

 
  wire                       SLAVE0_ARREADY,  SLAVE1_ARREADY,  SLAVE2_ARREADY,  SLAVE3_ARREADY,  SLAVE4_ARREADY,  SLAVE5_ARREADY,  SLAVE6_ARREADY,  SLAVE7_ARREADY, 
                             SLAVE8_ARREADY,  SLAVE9_ARREADY,  SLAVE10_ARREADY, SLAVE11_ARREADY, SLAVE12_ARREADY, SLAVE13_ARREADY, SLAVE14_ARREADY, SLAVE15_ARREADY, 
                             SLAVE16_ARREADY, SLAVE17_ARREADY, SLAVE18_ARREADY, SLAVE19_ARREADY, SLAVE20_ARREADY, SLAVE21_ARREADY, SLAVE22_ARREADY, SLAVE23_ARREADY, 
                             SLAVE24_ARREADY, SLAVE25_ARREADY, SLAVE26_ARREADY, SLAVE27_ARREADY, SLAVE28_ARREADY, SLAVE29_ARREADY, SLAVE30_ARREADY, SLAVE31_ARREADY;


  // Slave Read Data Ports
 wire [(NUM_MASTERS_WIDTH+ID_WIDTH)-1:0]    SLAVE0_RID,  SLAVE1_RID,  SLAVE2_RID,  SLAVE3_RID,  SLAVE4_RID,  SLAVE5_RID,  SLAVE6_RID,  SLAVE7_RID, 
                                            SLAVE8_RID,  SLAVE9_RID,  SLAVE10_RID, SLAVE11_RID, SLAVE12_RID, SLAVE13_RID, SLAVE14_RID, SLAVE15_RID, 
                                            SLAVE16_RID, SLAVE17_RID, SLAVE18_RID, SLAVE19_RID, SLAVE20_RID, SLAVE21_RID, SLAVE22_RID, SLAVE23_RID, 
                                            SLAVE24_RID, SLAVE25_RID, SLAVE26_RID, SLAVE27_RID, SLAVE28_RID, SLAVE29_RID, SLAVE30_RID, SLAVE31_RID;
                                            
 wire [SLAVE0_DATA_WIDTH-1:0]    SLAVE0_RDATA;
 wire [SLAVE1_DATA_WIDTH-1:0]    SLAVE1_RDATA;
 wire [SLAVE2_DATA_WIDTH-1:0]    SLAVE2_RDATA;
 wire [SLAVE3_DATA_WIDTH-1:0]    SLAVE3_RDATA;
 wire [SLAVE4_DATA_WIDTH-1:0]    SLAVE4_RDATA;
 wire [SLAVE5_DATA_WIDTH-1:0]    SLAVE5_RDATA;
 wire [SLAVE6_DATA_WIDTH-1:0]    SLAVE6_RDATA;
 wire [SLAVE7_DATA_WIDTH-1:0]    SLAVE7_RDATA;
 wire [SLAVE8_DATA_WIDTH-1:0]    SLAVE8_RDATA;
 wire [SLAVE9_DATA_WIDTH-1:0]    SLAVE9_RDATA;
 wire [SLAVE10_DATA_WIDTH-1:0]   SLAVE10_RDATA;
 wire [SLAVE11_DATA_WIDTH-1:0]   SLAVE11_RDATA;
 wire [SLAVE12_DATA_WIDTH-1:0]   SLAVE12_RDATA;
 wire [SLAVE13_DATA_WIDTH-1:0]   SLAVE13_RDATA;
 wire [SLAVE14_DATA_WIDTH-1:0]   SLAVE14_RDATA;
 wire [SLAVE15_DATA_WIDTH-1:0]   SLAVE15_RDATA;
 wire [SLAVE16_DATA_WIDTH-1:0]   SLAVE16_RDATA;
 wire [SLAVE17_DATA_WIDTH-1:0]   SLAVE17_RDATA;
 wire [SLAVE18_DATA_WIDTH-1:0]   SLAVE18_RDATA;
 wire [SLAVE19_DATA_WIDTH-1:0]   SLAVE19_RDATA;
 wire [SLAVE20_DATA_WIDTH-1:0]   SLAVE20_RDATA;
 wire [SLAVE21_DATA_WIDTH-1:0]   SLAVE21_RDATA;
 wire [SLAVE22_DATA_WIDTH-1:0]   SLAVE22_RDATA;
 wire [SLAVE23_DATA_WIDTH-1:0]   SLAVE23_RDATA;
 wire [SLAVE24_DATA_WIDTH-1:0]   SLAVE24_RDATA;
 wire [SLAVE25_DATA_WIDTH-1:0]   SLAVE25_RDATA;
 wire [SLAVE26_DATA_WIDTH-1:0]   SLAVE26_RDATA;
 wire [SLAVE27_DATA_WIDTH-1:0]   SLAVE27_RDATA;
 wire [SLAVE28_DATA_WIDTH-1:0]   SLAVE28_RDATA;
 wire [SLAVE29_DATA_WIDTH-1:0]   SLAVE29_RDATA;
 wire [SLAVE30_DATA_WIDTH-1:0]   SLAVE30_RDATA;
 wire [SLAVE31_DATA_WIDTH-1:0]   SLAVE31_RDATA;


 wire [1:0]                 SLAVE0_RRESP,  SLAVE1_RRESP,  SLAVE2_RRESP,  SLAVE3_RRESP,  SLAVE4_RRESP,  SLAVE5_RRESP,  SLAVE6_RRESP,  SLAVE7_RRESP,
                            SLAVE8_RRESP,  SLAVE9_RRESP,  SLAVE10_RRESP, SLAVE11_RRESP, SLAVE12_RRESP, SLAVE13_RRESP, SLAVE14_RRESP, SLAVE15_RRESP, 
                            SLAVE16_RRESP, SLAVE17_RRESP, SLAVE18_RRESP, SLAVE19_RRESP, SLAVE20_RRESP, SLAVE21_RRESP, SLAVE22_RRESP, SLAVE23_RRESP, 
                            SLAVE24_RRESP, SLAVE25_RRESP, SLAVE26_RRESP, SLAVE27_RRESP, SLAVE28_RRESP, SLAVE29_RRESP, SLAVE30_RRESP, SLAVE31_RRESP;

 wire                       SLAVE0_RLAST,  SLAVE1_RLAST,  SLAVE2_RLAST,  SLAVE3_RLAST,  SLAVE4_RLAST,  SLAVE5_RLAST,  SLAVE6_RLAST,  SLAVE7_RLAST,
                            SLAVE8_RLAST,  SLAVE9_RLAST,  SLAVE10_RLAST, SLAVE11_RLAST, SLAVE12_RLAST, SLAVE13_RLAST, SLAVE14_RLAST, SLAVE15_RLAST, 
                            SLAVE16_RLAST, SLAVE17_RLAST, SLAVE18_RLAST, SLAVE19_RLAST, SLAVE20_RLAST, SLAVE21_RLAST, SLAVE22_RLAST, SLAVE23_RLAST, 
                            SLAVE24_RLAST, SLAVE25_RLAST, SLAVE26_RLAST, SLAVE27_RLAST, SLAVE28_RLAST, SLAVE29_RLAST, SLAVE30_RLAST, SLAVE31_RLAST;
                                            
                                            
 wire [USER_WIDTH-1:0]      SLAVE0_RUSER,  SLAVE1_RUSER,  SLAVE2_RUSER,  SLAVE3_RUSER,  SLAVE4_RUSER,  SLAVE5_RUSER,  SLAVE6_RUSER,  SLAVE7_RUSER,
                            SLAVE8_RUSER,  SLAVE9_RUSER,  SLAVE10_RUSER, SLAVE11_RUSER, SLAVE12_RUSER, SLAVE13_RUSER, SLAVE14_RUSER, SLAVE15_RUSER, 
                            SLAVE16_RUSER, SLAVE17_RUSER, SLAVE18_RUSER, SLAVE19_RUSER, SLAVE20_RUSER, SLAVE21_RUSER, SLAVE22_RUSER, SLAVE23_RUSER, 
                            SLAVE24_RUSER, SLAVE25_RUSER, SLAVE26_RUSER, SLAVE27_RUSER, SLAVE28_RUSER, SLAVE29_RUSER, SLAVE30_RUSER, SLAVE31_RUSER;
                                            
                                            
 wire                       SLAVE0_RVALID,  SLAVE1_RVALID,  SLAVE2_RVALID,  SLAVE3_RVALID,  SLAVE4_RVALID,  SLAVE5_RVALID,  SLAVE6_RVALID,   SLAVE7_RVALID,
                            SLAVE8_RVALID,  SLAVE9_RVALID,  SLAVE10_RVALID, SLAVE11_RVALID, SLAVE12_RVALID, SLAVE13_RVALID, SLAVE14_RVALID, SLAVE15_RVALID, 
                            SLAVE16_RVALID, SLAVE17_RVALID, SLAVE18_RVALID, SLAVE19_RVALID, SLAVE20_RVALID, SLAVE21_RVALID, SLAVE22_RVALID, SLAVE23_RVALID, 
                            SLAVE24_RVALID, SLAVE25_RVALID, SLAVE26_RVALID, SLAVE27_RVALID, SLAVE28_RVALID, SLAVE29_RVALID, SLAVE30_RVALID, SLAVE31_RVALID;
                                            
                                            
 wire                       SLAVE0_RREADY,  SLAVE1_RREADY,  SLAVE2_RREADY,  SLAVE3_RREADY,  SLAVE4_RREADY,  SLAVE5_RREADY,  SLAVE6_RREADY,  SLAVE7_RREADY,
                            SLAVE8_RREADY,  SLAVE9_RREADY,  SLAVE10_RREADY, SLAVE11_RREADY, SLAVE12_RREADY, SLAVE13_RREADY, SLAVE14_RREADY, SLAVE15_RREADY, 
                            SLAVE16_RREADY, SLAVE17_RREADY, SLAVE18_RREADY, SLAVE19_RREADY, SLAVE20_RREADY, SLAVE21_RREADY, SLAVE22_RREADY, SLAVE23_RREADY, 
                            SLAVE24_RREADY, SLAVE25_RREADY, SLAVE26_RREADY, SLAVE27_RREADY, SLAVE28_RREADY, SLAVE29_RREADY, SLAVE30_RREADY, SLAVE31_RREADY;
   
  
  wire[8-1:0] M_CLK;
  wire[32-1:0] S_CLK;

  reg [ADDR_WIDTH-1:0] next_addr, offset_addr;

  generate
  if(MASTER0_CLOCK_DOMAIN_CROSSING)
    assign M_CLK[0] = M_CLK0;
  else
    assign M_CLK[0] = ACLK;
  endgenerate
  
  generate
  if(MASTER1_CLOCK_DOMAIN_CROSSING)
    assign M_CLK[1] = M_CLK1;
  else
    assign M_CLK[1] = ACLK;
  endgenerate
  
  generate
  if(MASTER2_CLOCK_DOMAIN_CROSSING)
    assign M_CLK[2] = M_CLK2;
  else
    assign M_CLK[2] = ACLK;
  endgenerate
  
  generate
  if(MASTER3_CLOCK_DOMAIN_CROSSING)
    assign M_CLK[3] = M_CLK3;
  else
    assign M_CLK[3] = ACLK;
  endgenerate
  
  generate
  if(MASTER4_CLOCK_DOMAIN_CROSSING)
    assign M_CLK[4] = M_CLK4;
  else
    assign M_CLK[4] = ACLK;
  endgenerate
  
  generate
  if(MASTER5_CLOCK_DOMAIN_CROSSING)
    assign M_CLK[5] = M_CLK5;
  else
    assign M_CLK[5] = ACLK;
  endgenerate
  
  generate
  if(MASTER6_CLOCK_DOMAIN_CROSSING)
    assign M_CLK[6] = M_CLK6;
  else
    assign M_CLK[6] = ACLK;
  endgenerate
  
  generate
  if(MASTER7_CLOCK_DOMAIN_CROSSING)
    assign M_CLK[7] = M_CLK7;
  else
    assign M_CLK[7] = ACLK;
  endgenerate
  
  generate
  if(SLAVE0_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[0] = S_CLK0;
  else
    assign S_CLK[0] = ACLK;
  endgenerate
  
  generate
  if(SLAVE1_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[1] = S_CLK1;
  else
    assign S_CLK[1] = ACLK;
  endgenerate
  
  generate
  if(SLAVE2_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[2] = S_CLK2;
  else
    assign S_CLK[2] = ACLK;
  endgenerate
  
  generate
  if(SLAVE3_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[3] = S_CLK3;
  else
    assign S_CLK[3] = ACLK;
  endgenerate
  
  generate
  if(SLAVE4_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[4] = S_CLK4;
  else
    assign S_CLK[4] = ACLK;
  endgenerate
  
  generate
  if(SLAVE5_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[5] = S_CLK5;
  else
    assign S_CLK[5] = ACLK;
  endgenerate
  
  generate
  if(SLAVE6_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[6] = S_CLK6;
  else
    assign S_CLK[6] = ACLK;
  endgenerate
  
  generate
  if(SLAVE7_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[7] = S_CLK7;
  else
    assign S_CLK[7] = ACLK;
  endgenerate
  
  generate
  if(SLAVE8_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[8] = S_CLK8;
  else
    assign S_CLK[8] = ACLK;
  endgenerate
  
  generate
  if(SLAVE9_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[9] = S_CLK9;
  else
    assign S_CLK[9] = ACLK;
  endgenerate
  
  generate
  if(SLAVE10_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[10] = S_CLK10;
  else
    assign S_CLK[10] = ACLK;
  endgenerate
  
  generate
  if(SLAVE11_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[11] = S_CLK11;
  else
    assign S_CLK[11] = ACLK;
  endgenerate
  
  generate
  if(SLAVE12_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[12] = S_CLK12;
  else
    assign S_CLK[12] = ACLK;
  endgenerate
  
  generate
  if(SLAVE13_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[13] = S_CLK13;
  else
    assign S_CLK[13] = ACLK;
  endgenerate
  
  generate
  if(SLAVE14_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[14] = S_CLK14;
  else
    assign S_CLK[14] = ACLK;
  endgenerate
  
  generate
  if(SLAVE15_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[15] = S_CLK15;
  else
    assign S_CLK[15] = ACLK;
  endgenerate
  
  generate
  if(SLAVE16_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[16] = S_CLK16;
  else
    assign S_CLK[16] = ACLK;
  endgenerate
  
  generate
  if(SLAVE17_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[17] = S_CLK17;
  else
    assign S_CLK[17] = ACLK;
  endgenerate
  
  generate
  if(SLAVE18_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[18] = S_CLK18;
  else
    assign S_CLK[18] = ACLK;
  endgenerate
  
  generate
  if(SLAVE19_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[19] = S_CLK19;
  else
    assign S_CLK[19] = ACLK;
  endgenerate
  
  generate
  if(SLAVE20_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[20] = S_CLK20;
  else
    assign S_CLK[20] = ACLK;
  endgenerate
  
  generate
  if(SLAVE21_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[21] = S_CLK21;
  else
    assign S_CLK[21] = ACLK;
  endgenerate
  
  generate
  if(SLAVE22_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[22] = S_CLK22;
  else
    assign S_CLK[22] = ACLK;
  endgenerate
  
  generate
  if(SLAVE23_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[23] = S_CLK23;
  else
    assign S_CLK[23] = ACLK;
  endgenerate
  
  generate
  if(SLAVE24_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[24] = S_CLK24;
  else
    assign S_CLK[24] = ACLK;
  endgenerate
  
  generate
  if(SLAVE25_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[25] = S_CLK25;
  else
    assign S_CLK[25] = ACLK;
  endgenerate
  
  generate
  if(SLAVE26_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[26] = S_CLK26;
  else
    assign S_CLK[26] = ACLK;
  endgenerate
  
  generate
  if(SLAVE27_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[27] = S_CLK27;
  else
    assign S_CLK[27] = ACLK;
  endgenerate
  
  generate
  if(SLAVE28_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[28] = S_CLK28;
  else
    assign S_CLK[28] = ACLK;
  endgenerate
  
  generate
  if(SLAVE29_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[29] = S_CLK29;
  else
    assign S_CLK[29] = ACLK;
  endgenerate
  
  generate
  if(SLAVE30_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[30] = S_CLK30;
  else
    assign S_CLK[30] = ACLK;
  endgenerate
  
  generate
  if(SLAVE31_CLOCK_DOMAIN_CROSSING)
    assign S_CLK[31] = S_CLK31;
  else
    assign S_CLK[31] = ACLK;
  endgenerate
  
  //==================================================================================================================================//

`ifdef WRAPPER_EN
  CoreAXI4Interconnect_w #
`else
  COREAXI4INTERCONNECT #
`endif
    (
      //=====================================================================
      // Global // parameters
      //=====================================================================
      .FAMILY         ( FAMILY ), 
      .NUM_MASTERS    ( NUM_MASTERS ),  // defines number of master ports 
	  .NUM_MASTERS_WIDTH (NUM_MASTERS_WIDTH),
      .NUM_SLAVES     ( NUM_SLAVES ),   // defines number of slaves
      .ID_WIDTH       ( ID_WIDTH ),     // number of bits for ID (ie AID, WID, BID) - valid 1-8 
      .ADDR_WIDTH     ( ADDR_WIDTH ),   // valid values - 16 - 64
      //====================================================================
      // Crossbar // parameters
      //====================================================================
      .DATA_WIDTH   ( DATA_WIDTH  ),        // valid widths - 32, 64, 128

      .NUM_THREADS         ( NUM_THREADS ),    // defined number of indpendent threads per master supported - valid range 1-8
      .OPEN_TRANS_MAX      ( OPEN_TRANS_MAX ),    // max number of outstanding transactions per thread - valid range 1-8

      .SLAVE0_START_ADDR  ( SLAVE0_START_ADDR   ),      // SLAVE0 Start address
      .SLAVE1_START_ADDR  ( SLAVE1_START_ADDR   ),      // SLAVE1 Start address
      .SLAVE2_START_ADDR  ( SLAVE2_START_ADDR   ),      // SLAVE2 Start address
      .SLAVE3_START_ADDR  ( SLAVE3_START_ADDR   ),      // SLAVE3 Start address
      .SLAVE4_START_ADDR  ( SLAVE4_START_ADDR   ),      // SLAVE4 Start address
      .SLAVE5_START_ADDR  ( SLAVE5_START_ADDR   ),      // SLAVE5 Start address
      .SLAVE6_START_ADDR  ( SLAVE6_START_ADDR   ),      // SLAVE6 Start address
      .SLAVE7_START_ADDR  ( SLAVE7_START_ADDR   ),      // SLAVE7 Start address
      .SLAVE8_START_ADDR  ( SLAVE8_START_ADDR   ),      // SLAVE8 Start address
      .SLAVE9_START_ADDR  ( SLAVE9_START_ADDR   ),      // SLAVE2 Start address
      .SLAVE10_START_ADDR  ( SLAVE10_START_ADDR   ),      // SLAVE3 Start address
      .SLAVE11_START_ADDR  ( SLAVE11_START_ADDR   ),      // SLAVE4 Start address
      .SLAVE12_START_ADDR  ( SLAVE12_START_ADDR   ),      // SLAVE5 Start address
      .SLAVE13_START_ADDR  ( SLAVE13_START_ADDR   ),      // SLAVE6 Start address
      .SLAVE14_START_ADDR  ( SLAVE14_START_ADDR   ),      // SLAVE7 Start address
      .SLAVE15_START_ADDR  ( SLAVE15_START_ADDR   ),      // SLAVE8 Start address
	  
      .SLAVE0_START_ADDR_UPPER  ( 0  ),      // SLAVE0 Start address
      .SLAVE1_START_ADDR_UPPER  ( 0  ),      // SLAVE1 Start address
      .SLAVE2_START_ADDR_UPPER  ( 0  ),      // SLAVE2 Start address
      .SLAVE3_START_ADDR_UPPER  ( 0  ),      // SLAVE3 Start address
      .SLAVE4_START_ADDR_UPPER  ( 0  ),      // SLAVE4 Start address
      .SLAVE5_START_ADDR_UPPER  ( 0  ),      // SLAVE5 Start address
      .SLAVE6_START_ADDR_UPPER  ( 0  ),      // SLAVE6 Start address
      .SLAVE7_START_ADDR_UPPER  ( 0  ),      // SLAVE7 Start address
      .SLAVE8_START_ADDR_UPPER  ( 0  ),      // SLAVE8 Start address
      .SLAVE9_START_ADDR_UPPER  ( 0  ),      // SLAVE2 Start address
      .SLAVE10_START_ADDR_UPPER  ( 0  ),      // SLAVE3 Start address
      .SLAVE11_START_ADDR_UPPER  ( 0  ),      // SLAVE4 Start address
      .SLAVE12_START_ADDR_UPPER  ( 0  ),      // SLAVE5 Start address
      .SLAVE13_START_ADDR_UPPER  ( 0  ),      // SLAVE6 Start address
      .SLAVE14_START_ADDR_UPPER  ( 0  ),      // SLAVE7 Start address
      .SLAVE15_START_ADDR_UPPER  ( 0  ),      // SLAVE8 Start address
	  
      .SLAVE0_END_ADDR    ( SLAVE0_END_ADDR ),  // SLAVE0 End address
      .SLAVE1_END_ADDR    ( SLAVE1_END_ADDR ),  // SLAVE1 End address
      .SLAVE2_END_ADDR    ( SLAVE2_END_ADDR ),  // SLAVE2 End address
      .SLAVE3_END_ADDR    ( SLAVE3_END_ADDR ),  // SLAVE3 End address
      .SLAVE4_END_ADDR    ( SLAVE4_END_ADDR ),  // SLAVE4 End address
      .SLAVE5_END_ADDR    ( SLAVE5_END_ADDR ),  // SLAVE5 End address
      .SLAVE6_END_ADDR    ( SLAVE6_END_ADDR ),  // SLAVE6 End address
      .SLAVE7_END_ADDR    ( SLAVE7_END_ADDR ),  // SLAVE7 End address
      .SLAVE8_END_ADDR    ( SLAVE8_END_ADDR ),  // SLAVE8 End address
      .SLAVE9_END_ADDR    ( SLAVE9_END_ADDR ),  // SLAVE2 End address
      .SLAVE10_END_ADDR    ( SLAVE10_END_ADDR ),  // SLAVE3 End address
      .SLAVE11_END_ADDR    ( SLAVE11_END_ADDR ),  // SLAVE4 End address
      .SLAVE12_END_ADDR    ( SLAVE12_END_ADDR ),  // SLAVE5 End address
      .SLAVE13_END_ADDR    ( SLAVE13_END_ADDR ),  // SLAVE6 End address
      .SLAVE14_END_ADDR    ( SLAVE14_END_ADDR ),  // SLAVE7 End address
      .SLAVE15_END_ADDR    ( SLAVE15_END_ADDR ),  // SLAVE8 End address
	  
      .SLAVE0_END_ADDR_UPPER    ( 0 ),  // SLAVE0 End address
      .SLAVE1_END_ADDR_UPPER    ( 0 ),  // SLAVE1 End address
      .SLAVE2_END_ADDR_UPPER    ( 0 ),  // SLAVE2 End address
      .SLAVE3_END_ADDR_UPPER    ( 0 ),  // SLAVE3 End address
      .SLAVE4_END_ADDR_UPPER    ( 0 ),  // SLAVE4 End address
      .SLAVE5_END_ADDR_UPPER    ( 0 ),  // SLAVE5 End address
      .SLAVE6_END_ADDR_UPPER    ( 0 ),  // SLAVE6 End address
      .SLAVE7_END_ADDR_UPPER    ( 0 ),  // SLAVE7 End address
      .SLAVE8_END_ADDR_UPPER    ( 0 ),  // SLAVE8 End address
      .SLAVE9_END_ADDR_UPPER    ( 0 ),  // SLAVE2 End address
      .SLAVE10_END_ADDR_UPPER    ( 0 ),  // SLAVE3 End address
      .SLAVE11_END_ADDR_UPPER    ( 0 ),  // SLAVE4 End address
      .SLAVE12_END_ADDR_UPPER    ( 0 ),  // SLAVE5 End address
      .SLAVE13_END_ADDR_UPPER    ( 0 ),  // SLAVE6 End address
      .SLAVE14_END_ADDR_UPPER    ( 0 ),  // SLAVE7 End address
      .SLAVE15_END_ADDR_UPPER    ( 0 ),  // SLAVE8 End address
	  
      .USER_WIDTH       ( USER_WIDTH       ),     // defines the number of bits for USER signals RUSER and WUSER
      .CROSSBAR_MODE      ( CROSSBAR_MODE      ),    // defines whether non-blocking (ie set 1) or shared access data path

      //.MASTER0_DEF_BURST_LEN( MASTER0_DEF_BURST_LEN ),
      //.MASTER1_DEF_BURST_LEN( MASTER1_DEF_BURST_LEN ),
      //.MASTER2_DEF_BURST_LEN( MASTER2_DEF_BURST_LEN ),
      //.MASTER3_DEF_BURST_LEN( MASTER3_DEF_BURST_LEN ),
      //.MASTER4_DEF_BURST_LEN( MASTER4_DEF_BURST_LEN ),
      //.MASTER5_DEF_BURST_LEN( MASTER5_DEF_BURST_LEN ),
      //.MASTER6_DEF_BURST_LEN( MASTER6_DEF_BURST_LEN ),
      //.MASTER7_DEF_BURST_LEN( MASTER7_DEF_BURST_LEN ),

      .SLAVE0_DWC_DATA_FIFO_DEPTH( SLAVE0_DWC_DATA_FIFO_DEPTH ),
      .SLAVE1_DWC_DATA_FIFO_DEPTH( SLAVE1_DWC_DATA_FIFO_DEPTH ),
      .SLAVE2_DWC_DATA_FIFO_DEPTH( SLAVE2_DWC_DATA_FIFO_DEPTH ),
      .SLAVE3_DWC_DATA_FIFO_DEPTH( SLAVE3_DWC_DATA_FIFO_DEPTH ),
      .SLAVE4_DWC_DATA_FIFO_DEPTH( SLAVE4_DWC_DATA_FIFO_DEPTH ),
      .SLAVE5_DWC_DATA_FIFO_DEPTH( SLAVE5_DWC_DATA_FIFO_DEPTH ),
      .SLAVE6_DWC_DATA_FIFO_DEPTH( SLAVE6_DWC_DATA_FIFO_DEPTH ),
      .SLAVE7_DWC_DATA_FIFO_DEPTH( SLAVE7_DWC_DATA_FIFO_DEPTH ),
      .SLAVE8_DWC_DATA_FIFO_DEPTH( SLAVE8_DWC_DATA_FIFO_DEPTH ),
	  .SLAVE9_DWC_DATA_FIFO_DEPTH( SLAVE9_DWC_DATA_FIFO_DEPTH ),
	  .SLAVE10_DWC_DATA_FIFO_DEPTH( SLAVE10_DWC_DATA_FIFO_DEPTH ),
	  .SLAVE11_DWC_DATA_FIFO_DEPTH( SLAVE11_DWC_DATA_FIFO_DEPTH ),
	  .SLAVE12_DWC_DATA_FIFO_DEPTH( SLAVE12_DWC_DATA_FIFO_DEPTH ),
	  .SLAVE13_DWC_DATA_FIFO_DEPTH( SLAVE13_DWC_DATA_FIFO_DEPTH ),
	  .SLAVE14_DWC_DATA_FIFO_DEPTH( SLAVE14_DWC_DATA_FIFO_DEPTH ),
	  .SLAVE15_DWC_DATA_FIFO_DEPTH( SLAVE15_DWC_DATA_FIFO_DEPTH ),
	 
      .MASTER0_DWC_DATA_FIFO_DEPTH( MASTER0_DWC_DATA_FIFO_DEPTH ),
      .MASTER1_DWC_DATA_FIFO_DEPTH( MASTER1_DWC_DATA_FIFO_DEPTH ),
      .MASTER2_DWC_DATA_FIFO_DEPTH( MASTER2_DWC_DATA_FIFO_DEPTH ),
      .MASTER3_DWC_DATA_FIFO_DEPTH( MASTER3_DWC_DATA_FIFO_DEPTH ),
      .MASTER4_DWC_DATA_FIFO_DEPTH( MASTER4_DWC_DATA_FIFO_DEPTH ),
      .MASTER5_DWC_DATA_FIFO_DEPTH( MASTER5_DWC_DATA_FIFO_DEPTH ),
      .MASTER6_DWC_DATA_FIFO_DEPTH( MASTER6_DWC_DATA_FIFO_DEPTH ),
      .MASTER7_DWC_DATA_FIFO_DEPTH( MASTER7_DWC_DATA_FIFO_DEPTH ),

      .MASTER0_WRITE_SLAVE0  ( MASTER0_WRITE_SLAVE0  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_WRITE_SLAVE1  ( MASTER0_WRITE_SLAVE1  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_WRITE_SLAVE2  ( MASTER0_WRITE_SLAVE2  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_WRITE_SLAVE3  ( MASTER0_WRITE_SLAVE3  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_WRITE_SLAVE4  ( MASTER0_WRITE_SLAVE4  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_WRITE_SLAVE5  ( MASTER0_WRITE_SLAVE5  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_WRITE_SLAVE6  ( MASTER0_WRITE_SLAVE6  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_WRITE_SLAVE7  ( MASTER0_WRITE_SLAVE7  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_WRITE_SLAVE8  ( MASTER0_WRITE_SLAVE8  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_WRITE_SLAVE9  ( MASTER0_WRITE_SLAVE9  ),   // bit for slave indicating if a master can write to that port
	  .MASTER0_WRITE_SLAVE10  ( MASTER0_WRITE_SLAVE10  ),   // bit for slave indicating if a master can write to that port
	  .MASTER0_WRITE_SLAVE11  ( MASTER0_WRITE_SLAVE11  ),   // bit for slave indicating if a master can write to that port
	  .MASTER0_WRITE_SLAVE12  ( MASTER0_WRITE_SLAVE12  ),   // bit for slave indicating if a master can write to that port
	  .MASTER0_WRITE_SLAVE13  ( MASTER0_WRITE_SLAVE13  ),   // bit for slave indicating if a master can write to that port
	  .MASTER0_WRITE_SLAVE14  ( MASTER0_WRITE_SLAVE14  ),   // bit for slave indicating if a master can write to that port
	  .MASTER0_WRITE_SLAVE15  ( MASTER0_WRITE_SLAVE15  ),   // bit for slave indicating if a master can write to that port
										  
      .MASTER1_WRITE_SLAVE0  ( MASTER1_WRITE_SLAVE0  ),   // bit for slave indicating if a master can write to that port
      .MASTER1_WRITE_SLAVE1  ( MASTER1_WRITE_SLAVE1  ),   // bit for slave indicating if a master can write to that port
      .MASTER1_WRITE_SLAVE2  ( MASTER1_WRITE_SLAVE2  ),   // bit for slave indicating if a master can write to that port
      .MASTER1_WRITE_SLAVE3  ( MASTER1_WRITE_SLAVE3  ),   // bit for slave indicating if a master can write to that port
      .MASTER1_WRITE_SLAVE4  ( MASTER1_WRITE_SLAVE4  ),   // bit for slave indicating if a master can write to that port
      .MASTER1_WRITE_SLAVE5  ( MASTER1_WRITE_SLAVE5  ),   // bit for slave indicating if a master can write to that port
      .MASTER1_WRITE_SLAVE6  ( MASTER1_WRITE_SLAVE6  ),   // bit for slave indicating if a master can write to that port
      .MASTER1_WRITE_SLAVE7  ( MASTER1_WRITE_SLAVE7  ),   // bit for slave indicating if a master can write to that port
      .MASTER2_WRITE_SLAVE0  ( MASTER2_WRITE_SLAVE0  ),   // bit for slave indicating if a master can write to that port
      .MASTER2_WRITE_SLAVE1  ( MASTER2_WRITE_SLAVE1  ),   // bit for slave indicating if a master can write to that port
      .MASTER2_WRITE_SLAVE2  ( MASTER2_WRITE_SLAVE2  ),   // bit for slave indicating if a master can write to that port
      .MASTER2_WRITE_SLAVE3  ( MASTER2_WRITE_SLAVE3  ),   // bit for slave indicating if a master can write to that port
      .MASTER2_WRITE_SLAVE4  ( MASTER2_WRITE_SLAVE4  ),   // bit for slave indicating if a master can write to that port
      .MASTER2_WRITE_SLAVE5  ( MASTER2_WRITE_SLAVE5  ),   // bit for slave indicating if a master can write to that port
      .MASTER2_WRITE_SLAVE6  ( MASTER2_WRITE_SLAVE6  ),   // bit for slave indicating if a master can write to that port
      .MASTER2_WRITE_SLAVE7  ( MASTER2_WRITE_SLAVE7  ),   // bit for slave indicating if a master can write to that port  
      .MASTER3_WRITE_SLAVE0  ( MASTER3_WRITE_SLAVE0  ),   // bit for slave indicating if a master can write to that port
      .MASTER3_WRITE_SLAVE1  ( MASTER3_WRITE_SLAVE1  ),   // bit for slave indicating if a master can write to that port
      .MASTER3_WRITE_SLAVE2  ( MASTER3_WRITE_SLAVE2  ),   // bit for slave indicating if a master can write to that port
      .MASTER3_WRITE_SLAVE3  ( MASTER3_WRITE_SLAVE3  ),   // bit for slave indicating if a master can write to that port
      .MASTER3_WRITE_SLAVE4  ( MASTER3_WRITE_SLAVE4  ),   // bit for slave indicating if a master can write to that port
      .MASTER3_WRITE_SLAVE5  ( MASTER3_WRITE_SLAVE5  ),   // bit for slave indicating if a master can write to that port
      .MASTER3_WRITE_SLAVE6  ( MASTER3_WRITE_SLAVE6  ),   // bit for slave indicating if a master can write to that port
      .MASTER3_WRITE_SLAVE7  ( MASTER3_WRITE_SLAVE7  ),   // bit for slave indicating if a master can write to that port  
      .MASTER4_WRITE_SLAVE0  ( MASTER4_WRITE_SLAVE0  ),   // bit for slave indicating if a master can write to that port
      .MASTER4_WRITE_SLAVE1  ( MASTER4_WRITE_SLAVE1  ),   // bit for slave indicating if a master can write to that port
      .MASTER4_WRITE_SLAVE2  ( MASTER4_WRITE_SLAVE2  ),   // bit for slave indicating if a master can write to that port
      .MASTER4_WRITE_SLAVE3  ( MASTER4_WRITE_SLAVE3  ),   // bit for slave indicating if a master can write to that port
      .MASTER4_WRITE_SLAVE4  ( MASTER4_WRITE_SLAVE4  ),   // bit for slave indicating if a master can write to that port
      .MASTER4_WRITE_SLAVE5  ( MASTER4_WRITE_SLAVE5  ),   // bit for slave indicating if a master can write to that port
      .MASTER4_WRITE_SLAVE6  ( MASTER4_WRITE_SLAVE6  ),   // bit for slave indicating if a master can write to that port
      .MASTER4_WRITE_SLAVE7  ( MASTER4_WRITE_SLAVE7  ),   // bit for slave indicating if a master can write to that port  
      .MASTER5_WRITE_SLAVE0  ( MASTER5_WRITE_SLAVE0  ),   // bit for slave indicating if a master can write to that port
      .MASTER5_WRITE_SLAVE1  ( MASTER5_WRITE_SLAVE1  ),   // bit for slave indicating if a master can write to that port
      .MASTER5_WRITE_SLAVE2  ( MASTER5_WRITE_SLAVE2  ),   // bit for slave indicating if a master can write to that port
      .MASTER5_WRITE_SLAVE3  ( MASTER5_WRITE_SLAVE3  ),   // bit for slave indicating if a master can write to that port
      .MASTER5_WRITE_SLAVE4  ( MASTER5_WRITE_SLAVE4  ),   // bit for slave indicating if a master can write to that port
      .MASTER5_WRITE_SLAVE5  ( MASTER5_WRITE_SLAVE5  ),   // bit for slave indicating if a master can write to that port
      .MASTER5_WRITE_SLAVE6  ( MASTER5_WRITE_SLAVE6  ),   // bit for slave indicating if a master can write to that port
      .MASTER5_WRITE_SLAVE7  ( MASTER5_WRITE_SLAVE7  ),   // bit for slave indicating if a master can write to that port  
      .MASTER6_WRITE_SLAVE0  ( MASTER6_WRITE_SLAVE0  ),   // bit for slave indicating if a master can write to that port
      .MASTER6_WRITE_SLAVE1  ( MASTER6_WRITE_SLAVE1  ),   // bit for slave indicating if a master can write to that port
      .MASTER6_WRITE_SLAVE2  ( MASTER6_WRITE_SLAVE2  ),   // bit for slave indicating if a master can write to that port
      .MASTER6_WRITE_SLAVE3  ( MASTER6_WRITE_SLAVE3  ),   // bit for slave indicating if a master can write to that port
      .MASTER6_WRITE_SLAVE4  ( MASTER6_WRITE_SLAVE4  ),   // bit for slave indicating if a master can write to that port
      .MASTER6_WRITE_SLAVE5  ( MASTER6_WRITE_SLAVE5  ),   // bit for slave indicating if a master can write to that port
      .MASTER6_WRITE_SLAVE6  ( MASTER6_WRITE_SLAVE6  ),   // bit for slave indicating if a master can write to that port
      .MASTER6_WRITE_SLAVE7  ( MASTER6_WRITE_SLAVE7  ),   // bit for slave indicating if a master can write to that port
      .MASTER7_WRITE_SLAVE0  ( MASTER7_WRITE_SLAVE0  ),   // bit for slave indicating if a master can write to that port
      .MASTER7_WRITE_SLAVE1  ( MASTER7_WRITE_SLAVE1  ),   // bit for slave indicating if a master can write to that port
      .MASTER7_WRITE_SLAVE2  ( MASTER7_WRITE_SLAVE2  ),   // bit for slave indicating if a master can write to that port
      .MASTER7_WRITE_SLAVE3  ( MASTER7_WRITE_SLAVE3  ),   // bit for slave indicating if a master can write to that port
      .MASTER7_WRITE_SLAVE4  ( MASTER7_WRITE_SLAVE4  ),   // bit for slave indicating if a master can write to that port
      .MASTER7_WRITE_SLAVE5  ( MASTER7_WRITE_SLAVE5  ),   // bit for slave indicating if a master can write to that port
      .MASTER7_WRITE_SLAVE6  ( MASTER7_WRITE_SLAVE6  ),   // bit for slave indicating if a master can write to that port
      .MASTER7_WRITE_SLAVE7  ( MASTER7_WRITE_SLAVE7  ),   // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE0  ( MASTER0_READ_SLAVE0  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE1  ( MASTER0_READ_SLAVE1  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE2  ( MASTER0_READ_SLAVE2  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE3  ( MASTER0_READ_SLAVE3  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE4  ( MASTER0_READ_SLAVE4  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE5  ( MASTER0_READ_SLAVE5  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE6  ( MASTER0_READ_SLAVE6  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE7  ( MASTER0_READ_SLAVE7  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE8  ( MASTER0_READ_SLAVE8  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE9  ( MASTER0_READ_SLAVE9  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE10  ( MASTER0_READ_SLAVE10  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE11  ( MASTER0_READ_SLAVE11  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE12  ( MASTER0_READ_SLAVE12  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE13  ( MASTER0_READ_SLAVE13  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE14  ( MASTER0_READ_SLAVE14  ),  // bit for slave indicating if a master can write to that port
      .MASTER0_READ_SLAVE15  ( MASTER0_READ_SLAVE15  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE0  ( MASTER1_READ_SLAVE0  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE1  ( MASTER1_READ_SLAVE1  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE2  ( MASTER1_READ_SLAVE2  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE3  ( MASTER1_READ_SLAVE3  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE4  ( MASTER1_READ_SLAVE4  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE5  ( MASTER1_READ_SLAVE5  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE6  ( MASTER1_READ_SLAVE6  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE7  ( MASTER1_READ_SLAVE7  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE8  ( MASTER1_READ_SLAVE8  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE9  ( MASTER1_READ_SLAVE9  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE10  ( MASTER1_READ_SLAVE10  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE11  ( MASTER1_READ_SLAVE11  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE12  ( MASTER1_READ_SLAVE12  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE13  ( MASTER1_READ_SLAVE13  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE14  ( MASTER1_READ_SLAVE14  ),  // bit for slave indicating if a master can write to that port
      .MASTER1_READ_SLAVE15  ( MASTER1_READ_SLAVE15  ),  // bit for slave indicating if a master can write to that port
      .MASTER2_READ_SLAVE0  ( MASTER2_READ_SLAVE0  ),  // bit for slave indicating if a master can write to that port
      .MASTER2_READ_SLAVE1  ( MASTER2_READ_SLAVE1  ),  // bit for slave indicating if a master can write to that port
      .MASTER2_READ_SLAVE2  ( MASTER2_READ_SLAVE2  ),  // bit for slave indicating if a master can write to that port
      .MASTER2_READ_SLAVE3  ( MASTER2_READ_SLAVE3  ),  // bit for slave indicating if a master can write to that port
      .MASTER2_READ_SLAVE4  ( MASTER2_READ_SLAVE4  ),  // bit for slave indicating if a master can write to that port
      .MASTER2_READ_SLAVE5  ( MASTER2_READ_SLAVE5  ),  // bit for slave indicating if a master can write to that port
      .MASTER2_READ_SLAVE6  ( MASTER2_READ_SLAVE6  ),  // bit for slave indicating if a master can write to that port
      .MASTER2_READ_SLAVE7  ( MASTER2_READ_SLAVE7  ),  // bit for slave indicating if a master can write to that port  
      .MASTER3_READ_SLAVE0  ( MASTER3_READ_SLAVE0  ),  // bit for slave indicating if a master can write to that port
      .MASTER3_READ_SLAVE1  ( MASTER3_READ_SLAVE1  ),  // bit for slave indicating if a master can write to that port
      .MASTER3_READ_SLAVE2  ( MASTER3_READ_SLAVE2  ),  // bit for slave indicating if a master can write to that port
      .MASTER3_READ_SLAVE3  ( MASTER3_READ_SLAVE3  ),  // bit for slave indicating if a master can write to that port
      .MASTER3_READ_SLAVE4  ( MASTER3_READ_SLAVE4  ),  // bit for slave indicating if a master can write to that port
      .MASTER3_READ_SLAVE5  ( MASTER3_READ_SLAVE5  ),  // bit for slave indicating if a master can write to that port
      .MASTER3_READ_SLAVE6  ( MASTER3_READ_SLAVE6  ),  // bit for slave indicating if a master can write to that port
      .MASTER3_READ_SLAVE7  ( MASTER3_READ_SLAVE7  ),  // bit for slave indicating if a master can write to that port  
      .MASTER4_READ_SLAVE0  ( MASTER4_READ_SLAVE0  ),  // bit for slave indicating if a master can write to that port
      .MASTER4_READ_SLAVE1  ( MASTER4_READ_SLAVE1  ),  // bit for slave indicating if a master can write to that port
      .MASTER4_READ_SLAVE2  ( MASTER4_READ_SLAVE2  ),  // bit for slave indicating if a master can write to that port
      .MASTER4_READ_SLAVE3  ( MASTER4_READ_SLAVE3  ),  // bit for slave indicating if a master can write to that port
      .MASTER4_READ_SLAVE4  ( MASTER4_READ_SLAVE4  ),  // bit for slave indicating if a master can write to that port
      .MASTER4_READ_SLAVE5  ( MASTER4_READ_SLAVE5  ),  // bit for slave indicating if a master can write to that port
      .MASTER4_READ_SLAVE6  ( MASTER4_READ_SLAVE6  ),  // bit for slave indicating if a master can write to that port
      .MASTER4_READ_SLAVE7  ( MASTER4_READ_SLAVE7  ),  // bit for slave indicating if a master can write to that port  
      .MASTER5_READ_SLAVE0  ( MASTER5_READ_SLAVE0  ),  // bit for slave indicating if a master can write to that port
      .MASTER5_READ_SLAVE1  ( MASTER5_READ_SLAVE1  ),  // bit for slave indicating if a master can write to that port
      .MASTER5_READ_SLAVE2  ( MASTER5_READ_SLAVE2  ),  // bit for slave indicating if a master can write to that port
      .MASTER5_READ_SLAVE3  ( MASTER5_READ_SLAVE3  ),  // bit for slave indicating if a master can write to that port
      .MASTER5_READ_SLAVE4  ( MASTER5_READ_SLAVE4  ),  // bit for slave indicating if a master can write to that port
      .MASTER5_READ_SLAVE5  ( MASTER5_READ_SLAVE5  ),  // bit for slave indicating if a master can write to that port
      .MASTER5_READ_SLAVE6  ( MASTER5_READ_SLAVE6  ),  // bit for slave indicating if a master can write to that port
      .MASTER5_READ_SLAVE7  ( MASTER5_READ_SLAVE7  ),  // bit for slave indicating if a master can write to that port  
      .MASTER6_READ_SLAVE0  ( MASTER6_READ_SLAVE0  ),  // bit for slave indicating if a master can write to that port
      .MASTER6_READ_SLAVE1  ( MASTER6_READ_SLAVE1  ),  // bit for slave indicating if a master can write to that port
      .MASTER6_READ_SLAVE2  ( MASTER6_READ_SLAVE2  ),  // bit for slave indicating if a master can write to that port
      .MASTER6_READ_SLAVE3  ( MASTER6_READ_SLAVE3  ),  // bit for slave indicating if a master can write to that port
      .MASTER6_READ_SLAVE4  ( MASTER6_READ_SLAVE4  ),  // bit for slave indicating if a master can write to that port
      .MASTER6_READ_SLAVE5  ( MASTER6_READ_SLAVE5  ),  // bit for slave indicating if a master can write to that port
      .MASTER6_READ_SLAVE6  ( MASTER6_READ_SLAVE6  ),  // bit for slave indicating if a master can write to that port
      .MASTER6_READ_SLAVE7  ( MASTER6_READ_SLAVE7  ),  // bit for slave indicating if a master can write to that port
      .MASTER7_READ_SLAVE0  ( MASTER7_READ_SLAVE0  ),  // bit for slave indicating if a master can write to that port
      .MASTER7_READ_SLAVE1  ( MASTER7_READ_SLAVE1  ),  // bit for slave indicating if a master can write to that port
      .MASTER7_READ_SLAVE2  ( MASTER7_READ_SLAVE2  ),  // bit for slave indicating if a master can write to that port
      .MASTER7_READ_SLAVE3  ( MASTER7_READ_SLAVE3  ),  // bit for slave indicating if a master can write to that port
      .MASTER7_READ_SLAVE4  ( MASTER7_READ_SLAVE4  ),  // bit for slave indicating if a master can write to that port
      .MASTER7_READ_SLAVE5  ( MASTER7_READ_SLAVE5  ),  // bit for slave indicating if a master can write to that port
      .MASTER7_READ_SLAVE6  ( MASTER7_READ_SLAVE6  ),  // bit for slave indicating if a master can write to that port
      .MASTER7_READ_SLAVE7  ( MASTER7_READ_SLAVE7  ),  // bit for slave indicating if a master can write to that port

      .RD_ARB_EN     ( RD_ARB_EN  ),      // select arb or ordered rdata

      //====================================================================
      // Port Protocol Convertor // parameters
      //====================================================================
      .MASTER0_DATA_WIDTH ( MASTER0_DATA_WIDTH ),      // Defines data width of Master0
      .MASTER1_DATA_WIDTH ( MASTER1_DATA_WIDTH ),      // Defines data width of Master1
      .MASTER2_DATA_WIDTH ( MASTER2_DATA_WIDTH ),      // Defines data width of Master2
      .MASTER3_DATA_WIDTH ( MASTER3_DATA_WIDTH ),      // Defines data width of Master3
      .MASTER4_DATA_WIDTH ( MASTER4_DATA_WIDTH ),      // Defines data width of Master4
      .MASTER5_DATA_WIDTH ( MASTER5_DATA_WIDTH ),      // Defines data width of Master5
      .MASTER6_DATA_WIDTH ( MASTER6_DATA_WIDTH ),      // Defines data width of Master6
      .MASTER7_DATA_WIDTH ( MASTER7_DATA_WIDTH ),      // Defines data width of Master7
 
	  .SLAVE0_DATA_WIDTH ( SLAVE0_DATA_WIDTH ),      // Defines data width of Slave0
      .SLAVE1_DATA_WIDTH ( SLAVE1_DATA_WIDTH ),      // Defines data width of Slave1
      .SLAVE2_DATA_WIDTH ( SLAVE2_DATA_WIDTH ),      // Defines data width of Slave2
      .SLAVE3_DATA_WIDTH ( SLAVE3_DATA_WIDTH ),      // Defines data width of Slave3
      .SLAVE4_DATA_WIDTH ( SLAVE4_DATA_WIDTH ),      // Defines data width of Slave4
      .SLAVE5_DATA_WIDTH ( SLAVE5_DATA_WIDTH ),      // Defines data width of Slave5
      .SLAVE6_DATA_WIDTH ( SLAVE6_DATA_WIDTH ),      // Defines data width of Slave6
      .SLAVE7_DATA_WIDTH ( SLAVE7_DATA_WIDTH ),      // Defines data width of Slave7
      .SLAVE8_DATA_WIDTH ( SLAVE8_DATA_WIDTH ),      // Defines data width of Slave8
      .SLAVE9_DATA_WIDTH ( SLAVE9_DATA_WIDTH ),      // Defines data width of Slave9
      .SLAVE10_DATA_WIDTH ( SLAVE10_DATA_WIDTH ),      // Defines data width of Slave10
      .SLAVE11_DATA_WIDTH ( SLAVE11_DATA_WIDTH ),      // Defines data width of Slave11
      .SLAVE12_DATA_WIDTH ( SLAVE12_DATA_WIDTH ),      // Defines data width of Slave12
      .SLAVE13_DATA_WIDTH ( SLAVE13_DATA_WIDTH ),      // Defines data width of Slave13
      .SLAVE14_DATA_WIDTH ( SLAVE14_DATA_WIDTH ),      // Defines data width of Slave14
      .SLAVE15_DATA_WIDTH ( SLAVE15_DATA_WIDTH ),      // Defines data width of Slave15
	  
      .MASTER0_TYPE  ( MASTER0_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .MASTER1_TYPE  ( MASTER1_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .MASTER2_TYPE  ( MASTER2_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .MASTER3_TYPE  ( MASTER3_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .MASTER4_TYPE  ( MASTER4_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .MASTER5_TYPE  ( MASTER5_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .MASTER6_TYPE  ( MASTER6_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .MASTER7_TYPE  ( MASTER7_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE0_TYPE  ( SLAVE0_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE1_TYPE  ( SLAVE1_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE2_TYPE  ( SLAVE2_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE3_TYPE  ( SLAVE3_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE4_TYPE  ( SLAVE4_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE5_TYPE  ( SLAVE5_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE6_TYPE  ( SLAVE6_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE7_TYPE  ( SLAVE7_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE8_TYPE  ( SLAVE8_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE9_TYPE  ( SLAVE9_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE10_TYPE  ( SLAVE10_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE11_TYPE  ( SLAVE11_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE12_TYPE  ( SLAVE12_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE13_TYPE  ( SLAVE13_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE14_TYPE  ( SLAVE14_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
      .SLAVE15_TYPE  ( SLAVE15_TYPE   ),    // Valid Values - 00 = AXI4, 01=AXI4-Lite, 11 = AXI3
	  
      .MASTER0_CLOCK_DOMAIN_CROSSING  ( MASTER0_CLOCK_DOMAIN_CROSSING   ),    
      .MASTER1_CLOCK_DOMAIN_CROSSING  ( MASTER1_CLOCK_DOMAIN_CROSSING   ),    
      .MASTER2_CLOCK_DOMAIN_CROSSING  ( MASTER2_CLOCK_DOMAIN_CROSSING   ),    
      .MASTER3_CLOCK_DOMAIN_CROSSING  ( MASTER3_CLOCK_DOMAIN_CROSSING   ),    
      .MASTER4_CLOCK_DOMAIN_CROSSING  ( MASTER4_CLOCK_DOMAIN_CROSSING   ),    
      .MASTER5_CLOCK_DOMAIN_CROSSING  ( MASTER5_CLOCK_DOMAIN_CROSSING   ),    
      .MASTER6_CLOCK_DOMAIN_CROSSING  ( MASTER6_CLOCK_DOMAIN_CROSSING   ),    
      .MASTER7_CLOCK_DOMAIN_CROSSING  ( MASTER7_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE0_CLOCK_DOMAIN_CROSSING  ( SLAVE0_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE1_CLOCK_DOMAIN_CROSSING  ( SLAVE1_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE2_CLOCK_DOMAIN_CROSSING  ( SLAVE2_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE3_CLOCK_DOMAIN_CROSSING  ( SLAVE3_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE4_CLOCK_DOMAIN_CROSSING  ( SLAVE4_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE5_CLOCK_DOMAIN_CROSSING  ( SLAVE5_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE6_CLOCK_DOMAIN_CROSSING  ( SLAVE6_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE7_CLOCK_DOMAIN_CROSSING  ( SLAVE7_CLOCK_DOMAIN_CROSSING   ),
      .SLAVE8_CLOCK_DOMAIN_CROSSING  ( SLAVE8_CLOCK_DOMAIN_CROSSING   ),
      .SLAVE9_CLOCK_DOMAIN_CROSSING  ( SLAVE9_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE10_CLOCK_DOMAIN_CROSSING  ( SLAVE10_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE11_CLOCK_DOMAIN_CROSSING  ( SLAVE11_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE12_CLOCK_DOMAIN_CROSSING  ( SLAVE12_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE13_CLOCK_DOMAIN_CROSSING  ( SLAVE13_CLOCK_DOMAIN_CROSSING   ),    
      .SLAVE14_CLOCK_DOMAIN_CROSSING  ( SLAVE14_CLOCK_DOMAIN_CROSSING   ),
      .SLAVE15_CLOCK_DOMAIN_CROSSING  ( SLAVE15_CLOCK_DOMAIN_CROSSING   ),
	  
      .SLV_AXI4PRT_ADDRDEPTH ( SLV_AXI4PRT_ADDRDEPTH  ),    // Number transations width - 1 => 2 transations, 2 => 4 transations, etc.
      .SLV_AXI4PRT_DATADEPTH ( SLV_AXI4PRT_DATADEPTH  ),    // Number transations width - 1 => 2 transations, 2 => 4 transations, etc.

      //====================================================================
      // Register Slice // parameters
      //====================================================================
      .MASTER0_CHAN_RS   ( MASTER0_CHAN_RS   ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .MASTER1_CHAN_RS   ( MASTER1_CHAN_RS   ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .MASTER2_CHAN_RS   ( MASTER2_CHAN_RS   ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .MASTER3_CHAN_RS   ( MASTER3_CHAN_RS   ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .MASTER4_CHAN_RS   ( MASTER4_CHAN_RS   ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .MASTER5_CHAN_RS   ( MASTER5_CHAN_RS   ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .MASTER6_CHAN_RS   ( MASTER6_CHAN_RS   ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .MASTER7_CHAN_RS   ( MASTER7_CHAN_RS   ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted

      .SLAVE0_CHAN_RS   ( SLAVE0_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE1_CHAN_RS   ( SLAVE1_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE2_CHAN_RS   ( SLAVE2_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE3_CHAN_RS   ( SLAVE3_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE4_CHAN_RS   ( SLAVE4_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE5_CHAN_RS   ( SLAVE5_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE6_CHAN_RS   ( SLAVE6_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE7_CHAN_RS   ( SLAVE7_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE8_CHAN_RS   ( SLAVE8_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE9_CHAN_RS   ( SLAVE9_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE10_CHAN_RS   ( SLAVE10_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE11_CHAN_RS   ( SLAVE11_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE12_CHAN_RS   ( SLAVE12_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE13_CHAN_RS   ( SLAVE13_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE14_CHAN_RS   ( SLAVE14_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE15_CHAN_RS   ( SLAVE15_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE16_CHAN_RS   ( SLAVE16_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE17_CHAN_RS   ( SLAVE17_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE18_CHAN_RS   ( SLAVE18_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE19_CHAN_RS   ( SLAVE19_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE20_CHAN_RS   ( SLAVE20_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE21_CHAN_RS   ( SLAVE21_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE22_CHAN_RS   ( SLAVE22_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE23_CHAN_RS   ( SLAVE23_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE24_CHAN_RS   ( SLAVE24_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE25_CHAN_RS   ( SLAVE25_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE26_CHAN_RS   ( SLAVE26_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE27_CHAN_RS   ( SLAVE27_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE28_CHAN_RS   ( SLAVE28_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE29_CHAN_RS   ( SLAVE29_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE30_CHAN_RS   ( SLAVE30_CHAN_RS     ),  // 0 - no CHAN register slice, 1 - CHAN register slice inserted
      .SLAVE31_CHAN_RS   ( SLAVE31_CHAN_RS     ),   // 0 - no CHAN register slice, 1 - CHAN register slice inserted
	  
	  .MASTER0_READ_INTERLEAVE   (1'b0),
	  .MASTER1_READ_INTERLEAVE   (1'b0),
	  .MASTER2_READ_INTERLEAVE   (1'b0),
	  .MASTER3_READ_INTERLEAVE   (1'b0),
	  .MASTER4_READ_INTERLEAVE   (1'b0),
	  .MASTER5_READ_INTERLEAVE   (1'b0),
	  .MASTER6_READ_INTERLEAVE   (1'b0),
	  .MASTER7_READ_INTERLEAVE   (1'b0),
	  .MASTER8_READ_INTERLEAVE   (1'b0),
	  .MASTER9_READ_INTERLEAVE   (1'b0),
	  .MASTER10_READ_INTERLEAVE   (1'b0),
	  .MASTER11_READ_INTERLEAVE   (1'b0),
	  .MASTER12_READ_INTERLEAVE   (1'b0),
	  .MASTER13_READ_INTERLEAVE   (1'b0),
	  .MASTER14_READ_INTERLEAVE   (1'b0),
	  .MASTER15_READ_INTERLEAVE   (1'b0),
	  
	  
      .SLAVE0_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE1_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE2_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE3_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE4_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE5_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE6_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE7_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE8_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE9_READ_INTERLEAVE    ( 1'b0    ),  
      .SLAVE10_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE11_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE12_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE13_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE14_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE15_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE16_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE17_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE18_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE19_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE20_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE21_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE22_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE23_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE24_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE25_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE26_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE27_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE28_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE29_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE30_READ_INTERLEAVE   ( 1'b0     ), 
      .SLAVE31_READ_INTERLEAVE   ( 1'b0     )


    )
  uut (

  // Global Signals
  .ACLK      ( ACLK ),
  .M_CLK0      ( M_CLK0 ),
  .M_CLK1      ( M_CLK1 ),
  .M_CLK2      ( M_CLK2 ),
  .M_CLK3      ( M_CLK3 ),
  .M_CLK4      ( M_CLK4 ),
  .M_CLK5      ( M_CLK5 ),
  .M_CLK6      ( M_CLK6 ),
  .M_CLK7      ( M_CLK7 ),

  .S_CLK0       ( S_CLK0  ),
  .S_CLK1       ( S_CLK1  ),
  .S_CLK2       ( S_CLK2  ),
  .S_CLK3       ( S_CLK3  ),
  .S_CLK4       ( S_CLK4  ),
  .S_CLK5       ( S_CLK5  ),
  .S_CLK6       ( S_CLK6  ),
  .S_CLK7       ( S_CLK7  ),
  .S_CLK8       ( S_CLK8  ),
  .S_CLK9       ( S_CLK9  ),
  .S_CLK10      ( S_CLK10 ),
  .S_CLK11      ( S_CLK11 ),
  .S_CLK12      ( S_CLK12 ),
  .S_CLK13      ( S_CLK13 ),
  .S_CLK14      ( S_CLK14 ),
  .S_CLK15      ( S_CLK15 ),
  .S_CLK16      ( S_CLK16 ),
  .S_CLK17      ( S_CLK17 ),
  .S_CLK18      ( S_CLK18 ),
  .S_CLK19      ( S_CLK19 ),
  .S_CLK20      ( S_CLK20 ),
  .S_CLK21      ( S_CLK21 ),
  .S_CLK22      ( S_CLK22 ),
  .S_CLK23      ( S_CLK23 ),
  .S_CLK24      ( S_CLK24 ),
  .S_CLK25      ( S_CLK25 ),
  .S_CLK26      ( S_CLK26 ),
  .S_CLK27      ( S_CLK27 ),
  .S_CLK28      ( S_CLK28 ),
  .S_CLK29      ( S_CLK29 ),
  .S_CLK30      ( S_CLK30 ),
  .S_CLK31      ( S_CLK31 ),

  .ARESETN    ( ARESETN ),

  //======================  Master Write Address Ports  ======================================================//
  .MASTER0_AWID          ( MASTER0_AWID ),
  .MASTER0_AWADDR        ( MASTER0_AWADDR ),
  .MASTER0_AWLEN        ( MASTER0_AWLEN ),
  .MASTER0_AWSIZE        ( MASTER0_AWSIZE ),
  .MASTER0_AWBURST      ( MASTER0_AWBURST ),
  .MASTER0_AWLOCK        ( MASTER0_AWLOCK ),
  .MASTER0_AWCACHE      ( MASTER0_AWCACHE ),
  .MASTER0_AWPROT        ( MASTER0_AWPROT ),
  .MASTER0_AWREGION      ( MASTER0_AWREGION ),
  .MASTER0_AWQOS        ( MASTER0_AWQOS ),        // not used internally
  .MASTER0_AWUSER        ( MASTER0_AWUSER ),        // not used internally
  .MASTER0_AWVALID      ( MASTER0_AWVALID ),
  .MASTER0_AWREADY      ( MASTER0_AWREADY ),

  .MASTER0_HADDR        ( MASTER0_HADDR ),
  .MASTER0_HSEL          ( MASTER0_HSEL ),
  .MASTER0_HBURST        ( MASTER0_HBURST ),
  .MASTER0_HMASTLOCK    ( MASTER0_HMASTLOCK ),
  .MASTER0_HPROT        ( MASTER0_HPROT ),
  .MASTER0_HSIZE        ( MASTER0_HSIZE ),
  .MASTER0_HNONSEC      ( MASTER0_HNONSEC ),
  .MASTER0_HTRANS        ( MASTER0_HTRANS ),
  .MASTER0_HWDATA        ( MASTER0_HWDATA ),
  .MASTER0_HRDATA        ( MASTER0_HRDATA ),
  .MASTER0_HWRITE        ( MASTER0_HWRITE ),
  .MASTER0_HREADY        ( MASTER0_HREADY ),
  .MASTER0_HRESP        ( MASTER0_HRESP ),

  .MASTER1_AWID          ( MASTER1_AWID ),
  .MASTER1_AWADDR        ( MASTER1_AWADDR ),
  .MASTER1_AWLEN        ( MASTER1_AWLEN ),
  .MASTER1_AWSIZE        ( MASTER1_AWSIZE ),
  .MASTER1_AWBURST      ( MASTER1_AWBURST ),
  .MASTER1_AWLOCK        ( MASTER1_AWLOCK ),
  .MASTER1_AWCACHE      ( MASTER1_AWCACHE ),
  .MASTER1_AWPROT        ( MASTER1_AWPROT ),
  .MASTER1_AWREGION      ( MASTER1_AWREGION ),
  .MASTER1_AWQOS        ( MASTER1_AWQOS ),        // not used internally
  .MASTER1_AWUSER        ( MASTER1_AWUSER ),        // not used internally
  .MASTER1_AWVALID      ( MASTER1_AWVALID ),
  .MASTER1_AWREADY      ( MASTER1_AWREADY ),

  .MASTER1_HADDR        ( MASTER1_HADDR ),
  .MASTER1_HSEL          ( MASTER1_HSEL ),
  .MASTER1_HBURST        ( MASTER1_HBURST ),
  .MASTER1_HMASTLOCK    ( MASTER1_HMASTLOCK ),
  .MASTER1_HPROT        ( MASTER1_HPROT ),
  .MASTER1_HSIZE        ( MASTER1_HSIZE ),
  .MASTER1_HNONSEC      ( MASTER1_HNONSEC ),
  .MASTER1_HTRANS        ( MASTER1_HTRANS ),
  .MASTER1_HWDATA        ( MASTER1_HWDATA ),
  .MASTER1_HRDATA        ( MASTER1_HRDATA ),
  .MASTER1_HWRITE        ( MASTER1_HWRITE ),
  .MASTER1_HREADY        ( MASTER1_HREADY ),
  .MASTER1_HRESP        ( MASTER1_HRESP ),


  .MASTER2_AWID          ( MASTER2_AWID ),
  .MASTER2_AWADDR        ( MASTER2_AWADDR ),
  .MASTER2_AWLEN        ( MASTER2_AWLEN ),
  .MASTER2_AWSIZE        ( MASTER2_AWSIZE ),
  .MASTER2_AWBURST      ( MASTER2_AWBURST ),
  .MASTER2_AWLOCK        ( MASTER2_AWLOCK ),
  .MASTER2_AWCACHE      ( MASTER2_AWCACHE ),
  .MASTER2_AWPROT        ( MASTER2_AWPROT ),
  .MASTER2_AWREGION      ( MASTER2_AWREGION ),
  .MASTER2_AWQOS        ( MASTER2_AWQOS ),        // not used internally
  .MASTER2_AWUSER        ( MASTER2_AWUSER ),        // not used internally
  .MASTER2_AWVALID      ( MASTER2_AWVALID ),
  .MASTER2_AWREADY      ( MASTER2_AWREADY ),

  .MASTER2_HADDR        ( MASTER2_HADDR ),
  .MASTER2_HSEL          ( MASTER2_HSEL ),
  .MASTER2_HBURST        ( MASTER2_HBURST ),
  .MASTER2_HMASTLOCK    ( MASTER2_HMASTLOCK ),
  .MASTER2_HPROT        ( MASTER2_HPROT ),
  .MASTER2_HSIZE        ( MASTER2_HSIZE ),
  .MASTER2_HNONSEC      ( MASTER2_HNONSEC ),
  .MASTER2_HTRANS        ( MASTER2_HTRANS ),
  .MASTER2_HWDATA        ( MASTER2_HWDATA ),
  .MASTER2_HRDATA        ( MASTER2_HRDATA ),
  .MASTER2_HWRITE        ( MASTER2_HWRITE ),
  .MASTER2_HREADY        ( MASTER2_HREADY ),
  .MASTER2_HRESP        ( MASTER2_HRESP ),


  .MASTER3_AWID          ( MASTER3_AWID ),
  .MASTER3_AWADDR        ( MASTER3_AWADDR ),
  .MASTER3_AWLEN        ( MASTER3_AWLEN ),
  .MASTER3_AWSIZE        ( MASTER3_AWSIZE ),
  .MASTER3_AWBURST      ( MASTER3_AWBURST ),
  .MASTER3_AWLOCK        ( MASTER3_AWLOCK ),
  .MASTER3_AWCACHE      ( MASTER3_AWCACHE ),
  .MASTER3_AWPROT        ( MASTER3_AWPROT ),
  .MASTER3_AWREGION      ( MASTER3_AWREGION ),
  .MASTER3_AWQOS        ( MASTER3_AWQOS ),        // not used internally
  .MASTER3_AWUSER        ( MASTER3_AWUSER ),        // not used internally
  .MASTER3_AWVALID      ( MASTER3_AWVALID ),
  .MASTER3_AWREADY      ( MASTER3_AWREADY ),

  .MASTER3_HADDR        ( MASTER3_HADDR ),
  .MASTER3_HSEL          ( MASTER3_HSEL ),
  .MASTER3_HBURST        ( MASTER3_HBURST ),
  .MASTER3_HMASTLOCK    ( MASTER3_HMASTLOCK ),
  .MASTER3_HPROT        ( MASTER3_HPROT ),
  .MASTER3_HSIZE        ( MASTER3_HSIZE ),
  .MASTER3_HNONSEC      ( MASTER3_HNONSEC ),
  .MASTER3_HTRANS        ( MASTER3_HTRANS ),
  .MASTER3_HWDATA        ( MASTER3_HWDATA ),
  .MASTER3_HRDATA        ( MASTER3_HRDATA ),
  .MASTER3_HWRITE        ( MASTER3_HWRITE ),
  .MASTER3_HREADY        ( MASTER3_HREADY ),
  .MASTER3_HRESP        ( MASTER3_HRESP ),

  .MASTER4_AWID          ( MASTER4_AWID ),
  .MASTER4_AWADDR        ( MASTER4_AWADDR ),
  .MASTER4_AWLEN        ( MASTER4_AWLEN ),
  .MASTER4_AWSIZE        ( MASTER4_AWSIZE ),
  .MASTER4_AWBURST      ( MASTER4_AWBURST ),
  .MASTER4_AWLOCK        ( MASTER4_AWLOCK ),
  .MASTER4_AWCACHE      ( MASTER4_AWCACHE ),
  .MASTER4_AWPROT        ( MASTER4_AWPROT ),
  .MASTER4_AWREGION      ( MASTER4_AWREGION ),
  .MASTER4_AWQOS        ( MASTER4_AWQOS ),        // not used internally
  .MASTER4_AWUSER        ( MASTER4_AWUSER ),        // not used internally
  .MASTER4_AWVALID      ( MASTER4_AWVALID ),
  .MASTER4_AWREADY      ( MASTER4_AWREADY ),

  .MASTER4_HADDR        ( MASTER4_HADDR ),
  .MASTER4_HSEL          ( MASTER4_HSEL ),
  .MASTER4_HBURST        ( MASTER4_HBURST ),
  .MASTER4_HMASTLOCK    ( MASTER4_HMASTLOCK ),
  .MASTER4_HPROT        ( MASTER4_HPROT ),
  .MASTER4_HSIZE        ( MASTER4_HSIZE ),
  .MASTER4_HNONSEC      ( MASTER4_HNONSEC ),
  .MASTER4_HTRANS        ( MASTER4_HTRANS ),
  .MASTER4_HWDATA        ( MASTER4_HWDATA ),
  .MASTER4_HRDATA        ( MASTER4_HRDATA ),
  .MASTER4_HWRITE        ( MASTER4_HWRITE ),
  .MASTER4_HREADY        ( MASTER4_HREADY ),
  .MASTER4_HRESP        ( MASTER4_HRESP ),

  .MASTER5_AWID          ( MASTER5_AWID ),
  .MASTER5_AWADDR        ( MASTER5_AWADDR ),
  .MASTER5_AWLEN        ( MASTER5_AWLEN ),
  .MASTER5_AWSIZE        ( MASTER5_AWSIZE ),
  .MASTER5_AWBURST      ( MASTER5_AWBURST ),
  .MASTER5_AWLOCK        ( MASTER5_AWLOCK ),
  .MASTER5_AWCACHE      ( MASTER5_AWCACHE ),
  .MASTER5_AWPROT        ( MASTER5_AWPROT ),
  .MASTER5_AWREGION      ( MASTER5_AWREGION ),
  .MASTER5_AWQOS        ( MASTER5_AWQOS ),        // not used internally
  .MASTER5_AWUSER        ( MASTER5_AWUSER ),        // not used internally
  .MASTER5_AWVALID      ( MASTER5_AWVALID ),
  .MASTER5_AWREADY      ( MASTER5_AWREADY ),

  .MASTER5_HADDR        ( MASTER5_HADDR ),
  .MASTER5_HSEL          ( MASTER5_HSEL ),
  .MASTER5_HBURST        ( MASTER5_HBURST ),
  .MASTER5_HMASTLOCK    ( MASTER5_HMASTLOCK ),
  .MASTER5_HPROT        ( MASTER5_HPROT ),
  .MASTER5_HSIZE        ( MASTER5_HSIZE ),
  .MASTER5_HNONSEC      ( MASTER5_HNONSEC ),
  .MASTER5_HTRANS        ( MASTER5_HTRANS ),
  .MASTER5_HWDATA        ( MASTER5_HWDATA ),
  .MASTER5_HRDATA        ( MASTER5_HRDATA ),
  .MASTER5_HWRITE        ( MASTER5_HWRITE ),
  .MASTER5_HREADY        ( MASTER5_HREADY ),
  .MASTER5_HRESP        ( MASTER5_HRESP ),

  .MASTER6_AWID          ( MASTER6_AWID ),
  .MASTER6_AWADDR        ( MASTER6_AWADDR ),
  .MASTER6_AWLEN        ( MASTER6_AWLEN ),
  .MASTER6_AWSIZE        ( MASTER6_AWSIZE ),
  .MASTER6_AWBURST      ( MASTER6_AWBURST ),
  .MASTER6_AWLOCK        ( MASTER6_AWLOCK ),
  .MASTER6_AWCACHE      ( MASTER6_AWCACHE ),
  .MASTER6_AWPROT        ( MASTER6_AWPROT ),
  .MASTER6_AWREGION      ( MASTER6_AWREGION ),
  .MASTER6_AWQOS        ( MASTER6_AWQOS ),        // not used internally
  .MASTER6_AWUSER        ( MASTER6_AWUSER ),        // not used internally
  .MASTER6_AWVALID      ( MASTER6_AWVALID ),
  .MASTER6_AWREADY      ( MASTER6_AWREADY ),

  .MASTER6_HADDR        ( MASTER6_HADDR ),
  .MASTER6_HSEL          ( MASTER6_HSEL ),
  .MASTER6_HBURST        ( MASTER6_HBURST ),
  .MASTER6_HMASTLOCK    ( MASTER6_HMASTLOCK ),
  .MASTER6_HPROT        ( MASTER6_HPROT ),
  .MASTER6_HSIZE        ( MASTER6_HSIZE ),
  .MASTER6_HNONSEC      ( MASTER6_HNONSEC ),
  .MASTER6_HTRANS        ( MASTER6_HTRANS ),
  .MASTER6_HWDATA        ( MASTER6_HWDATA ),
  .MASTER6_HRDATA        ( MASTER6_HRDATA ),
  .MASTER6_HWRITE        ( MASTER6_HWRITE ),
  .MASTER6_HREADY        ( MASTER6_HREADY ),
  .MASTER6_HRESP        ( MASTER6_HRESP ),

  .MASTER7_AWID          ( MASTER7_AWID ),
  .MASTER7_AWADDR        ( MASTER7_AWADDR ),
  .MASTER7_AWLEN        ( MASTER7_AWLEN ),
  .MASTER7_AWSIZE        ( MASTER7_AWSIZE ),
  .MASTER7_AWBURST      ( MASTER7_AWBURST ),
  .MASTER7_AWLOCK        ( MASTER7_AWLOCK ),
  .MASTER7_AWCACHE      ( MASTER7_AWCACHE ),
  .MASTER7_AWPROT        ( MASTER7_AWPROT ),
  .MASTER7_AWREGION      ( MASTER7_AWREGION ),
  .MASTER7_AWQOS        ( MASTER7_AWQOS ),        // not used internally
  .MASTER7_AWUSER        ( MASTER7_AWUSER ),        // not used internally
  .MASTER7_AWVALID      ( MASTER7_AWVALID ),
  .MASTER7_AWREADY      ( MASTER7_AWREADY ),

  .MASTER7_HADDR        ( MASTER7_HADDR ),
  .MASTER7_HSEL          ( MASTER7_HSEL ),
  .MASTER7_HBURST        ( MASTER7_HBURST ),
  .MASTER7_HMASTLOCK    ( MASTER7_HMASTLOCK ),
  .MASTER7_HPROT        ( MASTER7_HPROT ),
  .MASTER7_HSIZE        ( MASTER7_HSIZE ),
  .MASTER7_HNONSEC      ( MASTER7_HNONSEC ),
  .MASTER7_HTRANS        ( MASTER7_HTRANS ),
  .MASTER7_HWDATA        ( MASTER7_HWDATA ),
  .MASTER7_HRDATA        ( MASTER7_HRDATA ),
  .MASTER7_HWRITE        ( MASTER7_HWRITE ),
  .MASTER7_HREADY        ( MASTER7_HREADY ),
  .MASTER7_HRESP        ( MASTER7_HRESP ),

  //======================  Master Write Data Ports  =========================================================//
  .MASTER0_WDATA      ( MASTER0_WDATA ),
  .MASTER0_WSTRB      ( MASTER0_WSTRB ),
  .MASTER0_WLAST      ( MASTER0_WLAST ),
  .MASTER0_WUSER      ( MASTER0_WUSER ),
  .MASTER0_WVALID      ( MASTER0_WVALID ),
  .MASTER0_WREADY      ( MASTER0_WREADY ),

  .MASTER1_WDATA      ( MASTER1_WDATA ),
  .MASTER1_WSTRB      ( MASTER1_WSTRB ),
  .MASTER1_WLAST      ( MASTER1_WLAST ),
  .MASTER1_WUSER      ( MASTER1_WUSER ),
  .MASTER1_WVALID      ( MASTER1_WVALID ),
  .MASTER1_WREADY      ( MASTER1_WREADY ),

  .MASTER2_WDATA      ( MASTER2_WDATA ),
  .MASTER2_WSTRB      ( MASTER2_WSTRB ),
  .MASTER2_WLAST      ( MASTER2_WLAST ),
  .MASTER2_WUSER      ( MASTER2_WUSER ),
  .MASTER2_WVALID      ( MASTER2_WVALID ),
  .MASTER2_WREADY      ( MASTER2_WREADY ),

  .MASTER3_WDATA      ( MASTER3_WDATA ),
  .MASTER3_WSTRB      ( MASTER3_WSTRB ),
  .MASTER3_WLAST      ( MASTER3_WLAST ),
  .MASTER3_WUSER      ( MASTER3_WUSER ),
  .MASTER3_WVALID      ( MASTER3_WVALID ),
  .MASTER3_WREADY      ( MASTER3_WREADY ),

  .MASTER4_WDATA      ( MASTER4_WDATA ),
  .MASTER4_WSTRB      ( MASTER4_WSTRB ),
  .MASTER4_WLAST      ( MASTER4_WLAST ),
  .MASTER4_WUSER      ( MASTER4_WUSER ),
  .MASTER4_WVALID      ( MASTER4_WVALID ),
  .MASTER4_WREADY      ( MASTER4_WREADY ),

  .MASTER5_WDATA      ( MASTER5_WDATA ),
  .MASTER5_WSTRB      ( MASTER5_WSTRB ),
  .MASTER5_WLAST      ( MASTER5_WLAST ),
  .MASTER5_WUSER      ( MASTER5_WUSER ),
  .MASTER5_WVALID      ( MASTER5_WVALID ),
  .MASTER5_WREADY      ( MASTER5_WREADY ),

  .MASTER6_WDATA      ( MASTER6_WDATA ),
  .MASTER6_WSTRB      ( MASTER6_WSTRB ),
  .MASTER6_WLAST      ( MASTER6_WLAST ),
  .MASTER6_WUSER      ( MASTER6_WUSER ),
  .MASTER6_WVALID      ( MASTER6_WVALID ),
  .MASTER6_WREADY      ( MASTER6_WREADY ),

  .MASTER7_WDATA      ( MASTER7_WDATA ),
  .MASTER7_WSTRB      ( MASTER7_WSTRB ),
  .MASTER7_WLAST      ( MASTER7_WLAST ),
  .MASTER7_WUSER      ( MASTER7_WUSER ),
  .MASTER7_WVALID      ( MASTER7_WVALID ),
  .MASTER7_WREADY      ( MASTER7_WREADY ),

  //======================  Master Write Response Ports  =====================================================//
  .MASTER0_BID        ( MASTER0_BID ),
  .MASTER0_BRESP      ( MASTER0_BRESP ),
  .MASTER0_BUSER      ( MASTER0_BUSER ),
  .MASTER0_BVALID      ( MASTER0_BVALID ),
  .MASTER0_BREADY      ( MASTER0_BREADY ),

  .MASTER1_BID        ( MASTER1_BID ),
  .MASTER1_BRESP      ( MASTER1_BRESP ),
  .MASTER1_BUSER      ( MASTER1_BUSER ),
  .MASTER1_BVALID      ( MASTER1_BVALID ),
  .MASTER1_BREADY      ( MASTER1_BREADY ),

  .MASTER2_BID        ( MASTER2_BID ),
  .MASTER2_BRESP      ( MASTER2_BRESP ),
  .MASTER2_BUSER      ( MASTER2_BUSER ),
  .MASTER2_BVALID      ( MASTER2_BVALID ),
  .MASTER2_BREADY      ( MASTER2_BREADY ),

  .MASTER3_BID        ( MASTER3_BID ),
  .MASTER3_BRESP      ( MASTER3_BRESP ),
  .MASTER3_BUSER      ( MASTER3_BUSER ),
  .MASTER3_BVALID      ( MASTER3_BVALID ),
  .MASTER3_BREADY      ( MASTER3_BREADY ),

  .MASTER4_BID        ( MASTER4_BID ),
  .MASTER4_BRESP      ( MASTER4_BRESP ),
  .MASTER4_BUSER      ( MASTER4_BUSER ),
  .MASTER4_BVALID      ( MASTER4_BVALID ),
  .MASTER4_BREADY      ( MASTER4_BREADY ),

  .MASTER5_BID        ( MASTER5_BID ),
  .MASTER5_BRESP      ( MASTER5_BRESP ),
  .MASTER5_BUSER      ( MASTER5_BUSER ),
  .MASTER5_BVALID      ( MASTER5_BVALID ),
  .MASTER5_BREADY      ( MASTER5_BREADY ),

  .MASTER6_BID        ( MASTER6_BID ),
  .MASTER6_BRESP      ( MASTER6_BRESP ),
  .MASTER6_BUSER      ( MASTER6_BUSER ),
  .MASTER6_BVALID      ( MASTER6_BVALID ),
  .MASTER6_BREADY      ( MASTER6_BREADY ),

  .MASTER7_BID        ( MASTER7_BID ),
  .MASTER7_BRESP      ( MASTER7_BRESP ),
  .MASTER7_BUSER      ( MASTER7_BUSER ),
  .MASTER7_BVALID      ( MASTER7_BVALID ),
  .MASTER7_BREADY      ( MASTER7_BREADY ),

  //======================  Master Read Address Ports  =======================================================//

  .MASTER0_ARID        ( MASTER0_ARID ),
  .MASTER0_ARADDR      ( MASTER0_ARADDR ),
  .MASTER0_ARLEN      ( MASTER0_ARLEN ),
  .MASTER0_ARSIZE      ( MASTER0_ARSIZE ),
  .MASTER0_ARBURST    ( MASTER0_ARBURST ),
  .MASTER0_ARLOCK      ( MASTER0_ARLOCK ),
  .MASTER0_ARCACHE    ( MASTER0_ARCACHE ),
  .MASTER0_ARPROT      ( MASTER0_ARPROT ),
  .MASTER0_ARREGION    ( MASTER0_ARREGION ),
  .MASTER0_ARQOS      ( MASTER0_ARQOS ),    // not used
  .MASTER0_ARUSER      ( MASTER0_ARUSER ),
  .MASTER0_ARVALID    ( MASTER0_ARVALID ),
  .MASTER0_ARREADY    ( MASTER0_ARREADY ),

  .MASTER1_ARID        ( MASTER1_ARID ),
  .MASTER1_ARADDR      ( MASTER1_ARADDR ),
  .MASTER1_ARLEN      ( MASTER1_ARLEN ),
  .MASTER1_ARSIZE      ( MASTER1_ARSIZE ),
  .MASTER1_ARBURST    ( MASTER1_ARBURST ),
  .MASTER1_ARLOCK      ( MASTER1_ARLOCK ),
  .MASTER1_ARCACHE    ( MASTER1_ARCACHE ),
  .MASTER1_ARPROT      ( MASTER1_ARPROT ),
  .MASTER1_ARREGION    ( MASTER1_ARREGION ),
  .MASTER1_ARQOS      ( MASTER1_ARQOS ),    // not used
  .MASTER1_ARUSER      ( MASTER1_ARUSER ),
  .MASTER1_ARVALID    ( MASTER1_ARVALID ),
  .MASTER1_ARREADY    ( MASTER1_ARREADY ),

  .MASTER2_ARID        ( MASTER2_ARID ),
  .MASTER2_ARADDR      ( MASTER2_ARADDR ),
  .MASTER2_ARLEN      ( MASTER2_ARLEN ),
  .MASTER2_ARSIZE      ( MASTER2_ARSIZE ),
  .MASTER2_ARBURST    ( MASTER2_ARBURST ),
  .MASTER2_ARLOCK      ( MASTER2_ARLOCK ),
  .MASTER2_ARCACHE    ( MASTER2_ARCACHE ),
  .MASTER2_ARPROT      ( MASTER2_ARPROT ),
  .MASTER2_ARREGION    ( MASTER2_ARREGION ),
  .MASTER2_ARQOS      ( MASTER2_ARQOS ),    // not used
  .MASTER2_ARUSER      ( MASTER2_ARUSER ),
  .MASTER2_ARVALID    ( MASTER2_ARVALID ),
  .MASTER2_ARREADY    ( MASTER2_ARREADY ),

  .MASTER3_ARID        ( MASTER3_ARID ),
  .MASTER3_ARADDR      ( MASTER3_ARADDR ),
  .MASTER3_ARLEN      ( MASTER3_ARLEN ),
  .MASTER3_ARSIZE      ( MASTER3_ARSIZE ),
  .MASTER3_ARBURST    ( MASTER3_ARBURST ),
  .MASTER3_ARLOCK      ( MASTER3_ARLOCK ),
  .MASTER3_ARCACHE    ( MASTER3_ARCACHE ),
  .MASTER3_ARPROT      ( MASTER3_ARPROT ),
  .MASTER3_ARREGION    ( MASTER3_ARREGION ),
  .MASTER3_ARQOS      ( MASTER3_ARQOS ),    // not used
  .MASTER3_ARUSER      ( MASTER3_ARUSER ),
  .MASTER3_ARVALID    ( MASTER3_ARVALID ),
  .MASTER3_ARREADY    ( MASTER3_ARREADY ),

  .MASTER4_ARID        ( MASTER4_ARID ),
  .MASTER4_ARADDR      ( MASTER4_ARADDR ),
  .MASTER4_ARLEN      ( MASTER4_ARLEN ),
  .MASTER4_ARSIZE      ( MASTER4_ARSIZE ),
  .MASTER4_ARBURST    ( MASTER4_ARBURST ),
  .MASTER4_ARLOCK      ( MASTER4_ARLOCK ),
  .MASTER4_ARCACHE    ( MASTER4_ARCACHE ),
  .MASTER4_ARPROT      ( MASTER4_ARPROT ),
  .MASTER4_ARREGION    ( MASTER4_ARREGION ),
  .MASTER4_ARQOS      ( MASTER4_ARQOS ),    // not used
  .MASTER4_ARUSER      ( MASTER4_ARUSER ),
  .MASTER4_ARVALID    ( MASTER4_ARVALID ),
  .MASTER4_ARREADY    ( MASTER4_ARREADY ),

  .MASTER5_ARID        ( MASTER5_ARID ),
  .MASTER5_ARADDR      ( MASTER5_ARADDR ),
  .MASTER5_ARLEN      ( MASTER5_ARLEN ),
  .MASTER5_ARSIZE      ( MASTER5_ARSIZE ),
  .MASTER5_ARBURST    ( MASTER5_ARBURST ),
  .MASTER5_ARLOCK      ( MASTER5_ARLOCK ),
  .MASTER5_ARCACHE    ( MASTER5_ARCACHE ),
  .MASTER5_ARPROT      ( MASTER5_ARPROT ),
  .MASTER5_ARREGION    ( MASTER5_ARREGION ),
  .MASTER5_ARQOS      ( MASTER5_ARQOS ),    // not used
  .MASTER5_ARUSER      ( MASTER5_ARUSER ),
  .MASTER5_ARVALID    ( MASTER5_ARVALID ),
  .MASTER5_ARREADY    ( MASTER5_ARREADY ),

  .MASTER6_ARID        ( MASTER6_ARID ),
  .MASTER6_ARADDR      ( MASTER6_ARADDR ),
  .MASTER6_ARLEN      ( MASTER6_ARLEN ),
  .MASTER6_ARSIZE      ( MASTER6_ARSIZE ),
  .MASTER6_ARBURST    ( MASTER6_ARBURST ),
  .MASTER6_ARLOCK      ( MASTER6_ARLOCK ),
  .MASTER6_ARCACHE    ( MASTER6_ARCACHE ),
  .MASTER6_ARPROT      ( MASTER6_ARPROT ),
  .MASTER6_ARREGION    ( MASTER6_ARREGION ),
  .MASTER6_ARQOS      ( MASTER6_ARQOS ),    // not used
  .MASTER6_ARUSER      ( MASTER6_ARUSER ),
  .MASTER6_ARVALID    ( MASTER6_ARVALID ),
  .MASTER6_ARREADY    ( MASTER6_ARREADY ),

  .MASTER7_ARID        ( MASTER7_ARID ),
  .MASTER7_ARADDR      ( MASTER7_ARADDR ),
  .MASTER7_ARLEN      ( MASTER7_ARLEN ),
  .MASTER7_ARSIZE      ( MASTER7_ARSIZE ),
  .MASTER7_ARBURST    ( MASTER7_ARBURST ),
  .MASTER7_ARLOCK      ( MASTER7_ARLOCK ),
  .MASTER7_ARCACHE    ( MASTER7_ARCACHE ),
  .MASTER7_ARPROT      ( MASTER7_ARPROT ),
  .MASTER7_ARREGION    ( MASTER7_ARREGION ),
  .MASTER7_ARQOS      ( MASTER7_ARQOS ),    // not used
  .MASTER7_ARUSER      ( MASTER7_ARUSER ),
  .MASTER7_ARVALID    ( MASTER7_ARVALID ),
  .MASTER7_ARREADY    ( MASTER7_ARREADY ),

  //======================  Master Read Data Ports  ==========================================================//
  .MASTER0_RID        ( MASTER0_RID ),
  .MASTER0_RDATA      ( MASTER0_RDATA ),
  .MASTER0_RRESP      ( MASTER0_RRESP ),
  .MASTER0_RLAST      ( MASTER0_RLAST ),
  .MASTER0_RUSER      ( MASTER0_RUSER ),
  .MASTER0_RVALID      ( MASTER0_RVALID ),
  .MASTER0_RREADY      ( MASTER0_RREADY ),

  .MASTER1_RID        ( MASTER1_RID ),
  .MASTER1_RDATA      ( MASTER1_RDATA ),
  .MASTER1_RRESP      ( MASTER1_RRESP ),
  .MASTER1_RLAST      ( MASTER1_RLAST ),
  .MASTER1_RUSER      ( MASTER1_RUSER ),
  .MASTER1_RVALID      ( MASTER1_RVALID ),
  .MASTER1_RREADY      ( MASTER1_RREADY ),

  .MASTER2_RID        ( MASTER2_RID ),
  .MASTER2_RDATA      ( MASTER2_RDATA ),
  .MASTER2_RRESP      ( MASTER2_RRESP ),
  .MASTER2_RLAST      ( MASTER2_RLAST ),
  .MASTER2_RUSER      ( MASTER2_RUSER ),
  .MASTER2_RVALID      ( MASTER2_RVALID ),
  .MASTER2_RREADY      ( MASTER2_RREADY ),

  .MASTER3_RID        ( MASTER3_RID ),
  .MASTER3_RDATA      ( MASTER3_RDATA ),
  .MASTER3_RRESP      ( MASTER3_RRESP ),
  .MASTER3_RLAST      ( MASTER3_RLAST ),
  .MASTER3_RUSER      ( MASTER3_RUSER ),
  .MASTER3_RVALID      ( MASTER3_RVALID ),
  .MASTER3_RREADY      ( MASTER3_RREADY ),

  .MASTER4_RID        ( MASTER4_RID ),
  .MASTER4_RDATA      ( MASTER4_RDATA ),
  .MASTER4_RRESP      ( MASTER4_RRESP ),
  .MASTER4_RLAST      ( MASTER4_RLAST ),
  .MASTER4_RUSER      ( MASTER4_RUSER ),
  .MASTER4_RVALID      ( MASTER4_RVALID ),
  .MASTER4_RREADY      ( MASTER4_RREADY ),

  .MASTER5_RID        ( MASTER5_RID ),
  .MASTER5_RDATA      ( MASTER5_RDATA ),
  .MASTER5_RRESP      ( MASTER5_RRESP ),
  .MASTER5_RLAST      ( MASTER5_RLAST ),
  .MASTER5_RUSER      ( MASTER5_RUSER ),
  .MASTER5_RVALID      ( MASTER5_RVALID ),
  .MASTER5_RREADY      ( MASTER5_RREADY ),

  .MASTER6_RID        ( MASTER6_RID ),
  .MASTER6_RDATA      ( MASTER6_RDATA ),
  .MASTER6_RRESP      ( MASTER6_RRESP ),
  .MASTER6_RLAST      ( MASTER6_RLAST ),
  .MASTER6_RUSER      ( MASTER6_RUSER ),
  .MASTER6_RVALID      ( MASTER6_RVALID ),
  .MASTER6_RREADY      ( MASTER6_RREADY ),

  .MASTER7_RID        ( MASTER7_RID ),
  .MASTER7_RDATA      ( MASTER7_RDATA ),
  .MASTER7_RRESP      ( MASTER7_RRESP ),
  .MASTER7_RLAST      ( MASTER7_RLAST ),
  .MASTER7_RUSER      ( MASTER7_RUSER ),
  .MASTER7_RVALID      ( MASTER7_RVALID ),
  .MASTER7_RREADY      ( MASTER7_RREADY ),

  //======================  Slave Write Address Port  ========================================================//



   // Slave Write Address Port
  .SLAVE0_AWID          ( SLAVE0_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE0_AWADDR        ( SLAVE0_AWADDR ),
  .SLAVE0_AWLEN         ( SLAVE0_AWLEN ),
  .SLAVE0_AWSIZE        ( SLAVE0_AWSIZE ),
  .SLAVE0_AWBURST       ( SLAVE0_AWBURST ),
  .SLAVE0_AWLOCK        ( SLAVE0_AWLOCK ),
  .SLAVE0_AWCACHE       ( SLAVE0_AWCACHE ),
  .SLAVE0_AWPROT        ( SLAVE0_AWPROT ),
  .SLAVE0_AWREGION      ( SLAVE0_AWREGION ),      // not used
  .SLAVE0_AWQOS         ( SLAVE0_AWQOS ),        // not used
  .SLAVE0_AWUSER        ( SLAVE0_AWUSER ),
  .SLAVE0_AWVALID       ( SLAVE0_AWVALID ),
  .SLAVE0_AWREADY       ( SLAVE0_AWREADY ),
  
  .SLAVE1_AWID          ( SLAVE1_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE1_AWADDR        ( SLAVE1_AWADDR ),
  .SLAVE1_AWLEN         ( SLAVE1_AWLEN ),
  .SLAVE1_AWSIZE        ( SLAVE1_AWSIZE ),
  .SLAVE1_AWBURST       ( SLAVE1_AWBURST ),
  .SLAVE1_AWLOCK        ( SLAVE1_AWLOCK ),
  .SLAVE1_AWCACHE       ( SLAVE1_AWCACHE ),
  .SLAVE1_AWPROT        ( SLAVE1_AWPROT ),
  .SLAVE1_AWREGION      ( SLAVE1_AWREGION ),      // not used
  .SLAVE1_AWQOS         ( SLAVE1_AWQOS ),        // not used
  .SLAVE1_AWUSER        ( SLAVE1_AWUSER ),
  .SLAVE1_AWVALID       ( SLAVE1_AWVALID ),
  .SLAVE1_AWREADY       ( SLAVE1_AWREADY ),
 
  .SLAVE2_AWID          ( SLAVE2_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE2_AWADDR        ( SLAVE2_AWADDR ),
  .SLAVE2_AWLEN         ( SLAVE2_AWLEN ),
  .SLAVE2_AWSIZE        ( SLAVE2_AWSIZE ),
  .SLAVE2_AWBURST       ( SLAVE2_AWBURST ),
  .SLAVE2_AWLOCK        ( SLAVE2_AWLOCK ),
  .SLAVE2_AWCACHE       ( SLAVE2_AWCACHE ),
  .SLAVE2_AWPROT        ( SLAVE2_AWPROT ),
  .SLAVE2_AWREGION      ( SLAVE2_AWREGION ),      // not used
  .SLAVE2_AWQOS         ( SLAVE2_AWQOS ),        // not used
  .SLAVE2_AWUSER        ( SLAVE2_AWUSER ),
  .SLAVE2_AWVALID       ( SLAVE2_AWVALID ),
  .SLAVE2_AWREADY       ( SLAVE2_AWREADY ),
   
  .SLAVE3_AWID          ( SLAVE3_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE3_AWADDR        ( SLAVE3_AWADDR ),
  .SLAVE3_AWLEN         ( SLAVE3_AWLEN ),
  .SLAVE3_AWSIZE        ( SLAVE3_AWSIZE ),
  .SLAVE3_AWBURST       ( SLAVE3_AWBURST ),
  .SLAVE3_AWLOCK        ( SLAVE3_AWLOCK ),
  .SLAVE3_AWCACHE       ( SLAVE3_AWCACHE ),
  .SLAVE3_AWPROT        ( SLAVE3_AWPROT ),
  .SLAVE3_AWREGION      ( SLAVE3_AWREGION ),      // not used
  .SLAVE3_AWQOS         ( SLAVE3_AWQOS ),        // not used
  .SLAVE3_AWUSER        ( SLAVE3_AWUSER ),
  .SLAVE3_AWVALID       ( SLAVE3_AWVALID ),
  .SLAVE3_AWREADY       ( SLAVE3_AWREADY ),

  .SLAVE4_AWID          ( SLAVE4_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE4_AWADDR        ( SLAVE4_AWADDR ),
  .SLAVE4_AWLEN         ( SLAVE4_AWLEN ),
  .SLAVE4_AWSIZE        ( SLAVE4_AWSIZE ),
  .SLAVE4_AWBURST       ( SLAVE4_AWBURST ),
  .SLAVE4_AWLOCK        ( SLAVE4_AWLOCK ),
  .SLAVE4_AWCACHE       ( SLAVE4_AWCACHE ),
  .SLAVE4_AWPROT        ( SLAVE4_AWPROT ),
  .SLAVE4_AWREGION      ( SLAVE4_AWREGION ),      // not used
  .SLAVE4_AWQOS         ( SLAVE4_AWQOS ),        // not used
  .SLAVE4_AWUSER        ( SLAVE4_AWUSER ),
  .SLAVE4_AWVALID       ( SLAVE4_AWVALID ),
  .SLAVE4_AWREADY       ( SLAVE4_AWREADY ),
  
  .SLAVE5_AWID          ( SLAVE5_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE5_AWADDR        ( SLAVE5_AWADDR ),
  .SLAVE5_AWLEN         ( SLAVE5_AWLEN ),
  .SLAVE5_AWSIZE        ( SLAVE5_AWSIZE ),
  .SLAVE5_AWBURST       ( SLAVE5_AWBURST ),
  .SLAVE5_AWLOCK        ( SLAVE5_AWLOCK ),
  .SLAVE5_AWCACHE       ( SLAVE5_AWCACHE ),
  .SLAVE5_AWPROT        ( SLAVE5_AWPROT ),
  .SLAVE5_AWREGION      ( SLAVE5_AWREGION ),      // not used
  .SLAVE5_AWQOS         ( SLAVE5_AWQOS ),        // not used
  .SLAVE5_AWUSER        ( SLAVE5_AWUSER ),
  .SLAVE5_AWVALID       ( SLAVE5_AWVALID ),
  .SLAVE5_AWREADY       ( SLAVE5_AWREADY ),

  .SLAVE6_AWID          ( SLAVE6_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE6_AWADDR        ( SLAVE6_AWADDR ),
  .SLAVE6_AWLEN         ( SLAVE6_AWLEN ),
  .SLAVE6_AWSIZE        ( SLAVE6_AWSIZE ),
  .SLAVE6_AWBURST       ( SLAVE6_AWBURST ),
  .SLAVE6_AWLOCK        ( SLAVE6_AWLOCK ),
  .SLAVE6_AWCACHE       ( SLAVE6_AWCACHE ),
  .SLAVE6_AWPROT        ( SLAVE6_AWPROT ),
  .SLAVE6_AWREGION      ( SLAVE6_AWREGION ),      // not used
  .SLAVE6_AWQOS         ( SLAVE6_AWQOS ),        // not used
  .SLAVE6_AWUSER        ( SLAVE6_AWUSER ),
  .SLAVE6_AWVALID       ( SLAVE6_AWVALID ),
  .SLAVE6_AWREADY       ( SLAVE6_AWREADY ),
  
  .SLAVE7_AWID          ( SLAVE7_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE7_AWADDR        ( SLAVE7_AWADDR ),
  .SLAVE7_AWLEN         ( SLAVE7_AWLEN ),
  .SLAVE7_AWSIZE        ( SLAVE7_AWSIZE ),
  .SLAVE7_AWBURST       ( SLAVE7_AWBURST ),
  .SLAVE7_AWLOCK        ( SLAVE7_AWLOCK ),
  .SLAVE7_AWCACHE       ( SLAVE7_AWCACHE ),
  .SLAVE7_AWPROT        ( SLAVE7_AWPROT ),
  .SLAVE7_AWREGION      ( SLAVE7_AWREGION ),      // not used
  .SLAVE7_AWQOS         ( SLAVE7_AWQOS ),        // not used
  .SLAVE7_AWUSER        ( SLAVE7_AWUSER ),
  .SLAVE7_AWVALID       ( SLAVE7_AWVALID ),
  .SLAVE7_AWREADY       ( SLAVE7_AWREADY ),
    
  .SLAVE8_AWID          ( SLAVE8_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE8_AWADDR        ( SLAVE8_AWADDR ),
  .SLAVE8_AWLEN         ( SLAVE8_AWLEN ),
  .SLAVE8_AWSIZE        ( SLAVE8_AWSIZE ),
  .SLAVE8_AWBURST       ( SLAVE8_AWBURST ),
  .SLAVE8_AWLOCK        ( SLAVE8_AWLOCK ),
  .SLAVE8_AWCACHE       ( SLAVE8_AWCACHE ),
  .SLAVE8_AWPROT        ( SLAVE8_AWPROT ),
  .SLAVE8_AWREGION      ( SLAVE8_AWREGION ),      // not used
  .SLAVE8_AWQOS         ( SLAVE8_AWQOS ),        // not used
  .SLAVE8_AWUSER        ( SLAVE8_AWUSER ),
  .SLAVE8_AWVALID       ( SLAVE8_AWVALID ),
  .SLAVE8_AWREADY       ( SLAVE8_AWREADY ),
  
  .SLAVE9_AWID          ( SLAVE9_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE9_AWADDR        ( SLAVE9_AWADDR ),
  .SLAVE9_AWLEN         ( SLAVE9_AWLEN ),
  .SLAVE9_AWSIZE        ( SLAVE9_AWSIZE ),
  .SLAVE9_AWBURST       ( SLAVE9_AWBURST ),
  .SLAVE9_AWLOCK        ( SLAVE9_AWLOCK ),
  .SLAVE9_AWCACHE       ( SLAVE9_AWCACHE ),
  .SLAVE9_AWPROT        ( SLAVE9_AWPROT ),
  .SLAVE9_AWREGION      ( SLAVE9_AWREGION ),      // not used
  .SLAVE9_AWQOS         ( SLAVE9_AWQOS ),        // not used
  .SLAVE9_AWUSER        ( SLAVE9_AWUSER ),
  .SLAVE9_AWVALID       ( SLAVE9_AWVALID ),
  .SLAVE9_AWREADY       ( SLAVE9_AWREADY ),
 
  .SLAVE10_AWID         ( SLAVE10_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE10_AWADDR       ( SLAVE10_AWADDR ),
  .SLAVE10_AWLEN        ( SLAVE10_AWLEN ),
  .SLAVE10_AWSIZE       ( SLAVE10_AWSIZE ),
  .SLAVE10_AWBURST      ( SLAVE10_AWBURST ),
  .SLAVE10_AWLOCK       ( SLAVE10_AWLOCK ),
  .SLAVE10_AWCACHE      ( SLAVE10_AWCACHE ),
  .SLAVE10_AWPROT       ( SLAVE10_AWPROT ),
  .SLAVE10_AWREGION     ( SLAVE10_AWREGION ),      // not used
  .SLAVE10_AWQOS        ( SLAVE10_AWQOS ),        // not used
  .SLAVE10_AWUSER       ( SLAVE10_AWUSER ),
  .SLAVE10_AWVALID      ( SLAVE10_AWVALID ),
  .SLAVE10_AWREADY      ( SLAVE10_AWREADY ),
   
  .SLAVE11_AWID         ( SLAVE11_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE11_AWADDR       ( SLAVE11_AWADDR ),
  .SLAVE11_AWLEN        ( SLAVE11_AWLEN ),
  .SLAVE11_AWSIZE       ( SLAVE11_AWSIZE ),
  .SLAVE11_AWBURST      ( SLAVE11_AWBURST ),
  .SLAVE11_AWLOCK       ( SLAVE11_AWLOCK ),
  .SLAVE11_AWCACHE      ( SLAVE11_AWCACHE ),
  .SLAVE11_AWPROT       ( SLAVE11_AWPROT ),
  .SLAVE11_AWREGION     ( SLAVE11_AWREGION ),      // not used
  .SLAVE11_AWQOS        ( SLAVE11_AWQOS ),        // not used
  .SLAVE11_AWUSER       ( SLAVE11_AWUSER ),
  .SLAVE11_AWVALID      ( SLAVE11_AWVALID ),
  .SLAVE11_AWREADY      ( SLAVE11_AWREADY ),

  .SLAVE12_AWID         ( SLAVE12_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE12_AWADDR       ( SLAVE12_AWADDR ),
  .SLAVE12_AWLEN        ( SLAVE12_AWLEN ),
  .SLAVE12_AWSIZE       ( SLAVE12_AWSIZE ),
  .SLAVE12_AWBURST      ( SLAVE12_AWBURST ),
  .SLAVE12_AWLOCK       ( SLAVE12_AWLOCK ),
  .SLAVE12_AWCACHE      ( SLAVE12_AWCACHE ),
  .SLAVE12_AWPROT       ( SLAVE12_AWPROT ),
  .SLAVE12_AWREGION     ( SLAVE12_AWREGION ),      // not used
  .SLAVE12_AWQOS        ( SLAVE12_AWQOS ),        // not used
  .SLAVE12_AWUSER       ( SLAVE12_AWUSER ),
  .SLAVE12_AWVALID      ( SLAVE12_AWVALID ),
  .SLAVE12_AWREADY      ( SLAVE12_AWREADY ),
  
  .SLAVE13_AWID         ( SLAVE13_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE13_AWADDR       ( SLAVE13_AWADDR ),
  .SLAVE13_AWLEN        ( SLAVE13_AWLEN ),
  .SLAVE13_AWSIZE       ( SLAVE13_AWSIZE ),
  .SLAVE13_AWBURST      ( SLAVE13_AWBURST ),
  .SLAVE13_AWLOCK       ( SLAVE13_AWLOCK ),
  .SLAVE13_AWCACHE      ( SLAVE13_AWCACHE ),
  .SLAVE13_AWPROT       ( SLAVE13_AWPROT ),
  .SLAVE13_AWREGION     ( SLAVE13_AWREGION ),      // not used
  .SLAVE13_AWQOS        ( SLAVE13_AWQOS ),        // not used
  .SLAVE13_AWUSER       ( SLAVE13_AWUSER ),
  .SLAVE13_AWVALID      ( SLAVE13_AWVALID ),
  .SLAVE13_AWREADY      ( SLAVE13_AWREADY ),

  .SLAVE14_AWID         ( SLAVE14_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE14_AWADDR       ( SLAVE14_AWADDR ),
  .SLAVE14_AWLEN        ( SLAVE14_AWLEN ),
  .SLAVE14_AWSIZE       ( SLAVE14_AWSIZE ),
  .SLAVE14_AWBURST      ( SLAVE14_AWBURST ),
  .SLAVE14_AWLOCK       ( SLAVE14_AWLOCK ),
  .SLAVE14_AWCACHE      ( SLAVE14_AWCACHE ),
  .SLAVE14_AWPROT       ( SLAVE14_AWPROT ),
  .SLAVE14_AWREGION     ( SLAVE14_AWREGION ),      // not used
  .SLAVE14_AWQOS        ( SLAVE14_AWQOS ),        // not used
  .SLAVE14_AWUSER       ( SLAVE14_AWUSER ),
  .SLAVE14_AWVALID      ( SLAVE14_AWVALID ),
  .SLAVE14_AWREADY      ( SLAVE14_AWREADY ),
  
  .SLAVE15_AWID         ( SLAVE15_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE15_AWADDR       ( SLAVE15_AWADDR ),
  .SLAVE15_AWLEN        ( SLAVE15_AWLEN ),
  .SLAVE15_AWSIZE       ( SLAVE15_AWSIZE ),
  .SLAVE15_AWBURST      ( SLAVE15_AWBURST ),
  .SLAVE15_AWLOCK       ( SLAVE15_AWLOCK ),
  .SLAVE15_AWCACHE      ( SLAVE15_AWCACHE ),
  .SLAVE15_AWPROT       ( SLAVE15_AWPROT ),
  .SLAVE15_AWREGION     ( SLAVE15_AWREGION ),      // not used
  .SLAVE15_AWQOS        ( SLAVE15_AWQOS ),        // not used
  .SLAVE15_AWUSER       ( SLAVE15_AWUSER ),
  .SLAVE15_AWVALID      ( SLAVE15_AWVALID ),
  .SLAVE15_AWREADY      ( SLAVE15_AWREADY ),
  
  .SLAVE16_AWID         ( SLAVE16_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE16_AWADDR       ( SLAVE16_AWADDR ),
  .SLAVE16_AWLEN        ( SLAVE16_AWLEN ),
  .SLAVE16_AWSIZE       ( SLAVE16_AWSIZE ),
  .SLAVE16_AWBURST      ( SLAVE16_AWBURST ),
  .SLAVE16_AWLOCK       ( SLAVE16_AWLOCK ),
  .SLAVE16_AWCACHE      ( SLAVE16_AWCACHE ),
  .SLAVE16_AWPROT       ( SLAVE16_AWPROT ),
  .SLAVE16_AWREGION     ( SLAVE16_AWREGION ),      // not used
  .SLAVE16_AWQOS        ( SLAVE16_AWQOS ),        // not used
  .SLAVE16_AWUSER       ( SLAVE16_AWUSER ),
  .SLAVE16_AWVALID      ( SLAVE16_AWVALID ),
  .SLAVE16_AWREADY      ( SLAVE16_AWREADY ),
  
  .SLAVE17_AWID         ( SLAVE17_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE17_AWADDR       ( SLAVE17_AWADDR ),
  .SLAVE17_AWLEN        ( SLAVE17_AWLEN ),
  .SLAVE17_AWSIZE       ( SLAVE17_AWSIZE ),
  .SLAVE17_AWBURST      ( SLAVE17_AWBURST ),
  .SLAVE17_AWLOCK       ( SLAVE17_AWLOCK ),
  .SLAVE17_AWCACHE      ( SLAVE17_AWCACHE ),
  .SLAVE17_AWPROT       ( SLAVE17_AWPROT ),
  .SLAVE17_AWREGION     ( SLAVE17_AWREGION ),      // not used
  .SLAVE17_AWQOS        ( SLAVE17_AWQOS ),        // not used
  .SLAVE17_AWUSER       ( SLAVE17_AWUSER ),
  .SLAVE17_AWVALID      ( SLAVE17_AWVALID ),
  .SLAVE17_AWREADY      ( SLAVE17_AWREADY ),
 
  .SLAVE18_AWID         ( SLAVE18_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE18_AWADDR       ( SLAVE18_AWADDR ),
  .SLAVE18_AWLEN        ( SLAVE18_AWLEN ),
  .SLAVE18_AWSIZE       ( SLAVE18_AWSIZE ),
  .SLAVE18_AWBURST      ( SLAVE18_AWBURST ),
  .SLAVE18_AWLOCK       ( SLAVE18_AWLOCK ),
  .SLAVE18_AWCACHE      ( SLAVE18_AWCACHE ),
  .SLAVE18_AWPROT       ( SLAVE18_AWPROT ),
  .SLAVE18_AWREGION     ( SLAVE18_AWREGION ),      // not used
  .SLAVE18_AWQOS        ( SLAVE18_AWQOS ),        // not used
  .SLAVE18_AWUSER       ( SLAVE18_AWUSER ),
  .SLAVE18_AWVALID      ( SLAVE18_AWVALID ),
  .SLAVE18_AWREADY      ( SLAVE18_AWREADY ),

  .SLAVE19_AWID         ( SLAVE19_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE19_AWADDR       ( SLAVE19_AWADDR ),
  .SLAVE19_AWLEN        ( SLAVE19_AWLEN ),
  .SLAVE19_AWSIZE       ( SLAVE19_AWSIZE ),
  .SLAVE19_AWBURST      ( SLAVE19_AWBURST ),
  .SLAVE19_AWLOCK       ( SLAVE19_AWLOCK ),
  .SLAVE19_AWCACHE      ( SLAVE19_AWCACHE ),
  .SLAVE19_AWPROT       ( SLAVE19_AWPROT ),
  .SLAVE19_AWREGION     ( SLAVE19_AWREGION ),      // not used
  .SLAVE19_AWQOS        ( SLAVE19_AWQOS ),        // not used
  .SLAVE19_AWUSER       ( SLAVE19_AWUSER ),
  .SLAVE19_AWVALID      ( SLAVE19_AWVALID ),
  .SLAVE19_AWREADY      ( SLAVE19_AWREADY ),

  .SLAVE20_AWID         ( SLAVE20_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE20_AWADDR       ( SLAVE20_AWADDR ),
  .SLAVE20_AWLEN        ( SLAVE20_AWLEN ),
  .SLAVE20_AWSIZE       ( SLAVE20_AWSIZE ),
  .SLAVE20_AWBURST      ( SLAVE20_AWBURST ),
  .SLAVE20_AWLOCK       ( SLAVE20_AWLOCK ),
  .SLAVE20_AWCACHE      ( SLAVE20_AWCACHE ),
  .SLAVE20_AWPROT       ( SLAVE20_AWPROT ),
  .SLAVE20_AWREGION     ( SLAVE20_AWREGION ),      // not used
  .SLAVE20_AWQOS        ( SLAVE20_AWQOS ),        // not used
  .SLAVE20_AWUSER       ( SLAVE20_AWUSER ),
  .SLAVE20_AWVALID      ( SLAVE20_AWVALID ),
  .SLAVE20_AWREADY      ( SLAVE20_AWREADY ),
  
  .SLAVE21_AWID         ( SLAVE21_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE21_AWADDR       ( SLAVE21_AWADDR ),
  .SLAVE21_AWLEN        ( SLAVE21_AWLEN ),
  .SLAVE21_AWSIZE       ( SLAVE21_AWSIZE ),
  .SLAVE21_AWBURST      ( SLAVE21_AWBURST ),
  .SLAVE21_AWLOCK       ( SLAVE21_AWLOCK ),
  .SLAVE21_AWCACHE      ( SLAVE21_AWCACHE ),
  .SLAVE21_AWPROT       ( SLAVE21_AWPROT ),
  .SLAVE21_AWREGION     ( SLAVE21_AWREGION ),      // not used
  .SLAVE21_AWQOS        ( SLAVE21_AWQOS ),        // not used
  .SLAVE21_AWUSER       ( SLAVE21_AWUSER ),
  .SLAVE21_AWVALID      ( SLAVE21_AWVALID ),
  .SLAVE21_AWREADY      ( SLAVE21_AWREADY ),

  .SLAVE22_AWID         ( SLAVE22_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE22_AWADDR       ( SLAVE22_AWADDR ),
  .SLAVE22_AWLEN        ( SLAVE22_AWLEN ),
  .SLAVE22_AWSIZE       ( SLAVE22_AWSIZE ),
  .SLAVE22_AWBURST      ( SLAVE22_AWBURST ),
  .SLAVE22_AWLOCK       ( SLAVE22_AWLOCK ),
  .SLAVE22_AWCACHE      ( SLAVE22_AWCACHE ),
  .SLAVE22_AWPROT       ( SLAVE22_AWPROT ),
  .SLAVE22_AWREGION     ( SLAVE22_AWREGION ),      // not used
  .SLAVE22_AWQOS        ( SLAVE22_AWQOS ),        // not used
  .SLAVE22_AWUSER       ( SLAVE22_AWUSER ),
  .SLAVE22_AWVALID      ( SLAVE22_AWVALID ),
  .SLAVE22_AWREADY      ( SLAVE22_AWREADY ),

  .SLAVE23_AWID         ( SLAVE23_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE23_AWADDR       ( SLAVE23_AWADDR ),
  .SLAVE23_AWLEN        ( SLAVE23_AWLEN ),
  .SLAVE23_AWSIZE       ( SLAVE23_AWSIZE ),
  .SLAVE23_AWBURST      ( SLAVE23_AWBURST ),
  .SLAVE23_AWLOCK       ( SLAVE23_AWLOCK ),
  .SLAVE23_AWCACHE      ( SLAVE23_AWCACHE ),
  .SLAVE23_AWPROT       ( SLAVE23_AWPROT ),
  .SLAVE23_AWREGION     ( SLAVE23_AWREGION ),      // not used
  .SLAVE23_AWQOS        ( SLAVE23_AWQOS ),        // not used
  .SLAVE23_AWUSER       ( SLAVE23_AWUSER ),
  .SLAVE23_AWVALID      ( SLAVE23_AWVALID ),
  .SLAVE23_AWREADY      ( SLAVE23_AWREADY ),
  
  .SLAVE24_AWID         ( SLAVE24_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE24_AWADDR       ( SLAVE24_AWADDR ),
  .SLAVE24_AWLEN        ( SLAVE24_AWLEN ),
  .SLAVE24_AWSIZE       ( SLAVE24_AWSIZE ),
  .SLAVE24_AWBURST      ( SLAVE24_AWBURST ),
  .SLAVE24_AWLOCK       ( SLAVE24_AWLOCK ),
  .SLAVE24_AWCACHE      ( SLAVE24_AWCACHE ),
  .SLAVE24_AWPROT       ( SLAVE24_AWPROT ),
  .SLAVE24_AWREGION     ( SLAVE24_AWREGION ),      // not used
  .SLAVE24_AWQOS        ( SLAVE24_AWQOS ),        // not used
  .SLAVE24_AWUSER       ( SLAVE24_AWUSER ),
  .SLAVE24_AWVALID      ( SLAVE24_AWVALID ),
  .SLAVE24_AWREADY      ( SLAVE24_AWREADY ),
  
  .SLAVE25_AWID         ( SLAVE25_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE25_AWADDR       ( SLAVE25_AWADDR ),
  .SLAVE25_AWLEN        ( SLAVE25_AWLEN ),
  .SLAVE25_AWSIZE       ( SLAVE25_AWSIZE ),
  .SLAVE25_AWBURST      ( SLAVE25_AWBURST ),
  .SLAVE25_AWLOCK       ( SLAVE25_AWLOCK ),
  .SLAVE25_AWCACHE      ( SLAVE25_AWCACHE ),
  .SLAVE25_AWPROT       ( SLAVE25_AWPROT ),
  .SLAVE25_AWREGION     ( SLAVE25_AWREGION ),      // not used
  .SLAVE25_AWQOS        ( SLAVE25_AWQOS ),        // not used
  .SLAVE25_AWUSER       ( SLAVE25_AWUSER ),
  .SLAVE25_AWVALID      ( SLAVE25_AWVALID ),
  .SLAVE25_AWREADY      ( SLAVE25_AWREADY ),
 
  .SLAVE26_AWID         ( SLAVE26_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE26_AWADDR       ( SLAVE26_AWADDR ),
  .SLAVE26_AWLEN        ( SLAVE26_AWLEN ),
  .SLAVE26_AWSIZE       ( SLAVE26_AWSIZE ),
  .SLAVE26_AWBURST      ( SLAVE26_AWBURST ),
  .SLAVE26_AWLOCK       ( SLAVE26_AWLOCK ),
  .SLAVE26_AWCACHE      ( SLAVE26_AWCACHE ),
  .SLAVE26_AWPROT       ( SLAVE26_AWPROT ),
  .SLAVE26_AWREGION     ( SLAVE26_AWREGION ),      // not used
  .SLAVE26_AWQOS        ( SLAVE26_AWQOS ),        // not used
  .SLAVE26_AWUSER       ( SLAVE26_AWUSER ),
  .SLAVE26_AWVALID      ( SLAVE26_AWVALID ),
  .SLAVE26_AWREADY      ( SLAVE26_AWREADY ),
   
  .SLAVE27_AWID         ( SLAVE27_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE27_AWADDR       ( SLAVE27_AWADDR ),
  .SLAVE27_AWLEN        ( SLAVE27_AWLEN ),
  .SLAVE27_AWSIZE       ( SLAVE27_AWSIZE ),
  .SLAVE27_AWBURST      ( SLAVE27_AWBURST ),
  .SLAVE27_AWLOCK       ( SLAVE27_AWLOCK ),
  .SLAVE27_AWCACHE      ( SLAVE27_AWCACHE ),
  .SLAVE27_AWPROT       ( SLAVE27_AWPROT ),
  .SLAVE27_AWREGION     ( SLAVE27_AWREGION ),      // not used
  .SLAVE27_AWQOS        ( SLAVE27_AWQOS ),        // not used
  .SLAVE27_AWUSER       ( SLAVE27_AWUSER ),
  .SLAVE27_AWVALID      ( SLAVE27_AWVALID ),
  .SLAVE27_AWREADY      ( SLAVE27_AWREADY ),

  .SLAVE28_AWID         ( SLAVE28_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE28_AWADDR       ( SLAVE28_AWADDR ),
  .SLAVE28_AWLEN        ( SLAVE28_AWLEN ),
  .SLAVE28_AWSIZE       ( SLAVE28_AWSIZE ),
  .SLAVE28_AWBURST      ( SLAVE28_AWBURST ),
  .SLAVE28_AWLOCK       ( SLAVE28_AWLOCK ),
  .SLAVE28_AWCACHE      ( SLAVE28_AWCACHE ),
  .SLAVE28_AWPROT       ( SLAVE28_AWPROT ),
  .SLAVE28_AWREGION     ( SLAVE28_AWREGION ),      // not used
  .SLAVE28_AWQOS        ( SLAVE28_AWQOS ),        // not used
  .SLAVE28_AWUSER       ( SLAVE28_AWUSER ),
  .SLAVE28_AWVALID      ( SLAVE28_AWVALID ),
  .SLAVE28_AWREADY      ( SLAVE28_AWREADY ),
  
  .SLAVE29_AWID         ( SLAVE29_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE29_AWADDR       ( SLAVE29_AWADDR ),
  .SLAVE29_AWLEN        ( SLAVE29_AWLEN ),
  .SLAVE29_AWSIZE       ( SLAVE29_AWSIZE ),
  .SLAVE29_AWBURST      ( SLAVE29_AWBURST ),
  .SLAVE29_AWLOCK       ( SLAVE29_AWLOCK ),
  .SLAVE29_AWCACHE      ( SLAVE29_AWCACHE ),
  .SLAVE29_AWPROT       ( SLAVE29_AWPROT ),
  .SLAVE29_AWREGION     ( SLAVE29_AWREGION ),      // not used
  .SLAVE29_AWQOS        ( SLAVE29_AWQOS ),        // not used
  .SLAVE29_AWUSER       ( SLAVE29_AWUSER ),
  .SLAVE29_AWVALID      ( SLAVE29_AWVALID ),
  .SLAVE29_AWREADY      ( SLAVE29_AWREADY ),

  .SLAVE30_AWID         ( SLAVE30_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE30_AWADDR       ( SLAVE30_AWADDR ),
  .SLAVE30_AWLEN        ( SLAVE30_AWLEN ),
  .SLAVE30_AWSIZE       ( SLAVE30_AWSIZE ),
  .SLAVE30_AWBURST      ( SLAVE30_AWBURST ),
  .SLAVE30_AWLOCK       ( SLAVE30_AWLOCK ),
  .SLAVE30_AWCACHE      ( SLAVE30_AWCACHE ),
  .SLAVE30_AWPROT       ( SLAVE30_AWPROT ),
  .SLAVE30_AWREGION     ( SLAVE30_AWREGION ),      // not used
  .SLAVE30_AWQOS        ( SLAVE30_AWQOS ),        // not used
  .SLAVE30_AWUSER       ( SLAVE30_AWUSER ),
  .SLAVE30_AWVALID      ( SLAVE30_AWVALID ),
  .SLAVE30_AWREADY      ( SLAVE30_AWREADY ),
  
  .SLAVE31_AWID         ( SLAVE31_AWID ),        // Slave ID is composed of Master Port ID concatenated with transaction ID
  .SLAVE31_AWADDR       ( SLAVE31_AWADDR ),
  .SLAVE31_AWLEN        ( SLAVE31_AWLEN ),
  .SLAVE31_AWSIZE       ( SLAVE31_AWSIZE ),
  .SLAVE31_AWBURST      ( SLAVE31_AWBURST ),
  .SLAVE31_AWLOCK       ( SLAVE31_AWLOCK ),
  .SLAVE31_AWCACHE      ( SLAVE31_AWCACHE ),
  .SLAVE31_AWPROT       ( SLAVE31_AWPROT ),
  .SLAVE31_AWREGION     ( SLAVE31_AWREGION ),      // not used
  .SLAVE31_AWQOS        ( SLAVE31_AWQOS ),        // not used
  .SLAVE31_AWUSER       ( SLAVE31_AWUSER ),
  .SLAVE31_AWVALID      ( SLAVE31_AWVALID ),
  .SLAVE31_AWREADY      ( SLAVE31_AWREADY ),

  //======================  Slave Write Data Ports  ==========================================================//

// Slave Write Data Ports
  .SLAVE0_WID          ( SLAVE0_WID ),
  .SLAVE0_WDATA        ( SLAVE0_WDATA ),
  .SLAVE0_WSTRB        ( SLAVE0_WSTRB ),
  .SLAVE0_WLAST        ( SLAVE0_WLAST ),
  .SLAVE0_WUSER        ( SLAVE0_WUSER ),
  .SLAVE0_WVALID       ( SLAVE0_WVALID ),
  .SLAVE0_WREADY       ( SLAVE0_WREADY ),

  .SLAVE1_WID          ( SLAVE1_WID ),
  .SLAVE1_WDATA        ( SLAVE1_WDATA ),
  .SLAVE1_WSTRB        ( SLAVE1_WSTRB ),
  .SLAVE1_WLAST        ( SLAVE1_WLAST ),
  .SLAVE1_WUSER        ( SLAVE1_WUSER ),
  .SLAVE1_WVALID       ( SLAVE1_WVALID ),
  .SLAVE1_WREADY       ( SLAVE1_WREADY ),

  .SLAVE2_WID          ( SLAVE2_WID ),
  .SLAVE2_WDATA        ( SLAVE2_WDATA ),
  .SLAVE2_WSTRB        ( SLAVE2_WSTRB ),
  .SLAVE2_WLAST        ( SLAVE2_WLAST ),
  .SLAVE2_WUSER        ( SLAVE2_WUSER ),
  .SLAVE2_WVALID       ( SLAVE2_WVALID ),
  .SLAVE2_WREADY       ( SLAVE2_WREADY ),  
  
  .SLAVE3_WID          ( SLAVE3_WID ),
  .SLAVE3_WDATA        ( SLAVE3_WDATA ),
  .SLAVE3_WSTRB        ( SLAVE3_WSTRB ),
  .SLAVE3_WLAST        ( SLAVE3_WLAST ),
  .SLAVE3_WUSER        ( SLAVE3_WUSER ),
  .SLAVE3_WVALID       ( SLAVE3_WVALID ),
  .SLAVE3_WREADY       ( SLAVE3_WREADY ),
  
  .SLAVE4_WID          ( SLAVE4_WID ),
  .SLAVE4_WDATA        ( SLAVE4_WDATA ),
  .SLAVE4_WSTRB        ( SLAVE4_WSTRB ),
  .SLAVE4_WLAST        ( SLAVE4_WLAST ),
  .SLAVE4_WUSER        ( SLAVE4_WUSER ),
  .SLAVE4_WVALID       ( SLAVE4_WVALID ),
  .SLAVE4_WREADY       ( SLAVE4_WREADY ),

  .SLAVE5_WID          ( SLAVE5_WID ),
  .SLAVE5_WDATA        ( SLAVE5_WDATA ),
  .SLAVE5_WSTRB        ( SLAVE5_WSTRB ),
  .SLAVE5_WLAST        ( SLAVE5_WLAST ),
  .SLAVE5_WUSER        ( SLAVE5_WUSER ),
  .SLAVE5_WVALID       ( SLAVE5_WVALID ),
  .SLAVE5_WREADY       ( SLAVE5_WREADY ),

  .SLAVE6_WID          ( SLAVE6_WID ),
  .SLAVE6_WDATA        ( SLAVE6_WDATA ),
  .SLAVE6_WSTRB        ( SLAVE6_WSTRB ),
  .SLAVE6_WLAST        ( SLAVE6_WLAST ),
  .SLAVE6_WUSER        ( SLAVE6_WUSER ),
  .SLAVE6_WVALID       ( SLAVE6_WVALID ),
  .SLAVE6_WREADY       ( SLAVE6_WREADY ),

  .SLAVE7_WID          ( SLAVE7_WID ),
  .SLAVE7_WDATA        ( SLAVE7_WDATA ),
  .SLAVE7_WSTRB        ( SLAVE7_WSTRB ),
  .SLAVE7_WLAST        ( SLAVE7_WLAST ),
  .SLAVE7_WUSER        ( SLAVE7_WUSER ),
  .SLAVE7_WVALID       ( SLAVE7_WVALID ),
  .SLAVE7_WREADY       ( SLAVE7_WREADY ),
  
  .SLAVE8_WID          ( SLAVE8_WID ),
  .SLAVE8_WDATA        ( SLAVE8_WDATA ),
  .SLAVE8_WSTRB        ( SLAVE8_WSTRB ),
  .SLAVE8_WLAST        ( SLAVE8_WLAST ),
  .SLAVE8_WUSER        ( SLAVE8_WUSER ),
  .SLAVE8_WVALID       ( SLAVE8_WVALID ),
  .SLAVE8_WREADY       ( SLAVE8_WREADY ),

  .SLAVE9_WID          ( SLAVE9_WID ),
  .SLAVE9_WDATA        ( SLAVE9_WDATA ),
  .SLAVE9_WSTRB        ( SLAVE9_WSTRB ),
  .SLAVE9_WLAST        ( SLAVE9_WLAST ),
  .SLAVE9_WUSER        ( SLAVE9_WUSER ),
  .SLAVE9_WVALID       ( SLAVE9_WVALID ),
  .SLAVE9_WREADY       ( SLAVE9_WREADY ),

  .SLAVE10_WID         ( SLAVE10_WID ),
  .SLAVE10_WDATA       ( SLAVE10_WDATA ),
  .SLAVE10_WSTRB       ( SLAVE10_WSTRB ),
  .SLAVE10_WLAST       ( SLAVE10_WLAST ),
  .SLAVE10_WUSER       ( SLAVE10_WUSER ),
  .SLAVE10_WVALID      ( SLAVE10_WVALID ),
  .SLAVE10_WREADY      ( SLAVE10_WREADY ),  
  
  .SLAVE11_WID         ( SLAVE11_WID ),
  .SLAVE11_WDATA       ( SLAVE11_WDATA ),
  .SLAVE11_WSTRB       ( SLAVE11_WSTRB ),
  .SLAVE11_WLAST       ( SLAVE11_WLAST ),
  .SLAVE11_WUSER       ( SLAVE11_WUSER ),
  .SLAVE11_WVALID      ( SLAVE11_WVALID ),
  .SLAVE11_WREADY      ( SLAVE11_WREADY ),
  
  .SLAVE12_WID         ( SLAVE12_WID ),
  .SLAVE12_WDATA       ( SLAVE12_WDATA ),
  .SLAVE12_WSTRB       ( SLAVE12_WSTRB ),
  .SLAVE12_WLAST       ( SLAVE12_WLAST ),
  .SLAVE12_WUSER       ( SLAVE12_WUSER ),
  .SLAVE12_WVALID      ( SLAVE12_WVALID ),
  .SLAVE12_WREADY      ( SLAVE12_WREADY ),

  .SLAVE13_WID         ( SLAVE13_WID ),
  .SLAVE13_WDATA       ( SLAVE13_WDATA ),
  .SLAVE13_WSTRB       ( SLAVE13_WSTRB ),
  .SLAVE13_WLAST       ( SLAVE13_WLAST ),
  .SLAVE13_WUSER       ( SLAVE13_WUSER ),
  .SLAVE13_WVALID      ( SLAVE13_WVALID ),
  .SLAVE13_WREADY      ( SLAVE13_WREADY ),

  .SLAVE14_WID         ( SLAVE14_WID ),
  .SLAVE14_WDATA       ( SLAVE14_WDATA ),
  .SLAVE14_WSTRB       ( SLAVE14_WSTRB ),
  .SLAVE14_WLAST       ( SLAVE14_WLAST ),
  .SLAVE14_WUSER       ( SLAVE14_WUSER ),
  .SLAVE14_WVALID      ( SLAVE14_WVALID ),
  .SLAVE14_WREADY      ( SLAVE14_WREADY ),

  .SLAVE15_WID         ( SLAVE15_WID ),
  .SLAVE15_WDATA       ( SLAVE15_WDATA ),
  .SLAVE15_WSTRB       ( SLAVE15_WSTRB ),
  .SLAVE15_WLAST       ( SLAVE15_WLAST ),
  .SLAVE15_WUSER       ( SLAVE15_WUSER ),
  .SLAVE15_WVALID      ( SLAVE15_WVALID ),
  .SLAVE15_WREADY      ( SLAVE15_WREADY ),
  
  .SLAVE16_WID         ( SLAVE16_WID ),
  .SLAVE16_WDATA       ( SLAVE16_WDATA ),
  .SLAVE16_WSTRB       ( SLAVE16_WSTRB ),
  .SLAVE16_WLAST       ( SLAVE16_WLAST ),
  .SLAVE16_WUSER       ( SLAVE16_WUSER ),
  .SLAVE16_WVALID      ( SLAVE16_WVALID ),
  .SLAVE16_WREADY      ( SLAVE16_WREADY ),

  .SLAVE17_WID         ( SLAVE17_WID ),
  .SLAVE17_WDATA       ( SLAVE17_WDATA ),
  .SLAVE17_WSTRB       ( SLAVE17_WSTRB ),
  .SLAVE17_WLAST       ( SLAVE17_WLAST ),
  .SLAVE17_WUSER       ( SLAVE17_WUSER ),
  .SLAVE17_WVALID      ( SLAVE17_WVALID ),
  .SLAVE17_WREADY      ( SLAVE17_WREADY ),

  .SLAVE18_WID         ( SLAVE18_WID ),
  .SLAVE18_WDATA       ( SLAVE18_WDATA ),
  .SLAVE18_WSTRB       ( SLAVE18_WSTRB ),
  .SLAVE18_WLAST       ( SLAVE18_WLAST ),
  .SLAVE18_WUSER       ( SLAVE18_WUSER ),
  .SLAVE18_WVALID      ( SLAVE18_WVALID ),
  .SLAVE18_WREADY      ( SLAVE18_WREADY ),  
  
  .SLAVE19_WID         ( SLAVE19_WID ),
  .SLAVE19_WDATA       ( SLAVE19_WDATA ),
  .SLAVE19_WSTRB       ( SLAVE19_WSTRB ),
  .SLAVE19_WLAST       ( SLAVE19_WLAST ),
  .SLAVE19_WUSER       ( SLAVE19_WUSER ),
  .SLAVE19_WVALID      ( SLAVE19_WVALID ),
  .SLAVE19_WREADY      ( SLAVE19_WREADY ),
  
  .SLAVE20_WID         ( SLAVE20_WID ),
  .SLAVE20_WDATA       ( SLAVE20_WDATA ),
  .SLAVE20_WSTRB       ( SLAVE20_WSTRB ),
  .SLAVE20_WLAST       ( SLAVE20_WLAST ),
  .SLAVE20_WUSER       ( SLAVE20_WUSER ),
  .SLAVE20_WVALID      ( SLAVE20_WVALID ),
  .SLAVE20_WREADY      ( SLAVE20_WREADY ),

  .SLAVE21_WID         ( SLAVE21_WID ),
  .SLAVE21_WDATA       ( SLAVE21_WDATA ),
  .SLAVE21_WSTRB       ( SLAVE21_WSTRB ),
  .SLAVE21_WLAST       ( SLAVE21_WLAST ),
  .SLAVE21_WUSER       ( SLAVE21_WUSER ),
  .SLAVE21_WVALID      ( SLAVE21_WVALID ),
  .SLAVE21_WREADY      ( SLAVE21_WREADY ),

  .SLAVE22_WID         ( SLAVE22_WID ),
  .SLAVE22_WDATA       ( SLAVE22_WDATA ),
  .SLAVE22_WSTRB       ( SLAVE22_WSTRB ),
  .SLAVE22_WLAST       ( SLAVE22_WLAST ),
  .SLAVE22_WUSER       ( SLAVE22_WUSER ),
  .SLAVE22_WVALID      ( SLAVE22_WVALID ),
  .SLAVE22_WREADY      ( SLAVE22_WREADY ),

  .SLAVE23_WID         ( SLAVE23_WID ),
  .SLAVE23_WDATA       ( SLAVE23_WDATA ),
  .SLAVE23_WSTRB       ( SLAVE23_WSTRB ),
  .SLAVE23_WLAST       ( SLAVE23_WLAST ),
  .SLAVE23_WUSER       ( SLAVE23_WUSER ),
  .SLAVE23_WVALID      ( SLAVE23_WVALID ),
  .SLAVE23_WREADY      ( SLAVE23_WREADY ),
  
  .SLAVE24_WID         ( SLAVE24_WID ),
  .SLAVE24_WDATA       ( SLAVE24_WDATA ),
  .SLAVE24_WSTRB       ( SLAVE24_WSTRB ),
  .SLAVE24_WLAST       ( SLAVE24_WLAST ),
  .SLAVE24_WUSER       ( SLAVE24_WUSER ),
  .SLAVE24_WVALID      ( SLAVE24_WVALID ),
  .SLAVE24_WREADY      ( SLAVE24_WREADY ),

  .SLAVE25_WID         ( SLAVE25_WID ),
  .SLAVE25_WDATA       ( SLAVE25_WDATA ),
  .SLAVE25_WSTRB       ( SLAVE25_WSTRB ),
  .SLAVE25_WLAST       ( SLAVE25_WLAST ),
  .SLAVE25_WUSER       ( SLAVE25_WUSER ),
  .SLAVE25_WVALID      ( SLAVE25_WVALID ),
  .SLAVE25_WREADY      ( SLAVE25_WREADY ),

  .SLAVE26_WID         ( SLAVE26_WID ),
  .SLAVE26_WDATA       ( SLAVE26_WDATA ),
  .SLAVE26_WSTRB       ( SLAVE26_WSTRB ),
  .SLAVE26_WLAST       ( SLAVE26_WLAST ),
  .SLAVE26_WUSER       ( SLAVE26_WUSER ),
  .SLAVE26_WVALID      ( SLAVE26_WVALID ),
  .SLAVE26_WREADY      ( SLAVE26_WREADY ),  
  
  .SLAVE27_WID         ( SLAVE27_WID ),
  .SLAVE27_WDATA       ( SLAVE27_WDATA ),
  .SLAVE27_WSTRB       ( SLAVE27_WSTRB ),
  .SLAVE27_WLAST       ( SLAVE27_WLAST ),
  .SLAVE27_WUSER       ( SLAVE27_WUSER ),
  .SLAVE27_WVALID      ( SLAVE27_WVALID ),
  .SLAVE27_WREADY      ( SLAVE27_WREADY ),
  
  .SLAVE28_WID         ( SLAVE28_WID ),
  .SLAVE28_WDATA       ( SLAVE28_WDATA ),
  .SLAVE28_WSTRB       ( SLAVE28_WSTRB ),
  .SLAVE28_WLAST       ( SLAVE28_WLAST ),
  .SLAVE28_WUSER       ( SLAVE28_WUSER ),
  .SLAVE28_WVALID      ( SLAVE28_WVALID ),
  .SLAVE28_WREADY      ( SLAVE28_WREADY ),

  .SLAVE29_WID         ( SLAVE29_WID ),
  .SLAVE29_WDATA       ( SLAVE29_WDATA ),
  .SLAVE29_WSTRB       ( SLAVE29_WSTRB ),
  .SLAVE29_WLAST       ( SLAVE29_WLAST ),
  .SLAVE29_WUSER       ( SLAVE29_WUSER ),
  .SLAVE29_WVALID      ( SLAVE29_WVALID ),
  .SLAVE29_WREADY      ( SLAVE29_WREADY ),

  .SLAVE30_WID         ( SLAVE30_WID ),
  .SLAVE30_WDATA       ( SLAVE30_WDATA ),
  .SLAVE30_WSTRB       ( SLAVE30_WSTRB ),
  .SLAVE30_WLAST       ( SLAVE30_WLAST ),
  .SLAVE30_WUSER       ( SLAVE30_WUSER ),
  .SLAVE30_WVALID      ( SLAVE30_WVALID ),
  .SLAVE30_WREADY      ( SLAVE30_WREADY ),

  .SLAVE31_WID         ( SLAVE31_WID ),
  .SLAVE31_WDATA       ( SLAVE31_WDATA ),
  .SLAVE31_WSTRB       ( SLAVE31_WSTRB ),
  .SLAVE31_WLAST       ( SLAVE31_WLAST ),
  .SLAVE31_WUSER       ( SLAVE31_WUSER ),
  .SLAVE31_WVALID      ( SLAVE31_WVALID ),
  .SLAVE31_WREADY      ( SLAVE31_WREADY ),
  
  // Slave Write Response Ports
  .SLAVE0_BID            ( SLAVE0_BID ),
  .SLAVE0_BRESP          ( SLAVE0_BRESP ),
  .SLAVE0_BUSER          ( SLAVE0_BUSER ),
  .SLAVE0_BVALID         ( SLAVE0_BVALID ),
  .SLAVE0_BREADY         ( SLAVE0_BREADY ),

  .SLAVE1_BID            ( SLAVE1_BID ),
  .SLAVE1_BRESP          ( SLAVE1_BRESP ),
  .SLAVE1_BUSER          ( SLAVE1_BUSER ),
  .SLAVE1_BVALID         ( SLAVE1_BVALID ),
  .SLAVE1_BREADY         ( SLAVE1_BREADY ),

  .SLAVE2_BID            ( SLAVE2_BID ),
  .SLAVE2_BRESP          ( SLAVE2_BRESP ),
  .SLAVE2_BUSER          ( SLAVE2_BUSER ),
  .SLAVE2_BVALID         ( SLAVE2_BVALID ),
  .SLAVE2_BREADY         ( SLAVE2_BREADY ),

  .SLAVE3_BID            ( SLAVE3_BID ),
  .SLAVE3_BRESP          ( SLAVE3_BRESP ),
  .SLAVE3_BUSER          ( SLAVE3_BUSER ),
  .SLAVE3_BVALID         ( SLAVE3_BVALID ),
  .SLAVE3_BREADY         ( SLAVE3_BREADY ),

  .SLAVE4_BID            ( SLAVE4_BID ),
  .SLAVE4_BRESP          ( SLAVE4_BRESP ),
  .SLAVE4_BUSER          ( SLAVE4_BUSER ),
  .SLAVE4_BVALID         ( SLAVE4_BVALID ),
  .SLAVE4_BREADY         ( SLAVE4_BREADY ),

  .SLAVE5_BID            ( SLAVE5_BID ),
  .SLAVE5_BRESP          ( SLAVE5_BRESP ),
  .SLAVE5_BUSER          ( SLAVE5_BUSER ),
  .SLAVE5_BVALID         ( SLAVE5_BVALID ),
  .SLAVE5_BREADY         ( SLAVE5_BREADY ),

  .SLAVE6_BID            ( SLAVE6_BID ),
  .SLAVE6_BRESP          ( SLAVE6_BRESP ),
  .SLAVE6_BUSER          ( SLAVE6_BUSER ),
  .SLAVE6_BVALID         ( SLAVE6_BVALID ),
  .SLAVE6_BREADY         ( SLAVE6_BREADY ),

  .SLAVE7_BID            ( SLAVE7_BID ),
  .SLAVE7_BRESP          ( SLAVE7_BRESP ),
  .SLAVE7_BUSER          ( SLAVE7_BUSER ),
  .SLAVE7_BVALID         ( SLAVE7_BVALID ),
  .SLAVE7_BREADY         ( SLAVE7_BREADY ),

  .SLAVE8_BID            ( SLAVE8_BID ),
  .SLAVE8_BRESP          ( SLAVE8_BRESP ),
  .SLAVE8_BUSER          ( SLAVE8_BUSER ),
  .SLAVE8_BVALID         ( SLAVE8_BVALID ),
  .SLAVE8_BREADY         ( SLAVE8_BREADY ),

  .SLAVE9_BID            ( SLAVE9_BID ),
  .SLAVE9_BRESP          ( SLAVE9_BRESP ),
  .SLAVE9_BUSER          ( SLAVE9_BUSER ),
  .SLAVE9_BVALID         ( SLAVE9_BVALID ),
  .SLAVE9_BREADY         ( SLAVE9_BREADY ),

  .SLAVE10_BID           ( SLAVE10_BID ),
  .SLAVE10_BRESP         ( SLAVE10_BRESP ),
  .SLAVE10_BUSER         ( SLAVE10_BUSER ),
  .SLAVE10_BVALID        ( SLAVE10_BVALID ),
  .SLAVE10_BREADY        ( SLAVE10_BREADY ),

  .SLAVE11_BID           ( SLAVE11_BID ),
  .SLAVE11_BRESP         ( SLAVE11_BRESP ),
  .SLAVE11_BUSER         ( SLAVE11_BUSER ),
  .SLAVE11_BVALID        ( SLAVE11_BVALID ),
  .SLAVE11_BREADY        ( SLAVE11_BREADY ),

  .SLAVE12_BID           ( SLAVE12_BID ),
  .SLAVE12_BRESP         ( SLAVE12_BRESP ),
  .SLAVE12_BUSER         ( SLAVE12_BUSER ),
  .SLAVE12_BVALID        ( SLAVE12_BVALID ),
  .SLAVE12_BREADY        ( SLAVE12_BREADY ),

  .SLAVE13_BID           ( SLAVE13_BID ),
  .SLAVE13_BRESP         ( SLAVE13_BRESP ),
  .SLAVE13_BUSER         ( SLAVE13_BUSER ),
  .SLAVE13_BVALID        ( SLAVE13_BVALID ),
  .SLAVE13_BREADY        ( SLAVE13_BREADY ),

  .SLAVE14_BID           ( SLAVE14_BID ),
  .SLAVE14_BRESP         ( SLAVE14_BRESP ),
  .SLAVE14_BUSER         ( SLAVE14_BUSER ),
  .SLAVE14_BVALID        ( SLAVE14_BVALID ),
  .SLAVE14_BREADY        ( SLAVE14_BREADY ),

  .SLAVE15_BID           ( SLAVE15_BID ),
  .SLAVE15_BRESP         ( SLAVE15_BRESP ),
  .SLAVE15_BUSER         ( SLAVE15_BUSER ),
  .SLAVE15_BVALID        ( SLAVE15_BVALID ),
  .SLAVE15_BREADY        ( SLAVE15_BREADY ),

  .SLAVE16_BID           ( SLAVE16_BID ),
  .SLAVE16_BRESP         ( SLAVE16_BRESP ),
  .SLAVE16_BUSER         ( SLAVE16_BUSER ),
  .SLAVE16_BVALID        ( SLAVE16_BVALID ),
  .SLAVE16_BREADY        ( SLAVE16_BREADY ),

  .SLAVE17_BID           ( SLAVE17_BID ),
  .SLAVE17_BRESP         ( SLAVE17_BRESP ),
  .SLAVE17_BUSER         ( SLAVE17_BUSER ),
  .SLAVE17_BVALID        ( SLAVE17_BVALID ),
  .SLAVE17_BREADY        ( SLAVE17_BREADY ),

  .SLAVE18_BID           ( SLAVE18_BID ),
  .SLAVE18_BRESP         ( SLAVE18_BRESP ),
  .SLAVE18_BUSER         ( SLAVE18_BUSER ),
  .SLAVE18_BVALID        ( SLAVE18_BVALID ),
  .SLAVE18_BREADY        ( SLAVE18_BREADY ),

  .SLAVE19_BID           ( SLAVE19_BID ),
  .SLAVE19_BRESP         ( SLAVE19_BRESP ),
  .SLAVE19_BUSER         ( SLAVE19_BUSER ),
  .SLAVE19_BVALID        ( SLAVE19_BVALID ),
  .SLAVE19_BREADY        ( SLAVE19_BREADY ),

  .SLAVE20_BID           ( SLAVE20_BID ),
  .SLAVE20_BRESP         ( SLAVE20_BRESP ),
  .SLAVE20_BUSER         ( SLAVE20_BUSER ),
  .SLAVE20_BVALID        ( SLAVE20_BVALID ),
  .SLAVE20_BREADY        ( SLAVE20_BREADY ),

  .SLAVE21_BID           ( SLAVE21_BID ),
  .SLAVE21_BRESP         ( SLAVE21_BRESP ),
  .SLAVE21_BUSER         ( SLAVE21_BUSER ),
  .SLAVE21_BVALID        ( SLAVE21_BVALID ),
  .SLAVE21_BREADY        ( SLAVE21_BREADY ),

  .SLAVE22_BID           ( SLAVE22_BID ),
  .SLAVE22_BRESP         ( SLAVE22_BRESP ),
  .SLAVE22_BUSER         ( SLAVE22_BUSER ),
  .SLAVE22_BVALID        ( SLAVE22_BVALID ),
  .SLAVE22_BREADY        ( SLAVE22_BREADY ),

  .SLAVE23_BID           ( SLAVE23_BID ),
  .SLAVE23_BRESP         ( SLAVE23_BRESP ),
  .SLAVE23_BUSER         ( SLAVE23_BUSER ),
  .SLAVE23_BVALID        ( SLAVE23_BVALID ),
  .SLAVE23_BREADY        ( SLAVE23_BREADY ),

  .SLAVE24_BID           ( SLAVE24_BID ),
  .SLAVE24_BRESP         ( SLAVE24_BRESP ),
  .SLAVE24_BUSER         ( SLAVE24_BUSER ),
  .SLAVE24_BVALID        ( SLAVE24_BVALID ),
  .SLAVE24_BREADY        ( SLAVE24_BREADY ),

  .SLAVE25_BID           ( SLAVE25_BID ),
  .SLAVE25_BRESP         ( SLAVE25_BRESP ),
  .SLAVE25_BUSER         ( SLAVE25_BUSER ),
  .SLAVE25_BVALID        ( SLAVE25_BVALID ),
  .SLAVE25_BREADY        ( SLAVE25_BREADY ),

  .SLAVE26_BID           ( SLAVE26_BID ),
  .SLAVE26_BRESP         ( SLAVE26_BRESP ),
  .SLAVE26_BUSER         ( SLAVE26_BUSER ),
  .SLAVE26_BVALID        ( SLAVE26_BVALID ),
  .SLAVE26_BREADY        ( SLAVE26_BREADY ),

  .SLAVE27_BID           ( SLAVE27_BID ),
  .SLAVE27_BRESP         ( SLAVE27_BRESP ),
  .SLAVE27_BUSER         ( SLAVE27_BUSER ),
  .SLAVE27_BVALID        ( SLAVE27_BVALID ),
  .SLAVE27_BREADY        ( SLAVE27_BREADY ),

  .SLAVE28_BID           ( SLAVE28_BID ),
  .SLAVE28_BRESP         ( SLAVE28_BRESP ),
  .SLAVE28_BUSER         ( SLAVE28_BUSER ),
  .SLAVE28_BVALID        ( SLAVE28_BVALID ),
  .SLAVE28_BREADY        ( SLAVE28_BREADY ),

  .SLAVE29_BID           ( SLAVE29_BID ),
  .SLAVE29_BRESP         ( SLAVE29_BRESP ),
  .SLAVE29_BUSER         ( SLAVE29_BUSER ),
  .SLAVE29_BVALID        ( SLAVE29_BVALID ),
  .SLAVE29_BREADY        ( SLAVE29_BREADY ),

  .SLAVE30_BID           ( SLAVE30_BID ),
  .SLAVE30_BRESP         ( SLAVE30_BRESP ),
  .SLAVE30_BUSER         ( SLAVE30_BUSER ),
  .SLAVE30_BVALID        ( SLAVE30_BVALID ),
  .SLAVE30_BREADY        ( SLAVE30_BREADY ),

  .SLAVE31_BID           ( SLAVE31_BID ),
  .SLAVE31_BRESP         ( SLAVE31_BRESP ),
  .SLAVE31_BUSER         ( SLAVE31_BUSER ),
  .SLAVE31_BVALID        ( SLAVE31_BVALID ),
  .SLAVE31_BREADY        ( SLAVE31_BREADY ),

  //======================  Slave Read Address Port  =========================================================//
 // Slave Read Address Port
  .SLAVE0_ARID          ( SLAVE0_ARID ),
  .SLAVE0_ARADDR        ( SLAVE0_ARADDR ),
  .SLAVE0_ARLEN         ( SLAVE0_ARLEN ),
  .SLAVE0_ARSIZE        ( SLAVE0_ARSIZE ),
  .SLAVE0_ARBURST       ( SLAVE0_ARBURST ),
  .SLAVE0_ARLOCK        ( SLAVE0_ARLOCK ),
  .SLAVE0_ARCACHE       ( SLAVE0_ARCACHE ),
  .SLAVE0_ARPROT        ( SLAVE0_ARPROT ),
  .SLAVE0_ARREGION      ( SLAVE0_ARREGION ),      // not used
  .SLAVE0_ARQOS         ( SLAVE0_ARQOS ),        // not used
  .SLAVE0_ARUSER        ( SLAVE0_ARUSER ),
  .SLAVE0_ARVALID       ( SLAVE0_ARVALID ),
  .SLAVE0_ARREADY       ( SLAVE0_ARREADY ),
 
  .SLAVE1_ARID          ( SLAVE1_ARID ),
  .SLAVE1_ARADDR        ( SLAVE1_ARADDR ),
  .SLAVE1_ARLEN         ( SLAVE1_ARLEN ),
  .SLAVE1_ARSIZE        ( SLAVE1_ARSIZE ),
  .SLAVE1_ARBURST       ( SLAVE1_ARBURST ),
  .SLAVE1_ARLOCK        ( SLAVE1_ARLOCK ),
  .SLAVE1_ARCACHE       ( SLAVE1_ARCACHE ),
  .SLAVE1_ARPROT        ( SLAVE1_ARPROT ),
  .SLAVE1_ARREGION      ( SLAVE1_ARREGION ),      // not used
  .SLAVE1_ARQOS         ( SLAVE1_ARQOS ),        // not used
  .SLAVE1_ARUSER        ( SLAVE1_ARUSER ),
  .SLAVE1_ARVALID       ( SLAVE1_ARVALID ),
  .SLAVE1_ARREADY       ( SLAVE1_ARREADY ),

  .SLAVE2_ARID          ( SLAVE2_ARID ),
  .SLAVE2_ARADDR        ( SLAVE2_ARADDR ),
  .SLAVE2_ARLEN         ( SLAVE2_ARLEN ),
  .SLAVE2_ARSIZE        ( SLAVE2_ARSIZE ),
  .SLAVE2_ARBURST       ( SLAVE2_ARBURST ),
  .SLAVE2_ARLOCK        ( SLAVE2_ARLOCK ),
  .SLAVE2_ARCACHE       ( SLAVE2_ARCACHE ),
  .SLAVE2_ARPROT        ( SLAVE2_ARPROT ),
  .SLAVE2_ARREGION      ( SLAVE2_ARREGION ),      // not used
  .SLAVE2_ARQOS         ( SLAVE2_ARQOS ),        // not used
  .SLAVE2_ARUSER        ( SLAVE2_ARUSER ),
  .SLAVE2_ARVALID       ( SLAVE2_ARVALID ),
  .SLAVE2_ARREADY       ( SLAVE2_ARREADY ),

  .SLAVE3_ARID          ( SLAVE3_ARID ),
  .SLAVE3_ARADDR        ( SLAVE3_ARADDR ),
  .SLAVE3_ARLEN         ( SLAVE3_ARLEN ),
  .SLAVE3_ARSIZE        ( SLAVE3_ARSIZE ),
  .SLAVE3_ARBURST       ( SLAVE3_ARBURST ),
  .SLAVE3_ARLOCK        ( SLAVE3_ARLOCK ),
  .SLAVE3_ARCACHE       ( SLAVE3_ARCACHE ),
  .SLAVE3_ARPROT        ( SLAVE3_ARPROT ),
  .SLAVE3_ARREGION      ( SLAVE3_ARREGION ),      // not used
  .SLAVE3_ARQOS         ( SLAVE3_ARQOS ),        // not used
  .SLAVE3_ARUSER        ( SLAVE3_ARUSER ),
  .SLAVE3_ARVALID       ( SLAVE3_ARVALID ),
  .SLAVE3_ARREADY       ( SLAVE3_ARREADY ),

  .SLAVE4_ARID          ( SLAVE4_ARID ),
  .SLAVE4_ARADDR        ( SLAVE4_ARADDR ),
  .SLAVE4_ARLEN         ( SLAVE4_ARLEN ),
  .SLAVE4_ARSIZE        ( SLAVE4_ARSIZE ),
  .SLAVE4_ARBURST       ( SLAVE4_ARBURST ),
  .SLAVE4_ARLOCK        ( SLAVE4_ARLOCK ),
  .SLAVE4_ARCACHE       ( SLAVE4_ARCACHE ),
  .SLAVE4_ARPROT        ( SLAVE4_ARPROT ),
  .SLAVE4_ARREGION      ( SLAVE4_ARREGION ),      // not used
  .SLAVE4_ARQOS         ( SLAVE4_ARQOS ),        // not used
  .SLAVE4_ARUSER        ( SLAVE4_ARUSER ),
  .SLAVE4_ARVALID       ( SLAVE4_ARVALID ),
  .SLAVE4_ARREADY       ( SLAVE4_ARREADY ),

  .SLAVE5_ARID          ( SLAVE5_ARID ),
  .SLAVE5_ARADDR        ( SLAVE5_ARADDR ),
  .SLAVE5_ARLEN         ( SLAVE5_ARLEN ),
  .SLAVE5_ARSIZE        ( SLAVE5_ARSIZE ),
  .SLAVE5_ARBURST       ( SLAVE5_ARBURST ),
  .SLAVE5_ARLOCK        ( SLAVE5_ARLOCK ),
  .SLAVE5_ARCACHE       ( SLAVE5_ARCACHE ),
  .SLAVE5_ARPROT        ( SLAVE5_ARPROT ),
  .SLAVE5_ARREGION      ( SLAVE5_ARREGION ),      // not used
  .SLAVE5_ARQOS         ( SLAVE5_ARQOS ),        // not used
  .SLAVE5_ARUSER        ( SLAVE5_ARUSER ),
  .SLAVE5_ARVALID       ( SLAVE5_ARVALID ),
  .SLAVE5_ARREADY       ( SLAVE5_ARREADY ),
  
  .SLAVE6_ARID          ( SLAVE6_ARID ),
  .SLAVE6_ARADDR        ( SLAVE6_ARADDR ),
  .SLAVE6_ARLEN         ( SLAVE6_ARLEN ),
  .SLAVE6_ARSIZE        ( SLAVE6_ARSIZE ),
  .SLAVE6_ARBURST       ( SLAVE6_ARBURST ),
  .SLAVE6_ARLOCK        ( SLAVE6_ARLOCK ),
  .SLAVE6_ARCACHE       ( SLAVE6_ARCACHE ),
  .SLAVE6_ARPROT        ( SLAVE6_ARPROT ),
  .SLAVE6_ARREGION      ( SLAVE6_ARREGION ),      // not used
  .SLAVE6_ARQOS         ( SLAVE6_ARQOS ),        // not used
  .SLAVE6_ARUSER        ( SLAVE6_ARUSER ),
  .SLAVE6_ARVALID       ( SLAVE6_ARVALID ),
  .SLAVE6_ARREADY       ( SLAVE6_ARREADY ),
  
  .SLAVE7_ARID          ( SLAVE7_ARID ),
  .SLAVE7_ARADDR        ( SLAVE7_ARADDR ),
  .SLAVE7_ARLEN         ( SLAVE7_ARLEN ),
  .SLAVE7_ARSIZE        ( SLAVE7_ARSIZE ),
  .SLAVE7_ARBURST       ( SLAVE7_ARBURST ),
  .SLAVE7_ARLOCK        ( SLAVE7_ARLOCK ),
  .SLAVE7_ARCACHE       ( SLAVE7_ARCACHE ),
  .SLAVE7_ARPROT        ( SLAVE7_ARPROT ),
  .SLAVE7_ARREGION      ( SLAVE7_ARREGION ),      // not used
  .SLAVE7_ARQOS         ( SLAVE7_ARQOS ),        // not used
  .SLAVE7_ARUSER        ( SLAVE7_ARUSER ),
  .SLAVE7_ARVALID       ( SLAVE7_ARVALID ),
  .SLAVE7_ARREADY       ( SLAVE7_ARREADY ),
  
  .SLAVE8_ARID          ( SLAVE8_ARID ),
  .SLAVE8_ARADDR        ( SLAVE8_ARADDR ),
  .SLAVE8_ARLEN         ( SLAVE8_ARLEN ),
  .SLAVE8_ARSIZE        ( SLAVE8_ARSIZE ),
  .SLAVE8_ARBURST       ( SLAVE8_ARBURST ),
  .SLAVE8_ARLOCK        ( SLAVE8_ARLOCK ),
  .SLAVE8_ARCACHE       ( SLAVE8_ARCACHE ),
  .SLAVE8_ARPROT        ( SLAVE8_ARPROT ),
  .SLAVE8_ARREGION      ( SLAVE8_ARREGION ),      // not used
  .SLAVE8_ARQOS         ( SLAVE8_ARQOS ),        // not used
  .SLAVE8_ARUSER        ( SLAVE8_ARUSER ),
  .SLAVE8_ARVALID       ( SLAVE8_ARVALID ),
  .SLAVE8_ARREADY       ( SLAVE8_ARREADY ),
 
  .SLAVE9_ARID          ( SLAVE9_ARID ),
  .SLAVE9_ARADDR        ( SLAVE9_ARADDR ),
  .SLAVE9_ARLEN         ( SLAVE9_ARLEN ),
  .SLAVE9_ARSIZE        ( SLAVE9_ARSIZE ),
  .SLAVE9_ARBURST       ( SLAVE9_ARBURST ),
  .SLAVE9_ARLOCK        ( SLAVE9_ARLOCK ),
  .SLAVE9_ARCACHE       ( SLAVE9_ARCACHE ),
  .SLAVE9_ARPROT        ( SLAVE9_ARPROT ),
  .SLAVE9_ARREGION      ( SLAVE9_ARREGION ),      // not used
  .SLAVE9_ARQOS         ( SLAVE9_ARQOS ),        // not used
  .SLAVE9_ARUSER        ( SLAVE9_ARUSER ),
  .SLAVE9_ARVALID       ( SLAVE9_ARVALID ),
  .SLAVE9_ARREADY       ( SLAVE9_ARREADY ),

  .SLAVE10_ARID         ( SLAVE10_ARID ),
  .SLAVE10_ARADDR       ( SLAVE10_ARADDR ),
  .SLAVE10_ARLEN        ( SLAVE10_ARLEN ),
  .SLAVE10_ARSIZE       ( SLAVE10_ARSIZE ),
  .SLAVE10_ARBURST      ( SLAVE10_ARBURST ),
  .SLAVE10_ARLOCK       ( SLAVE10_ARLOCK ),
  .SLAVE10_ARCACHE      ( SLAVE10_ARCACHE ),
  .SLAVE10_ARPROT       ( SLAVE10_ARPROT ),
  .SLAVE10_ARREGION     ( SLAVE10_ARREGION ),      // not used
  .SLAVE10_ARQOS        ( SLAVE10_ARQOS ),        // not used
  .SLAVE10_ARUSER       ( SLAVE10_ARUSER ),
  .SLAVE10_ARVALID      ( SLAVE10_ARVALID ),
  .SLAVE10_ARREADY      ( SLAVE10_ARREADY ),

  .SLAVE11_ARID         ( SLAVE11_ARID ),
  .SLAVE11_ARADDR       ( SLAVE11_ARADDR ),
  .SLAVE11_ARLEN        ( SLAVE11_ARLEN ),
  .SLAVE11_ARSIZE       ( SLAVE11_ARSIZE ),
  .SLAVE11_ARBURST      ( SLAVE11_ARBURST ),
  .SLAVE11_ARLOCK       ( SLAVE11_ARLOCK ),
  .SLAVE11_ARCACHE      ( SLAVE11_ARCACHE ),
  .SLAVE11_ARPROT       ( SLAVE11_ARPROT ),
  .SLAVE11_ARREGION     ( SLAVE11_ARREGION ),      // not used
  .SLAVE11_ARQOS        ( SLAVE11_ARQOS ),        // not used
  .SLAVE11_ARUSER       ( SLAVE11_ARUSER ),
  .SLAVE11_ARVALID      ( SLAVE11_ARVALID ),
  .SLAVE11_ARREADY      ( SLAVE11_ARREADY ),

  .SLAVE12_ARID         ( SLAVE12_ARID ),
  .SLAVE12_ARADDR       ( SLAVE12_ARADDR ),
  .SLAVE12_ARLEN        ( SLAVE12_ARLEN ),
  .SLAVE12_ARSIZE       ( SLAVE12_ARSIZE ),
  .SLAVE12_ARBURST      ( SLAVE12_ARBURST ),
  .SLAVE12_ARLOCK       ( SLAVE12_ARLOCK ),
  .SLAVE12_ARCACHE      ( SLAVE12_ARCACHE ),
  .SLAVE12_ARPROT       ( SLAVE12_ARPROT ),
  .SLAVE12_ARREGION     ( SLAVE12_ARREGION ),      // not used
  .SLAVE12_ARQOS        ( SLAVE12_ARQOS ),        // not used
  .SLAVE12_ARUSER       ( SLAVE12_ARUSER ),
  .SLAVE12_ARVALID      ( SLAVE12_ARVALID ),
  .SLAVE12_ARREADY      ( SLAVE12_ARREADY ),

  .SLAVE13_ARID         ( SLAVE13_ARID ),
  .SLAVE13_ARADDR       ( SLAVE13_ARADDR ),
  .SLAVE13_ARLEN        ( SLAVE13_ARLEN ),
  .SLAVE13_ARSIZE       ( SLAVE13_ARSIZE ),
  .SLAVE13_ARBURST      ( SLAVE13_ARBURST ),
  .SLAVE13_ARLOCK       ( SLAVE13_ARLOCK ),
  .SLAVE13_ARCACHE      ( SLAVE13_ARCACHE ),
  .SLAVE13_ARPROT       ( SLAVE13_ARPROT ),
  .SLAVE13_ARREGION     ( SLAVE13_ARREGION ),      // not used
  .SLAVE13_ARQOS        ( SLAVE13_ARQOS ),        // not used
  .SLAVE13_ARUSER       ( SLAVE13_ARUSER ),
  .SLAVE13_ARVALID      ( SLAVE13_ARVALID ),
  .SLAVE13_ARREADY      ( SLAVE13_ARREADY ),
  
  .SLAVE14_ARID         ( SLAVE14_ARID ),
  .SLAVE14_ARADDR       ( SLAVE14_ARADDR ),
  .SLAVE14_ARLEN        ( SLAVE14_ARLEN ),
  .SLAVE14_ARSIZE       ( SLAVE14_ARSIZE ),
  .SLAVE14_ARBURST      ( SLAVE14_ARBURST ),
  .SLAVE14_ARLOCK       ( SLAVE14_ARLOCK ),
  .SLAVE14_ARCACHE      ( SLAVE14_ARCACHE ),
  .SLAVE14_ARPROT       ( SLAVE14_ARPROT ),
  .SLAVE14_ARREGION     ( SLAVE14_ARREGION ),      // not used
  .SLAVE14_ARQOS        ( SLAVE14_ARQOS ),        // not used
  .SLAVE14_ARUSER       ( SLAVE14_ARUSER ),
  .SLAVE14_ARVALID      ( SLAVE14_ARVALID ),
  .SLAVE14_ARREADY      ( SLAVE14_ARREADY ),
  
  .SLAVE15_ARID         ( SLAVE15_ARID ),
  .SLAVE15_ARADDR       ( SLAVE15_ARADDR ),
  .SLAVE15_ARLEN        ( SLAVE15_ARLEN ),
  .SLAVE15_ARSIZE       ( SLAVE15_ARSIZE ),
  .SLAVE15_ARBURST      ( SLAVE15_ARBURST ),
  .SLAVE15_ARLOCK       ( SLAVE15_ARLOCK ),
  .SLAVE15_ARCACHE      ( SLAVE15_ARCACHE ),
  .SLAVE15_ARPROT       ( SLAVE15_ARPROT ),
  .SLAVE15_ARREGION     ( SLAVE15_ARREGION ),      // not used
  .SLAVE15_ARQOS        ( SLAVE15_ARQOS ),        // not used
  .SLAVE15_ARUSER       ( SLAVE15_ARUSER ),
  .SLAVE15_ARVALID      ( SLAVE15_ARVALID ),
  .SLAVE15_ARREADY      ( SLAVE15_ARREADY ),
  
  .SLAVE16_ARID         ( SLAVE16_ARID ),
  .SLAVE16_ARADDR       ( SLAVE16_ARADDR ),
  .SLAVE16_ARLEN        ( SLAVE16_ARLEN ),
  .SLAVE16_ARSIZE       ( SLAVE16_ARSIZE ),
  .SLAVE16_ARBURST      ( SLAVE16_ARBURST ),
  .SLAVE16_ARLOCK       ( SLAVE16_ARLOCK ),
  .SLAVE16_ARCACHE      ( SLAVE16_ARCACHE ),
  .SLAVE16_ARPROT       ( SLAVE16_ARPROT ),
  .SLAVE16_ARREGION     ( SLAVE16_ARREGION ),      // not used
  .SLAVE16_ARQOS        ( SLAVE16_ARQOS ),        // not used
  .SLAVE16_ARUSER       ( SLAVE16_ARUSER ),
  .SLAVE16_ARVALID      ( SLAVE16_ARVALID ),
  .SLAVE16_ARREADY      ( SLAVE16_ARREADY ),
 
  .SLAVE17_ARID         ( SLAVE17_ARID ),
  .SLAVE17_ARADDR       ( SLAVE17_ARADDR ),
  .SLAVE17_ARLEN        ( SLAVE17_ARLEN ),
  .SLAVE17_ARSIZE       ( SLAVE17_ARSIZE ),
  .SLAVE17_ARBURST      ( SLAVE17_ARBURST ),
  .SLAVE17_ARLOCK       ( SLAVE17_ARLOCK ),
  .SLAVE17_ARCACHE      ( SLAVE17_ARCACHE ),
  .SLAVE17_ARPROT       ( SLAVE17_ARPROT ),
  .SLAVE17_ARREGION     ( SLAVE17_ARREGION ),      // not used
  .SLAVE17_ARQOS        ( SLAVE17_ARQOS ),        // not used
  .SLAVE17_ARUSER       ( SLAVE17_ARUSER ),
  .SLAVE17_ARVALID      ( SLAVE17_ARVALID ),
  .SLAVE17_ARREADY      ( SLAVE17_ARREADY ),

  .SLAVE18_ARID         ( SLAVE18_ARID ),
  .SLAVE18_ARADDR       ( SLAVE18_ARADDR ),
  .SLAVE18_ARLEN        ( SLAVE18_ARLEN ),
  .SLAVE18_ARSIZE       ( SLAVE18_ARSIZE ),
  .SLAVE18_ARBURST      ( SLAVE18_ARBURST ),
  .SLAVE18_ARLOCK       ( SLAVE18_ARLOCK ),
  .SLAVE18_ARCACHE      ( SLAVE18_ARCACHE ),
  .SLAVE18_ARPROT       ( SLAVE18_ARPROT ),
  .SLAVE18_ARREGION     ( SLAVE18_ARREGION ),      // not used
  .SLAVE18_ARQOS        ( SLAVE18_ARQOS ),        // not used
  .SLAVE18_ARUSER       ( SLAVE18_ARUSER ),
  .SLAVE18_ARVALID      ( SLAVE18_ARVALID ),
  .SLAVE18_ARREADY      ( SLAVE18_ARREADY ),

  .SLAVE19_ARID         ( SLAVE19_ARID ),
  .SLAVE19_ARADDR       ( SLAVE19_ARADDR ),
  .SLAVE19_ARLEN        ( SLAVE19_ARLEN ),
  .SLAVE19_ARSIZE       ( SLAVE19_ARSIZE ),
  .SLAVE19_ARBURST      ( SLAVE19_ARBURST ),
  .SLAVE19_ARLOCK       ( SLAVE19_ARLOCK ),
  .SLAVE19_ARCACHE      ( SLAVE19_ARCACHE ),
  .SLAVE19_ARPROT       ( SLAVE19_ARPROT ),
  .SLAVE19_ARREGION     ( SLAVE19_ARREGION ),      // not used
  .SLAVE19_ARQOS        ( SLAVE19_ARQOS ),        // not used
  .SLAVE19_ARUSER       ( SLAVE19_ARUSER ),
  .SLAVE19_ARVALID      ( SLAVE19_ARVALID ),
  .SLAVE19_ARREADY      ( SLAVE19_ARREADY ),

  .SLAVE20_ARID         ( SLAVE20_ARID ),
  .SLAVE20_ARADDR       ( SLAVE20_ARADDR ),
  .SLAVE20_ARLEN        ( SLAVE20_ARLEN ),
  .SLAVE20_ARSIZE       ( SLAVE20_ARSIZE ),
  .SLAVE20_ARBURST      ( SLAVE20_ARBURST ),
  .SLAVE20_ARLOCK       ( SLAVE20_ARLOCK ),
  .SLAVE20_ARCACHE      ( SLAVE20_ARCACHE ),
  .SLAVE20_ARPROT       ( SLAVE20_ARPROT ),
  .SLAVE20_ARREGION     ( SLAVE20_ARREGION ),      // not used
  .SLAVE20_ARQOS        ( SLAVE20_ARQOS ),        // not used
  .SLAVE20_ARUSER       ( SLAVE20_ARUSER ),
  .SLAVE20_ARVALID      ( SLAVE20_ARVALID ),
  .SLAVE20_ARREADY      ( SLAVE20_ARREADY ),

  .SLAVE21_ARID         ( SLAVE21_ARID ),
  .SLAVE21_ARADDR       ( SLAVE21_ARADDR ),
  .SLAVE21_ARLEN        ( SLAVE21_ARLEN ),
  .SLAVE21_ARSIZE       ( SLAVE21_ARSIZE ),
  .SLAVE21_ARBURST      ( SLAVE21_ARBURST ),
  .SLAVE21_ARLOCK       ( SLAVE21_ARLOCK ),
  .SLAVE21_ARCACHE      ( SLAVE21_ARCACHE ),
  .SLAVE21_ARPROT       ( SLAVE21_ARPROT ),
  .SLAVE21_ARREGION     ( SLAVE21_ARREGION ),      // not used
  .SLAVE21_ARQOS        ( SLAVE21_ARQOS ),        // not used
  .SLAVE21_ARUSER       ( SLAVE21_ARUSER ),
  .SLAVE21_ARVALID      ( SLAVE21_ARVALID ),
  .SLAVE21_ARREADY      ( SLAVE21_ARREADY ),
  
  .SLAVE22_ARID         ( SLAVE22_ARID ),
  .SLAVE22_ARADDR       ( SLAVE22_ARADDR ),
  .SLAVE22_ARLEN        ( SLAVE22_ARLEN ),
  .SLAVE22_ARSIZE       ( SLAVE22_ARSIZE ),
  .SLAVE22_ARBURST      ( SLAVE22_ARBURST ),
  .SLAVE22_ARLOCK       ( SLAVE22_ARLOCK ),
  .SLAVE22_ARCACHE      ( SLAVE22_ARCACHE ),
  .SLAVE22_ARPROT       ( SLAVE22_ARPROT ),
  .SLAVE22_ARREGION     ( SLAVE22_ARREGION ),      // not used
  .SLAVE22_ARQOS        ( SLAVE22_ARQOS ),        // not used
  .SLAVE22_ARUSER       ( SLAVE22_ARUSER ),
  .SLAVE22_ARVALID      ( SLAVE22_ARVALID ),
  .SLAVE22_ARREADY      ( SLAVE22_ARREADY ),
  
  .SLAVE23_ARID         ( SLAVE23_ARID ),
  .SLAVE23_ARADDR       ( SLAVE23_ARADDR ),
  .SLAVE23_ARLEN        ( SLAVE23_ARLEN ),
  .SLAVE23_ARSIZE       ( SLAVE23_ARSIZE ),
  .SLAVE23_ARBURST      ( SLAVE23_ARBURST ),
  .SLAVE23_ARLOCK       ( SLAVE23_ARLOCK ),
  .SLAVE23_ARCACHE      ( SLAVE23_ARCACHE ),
  .SLAVE23_ARPROT       ( SLAVE23_ARPROT ),
  .SLAVE23_ARREGION     ( SLAVE23_ARREGION ),      // not used
  .SLAVE23_ARQOS        ( SLAVE23_ARQOS ),        // not used
  .SLAVE23_ARUSER       ( SLAVE23_ARUSER ),
  .SLAVE23_ARVALID      ( SLAVE23_ARVALID ),
  .SLAVE23_ARREADY      ( SLAVE23_ARREADY ),
  
  .SLAVE24_ARID         ( SLAVE24_ARID ),
  .SLAVE24_ARADDR       ( SLAVE24_ARADDR ),
  .SLAVE24_ARLEN        ( SLAVE24_ARLEN ),
  .SLAVE24_ARSIZE       ( SLAVE24_ARSIZE ),
  .SLAVE24_ARBURST      ( SLAVE24_ARBURST ),
  .SLAVE24_ARLOCK       ( SLAVE24_ARLOCK ),
  .SLAVE24_ARCACHE      ( SLAVE24_ARCACHE ),
  .SLAVE24_ARPROT       ( SLAVE24_ARPROT ),
  .SLAVE24_ARREGION     ( SLAVE24_ARREGION ),      // not used
  .SLAVE24_ARQOS        ( SLAVE24_ARQOS ),        // not used
  .SLAVE24_ARUSER       ( SLAVE24_ARUSER ),
  .SLAVE24_ARVALID      ( SLAVE24_ARVALID ),
  .SLAVE24_ARREADY      ( SLAVE24_ARREADY ),
 
  .SLAVE25_ARID         ( SLAVE25_ARID ),
  .SLAVE25_ARADDR       ( SLAVE25_ARADDR ),
  .SLAVE25_ARLEN        ( SLAVE25_ARLEN ),
  .SLAVE25_ARSIZE       ( SLAVE25_ARSIZE ),
  .SLAVE25_ARBURST      ( SLAVE25_ARBURST ),
  .SLAVE25_ARLOCK       ( SLAVE25_ARLOCK ),
  .SLAVE25_ARCACHE      ( SLAVE25_ARCACHE ),
  .SLAVE25_ARPROT       ( SLAVE25_ARPROT ),
  .SLAVE25_ARREGION     ( SLAVE25_ARREGION ),      // not used
  .SLAVE25_ARQOS        ( SLAVE25_ARQOS ),        // not used
  .SLAVE25_ARUSER       ( SLAVE25_ARUSER ),
  .SLAVE25_ARVALID      ( SLAVE25_ARVALID ),
  .SLAVE25_ARREADY      ( SLAVE25_ARREADY ),

  .SLAVE26_ARID         ( SLAVE26_ARID ),
  .SLAVE26_ARADDR       ( SLAVE26_ARADDR ),
  .SLAVE26_ARLEN        ( SLAVE26_ARLEN ),
  .SLAVE26_ARSIZE       ( SLAVE26_ARSIZE ),
  .SLAVE26_ARBURST      ( SLAVE26_ARBURST ),
  .SLAVE26_ARLOCK       ( SLAVE26_ARLOCK ),
  .SLAVE26_ARCACHE      ( SLAVE26_ARCACHE ),
  .SLAVE26_ARPROT       ( SLAVE26_ARPROT ),
  .SLAVE26_ARREGION     ( SLAVE26_ARREGION ),      // not used
  .SLAVE26_ARQOS        ( SLAVE26_ARQOS ),        // not used
  .SLAVE26_ARUSER       ( SLAVE26_ARUSER ),
  .SLAVE26_ARVALID      ( SLAVE26_ARVALID ),
  .SLAVE26_ARREADY      ( SLAVE26_ARREADY ),

  .SLAVE27_ARID         ( SLAVE27_ARID ),
  .SLAVE27_ARADDR       ( SLAVE27_ARADDR ),
  .SLAVE27_ARLEN        ( SLAVE27_ARLEN ),
  .SLAVE27_ARSIZE       ( SLAVE27_ARSIZE ),
  .SLAVE27_ARBURST      ( SLAVE27_ARBURST ),
  .SLAVE27_ARLOCK       ( SLAVE27_ARLOCK ),
  .SLAVE27_ARCACHE      ( SLAVE27_ARCACHE ),
  .SLAVE27_ARPROT       ( SLAVE27_ARPROT ),
  .SLAVE27_ARREGION     ( SLAVE27_ARREGION ),      // not used
  .SLAVE27_ARQOS        ( SLAVE27_ARQOS ),        // not used
  .SLAVE27_ARUSER       ( SLAVE27_ARUSER ),
  .SLAVE27_ARVALID      ( SLAVE27_ARVALID ),
  .SLAVE27_ARREADY      ( SLAVE27_ARREADY ),

  .SLAVE28_ARID         ( SLAVE28_ARID ),
  .SLAVE28_ARADDR       ( SLAVE28_ARADDR ),
  .SLAVE28_ARLEN        ( SLAVE28_ARLEN ),
  .SLAVE28_ARSIZE       ( SLAVE28_ARSIZE ),
  .SLAVE28_ARBURST      ( SLAVE28_ARBURST ),
  .SLAVE28_ARLOCK       ( SLAVE28_ARLOCK ),
  .SLAVE28_ARCACHE      ( SLAVE28_ARCACHE ),
  .SLAVE28_ARPROT       ( SLAVE28_ARPROT ),
  .SLAVE28_ARREGION     ( SLAVE28_ARREGION ),      // not used
  .SLAVE28_ARQOS        ( SLAVE28_ARQOS ),        // not used
  .SLAVE28_ARUSER       ( SLAVE28_ARUSER ),
  .SLAVE28_ARVALID      ( SLAVE28_ARVALID ),
  .SLAVE28_ARREADY      ( SLAVE28_ARREADY ),

  .SLAVE29_ARID         ( SLAVE29_ARID ),
  .SLAVE29_ARADDR       ( SLAVE29_ARADDR ),
  .SLAVE29_ARLEN        ( SLAVE29_ARLEN ),
  .SLAVE29_ARSIZE       ( SLAVE29_ARSIZE ),
  .SLAVE29_ARBURST      ( SLAVE29_ARBURST ),
  .SLAVE29_ARLOCK       ( SLAVE29_ARLOCK ),
  .SLAVE29_ARCACHE      ( SLAVE29_ARCACHE ),
  .SLAVE29_ARPROT       ( SLAVE29_ARPROT ),
  .SLAVE29_ARREGION     ( SLAVE29_ARREGION ),      // not used
  .SLAVE29_ARQOS        ( SLAVE29_ARQOS ),        // not used
  .SLAVE29_ARUSER       ( SLAVE29_ARUSER ),
  .SLAVE29_ARVALID      ( SLAVE29_ARVALID ),
  .SLAVE29_ARREADY      ( SLAVE29_ARREADY ),
  
  .SLAVE30_ARID         ( SLAVE30_ARID ),
  .SLAVE30_ARADDR       ( SLAVE30_ARADDR ),
  .SLAVE30_ARLEN        ( SLAVE30_ARLEN ),
  .SLAVE30_ARSIZE       ( SLAVE30_ARSIZE ),
  .SLAVE30_ARBURST      ( SLAVE30_ARBURST ),
  .SLAVE30_ARLOCK       ( SLAVE30_ARLOCK ),
  .SLAVE30_ARCACHE      ( SLAVE30_ARCACHE ),
  .SLAVE30_ARPROT       ( SLAVE30_ARPROT ),
  .SLAVE30_ARREGION     ( SLAVE30_ARREGION ),      // not used
  .SLAVE30_ARQOS        ( SLAVE30_ARQOS ),        // not used
  .SLAVE30_ARUSER       ( SLAVE30_ARUSER ),
  .SLAVE30_ARVALID      ( SLAVE30_ARVALID ),
  .SLAVE30_ARREADY      ( SLAVE30_ARREADY ),
  
  .SLAVE31_ARID         ( SLAVE31_ARID ),
  .SLAVE31_ARADDR       ( SLAVE31_ARADDR ),
  .SLAVE31_ARLEN        ( SLAVE31_ARLEN ),
  .SLAVE31_ARSIZE       ( SLAVE31_ARSIZE ),
  .SLAVE31_ARBURST      ( SLAVE31_ARBURST ),
  .SLAVE31_ARLOCK       ( SLAVE31_ARLOCK ),
  .SLAVE31_ARCACHE      ( SLAVE31_ARCACHE ),
  .SLAVE31_ARPROT       ( SLAVE31_ARPROT ),
  .SLAVE31_ARREGION     ( SLAVE31_ARREGION ),      // not used
  .SLAVE31_ARQOS        ( SLAVE31_ARQOS ),        // not used
  .SLAVE31_ARUSER       ( SLAVE31_ARUSER ),
  .SLAVE31_ARVALID      ( SLAVE31_ARVALID ),
  .SLAVE31_ARREADY      ( SLAVE31_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE0_RID          ( SLAVE0_RID ),
  .SLAVE0_RDATA        ( SLAVE0_RDATA ),
  .SLAVE0_RRESP        ( SLAVE0_RRESP ),
  .SLAVE0_RLAST        ( SLAVE0_RLAST ),
  .SLAVE0_RUSER        ( SLAVE0_RUSER ),      // not used
  .SLAVE0_RVALID       ( SLAVE0_RVALID ),
  .SLAVE0_RREADY       ( SLAVE0_RREADY ),
   
  .SLAVE1_RID          ( SLAVE1_RID ),
  .SLAVE1_RDATA        ( SLAVE1_RDATA ),
  .SLAVE1_RRESP        ( SLAVE1_RRESP ),
  .SLAVE1_RLAST        ( SLAVE1_RLAST ),
  .SLAVE1_RUSER        ( SLAVE1_RUSER ),      // not used
  .SLAVE1_RVALID       ( SLAVE1_RVALID ),
  .SLAVE1_RREADY       ( SLAVE1_RREADY ),
   
  .SLAVE2_RID          ( SLAVE2_RID ),
  .SLAVE2_RDATA        ( SLAVE2_RDATA ),
  .SLAVE2_RRESP        ( SLAVE2_RRESP ),
  .SLAVE2_RLAST        ( SLAVE2_RLAST ),
  .SLAVE2_RUSER        ( SLAVE2_RUSER ),      // not used
  .SLAVE2_RVALID       ( SLAVE2_RVALID ),
  .SLAVE2_RREADY       ( SLAVE2_RREADY ),  
 
  .SLAVE3_RID          ( SLAVE3_RID ),
  .SLAVE3_RDATA        ( SLAVE3_RDATA ),
  .SLAVE3_RRESP        ( SLAVE3_RRESP ),
  .SLAVE3_RLAST        ( SLAVE3_RLAST ),
  .SLAVE3_RUSER        ( SLAVE3_RUSER ),      // not used
  .SLAVE3_RVALID       ( SLAVE3_RVALID ),
  .SLAVE3_RREADY       ( SLAVE3_RREADY ),
   
  .SLAVE4_RID          ( SLAVE4_RID ),
  .SLAVE4_RDATA        ( SLAVE4_RDATA ),
  .SLAVE4_RRESP        ( SLAVE4_RRESP ),
  .SLAVE4_RLAST        ( SLAVE4_RLAST ),
  .SLAVE4_RUSER        ( SLAVE4_RUSER ),      // not used
  .SLAVE4_RVALID       ( SLAVE4_RVALID ),
  .SLAVE4_RREADY       ( SLAVE4_RREADY ),
   
  .SLAVE5_RID          ( SLAVE5_RID ),
  .SLAVE5_RDATA        ( SLAVE5_RDATA ),
  .SLAVE5_RRESP        ( SLAVE5_RRESP ),
  .SLAVE5_RLAST        ( SLAVE5_RLAST ),
  .SLAVE5_RUSER        ( SLAVE5_RUSER ),      // not used
  .SLAVE5_RVALID       ( SLAVE5_RVALID ),
  .SLAVE5_RREADY       ( SLAVE5_RREADY ),
   
  .SLAVE6_RID          ( SLAVE6_RID ),
  .SLAVE6_RDATA        ( SLAVE6_RDATA ),
  .SLAVE6_RRESP        ( SLAVE6_RRESP ),
  .SLAVE6_RLAST        ( SLAVE6_RLAST ),
  .SLAVE6_RUSER        ( SLAVE6_RUSER ),      // not used
  .SLAVE6_RVALID       ( SLAVE6_RVALID ),
  .SLAVE6_RREADY       ( SLAVE6_RREADY ),
   
  .SLAVE7_RID          ( SLAVE7_RID ),
  .SLAVE7_RDATA        ( SLAVE7_RDATA ),
  .SLAVE7_RRESP        ( SLAVE7_RRESP ),
  .SLAVE7_RLAST        ( SLAVE7_RLAST ),
  .SLAVE7_RUSER        ( SLAVE7_RUSER ),      // not used
  .SLAVE7_RVALID       ( SLAVE7_RVALID ),
  .SLAVE7_RREADY       ( SLAVE7_RREADY ),
   
  .SLAVE8_RID          ( SLAVE8_RID ),
  .SLAVE8_RDATA        ( SLAVE8_RDATA ),
  .SLAVE8_RRESP        ( SLAVE8_RRESP ),
  .SLAVE8_RLAST        ( SLAVE8_RLAST ),
  .SLAVE8_RUSER        ( SLAVE8_RUSER ),      // not used
  .SLAVE8_RVALID       ( SLAVE8_RVALID ),
  .SLAVE8_RREADY       ( SLAVE8_RREADY ),
   
  .SLAVE9_RID          ( SLAVE9_RID ),
  .SLAVE9_RDATA        ( SLAVE9_RDATA ),
  .SLAVE9_RRESP        ( SLAVE9_RRESP ),
  .SLAVE9_RLAST        ( SLAVE9_RLAST ),
  .SLAVE9_RUSER        ( SLAVE9_RUSER ),      // not used
  .SLAVE9_RVALID       ( SLAVE9_RVALID ),
  .SLAVE9_RREADY       ( SLAVE9_RREADY ),  
 
  .SLAVE10_RID         ( SLAVE10_RID ),
  .SLAVE10_RDATA       ( SLAVE10_RDATA ),
  .SLAVE10_RRESP       ( SLAVE10_RRESP ),
  .SLAVE10_RLAST       ( SLAVE10_RLAST ),
  .SLAVE10_RUSER       ( SLAVE10_RUSER ),      // not used
  .SLAVE10_RVALID      ( SLAVE10_RVALID ),
  .SLAVE10_RREADY      ( SLAVE10_RREADY ),
   
  .SLAVE11_RID         ( SLAVE11_RID ),
  .SLAVE11_RDATA       ( SLAVE11_RDATA ),
  .SLAVE11_RRESP       ( SLAVE11_RRESP ),
  .SLAVE11_RLAST       ( SLAVE11_RLAST ),
  .SLAVE11_RUSER       ( SLAVE11_RUSER ),      // not used
  .SLAVE11_RVALID      ( SLAVE11_RVALID ),
  .SLAVE11_RREADY      ( SLAVE11_RREADY ),
   
  .SLAVE12_RID         ( SLAVE12_RID ),
  .SLAVE12_RDATA       ( SLAVE12_RDATA ),
  .SLAVE12_RRESP       ( SLAVE12_RRESP ),
  .SLAVE12_RLAST       ( SLAVE12_RLAST ),
  .SLAVE12_RUSER       ( SLAVE12_RUSER ),      // not used
  .SLAVE12_RVALID      ( SLAVE12_RVALID ),
  .SLAVE12_RREADY      ( SLAVE12_RREADY ),
   
  .SLAVE13_RID         ( SLAVE13_RID ),
  .SLAVE13_RDATA       ( SLAVE13_RDATA ),
  .SLAVE13_RRESP       ( SLAVE13_RRESP ),
  .SLAVE13_RLAST       ( SLAVE13_RLAST ),
  .SLAVE13_RUSER       ( SLAVE13_RUSER ),      // not used
  .SLAVE13_RVALID      ( SLAVE13_RVALID ),
  .SLAVE13_RREADY      ( SLAVE13_RREADY ),
   
  .SLAVE14_RID         ( SLAVE14_RID ),
  .SLAVE14_RDATA       ( SLAVE14_RDATA ),
  .SLAVE14_RRESP       ( SLAVE14_RRESP ),
  .SLAVE14_RLAST       ( SLAVE14_RLAST ),
  .SLAVE14_RUSER       ( SLAVE14_RUSER ),      // not used
  .SLAVE14_RVALID      ( SLAVE14_RVALID ),
  .SLAVE14_RREADY      ( SLAVE14_RREADY ),
   
  .SLAVE15_RID         ( SLAVE15_RID ),
  .SLAVE15_RDATA       ( SLAVE15_RDATA ),
  .SLAVE15_RRESP       ( SLAVE15_RRESP ),
  .SLAVE15_RLAST       ( SLAVE15_RLAST ),
  .SLAVE15_RUSER       ( SLAVE15_RUSER ),      // not used
  .SLAVE15_RVALID      ( SLAVE15_RVALID ),
  .SLAVE15_RREADY      ( SLAVE15_RREADY ),
   
  .SLAVE16_RID         ( SLAVE16_RID ),
  .SLAVE16_RDATA       ( SLAVE16_RDATA ),
  .SLAVE16_RRESP       ( SLAVE16_RRESP ),
  .SLAVE16_RLAST       ( SLAVE16_RLAST ),
  .SLAVE16_RUSER       ( SLAVE16_RUSER ),      // not used
  .SLAVE16_RVALID      ( SLAVE16_RVALID ),
  .SLAVE16_RREADY      ( SLAVE16_RREADY ),  
 
  .SLAVE17_RID         ( SLAVE17_RID ),
  .SLAVE17_RDATA       ( SLAVE17_RDATA ),
  .SLAVE17_RRESP       ( SLAVE17_RRESP ),
  .SLAVE17_RLAST       ( SLAVE17_RLAST ),
  .SLAVE17_RUSER       ( SLAVE17_RUSER ),      // not used
  .SLAVE17_RVALID      ( SLAVE17_RVALID ),
  .SLAVE17_RREADY      ( SLAVE17_RREADY ),
   
  .SLAVE18_RID         ( SLAVE18_RID ),
  .SLAVE18_RDATA       ( SLAVE18_RDATA ),
  .SLAVE18_RRESP       ( SLAVE18_RRESP ),
  .SLAVE18_RLAST       ( SLAVE18_RLAST ),
  .SLAVE18_RUSER       ( SLAVE18_RUSER ),      // not used
  .SLAVE18_RVALID      ( SLAVE18_RVALID ),
  .SLAVE18_RREADY      ( SLAVE18_RREADY ),
   
  .SLAVE19_RID         ( SLAVE19_RID ),
  .SLAVE19_RDATA       ( SLAVE19_RDATA ),
  .SLAVE19_RRESP       ( SLAVE19_RRESP ),
  .SLAVE19_RLAST       ( SLAVE19_RLAST ),
  .SLAVE19_RUSER       ( SLAVE19_RUSER ),      // not used
  .SLAVE19_RVALID      ( SLAVE19_RVALID ),
  .SLAVE19_RREADY      ( SLAVE19_RREADY ),
   
  .SLAVE20_RID         ( SLAVE20_RID ),
  .SLAVE20_RDATA       ( SLAVE20_RDATA ),
  .SLAVE20_RRESP       ( SLAVE20_RRESP ),
  .SLAVE20_RLAST       ( SLAVE20_RLAST ),
  .SLAVE20_RUSER       ( SLAVE20_RUSER ),      // not used
  .SLAVE20_RVALID      ( SLAVE20_RVALID ),
  .SLAVE20_RREADY      ( SLAVE20_RREADY ),
   
  .SLAVE21_RID         ( SLAVE21_RID ),
  .SLAVE21_RDATA       ( SLAVE21_RDATA ),
  .SLAVE21_RRESP       ( SLAVE21_RRESP ),
  .SLAVE21_RLAST       ( SLAVE21_RLAST ),
  .SLAVE21_RUSER       ( SLAVE21_RUSER ),      // not used
  .SLAVE21_RVALID      ( SLAVE21_RVALID ),
  .SLAVE21_RREADY      ( SLAVE21_RREADY ),
   
  .SLAVE22_RID         ( SLAVE22_RID ),
  .SLAVE22_RDATA       ( SLAVE22_RDATA ),
  .SLAVE22_RRESP       ( SLAVE22_RRESP ),
  .SLAVE22_RLAST       ( SLAVE22_RLAST ),
  .SLAVE22_RUSER       ( SLAVE22_RUSER ),      // not used
  .SLAVE22_RVALID      ( SLAVE22_RVALID ),
  .SLAVE22_RREADY      ( SLAVE22_RREADY ),
   
  .SLAVE23_RID         ( SLAVE23_RID ),
  .SLAVE23_RDATA       ( SLAVE23_RDATA ),
  .SLAVE23_RRESP       ( SLAVE23_RRESP ),
  .SLAVE23_RLAST       ( SLAVE23_RLAST ),
  .SLAVE23_RUSER       ( SLAVE23_RUSER ),      // not used
  .SLAVE23_RVALID      ( SLAVE23_RVALID ),
  .SLAVE23_RREADY      ( SLAVE23_RREADY ),  
 
  .SLAVE24_RID         ( SLAVE24_RID ),
  .SLAVE24_RDATA       ( SLAVE24_RDATA ),
  .SLAVE24_RRESP       ( SLAVE24_RRESP ),
  .SLAVE24_RLAST       ( SLAVE24_RLAST ),
  .SLAVE24_RUSER       ( SLAVE24_RUSER ),      // not used
  .SLAVE24_RVALID      ( SLAVE24_RVALID ),
  .SLAVE24_RREADY      ( SLAVE24_RREADY ),
   
  .SLAVE25_RID         ( SLAVE25_RID ),
  .SLAVE25_RDATA       ( SLAVE25_RDATA ),
  .SLAVE25_RRESP       ( SLAVE25_RRESP ),
  .SLAVE25_RLAST       ( SLAVE25_RLAST ),
  .SLAVE25_RUSER       ( SLAVE25_RUSER ),      // not used
  .SLAVE25_RVALID      ( SLAVE25_RVALID ),
  .SLAVE25_RREADY      ( SLAVE25_RREADY ),
   
  .SLAVE26_RID         ( SLAVE26_RID ),
  .SLAVE26_RDATA       ( SLAVE26_RDATA ),
  .SLAVE26_RRESP       ( SLAVE26_RRESP ),
  .SLAVE26_RLAST       ( SLAVE26_RLAST ),
  .SLAVE26_RUSER       ( SLAVE26_RUSER ),      // not used
  .SLAVE26_RVALID      ( SLAVE26_RVALID ),
  .SLAVE26_RREADY      ( SLAVE26_RREADY ),
   
  .SLAVE27_RID         ( SLAVE27_RID ),
  .SLAVE27_RDATA       ( SLAVE27_RDATA ),
  .SLAVE27_RRESP       ( SLAVE27_RRESP ),
  .SLAVE27_RLAST       ( SLAVE27_RLAST ),
  .SLAVE27_RUSER       ( SLAVE27_RUSER ),      // not used
  .SLAVE27_RVALID      ( SLAVE27_RVALID ),
  .SLAVE27_RREADY      ( SLAVE27_RREADY ),
   
  .SLAVE28_RID         ( SLAVE28_RID ),
  .SLAVE28_RDATA       ( SLAVE28_RDATA ),
  .SLAVE28_RRESP       ( SLAVE28_RRESP ),
  .SLAVE28_RLAST       ( SLAVE28_RLAST ),
  .SLAVE28_RUSER       ( SLAVE28_RUSER ),      // not used
  .SLAVE28_RVALID      ( SLAVE28_RVALID ),
  .SLAVE28_RREADY      ( SLAVE28_RREADY ),

  .SLAVE29_RID         ( SLAVE29_RID ),
  .SLAVE29_RDATA       ( SLAVE29_RDATA ),
  .SLAVE29_RRESP       ( SLAVE29_RRESP ),
  .SLAVE29_RLAST       ( SLAVE29_RLAST ),
  .SLAVE29_RUSER       ( SLAVE29_RUSER ),      // not used
  .SLAVE29_RVALID      ( SLAVE29_RVALID ),
  .SLAVE29_RREADY      ( SLAVE29_RREADY ),
   
  .SLAVE30_RID         ( SLAVE30_RID ),
  .SLAVE30_RDATA       ( SLAVE30_RDATA ),
  .SLAVE30_RRESP       ( SLAVE30_RRESP ),
  .SLAVE30_RLAST       ( SLAVE30_RLAST ),
  .SLAVE30_RUSER       ( SLAVE30_RUSER ),      // not used
  .SLAVE30_RVALID      ( SLAVE30_RVALID ),
  .SLAVE30_RREADY      ( SLAVE30_RREADY ),
   
  .SLAVE31_RID         ( SLAVE31_RID ),
  .SLAVE31_RDATA       ( SLAVE31_RDATA ),
  .SLAVE31_RRESP       ( SLAVE31_RRESP ),
  .SLAVE31_RLAST       ( SLAVE31_RLAST ),
  .SLAVE31_RUSER       ( SLAVE31_RUSER ),      // not used
  .SLAVE31_RVALID      ( SLAVE31_RVALID ),
  .SLAVE31_RREADY      ( SLAVE31_RREADY )
  
  );

//====================================================================================================================================
// AXI4 Slave transactor models - one for each mirrored slave interface
//====================================================================================================================================  
  Axi4SlaveGen # 
        (
          .SLAVE_NUM              ( 0 ),             // defines slave port number
          .ID_WIDTH                ( MASTERID_WIDTH ), 
          .ADDR_WIDTH              ( ADDR_WIDTH ),
          .DATA_WIDTH             ( SLAVE0_DATA_WIDTH ),
          .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH             ( USER_WIDTH ),
          .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
          .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
        )
      slv0  (
          // Global Signals
          .sysClk         ( S_CLK[0] ),
          .ARESETN        ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

          // Slave Read Address Port
          .SLAVE_ARID      ( SLAVE0_ARID ),
          .SLAVE_ARADDR    ( SLAVE0_ARADDR ),
          .SLAVE_ARLEN    ( SLAVE0_ARLEN ),
          .SLAVE_ARSIZE    ( SLAVE0_ARSIZE ),
          .SLAVE_ARBURST  ( SLAVE0_ARBURST ),
          .SLAVE_ARLOCK    ( SLAVE0_ARLOCK ),
          .SLAVE_ARCACHE  ( SLAVE0_ARCACHE ),
          .SLAVE_ARPROT    ( SLAVE0_ARPROT ),
          .SLAVE_ARREGION  ( SLAVE0_ARREGION ),      // not used
          .SLAVE_ARQOS    ( SLAVE0_ARQOS ),        // not used
          .SLAVE_ARUSER    ( SLAVE0_ARUSER ),
          .SLAVE_ARVALID  ( SLAVE0_ARVALID ),
          .SLAVE_ARREADY  ( SLAVE0_ARREADY ),

          //====================== Slave Data Ports  ================================================//
          .SLAVE_RVALID    ( SLAVE0_RVALID ),
          .SLAVE_RID      ( SLAVE0_RID ),
          .SLAVE_RDATA    ( SLAVE0_RDATA ),
          .SLAVE_RRESP    ( SLAVE0_RRESP ),
          .SLAVE_RLAST    ( SLAVE0_RLAST ),
          .SLAVE_RUSER    ( SLAVE0_RUSER ),
          .SLAVE_RREADY    ( SLAVE0_RREADY ),

          //====================== Slave Write Address Ports  ================================================//
          .SLAVE_AWID      ( SLAVE0_AWID ),
          .SLAVE_AWADDR    ( SLAVE0_AWADDR ),
          .SLAVE_AWLEN    ( SLAVE0_AWLEN ),
          .SLAVE_AWSIZE    ( SLAVE0_AWSIZE ),
          .SLAVE_AWBURST  ( SLAVE0_AWBURST ),
          .SLAVE_AWLOCK    ( SLAVE0_AWLOCK ),
          .SLAVE_AWCACHE  ( SLAVE0_AWCACHE ),
          .SLAVE_AWPROT    ( SLAVE0_AWPROT ),
          .SLAVE_AWREGION  ( SLAVE0_AWREGION ),      // not used
          .SLAVE_AWQOS    ( SLAVE0_AWQOS ),        // not used
          .SLAVE_AWUSER    ( SLAVE0_AWUSER ),
          .SLAVE_AWVALID  ( SLAVE0_AWVALID ),
          .SLAVE_AWREADY  ( SLAVE0_AWREADY ),

          //===================== Slave Write Data Ports  ============================================//
          .SLAVE_WDATA    ( SLAVE0_WDATA ),
          .SLAVE_WSTRB    ( SLAVE0_WSTRB ),
          .SLAVE_WLAST    ( SLAVE0_WLAST ),
          .SLAVE_WUSER    ( SLAVE0_WUSER ),
          .SLAVE_WVALID   ( SLAVE0_WVALID ),
          .SLAVE_WREADY   ( SLAVE0_WREADY ),

          // ===============  Master Write Response Ports  =======================================//
          // Master Write Response Ports
          .SLAVE_BID      ( SLAVE0_BID ),
          .SLAVE_BRESP    ( SLAVE0_BRESP ),
          .SLAVE_BUSER    ( SLAVE0_BUSER ),
          .SLAVE_BVALID   ( SLAVE0_BVALID ),
          .SLAVE_BREADY   ( SLAVE0_BREADY ),

          // ===============  Control Signals  =======================================================//
          .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
          .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
          .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
          .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
          .FORCE_ERROR           ( FORCE_ERROR[0] ),              // Forces error pn read/write RESP
          .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
        );

  Axi4SlaveGen # 
        (
          .SLAVE_NUM              ( 1 ),             // defines slave port number
          .ID_WIDTH                ( MASTERID_WIDTH ), 
          .ADDR_WIDTH              ( ADDR_WIDTH ),
          .DATA_WIDTH             ( SLAVE1_DATA_WIDTH ),
          .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH             ( USER_WIDTH ),
          .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
          .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )

        )
      slv1  (
          // Global Signals
          .sysClk         ( S_CLK[1] ),
          .ARESETN        ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

          // Slave Read Address Port
          .SLAVE_ARID      ( SLAVE1_ARID ),
          .SLAVE_ARADDR    ( SLAVE1_ARADDR ),
          .SLAVE_ARLEN    ( SLAVE1_ARLEN ),
          .SLAVE_ARSIZE    ( SLAVE1_ARSIZE ),
          .SLAVE_ARBURST  ( SLAVE1_ARBURST ),
          .SLAVE_ARLOCK    ( SLAVE1_ARLOCK ),
          .SLAVE_ARCACHE  ( SLAVE1_ARCACHE ),
          .SLAVE_ARPROT    ( SLAVE1_ARPROT ),
          .SLAVE_ARREGION  ( SLAVE1_ARREGION ),      // not used
          .SLAVE_ARQOS    ( SLAVE1_ARQOS ),        // not used
          .SLAVE_ARUSER    ( SLAVE1_ARUSER ),
          .SLAVE_ARVALID  ( SLAVE1_ARVALID ),
          .SLAVE_ARREADY  ( SLAVE1_ARREADY ),

          //====================== Slave Data Ports  =================================================//
          .SLAVE_RVALID    ( SLAVE1_RVALID ),
          .SLAVE_RID      ( SLAVE1_RID ),
          .SLAVE_RDATA    ( SLAVE1_RDATA ),
          .SLAVE_RRESP    ( SLAVE1_RRESP ),
          .SLAVE_RLAST    ( SLAVE1_RLAST ),
          .SLAVE_RUSER    ( SLAVE1_RUSER ),
          .SLAVE_RREADY    ( SLAVE1_RREADY),

          //====================== Slave Write Address Ports  ========================================//
          .SLAVE_AWID      ( SLAVE1_AWID ),
          .SLAVE_AWADDR    ( SLAVE1_AWADDR ),
          .SLAVE_AWLEN    ( SLAVE1_AWLEN ),
          .SLAVE_AWSIZE    ( SLAVE1_AWSIZE ),
          .SLAVE_AWBURST  ( SLAVE1_AWBURST ),
          .SLAVE_AWLOCK    ( SLAVE1_AWLOCK ),
          .SLAVE_AWCACHE  ( SLAVE1_AWCACHE ),
          .SLAVE_AWPROT    ( SLAVE1_AWPROT ),
          .SLAVE_AWREGION  ( SLAVE1_AWREGION ),      // not used
          .SLAVE_AWQOS    ( SLAVE1_AWQOS ),        // not used
          .SLAVE_AWUSER    ( SLAVE1_AWUSER ),
          .SLAVE_AWVALID  ( SLAVE1_AWVALID ),
          .SLAVE_AWREADY  ( SLAVE1_AWREADY ),

          //===================== Slave Write Data Ports  ============================================//
          .SLAVE_WDATA    ( SLAVE1_WDATA ),
          .SLAVE_WSTRB    ( SLAVE1_WSTRB ),
          .SLAVE_WLAST    ( SLAVE1_WLAST ),
          .SLAVE_WUSER    ( SLAVE1_WUSER ),
          .SLAVE_WVALID   ( SLAVE1_WVALID ),
          .SLAVE_WREADY   ( SLAVE1_WREADY ),

          // ===============  Master Write Response Ports  ===========================================//
          .SLAVE_BID      ( SLAVE1_BID ),
          .SLAVE_BRESP    ( SLAVE1_BRESP ),
          .SLAVE_BUSER    ( SLAVE1_BUSER ),
          .SLAVE_BVALID   ( SLAVE1_BVALID ),
          .SLAVE_BREADY   ( SLAVE1_BREADY ),

          // ===============  Control Signals  =======================================================//
          .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
          .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
          .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
          .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
          .FORCE_ERROR           ( FORCE_ERROR[1] ),              // Forces error pn read/write RESP
          .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
        );

  Axi4SlaveGen # 
        (
          .SLAVE_NUM              ( 2 ),             // defines slave port number
          .ID_WIDTH               ( MASTERID_WIDTH ), 
          .ADDR_WIDTH              ( ADDR_WIDTH ),
          .DATA_WIDTH             ( SLAVE2_DATA_WIDTH ),
          .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH             ( USER_WIDTH ),
          .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
          .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
        )
      slv2  (
          // Global Signals
          .sysClk         ( S_CLK[2] ),
          .ARESETN        ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

          //====================== Slave Read Address Port  ==========================================//
          .SLAVE_ARID      ( SLAVE2_ARID ),
          .SLAVE_ARADDR    ( SLAVE2_ARADDR ),
          .SLAVE_ARLEN    ( SLAVE2_ARLEN ),
          .SLAVE_ARSIZE    ( SLAVE2_ARSIZE ),
          .SLAVE_ARBURST  ( SLAVE2_ARBURST ),
          .SLAVE_ARLOCK    ( SLAVE2_ARLOCK ),
          .SLAVE_ARCACHE  ( SLAVE2_ARCACHE ),
          .SLAVE_ARPROT    ( SLAVE2_ARPROT ),
          .SLAVE_ARREGION  ( SLAVE2_ARREGION ),      // not used
          .SLAVE_ARQOS    ( SLAVE2_ARQOS ),        // not used
          .SLAVE_ARUSER    ( SLAVE2_ARUSER ),
          .SLAVE_ARVALID  ( SLAVE2_ARVALID ),
          .SLAVE_ARREADY  ( SLAVE2_ARREADY ),

          //====================== Slave Data Ports  ================================================//
          .SLAVE_RVALID    ( SLAVE2_RVALID ),
          .SLAVE_RID      ( SLAVE2_RID ),
          .SLAVE_RDATA    ( SLAVE2_RDATA ),
          .SLAVE_RRESP    ( SLAVE2_RRESP ),
          .SLAVE_RLAST    ( SLAVE2_RLAST ),
          .SLAVE_RUSER    ( SLAVE2_RUSER ),
          .SLAVE_RREADY    ( SLAVE2_RREADY),

          //====================== Slave Write Address Ports  =======================================//
          .SLAVE_AWID      ( SLAVE2_AWID ),
          .SLAVE_AWADDR    ( SLAVE2_AWADDR ),
          .SLAVE_AWLEN    ( SLAVE2_AWLEN ),
          .SLAVE_AWSIZE    ( SLAVE2_AWSIZE ),
          .SLAVE_AWBURST  ( SLAVE2_AWBURST ),
          .SLAVE_AWLOCK    ( SLAVE2_AWLOCK ),
          .SLAVE_AWCACHE  ( SLAVE2_AWCACHE ),
          .SLAVE_AWPROT    ( SLAVE2_AWPROT ),
          .SLAVE_AWREGION  ( SLAVE2_AWREGION ),      // not used
          .SLAVE_AWQOS    ( SLAVE2_AWQOS ),        // not used
          .SLAVE_AWUSER    ( SLAVE2_AWUSER ),
          .SLAVE_AWVALID  ( SLAVE2_AWVALID ),
          .SLAVE_AWREADY  ( SLAVE2_AWREADY ),

          //===================== Slave Write Data Ports  ============================================//
          .SLAVE_WDATA    ( SLAVE2_WDATA ),
          .SLAVE_WSTRB    ( SLAVE2_WSTRB ),
          .SLAVE_WLAST    ( SLAVE2_WLAST ),
          .SLAVE_WUSER    ( SLAVE2_WUSER ),
          .SLAVE_WVALID   ( SLAVE2_WVALID ),
          .SLAVE_WREADY   ( SLAVE2_WREADY ),
          
          //===================== Master Write Response Ports  ============================================//
          .SLAVE_BID      ( SLAVE2_BID ),
          .SLAVE_BRESP    ( SLAVE2_BRESP ),
          .SLAVE_BUSER    ( SLAVE2_BUSER ),
          .SLAVE_BVALID   ( SLAVE2_BVALID ),
          .SLAVE_BREADY   ( SLAVE2_BREADY ),

          // ===============  Control Signals  =======================================================//
          .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
          .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
           .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
          .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
          .FORCE_ERROR           ( FORCE_ERROR[2] ),              // Forces error pn read/write RESP
          .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
        );


  Axi4SlaveGen # 
        (
          .SLAVE_NUM              ( 3 ),             // defines slave port number
          .ID_WIDTH               ( MASTERID_WIDTH ), 
          .ADDR_WIDTH              ( ADDR_WIDTH ),
          .DATA_WIDTH             ( SLAVE3_DATA_WIDTH ),
          .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH             ( USER_WIDTH ),
          .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
          .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
        )
      slv3  (
          // Global Signals
          .sysClk         ( S_CLK[3] ),
          .ARESETN        ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

          // Slave Read Address Port
          .SLAVE_ARID      ( SLAVE3_ARID ),
          .SLAVE_ARADDR    ( SLAVE3_ARADDR ),
          .SLAVE_ARLEN    ( SLAVE3_ARLEN ),
          .SLAVE_ARSIZE    ( SLAVE3_ARSIZE ),
          .SLAVE_ARBURST  ( SLAVE3_ARBURST ),
          .SLAVE_ARLOCK    ( SLAVE3_ARLOCK ),
          .SLAVE_ARCACHE  ( SLAVE3_ARCACHE ),
          .SLAVE_ARPROT    ( SLAVE3_ARPROT ),
          .SLAVE_ARREGION  ( SLAVE3_ARREGION ),      // not used
          .SLAVE_ARQOS    ( SLAVE3_ARQOS ),        // not used
          .SLAVE_ARUSER    ( SLAVE3_ARUSER ),
          .SLAVE_ARVALID  ( SLAVE3_ARVALID ),
          .SLAVE_ARREADY  ( SLAVE3_ARREADY ),

          //====================== Slave Data Ports  ================================================//
          .SLAVE_RVALID    ( SLAVE3_RVALID ),
          .SLAVE_RID      ( SLAVE3_RID ),
          .SLAVE_RDATA    ( SLAVE3_RDATA ),
          .SLAVE_RRESP    ( SLAVE3_RRESP ),
          .SLAVE_RLAST    ( SLAVE3_RLAST ),
          .SLAVE_RUSER    ( SLAVE3_RUSER ),
          .SLAVE_RREADY    ( SLAVE3_RREADY),   

          //====================== Slave Write Address Ports  ================================================//
          .SLAVE_AWID      ( SLAVE3_AWID ),
          .SLAVE_AWADDR    ( SLAVE3_AWADDR ),
          .SLAVE_AWLEN    ( SLAVE3_AWLEN ),
          .SLAVE_AWSIZE    ( SLAVE3_AWSIZE ),
          .SLAVE_AWBURST  ( SLAVE3_AWBURST ),
          .SLAVE_AWLOCK    ( SLAVE3_AWLOCK ),
          .SLAVE_AWCACHE  ( SLAVE3_AWCACHE ),
          .SLAVE_AWPROT    ( SLAVE3_AWPROT ),
          .SLAVE_AWREGION  ( SLAVE3_AWREGION ),      // not used
          .SLAVE_AWQOS    ( SLAVE3_AWQOS ),        // not used
          .SLAVE_AWUSER    ( SLAVE3_AWUSER ),
          .SLAVE_AWVALID  ( SLAVE3_AWVALID ),
          .SLAVE_AWREADY  ( SLAVE3_AWREADY ),

          //===================== Slave Write Data Ports  ============================================//
          .SLAVE_WDATA    ( SLAVE3_WDATA ),
          .SLAVE_WSTRB    ( SLAVE3_WSTRB ),
          .SLAVE_WLAST    ( SLAVE3_WLAST ),
          .SLAVE_WUSER    ( SLAVE3_WUSER ),
          .SLAVE_WVALID   ( SLAVE3_WVALID ),
          .SLAVE_WREADY   ( SLAVE3_WREADY ),

          //===================== Master Write Response Ports  ========================================//
          .SLAVE_BID      ( SLAVE3_BID ),
          .SLAVE_BRESP    ( SLAVE3_BRESP ),
          .SLAVE_BUSER    ( SLAVE3_BUSER ),
          .SLAVE_BVALID   ( SLAVE3_BVALID ),
          .SLAVE_BREADY   ( SLAVE3_BREADY ),

          // ===============  Control Signals  =======================================================//
          .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
          .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
          .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
          .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
          .FORCE_ERROR           ( FORCE_ERROR[3] ),              // Forces error pn read/write RESP
          .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
        );

  Axi4SlaveGen # 
        (
          .SLAVE_NUM              ( 4 ),             // defines slave port number
          .ID_WIDTH                ( MASTERID_WIDTH ),
          .ADDR_WIDTH              ( ADDR_WIDTH ),
          .DATA_WIDTH              ( SLAVE4_DATA_WIDTH ),
          .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH              ( USER_WIDTH ),
          .LOWER_COMPARE_BIT      ( NUM_AXISLAVE_BITS ),
          .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
        )
      slv4  (
          //======================  Global Signals  =================================================//
          .sysClk         ( S_CLK[4] ),
          .ARESETN        ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

          //======================  Slave Read Address Port  ========================================//
          .SLAVE_ARID      ( SLAVE4_ARID ),
          .SLAVE_ARADDR    ( SLAVE4_ARADDR ),
          .SLAVE_ARLEN    ( SLAVE4_ARLEN ),
          .SLAVE_ARSIZE    ( SLAVE4_ARSIZE ),
          .SLAVE_ARBURST  ( SLAVE4_ARBURST ),
          .SLAVE_ARLOCK    ( SLAVE4_ARLOCK ),
          .SLAVE_ARCACHE  ( SLAVE4_ARCACHE ),
          .SLAVE_ARPROT    ( SLAVE4_ARPROT ),
          .SLAVE_ARREGION  ( SLAVE4_ARREGION ),      // not used
          .SLAVE_ARQOS    ( SLAVE4_ARQOS ),        // not used
          .SLAVE_ARUSER    ( SLAVE4_ARUSER ),
          .SLAVE_ARVALID  ( SLAVE4_ARVALID ),
          .SLAVE_ARREADY  ( SLAVE4_ARREADY ),

          //====================== Slave Data Ports  ================================================//
          .SLAVE_RVALID    ( SLAVE4_RVALID ),
          .SLAVE_RID      ( SLAVE4_RID ),
          .SLAVE_RDATA    ( SLAVE4_RDATA ),
          .SLAVE_RRESP    ( SLAVE4_RRESP ),
          .SLAVE_RLAST    ( SLAVE4_RLAST ),
          .SLAVE_RUSER    ( SLAVE4_RUSER ),
          .SLAVE_RREADY    ( SLAVE4_RREADY),

          //====================== Slave Write Address Ports  ========================================//
          .SLAVE_AWID      ( SLAVE4_AWID ),
          .SLAVE_AWADDR    ( SLAVE4_AWADDR ),
          .SLAVE_AWLEN    ( SLAVE4_AWLEN ),
          .SLAVE_AWSIZE    ( SLAVE4_AWSIZE ),
          .SLAVE_AWBURST  ( SLAVE4_AWBURST ),
          .SLAVE_AWLOCK    ( SLAVE4_AWLOCK ),
          .SLAVE_AWCACHE  ( SLAVE4_AWCACHE ),
          .SLAVE_AWPROT    ( SLAVE4_AWPROT ),
          .SLAVE_AWREGION  ( SLAVE4_AWREGION ),      // not used
          .SLAVE_AWQOS    ( SLAVE4_AWQOS ),        // not used
          .SLAVE_AWUSER    ( SLAVE4_AWUSER ),
          .SLAVE_AWVALID  ( SLAVE4_AWVALID ),
          .SLAVE_AWREADY  ( SLAVE4_AWREADY ),

          //===================== Slave Write Data Ports  ============================================//
          .SLAVE_WDATA    ( SLAVE4_WDATA ),
          .SLAVE_WSTRB    ( SLAVE4_WSTRB ),
          .SLAVE_WLAST    ( SLAVE4_WLAST ),
          .SLAVE_WUSER    ( SLAVE4_WUSER ),
          .SLAVE_WVALID   ( SLAVE4_WVALID ),
          .SLAVE_WREADY   ( SLAVE4_WREADY ),

          //=================== Master Write Response Ports  =========================================//
          .SLAVE_BID      ( SLAVE4_BID ),
          .SLAVE_BRESP    ( SLAVE4_BRESP ),
          .SLAVE_BUSER    ( SLAVE4_BUSER ),
          .SLAVE_BVALID   ( SLAVE4_BVALID ),
          .SLAVE_BREADY   ( SLAVE4_BREADY ),

          // ===============  Control Signals  =======================================================//
          .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
          .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
          .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
          .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
          .FORCE_ERROR           ( FORCE_ERROR[4] ),              // Forces error pn read/write RESP
          .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
         );

  Axi4SlaveGen # 
        (
          .SLAVE_NUM              ( 5 ),             // defines slave port number
          .ID_WIDTH               ( MASTERID_WIDTH ), 
          .ADDR_WIDTH              ( ADDR_WIDTH ),
          .DATA_WIDTH             ( SLAVE5_DATA_WIDTH ),
          .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH             ( USER_WIDTH ),
          .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
          .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )

        )
      slv5  (
          //======================  Global Signals   =======================================================//
          .sysClk         ( S_CLK[5] ),
          .ARESETN        ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

          //=====================  Slave Read Address Port  ================================================//
          .SLAVE_ARID      ( SLAVE5_ARID ),
          .SLAVE_ARADDR    ( SLAVE5_ARADDR ),
          .SLAVE_ARLEN    ( SLAVE5_ARLEN ),
          .SLAVE_ARSIZE    ( SLAVE5_ARSIZE ),
          .SLAVE_ARBURST  ( SLAVE5_ARBURST ),
          .SLAVE_ARLOCK    ( SLAVE5_ARLOCK ),
          .SLAVE_ARCACHE  ( SLAVE5_ARCACHE ),
          .SLAVE_ARPROT    ( SLAVE5_ARPROT ),
          .SLAVE_ARREGION  ( SLAVE5_ARREGION ),      // not used
          .SLAVE_ARQOS    ( SLAVE5_ARQOS ),        // not used
          .SLAVE_ARUSER    ( SLAVE5_ARUSER ),
          .SLAVE_ARVALID  ( SLAVE5_ARVALID ),
          .SLAVE_ARREADY  ( SLAVE5_ARREADY ),

          //====================== Slave Data Ports  ================================================//
          .SLAVE_RVALID    ( SLAVE5_RVALID ),
          .SLAVE_RID      ( SLAVE5_RID ),
          .SLAVE_RDATA    ( SLAVE5_RDATA ),
          .SLAVE_RRESP    ( SLAVE5_RRESP ),
          .SLAVE_RLAST    ( SLAVE5_RLAST ),
          .SLAVE_RUSER    ( SLAVE5_RUSER ),
          .SLAVE_RREADY    ( SLAVE5_RREADY),

          //====================== Slave Write Address Ports  ================================================//
          .SLAVE_AWID      ( SLAVE5_AWID ),
          .SLAVE_AWADDR    ( SLAVE5_AWADDR ),
          .SLAVE_AWLEN    ( SLAVE5_AWLEN ),
          .SLAVE_AWSIZE    ( SLAVE5_AWSIZE ),
          .SLAVE_AWBURST  ( SLAVE5_AWBURST ),
          .SLAVE_AWLOCK    ( SLAVE5_AWLOCK ),
          .SLAVE_AWCACHE  ( SLAVE5_AWCACHE ),
          .SLAVE_AWPROT    ( SLAVE5_AWPROT ),
          .SLAVE_AWREGION  ( SLAVE5_AWREGION ),      // not used
          .SLAVE_AWQOS    ( SLAVE5_AWQOS ),        // not used
          .SLAVE_AWUSER    ( SLAVE5_AWUSER ),
          .SLAVE_AWVALID  ( SLAVE5_AWVALID ),
          .SLAVE_AWREADY  ( SLAVE5_AWREADY ),

          //===================== Slave Write Data Ports  ============================================//
          .SLAVE_WDATA    ( SLAVE5_WDATA ),
          .SLAVE_WSTRB    ( SLAVE5_WSTRB ),
          .SLAVE_WLAST    ( SLAVE5_WLAST ),
          .SLAVE_WUSER    ( SLAVE5_WUSER ),
          .SLAVE_WVALID   ( SLAVE5_WVALID ),
          .SLAVE_WREADY   ( SLAVE5_WREADY ),

          //==================  Master Write Response Ports  ==========================================//
          .SLAVE_BID      ( SLAVE5_BID ),
          .SLAVE_BRESP    ( SLAVE5_BRESP ),
          .SLAVE_BUSER    ( SLAVE5_BUSER ),
          .SLAVE_BVALID   ( SLAVE5_BVALID ),

          .SLAVE_BREADY   ( SLAVE5_BREADY ),

          // ===============  Control Signals  =======================================================//
          .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
          .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
          .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
          .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
          .FORCE_ERROR           ( FORCE_ERROR[5] ),              // Forces error pn read/write RESP
          .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
         );


  Axi4SlaveGen # 
        (
          .SLAVE_NUM              ( 6 ),             // defines slave port number
          .ID_WIDTH               ( MASTERID_WIDTH ), 
          .ADDR_WIDTH              ( ADDR_WIDTH ),
          .DATA_WIDTH             ( SLAVE6_DATA_WIDTH ),
          .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH             ( USER_WIDTH ),
          .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
          .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
        )
      slv6  (
          //====================  Global Signals  =====================================================//
          .sysClk         ( S_CLK[6] ),
          .ARESETN        ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

          //======================  Slave Read Address Port  ==========================================//
          .SLAVE_ARID      ( SLAVE6_ARID ),
          .SLAVE_ARADDR    ( SLAVE6_ARADDR ),
          .SLAVE_ARLEN    ( SLAVE6_ARLEN ),
          .SLAVE_ARSIZE    ( SLAVE6_ARSIZE ),
          .SLAVE_ARBURST  ( SLAVE6_ARBURST ),
          .SLAVE_ARLOCK    ( SLAVE6_ARLOCK ),
          .SLAVE_ARCACHE  ( SLAVE6_ARCACHE ),
          .SLAVE_ARPROT    ( SLAVE6_ARPROT ),
          .SLAVE_ARREGION  ( SLAVE6_ARREGION ),      // not used
          .SLAVE_ARQOS    ( SLAVE6_ARQOS ),        // not used
          .SLAVE_ARUSER    ( SLAVE6_ARUSER ),
          .SLAVE_ARVALID  ( SLAVE6_ARVALID ),
          .SLAVE_ARREADY  ( SLAVE6_ARREADY ),

          //====================== Slave Data Ports  ================================================//
          .SLAVE_RVALID    ( SLAVE6_RVALID ),
          .SLAVE_RID      ( SLAVE6_RID ),
          .SLAVE_RDATA    ( SLAVE6_RDATA ),
          .SLAVE_RRESP    ( SLAVE6_RRESP ),
          .SLAVE_RLAST    ( SLAVE6_RLAST ),
          .SLAVE_RUSER    ( SLAVE6_RUSER ),
          .SLAVE_RREADY    ( SLAVE6_RREADY),

          //====================== Slave Write Address Ports  ================================================//
          .SLAVE_AWID      ( SLAVE6_AWID ),
          .SLAVE_AWADDR    ( SLAVE6_AWADDR ),
          .SLAVE_AWLEN    ( SLAVE6_AWLEN ),
          .SLAVE_AWSIZE    ( SLAVE6_AWSIZE ),
          .SLAVE_AWBURST  ( SLAVE6_AWBURST ),
          .SLAVE_AWLOCK    ( SLAVE6_AWLOCK ),
          .SLAVE_AWCACHE  ( SLAVE6_AWCACHE ),
          .SLAVE_AWPROT    ( SLAVE6_AWPROT ),
          .SLAVE_AWREGION  ( SLAVE6_AWREGION ),      // not used
          .SLAVE_AWQOS    ( SLAVE6_AWQOS ),        // not used
          .SLAVE_AWUSER    ( SLAVE6_AWUSER ),
          .SLAVE_AWVALID  ( SLAVE6_AWVALID ),
          .SLAVE_AWREADY  ( SLAVE6_AWREADY ),

          //===================== Slave Write Data Ports  ============================================//
          .SLAVE_WDATA    ( SLAVE6_WDATA ),
          .SLAVE_WSTRB    ( SLAVE6_WSTRB ),
          .SLAVE_WLAST    ( SLAVE6_WLAST ),
          .SLAVE_WUSER    ( SLAVE6_WUSER ),
          .SLAVE_WVALID   ( SLAVE6_WVALID ),
          .SLAVE_WREADY   ( SLAVE6_WREADY ),

          //==================  Master Write Response Ports  ==========================================//
          .SLAVE_BID      ( SLAVE6_BID ),
          .SLAVE_BRESP    ( SLAVE6_BRESP ),
          .SLAVE_BUSER    ( SLAVE6_BUSER ),
          .SLAVE_BVALID   ( SLAVE6_BVALID ),
          .SLAVE_BREADY( SLAVE6_BREADY ),

          // ===============  Control Signals  =======================================================//
          .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
          .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
          .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
          .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
          .FORCE_ERROR           ( FORCE_ERROR[6] ),              // Forces error pn read/write RESP
          .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
         );


  Axi4SlaveGen # 
        (
          .SLAVE_NUM              ( 7 ),                 // defines slave port number
          .ID_WIDTH               ( MASTERID_WIDTH ), 
          .ADDR_WIDTH              ( ADDR_WIDTH ),
          .DATA_WIDTH             ( SLAVE7_DATA_WIDTH ),
          .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH             ( USER_WIDTH ),
          .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
          .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )

        )
      slv7  (
          //=================  Global Signals  ==========================================================//
          .sysClk         ( S_CLK[7] ),
          .ARESETN        ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

          //================  Slave Read Address Port  ===================================================//
          .SLAVE_ARID      ( SLAVE7_ARID ),
          .SLAVE_ARADDR    ( SLAVE7_ARADDR ),
          .SLAVE_ARLEN    ( SLAVE7_ARLEN ),
          .SLAVE_ARSIZE    ( SLAVE7_ARSIZE ),
          .SLAVE_ARBURST  ( SLAVE7_ARBURST ),
          .SLAVE_ARLOCK    ( SLAVE7_ARLOCK ),
          .SLAVE_ARCACHE  ( SLAVE7_ARCACHE ),
          .SLAVE_ARPROT    ( SLAVE7_ARPROT ),
          .SLAVE_ARREGION  ( SLAVE7_ARREGION ),      // not used
          .SLAVE_ARQOS    ( SLAVE7_ARQOS ),        // not used
          .SLAVE_ARUSER    ( SLAVE7_ARUSER ),
          .SLAVE_ARVALID  ( SLAVE7_ARVALID ),
          .SLAVE_ARREADY  ( SLAVE7_ARREADY ),

          //====================== Slave Data Ports  ================================================//
          .SLAVE_RVALID    ( SLAVE7_RVALID ),
          .SLAVE_RID      ( SLAVE7_RID ),
          .SLAVE_RDATA    ( SLAVE7_RDATA ),
          .SLAVE_RRESP    ( SLAVE7_RRESP ),
          .SLAVE_RLAST    ( SLAVE7_RLAST ),
          .SLAVE_RUSER    ( SLAVE7_RUSER ),
          .SLAVE_RREADY    ( SLAVE7_RREADY),

          //====================== Slave Write Address Ports  ================================================//
          .SLAVE_AWID      ( SLAVE7_AWID ),
          .SLAVE_AWADDR    ( SLAVE7_AWADDR ),
          .SLAVE_AWLEN    ( SLAVE7_AWLEN ),
          .SLAVE_AWSIZE    ( SLAVE7_AWSIZE ),
          .SLAVE_AWBURST  ( SLAVE7_AWBURST ),
          .SLAVE_AWLOCK    ( SLAVE7_AWLOCK ),
          .SLAVE_AWCACHE  ( SLAVE7_AWCACHE ),
          .SLAVE_AWPROT    ( SLAVE7_AWPROT ),
          .SLAVE_AWREGION  ( SLAVE7_AWREGION ),      // not used
          .SLAVE_AWQOS    ( SLAVE7_AWQOS ),        // not used
          .SLAVE_AWUSER    ( SLAVE7_AWUSER ),
          .SLAVE_AWVALID  ( SLAVE7_AWVALID ),
          .SLAVE_AWREADY  ( SLAVE7_AWREADY ),

          //===================== Slave Write Data Ports  ============================================//
          .SLAVE_WDATA    ( SLAVE7_WDATA ),
          .SLAVE_WSTRB    ( SLAVE7_WSTRB ),
          .SLAVE_WLAST    ( SLAVE7_WLAST ),
          .SLAVE_WUSER    ( SLAVE7_WUSER ),
          .SLAVE_WVALID   ( SLAVE7_WVALID ),

          .SLAVE_WREADY   ( SLAVE7_WREADY ),

          //===================  Master Write Response Ports  =========================================//
          .SLAVE_BID      ( SLAVE7_BID ),
          .SLAVE_BRESP    ( SLAVE7_BRESP ),
          .SLAVE_BUSER    ( SLAVE7_BUSER ),
          .SLAVE_BVALID   ( SLAVE7_BVALID ),

          .SLAVE_BREADY   ( SLAVE7_BREADY ),

          // ===============  Control Signals  =======================================================//
          .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
          .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
          .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
          .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
          .FORCE_ERROR           ( FORCE_ERROR[7] ),              // Forces error pn read/write RESP
          .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
        );


 Axi4SlaveGen # (

    .SLAVE_NUM              ( 8 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE8_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv8 (
  .sysClk            (S_CLK[8]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE8_ARID ),
  .SLAVE_ARADDR      ( SLAVE8_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE8_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE8_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE8_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE8_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE8_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE8_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE8_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE8_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE8_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE8_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE8_ARREADY ),
                              
  // Slave Read Data Ports    
  .SLAVE_RID         ( SLAVE8_RID ),
  .SLAVE_RDATA       ( SLAVE8_RDATA ),
  .SLAVE_RRESP       ( SLAVE8_RRESP ),
  .SLAVE_RLAST       ( SLAVE8_RLAST ),
  .SLAVE_RUSER       ( SLAVE8_RUSER ),
  .SLAVE_RVALID      ( SLAVE8_RVALID ),
  .SLAVE_RREADY      ( SLAVE8_RREADY ),
                              
  .SLAVE_AWID        ( SLAVE8_AWID ),
  .SLAVE_AWADDR      ( SLAVE8_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE8_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE8_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE8_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE8_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE8_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE8_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE8_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE8_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE8_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE8_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE8_AWREADY ),
                              
  // Slave Write Data Ports   
  .SLAVE_WDATA       ( SLAVE8_WDATA ),
  .SLAVE_WSTRB       ( SLAVE8_WSTRB ),
  .SLAVE_WLAST       ( SLAVE8_WLAST ),
  .SLAVE_WUSER       ( SLAVE8_WUSER ),
  .SLAVE_WVALID      ( SLAVE8_WVALID ),
  .SLAVE_WREADY      ( SLAVE8_WREADY ),
                              
  // Slave Write Response Port
  .SLAVE_BID         ( SLAVE8_BID ),
  .SLAVE_BRESP       ( SLAVE8_BRESP ),
  .SLAVE_BUSER       ( SLAVE8_BUSER ),
  .SLAVE_BVALID      ( SLAVE8_BVALID ),
  .SLAVE_BREADY      ( SLAVE8_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[8] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);


 Axi4SlaveGen # (

    .SLAVE_NUM              ( 9 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE9_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv9 (
  .sysClk            (S_CLK[9]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE9_ARID ),
  .SLAVE_ARADDR      ( SLAVE9_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE9_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE9_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE9_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE9_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE9_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE9_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE9_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE9_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE9_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE9_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE9_ARREADY ),
                              
  // Slave Read Data Ports    
  .SLAVE_RID         ( SLAVE9_RID ),
  .SLAVE_RDATA       ( SLAVE9_RDATA ),
  .SLAVE_RRESP       ( SLAVE9_RRESP ),
  .SLAVE_RLAST       ( SLAVE9_RLAST ),
  .SLAVE_RUSER       ( SLAVE9_RUSER ),
  .SLAVE_RVALID      ( SLAVE9_RVALID ),
  .SLAVE_RREADY      ( SLAVE9_RREADY ),
                              
  .SLAVE_AWID        ( SLAVE9_AWID ),
  .SLAVE_AWADDR      ( SLAVE9_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE9_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE9_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE9_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE9_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE9_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE9_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE9_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE9_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE9_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE9_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE9_AWREADY ),
                              
  // Slave Write Data Ports   
  .SLAVE_WDATA       ( SLAVE9_WDATA ),
  .SLAVE_WSTRB       ( SLAVE9_WSTRB ),
  .SLAVE_WLAST       ( SLAVE9_WLAST ),
  .SLAVE_WUSER       ( SLAVE9_WUSER ),
  .SLAVE_WVALID      ( SLAVE9_WVALID ),
  .SLAVE_WREADY      ( SLAVE9_WREADY ),
                              
  // Slave Write Response Port
  .SLAVE_BID         ( SLAVE9_BID ),
  .SLAVE_BRESP       ( SLAVE9_BRESP ),
  .SLAVE_BUSER       ( SLAVE9_BUSER ),
  .SLAVE_BVALID      ( SLAVE9_BVALID ),
  .SLAVE_BREADY      ( SLAVE9_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[9] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 10 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE10_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv10 (
  .sysClk            (S_CLK[10]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE10_ARID ),
  .SLAVE_ARADDR      ( SLAVE10_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE10_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE10_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE10_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE10_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE10_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE10_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE10_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE10_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE10_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE10_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE10_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE10_RID ),
  .SLAVE_RDATA       ( SLAVE10_RDATA ),
  .SLAVE_RRESP       ( SLAVE10_RRESP ),
  .SLAVE_RLAST       ( SLAVE10_RLAST ),
  .SLAVE_RUSER       ( SLAVE10_RUSER ),
  .SLAVE_RVALID      ( SLAVE10_RVALID ),
  .SLAVE_RREADY      ( SLAVE10_RREADY ),

  .SLAVE_AWID        ( SLAVE10_AWID ),
  .SLAVE_AWADDR      ( SLAVE10_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE10_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE10_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE10_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE10_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE10_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE10_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE10_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE10_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE10_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE10_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE10_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE10_WDATA ),
  .SLAVE_WSTRB       ( SLAVE10_WSTRB ),
  .SLAVE_WLAST       ( SLAVE10_WLAST ),
  .SLAVE_WUSER       ( SLAVE10_WUSER ),
  .SLAVE_WVALID      ( SLAVE10_WVALID ),
  .SLAVE_WREADY      ( SLAVE10_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE10_BID ),
  .SLAVE_BRESP       ( SLAVE10_BRESP ),
  .SLAVE_BUSER       ( SLAVE10_BUSER ),
  .SLAVE_BVALID      ( SLAVE10_BVALID ),
  .SLAVE_BREADY      ( SLAVE10_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[10] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 11 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE11_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv11 (
  .sysClk            (S_CLK[11]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE11_ARID ),
  .SLAVE_ARADDR      ( SLAVE11_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE11_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE11_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE11_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE11_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE11_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE11_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE11_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE11_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE11_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE11_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE11_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE11_RID ),
  .SLAVE_RDATA       ( SLAVE11_RDATA ),
  .SLAVE_RRESP       ( SLAVE11_RRESP ),
  .SLAVE_RLAST       ( SLAVE11_RLAST ),
  .SLAVE_RUSER       ( SLAVE11_RUSER ),
  .SLAVE_RVALID      ( SLAVE11_RVALID ),
  .SLAVE_RREADY      ( SLAVE11_RREADY ),

  .SLAVE_AWID        ( SLAVE11_AWID ),
  .SLAVE_AWADDR      ( SLAVE11_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE11_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE11_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE11_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE11_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE11_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE11_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE11_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE11_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE11_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE11_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE11_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE11_WDATA ),
  .SLAVE_WSTRB       ( SLAVE11_WSTRB ),
  .SLAVE_WLAST       ( SLAVE11_WLAST ),
  .SLAVE_WUSER       ( SLAVE11_WUSER ),
  .SLAVE_WVALID      ( SLAVE11_WVALID ),
  .SLAVE_WREADY      ( SLAVE11_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE11_BID ),
  .SLAVE_BRESP       ( SLAVE11_BRESP ),
  .SLAVE_BUSER       ( SLAVE11_BUSER ),
  .SLAVE_BVALID      ( SLAVE11_BVALID ),
  .SLAVE_BREADY      ( SLAVE11_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[11] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 12 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE12_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv12 (
  .sysClk            (S_CLK[12]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE12_ARID ),
  .SLAVE_ARADDR      ( SLAVE12_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE12_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE12_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE12_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE12_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE12_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE12_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE12_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE12_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE12_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE12_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE12_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE12_RID ),
  .SLAVE_RDATA       ( SLAVE12_RDATA ),
  .SLAVE_RRESP       ( SLAVE12_RRESP ),
  .SLAVE_RLAST       ( SLAVE12_RLAST ),
  .SLAVE_RUSER       ( SLAVE12_RUSER ),
  .SLAVE_RVALID      ( SLAVE12_RVALID ),
  .SLAVE_RREADY      ( SLAVE12_RREADY ),

  .SLAVE_AWID        ( SLAVE12_AWID ),
  .SLAVE_AWADDR      ( SLAVE12_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE12_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE12_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE12_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE12_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE12_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE12_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE12_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE12_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE12_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE12_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE12_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE12_WDATA ),
  .SLAVE_WSTRB       ( SLAVE12_WSTRB ),
  .SLAVE_WLAST       ( SLAVE12_WLAST ),
  .SLAVE_WUSER       ( SLAVE12_WUSER ),
  .SLAVE_WVALID      ( SLAVE12_WVALID ),
  .SLAVE_WREADY      ( SLAVE12_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE12_BID ),
  .SLAVE_BRESP       ( SLAVE12_BRESP ),
  .SLAVE_BUSER       ( SLAVE12_BUSER ),
  .SLAVE_BVALID      ( SLAVE12_BVALID ),
  .SLAVE_BREADY      ( SLAVE12_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[12] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);


 Axi4SlaveGen # (

    .SLAVE_NUM              ( 13 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE13_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv13 (
  .sysClk            (S_CLK[13]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE13_ARID ),
  .SLAVE_ARADDR      ( SLAVE13_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE13_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE13_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE13_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE13_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE13_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE13_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE13_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE13_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE13_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE13_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE13_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE13_RID ),
  .SLAVE_RDATA       ( SLAVE13_RDATA ),
  .SLAVE_RRESP       ( SLAVE13_RRESP ),
  .SLAVE_RLAST       ( SLAVE13_RLAST ),
  .SLAVE_RUSER       ( SLAVE13_RUSER ),
  .SLAVE_RVALID      ( SLAVE13_RVALID ),
  .SLAVE_RREADY      ( SLAVE13_RREADY ),

  .SLAVE_AWID        ( SLAVE13_AWID ),
  .SLAVE_AWADDR      ( SLAVE13_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE13_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE13_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE13_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE13_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE13_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE13_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE13_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE13_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE13_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE13_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE13_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE13_WDATA ),
  .SLAVE_WSTRB       ( SLAVE13_WSTRB ),
  .SLAVE_WLAST       ( SLAVE13_WLAST ),
  .SLAVE_WUSER       ( SLAVE13_WUSER ),
  .SLAVE_WVALID      ( SLAVE13_WVALID ),
  .SLAVE_WREADY      ( SLAVE13_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE13_BID ),
  .SLAVE_BRESP       ( SLAVE13_BRESP ),
  .SLAVE_BUSER       ( SLAVE13_BUSER ),
  .SLAVE_BVALID      ( SLAVE13_BVALID ),
  .SLAVE_BREADY      ( SLAVE13_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[13] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);


 Axi4SlaveGen # (

    .SLAVE_NUM              ( 14 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE14_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv14 (
  .sysClk            (S_CLK[14]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE14_ARID ),
  .SLAVE_ARADDR      ( SLAVE14_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE14_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE14_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE14_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE14_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE14_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE14_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE14_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE14_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE14_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE14_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE14_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE14_RID ),
  .SLAVE_RDATA       ( SLAVE14_RDATA ),
  .SLAVE_RRESP       ( SLAVE14_RRESP ),
  .SLAVE_RLAST       ( SLAVE14_RLAST ),
  .SLAVE_RUSER       ( SLAVE14_RUSER ),
  .SLAVE_RVALID      ( SLAVE14_RVALID ),
  .SLAVE_RREADY      ( SLAVE14_RREADY ),

  .SLAVE_AWID        ( SLAVE14_AWID ),
  .SLAVE_AWADDR      ( SLAVE14_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE14_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE14_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE14_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE14_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE14_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE14_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE14_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE14_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE14_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE14_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE14_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE14_WDATA ),
  .SLAVE_WSTRB       ( SLAVE14_WSTRB ),
  .SLAVE_WLAST       ( SLAVE14_WLAST ),
  .SLAVE_WUSER       ( SLAVE14_WUSER ),
  .SLAVE_WVALID      ( SLAVE14_WVALID ),
  .SLAVE_WREADY      ( SLAVE14_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE14_BID ),
  .SLAVE_BRESP       ( SLAVE14_BRESP ),
  .SLAVE_BUSER       ( SLAVE14_BUSER ),
  .SLAVE_BVALID      ( SLAVE14_BVALID ),
  .SLAVE_BREADY      ( SLAVE14_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[14] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 15 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE15_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv15 (
  .sysClk            (S_CLK[15]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE15_ARID ),
  .SLAVE_ARADDR      ( SLAVE15_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE15_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE15_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE15_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE15_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE15_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE15_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE15_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE15_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE15_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE15_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE15_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE15_RID ),
  .SLAVE_RDATA       ( SLAVE15_RDATA ),
  .SLAVE_RRESP       ( SLAVE15_RRESP ),
  .SLAVE_RLAST       ( SLAVE15_RLAST ),
  .SLAVE_RUSER       ( SLAVE15_RUSER ),
  .SLAVE_RVALID      ( SLAVE15_RVALID ),
  .SLAVE_RREADY      ( SLAVE15_RREADY ),

  .SLAVE_AWID        ( SLAVE15_AWID ),
  .SLAVE_AWADDR      ( SLAVE15_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE15_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE15_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE15_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE15_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE15_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE15_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE15_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE15_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE15_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE15_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE15_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE15_WDATA ),
  .SLAVE_WSTRB       ( SLAVE15_WSTRB ),
  .SLAVE_WLAST       ( SLAVE15_WLAST ),
  .SLAVE_WUSER       ( SLAVE15_WUSER ),
  .SLAVE_WVALID      ( SLAVE15_WVALID ),
  .SLAVE_WREADY      ( SLAVE15_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE15_BID ),
  .SLAVE_BRESP       ( SLAVE15_BRESP ),
  .SLAVE_BUSER       ( SLAVE15_BUSER ),
  .SLAVE_BVALID      ( SLAVE15_BVALID ),
  .SLAVE_BREADY      ( SLAVE15_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[15] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 16 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE16_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv16 (
  .sysClk            (S_CLK[16]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE16_ARID ),
  .SLAVE_ARADDR      ( SLAVE16_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE16_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE16_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE16_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE16_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE16_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE16_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE16_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE16_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE16_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE16_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE16_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE16_RID ),
  .SLAVE_RDATA       ( SLAVE16_RDATA ),
  .SLAVE_RRESP       ( SLAVE16_RRESP ),
  .SLAVE_RLAST       ( SLAVE16_RLAST ),
  .SLAVE_RUSER       ( SLAVE16_RUSER ),
  .SLAVE_RVALID      ( SLAVE16_RVALID ),
  .SLAVE_RREADY      ( SLAVE16_RREADY ),

  .SLAVE_AWID        ( SLAVE16_AWID ),
  .SLAVE_AWADDR      ( SLAVE16_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE16_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE16_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE16_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE16_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE16_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE16_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE16_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE16_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE16_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE16_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE16_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE16_WDATA ),
  .SLAVE_WSTRB       ( SLAVE16_WSTRB ),
  .SLAVE_WLAST       ( SLAVE16_WLAST ),
  .SLAVE_WUSER       ( SLAVE16_WUSER ),
  .SLAVE_WVALID      ( SLAVE16_WVALID ),
  .SLAVE_WREADY      ( SLAVE16_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE16_BID ),
  .SLAVE_BRESP       ( SLAVE16_BRESP ),
  .SLAVE_BUSER       ( SLAVE16_BUSER ),
  .SLAVE_BVALID      ( SLAVE16_BVALID ),
  .SLAVE_BREADY      ( SLAVE16_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[16] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 17 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE17_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv17 (
  .sysClk            (S_CLK[17]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE17_ARID ),
  .SLAVE_ARADDR      ( SLAVE17_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE17_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE17_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE17_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE17_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE17_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE17_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE17_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE17_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE17_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE17_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE17_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE17_RID ),
  .SLAVE_RDATA       ( SLAVE17_RDATA ),
  .SLAVE_RRESP       ( SLAVE17_RRESP ),
  .SLAVE_RLAST       ( SLAVE17_RLAST ),
  .SLAVE_RUSER       ( SLAVE17_RUSER ),
  .SLAVE_RVALID      ( SLAVE17_RVALID ),
  .SLAVE_RREADY      ( SLAVE17_RREADY ),

  .SLAVE_AWID        ( SLAVE17_AWID ),
  .SLAVE_AWADDR      ( SLAVE17_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE17_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE17_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE17_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE17_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE17_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE17_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE17_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE17_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE17_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE17_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE17_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE17_WDATA ),
  .SLAVE_WSTRB       ( SLAVE17_WSTRB ),
  .SLAVE_WLAST       ( SLAVE17_WLAST ),
  .SLAVE_WUSER       ( SLAVE17_WUSER ),
  .SLAVE_WVALID      ( SLAVE17_WVALID ),
  .SLAVE_WREADY      ( SLAVE17_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE17_BID ),
  .SLAVE_BRESP       ( SLAVE17_BRESP ),
  .SLAVE_BUSER       ( SLAVE17_BUSER ),
  .SLAVE_BVALID      ( SLAVE17_BVALID ),
  .SLAVE_BREADY      ( SLAVE17_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[17] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 18 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE18_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv18 (
  .sysClk            (S_CLK[18]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE18_ARID ),
  .SLAVE_ARADDR      ( SLAVE18_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE18_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE18_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE18_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE18_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE18_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE18_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE18_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE18_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE18_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE18_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE18_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE18_RID ),
  .SLAVE_RDATA       ( SLAVE18_RDATA ),
  .SLAVE_RRESP       ( SLAVE18_RRESP ),
  .SLAVE_RLAST       ( SLAVE18_RLAST ),
  .SLAVE_RUSER       ( SLAVE18_RUSER ),
  .SLAVE_RVALID      ( SLAVE18_RVALID ),
  .SLAVE_RREADY      ( SLAVE18_RREADY ),

  .SLAVE_AWID        ( SLAVE18_AWID ),
  .SLAVE_AWADDR      ( SLAVE18_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE18_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE18_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE18_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE18_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE18_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE18_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE18_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE18_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE18_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE18_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE18_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE18_WDATA ),
  .SLAVE_WSTRB       ( SLAVE18_WSTRB ),
  .SLAVE_WLAST       ( SLAVE18_WLAST ),
  .SLAVE_WUSER       ( SLAVE18_WUSER ),
  .SLAVE_WVALID      ( SLAVE18_WVALID ),
  .SLAVE_WREADY      ( SLAVE18_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE18_BID ),
  .SLAVE_BRESP       ( SLAVE18_BRESP ),
  .SLAVE_BUSER       ( SLAVE18_BUSER ),
  .SLAVE_BVALID      ( SLAVE18_BVALID ),
  .SLAVE_BREADY      ( SLAVE18_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[18] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 19 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE19_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv19 (
  .sysClk            (S_CLK[19]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE19_ARID ),
  .SLAVE_ARADDR      ( SLAVE19_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE19_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE19_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE19_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE19_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE19_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE19_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE19_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE19_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE19_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE19_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE19_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE19_RID ),
  .SLAVE_RDATA       ( SLAVE19_RDATA ),
  .SLAVE_RRESP       ( SLAVE19_RRESP ),
  .SLAVE_RLAST       ( SLAVE19_RLAST ),
  .SLAVE_RUSER       ( SLAVE19_RUSER ),
  .SLAVE_RVALID      ( SLAVE19_RVALID ),
  .SLAVE_RREADY      ( SLAVE19_RREADY ),

  .SLAVE_AWID        ( SLAVE19_AWID ),
  .SLAVE_AWADDR      ( SLAVE19_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE19_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE19_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE19_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE19_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE19_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE19_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE19_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE19_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE19_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE19_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE19_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE19_WDATA ),
  .SLAVE_WSTRB       ( SLAVE19_WSTRB ),
  .SLAVE_WLAST       ( SLAVE19_WLAST ),
  .SLAVE_WUSER       ( SLAVE19_WUSER ),
  .SLAVE_WVALID      ( SLAVE19_WVALID ),
  .SLAVE_WREADY      ( SLAVE19_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE19_BID ),
  .SLAVE_BRESP       ( SLAVE19_BRESP ),
  .SLAVE_BUSER       ( SLAVE19_BUSER ),
  .SLAVE_BVALID      ( SLAVE19_BVALID ),
  .SLAVE_BREADY      ( SLAVE19_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[19] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 20 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE20_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv20 (
  .sysClk            (S_CLK[20]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE20_ARID ),
  .SLAVE_ARADDR      ( SLAVE20_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE20_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE20_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE20_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE20_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE20_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE20_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE20_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE20_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE20_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE20_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE20_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE20_RID ),
  .SLAVE_RDATA       ( SLAVE20_RDATA ),
  .SLAVE_RRESP       ( SLAVE20_RRESP ),
  .SLAVE_RLAST       ( SLAVE20_RLAST ),
  .SLAVE_RUSER       ( SLAVE20_RUSER ),
  .SLAVE_RVALID      ( SLAVE20_RVALID ),
  .SLAVE_RREADY      ( SLAVE20_RREADY ),

  .SLAVE_AWID        ( SLAVE20_AWID ),
  .SLAVE_AWADDR      ( SLAVE20_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE20_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE20_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE20_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE20_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE20_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE20_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE20_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE20_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE20_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE20_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE20_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE20_WDATA ),
  .SLAVE_WSTRB       ( SLAVE20_WSTRB ),
  .SLAVE_WLAST       ( SLAVE20_WLAST ),
  .SLAVE_WUSER       ( SLAVE20_WUSER ),
  .SLAVE_WVALID      ( SLAVE20_WVALID ),
  .SLAVE_WREADY      ( SLAVE20_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE20_BID ),
  .SLAVE_BRESP       ( SLAVE20_BRESP ),
  .SLAVE_BUSER       ( SLAVE20_BUSER ),
  .SLAVE_BVALID      ( SLAVE20_BVALID ),
  .SLAVE_BREADY      ( SLAVE20_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[20] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);


 Axi4SlaveGen # (

    .SLAVE_NUM              ( 21 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE21_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv21 (
  .sysClk            (S_CLK[21]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE21_ARID ),
  .SLAVE_ARADDR      ( SLAVE21_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE21_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE21_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE21_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE21_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE21_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE21_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE21_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE21_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE21_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE21_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE21_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE21_RID ),
  .SLAVE_RDATA       ( SLAVE21_RDATA ),
  .SLAVE_RRESP       ( SLAVE21_RRESP ),
  .SLAVE_RLAST       ( SLAVE21_RLAST ),
  .SLAVE_RUSER       ( SLAVE21_RUSER ),
  .SLAVE_RVALID      ( SLAVE21_RVALID ),
  .SLAVE_RREADY      ( SLAVE21_RREADY ),

  .SLAVE_AWID        ( SLAVE21_AWID ),
  .SLAVE_AWADDR      ( SLAVE21_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE21_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE21_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE21_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE21_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE21_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE21_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE21_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE21_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE21_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE21_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE21_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE21_WDATA ),
  .SLAVE_WSTRB       ( SLAVE21_WSTRB ),
  .SLAVE_WLAST       ( SLAVE21_WLAST ),
  .SLAVE_WUSER       ( SLAVE21_WUSER ),
  .SLAVE_WVALID      ( SLAVE21_WVALID ),
  .SLAVE_WREADY      ( SLAVE21_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE21_BID ),
  .SLAVE_BRESP       ( SLAVE21_BRESP ),
  .SLAVE_BUSER       ( SLAVE21_BUSER ),
  .SLAVE_BVALID      ( SLAVE21_BVALID ),
  .SLAVE_BREADY      ( SLAVE21_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[21] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 22 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE22_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv22 (
  .sysClk            (S_CLK[22]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE22_ARID ),
  .SLAVE_ARADDR      ( SLAVE22_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE22_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE22_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE22_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE22_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE22_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE22_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE22_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE22_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE22_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE22_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE22_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE22_RID ),
  .SLAVE_RDATA       ( SLAVE22_RDATA ),
  .SLAVE_RRESP       ( SLAVE22_RRESP ),
  .SLAVE_RLAST       ( SLAVE22_RLAST ),
  .SLAVE_RUSER       ( SLAVE22_RUSER ),
  .SLAVE_RVALID      ( SLAVE22_RVALID ),
  .SLAVE_RREADY      ( SLAVE22_RREADY ),

  .SLAVE_AWID        ( SLAVE22_AWID ),
  .SLAVE_AWADDR      ( SLAVE22_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE22_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE22_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE22_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE22_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE22_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE22_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE22_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE22_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE22_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE22_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE22_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE22_WDATA ),
  .SLAVE_WSTRB       ( SLAVE22_WSTRB ),
  .SLAVE_WLAST       ( SLAVE22_WLAST ),
  .SLAVE_WUSER       ( SLAVE22_WUSER ),
  .SLAVE_WVALID      ( SLAVE22_WVALID ),
  .SLAVE_WREADY      ( SLAVE22_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE22_BID ),
  .SLAVE_BRESP       ( SLAVE22_BRESP ),
  .SLAVE_BUSER       ( SLAVE22_BUSER ),
  .SLAVE_BVALID      ( SLAVE22_BVALID ),
  .SLAVE_BREADY      ( SLAVE22_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[22] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);


 Axi4SlaveGen # (

    .SLAVE_NUM              ( 23 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE23_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv23 (
  .sysClk            (S_CLK[23]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE23_ARID ),
  .SLAVE_ARADDR      ( SLAVE23_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE23_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE23_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE23_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE23_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE23_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE23_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE23_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE23_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE23_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE23_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE23_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE23_RID ),
  .SLAVE_RDATA       ( SLAVE23_RDATA ),
  .SLAVE_RRESP       ( SLAVE23_RRESP ),
  .SLAVE_RLAST       ( SLAVE23_RLAST ),
  .SLAVE_RUSER       ( SLAVE23_RUSER ),
  .SLAVE_RVALID      ( SLAVE23_RVALID ),
  .SLAVE_RREADY      ( SLAVE23_RREADY ),

  .SLAVE_AWID        ( SLAVE23_AWID ),
  .SLAVE_AWADDR      ( SLAVE23_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE23_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE23_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE23_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE23_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE23_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE23_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE23_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE23_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE23_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE23_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE23_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE23_WDATA ),
  .SLAVE_WSTRB       ( SLAVE23_WSTRB ),
  .SLAVE_WLAST       ( SLAVE23_WLAST ),
  .SLAVE_WUSER       ( SLAVE23_WUSER ),
  .SLAVE_WVALID      ( SLAVE23_WVALID ),
  .SLAVE_WREADY      ( SLAVE23_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE23_BID ),
  .SLAVE_BRESP       ( SLAVE23_BRESP ),
  .SLAVE_BUSER       ( SLAVE23_BUSER ),
  .SLAVE_BVALID      ( SLAVE23_BVALID ),
  .SLAVE_BREADY      ( SLAVE23_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[23] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 24 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE24_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv24 (
  .sysClk            (S_CLK[24]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE24_ARID ),
  .SLAVE_ARADDR      ( SLAVE24_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE24_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE24_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE24_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE24_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE24_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE24_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE24_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE24_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE24_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE24_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE24_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE24_RID ),
  .SLAVE_RDATA       ( SLAVE24_RDATA ),
  .SLAVE_RRESP       ( SLAVE24_RRESP ),
  .SLAVE_RLAST       ( SLAVE24_RLAST ),
  .SLAVE_RUSER       ( SLAVE24_RUSER ),
  .SLAVE_RVALID      ( SLAVE24_RVALID ),
  .SLAVE_RREADY      ( SLAVE24_RREADY ),

  .SLAVE_AWID        ( SLAVE24_AWID ),
  .SLAVE_AWADDR      ( SLAVE24_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE24_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE24_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE24_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE24_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE24_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE24_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE24_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE24_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE24_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE24_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE24_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE24_WDATA ),
  .SLAVE_WSTRB       ( SLAVE24_WSTRB ),
  .SLAVE_WLAST       ( SLAVE24_WLAST ),
  .SLAVE_WUSER       ( SLAVE24_WUSER ),
  .SLAVE_WVALID      ( SLAVE24_WVALID ),
  .SLAVE_WREADY      ( SLAVE24_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE24_BID ),
  .SLAVE_BRESP       ( SLAVE24_BRESP ),
  .SLAVE_BUSER       ( SLAVE24_BUSER ),
  .SLAVE_BVALID      ( SLAVE24_BVALID ),
  .SLAVE_BREADY      ( SLAVE24_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[24] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 25 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE25_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv25 (
  .sysClk            (S_CLK[25]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE25_ARID ),
  .SLAVE_ARADDR      ( SLAVE25_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE25_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE25_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE25_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE25_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE25_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE25_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE25_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE25_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE25_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE25_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE25_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE25_RID ),
  .SLAVE_RDATA       ( SLAVE25_RDATA ),
  .SLAVE_RRESP       ( SLAVE25_RRESP ),
  .SLAVE_RLAST       ( SLAVE25_RLAST ),
  .SLAVE_RUSER       ( SLAVE25_RUSER ),
  .SLAVE_RVALID      ( SLAVE25_RVALID ),
  .SLAVE_RREADY      ( SLAVE25_RREADY ),

  .SLAVE_AWID        ( SLAVE25_AWID ),
  .SLAVE_AWADDR      ( SLAVE25_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE25_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE25_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE25_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE25_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE25_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE25_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE25_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE25_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE25_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE25_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE25_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE25_WDATA ),
  .SLAVE_WSTRB       ( SLAVE25_WSTRB ),
  .SLAVE_WLAST       ( SLAVE25_WLAST ),
  .SLAVE_WUSER       ( SLAVE25_WUSER ),
  .SLAVE_WVALID      ( SLAVE25_WVALID ),
  .SLAVE_WREADY      ( SLAVE25_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE25_BID ),
  .SLAVE_BRESP       ( SLAVE25_BRESP ),
  .SLAVE_BUSER       ( SLAVE25_BUSER ),
  .SLAVE_BVALID      ( SLAVE25_BVALID ),
  .SLAVE_BREADY      ( SLAVE25_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[25] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 26 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE26_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv26 (
  .sysClk            (S_CLK[26]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE26_ARID ),
  .SLAVE_ARADDR      ( SLAVE26_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE26_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE26_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE26_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE26_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE26_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE26_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE26_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE26_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE26_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE26_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE26_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE26_RID ),
  .SLAVE_RDATA       ( SLAVE26_RDATA ),
  .SLAVE_RRESP       ( SLAVE26_RRESP ),
  .SLAVE_RLAST       ( SLAVE26_RLAST ),
  .SLAVE_RUSER       ( SLAVE26_RUSER ),
  .SLAVE_RVALID      ( SLAVE26_RVALID ),
  .SLAVE_RREADY      ( SLAVE26_RREADY ),

  .SLAVE_AWID        ( SLAVE26_AWID ),
  .SLAVE_AWADDR      ( SLAVE26_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE26_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE26_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE26_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE26_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE26_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE26_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE26_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE26_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE26_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE26_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE26_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE26_WDATA ),
  .SLAVE_WSTRB       ( SLAVE26_WSTRB ),
  .SLAVE_WLAST       ( SLAVE26_WLAST ),
  .SLAVE_WUSER       ( SLAVE26_WUSER ),
  .SLAVE_WVALID      ( SLAVE26_WVALID ),
  .SLAVE_WREADY      ( SLAVE26_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE26_BID ),
  .SLAVE_BRESP       ( SLAVE26_BRESP ),
  .SLAVE_BUSER       ( SLAVE26_BUSER ),
  .SLAVE_BVALID      ( SLAVE26_BVALID ),
  .SLAVE_BREADY      ( SLAVE26_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[26] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);


 Axi4SlaveGen # (

    .SLAVE_NUM              ( 27 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE27_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv27 (
  .sysClk            (S_CLK[27]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE27_ARID ),
  .SLAVE_ARADDR      ( SLAVE27_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE27_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE27_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE27_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE27_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE27_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE27_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE27_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE27_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE27_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE27_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE27_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE27_RID ),
  .SLAVE_RDATA       ( SLAVE27_RDATA ),
  .SLAVE_RRESP       ( SLAVE27_RRESP ),
  .SLAVE_RLAST       ( SLAVE27_RLAST ),
  .SLAVE_RUSER       ( SLAVE27_RUSER ),
  .SLAVE_RVALID      ( SLAVE27_RVALID ),
  .SLAVE_RREADY      ( SLAVE27_RREADY ),

  .SLAVE_AWID        ( SLAVE27_AWID ),
  .SLAVE_AWADDR      ( SLAVE27_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE27_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE27_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE27_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE27_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE27_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE27_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE27_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE27_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE27_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE27_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE27_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE27_WDATA ),
  .SLAVE_WSTRB       ( SLAVE27_WSTRB ),
  .SLAVE_WLAST       ( SLAVE27_WLAST ),
  .SLAVE_WUSER       ( SLAVE27_WUSER ),
  .SLAVE_WVALID      ( SLAVE27_WVALID ),
  .SLAVE_WREADY      ( SLAVE27_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE27_BID ),
  .SLAVE_BRESP       ( SLAVE27_BRESP ),
  .SLAVE_BUSER       ( SLAVE27_BUSER ),
  .SLAVE_BVALID      ( SLAVE27_BVALID ),
  .SLAVE_BREADY      ( SLAVE27_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[27] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 28 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE28_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv28 (
  .sysClk            (S_CLK[28]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE28_ARID ),
  .SLAVE_ARADDR      ( SLAVE28_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE28_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE28_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE28_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE28_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE28_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE28_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE28_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE28_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE28_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE28_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE28_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE28_RID ),
  .SLAVE_RDATA       ( SLAVE28_RDATA ),
  .SLAVE_RRESP       ( SLAVE28_RRESP ),
  .SLAVE_RLAST       ( SLAVE28_RLAST ),
  .SLAVE_RUSER       ( SLAVE28_RUSER ),
  .SLAVE_RVALID      ( SLAVE28_RVALID ),
  .SLAVE_RREADY      ( SLAVE28_RREADY ),

  .SLAVE_AWID        ( SLAVE28_AWID ),
  .SLAVE_AWADDR      ( SLAVE28_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE28_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE28_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE28_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE28_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE28_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE28_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE28_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE28_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE28_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE28_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE28_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE28_WDATA ),
  .SLAVE_WSTRB       ( SLAVE28_WSTRB ),
  .SLAVE_WLAST       ( SLAVE28_WLAST ),
  .SLAVE_WUSER       ( SLAVE28_WUSER ),
  .SLAVE_WVALID      ( SLAVE28_WVALID ),
  .SLAVE_WREADY      ( SLAVE28_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE28_BID ),
  .SLAVE_BRESP       ( SLAVE28_BRESP ),
  .SLAVE_BUSER       ( SLAVE28_BUSER ),
  .SLAVE_BVALID      ( SLAVE28_BVALID ),
  .SLAVE_BREADY      ( SLAVE28_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[28] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 29 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE29_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv29 (
  .sysClk            (S_CLK[29]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE29_ARID ),
  .SLAVE_ARADDR      ( SLAVE29_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE29_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE29_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE29_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE29_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE29_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE29_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE29_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE29_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE29_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE29_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE29_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE29_RID ),
  .SLAVE_RDATA       ( SLAVE29_RDATA ),
  .SLAVE_RRESP       ( SLAVE29_RRESP ),
  .SLAVE_RLAST       ( SLAVE29_RLAST ),
  .SLAVE_RUSER       ( SLAVE29_RUSER ),
  .SLAVE_RVALID      ( SLAVE29_RVALID ),
  .SLAVE_RREADY      ( SLAVE29_RREADY ),

  .SLAVE_AWID        ( SLAVE29_AWID ),
  .SLAVE_AWADDR      ( SLAVE29_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE29_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE29_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE29_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE29_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE29_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE29_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE29_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE29_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE29_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE29_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE29_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE29_WDATA ),
  .SLAVE_WSTRB       ( SLAVE29_WSTRB ),
  .SLAVE_WLAST       ( SLAVE29_WLAST ),
  .SLAVE_WUSER       ( SLAVE29_WUSER ),
  .SLAVE_WVALID      ( SLAVE29_WVALID ),
  .SLAVE_WREADY      ( SLAVE29_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE29_BID ),
  .SLAVE_BRESP       ( SLAVE29_BRESP ),
  .SLAVE_BUSER       ( SLAVE29_BUSER ),
  .SLAVE_BVALID      ( SLAVE29_BVALID ),
  .SLAVE_BREADY      ( SLAVE29_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[29] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

 Axi4SlaveGen # (

    .SLAVE_NUM              ( 30 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE8_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv30 (
  .sysClk            (S_CLK[30]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE30_ARID ),
  .SLAVE_ARADDR      ( SLAVE30_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE30_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE30_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE30_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE30_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE30_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE30_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE30_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE30_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE30_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE30_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE30_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE30_RID ),
  .SLAVE_RDATA       ( SLAVE30_RDATA ),
  .SLAVE_RRESP       ( SLAVE30_RRESP ),
  .SLAVE_RLAST       ( SLAVE30_RLAST ),
  .SLAVE_RUSER       ( SLAVE30_RUSER ),
  .SLAVE_RVALID      ( SLAVE30_RVALID ),
  .SLAVE_RREADY      ( SLAVE30_RREADY ),

  .SLAVE_AWID        ( SLAVE30_AWID ),
  .SLAVE_AWADDR      ( SLAVE30_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE30_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE30_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE30_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE30_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE30_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE30_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE30_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE30_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE30_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE30_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE30_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE30_WDATA ),
  .SLAVE_WSTRB       ( SLAVE30_WSTRB ),
  .SLAVE_WLAST       ( SLAVE30_WLAST ),
  .SLAVE_WUSER       ( SLAVE30_WUSER ),
  .SLAVE_WVALID      ( SLAVE30_WVALID ),
  .SLAVE_WREADY      ( SLAVE30_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE30_BID ),
  .SLAVE_BRESP       ( SLAVE30_BRESP ),
  .SLAVE_BUSER       ( SLAVE30_BUSER ),
  .SLAVE_BVALID      ( SLAVE30_BVALID ),
  .SLAVE_BREADY      ( SLAVE30_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[30] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);


 Axi4SlaveGen # (

    .SLAVE_NUM              ( 31 ),                 // defines slave port number
    .ID_WIDTH               ( MASTERID_WIDTH ), 
    .ADDR_WIDTH              ( ADDR_WIDTH ),
    .DATA_WIDTH             ( SLAVE31_DATA_WIDTH ),
    .SUPPORT_USER_SIGNALS   ( SUPPORT_USER_SIGNALS ),
    .USER_WIDTH             ( USER_WIDTH ),
    .LOWER_COMPARE_BIT       ( NUM_AXISLAVE_BITS ),
    .OPENTRANS_MAX          ( OPEN_SLTRANS_MAX )
  ) slv31 (
  .sysClk            (S_CLK[31]),
  .ARESETN           ( ARESETN ),      // active high reset synchronoise to RE AClk - asserted async.

  .SLAVE_ARID        ( SLAVE31_ARID ),
  .SLAVE_ARADDR      ( SLAVE31_ARADDR ),
  .SLAVE_ARLEN       ( SLAVE31_ARLEN ),
  .SLAVE_ARSIZE      ( SLAVE31_ARSIZE ),
  .SLAVE_ARBURST     ( SLAVE31_ARBURST ),
  .SLAVE_ARLOCK      ( SLAVE31_ARLOCK ),
  .SLAVE_ARCACHE     ( SLAVE31_ARCACHE ),
  .SLAVE_ARPROT      ( SLAVE31_ARPROT ),
  .SLAVE_ARREGION    ( SLAVE31_ARREGION ),
  .SLAVE_ARQOS       ( SLAVE31_ARQOS ),    // not used
  .SLAVE_ARUSER      ( SLAVE31_ARUSER ),
  .SLAVE_ARVALID     ( SLAVE31_ARVALID ),
  .SLAVE_ARREADY     ( SLAVE31_ARREADY ),
  
  // Slave Read Data Ports
  .SLAVE_RID         ( SLAVE31_RID ),
  .SLAVE_RDATA       ( SLAVE31_RDATA ),
  .SLAVE_RRESP       ( SLAVE31_RRESP ),
  .SLAVE_RLAST       ( SLAVE31_RLAST ),
  .SLAVE_RUSER       ( SLAVE31_RUSER ),
  .SLAVE_RVALID      ( SLAVE31_RVALID ),
  .SLAVE_RREADY      ( SLAVE31_RREADY ),

  .SLAVE_AWID        ( SLAVE31_AWID ),
  .SLAVE_AWADDR      ( SLAVE31_AWADDR ),
  .SLAVE_AWLEN       ( SLAVE31_AWLEN ),
  .SLAVE_AWSIZE      ( SLAVE31_AWSIZE ),
  .SLAVE_AWBURST     ( SLAVE31_AWBURST ),
  .SLAVE_AWLOCK      ( SLAVE31_AWLOCK ),
  .SLAVE_AWCACHE     ( SLAVE31_AWCACHE ),
  .SLAVE_AWPROT      ( SLAVE31_AWPROT ),
  .SLAVE_AWREGION    ( SLAVE31_AWREGION ),
  .SLAVE_AWQOS       ( SLAVE31_AWQOS ),        // not used internally
  .SLAVE_AWUSER      ( SLAVE31_AWUSER ),        // not used internally
  .SLAVE_AWVALID     ( SLAVE31_AWVALID ),
  .SLAVE_AWREADY     ( SLAVE31_AWREADY ),

  // Slave Write Data Ports
  .SLAVE_WDATA       ( SLAVE31_WDATA ),
  .SLAVE_WSTRB       ( SLAVE31_WSTRB ),
  .SLAVE_WLAST       ( SLAVE31_WLAST ),
  .SLAVE_WUSER       ( SLAVE31_WUSER ),
  .SLAVE_WVALID      ( SLAVE31_WVALID ),
  .SLAVE_WREADY      ( SLAVE31_WREADY ),

  // Slave Write Response Ports
  .SLAVE_BID         ( SLAVE31_BID ),
  .SLAVE_BRESP       ( SLAVE31_BRESP ),
  .SLAVE_BUSER       ( SLAVE31_BUSER ),
  .SLAVE_BVALID      ( SLAVE31_BVALID ),
  .SLAVE_BREADY      ( SLAVE31_BREADY ),

  // ===============  Control Signals  =======================================================//
  .SLAVE_ARREADY_Default ( SLAVE_ARREADY_Default ),      // defines whether SLAVE asserts ready or waits for ARVALID
  .SLAVE_AWREADY_Default ( SLAVE_AWREADY_Default ),      // defines whether SLAVE asserts ready or waits for WVALID
  .SLAVE_DATA_IDLE_EN    ( SLAVE_DATA_IDLE_EN ),          // Enables idle cycles to be inserted in Data channels
  .SLAVE_DATA_IDLE_CYCLES( SLAVE_DATA_IDLE_CYCLES ),      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3
  .FORCE_ERROR           ( FORCE_ERROR[31] ),              // Forces error pn read/write RESP
  .ERROR_BYTE             ( ERROR_BYTE  )                // Byte to force error on - for READs
);

  //====================================================================================================================================
  // AXI4/AHB Master transactor models - one for each mirrored master interface
  //====================================================================================================================================
  // Generate for Master0
  generate // mst0
  if (NUM_MASTERS > 0) begin
  if (MASTER0_TYPE != 2'b10)
  begin
    AxiMaster #

          (
            .MASTER_NUM          ( 0 ),    // master number
            .MASTER_TYPE         ( MASTER_TYPE[1:0] ),
            .ID_WIDTH            ( ID_WIDTH ),
            .ADDR_WIDTH          ( ADDR_WIDTH ),
            .DATA_WIDTH          ( MASTER0_DATA_WIDTH ), 
            .SUPPORT_USER_SIGNALS( SUPPORT_USER_SIGNALS ),
            .USER_WIDTH          ( USER_WIDTH ),
            .OPENTRANS_MAX       ( OPEN_MTTRANS_MAX )  // Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.
          )
        mst0  (
            // Global Signals
            .sysClk                 ( M_CLK[0] ),
            .ARESETN                ( ARESETN ),
            // Master Read Address Ports
            .MASTER_ARID            ( MASTER0_ARID ),
            .MASTER_ARADDR          ( MASTER0_ARADDR ),
            .MASTER_ARLEN            ( MASTER0_ARLEN ),
            .MASTER_ARSIZE          ( MASTER0_ARSIZE ),
            .MASTER_ARBURST          ( MASTER0_ARBURST ),
            .MASTER_ARLOCK          ( MASTER0_ARLOCK ),
            .MASTER_ARCACHE          ( MASTER0_ARCACHE ),
            .MASTER_ARPROT          ( MASTER0_ARPROT ),
            .MASTER_ARREGION        ( MASTER0_ARREGION ),    // not used
            .MASTER_ARQOS            ( MASTER0_ARQOS ),      // not used
            .MASTER_ARUSER          ( MASTER0_ARUSER ),
            .MASTER_ARVALID          ( MASTER0_ARVALID ),
            .MASTER_ARREADY          ( MASTER0_ARREADY ),

            // Master Read Data Ports
            .MASTER_RID              ( MASTER0_RID ),
            .MASTER_RDATA            ( MASTER0_RDATA ),
            .MASTER_RRESP            ( MASTER0_RRESP ),
            .MASTER_RLAST            ( MASTER0_RLAST ),
            .MASTER_RUSER            ( MASTER0_RUSER ),
            .MASTER_RVALID          ( MASTER0_RVALID ),
            .MASTER_RREADY          ( MASTER0_RREADY ),

            // Master Write Address Ports
            .MASTER_AWID            ( MASTER0_AWID ),
            .MASTER_AWADDR          ( MASTER0_AWADDR ),
            .MASTER_AWLEN            ( MASTER0_AWLEN ),
            .MASTER_AWSIZE          ( MASTER0_AWSIZE ),
            .MASTER_AWBURST          ( MASTER0_AWBURST ),
            .MASTER_AWLOCK          ( MASTER0_AWLOCK ),
            .MASTER_AWCACHE          ( MASTER0_AWCACHE ),
            .MASTER_AWPROT          ( MASTER0_AWPROT ),
            .MASTER_AWREGION        ( MASTER0_AWREGION ),    // not used
            .MASTER_AWQOS            ( MASTER0_AWQOS ),      // not used
            .MASTER_AWUSER          ( MASTER0_AWUSER ),
            .MASTER_AWVALID          ( MASTER0_AWVALID ),
            .MASTER_AWREADY          ( MASTER0_AWREADY ),

            // Master Write Data Ports
            .MASTER_WID              ( MASTER0_WID ),
            .MASTER_WDATA            ( MASTER0_WDATA ),
            .MASTER_WSTRB            ( MASTER0_WSTRB ),
            .MASTER_WLAST            ( MASTER0_WLAST ),
            .MASTER_WUSER            ( MASTER0_WUSER ),
            .MASTER_WVALID          ( MASTER0_WVALID ),
            .MASTER_WREADY          ( MASTER0_WREADY ),

            // Master Write Response Ports
            .MASTER_BID              ( MASTER0_BID ),
            .MASTER_BRESP            ( MASTER0_BRESP ),
            .MASTER_BUSER            ( MASTER0_BUSER ),
            .MASTER_BVALID          ( MASTER0_BVALID ),
            .MASTER_BREADY          ( MASTER0_BREADY ),

            // ===============  Control Signals  =======================================================//
            .MASTER_RREADY_Default  ( MASTER_RREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
            .MASTER_WREADY_Default  ( MASTER_WREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
            .d_MASTER_BREADY_default( d_MASTER_BREADY_default ),  // defines whether Master asserts ready or waits for RVALID
            .rdStart                ( rdStart[0] ),          // defines whether Master starts a transaction
            .rdBurstLen              ( rdBurstLen ),          // burst length of read transaction
            .rdStartAddr            ( rdStartAddr ),        // start addresss for read transaction
            .rdAID                  ( rdAID ),            // AID for read transactions
            .masterRdAddrDone        ( masterRdAddrDone[0] ),    // Asserted when a read transaction has been completed
            .masterRdDone            ( masterRdDone[0] ),      // Asserted when a read transaction has been completed
            .masterRdStatus          ( masterRdStatus[0] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
            .mstRAddrIdle            ( mstRAddrIdle[0] ),
            .rdASize                ( rdASize[0] ),          // read size for each transfer in burst
            .expRResp                ( expRResp[0] ),        // indicate Read Respons expected
            .expWResp                ( expWResp[0] ),        // indicate Write Respons expected
            .wrASize                 ( wrASize[0] ),          // write size for each transfer in burst
            .wrStart                ( wrStart[0] ),          // defines whether Master starts a transaction
            .BurstType              ( BurstType ),          // Type of burst - FIXED=00, INCR=01, WRAP=10 
            .wrBurstLen             ( wrBurstLen ),          // burst length of write transaction
            .wrStartAddr            ( wrStartAddr ),        // start addresss for write transaction
            .wrAID                  ( wrAID ),            // AID for write transactions

            .masterWrAddrDone        ( masterWrAddrDone[0] ),    // Address Write transaction has been completed
            .masterWrDone           ( masterWrDone[0] ),      // Asserted when a write transaction has been completed
            .masterWrStatus         ( masterWrStatus[0] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
            .mstWAddrIdle           ( mstWAddrIdle[0] ),      // indicates Read Address Bus is idle
            .masterRespDone          ( masterRespDone[0] ),      // Asserted when a write response transaction has completed
            .mstWrAddrFull          ( mstWrAddrFull[0]  ),      // Asserted when the internal queue for writes are full
            .mstRdAddrFull          ( mstRdAddrFull[0]  )      // Asserted when the internal queue for reads are full
      );
    end
    else if (MASTER0_TYPE == 2'b10)
    begin
      assign MASTER0_AWVALID  = 1'b0;

      assign MASTER0_AWID      = 0;
      assign MASTER0_AWADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER0_AWLEN    = 0;
      assign MASTER0_AWSIZE   = 0;
      assign MASTER0_AWBURST  = 0;
      assign MASTER0_AWLOCK   = 0;
      assign MASTER0_AWCACHE  = 0;
      assign MASTER0_AWPROT   = 0;
      assign MASTER0_AWREGION  = 0;
      assign MASTER0_AWQOS    = 0;    // not used
      assign MASTER0_AWUSER   = 0;

      assign MASTER0_WVALID  = 0;
      assign MASTER0_WDATA  = 0;
      assign MASTER0_WSTRB  = 0;
      assign MASTER0_WUSER  = 0;
      assign MASTER0_WLAST  = 0;

      assign MASTER0_ARVALID  = 1'b0;

      assign MASTER0_ARID      = 0;
      assign MASTER0_ARADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER0_ARLEN    = 0;
      assign MASTER0_ARSIZE   = 0;
      assign MASTER0_ARBURST  = 0;
      assign MASTER0_ARLOCK   = 0;
      assign MASTER0_ARCACHE  = 0;
      assign MASTER0_ARPROT   = 0;
      assign MASTER0_ARREGION  = 0;
      assign MASTER0_ARQOS    = 0;    // not used
      assign MASTER0_ARUSER   = 0;

      assign MASTER0_RREADY = 1'b0;


      AHBL_Master #(
          .AHB_AWIDTH        (AHB_AWIDTH),
          .AHB_DWIDTH        (MASTER0_DATA_WIDTH),
          .UNDEF_BURST      (UNDEF_BURST_MASTER0)
           )
      mst0 (
        // AHB Interface
        // Global Signal
         .HCLK          (M_CLK[0]),

         .HRESETn        (ARESETN),
         .HSEL          (MASTER0_HSEL),
         .HADDR          (MASTER0_HADDR),
         .HWRITE        (MASTER0_HWRITE),
         .HREADY        (MASTER0_HREADY),
         .HTRANS        (MASTER0_HTRANS),
         .HSIZE          (MASTER0_HSIZE),
         .HWDATA        (MASTER0_HWDATA),
         .HBURST        (MASTER0_HBURST),
         .HMASTLOCK      (MASTER0_HMASTLOCK),
         .HRESP          (MASTER0_HRESP),
         .HRDATA        (MASTER0_HRDATA),

         .HNONSEC        (MASTER0_HNONSEC),
         .HPROT          (MASTER0_HPROT),

         .start_tx      (start_tx[0]),
         .end_tx        (end_tx[0]),
         .hburst_tx      (hburst),
         .hsize_tx      (hsize),
         .haddr_tx      (haddr),
         .hwrite_tx      (hwrite)
         );
    end
    end
    endgenerate // mst0

  // Generate for Master1
  generate // mst1
  if (NUM_MASTERS > 1) begin
  if (MASTER1_TYPE != 2'b10)
  begin
    AxiMaster #
        (
          .MASTER_NUM          ( 1 ),    // master number
          .MASTER_TYPE         ( MASTER_TYPE[3:2] ),
          .ID_WIDTH            ( ID_WIDTH ),

          .ADDR_WIDTH          ( ADDR_WIDTH ),
          .DATA_WIDTH          ( MASTER1_DATA_WIDTH), 
          .SUPPORT_USER_SIGNALS( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH          ( USER_WIDTH ),
          .OPENTRANS_MAX       ( OPEN_MTTRANS_MAX )  // Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.
        )
      mst1  (
          // Global Signals
          .sysClk                 ( M_CLK[1] ),
          .ARESETN                ( ARESETN ),

          // Master Read Address Ports
          .MASTER_ARID            ( MASTER1_ARID ),
          .MASTER_ARADDR          ( MASTER1_ARADDR ),
          .MASTER_ARLEN            ( MASTER1_ARLEN ),
          .MASTER_ARSIZE          ( MASTER1_ARSIZE ),
          .MASTER_ARBURST          ( MASTER1_ARBURST ),
          .MASTER_ARLOCK          ( MASTER1_ARLOCK ),
          .MASTER_ARCACHE          ( MASTER1_ARCACHE ),
          .MASTER_ARPROT          ( MASTER1_ARPROT ),
          .MASTER_ARREGION        ( MASTER1_ARREGION ),    // not used
          .MASTER_ARQOS            ( MASTER1_ARQOS ),      // not used
          .MASTER_ARUSER          ( MASTER1_ARUSER ),
          .MASTER_ARVALID          ( MASTER1_ARVALID ),
          .MASTER_ARREADY          ( MASTER1_ARREADY ),

          // Master Read Data Ports
          .MASTER_RID              ( MASTER1_RID ),
          .MASTER_RDATA            ( MASTER1_RDATA ),
          .MASTER_RRESP            ( MASTER1_RRESP ),
          .MASTER_RLAST            ( MASTER1_RLAST ),
          .MASTER_RUSER            ( MASTER1_RUSER ),
          .MASTER_RVALID          ( MASTER1_RVALID ),
          .MASTER_RREADY          ( MASTER1_RREADY ),

          // Master Write Address Ports
          .MASTER_AWID            ( MASTER1_AWID ),
          .MASTER_AWADDR          ( MASTER1_AWADDR ),
          .MASTER_AWLEN            ( MASTER1_AWLEN ),
          .MASTER_AWSIZE          ( MASTER1_AWSIZE ),
          .MASTER_AWBURST          ( MASTER1_AWBURST ),
          .MASTER_AWLOCK          ( MASTER1_AWLOCK ),
          .MASTER_AWCACHE          ( MASTER1_AWCACHE ),
          .MASTER_AWPROT          ( MASTER1_AWPROT ),
          .MASTER_AWREGION        ( MASTER1_AWREGION ),    // not used
          .MASTER_AWQOS            ( MASTER1_AWQOS ),        // not used
          .MASTER_AWUSER          ( MASTER1_AWUSER ),
          .MASTER_AWVALID          ( MASTER1_AWVALID ),
          .MASTER_AWREADY          ( MASTER1_AWREADY ),

          // Master Write Data Ports
          .MASTER_WID              ( MASTER1_WID ),
          .MASTER_WDATA            ( MASTER1_WDATA ),
          .MASTER_WSTRB            ( MASTER1_WSTRB ),
          .MASTER_WLAST            ( MASTER1_WLAST ),
          .MASTER_WUSER            ( MASTER1_WUSER ),
          .MASTER_WVALID          ( MASTER1_WVALID ),
          .MASTER_WREADY          ( MASTER1_WREADY ),

          // Master Write Response Ports
          .MASTER_BID              ( MASTER1_BID ),
          .MASTER_BRESP            ( MASTER1_BRESP ),
          .MASTER_BUSER            ( MASTER1_BUSER ),
          .MASTER_BVALID          ( MASTER1_BVALID ),
          .MASTER_BREADY          ( MASTER1_BREADY ),

          // ===============  Control Signals  =======================================================//
          .MASTER_RREADY_Default  ( MASTER_RREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .MASTER_WREADY_Default  ( MASTER_WREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .d_MASTER_BREADY_default( d_MASTER_BREADY_default ),  // defines whether Master asserts ready or waits for RVALID
          .rdStart                ( rdStart[1] ),          // defines whether Master starts a transaction
          .rdBurstLen              ( rdBurstLen ),          // burst length of read transaction
          .rdStartAddr            ( rdStartAddr ),        // start addresss for read transaction
          .rdAID                  ( rdAID ),            // AID for read transactions
          .masterRdAddrDone        ( masterRdAddrDone[1] ),    // Asserted when a read transaction has been completed
          .masterRdDone            ( masterRdDone[1] ),      // Asserted when a read transaction has been completed
          .masterRdStatus          ( masterRdStatus[1] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstRAddrIdle            ( mstRAddrIdle[1] ),
          .rdASize                ( rdASize[1] ),          // read size for each transfer in burst
          .expRResp                ( expRResp[1] ),        // indicate Read Respons expected
          .expWResp                ( expWResp[1] ),        // indicate Write Respons expected
          .wrASize                 ( wrASize[1] ),          // write size for each transfer in burst
          .wrStart                ( wrStart[1] ),          // defines whether Master starts a transaction
          .BurstType              ( BurstType ),          // Type of burst - FIXED=00, INCR=01, WRAP=10 
          .wrBurstLen             ( wrBurstLen ),          // burst length of write transaction
          .wrStartAddr            ( wrStartAddr ),        // start addresss for write transaction
          .wrAID                  ( wrAID ),            // AID for write transactions

          .masterWrAddrDone        ( masterWrAddrDone[1] ),    // Address Write transaction has been completed
          .masterWrDone           ( masterWrDone[1] ),      // Asserted when a write transaction has been completed
          .masterWrStatus         ( masterWrStatus[1] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstWAddrIdle           ( mstWAddrIdle[1] ),      // indicates Read Address Bus is idle
          .masterRespDone          ( masterRespDone[1] ),      // Asserted when a write response transaction has completed
          .mstWrAddrFull          ( mstWrAddrFull[1]  ),      // Asserted when the internal queue for writes are full
          .mstRdAddrFull          ( mstRdAddrFull[1]  )      // Asserted when the internal queue for reads are full
    );
    end
    else if (MASTER1_TYPE == 2'b10)
    begin
      assign MASTER1_AWVALID  = 1'b0;

      assign MASTER1_AWID      = 0;
      assign MASTER1_AWADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER1_AWLEN    = 0;
      assign MASTER1_AWSIZE   = 0;
      assign MASTER1_AWBURST  = 0;
      assign MASTER1_AWLOCK   = 0;
      assign MASTER1_AWCACHE  = 0;
      assign MASTER1_AWPROT   = 0;
      assign MASTER1_AWREGION  = 0;
      assign MASTER1_AWQOS    = 0;    // not used
      assign MASTER1_AWUSER   = 0;

      assign MASTER1_WVALID  = 0;
      assign MASTER1_WDATA  = 0;
      assign MASTER1_WSTRB  = 0;
      assign MASTER1_WUSER  = 0;
      assign MASTER1_WLAST  = 0;

      assign MASTER1_ARVALID  = 1'b0;

      assign MASTER1_ARID      = 0;
      assign MASTER1_ARADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER1_ARLEN    = 0;
      assign MASTER1_ARSIZE   = 0;
      assign MASTER1_ARBURST  = 0;
      assign MASTER1_ARLOCK   = 0;
      assign MASTER1_ARCACHE  = 0;
      assign MASTER1_ARPROT   = 0;
      assign MASTER1_ARREGION  = 0;
      assign MASTER1_ARQOS    = 0;    // not used
      assign MASTER1_ARUSER   = 0;

      assign MASTER1_RREADY = 1'b0;

      AHBL_Master #(
          .AHB_AWIDTH      (AHB_AWIDTH),
          .AHB_DWIDTH      (MASTER1_DATA_WIDTH),
          .UNDEF_BURST      (UNDEF_BURST_MASTER1)
           )
      mst1 (
        // AHB Interface
        // Global Signal
         .HCLK          (M_CLK[1]),

         .HRESETn        (ARESETN),
         .HSEL          (MASTER1_HSEL),
         .HADDR          (MASTER1_HADDR),
         .HWRITE        (MASTER1_HWRITE),
         .HREADY        (MASTER1_HREADY),
         .HTRANS        (MASTER1_HTRANS),
         .HSIZE          (MASTER1_HSIZE),
         .HWDATA        (MASTER1_HWDATA),
         .HBURST        (MASTER1_HBURST),
         .HMASTLOCK      (MASTER1_HMASTLOCK),
         .HRESP          (MASTER1_HRESP),
         .HRDATA        (MASTER1_HRDATA),

         .HNONSEC        (MASTER1_HNONSEC),
         .HPROT          (MASTER1_HPROT),

         .start_tx      (start_tx[1]),
         .end_tx        (end_tx[1]),
         .hburst_tx      (hburst),
         .hsize_tx      (hsize),
         .haddr_tx      (haddr),
         .hwrite_tx      (hwrite)
         );
    end
    end
    endgenerate // mst1

  // Generate for Master2
  generate // mst2
  if (NUM_MASTERS > 2) begin
  if (MASTER2_TYPE != 2'b10)
  begin
    AxiMaster # 
        (
          .MASTER_NUM          ( 2 ),    // master number
          .MASTER_TYPE         ( MASTER_TYPE[5:4] ),
          .ID_WIDTH            ( ID_WIDTH ),

          .ADDR_WIDTH          ( ADDR_WIDTH ),
          .DATA_WIDTH          ( MASTER2_DATA_WIDTH ), 
          .SUPPORT_USER_SIGNALS( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH          ( USER_WIDTH ),
          .OPENTRANS_MAX       ( OPEN_MTTRANS_MAX )  // Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.
        )
      mst2  (
          // Global Signals
          .sysClk                 ( M_CLK[2] ),
          .ARESETN                ( ARESETN ),

          // Master Read Address Ports
          .MASTER_ARID            ( MASTER2_ARID ),
          .MASTER_ARADDR          ( MASTER2_ARADDR ),
          .MASTER_ARLEN            ( MASTER2_ARLEN ),
          .MASTER_ARSIZE          ( MASTER2_ARSIZE ),
          .MASTER_ARBURST          ( MASTER2_ARBURST ),
          .MASTER_ARLOCK          ( MASTER2_ARLOCK ),
          .MASTER_ARCACHE          ( MASTER2_ARCACHE ),
          .MASTER_ARPROT          ( MASTER2_ARPROT ),
          .MASTER_ARREGION        ( MASTER2_ARREGION ),    // not used
          .MASTER_ARQOS            ( MASTER2_ARQOS ),      // not used
          .MASTER_ARUSER          ( MASTER2_ARUSER ),
          .MASTER_ARVALID          ( MASTER2_ARVALID ),
          .MASTER_ARREADY          ( MASTER2_ARREADY ),

          // Master Read Data Ports
          .MASTER_RID              ( MASTER2_RID ),
          .MASTER_RDATA            ( MASTER2_RDATA ),
          .MASTER_RRESP            ( MASTER2_RRESP ),
          .MASTER_RLAST            ( MASTER2_RLAST ),
          .MASTER_RUSER            ( MASTER2_RUSER ),
          .MASTER_RVALID          ( MASTER2_RVALID ),
          .MASTER_RREADY          ( MASTER2_RREADY ),

          // Master Write Address Ports
          .MASTER_AWID            ( MASTER2_AWID ),
          .MASTER_AWADDR          ( MASTER2_AWADDR ),
          .MASTER_AWLEN            ( MASTER2_AWLEN ),
          .MASTER_AWSIZE          ( MASTER2_AWSIZE ),
          .MASTER_AWBURST          ( MASTER2_AWBURST ),
          .MASTER_AWLOCK          ( MASTER2_AWLOCK ),
          .MASTER_AWCACHE          ( MASTER2_AWCACHE ),
          .MASTER_AWPROT          ( MASTER2_AWPROT ),
          .MASTER_AWREGION        ( MASTER2_AWREGION ),    // not used
          .MASTER_AWQOS            ( MASTER2_AWQOS ),      // not used
          .MASTER_AWUSER          ( MASTER2_AWUSER ),
          .MASTER_AWVALID          ( MASTER2_AWVALID ),
          .MASTER_AWREADY          ( MASTER2_AWREADY ),

          // Master Write Data Ports
          .MASTER_WID              ( MASTER2_WID ),
          .MASTER_WDATA            ( MASTER2_WDATA ),
          .MASTER_WSTRB            ( MASTER2_WSTRB ),
          .MASTER_WLAST            ( MASTER2_WLAST ),
          .MASTER_WUSER            ( MASTER2_WUSER ),
          .MASTER_WVALID          ( MASTER2_WVALID ),
          .MASTER_WREADY          ( MASTER2_WREADY ),
  
          // Master Write Response Ports
          .MASTER_BID              ( MASTER2_BID ),
          .MASTER_BRESP            ( MASTER2_BRESP ),
          .MASTER_BUSER            ( MASTER2_BUSER ),
          .MASTER_BVALID          ( MASTER2_BVALID ),
          .MASTER_BREADY          ( MASTER2_BREADY ),
   
          // ===============  Control Signals  =======================================================//
          .MASTER_RREADY_Default  ( MASTER_RREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .MASTER_WREADY_Default  ( MASTER_WREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .d_MASTER_BREADY_default( d_MASTER_BREADY_default ),  // defines whether Master asserts ready or waits for RVALID
          .rdStart                ( rdStart[2] ),          // defines whether Master starts a transaction
          .rdBurstLen              ( rdBurstLen ),          // burst length of read transaction
          .rdStartAddr            ( rdStartAddr ),        // start addresss for read transaction
          .rdAID                  ( rdAID ),            // AID for read transactions
          .masterRdAddrDone        ( masterRdAddrDone[2] ),    // Asserted when a read transaction has been completed
          .masterRdDone            ( masterRdDone[2] ),      // Asserted when a read transaction has been completed
          .masterRdStatus          ( masterRdStatus[2] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstRAddrIdle            ( mstRAddrIdle[2] ),
          .rdASize                ( rdASize[2] ),          // read size for each transfer in burst
          .expRResp                ( expRResp[2] ),        // indicate Read Respons expected
          .expWResp                ( expWResp[2] ),        // indicate Write Respons expected
          .wrASize                 ( wrASize[2] ),          // write size for each transfer in burst
          .wrStart                ( wrStart[2] ),          // defines whether Master starts a transaction
          .BurstType              ( BurstType ),          // Type of burst - FIXED=00, INCR=01, WRAP=10 
          .wrBurstLen             ( wrBurstLen ),          // burst length of write transaction
          .wrStartAddr            ( wrStartAddr ),        // start addresss for write transaction
          .wrAID                  ( wrAID ),            // AID for write transactions

          .masterWrAddrDone        ( masterWrAddrDone[2] ),    // Address Write transaction has been completed
          .masterWrDone           ( masterWrDone[2] ),      // Asserted when a write transaction has been completed
          .masterWrStatus         ( masterWrStatus[2] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstWAddrIdle           ( mstWAddrIdle[2] ),      // indicates Read Address Bus is idle
          .masterRespDone          ( masterRespDone[2] ),      // Asserted when a write response transaction has completed
          .mstWrAddrFull          ( mstWrAddrFull[2]  ),      // Asserted when the internal queue for writes are full
          .mstRdAddrFull          ( mstRdAddrFull[2]  )      // Asserted when the internal queue for reads are full

    );
    end
    else if (MASTER2_TYPE == 2'b10)
    begin
      assign MASTER2_AWVALID  = 1'b0;

      assign MASTER2_AWID      = 0;
      assign MASTER2_AWADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER2_AWLEN    = 0;
      assign MASTER2_AWSIZE   = 0;
      assign MASTER2_AWBURST  = 0;
      assign MASTER2_AWLOCK   = 0;
      assign MASTER2_AWCACHE  = 0;
      assign MASTER2_AWPROT   = 0;
      assign MASTER2_AWREGION  = 0;
      assign MASTER2_AWQOS    = 0;    // not used
      assign MASTER2_AWUSER   = 0;

      assign MASTER2_WVALID  = 0;
      assign MASTER2_WDATA  = 0;
      assign MASTER2_WSTRB  = 0;
      assign MASTER2_WUSER  = 0;
      assign MASTER2_WLAST  = 0;

      assign MASTER2_ARVALID  = 1'b0;

      assign MASTER2_ARID      = 0;
      assign MASTER2_ARADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER2_ARLEN    = 0;
      assign MASTER2_ARSIZE   = 0;
      assign MASTER2_ARBURST  = 0;
      assign MASTER2_ARLOCK   = 0;
      assign MASTER2_ARCACHE  = 0;
      assign MASTER2_ARPROT   = 0;
      assign MASTER2_ARREGION  = 0;
      assign MASTER2_ARQOS    = 0;    // not used
      assign MASTER2_ARUSER   = 0;

      assign MASTER2_RREADY = 1'b0;


      AHBL_Master #(
          .AHB_AWIDTH        (AHB_AWIDTH),
          .AHB_DWIDTH        (MASTER2_DATA_WIDTH),
          .UNDEF_BURST      (UNDEF_BURST_MASTER2)
           )
      mst2              (
        // AHB Interface
        // Global Signal
         .HCLK          (M_CLK[2]),

         .HRESETn        (ARESETN),
         .HSEL          (MASTER2_HSEL),
         .HADDR          (MASTER2_HADDR),
         .HWRITE        (MASTER2_HWRITE),
         .HREADY        (MASTER2_HREADY),
         .HTRANS        (MASTER2_HTRANS),
         .HSIZE          (MASTER2_HSIZE),
         .HWDATA        (MASTER2_HWDATA),
         .HBURST        (MASTER2_HBURST),
         .HMASTLOCK      (MASTER2_HMASTLOCK),
         .HRESP          (MASTER2_HRESP),
         .HRDATA        (MASTER2_HRDATA),

         .HNONSEC        (MASTER2_HNONSEC),
         .HPROT          (MASTER2_HPROT),

         .start_tx      (start_tx[2]),
         .end_tx        (end_tx[2]),
         .hburst_tx      (hburst),
         .hsize_tx      (hsize),
         .haddr_tx      (haddr),
         .hwrite_tx      (hwrite)
         );
    end
    end
    endgenerate // mst2

  // Generate for Master3
  generate // mst3
  if (NUM_MASTERS > 3) begin
  if (MASTER3_TYPE != 2'b10)
  begin
    AxiMaster # 
        (
          .MASTER_NUM          ( 3 ),    // master number
          .MASTER_TYPE         ( MASTER_TYPE[7:6] ),
          .ID_WIDTH            ( ID_WIDTH ),

          .ADDR_WIDTH          ( ADDR_WIDTH ),
          .DATA_WIDTH          ( MASTER3_DATA_WIDTH ), 
          .SUPPORT_USER_SIGNALS( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH          ( USER_WIDTH ),
          .OPENTRANS_MAX       ( OPEN_MTTRANS_MAX )  // Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.
        )
      mst3  (
          // Global Signals
          .sysClk                 ( M_CLK[3] ),
          .ARESETN                ( ARESETN ),

          // Master Read Address Ports
          .MASTER_ARID            ( MASTER3_ARID ),
          .MASTER_ARADDR          ( MASTER3_ARADDR ),
          .MASTER_ARLEN            ( MASTER3_ARLEN ),
          .MASTER_ARSIZE          ( MASTER3_ARSIZE ),
          .MASTER_ARBURST          ( MASTER3_ARBURST ),
          .MASTER_ARLOCK          ( MASTER3_ARLOCK ),
          .MASTER_ARCACHE          ( MASTER3_ARCACHE ),
          .MASTER_ARPROT          ( MASTER3_ARPROT ),
          .MASTER_ARREGION        ( MASTER3_ARREGION ),    // not used
          .MASTER_ARQOS            ( MASTER3_ARQOS ),      // not used
          .MASTER_ARUSER          ( MASTER3_ARUSER ),
          .MASTER_ARVALID          ( MASTER3_ARVALID ),
          .MASTER_ARREADY          ( MASTER3_ARREADY ),

          // Master Read Data Ports
          .MASTER_RID              ( MASTER3_RID ),
          .MASTER_RDATA            ( MASTER3_RDATA ),
          .MASTER_RRESP            ( MASTER3_RRESP ),
          .MASTER_RLAST            ( MASTER3_RLAST ),
          .MASTER_RUSER            ( MASTER3_RUSER ),
          .MASTER_RVALID          ( MASTER3_RVALID ),
          .MASTER_RREADY          ( MASTER3_RREADY ),

          // Master Write Address Ports
          .MASTER_AWID            ( MASTER3_AWID ),
          .MASTER_AWADDR          ( MASTER3_AWADDR ),
          .MASTER_AWLEN            ( MASTER3_AWLEN ),
          .MASTER_AWSIZE          ( MASTER3_AWSIZE ),
          .MASTER_AWBURST          ( MASTER3_AWBURST ),
          .MASTER_AWLOCK          ( MASTER3_AWLOCK ),
          .MASTER_AWCACHE          ( MASTER3_AWCACHE ),
          .MASTER_AWPROT          ( MASTER3_AWPROT ),
          .MASTER_AWREGION        ( MASTER3_AWREGION ),    // not used
          .MASTER_AWQOS            ( MASTER3_AWQOS ),      // not used
          .MASTER_AWUSER          ( MASTER3_AWUSER ),
          .MASTER_AWVALID          ( MASTER3_AWVALID ),
          .MASTER_AWREADY          ( MASTER3_AWREADY ),

          // Master Write Data Ports
          .MASTER_WID              ( MASTER3_WID ),
          .MASTER_WDATA            ( MASTER3_WDATA ),
          .MASTER_WSTRB            ( MASTER3_WSTRB ),
          .MASTER_WLAST            ( MASTER3_WLAST ),
          .MASTER_WUSER            ( MASTER3_WUSER ),
          .MASTER_WVALID          ( MASTER3_WVALID ),
          .MASTER_WREADY          ( MASTER3_WREADY ),

          // Master Write Response Ports
          .MASTER_BID              ( MASTER3_BID ),
          .MASTER_BRESP            ( MASTER3_BRESP ),
          .MASTER_BUSER            ( MASTER3_BUSER ),
          .MASTER_BVALID          ( MASTER3_BVALID ),
          .MASTER_BREADY          ( MASTER3_BREADY ),

          // ===============  Control Signals  =======================================================//
          .MASTER_RREADY_Default  ( MASTER_RREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .MASTER_WREADY_Default  ( MASTER_WREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .d_MASTER_BREADY_default( d_MASTER_BREADY_default ),  // defines whether Master asserts ready or waits for RVALID
          .rdStart                ( rdStart[3] ),          // defines whether Master starts a transaction
          .rdBurstLen              ( rdBurstLen ),          // burst length of read transaction
          .rdStartAddr            ( rdStartAddr ),        // start addresss for read transaction
          .rdAID                  ( rdAID ),            // AID for read transactions
          .masterRdAddrDone        ( masterRdAddrDone[3] ),    // Asserted when a read transaction has been completed
          .masterRdDone            ( masterRdDone[3] ),      // Asserted when a read transaction has been completed
          .masterRdStatus          ( masterRdStatus[3] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstRAddrIdle            ( mstRAddrIdle[3] ),
          .rdASize                ( rdASize[3] ),          // read size for each transfer in burst
          .expRResp                ( expRResp[3] ),        // indicate Read Respons expected
          .expWResp                ( expWResp[3] ),        // indicate Write Respons expected
          .wrASize                 ( wrASize[3] ),          // write size for each transfer in burst
          .wrStart                ( wrStart[3] ),          // defines whether Master starts a transaction
          .BurstType              ( BurstType ),          // Type of burst - FIXED=00, INCR=01, WRAP=10 
          .wrBurstLen             ( wrBurstLen ),          // burst length of write transaction
          .wrStartAddr            ( wrStartAddr ),        // start addresss for write transaction
          .wrAID                  ( wrAID ),            // AID for write transactions

          .masterWrAddrDone        ( masterWrAddrDone[3] ),    // Address Write transaction has been completed
          .masterWrDone           ( masterWrDone[3] ),      // Asserted when a write transaction has been completed
          .masterWrStatus         ( masterWrStatus[3] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstWAddrIdle           ( mstWAddrIdle[3] ),      // indicates Read Address Bus is idle
          .masterRespDone          ( masterRespDone[3] ),      // Asserted when a write response transaction has completed
          .mstWrAddrFull          ( mstWrAddrFull[3]  ),      // Asserted when the internal queue for writes are full
          .mstRdAddrFull          ( mstRdAddrFull[3]  )      // Asserted when the internal queue for reads are full

    );
    end
    else if (MASTER3_TYPE == 2'b10)
    begin
      assign MASTER3_AWVALID  = 1'b0;

      assign MASTER3_AWID      = 0;
      assign MASTER3_AWADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER3_AWLEN    = 0;
      assign MASTER3_AWSIZE   = 0;
      assign MASTER3_AWBURST  = 0;
      assign MASTER3_AWLOCK   = 0;
      assign MASTER3_AWCACHE  = 0;
      assign MASTER3_AWPROT   = 0;
      assign MASTER3_AWREGION  = 0;
      assign MASTER3_AWQOS    = 0;    // not used
      assign MASTER3_AWUSER   = 0;

      assign MASTER3_WVALID  = 0;
      assign MASTER3_WDATA  = 0;
      assign MASTER3_WSTRB  = 0;
      assign MASTER3_WUSER  = 0;
      assign MASTER3_WLAST  = 0;

      assign MASTER3_ARVALID  = 1'b0;

      assign MASTER3_ARID      = 0;
      assign MASTER3_ARADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER3_ARLEN    = 0;
      assign MASTER3_ARSIZE   = 0;
      assign MASTER3_ARBURST  = 0;
      assign MASTER3_ARLOCK   = 0;
      assign MASTER3_ARCACHE  = 0;
      assign MASTER3_ARPROT   = 0;
      assign MASTER3_ARREGION  = 0;
      assign MASTER3_ARQOS    = 0;    // not used
      assign MASTER3_ARUSER   = 0;

      assign MASTER3_RREADY = 1'b0;


      AHBL_Master #(
          .AHB_AWIDTH        (AHB_AWIDTH),
          .AHB_DWIDTH        (MASTER3_DATA_WIDTH),
          .UNDEF_BURST      (UNDEF_BURST_MASTER3)
           )
      mst3 (
        // AHB Interface
        // Global Signal
         .HCLK          (M_CLK[3]),

         .HRESETn        (ARESETN),
         .HSEL          (MASTER3_HSEL),
         .HADDR          (MASTER3_HADDR),
         .HWRITE        (MASTER3_HWRITE),
         .HREADY        (MASTER3_HREADY),
         .HTRANS        (MASTER3_HTRANS),
         .HSIZE          (MASTER3_HSIZE),
         .HWDATA        (MASTER3_HWDATA),
         .HBURST        (MASTER3_HBURST),
         .HMASTLOCK      (MASTER3_HMASTLOCK),
         .HRESP          (MASTER3_HRESP),
         .HRDATA        (MASTER3_HRDATA),

         .HNONSEC        (MASTER3_HNONSEC),
         .HPROT          (MASTER3_HPROT),

         .start_tx      (start_tx[3]),
         .end_tx        (end_tx[3]),
         .hburst_tx      (hburst),
         .hsize_tx      (hsize),
         .haddr_tx      (haddr),
         .hwrite_tx      (hwrite)
         );
    end
    end
    endgenerate // mst3

  // Generate for Master4
  generate // mst4
  if (NUM_MASTERS > 4) begin
  if (MASTER4_TYPE != 2'b10)
  begin
    AxiMaster # 
        (
          .MASTER_NUM          ( 4 ),    // master number
          .MASTER_TYPE         ( MASTER_TYPE[9:8] ),
          .ID_WIDTH            ( ID_WIDTH ),

          .ADDR_WIDTH          ( ADDR_WIDTH ),
          .DATA_WIDTH          ( MASTER4_DATA_WIDTH ), 
          .SUPPORT_USER_SIGNALS( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH          ( USER_WIDTH ),
          .OPENTRANS_MAX       ( OPEN_MTTRANS_MAX )  // Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.
        )
      mst4  (
          // Global Signals
          .sysClk                 ( M_CLK[4] ),
          .ARESETN                ( ARESETN ),
   
          // Master Read Address Ports
          .MASTER_ARID            ( MASTER4_ARID ),
          .MASTER_ARADDR          ( MASTER4_ARADDR ),
          .MASTER_ARLEN            ( MASTER4_ARLEN ),
          .MASTER_ARSIZE          ( MASTER4_ARSIZE ),
          .MASTER_ARBURST          ( MASTER4_ARBURST ),
          .MASTER_ARLOCK          ( MASTER4_ARLOCK ),
          .MASTER_ARCACHE          ( MASTER4_ARCACHE ),
          .MASTER_ARPROT          ( MASTER4_ARPROT ),
          .MASTER_ARREGION        ( MASTER4_ARREGION ),    // not used
          .MASTER_ARQOS            ( MASTER4_ARQOS ),      // not used
          .MASTER_ARUSER          ( MASTER4_ARUSER ),
          .MASTER_ARVALID          ( MASTER4_ARVALID ),
          .MASTER_ARREADY          ( MASTER4_ARREADY ),

          // Master Read Data Ports
          .MASTER_RID              ( MASTER4_RID ),
          .MASTER_RDATA            ( MASTER4_RDATA ),
          .MASTER_RRESP            ( MASTER4_RRESP ),
          .MASTER_RLAST            ( MASTER4_RLAST ),
          .MASTER_RUSER            ( MASTER4_RUSER ),
          .MASTER_RVALID          ( MASTER4_RVALID ),
          .MASTER_RREADY          ( MASTER4_RREADY ),

          // Master Write Address Ports
          .MASTER_AWID            ( MASTER4_AWID ),
          .MASTER_AWADDR          ( MASTER4_AWADDR ),
          .MASTER_AWLEN            ( MASTER4_AWLEN ),
          .MASTER_AWSIZE          ( MASTER4_AWSIZE ),
          .MASTER_AWBURST          ( MASTER4_AWBURST ),
          .MASTER_AWLOCK          ( MASTER4_AWLOCK ),
          .MASTER_AWCACHE          ( MASTER4_AWCACHE ),
          .MASTER_AWPROT          ( MASTER4_AWPROT ),
          .MASTER_AWREGION        ( MASTER4_AWREGION ),    // not used
          .MASTER_AWQOS            ( MASTER4_AWQOS ),      // not used
          .MASTER_AWUSER          ( MASTER4_AWUSER ),
          .MASTER_AWVALID          ( MASTER4_AWVALID ),
          .MASTER_AWREADY          ( MASTER4_AWREADY ),

          // Master Write Data Ports
          .MASTER_WID              ( MASTER4_WID ),
          .MASTER_WDATA            ( MASTER4_WDATA ),
          .MASTER_WSTRB            ( MASTER4_WSTRB ),
          .MASTER_WLAST            ( MASTER4_WLAST ),
          .MASTER_WUSER            ( MASTER4_WUSER ),
          .MASTER_WVALID          ( MASTER4_WVALID ),
          .MASTER_WREADY          ( MASTER4_WREADY ),
  
          // Master Write Response Ports
          .MASTER_BID              ( MASTER4_BID ),
          .MASTER_BRESP            ( MASTER4_BRESP ),
          .MASTER_BUSER            ( MASTER4_BUSER ),
          .MASTER_BVALID          ( MASTER4_BVALID ),
          .MASTER_BREADY          ( MASTER4_BREADY ),
   
          // ===============  Control Signals  =======================================================//
          .MASTER_RREADY_Default  ( MASTER_RREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .MASTER_WREADY_Default  ( MASTER_WREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .d_MASTER_BREADY_default( d_MASTER_BREADY_default ),  // defines whether Master asserts ready or waits for RVALID
          .rdStart                ( rdStart[4] ),          // defines whether Master starts a transaction
          .rdBurstLen              ( rdBurstLen ),          // burst length of read transaction
          .rdStartAddr            ( rdStartAddr ),        // start addresss for read transaction
          .rdAID                  ( rdAID ),            // AID for read transactions
          .masterRdAddrDone        ( masterRdAddrDone[4] ),    // Asserted when a read transaction has been completed
          .masterRdDone            ( masterRdDone[4] ),      // Asserted when a read transaction has been completed
          .masterRdStatus          ( masterRdStatus[4] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstRAddrIdle            ( mstRAddrIdle[4] ),
          .rdASize                ( rdASize[4] ),          // read size for each transfer in burst
          .expRResp                ( expRResp[4] ),        // indicate Read Respons expected
          .expWResp                ( expWResp[4] ),        // indicate Write Respons expected
          .wrASize                 ( wrASize[4] ),          // write size for each transfer in burst
          .wrStart                ( wrStart[4] ),          // defines whether Master starts a transaction
          .BurstType              ( BurstType ),          // Type of burst - FIXED=00, INCR=01, WRAP=10 
          .wrBurstLen             ( wrBurstLen ),          // burst length of write transaction
          .wrStartAddr            ( wrStartAddr ),        // start addresss for write transaction
          .wrAID                  ( wrAID ),            // AID for write transactions

          .masterWrAddrDone        ( masterWrAddrDone[4] ),    // Address Write transaction has been completed
          .masterWrDone           ( masterWrDone[4] ),      // Asserted when a write transaction has been completed
          .masterWrStatus         ( masterWrStatus[4] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstWAddrIdle           ( mstWAddrIdle[4] ),      // indicates Read Address Bus is idle
          .masterRespDone          ( masterRespDone[4] ),      // Asserted when a write response transaction has completed
          .mstWrAddrFull          ( mstWrAddrFull[4]  ),      // Asserted when the internal queue for writes are full
          .mstRdAddrFull          ( mstRdAddrFull[4]  )      // Asserted when the internal queue for reads are full

    );
    end
    else if (MASTER4_TYPE == 2'b10)
    begin
      assign MASTER4_AWVALID  = 1'b0;

      assign MASTER4_AWID      = 0;
      assign MASTER4_AWADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER4_AWLEN    = 0;
      assign MASTER4_AWSIZE   = 0;
      assign MASTER4_AWBURST  = 0;
      assign MASTER4_AWLOCK   = 0;
      assign MASTER4_AWCACHE  = 0;
      assign MASTER4_AWPROT   = 0;
      assign MASTER4_AWREGION  = 0;
      assign MASTER4_AWQOS    = 0;    // not used
      assign MASTER4_AWUSER   = 0;

      assign MASTER4_WVALID  = 0;
      assign MASTER4_WDATA  = 0;
      assign MASTER4_WSTRB  = 0;
      assign MASTER4_WUSER  = 0;
      assign MASTER4_WLAST  = 0;

      assign MASTER4_ARVALID  = 1'b0;

      assign MASTER4_ARID      = 0;
      assign MASTER4_ARADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER4_ARLEN    = 0;
      assign MASTER4_ARSIZE   = 0;
      assign MASTER4_ARBURST  = 0;
      assign MASTER4_ARLOCK   = 0;
      assign MASTER4_ARCACHE  = 0;
      assign MASTER4_ARPROT   = 0;
      assign MASTER4_ARREGION  = 0;
      assign MASTER4_ARQOS    = 0;    // not used
      assign MASTER4_ARUSER   = 0;

      assign MASTER4_RREADY = 1'b0;

      AHBL_Master #(
          .AHB_AWIDTH        (AHB_AWIDTH),
          .AHB_DWIDTH        (MASTER4_DATA_WIDTH),
          .UNDEF_BURST      (UNDEF_BURST_MASTER4)
           )
      mst4 (
        // AHB Interface
        // Global Signal
         .HCLK          (M_CLK[4]),

         .HRESETn        (ARESETN),
         .HSEL          (MASTER4_HSEL),
         .HADDR          (MASTER4_HADDR),
         .HWRITE        (MASTER4_HWRITE),
         .HREADY        (MASTER4_HREADY),
         .HTRANS        (MASTER4_HTRANS),
         .HSIZE          (MASTER4_HSIZE),
         .HWDATA        (MASTER4_HWDATA),
         .HBURST        (MASTER4_HBURST),
         .HMASTLOCK      (MASTER4_HMASTLOCK),
         .HRESP          (MASTER4_HRESP),
         .HRDATA        (MASTER4_HRDATA),

         .HNONSEC        (MASTER4_HNONSEC),
         .HPROT          (MASTER4_HPROT),

         .start_tx      (start_tx[4]),
         .end_tx        (end_tx[4]),
         .hburst_tx      (hburst),
         .hsize_tx      (hsize),
         .haddr_tx      (haddr),
         .hwrite_tx      (hwrite)
         );
    end
    end
    endgenerate // mst4


  // Generate for Master5
  generate // mst5
  if (NUM_MASTERS > 5) begin
  if (MASTER5_TYPE != 2'b10)
  begin
    AxiMaster # 
        (
          .MASTER_NUM          ( 5 ),    // master number
          .MASTER_TYPE         ( MASTER_TYPE[11:10] ),
          .ID_WIDTH            ( ID_WIDTH ),

          .ADDR_WIDTH          ( ADDR_WIDTH ),
          .DATA_WIDTH          ( MASTER5_DATA_WIDTH ), 
          .SUPPORT_USER_SIGNALS( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH          ( USER_WIDTH ),
          .OPENTRANS_MAX       ( OPEN_MTTRANS_MAX )  // Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.
        )
      mst5  (
          // Global Signals
          .sysClk                 ( M_CLK[5] ),
          .ARESETN                ( ARESETN ),
   
          // Master Read Address Ports
          .MASTER_ARID            ( MASTER5_ARID ),
          .MASTER_ARADDR          ( MASTER5_ARADDR ),
          .MASTER_ARLEN            ( MASTER5_ARLEN ),
          .MASTER_ARSIZE          ( MASTER5_ARSIZE ),
          .MASTER_ARBURST          ( MASTER5_ARBURST ),
          .MASTER_ARLOCK          ( MASTER5_ARLOCK ),
          .MASTER_ARCACHE          ( MASTER5_ARCACHE ),
          .MASTER_ARPROT          ( MASTER5_ARPROT ),
          .MASTER_ARREGION        ( MASTER5_ARREGION ),    // not used
          .MASTER_ARQOS            ( MASTER5_ARQOS ),      // not used
          .MASTER_ARUSER          ( MASTER5_ARUSER ),
          .MASTER_ARVALID          ( MASTER5_ARVALID ),
          .MASTER_ARREADY          ( MASTER5_ARREADY ),

          // Master Read Data Ports
          .MASTER_RID              ( MASTER5_RID ),
          .MASTER_RDATA            ( MASTER5_RDATA ),
          .MASTER_RRESP            ( MASTER5_RRESP ),
          .MASTER_RLAST            ( MASTER5_RLAST ),
          .MASTER_RUSER            ( MASTER5_RUSER ),
          .MASTER_RVALID          ( MASTER5_RVALID ),
          .MASTER_RREADY          ( MASTER5_RREADY ),

          // Master Write Address Ports
          .MASTER_AWID            ( MASTER5_AWID ),
          .MASTER_AWADDR          ( MASTER5_AWADDR ),
          .MASTER_AWLEN            ( MASTER5_AWLEN ),
          .MASTER_AWSIZE          ( MASTER5_AWSIZE ),
          .MASTER_AWBURST          ( MASTER5_AWBURST ),
          .MASTER_AWLOCK          ( MASTER5_AWLOCK ),
          .MASTER_AWCACHE          ( MASTER5_AWCACHE ),
          .MASTER_AWPROT          ( MASTER5_AWPROT ),
          .MASTER_AWREGION        ( MASTER5_AWREGION ),    // not used
          .MASTER_AWQOS            ( MASTER5_AWQOS ),      // not used
          .MASTER_AWUSER          ( MASTER5_AWUSER ),
          .MASTER_AWVALID          ( MASTER5_AWVALID ),
          .MASTER_AWREADY          ( MASTER5_AWREADY ),

          // Master Write Data Ports
          .MASTER_WID              ( MASTER5_WID ),
          .MASTER_WDATA            ( MASTER5_WDATA ),
          .MASTER_WSTRB            ( MASTER5_WSTRB ),
          .MASTER_WLAST            ( MASTER5_WLAST ),
          .MASTER_WUSER            ( MASTER5_WUSER ),
          .MASTER_WVALID          ( MASTER5_WVALID ),
          .MASTER_WREADY          ( MASTER5_WREADY ),
  
          // Master Write Response Ports
          .MASTER_BID              ( MASTER5_BID ),
          .MASTER_BRESP            ( MASTER5_BRESP ),
          .MASTER_BUSER            ( MASTER5_BUSER ),
          .MASTER_BVALID          ( MASTER5_BVALID ),
          .MASTER_BREADY          ( MASTER5_BREADY ),
   
          // ===============  Control Signals  =======================================================//
          .MASTER_RREADY_Default  ( MASTER_RREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .MASTER_WREADY_Default  ( MASTER_WREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .d_MASTER_BREADY_default( d_MASTER_BREADY_default ),  // defines whether Master asserts ready or waits for RVALID
          .rdStart                ( rdStart[5] ),          // defines whether Master starts a transaction
          .rdBurstLen              ( rdBurstLen ),          // burst length of read transaction
          .rdStartAddr            ( rdStartAddr ),        // start addresss for read transaction
          .rdAID                  ( rdAID ),            // AID for read transactions
          .masterRdAddrDone        ( masterRdAddrDone[5] ),    // Asserted when a read transaction has been completed
          .masterRdDone            ( masterRdDone[5] ),      // Asserted when a read transaction has been completed
          .masterRdStatus          ( masterRdStatus[5] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstRAddrIdle            ( mstRAddrIdle[5] ),
          .rdASize                ( rdASize[5] ),          // read size for each transfer in burst
          .expRResp                ( expRResp[5] ),        // indicate Read Respons expected
          .expWResp                ( expWResp[5] ),        // indicate Write Respons expected
          .wrASize                 ( wrASize[5] ),          // write size for each transfer in burst
          .wrStart                ( wrStart[5] ),          // defines whether Master starts a transaction
          .BurstType              ( BurstType ),          // Type of burst - FIXED=00, INCR=01, WRAP=10 
          .wrBurstLen             ( wrBurstLen ),          // burst length of write transaction
          .wrStartAddr            ( wrStartAddr ),        // start addresss for write transaction
          .wrAID                  ( wrAID ),            // AID for write transactions

          .masterWrAddrDone        ( masterWrAddrDone[5] ),    // Address Write transaction has been completed
          .masterWrDone           ( masterWrDone[5] ),      // Asserted when a write transaction has been completed
          .masterWrStatus         ( masterWrStatus[5] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstWAddrIdle           ( mstWAddrIdle[5] ),      // indicates Read Address Bus is idle
          .masterRespDone          ( masterRespDone[5] ),      // Asserted when a write response transaction has completed
          .mstWrAddrFull          ( mstWrAddrFull[5]  ),      // Asserted when the internal queue for writes are full
          .mstRdAddrFull          ( mstRdAddrFull[5]  )      // Asserted when the internal queue for reads are full
    );
    end
    else if (MASTER5_TYPE == 2'b10)
    begin
      assign MASTER5_AWVALID  = 1'b0;

      assign MASTER5_AWID      = 0;
      assign MASTER5_AWADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER5_AWLEN    = 0;
      assign MASTER5_AWSIZE   = 0;
      assign MASTER5_AWBURST  = 0;
      assign MASTER5_AWLOCK   = 0;
      assign MASTER5_AWCACHE  = 0;
      assign MASTER5_AWPROT   = 0;
      assign MASTER5_AWREGION  = 0;
      assign MASTER5_AWQOS    = 0;    // not used
      assign MASTER5_AWUSER   = 0;

      assign MASTER5_WVALID  = 0;
      assign MASTER5_WDATA  = 0;
      assign MASTER5_WSTRB  = 0;
      assign MASTER5_WUSER  = 0;
      assign MASTER5_WLAST  = 0;

      assign MASTER5_ARVALID  = 1'b0;

      assign MASTER5_ARID      = 0;
      assign MASTER5_ARADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER5_ARLEN    = 0;
      assign MASTER5_ARSIZE   = 0;
      assign MASTER5_ARBURST  = 0;
      assign MASTER5_ARLOCK   = 0;
      assign MASTER5_ARCACHE  = 0;
      assign MASTER5_ARPROT   = 0;
      assign MASTER5_ARREGION  = 0;
      assign MASTER5_ARQOS    = 0;    // not used
      assign MASTER5_ARUSER   = 0;

      assign MASTER5_RREADY = 1'b0;


      AHBL_Master #(
          .AHB_AWIDTH        (AHB_AWIDTH),
          .AHB_DWIDTH        (MASTER5_DATA_WIDTH),
          .UNDEF_BURST      (UNDEF_BURST_MASTER5)
           )
      mst5 (
        // AHB Interface
        // Global Signal
         .HCLK          (M_CLK[5]),

         .HRESETn        (ARESETN),
         .HSEL          (MASTER5_HSEL),
         .HADDR          (MASTER5_HADDR),
         .HWRITE        (MASTER5_HWRITE),
         .HREADY        (MASTER5_HREADY),
         .HTRANS        (MASTER5_HTRANS),
         .HSIZE          (MASTER5_HSIZE),
         .HWDATA        (MASTER5_HWDATA),
         .HBURST        (MASTER5_HBURST),
         .HMASTLOCK      (MASTER5_HMASTLOCK),
         .HRESP          (MASTER5_HRESP),
         .HRDATA        (MASTER5_HRDATA),

         .HNONSEC        (MASTER5_HNONSEC),
         .HPROT          (MASTER5_HPROT),

         .start_tx      (start_tx[5]),
         .end_tx        (end_tx[5]),
         .hburst_tx      (hburst),
         .hsize_tx      (hsize),
         .haddr_tx      (haddr),
         .hwrite_tx      (hwrite)
         );
    end
    end
    endgenerate // mst5


  // Generate for Master6
  generate // mst6
  if (NUM_MASTERS > 6) begin
  if (MASTER6_TYPE != 2'b10)
  begin
    AxiMaster # 
        (
          .MASTER_NUM          ( 6 ),    // master number
          .MASTER_TYPE         ( MASTER_TYPE[13:12] ),
          .ID_WIDTH            ( ID_WIDTH ),

          .ADDR_WIDTH          ( ADDR_WIDTH ),
          .DATA_WIDTH          ( MASTER6_DATA_WIDTH ), 
          .SUPPORT_USER_SIGNALS( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH          ( USER_WIDTH ),
          .OPENTRANS_MAX       ( OPEN_MTTRANS_MAX )  // Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.
        )
      mst6  (
          // Global Signals
          .sysClk                 ( M_CLK[6] ),
          .ARESETN                ( ARESETN ),
   
          // Master Read Address Ports
          .MASTER_ARID            ( MASTER6_ARID ),
          .MASTER_ARADDR          ( MASTER6_ARADDR ),
          .MASTER_ARLEN            ( MASTER6_ARLEN ),
          .MASTER_ARSIZE          ( MASTER6_ARSIZE ),
          .MASTER_ARBURST          ( MASTER6_ARBURST ),
          .MASTER_ARLOCK          ( MASTER6_ARLOCK ),
          .MASTER_ARCACHE          ( MASTER6_ARCACHE ),
          .MASTER_ARPROT          ( MASTER6_ARPROT ),
          .MASTER_ARREGION        ( MASTER6_ARREGION ),    // not used
          .MASTER_ARQOS            ( MASTER6_ARQOS ),      // not used
          .MASTER_ARUSER          ( MASTER6_ARUSER ),
          .MASTER_ARVALID          ( MASTER6_ARVALID ),
          .MASTER_ARREADY          ( MASTER6_ARREADY ),

          // Master Read Data Ports
          .MASTER_RID              ( MASTER6_RID ),
          .MASTER_RDATA            ( MASTER6_RDATA ),
          .MASTER_RRESP            ( MASTER6_RRESP ),
          .MASTER_RLAST            ( MASTER6_RLAST ),
          .MASTER_RUSER            ( MASTER6_RUSER ),
          .MASTER_RVALID          ( MASTER6_RVALID ),
          .MASTER_RREADY          ( MASTER6_RREADY ),

          // Master Write Address Ports
          .MASTER_AWID            ( MASTER6_AWID ),
          .MASTER_AWADDR          ( MASTER6_AWADDR ),
          .MASTER_AWLEN            ( MASTER6_AWLEN ),
          .MASTER_AWSIZE          ( MASTER6_AWSIZE ),
          .MASTER_AWBURST          ( MASTER6_AWBURST ),
          .MASTER_AWLOCK          ( MASTER6_AWLOCK ),
          .MASTER_AWCACHE          ( MASTER6_AWCACHE ),
          .MASTER_AWPROT          ( MASTER6_AWPROT ),
          .MASTER_AWREGION        ( MASTER6_AWREGION ),    // not used
          .MASTER_AWQOS            ( MASTER6_AWQOS ),      // not used
          .MASTER_AWUSER          ( MASTER6_AWUSER ),
          .MASTER_AWVALID          ( MASTER6_AWVALID ),
          .MASTER_AWREADY          ( MASTER6_AWREADY ),

          // Master Write Data Ports
          .MASTER_WID              ( MASTER6_WID ),
          .MASTER_WDATA            ( MASTER6_WDATA ),
          .MASTER_WSTRB            ( MASTER6_WSTRB ),
          .MASTER_WLAST            ( MASTER6_WLAST ),
          .MASTER_WUSER            ( MASTER6_WUSER ),
          .MASTER_WVALID          ( MASTER6_WVALID ),
          .MASTER_WREADY          ( MASTER6_WREADY ),
  
          // Master Write Response Ports
          .MASTER_BID              ( MASTER6_BID ),
          .MASTER_BRESP            ( MASTER6_BRESP ),
          .MASTER_BUSER            ( MASTER6_BUSER ),
          .MASTER_BVALID          ( MASTER6_BVALID ),
          .MASTER_BREADY          ( MASTER6_BREADY ),
   
          // ===============  Control Signals  =======================================================//
          .MASTER_RREADY_Default  ( MASTER_RREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .MASTER_WREADY_Default  ( MASTER_WREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .d_MASTER_BREADY_default( d_MASTER_BREADY_default ),  // defines whether Master asserts ready or waits for RVALID
          .rdStart                ( rdStart[6] ),          // defines whether Master starts a transaction
          .rdBurstLen              ( rdBurstLen ),          // burst length of read transaction
          .rdStartAddr            ( rdStartAddr ),        // start addresss for read transaction
          .rdAID                  ( rdAID ),            // AID for read transactions
          .masterRdAddrDone        ( masterRdAddrDone[6] ),    // Asserted when a read transaction has been completed
          .masterRdDone            ( masterRdDone[6] ),      // Asserted when a read transaction has been completed
          .masterRdStatus          ( masterRdStatus[6] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstRAddrIdle            ( mstRAddrIdle[6] ),
          .rdASize                ( rdASize[6] ),          // read size for each transfer in burst
          .expRResp                ( expRResp[6] ),        // indicate Read Respons expected
          .expWResp                ( expWResp[6] ),        // indicate Write Respons expected
          .wrASize                 ( wrASize[6] ),          // write size for each transfer in burst
          .wrStart                ( wrStart[6] ),          // defines whether Master starts a transaction
          .BurstType              ( BurstType ),          // Type of burst - FIXED=00, INCR=01, WRAP=10 
          .wrBurstLen             ( wrBurstLen ),          // burst length of write transaction
          .wrStartAddr            ( wrStartAddr ),        // start addresss for write transaction
          .wrAID                  ( wrAID ),            // AID for write transactions

          .masterWrAddrDone        ( masterWrAddrDone[6] ),    // Address Write transaction has been completed
          .masterWrDone           ( masterWrDone[6] ),      // Asserted when a write transaction has been completed
          .masterWrStatus         ( masterWrStatus[6] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstWAddrIdle           ( mstWAddrIdle[6] ),      // indicates Read Address Bus is idle
          .masterRespDone          ( masterRespDone[6] ),      // Asserted when a write response transaction has completed
          .mstWrAddrFull          ( mstWrAddrFull[6]  ),      // Asserted when the internal queue for writes are full
          .mstRdAddrFull          ( mstRdAddrFull[6]  )      // Asserted when the internal queue for reads are full
    );
    end
    else if (MASTER6_TYPE == 2'b10)
    begin
      assign MASTER6_AWVALID  = 1'b0;

      assign MASTER6_AWID      = 0;
      assign MASTER6_AWADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER6_AWLEN    = 0;
      assign MASTER6_AWSIZE   = 0;
      assign MASTER6_AWBURST  = 0;
      assign MASTER6_AWLOCK   = 0;
      assign MASTER6_AWCACHE  = 0;
      assign MASTER6_AWPROT   = 0;
      assign MASTER6_AWREGION  = 0;
      assign MASTER6_AWQOS    = 0;    // not used
      assign MASTER6_AWUSER   = 0;

      assign MASTER6_WVALID  = 0;
      assign MASTER6_WDATA  = 0;
      assign MASTER6_WSTRB  = 0;
      assign MASTER6_WUSER  = 0;
      assign MASTER6_WLAST  = 0;

      assign MASTER6_ARVALID  = 1'b0;

      assign MASTER6_ARID      = 0;
      assign MASTER6_ARADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER6_ARLEN    = 0;
      assign MASTER6_ARSIZE   = 0;
      assign MASTER6_ARBURST  = 0;
      assign MASTER6_ARLOCK   = 0;
      assign MASTER6_ARCACHE  = 0;
      assign MASTER6_ARPROT   = 0;
      assign MASTER6_ARREGION  = 0;
      assign MASTER6_ARQOS    = 0;    // not used
      assign MASTER6_ARUSER   = 0;

      assign MASTER6_RREADY = 1'b0;

      AHBL_Master #(
          .AHB_AWIDTH        (AHB_AWIDTH),
          .AHB_DWIDTH        (MASTER6_DATA_WIDTH),
          .UNDEF_BURST      (UNDEF_BURST_MASTER6)
           )
      mst6 (
        // AHB Interface
        // Global Signal
         .HCLK          (M_CLK[6]),

         .HRESETn        (ARESETN),
         .HSEL          (MASTER6_HSEL),
         .HADDR          (MASTER6_HADDR),
         .HWRITE        (MASTER6_HWRITE),
         .HREADY        (MASTER6_HREADY),
         .HTRANS        (MASTER6_HTRANS),
         .HSIZE          (MASTER6_HSIZE),
         .HWDATA        (MASTER6_HWDATA),
         .HBURST        (MASTER6_HBURST),
         .HMASTLOCK      (MASTER6_HMASTLOCK),
         .HRESP          (MASTER6_HRESP),
         .HRDATA        (MASTER6_HRDATA),

         .HNONSEC        (MASTER6_HNONSEC),
         .HPROT          (MASTER6_HPROT),

         .start_tx      (start_tx[6]),
         .end_tx        (end_tx[6]),
         .hburst_tx      (hburst),
         .hsize_tx      (hsize),
         .haddr_tx      (haddr),
         .hwrite_tx      (hwrite)
         );
    end
    end
    endgenerate // mst6



  // Generate for Master7
  generate // mst7
  if (NUM_MASTERS > 7) begin
  if (MASTER7_TYPE != 2'b10)
  begin
    AxiMaster # 
        (
          .MASTER_NUM( 7 ),    // master number
          .MASTER_TYPE ( MASTER_TYPE[15:14] ),
          .ID_WIDTH( ID_WIDTH ),

          .ADDR_WIDTH( ADDR_WIDTH ),
          .DATA_WIDTH( MASTER7_DATA_WIDTH ), 
          .SUPPORT_USER_SIGNALS( SUPPORT_USER_SIGNALS ),
          .USER_WIDTH( USER_WIDTH ),
          .OPENTRANS_MAX( OPEN_MTTRANS_MAX )  // Number of open transations width - 1 => 2 transations, 2 => 4 transations, etc.
        )
      mst7  (
          // Global Signals
          .sysClk                 ( M_CLK[7] ),
          .ARESETN                ( ARESETN ),

          // Master Read Address Ports
          .MASTER_ARID            ( MASTER7_ARID ),
          .MASTER_ARADDR          ( MASTER7_ARADDR ),
          .MASTER_ARLEN            ( MASTER7_ARLEN ),
          .MASTER_ARSIZE          ( MASTER7_ARSIZE ),
          .MASTER_ARBURST          ( MASTER7_ARBURST ),
          .MASTER_ARLOCK          ( MASTER7_ARLOCK ),
          .MASTER_ARCACHE          ( MASTER7_ARCACHE ),
          .MASTER_ARPROT          ( MASTER7_ARPROT ),
          .MASTER_ARREGION        ( MASTER7_ARREGION ),    // not used
          .MASTER_ARQOS            ( MASTER7_ARQOS ),      // not used
          .MASTER_ARUSER          ( MASTER7_ARUSER ),
          .MASTER_ARVALID          ( MASTER7_ARVALID ),
          .MASTER_ARREADY          ( MASTER7_ARREADY ),

          // Master Read Data Ports
          .MASTER_RID              ( MASTER7_RID ),
          .MASTER_RDATA            ( MASTER7_RDATA ),
          .MASTER_RRESP            ( MASTER7_RRESP ),
          .MASTER_RLAST            ( MASTER7_RLAST ),
          .MASTER_RUSER            ( MASTER7_RUSER ),
          .MASTER_RVALID          ( MASTER7_RVALID ),
          .MASTER_RREADY          ( MASTER7_RREADY ),

          // Master Write Address Ports
          .MASTER_AWID            ( MASTER7_AWID ),
          .MASTER_AWADDR          ( MASTER7_AWADDR ),
          .MASTER_AWLEN            ( MASTER7_AWLEN ),
          .MASTER_AWSIZE          ( MASTER7_AWSIZE ),
          .MASTER_AWBURST          ( MASTER7_AWBURST ),
          .MASTER_AWLOCK          ( MASTER7_AWLOCK ),
          .MASTER_AWCACHE          ( MASTER7_AWCACHE ),
          .MASTER_AWPROT          ( MASTER7_AWPROT ),
          .MASTER_AWREGION        ( MASTER7_AWREGION ),    // not used
          .MASTER_AWQOS            ( MASTER7_AWQOS ),      // not used
          .MASTER_AWUSER          ( MASTER7_AWUSER ),
          .MASTER_AWVALID          ( MASTER7_AWVALID ),
          .MASTER_AWREADY          ( MASTER7_AWREADY ),

          // Master Write Data Ports
          .MASTER_WID              ( MASTER7_WID ),
          .MASTER_WDATA            ( MASTER7_WDATA ),
          .MASTER_WSTRB            ( MASTER7_WSTRB ),
          .MASTER_WLAST            ( MASTER7_WLAST ),
          .MASTER_WUSER            ( MASTER7_WUSER ),
          .MASTER_WVALID          ( MASTER7_WVALID ),
          .MASTER_WREADY          ( MASTER7_WREADY ),
  
          // Master Write Response Ports
          .MASTER_BID              ( MASTER7_BID ),
          .MASTER_BRESP            ( MASTER7_BRESP ),
          .MASTER_BUSER            ( MASTER7_BUSER ),
          .MASTER_BVALID          ( MASTER7_BVALID ),
          .MASTER_BREADY          ( MASTER7_BREADY ),
   
          // ===============  Control Signals  =======================================================//
          .MASTER_RREADY_Default  ( MASTER_RREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .MASTER_WREADY_Default  ( MASTER_WREADY_Default ),    // defines whether Master asserts ready or waits for RVALID
          .d_MASTER_BREADY_default( d_MASTER_BREADY_default ),  // defines whether Master asserts ready or waits for RVALID
          .rdStart                ( rdStart[7] ),          // defines whether Master starts a transaction
          .rdBurstLen              ( rdBurstLen ),          // burst length of read transaction
          .rdStartAddr            ( rdStartAddr ),        // start addresss for read transaction
          .rdAID                  ( rdAID ),            // AID for read transactions
          .masterRdAddrDone        ( masterRdAddrDone[7] ),    // Asserted when a read transaction has been completed
          .masterRdDone            ( masterRdDone[7] ),      // Asserted when a read transaction has been completed
          .masterRdStatus          ( masterRdStatus[7] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstRAddrIdle            ( mstRAddrIdle[7] ),
          .rdASize                ( rdASize[7] ),          // read size for each transfer in burst
          .expRResp                ( expRResp[7] ),        // indicate Read Respons expected
          .expWResp                ( expWResp[7] ),        // indicate Write Respons expected
          .wrASize                 ( wrASize[7] ),          // write size for each transfer in burst
          .wrStart                ( wrStart[7] ),          // defines whether Master starts a transaction
          .BurstType              ( BurstType ),          // Type of burst - FIXED=00, INCR=01, WRAP=10 
          .wrBurstLen             ( wrBurstLen ),          // burst length of write transaction
          .wrStartAddr            ( wrStartAddr ),        // start addresss for write transaction
          .wrAID                  ( wrAID ),            // AID for write transactions

          .masterWrAddrDone        ( masterWrAddrDone[7] ),    // Address Write transaction has been completed
          .masterWrDone           ( masterWrDone[7] ),      // Asserted when a write transaction has been completed
          .masterWrStatus         ( masterWrStatus[7] ),      // Status of read transaction - Pass =1, Fail=0. Only valid when masterRdDone asserted
          .mstWAddrIdle           ( mstWAddrIdle[7] ),      // indicates Read Address Bus is idle
          .masterRespDone          ( masterRespDone[7] ),      // Asserted when a write response transaction has completed
          .mstWrAddrFull          ( mstWrAddrFull[7]  ),      // Asserted when the internal queue for writes are full
          .mstRdAddrFull          ( mstRdAddrFull[7]  )      // Asserted when the internal queue for reads are full
          );

    end
    else if (MASTER7_TYPE == 2'b10)
    begin
      assign MASTER7_AWVALID  = 1'b0;

      assign MASTER7_AWID      = 0;
      assign MASTER7_AWADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER7_AWLEN    = 0;
      assign MASTER7_AWSIZE   = 0;
      assign MASTER7_AWBURST  = 0;
      assign MASTER7_AWLOCK   = 0;
      assign MASTER7_AWCACHE  = 0;
      assign MASTER7_AWPROT   = 0;
      assign MASTER7_AWREGION  = 0;
      assign MASTER7_AWQOS    = 0;    // not used
      assign MASTER7_AWUSER   = 0;

      assign MASTER7_WVALID  = 0;
      assign MASTER7_WDATA  = 0;
      assign MASTER7_WSTRB  = 0;
      assign MASTER7_WUSER  = 0;
      assign MASTER7_WLAST  = 0;

      assign MASTER7_ARVALID  = 1'b0;

      assign MASTER7_ARID      = 0;
      assign MASTER7_ARADDR   = 0;        // make up data to be easy read in simulation
      assign MASTER7_ARLEN    = 0;
      assign MASTER7_ARSIZE   = 0;
      assign MASTER7_ARBURST  = 0;
      assign MASTER7_ARLOCK   = 0;
      assign MASTER7_ARCACHE  = 0;
      assign MASTER7_ARPROT   = 0;
      assign MASTER7_ARREGION  = 0;
      assign MASTER7_ARQOS    = 0;    // not used
      assign MASTER7_ARUSER   = 0;

      assign MASTER7_RREADY = 1'b0;

      AHBL_Master #(
          .AHB_AWIDTH        (AHB_AWIDTH),
          .AHB_DWIDTH        (MASTER7_DATA_WIDTH),
          .UNDEF_BURST      (UNDEF_BURST_MASTER7)
           )
      mst7 (
        // AHB Interface
        // Global Signal
         .HCLK          (M_CLK[7]),

         .HRESETn        (ARESETN),
         .HSEL          (MASTER7_HSEL),
         .HADDR          (MASTER7_HADDR),
         .HWRITE        (MASTER7_HWRITE),
         .HREADY        (MASTER7_HREADY),
         .HTRANS        (MASTER7_HTRANS),
         .HSIZE          (MASTER7_HSIZE),
         .HWDATA        (MASTER7_HWDATA),
         .HBURST        (MASTER7_HBURST),
         .HMASTLOCK      (MASTER7_HMASTLOCK),
         .HRESP          (MASTER7_HRESP),
         .HRDATA        (MASTER7_HRDATA),

         .HNONSEC        (MASTER7_HNONSEC),
         .HPROT          (MASTER7_HPROT),

         .start_tx      (start_tx[7]),
         .end_tx        (end_tx[7]),
         .hburst_tx      (hburst),
         .hsize_tx      (hsize),
         .haddr_tx      (haddr),
         .hwrite_tx      (hwrite)
         );
    end
    end
    endgenerate // mst7


//======================================================================================================================================
// ACLK - system clock
//======================================================================================================================================

initial begin
   ACLK <= 0;
end
always
  begin
    #(XBAR_CLK_PERIOD/2) ACLK <= #(XBAR_PHASE) ~ACLK;
  end

generate
if (MASTER0_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(MASTER0_CLK_PERIOD/2) M_CLK0 <= #(MASTER0_PHASE) ~M_CLK0;
  end
end else
always @(*) begin
  M_CLK0 <= ACLK;
end
endgenerate

generate
if (MASTER1_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(MASTER1_CLK_PERIOD/2) M_CLK1 <= #(MASTER1_PHASE) ~M_CLK1;
  end
end else
always @(*) begin
  M_CLK1 <= ACLK;
end
endgenerate

generate
if (MASTER2_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(MASTER2_CLK_PERIOD/2) M_CLK2 <= #(MASTER2_PHASE) ~M_CLK2;
  end
end else
always @(*) begin
  M_CLK2 <= ACLK;
end
endgenerate

generate
if (MASTER3_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(MASTER3_CLK_PERIOD/2) M_CLK3 <= #(MASTER3_PHASE) ~M_CLK3;
  end
end else
always @(*) begin
  M_CLK3 <= ACLK;
end
endgenerate

generate
if (MASTER4_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(MASTER4_CLK_PERIOD/2) M_CLK4 <= #(MASTER4_PHASE) ~M_CLK4;
  end
end else
always @(*) begin
  M_CLK4 <= ACLK;
end
endgenerate

generate
if (MASTER5_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(MASTER5_CLK_PERIOD/2) M_CLK5 <= #(MASTER5_PHASE) ~M_CLK5;
  end
end else
always @(*) begin
  M_CLK5 <= ACLK;
end
endgenerate

generate
if (MASTER6_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(MASTER6_CLK_PERIOD/2) M_CLK6 <= #(MASTER6_PHASE) ~M_CLK6;
  end
end else
always @(*) begin
  M_CLK6 <= ACLK;
end
endgenerate

generate
if (MASTER7_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(MASTER7_CLK_PERIOD/2) M_CLK7 <= #(MASTER7_PHASE) ~M_CLK7;
  end
end else
always @(*) begin
  M_CLK7 <= ACLK;
end
endgenerate

generate
if (SLAVE0_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE0_CLK_PERIOD/2) S_CLK0 <= #(SLAVE0_PHASE) ~S_CLK0;
  end
end else begin
always @(*) begin
  S_CLK0 <= ACLK;
end
end
endgenerate

generate
if (SLAVE1_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE1_CLK_PERIOD/2) S_CLK1 <= #(SLAVE1_PHASE) ~S_CLK1;
  end
end else
always @(*) begin
  S_CLK1 <= ACLK;
end
endgenerate

generate
if (SLAVE2_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE2_CLK_PERIOD/2) S_CLK2 <= #(SLAVE2_PHASE) ~S_CLK2;
  end
end else
always @(*) begin
  S_CLK2 <= ACLK;
end
endgenerate

generate
if (SLAVE3_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE3_CLK_PERIOD/2) S_CLK3 <= #(SLAVE3_PHASE) ~S_CLK3;
  end
end else
always @(*) begin
  S_CLK3 <= ACLK;
end
endgenerate

generate
if (SLAVE4_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE4_CLK_PERIOD/2) S_CLK4 <= #(SLAVE4_PHASE) ~S_CLK4;
  end
end else
always @(*) begin
  S_CLK4 <= ACLK;
end
endgenerate

generate
if (SLAVE5_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE5_CLK_PERIOD/2) S_CLK5 <= #(SLAVE5_PHASE) ~S_CLK5;
  end
end else
always @(*) begin
  S_CLK5 <= ACLK;
end
endgenerate

generate
if (SLAVE6_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE6_CLK_PERIOD/2) S_CLK6 <= #(SLAVE6_PHASE) ~S_CLK6;
  end
end else
always @(*) begin
  S_CLK6 <= ACLK;
end
endgenerate

generate
if (SLAVE7_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE7_CLK_PERIOD/2) S_CLK7 <= #(SLAVE7_PHASE) ~S_CLK7;
  end  
end else
always @(*) begin
  S_CLK7 <= ACLK;
end
endgenerate

generate
if (SLAVE8_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE8_CLK_PERIOD/2) S_CLK8 <= #(SLAVE8_PHASE) ~S_CLK8;
  end  
end else
always @(*) begin
  S_CLK8 <= ACLK;
end
endgenerate

generate
if (SLAVE9_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE8_CLK_PERIOD/2) S_CLK9 <= #(SLAVE9_PHASE) ~S_CLK9;
  end  
end else
always @(*) begin
  S_CLK9 <= ACLK;
end
endgenerate

generate
if (SLAVE10_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE10_CLK_PERIOD/2) S_CLK10 <= #(SLAVE10_PHASE) ~S_CLK10;
  end  
end else
always @(*) begin
  S_CLK10 <= ACLK;
end
endgenerate

generate
if (SLAVE11_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE11_CLK_PERIOD/2) S_CLK11 <= #(SLAVE11_PHASE) ~S_CLK11;
  end  
end else
always @(*) begin
  S_CLK11 <= ACLK;
end
endgenerate

generate
if (SLAVE12_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE12_CLK_PERIOD/2) S_CLK12 <= #(SLAVE12_PHASE) ~S_CLK12;
  end  
end else
always @(*) begin
  S_CLK12 <= ACLK;
end
endgenerate

generate
if (SLAVE13_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE13_CLK_PERIOD/2) S_CLK13 <= #(SLAVE13_PHASE) ~S_CLK13;
  end  
end else
always @(*) begin
  S_CLK13 <= ACLK;
end
endgenerate

generate
if (SLAVE14_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE14_CLK_PERIOD/2) S_CLK14 <= #(SLAVE14_PHASE) ~S_CLK14;
  end  
end else
always @(*) begin
  S_CLK14 <= ACLK;
end
endgenerate

generate
if (SLAVE15_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE15_CLK_PERIOD/2) S_CLK15 <= #(SLAVE15_PHASE) ~S_CLK15;
  end  
end else
always @(*) begin
  S_CLK15 <= ACLK;
end
endgenerate

generate
if (SLAVE16_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE16_CLK_PERIOD/2) S_CLK16 <= #(SLAVE16_PHASE) ~S_CLK16;
  end  
end else
always @(*) begin
  S_CLK16 <= ACLK;
end
endgenerate

generate
if (SLAVE17_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE17_CLK_PERIOD/2) S_CLK17 <= #(SLAVE17_PHASE) ~S_CLK17;
  end  
end else
always @(*) begin
  S_CLK17 <= ACLK;
end
endgenerate

generate
if (SLAVE18_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE18_CLK_PERIOD/2) S_CLK18 <= #(SLAVE18_PHASE) ~S_CLK18;
  end  
end else
always @(*) begin
  S_CLK18 <= ACLK;
end
endgenerate

generate
if (SLAVE19_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE19_CLK_PERIOD/2) S_CLK19 <= #(SLAVE19_PHASE) ~S_CLK19;
  end  
end else
always @(*) begin
  S_CLK19 <= ACLK;
end
endgenerate

generate
if (SLAVE20_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE20_CLK_PERIOD/2) S_CLK20 <= #(SLAVE20_PHASE) ~S_CLK20;
  end  
end else
always @(*) begin
  S_CLK20 <= ACLK;
end
endgenerate

generate
if (SLAVE21_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE21_CLK_PERIOD/2) S_CLK21 <= #(SLAVE21_PHASE) ~S_CLK21;
  end  
end else
always @(*) begin
  S_CLK21 <= ACLK;
end
endgenerate

generate
if (SLAVE22_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE22_CLK_PERIOD/2) S_CLK22 <= #(SLAVE22_PHASE) ~S_CLK22;
  end  
end else
always @(*) begin
  S_CLK22 <= ACLK;
end
endgenerate

generate
if (SLAVE23_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE23_CLK_PERIOD/2) S_CLK23 <= #(SLAVE23_PHASE) ~S_CLK23;
  end  
end else
always @(*) begin
  S_CLK23 <= ACLK;
end
endgenerate

generate
if (SLAVE24_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE24_CLK_PERIOD/2) S_CLK24 <= #(SLAVE24_PHASE) ~S_CLK24;
  end  
end else
always @(*) begin
  S_CLK24 <= ACLK;
end
endgenerate

generate
if (SLAVE25_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE25_CLK_PERIOD/2) S_CLK25 <= #(SLAVE25_PHASE) ~S_CLK25;
  end  
end else
always @(*) begin
  S_CLK25 <= ACLK;
end
endgenerate

generate
if (SLAVE26_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE26_CLK_PERIOD/2) S_CLK26 <= #(SLAVE26_PHASE) ~S_CLK26;
  end  
end else
always @(*) begin
  S_CLK26 <= ACLK;
end
endgenerate

generate
if (SLAVE27_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE27_CLK_PERIOD/2) S_CLK27 <= #(SLAVE27_PHASE) ~S_CLK27;
  end  
end else
always @(*) begin
  S_CLK27 <= ACLK;
end
endgenerate

generate
if (SLAVE28_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE28_CLK_PERIOD/2) S_CLK28 <= #(SLAVE28_PHASE) ~S_CLK28;
  end  
end else
always @(*) begin
  S_CLK28 <= ACLK;
end
endgenerate

generate
if (SLAVE29_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE29_CLK_PERIOD/2) S_CLK29 <= #(SLAVE29_PHASE) ~S_CLK29;
  end  
end else
always @(*) begin
  S_CLK29 <= ACLK;
end
endgenerate

generate
if (SLAVE30_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE30_CLK_PERIOD/2) S_CLK30 <= #(SLAVE30_PHASE) ~S_CLK30;
  end  
end else
always @(*) begin
  S_CLK30 <= ACLK;
end
endgenerate

generate
if (SLAVE31_CLOCK_DOMAIN_CROSSING) begin
always
  begin
    #(SLAVE31_CLK_PERIOD/2) S_CLK31 <= #(SLAVE31_PHASE) ~S_CLK31;
  end  
end else
always @(*) begin
  S_CLK31 <= ACLK;
end
endgenerate


//=======================================================================================================================================


//=========================================================================================
// AXI4Read - initate a Read transaction on the AXI4 Bus
//=========================================================================================
task AXI4Read;

  input [NUM_MASTERS_WIDTH-1:0]  masterNum;
  input [ADDR_WIDTH-1:0]       readAddr;
  input [ID_WIDTH-1:0]        readID;
  input [7:0]           readLen;  
  input [1:0]            readType;
  input [2:0]            readSize;
  input [1:0]            readRResp;

begin

  //============================================
  // Drive out Address phase
  //============================================
  @( posedge M_CLK[masterNum])
    begin
      // define // parameters for read
      rdStartAddr      <= readAddr;
      rdBurstLen      <= readLen;
      BurstType      <= readType;
      rdAID        <= readID;
      rdASize[masterNum]  <= readSize;
      expRResp[masterNum]  <= readRResp;

      rdStart[masterNum]  <= 1;
    end

  @( negedge M_CLK[masterNum]);
  while ( mstRdAddrFull[masterNum] )    // wait till readFifo is not full
    begin
      @( negedge M_CLK[masterNum] );
    end    

  @( posedge M_CLK[masterNum])
    begin
      rdStart[masterNum]     <= 0;
    end
end
endtask    // AXI4Read task


//=========================================================================================
// AXI4Write - initate a Wrire transaction on the AXI4 Bus
//=========================================================================================
task AXI4Write;

  input [NUM_MASTERS_WIDTH-1:0]  masterNum;
  input [ADDR_WIDTH-1:0]       writeAddr;
  input [ID_WIDTH-1:0]        writeID;
  input [7:0]           writeLen;
  input [1:0]            writeType;
  input [2:0]            writeSize;
  input [1:0]            writeRResp;

begin

  //============================================
  // Drive out Address phase
  //============================================
  @( posedge M_CLK[masterNum])
    begin
      // define // parameters for write
      wrStartAddr      <= writeAddr;
      wrBurstLen      <= writeLen;
      BurstType      <= writeType;
      wrAID        <= writeID;
      wrASize[masterNum]  <= writeSize;
      expWResp[masterNum]  <= writeRResp;

      wrStart[masterNum]   <= 1;
    end

  @( negedge M_CLK[masterNum]);
  while ( mstWrAddrFull[masterNum] )    // wait till readFifo is not full
    begin
      @( negedge M_CLK[masterNum] );
    end

  @( posedge M_CLK[masterNum])
    begin
      wrStart[masterNum]     <= 0;
    end
end
endtask    // AXI4Write task

//=====================================================================================================================================

reg              passStatus;

integer            j, k, i, l, burst, cnt, multiSize, TxSize;
reg no_tx;

integer a,b,c,d;

reg              fullFound;

reg [ADDR_WIDTH-1:0]     rdAddr, wrAddr;
reg [ID_WIDTH-1:0]      rdID, wrID;
reg [7:0]           rdLen, wrLen;  

reg [2:0]          wrSize    [NUM_MASTERS-1:0];
reg [2:0]          rdSize    [NUM_MASTERS-1:0];

reg [1:0]          wrResp, rdResp;
reg [23:0]          shiftDefault;

reg [NUM_SLAVES-1:0]    WRITE_CONNECTIVITY;
reg [NUM_SLAVES-1:0]    READ_CONNECTIVITY;

integer            startTime, elapsedTime, endTime, burstTime, numTrans, numMasters, nPorts;

reg              fullConnectivity;

always @( passStatus )
begin
  if (passStatus == 0 )
    $stop;
end

//=================================================================================================================================
// Run tests based on Master/Slaves types
//=================================================================================================================================
initial 
begin

  // Initialize Inputs
  passStatus = 1;    // initialise to passing;

  // reset core
  M_CLK0      <= 0;
  M_CLK1      <= 0;
  M_CLK2      <= 0;
  M_CLK3      <= 0;
  M_CLK4      <= 0;
  M_CLK5      <= 0;
  M_CLK6      <= 0;
  M_CLK7      <= 0;

  S_CLK0      <= 0;
  S_CLK1      <= 0;
  S_CLK2      <= 0;
  S_CLK3      <= 0;
  S_CLK4      <= 0;
  S_CLK5      <= 0;
  S_CLK6      <= 0;
  S_CLK7      <= 0;
  S_CLK8      <= 0;
  S_CLK9      <= 0;
  S_CLK10     <= 0;
  S_CLK11     <= 0;
  S_CLK12     <= 0;
  S_CLK13     <= 0;
  S_CLK14     <= 0;
  S_CLK15     <= 0;
  S_CLK16     <= 0;
  S_CLK17     <= 0;
  S_CLK18     <= 0;
  S_CLK19     <= 0;
  S_CLK20     <= 0;
  S_CLK21     <= 0;
  S_CLK22     <= 0;
  S_CLK23     <= 0;
  S_CLK24     <= 0;
  S_CLK25     <= 0;
  S_CLK26     <= 0;
  S_CLK27     <= 0;
  S_CLK28     <= 0;
  S_CLK29     <= 0;
  S_CLK30     <= 0;
  S_CLK31     <= 0;

  ARESETN     <= 0;



  $display( "\n\n================================================================================== " );
  $display( "%t  --- Starting  Tests                                                  ", $time );
  $display( "===================================================================================\n\n" );

  @( posedge ACLK);
  @( posedge ACLK);

  //====================== Initial Masters  ================================================//

  MASTER_RREADY_Default   = 1;
  MASTER_WREADY_Default  = 1;
  d_MASTER_BREADY_default  = 1;

  SLAVE_ARREADY_Default   = 1;
  SLAVE_AWREADY_Default   = 1;

  SLAVE_DATA_IDLE_EN    = RNDEN;    // Enables idle cycles to be inserted in Data channels
  SLAVE_DATA_IDLE_CYCLES  = 0;      // Idle cycles = 00= random, 01 = 1, 10=2, 11=3

  FORCE_ERROR        = 32'h0;     // Forces error pn read/write RESP
  ERROR_BYTE        = 8'h0;      // Byte to force error on - for READs

  rdAddr         = 0;
  wrAddr         = 0;

  rdBurstLen    <= 0;
  rdStartAddr    <= 0;  
  rdAID      <= 0;

  wrBurstLen    <= 0;
  wrStartAddr    <= 0;  
  wrAID      <= 0;

  BurstType    <= 2'b01;      // INCR type

  #1;

  for (k=0; k< NUM_MASTERS; k=k+1 )
    begin
      rdStart[k]    <= 0;    
      wrStart[k]    <= 0;
      wrSize[k]    <= 0;
      rdSize[k]    <= 0;
    end

  #30;

  @( posedge ACLK)  ARESETN <= 1;

  @(posedge ACLK);

  #100;
  @(posedge ACLK);

  //================================================================================================================
  // Select Test to run
  //================================================================================================================

  //`include "./User_Tests_incl.v"            // performs detailed verification of AXI4CROSS
  // ********************************************************************
  //  Microsemi Corporation Proprietary and Confidential
  //  Copyright 2017 Microsemi Corporation.  All rights reserved.
  //
  // ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
  // ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
  // IN ADVANCE IN WRITING.
  //
  // Description: CoreAXI4Interconnect testbench
  //
  // Revision Information:
  // Date     Description:     Tests for user testbench to verify operation with all ports defined as Masters & Slaves.
  // Feb17    Revision 1.0
  //
  // Notes:
  // best viewed with tabstops set to "4"
  // ********************************************************************
  
  begin
      $display( "\n\n===============================================================================================================" );
      $display( "                        User Testing with all Masters- all Slaves" ); 
      $display( "===============================================================================================================\n\n" );
  
      for (multiSize = 0; multiSize < 8; multiSize = multiSize+1)
      begin
  
      for (burst = 0; burst < 3; burst = burst+1)
      begin
      
      #100;
      @(posedge ACLK);
      $display( "\n\n===============================================================================================================" );
      $display( "%t  --- Test 1 - Check Write Connectivity map - Write from each Master to each slave       ", $time );
      $display( "===============================================================================================================\n\n" );
  
      //===========  Write to each slave from each master =====================
	  for ( j=0; j<NUM_MASTERS; j=j+1 )
        begin
          WRITE_CONNECTIVITY = MASTER_WRITE_CONNECTIVITY[(j*NUM_SLAVES) +: NUM_SLAVES ];
        
          for ( k=0; k <NUM_SLAVES; k=k+1 )	
            begin
  
              TxSize <= multiSize % (1+($clog2(MASTER_PORTS_DATA_WIDTH[(32*j)+:32]/8)));
              //wrAddr[ADDR_WIDTH-1:ADDR_WIDTH-ADDR_DEC_WIDTH]	<= k[ADDR_DEC_WIDTH-1:0];
              //wrAddr[NUM_AXISLAVE_BITS-1:NUM_AXISLAVE_BITS-NUM_MASTERS_WIDTH]	<= j[NUM_MASTERS_WIDTH-1:0];		// map each Master into different memory area in Slave
              //wrAddr[NUM_AXISLAVE_BITS-NUM_MASTERS_WIDTH-1:NUM_AXISLAVE_BITS-NUM_MASTERS_WIDTH-NUM_SLAVES_WIDTH]	<= k[NUM_SLAVES_WIDTH-1:0];		// map each Slave into different memory area in Slave
              //wrAddr[NUM_AXISLAVE_BITS-NUM_MASTERS_WIDTH-NUM_SLAVES_WIDTH-1:0]  <= 0;
  
  
              wrAddr <= SLAVE_ADDR[(32*k)+:32] + j*64;
              @(posedge M_CLK[j]);
              @(posedge M_CLK[j]);
  
              for (cnt = 0; cnt < MAX_TX_MST_SLV; cnt = cnt + 1)
              begin
          
              wrID			<= k+j+1;
  
              
              wrResp			<= ( WRITE_CONNECTIVITY[k] ) ? 2'b00 : 2'b11;
  
              $display("WRITE transaction: master %d type %d slave %d master data width", j, MASTER_TYPE[(2*j)+:2], k, MASTER_PORTS_DATA_WIDTH[(32*j)+:32]);
              if (MASTER_TYPE[(2*j)+:2] == 2'b10) begin // AHB master
                #1;
                hburst <= (cnt % 8);
                hsize <= TxSize;
                haddr <= 32'h0 |  (wrAddr & ~((1<< TxSize)-1));
                hwrite <= 1'b1;
                start_tx <= 1 << j;
  
                @(posedge M_CLK[j]);
                start_tx <= 'b0;
                #1;
                @(posedge end_tx[j]);
              end
              else begin
  
                offset_addr = (((((cnt+CNT_INIT)%(((burst == 1)&& (MASTER_TYPE[(2*j)+:2] == 2'b00) ) ? 256 : 16))+1) << TxSize));
                #1 next_addr = ((wrAddr+offset_addr));
  
                if (wrAddr[ADDR_WIDTH-1:12] == (next_addr >> 12) ) begin
                  if (burst == 2) begin
                      wrLen <= 2**((cnt % 4) + 1) - 1;
                   end
                   else begin
                      wrLen			<= (cnt+CNT_INIT) % (((burst == 1) && (MASTER_TYPE[(2*j)+:2] == 2'b00)) ? 256 : 16);
                   end
                   no_tx = 0;
                end
                else begin
                  if (burst == 2) begin
                    if (((13'h1000 - wrAddr[11:0]) >> TxSize) < 2) begin
                      no_tx = 1;
                      wrLen = 1;
                    end
                    else begin
                      no_tx = 0;
                      wrLen <= 2**((((13'h1000 - wrAddr[11:0]) >> TxSize) % 4) + 1) - 1;
                    end
                  end
                  else begin
                    no_tx = 0;
                    wrLen     <= ((12'hFFF - wrAddr[11:0]) >> TxSize);
                  end
                end
              
              if (burst == 2'b10) begin // WRAP burst
                wrAddr[5:0] <= 6'h0;
              end
              
              if (MASTER_TYPE[(2*j)+:2] == 2'b01) begin // AXI4-Lite master
                  wrLen <=  'b0;
                  TxSize <= $clog2(MASTER_PORTS_DATA_WIDTH[(32*j)+:32]/8);
              end
              if (no_tx == 0) begin
                  #1 AXI4Write( j[7:0], (wrAddr), wrID, wrLen, burst, TxSize, wrResp  );				// master to each slave
  
                #1 $display("\n %t, Waiting for masterRespDone[%d] to assert for write to slave[%d]\n", $time,  j, k );
            
                @(posedge masterRespDone[j] )
                  begin
                    #1;
  
                    if ( WRITE_CONNECTIVITY[k] )	// if master can write to slave
                      begin
                        if ( ~masterWrStatus[j] )
                          begin
                            #1 $display("%t, MASTER Error - masterWrStatus = %b", $time,  masterWrStatus[j] );
                            $stop;
                          end
                        passStatus = passStatus & masterWrStatus[j];	
                      end
                    else							// if master cannot wrote to slave - should get DECRR back
                      begin
                        if ( ~masterWrStatus[j] )
                          begin
                            #1 $display("%t, MASTER Error - expected DECERR- masterWrStatus = %b", $time,  masterWrStatus[j] );
                            $stop;
                          end
                        else
                          begin
                            #1 $display("\n%t, MASTER DECERR ok - expected DECERR- masterWrStatus = %b\n", $time,  masterWrStatus[j] );
                          end
                        passStatus = passStatus & masterWrStatus[j];
                      end
                  end
              end

            end
  
  
              if  (MASTER_TYPE[(2*j)+:2] == 2'b10) begin
                if (hburst == 1)
                  wrAddr <= ( wrAddr + (UNDEF_AHB_BURST[(8*j)+:8] << TxSize));
                else
                  wrAddr <= ( wrAddr + ((2**(1+hburst[2:1])+2) << TxSize));
              end
              else if (burst == 2'b10) begin
                wrAddr <= wrAddr + (2 << ($clog2(wrLen+1)+TxSize));
              end
              else begin
                wrAddr <= ( wrAddr + ((cnt+CNT_INIT+2) << TxSize));
              end
  
              end
            end
  
        end
  
        
      $display( "\n\n===============================================================================================================" );
      $display( "%t  --- Test 2 - Check Read Connectivity map - Read from each Slave to each Master       ", $time );
      $display( "==============================================================================================================\n\n " );
    
  
      //===========  Read from each slave from each master =====================
      for ( j=0; j<NUM_MASTERS; j=j+1 )
        begin
          READ_CONNECTIVITY = MASTER_READ_CONNECTIVITY[(j*NUM_SLAVES) +: NUM_SLAVES ];
  
          for ( k=0; k <NUM_SLAVES; k=k+1 )	
			begin
              TxSize <= multiSize % (1+($clog2(MASTER_PORTS_DATA_WIDTH[(32*j)+:32]/8)));
              //rdAddr[ADDR_WIDTH-1:ADDR_WIDTH-ADDR_DEC_WIDTH]	<= k[ADDR_DEC_WIDTH-1:0];
              //rdAddr[NUM_AXISLAVE_BITS-1:NUM_AXISLAVE_BITS-NUM_MASTERS_WIDTH]	<= j[NUM_MASTERS_WIDTH-1:0];		// map each Master into different memory area in Slave
              //rdAddr[NUM_AXISLAVE_BITS-NUM_MASTERS_WIDTH-1:NUM_AXISLAVE_BITS-NUM_MASTERS_WIDTH-NUM_SLAVES_WIDTH]	<= k[NUM_SLAVES_WIDTH-1:0];		// map each Slave into different memory area in Slave
              //rdAddr[NUM_AXISLAVE_BITS-NUM_MASTERS_WIDTH-NUM_SLAVES_WIDTH-1:0]  <= 0;
              rdAddr <= SLAVE_ADDR[(32*k)+:32] + j*64;
              @(posedge M_CLK[j]);
              @(posedge M_CLK[j]);
  
              for (cnt = 0; cnt < MAX_TX_MST_SLV; cnt = cnt + 1)
              begin
              
                rdID			<= k+j+1;
                rdResp			<= READ_CONNECTIVITY[k] ? 2'b0 : 2'b11;
  
                $display("READ transaction: master %d type %d slave %d master data width %d", j, MASTER_TYPE[(2*j)+:2], k, MASTER_PORTS_DATA_WIDTH[(32*j)+:32]);
                if (MASTER_TYPE[(2*j)+:2] == 2'b10) begin // AHB master
                  #1;
                  hburst <=  (cnt % 8);
                  hsize <= TxSize;
                  haddr <= 32'h0 | (rdAddr & ~((1<< TxSize)-1));
                  hwrite <= 1'b0;
                  start_tx <= 1 << j;
                  @(posedge M_CLK[j]);
                  start_tx <= 'b0;
                  #1;
                  @(posedge end_tx[j]);
                end
                else begin
  
                  offset_addr = (((((cnt+CNT_INIT)%(((burst == 1)&& (MASTER_TYPE[(2*j)+:2] == 2'b00) ) ? 256 : 16))+1) << TxSize));
                  #1 next_addr = ((rdAddr+offset_addr));
  
                  if (rdAddr[ADDR_WIDTH-1:12] == (next_addr >> 12))  begin
                    if (burst == 2) begin
                      rdLen <= 2**((cnt % 4) + 1) - 1;
                    end
                    else begin
                      rdLen			<= (cnt+CNT_INIT) % (((burst == 1) && (MASTER_TYPE[(2*j)+:2] == 2'b00)) ? 256 : 16);
                    end
                      no_tx = 0;
                  end
                  else begin
                    if (burst == 2) begin
                      if (((13'h1000 - rdAddr[11:0]) >> TxSize) < 2) begin
                        no_tx = 1;
                        rdLen = 1;
                      end
                      else begin
                        no_tx = 0;
                        rdLen <= 2**((((13'h1000 - rdAddr[11:0]) >> TxSize) % 4) + 1) - 1;
                      end
                    end
                    else begin
                      no_tx = 0;
                      rdLen     <= ((12'hFFF - rdAddr[11:0]) >> TxSize);
                    end
                  end
  
                if (burst == 2'b10) begin // WRAP burst
                  rdAddr[5:0] <= 6'h00;
                end
                
                if (MASTER_TYPE[(2*j)+:2] == 2'b01) begin // AXI4-Lite master
                  rdLen <=  'b0;
                  TxSize <= $clog2(MASTER_PORTS_DATA_WIDTH[(32*j)+:32]/8);
                end
                      
                if (no_tx == 0) begin
                  #1 AXI4Read( j[7:0], (rdAddr), rdID, rdLen, burst, TxSize, rdResp  );				// master to each slave
  
                  #1 $display("\n %t, Waiting for masterRdDone[%d] to assert for read from slave[%d]\n", $time,  j, k );
  
                  @(posedge masterRdDone[j] )
                    begin
                      #1;
                      if ( READ_CONNECTIVITY[k] )	// if master can read from slave
                        begin
                          if ( ~masterRdStatus[j] )
                            begin
                              #1 $display("%t, MASTER Error - masterRdStatus = %b", $time,  masterRdStatus[j] );
                              $stop;
                            end
                          passStatus = passStatus & masterRdStatus[j];	
                        end
                      else							// if master cannot wrote to slave - should get DECRR back
                        begin
                          if ( ~masterRdStatus[j] )
                            begin
                              #1 $display("%t, MASTER Error - expected DECERR- masterRdStatus = %b", $time,  masterRdStatus[j] );
                              $stop;
                            end
                          else
                            begin
                              #1 $display("\n%t, MASTER DECERR ok - expected DECERR- masterRdStatus = %b\n", $time,  masterRdStatus[j] );
                            end
                          passStatus = passStatus & masterRdStatus[j];
                        end
                    end
                end
               end
  
                if  (MASTER_TYPE[(2*j)+:2] == 2'b10) begin
                  if (hburst == 1)
                    rdAddr <= ( rdAddr + (UNDEF_AHB_BURST[(8*j)+:8] << TxSize));
                  else
                    rdAddr <= ( rdAddr + ((2**(1+hburst[2:1])+2) << TxSize));
                end
                else if (burst == 2'b10) begin
                  rdAddr <= rdAddr + (2 << ($clog2(rdLen+1)+TxSize));
                end
                else begin
                  rdAddr <= ( rdAddr + ((cnt+CNT_INIT+2) << TxSize));
                end
                
              end
          end
        end
        
      end
    end
  
  
      #50;
      if (passStatus)
        begin
          $display( "\n\n==============================================================================================" );
          $display( "%t Passed : all tests passed", $time );
          $display( "==============================================================================================\n\n" );
          //$stop;
        end
      else
        begin
          $display( "\n\n============================================================================================" );
          $display( "%t FAIL : at least 1 tests failed ", $time );
          $display( "==============================================================================================\n" );
        end
  
  
      #500 
      $stop;
      $finish;
  
  end		// User_Tests_incl.v

  end


endmodule   // User_Test.v
