// ****************************************************************************/
// Microsemi Corporation Proprietary and Confidential
// Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: CoreAXI4DMAController user testbench driver model
//
// SVN Revision Information:
// SVN $Revision: 28772 $
// SVN $Date: 2017-02-09 20:06:50 +0000 (Thu, 09 Feb 2017) $
//
// Resolved SARs
// SAR      Date     Who   Description
//
// Notes:
//
// ****************************************************************************/

////////////////////////////////////////////////////////////////////////////////
// Constants
////////////////////////////////////////////////////////////////////////////////
localparam START_OP_REG_ADDR              = 32'h04; 
localparam BD0_CONFIG_REG_ADDR            = 32'h60;
localparam BD0_BYTE_CNT_REG_ADDR          = 32'h64;
localparam BD0_SRC_ADDR_REG_ADDR          = 32'h68;
localparam BD0_DST_ADDR_REG_ADDR          = 32'h6C;
localparam BD0_NEXT_DSCRPTR_ADDR_REG_ADDR = 32'h70;
localparam INT0_STATUS_REG_ADDR           = 32'h10;
localparam INT0_MASK_REG_ADDR             = 32'h14;
localparam INT0_CLEAR_REG_ADDR            = 32'h18;
localparam INT0_EXT_ADDR_REG_ADDR         = 32'h1C;

