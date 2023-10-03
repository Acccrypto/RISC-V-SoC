// ****************************************************************************/
// Microsemi Corporation Proprietary and Confidential
// Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: 
//
// SVN Revision Information:
// SVN $Revision: 28873 $
// SVN $Date: 2017-02-13 13:08:48 +0000 (Mon, 13 Feb 2017) $
//
// Resolved SARs
// SAR      Date     Who   Description
//
// Notes:
//
// ****************************************************************************/
`define STR_TEST_CASE_0
`define STR_TEST_CASE_1

#200000;
$display ($time, "Begin AXI4-Stream testing");
`ifdef STR_TEST_CASE_0
    $display ($time, "Executing stream test case 0");
    #1000;
    axi4_stream_write(
        2'b00,    // destRouteInfo
        24'd4096, // dstNumOfBytes
        'h00      // srcAddr
    );
    $display($time, "Completed executing stream test case 0");
`endif
`ifdef STR_TEST_CASE_1
    $display ($time, "Executing stream test case 0");
    #10000;
    axi4_stream_write(
        2'b01,    // destRouteInfo
        24'd4096, // dstNumOfBytes
        'h00      // srcAddr
    );
    $display($time, "Completed executing stream test case 0");
`endif