////////////////////////////////////////////////////////////////////////////////
// config_int_dscrptr() task implementation
////////////////////////////////////////////////////////////////////////////////
task config_int_dscrptr;
    input [31:0]    this_DMA_addr;
    input [4:0]     dscrptr_num;
    input [22:0]    num_of_bytes;
    input [31:0]    src_addr;
    input [1:0]     src_op;
    input [31:0]    dst_addr;
    input [1:0]     dst_op; 
    input           int_on_process;
    input           chain;
    input           src_data_valid;
    input           dst_data_ready;
    input           ext_dscrptr_next;
    input [31:0]    next_dscrptr_num_addr;
    begin
        // Write to the byte count register
        axi_write(this_DMA_addr+BD0_BYTE_CNT_REG_ADDR+(dscrptr_num*32), num_of_bytes, 4'hF);
        
        // Write to the source address register
        axi_write(this_DMA_addr+BD0_SRC_ADDR_REG_ADDR+(dscrptr_num*32), src_addr, 4'hF);
        
        // Write to the destination address register
        axi_write(this_DMA_addr+BD0_DST_ADDR_REG_ADDR+(dscrptr_num*32), dst_addr, 4'hF);
        
        // Write to the next descriptor address register
        axi_write(this_DMA_addr+BD0_NEXT_DSCRPTR_ADDR_REG_ADDR+(dscrptr_num*32), next_dscrptr_num_addr, 4'hF);
        
        //                                                           Dscrptr valid, both data valid bits set
        axi_write(this_DMA_addr+BD0_CONFIG_REG_ADDR+(dscrptr_num*32), {16'd0, 1'b1, dst_data_ready, src_data_valid, int_on_process, ext_dscrptr_next, chain, {6{1'b0}}, dst_op, src_op}, 4'hF);
    end
endtask

task config_ext_dscrptr;
    input [31:0]    ext_dscrptr_addr;
    input [22:0]    num_of_bytes;
    input [31:0]    src_addr;
    input [1:0]     src_op;
    input [31:0]    dst_addr;
    input [1:0]     dst_op; 
    input           int_on_process;
    input           chain;
    input           src_data_valid;
    input           dst_data_ready;
    input           ext_dscrptr_next;
    input [31:0]    next_dscrptr_num_addr;
    begin
        // Write to the byte count register
        axi_write(ext_dscrptr_addr+4, num_of_bytes, 4'hF);
        
        // Write to the source address register
        axi_write(ext_dscrptr_addr+8, src_addr, 4'hF);
        
        // Write to the destination address register
        axi_write(ext_dscrptr_addr+12, dst_addr, 4'hF);
        
        // Write to the next descriptor address register
        axi_write(ext_dscrptr_addr+16, next_dscrptr_num_addr, 4'hF);
        
        //                                             Dscrptr valid, both data valid bits set
        axi_write(ext_dscrptr_addr+0, {16'd0, 1'b1, dst_data_ready, src_data_valid, int_on_process, ext_dscrptr_next, chain, {6{1'b0}}, dst_op, src_op}, 4'hF);
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// config_irq() task implementation
////////////////////////////////////////////////////////////////////////////////
task config_irq;
    input [31:0]    this_DMA_addr;
    input [1:0]     int_num;
    input [3:0]     mask;
    begin
        axi_write(this_DMA_addr+INT0_MASK_REG_ADDR+(int_num*16), {{28{1'b0}}, mask}, 4'h1);
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// wait_irq() task implementation
////////////////////////////////////////////////////////////////////////////////
task wait_irq;
    input [31:0]    this_DMA_addr;
    input [1:0]     int_num;
    input [5:0]     dscrptr_num;
    input           ext_dscrptr;
    input [31:0]    ext_dscrptr_num;
    input [4:0]     status;
    begin
        // Wait for an interrupt to be generated
        wait (interrupt[int_num]);
        axi_read(this_DMA_addr+INT0_STATUS_REG_ADDR+(int_num*16));
        if (rdWord[3:0] != status)
            begin
                // Somthing other than an expected status returned
                $display($time, "Interrupt error detected. Expected status %h doesn't match actual status of %h", status, rdWord);
                $stop;
            end
        else if (rdWord[9:4] != dscrptr_num)
            begin
                // The wrong descriptor number has been returned
                $display($time, "Interrupt status internal descriptor number not expected as %d, expected %d", rdWord[9:4], dscrptr_num);
                $stop;
            end
        if (ext_dscrptr)
            begin
                axi_read(this_DMA_addr+INT0_EXT_ADDR_REG_ADDR+(int_num*16));
                if (rdWord[31:0] != ext_dscrptr_num)
                    begin
                        // Somthing other than an expected status returned
                        $display($time, "Interrupt status external descriptor number not expected as %h, expected %h", rdWord[31:0], ext_dscrptr_num);
                        $stop;
                    end
            end
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// clr_irq() task implementation
////////////////////////////////////////////////////////////////////////////////
task clr_irq;
    input [31:0]    this_DMA_addr;
    input [1:0]     int_num;
    input [3:0]     clear;
    begin
        axi_write(this_DMA_addr+INT0_CLEAR_REG_ADDR+(int_num*16), {{28{1'b0}}, clear}, 4'h1);
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// start_operation() task implementation
////////////////////////////////////////////////////////////////////////////////
task start_operation;
    input [31:0]    this_DMA_addr;
    input [4:0]     dscrptr_num;
    begin
        axi_write(this_DMA_addr+START_OP_REG_ADDR, bcd_2_one_hot(dscrptr_num), 4'hF);
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// Function to convert from BCD to one-hot
////////////////////////////////////////////////////////////////////////////////
function [31:0] bcd_2_one_hot;
    input [4:0]     dscrptr_num;
    begin
        bcd_2_one_hot = (dscrptr_num == 'd0 ) ? 32'b00000000000000000000000000000001 :
                        (dscrptr_num == 'd1 ) ? 32'b00000000000000000000000000000010 :
                        (dscrptr_num == 'd2 ) ? 32'b00000000000000000000000000000100 :
                        (dscrptr_num == 'd3 ) ? 32'b00000000000000000000000000001000 :
                        (dscrptr_num == 'd4 ) ? 32'b00000000000000000000000000010000 :
                        (dscrptr_num == 'd5 ) ? 32'b00000000000000000000000000100000 :
                        (dscrptr_num == 'd6 ) ? 32'b00000000000000000000000001000000 :
                        (dscrptr_num == 'd7 ) ? 32'b00000000000000000000000010000000 :
                        (dscrptr_num == 'd8 ) ? 32'b00000000000000000000000100000000 :
                        (dscrptr_num == 'd9 ) ? 32'b00000000000000000000001000000000 :
                        (dscrptr_num == 'd10) ? 32'b00000000000000000000010000000000 :
                        (dscrptr_num == 'd11) ? 32'b00000000000000000000100000000000 :
                        (dscrptr_num == 'd12) ? 32'b00000000000000000001000000000000 :
                        (dscrptr_num == 'd13) ? 32'b00000000000000000010000000000000 :
                        (dscrptr_num == 'd14) ? 32'b00000000000000000100000000000000 :
                        (dscrptr_num == 'd15) ? 32'b00000000000000001000000000000000 :
                        (dscrptr_num == 'd16) ? 32'b00000000000000010000000000000000 :
                        (dscrptr_num == 'd17) ? 32'b00000000000000100000000000000000 :
                        (dscrptr_num == 'd18) ? 32'b00000000000001000000000000000000 :
                        (dscrptr_num == 'd19) ? 32'b00000000000010000000000000000000 :
                        (dscrptr_num == 'd20) ? 32'b00000000000100000000000000000000 :
                        (dscrptr_num == 'd21) ? 32'b00000000001000000000000000000000 :
                        (dscrptr_num == 'd22) ? 32'b00000000010000000000000000000000 :
                        (dscrptr_num == 'd23) ? 32'b00000000100000000000000000000000 :
                        (dscrptr_num == 'd24) ? 32'b00000001000000000000000000000000 :
                        (dscrptr_num == 'd25) ? 32'b00000010000000000000000000000000 :
                        (dscrptr_num == 'd26) ? 32'b00000100000000000000000000000000 :
                        (dscrptr_num == 'd27) ? 32'b00001000000000000000000000000000 :
                        (dscrptr_num == 'd28) ? 32'b00010000000000000000000000000000 :
                        (dscrptr_num == 'd29) ? 32'b00100000000000000000000000000000 :
                        (dscrptr_num == 'd30) ? 32'b01000000000000000000000000000000 :
                        (dscrptr_num == 'd31) ? 32'b10000000000000000000000000000000 :
                        'd0;
    end
endfunction

////////////////////////////////////////////////////////////////////////////////
// src_data_valid_reset_int() task implementation
////////////////////////////////////////////////////////////////////////////////
task src_data_valid_reset_int;
    input [31:0]    this_DMA_addr;
    input [4:0]     dscrptr_num;
    begin
        // Read modify write operation on the descriptor N Configuration
        // register to reset the source data valid bit every time that an
        // operation completes of the descriptor.
        // Need to write to the descriptor valid bit
        axi_read (this_DMA_addr+BD0_CONFIG_REG_ADDR+(dscrptr_num*32));
        rdWord = rdWord | 32'h0000B000; // bit 15 & 12 -dscrptr valid & data valid
        axi_write (this_DMA_addr+BD0_CONFIG_REG_ADDR+(dscrptr_num*32), rdWord, 4'hF);
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// src_data_valid_reset_ext() task implementation
////////////////////////////////////////////////////////////////////////////////
task src_data_valid_reset_ext;
    input [31:0]    ext_dscrptr_addr;
    begin
        // Read modify write operation on the descriptor N Configuration
        // register to reset the source data valid bit every time that an
        // operation completes of the descriptor.
        // Need to write to the descriptor valid bit
        axi_read (ext_dscrptr_addr+0);
        rdWord = rdWord | 32'h0000B000; // bit 15 & 12 -dscrptr valid & data valid
        axi_write (ext_dscrptr_addr+0, rdWord, 4'hF);
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// dst_data_ready_reset_int() task implementation
////////////////////////////////////////////////////////////////////////////////
task dst_data_ready_reset_int;
    input [31:0]    this_DMA_addr;
    input [4:0]     dscrptr_num;
    begin
        // Read modify write operation on the descriptor N Configuration
        // register to reset the destination data ready bit every time that an
        // operation completes of the descriptor.
        // Need to write to the descriptor valid bit
        axi_read (this_DMA_addr+BD0_CONFIG_REG_ADDR+(dscrptr_num*32));
        rdWord = rdWord | 32'h0000C000; // bit 15 & 14 -dscrptr valid & data ready
        axi_write (this_DMA_addr+BD0_CONFIG_REG_ADDR+(dscrptr_num*32), rdWord, 4'hF);
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// dst_data_ready_reset_ext() task implementation
////////////////////////////////////////////////////////////////////////////////
task dst_data_ready_reset_ext;
    input [31:0]    ext_dscrptr_addr;
    begin
        // Read modify write operation on the descriptor N Configuration
        // register to reset the destination data ready bit every time that an
        // operation completes of the descriptor.
        // Need to write to the descriptor valid bit
        axi_read (ext_dscrptr_addr+0);
        rdWord = rdWord | 32'h0000C000; // bit 15 & 14 -dscrptr valid & data ready
        axi_write (ext_dscrptr_addr+0, rdWord, 4'hF);
    end
endtask

////////////////////////////////////////////////////////////////////////////////
// terminate_internal_chain() task implementation
////////////////////////////////////////////////////////////////////////////////
task terminate_internal_chain;
    input [31:0]    this_DMA_addr;
    input [4:0]     dscrptr_num;
    begin
        // Read modify write operation on the descriptor N Configuration
        // register to clear the chain bit
        axi_read (this_DMA_addr+BD0_CONFIG_REG_ADDR+(dscrptr_num*32));
        rdWord = rdWord & 32'hFFFFFBFF; // bit 10 - data valid/ready
        axi_write (this_DMA_addr+BD0_CONFIG_REG_ADDR+(dscrptr_num*32), rdWord, 4'hF);
    end

endtask